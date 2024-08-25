// AN INTERPRETER FOR THE LUA PROGRAMMING LANGUAGE
// obviously written in Rust

use crate::vm::ExeState;
use std::collections::HashMap;
use std::env;
use std::fmt;
use std::fs::File;

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
    Function(fn(&mut ExeState) -> i32),
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
    pub fn new(input: File) -> Self {}
    pub fn next(&mut self) -> Token {}
}

// loop {
//     if let Some(token) = lexer.next() {
//         match token {
//             ...
//         }
//     } else {
//         break
//     }
// }

#[derive(Debug)]
pub struct ParseProto {
    pub constants: Vec<Value>,
    pub bytecodes: Vec<ByteCode>,
}

pub fn load(input: File) -> ParseProto {
    let mut constants = Vec::new();
    let mut bytecodes = Vec::new();
    let mut lex = Lexer::new(input);

    loop {
        match lex.next() {
            Token::Name(name) => {
                constants.push(Value::String(name));
                bytecodes.push(ByteCode::GetGlobal(0, (constants.len() - 1) as u8));

                if let Token::String(string) = lex.next() {
                    constants.push(Value::String(string));
                    bytecodes.push(ByteCode::LoadConst(1, (constants.len() - 1) as u8));
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

// vm state
pub struct ExeState {
    globals: HashMap<String, Value>,
    stack: Vec<Value>,
}

// fn lib_print(state: &mut ExeState) -> i32 {
//     println!("{:?}", state.stack[1]);
//     0
// }
//
fn lib_print(state: &mut ExeState) -> ! {
    println!("{:?}", state.stack[1]);
}

impl ExeState {
    pub fn new() -> Self {
        let mut globals = HashMap::new();
        globals.insert(String::from("print"), Value::Function(lib_print));

        ExeState {
            globals,
            stack: Vec::new(),
        }
    }
}

pub fn execute(&mut self, proto: &ParseProto) {
    for code in proto.bytecodes.iter() {
        match *code {
            ByteCode::GetGlobal(dst, name) => {
                let name = &proto.constants[name as usize];
                if let Value::String(key) = name {
                    let v = self.globals.get(key).unwrap_or(&Value::Nil).clone();
                    self.set_stack(dst, v);
                } else {
                    panic!("invalid global key: {name:?");
                }
            }
            ByteCode::LoadConst(dst, c) => {
                let v = proto.constants[c as usize].clone();
                self.set_stack(dst, v);
            }

            ByteCode::Call(function, _) => {
                let function = &self.constants[function as usize].clone();
                if let Value::Function(f) = function {
                    f(self);
                } else {
                    panic!("invalid function: {function:?}");
                }
            }
        }
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        println!("Usage: {} script", args[0]);
        // return;
    }
    let file = File::open(&args[1]).unwrap();

    let proto = parser::load(file);
    vm::ExeState::new().execute(&proto);
}
