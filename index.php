<?php
session_start();
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="author" content="Aketza Gonzalez Rey">
    <meta name="author" content="Daniel Alvarez Burgo">
    <meta name="description" content="Pagina principal en la cual, se muestra una breve descripcion de que es Blanconomicon">
    <link rel="stylesheet" href="./css/style.css">
    <link rel="icon" href="./src/img/logo1.png" type="image/x-icon">
    <title>Blanconomicon</title>
</head>

<body>
    <header>
        <h1>Blanconomicon</h1>
        <nav class="menu">
            <div class="menu--etiqueta">
                <a href="index.php"><img src="./src/img/logo2.png" alt="Despliega Menu" class="menu--logo"></a>
            </div>
            <div class="menu--items">
                <div class="menu--item"><a href="./php/login.php">Login</a></div>
            </div>
        </nav>
        <div class="derecha-header">
            <?php
            if (isset($_SESSION['user'])) {
                echo "<span>Usuario: <b>".$_SESSION['user']."</b></span>";
                echo "<span><a href='./php/login.php'>LOGOUT</a></span>";
            } else {
                echo "<span><a href='./php/login.php'>Login</a></span>";
            }
            ?>
        </div>
    </header>
    <main>
        <!-- Informacion de la Pagina -->
        <section class="contenedor">
            <img width=300px src="src\img\logo1.png" alt="">
            <br>
            <img width=300px src="src\img\logo2.png" alt="">
            <br>
            <br>
            <br>
            <br>
        </section>
    </main>
    <footer>
        <!-- Footer -->
    </footer>
</body>

</html>