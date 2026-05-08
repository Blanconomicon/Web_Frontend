<?php
require_once "../utility/utils.php";

//comprobar si se ha hecho login
comprobarLogin();

//si se quiere crear un grupo y el nombre es valido
if (isset($_POST['crearGrupo']) && trim($_POST['nombreGrupo']) != "") {
    crearGrupo($_POST['nombreGrupo']);
}

//si se quiere aniadir a alguien a un grupo
if (isset($_POST['aniadirAGrupo'])) {
    putGroupMember(getCon(), $_GET['idGrupo'], $_POST['selectPersonas']);
}

//si se quiere borrar un grupo
if (isset($_GET['grupoBorrar'])) {
    deleteGroup(getCon(), $_GET['grupoBorrar'], $_SESSION['user'][0]->user_nick);
}

//si se quiere salir de un grupo
if (isset($_GET['salirDelGrupo'])) {
    deleteGroupMember(getCon(), $_GET['salirDelGrupo'], $_SESSION['user'][0]->user_nick);
}


//lista de grupos
$grupos = obtenerGrupos($_SESSION['user'][0]->user_nick);
$posibles = [];

require_once "../includes/header.php";

?>
<main>
    <!-- Informacion de la Pagina -->
    <section class="contenedor">

        <?php
        //mostrar los grupos
        foreach ($grupos as $grupo) {
            echo "<div class='grid-2'>";
            echo "<p class='centrado'><a href='grupos.php?idGrupo=" . $grupo->group_id . "' class='centrado' style='margin: 0;'>" . $grupo->group_name . "</a></p>";

            // mostrar ELIMINAR o SALIR en funcion de si el grupo te pertenece
            if ($grupo->user_nick == $_SESSION['user'][0]->user_nick) {
                echo "<a href='grupos.php?grupoBorrar=" . $grupo->group_id . "' class='centrado ocupaTodo'><button class='ocupaTodo'>ELIMINAR</button></a>";
            } else {
                echo "<a href='grupos.php?salirDelGrupo=" . $grupo->group_id . "' class='centrado ocupaTodo'><button class='ocupaTodo'>SALIR</button></a>";
            }
            echo "</div>";
            echo "<br>";

            //mostrar la tabla con informacion del grupo
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
                <button id="btnAniadir" class="centrado" <?php echo ($grupo->user_nick == $_SESSION['user'][0]->user_nick) ? "" : "disabled"; ?>>Añadir gente</button>
                <br>
        <?php
            }
        }
        ?>
        <button id="btnNuevoGrupo" class="centrado">Nuevo grupo</button>

        <!-- dialogo para crear un grupo -->
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

        <!-- dialogo para aniadir a alguien a un grupo -->
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