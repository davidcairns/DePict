//
// This file (and all other Swift source files in the Sources directory of this playground) will be precompiled into a framework which is automatically made available to DePicture.playground.
//

import Foundation
import CoreGraphics
import UIKit

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


///: Generalized Recursion
public func Recursing<T>(colorer: T -> Colorer, #startingValue: T, #nextValue: T -> T, until terminus: T -> Bool) -> Colorer {
	if terminus(startingValue) {
		return EmptyColorer()
	}
	return colorer(startingValue) + Recursing(colorer, startingValue: nextValue(startingValue), nextValue: nextValue, until: terminus)
}


