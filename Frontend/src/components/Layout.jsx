import React, { useState } from 'react';
import Toolbar from './Toolbar';
import Editor from './Editor';
import OutputPanel from './OutputPanel';
import Console from './Console';
import { parserService } from '../services/parserService';
import '../styles/components.css';



{/*
     esto es el layout principal, aqui se va a organizar todo lo que se va a mostrar en la pagina, el editor, la consola 
     y la salida de errores y resultados
*/}

export default function Layout() {
  const [code, setCode] = useState('');
  const [output, setOutput] = useState('');
  const [errors, setErrors] = useState('');
  const [logs, setLogs] = useState([]);

  const handleRun = async () => {
    setLogs([{ type: 'info', message: 'Ejecutando código...' }]);
    setOutput('');
    setErrors('');

    try {
      const result = await parserService.parseCode(code);
      setOutput(JSON.stringify(result, null, 2));
      setLogs(prev => [...prev, { type: 'success', message: 'Ejecución exitosa' }]);
    } catch (error) {
      setErrors(error.message);
      setLogs(prev => [...prev, { type: 'error', message: error.message }]);
    }
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

  return (
    <div className="layout-container">
      <Toolbar onRun={handleRun} onClear={handleClear} onSave={handleSave} />
      
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