/* ============================================================
La clase Entorno implementa una estructura de lista enlazada para 
manejar los ámbitos del lenguaje. Su función es almacenar las 
variables en un Map y proporcionar un mecanismo de resolución de nombres 
que busca de forma ascendente desde el ámbito local hasta el global.
   ============================================================ */

class Entorno {
    constructor(padre = null) {
        this.variables = new Map(); // Es el diccionario donde guardas físicamente el nombre de la variable y su información
        this.padre = padre;
    }

    guardar(nombre, valor, tipo) {  // Aquí es donde guardas la variable en el entorno actual
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