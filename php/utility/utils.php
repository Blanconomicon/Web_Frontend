<?php

require_once __DIR__ . "/conexion.php";
require_once __DIR__ . "/config.php";
session_start();

$con = conexion(RUTA, DBNAME, USER, PASSWORD);

function getCon(){
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
function loginOK($user, $password)
{
    global $con;
    $passCorrecta = getPass($con, $user);
    if (count($passCorrecta) == 0) {
        return false;
    }
    return password_verify($password, $passCorrecta[0]->pass_hash);
}

//funcion para registrarse
function register($user, $email, $nombre, $password, $password2)
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
function obtenerGrupos($user)
{
    global $con;
    $arrGrupos = getGroup($con,$user);
    return $arrGrupos;
}

//funcion para obtener todos los jugadores de un mismo grupo
function obtenerJugadores($idGrupo)
{
    global $con;
    $arrJugadores = getGroupMembers($con,$idGrupo);
    return $arrJugadores;
}

//funcion para crear un nuevo grupo
function crearGrupo($nombreGrupo)
{
    global $con;
    $id=putGroup($con,$nombreGrupo,$_SESSION['user'][0]->user_nick);
    putGroupMember($con,$id,$_SESSION['user'][0]->user_nick,"M");
}

//--------------------------------------------
//FUNCIONES DE PERSONAJES
//--------------------------------------------

//funcion para obtener todos los personajes de un usuario
function obtenerPersonajes($user)
{
    $arrPersonajes = getCharacter(getCon(),$user);
    return $arrPersonajes;
}
