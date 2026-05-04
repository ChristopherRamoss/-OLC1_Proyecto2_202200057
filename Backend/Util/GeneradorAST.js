/* ============================================================
El GeneradorAST implementa un recorrido recursivo sobre el árbol de sintaxis, 
traduciendo cada objeto y propiedad a una gramática DOT. Su propósito es 
facilitar la depuración y cumplir con el reporte visual del AST
   ============================================================ */

let cuerpoDot = "";
let contador = 0;

const generarDOT = (ast) => { // Reiniciar variables globales para cada generación
    cuerpoDot = "digraph AST {\n";
    cuerpoDot += '  nodesep=0.5; ranksep=0.5;\n';
    cuerpoDot += '  node [shape=box, fontname="Arial", style="filled", fillcolor="#f9f9f9"];\n';
    cuerpoDot += '  edge [color="#cccccc"];\n';
    
    contador = 0;
    let raizId = `n${contador++}`;
    cuerpoDot += `  ${raizId} [label="program:1", fillcolor="#e1f5fe"];\n`;
    
    recorrer(ast, raizId);
    
    cuerpoDot += "}";
    return cuerpoDot;
};

const recorrer = (nodo, padreId) => { 
    if (nodo === null || nodo === undefined) return;

    // Si es un arreglo (lista de instrucciones)
    if (Array.isArray(nodo)) {
        nodo.forEach(item => recorrer(item, padreId));
        return;
    }

    if (typeof nodo === 'object') {
        let actualId = `n${contador++}`;
        
        // Limpiamos el nombre del tipo para evitar errores de sintaxis en DOT
        let tipo = nodo.tipo ? nodo.tipo.toString().replace(/"/g, '\\"') : "nodo";
        
        cuerpoDot += `  ${actualId} [label="${tipo}"];\n`;
        cuerpoDot += `  ${padreId} -> ${actualId};\n`;

        // Recorremos los hijos
        for (let propiedad in nodo) {
            if (propiedad !== 'tipo') {
                const valor = nodo[propiedad];
                
                if (Array.isArray(valor) || (valor !== null && typeof valor === 'object')) {
                    recorrer(valor, actualId);
                } else if (valor !== null && valor !== undefined) {
                    // Es un valor terminal (ID, número, string)
                    let terminalId = `n${contador++}`;
                    let labelTerminal = valor.toString().replace(/"/g, '\\"');
                    cuerpoDot += `  ${terminalId} [label="${labelTerminal}", shape=ellipse, fillcolor="#fff9c4"];\n`;
                    cuerpoDot += `  ${actualId} -> ${terminalId};\n`;
                }
            }
        }
    }
};

module.exports = { generarDOT };