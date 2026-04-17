import React, { useState } from 'react';
import Toolbar from './Toolbar';
import Editor from './Editor';
import OutputPanel from './OutputPanel';
import Console from './Console';
import { parserService } from '../services/parserService';
import '../styles/components.css';


export default function Layout() {
  const [code, setCode] = useState('');
  const [output, setOutput] = useState('');
  const [errors, setErrors] = useState('');
  const [logs, setLogs] = useState([]);

  // --- NUEVA LÓGICA DE EJECUCIÓN (CONEXIÓN AL BACKEND) ---
  const handleRun = async () => {
    setLogs([{ type: 'info', message: 'Ejecutando código en servidor...' }]);
    setOutput('');
    setErrors('');

    try {
      // 1. Enviamos el código al backend para análisis y reporte
      const response = await fetch('http://localhost:4000/analizar', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ codigo: code })
      });

      const result = await response.json();

      if (response.ok) {
        // Mostramos el AST en el panel de salida
        setOutput(JSON.stringify(result.ast, null, 2));
        
        if (result.errores && result.errores.length > 0) {
          setLogs(prev => [...prev, { type: 'error', message: `Análisis con ${result.errores.length} errores. Revisa el reporte.` }]);
        } else {
          setLogs(prev => [...prev, { type: 'success', message: 'Ejecución exitosa' }]);
        }
      } else {
        throw new Error(result.mensaje || 'Error en el servidor');
      }
    } catch (error) {
      setErrors(error.message);
      setLogs(prev => [...prev, { type: 'error', message: `Error de conexión: ${error.message}` }]);
    }
  };

  // --- NUEVA FUNCIÓN PARA REPORTES ---
    const handleReport = () => {
        // Abrimos ambas rutas en pestañas nuevas
        window.open('http://localhost:4000/reporte-errores', '_blank');
        
        // El pequeño delay evita que el navegador bloquee la segunda pestaña
        setTimeout(() => {
            window.open('http://localhost:4000/reporte-tabla', '_blank');
        }, 500);
    };

    // Dentro de tu componente Layout
  const verErrores = () => {
      window.open('http://localhost:4000/reporte-errores', '_blank');
  };

  const verSimbolos = () => {
      window.open('http://localhost:4000/reporte-tabla', '_blank');
  };
  
  const verAST = () => {
    window.open('http://localhost:4000/reporte-ast', '_blank');
  };

  const handleClear = () => {
    setCode('');
    setOutput('');
    setErrors('');
    setLogs([]);
  };

  const handleSave = () => {
    const element = document.createElement('a');
    element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(code));
    element.setAttribute('download', 'codigo.txt');
    element.style.display = 'none';
    document.body.appendChild(element);
    element.click();
    document.body.removeChild(element);
    setLogs(prev => [...prev, { type: 'info', message: 'Archivo descargado' }]);
  };

  const handleOpen = (fileContent) => {
    setCode(fileContent);
    setLogs([{ type: 'success', message: 'Archivo cargado correctamente' }]);
  };

  return (
    <div className="layout-container">
      {/* Agregamos handleReport aquí */}
      <Toolbar 
        onRun={handleRun} 
        onClear={handleClear} 
        onSave={handleSave} 
        onOpen={handleOpen} 
        onReport={handleReport} 
        verErrores={verErrores}
        verSimbolos={verSimbolos}
        verAST={verAST}
      />
      
      <div className="main-content">
        <div className="editor-section">
          <Editor code={code} setCode={setCode} />
        </div>
        
        <div className="right-section">
          <OutputPanel output={output} errors={errors} />
          <Console logs={logs} />
        </div>
      </div>
    </div>
  );
}