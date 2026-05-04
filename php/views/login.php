<?php
require_once "../utility/utils.php";

$error = "";
if (isset($_POST['login'])) {
    if (trim($_POST['user']) != "" && trim($_POST['password']) != "") {
        //comprobar loginOK
        if (loginOK($_POST['user'], $_POST['password'])) {
            //Guardar el user_nick
            $_SESSION['user'] = getUser(getCon(), $_POST['user']);
            // redirigir a index.php
            header("Location: ../../index.php");
            exit();
        } else {
            $error = "<p style='color: red'>Usuario o contraseña invalidos</p>";
        }
    } else {
        $error = "<p style='color: red'>Debes introducir un usuario y una contraseña</p>";
    }
}


require_once "../includes/header.php";

?>
<main>
    <!-- Informacion de la Pagina -->
    <section class="contenedor">
        <?php
        echo $error;
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
<?php
require_once "../includes/footer.php"
?>
</body>

</html>