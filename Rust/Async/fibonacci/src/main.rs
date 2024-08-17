// use std::thread;

// fn main() {
//     let mut threads = Vec::new();

//     for i in 0..8 {
//         let handle = thread::spawn(move || {
//             let result = fibonacci(4000);
//             println!("THREAD {} RESULT: {}", i, result);
//         });
//         threads.push(handle);
//     }
//     for handle in threads {
//         handle.join().unwrap();
//     }
// }

// fn fibonacci(n: u64) -> u64 {
//     if n == 0 || n == 1 {
//         return n;
//     }
//     fibonacci(n - 1) + fibonacci(n - 2)
// }

use reqwest::Error;
use std::time::Instant;

#[tokio::main]
async fn main() -> Result<(), Error> {
    let url = "https://jsonplaceholder.typicode.com/posts/1";

    let start_time = Instant::now();
    let _ = reqwest::get(url).await?;
    let _ = reqwest::get(url).await?;
    let _ = reqwest::get(url).await?;
    let _ = reqwest::get(url).await?;
    let _ = reqwest::get(url).await?;

    let elapsed_time = start_time.elapsed();
    println!("Request took {} ms", elapsed_time.as_millis());
    Ok(())
}
