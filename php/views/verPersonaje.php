<?php
require_once "../utility/utils.php";

comprobarLogin();

require_once "../includes/header.php";
?>

<?php
require_once "../includes/footer.php"
?>
<script src="../../js/menuHamburguesa.js"></script>
  <main class="dnd">
    <section class="dnd__sheet">

      <!-- CABECERA -->
      <div class="dnd__header">
        <div class="dnd__title">Nombre del personaje</div>
        <div class="dnd__text">Clase <span class="dnd__muted">- Subclase</span></div>
        <div class="dnd__text">Raza</div>
        <div class="dnd__text">Trasfondo</div>
      </div>

      <!-- ATRIBUTOS -->
      <div class="dnd__attributes">

        <div class="dnd__attribute">
          <div class="dnd__attr-name">Fuerza</div>
          <div class="dnd__attr-mod">Modificador</div>
          <div class="dnd__attr-score">10</div>
        </div>

        <div class="dnd__attribute">
          <div class="dnd__attr-name">Destreza</div>
          <div class="dnd__attr-mod">Modificador</div>
          <div class="dnd__attr-score">14</div>
        </div>

        <div class="dnd__attribute">
          <div class="dnd__attr-name">Constitución</div>
          <div class="dnd__attr-mod">Modificador</div>
          <div class="dnd__attr-score">12</div>
        </div>

        <div class="dnd__attribute">
          <div class="dnd__attr-name">Inteligencia</div>
          <div class="dnd__attr-mod">Modificador</div>
          <div class="dnd__attr-score">16</div>
        </div>

        <div class="dnd__attribute">
          <div class="dnd__attr-name">Sabiduría</div>
          <div class="dnd__attr-mod">Modificador</div>
          <div class="dnd__attr-score">11</div>
        </div>

        <div class="dnd__attribute">
          <div class="dnd__attr-name">Carisma</div>
          <div class="dnd__attr-mod">Modificador</div>
          <div class="dnd__attr-score">13</div>
        </div>

      </div>

      <!-- STATS -->
      <div class="dnd__stats">
        <div class="dnd__stat-box">CA</div>
        <div class="dnd__stat-box">Movimiento</div>
        <div class="dnd__stat-box">Bonificador de competencia</div>
      </div>

      <!-- BLOQUES -->
      <div class="dnd__block">
        <div class="dnd__block-title">Equipo</div>
        <div class="dnd__block-content"></div>
      </div>

      <div class="dnd__block">
        <div class="dnd__block-title">Características</div>
        <div class="dnd__block-content"></div>
      </div>

      <div class="dnd__block">
        <div class="dnd__block-title">Hechizos</div>
        <div class="dnd__block-content"></div>
      </div>

    </section>
  </main>
</body>

</html>