const Entorno = require('../Util/Entorno');

class Interprete {
    constructor() {
        this.consola = ""; // Aquí se guardará lo que imprima Println
    }

    ejecutar(ast) {
        const entornoGlobal = new Entorno();
        this.consola = "";
        
        try {
            this.recorrer(ast, entornoGlobal);
            return this.consola;
        } catch (error) {
            return `Error en ejecución: ${error.message}`;
        }
    }

    recorrer(nodo, entorno) {
        if (!nodo) return;

        if (Array.isArray(nodo)) {
            nodo.forEach(item => {
                if (item) this.recorrer(item, entorno);
            });
            return;
        }

        switch (nodo.tipo) {
            case 'decl_var':
                const valor = this.evaluarExpresion(nodo.valor, entorno);
                entorno.guardar(nodo.nombre, valor, nodo.tipoDato);
                
                // --- LOG AUTOMÁTICO ---
                this.consola += `> Declaración: variable '${nodo.nombre}' inicializada con valor: ${valor}\n`;
                break;

            case 'asignacion':
                const nuevoValor = this.evaluarExpresion(nodo.valor, entorno);
                // Buscamos si existe para actualizarla
                let sim = entorno.obtener(nodo.nombre);
                if (sim) {
                    sim.valor = nuevoValor;
                    this.consola += `> Asignación: variable '${nodo.nombre}' cambió a: ${nuevoValor}\n`;
                } else {
                    throw new Error(`Semántico: La variable '${nodo.nombre}' no existe.`);
                }
                break;

            case 'llamada':
                if (nodo.nombre === 'fmt.Println' || nodo.nombre === 'fmt.Print') {
                    const valores = nodo.args.map(arg => this.evaluarExpresion(arg, entorno));
                    // Imprimimos el resultado real del usuario
                    this.consola += "SALIDA: " + valores.join(" ") + (nodo.nombre === 'fmt.Println' ? "\n" : "");
                }
                break;

            case 'func_main':
                this.consola += "--- Iniciando ejecución de main ---\n";
                this.recorrer(nodo.cuerpo.cuerpo, entorno);
                this.consola += "--- Fin de ejecución ---\n";
                break;

            // Si tienes sentencias IF, puedes agregar logs también:
            case 'if':
                const cond = this.evaluarExpresion(nodo.condicion, entorno);
                this.consola += `> Evaluando IF: condición es ${cond}\n`;
                if (cond) {
                    this.recorrer(nodo.entonces.cuerpo, entorno);
                } else if (nodo.sino) {
                    this.recorrer(nodo.sino.cuerpo || nodo.sino, entorno);
                }
                break;
        }
    }

    evaluarExpresion(exp, entorno) {
        if (!exp) return null;

        switch (exp.tipo) {
            case 'lit_int': return exp.valor;
            case 'lit_string': return exp.valor.replace(/"/g, ''); // Quitar comillas
            case 'lit_bool': return exp.valor;
            case 'id':
                const sim = entorno.obtener(exp.nombre);
                if (sim) return sim.valor;
                throw new Error(`Variable ${exp.nombre} no definida`);
            case 'op_bin':
                const izq = this.evaluarExpresion(exp.izq, entorno);
                const der = this.evaluarExpresion(exp.der, entorno);
                if (exp.op === '+') return izq + der;
                if (exp.op === '-') return izq - der;
                if (exp.op === '*') return izq * der;
                if (exp.op === '/') return izq / der;
                // ... agregar más operadores relacionales aquí
            default:
                return null;
        }
    }
}

module.exports = new Interprete();