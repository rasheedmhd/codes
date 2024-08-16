use std::net::{TcpListener, TcpStream};
use std::io::{Read, Write, Result};
use std::thread;

fn handle_client(mut stream: TcpStream) {
    let mut buffer = [0; 512]; // Create a buffer to hold incoming data.
    
    loop {
        match stream.read(&mut buffer) {
            Ok(size) => {
                if size == 0 { // If no data is received, break the loop.
                    break;
                }
                stream.write(&buffer[0..size]).expect("Failed to write back to socket");
            },
            Err(e) => {
                eprintln!("Failed to read from connection: {}", e);
                break;
            }
        }
    }
}

fn main() -> Result<()> {
    let listener = TcpListener::bind("127.0.0.1:7878")?; // Bind the listener to an address and port.
    println!("Server listening on port 7878");

    for stream in listener.incoming() {
        match stream {
            Ok(stream) => {
                println!("New connection: {}", stream.peer_addr().unwrap());
                thread::spawn(|| { // Handle each connection in a separate thread.
                    handle_client(stream)
                });
            },
            Err(e) => {
                eprintln!("Connection failed: {}", e);
            }
        }
    }

    Ok(())
}
