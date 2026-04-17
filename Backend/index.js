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
    try {
        console.log("Iniciando análisis...");
        const ast = parser.parse(req.body.codigo);
        console.log("Análisis terminado con éxito");
        res.json({ ast, errores: listaErrores });
    } catch (e) {
        console.log("¡ERROR DETECTADO!");
        console.log(e.stack); // Esto te dirá exactamente en qué línea de qué archivo falló
        res.status(500).json({ mensaje: "Error fatal", detalle: e.message });
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
