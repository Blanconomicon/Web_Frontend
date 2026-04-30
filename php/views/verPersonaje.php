<?php
require_once "../utility/utils.php";

comprobarLogin();

// require_once "../includes/header.php";
?>

<?php
// require_once "../includes/footer.php"
?><html lang="es">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="author" content="Aketza Gonzalez Rey">
  <meta name="author" content="Daniel Alvarez Burgo">
  <meta name="description" content="Pagina principal en la cual, se muestra una breve descripcion de que es Blanconomicon">

  <link rel="stylesheet" href="../../css/verPersonaje.css">
  <link rel="icon" href="../../src/img/logo1.png" type="image/x-icon">
  <?php
  echo "<title>Blanconomicon | " . ucfirst(substr(basename($_SERVER['PHP_SELF']), 0, strlen(basename($_SERVER['PHP_SELF'])) - 4))
    . "</title>"
  ?>
</head>

<body>
  <main>
    <section class="dnd__sheet">

      <!-- CABECERA -->
      <div class="dnd__header">
        <div class="dnd__title">Nombre del personaje</div>
        <div class="dnd__text">Clase <span class="dnd__muted">- Subclase</span></div>
        <div class="dnd__text">Raza</div>
        <div class="dnd__text">Trasfondo</div>
      </div>

      <!-- STATS PRINCIPALES -->
      <div class="dnd__stats">
        <div class="dnd__stat-box">CA <br> 14</div>
        <div class="dnd__stat-box">Velocidad <br> 30</div>
        <div class="dnd__stat-box">Bonif. competencia <br> +2</div>
      </div>

      <!-- ATRIBUTOS + HABILIDADES -->
      <div class="dnd__columns">

        <!-- ATRIBUTOS -->
        <div class="dnd__attributes">

          <div class="dnd__attribute">
            <div class="dnd__attr-name">Fuerza</div>
            <div class="dnd__attr-mod">+2</div>
            <div class="dnd__attr-score">14</div>
          </div>

          <div class="dnd__attribute">
            <div class="dnd__attr-name">Destreza</div>
            <div class="dnd__attr-mod">+3</div>
            <div class="dnd__attr-score">16</div>
          </div>

          <div class="dnd__attribute">
            <div class="dnd__attr-name">Constitución</div>
            <div class="dnd__attr-mod">+1</div>
            <div class="dnd__attr-score">12</div>
          </div>

          <div class="dnd__attribute">
            <div class="dnd__attr-name">Inteligencia</div>
            <div class="dnd__attr-mod">+0</div>
            <div class="dnd__attr-score">10</div>
          </div>

          <div class="dnd__attribute">
            <div class="dnd__attr-name">Sabiduría</div>
            <div class="dnd__attr-mod">+1</div>
            <div class="dnd__attr-score">12</div>
          </div>

          <div class="dnd__attribute">
            <div class="dnd__attr-name">Carisma</div>
            <div class="dnd__attr-mod">+4</div>
            <div class="dnd__attr-score">18</div>
          </div>

        </div>

        <!-- HABILIDADES -->
        <div class="dnd__skills">

          <div class="dnd__skill"><span>Acrobacias</span><span class="dnd__skill-mod">+3</span></div>
          <div class="dnd__skill"><span>Arcanos</span><span class="dnd__skill-mod">+2</span></div>
          <div class="dnd__skill"><span>Atletismo</span><span class="dnd__skill-mod">+2</span></div>
          <div class="dnd__skill"><span>Engaño</span><span class="dnd__skill-mod">+6</span></div>
          <div class="dnd__skill"><span>Historia</span><span class="dnd__skill-mod">+2</span></div>
          <div class="dnd__skill"><span>Interpretación</span><span class="dnd__skill-mod">+6</span></div>
          <div class="dnd__skill"><span>Intimidación</span><span class="dnd__skill-mod">+4</span></div>
          <div class="dnd__skill"><span>Investigación</span><span class="dnd__skill-mod">+2</span></div>
          <div class="dnd__skill"><span>Juego de manos</span><span class="dnd__skill-mod">+5</span></div>
          <div class="dnd__skill"><span>Medicina</span><span class="dnd__skill-mod">+1</span></div>
          <div class="dnd__skill"><span>Naturaleza</span><span class="dnd__skill-mod">+2</span></div>
          <div class="dnd__skill"><span>Percepción</span><span class="dnd__skill-mod">+3</span></div>
          <div class="dnd__skill"><span>Perspicacia</span><span class="dnd__skill-mod">+3</span></div>
          <div class="dnd__skill"><span>Persuasión</span><span class="dnd__skill-mod">+6</span></div>
          <div class="dnd__skill"><span>Religión</span><span class="dnd__skill-mod">+2</span></div>
          <div class="dnd__skill"><span>Sigilo</span><span class="dnd__skill-mod">+3</span></div>
          <div class="dnd__skill"><span>Supervivencia</span><span class="dnd__skill-mod">+1</span></div>

        </div>

      </div>

      <!-- BLOQUES INFERIORES -->
      <div class="dnd__bottom">

        <div class="dnd__block">
          <div class="dnd__block-title">Equipo</div>
          <div class="dnd__block-content">
            <ul>
              <li>objeto1</li>
              <li>objeto2</li>
              <li>objeto3</li>
            </ul>
          </div>
        </div>

        <div class="dnd__block">
          <div class="dnd__block-title">Características</div>
          <div class="dnd__block-content">
            <ul>
              <li>feat1</li>
              <li>feat2</li>
              <li>feat3</li>
            </ul>
          </div>
        </div>

        <div class="dnd__block">
          <div class="dnd__block-title">Hechizos</div>
          <div class="dnd__block-content">
            <ul>
              <li>spell1</li>
              <li>spell2</li>
              <li>spell3</li>
            </ul>
          </div>
        </div>

      </div>

    </section>
  </main>
</body>

</html>