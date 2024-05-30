pub mod jlox {

    use super::token::Token;

    pub enum Expr {
        Binary(BinaryExpr),
        Grouping(GroupingExpr),
        Literal(LiteralExpr),
        Unary(UnaryExpr),
    }

    // pub trait Visitor<R> {
    //     fn visit_binary_expr(&mut self, expr: &BinaryExpr) -> R;
    //     fn visit_grouping_expr(&mut self, expr: &GroupingExpr) -> R;
    //     fn visit_literal_expr(&mut self, expr: &LiteralExpr) -> R;
    //     fn visit_unary_expr(&mut self, expr: &UnaryExpr) -> R;
    // }


    pub struct BinaryExpr {
        pub Box<Expr> left,
        pub Token operator,
        pub Box<Expr> right,
    }

    impl BinaryExpr {
        pub fn new(Box<Expr> left, Token operator, Box<Expr> right) -> Self {
            Self {
                left,
                operator,
                right,
            }
        }
    }

    impl Expr for BinaryExpr {
        fn accept<R>(&self, visitor: &mut dyn Visitor<R>) -> R {
            visitor.visit_binary_expr(self)
        }
    }


    pub struct GroupingExpr {
        pub Box<Expr> expression,
    }

    impl GroupingExpr {
        pub fn new(Box<Expr> expression) -> Self {
            Self {
                expression,
            }
        }
    }

    impl Expr for GroupingExpr {
        fn accept<R>(&self, visitor: &mut dyn Visitor<R>) -> R {
            visitor.visit_grouping_expr(self)
        }
    }


    pub struct LiteralExpr {
        pub LiteralValue value,
    }

    impl LiteralExpr {
        pub fn new(LiteralValue value) -> Self {
            Self {
                value,
            }
        }
    }

    impl Expr for LiteralExpr {
        fn accept<R>(&self, visitor: &mut dyn Visitor<R>) -> R {
            visitor.visit_literal_expr(self)
        }
    }


    pub struct UnaryExpr {
        pub Token operator,
        pub Box<Expr> right,
    }

    impl UnaryExpr {
        pub fn new(Token operator, Box<Expr> right) -> Self {
            Self {
                operator,
                right,
            }
        }
    }

    impl Expr for UnaryExpr {
        fn accept<R>(&self, visitor: &mut dyn Visitor<R>) -> R {
            visitor.visit_unary_expr(self)
        }
    }

}
