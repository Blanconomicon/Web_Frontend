<?php
//funcion que crea una conexion con la bd y devuelve la conexion o false
    function conexion(String $ruta,String $nombreDB,String $usuario,String $password){
        try{
            $con=new PDO("mysql:host=$ruta;dbname=$nombreDB",$usuario,$password);
            return $con;
        }catch(PDOException $e){
            echo $e->getMessage();
            return false;
        }
    }