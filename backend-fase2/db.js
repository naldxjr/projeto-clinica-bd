const mysql = require('mysql2');

const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',        
    password: 'ln171024', 
    database: 'clinica_especialidades',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

module.exports = pool.promise();