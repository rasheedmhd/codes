// Implementing Go anonymous fields in rust
// using Deref ops

use std::ops::Deref;

#[derive(Debug)]
struct Age {
    a: u8,
}

struct Person {
    name: String,
    age: Age,
}

struct Employee {
    person: Person, // Composition, not anonymous
    id: u32,
    company: String,
}

impl Deref for Employee {
    type Target = Person;

    fn deref(&self) -> &Self::Target {
        &self.person
    }
}

impl Deref for Person {
    type Target = Age;

    fn deref(&self) -> &Self::Target {
        &self.age
    }
}

fn main() {
    let e = Employee {
        person: Person {
            name: "Alice".to_string(),
            age: Age { a: 30 },
        },
        id: 101,
        company: "Tech Corp".to_string(),
    };

    // Direct access using Deref
    println!("Name: {}", e.name); // Accessing fields of Person through Deref
    println!("Age: {:?}", e.a);
}
