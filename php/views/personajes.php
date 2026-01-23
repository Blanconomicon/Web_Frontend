<?php
require_once "../utility/utils.php";

comprobarLogin();

$personajes = obtenerPersonajes($_SESSION['user']);


require_once "../includes/header.php";
?>
    <main>
        <!-- Informacion de la Pagina -->
        <section class="contenedor">
            <?php
            foreach ($personajes as $personaje) {
                echo "<p class='centrado'><a href='consultarPersonajes.php?nombrePj=" . $personaje->char_name . "'>" . $$personaje->char_name . "</a></p>";
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