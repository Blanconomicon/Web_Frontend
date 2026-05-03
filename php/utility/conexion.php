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
function getCharacter(PDO $con, $nick, $id = null)
{
    try {
        $stmt = $con->prepare("CALL getCharacter(:id, :nick)");
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->bindParam(":nick", $nick, PDO::PARAM_STR);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

// funcion para crar un personaje
function putCharacter(
    PDO $con,
    $nick,
    $nombrePersonaje,
    $idRaza,
    $idClase,
    $idTrasfondo,
    $str,
    $dex,
    $constitucion,
    $int,
    $wis,
    $cha,
    $maxHP,
    $idSubraza = null
) {
    try {
        $stmt = $con->prepare("CALL putCharacter(:nick, :nombrePersonaje, 
        :idRaza, :idSubraza, :idClase, :idTrasfondo, :str, :dex, :constitucion, 
        :int, :wis, :cha, :maxHP)");
        $stmt->bindParam(":nick", $nick, PDO::PARAM_STR);
        $stmt->bindParam(":nombrePersonaje", $nombrePersonaje, PDO::PARAM_STR);
        $stmt->bindParam(":idRaza", $idRaza, PDO::PARAM_INT);
        $stmt->bindParam(":idSubraza", $idSubraza, PDO::PARAM_INT);
        $stmt->bindParam(":idClase", $idClase, PDO::PARAM_INT);
        $stmt->bindParam(":idTrasfondo", $idTrasfondo, PDO::PARAM_INT);
        $stmt->bindParam(":str", $str, PDO::PARAM_INT);
        $stmt->bindParam(":dex", $dex, PDO::PARAM_INT);
        $stmt->bindParam(":constitucion", $constitucion, PDO::PARAM_INT);
        $stmt->bindParam(":int", $int, PDO::PARAM_INT);
        $stmt->bindParam(":wis", $wis, PDO::PARAM_INT);
        $stmt->bindParam(":cha", $cha, PDO::PARAM_INT);
        $stmt->bindParam(":maxHP", $maxHP, PDO::PARAM_INT);
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

function getTraitClass(PDO $con, $idClase, $nivelClase = null, $idSubclase = null)
{
    try {
        $stmt = $con->prepare("CALL getTraitClass(:idClase, :idSubclase, :nivelClase)");
        $stmt->bindParam("idClase", $idClase, PDO::PARAM_INT);
        $stmt->bindParam("nivelClase", $nivelClase, PDO::PARAM_INT);
        $stmt->bindParam("idSubclase", $idSubclase, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para obtener los grupos de un usuario
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

//funcion para aniadir un nuevo grupo
function putGroup(PDO $con, $nombreGrupo, $nick)
{
    try {
        $stmt = $con->prepare("CALL putGroup(:nombreGrupo, :nick)");
        $stmt->bindParam(":nombreGrupo", $nombreGrupo);
        $stmt->bindParam(":nick", $nick);

        $stmt->execute();

        $resultado = $stmt->fetch(PDO::FETCH_ASSOC);

        return $resultado['id'];

    } catch (PDOException $e) {
        echo $e->getMessage();
    }
}

function getNoGroupUser(PDO $con, $idGrupo)
{
    try {
        $stmt = $con->prepare("CALL getNoGroupUser(:idGrupo)");
        $stmt->bindParam(":idGrupo", $idGrupo, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//TODO arreglar cuando se arregle la consulta en la db
function putGroupMember(PDO $con, $grupoId, $nick, $rolId="J")
{
    try {
        $stmt = $con->prepare("CALL putGroupMembers(:grupoId, :nick, :rolId)");
        $stmt->bindParam(":grupoId", $grupoId, PDO::PARAM_INT);
        $stmt->bindParam(":nick", $nick, PDO::PARAM_STR);
        $stmt->bindParam(":rolId", $rolId, PDO::PARAM_STR);
        return $stmt->execute();
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}


//funcion para obtener los miembros de un grupo y su rol
function getGroupMembers(PDO $con, $id)
{
    try {
        $stmt = $con->prepare("CALL getGroupMembers(:id)");
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para obtener la contrasenia de un usuario por su nick
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

//funcion para obtener una lista de las razas/especies o la informacion de una raza/especie completo
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

//funcion para obtener las subrazas de una raza concreta
function getSubrace(PDO $con, $raceId, $subraceId = null)
{
    try {
        $stmt = $con->prepare("CALL getSubrace(:raceId, :subraceId)");
        $stmt->bindParam(":raceId", $raceId, PDO::PARAM_INT);
        $stmt->bindParam(":subraceId", $subraceId, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

function getTraitRace(PDO $con, $idRaza, $idSubraza = null)
{
    try {
        $stmt = $con->prepare("CALL getTraitRace(:idRaza, :idSubraza)");
        $stmt->bindParam("idRaza", $idRaza, PDO::PARAM_INT);
        $stmt->bindParam("idSubraza", $idSubraza, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para obtener el tamanio por su id
function getSize(PDO $con, $sizeId = null)
{
    try {
        $stmt = $con->prepare("CALL getSize(:id)");
        $stmt->bindParam(":id", $sizeId, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para obtener un usuario por su nick
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

//funcion para introducir un nuevo usuario en la db
function putUser(PDO $con, $nick, $username, $mail, $hash)
{
    try {
        $stmt = $con->prepare("CALL putUser(:nick, :username, :mail, :hash)");
        $stmt->bindParam(":nick", $nick, PDO::PARAM_STR);
        $stmt->bindParam(":username", $username, PDO::PARAM_STR);
        $stmt->bindParam(":mail", $mail, PDO::PARAM_STR);
        $stmt->bindParam(":hash", $hash, PDO::PARAM_STR);
        return $stmt->execute();
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}
