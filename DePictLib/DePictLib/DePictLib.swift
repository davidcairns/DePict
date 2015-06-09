//
//  DePictLib.swift
//  DePictLib
//
//  Created by David Cairns on 4/10/15.
//  Copyright (c) 2015 David Cairns. All rights reserved.
//

import Foundation
import CoreGraphics

///: Drawing
private func CreateDrawingContext(size: CGSize) -> CGContext {
	let bitsPerComponent = 8
	let numComponents = 4
	let bytesPerRow = (bitsPerComponent / 8) * numComponents * Int(size.width)
	let colorspace = CGColorSpaceCreateDeviceRGB()
	let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
	return CGBitmapContextCreate(nil, Int(size.width), Int(size.height), bitsPerComponent, bytesPerRow, colorspace, bitmapInfo)
}

public func Draw(width: Int = 100, height: Int = 100, #colorer: Colorer) -> Image {
	let context = CreateDrawingContext(CGSize(width: width, height: height))
	colorer(context)
	return ImageFromCGImage(CGBitmapContextCreateImage(context))
}
