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
function getBackground(PDO $con, int|null $id = null)
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

//funcion para obtener las caracteristicas que aumenta un trasfondo
function getBackgroundAbility(PDO $con, int|null $id = null)
{
    try {
        $stmt = $con->prepare("CALL getBackgroundAbility(:id)");
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para obtener todos los datos de los trasfondos o de un trasfondo concreto
function getBackgroundFull(PDO $con, int $id)
{
    try {
        $stmt = $con->prepare("CALL getBackgroundFull(:id)");
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para obtener la informacion de un personaje
function getCharacter(PDO $con, string $nick, int|null $id = null)
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
    string $nick,
    string $nombrePersonaje,
    int $idRaza,
    int $idClase,
    int $idTrasfondo,
    int $str,
    int $dex,
    int $constitucion,
    int $int,
    int $wis,
    int $cha,
    int $maxHP,
    int $ca,
    int $iniciativa,
    int $gp,
    int|null $idSubraza = null
) {
    try {
        $stmt = $con->prepare("CALL putCharacter(:nick, :nombrePersonaje, 
        :idRaza, :idSubraza, :idClase, :idTrasfondo, :str, :dex, :constitucion, 
        :int, :wis, :cha, :maxHP, :ca, :iniciativa, :gp)");
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
        $stmt->bindParam(":ca", $ca, PDO::PARAM_INT);
        $stmt->bindParam(":iniciativa", $iniciativa, PDO::PARAM_INT);
        $stmt->bindParam(":gp", $gp, PDO::PARAM_INT);
        $stmt->execute();
        $resultado = $stmt->fetch(PDO::FETCH_ASSOC);
        return $resultado['character_id'];
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para borrar un personaje por su id
function deleteCharacter(PDO $con, int $idPersonaje, string $nick)
{
    try {
        $stmt = $con->prepare("CALL deleteCharacter(:idPersonaje,:nick)");
        $stmt->bindParam(":idPersonaje", $idPersonaje, PDO::PARAM_INT);
        $stmt->bindParam(":nick", $nick, PDO::PARAM_STR);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//Funcion para obtener una lista de las clases o la informacion de una clase completo
function getClass(PDO $con, int|null $id = null)
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

//funcion para obtener los traits de una clase concreta
function getTraitClass(PDO $con, int $idClase, int|null $nivelClase = null, int|null $idSubclase = null)
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

//funcion para obtener las competencias de una clase
function getProfClass(PDO $con, int $idClase, int|null $nivelClase = null)
{
    try {
        $stmt = $con->prepare("CALL getProfClass(:idClase, :nivelClase)");
        $stmt->bindParam("idClase", $idClase, PDO::PARAM_INT);
        $stmt->bindParam("nivelClase", $nivelClase, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para obtener la tabla de la clase o una linea de la tabla
function getClassLevelProgression(PDO $con, int $idClase, int|null $nivelClase = null)
{
    try {
        $stmt = $con->prepare("CALL getClassLevelProgression(:idClase, :nivelClase)");
        $stmt->bindParam("idClase", $idClase, PDO::PARAM_INT);
        $stmt->bindParam("nivelClase", $nivelClase, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para obtener los grupos de un usuario
function getGroup(PDO $con, string $nick, int|null $id = null)
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
function putGroup(PDO $con, string $nombreGrupo, string $nick)
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

//funcion para borrar un grupo por su id
function deleteGroup(PDO $con, int $idGrupo, string $nick)
{
    try {
        $stmt = $con->prepare("CALL deleteGroup(:idGrupo,:nick)");
        $stmt->bindParam(":idGrupo", $idGrupo, PDO::PARAM_INT);
        $stmt->bindParam(":nick", $nick, PDO::PARAM_STR);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para obtener los usuarios que no esten en un grupo
function getNoGroupUser(PDO $con, int $idGrupo)
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

//funcion para aniadir un miembro a un grupo
function putGroupMember(PDO $con, int $grupoId, string $nick, string $rolId = "J")
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
function getGroupMembers(PDO $con, int $id)
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

//funcion para borrar un grupo por su id
function deleteGroupMember(PDO $con, int $idGrupo, string $nick)
{
    try {
        $stmt = $con->prepare("CALL deleteGroupMember(:idGrupo,:nick)");
        $stmt->bindParam(":idGrupo", $idGrupo, PDO::PARAM_INT);
        $stmt->bindParam(":nick", $nick, PDO::PARAM_STR);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para obtener la contrasenia de un usuario por su nick
function getPass(PDO $con, string|null $nick = null)
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
function getRace(PDO $con, int|null $id = null)
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
function getSubrace(PDO $con, int $raceId, int|null $subraceId = null)
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

//funcion para obtener los traits de una raza y subraza
function getTraitRace(PDO $con, int $idRaza, int|null $idSubraza = null)
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

//funcion para obtener las competencias de las razas
function getProfRace(PDO $con, int|null $idRaza = null)
{
    try {
        $stmt = $con->prepare("CALL getProfRace(:idRaza)");
        $stmt->bindParam("idRaza", $idRaza, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para obtener el tamanio por su id
function getSize(PDO $con, int|null $sizeId = null)
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

//funcion para obtener los spells de una clase con un nivel
function getSpellClass(PDO $con, int $idClase, int|null $nivelConjuro = null)
{
    try {
        $stmt = $con->prepare("CALL getSpellClass(:idClase, :nivelConjuro)");
        $stmt->bindParam(":idClase", $idClase, PDO::PARAM_INT);
        $stmt->bindParam(":nivelConjuro", $nivelConjuro, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para obtener los spells 
function getSpell(PDO $con, int|null $idSpell = null, int|null $nivelConjuro = null)
{
    try {
        $stmt = $con->prepare("CALL getSpell(:idSpell, :nivelConjuro)");
        $stmt->bindParam(":idSpell", $idSpell, PDO::PARAM_INT);
        $stmt->bindParam(":nivelConjuro", $nivelConjuro, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para obtener los spells 
function getSpellSchool(PDO $con, int|null $idSpellSchool = null)
{
    try {
        $stmt = $con->prepare("CALL getSpellSchool(:idSpellSchool)");
        $stmt->bindParam(":idSpellSchool", $idSpellSchool, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para obtener un usuario por su nick
function getUser(PDO $con, string $nick)
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
function putUser(PDO $con, string $nick, string $username, string $mail, string $hash)
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

//funcion para obtener los bundle o un bundle concreto
function getBundle(PDO $con, int|null $idBundle = null)
{
    try {
        $stmt = $con->prepare("CALL getBundle(:idBundle)");
        $stmt->bindParam(":idBundle", $idBundle, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para obtener los objetos de un bundle concreto
function getBundleItems(PDO $con, int $idBundle)
{
    try {
        $stmt = $con->prepare("CALL getBundleItems(:idBundle)");
        $stmt->bindParam(":idBundle", $idBundle, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para obtener los bundle de una clase
function getClassBundle(PDO $con, int $idClase)
{
    try {
        $stmt = $con->prepare("CALL getClassBundle(:idClase)");
        $stmt->bindParam(":idClase", $idClase, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para obtener la informacion de las caracteristicas o de una caracteristica concreta
function getAbility(PDO $con, int|null $idCaracteristica = null)
{
    try {
        $stmt = $con->prepare("CALL getAbility(:idCaracteristica)");
        $stmt->bindParam(":idCaracteristica", $idCaracteristica, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para obtener la informacion de las habilidades o una habilidad concreta
function getSkill(PDO $con, int|null $idSkill = null)
{
    try {
        $stmt = $con->prepare("CALL getSkill(:idSkill)");
        $stmt->bindParam(":idSkill", $idSkill, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para obtener las habilidades en las que el personaje es competente
function getCharacterSkillProficiency(PDO $con, int $idPersonaje, int|null $idSkill = null)
{
    try {
        $stmt = $con->prepare("CALL getCharacterSkillProficiency(:idPersonaje, :idSkill)");
        $stmt->bindParam(":idPersonaje", $idPersonaje, PDO::PARAM_INT);
        $stmt->bindParam(":idSkill", $idSkill, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para aniadir una competencia o pericia al personaje
function putCharacterSkillProficiency(PDO $con, int $idPersonaje, int $idSkill, string $tipoCompetencia)
{
    try {
        $stmt = $con->prepare("CALL putCharacterSkillProficiency(:idPersonaje, :idSkill, :tipoCompetencia)");
        $stmt->bindParam(":idPersonaje", $idPersonaje, PDO::PARAM_INT);
        $stmt->bindParam(":idSkill", $idSkill, PDO::PARAM_INT);
        $stmt->bindParam(":tipoCompetencia", $tipoCompetencia, PDO::PARAM_STR);
        return $stmt->execute();
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para obtener los conjuros de un perosnaje
function getCharacterSpell(PDO $con, int $idPersonaje, int|null $idSpell = null)
{
    try {
        $stmt = $con->prepare("CALL getCharacterSpell(:idPersonaje, :idSpell)");
        $stmt->bindParam(":idPersonaje", $idPersonaje, PDO::PARAM_INT);
        $stmt->bindParam(":idSpell", $idSpell, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para aniadir un conjuro al personaje
function putCharacterSpell(PDO $con, int $idPersonaje, int $idSpell)
{
    try {
        $stmt = $con->prepare("CALL putCharacterSpell(:idPersonaje, :idSpell)");
        $stmt->bindParam(":idPersonaje", $idPersonaje, PDO::PARAM_INT);
        $stmt->bindParam(":idSpell", $idSpell, PDO::PARAM_INT);
        return $stmt->execute();
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para obtener un item concreto
function getItem(PDO $con, int $idObjeto)
{
    try {
        $stmt = $con->prepare("CALL getItem(:idObjeto)");
        $stmt->bindParam(":idObjeto", $idObjeto, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para obtener los objetos que posee un personaje
function getCharacterInventory(PDO $con, int $idPersonaje)
{
    try {
        $stmt = $con->prepare("CALL getCharacterInventory(:idPersonaje)");
        $stmt->bindParam(":idPersonaje", $idPersonaje, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para insertar un item en el inventario de un personaje
function putCharacterInventory(PDO $con, int $idPersonaje, int $idItem, int $cantidad)
{
    try {
        $stmt = $con->prepare("CALL putCharacterInventory(:idPersonaje, :idItem, :cantidad)");
        $stmt->bindParam(":idPersonaje", $idPersonaje, PDO::PARAM_INT);
        $stmt->bindParam(":idItem", $idItem, PDO::PARAM_INT);
        $stmt->bindParam(":cantidad", $cantidad, PDO::PARAM_INT);
        return $stmt->execute();
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para obtener las dotes o una dote concreta
function getFeat(PDO $con, int|null $idDote = null)
{
    try {
        $stmt = $con->prepare("CALL getFeat(:idDote)");
        $stmt->bindParam(":idDote", $idDote, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

//funcion para obtener la dote del trasfondo
function getBackgroundFeat(PDO $con, int $idTrasfondo)
{
    try {
        $stmt = $con->prepare("CALL getBackgroundFeat(:idTrasfondo)");
        $stmt->bindParam(":idTrasfondo", $idTrasfondo, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}
