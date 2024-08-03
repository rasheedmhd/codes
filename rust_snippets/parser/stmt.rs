
    use super::token::Token;
    type BoxedExpr = Box<Expr>;

    pub enum Stmt {
        Block(BlockStmt),
    }

    pub trait Visitor<T> {
        fn visit_block_stmt(&mut self, stmt: &BlockStmt) -> T;
    }

    impl Stmt {
        pub fn accept<T>(&self, visitor: &mut dyn Visitor<T>) -> T {
            match self {
                Stmt::Block(stmt) => visitor.visit_block_stmt(stmt),
            }
        }
    }


    #[derive(Clone, Debug, PartialEq)]
    pub struct BlockStmt {
        pub statements: Vec<Stmt>,
    }

    impl BlockStmt {
        pub fn new(statements: Vec<Stmt>) -> Self {
            Self {
                statements,
            }
        }

}
