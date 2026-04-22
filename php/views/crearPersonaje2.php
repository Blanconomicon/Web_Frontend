<?php
require_once "../utility/utils.php";
require_once "../utility/conexion.php";

comprobarLogin();
if (!isset($_SESSION['personaje']) || isset($_POST["anterior"])) {
    header("Location: ./crearPersonaje.php");
    exit();
}
$personaje = $_SESSION["personaje"];

if (isset($_POST['siguiente'])) {
    //TODO arreglar con las caracteristicas de la raza
    $personaje->subraza = $_POST["subraza"];
    $_SESSION['personaje'] = $personaje;
    header("Location: ./crearPersonaje3.php");
    exit();
}

$raza = getRace($con, $personaje->raza);
$tamanios = getSize($con, $raza[0]->size_id);


//TODO cargar bien los select
require_once "../includes/header.php";
?>
<main>
    <!-- Informacion de la Pagina -->
    <section class="contenedor">
        <form action="" method="post">
            <h2><?php echo $raza[0]->race_name ?></h2>
            <select name="subraza" id="subraza">
                <option value="SUBRAZA">SUBRAZA</option>
            </select>
            <select name="tamanio" id="tamanio">
                <!-- <option value="tamanio">TAMAÑO EN SELECT SOLO SI SE PUEDE ELEGIR</option> -->
                <?php
                foreach ($tamanios as $tamanio) {
                    echo "<option value='$tamanio->size_id'>$tamanio->size_name</option>";
                }
                ?>
            </select>
            <div>
                <ul>
                    <?php
                    //TODO hacer que aparezca bien
                    foreach ($raza[0] as $nombreCaracteristica => $caracteristica) {
                        echo "<li><b>$nombreCaracteristica:</b>$caracteristica</li>";
                    }
                    ?>
                </ul>
            </div>
            <div>
                <input type="submit" name="anterior" value="Anterior">
                <input type="submit" name="siguiente" value="Siguiente">
            </div>
        </form>
    </section>
</main>
<?php
require_once "../includes/footer.php"
?>
<script src="../../js/menuHamburguesa.js"></script>
</body>

</html>