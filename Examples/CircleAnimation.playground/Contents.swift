/*:
## Let’s draw a circle-filling animation!

We can use the `Animated` function to generate a range of images. This makes
it easy to create pre-baked animations. You can also express animated interface
elements simply and easily using the same style.
*/

import DePictLib

let animation: [Image] = Animated(numFrames: 24) { (progress: Double) -> Image in
	let radial: Double -> Shape = TweenedRadial(centerX: 50, centerY: 50, radius: 50, fromAngle: M_PI_2)
	return Draw(
		Filled(color: Light(Brown), shape: Circle(centerX: 50, Y: 50, radius: 44))
		+
		Masked(
			colorer: Filled(color: Blue, shape: Circle(centerX: 50, Y: 50, radius: 40)),
			mask: radial(progress)
		)
	)
}

animation
