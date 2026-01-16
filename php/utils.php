<?php
session_start();

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
