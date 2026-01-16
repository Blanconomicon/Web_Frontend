<?php
session_start();

//funcion para redirigir a login si no hay login realizado
function comprobarLogin()
{
    if (!isset($_SESSION['user'])) {
        header("Location: ../index.php");
        exit();
    }
}

//Funcion para el logout
function logout()
{
    session_destroy();
    header("Location: php/login.php");
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
    $usuarioCorrecto = true;
    if ($usuarioCorrecto) {
        //Si el usuario es correcto redirigir al index y registrarlo
        //TODO registrar al usuario
        $_SESSION['user'] = $user;
        header("Location: ../index.php");
        exit();
    }
}

//funcion para obtener los grupos de un usuario concreto y devuelve un array con estos
function obtenerGrupos($user)
{
    //TODO obtener los grupos a los que pertenece un usuario concreto
    $arrGrupo = [];
    return $arrGrupo;
}

//funcion para obtener todos los jugadores de un mismo grupo
function obtenerJugadores($idGrupo)
{
    //TODO obtener los jugadores de un grupo concreto (rol incluido????)
    $arrJugadores = [];
    return $arrJugadores;
}

//funcion para crear un nuevo grupo
function crearGrupo($nombre)
{
    //TODO crear el grupo

    header("Location: ./grupos.php");
    exit();
}
