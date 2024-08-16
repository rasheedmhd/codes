
    use super::token::Token;
    type BoxedExpr = Box<Expr>;

    pub enum Stmt {
        Call(CallStmt),
    }

    pub trait Visitor<T> {
        fn visit_call_stmt(&mut self, stmt: &CallStmt) -> T;
    }

    impl Stmt {
        pub fn accept<T>(&self, visitor: &mut dyn Visitor<T>) -> T {
            match self {
                Stmt::Call(stmt) => visitor.visit_call_stmt(stmt),
            }
        }
    }

    #[derive(Clone, Debug, PartialEq)]
    pub struct CallStmt {
        pub callee : BoxedExpr,
        pub paren : Token,
        pub arguments : Vec<BoxedExpr>,
    }

    impl CallStmt {
        pub fn new(callee : BoxedExpr, paren : Token, arguments : Vec<BoxedExpr>) -> Self {
            Self {
                callee,
                paren,
                arguments,
            }
        }
    }
