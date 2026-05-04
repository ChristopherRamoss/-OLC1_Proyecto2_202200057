%{
    const { agregarError } = require('../Util/Errores');
%}


%lex

%%

[ \t\r]+            /* ignorar espacios y tabs */
\n+                 return 'NL';
";"                 return 'SEMICOLON';

"//"[^\n]*                  /* comentario de una línea */
"/*"[\s\S]*?"*/"            /* comentario multilínea */

"true"                      return 'TRUE';
"false"                     return 'FALSE';
"nil"                       return 'NIL';

"int"                       return 'T_INT';
"float64"                   return 'T_FLOAT64';
"string"                    return 'T_STRING';
"bool"                      return 'T_BOOL';
"rune"                      return 'T_RUNE';
"var"                       return 'VAR';
"const"                     return 'CONST';
"func"                      return 'FUNC';
"return"                    return 'RETURN';
"if"                        return 'IF';
"else"                      return 'ELSE';
"for"                       return 'FOR';
"break"                     return 'BREAK';
"continue"                  return 'CONTINUE';
"switch"                    return 'SWITCH';
"case"                      return 'CASE';
"default"                   return 'DEFAULT';
"struct"                    return 'STRUCT';
"range"                     return 'RANGE';
"main"                      return 'MAIN';
"fmt"                       return 'FMT';
"Println"                   return 'PRINTLN';
"println"                   return 'PRINTLN';
"Print"                     return 'PRINT';
"print"                     return 'PRINT';
"strconv"                   return 'STRCONV';
"Atoi"                      return 'ATOI';
"ParseFloat"                return 'PARSEFLOAT';
"reflect"                   return 'REFLECT';
"TypeOf"                    return 'TYPEOF';
"slices"                    return 'SLICES';
"Index"                     return 'INDEX';
"strings"                   return 'STRINGS';
"Join"                      return 'JOIN';
"append"                    return 'APPEND';
"len"                       return 'LEN';

[0-9]+"."[0-9]+([eE][+-]?[0-9]+)?   return 'LIT_FLOAT';
[0-9]+                               return 'LIT_INT';

\"(\\[\"\\nrt]|[^\"\\])*\"           return 'LIT_STRING';
\'(\\[\'\\nrt]|[^\\'\\])\'           return 'LIT_RUNE';

[a-zA-Z_][a-zA-Z0-9_]*              return 'ID';

"++"                        return 'INC';
"--"                        return 'DEC';
"+"                         return 'PLUS';
"-"                         return 'MINUS';
"*"                         return 'TIMES';
"/"                         return 'DIVIDE';
"%"                         return 'MOD';

":="                        return 'DECL_ASSIGN';
"+="                        return 'PLUS_ASSIGN';
"-="                        return 'MINUS_ASSIGN';
"*="                        return 'TIMES_ASSIGN';
"/="                        return 'DIVIDE_ASSIGN';
"%="                        return 'MOD_ASSIGN';
"="                         return 'ASSIGN';

"=="                        return 'EQ';
"!="                        return 'NEQ';
"<="                        return 'LTE';
">="                        return 'GTE';
"<"                         return 'LT';
">"                         return 'GT';

"&&"                        return 'AND';
"||"                        return 'OR';
"!"                         return 'NOT';

"("                         return 'LPAREN';
")"                         return 'RPAREN';
"{"                         return 'LBRACE';
"}"                         return 'RBRACE';
"["                         return 'LBRACKET';
"]"                         return 'RBRACKET';
","                         return 'COMMA';
"."                         return 'DOT';
":"                         return 'COLON';

<<EOF>>                     return 'EOF';

.   {
    agregarError("Léxico", `El símbolo ${yytext} no es reconocido`, yylloc.first_line, yylloc.first_column);
}

/lex

/* ============================================================
   PRECEDENCIA — de menor a mayor
   ============================================================ */
