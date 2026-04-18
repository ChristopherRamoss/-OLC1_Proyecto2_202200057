%{
    const { agregarError } = require('../Util/Errores');
%}


%lex

%%

/* ── Espacios en blanco ─────────────────────────────────── */
// \s+                         /* ignorar espacios, tabs, saltos de línea */
[ \t\r]+            /* ignorar espacios y tabs */
\n+                 return 'NL'; // Ahora el enter es un token
";"                 return 'SEMICOLON';

/* ── Comentarios ────────────────────────────────────────── */
"//"[^\n]*                  /* comentario de una línea — ignorar */
"/*"[\s\S]*?"*/"            /* comentario multilínea — ignorar */

/* ── Literales booleanos ────────────────────────────────── */
"true"                      return 'TRUE';
"false"                     return 'FALSE';

/* ── Valor nulo ─────────────────────────────────────────── */
"nil"                       return 'NIL';

/* ── Palabras reservadas ────────────────────────────────── */
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
"while"                     return 'WHILE';
"break"                     return 'BREAK';
"continue"                  return 'CONTINUE';
"switch"                    return 'SWITCH';
"case"                      return 'CASE';
"default"                   return 'DEFAULT';
"struct"                    return 'STRUCT';
"range"                     return 'RANGE';         // nuevo
"interface"                 return 'INTERFACE';
"package"                   return 'PACKAGE';
"import"                    return 'IMPORT';
"fmt"                       return 'FMT';
"println"                   return 'PRINTLN';
"print"                     return 'PRINT';
"main"                      return 'MAIN';
"Println"                   return 'PRINTLN';
"Print"                     return 'PRINT';

/* ── Funciones embebidas nuevas (namespaces) ── */
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

/* ── Literales numéricos ─────────────────────────────────
   float64: dígitos, punto decimal obligatorio, exponente opcional
   int    : solo dígitos enteros                               */
[0-9]+"."[0-9]+([eE][+-]?[0-9]+)?   return 'LIT_FLOAT';
[0-9]+                               return 'LIT_INT';

/* ── Literales de cadena (string) ───────────────────────── 
   Soporta secuencias de escape: \" \\ \n \r \t             */
\"(\\[\"\\nrt]|[^\"\\])*\"           return 'LIT_STRING';

/* ── Literal de rune (carácter simple entre comillas simples) */
\'(\\[\'\\nrt]|[^\\'\\])\'           return 'LIT_RUNE';

/* ── Identificadores ────────────────────────────────────── 
   Inician con letra o guión bajo; siguen letras, dígitos o _ */
[a-zA-Z_][a-zA-Z0-9_]*              return 'ID';

/* ── Operadores aritméticos ─────────────────────────────── */
"++"                        return 'INC';
"--"                        return 'DEC';
"+"                         return 'PLUS';
"-"                         return 'MINUS';
"*"                         return 'TIMES';
"/"                         return 'DIVIDE';
"%"                         return 'MOD';

/* ── Operadores de asignación ───────────────────────────── */
":="                        return 'DECL_ASSIGN';
"+="                        return 'PLUS_ASSIGN';
"-="                        return 'MINUS_ASSIGN';
"*="                        return 'TIMES_ASSIGN';
"/="                        return 'DIVIDE_ASSIGN';
"%="                        return 'MOD_ASSIGN';
"="                         return 'ASSIGN';

/* ── Operadores relacionales ────────────────────────────── */
"=="                        return 'EQ';
"!="                        return 'NEQ';
"<="                        return 'LTE';
">="                        return 'GTE';
"<"                         return 'LT';
">"                         return 'GT';

/* ── Operadores lógicos ─────────────────────────────────── */
"&&"                        return 'AND';
"||"                        return 'OR';
"!"                         return 'NOT';

/* ── Delimitadores ──────────────────────────────────────── */
"("                         return 'LPAREN';
")"                         return 'RPAREN';
"{"                         return 'LBRACE';
"}"                         return 'RBRACE';
"["                         return 'LBRACKET';
"]"                         return 'RBRACKET';
";"                         return 'SEMICOLON';
","                         return 'COMMA';
"."                         return 'DOT';
":"                         return 'COLON';

/* ── Fin de entrada ─────────────────────────────────────── */
<<EOF>>                     return 'EOF';

/* ── Carácter no reconocido ─────────────────────────────── */
.                           return 'UNKNOWN';

