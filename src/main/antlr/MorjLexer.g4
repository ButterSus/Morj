// $antlr-format alignTrailingComments true, columnLimit 150, maxEmptyLinesToKeep 1, reflowComments false, useTab false
// $antlr-format allowShortRulesOnASingleLine true, allowShortBlocksOnASingleLine true, minEmptyLines 0, alignSemicolons ownLine
// $antlr-format alignColons trailing, singleLineOverrulesHangingColon true, alignLexerCommands true, alignLabels true, alignTrailers true

lexer grammar MorjLexer;

options {
    superClass = MorjLexerBase;
}

// Comments
HashBangLine      :                           {this.IsStartOfFile()}? '#!' ~[\r\n\u2028\u2029]*;
MultiLineComment  : '/*' .*? '*/'             -> channel(HIDDEN);
SingleLineComment : '//' ~[\r\n\u2028\u2029]* -> channel(HIDDEN);

// Whitespace
WhiteSpaces      : [\t\u000B\u000C\u0020\u00A0]+ -> skip;
LineTerminator   : [\r\n\u2028\u2029];
LineContinuation : '\\' LineTerminator -> skip;

// Braces
OpenBracket  : '[';
CloseBracket : ']';
OpenBrace    : '{' -> pushMode(DEFAULT_MODE);
CloseBrace   : '}' -> popMode;
OpenParen    : '(';
CloseParen   : ')';

// Base characters
SemiColon                  : ';';
Comma                      : ',';
Assign                     : '=';
QuestionMark               : '?';
Colon                      : ':';
Ellipsis                   : '...';
Range                      : '..';
RangeUntil                 : '..<';
Dot                        : '.';
PlusPlus                   : '++';
MinusMinus                 : '--';
Plus                       : '+';
Minus                      : '-';
BitNot                     : '~';
Not                        : '!';
Multiply                   : '*';
Divide                     : '/';
Modulus                    : '%';
Power                      : '**';
Hashtag                    : '#';
RightShiftArithmetic       : '>>';
LeftShiftArithmetic        : '<<';
LessThan                   : '<';
MoreThan                   : '>';
LessThanEquals             : '<=';
GreaterThanEquals          : '>=';
Equals_                    : '==';
NotEquals                  : '!=';
BitAnd                     : '&';
BitXOr                     : '^';
BitOr                      : '|';
And                        : '&&';
Or                         : '||';
MultiplyAssign             : '*=';
DivideAssign               : '/=';
ModulusAssign              : '%=';
PlusAssign                 : '+=';
MinusAssign                : '-=';
LeftShiftArithmeticAssign  : '<<=';
RightShiftArithmeticAssign : '>>=';
BitAndAssign               : '&=';
BitXorAssign               : '^=';
BitOrAssign                : '|=';
PowerAssign                : '**=';
At                         : '@';

// None Literals
NoneLiteral: 'none';

// Boolean Literals
BooleanLiteral: 'true' | 'false';

// Numeric Literals
FloatLiteral: DoubleLiteral [fF] | DecimalIntegerLiteral [fF];
DoubleLiteral:
    DecimalIntegerLiteral? '.' DecimalDigitsLiteral ExponentPart?
    | DecimalIntegerLiteral ExponentPart
;
DecIntegerLiteral    : DecimalIntegerLiteral;
HexIntegerLiteral    : '0' [xX] HexDigit ('_'? HexDigit)*;
OctalIntegerLiteral  : '0' [oO] [0-7] ('_'? [0-7])*;
BinaryIntegerLiteral : '0' [bB] [01] ('_'? [01])*;

// Keywords
Operator    : 'operator';
Constructor : 'constructor';
If          : 'if';
Else        : 'else';
Break       : 'break';
While       : 'while';
For         : 'for';
Return      : 'return';
Continue    : 'continue';
Class       : 'class';

// Reserved (May be added)
Loop      : 'loop';
In        : 'in';
Is        : 'is';
Public    : 'public';
Pub       : 'pub';
Private   : 'private';
Protected : 'protected';
Final     : 'final';
Static    : 'static';
Abstract  : 'abstract';
Override  : 'override';

// Soft keywords


// Identifiers
Identifier              : IdentifierStart IdentifierPart*;
IdentifierOrSoftKeyword : Identifier | Get | Set | Field;

// Strings
CharacterLiteral                : '\'' (UnicodeEscapeSequence | SingleStringCharacter) '\'';
DoubleQuoteStringStart          : '"'   -> pushMode(DoubleQuoteStringMode);
MultiLineDoubleQuoteStringStart : '"""' -> pushMode(MultiLineDoubleQuoteStringMode);

// Section: Inside strings
mode DoubleQuoteStringMode;
DoubleQuoteStringEnd         : '"' -> popMode;
DoubleQuoteStringRef         : FieldIdentifier;
DoubleQuoteStringText        : DoubleStringCharacter+ | '$'; // TODO: Dollar signs are handled by the ...
DoubleQuoteStringEscapedChar : EscapeSequence;
DoubleQuoteStringExprStart   : '${' -> pushMode(DEFAULT_MODE);

mode MultiLineDoubleQuoteStringMode;
MultiLineDoubleQuoteStringEnd         : '"""' -> popMode;
MultiLineDoubleQuoteStringRef         : FieldIdentifier;
MultiLineDoubleQuoteStringText        : DoubleStringCharacter+ | '$';
MultiLineDoubleQuoteStringEscapedChar : EscapeSequence;
MultiLineDoubleQuoteStringExprStart   : '${'           -> pushMode(DEFAULT_MODE);
MultiLineDoubleQuoteStringNewLine     : LineTerminator -> skip;

// Fragments: Numeric
fragment DecimalIntegerLiteral : [1-9] ('_'? [0-9])*;
fragment DecimalDigitsLiteral  : [0-9] ('_'? [0-9])*;
fragment ExponentPart          : [eE] [+-]? [0-9] ('_'? [0-9])*;
fragment HexDigit              : [0-9a-fA-F];

// Fragments: Identifier
fragment IdentifierPart  : IdentifierStart | [\p{Mn}] | [\p{Nd}] | [\p{Pc}] | '\u200C' | '\u200D';
fragment IdentifierStart : [\p{L}] | [$_];

// Fragments: String
fragment DoubleStringCharacter : ~["\\\r\n$];
fragment SingleStringCharacter : ~['\\\r\n$];
fragment EscapeSequence        : UnicodeEscapeSequence | EscapedIdentifier;
fragment UnicodeEscapeSequence : 'u' HexDigit HexDigit HexDigit HexDigit;
fragment EscapedIdentifier     : '\\' [tbrn\\"'$];
fragment FieldIdentifier       : '$' Identifier;