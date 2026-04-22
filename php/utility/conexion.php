<?php
//funcion que crea una conexion con la bd y devuelve la conexion o false
function conexion(String $ruta, String $nombreDB, String $usuario, String $password)
{
    try {
        $con = new PDO("mysql:host=$ruta;dbname=$nombreDB", $usuario, $password);
        return $con;
    } catch (PDOException $e) {
        echo $e->getMessage();
        return false;
    }
}

//Funcion para obtener una lista de los backgrounds o la informacion de un background completo
function getBackground(PDO $con, $id = null)
{
    try {
        $stmt = $con->prepare("CALL getBackground(:id)");
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//TODO poner el comentario bien
function getCharacter(PDO $con, $id = null, $nick = null)
{
    try {
        $stmt = $con->prepare("CALL getCharacter(:id, :nick)");
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->bindParam(":nick", $nick, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//Funcion para obtener una lista de las clases o la informacion de una clase completo
function getClass(PDO $con, $id = null)
{
    try {
        $stmt = $con->prepare("CALL getClass(:id)");
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//TODO poner el comentario
function getGroup(PDO $con, $nick, $id = null)
{
    try {
        $stmt = $con->prepare("CALL getGroup(:id, :nick)");
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->bindParam(":nick", $nick, PDO::PARAM_STR);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//TODO poner el comentario
function getGroupMembers(PDO $con, $id, $nick = null)
{
    try {
        $stmt = $con->prepare("CALL getGroupMembers(:id, :nick)");
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->bindParam(":nick", $nick, PDO::PARAM_STR);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//TODO poner el comentario
function getPass(PDO $con, $nick = null)
{
    try {
        $stmt = $con->prepare("CALL getPass(:nick)");
        $stmt->bindParam(":nick", $nick, PDO::PARAM_STR);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//Funcion para obtener una lista de las razas/especies o la informacion de una raza/especie completo
function getRace(PDO $con, $id = null)
{
    try {
        $stmt = $con->prepare("CALL getRace(:id)");
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

function getSize(PDO $con,$sizeId=null){
    try {
        $stmt = $con->prepare("CALL getSize(:id)");
        $stmt->bindParam(":id", $sizeId, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//TODO poner el comentario
function getUser(PDO $con, $nick)
{
    try {
        $stmt = $con->prepare("CALL getUser(:nick)");
        $stmt->bindParam(":nick", $nick, PDO::PARAM_STR);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//TODO poner el comentario
function putUser(PDO $con, $nick, $username, $mail, $hash, $salt)
{
    try {
        $stmt = $con->prepare("CALL putUser(:nick, :username, :mail, :hash, :salt)");
        $stmt->bindParam(":nick", $nick, PDO::PARAM_STR);
        $stmt->bindParam(":username", $username, PDO::PARAM_STR);
        $stmt->bindParam(":mail", $mail, PDO::PARAM_STR);
        $stmt->bindParam(":hash", $hash, PDO::PARAM_STR);
        $stmt->bindParam(":salt", $salt, PDO::PARAM_STR);
        return $stmt->execute();
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}