// ... en la sección del Lexer ...
. { 
    agregarError("Léxico", `El símbolo ${yytext} no es reconocido`, yylloc.first_line, yylloc.first_column); 
}


/lex

/* ============================================================
   PRECEDENCIA Y ASOCIATIVIDAD
   (de menor a mayor precedencia — el último tiene mayor)
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
%left       LBRACKET RBRACKET          /* acceso a índices de slice */
%left       DOT                        /* acceso a atributo de struct */
%left       LPAREN RPAREN LBRACKET RBRACKET DOT

/* ============================================================
   REGLAS GRAMATICALES (Parser)
   ============================================================ */
%start programa

%%

/* ── Programa principal ─────────────────────────────────────
   El programa puede ser:
   a) Una función main (punto de entrada estándar GoScript)
   b) Declaraciones sueltas en ámbito global               */
programa
    : declaraciones_globales EOF
        { return $1; }
    ;

/* ── func main() — punto de entrada ─────────────────────── */
func_main
    : FUNC MAIN LPAREN RPAREN bloque
        { $$ = { tipo: 'func_main', cuerpo: $5 }; }
    ;

/* ── Declaraciones en ámbito global ─────────────────────── */
declaraciones_globales
    : declaraciones_globales declaracion_global { $1.push($2); $$ = $1; }
    | /* vacío */                               { $$ = []; }
    ;

terminador
    : SEMICOLON
    | NL
    ;


declaracion_global
    : decl_variable terminador   { $$ = $1; }
    | decl_constante terminador  { $$ = $1; }
    | decl_funcion              { $$ = $1; }
    | func_main                 { $$ = $1; }
    | decl_struct                { $$ = $1; }
    | NL                        { $$ = null; } // Ignorar líneas vacías globales
    | error terminador           { $$ = null; } // <--- RECUPERACIÓN GLOBAL
    ;

decl_struct
    : STRUCT ID LBRACE campos_struct RBRACE
        { $$ = { tipo: 'decl_struct', nombre: $2, campos: $4 }; }
    ;

campos_struct
    : campos_struct campo_struct  { $1.push($2); $$ = $1; }
    | campo_struct                { $$ = [$1]; }
    ;

campo_struct
    : tipo ID terminador
        { $$ = { tipoDato: $1, nombre: $2 }; }
    ;


/* ── Declaración de variables ───────────────────────────────
   Forma 1 (explícita con tipo y valor):  var nombre tipo = expr
   Forma 2 (explícita con tipo sin valor): var nombre tipo
   Forma 3 (implícita, inferencia):        nombre := expr       */
decl_variable
    : VAR ID tipo ASSIGN expresion
        { 
            require('../Util/TablaSimbolos').listaSimbolos.push({
                id: $2, 
                tipoSimbolo: 'Variable', 
                tipoDato: $3, 
                ambito: 'Global',
                linea: yylineno + 1, 
                columna: @2.first_column // <--- CAMBIA ESTO
            });
            $$ = { tipo: 'decl_var', forma: 'explicita_valor', nombre: $2, tipoDato: $3, valor: $5 }; 
        }
    | VAR ID tipo
        { 
            require('../Util/TablaSimbolos').listaSimbolos.push({
                id: $2, 
                tipoSimbolo: 'Variable', 
                tipoDato: $3, 
                ambito: 'Global',
                linea: yylineno + 1, 
                columna: @2.first_column // <--- CAMBIA ESTO
            });
            $$ = { tipo: 'decl_var', forma: 'explicita_sin_valor', nombre: $2, tipoDato: $3, valor: null }; 
        }
    | VAR ID ASSIGN expresion
        { 
            require('../Util/TablaSimbolos').listaSimbolos.push({
                id: $2, 
                tipoSimbolo: 'Variable', 
                tipoDato: 'inferido', 
                ambito: 'Global',
                linea: yylineno + 1, 
                columna: @2.first_column // <--- CAMBIA ESTO
            });
            $$ = { tipo: 'decl_var', forma: 'explicita_valor', nombre: $2, tipoDato: null, valor: $4 }; 
        }
    | ID DECL_ASSIGN expresion
        { 
            require('../Util/TablaSimbolos').listaSimbolos.push({
                id: $1, 
                tipoSimbolo: 'Variable', 
                tipoDato: 'inferido', 
                ambito: 'Local',
                linea: yylineno + 1, 
                columna: @1.first_column // <--- AQUÍ ES @1 porque ID es el primer elemento
            });
            $$ = { tipo: 'decl_var', forma: 'implicita', nombre: $1, tipoDato: null, valor: $3 }; 
        }

    | ID ID ASSIGN LBRACE lista_campos_instancia RBRACE
        {
            /* Persona p = { Nombre: "Alice", Edad: 25 } */
            require('../Util/TablaSimbolos').listaSimbolos.push({
                id: $2,
                tipoSimbolo: 'Variable',
                tipoDato: $1,
                ambito: 'Local',
                linea: yylineno + 1,
                columna: @2.first_column
            });
            $$ = { tipo: 'decl_var', forma: 'struct_literal', tipoStruct: $1, nombre: $2, campos: $5 };
        }
        ;

