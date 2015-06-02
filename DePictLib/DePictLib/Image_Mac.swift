//
//  Image_Mac.swift
//  DePictLib
//
//  Created by David Cairns on 6/2/15.
//  Copyright (c) 2015 David Cairns. All rights reserved.
//

import Foundation
import Cocoa

public typealias Image = NSImage

public func ImageFromCGImage(image: CGImage) -> Image {
	return NSImage(CGImage: image, size: NSZeroSize)
}
