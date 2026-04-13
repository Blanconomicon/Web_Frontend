<?php

require_once __DIR__."/conexion.php";
require_once __DIR__."/config.php";
session_start();

$con=conexion(RUTA,DBNAME,USER,PASSWORD);

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
    //TODO validar cuando este la DB conectada
    return true;
}

//funcion para registrarse
function register($user, $email, $nombre, $password, $password2)
{
    //TODO comprobar que el usuario no exista y que las passwords coinciden
    global $con;
    // getUser($con,$nombre);
    $usuarioCorrecto = true;
    if ($usuarioCorrecto) {
        //Si el usuario es correcto redirigir al index y registrarlo
        //TODO registrar al usuario
        $_SESSION['user'] = $user;
        header("Location: ../../index.php");
        exit();
    }else{

    }
}
//--------------------------------------------
//FUNCIONES DE GRUPOS
//--------------------------------------------

//funcion para obtener los grupos de un usuario concreto y devuelve un array con estos
function obtenerGrupos($user)
{
    //TODO obtener los grupos a los que pertenece un usuario concreto
    $arrGrupos = [];
    return $arrGrupos;
}

//funcion para obtener todos los jugadores de un mismo grupo
function obtenerJugadores($idGrupo)
{
    //TODO obtener los jugadores de un grupo concreto (nombre y rol)
    $arrJugadores = [];
    return $arrJugadores;
}

//funcion para crear un nuevo grupo
function crearGrupo($nombre)
{
    //TODO crear el grupo

}

//--------------------------------------------
//FUNCIONES DE PERSONAJES
//--------------------------------------------

//funcion para obtener todos los personajes de un usuario
function obtenerPersonajes($user){
    //TODO obtener los personajes de un jugador
    $arrPersonajes = [];
    return $arrPersonajes;
}