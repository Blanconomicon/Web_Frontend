<?php
require_once "../utility/utils.php";
comprobarLogin();

if (isset($_POST['submit'])) {
    crearGrupo($_POST['nombreGrupo']);
    echo "<script>window.close();</script>";
}
?>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="../../css/style.css">
    <title>Nuevo grupo</title>
</head>

<body>
    <div class="modal">
        <form method="post">
            <p>Nombre del grupo:</p>
            <input type="text" name="nombreGrupo" required>
            <br><br>
            <input type="submit" name="submit" value="Crear">
        </form>
    </div>
</body>

</html>