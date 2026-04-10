import React from 'react';
import { MdPlayArrow, MdSave, MdDelete } from 'react-icons/md';
import '../styles/components.css';


{/*
        Esta es la barra de herramientas, aqui se van a colocar los botones para ejecutar el codigo,
         limpiar el editor y guardar el codigo en un archivo
*/}


export default function Toolbar({ onRun, onClear, onSave }) {
  return (
    <div className="toolbar">
      <button className="btn btn-primary" onClick={onRun}>
        <MdPlayArrow /> Ejecutar
      </button>
      <button className="btn btn-success" onClick={onSave}>
        <MdSave /> Guardar
      </button>
      <button className="btn btn-danger" onClick={onClear}>
        <MdDelete /> Limpiar
      </button>
    </div>
  );
}