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
	Assign,
	Arrow,

	// Comparison
	Eq,
	Gt,
	GtEq,
	Lt,
	LtEq,
	NotEq,

	// Logical
	And,
	Bang,
	Or,

	// Increment / Decrement
	DoubleMinus,
	DoublePlus,

	// Delimiters
	LeftBrace,
	LeftBracket,
	LeftParen,
	RightBrace,
	RightBracket,
	RightParen,

	// Punctuation
	Colon,
	Comma,
	Dot,
	Semi,

	// Literals
	Float,
	Identifier,
	Int,
	Number,
	Quote,
	Rune,

	// Types
	Bool,
	Byte,
	Float32,
	Float64,
	Int8,
	Int16,
	Int32,
	Int64,
	String,
	Uint8,
	Uint16,
	Uint32,
	Uint64,

	// Keywords
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

	// Control
	EOF,
}

@(rodata)
Keyword := #partial [Kind]string {
	.Bool     = "bool",
	.Byte     = "byte",
	.Rune     = "rune",
	.Float32  = "f32",
	.Float64  = "f64",
	.Int8     = "i8",
	.Int16    = "i16",
	.Int32    = "i32",
	.Int64    = "i64",
	.Uint8    = "u8",
	.Uint16   = "u16",
	.Uint32   = "u32",
	.Uint64   = "u64",
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
