Quartz 2D Programming Guide
Apple Official Documentation

# Introduction #

Quartz 2D 是一个高级、轻量的二维绘图引擎。它不依赖于分辨率或设备。Quartz 2D 会尽量地使用图形硬件的性能。

Quartz 2D API 易于使用，提供了对透明图层、基于路径的绘图、offscreen rendering、高级色彩管理、抗锯齿、PDF 文档处理等强大功能。

Quartz 2D API 是 Core Graphics framework 的一部分，故有时候 Quartz 也被称为 Core Graphics, 或者 CG.

本文档适于 iOS 和 OS X 开发者。

# Overview of Quartz 2D #

在 OS X 中，Quartz 2D 可与所有其他图形图像技术协同工作—— Core Image, Core Video, OpenGL, QuickTime. 既可在 Quartz 中从 QuickTime 创建图像，也可把 Quartz 中的图像传递给 Core Image.

类似的，在 iOS 中 Quartz 2D 也可与所有其他可用的图形与动画技术一起工作，如 Core Animation, OpenGL ES, 及 UIKit. 

## The Page ##

Quartz 2D uses the **painter's model** for its imaging. In the painter's model, each successive drawing operation applies a layer of "paint" to an output "canvas", often called a **page**. The paint on the page can be modified by overlaying more paint through additional drawing operations. An object drawn on the page cannot be modified except by overlaying more paint. This model allows you to construct extremely sophisticated images from a small number of powerful primitives.

The page 既可以是一张真实的纸（若输出设备是打印机），也可以是一张虚拟的纸（若输出设备是 PDF 文件），也可以是一个位图。Page 的具体特征取决于你所使用的 graphics context.

在 painter's model 中，绘图的顺序是很重要的。

## Drawing Destinations: The Graphics Context ##

A graphics context is an opaque data type (CGContextRef), 它封装了 Quartz 用以把图像绘制到输出设备所使用的信息。Graphics context 中的信息包括图形绘制参数，and a device-specific representation of the paint on the page. Quartz 中的所有对象都被绘制到（或者说包含于）graphics context 中。

可把 graphics context 想像成 drawing destination, 使用 Quartz 绘图时，所有特定于设备的特性都包含在你所使用的那种 graphics context 中。也就是说，你可以使用同样的绘图例程把同一个图像绘制到不同的设备中，只需要提供不同的 graphics context 即可。Quartz 自会为你处理不同设备的差异。

程序可用的 graphics context 有：

- Bitmap graphics context. 允许把 RGB 色彩、 CMYK 色彩，或灰阶绘制到位图。位图是一个由像素构成的矩形数组（或曰 raster），每个像素表示图像中的一个点。位图图像也被称为取样图像 (sampled images).
- PDF graphics context. 允许创建 PDF 文件。In a PDF file, your drawing is preserved as a sequence of commands. PDF 文件与位置的一些重要区别：
    - PDF 文件可能包含多页；
    - 从 PDF 文件向其他设备绘图时，最终的图像会针对目标设备的显示特性作出优化；
    - PDF 文件与分辨率无关，它们可以以无限大或无限小的尺寸被绘制而不牺牲图像细节。
- Window graphics context. 可用以在窗口中绘图。注意 Quartz 2D 是一个图形引擎而不是一个窗口管理系统，所以你需要使用一个 application framework 来获得一个 window graphics context.
- A layer context (CGLayerRef) is an offscreen drawing destination associated with another graphics context. It is designed for optimal performance when drawing the layer to the graphics context that created it. A layer context can be a much better choice for offscreen drawing than a bitmap graphics context
- 在 OS X 中打印时，你要把内容发送给一个 PostScript graphics context, 后者由 printing framework 管理。

## Quartz 2D Opaque Data Types ##

除了 graphics context, Quartz 2D 还定义了许多 opaque 数据类型。由于 Quartz 2D API 是 Core Graphics framework 的一部分，故这些数据类型和操作这些数据类型的例程使用 CG 前缀。



Quartz 2D creates objects from opaque data types that your application operates on to achieve a particular drawing output. Figure 1-3 shows the sorts of results you can achieve when you apply drawing operations to three of the objects provided by Quartz 2D. For example:

You can rotate and display a PDF page by creating a PDF page object, applying a rotation operation to the graphics context, and asking Quartz 2D to draw the page to a graphics context.
You can draw a pattern by creating a pattern object, defining the shape that makes up the pattern, and setting up Quartz 2D to use the pattern as paint when it draws to a graphics context.
You can fill an area with an axial or radial shading by creating a shading object, providing a function that determines the color at each point in the shading, and then asking Quartz 2D to use the shading as a fill color.

## Graphics States ##

## Quartz 2D Coordinate Systems ##

## Memory Management: Object Ownership ##


# Graphics Contexts #

# Paths #

# Color and Color Spaces #

# Transforms #

# Patterns #

# Shadows #

# Gradients #

# Transparency Layers #

# Data Management in Quartz 2D #

# Bitmap Images and Image Masks #

# Core Graphics Layer Drawing #

# PDF Document Creation, Viewing, and Transforming #

# PDF Document Parsing #

# PostScript Conversion #

# Text #
