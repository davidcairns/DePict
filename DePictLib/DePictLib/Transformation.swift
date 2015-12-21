//
//  Transformation.swift
//  DePictLib
//
//  Created by David Cairns on 4/16/15.
//  Copyright (c) 2015 David Cairns. All rights reserved.
//

import Foundation
import CoreGraphics

///: Transformation
private func Transformed(transform: CGAffineTransform, shape: Shape, width: Double, height: Double) -> Shape {
	return Shape(width: width, height: height) {
		let path = CGPathCreateMutable()
		var t = transform
		CGPathAddPath(path, &t, shape.build())
		return path
	}
}
private func Transformed(transform: CGAffineTransform, colorer: Colorer, width: Double, height: Double) -> Colorer {
	return Colorer(width: width, height: height) { context in
		applyPushed(context: context) {
			CGContextConcatCTM(context, transform)
			colorer.build(context)
		}
	}
}
private func Transformed(transform: CGAffineTransform, shape: Shape) -> Shape {
	return Transformed(transform, shape: shape, width: shape.width, height: shape.height)
}
private func Transformed(transform: CGAffineTransform, colorer: Colorer) -> Colorer {
	return Transformed(transform, colorer: colorer, width: colorer.width, height: colorer.height)
}

public func Translated(x x: Int, y: Int, shape: Shape) -> Shape {
	return Transformed(CGAffineTransformMakeTranslation(CGFloat(x), CGFloat(y)), shape: shape)
}
public func Translated(x x: Int, y: Int, colorer: Colorer) -> Colorer {
	return Transformed(CGAffineTransformMakeTranslation(CGFloat(x), CGFloat(y)), colorer: colorer)
}
public func Rotated(degrees degrees: Int, shape: Shape) -> Shape {
	return Transformed(CGAffineTransformMakeRotation(CGFloat(degrees) / CGFloat(M_PI)), shape: shape)
}
public func Rotated(degrees degrees: Int, colorer: Colorer) -> Colorer {
	return Transformed(CGAffineTransformMakeRotation(CGFloat(degrees) / CGFloat(M_PI)), colorer: colorer)
}

public func Scaled(x x: Double, y: Double, shape: Shape) -> Shape {
	return Transformed(CGAffineTransformMakeScale(CGFloat(x), CGFloat(y)), shape: shape, width: shape.width * x, height: shape.height * x)
}
public func Scaled(factor: Double, shape: Shape) -> Shape {
	return Scaled(x: factor, y: factor, shape: shape)
}

public func Scaled(x x: Double, y: Double, colorer: Colorer) -> Colorer {
	return Transformed(CGAffineTransformMakeScale(CGFloat(x), CGFloat(y)), colorer: colorer, width: colorer.width * x, height: colorer.height * x)
}
public func Scaled(factor: Double, colorer: Colorer) -> Colorer {
	return Scaled(x: factor, y: factor, colorer: colorer)
}
