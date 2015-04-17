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

