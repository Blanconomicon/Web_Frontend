<?php
require_once "../utility/utils.php";
require_once "../utility/conexion.php";

comprobarLogin();
if (!isset($_SESSION['personaje']) || isset($_POST["anterior"]) || !isset($_SESSION['personaje']->subraza)) {
    header("Location: ./crearPersonaje2.php");
    exit();
}
$personaje = $_SESSION["personaje"];

if (isset($_POST['siguiente'])) {
    //TODO arreglar con las caracteristicas de la clase
    $personaje->datosClase = $_POST["datosClase"];
    $_SESSION['personaje'] = $personaje;
    header("Location: ./crearPersonaje4.php");
    exit();
}


$clase=getClass(getCon(),$personaje->clase);
$traitsClase=getTraitClass(getCon(),$personaje->clase,1);

require_once "../includes/header.php";
?>
<main>
    <!-- Informacion de la Pagina -->
    <section class="contenedor">
        <form action="" method="post">
            <h2><?php echo $clase[0]->class_name; ?></h2>
            <div>
                <ul>
                    <?php
                    foreach ($traitsClase as $trait) {
                        echo "<li><b>".$trait->trait_name.": </b>".$trait->trait_desc."</li>";
                    }
                    ?>
                </ul>
            </div>
            <!-- TODO cambiar esto por la informacion de la clase -->
            <input type="hidden" name="datosClase" value="datosClase">
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