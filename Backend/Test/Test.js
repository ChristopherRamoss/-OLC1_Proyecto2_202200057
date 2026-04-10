var fs = require('fs');
var path = require('path');
var parser = require('../Lenguaje/Parser');

const filePath = path.join(__dirname, '../Inputs/Prueba.txt');

fs.readFile(filePath, 'utf8', (err, data) => {
    if (err) throw err;
    let string = data.toString();
    console.log(parser.parse(string));
});