# ARCHITECTURE — Picwoa: AI Photography Coach

**Version:** 1.0  
**Stack:** Swift 6 / SwiftUI / AVFoundation / Vision / CoreML / CoreImage / OpenAI  
**Pattern:** Clean Architecture + MVVM + Feature-First  

---

## 1. System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                    │
│   SwiftUI Views  ·  ViewModels  ·  Navigation           │
└──────────────────────────┬──────────────────────────────┘
                           │ @Observable / async/await
┌──────────────────────────▼──────────────────────────────┐
│                   APPLICATION LAYER                      │
│   Use Cases  ·  Coordinators  ·  State Machines         │
└──────────────────────────┬──────────────────────────────┘
                           │ Protocol-based interfaces
┌──────────────────────────▼──────────────────────────────┐
│                     DOMAIN LAYER                         │
│   Entities  ·  Business Rules  ·  Rule Engine           │
└──────────────────────────┬──────────────────────────────┘
                           │ Dependency Inversion
┌──────────────────────────▼──────────────────────────────┐
│                  INFRASTRUCTURE LAYER                    │
│   VisionEngine  ·  CameraEngine  ·  OpenAIClient        │
│   CoreImageProcessor  ·  PhotoSaver                     │
└──────────────────────────┬──────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────┐
│                   EXTERNAL SERVICES                      │
│   AVFoundation  ·  Vision  ·  CoreML  ·  OpenAI API     │
│   CoreImage  ·  PhotosUI / PHPhotoLibrary               │
└─────────────────────────────────────────────────────────┘
```

---

## 2. Feature Architecture

Ứng dụng được tổ chức theo **Feature-first**, không phải layer-first.

Mỗi feature là một module độc lập, sở hữu toàn bộ Views / ViewModels / Models / Services / Components của nó.

```
Picwoa/
├── App/
├── Features/
│   ├── CameraExperience/       ← Dev A
│   ├── PoseCoaching/           ← Dev B
│   ├── SceneAnalysis/          ← Dev B
│   ├── LiveOverlay/            ← Dev C
│   ├── PhotoCapture/           ← Dev A
│   ├── PhotoReview/            ← Dev C
│   └── PhotoEditing/           ← Dev C
├── Core/
│   ├── CameraEngine/
│   ├── VisionEngine/
│   ├── DesignSystem/
│   └── Extensions/
├── AI/
│   ├── RuleEngine/
│   ├── PromptBuilder/
│   ├── AIOrchestrator/
│   └── OpenAIClient/
└── Resources/
```

---

## 3. Clean Architecture — Layers

### Presentation Layer
- SwiftUI Views (pure UI, no business logic)
- `@Observable` ViewModels (state + intent handling)
- NavigationCoordinator

### Application Layer
- Use Cases (orchestrate domain + infrastructure)
- App State Machine
- Feature coordinators

### Domain Layer
- Entities: `PoseObservation`, `CoachingResult`, `EditingRecipe`, `PhotoScore`
- Business Rules (pure Swift, no framework dependencies)
- Rule Engine (deterministic logic)

### Infrastructure Layer
- `CameraEngine` wraps AVFoundation
- `VisionEngine` wraps Vision Framework
- `OpenAIClient` wraps URLSession
- `CoreImageProcessor` wraps CoreImage
- `PhotoSaver` wraps PHPhotoLibrary

### External Services
- AVFoundation, Vision, CoreML, CoreImage
- OpenAI Chat Completions API
- PHPhotoLibrary

### Dependency Rule

```
Presentation → Application → Domain ← Infrastructure
                                ↑
                          (via Protocol)
