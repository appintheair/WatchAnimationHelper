//
//  ViewController.swift
//  LayerAnimations
//
//  Created by Sergey Pronin on 1/16/15.
//  Copyright (c) 2015 AITA LTD. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var point: RoundView!
    var plane: PlaneView!
    var imageView: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        point = RoundView(location: CGPointMake(self.view.center.x, self.view.center.y))
        point.backgroundColor = UIColor.clearColor()
        self.view.addSubview(point)

        imageView.frame = CGRectMake(100, 100, 100, 100)
        imageView.backgroundColor = UIColor.grayColor()
        self.view.addSubview(imageView)
        
        plane = PlaneView()
        plane.center = self.view.center
        self.view.addSubview(plane)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickButton(sender: AnyObject) {
        var image = plane.animate()
//        var image = point.animate()
        
        imageView.animationImages = image.images!
        imageView.animationDuration = 2
        imageView.startAnimating()
    }

}

