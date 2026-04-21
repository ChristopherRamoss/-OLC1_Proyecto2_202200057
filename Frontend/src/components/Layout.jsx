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

  const handleRun = async () => {
    setLogs([]);
    setOutput('');
    setErrors('');

    try {
      const response = await fetch('http://localhost:4000/analizar', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ codigo: code })
      });

      const result = await response.json();

      if (response.ok) {
        setOutput(JSON.stringify(result.ast, null, 2));

        // Solo los prints del programa, sin mensajes extra
        const logsEjecucion = (result.salida || []).map(linea => ({
          type: 'output',
          message: linea
        }));

        setLogs(logsEjecucion);

      } else {
        throw new Error(result.mensaje || 'Error en el servidor');
      }
    } catch (error) {
      setErrors(error.message);
    }
  };

  const handleReport = () => {
    window.open('http://localhost:4000/reporte-errores', '_blank');
    setTimeout(() => {
      window.open('http://localhost:4000/reporte-tabla', '_blank');
    }, 500);
  };

  const verErrores = () => window.open('http://localhost:4000/reporte-errores', '_blank');
  const verSimbolos = () => window.open('http://localhost:4000/reporte-tabla', '_blank');
  const verAST = () => window.open('http://localhost:4000/reporte-ast', '_blank');

  const handleClear = () => {
    setCode('');
    setOutput('');
    setErrors('');
    setLogs([]);
  };

  const handleSave = () => {
    const element = document.createElement('a');
    element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(code));
    element.setAttribute('download', 'codigo.gst');
    element.style.display = 'none';
    document.body.appendChild(element);
    element.click();
    document.body.removeChild(element);
    setLogs(prev => [...prev, { type: 'info', message: 'Archivo guardado como codigo.gst' }]);
  };

  const handleOpen = (fileContent) => {
    setCode(fileContent);
    setLogs([{ type: 'success', message: 'Archivo cargado correctamente' }]);
  };

  return (
    <div className="layout-container">
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