```

- Domain layer có ZERO dependency ra ngoài
- Infrastructure implement protocols defined in Domain
- Presentation chỉ biết đến ViewModels, không biết Infrastructure

---

## 4. Folder Structure (Production)

```
Picwoa/
│
├── App/
│   ├── PicwoaApp.swift               ← App entry point
│   ├── AppCoordinator.swift          ← Root navigation
│   └── AppState.swift                ← Global app state
│
├── Features/
│   │
│   ├── CameraExperience/
│   │   ├── Views/
│   │   │   ├── CameraScreen.swift
│   │   │   └── BottomToolbar.swift
│   │   ├── ViewModels/
│   │   │   └── CameraViewModel.swift
│   │   ├── Components/
│   │   │   ├── CaptureButton.swift
│   │   │   └── FlashToggle.swift
│   │   └── CameraExperienceRoute.swift
│   │
│   ├── PoseCoaching/
│   │   ├── Views/
│   │   │   └── PoseDebugOverlay.swift   ← dev only
│   │   ├── ViewModels/
│   │   │   └── PoseCoachingViewModel.swift
│   │   ├── Models/
│   │   │   ├── PoseObservation.swift
│   │   │   └── CoachingRule.swift
│   │   └── Services/
│   │       └── PoseAnalysisService.swift
│   │
│   ├── SceneAnalysis/
│   │   ├── Models/
│   │   │   └── SceneContext.swift
│   │   └── Services/
│   │       └── SceneClassifierService.swift
│   │
│   ├── LiveOverlay/
│   │   ├── Views/
│   │   │   ├── CoachingOverlay.swift
│   │   │   ├── CoachingCard.swift
│   │   │   └── DirectionArrow.swift
│   │   ├── ViewModels/
│   │   │   └── OverlayViewModel.swift
│   │   └── Models/
│   │       └── OverlayState.swift
│   │
│   ├── PhotoCapture/
│   │   ├── ViewModels/
│   │   │   └── CaptureViewModel.swift
│   │   └── Services/
│   │       └── CaptureService.swift
│   │
│   ├── PhotoReview/
│   │   ├── Views/
│   │   │   ├── ReviewScreen.swift
│   │   │   ├── ScoreView.swift
│   │   │   └── BeforeAfterView.swift
│   │   ├── ViewModels/
│   │   │   └── ReviewViewModel.swift
│   │   └── Models/
│   │       └── PhotoScore.swift
│   │
│   └── PhotoEditing/
│       ├── ViewModels/
│       │   └── EditingViewModel.swift
│       ├── Models/
│       │   └── EditingRecipe.swift
│       └── Services/
│           └── CoreImageProcessor.swift
│
├── Core/
│   │
│   ├── CameraEngine/
│   │   ├── CameraEngine.swift            ← AVFoundation wrapper
│   │   ├── CameraPermissionManager.swift
│   │   └── CameraConfiguration.swift
│   │
│   ├── VisionEngine/
│   │   ├── VisionEngine.swift            ← Vision Framework wrapper
│   │   ├── PersonDetector.swift
│   │   └── PoseDetector.swift
│   │
│   ├── DesignSystem/
│   │   ├── Tokens/
│   │   │   ├── Colors.swift
│   │   │   ├── Typography.swift
│   │   │   ├── Spacing.swift
│   │   │   └── Animation.swift
│   │   └── Components/
│   │       ├── PrimaryButton.swift
│   │       ├── GlassCard.swift
│   │       └── PermissionView.swift
│   │
│   └── Extensions/
│       ├── UIImage+CoreImage.swift
│       └── View+Conditional.swift
│
├── AI/
│   │
│   ├── RuleEngine/
│   │   ├── RuleEngine.swift              ← Deterministic analysis
│   │   ├── PoseRules.swift               ← Rule definitions
│   │   └── RuleEvaluator.swift
│   │
│   ├── PromptBuilder/
│   │   ├── PromptBuilder.swift
│   │   └── PromptTemplates.swift
│   │
│   ├── AIOrchestrator/
│   │   ├── AIOrchestrator.swift          ← Coordinates AI pipeline
│   │   └── ResponseParser.swift
│   │
│   └── OpenAIClient/
│       ├── OpenAIClient.swift
│       ├── OpenAIRequest.swift
│       └── OpenAIResponse.swift
│
└── Resources/
    ├── Assets.xcassets
    ├── Localizable.strings               ← tiếng Việt
    └── Config.plist                      ← API keys (gitignored)
