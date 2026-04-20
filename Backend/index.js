const express = require('express');
const cors = require('cors');
const parser = require('./Lenguaje/Parser'); // Tu parser de Jison
const { listaErrores, limpiarErrores } = require('./Util/Errores');
const { generarHTMLReporte } = require('./Util/Reportes');
const { listaSimbolos } = require('./Util/TablaSimbolos');
const interprete = require('./Lenguaje/Interprete');

// NUEVO
const { generarDOT } = require('./Util/GeneradorAST');

// nuevo
let ultimoAST = null; // Variable para persistir el árbol


const app = express();
app.use(cors()); // Permite comunicación con React
app.use(express.json()); // Permite leer JSON en las peticiones

// RUTA PARA ANALIZAR
app.post('/analizar', (req, res) => {
    const { codigo } = req.body;
    try {
        const ast = parser.parse(codigo); // Ejecuta el parser
        ultimoAST = ast; // <--- ¡ESTA LÍNEA ES LA QUE FALTA!
        
        console.log("AST guardado correctamente"); // Agrega este log para estar seguro
        res.json({ ast, errores: listaErrores });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});




app.get('/reporte-ast', (req, res) => {
    if (!ultimoAST) {
        return res.send("<h1>No hay un AST generado. Por favor, ejecuta el código primero.</h1>");
    }

    const dot = generarDOT(ultimoAST);
    const dotSeguro = dot.replace(/\\/g, "\\\\").replace(/`/g, "\\`").replace(/\$/g, "\\$");
    

    const html = `
        <html>
            <head>
                <title>Reporte AST</title>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/viz.js/2.1.2/viz.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/viz.js/2.1.2/full.render.js"></script>
            </head>
            <body style="background-color: #f8f9fa; font-family: sans-serif; text-align: center;">
                <h2>Árbol de Sintaxis Abstracta (AST)</h2>
                <div id="graph" style="margin-top: 20px;"></div>
                <script>
                    var viz = new Viz();
                    viz.renderSVGElement(\`${dotSeguro}\`)
                    .then(element => {
                        document.getElementById('graph').appendChild(element);
                    })
                    .catch(error => {
                        console.error(error);
                        document.getElementById('graph').innerHTML = "Error al renderizar el AST";
                    });
                </script>
            </body>
        </html>
    `;
    res.send(html);
});





// RUTA PARA LOS REPORTES
// Ruta para Errores
app.get('/reporte-errores', (req, res) => {
    const { listaErrores } = require('./Util/Errores');
    const { generarHTMLReporte } = require('./Util/Reportes');
    
    const html = generarHTMLReporte('ERRORES', listaErrores);
    res.send(html);
});

// Ruta para Símbolos
app.get('/reporte-tabla', (req, res) => {
    const { listaSimbolos } = require('./Util/TablaSimbolos');
    const { generarHTMLReporte } = require('./Util/Reportes');
    
    const html = generarHTMLReporte('SIMBOLOS', listaSimbolos);
    res.send(html);
});

app.listen(4000, () => console.log("🚀 Servidor Backend en http://localhost:4000"));


// camvios 
// cambios
// cambioss


// funciona 
// funciona