%right      ASSIGN DECL_ASSIGN PLUS_ASSIGN MINUS_ASSIGN TIMES_ASSIGN DIVIDE_ASSIGN MOD_ASSIGN
%left       OR
%left       AND
%left       EQ NEQ
%left       LT GT LTE GTE
%left       PLUS MINUS
%left       TIMES DIVIDE MOD
%right      UMINUS NOT
%left       INC DEC
%left       DOT
%left       LBRACKET RBRACKET
%left       LPAREN RPAREN

%start programa

%%

/* ── Programa ─────────────────────────────────────────────── */
programa
    : declaraciones_globales EOF  { return $1; }
    ;

/* ── NL opcionales ───────────────────────────────────────── */
nl_opt
    : nl_opt NL  { $$ = null; }
    | /* vacío */ { $$ = null; }
    ;

/* ── Terminador ──────────────────────────────────────────── */
terminador
    : SEMICOLON
    | NL
    ;

/* ── Declaraciones globales ──────────────────────────────── */
declaraciones_globales
    : declaraciones_globales declaracion_global  { $1.push($2); $$ = $1; }
    | /* vacío */                                { $$ = []; }
    ;

declaracion_global
    : decl_variable terminador   { $$ = $1; }
    | decl_constante terminador  { $$ = $1; }
    | decl_funcion               { $$ = $1; }
    | func_main                  { $$ = $1; }
    | decl_struct                { $$ = $1; }
    | NL                         { $$ = null; }
    | error terminador           { $$ = null; }
    ;

/* ── func main ───────────────────────────────────────────── */
func_main
    : FUNC MAIN LPAREN RPAREN bloque
        { $$ = { tipo: 'func_main', cuerpo: $5 }; }
    ;

/* ── Structs ─────────────────────────────────────────────── */
decl_struct
    : STRUCT ID LBRACE nl_opt campos_struct RBRACE
        { $$ = { tipo: 'decl_struct', nombre: $2, campos: $5 }; }
    ;

campos_struct
    : campos_struct campo_struct  { $1.push($2); $$ = $1; }
    | campo_struct                { $$ = [$1]; }
    ;

campo_struct
    : tipo ID SEMICOLON nl_opt  { $$ = { tipoDato: $1, nombre: $2 }; }
    | tipo ID NL nl_opt         { $$ = { tipoDato: $1, nombre: $2 }; }
    ;

/* ── Tipos ───────────────────────────────────────────────── */
tipo
    : T_INT                  { $$ = 'int'; }
    | T_FLOAT64              { $$ = 'float64'; }
    | T_STRING               { $$ = 'string'; }
    | T_BOOL                 { $$ = 'bool'; }
    | T_RUNE                 { $$ = 'rune'; }
    | LBRACKET RBRACKET tipo { $$ = '[]' + $3; }
    | ID                     { $$ = $1; }
    ;

