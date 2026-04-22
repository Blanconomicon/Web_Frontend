<?php
require_once "../utility/utils.php";

comprobarLogin();

if (isset($_POST['submit'])) {
    crearGrupo($_POST['nombreGrupo']);
}

$grupos = obtenerGrupos($_SESSION['user'][0]->user_nick);

require_once "../includes/header.php";

?>
<main>
    <!-- Informacion de la Pagina -->
    <section class="contenedor">
        <?php
        // var_dump(getGroup($con,$_SESSION['user'][0]->user_nick));
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
                <button id="btnAniadir" class="centrado">Añadir gente</button>
        <?php
                // echo "<p><a href='grupos.php?idGrupo=" . $grupo->group_id . "&aniadirGente'>Añadir gente</a></p>";
            }
        }
        ?>
        <button id="btnNuevoGrupo" class="centrado">Nuevo grupo</button>
        <dialog id="dialogCrear">
            <div>
                <form method="post">
                    <p>Nombre del grupo:</p>
                    <input type="text" name="nombreGrupo" required>
                    <br><br>
                    <div>
                        <input type="submit" name="submit" value="Crear">
                        <button id="btnCancelar" type="reset">Cancelar</button>
                    </div>
                </form>
            </div>
        </dialog>
        <dialog id="dialogAniadir">
            <div>
                <form method="post">
                    <p>Persona a invitar:</p>
                    <select name="selectPersonas" id="selectPersonas">
                        <!-- TODO CARGAR CON LAS PERSONAS QUE NO ESTAN EN EL GRUPO -->
                        <option value="persona">CARGAR CON LAS PERSONAS QUE NO ESTAN EN EL GRUPO</option>
                    </select>
                    <br>
                    <div>
                        <input type="submit" name="submit" value="Añadir">
                        <button id="btnCancelarAnaidir" type="reset">Cancelar</button>
                    </div>
                </form>
            </div>
        </dialog>
    </section>
</main>
<?php
require_once "../includes/footer.php"
?>
<script src="../../js/menuHamburguesa.js"></script>
<script src="../../js/grupos.js"></script>
</body>

</html>