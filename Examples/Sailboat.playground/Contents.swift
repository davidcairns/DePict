/*:
## Let’s draw a sailboat!

By describing a drawing in this way, we can clearly see how the different
elements break down.

However, a computer is a dynamic medium! We have a lot of duplicated values
in the above. These can be *abstracted* to a `let` statement, giving a name
to the value. Then we can use this name to refer to the value later, and
combine it with other values.
*/


import DePictLib

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


/*: 
Now check it out! You can change the level of the horizon (by, for example, changing
the line above to `let horizon = 50`), and the value of the horizon will change
everything that was defined relative to it, and all the values defined relative to
those values, and so on.

In other words, changing the horizon changes where the hull is drawn, which changes 
where the mast is drawn, which changes where the sail is drawn. Try it out, and watch
the sidebar!
*/