literal_slice
    : LBRACKET RBRACKET tipo LBRACE lista_expresiones RBRACE
        { $$ = { tipo: 'lit_slice', tipoDato: $3, elementos: $5 }; }
    | LBRACKET RBRACKET tipo LBRACE RBRACE
        { $$ = { tipo: 'lit_slice', tipoDato: $3, elementos: [] }; }
    ;


lista_filas_slice
    : lista_filas_slice COMMA fila_slice  { $1.push($3); $$ = $1; }
    | fila_slice                           { $$ = [$1]; }
    ;


fila_slice
    : LBRACE lista_expresiones RBRACE  { $$ = $2; }
    | LBRACE RBRACE                    { $$ = []; }
    ;


lista_expresiones
    : lista_expresiones COMMA expresion  { $1.push($3); $$ = $1; }
    | expresion                           { $$ = [$1]; }
    ;



lista_campos_instancia
    : lista_campos_instancia COMMA campo_instancia  { $1.push($3); $$ = $1; }
    | campo_instancia                                { $$ = [$1]; }
    ;

campo_instancia
    : ID COLON expresion  { $$ = { campo: $1, valor: $3 }; }
    ;

/* ── Declaración de constantes ──────────────────────────── */
decl_constante
    : CONST ID tipo ASSIGN expresion
        { $$ = { tipo: 'decl_const', nombre: $2, tipoDato: $3, valor: $5 }; }
    | CONST ID ASSIGN expresion
        { $$ = { tipo: 'decl_const', nombre: $2, tipoDato: null, valor: $4 }; }
    ;

/* ── Tipos de datos primitivos ──────────────────────────── */
tipo
    : T_INT      { $$ = 'int'; }
    | T_FLOAT64  { $$ = 'float64'; }
    | T_STRING   { $$ = 'string'; }
    | T_BOOL     { $$ = 'bool'; }
    | T_RUNE     { $$ = 'rune'; }
    | LBRACKET RBRACKET tipo    { $$ = '[]' + $3; }   /* cubre []int, [][]int, [][][]int … */
    | ID                        { $$ = $1; }            /* tipos struct por nombre */
    ;

/* ── Declaración de funciones ───────────────────────────── */
decl_funcion
    : FUNC ID LPAREN parametros RPAREN tipo bloque
        { $$ = { tipo: 'decl_func', nombre: $2, params: $4, retorno: $6, cuerpo: $7 }; }
    | FUNC ID LPAREN parametros RPAREN bloque
        { $$ = { tipo: 'decl_func', nombre: $2, params: $4, retorno: null, cuerpo: $6 }; }
    ;

parametros
    : lista_parametros
    | /* vacío */  { $$ = []; }
    ;

lista_parametros
    : lista_parametros COMMA parametro  { $$ = $1; $$.push($3); }
    | parametro                          { $$ = [$1]; }
    ;

parametro
    : ID tipo  { $$ = { nombre: $1, tipoDato: $2 }; }
    ;

/* ── Bloque de sentencias (4.1) ─────────────────────────────
   Delimitado por { }.
   Puede contener sentencias y bloques anidados independientes.
   Cada bloque define su propio ámbito léxico.              */
bloque
    : LBRACE sentencias RBRACE  { $$ = { tipo: 'bloque', cuerpo: $2 }; }
    ;

sentencias
    : sentencias sentencia_bloque { if($2) $1.push($2); $$ = $1; }
    | /* vacío */                 { $$ = []; }
    ;