/* ── Declaración de variables ────────────────────────────── */
decl_variable
    : VAR ID tipo ASSIGN expresion
        {
            require('../Util/TablaSimbolos').listaSimbolos.push({
                id: $2, tipoSimbolo: 'Variable', tipoDato: $3,
                ambito: 'Global', linea: yylineno + 1, columna: @2.first_column
            });
            $$ = { tipo: 'decl_var', forma: 'explicita_valor', nombre: $2, tipoDato: $3, valor: $5 };
        }
    | VAR ID tipo
        {
            require('../Util/TablaSimbolos').listaSimbolos.push({
                id: $2, tipoSimbolo: 'Variable', tipoDato: $3,
                ambito: 'Global', linea: yylineno + 1, columna: @2.first_column
            });
            $$ = { tipo: 'decl_var', forma: 'explicita_sin_valor', nombre: $2, tipoDato: $3, valor: null };
        }
    | VAR ID ASSIGN expresion
        {
            require('../Util/TablaSimbolos').listaSimbolos.push({
                id: $2, tipoSimbolo: 'Variable', tipoDato: 'inferido',
                ambito: 'Global', linea: yylineno + 1, columna: @2.first_column
            });
            $$ = { tipo: 'decl_var', forma: 'explicita_valor', nombre: $2, tipoDato: null, valor: $4 };
        }
    | ID DECL_ASSIGN expresion
        {
            require('../Util/TablaSimbolos').listaSimbolos.push({
                id: $1, tipoSimbolo: 'Variable', tipoDato: 'inferido',
                ambito: 'Local', linea: yylineno + 1, columna: @1.first_column
            });
            $$ = { tipo: 'decl_var', forma: 'implicita', nombre: $1, tipoDato: null, valor: $3 };
        }
    | ID ID ASSIGN LBRACE nl_opt lista_campos_instancia COMMA nl_opt RBRACE
        {
            require('../Util/TablaSimbolos').listaSimbolos.push({
                id: $2, tipoSimbolo: 'Variable', tipoDato: $1,
                ambito: 'Local', linea: yylineno + 1, columna: @2.first_column
            });
            $$ = { tipo: 'decl_var', forma: 'struct_literal', tipoStruct: $1, nombre: $2, campos: $6 };
        }
    | ID ID ASSIGN LBRACE nl_opt lista_campos_instancia nl_opt RBRACE
        {
            require('../Util/TablaSimbolos').listaSimbolos.push({
                id: $2, tipoSimbolo: 'Variable', tipoDato: $1,
                ambito: 'Local', linea: yylineno + 1, columna: @2.first_column
            });
            $$ = { tipo: 'decl_var', forma: 'struct_literal', tipoStruct: $1, nombre: $2, campos: $6 };
        }
    | ID ID DECL_ASSIGN LBRACE nl_opt lista_campos_instancia COMMA nl_opt RBRACE
        {
            require('../Util/TablaSimbolos').listaSimbolos.push({
                id: $2, tipoSimbolo: 'Variable', tipoDato: $1,
                ambito: 'Local', linea: yylineno + 1, columna: @2.first_column
            });
            $$ = { tipo: 'decl_var', forma: 'struct_literal', tipoStruct: $1, nombre: $2, campos: $6 };
        }
    | ID ID DECL_ASSIGN LBRACE nl_opt lista_campos_instancia nl_opt RBRACE
        {
            require('../Util/TablaSimbolos').listaSimbolos.push({
                id: $2, tipoSimbolo: 'Variable', tipoDato: $1,
                ambito: 'Local', linea: yylineno + 1, columna: @2.first_column
            });
            $$ = { tipo: 'decl_var', forma: 'struct_literal', tipoStruct: $1, nombre: $2, campos: $6 };
        }
    ;

/* ── Constantes ──────────────────────────────────────────── */
decl_constante
    : CONST ID tipo ASSIGN expresion
        { $$ = { tipo: 'decl_const', nombre: $2, tipoDato: $3, valor: $5 }; }
    | CONST ID ASSIGN expresion
        { $$ = { tipo: 'decl_const', nombre: $2, tipoDato: null, valor: $4 }; }
    ;

/* ── Funciones ───────────────────────────────────────────── */
decl_funcion
    : FUNC ID LPAREN parametros RPAREN tipo bloque
        { $$ = { tipo: 'decl_func', nombre: $2, params: $4, retorno: $6, cuerpo: $7 }; }
    | FUNC ID LPAREN parametros RPAREN bloque
        { $$ = { tipo: 'decl_func', nombre: $2, params: $4, retorno: null, cuerpo: $6 }; }
    ;

parametros
    : lista_parametros  { $$ = $1; }
    | /* vacío */       { $$ = []; }
    ;

lista_parametros
    : lista_parametros COMMA parametro  { $1.push($3); $$ = $1; }
    | parametro                          { $$ = [$1]; }
    ;

parametro
    : ID tipo  { $$ = { nombre: $1, tipoDato: $2 }; }
    ;

/* ── Bloques ─────────────────────────────────────────────── */
bloque
    : LBRACE sentencias RBRACE  { $$ = { tipo: 'bloque', cuerpo: $2 }; }
    ;

sentencias
    : sentencias sentencia_bloque  { if($2 !== null) $1.push($2); $$ = $1; }
    | /* vacío */                  { $$ = []; }
    ;

