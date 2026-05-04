<?php
require_once "../utility/utils.php";
require_once "../utility/conexion.php";

comprobarLogin();
if (!isset($_SESSION['personaje']) || isset($_POST["anterior"]) || !isset($_SESSION['personaje']->subraza)) {
    header("Location: ./crearPersonaje2.php");
    exit();
}
$personaje = $_SESSION["personaje"];
$clase = getClass(getCon(), $personaje->clase);

if (isset($_POST['siguiente'])) {
    $personaje->datosClase = $_POST["datosClase"];
    $personaje->pg = intval(substr($clase[0]->class_hpdice, 1)) + (($personaje->constitucion - 10) / 2);
    $_SESSION['personaje'] = $personaje;
    header("Location: ./crearPersonaje4.php");
    exit();
}

$traitsClase = getTraitClass(getCon(), $personaje->clase, 1);
$competenciasClase = getProfClass(getCon(), $personaje->clase, 1);
$competenciasArmas = array_filter($competenciasClase, function ($competencia) {
    return $competencia->prof_type == "weapon"||$competencia->prof_type == "group";
});
$competenciasHabilidades = array_filter($competenciasClase, function ($competencia) {
    return $competencia->prof_type == "skill";
});
$competenciasArmaduras = array_filter($competenciasClase, function ($competencia) {
    return $competencia->prof_type == "armor";
});
$competenciasHerramientas = array_filter($competenciasClase, function ($competencia) {
    return $competencia->prof_type == "tool";
});
$competenciasIdiomas = array_filter($competenciasClase, function ($competencia) {
    return $competencia->prof_type == "language";
});

require_once "../includes/header.php";
?>
<main>
    <!-- Informacion de la Pagina -->
    <section class="contenedor">
        <form action="" method="post">
            <h2><?php echo $clase[0]->class_name; ?></h2>
            <h3>Traits de la clase</h3>
            <ul>
                <?php
                foreach ($traitsClase as $trait) {
                    echo "<li><b>" . $trait->trait_name . ": </b>" . $trait->trait_desc . "</li>";
                }
                ?>
            </ul>
            <div class="gridResponsive">

                <?php
                if (count($competenciasArmas) > 0) {
                    echo "<div>";
                    echo "<h3>Competencias con armas</h3>";
                    echo "<ul>";
                    foreach ($competenciasArmas as $competencia) {
                        echo "<li>" . $competencia->prof_name . "</li>";
                    }
                    echo "</ul>";
                    echo "</div>";
                }
                if (count($competenciasHabilidades) > 0) {
                    echo "<div>";
                    echo "<h3>Competencias con habilidades</h3>";
                    echo "<ul>";
                    foreach ($competenciasHabilidades as $competencia) {
                        echo "<li>" . $competencia->prof_name . "</li>";
                    }
                    echo "</ul>";
                    echo "</div>";
                }
                if (count($competenciasArmaduras) > 0) {
                    echo "<div>";
                    echo "<h3>Competencias con armaduras</h3>";
                    echo "<ul>";
                    foreach ($competenciasArmaduras as $competencia) {
                        echo "<li>" . $competencia->prof_name . "</li>";
                    }
                    echo "</ul>";
                    echo "</div>";
                }
                if (count($competenciasHerramientas) > 0) {
                    echo "<div>";
                    echo "<h3>Competencias con herramientas</h3>";
                    echo "<ul>";
                    foreach ($competenciasHerramientas as $competencia) {
                        echo "<li>" . $competencia->prof_name . "</li>";
                    }
                    echo "</ul>";
                    echo "</div>";
                }
                if (count($competenciasIdiomas) > 0) {
                    echo "<div>";
                    echo "<h3>Competencias con idiomas</h3>";
                    echo "<ul>";
                    foreach ($competenciasIdiomas as $competencia) {
                        echo "<li>" . $competencia->prof_name . "</li>";
                    }
                    echo "</ul>";
                    echo "</div>";
                }
                ?>
            </div>
            <!-- TODO cambiar esto por la informacion de la clase -->
            <input type="hidden" name="datosClase" value="datosClase">
            <hr class="ocupaTodo">
            <div class="centrado">
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