/* Una sentencia dentro de un bloque puede ser:
   - una sentencia normal terminada en ;
   - un bloque independiente anidado { ... }  (4.1)         */

sentencia_bloque
    : sentencia terminador   { $$ = $1; }
    | bloque                { $$ = $1; } // Bloque independiente (4.1) sin terminador
    | NL                    { $$ = null; } // Ignorar líneas vacías internas
    | error terminador       { $$ = null; } // <--- RECUPERACIÓN LOCAL
    ;

/* ── Sentencias ─────────────────────────────────────────── */
sentencia
    : decl_variable
    | decl_constante
    | asignacion
    | sentencia_if
    | sentencia_for
    | sentencia_switch
    | sentencia_return
    | sentencia_break
    | sentencia_continue
    | expresion
    ;

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
    
    /* ── Asignación a índice de slice ── */
    | acceso_indexado ASSIGN expresion
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
    /* ── Asignación a atributo de struct ── */
    | acceso_atributo ASSIGN expresion
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



/* ── Sentencia if / else ────────────────────────────────── */
sentencia_if
    : IF expresion bloque
        { $$ = { tipo: 'if', condicion: $2, entonces: $3, sino: null }; }
    | IF expresion bloque ELSE bloque
        { $$ = { tipo: 'if', condicion: $2, entonces: $3, sino: $5 }; }
    | IF expresion bloque ELSE sentencia_if
        { $$ = { tipo: 'if', condicion: $2, entonces: $3, sino: $5 }; }
    ;

/* ── Sentencia for ──────────────────────────────────────── */
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
    : decl_variable
    | asignacion
    | /* vacío */  { $$ = null; }
    ;

sentencia_for_post
    : asignacion
    | ID INC  { $$ = { tipo: 'inc', nombre: $1 }; }
    | ID DEC  { $$ = { tipo: 'dec', nombre: $1 }; }
    | /* vacío */  { $$ = null; }
    ;

/* ── Sentencias swich ──────────────────────────────── */
sentencia_switch
    : SWITCH expresion LBRACE lista_cases RBRACE
        { $$ = { tipo: 'switch', expresion: $2, casos: $4 }; }
    ;

lista_cases
    : lista_cases caso_switch  { $1.push($2); $$ = $1; }
    | /* vacío */               { $$ = []; }
    ;

caso_switch
    : CASE expresion COLON sentencias
        { $$ = { tipo: 'case', valor: $2, cuerpo: $4 }; }
    | DEFAULT COLON sentencias
        { $$ = { tipo: 'default', cuerpo: $3 }; }
    ;



/* ── Sentencias de control ──────────────────────────────── */
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

/* ── Llamada a función ──────────────────────────────────── */
llamada_funcion
    : ID LPAREN argumentos RPAREN
        { $$ = { tipo: 'llamada', nombre: $1, args: $3 }; }
    | FMT DOT PRINTLN LPAREN argumentos RPAREN
        { $$ = { tipo: 'llamada', nombre: 'fmt.Println', args: $5 }; }
    | FMT DOT PRINT LPAREN argumentos RPAREN
        { $$ = { tipo: 'llamada', nombre: 'fmt.Print', args: $5 }; }

    /* ── strconv ── */
    | STRCONV DOT ATOI LPAREN expresion RPAREN
        { $$ = { tipo: 'llamada', nombre: 'strconv.Atoi', args: [$5] }; }
    | STRCONV DOT PARSEFLOAT LPAREN expresion RPAREN
        { $$ = { tipo: 'llamada', nombre: 'strconv.ParseFloat', args: [$5] }; }
    /* ── reflect ── */
    | REFLECT DOT TYPEOF LPAREN expresion RPAREN
        { $$ = { tipo: 'llamada', nombre: 'reflect.TypeOf', args: [$5] }; }
    /* ── slices ── */
    | SLICES DOT INDEX LPAREN expresion COMMA expresion RPAREN
        { $$ = { tipo: 'llamada', nombre: 'slices.Index', args: [$5, $7] }; }
    /* ── strings ── */
    | STRINGS DOT JOIN LPAREN expresion COMMA expresion RPAREN
        { $$ = { tipo: 'llamada', nombre: 'strings.Join', args: [$5, $7] }; }
    /* ── len y append ── */
    | LEN LPAREN expresion RPAREN
        { $$ = { tipo: 'llamada', nombre: 'len', args: [$3] }; }
    | APPEND LPAREN expresion COMMA expresion RPAREN
        { $$ = { tipo: 'llamada', nombre: 'append', args: [$3, $5] }; }
    ;




