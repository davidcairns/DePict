//
//  Shape.swift
//  DePictLib
//
//  Created by David Cairns on 4/16/15.
//  Copyright (c) 2015 David Cairns. All rights reserved.
//

import Foundation
import CoreGraphics

public typealias ShapeFunc = () -> CGPath
public struct Shape {
	public let width, height: Double
	public let build: ShapeFunc
	
	init(width: Double, height: Double, build: @escaping ShapeFunc) {
		self.width = width
		self.height = height
		self.build = build
	}
	init(width: Int, height: Int, build: @escaping ShapeFunc) {
		self.width = Double(width)
		self.height = Double(height)
		self.build = build
	}
}

public func EmptyShape() -> Shape {
	return Shape(width: 0, height: 0) { CGMutablePath() }
}

private func compose_shape_builds(_ lhs: @escaping ShapeFunc, rhs: @escaping ShapeFunc) -> ShapeFunc {
	return {
		let path = CGMutablePath()
        path.addPath(lhs())
        path.addPath(rhs())
		return path
	}
}

public func +(lhs: Shape, rhs: Shape) -> Shape {
	return Shape(width: max(lhs.width, rhs.width), height: max(lhs.height, rhs.height), build: compose_shape_builds(lhs.build, rhs: rhs.build))
}

public func nextTo(_ lhs: Shape, _ rhs: Shape, distance: Int = 0) -> Shape {
	return Shape(width: lhs.width + rhs.width + Double(distance),
	             height: max(lhs.height, rhs.height),
	             build: compose_shape_builds(lhs.build, rhs: Translated(x: Int(lhs.width) + distance, y: 0, shape: rhs).build))
}

public func onTopOf(_ lhs: Shape, _ rhs: Shape, distance: Int = 0) -> Shape {
    return Shape(width: max(lhs.width, rhs.width),
                 height: lhs.height + rhs.height + Double(distance),
                 build: compose_shape_builds(rhs.build, rhs: Translated(x: 0, y: Int(rhs.height) + distance, shape: lhs).build))
}

precedencegroup HorizontalStacked {
    associativity: left
    higherThan: BitwiseShiftPrecedence
}

precedencegroup VerticalStacked {
    associativity: left
    higherThan: HorizontalStacked
}

infix operator ||| : HorizontalStacked
infix operator --- : VerticalStacked


public func |||(lhs: Shape, rhs: Shape) -> Shape {
	return nextTo(lhs, rhs)
}

public func ---(lhs: Shape, rhs: Shape) -> Shape {
	return onTopOf(lhs, rhs)
}

public typealias ShapeCombiner = ((Shape, Shape) -> Shape)
public func spaced(_ distance: Int = 10) -> ShapeCombiner {
	return { lhs, rhs in
		return nextTo(lhs, rhs, distance: distance)
	}
}
public func stacked(_ distance: Int = 10) -> ShapeCombiner {
	return { lhs, rhs in
		return onTopOf(lhs, rhs, distance: distance)
	}
}


///: Shapes
public typealias Point = (x: Int, y: Int)
public func Line(fromX: Int, y fromY: Int, toX: Int, y toY: Int) -> Shape {
	return Shape(width: abs(Double(toX) - Double(fromX)), height: abs(Double(toY) - Double(fromY))) {
		let path = CGMutablePath()
        path.move(to: CGPoint(x: fromX, y: fromY))
        path.addLine(to: CGPoint(x: toX, y: toY))
		path.closeSubpath()
		return path
	}
}
public func Line(from: Point, to: Point) -> Shape {
	return Line(fromX: from.x, y: from.y, toX: to.x, y: to.y)
}
public func Line(_ points: [Point]) -> Shape {
	var minx = Double.infinity, miny = Double.infinity, maxx = -Double.infinity, maxy = -Double.infinity
	for point in points {
		minx = min(minx, Double(point.x))
		maxx = max(maxx, Double(point.x))
		miny = min(miny, Double(point.y))
		maxy = max(maxy, Double(point.y))
	}
	
	return Shape(width: abs(maxx - minx), height: abs(maxy - miny)) {
		let path = CGMutablePath()
        path.addLines(between: points.map({ CGPoint(x: $0, y: $1) }))
		return path
	}
}
public func Rectangle(x: Int, y: Int, width: Int, height: Int) -> Shape {
	return Shape(width: width, height: height) {
		CGPath(rect: CGRect(x: x, y: y, width: width, height: height), transform: nil)
	}
}
public func Rectangle(width: Int, height: Int) -> Shape {
	return Shape(width: width, height: height) {
		CGPath(rect: CGRect(x: 0, y: 0, width: width, height: height), transform: nil)
	}
}

public func Circle(centerX: Int, Y centerY: Int, radius: Int) -> Shape {
	return Shape(width: abs(centerX) + radius, height: abs(centerY) + radius) {
		CGPath(
			ellipseIn: CGRect(
				x: centerX - radius,
				y: centerY - radius,
				width: radius * 2,
				height: radius * 2),
			transform: nil)
	}
}
public func Circle(radius: Int) -> Shape {
	return Shape(width: 2 * radius, height: 2 * radius) {
		CGPath(
			ellipseIn: CGRect(
				x: 0,
				y: 0,
				width: radius * 2,
				height: radius * 2),
			transform: nil)
	}
}

public func Radial(centerX: Int, centerY: Int, radius: Int, fromAngle: Double, toAngle: Double, clockwise: Bool = true) -> Shape {
	return Shape(width: 2 * radius, height: 2 * radius) {
		let path = CGMutablePath()
        path.move(to: CGPoint(x: centerX, y: centerY))
        path.addArc(center: CGPoint(x: centerX, y: centerY), radius: CGFloat(radius), startAngle: CGFloat(fromAngle), endAngle: CGFloat(toAngle), clockwise: clockwise)
		path.closeSubpath()
		return path
	}
}
public func TweenedRadial(centerX: Int, centerY: Int, radius: Int, fromAngle: Double, clockwise: Bool = true) -> ((Double) -> Shape) {
	return { progress in
        return Radial(centerX: centerX, centerY: centerY, radius: radius, fromAngle: fromAngle, toAngle: fromAngle - progress * 2.0 * M_PI, clockwise: clockwise)
	}
}
