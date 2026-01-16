<?php
require_once "./utils.php";
$error="";
if (isset($_POST['register'])) {
    if (
        trim($_POST['user']) != "" && trim($_POST['email']) != "" && trim($_POST['nombre']) != "" &&
        trim($_POST['password']) != "" && trim($_POST['password2']) != ""
    ) {
        register($_POST['user'], $_POST['email'], $_POST['nombre'], $_POST['password'], $_POST['password2']);
    }else{
        $error = "<p style='color: red'>Todos los campos deben tener texto para poder registrarse</p>";
    }
}

?>
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
        <div class="derecha-header">
            <span><a href="../index.php">Ver index</a></span>
        </div>
    </header>
    <main>
        <!-- Informacion de la Pagina -->
        <section class="contenedor">
            <?php
                echo $error
            ?>
            <form method="post">
                <table>
                    <tr>
                        <td>User</td>
                        <td><input type="text" name="user" class="ocupaTodo" required></td>
                    </tr>
                    <tr>
                        <td>Email</td>
                        <td><input type="email" name="email" class="ocupaTodo" required></td>
                    </tr>
                    <tr>
                        <td>Nombre</td>
                        <td><input type="text" name="nombre" class="ocupaTodo" required></td>
                    </tr>
                    <tr>
                        <td>Password</td>
                        <td><input type="password" name="password" class="ocupaTodo" required></td>
                    </tr>
                    <tr>
                        <td>Repetir Password</td>
                        <td><input type="password" name="password2" class="ocupaTodo" required></td>
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
        <p>Daniel Alvarez - Aketza González</p>
    </footer>
</body>

</html>