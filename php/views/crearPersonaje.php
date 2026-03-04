<?php
require_once "../utility/utils.php";

comprobarLogin();

if (isset($_POST['siguiente'])) {
    $personaje = new stdClass();
    $personaje->nombre = $_POST["nombrePj"];
    $personaje->raza = $_POST["raza"];
    $personaje->clase = $_POST["clase"];
    $personaje->trasfondo = $_POST["trasfondo"];
    $personaje->fuerza = $_POST["selectFuerza"];
    $personaje->destreza = $_POST["selectDesteza"];
    $personaje->constitucion = $_POST["selectConstitucion"];
    $personaje->inteligencia = $_POST["selectInteligencia"];
    $personaje->sabiduria = $_POST["selectSabiduria"];
    $personaje->carisma = $_POST["selectCarisma"];
    $_SESSION['personaje'] = $personaje;
    header("Location: ./crearPersonaje2.php");
    exit();
}
$personaje = null;
if (isset($_SESSION['personaje'])) {
    $personaje = $_SESSION['personaje'];
}



//TODO cargar los selects
//TODO recargar los selects con lo que tuviera el personaje si se ha pulsado atras desde la siguente pagina

require_once "../includes/header.php";
?>
<main>
    <!-- Informacion de la Pagina -->
    <section class="contenedor">
        <form action="" method="post">
            <table>
                <tr>
                    <td colspan="2">
                        <input class="ocupaTodo" type="text" name="nombrePj" id="nombrePj" placeholder="Nombre del personaje" required value=<?php echo ($personaje != null) ? $personaje->nombre : "" ?>>
                    </td>
                </tr>
                <tr>
                    <td>
                        <select class="ocupaTodo" name="raza" id="raza">
                            <option value="RAZA">RAZA</option>
                        </select>
                    </td>
                    <td>
                        <select class="ocupaTodo" name="clase" id="clase">
                            <option value="CLASE">CLASE</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <select class="ocupaTodo" name="trasfondo" id="trasfondo">
                            <option value="TRASFONDO">TRASFONDO</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" id="tdCompraPuntos">
                        <h3 class="centrado">Compra de puntos</h3>
                        <p class="centrado"><b id="txtRestantes">27/27</b></p>
                        <table>
                            <tr>
                                <th>Fuerza</th>
                                <th>Desteza</th>
                                <th>Constitución</th>
                            </tr>
                            <tr>
                                <td>
                                    <select name="selectFuerza" id="selectFuerza">
                                        <?php
                                        for ($i = 8; $i <= 15; $i++) {
                                            $selected = ($personaje && $personaje->fuerza == $i) ? "selected" : "";
                                            echo "<option value='$i' $selected>$i</option>";
                                        }
                                        ?>
                                    </select>
                                    <br>
                                    <table>
                                        <tr>
                                            <th>Total</th>
                                            <td id="txtFuerzaTotal">8</td>
                                        </tr>
                                        <tr>
                                            <th>Modificador</th>
                                            <td id="txtFuerzaModificador">-1</td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                    <select name="selectDesteza" id="selectDesteza">
                                        <?php
                                        for ($i = 8; $i <= 15; $i++) {
                                            $selected = ($personaje && $personaje->destreza == $i) ? "selected" : "";
                                            echo "<option value='$i' $selected>$i</option>";
                                        }
                                        ?>
                                    </select>
                                    <br>
                                    <table>
                                        <tr>
                                            <th>Total</th>
                                            <td id="txtDestezaTotal">8</td>
                                        </tr>
                                        <tr>
                                            <th>Modificador</th>
                                            <td id="txtDestezaModificador">-1</td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                    <select name="selectConstitucion" id="selectConstitucion">
                                        <?php
                                        for ($i = 8; $i <= 15; $i++) {
                                            $selected = ($personaje && $personaje->constitucion == $i) ? "selected" : "";
                                            echo "<option value='$i' $selected>$i</option>";
                                        }
                                        ?>
                                    </select>
                                    <br>
                                    <table>
                                        <tr>
                                            <th>Total</th>
                                            <td id="txtConstitucionTotal">8</td>
                                        </tr>
                                        <tr>
                                            <th>Modificador</th>
                                            <td id="txtConstitucionModificador">-1</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <br>
                        <table>
                            <tr>
                                <th>Inteligencia</th>
                                <th>Sabiduría</th>
                                <th>Carisma</th>
                            </tr>
                            <tr>
                                <td>
                                    <select name="selectInteligencia" id="selectInteligencia">
                                        <?php
                                        for ($i = 8; $i <= 15; $i++) {
                                            $selected = ($personaje && $personaje->inteligencia == $i) ? "selected" : "";
                                            echo "<option value='$i' $selected>$i</option>";
                                        }
                                        ?>
                                    </select>
                                    <br>
                                    <table>
                                        <tr>
                                            <th>Total</th>
                                            <td id="txtInteligenciaTotal">8</td>
                                        </tr>
                                        <tr>
                                            <th>Modificador</th>
                                            <td id="txtInteligenciaModificador">-1</td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                    <select name="selectSabiduria" id="selectSabiduria">
                                        <?php
                                        for ($i = 8; $i <= 15; $i++) {
                                            $selected = ($personaje && $personaje->sabiduria == $i) ? "selected" : "";
                                            echo "<option value='$i' $selected>$i</option>";
                                        }
                                        ?>
                                    </select>
                                    <br>
                                    <table>
                                        <tr>
                                            <th>Total</th>
                                            <td id="txtSabiduriaTotal">8</td>
                                        </tr>
                                        <tr>
                                            <th>Modificador</th>
                                            <td id="txtSabiduriaModificador">-1</td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                    <select name="selectCarisma" id="selectCarisma">
                                        <?php
                                        for ($i = 8; $i <= 15; $i++) {
                                            $selected = ($personaje && $personaje->carisma == $i) ? "selected" : "";
                                            echo "<option value='$i' $selected>$i</option>";
                                        }
                                        ?>
                                    </select>
                                    <br>
                                    <table>
                                        <tr>
                                            <th>Total</th>
                                            <td id="txtCarismaTotal">8</td>
                                        </tr>
                                        <tr>
                                            <th>Modificador</th>
                                            <td id="txtCarismaModificador">-1</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="2"><input type="submit" id="btnSiguiente" name="siguiente" value="Siguiente"></td>
                </tr>
            </table>
        </form>
    </section>
</main>
<?php
require_once "../includes/footer.php"
?>
<script src="../../js/menuHamburguesa.js"></script>
<script src="../../js/compraPuntos.js"></script>
</body>

</html>