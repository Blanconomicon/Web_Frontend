<?php
require_once "../utility/utils.php";

comprobarLogin();

if(isset($_GET['idPersonajeBorrar'])){
    deleteCharacter(getCon(),$_GET['idPersonajeBorrar'],$_SESSION['user'][0]->user_nick);
}

$personajes = obtenerPersonajes($_SESSION['user'][0]->user_nick);


require_once "../includes/header.php";
?>
<main>
    <!-- Informacion de la Pagina -->
    <section class="contenedor">
        <?php
        foreach ($personajes as $personaje) {
            echo "<p class='centrado'><a href='verPersonaje.php?idPersonaje=" . $personaje->character_id . "' target='_blank'>"
                . $personaje->character_name . "</a></p>";
            echo "<a href='personajes.php?idPersonajeBorrar=".$personaje->character_id."'><button>ELIMINAR</button></a>";
        }
        ?>
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