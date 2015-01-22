//
//  InterfaceController.swift
//  LayerAnimations WatchKit Extension
//
//  Created by Sergey Pronin on 1/18/15.
//  Copyright (c) 2015 AITA LTD. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    @IBOutlet weak var image: WKInterfaceImage!
    
    var duration: Double!
    var count: Int!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        var point = RoundView(location: CGPointMake(0, 0))
        point.backgroundColor = UIColor.clearColor()
        var img = point.animate()
        duration = img.duration
        count = img.images!.count
        WKInterfaceDevice.currentDevice().addCachedImage(img, name: "anim")
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        image.setImageNamed("anim")
        image.startAnimatingWithImagesInRange(NSMakeRange(0, count), duration: duration, repeatCount: -1)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
