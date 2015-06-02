# DePicture.playground - noun: a place where people can play with drawing

A simple, declarative, functional drawing framework! In Swift!  

To produce a drawing, call the `Draw` function (just type *Draw* and let autocomplete
do the rest!).  

Pass `Draw` a `Colorer`. There are currently two ways to color something. Type either:
• *Filled*, for filled-in shapes, or
• *Outlined*, for outlined or “stroked” shapes.

And then provide a color -- `Black`, `Yellow`, `Red`, or create anything you like.  

Now you can specify the `Shape` to be drawn:
• `Line`
• `Rectangle`
• `Circle`
• & more

In this way, the description of your drawing reads nicely:
	`Draw(colorer: Filled(color: Blue, shape: Circle(…)))`
	“Draw a Filled Blue Circle”

You can also combine `Shapes` and `Colorers` with `+`:
```
	let crossShape = Line(fromX: 1, y: 1, toX: 9, y: 9) + Line(fromX: 1, y: 9, toX: 9, y: 1)
	let blueSquare = Filled(Blue, Rectangle(x: 2, y: 2, width: 6, height: 6))
	let squareWithCross = blueSquare + Outlined(Red, crossShape)
```

This lets you create abstractions within your drawing and reuse them. You can turn the above *description* of `squareWithCross` into an image by `Draw`ing it:
	`Draw(width: 10, height: 10, color: squareWithCross)`

-----

### Drawing a Face

We can draw a face in just a single line of readable, declarative code. See how the pieces reflect the final result.

```
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
```

![A Face](http://davidcairns.github.io/DePict_README_images/face.png "A Face")

### Drawing Information graphics

It’s trivial to use DePict to turn data into information graphics, and the declarative style allows you to do so in an obvious, clear way.  

1) Start with some data you want to graph…  
`let data = [11, 87, 98, 48, 41, 88, 63, 69, 8, 79]`

2) For each datum, create a filled rectangle with height relative to its value.
`let bars = Array(0 ..< data.count).map({ Filled(color: Magenta, shape: Rectangle(x: $0 * 10, y: 0, width: 5, height: data[$0])) })`

3) Combine the rectangles.
`let graphData = bars.reduce(EmptyColorer(), combine: +)`


![Bar Charts](http://davidcairns.github.io/DePict_README_images/bar-chart.png "A Bar Chart")


-----

DePict is a super-simple wrapper for CoreGraphics that makes your drawing easy to ready and modify. It works great for iOS and Mac apps. Anything you would use CoreGraphics for, you can express more simply and easily with DePict.  

If you come up with something fun, fork the code, or tweet me `@davidcairns`!

