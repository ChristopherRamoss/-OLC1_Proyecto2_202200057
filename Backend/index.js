// index.js
const express = require('express');
const cors    = require('cors');

const parser             = require('./Lenguaje/Parser');
const { interpretar }    = require('./Lenguaje/Interprete');
const { generarDOT }     = require('./Util/GeneradorAST');
const { generarHTMLReporte } = require('./Util/Reportes');
const { listaErrores, limpiarErrores } = require('./Util/Errores');
const { listaSimbolos }  = require('./Util/TablaSimbolos');

const app = express();
app.use(cors());
app.use(express.json());

let ultimoAST = null;

/* ── POST /analizar ────────────────────────────────────────
   Recibe el código fuente, lo parsea e interpreta.
   Devuelve: { salida, errores, ast }
   ──────────────────────────────────────────────────────── */
// cambios
// cambios
app.post('/analizar', (req, res) => {
    const { codigo } = req.body;

    // 1. Limpieza total de estados
    limpiarErrores();
    listaSimbolos.length = 0;
    ultimoAST = null;

    let ast = null;
    let salida = [];

    try {
        // Intentar parsear
        ast = parser.parse(codigo);
        ultimoAST = ast;
    } catch (e) {
        // SI FALLA EL PARSER:
        console.error("--- ERROR DE PARSEO ---");
        console.error(e.message); // Esto te dirá la línea exacta del error en tu consola de Node

        // Devolvemos un 400 (Bad Request) para que el Frontend sepa que falló la sintaxis
        return res.status(400).json({ 
            salida: ["Error sintáctico: Revisa la consola de errores"], 
            errores: listaErrores, 
            ast: null,
            mensaje: e.message 
        });
    }

    // 2. Interpretar el AST (Solo si el parser tuvo éxito)
    try {
        const resultado = interpretar(ast);
        salida = resultado.salida || [];
    } catch (e) {
        console.error("--- ERROR SEMÁNTICO/INTÉRPRETE ---");
        console.error(e);
        const { agregarError } = require('./Util/Errores');
        agregarError('Semántico', `Error en ejecución: ${e.message}`, 0, 0);
        salida.push("Error en la ejecución del intérprete.");
    }

    // Responder con éxito (200)
    res.json({ salida, errores: listaErrores, ast });
});

/* ── GET /reporte-ast ──────────────────────────────────── */
app.get('/reporte-ast', (req, res) => {
    if (!ultimoAST) {
        return res.send('<h1>No hay AST generado. Ejecuta el código primero.</h1>');
    }

    const dot = generarDOT(ultimoAST);
    const dotSeguro = dot
        .replace(/\\/g,  '\\\\')
        .replace(/`/g,   '\\`')
        .replace(/\$/g,  '\\$');

    const html = `
    <html>
      <head>
        <title>Reporte AST</title>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/viz.js/2.1.2/viz.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/viz.js/2.1.2/full.render.js"></script>
      </head>
      <body>
        <h2>Árbol de Sintaxis Abstracta (AST)</h2>
        <div id="graph"></div>
        <script>
          var viz = new Viz();
          viz.renderSVGElement(\`${dotSeguro}\`)
            .then(el => document.getElementById('graph').appendChild(el))
            .catch(err => {
              console.error(err);
              document.getElementById('graph').innerHTML = '<p style="color:red">Error al renderizar el AST</p>';
            });
        </script>
      </body>
    </html>`;

    res.send(html);
});

/* ── GET /reporte-errores ──────────────────────────────── */
app.get('/reporte-errores', (req, res) => {
    const html = generarHTMLReporte('ERRORES', listaErrores);
    res.send(html);
});

/* ── GET /reporte-tabla ────────────────────────────────── */
app.get('/reporte-tabla', (req, res) => {
    const html = generarHTMLReporte('SIMBOLOS', listaSimbolos);
    res.send(html);
});

app.listen(4000, () => console.log('🚀 Backend en http://localhost:4000'));