```

---

## 5. Dependency Rules

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│ Presentation │────▶│  Application │────▶│    Domain    │
│   (Views,    │     │  (UseCases,  │     │  (Entities,  │
│  ViewModels) │     │ Coordinators)│     │    Rules)    │
└──────────────┘     └──────────────┘     └──────┬───────┘
                                                  │ ◀── Protocol
                                          ┌───────▼───────┐
                                          │Infrastructure │
                                          │ (Engines,     │
                                          │  Clients)     │
                                          └───────────────┘
```

| Layer | Có thể import | Không được import |
|-------|--------------|-------------------|
| Presentation | Application, Domain, DesignSystem | Infrastructure, AI internals |
| Application | Domain, Core protocols | AVFoundation, Vision trực tiếp |
| Domain | Không có | Tất cả frameworks |
| Infrastructure | Domain (protocols) | Presentation, Application |
| AI | Domain, Core | Presentation |

**Inter-feature dependencies:**

| Feature | Phụ thuộc vào |
|---------|--------------|
| CameraExperience | CameraEngine, VisionEngine |
| PoseCoaching | VisionEngine, AI/RuleEngine |
| SceneAnalysis | VisionEngine, CoreML |
| LiveOverlay | PoseCoaching, AI/AIOrchestrator |
| PhotoCapture | CameraEngine |
| PhotoReview | AI/AIOrchestrator, PhotoEditing |
| PhotoEditing | Core/CoreImageProcessor |

Features KHÔNG import lẫn nhau trực tiếp — giao tiếp qua shared models trong Domain.

---

## 6. AI Pipeline

```
┌─────────────────────────────────────────────────────────┐
│                    CAMERA FEED                          │
│              CMSampleBuffer @ 30 FPS                    │
└───────────────────────┬─────────────────────────────────┘
                        │ Every frame
          ┌─────────────▼─────────────┐
          │      VISION ENGINE        │
          │  VNDetectHumanBodyPose    │
          │  PersonDetector           │
          └──────┬────────────────────┘
                 │ PoseObservation (≥15 FPS)
        ┌────────▼────────┐
        │ SCENE ANALYZER  │
        │ CoreML / Heuris │
        └────────┬────────┘
                 │ SceneContext
        ┌────────▼────────────────────┐
        │       RULE ENGINE           │
        │  Deterministic evaluation   │
        │  < 10ms                     │
        └────────┬────────────────────┘
                 │ [CoachingRule] — issues list
                 │
        ┌────────▼────────────────────┐
        │     AI ORCHESTRATOR         │
        │  Throttle: 1 req / 3s       │
        │  Fallback: Rule Engine      │
        └────────┬────────────────────┘
                 │ Structured JSON payload
        ┌────────▼────────────────────┐
        │     PROMPT BUILDER          │
        │  Build ChatCompletions req  │
        └────────┬────────────────────┘
                 │ HTTP POST
        ┌────────▼────────────────────┐
        │     OPENAI CLIENT           │
        │  URLSession async/await     │
        │  Timeout: 2s                │
        └────────┬────────────────────┘
                 │ Raw JSON response
        ┌────────▼────────────────────┐
        │     RESPONSE PARSER         │
        │  Validate + decode          │
        │  Fallback on error          │
        └────────┬────────────────────┘
                 │ AICoachingResponse
          ┌──────┴──────────┐
          │                 │
  ┌───────▼──────┐  ┌───────▼──────────┐
  │ OVERLAY      │  │ EDITING RECIPE   │
  │ RENDERER     │  │ (post-capture)   │
  │ CoachingCard │  │ CoreImageProcessor│
  └──────────────┘  └──────────────────┘
```

### Throttle & Caching Strategy

```
Frame → Rule Engine → [issues unchanged?]
                             │
                      Yes ───┼─── No
                             │         │
                      skip AI call   debounce 3s
                             │         │
                      use cached ◄──── AI call
                      response
```

---

## 7. Data Flow

### Flow 1 — Real-time Coaching Loop

