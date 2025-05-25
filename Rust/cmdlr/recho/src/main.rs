// use std::{process, env};
use clap::{Command, arg};

fn main() {
    let matches = Command::new("recho")
        .version("0.0.1")
        .author("Rasheed Starlet : starletgh@gmail.com")
        .about("echo Impl in Rust")
        .arg(arg!(--text <TEXT>).required(true))
        .arg(arg!(--n <OMIT_NEWLINE>))
        // .arg(
        //     Arg::with_name("text")
        //         .value_name("TEXT")
        //         .help("Input text")
        //         .required(true)
        //         .min_values(1),
        // // )
        // .arg(
        //     Arg::with_name("omit_newline")
        //         .short("n")
        //         .help("Do not print newline")
        //         .takes_value(false),
        // )
        .get_matches();

    println!("{:#?}", matches)
}