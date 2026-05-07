<?php
require_once "../utility/utils.php";

//comprobar si se ha hecho login
comprobarLogin();

//si se quiere borrar el personaje
if (isset($_GET['idPersonajeBorrar'])) {
    deleteCharacter(getCon(), $_GET['idPersonajeBorrar'], $_SESSION['user'][0]->user_nick);
}

//obtener los personajes
$personajes = obtenerPersonajes($_SESSION['user'][0]->user_nick);
$_SESSION["personaje"] = null;

require_once "../includes/header.php";
?>
<main>
    <!-- Informacion de la Pagina -->
    <section class="contenedor">
        <div class="grid-2">
            <?php
            //mostrar personajes
            foreach ($personajes as $personaje) {
                echo "<p class='centrado'><a href='verPersonaje.php?idPersonaje=" . $personaje->character_id . "' target='_blank'>"
                    . $personaje->character_name . "</a></p>";
                echo "<a href='personajes.php?idPersonajeBorrar=" . $personaje->character_id . "' class='centrado ocupaTodo'><button class='ocupaTodo'>ELIMINAR</button></a>";
            }
            ?>
        </div>
        <br>
        <button onclick="location.href='./crearPersonaje.php'" class="centrado">
            Nuevo Personaje
        </button>
    </section>
</main>
<?php
require_once "../includes/footer.php"
?>
<script src="../../js/menuHamburguesa.js"></script>
</body>

</html>