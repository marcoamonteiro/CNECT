//
//  UIImageEffects.swift
//  CNECT
//
//  Created by Tobin Bell on 3/3/16.
//  Copyright © 2016 Marco Monteiro. All rights reserved.
//
/*
import Accelerate

class UIImageEffects {
    
    static func imageByApplyingLightEffectTo(inputImage: UIImage) -> UIImage? {
        let tintColor = UIColor(white: 1.0, alpha: 0.3)
        return imageByApplyingBlurTo(inputImage, radius: 60, tintColor: tintColor, saturationDeltaFactor: 1, maskImage: nil)
    }
    
    static func imageByApplyingExtraLightEffectTo(inputImage: UIImage) -> UIImage? {
        let tintColor = UIColor(white: 0.97, alpha: 0.82)
        return imageByApplyingBlurTo(inputImage, radius: 40, tintColor: tintColor, saturationDeltaFactor: 1, maskImage: nil)
    }
    
    static func imageByApplyingDarkEffectTo(inputImage: UIImage) -> UIImage? {
        let tintColor = UIColor(white: 0.11, alpha: 0.73)
        return imageByApplyingBlurTo(inputImage, radius: 40, tintColor: tintColor, saturationDeltaFactor: 1, maskImage: nil)
    }
    
    static func imageByApplyingTintEffectTo(inputImage: UIImage, withColor tintColor: UIColor) -> UIImage? {
        let effectAlpha = CGFloat(0.6)
        var effectColor = tintColor
        let componentCount = CGColorGetNumberOfComponents(tintColor.CGColor)
        
        if (componentCount == 2) {
            var white = CGFloat()
            if tintColor.getWhite(&white, alpha: nil) {
                effectColor = UIColor(white: white, alpha: effectAlpha)
            }
        } else {
            var red = CGFloat(), green = CGFloat(), blue = CGFloat()
            if tintColor.getRed(&red, green: &green, blue: &blue, alpha: nil) {
                effectColor = UIColor(red: red, green: green, blue: blue, alpha: effectAlpha)
            }
        }
        
        return imageByApplyingBlurTo(inputImage, radius: 20, tintColor: effectColor, saturationDeltaFactor: -1, maskImage: nil)
    }
    
    /**
     * Applies a blur, tint color, and saturation adjustment to @a inputImage,
     * optionally within the area specified by @a maskImage.
     *
     * - parameter inputImage:
     *      The source image.  A modified copy of this image will be returned.
     * - parameter blurRadius:
     *      The radius of the blur in points.
     * - parameter tintColor:
     *      An optional UIColor object that is uniformly blended with the
     *      result of the blur and saturation operations.  The alpha channel
     *      of this color determines how strong the tint is.
     * - parameter saturationDeltaFactor
     *      A value of 1.0 produces no change in the resulting image.  Values
     *      less than 1.0 will desaturation the resulting image while values
     *      greater than 1.0 will have the opposite effect.
     * - parameter maskImage
     *      If specified, @a inputImage is only modified in the area(s) defined
     *      by this mask.  This must be an image mask or it must meet the
     *      requirements of the mask parameter of CGContextClipToMask.
     */
    private static func imageByApplyingBlurTo(inputImage: UIImage, radius inputRadius: Float, tintColor: UIColor?, saturationDeltaFactor: Float, maskImage: UIImage?) -> UIImage? {
        
        // Check pre-conditions.
        if inputImage.size.width < 1 || inputImage.size.height < 1 {
            print("*** error: invalid size: (\(inputImage.size.width) x \(inputImage.size.height)). Both dimensions must be >= 1: \(inputImage)")
            return nil
        }
        
        guard let inputCGImage = inputImage.CGImage else {
            print("*** error: inputImage must be backed by a CGImage: \(inputImage)")
            return nil
        }
        
        if maskImage != nil && maskImage?.CGImage != nil {
            print("*** error: effectMaskImage must be backed by a CGImage: \(maskImage)")
            return nil
        }
        
        let hasBlur = inputRadius > __FLT_EPSILON__
        let hasSaturationChange = fabs(saturationDeltaFactor - 1) > __FLT_EPSILON__
        
        let inputImageScale = inputImage.scale
        let inputImageBitmapInfo = CGImageGetBitmapInfo(inputCGImage)
        let inputImageAlphaInfo = CGImageAlphaInfo(rawValue: inputImageBitmapInfo.rawValue & CGBitmapInfo.AlphaInfoMask.rawValue)
        
        let outputImageSizeInPoints = inputImage.size
        let outputImageRectInPoints = CGRect(origin: CGPoint.zero, size: outputImageSizeInPoints)
        
        // Set up output context.
        let useOpaqueContext = inputImageAlphaInfo == .None ||
                                inputImageAlphaInfo == .NoneSkipLast ||
                                inputImageAlphaInfo == .NoneSkipFirst
        
        UIGraphicsBeginImageContextWithOptions(outputImageRectInPoints.size, useOpaqueContext, inputImageScale)
        let outputContext = UIGraphicsGetCurrentContext()
        
        CGContextScaleCTM(outputContext, 1, -1)
        CGContextTranslateCTM(outputContext, 0, -outputImageRectInPoints.size.height)
        
        if hasBlur || hasSaturationChange {
            
            var effectInBuffer = vImage_Buffer()
            var scratchBuffer1 = vImage_Buffer()
            
            var inputBuffer = withUnsafeMutablePointer(&effectInBuffer) { $0 }
            var outputBuffer = withUnsafeMutablePointer(&scratchBuffer1) { $0 }
            
            var format = vImage_CGImageFormat(bitsPerComponent: 8,
                bitsPerPixel: 32,
                colorSpace: nil,
                bitmapInfo: CGBitmapInfo(rawValue:
                    CGImageAlphaInfo.PremultipliedFirst.rawValue | CGBitmapInfo.ByteOrder32Little.rawValue),
                version: 0,
                decode: nil,
                renderingIntent: .RenderingIntentPerceptual)
            
            let error = vImageBuffer_InitWithCGImage(&scratchBuffer1, &format, nil, inputCGImage, UInt32(kvImagePrintDiagnosticsToConsole))
           
            if error != kvImageNoError {
                print("*** error: vImageBuffer_InitWithCGImage returned error code \(error) for inputImage: \(inputImage)")
                UIGraphicsEndImageContext()
                return nil
            }
            
            vImageBuffer_Init(&scratchBuffer1, effectInBuffer.height, effectInBuffer.width, format.bitsPerPixel, UInt32(kvImageNoFlags))
            
            if hasBlur {
                // A description of how to compute the box kernel width from the Gaussian
                // radius (aka standard deviation) appears in the SVG spec:
                // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
                //
                // For larger values of 's' (s >= 2.0), an approximation can be used: Three
                // successive box-blurs build a piece-wise quadratic convolution kernel, which
                // approximates the Gaussian kernel to within roughly 3%.
                //
                // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
                //
                // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
                //
                var inputRadius = inputRadius * Float(inputImageScale)
                if inputRadius - 2 < __FLT_EPSILON__ {
                    inputRadius = 2
                }
                
                var radius = UInt32((inputRadius * 3 * Float(sqrt(2 * M_PI)) / 4 + 0.5) / 2)
                radius |= 1; // force radius to be odd so that the three box-blur methodology works.
                
                let tempBufferSize = vImageBoxConvolve_ARGB8888(inputBuffer,
                    outputBuffer,
                    nil,
                    0, 0,
                    radius, radius,
                    nil,
                    UInt32(kvImageGetTempBufferSize | kvImageEdgeExtend))
                
                let tempBuffer = malloc(tempBufferSize)
                
                vImageBoxConvolve_ARGB8888(inputBuffer,
                    outputBuffer,
                    tempBuffer,
                    0, 0,
                    radius, radius,
                    nil,
                    UInt32(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(outputBuffer,
                    inputBuffer,
                    tempBuffer,
                    0, 0,
                    radius,
                    radius,
                    nil,
                    UInt32(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(inputBuffer,
                    outputBuffer,
                    tempBuffer,
                    0, 0,
                    radius, radius,
                    nil,
                    UInt32(kvImageEdgeExtend))
                
                free(tempBuffer)
                
                swap(&inputBuffer, &outputBuffer)
            }
                
            if hasSaturationChange {
                let s = saturationDeltaFactor
                
                // These values appear in the W3C Filter Effects spec:
                // https://dvcs.w3.org/hg/FXTF/raw-file/default/filters/index.html#grayscaleEquivalent
                let floatingPointSaturationMatrix: [Float] = [
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                    0,                    0,                    0,                    1,
                ]
                
                let divisor = Int32(256)
                
                var roundedSaturationMatrix = floatingPointSaturationMatrix.map { float in
                    return Int16(roundf(float * Float(divisor)))
                }
                
                let saturationMatrix = UnsafeMutablePointer<Int16>.alloc(roundedSaturationMatrix.count)
                roundedSaturationMatrix.withUnsafeMutableBufferPointer { pointer in
                    let a = pointer.baseAddress
                    saturationMatrix.initializeFrom(a, count: roundedSaturationMatrix.count)
                }
                
                vImageMatrixMultiply_ARGB8888(inputBuffer, outputBuffer, saturationMatrix, divisor, nil, nil, UInt32(kvImageNoFlags))
                
                swap(&inputBuffer, &outputBuffer)
            }
            
            var effectCGImage = vImageCreateCGImageFromBuffer(inputBuffer, &format, cleanupBuffer, nil, UInt32(kvImageNoAllocate), nil)?.takeUnretainedValue()
            
            if effectCGImage == nil {
                effectCGImage = vImageCreateCGImageFromBuffer(inputBuffer, &format, nil, nil, UInt32(kvImageNoFlags), nil)?.takeUnretainedValue()
                free(inputBuffer.memory.data)
            }
            
            if maskImage != nil {
                // Only need to draw the base image if the effect image will be masked.
                CGContextDrawImage(outputContext, outputImageRectInPoints, inputCGImage)
            }
            
            // draw effect image
            CGContextSaveGState(outputContext)
            if let maskImage = maskImage {
                CGContextClipToMask(outputContext, outputImageRectInPoints, maskImage.CGImage)
            }
            CGContextDrawImage(outputContext, outputImageRectInPoints, effectCGImage)
            CGContextRestoreGState(outputContext)
            
            // Cleanup
            free(outputBuffer.memory.data)
        } else {
            // draw base image
            CGContextDrawImage(outputContext, outputImageRectInPoints, inputCGImage)
        }
        
        // Add in color tint.
        if let tintColor = tintColor {
            CGContextSaveGState(outputContext)
            CGContextSetFillColorWithColor(outputContext, tintColor.CGColor)
            CGContextFillRect(outputContext, outputImageRectInPoints)
            CGContextRestoreGState(outputContext)
        }
        
        // Output image is ready.
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return outputImage
        
    }
    
}

private func cleanupBuffer(userData: UnsafeMutablePointer<Void>, bufferData: UnsafeMutablePointer<Void>) {
    free(bufferData)
}
*/