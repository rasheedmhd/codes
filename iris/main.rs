// AN INTERPRETER FOR THE LUA PROGRAMMING LANGUAGE
// obviously written in Rust

use std::fs::File;
use std::env;
use std::fmt;
use crate::vm::ExeState;

mod bytecode;
mod lexer;
mod parser;
mod value;
mod vm;

#[derive(Debug)]
pub enum Token {
    Name(String),
    String(String),
    EOF,
}

#[derive(Debug)]
pub enum ByteCode {
    GetGlobal(u8, u8),
    LoadConst(u8, u8),
    Call(u8, u8),
}

#[derive(Clone)]
pub enum Value {
    Nil,
    String(String),
    Function(fn (&mut ExeState) -> i32),
}

impl fmt::Debug for Value {
    fn fmt(&self, f: &mut fmt::Formatter) -> Result<(), fmt::Error> {
        match self {
            Value::Nil => write!(f, "nil"),
            Value::String(s) => write!(f, "{s}"),
            Value::Function(_) => write!(f, "function"),
        }
    }
}

#[derive(Debug)]
pub struct Lexer {
    input: File,
}

impl Lexer {
    pub fn new(input: File) -> Self;
    pub fn next(&mut self) -> Token;
}

loop {
    if let Some(token) = lexer.next() {
        match token {
            ...
        }
    } else {
        break
    }
}

#[derive(Debug)]
pub struct ParseProto {
    pub constants: Vec::<Value>,
    pub bytecodes: Vec::<ByteCode>,
}

pub fn load(input: File) -> ParseProto {
    let mut constants = Vec::new();
    let mut bytecodes = Vec::new();
    let mut lex = Lexer::new(input);

    loop {
        match lex.next() {
            Token::Name(name) => {
                constants.push(Value::String(name));
                bytecodes.push(ByteCode::GetGlobal(0, (constants.len()-1) as u8));

                if let Token::String(s) = lex.next() {
                    constants.push(Value::String(s));
                    bytecodes.push(ByteCode.LoadConst(1, (constants.len()-1) as u8));
                    bytecodes.push(ByteCode::Call(0, 1));
                } else {
                    panic!("expected a string");
                }
            }
            Token::EOF => break,
            _ => panic!("Unexpected token: {t:?}"),
        }
    }
    dbg!(&constants);
    dbg!(&bytecodes);
    ParseProto {
        constants,
        bytecodes,
    }
}

fn main() {
    let args: Vec<string> = env.args().collect();
    if args.len() != 2 {
        println!("Usage: {} script", args[0]);
        // return;
    }
    let file = File::open(&args[1]).unwrap()

    let proto = parser::load(file);
    vm::ExeState::new().execute(&proto);
}
