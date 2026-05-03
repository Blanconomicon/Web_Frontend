<?php
require_once "../utility/utils.php";
require_once "../utility/conexion.php";

comprobarLogin();
if (!isset($_SESSION['personaje']) || isset($_POST["anterior"]) || !isset($_SESSION['personaje']->subraza)) {
    header("Location: ./crearPersonaje2.php");
    exit();
}
$personaje = $_SESSION["personaje"];
$clase=getClass(getCon(),$personaje->clase);

if (isset($_POST['siguiente'])) {
    $personaje->datosClase = $_POST["datosClase"];
    $personaje->pg=intval(substr($clase[0]->class_hpdice,1))+(($personaje->constitucion-10)/2);
    $_SESSION['personaje'] = $personaje;
    header("Location: ./crearPersonaje4.php");
    exit();
}

$traitsClase=getTraitClass(getCon(),$personaje->clase,1);
$competenciasClase=getProfClass(getCon(),$personaje->clase,1);

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
                    foreach ($competenciasClase as $competencia) {
                        echo "<li><b>".$competencia->prof_type.": </b>".$competencia->prof_name."</li>";
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