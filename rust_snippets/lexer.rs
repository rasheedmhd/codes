#[derive(Debug, PartialEq)]
enum Token {
    Identifier(String),
    Number(i64),
    Equals,
    Plus,
    Minus,
    Multiply,
    Divide,
    LParen,
    RParen,
    EOF,
}

struct Lexer {
    input: String,
    position: usize,
}

impl Lexer {
    fn new(input: String) -> Self {
        Lexer { input, position: 0 }
    }

    fn get_char(&self) -> Option<char> {
        self.input.chars().nth(self.position)
    }

    fn advance(&mut self) {
        self.position += 1;
    }

    fn lex(&mut self) -> Vec<Token> {
        let mut tokens = Vec::new();

        while let Some(c) = self.get_char() {
            match c {
                '=' => {
                    tokens.push(Token::Equals);
                    self.advance();
                }
                '+' => {
                    tokens.push(Token::Plus);
                    self.advance();
                }
                '-' => {
                    tokens.push(Token::Minus);
                    self.advance();
                }
                '*' => {
                    tokens.push(Token::Multiply);
                    self.advance();
                }
                '/' => {
                    tokens.push(Token::Divide);
                    self.advance();
                }
                '(' => {
                    tokens.push(Token::LParen);
                    self.advance();
                }
                ')' => {
                    tokens.push(Token::RParen);
                    self.advance();
                }
                '0'..='9' => {
                    let mut num = 0;
                    while let Some(d) = self.get_char().and_then(|c| c.to_digit(10)) {
                        num = num * 10 + d as i64;
                        self.advance();
                    }
                    tokens.push(Token::Number(num));
                }
                'a'..='z' | 'A'..='Z' | '_' => {
                    let mut identifier = String::new();
                    while let Some(c) = self.get_char().filter(|c| c.is_alphanumeric() || *c == '_')
                    {
                        identifier.push(c);
                        self.advance();
                    }
                    tokens.push(Token::Identifier(identifier));
                }
                _ => {
                    self.advance();
                }
            }
        }

        tokens.push(Token::EOF);
        tokens
    }
}
