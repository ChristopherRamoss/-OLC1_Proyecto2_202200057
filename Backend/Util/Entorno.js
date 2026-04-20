class Entorno {
    constructor(padre = null) {
        this.variables = new Map(); // Guarda { nombre: {valor, tipo} }
        this.padre = padre;
    }

    guardar(nombre, valor, tipo) {
        this.variables.set(nombre, { valor, tipo });
    }

    obtener(nombre) {
        let actual = this;
        while (actual != null) {
            if (actual.variables.has(nombre)) return actual.variables.get(nombre);
            actual = actual.padre;
        }
        return null;
    }
}
module.exports = Entorno;