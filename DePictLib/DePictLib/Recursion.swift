//
//  Recursion.swift
//  DePictLib
//
//  Created by David Cairns on 4/16/15.
//  Copyright (c) 2015 David Cairns. All rights reserved.
//

import Foundation

///: Generalized Recursion
public func Recursing<T>(colorer: T -> Colorer, startingValue: T, nextValue: T -> T, until terminus: T -> Bool) -> Colorer {
	if terminus(startingValue) {
		return EmptyColorer()
	}
	return colorer(startingValue) + Recursing(colorer, startingValue: nextValue(startingValue), nextValue: nextValue, until: terminus)
}
public func Recursing<T>(shape: T -> Shape, startingValue: T, nextValue: T -> T, until terminus: T -> Bool) -> Shape {
	if terminus(startingValue) {
		return EmptyShape()
	}
	return shape(startingValue) + Recursing(shape, startingValue: nextValue(startingValue), nextValue: nextValue, until: terminus)
}
