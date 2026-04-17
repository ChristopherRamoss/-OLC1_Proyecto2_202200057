import React, { useRef } from 'react';
import { MdPlayArrow, MdSave, MdDelete, MdFolderOpen } from 'react-icons/md';
import '../styles/components.css';
import { MdBarChart } from 'react-icons/md'; // Ícono para reportes

export default function Toolbar({ onRun, onClear, onSave, onOpen, verErrores, verSimbolos}) {
  const fileInputRef = useRef(null);

  const handleOpenClick = () => {
    fileInputRef.current?.click();
  };

  const handleFileChange = (event) => {
    const file = event.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        const content = e.target?.result;
        onOpen(content);
      };
      reader.readAsText(file);
    }
  };

  return (
    <div className="toolbar">
      <button className="btn btn-info" onClick={handleOpenClick}>
        <MdFolderOpen /> Abrir
      </button>

      <input
        ref={fileInputRef}
        type="file"
        onChange={handleFileChange}
        style={{ display: 'none' }}
        accept=".txt,.js,.java,.c,.cpp,.py,.rb,.go,.ts,.jsx,.tsx"
      />

      

      <button className="btn btn-primary" onClick={onRun}>
        <MdPlayArrow /> Ejecutar
      </button>





      <button className="btn btn-success" onClick={onSave}>
        <MdSave /> Guardar
      </button>

      <button className="btn btn-danger" onClick={onClear}>
        <MdDelete /> Limpiar
      </button>

      <button onClick={verErrores} style={{ backgroundColor: '#d9534f', color: 'white' }}>
            Reporte de Errores
        </button>
        
        <button onClick={verSimbolos} style={{ backgroundColor: '#5cb85c', color: 'white' }}>
            Tabla de Símbolos
        </button>

    </div>
  );
}