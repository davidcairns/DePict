/*:
## Let's make recursive drawings!

Recursion allows us to repeatedly nest a drawing inside itself, using a simple set of rules.
It’s easiest to think of a recursive process as one that
1. starts at some value,
2. expresses how to progress from a value to the next value,
3. checks for completion

Below, we use the `Recursing` function to constantly shrink the width of the square by 10%.
But the `Recursing` function doesn’t just work with `width`, it will work with any kind of
value you pass into it!
*/

import DePictLib

let recursiveSquares = Recursing({ size in Outlined(color: Blue, shape: Rectangle(x: 0, y: 0, width: size, height: size)) }, 
	startingValue: 100, 
	nextValue: { size in size * 9 / 10 }, 
	until: { size in size < 1 })
Draw(recursiveSquares)

