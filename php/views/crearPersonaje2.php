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

$raza = getRace(getCon(), $personaje->raza);
$tamanios = getSize(getCon(), $raza[0]->size_id);
$subrazas = getSubrace(getCon(), $personaje->raza);
$traitsRaza=getTraitRace(getCon(),$personaje->raza);


//TODO cargar bien los select
require_once "../includes/header.php";
?>
<main>
    <!-- Informacion de la Pagina -->
    <section class="contenedor">
        <?php
        // var_dump($subrazas);
        ?>
        <form action="" method="post">
            <h2><?php echo $raza[0]->race_name ?></h2>
            <?php
                if(count($subrazas)>0){
            ?>
            <select name="subraza" id="subraza">
                <?php
                foreach ($subrazas as $subraza) {
                    echo "<option value='$subraza->subrace_id'>$subraza->subrace_name</option>";
                }
                ?>
                <!-- <option value="SUBRAZA">SUBRAZA</option> -->
            </select>
            <?php
                }
            ?>
            <select name="tamanio" id="tamanio">
                <!-- <option value="tamanio">TAMAÑO EN SELECT SOLO SI SE PUEDE ELEGIR</option> -->
                <?php
                echo "<option value='".$tamanios[0]->size_id."'>".$tamanios[0]->size_name."</option>";
                if($tamanios[0]->size_id==3 && $raza[0]->race_name!="Enano") {
                    echo "<option value='2'>Pequeño</option>";
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
                    foreach ($traitsRaza as $traitRaza) {
                        echo "<li><b>".$traitRaza->trait_name.":</b>".$traitRaza->trait_desc."</li>";
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