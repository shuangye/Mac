View programming Guide for iOS
Apple Official Documentation


# Animations #
本章讲的动画技术都是 Core Animation 内置的，你要做的就是触发动画，对每一帧的渲染就是 Core Animation 的事了。

## What Can Be Animated? ##
UIKit 和 Core Animation 都提供了对动画的支持，但二者所支持的 level 不同。UIkit 中的动画是使用 UIView 对象执行的，view 支持一些基本、常用的动画。如你可以用动画呈现对 view 的属性的改变，或以 transition animation 的形式替换一部分 view.

UIView 类可以施加动画效果的属性，即对动画有内置支持的属性：

- frame: 修改 view 的位置和大小（相对于 superview 的坐标系统）；
- bounds: 修改 view 的大小；
- center: 修改 view 的位置（相对于 superview 的坐标系统）；
- transform: scale, rotate, or translate the view relative to its center point. 使用该属性的 transformations 总是在 2D 空间内执行，要执行 3D transformations, 必须使用 Core Animation 操纵 view 的 layer object.
- alpha: 修改 view 的透明度；
- backgroundColor: 修改 view 的背景色；
- contentStretch: 修改 view 的内容以怎样的方式填充可用空间。

可施加动画并不意味着动画会自动发生，对这些属性的普通修改仅仅是立即更新了这些属性而无动画效果。要产生动画效果，需要在 animation block 中修改这些属性值。

要执行更复杂的动画，或 UIView 类不支持的动画，就要使用 Core Animation 及 view's underlying layer 了。 View 和 layer 对象紧密关联，对 view's layer 的修改会影响支 view 自身。使用 Core Animation 可对 view's layer 执行以下类型的动画：

- Layer 的大小和位置；
- 执行 transformations 时所使用的中心点；
- 在 3D 空间内对 layer 或其 sub layers 执行 transformations;
- 从 layer hierarchy 中增加或删除一个 layer;
- Layer 相对于其他 sibling layers 的 Z-index;
- Layer's shadow;
- Layer's border (including whether the layer's corners are rounded);
- The portion of the layer that stretches during resizing operations
- The layer's opacity
- The clipping behavior for sub layers that lie outside the layer's bounds
- Layer 的当前内容
- The rasterization behavior of the layer

Note: If your view hosts custom layer objects—that is, layer objects without an associated view—you must use Core Animation to animate any changes to them.

## Animating Property Changes in a View ##
把对 UIView 属性的改变放在 animation block 中。The term animation block is used in the generic sense to refer to any code that designates animatable changes. 在 iOS 4 + 中使用 block 对象创建 animation block, 在较早版本中则用 UIView 的特殊类方法 (+beginAnimations:context:, +commitAnimations) 标记 animation block 的开始和结束。

注：Apple 推荐使用块对象来创建 animation block, 故本章省略 +beginAnimations:context:, +commitAnimations 类方法。

### Starting Animations Using the Block-Based Mehthods ###

Class methods for iOS 4 +:

- animateWithDuration:animations:
- animateWithDuration:animations:completion:
- animateWithDuration:delay:options:animations:completion:

以上动画方法是在另一个独立的线程上执行的，这样可避免阻塞当前线程或主线程。可以在 completion handler 参数中通知程序动画已完成，或串联另一个动画。

若动画修改了属性 A 的值且正在执行中，此时又再修改属性 A 的值不会使动画停止，而是把属性 A 动画呈现到新赋的值。 

Important: Changing the value of a property while an animation involving that property is already in progress does not stop the current animation. Instead, the current animation continues and animates to the new value you just assigned to the property.

### Nesting Animation Blocks ###

嵌套动画 vs. 串联动画：嵌套动画把新定义的动画放在 animations: 参数中，而串联动画把新定义的动画放在 completion 参数中。

串联的动画与它所在的父级动画同时开始，且继承了父级动画的配置参数，但这些参数可以被 overridden. 如：

    [UIView animateWithDuration:1.0
                          delay:0.3
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                                   aView.alpha = 0.0;     
                                   // Create a nested animation that has a different
                                   // duration, timing curve, and configuration.
                                   [UIView animateWithDuration:0.20
                                                         delay:0.0
                                                       options:UIViewAnimationOptionOverrideInheritedCurve |
                                                               UIViewAnimationOptionCurveLinear |
                                                               UIViewAnimationOptionOverrideInheritedDuration |
                                                               UIViewAnimationOptionRepeat |
                                                               UIViewAnimationOptionAutoreverse
                                                    animations:^{
                                                                 [UIView setAnimationRepeatCount:2.5];
                                                                 anotherView.alpha = 0.0;
                                                                }
                                                    completion:nil];     
                                 }
                     completion:nil];

### Implementing Animations That Reverse Themselves ###

When creating reversible animations in conjunction with a repeat count, consider specifying a non integer value for the repeat count. For an auto-reversing animation, each complete cycle of the animation involves animating from the original value to the new value and back again. If you want your animation to end on the new value, adding 0.5 to the repeat count causes the animation to complete the extra half cycle needed to end at the new value. If you do not include this half step, your animation will animate to the original value and then snap quickly to the new value, which may not be the visual effect you want.

## Creating Animated Transitions Between Views ##

Animated view transitions are a way for you to make changes to your view hierarchy beyond those offered by view controllers. Although you should use view controllers to manage succinct view hierarchies, there may be times when you want to replace all or part of a view hierarchy. In those situations, you can use view-based transitions to animate the addition and removal of your views.

View transitions help you hide sudden changes associated with adding, removing, hiding, or showing views in your view hierarchy. You use view transitions to implement the following types of changes:

