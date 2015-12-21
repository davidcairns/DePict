/*:
# DePict
### by @[davidcairns](https://twitter.com/davidcairns)
## _- noun: a place where people can play with drawing._
##

---

This playground allows you to draw pictures using simple, declarative code.

To produce a drawing, call the `Draw` function (just type **Draw** and let autocomplete
do the rest!).

You will see that `Draw` requires a `Colorer`. Type either:
- `Filled`, for filled-in shapes, or
- `Outlined`, for outlined or _stroked_ shapes.

After you pick one and provide it a color (see the built-in colors below), you will
see that a `Colorer` requires a `Shape`. Type either:
- `Line`,
- `Rectangle`,
- or `Circle`

You can also combine shapes and nest them, such as: 

let crossShape = Line(fromX: 1, y: 1,
						toX: 9, y: 9)
				+ Line(fromX: 1, y: 9,
						 toX: 9, y: 1)
let blueSquare = Filled(Blue, Rectangle(x: 2, y: 2, width: 6, height: 6))
let myShape = blueSquare + Outlined(Red, crossShape)

You can turn the above _description_ of a shape into a shape by _Draw-ing_ it:

Draw(width: 10, height: 10, colorer: myShape)
*/

import DePictLib

/*:
## Let’s draw a face!

Below, there’s some simple code for drawing a face. On the right side of the
playground window, you should see something that says `w 100 h 100`. Mouse-over it and
then click the empty circle that appears. You should see a drawing of a face appear!
*/

Draw(Scaled(2.0, colorer:
	// Hair (behind head)
	Filled(color: Black, shape: Circle(centerX: 50, Y: 58, radius: 40))
		
	// Face
	+ Filled(color: Brown, shape: Circle(centerX: 50, Y: 50, radius: 40))
	
	// Eyes and pupils
	+ Filled(color: White, shape: Rectangle(x: 20, y: 50, width: 20, height: 8))
	+ Filled(color: Blue, shape: Circle(centerX: 30, Y: 54, radius: 2))
	+ Filled(color: White, shape: Rectangle(x: 60, y: 50, width: 20, height: 8))
	+ Filled(color: Blue, shape: Circle(centerX: 70, Y: 54, radius: 2))
	
	// Nose
	+ Outlined(color: Light(Brown), shape:
		Line(fromX: 50, y: 54, toX: 56, y: 44)
		+ Line(fromX: 56, y: 44, toX: 52, y: 42)
	)
	
	// Mouth
	+ Outlined(color: Light(Red), shape:
		Line([(40, 30), (46, 25), (54, 25)])
	)
))

//: See if you can give the face some 😎 or 👂s or eyebrows 😯!


