
    use super::token::Token;
    type BoxedExpr = Box<Expr>;

    pub enum Expr {
        Return(ReturnExpr),
    }

    pub trait Visitor<T> {
        fn visit_return_expr(&mut self, expr: &ReturnExpr) -> T;
    }

    impl Expr {
        pub fn accept<T>(&self, visitor: &mut dyn Visitor<T>) -> T {
            match self {
                Expr::Return(expr) => visitor.visit_return_expr(expr),
            }
        }
    }

    #[derive(Clone, Debug, PartialEq)]
    pub struct ReturnExpr {
        pub keyword : Token,
        pub value : BoxedExpr,
    }

    impl ReturnExpr {
        pub fn new(keyword : Token, value : BoxedExpr) -> Self {
            Self {
                keyword,
                value,
            }
        }
    }
