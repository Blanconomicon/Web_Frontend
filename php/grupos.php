<?php
require_once "./utils.php";

if(isset($_GET['nombreGrupo'])){
    crearGrupo($_GET['nombreGrupo']);
}

$grupos = obtenerGrupos($_SESSION['user'])
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
    <title>Blanconomicon | Grupos</title>
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
                    <div class="menu--item"><a href="./php/personajes.php">Personajes</a></div>
                    <div class="menu--item activo">Grupos</div>
                </div>
            </nav>
        <?php
        }
        ?>
        <div class="derecha-header">
            <?php
            echo "<span>Usuario: <b>" . $_SESSION['user'] . "</b></span>";
            echo "<span><a href='../index.php?logout'>LOGOUT</a></span>";
            ?>
        </div>
    </header>
    <main>
        <!-- Informacion de la Pagina -->
        <section class="contenedor">
            <?php
            foreach ($grupos as $gurpo) {
                echo "<p><a href='grupos.php?idGrupo=" . $gurpo->id . "'>" . $gurpo->nombre . "</a></p>";
                if (isset($_GET['idGrupo']) && $_GET['idGrupo'] == $grupo->id) {
                    $jugadores = obtenerJugadores($grupo->id);
            ?>
                    <table>
                        <tr>
                            <th>JUGADOR</th>
                            <th>ROL</th>
                        </tr>
                        <?php
                        foreach ($jugadores as $jugador) {
                            echo "<tr>";
                            echo "<td>" . $jugador->nombre . "</td>";
                            echo "<td>" . $jugador->rol . "</td>";
                            echo "</tr>";
                        }
                        ?>
                    </table>
            <?php
                    echo "<p><a href='grupos.php?idGrupo=" . $gurpo->id . "&aniadirGente'>Añadir gente</a></p>";
                }
            }
            ?>
            <button id="btnNuevoGrupo">Nuevo grupo</button>

            <div id="modal" style="display:none; position:fixed; top:40%; left:40%; background:#fff; padding:20px; border:1px solid #000;">
                <p>Nombre del grupo:</p>
                <input type="text" id="nombre">
                <button id="btnCrearGrupo">Aceptar</button>
            </div>

        </section>
    </main>
    <footer>
        <p>Daniel Alvarez - Aketza González</p>
    </footer>
    <script src="../js/menuHamburguesa.js"></script>
    <script src="../js/crearGrupo.js"></script>
</body>

</html>