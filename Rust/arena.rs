// USING bumpalo for arena mem management
struct SomeData {
    name: String,
    value: u32,
}

fn bumpalo_example() {
    let mut arena = bumpalo::Bump::now();

    for _ in 0..10 {
        let data1: &mut SomeData = arena.alloc(SomeData {
            name: "some data".to_string(),
            value: 1,
        });
        let data2: &mut String = arena.alloc(String::from("some more data"));

        println!("{data1}");
        println!("{data2}");

        arena.reset();
    }
}

fn main() {
    bumpalo_example();
}
