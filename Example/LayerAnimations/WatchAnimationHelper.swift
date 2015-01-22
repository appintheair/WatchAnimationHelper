// WatchAnimationHelper.swift
//
// Copyright (c) 2014 App in the Air https://www.appintheair.mobi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import UIKit
import QuartzCore

/// Default animation frames/second
let FPS: Double = 60

extension UIView {
    /**
        Resolves CABasicAnimation generating animated image.
    
        :param: animation CABasicAnimation to resolve
        
        :returns: an animated image
    */
    func watch_resolveAnimation(animation: CABasicAnimation) -> UIImage {
        var timingFunction = animation.timingFunction ?? CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        var bezier: [CGPoint] = []  //cubic bezier
        //resolving bezier to 4 points
        for i in 0...3 {
            var pointsPointer = UnsafeMutablePointer<Float>.alloc(2)
            timingFunction!.getControlPointAtIndex(UInt(i), values: pointsPointer)
            var c = CGPointMake(CGFloat(pointsPointer[0]), CGFloat(pointsPointer[1]))
            bezier.append(c)
        }
        
        var fromValue = animation.fromValue as Double
        var valueSpan: Double = (animation.toValue as Double) - fromValue
        
        var iterations = animation.duration * FPS
        var percentPerTick = 1.0 / iterations
        
        var images: [UIImage] = []  //holds rendered images
        
        var currentPercent = 0.0
        for _ in 0...Int(iterations) {
            var bezValue = resolveBezier(bezier, percent: currentPercent)       //value on bezier curve
            var currentValue = fromValue + valueSpan*Double(1-bezValue.x)       //current value on [fromValue, toValue] segment
            
            self.layer.setValue(currentValue, forKeyPath: animation.keyPath)    //setting current layer's value
            images.append(self.renderToImage())                                 //rendering contents to image
            
            currentPercent += percentPerTick
        }
        return UIImage.animatedImageWithImages(images, duration: animation.duration)
    }
    
    /**
        Renders current view's layer to an image.
        It respects transformations applied to layer.
        
        Chooses between renderInContext: and drawLayer:inContext:
        depending on which class view's layer belongs to.
    
        :returns: Image representation of layer's contents
    */
    func renderToImage() -> UIImage {
        //preparting context for rendering
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        
        var context = UIGraphicsGetCurrentContext()
        
        //applying transformations from layer to context
        var transform = self.layer.affineTransform()
        CGContextTranslateCTM(context, self.bounds.size.width/2, self.bounds.size.height/2)
        CGContextConcatCTM(context, transform)
        CGContextTranslateCTM(context, -self.bounds.size.width/2, -self.bounds.size.height/2)
        //if custom layer's class -> uses drawLayer
        if String.fromCString(class_getName(self.layer.dynamicType))! != "CALayer" {
            self.drawLayer(self.layer, inContext: UIGraphicsGetCurrentContext())
        } else {
            self.layer.renderInContext(context)
        }
        
        //extracting image from context
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

/**
    Resolves Bezier curve according to formulae

    B(t)=(1-t)^3*p0 + 3(1-t)^2*t*p1 + 3(1-t)*t^2*p2 + t^3*p3 | t=[0,1]

    http://en.wikipedia.org/wiki/B%C3%A9zier_curve


    :param: p Bezier Curve description: array[4] of points for cubic curve
    :param: percent Percent of the final value to be calculated [0,1]

    :returns: Calculated point on the given Bezier Curve. X - value, Y - timing parameter
*/
func resolveBezier(p: [CGPoint], #percent: Double) -> CGPoint {
    var point = CGPoint()
    point.x = p[0].x*B1(percent) + p[1].x*B2(percent) + p[2].x*B3(percent) + p[3].x*B4(percent)
    point.y = p[0].y*B1(percent) + p[1].y*B2(percent) + p[2].y*B3(percent) + p[3].y*B4(percent)
    return point
}

func B1(t: Double) -> CGFloat {
    return CGFloat(t*t*t)
}

func B2(t: Double) -> CGFloat {
    return CGFloat(3*t*t*(1-t))
}

func B3(t: Double) -> CGFloat {
    return CGFloat(3*t*(1-t)*(1-t))
}

func B4(t: Double) -> CGFloat {
    return CGFloat((1-t)*(1-t)*(1-t))
}
