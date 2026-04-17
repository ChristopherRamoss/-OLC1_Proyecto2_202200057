class ErrorCustom {
    constructor(tipo, descripcion, linea, columna) {
        this.tipo = tipo;
        this.descripcion = descripcion;
        this.linea = linea;
        this.columna = columna;
    }
}

const listaErrores = [];

const agregarError = (tipo, desc, lin, col) => {
    listaErrores.push(new ErrorCustom(tipo, desc, lin, col));
};

const limpiarErrores = () => { listaErrores.length = 0; };

// CAMBIO AQUÍ: Usar module.exports
module.exports = {
    listaErrores,
    agregarError,
    limpiarErrores
};