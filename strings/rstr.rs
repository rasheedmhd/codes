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
