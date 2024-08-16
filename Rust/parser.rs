#[derive(Debug)]
enum ASTNode {
    Assignment(String, Box<ASTNode>),
    BinaryOp(Box<ASTNode>, Token, Box<ASTNode>),
    Number(i64),
    Identifier(String),
}

struct Parser {
    tokens: Vec<Token>,
    position: usize,
}

impl Parser {
    fn new(tokens: Vec<Token>) -> Self {
        Parser {
            tokens,
            position: 0,
        }
    }

    fn current_token(&self) -> &Token {
        &self.tokens[self.position]
    }

    fn consume(&mut self) -> &Token {
        let token = &self.tokens[self.position];
        self.position += 1;
        token
    }

    fn parse(&mut self) -> ASTNode {
        self.parse_assignment()
    }

    fn parse_assignment(&mut self) -> ASTNode {
        if let Token::Identifier(name) = self.current_token() {
            let name = name.clone();
            self.consume();
            if let Token::Equals = self.current_token() {
                self.consume();
                let expr = self.parse_expression();
                return ASTNode::Assignment(name, Box::new(expr));
            }
        }
        panic!("Syntax error: Expected assignment");
    }

    fn parse_expression(&mut self) -> ASTNode {
        self.parse_term()
    }

    fn parse_term(&mut self) -> ASTNode {
        let mut node = self.parse_factor();

        while matches!(self.current_token(), Token::Plus | Token::Minus) {
            let op = self.consume().clone();
            let right = self.parse_factor();
            node = ASTNode::BinaryOp(Box::new(node), op, Box::new(right));
        }

        node
    }

    fn parse_factor(&mut self) -> ASTNode {
        let mut node = self.parse_primary();

        while matches!(self.current_token(), Token::Multiply | Token::Divide) {
            let op = self.consume().clone();
            let right = self.parse_primary();
            node = ASTNode::BinaryOp(Box::new(node), op, Box::new(right));
        }

        node
    }

    fn parse_primary(&mut self) -> ASTNode {
        match self.consume() {
            Token::Number(value) => ASTNode::Number(*value),
            Token::Identifier(name) => ASTNode::Identifier(name.clone()),
            Token::LParen => {
                let expr = self.parse_expression();
                if let Token::RParen = self.current_token() {
                    self.consume();
                } else {
                    panic!("Syntax error: Expected closing parenthesis");
                }
                expr
            }
            _ => panic!("Syntax error: Unexpected token"),
        }
    }
}
