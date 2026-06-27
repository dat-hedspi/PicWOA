@preconcurrency import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

struct CoreImageProcessor: ImageProcessor {

    private let context = CIContext()

    func apply(recipe: EditingRecipe, to image: UIImage) async -> UIImage {
        guard let ciImage = CIImage(image: image) else { return image }

        var output = ciImage
        let recipe = soften(recipe)

        // Exposure
        let exposureFilter = CIFilter.exposureAdjust()
        exposureFilter.inputImage = output
        exposureFilter.ev = recipe.exposure
        output = exposureFilter.outputImage ?? output

        // Contrast & Highlights & Shadows (via Tone Curve)
        let colorControls = CIFilter.colorControls()
        colorControls.inputImage = output
        colorControls.contrast = 1.0 + (recipe.contrast / 100.0)
        colorControls.brightness = 0
        colorControls.saturation = 1.0 + (recipe.vibrance / 300.0)
        output = colorControls.outputImage ?? output

        // Temperature
        let tempFilter = CIFilter.temperatureAndTint()
        tempFilter.inputImage = output
        tempFilter.neutral = CIVector(x: 6500 + CGFloat(recipe.temperature * 10), y: 0)
        output = tempFilter.outputImage ?? output

        // Highlights & Shadows
        let highlightFilter = CIFilter.highlightShadowAdjust()
        highlightFilter.inputImage = output
        highlightFilter.highlightAmount = 1.0 + (recipe.highlights / 250.0)
        highlightFilter.shadowAmount = 1.0 + (recipe.shadows / 250.0)
        output = highlightFilter.outputImage ?? output

        guard let cgImage = context.createCGImage(output, from: output.extent) else { return image }
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }

    private func soften(_ recipe: EditingRecipe) -> EditingRecipe {
        EditingRecipe(
            exposure: clamp(recipe.exposure * 0.35, min: -0.2, max: 0.2),
            contrast: clamp(recipe.contrast * 0.45, min: -12, max: 12),
            highlights: clamp(recipe.highlights * 0.35, min: -15, max: 10),
            shadows: clamp(recipe.shadows * 0.35, min: -10, max: 15),
            temperature: clamp(recipe.temperature * 0.35, min: -8, max: 8),
            vibrance: clamp(recipe.vibrance * 0.4, min: -10, max: 12)
        )
    }

    private func clamp(_ value: Float, min: Float, max: Float) -> Float {
        Swift.max(min, Swift.min(max, value))
    }
}
