<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="author" content="Aketza Gonzalez Rey">
    <meta name="author" content="Daniel Alvarez Burgo">
    <meta name="description" content="Pagina principal en la cual, se muestra una breve descripcion de que es Blanconomicon">
    <link rel="stylesheet" href="../css/style.css">
    <link rel="icon" href="../src/img/logo1.png" type="image/x-icon">
    <title>Blanconomicon</title>
</head>
<body>
    <header>
        <h1>Blanconomicon</h1>
        <nav class="menu">
            <div class="menu--etiqueta">
                <a href="../index.php"><img src="../src/img/logo2.png" alt="Despliega Menu" class="menu--logo"></a>
            </div>
            <div class="menu--items">
                <!-- Menu items -->
            </div>
        </nav>
    </header>
    <main>
        <!-- Informacion de la Pagina -->
        <section class="contenedor">
            <form method="post">
                <table>
                    <tr>
                        <td>User</td>
                        <td><input type="text" name="user" class="ocupaTodo"></td>
                    </tr>
                    <tr>
                        <td>Email</td>
                        <td><input type="text" name="email" class="ocupaTodo"></td>
                    </tr>
                    <tr>
                        <td>Nombre</td>
                        <td><input type="text" name="nombre" class="ocupaTodo"></td>
                    </tr>
                    <tr>
                        <td>Password</td>
                        <td><input type="password" name="password" class="ocupaTodo"></td>
                    </tr>
                    <tr>
                        <td>Repetir Password</td>
                        <td><input type="password" name="password2" class="ocupaTodo"></td>
                    </tr>
                    <tr>
                        <td colspan="2"><input type="submit" value="Registrarse" name="register" class="ocupaTodo"></td>
                    </tr>
                </table>
            </form>
            <p>Ya tienes una cuenta, <a href="./login.php">INICIA SESION</a></p>
        </section>
    </main>
    <footer>
        <!-- Footer -->
    </footer>
</body>
</html>