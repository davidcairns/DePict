/*: DePicture.playground - noun: a place where people can play with drawing.
	by David Cairns

	This playground allows you to draw pictures using simple, declarative code.

	To produce a drawing, call the `Draw` function (just type *Draw* and let autocorrect
	do the rest!).

	You will see that `Draw` requires a `Colorer`. Type either:
	• *Filled*, for filled-in shapes, or
	• *Outlined*, for outlined or “stroked” shapes.

	After you pick one and provide it a color (see the built-in colors below), you will
	see that a `Colorer` requires a `Shape`. Type either:
	• `Line`,
	• `Rectangle`, or
	• `Circle`

	You can also combine shapes and nest them, such as: 
	```
	let crossShape = Line(fromX: 1, y: 1, toX: 9, y: 9) + Line(fromX: 1, y: 9, toX: 9, y: 1)
	let blueSquare = Filled(Blue, Rectangle(x: 2, y: 2, width: 6, height: 6))
	let myShape = blueSquare + Outlined(Red, crossShape)
	```

	You can turn the above *description* of a shape into a shape by *Draw*ing it:
	`Draw(width: 10, height: 10, color: myShape)`


	At the bottom, there’s some simple code for drawing a face. On the right side of the
	playground window, you should see something that says `w 100 h 100`. Mouse-over it and
	then click the empty circle that appears. You should see a drawing of a face appear!
	
	See if you can give the face some glasses or ears or eyebrows!

*/


import UIKit
import CoreGraphics

public typealias Shape = () -> CGPathRef
public typealias Colorer = (CGContextRef) -> ()
public func EmptyShape() -> Shape {
	return { CGPathCreateMutable() }
}
public func EmptyColorer() -> Colorer {
	return { _ in }
}
public func +(lhs: Shape, rhs: Shape) -> Shape {
	return {
		let path = CGPathCreateMutable()
		CGPathAddPath(path, nil, lhs())
		CGPathAddPath(path, nil, rhs())
		return path
	}
}
public func +(lhs: Colorer, rhs: Colorer) -> Colorer {
	return { context in
		lhs(context)
		rhs(context)
	}
}

///: Shapes
public typealias Point = (x: Int, y: Int)
public func Line(#fromX: Int, y fromY: Int, #toX: Int, y toY: Int) -> Shape {
	return {
		let path = CGPathCreateMutable()
		CGPathMoveToPoint(path, nil, CGFloat(fromX), CGFloat(fromY))
		CGPathAddLineToPoint(path, nil, CGFloat(toX), CGFloat(toY))
		CGPathCloseSubpath(path)
		return path
	}
}
public func Line(#from: Point, #to: Point) -> Shape {
	return Line(fromX: from.x, y: from.y, toX: to.x, y: to.y)
}
public func Line(points: [Point]) -> Shape {
	return {
		let path = CGPathCreateMutable()
		points.map({ (x, y) -> CGPoint in
			CGPoint(x: x, y: y)
		}).withUnsafeBufferPointer { CGPathAddLines(path, nil, $0.baseAddress, points.count) }
		return path
	}
}
public func Rectangle(#x: Int, #y: Int, #width: Int, #height: Int) -> Shape {
	return {
		CGPathCreateWithRect(CGRect(x: x, y: y, width: width, height: height), nil)
	}
}
public func Circle(#centerX: Int, Y centerY: Int, #radius: Int) -> Shape {
	return {
		CGPathCreateWithEllipseInRect(
			CGRect(
				x: centerX - radius, 
				y: centerY - radius, 
				width: radius * 2, 
				height: radius * 2), 
			nil)
	}
}

///: Coloring
public struct Color { let red: Float, green: Float, blue: Float }
public let Red = Color(red: 1.0, green: 0.0, blue: 0.0)
public let Green = Color(red: 0.0, green: 1.0, blue: 0.0)
public let Blue = Color(red: 0.0, green: 0.0, blue: 1.0)
public let White = Color(red: 1.0, green: 1.0, blue: 1.0)
public let Black = Color(red: 0.0, green: 0.0, blue: 0.0)
public let Brown = Color(red: 0.6, green: 0.3, blue: 0.0)
public let Magenta = Color(red: 1.0, green: 0.0, blue: 1.0)
public let Yellow = Color(red: 1.0, green: 1.0, blue: 0.0)
public func Light(color: Color) -> Color {
	let d = (1.0 - color.red, 1.0 - color.green, 1.0 - color.blue)
	return Color(red: color.red + 0.5 * d.0, green: color.green + 0.5 * d.1, blue: color.blue + 0.5 * d.2)
}

