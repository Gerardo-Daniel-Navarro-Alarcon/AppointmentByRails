const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

// Modelo de usuario (asegúrate de que esté bien definido en tu proyecto)
const Usuario = require('./models/Usuario'); // Asegúrate que la ruta sea correcta

// Conectar a MongoDB
mongoose.connect('mongodb://localhost:27017/LoginAppointmentByNode', {
    useNewUrlParser: true,
    useUnifiedTopology: true,
}).then(() => console.log('Conectado a MongoDB'))
    .catch((error) => console.error('Error al conectar a MongoDB:', error));

// Crear un usuario nuevo
const crearUsuario = async () => {
    const hashedPassword = await bcrypt.hash('adminMDB', 10); // Contraseña encriptada

    try {
        const nuevoUsuario = new Usuario({
            email: 'adminMDB@example.com',
            password: hashedPassword,
        });

        await nuevoUsuario.save();
        console.log('Usuario creado exitosamente');
    } catch (error) {
        console.error('Error al crear el usuario:', error);
    } finally {
        mongoose.connection.close(); // Cierra la conexión a MongoDB
    }
};

crearUsuario();
