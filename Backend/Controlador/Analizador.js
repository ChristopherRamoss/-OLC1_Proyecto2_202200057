const parser = require('../Lenguaje/Parser');
const { limpiarErrores, listaErrores } = require('../Util/Errores');
const { generarHTMLReporte } = require('../Util/Reportes');

export const procesarEntrada = (codigo) => {
    limpiarErrores(); // Limpiar errores de ejecuciones anteriores
    
    try {
        const ast = parser.parse(codigo);
        // Aquí es donde en el futuro recorrerás el AST para llenar la Tabla de Símbolos
        
        return {
            success: true,
            ast: ast,
            errores: listaErrores
        };
    } catch (e) {
        // Errores fatales del parser
        return {
            success: false,
            error: e.message,
            errores: listaErrores
        };
    }
};