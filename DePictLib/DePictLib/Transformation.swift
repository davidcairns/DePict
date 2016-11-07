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
private func Transformed(_ transform: CGAffineTransform, shape: Shape, width: Double, height: Double) -> Shape {
	return Shape(width: width, height: height) {
		let path = CGMutablePath()
        path.addPath(shape.build(), transform: transform)
		return path
	}
}
private func Transformed(_ transform: CGAffineTransform, colorer: Colorer, width: Double, height: Double) -> Colorer {
	return Colorer(width: width, height: height) { context in
		applyPushed(context) {
			context.concatenate(transform)
			colorer.build(context)
		}
	}
}
private func Transformed(_ transform: CGAffineTransform, shape: Shape) -> Shape {
	return Transformed(transform, shape: shape, width: shape.width, height: shape.height)
}
private func Transformed(_ transform: CGAffineTransform, colorer: Colorer) -> Colorer {
	return Transformed(transform, colorer: colorer, width: colorer.width, height: colorer.height)
}

public func Translated(x: Int, y: Int, shape: Shape) -> Shape {
	return Transformed(CGAffineTransform(translationX: CGFloat(x), y: CGFloat(y)), shape: shape)
}
public func Translated( x: Int, y: Int, colorer: Colorer) -> Colorer {
	return Transformed(CGAffineTransform(translationX: CGFloat(x), y: CGFloat(y)), colorer: colorer)
}
public func Rotated(_ degrees: Int, shape: Shape) -> Shape {
	return Transformed(CGAffineTransform(rotationAngle: CGFloat(degrees) / CGFloat(M_PI)), shape: shape)
}
public func Rotated(_ degrees: Int, colorer: Colorer) -> Colorer {
	return Transformed(CGAffineTransform(rotationAngle: CGFloat(degrees) / CGFloat(M_PI)), colorer: colorer)
}

public func Scaled(x: Double, y: Double, shape: Shape) -> Shape {
	return Transformed(CGAffineTransform(scaleX: CGFloat(x), y: CGFloat(y)), shape: shape, width: shape.width * x, height: shape.height * x)
}
public func Scaled(_ factor: Double, shape: Shape) -> Shape {
	return Scaled(x: factor, y: factor, shape: shape)
}

public func Scaled(x: Double, y: Double, colorer: Colorer) -> Colorer {
	return Transformed(CGAffineTransform(scaleX: CGFloat(x), y: CGFloat(y)), colorer: colorer, width: colorer.width * x, height: colorer.height * x)
}
public func Scaled(_ factor: Double, colorer: Colorer) -> Colorer {
	return Scaled(x: factor, y: factor, colorer: colorer)
}
