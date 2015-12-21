//
//  Colorer.swift
//  DePictLib
//
//  Created by David Cairns on 4/16/15.
//  Copyright (c) 2015 David Cairns. All rights reserved.
//

import Foundation
import CoreGraphics

public typealias ColorerFunc = CGContextRef -> ()

public struct Colorer {
	public let width, height: Double
	public let build: ColorerFunc
}

public func EmptyColorer() -> Colorer {
	return Colorer(width: 0.0, height: 0.0) { _ in }
}

private func compose_colorer_builds(lhs: ColorerFunc, rhs: ColorerFunc) -> ColorerFunc {
	return  { context in
		lhs(context)
		rhs(context)
	}
}

// Draw on top of each other
public func +(lhs: Colorer, rhs: Colorer) -> Colorer {
	return Colorer(width: max(lhs.width, rhs.width), height: max(lhs.height, rhs.height), build: compose_colorer_builds(lhs.build, rhs: rhs.build))
}

// Draw Left next to Right
public func nextTo(lhs: Colorer, _ rhs: Colorer, distance: Int = 0) -> Colorer {
	return Colorer(width: lhs.width + rhs.width + Double(distance),
		height: max(lhs.height, rhs.height),
		build: compose_colorer_builds(lhs.build, rhs: Translated(x: Int(lhs.width) + distance, y: 0, colorer: rhs).build))
}
public func |||(lhs: Colorer, rhs: Colorer) -> Colorer {
	return nextTo(lhs, rhs)
}

// Draw Left on top of Right
public func onTopOf(lhs: Colorer, _ rhs: Colorer, distance: Int = 0) -> Colorer {
	return Colorer(width: max(lhs.width, rhs.width),
				   height: lhs.height + rhs.height + Double(distance),
				   build: compose_colorer_builds(rhs.build, rhs: Translated(x: 0, y: Int(rhs.height) + distance, colorer: lhs).build))
}
public func ---(lhs: Colorer, rhs: Colorer) -> Colorer {
	return onTopOf(lhs, rhs)
}

public typealias ColorerCombiner = ((Colorer, Colorer) -> Colorer)
public func spaced(distance: Int = 10) -> ColorerCombiner {
	return { lhs, rhs in
		return nextTo(lhs, rhs, distance: distance)
	}
}
public func stacked(distance: Int = 10) -> ColorerCombiner {
	return { lhs, rhs in
		return onTopOf(lhs, rhs, distance: distance)
	}
}



public func Outlined(color color: Color, shape: Shape) -> Colorer {
	return Colorer(width: shape.width, height: shape.height) { context in
		applyPushed(context: context) {
			CGContextSetStrokeColorWithColor(context, colorToCGColor(color))
			CGContextAddPath(context, shape.build())
			CGContextStrokePath(context)
		}
	}
}
public func Filled(color color: Color, shape: Shape) -> Colorer {
	return Colorer(width: shape.width, height: shape.height) { context in
		applyPushed(context: context) {
			CGContextSetFillColorWithColor(context, colorToCGColor(color))
			CGContextAddPath(context, shape.build())
			CGContextFillPath(context)
		}
	}
}

