/* ============================================================
La clase Simbolo es una estructura de datos diseñada para el 
almacenamiento de metadatos de los identificadores. A diferencia del Entorno,
que gestiona valores en tiempo de ejecución, este módulo se encarga de 
recolectar la información necesaria para generar el reporte de la Tabla de Símbolos
   ============================================================ */

class Simbolo {
    constructor(id, tipoSimbolo, tipoDato, ambito, linea, columna) {
        this.id = id;
        this.tipoSimbolo = tipoSimbolo;
        this.tipoDato = tipoDato;
        this.ambito = ambito;
        this.linea = linea;
        this.columna = columna;
    }
}

const listaSimbolos = [];

module.exports = {
    Simbolo,
    listaSimbolos
};