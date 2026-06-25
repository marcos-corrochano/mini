package ast

import "../lexer"

Stmt :: union {
	ExprStmt,
	VarStmt,
}

ExprStmt :: struct {
	expr: ^Expr,
}

VarStmt :: struct {
	name:  string,
	type:  lexer.Kind,
	value: Maybe(^Expr),
}
