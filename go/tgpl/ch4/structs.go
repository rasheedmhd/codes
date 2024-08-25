type Employee struct {
	ID      int
	Name    string
	Address string
	// also valid
	// Name, Address      string
	DoB       time.Time
	Position  string
	Salary    int
	ManagerID int
}

var dilbert Employee

// . notation
dilbert.Salary -= 5000 // demoted, for writing too few lines of code

// pointes
position := &dilbert.Position     //  take  address
*position = "Senior " + *position // access through a pointer

// The dot notation also works with a pointer to a struct:
var employeeOfTheMonth *Employee = &dilbert
employeeOfTheMonth.Position += " (proactive team player)"

// The last statement is equivalent to
(*employeeOfTheMonth).Position += " (proactive team player)"

// The name of a struct field is exported if it begins with a capital letter ;


// struct literals
type Point struct { x, y int }
point := Point{1, 2}


// If a field is omitted in t his kind of literal, it is set to the zero value for its type.
// Because names are prov ide d, he order of fields do esn’t matter.
anim := gif.GIF{LoopCount: nframes}

// If you need to use struct fields in a different package
// you must export by setting the field name as capitalized
package p
type T struct{ a, b int } // a and b are not exported
package q
import "p"
var _ = p.T{a: 1, b: 2} // compile error: can't reference a, b
var _ = p.T{1, 2}       // compile error: can't reference a, b

// structs are first class
// passing/returning structs to/from functions
func Scale(p Point, factor int) Point {
    return Point{p.X * factor, p.Y * factor}
}
fmt.Println(Scale(Point{1, 2}, 5)) // "{5 10}"


// for efficiency pass structs(large) as pointers/references
func Bonus(e *Employee, percent int) int {
    return e.Salary * percent / 100
}

// Since go is call-by-name, to modify the struct pass pointers/references
func AwardAnnualRaise(e *Employee) {
    e.Salary = e.Salary * 105 / 100
}

// Use this short hand notation to create and initialize a struct variable and obtain its address:
pp := &Point{1,2}
// same as
pp := new(Point)
*pp = Point{1, 2}

// but
&Point{1, 2}
// can be used directly within an expression, such as a function call.

// 4.4.2. Comparing Structs
// If all the fields of a struct are comparable, the struct itself is comparable,
// So two expressions of that type may becomp are d using == or !=


type Point struct{ X, Y int }

p := Point{1, 2}
q := Point{2, 1}
fmt.Println(p.X == q.X && p.Y == q.Y) // "false"
fmt.Println(p == q)                   // "false"



// Comparable struct types,
// like ot her comparable types,
// may be used as the key type of a map.
type address struct {
	hostname string
	port int
}

hits := make(map[address]int)
hits[address{"golang.org", 443}]++

// 4.4.3. Struct Embedding and Anonymous Fields
type Circle struct {
    X, Y, Radius int
}

type Wheel struct {
    X, Y, Radius, Spokes int
}

// creating a wheel
// declare and initialize
var w Wheel
w.X = 8
w.Y = 8
w.Radius = 5
w.Spokes = 20

// Struct literal
w := Wheel{8,8,5,20

// Struct literal with named fields
w := Wheel{X: 8, Y: 8, Radius: 5, Spokes: 20}


// refactor
type Point struct {
    X, Y int
}

type Circle struct {
    Center Point
    Radius int
}

type Wheel struct {
    Circle Circle
    Spokes int
}

// Accessing
var w Wheel
w.Circle.Center.X = 8
w.Circle.Center.Y = 8
w.Circle.Radius = 5
w.Spokes = 20

// Embedding structs as fields into other structs
// anonymous fields, have no name but types

type Circle struct {
    Point
    Radius int
}

type Wheel struct {
	Circle
	Spokes int
}

var w Wheel
w.X = 8 // equivalent to w.Circle.Point.X = 8
w.Y = 8 // equivalent to w.Circle.Point.Y = 8
w.Radius = 5 // equivalent to w.Circle.Radius = 5
w.Spokes = 20

// Unfortunately, there’s no corresponding shorthand for the struct literal syntax,
// so neither of these will compile:
w = Wheel{8, 8, 5, 20}                       // compile error: unknown fields
w = Wheel{X: 8, Y: 8, Radius: 5, Spokes: 20} // compile error: unknown fields

// initialization of anonymous fields
// Positional literals
w = Wheel{Circle{Point{8, 8}, 5}, 20}

// Named fields
w = Wheel{
    Circle: Circle{
        Point:  Point{X: 8, Y: 8},
        Radius: 5,
    },
    Spokes: 20, // NOTE: trailing comma necessary here (and at Radius)
}

fmt.Printf("%#v\n", w)
// Output:
// Wheel{Circle:Circle{Point:Point{X:8, Y:8}, Radius:5}, Spokes:20}
w.X = 42
fmt.Printf("%#v\n", w)
// Output:
// Wheel{Circle:Circle{Point:Point{X:42, Y:8}, Radius:5}, Spokes:20}
