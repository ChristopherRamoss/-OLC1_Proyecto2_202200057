// Analizador léxico
%lex
%%

\s+                   /* ignorar espacios */
[0-9]+\.[0-9]+        return 'TK_double';
[0-9]+                return 'TK_int';
<<EOF>>               return 'EOF';
/lex

// Analizador sintáctico
%start INICIO
%%

INICIO
    : LISTA EOF { return $1; }
    ;

LISTA
    : LISTA NUMERO { $$ = $1.concat([$2]); }
    | NUMERO       { $$ = [$1]; }
    ;

NUMERO
    : TK_int    { $$ = Number(yytext); }
    | TK_double { $$ = Number(yytext); }
    ;
