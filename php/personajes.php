<?php
require_once "./utils.php";

comprobarLogin();

$personajes = obtenerPersonajes($_SESSION['user'])
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="author" content="Aketza Gonzalez Rey">
    <meta name="author" content="Daniel Alvarez Burgo">
    <meta name="description" content="Pagina principal en la cual, se muestra una breve descripcion de que es Blanconomicon">
    <link rel="stylesheet" href="../css/style.css">
    <link rel="icon" href="../src/img/logo1.png" type="image/x-icon">
    <title>Blanconomicon | Personajes</title>
</head>

<body>
    <header>
        <h1>Blanconomicon</h1>
        <?php
        if (isset($_SESSION['user'])) {
        ?>
            <div class="menu-hamburguesa" id="menu-hamburguesa">
                <div class="bar"></div>
                <div class="bar"></div>
                <div class="bar"></div>
            </div>
            <nav class="menu" id="menu">
                <div class="menu--etiqueta">
                    <!-- <a href="index.php"><img src="./src/img/logo2.png" alt="Despliega Menu" class="menu--logo"></a> -->
                    <img src="../src/img/logo2.png" alt="Despliega Menu" class="menu--logo">
                </div>
                <div class="menu--items">
                    <div class="menu--item"><a href="../index.php">Index</a></div>
                    <div class="menu--item activo">Personajes</div>
                    <div class="menu--item"><a href="./grupos.php">Grupos</a></div>
                </div>
            </nav>
        <?php
        }
        ?>
        <div class="derecha-header">
            <?php
            echo "<span>Usuario: <b>" . $_SESSION['user'] . "</b></span>";
            echo "<span><a href='../index.php?logout'>Logout</a></span>";
            ?>
        </div>
    </header>
    <main>
        <!-- Informacion de la Pagina -->
        <section class="contenedor">
            <?php
            foreach ($personajes as $personaje) {
                echo "<p><a href='consultarPersonajes.php?nombrePj=" . $personaje->char_name . "'>" . $$personaje->char_name . "</a></p>";
            }
            ?>
            <button onclick="location.href='./crearPersonaje.php'">
                Nuevo Personaje
            </button>
        </section>
    </main>
    <footer>
        <p>Daniel Alvarez - Aketza González</p>
    </footer>
    <script src="../js/menuHamburguesa.js"></script>
</body>

</html>