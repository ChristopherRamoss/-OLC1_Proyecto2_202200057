import React from 'react';

{/*
     Esta es la parte que tiene la consola que puede mostrar mensajes de depuracion 
    Ejecutando codigo y tonteras asi
*/}


export default function Console({ logs }) {
  return (
    <div className="console-panel">
      <div className="panel-header">
        <h2>Consola</h2>
      </div>
      <div className="console-content">
        {logs.length === 0 ? (
          <p className="placeholder">Aún no hay mensajes</p>
        ) : (
          logs.map((log, idx) => (
            <div key={idx} className={`log-line ${log.type}`}>
              [{log.type.toUpperCase()}] {log.message}
            </div>
          ))
        )}
      </div>
    </div>
  );
}