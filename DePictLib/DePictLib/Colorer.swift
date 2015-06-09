//
//  Colorer.swift
//  DePictLib
//
//  Created by David Cairns on 4/16/15.
//  Copyright (c) 2015 David Cairns. All rights reserved.
//

import Foundation
import CoreGraphics

public typealias Colorer = (CGContext) -> ()
public func EmptyColorer() -> Colorer {
	return { _ in }
}
public func +(lhs: Colorer, rhs: Colorer) -> Colorer {
	return { context in
		lhs(context)
		rhs(context)
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

