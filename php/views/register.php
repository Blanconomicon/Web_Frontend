<?php
require_once "../utility/utils.php";
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


require_once "../includes/header.php";
?>
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