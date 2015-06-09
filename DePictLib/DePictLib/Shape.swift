//
//  Shape.swift
//  DePictLib
//
//  Created by David Cairns on 4/16/15.
//  Copyright (c) 2015 David Cairns. All rights reserved.
//

import Foundation
import CoreGraphics

public typealias Shape = () -> CGPath
public func EmptyShape() -> Shape {
	return { CGPathCreateMutable() }
}
public func +(lhs: Shape, rhs: Shape) -> Shape {
	return {
		let path = CGPathCreateMutable()
		CGPathAddPath(path, nil, lhs())
		CGPathAddPath(path, nil, rhs())
		return path
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

public func Radial(#centerX: Int, #centerY: Int, #radius: Int, #fromAngle: Double, #toAngle: Double, clockwise: Bool = true) -> Shape {
	return {
		let path = CGPathCreateMutable()
		CGPathMoveToPoint(path, nil, CGFloat(centerX), CGFloat(centerY))
		CGPathAddArc(path, nil, CGFloat(centerX), CGFloat(centerY), CGFloat(radius), CGFloat(fromAngle), CGFloat(toAngle), clockwise)
		CGPathCloseSubpath(path)
		return path
	}
}
public func TweenedRadial(#centerX: Int, #centerY: Int, #radius: Int, #fromAngle: Double, clockwise: Bool = true) -> (Double -> Shape) {
	return { progress in
		return Radial(centerX: centerX, centerY: centerY, radius: radius, fromAngle: fromAngle, toAngle: fromAngle - progress * 2.0 * M_PI, clockwise: clockwise)
	}
}
