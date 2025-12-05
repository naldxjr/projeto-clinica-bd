const express = require('express');
const cors = require('cors');
const db = require('./db');

const app = express();
app.use(express.json());
app.use(cors());


app.get('/pacientes', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM paciente');
        res.json(rows);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.get('/pacientes/:id', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM paciente WHERE id_paciente = ?', [req.params.id]);
        if (rows.length === 0) return res.status(404).json({ msg: 'Paciente não encontrado' });
        res.json(rows[0]);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.post('/pacientes', async (req, res) => {
    const { nome, cpf, data_nasc, id_convenio, id_usuario } = req.body;
    try {
        const sql = 'INSERT INTO paciente (nome_paciente, cpf, data_nascimento, id_convenio, id_usuario) VALUES (?, ?, ?, ?, ?)';
        const [result] = await db.query(sql, [nome, cpf, data_nasc, id_convenio, id_usuario]);
        res.status(201).json({ msg: 'Paciente criado!', id: result.insertId });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.put('/pacientes/:id', async (req, res) => {
    const { nome } = req.body;
    try {
        await db.query('UPDATE paciente SET nome_paciente = ? WHERE id_paciente = ?', [nome, req.params.id]);
        res.json({ msg: 'Paciente atualizado com sucesso!' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.delete('/pacientes/:id', async (req, res) => {
    try {
        await db.query('DELETE FROM paciente WHERE id_paciente = ?', [req.params.id]);
        res.json({ msg: 'Paciente excluído!' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.get('/medicos', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM medico');
        res.json(rows);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.get('/medicos/:id', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM medico WHERE id_medico = ?', [req.params.id]);
        if (rows.length === 0) return res.status(404).json({ msg: 'Médico não encontrado' });
        res.json(rows[0]);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.post('/medicos', async (req, res) => {
    const { nome, crm, id_usuario } = req.body;
    try {
        const sql = 'INSERT INTO medico (nome_medico, crm, id_usuario) VALUES (?, ?, ?)';
        const [result] = await db.query(sql, [nome, crm, id_usuario]);
        res.status(201).json({ msg: 'Médico criado!', id: result.insertId });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.put('/medicos/:id', async (req, res) => {
    const { nome } = req.body;
    try {
        await db.query('UPDATE medico SET nome_medico = ? WHERE id_medico = ?', [nome, req.params.id]);
        res.json({ msg: 'Médico atualizado com sucesso!' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});


app.delete('/medicos/:id', async (req, res) => {
    try {
        await db.query('DELETE FROM medico WHERE id_medico = ?', [req.params.id]);
        res.json({ msg: 'Médico excluído!' });
    } catch (error) {
        res.status(500).json({ error: 'Não é possível excluir médico com consultas vinculadas.' });
    }
});

app.post('/agendar', async (req, res) => {
    const { id_paciente, id_medico, id_especialidade, data_hora, valor } = req.body;
    try {
        const sql = 'CALL prc_agendar_consulta(?, ?, ?, ?, ?)';
        await db.query(sql, [id_paciente, id_medico, id_especialidade, data_hora, valor]);
        res.json({ msg: 'Sucesso! Procedure executada e consulta agendada.' });
    } catch (error) {
        res.status(400).json({ erro_banco: error.sqlMessage });
    }
});

app.get('/medicos/:id/faturamento', async (req, res) => {
    try {
        const sql = 'SELECT fn_faturamento_medico(?) AS total_faturado';
        const [rows] = await db.query(sql, [req.params.id]);
        res.json({ 
            id_medico: req.params.id, 
            faturamento: rows[0].total_faturado 
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.patch('/consultas/:id/cancelar', async (req, res) => {
    try {
        await db.query("UPDATE consulta SET status = 'CANCELADA' WHERE id_consulta = ?", [req.params.id]);
        res.json({ msg: 'Consulta cancelada! Trigger de auditoria disparada no banco.' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.listen(3000, () => {
    console.log('Backend rodando na porta 3000');
    console.log('Tudo pronto!');
});