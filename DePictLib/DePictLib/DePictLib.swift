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
private func CreateDrawingContext(_ size: CGSize) -> CGContext {
	let bitsPerComponent = 8
	let numComponents = 4
	let bytesPerRow = (bitsPerComponent / 8) * numComponents * Int(size.width)
	let colorspace = CGColorSpaceCreateDeviceRGB()
	let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
	return CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorspace, bitmapInfo: bitmapInfo.rawValue)!
}

public func Draw(width: Int, height: Int, colorer: Colorer) -> Image {
	let context = CreateDrawingContext(CGSize(width: width, height: height))
	colorer.build(context)
	return ImageFromCGImage(context.makeImage()!)
}

public func Draw(_ colorer: Colorer) -> Image {
    return Draw(width: Int(colorer.width), height: Int(colorer.height), colorer: colorer)
}

public func Draw(_ shape: Shape) -> Image {
	return Draw(Outlined(color: Black, shape: shape))
}
