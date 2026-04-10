import React from 'react';

{/*
        Esta es la parte que muestra la salida de errores y resultados, 
        aqui se va a mostrar lo que el parser devuelve, o los errores que ocurran
*/}


export default function OutputPanel({ output, errors }) {
  return (
    <div className="output-panel">
      <div className="panel-header">
        <h2>Salida</h2>
      </div>
      <div className="output-content">
        {errors && <div className="error-box">{errors}</div>}
        {output && <div className="success-box">{output}</div>}
        {!output && !errors && <p className="placeholder">Ejecuta el código para ver resultados..</p>}
      </div>
    </div>
  );
}