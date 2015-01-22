//
//  Views.swift
//  LayerAnimations
//
//  Created by Sergey Pronin on 1/21/15.
//  Copyright (c) 2015 AITA LTD. All rights reserved.
//

import UIKit
import Foundation
import QuartzCore

class RoundLayer: CALayer {
    dynamic var radius: CGFloat = 0
    
    override init(layer: AnyObject) {
        super.init(layer: layer)
        if layer is RoundLayer {
            self.radius = (layer as RoundLayer).radius
        }
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init() {
        super.init()
    }
    
    override class func needsDisplayForKey(key: String) -> Bool {
        if key == "radius" {
            return true
        }
        return super.needsDisplayForKey(key)
    }
}
let kRoundMaxRadius: CGFloat = 100
class RoundView: UIView {
    
    var pointColor: UIColor = UIColor.redColor()
    
    convenience init(location: CGPoint) {
        self.init(frame: CGRectMake(location.x, location.y, kRoundMaxRadius, kRoundMaxRadius))
    }
    
    override init(var frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override class func layerClass() -> AnyClass {
        return RoundLayer.self
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
    }
    
    override func drawLayer(layer: CALayer, inContext context: CGContextRef) {
        var radius = (layer as RoundLayer).radius
        
        //        println(radius)
        
        var circleRect = CGContextGetClipBoundingBox(context)
        CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
        CGContextFillEllipseInRect(context, CGRectMake((circleRect.size.width-radius)/2, (circleRect.size.height-radius)/2, radius, radius))
    }
    
    func animate() -> UIImage {
        var animation = CABasicAnimation(keyPath: "radius")
        animation.duration = 0.4
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.fromValue = 0
        animation.toValue = kRoundMaxRadius
        (self.layer as RoundLayer).radius = kRoundMaxRadius
        //        self.layer.addAnimation(animation, forKey:"radius")
        
        return self.watch_resolveAnimation(animation)
    }
}

class PlaneView: UIView {
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(var frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience override init() {
        var img = UIImage(named: "hud_plane")!
        var imageView = UIImageView(image: img)
        self.init(frame: CGRectMake(0, 0, img.size.width, img.size.height))
        self.addSubview(imageView)
        self.backgroundColor = UIColor.blackColor()
    }
    
    func animate() -> UIImage {
        var rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = M_PI * 2.0
        rotation.duration = 2
        self.layer.addAnimation(rotation, forKey: "rotationAnimation")
        
        return self.watch_resolveAnimation(rotation)
    }
}