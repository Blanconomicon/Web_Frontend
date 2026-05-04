<?php
require_once "../utility/utils.php";

comprobarLogin();
$_SESSION["personaje"] = null;

if (isset($_POST['crearGrupo'])) {
    crearGrupo($_POST['nombreGrupo']);
}

if (isset($_POST['aniadirAGrupo'])) {
    putGroupMember(getCon(), $_GET['idGrupo'], $_POST['selectPersonas']);
}

// $grupos = obtenerGrupos("admin");
$grupos = obtenerGrupos($_SESSION['user'][0]->user_nick);
$posibles = [];

require_once "../includes/header.php";

?>
<main>
    <!-- Informacion de la Pagina -->
    <section class="contenedor">
        <?php
        // var_dump(obtenerGrupos($_SESSION['user'][0]->user_nick));
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
                    // var_dump($jugadores);
                    $posibles = getNoGroupUser(getCon(), $grupo->group_id);
                    foreach ($jugadores as $jugador) {
                        echo "<tr>";
                        echo "<td>" . $jugador->user_nick . "</td>";
                        echo "<td>" . $jugador->rol_name . "</td>";
                        echo "</tr>";
                    }
                    ?>
                </table>
                <br>
                <button id="btnAniadir" class="centrado">Añadir gente</button>
                <br>
        <?php
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
                        <input type="submit" name="crearGrupo" value="Crear">
                        <button id="btnCancelar" type="reset">Cancelar</button>
                    </div>
                </form>
            </div>
        </dialog>
        <dialog id="dialogAniadir">
            <div>
                <form method="post">
                    <p>Persona a invitar:</p>
                    <?php
                    $hay = true;
                    if (count($posibles) > 0) {
                    ?>
                        <select name="selectPersonas" id="selectPersonas">
                            <?php
                            foreach ($posibles as $posible) {
                                echo "<option value='$posible->user_nick'>$posible->user_nick</option>";
                            }
                            ?>
                        </select>
                    <?php
                    } else {
                        $hay = false;
                        echo "<p>No hay personas que se puedan añadir</p>";
                    }
                    ?>
                    <br>
                    <div>
                        <input type="submit" name="aniadirAGrupo" value="Añadir" <?php echo $hay ? '' : 'disabled' ?>>
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