sentencia_bloque
    : sentencia_if                         { $$ = $1; }
    | sentencia_for                        { $$ = $1; }
    | sentencia_switch                     { $$ = $1; }
    | bloque                               { $$ = $1; }
    | decl_variable terminador             { $$ = $1; }
    | decl_constante terminador            { $$ = $1; }
    | asignacion terminador                { $$ = $1; }
    | asignacion_indexada terminador       { $$ = $1; }
    | asignacion_atributo terminador       { $$ = $1; }
    | sentencia_return terminador          { $$ = $1; }
    | sentencia_break terminador           { $$ = $1; }
    | sentencia_continue terminador        { $$ = $1; }
    | ID INC terminador                    { $$ = { tipo: 'inc', nombre: $1 }; }
    | ID DEC terminador                    { $$ = { tipo: 'dec', nombre: $1 }; }
    | expresion terminador                 { $$ = $1; }
    | NL                                   { $$ = null; }
    | error terminador                     { $$ = null; }
    ;

/* ── Asignaciones simples (solo ID como lvalue) ──────────── */
asignacion
    : ID ASSIGN expresion
        { $$ = { tipo: 'asignacion', nombre: $1, valor: $3 }; }
    | ID PLUS_ASSIGN expresion
        { $$ = { tipo: 'asignacion_op', op: '+=', nombre: $1, valor: $3 }; }
    | ID MINUS_ASSIGN expresion
        { $$ = { tipo: 'asignacion_op', op: '-=', nombre: $1, valor: $3 }; }
    | ID TIMES_ASSIGN expresion
        { $$ = { tipo: 'asignacion_op', op: '*=', nombre: $1, valor: $3 }; }
    | ID DIVIDE_ASSIGN expresion
        { $$ = { tipo: 'asignacion_op', op: '/=', nombre: $1, valor: $3 }; }
    | ID MOD_ASSIGN expresion
        { $$ = { tipo: 'asignacion_op', op: '%=', nombre: $1, valor: $3 }; }
    ;

/* ── Asignaciones con lvalue indexado ────────────────────── */
asignacion_indexada
    : acceso_indexado ASSIGN expresion
        { $$ = { tipo: 'asignacion_indice', acceso: $1, valor: $3 }; }
    | acceso_indexado PLUS_ASSIGN expresion
        { $$ = { tipo: 'asignacion_op_indice', op: '+=', acceso: $1, valor: $3 }; }
    | acceso_indexado MINUS_ASSIGN expresion
        { $$ = { tipo: 'asignacion_op_indice', op: '-=', acceso: $1, valor: $3 }; }
    | acceso_indexado TIMES_ASSIGN expresion
        { $$ = { tipo: 'asignacion_op_indice', op: '*=', acceso: $1, valor: $3 }; }
    | acceso_indexado DIVIDE_ASSIGN expresion
        { $$ = { tipo: 'asignacion_op_indice', op: '/=', acceso: $1, valor: $3 }; }
    | acceso_indexado MOD_ASSIGN expresion
        { $$ = { tipo: 'asignacion_op_indice', op: '%=', acceso: $1, valor: $3 }; }
    ;

/* ── Asignaciones con lvalue de atributo ─────────────────── */
asignacion_atributo
    : acceso_atributo ASSIGN expresion
        { $$ = { tipo: 'asignacion_atributo', acceso: $1, valor: $3 }; }
    | acceso_atributo PLUS_ASSIGN expresion
        { $$ = { tipo: 'asignacion_op_atributo', op: '+=', acceso: $1, valor: $3 }; }
    | acceso_atributo MINUS_ASSIGN expresion
        { $$ = { tipo: 'asignacion_op_atributo', op: '-=', acceso: $1, valor: $3 }; }
    | acceso_atributo TIMES_ASSIGN expresion
        { $$ = { tipo: 'asignacion_op_atributo', op: '*=', acceso: $1, valor: $3 }; }
    | acceso_atributo DIVIDE_ASSIGN expresion
        { $$ = { tipo: 'asignacion_op_atributo', op: '/=', acceso: $1, valor: $3 }; }
    | acceso_atributo MOD_ASSIGN expresion
        { $$ = { tipo: 'asignacion_op_atributo', op: '%=', acceso: $1, valor: $3 }; }
    ;

