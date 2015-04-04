/*: DePicture.playground - noun: a place where people can play with drawing.
by David Cairns

This playground allows you to draw pictures using simple, declarative code.

To produce a drawing, call the `Draw` function (just type *Draw* and let autocomplete
do the rest!).

You will see that `Draw` requires a `Colorer`. Type either:
• *Filled*, for filled-in shapes, or
• *Outlined*, for outlined or “stroked” shapes.

After you pick one and provide it a color (see the built-in colors below), you will
see that a `Colorer` requires a `Shape`. Type either:
• `Line`,
• `Rectangle`, or
• `Circle`

You can also combine shapes and nest them, such as: 
```
let crossShape = Line(fromX: 1, y: 1, toX: 9, y: 9) + Line(fromX: 1, y: 9, toX: 9, y: 1)
let blueSquare = Filled(Blue, Rectangle(x: 2, y: 2, width: 6, height: 6))
let myShape = blueSquare + Outlined(Red, crossShape)
```

You can turn the above *description* of a shape into a shape by *Draw*ing it:
`Draw(width: 10, height: 10, color: myShape)`


At the bottom, there’s some simple code for drawing a face. On the right side of the
playground window, you should see something that says `w 100 h 100`. Mouse-over it and
then click the empty circle that appears. You should see a drawing of a face appear!

See if you can give the face some glasses or ears or eyebrows!

*/


import UIKit
import CoreGraphics
import XCPlayground



///: Let’s draw a face!

Draw(colorer:
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
)





/*: By describing a drawing in this way, we can clearly see how the different
	elements break down.

	However, a computer is a dynamic medium! We have a lot of duplicated values
	in the above. These can be *abstracted* to a `let` statement, giving a name
	to the value. Then we can use this name to refer to the value later, and
	combine it with other values.

	For an example, let’s draw a sailboat!
*/

// The horizon is denoted by a horizontal through our scene, separating the sea and
// the sky. By specify where the horizon is, we can refer to it later. The canvas is
// 100x100, so let’s put the horizon just below center, at 35.
let horizon = 35

// We want the hull of the sailboat to bridge the horizon, so let’s make the bottom
// of the hull just below the horizon and the top of the hull just above it.
let topOfHull = horizon + 5
let bottomOfHull = horizon - 5

// Next is the sailboat’s mast. First, let’s put it at the center of the boat. But
// how high should it be? Let’s make it really tall!
let mastPlace = 50
let heightOfMast = 50
let topOfMast = topOfHull + heightOfMast

// Lastly, the sail. How wide is it? Also, how far should we draw it from the mast?
// And how high above the hull should the sail be?
let widthOfSail = 26
let sailEdge = mastPlace - 2
let hullToSail = 6
let bottomOfSail = topOfHull + hullToSail

Draw(colorer: 
	// Sky
	Filled(color: Light(Light(Blue)), shape: Rectangle(x: 0, y: 0, width: 100, height: 100))
	
	// Sea
	+ Filled(color: Blue, shape: Rectangle(x: 0, y: 0, width: 100, height: horizon))
	
	// Hull
	+ Filled(color: Light(Brown), shape: Line([(10, topOfHull), (20, bottomOfHull), (80, bottomOfHull), (90, topOfHull)]))
	
	// Mast -- goes from the top of the hull way up!
	+ Outlined(color: Black, shape: Line(fromX: mastPlace, y: topOfHull, toX: mastPlace, y: topOfMast))
	
	// Sail
	+ Filled(color: White, shape: Line([(sailEdge, topOfMast - 3), (sailEdge - widthOfSail, bottomOfSail), (sailEdge, bottomOfSail)]))
)



/*: Now check it out! You can change the level of the horizon (by, for example, changing
	the line above to `let horizon = 50`), and the value of the horizon will change
	everything that was defined relative to it, and all the values defined relative to
	those values, and so on.

	In other words, changing the horizon changes where the hull is drawn, which changes 
	where the mast is drawn, which changes where the sail is drawn. Try it out!
*/





/*: You can even make recursive drawings!
	
	Recursion allows us to repeatedly nest a drawing inside itself, using a simple set of rules.
	It’s easiest to think of a recursive process as one that 
		1) starts at some value, 
		2) expresses how to progress from a value to the next value,
		3) checks for completion
	
	Below, we use the `Recursing` function to constantly shrink the width of the square by 10%.
	But the `Recursing` function doesn’t just work with `width`, it will work with any kind of
	value you pass into it!
*/

let recursiveColorer = Recursing({ width in Outlined(color: Blue, shape: Rectangle(x: 0, y: 0, width: Int(width * 100.0), height: Int(width * 100.0))) }, 
	startingValue: 1.0, 
	nextValue: { width in width * 0.9 }, 
	until: { width in width < 0.01 })
Draw(colorer: recursiveColorer)