```
CMSampleBuffer
    │
    ▼ (VisionEngine — background thread)
PoseObservation
    │
    ▼ (RuleEngine — background thread)
[CoachingRule]
    │
    ├──► immediate ──► OverlayViewModel (MainActor) ──► CoachingCard UI
    │
    └──► throttled ──► AIOrchestrator
                           │
                           ▼ (URLSession — background)
                       AICoachingResponse
                           │
                           ▼ (MainActor)
                       OverlayViewModel ──► CoachingCard UI
```

### Flow 2 — Capture Flow

```
User taps CaptureButton
    │
    ▼
CaptureViewModel.capture()
    │
    ▼ (AVCapturePhotoOutput)
UIImage (full resolution)
    │
    ▼
ReviewViewModel.init(image: UIImage, coaching: AICoachingResponse)
    │
    ├──► DisplayOriginal ──► BeforeAfterView
    │
    └──► CoreImageProcessor.apply(recipe)
              │
              ▼
         UIImage (edited) ──► BeforeAfterView
```

### Flow 3 — Save Flow

```
User taps "Lưu ảnh"
    │
    ▼
PhotoSaver.save(editedImage)
    │
    ├── Permission check
    │        │
    │        ├─ Denied ──► PermissionView
    │        │
    │        └─ Granted ──► PHPhotoLibrary.save()
    │                             │
    │                             ▼
    └────────────────────── Success toast + dismiss
```

---

## 8. State Machine

### App-level State

```
                ┌──────────┐
                │  Launch  │
                └────┬─────┘
                     │
          ┌──────────▼──────────┐
          │  Permission Check   │
          └──────┬──────────────┘
                 │
        ┌────────┴────────┐
        │                 │
   ┌────▼────┐      ┌─────▼──────┐
   │ Denied  │      │  Granted   │
   │ (show   │      │            │
   │  guide) │      └─────┬──────┘
   └─────────┘            │
                    ┌──────▼──────┐
                    │   Camera    │
                    │   Active    │◄──────────────┐
                    └──────┬──────┘               │
                           │                      │
              ┌────────────┼────────────┐         │
              │            │            │         │
         ┌────▼────┐  ┌────▼────┐  ┌───▼────┐    │
         │No Person│  │Detecting│  │Coaching│    │
         │         │  │         │  │        │    │
         └─────────┘  └────┬────┘  └───┬────┘    │
                           │           │         │
                      ┌────▼───────────▼────┐    │
                      │   ReadyToCapture    │    │
                      └────────┬────────────┘    │
                               │                 │
                       ┌───────▼───────┐         │
                       │  Capturing    │         │
                       └───────┬───────┘         │
                               │                 │
                       ┌───────▼───────┐         │
                       │   Reviewing   │         │
                       └───┬───────┬───┘         │
                           │       │             │
                      ┌────▼──┐  ┌─▼──────┐     │
                      │ Save  │  │ Retake ├─────┘
                      └───────┘  └────────┘
```

### CameraSession States

| State | Description | Overlay |
|-------|-------------|---------|
| `idle` | Camera chưa chạy | — |
| `noPerson` | Không phát hiện người | "Bước vào khung hình" |
| `detecting` | Đang phân tích pose | Skeleton loading |
| `coaching` | Có gợi ý cần điều chỉnh | CoachingCard active |
| `readyToCapture` | Tư thế đạt chuẩn | "Hoàn hảo! Chụp ngay" + pulse |
| `capturing` | Đang chụp | Flash effect |
| `reviewing` | Đang xem kết quả | ReviewScreen modal |

---

## 9. ADR — Architecture Decision Records

### ADR-001: Feature-First Folder Structure

**Decision:** Tổ chức code theo feature (CameraExperience, PoseCoaching...) thay vì layer (Views, Models, Services).

**Why:** 3 developers làm song song — mỗi người sở hữu một feature hoàn chỉnh, tránh conflict. Dễ onboard thêm AI coding agents sau này. Phù hợp với codebase scale lên.

**Trade-off:** Một số shared code cần đặt trong `Core/` — cần kỷ luật để không duplicate.

---

