<title>Apple Development Environment</title>

# Core Foundation #

Core Foundation 用 C 编写，名字前缀是 CF; Foundation 用 Objective-C 编写，名字前缀是 NS.

Core Foundation 是 Foundation 和 Carbon 的共同基础。

Some types in Core Foundation are "toll-free bridged", or interchangeable with a simple cast, with those of their Foundation Kit counterparts. For example, one could create a `CFDictionaryRef` Core Foundation type, and then later simply use a standard C cast to convert it to its Objective-C counterpart, `NSDictionary *`, and then use the desired Objective-C methods on that object as one normally would.

## History ##

参考这里讲的历史 http://ridiculousfish.com/blog/posts/bridge.html 及 [Wikipedia](http://en.wikipedia.org/wiki/Cocoa_(API))

Mac OS 9 和 NeXTSTEP (OO) 合并成 Mac OS X. 创建了 Core Foundation, 作为传统 Mac 工具箱和 OPENSTEP（OPENSTEP 是 NeXTSTEP 的工具箱） 的共同基础，于是 Core Foundation 就成了联系这两大 API 的桥梁。在使用 Core Foundation 整合的过程中：

- 传统的 Mac 工具箱作了较大的改动，成了 Carbon;
- OPENSTEP 只作了较小的改动（NS 名字前缀来自 OPENSTEP, 而 Foundation 中的名字前缀仍为 NS, 从这一点就可以看出），成了 Cocoa （Cocoa 包含了 Foundation）。

由于 Foundation 更 high-level、更 modern, 故编程时首选 Foundation, 而 Core Foundation 只用以处理历史遗留问题。

Apple 把 Core Foundation 的大部分开源，曰 CFLite. 还有一个第三方的开源实现，曰 OpenCFLite.

# Cocoa for OS X#

Cocoa consists of the Foundation Kit, Application Kit, and Core Data frameworks, as included by `Cocoa.h` header file, as well as the libraries and frameworks included by those, such as the C standard library and the Objective-C runtime.

[Mac OS X System Frameworks](https://developer.apple.com/library/mac/documentation/MacOSX/Conceptual/OSX_Technology_Overview/SystemFrameworks/SystemFrameworks.html) 

Cocoa consists of 3 Objective-C object libraries called frameworks. The Cocoa frameworks are implemented as a type of **application bundle**, containing the aforementioned items in standard locations.

- Foundation Kit, 常被简称为 Foundation, 首见于 NeXTSTEP 3 中的 Enterprise Objects Framework. It was developed as part of the OpenStep work, and subsequently became the basis for OpenStep's AppKit when that system was released in 1994. On OS X, Foundation is based on Core Foundation. Foundation is a generic object-oriented library providing string and value manipulation, containers and iteration, distributed computing, run loops, and other functions that are not directly tied to the graphical UI. The "NS" prefix, used for all classes and constants in the framework, comes from Cocoa's OPENSTEP heritage, which was jointly developed by NeXT and Sun.
- Application Kit or AppKit is directly descended from the original NeXTSTEP Application Kit. It contains code programs can use to create and interact with graphical user interfaces. AppKit is built on top of Foundation, and uses the same "NS" prefix.
- Core Data is the object persistence framework included with Foundation and Cocoa and found in `Cocoa.h`.

A key part of the Cocoa architecture is its comprehensive views model. This is organized along conventional lines for an application framework, but is based on the PDF drawing model provided by Quartz. This allows creation of custom drawing content using PostScript-like drawing commands, which also allows automatic printer support and so forth. Since the Cocoa framework manages all the clipping, scrolling, scaling and other chores of drawing graphics, the programmer is freed from implementing basic infrastructure and can concentrate only on the unique aspects of an application's content.




# Cocoa Touch for iOS #

[iOS System Frameworks](https://developer.apple.com/library/ios/documentation/Miscellaneous/Conceptual/iPhoneOSTechOverview/iPhoneOSFrameworks/iPhoneOSFrameworks.html)