/* ── IF ─────────────────────────────────────────────────── */
sentencia_if
    : IF expresion bloque
        { $$ = { tipo: 'if', condicion: $2, entonces: $3, sino: null }; }
    | IF expresion bloque ELSE bloque
        { $$ = { tipo: 'if', condicion: $2, entonces: $3, sino: $5 }; }
    | IF expresion bloque ELSE sentencia_if
        { $$ = { tipo: 'if', condicion: $2, entonces: $3, sino: $5 }; }
    ;

/* ── FOR ─────────────────────────────────────────────────── */
sentencia_for
    : FOR expresion bloque
        { $$ = { tipo: 'for_while', condicion: $2, cuerpo: $3 }; }
    | FOR sentencia_for_init SEMICOLON expresion SEMICOLON sentencia_for_post bloque
        { $$ = { tipo: 'for_clasico', init: $2, condicion: $4, post: $6, cuerpo: $7 }; }
    | FOR ID COMMA ID DECL_ASSIGN RANGE expresion bloque
        { $$ = { tipo: 'for_range', indice: $2, valor: $4, iterable: $7, cuerpo: $8 }; }
    | FOR ID DECL_ASSIGN RANGE expresion bloque
        { $$ = { tipo: 'for_range', indice: null, valor: $2, iterable: $5, cuerpo: $6 }; }
    ;

sentencia_for_init
    : decl_variable        { $$ = $1; }
    | asignacion           { $$ = $1; }
    | asignacion_indexada  { $$ = $1; }
    | asignacion_atributo  { $$ = $1; }
    | /* vacío */          { $$ = null; }
    ;

sentencia_for_post
    : asignacion           { $$ = $1; }
    | asignacion_indexada  { $$ = $1; }
    | asignacion_atributo  { $$ = $1; }
    | ID INC               { $$ = { tipo: 'inc', nombre: $1 }; }
    | ID DEC               { $$ = { tipo: 'dec', nombre: $1 }; }
    | /* vacío */          { $$ = null; }
    ;

/* ── SWITCH ──────────────────────────────────────────────── */
sentencia_switch
    : SWITCH expresion LBRACE nl_opt lista_cases RBRACE
        { $$ = { tipo: 'switch', expresion: $2, casos: $5 }; }
    ;

lista_cases
    : lista_cases caso_switch  { $1.push($2); $$ = $1; }
    | /* vacío */              { $$ = []; }
    ;

caso_switch
    : CASE expresion COLON sentencias_case
        { $$ = { tipo: 'case', valor: $2, cuerpo: $4 }; }
    | DEFAULT COLON sentencias_case
        { $$ = { tipo: 'default', cuerpo: $3 }; }
    ;

sentencias_case
    : sentencias_case sentencia_bloque_case  { if($2 !== null) $1.push($2); $$ = $1; }
    | /* vacío */                            { $$ = []; }
    ;

sentencia_bloque_case
    : sentencia_if                          { $$ = $1; }
    | sentencia_for                         { $$ = $1; }
    | sentencia_switch                      { $$ = $1; }
    | bloque                                { $$ = $1; }
    | decl_variable terminador              { $$ = $1; }
    | decl_constante terminador             { $$ = $1; }
    | asignacion terminador                 { $$ = $1; }
    | asignacion_indexada terminador        { $$ = $1; }
    | asignacion_atributo terminador        { $$ = $1; }
    | sentencia_return terminador           { $$ = $1; }
    | sentencia_break terminador            { $$ = $1; }
    | sentencia_continue terminador         { $$ = $1; }
    | expresion terminador                  { $$ = $1; }
    | NL                                    { $$ = null; }
    ;

/* ── Sentencias de control ───────────────────────────────── */
sentencia_return
    : RETURN expresion  { $$ = { tipo: 'return', valor: $2 }; }
    | RETURN            { $$ = { tipo: 'return', valor: null }; }
    ;

sentencia_break
    : BREAK  { $$ = { tipo: 'break' }; }
    ;

sentencia_continue
    : CONTINUE  { $$ = { tipo: 'continue' }; }
    ;

