package lexer

import "core:fmt"
import "core:os"
import "core:unicode"

Lexer :: struct {
	source: string,
	start:  int,
	column: int,
	line:   int,
	offset: int,
}

lexer: Lexer

init :: proc(source: string) {
	lexer.source = source
	lexer.line = 1
}

peek :: proc() -> rune {
	if is_done() do return -1
	return rune(lexer.source[lexer.offset])
}

next :: proc() -> rune {
	if is_done() do return -1
	current := lexer.source[lexer.offset]

	if current == '\n' {
		lexer.column = 0
		lexer.line += 1
	}

	lexer.column += 1
	lexer.offset += 1
	return rune(current)
}

is_utf8 :: proc(char: rune) -> bool {
	return char <= unicode.MAX_ASCII
}

is_done :: proc() -> bool {
	return lexer.offset >= len(lexer.source)
}

tokenize :: proc() -> []Token {
	tokens := make([dynamic]Token)

	for !is_done() {
		char := peek()
		lexer.start = lexer.offset

		if !is_utf8(char) {
			fmt.println("Invalid character!")
			os.exit(1)
		}

		if unicode.is_space(char) {
			next()
			continue
		}

		switch {
		case unicode.is_letter(char), char == '_':
			append(&tokens, scan_literal())
		case unicode.is_number(char):
			append(&tokens, scan_number())
		case:
			fmt.println("Unhandled character '%s'", char)
			os.exit(1)
		}
	}

	return tokens[:]
}
