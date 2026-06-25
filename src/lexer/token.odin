package lexer

Kind :: enum {
	// Arithmetic
	Caret,
	Minus,
	MinusEq,
	Percentage,
	Plus,
	PlusEq,
	Slash,
	Star,

	// Assignment
	Arrow,
	Assign,

	// Comparison
	Eq,
	Gt,
	GtEq,
	Lt,
	LtEq,
	NotEq,

	// Control
	EOF,
	EOL,

	// Delimiter
	LeftBrace,
	LeftBracket,
	LeftParen,
	RightBrace,
	RightBracket,
	RightParen,

	// Increment
	DoubleMinus,
	DoublePlus,

	// Keyword
	Break,
	Continue,
	Else,
	False,
	Fn,
	For,
	If,
	Pub,
	True,
	When,

	// Literal
	FloatLiteral,
	Identifier,
	IntLiteral,
	NumberLiteral,
	StringLiteral,
	RuneLiteral,

	// Logical
	And,
	Bang,
	Or,

	// Punctuation
	Colon,
	Comma,
	Dot,
	Semi,

	// Type
	Bool,
	Byte,
	Float,
	String,
	Int,
	Rune,
}

Keyword := #partial [Kind]string {
	.Bool     = "bool",
	.Byte     = "byte",
	.Rune     = "rune",
	.Float    = "float",
	.Int      = "int",
	.Break    = "break",
	.Continue = "continue",
	.Else     = "else",
	.False    = "false",
	.Fn       = "fn",
	.For      = "for",
	.If       = "if",
	.Pub      = "pub",
	.String   = "string",
	.True     = "true",
	.When     = "when",
}

Token :: struct {
	kind:  Kind,
	value: Maybe(string),
	start: int,
	end:   int,
	line:  int,
}

token :: proc(kind: Kind) -> Token {
	lexeme: Maybe(string)
	lexeme = lexer.source[lexer.start:lexer.offset]

	if kind == .EOF {
		lexeme = nil
		lexer.start = -1
		lexer.offset = -1
		lexer.column = -1
	}

	return Token {
		kind = kind,
		value = lexeme,
		start = lexer.start,
		end = lexer.offset,
		line = lexer.line,
	}
}

is_type :: proc(kind: Kind) -> bool {
	return kind >= .Bool && kind <= .Rune
}

is_keyword :: proc(kind: Kind) -> bool {
	return kind >= .Break && kind <= .When
}

is_literal :: proc(kind: Kind) -> bool {
	return kind >= .FloatLiteral && kind <= .RuneLiteral
}
