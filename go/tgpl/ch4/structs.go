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

// The name of a st r uc t field is exp or te d if it b eg ins w it h a c apit al letter ;
