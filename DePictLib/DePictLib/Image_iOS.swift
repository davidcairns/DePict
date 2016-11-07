//
//  Image_iOS.swift
//  DePictLib
//
//  Created by David Cairns on 6/2/15.
//  Copyright (c) 2015 David Cairns. All rights reserved.
//

import Foundation
import UIKit

public typealias Image = UIImage

public func ImageFromCGImage(_ image: CGImage) -> Image {
	return UIImage(cgImage: image)
}
