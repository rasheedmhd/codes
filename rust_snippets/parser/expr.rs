
    use super::token::Token;
    type BoxedExpr = Box<Expr>;

    pub enum Expr {
        Call(CallExpr),
    }

    pub trait Visitor<T> {
        fn visit_call_expr(&mut self, expr: &CallExpr) -> T;
    }

    impl Expr {
        pub fn accept<T>(&self, visitor: &mut dyn Visitor<T>) -> T {
            match self {
                Expr::Call(expr) => visitor.visit_call_expr(expr),
            }
        }
    }

    #[derive(Clone, Debug, PartialEq)]
    pub struct CallExpr {
        pub callee : BoxedExpr,
        pub paren : Token,
        pub arguments : Vec<BoxedExpr>,
    }

    impl CallExpr {
        pub fn new(callee : BoxedExpr, paren : Token, arguments : Vec<BoxedExpr>) -> Self {
            Self {
                callee,
                paren,
                arguments,
            }
        }
    }
