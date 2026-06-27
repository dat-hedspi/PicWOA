import Foundation
import OSLog

private let openAILogger = Logger(subsystem: "com.picwoa.app", category: "OpenAI")

enum OpenAIError: Error {
    case invalidResponse
    case timeout
    case networkError(Error)
    case parseError
}

/// HTTP client that calls the OpenAI Chat Completions API.
///
/// - Model + timeout injected from `AIConfig` (not hardcoded).
/// - Retries once on timeout / transient network error (AI_ORCHESTRATION_SPEC §6).
/// - API key kept separately in the `Authorization` header, never logged.
final class OpenAIClient: AIBackendProtocol, Sendable {
    private let apiKey: String
    private let model: String
    private let timeout: TimeInterval
    private let session: URLSession
    private let endpoint = URL(string: "https://api.openai.com/v1/chat/completions")!

    init(
        apiKey: String,
        model: String = "gpt-4o-mini",
        timeout: TimeInterval = 2.0,
        session: URLSession = .shared
    ) {
        self.apiKey = apiKey
        self.model = model
        self.timeout = timeout
        self.session = session
    }

    func send(_ request: OpenAIRequest) async throws -> AICoachingResponse {
        do {
            return try await performRequest(request)
        } catch {
            // Retry once for a transient error (timeout / lost network).
            if isRetryable(error) {
                openAILogger.warning("Retrying OpenAI request after transient error: \(String(describing: error), privacy: .public)")
                #if DEBUG
                print("[API] ⚠️ retry — \(error)")
                #endif
                return try await performRequest(request)
            }
            throw error
        }
    }

    private func performRequest(_ request: OpenAIRequest) async throws -> AICoachingResponse {
        var urlRequest = URLRequest(url: endpoint, timeoutInterval: timeout)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = PromptBuilder.buildChatRequest(from: request, model: model)
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)

        openAILogger.info("POST \(self.endpoint.host ?? "unknown", privacy: .public) model=\(self.model, privacy: .public) issues=\(request.issues.count)")
        #if DEBUG
        let startedAt = Date()
        print("[API] → POST \(endpoint.host ?? "") model=\(model) issues=\(request.issues.count)")
        #else
        let startedAt = Date()
        #endif

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch let urlError as URLError where urlError.code == .timedOut {
            openAILogger.error("OpenAI timeout after \(Date().timeIntervalSince(startedAt) * 1000, format: .fixed(precision: 0))ms")
            #if DEBUG
            print("[API] ❌ timeout after \(String(format: "%.0f", Date().timeIntervalSince(startedAt) * 1000))ms")
            #endif
            throw OpenAIError.timeout
        } catch let urlError as URLError where urlError.code == .cancelled {
            openAILogger.info("OpenAI request cancelled")
            throw CancellationError()
        } catch {
            openAILogger.error("OpenAI network error: \(String(describing: error), privacy: .public)")
            #if DEBUG
            print("[API] ❌ network error — \(error)")
            #endif
            throw OpenAIError.networkError(error)
        }

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            let status = (response as? HTTPURLResponse)?.statusCode ?? -1
            openAILogger.error("OpenAI HTTP \(status)")
            #if DEBUG
            print("[API] ❌ HTTP \(status)")
            #endif
            throw OpenAIError.invalidResponse
        }

        openAILogger.info("OpenAI success status=\(http.statusCode) time=\(Date().timeIntervalSince(startedAt) * 1000, format: .fixed(precision: 0))ms bytes=\(data.count)")
        #if DEBUG
        print("[API] ✅ \(http.statusCode) time=\(String(format: "%.0f", Date().timeIntervalSince(startedAt) * 1000))ms bytes=\(data.count)")
        #endif

        return try ResponseParser.parse(data: data)
    }

    private func isRetryable(_ error: Error) -> Bool {
        switch error {
        case OpenAIError.timeout, OpenAIError.networkError:
            return true
        default:
            return false
        }
    }
}
