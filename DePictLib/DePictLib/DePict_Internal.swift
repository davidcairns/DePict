//
//  DePict_Internal.swift
//  DePictLib
//
//  Created by David Cairns on 4/16/15.
//  Copyright (c) 2015 David Cairns. All rights reserved.
//

import Foundation
import CoreGraphics

///: Private
internal func colorToCGColor(color: Color) -> CGColor {
	let space = CGColorSpaceCreateDeviceRGB()
	let components: [CGFloat] = [
		CGFloat(color.red),
		CGFloat(color.green),
		CGFloat(color.blue),
		CGFloat(1.0)
	]
	return components.withUnsafeBufferPointer {
		return CGColorCreate(space, $0.baseAddress)!
	}
}
internal func applyPushed(context context: CGContext, block: () -> ()) {
	CGContextSaveGState(context)
	block()
	CGContextRestoreGState(context)
}
