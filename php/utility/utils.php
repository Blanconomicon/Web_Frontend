<?php

require_once __DIR__ . "/conexion.php";
require_once __DIR__ . "/config.php";
session_start();

$con = conexion(RUTA, DBNAME, USER, PASSWORD);

function getCon()
{
    global $con;
    return $con;
}

//--------------------------------------------
//FUNCIONES DE LOGIN
//--------------------------------------------

//funcion para redirigir a login si no hay login realizado
function comprobarLogin()
{
    if (!isset($_SESSION['user'])) {
        header("Location: ../../index.php");
        exit();
    }
}

//Funcion para el logout
function logout()
{
    session_destroy();
    header("Location: php/views/login.php");
}

//fucnion para comprobar el login
function loginOK(string $user, string $password)
{
    global $con;
    $passCorrecta = getPass($con, $user);
    if (count($passCorrecta) == 0) {
        return false;
    }
    return password_verify($password, $passCorrecta[0]->pass_hash);
}

//funcion para registrarse
function register(string $user, string $email, string $nombre, string $password, string $password2)
{
    global $con;
    $usuarioCorrecto = true;
    if ($password != $password2) {
        $usuarioCorrecto = false;
        return 'Las contraseñas deben coincidir';
    }
    $usuario = getUser($con, $user);
    if ($usuarioCorrecto && count($usuario) != 0) {
        $usuarioCorrecto = false;
        return 'El usuario ya existe ';
    }
    if ($usuarioCorrecto) {
        //Si el usuario es correcto redirigir al index y registrarlo
        putUser($con, $user, $nombre, $email, password_hash($password, PASSWORD_ARGON2ID));
        $usuario = getUser($con, $user);
        $_SESSION['user'] = $usuario;
        header("Location: ../../index.php");
        exit();
    }
}
//--------------------------------------------
//FUNCIONES DE GRUPOS
//--------------------------------------------

//funcion para obtener los grupos de un usuario concreto y devuelve un array con estos
function obtenerGrupos(string $user)
{
    global $con;
    $arrGrupos = getGroup($con, $user);
    return $arrGrupos;
}

//funcion para obtener todos los jugadores de un mismo grupo
function obtenerJugadores(int $idGrupo)
{
    global $con;
    $arrJugadores = getGroupMembers($con, $idGrupo);
    return $arrJugadores;
}

//funcion para crear un nuevo grupo
function crearGrupo(string $nombreGrupo)
{
    global $con;
    $id = putGroup($con, $nombreGrupo, $_SESSION['user'][0]->user_nick);
    putGroupMember($con, $id, $_SESSION['user'][0]->user_nick, "M");
}

//--------------------------------------------
//FUNCIONES DE PERSONAJES
//--------------------------------------------

//funcion para obtener todos los personajes de un usuario
function obtenerPersonajes(string $user)
{
    $arrPersonajes = getCharacter(getCon(), $user);
    return $arrPersonajes;
}

//funcion para obtener el modificador de una puntuacion
function obtenerModificador(int $puntuacion)
{
    return floor(($puntuacion - 10) / 2);
}

//funcion para mostrar las competencias del source
function mostrarCompetencias(
    array $competenciasSource,
    bool $seleccionandoCompetencias = false,
    array|null $competenciasTiene = null,
    int|null $cantidadCompetencias = null
) {
    //crear las competencias
    $competenciasArmas = array_filter($competenciasSource, function ($competencia) {
        return $competencia->prof_type == "weapon" || $competencia->prof_type == "group";
    });
    $competenciasHabilidades = array_filter($competenciasSource, function ($competencia) {
        return $competencia->prof_type == "skill";
    });
    $competenciasArmaduras = array_filter($competenciasSource, function ($competencia) {
        return $competencia->prof_type == "armor";
    });
    $competenciasHerramientas = array_filter($competenciasSource, function ($competencia) {
        return $competencia->prof_type == "tool";
    });
    $competenciasIdiomas = array_filter($competenciasSource, function ($competencia) {
        return $competencia->prof_type == "language";
    });
    //mostrar las competencias
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
        if ($seleccionandoCompetencias) {
            echo "<h4>Puedes elegir " . $cantidadCompetencias . " competencias</h4>";
            foreach ($competenciasHabilidades as $competencia) {
                echo "<input type='checkbox' value='" . $competencia->prof_id .
                    "' name='checkCompetencias[]'" . (in_array($competencia->prof_id, $competenciasTiene) ? "checked" : "") . ">"
                    . $competencia->prof_name . "</input><br>";
            }
        } else {
            echo "<ul>";
            foreach ($competenciasHabilidades as $competencia) {
                echo "<li>" . $competencia->prof_name . "</li>";
            }
            echo "</ul>";
        }
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
}

function mostrarTablaSpells(string $titulo, int $idClase, int $nivelSpell)
{
    $conjuros = getSpellClass(getCon(), $idClase, $nivelSpell);
    echo "<div class='conScroll'>";
    echo "<h3 class='centrado'>$titulo</h3>";
    echo "<br>";
    echo "<table style='width: 80%;'>";
    echo "<tr>";
    echo "<th></th>";
    echo "<th>Nombre</th>";
    echo "<th>Tiempo de lanzamiento</th>";
    echo "<th>Duracion</th>";
    echo "<th>Distancia</th>";
    echo "<th>Concentracion</th>";
    if ($nivelSpell > 0) {
        echo "<th>Ritual</th>";
    }
    echo "</tr>";
    foreach ($conjuros as $conjuro) {
        echo "<tr>";
        if (isset($_SESSION['personaje']->{strtolower($titulo)})) {
            echo "<td><input type='checkbox' value='" . $conjuro->spell_id . "' name='" . $titulo . "[]' " .
                (in_array($conjuro->spell_id, $_SESSION['personaje']->{strtolower($titulo)}) ? "checked" : "") .
                "></td>";
        } else {
            echo "<td><input type='checkbox' value='" . $conjuro->spell_id . "' name='" . $titulo . "[]' " .
                "></td>";
        }
        echo "<td>" . $conjuro->spell_name . "</td>";
        echo "<td>" . $conjuro->spell_cast_time . "</td>";
        echo "<td>" . $conjuro->spell_duration . "</td>";
        echo "<td>" . $conjuro->spell_range . "</td>";
        echo "<td><input type='checkbox' " . (($conjuro->spell_concentration) ? "checked" : "") . " disabled></td>";
        if ($nivelSpell > 0) {
            echo "<td><input type='checkbox' " . (($conjuro->spell_ritual) ? "checked" : "") . " disabled></td>";
        }
        echo "</tr>";
    }
    echo "</table>";
    echo "</div>";
}