- **Change the visible subviews of an existing view.** You typically choose this option when you want to make relatively small changes to an existing view.
- **Replace one view in your view hierarchy with a different view.** You typically choose this option when you want to replace a view hierarchy that spans all or most of the screen.

不要把 view transitions 与 view controller 发起的 (initiated) transitions 混淆，后者如 modal view controller 展示内容，或新的 view controller 推入 navigation stack. View transitions 只影响 view hierarchy, 而 view controller transitions 还改变当前活跃的 view controller.

### Changing the Subviews of a View ###

    class func transitionWithView(_ view: UIView,
                         duration duration: NSTimeInterval,
                          options options: UIViewAnimationOptions,
                       animations animations: () -> Void,
                       completion completion: ((Bool) -> Void)?)

TBC...

### Replacing a View with a Different View ###

欲使界面有显著变化时，可尝试替换 views. 该技术仅交换 views 而不交换 view controllers, 故你需负责适当地设计程序的 controller 对象。该技术是使用一些标准 transitions 快速呈现新 views 的方法。

    // iOS 4 +, to transition between two views
    class func transitionFromView(_ fromView: UIView,
                           toView toView: UIView,
                         duration duration: NSTimeInterval,
                          options options: UIViewAnimationOptions,
                       completion completion: ((Bool) -> Void)?)

该方法实际会把第一个 view 从 hierarchy 中移除、并插入第二个，故若要保留第一个，则要确保拥有对其引用。若只是想把 view 隐藏而不是将其从 hierarchy 中移除，请在 options 参数中加入 UIViewAnimationOptionShowHideTransitionViews.

以下代码在单个 view controller 的两个 subviews (primaryView, secondaryView) 之间切换（注：除了切换，view controller 还需管理这两个 subviews 的加载与卸载）： 

    - (IBAction)toggleMainViews:(id)sender {
        [UIView transitionFromView:(displayingPrimary ? primaryView : secondaryView)
                            toView:(displayingPrimary ? secondaryView : primaryView)
                          duration:1.0
                           options:(displayingPrimary ? UIViewAnimationOptionTransitionFlipFromRight :
                                   UIViewAnimationOptionTransitionFlipFromLeft)
                        completion:^(BOOL finished) {
                                      if (finished)
                                          displayingPrimary = !displayingPrimary;                                      
                                   }];
    }

## Animating View and Layer Changes Together ##

可自由地混合基于 view 和 基于 layer 的动画代码，但配置动画参数的过程取决于 layer 的拥有者。
更改 view-owned layer 与更改 view 自身一样，且施加于 layer' properties 的动画遵循当前 view-based animation block 的动画参数。但这对自己创建的 layer 不成立，自定义的 layer 对象会忽略 view-based animation block 参数并使用默认的 Core Animation 参数。

Applications can freely mix view-based and layer-based animation code as needed but the process for configuring your animation parameters depends on who owns the layer. Changing a view-owned layer is the same as changing the view itself, and any animations you apply to the layer’s properties respect the animation parameters of the current view-based animation block. The same is not true for layers that you create yourself. Custom layer objects ignore view-based animation block parameters and use the default Core Animation parameters instead.

若要为自己创建的 layer 自定义动画参数，必须直接使用 Core Animation. 使用 Core Animation 通常要创建 CAAnimation 的子类对象，然后将其加到相应的 layer. 可以在 view-based animation block 之内或之外施加这样的动画。

以下代码同时对一个 view 和一个自定义 layer 施加动画。
Listing 4-9 shows an animation that modifies a view and a custom layer at the same time. The view in this example contains a custom CALayer object at the center of its bounds. The animation rotates the view counter clockwise while rotating the layer clockwise. Because the rotations are in opposite directions, the layer maintains its original orientation relative to the screen and does not appear to rotate significantly. However, the view beneath that layer spins 360 degrees and returns to its original orientation. This example is presented primarily to demonstrate how you can mix view and layer animations. This type of mixing should not be used in situations where precise timing is needed.

    [UIView animateWithDuration:1.0
                          delay:0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                        // Animate the first half of the view rotation.
                        CGAffineTransform  xform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-180));
                        backingView.transform = xform;
     
                        // Rotate the embedded CALayer in the opposite direction.
                        CABasicAnimation*layerAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
                        layerAnimation.duration = 2.0;
                        layerAnimation.beginTime = 0; //CACurrentMediaTime() + 1;
                        layerAnimation.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionRotateZ];
                        layerAnimation.timingFunction = [CAMediaTimingFunction
                        functionWithName:kCAMediaTimingFunctionLinear];
                        layerAnimation.fromValue = [NSNumber numberWithFloat:0.0];
                        layerAnimation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(360.0)];
                        layerAnimation.byValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(180.0)];
                        [manLayer addAnimation:layerAnimation forKey:@"layerAnimation"];
                     }
                   completion:^(BOOL finished){
                   // Now do the second half of the view rotation.
                   [UIView animateWithDuration:1.0
                                         delay: 0.0
                                       options: UIViewAnimationOptionCurveLinear
                                    animations:^{
                                                 CGAffineTransform  xform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-359));
                                                 backingView.transform = xform;
                                             }
                                    completion:^(BOOL finished)
                                       backingView.transform = CGAffineTransformIdentity;
                   ];
    }];

You could also create and apply the CABasicAnimation object outside of the view-based animation block to achieve the same results. All of the animations ultimately rely on Core Animation for their execution. Thus, if they are submitted at approximately the same time, they run together.

If precise timing between your view and layer based animations is required, it is recommended that you create all of the animations using Core Animation. You may find that some animations are easier to perform using Core Animation anyway. For example, the view-based rotation in Listing 4-9 requires a multistep sequence for rotations of more than 180 degrees, whereas the Core Animation portion uses a rotation value function that rotates from start to finish through a middle value.