/*:
## Let’s draw a bar graph!

It’s also easy to use DePict to draw complex, data-driven graphics and animations.
*/

import DePictLib

// 1) Start with some data you want to graph...
let data = [11, 87, 98, 48, 41, 88, 63, 69, 8, 79]

// 2) For each datum, create a filled rectangle with height relative to its value.
let bars = Array(0 ..< data.count).map({ Filled(color: Magenta, shape: Rectangle(x: $0 * 10, y: 0, width: 5, height: data[$0])) })

// 3) Combine the rectangles using the `+` operator -- note that starting with `EmptyColorer` is just like summing numbers by starting with 0.
let graphData = bars.reduce(EmptyColorer(), combine: +)

Draw(colorer: graphData)

