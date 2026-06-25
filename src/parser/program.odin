package parser

import "../ast"
import "../lexer"
import "core:fmt"
import "core:os"

Node :: union {
	ast.Expr,
	ast.Stmt,
}

Program :: struct {
	nodes: [dynamic]^Node,
}

parse :: proc() -> (program: Program) {
	program.nodes = make([dynamic]^Node)

	for !is_done() {
		switch {
		case lexer.is_type(peek().kind):
			append(&program.nodes, parse_var_expr())
		case:
			next()
		}
	}; return
}

parse_var_expr :: proc() -> ^Node {
	type := next()
	name := expect(.Identifier)

	var := ast.VarStmt {
		type = type.kind,
		name = name.value.?,
	}

	if match(.Assign) {
		fmt.println("Assigment not handled!")
		os.exit(1)
	}

	node := new(Node)
	node^ = var
	return node
}
