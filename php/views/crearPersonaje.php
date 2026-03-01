<?php
require_once "../utility/utils.php";

comprobarLogin();

//TODO cargar los selects

require_once "../includes/header.php";
?>
<main>
    <!-- Informacion de la Pagina -->
    <section class="contenedor">
        <form action="" method="post">
            <table>
                <tr>
                    <td colspan="2">
                        <input class="ocupaTodo" type="text" name="nombrePj" id="nombrePj" placeholder="Nombre del personaje">
                    </td>
                </tr>
                <tr>
                    <td>
                        <select class="ocupaTodo" name="raza" id="raza"></select>
                    </td>
                    <td>
                        <select class="ocupaTodo" name="clase" id="clase"></select>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <select class="ocupaTodo" name="trasfondo" id="trasfondo"></select>
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
                                    <select name="selectFuerza" id="selectFuerza"></select>
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
                                    <select name="selectDesteza" id="selectDesteza"></select>
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
                                    <select name="selectConstitucion" id="selectConstitucion"></select>
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
                                    <select name="selectInteligencia" id="selectInteligencia"></select>
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
                                    <select name="selectSabiduria" id="selectSabiduria"></select>
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
                                    <select name="selectCarisma" id="selectCarisma"></select>
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
                    <td colspan="2"><input type="submit" name="siguiente" value="Siguiente"></td>
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