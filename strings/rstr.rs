// fn main() {
//     let arg = std::env::args()
//         .skip(1)
//         .next()
//         .expect("should have one argument");
//     println!("{}", arg.to_uppercase());
// }

// When we used args_os()
// we don't get .to_uppercase

// fn main() {
//     let arg = std::env::args_os()
//         .skip(1)
//         .next()
//         .expect("should have one argument");
//     println!("{:?}", arg)
// }
//
//

// In Rust, provided you don't explicitly work around it with unsafe, values of type String are always valid UTF-8.

// Now we can gracefully handle the error
fn main() {
    let arg = std::env::args_os()
        .skip(1)
        .next()
        .expect("should have one argument");

    match arg.to_str() {
        Some(arg) => println!("valid UTF-8: {}", arg),
        None => println!("not valid UTF-8: {:?}", arg),
    }
}

// What if we want to print the Unicode scalar values's numbers instead of their, uh, graphemes?
// fn main() {
//     let arg = std::env::args()
//         .skip(1)
//         .next()
//         .expect("should have one argument");

//     for c in arg.chars() {
//         print!("{} (U+{:04X}) ", c, c as u32);
//     }
//     println!()
// }

// What if we want to show how it's encoded as UTF-8? By which I mean, print the individual bytes?
// fn main() {
//     let arg = std::env::args()
//         .skip(1)
//         .next()
//         .expect("should have one argument");

//     for b in arg.bytes() {
//         print!("{:02X} ", b);
//     }
//     println!()
// }
