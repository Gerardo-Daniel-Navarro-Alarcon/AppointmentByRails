const express = require('express');
const mongoose = require('mongoose');
const session = require('express-session');
const authRoutes = require('./routes/auth');
const cors = require('cors');
const app = express();

app.use(cors({
    origin: 'http://localhost:3000',  // Permite solicitudes desde el frontend
    credentials: true  // Permitir envío de cookies para la sesión
}));
mongoose.connect('mongodb://localhost:27017/LoginAppointmentByNode', {
    useNewUrlParser: true,
    useUnifiedTopology: true,
}).then(() => console.log('Conexión a MongoDB exitosa'))
    .catch((error) => console.error('Error al conectar:', error));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(session({ secret: 'miClaveSecreta', resave: false, saveUninitialized: true }));

app.use('/auth', authRoutes);

app.get('/inicio', (req, res) => {
    if (!req.session.userId) return res.redirect('/login');
    res.sendFile(__dirname + '/views/inicio.html');
});

const PORT = 3001;
app.listen(PORT, () => console.log(`Servidor corriendo en el puerto ${PORT}`));
