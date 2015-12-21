//
//  Animation.swift
//  DePictLib
//
//  Created by David Cairns on 6/8/15.
//  Copyright (c) 2015 David Cairns. All rights reserved.
//

import Foundation

public func Animated <T> (numFrames numFrames: Int = 24, thing: Double -> T) -> [T] {
	return Array(0 ... numFrames).map { (idx: Int) -> T in
		let progress = Double(idx) / Double(numFrames)
		return thing(progress)
	}
}