### ADR-002: @Observable thay vì ObservableObject

**Decision:** Dùng Swift Observation (`@Observable`) cho ViewModels, không dùng `ObservableObject` + `@Published`.

**Why:** Swift 6 native. Granular re-render (chỉ view nào đọc property đó mới re-render). Ít boilerplate hơn. Performance tốt hơn với camera frame updates tần số cao.

**Trade-off:** Requires iOS 17+. Chấp nhận được cho MVP target iPhone 11+.

---

### ADR-003: Vision Framework thay vì Custom CoreML Model

**Decision:** Dùng `VNDetectHumanBodyPoseRequest` built-in, không train custom model.

**Why:** No ML model required cho MVP. Apple's built-in đủ cho 17 landmarks. Không tốn thời gian chuẩn bị dataset / training trong hackathon 4 giờ.

**Trade-off:** Ít customizable hơn. V2 có thể replace bằng fine-tuned model.

---

### ADR-004: Chỉ gửi Metadata lên OpenAI — Không upload ảnh

**Decision:** AI payload chỉ chứa structured JSON (scene, pose, issues). Không bao giờ encode UIImage thành base64 gửi lên cloud.

**Why:** Privacy-first principle. Giảm latency (JSON << image size). Giảm OpenAI cost (Vision API đắt hơn Chat). Phù hợp App Store privacy requirements.

**Trade-off:** AI không thể nhận xét về ánh sáng thực tế hay bố cục chi tiết — chỉ biết qua metadata. Chấp nhận được cho MVP.

---

### ADR-005: Rule Engine chạy trước AI

**Decision:** Rule Engine deterministic chạy trên mọi frame. AI chỉ được gọi khi Rule Engine phát hiện issues, và throttle 1 request/3 giây.

**Why:** Rule Engine < 10ms, không cần network. Giảm OpenAI API calls > 90%. Overlay vẫn hoạt động khi offline. Fallback tự nhiên.

**Trade-off:** Coaching text từ Rule Engine ít tự nhiên hơn AI. Giải quyết bằng cách AI override Rule Engine text khi có response.

---

### ADR-006: Async/Await — Không dùng Combine

**Decision:** Dùng Swift Concurrency (async/await, actors, AsyncStream) xuyên suốt codebase. Không dùng Combine.

**Why:** Swift 6 concurrency model rõ ràng hơn, dễ debug hơn Combine. Compiler-enforced data race safety. Dễ đọc và maintain. Phù hợp với team và AI coding agents.

**Trade-off:** Một số Apple APIs vẫn Combine-based — wrap chúng trong async wrappers.

---

### ADR-007: Mock Mode

**Decision:** AIOrchestrator có `MockAIOrchestrator` implementing cùng protocol, return canned responses.

**Why:** Dev C có thể build AI layer mà không cần API key. Demo backup khi network fail. Unit testing không cần network.

**Trade-off:** Cần maintain mock data sync với real response schema.

---

## 10. Future Expansion

### Pluggable AI Backend

```
AIOrchestrator
    │
    ├── OpenAIClient (current)
    ├── AnthropicClient (V1)
    └── OnDeviceCoreMLModel (V2)
```

`AIOrchestrator` nhận bất kỳ backend nào implement `AIBackendProtocol`.

### Pluggable Vision Models

```
VisionEngine
    │
    ├── AppleVisionPoseDetector (current)
    └── CustomCoreMLPoseDetector (V2)
```

### New Features plug vào Features/ không ảnh hưởng core

```
Features/
    ├── [existing features]
    ├── CompositionGuide/     ← V1: tự thêm vào
    ├── AutoCapture/          ← V1
    ├── GroupCoaching/        ← V2
    └── VoiceCoaching/        ← V2
```

### Scene Classification Scale-up

```
SceneAnalysis/
    ├── SceneClassifierService (indoor/outdoor — MVP)
    └── DetailedSceneClassifier (cafe/beach/street... — V1)
```

---

*Architecture này là blueprint cho toàn bộ implementation. Mọi module plan và code generation phải follow document này.*
