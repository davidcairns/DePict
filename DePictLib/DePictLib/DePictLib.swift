//
//  DePictLib.swift
//  DePictLib
//
//  Created by David Cairns on 4/10/15.
//  Copyright (c) 2015 David Cairns. All rights reserved.
//

//
// This file (and all other Swift source files in the Sources directory of this playground) will be precompiled into a framework which is automatically made available to DePicture.playground.
//

import Foundation
import CoreGraphics
import UIKit

///: Drawing
private func CreateDrawingContext(size: CGSize) -> CGContextRef {
	let bitsPerComponent = 8
	let numComponents = 4
	let bytesPerRow = (bitsPerComponent / 8) * numComponents * Int(size.width)
	let colorspace = CGColorSpaceCreateDeviceRGB()
	let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
	return CGBitmapContextCreate(nil, Int(size.width), Int(size.height), bitsPerComponent, bytesPerRow, colorspace, bitmapInfo)
}
public typealias Image = UIImage
public func Draw(width: Int = 100, height: Int = 100, #colorer: Colorer) -> Image {
	let context = CreateDrawingContext(CGSize(width: width, height: height))
	colorer(context)
	return UIImage(CGImage: CGBitmapContextCreateImage(context))!
}
