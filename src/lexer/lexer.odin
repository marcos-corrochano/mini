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
	if is_done() do return 0
	return rune(lexer.source[lexer.offset])
}

next :: proc() -> rune {
	if is_done() do return 0
	current := lexer.source[lexer.offset]

	if current == '\n' {
		lexer.column = 0
		lexer.line += 1
	}

	lexer.column += 1
	lexer.offset += 1
	return rune(current)
}

is_ascii :: proc(char: rune) -> bool {
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

		if !is_ascii(char) {
			fmt.printfln("Invalid character '%r'", char)
			os.exit(1)
		}

		if char == '#' {
			for !is_done() {
				if peek() == '\n' do break
				next()
			}; continue
		}

		switch {
		case unicode.is_space(char):
			if char == '\n' do append(&tokens, token(.EOL))
			next()
		case unicode.is_letter(char), char == '_':
			append(&tokens, literal())
		case unicode.is_number(char):
			append(&tokens, number())
		case unicode.is_graphic(char):
			if char == '"' do append(&tokens, quote())
			else do append(&tokens, graphic())
		case:
			fmt.printfln("Unhandled character '%r'", char)
			os.exit(1)
		}
	}

	append(&tokens, token(.EOF))
	return tokens[:]
}
