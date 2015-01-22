WatchKit animations seems to be hardworking process to set up to.

The point of this project is to simplify WatchKit animation creation
using existing codebase.

For now it supports [`CABasicAnimation`](https://developer.apple.com/library/mac/documentation/GraphicsImaging/Reference/CABasicAnimation_class/index.html)
and [custom animatable properties](https://developer.apple.com/library/ios/samplecode/sc2284/Introduction/Intro.html)

---

## Installation
Just copy `WatchAnimationHelper.swift` to your project.

##Usage
### CALayer property animation
Imagine the following animation for rotation:
```swift
var rotation = CABasicAnimation(keyPath: "transform.rotation.z")
rotation.fromValue = 0
rotation.toValue = M_PI * 2.0
rotation.duration = 2
self.layer.addAnimation(rotation, forKey: "rotationAnimation")
```
In order to get animated image ready for WKInterfaceImage replace
```swift
self.layer.addAnimation(rotation, forKey: "rotationAnimation")
```
with
```swift
var animatedImage = self.watch_resolveAnimation(rotation)
```
then use it with
```swift
override func awakeWithContext(context: AnyObject?) {
    //...
    var animatedImage = self.watch_resolveAnimation(rotation)
    animationDuration = animatedImage.duration
    imagesCount = animatedImage.images!.count
    WKInterfaceDevice.currentDevice().addCachedImage(img, name: "anim")
    //..
}

func startAnimation() {
    wkImage.setImageNamed("anim")
    wkImage.startAnimatingWithImagesInRange(NSMakeRange(0, count),
                                            duration: duration,
                                            repeatCount: -1)
}
```

### Custom property animation
In order to use such method with your custom animatable property
you need to define your custom property
```swift
class RoundLayer: CALayer {
    dynamic var radius: CGFloat = 0

    override class func needsDisplayForKey(key: String) -> Bool {
        if key == "radius" {
            return true
        }
        return super.needsDisplayForKey(key)
    }
}
```
and use this layer in some view
```swift
class RoundView: UIView {
    override class func layerClass() -> AnyClass {
        return RoundLayer.self
    }

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
    }

    override func drawLayer(layer: CALayer, inContext context: CGContextRef) {
        var radius = (layer as RoundLayer).radius

        var circleRect = CGContextGetClipBoundingBox(context)
        CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
        CGContextFillEllipseInRect(context, CGRectMake((circleRect.size.width-radius)/2, (circleRect.size.height-radius)/2, radius, radius))
    }
}
```
then having such animation
```swift
var animation = CABasicAnimation(keyPath: "radius")
animation.duration = 0.4
animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
animation.fromValue = 0
animation.toValue = 100
(self.layer as QQMapPointLayer).radius = 100

self.layer.addAnimation(animation, forKey: "radiusAnimation")
```
the last line can be replaced with
```swift
var animatedImage = self.watch_resolveAnimation(animation)
```

## Issues / Limitations
- Only `CABasicAnimation` is supported for now
- Looking forward to resolve `CAAnimationGroup` and `CAKeyframeAnimation`
- Not all animation use-cases might be covered
