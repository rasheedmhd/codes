
    use super::token::Token;
    type BoxedExpr = Box<Expr>;

    pub enum Expr {
        Assign(AssignExpr),
    }

    pub trait Visitor<T> {
        fn visit_assign_expr(&mut self, expr: &AssignExpr) -> T;
    }

    impl Expr {
        pub fn accept<T>(&self, visitor: &mut dyn Visitor<T>) -> T {
            match self {
                Expr::Assign(expr) => visitor.visit_assign_expr(expr),
            }
        }
    }


    pub struct AssignExpr {
        pub name: Token,
        pub value : BoxedExpr,
    }

    impl AssignExpr {
        pub fn new(name: Token, value : BoxedExpr) -> Self {
            Self {
                name,
                value,
            }
        }

}
