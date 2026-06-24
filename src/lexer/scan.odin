package lexer

import "core:fmt"
import "core:os"
import "core:strings"
import "core:unicode"

literal :: proc() -> Token {
	for !is_done() {
		char := peek()
		if !unicode.is_letter(char) && !unicode.is_number(char) && char != '_' do break
		next()
	}

	lexeme := lexer.source[lexer.start:lexer.offset]

	for word, kind in Keyword {
		if strings.compare(lexeme, word) != 0 do continue
		return token(kind)
	}

	return token(.Identifier)
}

quote :: proc() -> Token {
	next()
	lexer.start += 1

	for {
		if is_done() {
			fmt.println("Close quote colon not found!")
			os.exit(1)
		}

		if peek() == '"' do break; next()
	}

	result := token(.Quote); next()
	return result
}

number :: proc() -> (tok: Token) {
	next(); for !is_done() {
		char := peek()

		if char == '.' {
			next()
			continue
		}

		if !unicode.is_number(char) do break
		next()
	}

	lexeme := lexer.source[lexer.start:lexer.offset]

	if strings.contains(lexeme, ".") {
		tok = token(.Float)
	} else do tok = token(.Int)

	return tok
}

graphic :: proc() -> (tok: Token) {
	switch current := next(); current {
	case '+':
		char := peek()
		tok = token(.Plus)
		if char == '=' {next(); tok = token(.PlusEq)}
		if char == '+' {next(); tok = token(.DoublePlus)}
	case '-':
		char := peek()
		tok = token(.Minus)
		if char == '=' {next(); tok = token(.MinusEq)}
		if char == '-' {next(); tok = token(.DoubleMinus)}
		if char == '>' {next(); tok = token(.Arrow)}
	case '<':
		char := peek()
		tok = token(.Lt)
		if char == '=' {next(); tok = token(.LtEq)}
	case '>':
		char := peek()
		tok = token(.Gt)
		if char == '=' {next(); tok = token(.GtEq)}
	case '!':
		char := peek()
		tok = token(.Bang)
		if char == '=' {next(); tok = token(.NotEq)}
	case '=':
		char := peek()
		tok = token(.Assign)
		if char == '=' {next(); tok = token(.Eq)}
	case '(':
		tok = token(.LeftParen)
	case ')':
		tok = token(.RightParen)
	case '{':
		tok = token(.LeftBrace)
	case '}':
		tok = token(.RightBrace)
	case '[':
		tok = token(.LeftBracket)
	case ']':
		tok = token(.RightBracket)
	case '*':
		tok = token(.Star)
	case '%':
		tok = token(.Percentage)
	case '^':
		tok = token(.Caret)
	case '/':
		tok = token(.Slash)
	case ':':
		tok = token(.Colon)
	case '.':
		tok = token(.Dot)
	case ';':
		tok = token(.Semi)
	case ',':
		tok = token(.Comma)
	case:
		fmt.printfln("Unhandled character '%r'", current)
		os.exit(1)
	}

	return tok
}
