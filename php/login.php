<?php
require_once "./utils.php";

$error = "";

if (isset($_POST['login'])) {
    if (trim($_POST['user']) != "" && trim($_POST['password']) != "") {
        //comprobar loginOK
        if (loginOK($_POST['user'], $_POST['password'])) {
            //Guardar el user_nick
            $_SESSION['user'] = $_POST['user'];
            // redirigir a index.php
            header("Location: ../index.php");
            exit();
        } else {
            $error = "<p style='color: red'>Usuario o contraseña invalidos</p>";
        }
    } else {
        $error = "<p style='color: red'>Debes introducir un usuario y una contraseña</p>";
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
                        <td>Password</td>
                        <td><input type="password" name="password" class="ocupaTodo" required></td>
                    </tr>
                    <tr>
                        <td colspan="2"><input type="submit" value="Login" name="login" class="ocupaTodo"></td>
                    </tr>
                </table>
            </form>
            <p>No tienes una cuenta, <a href="./register.php">REGISTRATE</a></p>
        </section>
    </main>
    <footer>
        <p>Daniel Alvarez - Aketza González</p>
    </footer>
</body>

</html>