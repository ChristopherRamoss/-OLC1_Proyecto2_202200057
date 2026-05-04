/* ============================================================
Logica para crear un HTML de los reportes tanto de simbolos
Como de reporte de errores
   ============================================================ */

const generarHTMLReporte = (tipo, datos) => {
    const listaSimbolos = [];
    const esError = tipo === 'ERRORES';
    const titulo = esError ? "Reporte de Errores" : "Tabla de Símbolos";
    const colorHeader = esError ? "#d9534f" : "#5cb85c";

    let tablaEncabezado = esError 
        ? `<thead><tr><th>No.</th><th>Descripción</th><th>Línea</th><th>Columna</th><th>Tipo</th></tr></thead>`
        : `<thead><tr><th>ID</th><th>Tipo Símbolo</th><th>Tipo Dato</th><th>Ámbito</th><th>Línea</th><th>Columna</th></tr></thead>`;

    let filas = "";
    datos.forEach((item, index) => {
        if (esError) {
            filas += `<tr><td>${index+1}</td><td>${item.descripcion}</td><td>${item.linea}</td><td>${item.columna}</td><td>${item.tipo}</td></tr>`;
        } else {
            filas += `<tr><td>${item.id || ''}</td><td>${item.tipoSimbolo || ''}</td><td>${item.tipoDato || ''}</td><td>${item.ambito || ''}</td><td>${item.linea || ''}</td><td>${item.columna || ''}</td></tr>`;
        }
    });

    return `
    <!DOCTYPE html>
    <html>
        <head>
            <meta charset="UTF-8">
            <title>${titulo}</title>
            <style>
                body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; padding: 20px; background-color: #f9f9f9; }
                h2 { color: #333; }
                table { width: 100%; border-collapse: collapse; margin-top: 20px; background-color: white; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
                th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
                th { background-color: ${colorHeader}; color: white; text-transform: uppercase; }
                tr:nth-child(even) { background-color: #f2f2f2; }
                tr:hover { background-color: #ddd; }
            </style>
        </head>
        <body>
            <h2>${titulo}</h2>
            <table>${tablaEncabezado}<tbody>${filas}</tbody></table>
        </body>
    </html>`;
};

// ESTA ES LA ÚNICA FORMA DE EXPORTAR EN COMMONJS
module.exports = {
    generarHTMLReporte
};