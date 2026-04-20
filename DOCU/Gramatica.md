<programa> ::= <declaraciones_globales> <EOF>

<declaraciones_globales> ::= <declaraciones_globales> <declaracion_global>
                           | ε

<declaracion_global> ::= <decl_variable> <terminador>
                       | <decl_constante> <terminador>
                       | <decl_funcion>
                       | <func_main>
                       | <decl_struct>
                       | <NL>
                       | error <terminador>

<terminador> ::= ";" | <NL>

<func_main> ::= "func" "main" "(" ")" <bloque>

<decl_struct> ::= "struct" <ID> "{" <campos_struct> "}"

<campos_struct> ::= <campos_struct> <campo_struct>
                  | <campo_struct>

<campo_struct> ::= <tipo> <ID> ";" 
                 | <tipo> <ID> <NL>

<tipo> ::= "int" | "float64" | "string" | "bool" | "rune"
         | "[" "]" <tipo>
         | <ID>

<decl_variable> ::= "var" <ID> <tipo> "=" <expresion>
                  | "var" <ID> <tipo>
                  | "var" <ID> "=" <expresion>
                  | <ID> ":=" <expresion>
                  | <ID> <ID> "=" "{" <lista_campos_instancia> "}"

<decl_constante> ::= "const" <ID> <tipo> "=" <expresion>
                   | "const" <ID> "=" <expresion>

<decl_funcion> ::= "func" <ID> "(" <parametros> ")" <tipo> <bloque>
                 | "func" <ID> "(" <parametros> ")" <bloque>

<parametros> ::= <lista_parametros> | ε

<lista_parametros> ::= <lista_parametros> "," <parametro>
                     | <parametro>

<parametro> ::= <ID> <tipo>

<bloque> ::= "{" <sentencias> "}"

<sentencias> ::= <sentencias> <sentencia_bloque>
               | ε

<sentencia_bloque> ::= <sentencia_if>
                     | <sentencia_for>
                     | <sentencia_switch>
                     | <bloque>
                     | <decl_variable> <terminador>
                     | <decl_constante> <terminador>
                     | <asignacion> <terminador>
                     | <sentencia_return> <terminador>
                     | <sentencia_break> <terminador>
                     | <sentencia_continue> <terminador>
                     | <ID> "++" <terminador>
                     | <ID> "--" <terminador>
                     | <expresion> <terminador>
                     | <NL>
                     | error <terminador>

<asignacion> ::= <ID> "=" <expresion>
               | <ID> "+=" <expresion>
               | <ID> "-=" <expresion>
               | <ID> "*=" <expresion>
               | <ID> "/=" <expresion>
               | <ID> "%=" <expresion>
               | <acceso_indexado> "=" <expresion>
               | <acceso_atributo> "=" <expresion>

<sentencia_if> ::= "if" <expresion> <bloque>
                 | "if" <expresion> <bloque> "else" <bloque>
                 | "if" <expresion> <bloque> "else" <sentencia_if>

<sentencia_for> ::= "for" <expresion> <bloque>
                  | "for" <sentencia_for_init> ";" <expresion> ";" <sentencia_for_post> <bloque>
                  | "for" <ID> "," <ID> ":=" "range" <expresion> <bloque>
                  | "for" <ID> ":=" "range" <expresion> <bloque>

<sentencia_for_init> ::= <decl_variable> | <asignacion> | ε
<sentencia_for_post> ::= <asignacion> | <ID> "++" | <ID> "--" | ε

<sentencia_switch> ::= "switch" <expresion> "{" <lista_cases> "}"

<lista_cases> ::= <lista_cases> <caso_switch>
                | ε

<caso_switch> ::= "case" <expresion> ":" <sentencias_case>
                | "default" ":" <sentencias_case>

<sentencias_case> ::= <sentencias_case> <sentencia_bloque_case>
                    | ε

<sentencia_bloque_case> ::= <sentencia_if>
                          | <sentencia_for>
                          | <sentencia_switch>
                          | <bloque>
                          | <decl_variable> <terminador>
                          | <decl_constante> <terminador>
                          | <asignacion> <terminador>
                          | <sentencia_return> <terminador>
                          | <sentencia_break> <terminador>
                          | <sentencia_continue> <terminador>
                          | <expresion> <terminador>
                          | <NL>

<sentencia_return> ::= "return" <expresion> | "return"
<sentencia_break> ::= "break"
<sentencia_continue> ::= "continue"

<llamada_funcion> ::= <ID> "(" <argumentos> ")"
                    | "fmt" "." "Println" "(" <argumentos> ")"
                    | "fmt" "." "Print" "(" <argumentos> ")"
                    | "strconv" "." "Atoi" "(" <expresion> ")"
                    | "strconv" "." "ParseFloat" "(" <expresion> ")"
                    | "reflect" "." "TypeOf" "(" <expresion> ")"
                    | "slices" "." "Index" "(" <expresion> "," <expresion> ")"
                    | "strings" "." "Join" "(" <expresion> "," <expresion> ")"
                    | "len" "(" <expresion> ")"
                    | "append" "(" <expresion> "," <expresion> ")"

<argumentos> ::= <lista_argumentos> | ε
<lista_argumentos> ::= <lista_argumentos> "," <expresion>
                     | <expresion>

<expresion> ::= <expresion> "||" <expresion>
              | <expresion> "&&" <expresion>
              | <expresion> "==" <expresion>
              | <expresion> "!=" <expresion>
              | <expresion> "<" <expresion>
              | <expresion> ">" <expresion>
              | <expresion> "<=" <expresion>
              | <expresion> ">=" <expresion>
              | <expresion> "+" <expresion>
              | <expresion> "-" <expresion>
              | <expresion> "*" <expresion>
              | <expresion> "/" <expresion>
              | <expresion> "%" <expresion>
              | "-" <expresion>
              | "!" <expresion>
              | "(" <expresion> ")"
              | <llamada_funcion>
              | <acceso_indexado>
              | <acceso_atributo>
              | <literal_slice>
              | <LIT_INT>
              | <LIT_FLOAT>
              | <LIT_STRING>
              | <LIT_RUNE>
              | "true"
              | "false"
              | "nil"
              | <ID>

<acceso_indexado> ::= <ID> "[" <expresion> "]"
                    | <acceso_indexado> "[" <expresion> "]"
                    | <acceso_atributo> "[" <expresion> "]"

<acceso_atributo> ::= <ID> "." <ID>
                    | <acceso_indexado> "." <ID>
                    | <acceso_atributo> "." <ID>

<literal_slice> ::= "[" "]" <tipo> "{" <lista_elementos_slice> "}"
                  | "[" "]" <tipo> "{}"

<lista_elementos_slice> ::= <lista_elementos_slice> "," <elemento_slice>
                          | <elemento_slice>

<elemento_slice> ::= "{" <lista_expresiones> "}"
                   | "{}"
                   | <expresion>

<lista_expresiones> ::= <lista_expresiones> "," <expresion>
                      | <expresion>

<lista_campos_instancia> ::= <lista_campos_instancia> "," <campo_instancia>
                           | <campo_instancia>

<campo_instancia> ::= <ID> ":" <expresion>