private func applyPushed(#context: CGContextRef, block: () -> ()) {
	CGContextSaveGState(context)
	block()
	CGContextRestoreGState(context)
}
private func colorToCGColor(color: Color) -> CGColorRef {
	let space = CGColorSpaceCreateDeviceRGB()
	let components: [CGFloat] = [
		CGFloat(color.red), 
		CGFloat(color.green), 
		CGFloat(color.blue),
		CGFloat(1.0)
	]
	return components.withUnsafeBufferPointer {
		return CGColorCreate(space, $0.baseAddress)
	}
}
public func Outlined(#color: Color, #shape: Shape) -> Colorer {
	return { context in
		applyPushed(context: context) {
			CGContextSetStrokeColorWithColor(context, colorToCGColor(color))
			CGContextAddPath(context, shape())
			CGContextStrokePath(context)
		}
	}
}
public func Filled(#color: Color, #shape: Shape) -> Colorer {
	return { context in
		applyPushed(context: context) {
			CGContextSetFillColorWithColor(context, colorToCGColor(color))
			CGContextAddPath(context, shape())
			CGContextFillPath(context)
		}
	}
}

///: Transformation
private func Transformed(transform: CGAffineTransform, shape: Shape) -> Shape {
	return {
		let path = CGPathCreateMutable()
		var t = transform
		CGPathAddPath(path, &t, shape())
		return path
	}
}
private func Transformed(transform: CGAffineTransform, colorer: Colorer) -> Colorer {
	return { context in
		applyPushed(context: context) {
			CGContextConcatCTM(context, transform)
			colorer(context)
		}
	}
}
public func Translated(#x: Int, #y: Int, shape: Shape) -> Shape {
	return Transformed(CGAffineTransformMakeTranslation(CGFloat(x), CGFloat(y)), shape)
}
public func Translated(#x: Int, #y: Int, colorer: Colorer) -> Colorer {
	return Transformed(CGAffineTransformMakeTranslation(CGFloat(x), CGFloat(y)), colorer)
}
public func Rotated(#degrees: Int, shape: Shape) -> Shape {
	return Transformed(CGAffineTransformMakeRotation(CGFloat(degrees) / CGFloat(M_PI)), shape)
}
public func Rotated(#degrees: Int, colorer: Colorer) -> Colorer {
	return Transformed(CGAffineTransformMakeRotation(CGFloat(degrees) / CGFloat(M_PI)), colorer)
}

///: Drawing
private func CreateDrawingContext(size: CGSize) -> CGContextRef {
	let bitsPerComponent = 8
	let numComponents = 4
	let bytesPerRow = (bitsPerComponent / 8) * numComponents * Int(size.width)
	let colorspace = CGColorSpaceCreateDeviceRGB()
	let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
	return CGBitmapContextCreate(nil, Int(size.width), Int(size.height), bitsPerComponent, bytesPerRow, colorspace, bitmapInfo)
}
public typealias Image = UIImage
public func Draw(width: Int = 100, height: Int = 100, #colorer: Colorer) -> Image {
	let context = CreateDrawingContext(CGSize(width: width, height: height))
	colorer(context)
	return UIImage(CGImage: CGBitmapContextCreateImage(context))!
}



///: Let’s draw a face!

Draw(width: 100, height: 100, colorer:
	// Hair (behind head)
	Filled(color: Black, shape: Circle(centerX: 50, Y: 58, radius: 40))
	
	// Face
	+ Filled(color: Brown, shape: Circle(centerX: 50, Y: 50, radius: 40))
	
	// Eyes and pupils
	+ Filled(color: White, shape: Rectangle(x: 20, y: 50, width: 20, height: 8))
	+ Filled(color: Blue, shape: Circle(centerX: 30, Y: 54, radius: 2))
	+ Filled(color: White, shape: Rectangle(x: 60, y: 50, width: 20, height: 8))
	+ Filled(color: Blue, shape: Circle(centerX: 70, Y: 54, radius: 2))
	
	// Nose
	+ Outlined(color: Light(Brown), shape: 
		Line(fromX: 50, y: 54, toX: 56, y: 44)
		+ Line(fromX: 56, y: 44, toX: 52, y: 42)
	)
	
	// Mouth
	+ Outlined(color: Light(Red), shape: 
		Line([(40, 30), (46, 25), (54, 25)])
	)
)









