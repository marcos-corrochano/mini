package parser

import "../lexer"
import "core:fmt"
import "core:os"

Parser :: struct {
	tokens: []lexer.Token,
	offset: int,
}

parser: Parser

init :: proc(tokens: []lexer.Token) {
    parser.tokens = tokens
}

peek :: proc() -> lexer.Token {
	return parser.tokens[parser.offset]
}

next :: proc() -> lexer.Token {
	current := parser.tokens[parser.offset]
	parser.offset += 1
	return current
}

expect :: proc(kind: lexer.Kind) -> (token: lexer.Token) {
	token = next(); if token.kind != kind {
		fmt.printfln("Expected %v, got %v", kind, token.kind)
		os.exit(1)
	}; return
}

match :: proc(list: ..lexer.Kind) -> bool {
    for kind in list {
        if peek().kind == kind {
            next()
            return true
        }
    }
	
	return false
}

is_done :: proc() -> bool {
	return parser.offset >= len(parser.tokens)
}
