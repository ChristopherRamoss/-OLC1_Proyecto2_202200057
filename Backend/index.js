const express = require('express');
const cors = require('cors');
const parser = require('./Lenguaje/Parser'); // Tu parser de Jison
const { listaErrores, limpiarErrores } = require('./Util/Errores');
const { generarHTMLReporte } = require('./Util/Reportes');
const { listaSimbolos } = require('./Util/TablaSimbolos');

const app = express();
app.use(cors()); // Permite comunicación con React
app.use(express.json()); // Permite leer JSON en las peticiones

// RUTA PARA ANALIZAR
app.post('/analizar', (req, res) => {
    const { codigo } = req.body;
    limpiarErrores(); 
    // Aquí podrías limpiar también la lista de símbolos
    
    try {
        const ast = parser.parse(codigo);
        // IMPORTANTE: Aquí recorrerás el AST después para llenar listaSimbolos
        res.json({ mensaje: "Análisis finalizado", ast, errores: listaErrores });
    } catch (e) {
        res.status(400).json({ mensaje: "Error fatal", error: e.message, errores: listaErrores });
    }
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
