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