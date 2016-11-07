//
//  Mask.swift
//  DePictLib
//
//  Created by David Cairns on 6/8/15.
//  Copyright (c) 2015 David Cairns. All rights reserved.
//

import Foundation

public func Masked(colorer: Colorer, mask: Shape) -> Colorer {
	return Colorer(width: colorer.width, height: colorer.height) { context in
		applyPushed(context) {
			context.addPath(mask.build())
			context.clip()
			colorer.build(context)
		}
	}
}