/* ── Llamadas a función ──────────────────────────────────── */
llamada_funcion
    : ID LPAREN argumentos RPAREN
        { $$ = { tipo: 'llamada', nombre: $1, args: $3 }; }
    | FMT DOT PRINTLN LPAREN argumentos RPAREN
        { $$ = { tipo: 'llamada', nombre: 'fmt.Println', args: $5 }; }
    | FMT DOT PRINT LPAREN argumentos RPAREN
        { $$ = { tipo: 'llamada', nombre: 'fmt.Print', args: $5 }; }
    | STRCONV DOT ATOI LPAREN expresion RPAREN
        { $$ = { tipo: 'llamada', nombre: 'strconv.Atoi', args: [$5] }; }
    | STRCONV DOT PARSEFLOAT LPAREN expresion RPAREN
        { $$ = { tipo: 'llamada', nombre: 'strconv.ParseFloat', args: [$5] }; }
    | REFLECT DOT TYPEOF LPAREN expresion RPAREN
        { $$ = { tipo: 'llamada', nombre: 'reflect.TypeOf', args: [$5] }; }
    | SLICES DOT INDEX LPAREN expresion COMMA expresion RPAREN
        { $$ = { tipo: 'llamada', nombre: 'slices.Index', args: [$5, $7] }; }
    | STRINGS DOT JOIN LPAREN expresion COMMA expresion RPAREN
        { $$ = { tipo: 'llamada', nombre: 'strings.Join', args: [$5, $7] }; }
    | LEN LPAREN expresion RPAREN
        { $$ = { tipo: 'llamada', nombre: 'len', args: [$3] }; }
    | APPEND LPAREN expresion COMMA expresion RPAREN
        { $$ = { tipo: 'llamada', nombre: 'append', args: [$3, $5] }; }
    ;

argumentos
    : lista_argumentos  { $$ = $1; }
    | /* vacío */       { $$ = []; }
    ;

lista_argumentos
    : lista_argumentos COMMA expresion  { $1.push($3); $$ = $1; }
    | expresion                          { $$ = [$1]; }
    ;

/* ── Expresiones ─────────────────────────────────────────── */
expresion
    : expresion OR expresion
        { $$ = { tipo: 'op_bin', op: '||', izq: $1, der: $3 }; }
    | expresion AND expresion
        { $$ = { tipo: 'op_bin', op: '&&', izq: $1, der: $3 }; }
    | expresion EQ expresion
        { $$ = { tipo: 'op_bin', op: '==', izq: $1, der: $3 }; }
    | expresion NEQ expresion
        { $$ = { tipo: 'op_bin', op: '!=', izq: $1, der: $3 }; }
    | expresion LT expresion
        { $$ = { tipo: 'op_bin', op: '<',  izq: $1, der: $3 }; }
    | expresion GT expresion
        { $$ = { tipo: 'op_bin', op: '>',  izq: $1, der: $3 }; }
    | expresion LTE expresion
        { $$ = { tipo: 'op_bin', op: '<=', izq: $1, der: $3 }; }
    | expresion GTE expresion
        { $$ = { tipo: 'op_bin', op: '>=', izq: $1, der: $3 }; }
    | expresion PLUS expresion
        { $$ = { tipo: 'op_bin', op: '+', izq: $1, der: $3 }; }
    | expresion MINUS expresion
        { $$ = { tipo: 'op_bin', op: '-', izq: $1, der: $3 }; }
    | expresion TIMES expresion
        { $$ = { tipo: 'op_bin', op: '*', izq: $1, der: $3 }; }
    | expresion DIVIDE expresion
        { $$ = { tipo: 'op_bin', op: '/', izq: $1, der: $3 }; }
    | expresion MOD expresion
        { $$ = { tipo: 'op_bin', op: '%', izq: $1, der: $3 }; }
    | MINUS expresion %prec UMINUS
        { $$ = { tipo: 'op_unario', op: '-', operando: $2 }; }
    | NOT expresion
        { $$ = { tipo: 'op_unario', op: '!', operando: $2 }; }
    | LPAREN expresion RPAREN  { $$ = $2; }
    | llamada_funcion          { $$ = $1; }
    | acceso_indexado          { $$ = $1; }
    | acceso_atributo          { $$ = $1; }
    | literal_slice            { $$ = $1; }
    | LIT_INT     { $$ = { tipo: 'lit_int',    valor: parseInt($1, 10) }; }
    | LIT_FLOAT   { $$ = { tipo: 'lit_float',  valor: parseFloat($1) }; }
    | LIT_STRING  { $$ = { tipo: 'lit_string', valor: $1 }; }
    | LIT_RUNE    { $$ = { tipo: 'lit_rune',   valor: $1 }; }
    | TRUE        { $$ = { tipo: 'lit_bool',   valor: true }; }
    | FALSE       { $$ = { tipo: 'lit_bool',   valor: false }; }
    | NIL         { $$ = { tipo: 'nil' }; }
    | ID          { $$ = { tipo: 'id',         nombre: $1 }; }
    ;