argumentos
    : lista_argumentos  { $$ = $1; }
    | /* vacío */        { $$ = []; }
    ;

lista_argumentos
    : lista_argumentos COMMA expresion  { $$ = $1; $$.push($3); }
    | expresion                          { $$ = [$1]; }
    ;

/* ── Expresiones (4.2 — signos de agrupación incluidos) ────
   La regla  LPAREN expresion RPAREN  implementa la agrupación.
   Las precedencias declaradas arriba garantizan que
   3 - (1 + 3) * 32 / 90  se evalúe correctamente.         */
expresion
    /* Operadores lógicos */
    : expresion OR expresion
        { $$ = { tipo: 'op_bin', op: '||', izq: $1, der: $3 }; }
    | expresion AND expresion
        { $$ = { tipo: 'op_bin', op: '&&', izq: $1, der: $3 }; }
    /* Operadores relacionales */
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
    /* Operadores aritméticos */
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
    /* Operadores unarios */
    | MINUS expresion %prec UMINUS
        { $$ = { tipo: 'op_unario', op: '-', operando: $2 }; }
    | NOT expresion
        { $$ = { tipo: 'op_unario', op: '!', operando: $2 }; }
    /* Incremento / decremento como expresión */
    | ID INC  { $$ = { tipo: 'inc', nombre: $1 }; }
    | ID DEC  { $$ = { tipo: 'dec', nombre: $1 }; }
    /* Agrupación (4.2) — paréntesis cambian precedencia */
    | LPAREN expresion RPAREN  { $$ = $2; }
    /* Llamada a función como expresión */
    | llamada_funcion

    /* Acceso a elemento de slice: arr[i], mat[i][j] */
    | acceso_indexado          { $$ = $1; }
    /* Acceso a atributo de struct: obj.Campo */
    | acceso_atributo          { $$ = $1; }
    /* Literal de slice: []int{1,2,3} */
    | literal_slice            { $$ = $1; }
    
    /* Literales y terminales */
    | LIT_INT     { $$ = { tipo: 'lit_int',    valor: parseInt($1, 10) }; }
    | LIT_FLOAT   { $$ = { tipo: 'lit_float',  valor: parseFloat($1) }; }
    | LIT_STRING  { $$ = { tipo: 'lit_string', valor: $1 }; }
    | LIT_RUNE    { $$ = { tipo: 'lit_rune',   valor: $1 }; }
    | TRUE        { $$ = { tipo: 'lit_bool',   valor: true }; }
    | FALSE       { $$ = { tipo: 'lit_bool',   valor: false }; }
    | NIL         { $$ = { tipo: 'nil' }; }
    | ID          { $$ = { tipo: 'id',         nombre: $1 }; }

    ;

acceso_indexado
    : ID LBRACKET expresion RBRACKET
        { $$ = { tipo: 'acceso_indice', objeto: { tipo: 'id', nombre: $1 }, indice: $3 }; }
    | acceso_indexado LBRACKET expresion RBRACKET
        { $$ = { tipo: 'acceso_indice', objeto: $1, indice: $3 }; }
    | acceso_atributo LBRACKET expresion RBRACKET
        { $$ = { tipo: 'acceso_indice', objeto: $1, indice: $3 }; }
    ;


/* -----------------------------------------------------------
   2.7  acceso_atributo — NUEVA regla
   Maneja obj.Campo y obj.Campo.SubCampo.
   ----------------------------------------------------------- */
acceso_atributo
    : ID DOT ID
        { $$ = { tipo: 'acceso_atributo', objeto: { tipo: 'id', nombre: $1 }, campo: $3 }; }
    | acceso_indexado DOT ID
        { $$ = { tipo: 'acceso_atributo', objeto: $1, campo: $3 }; }
    | acceso_atributo DOT ID
        { $$ = { tipo: 'acceso_atributo', objeto: $1, campo: $3 }; }
    ;


%%



// Al final del archivo .jison
parser.parseError = function(str, hash) {
    agregarError("Sintáctico", `Error recuperable: ${str}`, hash.line, hash.loc.first_column);
};



// modificaciones
// modificaciones
// modificaciones
// modificaciones
// modificaciones
// modificaciones
// modificaciones