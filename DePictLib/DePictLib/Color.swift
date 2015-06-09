//
//  Color.swift
//  DePictLib
//
//  Created by David Cairns on 4/16/15.
//  Copyright (c) 2015 David Cairns. All rights reserved.
//

import Foundation

///: Coloring
public struct Color { let red: Float, green: Float, blue: Float }
public let Red = Color(red: 1.0, green: 0.0, blue: 0.0)
public let Green = Color(red: 0.0, green: 1.0, blue: 0.0)
public let Blue = Color(red: 0.0, green: 0.0, blue: 1.0)
public let White = Color(red: 1.0, green: 1.0, blue: 1.0)
public let Gray = Color(red: 0.5, green: 0.5, blue: 0.5)
public let Black = Color(red: 0.0, green: 0.0, blue: 0.0)
public let Brown = Color(red: 0.6, green: 0.3, blue: 0.0)
public let Magenta = Color(red: 1.0, green: 0.0, blue: 1.0)
public let Yellow = Color(red: 1.0, green: 1.0, blue: 0.0)
public func Light(color: Color) -> Color {
	let d = (1.0 - color.red, 1.0 - color.green, 1.0 - color.blue)
	return Color(red: color.red + 0.5 * d.0, green: color.green + 0.5 * d.1, blue: color.blue + 0.5 * d.2)
}
public func Dark(color: Color) -> Color {
	return Color(red: 0.5 * color.red, green: 0.5 * color.green, blue: 0.5 * color.blue)
}
