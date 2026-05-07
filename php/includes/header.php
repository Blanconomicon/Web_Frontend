<?php
//comprobar que se ha realizado el login
if (isset($_GET['logout'])) {
    logout();
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
    <?php
    //comprobar si se esta en el index para cargar el logo y las fotos
    if (basename($_SERVER['PHP_SELF']) == "index.php") {
    ?>
        <link rel="stylesheet" href="./css/style.css">
        <link rel="icon" href="./src/img/logo1.png" type="image/x-icon">
    <?php
    } else {
    ?>
        <link rel="stylesheet" href="../../css/style.css">
        <link rel="icon" href="../../src/img/logo1.png" type="image/x-icon">
    <?php
    }
    //poner el tittle en funcion de la pagina en la que nos encontramos
    echo "<title>Blanconomicon | " . ucfirst(substr(basename($_SERVER['PHP_SELF']), 0, strlen(basename($_SERVER['PHP_SELF'])) - 4))
        . "</title>"
    ?>
</head>

<body>
    <script src="../../js/utils.js"></script>
    <header>
        <h1>Blanconomicon</h1>
        <?php
        //comprobar si hay sesion iniciada para mostrar el header
        if (isset($_SESSION['user'])) {
        ?>
            <div class="menu-hamburguesa" id="menu-hamburguesa">
                <div class="bar"></div>
                <div class="bar"></div>
                <div class="bar"></div>
            </div>
            <nav class="menu" id="menu">
                <div class="menu--etiqueta">

                    <?php
                    if (basename($_SERVER['PHP_SELF']) == "index.php") {
                        echo "<img src='./src/img/logo2.png' alt='Despliega Menu' class='menu--logo'>";
                    } else {
                        echo "<img src='../../src/img/logo2.png' alt='Despliega Menu' class='menu--logo'>";
                    }
                    ?>
                </div>
                <div class="menu--items">
                    <?php
                    //poner los enlaces del menu de navegacion en funcion de donde se encuentre
                    switch (basename($_SERVER['PHP_SELF'])) {
                        case 'index.php':
                            echo "<div class='menu--item activo'>Index</div>";
                            echo "<div class='menu--item'><a href='./php/views/personajes.php'>Personajes</a></div>";
                            echo "<div class='menu--item'><a href='./php/views/grupos.php'>Grupos</a></div>";
                            break;
                        case "grupos.php":
                            echo "<div class='menu--item'><a href='../../index.php'>Index</a></div>";
                            echo "<div class='menu--item'><a href='./personajes.php'>Personajes</a></div>";
                            echo "<div class='menu--item activo'>Grupos</div>";
                            break;
                        case "personajes.php":
                            echo "<div class='menu--item'><a href='../../index.php'>Index</a></div>";
                            echo "<div class='menu--item activo'>Personajes</div>";
                            echo "<div class='menu--item'><a href='./grupos.php'>Grupos</a></div>";
                            break;
                        case "crearPersonaje.php":
                        case "crearPersonaje2.php":
                        case "crearPersonaje3.php":
                        case "crearPersonaje4.php":
                            echo "<div class='menu--item'><a href='../../index.php'>Index</a></div>";
                            echo "<div class='menu--item'><a href='./personajes.php'>Personajes</a></div>";
                            echo "<div class='menu--item'><a href='./grupos.php'>Grupos</a></div>";
                            break;
                    }
                    ?>
                </div>
            </nav>
        <?php
        }
        ?>
        <div class="derecha-header">
            <?php
            //poner la informacion del usuario o el enlace para hacer login
            if (isset($_SESSION['user'])) {
                echo "<span>Usuario: <b>" . $_SESSION['user'][0]->user_nick . "</b></span>";
                if (basename($_SERVER['PHP_SELF']) == "index.php") {
                    echo "<span><a href='index.php?logout'>Logout</a></span>";
                } else {
                    echo "<span><a href='../../index.php?logout'>Logout</a></span>";
                }
            } else {
                if (basename($_SERVER['PHP_SELF']) == "index.php") {
                    echo "<span><a href='php/views/login.php'>Login</a></span>";
                } else {
                    echo "<span><a href='./login.php'>Login</a></span>";
                }
            }
            ?>
        </div>
    </header>