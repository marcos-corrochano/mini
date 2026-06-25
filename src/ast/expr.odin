package ast

import "../lexer"

Expr :: union {
	LiteralExpr,
	IdentifierExpr,
	BinaryExpr,
	CallExpr,
}

LiteralExpr :: struct {
	kind:  lexer.Kind,
	value: string,
}

IdentifierExpr :: struct {
	name: string,
}

BinaryExpr :: struct {
	left:     ^Expr,
	operator: lexer.Kind,
	right:    ^Expr,
}

CallExpr :: struct {
	name: string,
	args: [dynamic]^Expr,
}
