import React from 'react';


{/*
     Esta es la parte donde se va a ingresar la informacion  (Archivo de entrada) 
    
*/}


export default function Editor({ code, setCode }) {
  return (
    <div className="editor-panel">
      <div className="panel-header">
        <h2>Editor de Codigo</h2>
      </div>
      <textarea
        className="code-editor"
        value={code}
        onChange={(e) => setCode(e.target.value)}
        placeholder="Escribe tu código aqui"
        spellCheck="false"
      />
    </div>
  );
}