use std::process;
use std::env::args;
use std::io::Write;
use std::fs::File;
use std::fs;

// const BUFFER: usize = 2048; 

fn main() {
    
    let _version: u8 = 1;
    
    let argv: Vec<String> = args().collect();

    let argc = argv.len();

    if argc != 3 {
        println!("We need 2 arguments for copy program");
        process::exit(1);
    }

    // open source file
    let fdold = File::open(argv[1]);

    // create new file
    let fdnew = File::create(argv[2]);


}

