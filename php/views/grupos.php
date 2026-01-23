<?php
require_once "../utility/utils.php";

comprobarLogin();

if (isset($_POST['submit'])) {
    crearGrupo($_POST['nombreGrupo']);
}

$grupos = obtenerGrupos($_SESSION['user']);

require_once "../includes/header.php";

?>
    <main>
        <!-- Informacion de la Pagina -->
        <section class="contenedor">
            <?php
            foreach ($grupos as $grupo) {
                echo "<p><a href='grupos.php?idGrupo=" . $grupo->group_id . "'>" . $grupo->group_name . "</a></p>";
                if (isset($_GET['idGrupo']) && $_GET['idGrupo'] == $grupo->group_id) {
                    $jugadores = obtenerJugadores($grupo->group_id);
            ?>
                    <table>
                        <tr>
                            <th>JUGADOR</th>
                            <th>ROL</th>
                        </tr>
                        <?php
                        foreach ($jugadores as $jugador) {
                            echo "<tr>";
                            echo "<td>" . $jugador->user_nick . "</td>";
                            echo "<td>" . $jugador->rol_name . "</td>";
                            echo "</tr>";
                        }
                        ?>
                    </table>
            <?php
                    echo "<p><a href='grupos.php?idGrupo=" . $grupo->group_id . "&aniadirGente'>Añadir gente</a></p>";
                }
            }
            ?>
            <button id="btnNuevoGrupo" class="centrado">Nuevo grupo</button>

        </section>
    </main>
<?php
    require_once "../includes/footer.php"
?>
    <script src="../../js/menuHamburguesa.js"></script>
    <script src="../../js/crearGrupo.js"></script>
</body>

</html>