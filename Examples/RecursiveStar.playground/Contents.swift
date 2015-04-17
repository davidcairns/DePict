/*:
## Let's make a star!

We can use simple declarative recursion to create beautiful algorithmically-generated geometry.
*/

import DePictLib

let step = 0.05
let spiral = Recursing({ (r: Double) -> Shape in 
	Line(fromX: 200 + Int(2 * r * cos(r - step)),	y: 200 + Int(2 * r * sin(r - step)), 
		   toX: 200 + Int(3 * r * cos(r + step)),	y: 200 + Int(3 * r * sin(r + step)))
	}, 
	startingValue: 0.0, 
	nextValue: { (r: Double) -> Double in r + 4 * step }, 
	until: { (r: Double) -> Bool in r >= 20 * M_PI } )

Draw(width: 400, height: 400, colorer: Outlined(color: Black, shape: spiral))
