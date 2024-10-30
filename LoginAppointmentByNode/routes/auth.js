const express = require('express');
const Usuario = require('../models/Usuario');
const router = express.Router();

router.post('/login', async (req, res) => {
    const { email, password } = req.body;
    const usuario = await Usuario.findOne({ email });
    if (!usuario || !(await usuario.comparePassword(password))) {
        return res.status(400).json({ error: 'Credenciales incorrectas' });
    }
    req.session.userId = usuario._id;
    res.redirect('/inicio');
});

router.post('/logout', (req, res) => {
    req.session.destroy(() => res.redirect('/login'));
});

module.exports = router;
