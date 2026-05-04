/* ============================================================
El módulo Errores implementa un patrón de recolección de excepciones. 
Centraliza las fallas detectadas en cualquier fase del análisis, 
almacenando metadatos como la ubicación exacta (línea y columna) para generar el reporte
   ============================================================ */


class ErrorCustom {         // Define si el error es lexico sintactico o semantico 
    constructor(tipo, descripcion, linea, columna) {
        this.tipo = tipo;
        this.descripcion = descripcion;
        this.linea = linea;
        this.columna = columna;
    }
}

const listaErrores = [];    // Aqui se van almacenar los errores que se vayan encontrando 

const agregarError = (tipo, desc, lin, col) => { // Es el método que llaman el Parser e Intérprete cada vez que encuentran un error
    listaErrores.push(new ErrorCustom(tipo, desc, lin, col));
};

const limpiarErrores = () => { listaErrores.length = 0; };


module.exports = {
    listaErrores,
    agregarError,
    limpiarErrores
};