/* ── Acceso indexado ─────────────────────────────────────── */
acceso_indexado
    : ID LBRACKET expresion RBRACKET
        { $$ = { tipo: 'acceso_indice', objeto: { tipo: 'id', nombre: $1 }, indice: $3 }; }
    | acceso_indexado LBRACKET expresion RBRACKET
        { $$ = { tipo: 'acceso_indice', objeto: $1, indice: $3 }; }
    | acceso_atributo LBRACKET expresion RBRACKET
        { $$ = { tipo: 'acceso_indice', objeto: $1, indice: $3 }; }
    ;

/* ── Acceso a atributo ───────────────────────────────────── */
acceso_atributo
    : ID DOT ID
        { $$ = { tipo: 'acceso_atributo', objeto: { tipo: 'id', nombre: $1 }, campo: $3 }; }
    | acceso_indexado DOT ID
        { $$ = { tipo: 'acceso_atributo', objeto: $1, campo: $3 }; }
    | acceso_atributo DOT ID
        { $$ = { tipo: 'acceso_atributo', objeto: $1, campo: $3 }; }
    | llamada_funcion DOT ID
        { $$ = { tipo: 'acceso_atributo', objeto: $1, campo: $3 }; }
    ;

/* ── Literales de slice ─────────────────────────────────── */
literal_slice
    : LBRACKET RBRACKET tipo LBRACE nl_opt lista_elementos_slice COMMA nl_opt RBRACE
        { $$ = { tipo: 'lit_slice', tipoDato: $3, elementos: $6 }; }
    | LBRACKET RBRACKET tipo LBRACE nl_opt lista_elementos_slice nl_opt RBRACE
        { $$ = { tipo: 'lit_slice', tipoDato: $3, elementos: $6 }; }
    | LBRACKET RBRACKET tipo LBRACE nl_opt RBRACE
        { $$ = { tipo: 'lit_slice', tipoDato: $3, elementos: [] }; }
    ;

lista_elementos_slice
    : lista_elementos_slice COMMA nl_opt elemento_slice
        { $1.push($4); $$ = $1; }
    | elemento_slice
        { $$ = [$1]; }
    ;

elemento_slice
    : LBRACE lista_expresiones RBRACE
        { $$ = { tipo: 'fila_slice', elementos: $2 }; }
    | LBRACE RBRACE
        { $$ = { tipo: 'fila_slice', elementos: [] }; }
    | expresion
        { $$ = $1; }
    ;

lista_expresiones
    : lista_expresiones COMMA expresion  { $1.push($3); $$ = $1; }
    | expresion                           { $$ = [$1]; }
    ;

/* ── Instanciación de struct ─────────────────────────────── */
lista_campos_instancia
    : lista_campos_instancia COMMA nl_opt campo_instancia
        { $1.push($4); $$ = $1; }
    | campo_instancia
        { $$ = [$1]; }
    ;

campo_instancia
    : ID COLON expresion  { $$ = { campo: $1, valor: $3 }; }
    ;

%%

parser.parseError = function(str, hash) {
    agregarError("Sintáctico", `Error recuperable: ${str}`, hash.line, hash.loc.first_column);
};
