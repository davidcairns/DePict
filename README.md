# DePicture.playground - noun: a place where people can play with drawing

A simple, declarative, functional drawing framework! In Swift!  

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

You can also combine `Shapes` and `Colorers` and nest them, like so:
```
	let crossShape = Line(fromX: 1, y: 1, toX: 9, y: 9) + Line(fromX: 1, y: 9, toX: 9, y: 1)
	let blueSquare = Filled(Blue, Rectangle(x: 2, y: 2, width: 6, height: 6))
	let squareWithCross = blueSquare + Outlined(Red, crossShape)
```

You can turn the above *description* of `squareWithCross` into a shape by *Draw*ing it:
	`Draw(width: 10, height: 10, color: squareWithCross)`


At the bottom, there’s some simple code describing a face, followed by the image produced.
See if you can give the face some glasses or ears or eyebrows! Or, better yet, come up
with your own creation! Go nuts!
	
If you come up with something fun, fork the code, or tweet me `@davidcairns`!

