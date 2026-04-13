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

$raza=getRace($con,$personaje->raza);


//TODO cargar el select
require_once "../includes/header.php";
?>
<main>
    <!-- Informacion de la Pagina -->
    <section class="contenedor">
        <form action="" method="post">
            <h2><?php echo $raza[0]->race_name;?></h2>
            <select name="subraza" id="subraza">
                <option value="SUBRAZA">SUBRAZA</option>
            </select>
            <select name="tamanio" id="tamanio">
                <option value="tamanio">TAMAÑO EN SELECT SOLO SI SE PUEDE ELEGIR</option>
            </select>
            <div>
                CARACTERISTICAS DE LA RAZA Y SUBRAZA (VELOCIDAD INCLUIDA, 30 PIES SIEMPRE)
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