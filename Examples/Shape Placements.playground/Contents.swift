
import DePictLib

/// Turn data into graphics very quickly using simple combining functions, without having
/// to do the math of positioning each element yourself.
let data = Array(1 ... 20)
let circles = data.map({ Circle(radius: 1 + $0) }).reduce(EmptyShape(), spaced(5))
Draw(Filled(color: Blue, shape: circles))



/// Use simple operators to align elements declaritively -- the code directly represents the image!
let greenCircle = Filled(color: Green, shape: Circle(radius: 40))
let brownCircle = Filled(color: Brown, shape: Circle(radius: 40))
Draw(greenCircle ||| brownCircle ||| brownCircle
	 ---
	 brownCircle ||| brownCircle
	 ---
	 brownCircle)



/// Start with some random data...
let data2 = Array(1 ... 20).map({ _ in 1 + arc4random() % 10 })
/// Turn each datum into a row of circles...
let circlerow = data2.map({ Array(1 ... $0).map({ _ in Circle(radius: 10) }).reduce(EmptyShape(), |||) })
/// Combine all the rows into a single shape
					 .reduce(EmptyShape(), ---)
Draw(Filled(color: Green, shape: circlerow))
