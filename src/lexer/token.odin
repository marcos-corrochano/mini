package lexer

Token :: struct {
	type:  string,
	value: Maybe(string),
}

token :: proc(type: string) -> Token {
    lexeme := lexer.source[lexer.start:lexer.offset]
	return Token{type = type, value = lexeme}
}
