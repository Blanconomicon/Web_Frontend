-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 05-05-2026 a las 14:32:35
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `dbtfg`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCharacter` (IN `p_character_id` INT, IN `p_user_nick` VARCHAR(30))   BEGIN
    DELETE FROM `character`
    WHERE character_id = CONVERT(p_character_id USING utf8mb4)
      AND user_nick    = CONVERT(p_user_nick    USING utf8mb4);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAbility` (IN `p_id` INT)   BEGIN
    IF p_id IS NULL THEN
        SELECT *
        FROM ability;
    ELSE
        SELECT *
        FROM ability
        WHERE ability_id = CONVERT(p_id USING utf8mb4);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getBackground` (IN `p_id` INT)   BEGIN
    IF p_id IS NULL THEN
        SELECT background_id, background_name
        FROM background
        ORDER BY background_id;
    ELSE
        SELECT *
        FROM background
        WHERE background_id = CONVERT(p_id USING utf8mb4);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getBackgroundAbility` (IN `p_id` INT)   BEGIN
    IF p_id IS NULL THEN
        SELECT ba.background_id, b.background_name,
               ba.ability_id, a.ability_name, a.ability_abbr
        FROM background_ability ba
        INNER JOIN background b ON b.background_id = ba.background_id
        INNER JOIN ability    a ON a.ability_id    = ba.ability_id
        ORDER BY ba.background_id, ba.ability_id;
    ELSE
        SELECT ba.background_id,
               ba.ability_id, a.ability_name, a.ability_abbr
        FROM background_ability ba
        INNER JOIN ability a ON a.ability_id = ba.ability_id
        WHERE ba.background_id = CONVERT(p_id USING utf8mb4)
        ORDER BY ba.ability_id;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getBackgroundFull` (IN `p_id` INT)   BEGIN 
-- 1. Datos del trasfondo
    SELECT b.*
    FROM background b
    WHERE b.background_id = CONVERT(p_id USING utf8mb4);

    -- 2. Características que otorga (+2/+1/+1)
    SELECT ba.ability_id, a.ability_name, a.ability_abbr
    FROM background_ability ba
    INNER JOIN ability a ON a.ability_id = ba.ability_id
    WHERE ba.background_id = CONVERT(p_id USING utf8mb4)
    ORDER BY ba.ability_id;

    -- 3. Habilidades fijas
    SELECT bs.skill_id, s.skill_name
    FROM background_skill bs
    INNER JOIN skill s ON s.skill_id = bs.skill_id
    WHERE bs.background_id = CONVERT(p_id USING utf8mb4)
    ORDER BY s.skill_name;

    -- 4. Competencias de herramienta/idioma/vehículo
    SELECT bp.prof_id, p.prof_name, p.prof_type
    FROM background_prof bp
    INNER JOIN prof p ON p.prof_id = bp.prof_id
    WHERE bp.background_id = CONVERT(p_id USING utf8mb4)
    ORDER BY p.prof_type, p.prof_name;

    -- 5. Ítems del bundle asociado
    SELECT bi.item_id, i.item_name, bi.item_count,
           i.item_weight, i.item_price
    FROM background b
    INNER JOIN bundle_item bi ON bi.bundle_id = b.bundle_id
    INNER JOIN item        i  ON i.item_id    = bi.item_id
    WHERE b.background_id = CONVERT(p_id USING utf8mb4)
    ORDER BY i.item_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getBundle` (IN `p_id` INT)   BEGIN
    IF p_id IS NULL THEN
        SELECT bundle_id, bundle_name, bundle_price
        FROM bundle
        ORDER BY bundle_id;
    ELSE
        SELECT *
        FROM bundle
        WHERE bundle_id = CONVERT(p_id USING utf8mb4);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getBundleItems` (IN `p_id` INT)   BEGIN
	SELECT *
    FROM item
    WHERE EXISTS(
        SELECT *
    	FROM bundle_item
    	WHERE item.item_id = bundle_item.item_id
        AND bundle_item.bundle_id = p_id);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getCharacter` (IN `p_id` INT, IN `u_nick` VARCHAR(30))   BEGIN
    IF p_id IS NULL THEN
        SELECT character_id, character_name
        FROM `character`
        WHERE user_nick = CONVERT(u_nick USING utf8mb4);
    ELSE
        SELECT *
        FROM `character`
        WHERE character_id = CONVERT(p_id USING utf8mb4)
        AND user_nick = CONVERT(u_nick USING utf8mb4);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getCharacterSkillProficiency` (IN `char_id` INT, IN `p_id` INT)   BEGIN
IF p_id IS NULL THEN
     SELECT *
       FROM character_skill_proficiency
        WHERE character_id = CONVERT(char_id USING utf8mb4);
ELSE
     SELECT *
       FROM character_skill_proficiency
        WHERE character_id = CONVERT(char_id USING utf8mb4) AND
skill_id=CONVERT(p_id USING utf8mb4);
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getCharacterSpell` (IN `char_id` INT, IN `spell_id` INT)   BEGIN
    IF spell_id IS NULL THEN
        SELECT *
        FROM character_spell
WHERE character_id = CONVERT(char_id USING utf8mb4);
    ELSE
        SELECT *
        FROM character_spell
        WHERE character_id = CONVERT(char_id  USING utf8mb4) AND
spell_id = CONVERT(spell_id USING utf8mb4);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getClass` (IN `p_id` INT)   BEGIN
    IF p_id IS NULL THEN
        SELECT class_id, class_name
        FROM class
        ORDER BY class_name;
    ELSE
        SELECT *
        FROM class
        WHERE class_id = CONVERT(p_id USING utf8mb4)
        ORDER BY class_name;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getClassLevelProgression` (IN `p_id` INT, IN `p_level` INT)   BEGIN
    IF p_level IS NULL THEN
        SELECT *
        FROM class_level_progression
        WHERE class_id=CONVERT(p_id USING utf8mb4);
    ELSE
        SELECT *
        FROM class_level_progression
        WHERE class_id = CONVERT(p_id USING utf8mb4)
        AND level=CONVERT(p_level USING utf8mb4);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getGroup` (IN `p_id` INT, IN `u_nick` VARCHAR(20))   BEGIN
    IF p_id IS NULL THEN
        SELECT group_id, group_name
        FROM groups
        WHERE exists 
        	(SELECT * 
             FROM users_groups 
             WHERE groups.group_id = users_groups.group_id 
             AND user_nick = CONVERT(u_nick USING utf8mb4));
	ELSE
        SELECT *
        FROM groups
        WHERE exists
        	(SELECT * 
             FROM users_groups 
             WHERE users.user_nick = users_groups.user_nick
             AND group_id = CONVERT(p_id USING utf8mb4) 
             AND user_nick = CONVERT(u_nick USING utf8mb4));
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getGroupMembers` (IN `p_id` INT)   BEGIN
	SELECT 
        ug.group_id, 
        ug.user_nick, 
        r.rol_name
	FROM users_groups ug
	INNER JOIN rol r 
        ON r.rol_id = ug.rol_id
	WHERE ug.group_id = CONVERT(p_id USING utf8mb4);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getNoGroupUser` (IN `p_id` INT)   BEGIN
	SELECT 
        users.user_nick
        FROM users
	WHERE NOT EXISTS (
		SELECT *
		FROM users_groups
		WHERE users.user_nick = users_groups.user_nick
        AND users_groups.group_id = CONVERT(p_id USING utf8mb4)
	);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getPass` (IN `p_nick` VARCHAR(30))   BEGIN
	SELECT *
    FROM pass
    WHERE user_nick = CONVERT(p_nick USING utf8mb4);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getProfClass` (IN `p_id` INT, IN `p_lv` INT)   BEGIN
    IF p_lv IS NULL THEN
        SELECT pc.prof_id, pc.class_id, pc.class_lv,
               p.prof_type, p.prof_name
        FROM prof_class pc
        INNER JOIN prof p ON p.prof_id = pc.prof_id
        WHERE pc.class_id = CONVERT(p_id USING utf8mb4)
        ORDER BY pc.class_lv, p.prof_name;
    ELSE
        SELECT pc.prof_id, pc.class_id, pc.class_lv,
               p.prof_type, p.prof_name
        FROM prof_class pc
        INNER JOIN prof p ON p.prof_id = pc.prof_id
        WHERE pc.class_id = CONVERT(p_id USING utf8mb4)
          AND pc.class_lv <= CONVERT(p_lv USING utf8mb4)
        ORDER BY pc.class_lv, p.prof_name;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getProfRace` (IN `p_id` INT)   BEGIN
    IF p_id IS NULL THEN
        SELECT pr.prof_id, pr.race_id, pr.race_lv,
               p.prof_type, p.prof_name,
               r.race_name
        FROM prof_race pr
        INNER JOIN prof p  ON p.prof_id  = pr.prof_id
        INNER JOIN race r  ON r.race_id  = pr.race_id
        ORDER BY r.race_name, p.prof_name;
    ELSE
        SELECT pr.prof_id, pr.race_id, pr.race_lv,
               p.prof_type, p.prof_name
        FROM prof_race pr
        INNER JOIN prof p ON p.prof_id = pr.prof_id
        WHERE pr.race_id = CONVERT(p_id USING utf8mb4)
        ORDER BY p.prof_name;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getProfSubclass` (IN `p_class_id` INT, IN `p_subclass_id` INT)   BEGIN
    IF p_subclass_id IS NULL THEN
        SELECT psc.prof_id, psc.class_id, psc.subclass_id, psc.subclass_lv,
               p.prof_type, p.prof_name,
               sc.subclass_name
        FROM prof_subclass psc
        INNER JOIN prof     p   ON p.prof_id     = psc.prof_id
        INNER JOIN subclass sc  ON sc.class_id   = psc.class_id
                                AND sc.subclass_id = psc.subclass_id
        WHERE psc.class_id = CONVERT(p_class_id USING utf8mb4)
        ORDER BY psc.subclass_id, p.prof_name;
    ELSE
        SELECT psc.prof_id, psc.class_id, psc.subclass_id, psc.subclass_lv,
               p.prof_type, p.prof_name
        FROM prof_subclass psc
        INNER JOIN prof p ON p.prof_id = psc.prof_id
        WHERE psc.class_id   = CONVERT(p_class_id   USING utf8mb4)
          AND psc.subclass_id = CONVERT(p_subclass_id USING utf8mb4)
        ORDER BY p.prof_name;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getProfSubrace` (IN `p_race_id` INT, IN `p_subrace_id` INT)   BEGIN
    IF p_subrace_id IS NULL THEN
        -- Todas las subrazas de esa raza
        SELECT psr.prof_id, psr.race_id, psr.subrace_id, psr.subrace_lv,
               p.prof_type, p.prof_name,
               sr.subrace_name
        FROM prof_subrace psr
        INNER JOIN prof    p   ON p.prof_id    = psr.prof_id
        INNER JOIN subrace sr  ON sr.race_id   = psr.race_id
                               AND sr.subrace_id = psr.subrace_id
        WHERE psr.race_id = CONVERT(p_race_id USING utf8mb4)
        ORDER BY psr.subrace_id, p.prof_name;
    ELSE
        SELECT psr.prof_id, psr.race_id, psr.subrace_id, psr.subrace_lv,
               p.prof_type, p.prof_name
        FROM prof_subrace psr
        INNER JOIN prof p ON p.prof_id = psr.prof_id
        WHERE psr.race_id    = CONVERT(p_race_id    USING utf8mb4)
          AND psr.subrace_id = CONVERT(p_subrace_id USING utf8mb4)
        ORDER BY p.prof_name;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getRace` (IN `p_id` INT)   BEGIN
    IF p_id IS NULL THEN
        SELECT race_id, race_name
        FROM race
        ORDER BY race_name;
    ELSE
        SELECT *
        FROM race
        WHERE race_id = CONVERT(p_id USING utf8mb4)
        ORDER BY race_name;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSize` (IN `p_id` INT)   BEGIN
IF p_id IS NULL THEN
        SELECT size_id, size_name
        FROM size;
    ELSE
        SELECT *
        FROM size
        WHERE size_id = CONVERT(p_id USING utf8mb4);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSkill` (IN `p_id` INT)   BEGIN
    IF p_id IS NULL THEN
        SELECT *
        FROM skill;
    ELSE
        SELECT *
        FROM skill
        WHERE skill_id = CONVERT(p_id USING utf8mb4);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSpell` (IN `p_id` INT, IN `p_level` INT)   BEGIN
    IF p_id IS NOT NULL THEN
        SELECT * FROM spell WHERE spell_id = CONVERT(p_id USING utf8mb4);
    ELSEIF p_level IS NOT NULL THEN
        SELECT spell_id, spell_name, spell_level, spell_school_id,
               spell_ritual, spell_cast_time, spell_range, spell_duration,
               spell_concentration
        FROM spell
        WHERE spell_level = CONVERT(p_level USING utf8mb4)
        ORDER BY spell_name;
    ELSE
        SELECT spell_id, spell_name, spell_level, spell_school_id,
               spell_ritual, spell_cast_time, spell_range, spell_duration,
               spell_concentration
        FROM spell
        ORDER BY spell_level, spell_name;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSpellClass` (IN `p_class_id` INT, IN `p_level` INT)   BEGIN
    IF p_level IS NULL THEN
        SELECT s.spell_id, s.spell_name, s.spell_level,
               s.spell_ritual, s.spell_cast_time, s.spell_range,
               s.spell_duration, s.spell_concentration
        FROM spell_class sc
        INNER JOIN spell s ON s.spell_id = sc.spell_id
        WHERE sc.class_id = CONVERT(p_class_id USING utf8mb4)
        ORDER BY s.spell_level, s.spell_name;
    ELSE
        SELECT s.spell_id, s.spell_name, s.spell_level,
               s.spell_ritual, s.spell_cast_time, s.spell_range,
               s.spell_duration, s.spell_concentration
        FROM spell_class sc
        INNER JOIN spell s ON s.spell_id = sc.spell_id
        WHERE sc.class_id  = CONVERT(p_class_id USING utf8mb4)
          AND s.spell_level = CONVERT(p_level    USING utf8mb4)
        ORDER BY s.spell_name;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSpellSchool` (IN `p_id` INT)   BEGIN
    IF p_id IS NULL THEN
        SELECT *
        FROM spell_school;
    ELSE
        SELECT *
        FROM spell_school
        WHERE spell_school_id= CONVERT(p_id USING utf8mb4);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSubclass` (IN `p_id` INT, IN `p_subid` INT)   BEGIN
    IF p_subid IS NULL THEN
        SELECT class_id, subclass_id, subclass_name
        FROM subclass
        WHERE race_id = CONVERT(p_id USING utf8mb4)
        ORDER BY subclass_name;
    ELSE
        SELECT *
        FROM class
        WHERE class_id = CONVERT(p_id USING utf8mb4)
        AND subclass_id = CONVERT(p_subid USING utf8mb4)
        ORDER BY subclass_name;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSubclassNamed` (IN `p_id` INT, IN `p_subid` INT)   BEGIN
    IF p_subid IS NULL THEN
        SELECT sc.class_id, sc.subclass_id, sc.subclass_name, sc.subclass_desc
        FROM subclass sc
        WHERE sc.class_id = CONVERT(p_id USING utf8mb4)
        ORDER BY sc.subclass_name;
    ELSE
        SELECT sc.class_id, sc.subclass_id, sc.subclass_name, sc.subclass_desc
        FROM subclass sc
        WHERE sc.class_id   = CONVERT(p_id    USING utf8mb4)
          AND sc.subclass_id = CONVERT(p_subid USING utf8mb4);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSubrace` (IN `p_id` INT, IN `p_subid` INT)   BEGIN
    IF p_subid IS NULL THEN
        SELECT race_id, subrace_id, subrace_name
        FROM subrace
        WHERE race_id = CONVERT(p_id USING utf8mb4)
        ORDER BY subrace_name;
    ELSE
        SELECT *
        FROM subrace
        WHERE race_id = CONVERT(p_id USING utf8mb4)
        AND subrace_id = CONVERT(p_subid USING utf8mb4)
        ORDER BY subrace_name;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSubraceNamed` (IN `p_id` INT, IN `p_subid` INT)   BEGIN
    IF p_subid IS NULL THEN
        SELECT sr.race_id, sr.subrace_id, sr.subrace_name, sr.subrace_desc
        FROM subrace sr
        WHERE sr.race_id = CONVERT(p_id USING utf8mb4)
        ORDER BY sr.subrace_name;
    ELSE
        SELECT sr.race_id, sr.subrace_id, sr.subrace_name, sr.subrace_desc
        FROM subrace sr
        WHERE sr.race_id   = CONVERT(p_id    USING utf8mb4)
          AND sr.subrace_id = CONVERT(p_subid USING utf8mb4);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTrait` (IN `p_id` INT)   BEGIN
    IF p_id IS NULL THEN
        SELECT trait_id, trait_name, trait_desc
        FROM trait
        ORDER BY trait_name;
    ELSE
        SELECT trait_id, trait_name, trait_desc
        FROM trait
        WHERE trait_id = CONVERT(p_id USING utf8mb4);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTraitClass` (IN `p_class_id` INT, IN `p_subclass_id` INT, IN `p_lv` INT)   BEGIN
    IF p_subclass_id IS NULL THEN
        IF p_lv IS NULL THEN
            SELECT tc.trait_id, tc.class_id, tc.class_lv,
                   t.trait_name, t.trait_desc
            FROM trait_class tc
            INNER JOIN trait t ON t.trait_id = tc.trait_id
            WHERE tc.class_id = CONVERT(p_class_id USING utf8mb4)
            ORDER BY tc.class_lv, t.trait_name;
        ELSE
            SELECT tc.trait_id, tc.class_id, tc.class_lv,
                   t.trait_name, t.trait_desc
            FROM trait_class tc
            INNER JOIN trait t ON t.trait_id = tc.trait_id
            WHERE tc.class_id = CONVERT(p_class_id USING utf8mb4)
              AND tc.class_lv <= CONVERT(p_lv USING utf8mb4)
            ORDER BY tc.class_lv, t.trait_name;
        END IF;
    ELSE
        IF p_lv IS NULL THEN
            SELECT tsc.trait_id, tsc.class_id, tsc.subclass_id, tsc.subclass_lv,
                   t.trait_name, t.trait_desc
            FROM trait_subclass tsc
            INNER JOIN trait t ON t.trait_id = tsc.trait_id
            WHERE tsc.class_id   = CONVERT(p_class_id   USING utf8mb4)
              AND tsc.subclass_id = CONVERT(p_subclass_id USING utf8mb4)
            ORDER BY tsc.subclass_lv, t.trait_name;
        ELSE
            SELECT tsc.trait_id, tsc.class_id, tsc.subclass_id, tsc.subclass_lv,
                   t.trait_name, t.trait_desc
            FROM trait_subclass tsc
            INNER JOIN trait t ON t.trait_id = tsc.trait_id
            WHERE tsc.class_id    = CONVERT(p_class_id    USING utf8mb4)
              AND tsc.subclass_id  = CONVERT(p_subclass_id USING utf8mb4)
              AND tsc.subclass_lv <= CONVERT(p_lv USING utf8mb4)
            ORDER BY tsc.subclass_lv, t.trait_name;
        END IF;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTraitRace` (IN `p_race_id` INT, IN `p_subrace_id` INT)   BEGIN
    IF p_subrace_id IS NULL THEN
        -- Rasgos directos de la raza
        SELECT tr.trait_id, tr.race_id, tr.race_lv,
               t.trait_name, t.trait_desc
        FROM trait_race tr
        INNER JOIN trait t ON t.trait_id = tr.trait_id
        WHERE tr.race_id = CONVERT(p_race_id USING utf8mb4)
        ORDER BY tr.race_lv, t.trait_name;
    ELSE
        -- Rasgos de una subraza específica
        SELECT tsr.trait_id, tsr.race_id, tsr.subrace_id, tsr.subrace_lv,
               t.trait_name, t.trait_desc
        FROM trait_subrace tsr
        INNER JOIN trait t ON t.trait_id = tsr.trait_id
        WHERE tsr.race_id    = CONVERT(p_race_id    USING utf8mb4)
          AND tsr.subrace_id = CONVERT(p_subrace_id USING utf8mb4)
        ORDER BY tsr.subrace_lv, t.trait_name;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getUser` (IN `p_id` VARCHAR(30))   BEGIN
	IF checkUser(p_id) != 0 THEN
    	SELECT *
    	FROM users
    	WHERE users.user_nick = CONVERT(p_id USING utf8mb4);
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `putCharacter` (IN `p_user_nick` VARCHAR(30), IN `p_name` VARCHAR(30), IN `p_race_id` INT, IN `p_subrace_id` INT, IN `p_class_id` INT, IN `p_background_id` INT, IN `p_str` INT, IN `p_dex` INT, IN `p_con` INT, IN `p_int` INT, IN `p_wis` INT, IN `p_cha` INT, IN `p_max_hp` INT, IN `p_armor_class` INT, IN `p_initiative` INT)   BEGIN
    INSERT INTO `character` (
        user_nick, character_name, race_id, subrace_id, class_id, background_id,
        strength, dexterity, constitution, intelligence, wisdom, charisma,
        max_hp, current_hp, armor_class, initiative, character_date
    ) VALUES (
        p_user_nick, p_name, p_race_id, p_subrace_id, p_class_id, p_background_id,
        p_str, p_dex, p_con, p_int, p_wis, p_cha,
        p_max_hp, p_max_hp, p_armor_class, p_initiative, CURDATE()
    );
    SELECT LAST_INSERT_ID() AS character_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `putCharacterSkillProficiency` (IN `char_id` INT, IN `p_id` INT, IN `prof_type` VARCHAR(10))   BEGIN
	INSERT INTO `character_skill_proficiency` (`character_id`, `skill_id`, `proficiency_type`) 
    VALUES (char_id, p_id, prof_type);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `putCharacterSpell` (IN `char_id` INT, IN `p_id` INT)   BEGIN
INSERT INTO `character_spell` (`character_id`, `spell_id`) VALUES (char_id, p_id);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `putGroup` (IN `p_group_name` VARCHAR(30), IN `p_user_name` VARCHAR(50))   BEGIN
    INSERT INTO groups(groups.group_name,groups.user_name)
    VALUES(p_group_name,p_user_name);
SELECT LAST_INSERT_ID() AS id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `putGroupMembers` (IN `p_id` INT, IN `p_username` VARCHAR(30), IN `p_rol` CHAR(1))   BEGIN
	INSERT INTO users_groups(users_groups.group_id,users_groups.user_nick,users_groups.rol_id)
	VALUES(p_id,p_username,p_rol);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `putUser` (IN `p_nick` VARCHAR(30), IN `p_username` VARCHAR(30), IN `p_mail` VARCHAR(50), IN `p_hash` VARCHAR(255))   BEGIN
	INSERT INTO users(users.user_nick,users.user_name,users.user_mail)
	VALUES(p_nick,p_username,p_mail);
	INSERT INTO pass(pass.user_nick,pass.pass_hash)
    VALUES(p_nick,p_hash);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCharacterHP` (IN `p_character_id` INT, IN `p_current_hp` INT, IN `p_temp_hp` INT)   BEGIN
    UPDATE `character`
    SET current_hp = p_current_hp,
        temp_hp    = COALESCE(p_temp_hp, temp_hp)
    WHERE character_id = CONVERT(p_character_id USING utf8mb4);
END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `checkUser` (`p_id` VARCHAR(30)) RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE N INT;

    SELECT COUNT(*) INTO N
    FROM users
    WHERE user_nick = CONVERT(p_id USING utf8mb4);

    IF N = 0 THEN
        RETURN 0;
    ELSE
        RETURN 1;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ability`
--

CREATE TABLE `ability` (
  `ability_id` int(1) NOT NULL,
  `ability_name` varchar(20) NOT NULL,
  `ability_abbr` char(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ability`
--

INSERT INTO `ability` (`ability_id`, `ability_name`, `ability_abbr`) VALUES
(1, 'Fuerza', 'STR'),
(2, 'Destreza', 'DEX'),
(3, 'Constitución', 'CON'),
(4, 'Inteligencia', 'INT'),
(5, 'Sabiduría', 'WIS'),
(6, 'Carisma', 'CHA');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `armor_type`
--

CREATE TABLE `armor_type` (
  `armor_type_id` int(1) NOT NULL,
  `armor_type_name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `armor_type`
--

INSERT INTO `armor_type` (`armor_type_id`, `armor_type_name`) VALUES
(1, 'Ligera'),
(2, 'Media'),
(3, 'Pesada'),
(4, 'Escudo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `background`
--

CREATE TABLE `background` (
  `background_id` int(11) NOT NULL,
  `background_name` varchar(50) NOT NULL,
  `background_feat` int(6) NOT NULL,
  `skill_choice_count` int(1) NOT NULL DEFAULT 2,
  `tool_choice_count` int(1) NOT NULL DEFAULT 1,
  `language_choice_count` int(1) NOT NULL DEFAULT 1,
  `bundle_id` int(4) DEFAULT NULL,
  `suggested_personality_trait` text DEFAULT NULL,
  `suggested_ideals` text DEFAULT NULL,
  `suggested_bonds` text DEFAULT NULL,
  `suggested_flaws` text DEFAULT NULL,
  `feature_description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `background`
--

INSERT INTO `background` (`background_id`, `background_name`, `background_feat`, `skill_choice_count`, `tool_choice_count`, `language_choice_count`, `bundle_id`, `suggested_personality_trait`, `suggested_ideals`, `suggested_bonds`, `suggested_flaws`, `feature_description`) VALUES
(1, 'Acólito', 0, 0, 0, 2, 101, 'Cito las escrituras de mi fe para guiar a quienes me rodean. Veo las señales divinas en los eventos cotidianos.', 'Tradición. Los ritos sagrados deben preservarse exactamente. (Legal)\nCaridad. Sirvo a los necesitados sin esperar recompensa. (Bueno)\nPoder. La fe es el camino hacia la influencia y la grandeza. (Legal)', 'Daría mi vida por proteger el templo que me acogió.\nBusco recuperar un artefacto sagrado robado a mi congregación.', 'Soy intolerante con quienes no comparten mi fe.\nConfío ciegamente en la jerarquía de mi orden.', 'Refugio de los Fieles: tú y tus compañeros recibís alojamiento y comida gratis en cualquier templo de tu deidad o de deidades aliadas. Puedes realizar los ritos sagrados de tu fe.'),
(2, 'Charlatán', 0, 0, 0, 0, 102, 'Tengo siempre una historia preparada. Nadie sospecha de mi sonrisa. Me adapto a quien tenga delante.', 'Libertad. Nadie debería poder controlarme. (Caótico)\nAspiración. Me ganaré lo que merezco, de una forma u otra. (Cualquiera)', 'Alguien descubrió una de mis mentiras y ahora me persigue.\nProtejo a la única persona que conoce mi verdadera identidad.', 'No puedo evitar mentir, aunque la verdad sea más útil.\nSoy incapaz de resistir estafar a alguien más rico que yo.', 'Identidad Falsa: posees una segunda identidad completa con documentos falsificados, un disfraz convincente y una red de contactos que respaldan tu historia. Crear una nueva identidad requiere 1 semana y 25 po.'),
(3, 'Criminal', 0, 0, 0, 0, 103, 'Siempre tengo un plan de escape. Nunca muestro mis cartas hasta el momento adecuado.', 'Libertad. Las reglas son para quien no tiene el talento para evitarlas. (Caótico)\nLealtad. Traicionar a los tuyos es lo único imperdonable. (Legal)', 'Tengo una deuda de sangre con alguien del submundo.\nProtejo a mi familia de conocer mi vida real.', 'Traicionaría a casi cualquiera para salvar mi pellejo.\nSi veo una oportunidad de robo, me cuesta resistirla.', 'Contacto Criminal: tienes un enlace fiable en el submundo. Puedes pasar mensajes a otros criminales en la misma región y obtener información de la calle antes que nadie.'),
(4, 'Héroe del Pueblo', 0, 0, 0, 0, 104, 'Soy directo y prefiero la acción a las palabras largas. Confío en el trabajo duro y en las manos callosas.', 'Pueblo. Mi deber es proteger a los que no pueden protegerse solos. (Bueno)\nDestino. Fui elegido para hacer grandes cosas; lo siento. (Cualquiera)', 'Defiendo mi aldea natal de cualquier amenaza que se acerque.\nEl héroe que me inspiró de niño es mi modelo a seguir.', 'Desconfío de los nobles y los eruditos sin callos en las manos.\nCuando me propongo algo me vuelvo obsesivo hasta lograrlo.', 'Hospitalidad Rústica: la gente común te reconoce como uno de los suyos. Puedes encontrar refugio, comida básica y apoyo entre campesinos y aldeanos, que te ayudarán a ocultarte de nobles o soldados si es preciso.'),
(5, 'Marinero', 0, 0, 0, 0, 105, 'Me río ante el peligro y tengo una historia de mar para cada ocasión. El horizonte siempre me llama.', 'Respeto. En el mar, el capitán manda y su palabra es ley. (Legal)\nLibertad. Cada puerto es un nuevo comienzo. (Caótico)', 'Mi barco y su tripulación son mi familia; los protegeré siempre.\nDebo vengar la pérdida de un barco querido que naufragó.', 'Bebo demasiado cuando toco tierra y siempre acabo en problemas.\nNo confío en quien nunca ha visto el mar.', 'Pasaje en Barco: mientras no seas un fugitivo, puedes conseguir pasaje gratuito en barcos de vela para ti y hasta cinco compañeros, a cambio de trabajo durante la travesía.'),
(6, 'Noble', 0, 0, 0, 1, 106, 'Mis modales y lenguaje son impecables. Espero el mismo refinamiento en mis acompañantes.', 'Responsabilidad. El poder conlleva el deber de proteger a los más débiles. (Legal)\nFamilia. La sangre es lo más sagrado que existe. (Cualquiera)', 'Haré cualquier cosa por proteger el honor de mi linaje.\nBusco recuperar un tesoro familiar perdido o robado.', 'Soy condescendiente con quienes considero de menor cuna.\nGuardo un secreto que podría hundir a toda mi familia.', 'Privilegio de Rango: tu posición noble te abre puertas. La gente común te trata con deferencia y puedes obtener audiencia con aristócratas y funcionarios con facilidad, siempre que no estés en desgracia.'),
(7, 'Soldado', 0, 0, 0, 0, 107, 'Soy directo y disciplinado. Valoro la lealtad y el cumplimiento del deber por encima de todo.', 'Unidad. Solo juntos somos invencibles. (Legal)\nValentía. Nunca abandonar a un compañero en el campo. (Cualquiera)', 'Nunca olvidaré a los camaradas que cayeron a mi lado.\nDebo honrar el sacrificio de mi unidad cumpliendo su misión.', 'Obedezco órdenes sin cuestionarlas, incluso cuando debería.\nBusco peleas para demostrar que no he perdido mi habilidad.', 'Rango Militar: los soldados activos y veteranos reconocen tu autoridad. En territorios aliados puedes requisar equipo básico y alojamiento, y acceder a instalaciones militares.'),
(8, 'Ermitaño', 0, 0, 0, 1, 108, 'Soy tranquilo y reflexivo. Escucho más de lo que hablo, y cuando hablo, mis palabras pesan.', 'Sabiduría. El conocimiento interior es el camino hacia la verdad. (Neutral)\nVinculación. Debo compartir lo que aprendí con el mundo. (Bueno)', 'Mi retiro me reveló algo que el mundo necesita saber urgentemente.\nDebo proteger el lugar sagrado donde viví.', 'Me obsesiono con cuestiones filosóficas y pierdo el hilo práctico.\nMe cuesta confiar en los demás tras años de soledad.', 'Descubrimiento: durante tu retiro alcanzaste una revelación única, filosófica, espiritual o histórica. El DM decide los detalles; puede tener implicaciones importantes en la campaña.'),
(9, 'Artista', 0, 0, 0, 0, 109, 'Tengo una historia o canción para cada ocasión. Vivo para la atención y el aplauso del público.', 'Belleza. El arte eleva el alma y hace el mundo mejor. (Bueno)\nLibertad. El arte no puede vivir encadenado. (Caótico)', 'Mi instrumento es lo más preciado que tengo; me recuerda a alguien amado.\nQuiero inspirar a otros a superar sus propios límites con mi arte.', 'Haré cualquier cosa por la fama, incluyendo exagerar mis hazañas.\nUna vez que empiezo a actuar, es difícil que me detenga.', 'Por Amor al Arte: puedes conseguir alojamiento y comida básicos cada noche en tabernas, posadas u otros lugares donde tu arte sea apreciado, a cambio de actuar.'),
(10, 'Sabio', 0, 0, 0, 2, 110, 'Cito expertos y textos académicos constantemente. Soy preciso y metódico en mi razonamiento.', 'Conocimiento. El saber tiene valor intrínseco independientemente de su uso. (Neutral)\nLogro. Debo demostrar que soy el mejor en mi campo. (Cualquiera)', 'Mi investigación está dedicada a un objetivo más grande que yo mismo.\nDebo devolver un texto antiguo a su legítimo propietario.', 'Me distraen los misterios intelectuales incluso en medio del peligro.\nSubestimo a quienes no tienen mi nivel de formación académica.', 'Investigador: cuando intentas recordar o buscar un dato, si no lo conoces, siempre sabes a qué persona, biblioteca o institución acudir para encontrarlo.'),
(11, 'Callejero', 0, 0, 0, 0, 111, 'Duermo con un ojo abierto y siempre localizo la salida más cercana. Soy silencioso y observador.', 'Supervivencia. Lo primero es seguir vivo para ver mañana. (Neutral)\nSolidaridad. Protejo a los débiles porque yo fui uno de ellos. (Bueno)', 'La ciudad donde crecí es mi hogar y la defenderé.\nAlguien me ayudó cuando lo necesitaba; le debo lealtad eterna.', 'Tiendo a robar sin pensarlo cuando veo algo que necesito.\nNo confío en nadie, especialmente en figuras de autoridad.', 'Conocimiento de la Ciudad: conoces los callejones, escondites y pasajes secretos de cualquier ciudad donde hayas vivido. Puedes encontrar refugio, comida básica e información en el submundo urbano.'),
(12, 'Mercader', 0, 0, 0, 1, 112, 'Siempre veo el ángulo rentable en cualquier situación. Soy persuasivo y nunca hago una oferta sin conocer la respuesta.', 'Acuerdo. Un contrato firmado es sagrado; la palabra dada, también. (Legal)\nProsperidad. La riqueza es la medida del éxito personal. (Cualquiera)', 'Mi red de socios es mi familia; los protegeré a cualquier precio.\nDebo recuperar una mercancía valiosa que me fue robada.', 'El oro es mi prioridad, incluso por encima de mis amigos.\nVeo cada interacción como una transacción potencial.', 'Red Comercial: gracias a tus contactos mercantiles puedes conseguir bienes a precio de coste en ciudades importantes y tienes acceso a información sobre el mercado local antes que la mayoría.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `background_ability`
--

CREATE TABLE `background_ability` (
  `background_id` int(11) NOT NULL,
  `ability_id` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `background_ability`
--

INSERT INTO `background_ability` (`background_id`, `ability_id`) VALUES
(1, 4),
(1, 5),
(1, 6),
(2, 2),
(2, 4),
(2, 6),
(3, 2),
(3, 3),
(3, 4),
(4, 1),
(4, 3),
(4, 5),
(5, 1),
(5, 2),
(5, 5),
(6, 1),
(6, 4),
(6, 6),
(7, 1),
(7, 3),
(7, 5),
(8, 3),
(8, 4),
(8, 5),
(9, 2),
(9, 5),
(9, 6),
(10, 4),
(10, 5),
(10, 6),
(11, 2),
(11, 4),
(11, 6),
(12, 3),
(12, 4),
(12, 6);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `background_feat`
--

CREATE TABLE `background_feat` (
  `background_id` int(11) NOT NULL,
  `feat_id` int(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `background_prof`
--

CREATE TABLE `background_prof` (
  `background_id` int(11) NOT NULL,
  `prof_id` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `background_prof`
--

INSERT INTO `background_prof` (`background_id`, `prof_id`) VALUES
(2, 28),
(2, 42),
(3, 31),
(3, 52),
(4, 25),
(4, 55),
(5, 34),
(5, 59),
(6, 54),
(7, 52),
(7, 55),
(8, 44),
(9, 48),
(11, 31),
(12, 34);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `background_skill`
--

CREATE TABLE `background_skill` (
  `background_id` int(11) NOT NULL,
  `skill_id` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `background_skill`
--

INSERT INTO `background_skill` (`background_id`, `skill_id`) VALUES
(1, 13),
(1, 15),
(2, 4),
(2, 9),
(3, 4),
(3, 16),
(4, 17),
(4, 18),
(5, 2),
(5, 12),
(6, 5),
(6, 14),
(7, 2),
(7, 7),
(8, 10),
(8, 15),
(9, 1),
(9, 6),
(10, 3),
(10, 5),
(11, 9),
(11, 16),
(12, 13),
(12, 14);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bundle`
--

CREATE TABLE `bundle` (
  `bundle_id` int(4) NOT NULL,
  `bundle_name` varchar(50) NOT NULL,
  `bundle_price` float(11,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `bundle`
--

INSERT INTO `bundle` (`bundle_id`, `bundle_name`, `bundle_price`) VALUES
(1, 'Equipo de Aventurero', 19.00),
(2, 'Equipo de Explorador', 12.00),
(3, 'Equipo de Diplomático', 25.00),
(4, 'Equipo de Guerrero Básico', 50.00),
(5, 'Equipo de Mago Iniciado', 35.00),
(101, 'Equipo del Devoto (Acólito)', 15.00),
(102, 'Equipo del Estafador (Charlatán)', 20.00),
(103, 'Equipo del Infractor (Criminal)', 25.00),
(104, 'Equipo del Campesino Heroico (Héroe del pueblo)', 12.00),
(105, 'Equipo del Navegante (Marinero)', 18.00),
(106, 'Equipo del Aristócrata (Noble)', 30.00),
(107, 'Equipo del Veterano (Soldado)', 18.00),
(108, 'Equipo del Recluso (Ermitaño)', 10.00),
(109, 'Equipo del Artista Errante (Artista)', 22.00),
(110, 'Equipo del Erudito (Sabio)', 15.00),
(111, 'Equipo del Callejero (Huérfano)', 15.00),
(112, 'Equipo del Comerciante (Mercader)', 20.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bundle_item`
--

CREATE TABLE `bundle_item` (
  `bundle_id` int(4) NOT NULL,
  `item_id` int(10) NOT NULL,
  `item_count` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `bundle_item`
--

INSERT INTO `bundle_item` (`bundle_id`, `item_id`, `item_count`) VALUES
(101, 704, 5),
(101, 705, 1),
(101, 706, 1),
(101, 707, 1),
(101, 708, 5),
(101, 709, 1),
(101, 731, 1),
(102, 704, 5),
(102, 705, 1),
(102, 710, 1),
(102, 711, 1),
(102, 723, 1),
(102, 731, 1),
(102, 739, 1),
(103, 1, 1),
(103, 301, 1),
(103, 703, 2),
(103, 704, 5),
(103, 705, 1),
(103, 712, 1),
(103, 731, 1),
(104, 704, 10),
(104, 705, 1),
(104, 713, 1),
(104, 714, 1),
(104, 731, 1),
(104, 741, 1),
(105, 1, 1),
(105, 702, 1),
(105, 704, 10),
(105, 705, 1),
(105, 715, 1),
(105, 716, 1),
(105, 731, 1),
(105, 742, 1),
(106, 101, 1),
(106, 704, 15),
(106, 705, 1),
(106, 723, 1),
(106, 733, 1),
(106, 734, 1),
(106, 735, 1),
(107, 102, 1),
(107, 401, 1),
(107, 704, 10),
(107, 705, 1),
(107, 711, 1),
(107, 717, 1),
(107, 718, 1),
(107, 731, 1),
(107, 740, 1),
(108, 3, 1),
(108, 704, 8),
(108, 705, 1),
(108, 719, 1),
(108, 720, 1),
(108, 731, 1),
(108, 736, 1),
(109, 1, 1),
(109, 704, 10),
(109, 705, 1),
(109, 721, 1),
(109, 722, 1),
(109, 723, 1),
(109, 737, 1),
(110, 3, 1),
(110, 704, 8),
(110, 705, 1),
(110, 724, 1),
(110, 725, 1),
(110, 726, 1),
(110, 731, 1),
(110, 735, 1),
(111, 704, 5),
(111, 705, 1),
(111, 727, 1),
(111, 728, 1),
(111, 729, 1),
(111, 732, 1),
(111, 741, 1),
(112, 1, 1),
(112, 703, 3),
(112, 704, 12),
(112, 705, 1),
(112, 723, 1),
(112, 730, 1),
(112, 738, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `character`
--

CREATE TABLE `character` (
  `character_id` int(11) NOT NULL,
  `user_nick` varchar(30) NOT NULL,
  `character_name` varchar(30) NOT NULL,
  `character_level` int(2) NOT NULL DEFAULT 1,
  `race_id` int(2) NOT NULL,
  `subrace_id` int(4) DEFAULT NULL,
  `class_id` int(2) NOT NULL,
  `subclass_id` int(4) DEFAULT NULL,
  `background_id` int(4) DEFAULT NULL,
  `strength` int(2) NOT NULL DEFAULT 10,
  `dexterity` int(2) NOT NULL DEFAULT 10,
  `constitution` int(2) NOT NULL DEFAULT 10,
  `intelligence` int(2) NOT NULL DEFAULT 10,
  `wisdom` int(2) NOT NULL DEFAULT 10,
  `charisma` int(2) NOT NULL DEFAULT 10,
  `max_hp` int(4) NOT NULL,
  `current_hp` int(4) NOT NULL,
  `temp_hp` int(4) DEFAULT 0,
  `armor_class` int(2) NOT NULL DEFAULT 10,
  `initiative` int(2) NOT NULL DEFAULT 0,
  `speed` int(3) NOT NULL DEFAULT 30,
  `inspiration` tinyint(1) DEFAULT 0,
  `experience_points` int(6) DEFAULT 0,
  `alignment` varchar(20) DEFAULT NULL,
  `deity` varchar(30) DEFAULT NULL,
  `personality_trait` text DEFAULT NULL,
  `ideals` text DEFAULT NULL,
  `bonds` text DEFAULT NULL,
  `flaws` text DEFAULT NULL,
  `languages` text DEFAULT NULL,
  `proficiency_bonus` int(1) DEFAULT 2,
  `character_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `character`
--

INSERT INTO `character` (`character_id`, `user_nick`, `character_name`, `character_level`, `race_id`, `subrace_id`, `class_id`, `subclass_id`, `background_id`, `strength`, `dexterity`, `constitution`, `intelligence`, `wisdom`, `charisma`, `max_hp`, `current_hp`, `temp_hp`, `armor_class`, `initiative`, `speed`, `inspiration`, `experience_points`, `alignment`, `deity`, `personality_trait`, `ideals`, `bonds`, `flaws`, `languages`, `proficiency_bonus`, `character_date`) VALUES
(12, 'pako', 'otrdgrfgvfdgvfdzgv', 1, 7, 3, 2, NULL, 1, 15, 15, 15, 10, 8, 9, 10, 10, 0, 12, 2, 30, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, '2026-05-05'),
(13, 'pako', 'b', 1, 7, 3, 1, NULL, 1, 15, 15, 15, 10, 9, 8, 14, 14, 0, 14, 2, 30, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, '2026-05-05');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `character_feat`
--

CREATE TABLE `character_feat` (
  `character_id` int(11) NOT NULL,
  `feat_id` int(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `character_inventory`
--

CREATE TABLE `character_inventory` (
  `character_id` int(11) NOT NULL,
  `item_id` int(10) NOT NULL,
  `quantity` int(5) DEFAULT 1,
  `equipped` tinyint(1) DEFAULT 0,
  `notes` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `character_proficiency`
--

CREATE TABLE `character_proficiency` (
  `character_id` int(11) NOT NULL,
  `prof_id` int(5) NOT NULL,
  `proficiency_type` enum('proficient','expertise') DEFAULT 'proficient'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `character_skill_proficiency`
--

CREATE TABLE `character_skill_proficiency` (
  `character_id` int(11) NOT NULL,
  `skill_id` int(1) NOT NULL,
  `proficiency_type` enum('proficient','expertise') DEFAULT 'proficient'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `character_skill_proficiency`
--

INSERT INTO `character_skill_proficiency` (`character_id`, `skill_id`, `proficiency_type`) VALUES
(12, 1, 'proficient'),
(12, 4, 'proficient'),
(12, 6, 'proficient'),
(13, 7, 'proficient'),
(13, 12, 'proficient');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `character_spell`
--

CREATE TABLE `character_spell` (
  `character_id` int(11) NOT NULL,
  `spell_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `character_spell`
--

INSERT INTO `character_spell` (`character_id`, `spell_id`) VALUES
(12, 1),
(12, 8),
(12, 101),
(12, 102),
(12, 103),
(12, 109);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `class`
--

CREATE TABLE `class` (
  `class_id` int(2) NOT NULL,
  `class_name` varchar(30) NOT NULL,
  `class_hpdice` varchar(4) NOT NULL,
  `safe1_ability_id` int(1) NOT NULL,
  `safe2_ability_id` int(11) NOT NULL,
  `class_spellcaster` tinyint(1) NOT NULL,
  `spellcasting_ability` int(11) DEFAULT NULL,
  `class_bundle_id` int(4) NOT NULL,
  `prof_cuantity` int(11) NOT NULL DEFAULT 2
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `class`
--

INSERT INTO `class` (`class_id`, `class_name`, `class_hpdice`, `safe1_ability_id`, `safe2_ability_id`, `class_spellcaster`, `spellcasting_ability`, `class_bundle_id`, `prof_cuantity`) VALUES
(1, 'Bárbaro', 'd12', 1, 3, 0, NULL, 0, 2),
(2, 'Bardo', 'd8', 2, 6, 1, 6, 0, 3),
(3, 'Clérigo', 'd8', 5, 6, 1, 5, 0, 2),
(4, 'Druida', 'd8', 4, 5, 1, 5, 0, 2),
(5, 'Guerrero', 'd10', 1, 3, 0, 4, 0, 2),
(6, 'Mago', 'd6', 4, 5, 1, 4, 0, 2),
(7, 'Monje', 'd8', 1, 2, 0, NULL, 0, 2),
(8, 'Paladín', 'd10', 5, 6, 1, 6, 0, 2),
(9, 'Pícaro', 'd8', 2, 4, 0, 4, 0, 4),
(10, 'Explorador', 'd10', 1, 2, 0, 5, 0, 3),
(11, 'Hechicero', 'd6', 3, 6, 1, 6, 0, 2),
(12, 'Brujo', 'd8', 5, 6, 1, 6, 0, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `class_level_progression`
--

CREATE TABLE `class_level_progression` (
  `class_id` int(2) NOT NULL,
  `level` int(2) NOT NULL,
  `proficiency_bonus` int(1) NOT NULL,
  `features` text DEFAULT NULL,
  `cantrips_known` int(2) DEFAULT 0,
  `spells_known` int(2) DEFAULT 0,
  `spell_slots_1` int(2) DEFAULT 0,
  `spell_slots_2` int(2) DEFAULT 0,
  `spell_slots_3` int(2) DEFAULT 0,
  `spell_slots_4` int(2) DEFAULT 0,
  `spell_slots_5` int(2) DEFAULT 0,
  `spell_slots_6` int(2) DEFAULT 0,
  `spell_slots_7` int(2) DEFAULT 0,
  `spell_slots_8` int(2) DEFAULT 0,
  `spell_slots_9` int(2) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `class_level_progression`
--

INSERT INTO `class_level_progression` (`class_id`, `level`, `proficiency_bonus`, `features`, `cantrips_known`, `spells_known`, `spell_slots_1`, `spell_slots_2`, `spell_slots_3`, `spell_slots_4`, `spell_slots_5`, `spell_slots_6`, `spell_slots_7`, `spell_slots_8`, `spell_slots_9`) VALUES
(1, 1, 2, 'Furia (2), Defensa sin Armadura', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 2, 2, 'Ataque Temerario, Sentido del Peligro', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 3, 2, 'Camino del Bárbaro, Furia (3)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 4, 2, 'Mejora de Característica', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 5, 3, 'Ataque Extra, Movimiento Rápido', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 6, 3, 'Camino del Bárbaro (rasgo), Furia (4)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 7, 3, 'Instinto Salvaje, Instinto Feral', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 8, 3, 'Mejora de Característica', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 9, 4, 'Pensamiento Brutal, Furia (5)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 10, 4, 'Camino del Bárbaro (rasgo)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 11, 4, 'Furia (6)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 12, 4, 'Mejora de Característica', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 13, 5, 'Movimiento Imparable', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 14, 5, 'Camino del Bárbaro (rasgo)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 15, 5, 'Furia (7)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 16, 5, 'Mejora de Característica', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 17, 6, 'Ira Devastadora', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 18, 6, 'Poder Indomable, Furia (Ilimitada)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 19, 6, 'Mejora de Característica', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 20, 6, 'Campeón Primigenio', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 1, 2, 'Competencias de Habilidad (3), Inspiración Bárdica (d6)', 2, 4, 2, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 2, 2, 'Canción de Descanso (d6), Multicompetencia', 2, 5, 3, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 3, 2, 'Colegio de Bardo, Expertise', 2, 6, 4, 2, 0, 0, 0, 0, 0, 0, 0),
(2, 4, 2, 'Mejora de Característica', 3, 7, 4, 3, 0, 0, 0, 0, 0, 0, 0),
(2, 5, 3, 'Inspiración Bárdica (d8), Fuente de Inspiración', 3, 8, 4, 3, 2, 0, 0, 0, 0, 0, 0),
(2, 6, 3, 'Rasgo del Colegio, Contramagia', 3, 9, 4, 3, 3, 0, 0, 0, 0, 0, 0),
(2, 7, 3, 'Secretos Mágicos', 3, 10, 4, 3, 3, 1, 0, 0, 0, 0, 0),
(2, 8, 3, 'Mejora de Característica', 3, 11, 4, 3, 3, 2, 0, 0, 0, 0, 0),
(2, 9, 4, 'Canción de Descanso (d8), Inspiración Bárdica (d8)', 3, 12, 4, 3, 3, 3, 1, 0, 0, 0, 0),
(2, 10, 4, 'Secretos Mágicos, Expertise, Inspiración Bárdica (d10)', 4, 14, 4, 3, 3, 3, 2, 0, 0, 0, 0),
(2, 11, 4, 'Rasgo del Colegio', 4, 15, 4, 3, 3, 3, 2, 1, 0, 0, 0),
(2, 12, 4, 'Mejora de Característica', 4, 15, 4, 3, 3, 3, 2, 1, 0, 0, 0),
(2, 13, 5, 'Canción de Descanso (d10)', 4, 16, 4, 3, 3, 3, 2, 1, 1, 0, 0),
(2, 14, 5, 'Secretos Mágicos, Rasgo del Colegio', 4, 18, 4, 3, 3, 3, 2, 1, 1, 0, 0),
(2, 15, 5, 'Inspiración Bárdica (d12)', 4, 19, 4, 3, 3, 3, 2, 1, 1, 1, 0),
(2, 16, 5, 'Mejora de Característica', 4, 19, 4, 3, 3, 3, 2, 1, 1, 1, 0),
(2, 17, 6, 'Canción de Descanso (d12)', 4, 20, 4, 3, 3, 3, 2, 1, 1, 1, 1),
(2, 18, 6, 'Secretos Mágicos', 4, 22, 4, 3, 3, 3, 3, 1, 1, 1, 1),
(2, 19, 6, 'Mejora de Característica', 4, 22, 4, 3, 3, 3, 3, 2, 1, 1, 1),
(2, 20, 6, 'Inspiración Bárdica Superior', 4, 22, 4, 3, 3, 3, 3, 2, 2, 1, 1),
(3, 1, 2, 'Conjuros de Dominio, Lanzamiento de Conjuros', 3, 4, 2, 0, 0, 0, 0, 0, 0, 0, 0),
(3, 2, 2, 'Canal de Divinidad (1/descC), Conjuros de Dominio', 3, 6, 3, 0, 0, 0, 0, 0, 0, 0, 0),
(3, 3, 2, 'Conjuros de Dominio', 3, 8, 4, 2, 0, 0, 0, 0, 0, 0, 0),
(3, 4, 2, 'Mejora de Característica', 4, 10, 4, 3, 0, 0, 0, 0, 0, 0, 0),
(3, 5, 3, 'Destruir No Muertos (VD 1/2), Conjuros de Dominio', 4, 12, 4, 3, 2, 0, 0, 0, 0, 0, 0),
(3, 6, 3, 'Canal de Divinidad (2/descC), Rasgo de Dominio', 4, 14, 4, 3, 3, 0, 0, 0, 0, 0, 0),
(3, 7, 3, 'Conjuros de Dominio', 4, 16, 4, 3, 3, 1, 0, 0, 0, 0, 0),
(3, 8, 3, 'Mejora de Característica, Golpe Divino, Destruir No Muertos (VD 1)', 4, 18, 4, 3, 3, 2, 0, 0, 0, 0, 0),
(3, 9, 4, 'Conjuros de Dominio', 4, 20, 4, 3, 3, 3, 1, 0, 0, 0, 0),
(3, 10, 4, 'Intervención Divina', 5, 22, 4, 3, 3, 3, 2, 0, 0, 0, 0),
(3, 11, 4, 'Destruir No Muertos (VD 2)', 5, 24, 4, 3, 3, 3, 2, 1, 0, 0, 0),
(3, 12, 4, 'Mejora de Característica', 5, 24, 4, 3, 3, 3, 2, 1, 0, 0, 0),
(3, 13, 5, 'Destruir No Muertos (VD 3)', 5, 26, 4, 3, 3, 3, 2, 1, 1, 0, 0),
(3, 14, 5, 'Rasgo de Dominio', 5, 28, 4, 3, 3, 3, 2, 1, 1, 0, 0),
(3, 15, 5, 'Destruir No Muertos (VD 4)', 5, 30, 4, 3, 3, 3, 2, 1, 1, 1, 0),
(3, 16, 5, 'Mejora de Característica', 5, 30, 4, 3, 3, 3, 2, 1, 1, 1, 0),
(3, 17, 6, 'Destruir No Muertos (VD 4), Canal de Divinidad (3/descC)', 5, 32, 4, 3, 3, 3, 2, 1, 1, 1, 1),
(3, 18, 6, 'Canal de Divinidad (3/descC)', 5, 32, 4, 3, 3, 3, 3, 1, 1, 1, 1),
(3, 19, 6, 'Mejora de Característica', 5, 34, 4, 3, 3, 3, 3, 2, 1, 1, 1),
(3, 20, 6, 'Intervención Divina Mejorada', 5, 36, 4, 3, 3, 3, 3, 2, 2, 1, 1),
(4, 1, 2, 'Lanzamiento de Conjuros, Druídico', 2, 4, 2, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 2, 2, 'Forma Salvaje (VD 1/4), Círculo de Druida', 2, 5, 3, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 3, 2, 'Forma Salvaje (VD 1/2)', 2, 6, 4, 2, 0, 0, 0, 0, 0, 0, 0),
(4, 4, 2, 'Mejora de Característica, Forma Salvaje (vuelo)', 3, 7, 4, 3, 0, 0, 0, 0, 0, 0, 0),
(4, 5, 3, 'Rasgo de Círculo', 3, 8, 4, 3, 2, 0, 0, 0, 0, 0, 0),
(4, 6, 3, 'Forma Salvaje mejorada, Rasgo de Círculo', 3, 9, 4, 3, 3, 0, 0, 0, 0, 0, 0),
(4, 7, 3, 'Rasgo de Círculo', 3, 10, 4, 3, 3, 1, 0, 0, 0, 0, 0),
(4, 8, 3, 'Mejora de Característica, Forma Salvaje (VD 1)', 3, 11, 4, 3, 3, 2, 0, 0, 0, 0, 0),
(4, 9, 4, 'Rasgo de Círculo', 3, 12, 4, 3, 3, 3, 1, 0, 0, 0, 0),
(4, 10, 4, 'Rasgo de Círculo, Forma Salvaje (VD 2)', 4, 14, 4, 3, 3, 3, 2, 0, 0, 0, 0),
(4, 11, 4, NULL, 4, 15, 4, 3, 3, 3, 2, 1, 0, 0, 0),
(4, 12, 4, 'Mejora de Característica', 4, 15, 4, 3, 3, 3, 2, 1, 0, 0, 0),
(4, 13, 5, NULL, 4, 16, 4, 3, 3, 3, 2, 1, 1, 0, 0),
(4, 14, 5, 'Rasgo de Círculo', 4, 18, 4, 3, 3, 3, 2, 1, 1, 0, 0),
(4, 15, 5, 'Forma Salvaje (VD 3)', 4, 19, 4, 3, 3, 3, 2, 1, 1, 1, 0),
(4, 16, 5, 'Mejora de Característica', 4, 19, 4, 3, 3, 3, 2, 1, 1, 1, 0),
(4, 17, 6, NULL, 4, 20, 4, 3, 3, 3, 2, 1, 1, 1, 1),
(4, 18, 6, 'Hechizos de Mente en Blanco, Alma de la Bestia', 4, 22, 4, 3, 3, 3, 3, 1, 1, 1, 1),
(4, 19, 6, 'Mejora de Característica', 4, 22, 4, 3, 3, 3, 3, 2, 1, 1, 1),
(4, 20, 6, 'Archidruida', 4, 22, 4, 3, 3, 3, 3, 2, 2, 1, 1),
(5, 1, 2, 'Estilo de Combate, Segundo Viento', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 2, 2, 'Acción Súbita', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 3, 2, 'Arquetipo Marcial', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 4, 2, 'Mejora de Característica', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 5, 3, 'Ataque Extra (2)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 6, 3, 'Mejora de Característica', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 7, 3, 'Rasgo de Arquetipo', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 8, 3, 'Mejora de Característica', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 9, 4, 'Indomable (1 uso)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 10, 4, 'Rasgo de Arquetipo', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 11, 4, 'Ataque Extra (3)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 12, 4, 'Mejora de Característica', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 13, 5, 'Indomable (2 usos)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 14, 5, 'Mejora de Característica', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 15, 5, 'Rasgo de Arquetipo', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 16, 5, 'Mejora de Característica', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 17, 6, 'Acción Súbita (2 usos), Indomable (3 usos)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 18, 6, 'Rasgo de Arquetipo', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 19, 6, 'Mejora de Característica', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 20, 6, 'Ataque Extra (4)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(6, 1, 2, 'Lanzamiento de Conjuros, Recuperación Arcana', 3, 6, 2, 0, 0, 0, 0, 0, 0, 0, 0),
(6, 2, 2, 'Tradición Arcana', 3, 8, 3, 0, 0, 0, 0, 0, 0, 0, 0),
(6, 3, 2, NULL, 3, 10, 4, 2, 0, 0, 0, 0, 0, 0, 0),
(6, 4, 2, 'Mejora de Característica', 4, 12, 4, 3, 0, 0, 0, 0, 0, 0, 0),
(6, 5, 3, NULL, 4, 14, 4, 3, 2, 0, 0, 0, 0, 0, 0),
(6, 6, 3, 'Rasgo de Tradición Arcana', 4, 16, 4, 3, 3, 0, 0, 0, 0, 0, 0),
(6, 7, 3, NULL, 4, 18, 4, 3, 3, 1, 0, 0, 0, 0, 0),
(6, 8, 3, 'Mejora de Característica', 4, 20, 4, 3, 3, 2, 0, 0, 0, 0, 0),
(6, 9, 4, NULL, 4, 22, 4, 3, 3, 3, 1, 0, 0, 0, 0),
(6, 10, 4, 'Rasgo de Tradición Arcana', 5, 24, 4, 3, 3, 3, 2, 0, 0, 0, 0),
(6, 11, 4, NULL, 5, 26, 4, 3, 3, 3, 2, 1, 0, 0, 0),
(6, 12, 4, 'Mejora de Característica', 5, 26, 4, 3, 3, 3, 2, 1, 0, 0, 0),
(6, 13, 5, NULL, 5, 28, 4, 3, 3, 3, 2, 1, 1, 0, 0),
(6, 14, 5, 'Rasgo de Tradición Arcana', 5, 30, 4, 3, 3, 3, 2, 1, 1, 0, 0),
(6, 15, 5, NULL, 5, 32, 4, 3, 3, 3, 2, 1, 1, 1, 0),
(6, 16, 5, 'Mejora de Característica', 5, 32, 4, 3, 3, 3, 2, 1, 1, 1, 0),
(6, 17, 6, NULL, 5, 34, 4, 3, 3, 3, 2, 1, 1, 1, 1),
(6, 18, 6, 'Dominio de Hechizo', 5, 36, 4, 3, 3, 3, 3, 1, 1, 1, 1),
(6, 19, 6, 'Mejora de Característica', 5, 38, 4, 3, 3, 3, 3, 2, 1, 1, 1),
(6, 20, 6, 'Hechizo Señalado', 5, 40, 4, 3, 3, 3, 3, 2, 2, 1, 1),
(7, 1, 2, 'Defensa sin Armadura, Artes Marciales (d4)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(7, 2, 2, 'Ki (2 puntos), Movimiento sin Armadura (+3m)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(7, 3, 2, 'Tradición Monástica, Parar Proyectiles', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(7, 4, 2, 'Mejora de Característica, Caída Lenta', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(7, 5, 3, 'Ataque Extra, Golpe Aturdidor, Artes Marciales (d6)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(7, 6, 3, 'Golpe de Ki, Rasgo de Tradición, Movimiento sin Armadura (+4,5m)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(7, 7, 3, 'Evasión, Tranquilidad del Alma', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(7, 8, 3, 'Mejora de Característica', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(7, 9, 4, 'Movimiento sin Armadura (+6m, trepar/correr en agua)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(7, 10, 4, 'Rasgo de Tradición, Purity of Body', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(7, 11, 4, 'Visión de Sombras, Artes Marciales (d8)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(7, 12, 4, 'Mejora de Característica', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(7, 13, 5, 'Lengua del Sol y la Luna', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(7, 14, 5, 'Alma de Diamante', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(7, 15, 5, 'Mente en Blanco Atemporal', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(7, 16, 5, 'Mejora de Característica, Artes Marciales (d10)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(7, 17, 6, 'Rasgo de Tradición', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(7, 18, 6, 'Cuerpo Vacío', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(7, 19, 6, 'Mejora de Característica', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(7, 20, 6, 'Ser Perfecto, Artes Marciales (d12)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(8, 1, 2, 'Detección Divina, Imposición de Manos', 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0),
(8, 2, 2, 'Estilo de Combate, Lanzamiento de Conjuros, Golpe Divino', 0, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0),
(8, 3, 2, 'Juramento Sagrado, Canal de Divinidad', 0, 4, 3, 0, 0, 0, 0, 0, 0, 0, 0),
(8, 4, 2, 'Mejora de Característica', 0, 5, 3, 0, 0, 0, 0, 0, 0, 0, 0),
(8, 5, 3, 'Ataque Extra', 0, 6, 4, 2, 0, 0, 0, 0, 0, 0, 0),
(8, 6, 3, 'Aura de Protección', 0, 7, 4, 2, 0, 0, 0, 0, 0, 0, 0),
(8, 7, 3, 'Rasgo de Juramento', 0, 8, 4, 3, 0, 0, 0, 0, 0, 0, 0),
(8, 8, 3, 'Mejora de Característica', 0, 9, 4, 3, 0, 0, 0, 0, 0, 0, 0),
(8, 9, 4, 'Canal de Divinidad (2/descC)', 0, 10, 4, 3, 2, 0, 0, 0, 0, 0, 0),
(8, 10, 4, 'Aura de Valentía', 0, 11, 4, 3, 2, 0, 0, 0, 0, 0, 0),
(8, 11, 4, 'Golpe Divino Mejorado (2d8)', 0, 12, 4, 3, 3, 0, 0, 0, 0, 0, 0),
(8, 12, 4, 'Mejora de Característica', 0, 12, 4, 3, 3, 0, 0, 0, 0, 0, 0),
(8, 13, 5, NULL, 0, 14, 4, 3, 3, 1, 0, 0, 0, 0, 0),
(8, 14, 5, 'Purificadora de la Limpieza', 0, 14, 4, 3, 3, 1, 0, 0, 0, 0, 0),
(8, 15, 5, 'Rasgo de Juramento', 0, 15, 4, 3, 3, 2, 0, 0, 0, 0, 0),
(8, 16, 5, 'Mejora de Característica', 0, 15, 4, 3, 3, 2, 0, 0, 0, 0, 0),
(8, 17, 6, 'Golpe Divino Mejorado (3d8)', 0, 17, 4, 3, 3, 3, 1, 0, 0, 0, 0),
(8, 18, 6, 'Aura mejorada (18m)', 0, 17, 4, 3, 3, 3, 1, 0, 0, 0, 0),
(8, 19, 6, 'Mejora de Característica', 0, 19, 4, 3, 3, 3, 2, 0, 0, 0, 0),
(8, 20, 6, 'Ser Sagrado', 0, 19, 4, 3, 3, 3, 2, 0, 0, 0, 0),
(9, 1, 2, 'Expertise (2), Ataque Furtivo (1d6), Jerga de Ladrones', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 2, 2, 'Acción Astucia', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 3, 2, 'Arquetipo de Pícaro, Ataque Furtivo (2d6)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 4, 2, 'Mejora de Característica', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 5, 3, 'Ataque Furtivo (3d6), Sin Rastro', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 6, 3, 'Expertise (2 adicionales)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 7, 3, 'Evasión, Ataque Furtivo (4d6)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 8, 3, 'Mejora de Característica', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 9, 4, 'Rasgo de Arquetipo, Ataque Furtivo (5d6)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 10, 4, 'Mejora de Característica', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 11, 4, 'Talento Confiable, Ataque Furtivo (6d6)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 12, 4, 'Mejora de Característica', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 13, 5, 'Rasgo de Arquetipo, Ataque Furtivo (7d6)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 14, 5, 'Sentido Ciego (3m)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 15, 5, 'Esquiva Sobrenatural, Ataque Furtivo (8d6)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 16, 5, 'Mejora de Característica', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 17, 6, 'Rasgo de Arquetipo, Ataque Furtivo (9d6)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 18, 6, 'Escurridizo', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 19, 6, 'Mejora de Característica, Ataque Furtivo (10d6)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 20, 6, 'Golpe del Destino', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(10, 1, 2, 'Favorito Natural, Exploración Natural (1)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(10, 2, 2, 'Estilo de Combate, Conjuros de Explorador', 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0),
(10, 3, 2, 'Arquetipo de Explorador, Exploración Natural (2)', 0, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0),
(10, 4, 2, 'Mejora de Característica', 0, 4, 3, 0, 0, 0, 0, 0, 0, 0, 0),
(10, 5, 3, 'Ataque Extra', 0, 5, 4, 2, 0, 0, 0, 0, 0, 0, 0),
(10, 6, 3, 'Favorito Natural Mejorado', 0, 6, 4, 2, 0, 0, 0, 0, 0, 0, 0),
(10, 7, 3, 'Rasgo de Arquetipo, Exploración Natural (3)', 0, 7, 4, 3, 0, 0, 0, 0, 0, 0, 0),
(10, 8, 3, 'Mejora de Característica, Tierra en Pie (1)', 0, 8, 4, 3, 0, 0, 0, 0, 0, 0, 0),
(10, 9, 4, NULL, 0, 9, 4, 3, 2, 0, 0, 0, 0, 0, 0),
(10, 10, 4, 'Escondite Natural', 0, 10, 4, 3, 2, 0, 0, 0, 0, 0, 0),
(10, 11, 4, 'Rasgo de Arquetipo', 0, 11, 4, 3, 3, 0, 0, 0, 0, 0, 0),
(10, 12, 4, 'Mejora de Característica', 0, 11, 4, 3, 3, 0, 0, 0, 0, 0, 0),
(10, 13, 5, NULL, 0, 13, 4, 3, 3, 1, 0, 0, 0, 0, 0),
(10, 14, 5, 'Desaparecer', 0, 13, 4, 3, 3, 1, 0, 0, 0, 0, 0),
(10, 15, 5, 'Rasgo de Arquetipo, Tierra en Pie (2)', 0, 14, 4, 3, 3, 2, 0, 0, 0, 0, 0),
(10, 16, 5, 'Mejora de Característica', 0, 14, 4, 3, 3, 2, 0, 0, 0, 0, 0),
(10, 17, 6, NULL, 0, 16, 4, 3, 3, 3, 1, 0, 0, 0, 0),
(10, 18, 6, 'Sentidos Salvajes', 0, 16, 4, 3, 3, 3, 1, 0, 0, 0, 0),
(10, 19, 6, 'Mejora de Característica', 0, 18, 4, 3, 3, 3, 2, 0, 0, 0, 0),
(10, 20, 6, 'Cazador de Asesinos', 0, 18, 4, 3, 3, 3, 2, 0, 0, 0, 0),
(11, 1, 2, 'Lanzamiento de Conjuros, Origen Sorcérico', 4, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0),
(11, 2, 2, 'Puntos de Fuente Sorcérica (2)', 4, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0),
(11, 3, 2, 'Metamagia (2)', 4, 4, 4, 2, 0, 0, 0, 0, 0, 0, 0),
(11, 4, 2, 'Mejora de Característica', 5, 5, 4, 3, 0, 0, 0, 0, 0, 0, 0),
(11, 5, 3, 'Puntos de Fuente (5)', 5, 6, 4, 3, 2, 0, 0, 0, 0, 0, 0),
(11, 6, 3, 'Rasgo de Origen Sorcérico', 5, 7, 4, 3, 3, 0, 0, 0, 0, 0, 0),
(11, 7, 3, 'Puntos de Fuente (7)', 5, 8, 4, 3, 3, 1, 0, 0, 0, 0, 0),
(11, 8, 3, 'Mejora de Característica', 5, 9, 4, 3, 3, 2, 0, 0, 0, 0, 0),
(11, 9, 4, 'Puntos de Fuente (9)', 5, 10, 4, 3, 3, 3, 1, 0, 0, 0, 0),
(11, 10, 4, 'Metamagia (3), Rasgo de Origen', 6, 11, 4, 3, 3, 3, 2, 0, 0, 0, 0),
(11, 11, 4, 'Puntos de Fuente (11)', 6, 12, 4, 3, 3, 3, 2, 1, 0, 0, 0),
(11, 12, 4, 'Mejora de Característica', 6, 12, 4, 3, 3, 3, 2, 1, 0, 0, 0),
(11, 13, 5, 'Puntos de Fuente (13)', 6, 13, 4, 3, 3, 3, 2, 1, 1, 0, 0),
(11, 14, 5, 'Rasgo de Origen Sorcérico', 6, 13, 4, 3, 3, 3, 2, 1, 1, 0, 0),
(11, 15, 5, 'Puntos de Fuente (15)', 6, 14, 4, 3, 3, 3, 2, 1, 1, 1, 0),
(11, 16, 5, 'Mejora de Característica', 6, 14, 4, 3, 3, 3, 2, 1, 1, 1, 0),
(11, 17, 6, 'Metamagia (4), Puntos de Fuente (17)', 6, 15, 4, 3, 3, 3, 2, 1, 1, 1, 1),
(11, 18, 6, 'Rasgo de Origen Sorcérico', 6, 15, 4, 3, 3, 3, 3, 1, 1, 1, 1),
(11, 19, 6, 'Mejora de Característica, Puntos de Fuente (19)', 6, 15, 4, 3, 3, 3, 3, 2, 1, 1, 1),
(11, 20, 6, 'Restauración Sorcérica', 6, 15, 4, 3, 3, 3, 3, 2, 2, 1, 1),
(12, 1, 2, 'Patrón Ultraterreno, Magia de Pacto (1/descC, nv1)', 2, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0),
(12, 2, 2, 'Invocaciones Sobrenaturales (2)', 2, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0),
(12, 3, 2, 'Boon de Pacto, Magia de Pacto (2/descC, nv2)', 2, 4, 0, 2, 0, 0, 0, 0, 0, 0, 0),
(12, 4, 2, 'Mejora de Característica', 3, 5, 0, 2, 0, 0, 0, 0, 0, 0, 0),
(12, 5, 3, 'Magia de Pacto (2/descC, nv3)', 3, 6, 0, 0, 2, 0, 0, 0, 0, 0, 0),
(12, 6, 3, 'Rasgo de Patrón', 3, 7, 0, 0, 2, 0, 0, 0, 0, 0, 0),
(12, 7, 3, 'Invocaciones (4), Magia de Pacto (nv4)', 3, 8, 0, 0, 0, 2, 0, 0, 0, 0, 0),
(12, 8, 3, 'Mejora de Característica', 3, 9, 0, 0, 0, 2, 0, 0, 0, 0, 0),
(12, 9, 4, 'Magia de Pacto (2/descC, nv5)', 3, 10, 0, 0, 0, 0, 2, 0, 0, 0, 0),
(12, 10, 4, 'Rasgo de Patrón, Invocaciones (5)', 4, 10, 0, 0, 0, 0, 2, 0, 0, 0, 0),
(12, 11, 4, 'Magia Mística (nv5, 3/descC)', 4, 11, 0, 0, 0, 0, 3, 0, 0, 0, 0),
(12, 12, 4, 'Mejora de Característica', 4, 11, 0, 0, 0, 0, 3, 0, 0, 0, 0),
(12, 13, 5, 'Invocaciones (6)', 4, 12, 0, 0, 0, 0, 3, 0, 0, 0, 0),
(12, 14, 5, 'Rasgo de Patrón', 4, 12, 0, 0, 0, 0, 3, 0, 0, 0, 0),
(12, 15, 5, 'Magia Mística (4/descC)', 4, 13, 0, 0, 0, 0, 4, 0, 0, 0, 0),
(12, 16, 5, 'Mejora de Característica', 4, 13, 0, 0, 0, 0, 4, 0, 0, 0, 0),
(12, 17, 6, 'Invocaciones (7)', 4, 14, 0, 0, 0, 0, 4, 0, 0, 0, 0),
(12, 18, 6, 'Rasgo de Patrón', 4, 14, 0, 0, 0, 0, 4, 0, 0, 0, 0),
(12, 19, 6, 'Mejora de Característica, Invocaciones (8)', 4, 15, 0, 0, 0, 0, 4, 0, 0, 0, 0),
(12, 20, 6, 'Hechicero Eldritch, Magia Mística (4/descC)', 4, 15, 0, 0, 0, 0, 4, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `damage`
--

CREATE TABLE `damage` (
  `damage_id` int(2) NOT NULL,
  `damage_name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `damage`
--

INSERT INTO `damage` (`damage_id`, `damage_name`) VALUES
(0, 'Sin daño'),
(1, 'Ácido'),
(2, 'Contundente'),
(3, 'Frío'),
(4, 'Fuego'),
(5, 'Fuerza'),
(6, 'Eléctrico'),
(7, 'Necrótico'),
(8, 'Perforante'),
(9, 'Veneno'),
(10, 'Psíquico'),
(11, 'Radiante'),
(12, 'Cortante'),
(13, 'Trueno');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `feat`
--

CREATE TABLE `feat` (
  `feat_id` int(6) NOT NULL,
  `feat_name` varchar(30) NOT NULL,
  `feat_desc` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `feat_ability`
--

CREATE TABLE `feat_ability` (
  `feat_id` int(6) NOT NULL,
  `ability_id` int(1) NOT NULL,
  `feat_ability_bonus` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `feat_prerequisite`
--

CREATE TABLE `feat_prerequisite` (
  `feat_id` int(6) DEFAULT NULL,
  `prerequisite_type` enum('ability','level','class','other') DEFAULT NULL,
  `reference_id` int(11) DEFAULT NULL,
  `value` int(11) DEFAULT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `groups`
--

CREATE TABLE `groups` (
  `group_id` int(11) NOT NULL,
  `group_name` varchar(50) NOT NULL,
  `user_name` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `groups`
--

INSERT INTO `groups` (`group_id`, `group_name`, `user_name`) VALUES
(1, 'Los Buscadores del Amanecer', 'dm_carlos'),
(2, 'La Orden del Fénix', 'dm_carlos'),
(3, 'Mesa de Pruebas', 'admin'),
(4, 'grupoPako', 'pako');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `item`
--

CREATE TABLE `item` (
  `item_id` int(10) NOT NULL,
  `item_name` varchar(30) NOT NULL,
  `item_desc` varchar(255) NOT NULL,
  `item_count` int(5) NOT NULL,
  `item_weight` float(5,2) NOT NULL,
  `item_price` float(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `item`
--

INSERT INTO `item` (`item_id`, `item_name`, `item_desc`, `item_count`, `item_weight`, `item_price`) VALUES
(1, 'Daga', 'Arma ligera, arrojadiza, con empuñadura corta y hoja afilada', 1, 0.50, 2.00),
(2, 'Maza', 'Arma contundente de mango corto con cabeza pesada', 1, 2.00, 5.00),
(3, 'Bastón', 'Vara de madera robusta usada como arma o apoyo', 1, 2.00, 0.10),
(4, 'Hacha de mano', 'Hacha pequeña para una mano, también arrojadiza', 1, 1.00, 5.00),
(5, 'Espada corta', 'Espada ligera de hoja corta, ideal para combate cerrado', 1, 1.00, 10.00),
(6, 'Lanza', 'Asta con punta metálica, también arrojadiza', 1, 1.50, 1.00),
(7, 'Garrote', 'Palo grueso de madera endurecida', 1, 2.00, 0.10),
(8, 'Hoz', 'Herramienta de labranza adaptada como arma', 1, 1.00, 1.00),
(9, 'Jabalina', 'Lanza corta arrojadiza de madera y punta metálica', 1, 1.00, 0.50),
(10, 'Martillo ligero', 'Martillo pequeño arrojadizo', 1, 1.00, 2.00),
(101, 'Espada larga', 'Espada versátil de hoja recta, a una o dos manos', 1, 1.50, 15.00),
(102, 'Hacha de batalla', 'Hacha grande diseñada para el combate', 1, 2.00, 10.00),
(103, 'Martillo de guerra', 'Martillo pesado con cabeza de metal', 1, 2.00, 15.00),
(104, 'Espada bastarda', 'Espada de mano y media, versátil y poderosa', 1, 3.00, 35.00),
(105, 'Gran hacha', 'Hacha de dos manos con doble filo', 1, 3.50, 30.00),
(106, 'Gran espada', 'Espada enorme de dos manos con gran alcance', 1, 3.00, 50.00),
(107, 'Espada ancha', 'Espada de hoja ancha y pesada, una mano', 1, 2.00, 25.00),
(108, 'Mayal', 'Mango con cabeza de metal unida por cadena', 1, 2.00, 10.00),
(109, 'Lanza de caballería', 'Lanza larga usada a caballo, requiere dos manos a pie', 1, 3.00, 10.00),
(110, 'Pico de guerra', 'Pico de combate con punta de acero', 1, 2.00, 5.00),
(111, 'Tridente', 'Arma con tres puntas, también arrojadiza', 1, 2.00, 5.00),
(112, 'Estoque', 'Espada de hoja delgada para ataques perforantes precisos', 1, 1.00, 25.00),
(201, 'Arco corto', 'Arco pequeño, fácil de manejar en espacios reducidos', 1, 1.00, 25.00),
(202, 'Arco largo', 'Arco alto, de gran alcance y potencia', 1, 1.50, 50.00),
(203, 'Ballesta ligera', 'Ballesta simple, fácil de recargar', 1, 2.50, 25.00),
(204, 'Ballesta de mano', 'Ballesta pequeña para una mano', 1, 1.50, 75.00),
(205, 'Ballesta pesada', 'Ballesta grande de gran potencia y alcance', 1, 4.50, 50.00),
(206, 'Cerbatana', 'Tubo para disparar dardos con el aliento', 1, 0.50, 10.00),
(301, 'Armadura de cuero', 'Armadura hecha de cuero endurecido', 1, 5.00, 10.00),
(302, 'Armadura de cuero tachonado', 'Cuero reforzado con tachuelas metálicas', 1, 6.50, 45.00),
(303, 'Camisote de mallas', 'Camisa corta de anillos entrelazados sobre cuero', 1, 6.00, 50.00),
(401, 'Cota de malla', 'Camisa hecha de anillos metálicos entrelazados', 1, 20.00, 75.00),
(402, 'Armadura de escamas', 'Capas superpuestas de metal sobre cuero', 1, 22.50, 50.00),
(403, 'Coraza', 'Pechera y espalda de metal, resto de cuero', 1, 10.00, 400.00),
(404, 'Media armadura', 'Protección metálica completa excepto cabeza', 1, 20.00, 750.00),
(501, 'Armadura de placas', 'Armadura completa de placas metálicas articuladas', 1, 32.50, 1500.00),
(502, 'Armadura de anillos', 'Cuero con anillos de metal cosidos', 1, 20.00, 30.00),
(503, 'Cota de bandas', 'Tiras verticales de metal unidas a cuero', 1, 25.00, 200.00),
(601, 'Escudo', 'Escudo redondo o rectangular de madera y metal', 1, 3.00, 10.00),
(701, 'Kit de curador', 'Suministros para primeros auxilios (10 usos)', 1, 1.50, 5.00),
(702, 'Cuerda de cáñamo (15m)', 'Cuerda resistente de 15 metros', 1, 5.00, 1.00),
(703, 'Antorcha', 'Vara de madera con extremo empapado en resina', 1, 0.50, 0.01),
(704, 'Raciones (1 día)', 'Comida para un día de viaje', 1, 0.50, 0.50),
(705, 'Cantimplora', 'Recipiente para agua', 1, 2.00, 0.20),
(706, 'Símbolo sagrado', 'Amuleto o emblema religioso de una deidad', 1, 0.10, 5.00),
(707, 'Libro de oraciones', 'Pequeño libro con plegarias y textos religiosos', 1, 0.50, 2.00),
(708, 'Incienso (varita)', 'Varita aromática usada en ceremonias religiosas', 1, 0.05, 0.10),
(709, 'Vestiduras religiosas', 'Ropa ceremonial para oficios religiosos', 1, 1.00, 3.00),
(710, 'Kit de disfraz', 'Maquillaje, pelucas y accesorios para cambiar la apariencia', 1, 1.50, 15.00),
(711, 'Herramientas de juego', 'Dados, cartas y otros elementos de juego', 1, 0.20, 1.00),
(712, 'Herramientas de ladrón', 'Palancas, limas y ganzúas para abrir cerraduras', 1, 1.00, 25.00),
(713, 'Pala', 'Herramienta para cavar', 1, 3.00, 1.00),
(714, 'Olla de hierro', 'Recipiente metálico para cocinar', 1, 2.00, 0.50),
(715, 'Garfio', 'Gancho de metal con cuerda, usado para escalar', 1, 2.00, 1.00),
(716, 'Amuleto de la suerte', 'Pequeño objeto que se cree trae buena fortuna', 1, 0.10, 2.00),
(717, 'Insignia de rango', 'Distintivo que indica posición militar', 1, 0.10, 1.00),
(718, 'Trofeo de guerra', 'Parte de un enemigo vencido (colmillo, garra, etc.)', 1, 0.20, 0.50),
(719, 'Kit de herbalismo', 'Herramientas para recolectar y preparar hierbas', 1, 0.50, 5.00),
(720, 'Mantas', 'Prenda de abrigo para dormir', 1, 1.50, 0.50),
(721, 'Instrumento musical', 'Instrumento básico para interpretar música', 1, 1.00, 5.00),
(722, 'Disfraz', 'Vestimenta para actuar o cambiar de apariencia', 1, 1.00, 2.00),
(723, 'Ropa fina', 'Vestimenta de calidad para ocasiones especiales', 1, 1.00, 5.00),
(724, 'Botella de tinta', 'Recipiente con tinta para escribir', 1, 0.10, 0.50),
(725, 'Pluma de escribir', 'Instrumento para escribir con tinta', 1, 0.05, 0.10),
(726, 'Libro pequeño', 'Cuaderno o libro en blanco para anotaciones', 1, 0.50, 2.00),
(727, 'Mapa de ciudad', 'Plano detallado de una ciudad específica', 1, 0.10, 1.00),
(728, 'Ratón de mascota', 'Pequeño roedor domesticado', 1, 0.05, 0.50),
(729, 'Navaja', 'Cuchillo pequeño plegable', 1, 0.10, 0.50),
(730, 'Balanza de mercader', 'Instrumento para pesar mercancías', 1, 0.50, 2.00),
(731, 'Ropa común', 'Vestimenta sencilla y duradera', 1, 1.00, 0.50),
(732, 'Ropa sucia', 'Vestimenta vieja y en mal estado', 1, 1.00, 0.10),
(733, 'Pergamino de linaje', 'Documento que acredita ascendencia noble', 1, 0.10, 5.00),
(734, 'Anillo de sello', 'Anillo con grabado para sellar documentos', 1, 0.05, 5.00),
(735, 'Carta de presentación', 'Documento de recomendación firmado', 1, 0.05, 1.00),
(736, 'Diario personal', 'Cuaderno con anotaciones íntimas', 1, 0.30, 1.00),
(737, 'Poema escrito', 'Composición poética en papel', 1, 0.05, 0.20),
(738, 'Contrato comercial', 'Documento de acuerdo mercantil', 1, 0.10, 1.00),
(739, 'Nota críptica', 'Mensaje cifrado o en clave', 1, 0.05, 0.50),
(740, 'Carta de compañero', 'Correspondencia de un aliado caído', 1, 0.05, 0.50),
(741, 'Recuerdo familiar', 'Objeto sentimental de los padres', 1, 0.10, 0.50),
(742, 'Mapa incompleto', 'Fragmento de un mapa del tesoro', 1, 0.10, 2.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `item_armor`
--

CREATE TABLE `item_armor` (
  `item_id` int(10) NOT NULL,
  `armor_type_id` int(1) NOT NULL,
  `armor_ca` int(2) NOT NULL,
  `armor_str` int(2) NOT NULL,
  `item_type` int(1) NOT NULL,
  `armor_stealth` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `item_armor`
--

INSERT INTO `item_armor` (`item_id`, `armor_type_id`, `armor_ca`, `armor_str`, `item_type`, `armor_stealth`) VALUES
(301, 1, 11, 0, 1, 0),
(302, 1, 12, 0, 1, 0),
(303, 1, 13, 0, 1, 0),
(401, 2, 14, 0, 2, 0),
(402, 2, 14, 0, 2, 1),
(403, 2, 14, 0, 2, 0),
(404, 2, 15, 0, 2, 1),
(501, 3, 18, 15, 3, 1),
(502, 3, 14, 0, 3, 1),
(503, 3, 14, 0, 3, 1),
(601, 4, 2, 0, 4, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `item_wand`
--

CREATE TABLE `item_wand` (
  `item_id` int(10) NOT NULL,
  `wand_charges` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `item_weapon`
--

CREATE TABLE `item_weapon` (
  `item_id` int(10) NOT NULL,
  `skill_id` int(1) NOT NULL,
  `weapon_hitdice` varchar(5) NOT NULL,
  `damage_id` int(1) NOT NULL,
  `mastery_id` int(4) NOT NULL,
  `weapon_properties` varchar(100) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `item_weapon`
--

INSERT INTO `item_weapon` (`item_id`, `skill_id`, `weapon_hitdice`, `damage_id`, `mastery_id`, `weapon_properties`) VALUES
(1, 1, '1d4', 8, 3, 'Ligera, arrojadiza (6/18)'),
(2, 2, '1d6', 2, 2, ''),
(3, 2, '1d6', 2, 5, 'Versátil (1d8)'),
(4, 2, '1d6', 12, 7, 'Ligera, arrojadiza (6/18)'),
(5, 1, '1d6', 8, 3, 'Ligera'),
(6, 2, '1d6', 8, 7, 'Arrojadiza (6/18), versátil (1d8)'),
(7, 2, '1d4', 2, 2, ''),
(8, 2, '1d4', 12, 9, 'Ligera'),
(9, 2, '1d6', 8, 7, 'Arrojadiza (9/36)'),
(10, 2, '1d4', 2, 7, 'Ligera, arrojadiza (6/18)'),
(101, 2, '1d8', 12, 1, 'Versátil (1d10)'),
(102, 2, '1d8', 12, 2, ''),
(103, 2, '1d8', 2, 2, 'Versátil (1d10)'),
(104, 2, '1d8', 12, 2, 'Versátil (2d6)'),
(105, 2, '1d12', 12, 2, 'Pesada, dos manos'),
(106, 2, '2d6', 12, 2, 'Pesada, dos manos'),
(107, 2, '2d6', 12, 4, 'Dos manos, pesada'),
(108, 2, '1d8', 2, 2, ''),
(109, 2, '1d12', 8, 4, 'Alcance, especial'),
(110, 2, '1d8', 8, 2, ''),
(111, 2, '1d6', 8, 7, 'Arrojadiza (6/18), versátil (1d8)'),
(112, 1, '1d8', 8, 3, 'Ligera'),
(201, 1, '1d6', 8, 8, 'Munición (24/96), dos manos'),
(202, 1, '1d8', 8, 8, 'Munición (45/180), dos manos, pesada'),
(203, 1, '1d8', 8, 8, 'Munición (24/96), dos manos, recarga'),
(204, 1, '1d6', 8, 8, 'Munición (9/36), ligera'),
(205, 1, '1d10', 8, 8, 'Munición (30/120), dos manos, pesada, recarga'),
(206, 1, '1', 9, 8, 'Munición (7,5/30), dos manos');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mastery`
--

CREATE TABLE `mastery` (
  `mastery_id` int(4) NOT NULL,
  `mastery_name` varchar(20) NOT NULL,
  `mastery_desc` varchar(2000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `mastery`
--

INSERT INTO `mastery` (`mastery_id`, `mastery_name`, `mastery_desc`) VALUES
(1, 'Flexible', 'Puedes cambiar el tipo de daño entre contundente, cortante y perforante cuando atacas con esta arma.'),
(2, 'Pesada', 'Las criaturas Pequeñas y más pequeñas tienen desventaja en las tiradas de ataque con esta arma.'),
(3, 'Ligera', 'Cuando atacas con esta arma usando la acción de Atacar, puedes realizar un ataque adicional con otra arma Ligera como acción adicional.'),
(4, 'Cargada', 'Si te mueves al menos 3 metros en línea recta antes de este ataque, añades 1d6 al daño si el ataque impacta.'),
(5, 'Versátil', 'Esta arma puede usarse con una o dos manos. El daño entre paréntesis es el de dos manos.'),
(6, 'Alcance', 'Esta arma aumenta tu alcance de ataque cuerpo a cuerpo en 1,5 metros.'),
(7, 'Arrojadiza', 'Puedes lanzar esta arma a distancia. Si es un arma cuerpo a cuerpo, usas el mismo modificador de característica.'),
(8, 'A distancia', 'Esta arma solo puede usarse para ataques a distancia. Tiene rango normal y largo en metros.'),
(9, 'Fiable', 'Cuando tiras el daño con esta arma y el resultado es inferior a tu bonificador de competencia, usas el bonificador de competencia como resultado.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pass`
--

CREATE TABLE `pass` (
  `user_nick` varchar(30) NOT NULL,
  `pass_hash` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pass`
--

INSERT INTO `pass` (`user_nick`, `pass_hash`) VALUES
('admin', '$2y$10$ABC123XYZ456$hashedpassword1'),
('dm_carlos', '$2y$10$DEF789GHI012$hashedpassword2'),
('jugador_ana', '$2y$10$JKL345MNO678$hashedpassword3'),
('jugador_luis', '$2y$10$PQR901STU234$hashedpassword4'),
('jugador_sofia', '$2y$10$VWX567YZA890$hashedpassword5'),
('pako', '$argon2id$v=19$m=65536,t=4,p=1$V2lubG90aWFaNFJHSzd2TQ$kPT3zzyyo/m9SLuBQFaUpkFcLmH6gwvqg6ryi0KrCd0');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prof`
--

CREATE TABLE `prof` (
  `prof_id` int(5) NOT NULL,
  `prof_name` varchar(30) NOT NULL,
  `prof_type` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `prof`
--

INSERT INTO `prof` (`prof_id`, `prof_name`, `prof_type`) VALUES
(1, 'Armas simples', 'weapon'),
(2, 'Armas marciales', 'weapon'),
(3, 'Armas de fuego', 'weapon'),
(4, 'Ballestas', 'weapon'),
(5, 'Espadas', 'weapon'),
(6, 'Hachas', 'weapon'),
(7, 'Mazas', 'weapon'),
(8, 'Lanzas', 'weapon'),
(9, 'Armas arrojadizas', 'weapon'),
(10, 'Armas a distancia', 'weapon'),
(11, 'Armas de combate cuerpo a cuer', 'weapon'),
(12, 'Armas con mango', 'weapon'),
(13, 'Armas flexibles', 'weapon'),
(14, 'Armas de filo', 'weapon'),
(15, 'Armaduras ligeras', 'armor'),
(16, 'Armaduras medianas', 'armor'),
(17, 'Armaduras pesadas', 'armor'),
(18, 'Escudos', 'armor'),
(19, 'Armaduras de placas', 'armor'),
(20, 'Armaduras de cuero', 'armor'),
(21, 'Armaduras de malla', 'armor'),
(22, 'Herramientas de alquimista', 'tool'),
(23, 'Herramientas de cervecero', 'tool'),
(24, 'Herramientas de calígrafo', 'tool'),
(25, 'Herramientas de carpintero', 'tool'),
(26, 'Herramientas de cartógrafo', 'tool'),
(27, 'Herramientas de cocinero', 'tool'),
(28, 'Herramientas de falsificación', 'tool'),
(29, 'Herramientas de herrero', 'tool'),
(30, 'Herramientas de joyero', 'tool'),
(31, 'Herramientas de ladrón', 'tool'),
(32, 'Herramientas de marroquinería', 'tool'),
(33, 'Herramientas de músico', 'tool'),
(34, 'Herramientas de navegante', 'tool'),
(35, 'Herramientas de pintor', 'tool'),
(36, 'Herramientas de peletero', 'tool'),
(37, 'Herramientas de pescador', 'tool'),
(38, 'Herramientas de pocionista', 'tool'),
(39, 'Herramientas de sastre', 'tool'),
(40, 'Herramientas de vidriero', 'tool'),
(41, 'Kit de desactivación de trampa', 'tool'),
(42, 'Kit de disfraz', 'tool'),
(43, 'Kit de envenenador', 'tool'),
(44, 'Kit de herbalista', 'tool'),
(45, 'Kit de jugador', 'tool'),
(46, 'Kit de reparación', 'tool'),
(47, 'Kit de venenos', 'tool'),
(48, 'Instrumentos de cuerda', 'tool'),
(49, 'Instrumentos de viento', 'tool'),
(50, 'Instrumentos de percusión', 'tool'),
(51, 'Instrumentos de teclado', 'tool'),
(52, 'Juego de dados', 'tool'),
(53, 'Mazo de cartas', 'tool'),
(54, 'Tablero de ajedrez', 'tool'),
(55, 'Carruajes terrestres', 'vehicle'),
(56, 'Carros de guerra', 'vehicle'),
(57, 'Carros de combate', 'vehicle'),
(58, 'Trineos', 'vehicle'),
(59, 'Barcos de vela', 'vehicle'),
(60, 'Barcos de remos', 'vehicle'),
(61, 'Barcos de guerra', 'vehicle'),
(62, 'Balsas', 'vehicle'),
(63, 'Canoas', 'vehicle'),
(64, 'Galeras', 'vehicle'),
(65, 'Goletas', 'vehicle'),
(66, 'Carabelas', 'vehicle'),
(67, 'Carros voladores', 'vehicle'),
(68, 'Barcos voladores', 'vehicle'),
(69, 'Mecanismos de asedio', 'vehicle'),
(70, 'Máquinas de guerra', 'vehicle'),
(71, 'Común', 'language'),
(72, 'Élfico', 'language'),
(73, 'Enano', 'language'),
(74, 'Gigante', 'language'),
(75, 'Gnomo', 'language'),
(76, 'Trasgo', 'language'),
(77, 'Mediano', 'language'),
(78, 'Orco', 'language'),
(79, 'Abisal', 'language'),
(80, 'Celestial', 'language'),
(81, 'Draconido', 'language'),
(82, 'Infernal', 'language'),
(83, 'Primordial', 'language'),
(84, 'Sylvan', 'language'),
(85, 'Subcomún', 'language'),
(86, 'Gith', 'language'),
(87, 'Profundo', 'language'),
(88, 'Jerga de ladrones', 'language'),
(89, 'Druídico', 'language'),
(90, 'Telépata', 'language'),
(91, 'Aurano', 'language'),
(92, 'Acuano', 'language'),
(93, 'Ignano', 'language'),
(94, 'Terrano', 'language'),
(95, 'Aurel', 'language'),
(96, 'Sahuagin', 'language'),
(97, 'Sphinx', 'language'),
(98, 'Umbral', 'language'),
(99, 'Común Antiguo', 'language'),
(100, 'Runas enanas', 'language'),
(101, 'Acrobacias', 'skill'),
(102, 'Atletismo', 'skill'),
(103, 'Arcano', 'skill'),
(104, 'Engaño', 'skill'),
(105, 'Historia', 'skill'),
(106, 'Interpretación', 'skill'),
(107, 'Intimidación', 'skill'),
(108, 'Investigación', 'skill'),
(109, 'Juego de manos', 'skill'),
(110, 'Medicina', 'skill'),
(111, 'Naturaleza', 'skill'),
(112, 'Percepción', 'skill'),
(113, 'Perspicacia', 'skill'),
(114, 'Persuasión', 'skill'),
(115, 'Religión', 'skill'),
(116, 'Sigilo', 'skill'),
(117, 'Supervivencia', 'skill'),
(118, 'Trato con animales', 'skill'),
(119, 'Armas flexibles', 'mastery'),
(120, 'Armas pesadas', 'mastery'),
(121, 'Armas ligeras', 'mastery'),
(122, 'Armas con carga', 'mastery'),
(123, 'Armas a dos manos', 'mastery'),
(124, 'Armas de alcance', 'mastery'),
(125, 'Armas arrojadizas', 'mastery'),
(126, 'Armas a distancia', 'mastery'),
(127, 'Armas fiables', 'mastery'),
(128, 'Armas sutiles', 'mastery'),
(129, 'Alquimia', 'craft'),
(130, 'Armería', 'craft'),
(131, 'Carpintería', 'craft'),
(132, 'Cocina', 'craft'),
(133, 'Costura', 'craft'),
(134, 'Escritura', 'craft'),
(135, 'Forja', 'craft'),
(136, 'Herrería', 'craft'),
(137, 'Joyería', 'craft'),
(138, 'Marcos de arco', 'craft'),
(139, 'Música', 'craft'),
(140, 'Pintura', 'craft'),
(141, 'Pociones', 'craft'),
(142, 'Sastrería', 'craft'),
(143, 'Talla de madera', 'craft'),
(144, 'Talla de piedra', 'craft'),
(145, 'Vidriería', 'craft'),
(146, 'Leyendas antiguas', 'lore'),
(147, 'Criaturas mágicas', 'lore'),
(148, 'Reinos olvidados', 'lore'),
(149, 'Linajes nobles', 'lore'),
(150, 'Cultos secretos', 'lore'),
(151, 'Artefactos perdidos', 'lore'),
(152, 'Magia arcana', 'lore'),
(153, 'Religiones', 'lore'),
(154, 'Bestiario', 'lore'),
(155, 'Heráldica', 'lore'),
(156, 'Geografía', 'lore'),
(157, 'Astronomía', 'lore'),
(158, 'Historia militar', 'lore'),
(159, 'Lanzamiento de conjuros', 'special'),
(160, 'Invocación de familiar', 'special'),
(161, 'Lectura de runas', 'special'),
(162, 'Detectar magia', 'special'),
(163, 'Identificar conjuros', 'special'),
(164, 'Crear objetos mágicos', 'special'),
(165, 'Construir trampas', 'special'),
(166, 'Desactivar trampas', 'special'),
(167, 'Abrir cerraduras', 'special'),
(168, 'Falsificar documentos', 'special'),
(169, 'Disfrazarse', 'special'),
(170, 'Seguir rastros', 'special'),
(171, 'Cazar', 'special'),
(172, 'Pescar', 'special'),
(173, 'Navegar', 'special'),
(174, 'Montar', 'special'),
(175, 'Nadar', 'special'),
(176, 'Escalar', 'special'),
(177, 'Saltar', 'special'),
(178, 'Equilibrio', 'special'),
(179, 'Armas de duelo', 'group'),
(180, 'Armas de gran tamaño', 'group'),
(181, 'Armas exóticas', 'group'),
(182, 'Armas improvisadas', 'group'),
(183, 'Armas de monje', 'group'),
(184, 'Armas de pícaro', 'group'),
(185, 'Armas de druida', 'group'),
(186, 'Armas de bardo', 'group'),
(187, 'Armas de clérigo', 'group'),
(188, 'Armas de hechicero', 'group'),
(189, 'Armas de brujo', 'group'),
(190, 'Armas de mago', 'group');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prof_class`
--

CREATE TABLE `prof_class` (
  `prof_id` int(5) NOT NULL,
  `class_id` int(4) NOT NULL,
  `class_lv` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `prof_class`
--

INSERT INTO `prof_class` (`prof_id`, `class_id`, `class_lv`) VALUES
(1, 1, 1),
(1, 2, 1),
(1, 3, 1),
(1, 4, 1),
(1, 5, 1),
(1, 6, 1),
(1, 7, 1),
(1, 8, 1),
(1, 9, 1),
(1, 10, 1),
(1, 11, 1),
(1, 12, 1),
(2, 1, 1),
(2, 5, 1),
(2, 8, 1),
(2, 10, 1),
(4, 2, 1),
(4, 6, 1),
(4, 9, 1),
(4, 11, 1),
(5, 2, 1),
(5, 9, 1),
(5, 12, 1),
(10, 2, 1),
(15, 1, 1),
(15, 2, 1),
(15, 3, 1),
(15, 4, 1),
(15, 5, 1),
(15, 8, 1),
(15, 9, 1),
(15, 10, 1),
(15, 12, 1),
(16, 1, 1),
(16, 3, 1),
(16, 4, 1),
(16, 5, 1),
(16, 8, 1),
(16, 10, 1),
(17, 5, 1),
(17, 8, 1),
(18, 1, 1),
(18, 3, 1),
(18, 4, 1),
(18, 5, 1),
(18, 8, 1),
(18, 10, 1),
(31, 9, 1),
(44, 4, 1),
(48, 2, 1),
(88, 9, 1),
(89, 4, 1),
(101, 2, 1),
(101, 5, 1),
(101, 7, 1),
(101, 9, 1),
(102, 1, 1),
(102, 5, 1),
(102, 8, 1),
(102, 9, 1),
(102, 10, 1),
(103, 4, 1),
(103, 6, 1),
(103, 11, 1),
(103, 12, 1),
(104, 2, 1),
(104, 9, 1),
(104, 11, 1),
(105, 3, 1),
(105, 5, 1),
(105, 6, 1),
(105, 7, 1),
(105, 12, 1),
(106, 2, 1),
(107, 1, 1),
(107, 2, 1),
(107, 5, 1),
(107, 8, 1),
(107, 11, 1),
(107, 12, 1),
(108, 6, 1),
(108, 7, 1),
(108, 9, 1),
(108, 10, 1),
(108, 12, 1),
(109, 9, 1),
(110, 3, 1),
(110, 6, 1),
(110, 8, 1),
(111, 4, 1),
(111, 10, 1),
(112, 1, 1),
(112, 5, 1),
(112, 9, 1),
(112, 10, 1),
(113, 2, 1),
(113, 3, 1),
(113, 4, 1),
(113, 5, 1),
(113, 7, 1),
(113, 8, 1),
(113, 12, 1),
(114, 2, 1),
(114, 3, 1),
(114, 8, 1),
(114, 9, 1),
(114, 11, 1),
(115, 3, 1),
(115, 4, 1),
(115, 6, 1),
(115, 7, 1),
(115, 8, 1),
(115, 11, 1),
(115, 12, 1),
(116, 7, 1),
(116, 9, 1),
(116, 10, 1),
(117, 1, 1),
(117, 4, 1),
(117, 10, 1),
(118, 4, 1),
(118, 10, 1),
(183, 7, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prof_race`
--

CREATE TABLE `prof_race` (
  `prof_id` int(5) NOT NULL,
  `race_id` int(4) NOT NULL,
  `race_lv` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `prof_race`
--

INSERT INTO `prof_race` (`prof_id`, `race_id`, `race_lv`) VALUES
(6, 4, 1),
(7, 4, 1),
(29, 4, 1),
(71, 1, 1),
(71, 2, 1),
(71, 3, 1),
(71, 4, 1),
(71, 5, 1),
(71, 6, 1),
(71, 7, 1),
(71, 8, 1),
(71, 9, 1),
(71, 10, 1),
(72, 2, 1),
(73, 4, 1),
(74, 8, 1),
(75, 6, 1),
(77, 3, 1),
(78, 10, 1),
(80, 7, 1),
(81, 5, 1),
(82, 9, 1),
(107, 10, 1),
(112, 2, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prof_subclass`
--

CREATE TABLE `prof_subclass` (
  `prof_id` int(5) NOT NULL,
  `class_id` int(4) NOT NULL,
  `subclass_id` int(4) NOT NULL,
  `subclass_lv` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `prof_subclass`
--

INSERT INTO `prof_subclass` (`prof_id`, `class_id`, `subclass_id`, `subclass_lv`) VALUES
(2, 3, 4, 1),
(2, 3, 6, 1),
(2, 3, 8, 1),
(17, 3, 4, 1),
(17, 3, 5, 1),
(17, 3, 6, 1),
(18, 8, 1, 1),
(18, 8, 2, 1),
(18, 8, 3, 1),
(18, 8, 4, 1),
(71, 3, 7, 1),
(72, 3, 7, 1),
(103, 2, 2, 3),
(105, 2, 2, 3),
(108, 2, 2, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prof_subrace`
--

CREATE TABLE `prof_subrace` (
  `prof_id` int(5) NOT NULL,
  `race_id` int(4) NOT NULL,
  `subrace_id` int(4) NOT NULL,
  `subrace_lv` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `prof_subrace`
--

INSERT INTO `prof_subrace` (`prof_id`, `race_id`, `subrace_id`, `subrace_lv`) VALUES
(2, 2, 1, 1),
(5, 2, 3, 1),
(4, 2, 3, 1),
(15, 4, 2, 1),
(16, 4, 2, 1),
(22, 6, 1, 1),
(1, 2, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `race`
--

CREATE TABLE `race` (
  `race_id` int(2) NOT NULL,
  `race_name` varchar(30) NOT NULL,
  `race_speed` int(3) NOT NULL,
  `size_id` int(1) NOT NULL,
  `race_age` int(5) NOT NULL,
  `race_desc` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `race`
--

INSERT INTO `race` (`race_id`, `race_name`, `race_speed`, `size_id`, `race_age`, `race_desc`) VALUES
(1, 'Humano', 30, 3, 100, 'Los humanos son la raza más versátil y extendida de Faerûn. En D&D 2024, los humanos ganan el rasgo Versátil: obtienen competencia en un arma, herramienta o habilidad adicional, y una vez por descanso corto pueden conferirse a sí mismos ventaja en una tirada.'),
(2, 'Elfo', 30, 3, 750, 'Los elfos son seres mágicos de larga vida, con conexión innata con la naturaleza y la magia. En D&D 2024 todos los elfos comparten: visión en la oscuridad 60 pies, Ascendencia Feérica (ventaja contra encantamiento), Trance (descanso largo en 4 horas), e idiomas Común y Élfico.'),
(3, 'Mediano', 30, 2, 150, 'Los medianos son criaturas pequeñas y resistentes, conocidas por su valentía y su pie en la tierra. En D&D 2024 todos los medianos tienen: tamaño Pequeño, velocidad 30 pies, Valiente (ventaja contra el efecto asustado), Sigilo del Mediano (ocultarse tras criaturas más grandes), e idiomas Común y Mediano.'),
(4, 'Enano', 30, 3, 350, 'Los enanos son seres robustos y tenaces, conocidos por su habilidad artesanal y su resistencia. En D&D 2024 todos los enanos tienen: velocidad 30 pies (no reducida por armadura), visión en la oscuridad 60 pies, Resistencia Enana (ventaja contra veneno, resistencia al daño de veneno), competencia en herramientas de artesano, e idiomas Común y Enano.'),
(5, 'Draconido', 30, 3, 80, 'Los draconidos son orgullosos guerreros humanoides con sangre de dragón. En D&D 2024 su Ancestral Dracónico determina tipo de daño; su Aliento inflige ese daño en un cono o línea (tSalv CON o DES, CD 8 + CON + comp), y su Resistencia los hace inmunes al daño de su tipo ancestral a nivel 5.'),
(6, 'Gnomo', 30, 2, 500, 'Los gnomos son pequeñas criaturas inteligentes y curiosas con afinidad natural por la magia. En D&D 2024 todos los gnomos tienen: tamaño Pequeño, velocidad 30 pies, visión en la oscuridad 60 pies, Astucia de Gnomo (ventaja en tSalv de INT, SAB y CAR contra magia), e idiomas Común y Gnomo.'),
(7, 'Aasimar', 30, 3, 90, 'Los aasimar llevan sangre celestial en sus venas. Rasgos en 2024: tamaño Mediano o Pequeño, velocidad 30 pies, visión en la oscuridad 60 pies, Resistencia Celestial (resistencia a daño necrótico y radiante), Curación de Manos (restaurar PG = nivel del personaje, 1/descanso largo), Revelación Celestial (nivel 3, 1/descanso largo, efectos según subtipo). Idiomas: Común y Celestial.'),
(8, 'Goliat', 35, 3, 80, 'Los goliats son descendientes de gigantes. Rasgos en 2024: tamaño Mediano (o Grande a elección), velocidad 35 pies, Constitución Poderosa (cuentan como un tamaño mayor para cargar/empujar/arrastrar), Resistencia de Gigante (1/descanso corto: reducir daño a la mitad como reacción), Legado de Gigante (conjuro/rasgo según tipo de gigante ancestral). Idiomas: Común y Gigante.'),
(9, 'Tiefling', 30, 3, 90, 'Los tieflings llevan la marca infernal de un pacto ancestral. En D&D 2024 tienen: visión en la oscuridad 60 pies, Resistencia Infernal (resistencia al daño de fuego), y el rasgo Legado Infernal que otorga conjuros innatos según linaje (Abissal, Asmodeo, Fierna, etc.) con escalado por nivel.'),
(10, 'Orco', 30, 3, 60, 'Los orcos son guerreros robustos con gran resistencia innata. Rasgos en 2024: tamaño Mediano, velocidad 30 pies, visión en la oscuridad 120 pies, Aguante Atroz (1/descanso largo: cuando los PG caen a 0 pero no mueres, quedan en 1 PG en su lugar), Presencia Intimidante (competencia en Intimidación), Poderoso Físico (cuentan como un tamaño mayor para cargar/empujar). Idiomas: Común y Orco.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `rol_id` char(1) NOT NULL,
  `rol_name` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`rol_id`, `rol_name`) VALUES
('A', 'Administra'),
('E', 'Espectador'),
('J', 'Jugador'),
('M', 'Maestro');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `size`
--

CREATE TABLE `size` (
  `size_id` int(1) NOT NULL,
  `size_name` varchar(20) NOT NULL,
  `size_desc` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `size`
--

INSERT INTO `size` (`size_id`, `size_name`, `size_desc`) VALUES
(1, 'Diminuto', 'Menos de 60 cm de altura'),
(2, 'Pequeño', 'Entre 60 cm y 1,20 m de altura'),
(3, 'Mediano', 'Entre 1,20 m y 1,80 m de altura'),
(4, 'Grande', 'Entre 1,80 m y 3,60 m de altura'),
(5, 'Enorme', 'Entre 3,60 m y 7,50 m de altura'),
(6, 'Gargantuesco', 'Más de 7,50 m de altura');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `skill`
--

CREATE TABLE `skill` (
  `skill_id` int(3) NOT NULL,
  `skill_name` varchar(20) NOT NULL,
  `ability_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `skill`
--

INSERT INTO `skill` (`skill_id`, `skill_name`, `ability_id`) VALUES
(1, 'Acrobacias', 2),
(2, 'Atletismo', 1),
(3, 'Arcano', 4),
(4, 'Engaño', 6),
(5, 'Historia', 5),
(6, 'Interpretación', 6),
(7, 'Intimidación', 6),
(8, 'Investigación', 4),
(9, 'Juego de manos', 2),
(10, 'Medicina', 5),
(11, 'Naturaleza', 5),
(12, 'Percepción', 5),
(13, 'Perspicacia', 5),
(14, 'Persuasión', 6),
(15, 'Religión', 5),
(16, 'Sigilo', 2),
(17, 'Supervivencia', 5),
(18, 'Trato con animales', 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `spell`
--

CREATE TABLE `spell` (
  `spell_id` int(6) NOT NULL,
  `spell_name` varchar(50) NOT NULL,
  `spell_level` int(1) NOT NULL,
  `spell_school_id` int(2) NOT NULL,
  `spell_ritual` tinyint(1) NOT NULL DEFAULT 0,
  `spell_cast_time` varchar(50) NOT NULL,
  `spell_range` varchar(50) NOT NULL,
  `spell_duration` varchar(50) NOT NULL,
  `spell_concentration` tinyint(1) NOT NULL DEFAULT 0,
  `spell_desc` text NOT NULL,
  `spell_higher_level` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `spell`
--

INSERT INTO `spell` (`spell_id`, `spell_name`, `spell_level`, `spell_school_id`, `spell_ritual`, `spell_cast_time`, `spell_range`, `spell_duration`, `spell_concentration`, `spell_desc`, `spell_higher_level`) VALUES
(1, 'Fuego fatuo', 0, 7, 0, '1 acción', '36 m', '1 minuto', 1, 'Creas una luz espectral que flota en un punto. Emite luz tenue en radio de 3 m. Puedes moverla hasta 9 m con acción adicional.', NULL),
(2, 'Mano de mago', 0, 2, 0, '1 acción', '9 m', '1 minuto', 0, 'Creas una mano espectral que puede manipular objetos de hasta 2,5 kg, abrir puertas y contenedores, o entregar objetos.', NULL),
(3, 'Prestidigitación', 0, 2, 0, '1 acción', '3 m', 'Hasta 1 hora', 0, 'Realizas un pequeño truco mágico inocuo: crear un efecto sensorial, limpiar un objeto, encender o apagar una llama, etc.', NULL),
(4, 'Rayo de fuego', 0, 5, 0, '1 acción', '36 m', 'Instantáneo', 0, 'Lanzas un rayo de fuego a una criatura. Tirada de ataque de conjuro a distancia. Impacto: 1d10 daño de fuego. Aumenta 1d10 en nv 5, 11 y 17.', NULL),
(5, 'Taumaturgia', 0, 8, 0, '1 acción', '9 m', '1 minuto', 0, 'Manifiestas un pequeño prodigio divino: tu voz retumba, tus ojos brillan, puertas se abren solas o luces parpadean.', NULL),
(6, 'Toque de muerte', 0, 7, 0, '1 acción', 'Toque', 'Instantáneo', 0, 'Invocas la energía de la muerte en una criatura que tocas. Tirada de ataque de conjuro cuerpo a cuerpo. Impacto: 1d6 + SAB daño necrótico (1d6 adicional cada 2 niveles a partir de nv 5).', NULL),
(7, 'Rayo de Frío', 0, 5, 0, '1 acción', '18 m', 'Instantáneo', 0, 'Lanzas un rayo de luz helada. Tirada de ataque a distancia. Impacto: 1d8 daño frío y velocidad de la criatura reducida a 0 hasta el próximo turno. Aumenta 1d8 en nv 5, 11 y 17.', NULL),
(8, 'Ilusión menor', 0, 6, 0, '1 acción', '9 m', '1 minuto', 0, 'Creas un sonido o imagen ilusoria. Puede ser un sonido de hasta voz inteligible, o una imagen inmóvil que quepa en un cubo de 1,5 m.', NULL),
(9, 'Luz', 0, 5, 0, '1 acción', 'Toque', '1 hora', 0, 'Un objeto que no se lleva puesto emite luz brillante en radio de 6 m y luz tenue 6 m más allá. Solo puede existir una instancia a la vez.', NULL),
(10, 'Veneno Ácido', 0, 2, 0, '1 acción', '18 m', '1 minuto', 0, 'Invocas una burbuja de ácido. Objetivo: tirada de tSalv de CON o recibe 1d6 de daño ácido inmediatamente y 1d6 al inicio de su siguiente turno.', NULL),
(101, 'Curación de heridas', 1, 1, 0, '1 acción', 'Toque', 'Instantáneo', 0, 'Una criatura que toques recupera 1d8 + modificador de lanzamiento PG.', 'Al lanzarlo con ranura nv 2+, el daño aumenta 1d8 por cada nivel adicional.'),
(102, 'Detección de magia', 1, 3, 1, '1 acción', 'Personal', 'Hasta 10 minutos', 1, 'Durante la duración, sientes la presencia de magia dentro de 9 m. Si detectas magia, puedes ver un aura tenue alrededor del objeto o criatura mágicos.', NULL),
(103, 'Dormir', 1, 4, 0, '1 acción', '18 m', '1 minuto', 0, 'Envías criaturas a un sueño mágico. Lanza 5d8: el total es los PG que puedes adormecer (de menor a mayor PG). Las criaturas dormidas no despiertan con daño.', 'Al lanzarlo con ranura nv 2+, añades 2d8 por cada nivel adicional.'),
(104, 'Armadura de mago', 1, 1, 0, '1 acción', 'Toque', '8 horas', 0, 'Tocas a una criatura voluntaria que no lleve armadura. La CA base de la criatura pasa a ser 13 + modificador de DES.', NULL),
(105, 'Manos ardientes', 1, 5, 0, '1 acción', 'Personal', 'Instantáneo', 0, 'Llamas brotan de tus manos en cono de 4,5 m. Las criaturas en el área hacen tSalv de DES: fracaso 3d6 fuego, éxito la mitad.', 'Al lanzarlo con ranura nv 2+, el daño aumenta 1d6 por cada nivel adicional.'),
(106, 'Cura ligera de heridas', 1, 1, 0, '1 acción adicional', 'Toque', 'Instantáneo', 0, 'Una criatura que toques recupera 1d4 + modificador de lanzamiento PG.', NULL),
(107, 'Proyectil mágico', 1, 5, 0, '1 acción', '36 m', 'Instantáneo', 0, 'Creas tres dardos brillantes que golpean automáticamente. Cada dardo inflige 1d4+1 de daño de fuerza.', 'Al lanzarlo con ranura nv 2+, creas un dardo adicional por cada nivel adicional.'),
(108, 'Escudo', 1, 1, 0, '1 reacción', 'Personal', '1 asalto', 0, 'Cuando te impactan con un ataque, invocas un escudo invisible que añade +5 a tu CA incluido el ataque desencadenante. También bloqueas Proyectil mágico.', NULL),
(109, 'Gracia feérica', 1, 8, 0, '1 acción', 'Toque', 'Hasta 1 hora', 1, 'Tocas a una criatura voluntaria. Hasta que el conjuro termine: la criatura no deja huella ni olor; puede pasar por espacios de criaturas de tamaño pequeño o mayor.', NULL),
(110, 'Palabra de curación', 1, 5, 0, '1 acción adicional', '18 m', 'Instantáneo', 0, 'Una criatura que puedas ver recupera 1d4 + modificador de lanzamiento PG.', 'Al lanzarlo con ranura nv 2+, el daño aumenta 1d4 por cada nivel adicional.'),
(111, 'Identificar', 1, 3, 1, '1 minuto', 'Toque', 'Instantáneo', 0, 'Eliges un objeto o criatura. Aprendes sus propiedades mágicas, cómo usarlo, si requiere sintonía y cuántos cargos le quedan.', NULL),
(112, 'Imagen silenciosa', 1, 6, 0, '1 acción', '18 m', 'Hasta 10 minutos', 1, 'Creas una imagen visual de un objeto, criatura u otro fenómeno visible que quepa en un cubo de 4,5 m. La imagen no tiene sonido, olor, ni tactilidad.', NULL),
(201, 'Invisibilidad', 2, 6, 0, '1 acción', 'Toque', 'Hasta 1 hora', 1, 'Una criatura que toques se vuelve invisible hasta que el conjuro termine, ataque o lance un conjuro.', 'Al lanzarlo con ranura nv 3+, puedes apuntar a una criatura adicional por cada nivel adicional.'),
(202, 'Sugestión', 2, 4, 0, '1 acción', '9 m', 'Hasta 8 horas', 1, 'Pronuncias una sugerencia de dos palabras o más a una criatura que puedas entenderte. La criatura debe hacer tSalv de SAB. Si falla, seguir la sugestión.', NULL),
(203, 'Misil de ácido de Melf', 2, 2, 0, '1 acción', '18 m', 'Hasta 1 minuto', 0, 'Creas tres dardos de ácido brillantes. Cada dardo impacta automáticamente: 2d4 daño de ácido ahora y 2d4 al final de su siguiente turno.', 'Al lanzarlo con ranura nv 3+, creas un dardo adicional por cada nivel adicional.'),
(204, 'Espejo de imágenes', 2, 6, 0, '1 acción', 'Personal', '1 minuto', 0, 'Tres duplicados ilusorios de ti mismo aparecen en tu espacio. Cuando te atacan, el atacante apunta aleatoriamente a ti o a un duplicado.', NULL),
(205, 'Toque de parálisis', 2, 8, 0, '1 acción', 'Toque', 'Hasta 1 minuto', 1, 'Tirada de ataque de conjuro cuerpo a cuerpo. Impacto: la criatura está paralizada hasta que el conjuro termine. Puede repetir la tSalv de CON cada turno.', NULL),
(206, 'Curación espiritual', 2, 1, 0, '1 acción adicional', '18 m', 'Hasta 1 minuto', 1, 'Invocas un arma espiritual en forma de símbolo de tu deidad. Usas acción adicional para realizar un ataque cuerpo a cuerpo de conjuro con ella: 1d8 + mod de lanzamiento.', 'Al lanzarlo con ranura nv 3+, el daño aumenta 1d8 por cada dos niveles adicionales.'),
(207, 'Oscuridad', 2, 5, 0, '1 acción', '18 m', 'Hasta 10 minutos', 1, 'La oscuridad mágica llena una esfera de 4,5 m de radio centrada en un punto. Las criaturas sin visión en oscuridad total no pueden ver a través de ella.', NULL),
(208, 'Detectar pensamientos', 2, 3, 0, '1 acción', 'Personal', 'Hasta 1 minuto', 1, 'Puedes leer los pensamientos superficiales de las criaturas dentro de 9 m. La criatura puede hacer tSalv de SAB para resistir.', NULL),
(301, 'Bola de fuego', 3, 5, 0, '1 acción', '45 m', 'Instantáneo', 0, 'Una explosión de llamas surge en un punto. Las criaturas en radio de 6 m hacen tSalv de DES: fracaso 8d6 fuego, éxito la mitad.', 'Al lanzarlo con ranura nv 4+, el daño aumenta 1d6 por cada nivel adicional.'),
(302, 'Contramagia', 3, 1, 0, '1 reacción', '18 m', 'Instantáneo', 0, 'Intentas cancelar un conjuro siendo lanzado. Si es de nivel 3 o inferior, falla. Si es de nivel superior, haces prueba de característica contra CD 10 + nivel del conjuro.', NULL),
(303, 'Hipnotismo', 3, 4, 0, '1 acción', '36 m', 'Hasta 1 hora', 1, 'Hasta seis criaturas que puedas ver en radio de 6 m deben hacer tSalv de SAB. Las que fallen quedan incapacitadas y velocidad 0 hasta que el conjuro termine o reciban daño.', NULL),
(304, 'Vuelo', 3, 8, 0, '1 acción', 'Toque', 'Hasta 10 minutos', 1, 'Tocas a una criatura voluntaria. Gana velocidad de vuelo de 18 m durante la duración.', 'Al lanzarlo con ranura nv 4+, puedes apuntar a una criatura adicional por cada nivel adicional.'),
(305, 'Luz del día', 3, 5, 1, '1 acción', '18 m', '1 hora', 0, 'Una esfera de luz de 18 m de radio brilla desde el punto que eliges. La oscuridad creada por conjuros de nivel 3 o menor es disipada en el área.', NULL),
(306, 'Revivir', 3, 7, 0, '1 acción', 'Toque', 'Instantáneo', 0, 'Tocas a una criatura que ha muerto en el último minuto. La criatura regresa a la vida con 1 PG. No revive criaturas que murieron de vejez.', NULL),
(307, 'Disipa magia', 3, 1, 0, '1 acción', '36 m', 'Instantáneo', 0, 'Elige un objeto, criatura o efecto mágico en rango. Los conjuros de nivel 3 o menor sobre el objetivo finalizan. Para conjuros superiores, haces prueba de característica contra CD 10 + nivel del conjuro.', NULL),
(308, 'Lanzamiento de relámpagos', 3, 5, 0, '1 acción', 'Personal', 'Instantáneo', 0, 'Un rayo de 30 m de longitud y 1,5 m de ancho. Las criaturas en la línea hacen tSalv de DES: fracaso 8d6 eléctrico, éxito la mitad.', 'Al lanzarlo con ranura nv 4+, el daño aumenta 1d6 por cada nivel adicional.'),
(401, 'Polimorfar', 4, 8, 0, '1 acción', '18 m', 'Hasta 1 hora', 1, 'Transformas una criatura en otra forma. La criatura hace tSalv de SAB. Si falla, se convierte en la bestia elegida hasta que caiga a 0 PG o el conjuro termine.', NULL),
(402, 'Tormenta de hielo', 4, 5, 0, '1 acción', '90 m', 'Instantáneo', 0, 'Granizo helado cae en un cilindro de 6 m de radio y 6 m de altura. Las criaturas hacen tSalv de DES: fracaso 2d8 contundente + 4d6 frío, éxito solo la mitad.', 'Al lanzarlo con ranura nv 5+, el daño contundente aumenta 1d8 por cada nivel adicional.'),
(403, 'Destierro', 4, 1, 0, '1 acción', '18 m', 'Hasta 1 minuto', 1, 'Intentas desterrar a una criatura a otro plano. Hace tSalv de CAR. Si falla, queda desterrada hasta que el conjuro termine o concentración se rompa.', NULL),
(404, 'Adivinación', 4, 3, 1, '1 acción', 'Personal', 'Instantáneo', 0, 'Tu magia y una ofrenda te ponen en contacto con un semidiós, espíritu u otro ser de conocimiento. Recibes una respuesta breve, honesta sobre un acontecimiento futuro en los próximos 7 días.', NULL),
(405, 'Guardián de la fe', 4, 1, 0, '1 acción', '9 m', '8 horas', 0, 'Aparece un gran guardián espectral que protege un área de 3 m de radio. Las criaturas hostiles que entren en el área reciben 20 daño radiante (tSalv de DES, mitad si tiene éxito).', NULL),
(501, 'Bola de fuego mayor', 5, 5, 0, '1 acción', '45 m', 'Instantáneo', 0, 'Como Bola de fuego pero inflige 12d6 de daño de fuego. Rango de explosión 6 m.', 'Al lanzarlo con ranura nv 6+, el daño aumenta 1d6 por cada nivel adicional.'),
(502, 'Cono de frío', 5, 5, 0, '1 acción', 'Personal', 'Instantáneo', 0, 'Un cono de aire helado de 18 m. Las criaturas hacen tSalv de CON: fracaso 8d8 daño frío, éxito la mitad.', 'Al lanzarlo con ranura nv 6+, el daño aumenta 1d8 por cada nivel adicional.'),
(503, 'Resurrección', 5, 7, 0, '1 hora', 'Toque', 'Instantáneo', 0, 'Traes de vuelta a un muerto que lleva menos de 10 años muerto. La criatura regresa a la vida con 1 PG con todas sus habilidades. Lleva un punto de agotamiento.', NULL),
(504, 'Telepatía', 5, 3, 0, '1 acción', 'Sin límite', 'Hasta 24 horas', 1, 'Estableces un vínculo telepático con otra criatura que conozcas. Podéis comunicaros libremente a cualquier distancia (incluso planos distintos).', NULL),
(505, 'Ráfaga de llamas', 5, 2, 0, '1 acción', 'Personal', 'Instantáneo', 0, 'Cuatro columnas de llamas bajan del cielo. Cada una afecta a un cilindro de 3 m de radio y 12 m de altura: tSalv de DES o 4d6 fuego + 4d6 radiante (mitad si tiene éxito).', 'Al lanzarlo con ranura nv 6+, el daño de fuego y radiante aumenta 1d6 por cada nivel adicional.'),
(601, 'Cadena de relámpagos', 6, 5, 0, '1 acción', '30 m', 'Instantáneo', 0, 'Un rayo golpea a un objetivo primario: 10d8 eléctrico (tSalv de DES, mitad si tiene éxito). El rayo rebota hasta tres objetivos adicionales dentro de 9 m del anterior.', 'Al lanzarlo con ranura nv 7+, el daño aumenta 1d8 por nivel de ranura.'),
(602, 'Crear no muertos', 6, 7, 0, '1 minuto', '3 m', 'Instantáneo', 0, 'Puedes lanzar este conjuro solo de noche. Hasta tres cadáveres de humanoides medianos o pequeños se levantan como ghules bajo tu control hasta el próximo anochecer.', 'Al lanzarlo con ranura nv 7+, puedes crear criatura más poderosa o más criaturas.'),
(603, 'Visión de la verdad', 6, 3, 0, '1 acción', 'Personal', 'Hasta 1 hora', 1, 'Puedes ver las cosas como son realmente. Ves criaturas invisibles y objetos, ves en la oscuridad, ves planos etéreos y percibes ilusiones como tales.', NULL),
(701, 'Teletransportación', 7, 2, 0, '1 acción', '3 m', 'Instantáneo', 0, 'Tú y hasta ocho criaturas voluntarias en rango os teletransportáis a un destino que conozcas. La fiabilidad depende del conocimiento que tengas del destino.', NULL),
(702, 'Regeneración', 7, 8, 0, '1 minuto', 'Toque', '1 hora', 0, 'Tocas a una criatura y estimulas su capacidad de curación. El objetivo recupera 4d8+15 PG. Durante la duración, recupera 1 PG al inicio de cada turno.', NULL),
(703, 'Mano de hierro', 7, 2, 0, '1 acción', '18 m', 'Hasta 1 minuto', 1, 'Una mano arcana gigante (4×4 m) aparece en un punto. Puede: bloquear, empujar (Fueza del conjurador vs. la criatura), agarrar o aplastar.', NULL),
(801, 'Terremoto', 8, 5, 0, '1 acción', '120 m', 'Instantáneo', 0, 'Creas un seísmo en radio de 30 m. El terreno se vuelve difícil, estructuras pueden derrumbarse y criaturas pueden caer al suelo. Efectos variados según la naturaleza del suelo.', NULL),
(802, 'Plaga de insectos', 8, 2, 0, '1 acción', '90 m', 'Hasta 10 minutos', 1, 'Una nube de langostas de 6 m de radio llena el área. Es terreno difícil. Las criaturas en el área al inicio de tu turno reciben 4d10 daño perforante (tSalv de CON, mitad si tiene éxito).', NULL),
(803, 'Palabra de poder: aturdir', 8, 4, 0, '1 acción', '18 m', 'Hasta 1 minuto', 0, 'Pronuncias una palabra de poder que abruma la mente de una criatura con 150 PG o menos. Queda aturdida. Puede repetir tSalv de CON al final de cada turno.', NULL),
(901, 'Deseo', 9, 2, 0, '1 acción', 'Personal', 'Instantáneo', 0, 'El conjuro más poderoso que pueden lanzar los mortales. Replicar cualquier conjuro de nivel 8 o inferior sin componentes. O bien, puedes intentar cumplir un deseo literal, con riesgo de efectos secundarios graves.', NULL),
(902, 'Palabra de poder: matar', 9, 4, 0, '1 acción', '18 m', 'Instantáneo', 0, 'Pronuncias una palabra de poder que obliga a una criatura con 100 PG o menos a morir instantáneamente. Sin tirada de salvación.', NULL),
(903, 'Tempestad del tiempo', 9, 2, 0, '1 acción', '90 m', 'Hasta 1 minuto', 1, 'Invocas una tempestad mágica en un cilindro de 40 m de radio y 40 m de altura. Las criaturas en el área hacen tSalv de CON o reciben 6d10 trueno y están aturdidas. Viento, lluvia y rayos dificultan la acción.', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `spell_attack`
--

CREATE TABLE `spell_attack` (
  `spell_id` int(6) NOT NULL,
  `attack_type_id` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `spell_attack`
--

INSERT INTO `spell_attack` (`spell_id`, `attack_type_id`) VALUES
(4, 1),
(6, 1),
(7, 1),
(103, 2),
(105, 2),
(107, 1),
(202, 2),
(205, 1),
(206, 1),
(301, 2),
(303, 2),
(308, 2),
(402, 2),
(501, 2),
(502, 2),
(601, 2),
(802, 2),
(803, 2),
(902, 2),
(903, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `spell_attack_type`
--

CREATE TABLE `spell_attack_type` (
  `attack_type_id` int(1) NOT NULL,
  `attack_type_name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `spell_attack_type`
--

INSERT INTO `spell_attack_type` (`attack_type_id`, `attack_type_name`) VALUES
(1, 'Ataque de conjuro'),
(2, 'Salvación');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `spell_class`
--

CREATE TABLE `spell_class` (
  `spell_id` int(6) NOT NULL,
  `class_id` int(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `spell_class`
--

INSERT INTO `spell_class` (`spell_id`, `class_id`) VALUES
(1, 2),
(1, 6),
(1, 11),
(1, 12),
(2, 2),
(2, 6),
(2, 11),
(3, 2),
(3, 6),
(3, 11),
(4, 6),
(4, 11),
(5, 3),
(6, 3),
(7, 6),
(7, 11),
(8, 2),
(8, 6),
(8, 11),
(8, 12),
(9, 2),
(9, 3),
(9, 6),
(10, 6),
(10, 11),
(101, 2),
(101, 3),
(101, 8),
(102, 2),
(102, 3),
(102, 4),
(103, 2),
(103, 6),
(104, 6),
(105, 6),
(105, 11),
(106, 3),
(106, 8),
(107, 6),
(107, 11),
(108, 6),
(109, 2),
(109, 4),
(110, 3),
(110, 4),
(111, 3),
(111, 6),
(112, 2),
(112, 6),
(201, 2),
(201, 6),
(201, 11),
(201, 12),
(202, 2),
(202, 12),
(203, 6),
(204, 6),
(204, 11),
(205, 6),
(205, 12),
(206, 3),
(207, 6),
(207, 12),
(208, 2),
(208, 6),
(301, 6),
(301, 11),
(302, 6),
(302, 11),
(303, 2),
(303, 12),
(304, 6),
(304, 11),
(305, 3),
(305, 4),
(306, 3),
(306, 8),
(307, 3),
(307, 4),
(307, 6),
(308, 6),
(308, 11),
(401, 4),
(401, 6),
(402, 6),
(402, 11),
(403, 3),
(403, 8),
(404, 3),
(404, 4),
(405, 3),
(501, 6),
(501, 11),
(502, 6),
(502, 11),
(503, 3),
(503, 8),
(504, 6),
(505, 3),
(505, 4),
(601, 6),
(601, 11),
(602, 3),
(602, 6),
(603, 3),
(603, 6),
(701, 6),
(701, 11),
(702, 3),
(702, 4),
(703, 6),
(801, 3),
(801, 4),
(801, 6),
(802, 3),
(802, 4),
(802, 8),
(803, 2),
(803, 6),
(803, 12),
(901, 6),
(901, 11),
(902, 2),
(902, 6),
(902, 12),
(903, 6),
(903, 11);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `spell_component`
--

CREATE TABLE `spell_component` (
  `component_id` int(1) NOT NULL,
  `component_name` varchar(20) NOT NULL,
  `component_short` char(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `spell_component`
--

INSERT INTO `spell_component` (`component_id`, `component_name`, `component_short`) VALUES
(1, 'Verbal', 'V'),
(2, 'Somático', 'S'),
(3, 'Material', 'M');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `spell_damage`
--

CREATE TABLE `spell_damage` (
  `spell_id` int(6) NOT NULL,
  `damage_id` int(2) NOT NULL,
  `damage_dice` varchar(10) NOT NULL,
  `damage_scaling` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `spell_damage`
--

INSERT INTO `spell_damage` (`spell_id`, `damage_id`, `damage_dice`, `damage_scaling`) VALUES
(4, 4, '1d10', '+1d10 en niveles 5, 11 y 17'),
(6, 7, '1d6', '+1d6 cada 2 niveles a partir de nv5'),
(7, 3, '1d8', '+1d8 en niveles 5, 11 y 17'),
(10, 1, '1d6', 'Solo en turno inicial'),
(101, 11, '1d8', '+1d8 por nivel de ranura'),
(105, 4, '3d6', '+1d6 por nivel de ranura'),
(107, 5, '1d4+1', 'Dardo fijo, no escala con dado'),
(203, 1, '2d4', '+1 dardo por nivel de ranura'),
(206, 11, '1d8', '+1d8 por 2 niveles de ranura'),
(301, 4, '8d6', '+1d6 por nivel de ranura'),
(302, 0, '0', NULL),
(308, 6, '8d6', '+1d6 por nivel de ranura'),
(402, 2, '2d8', NULL),
(402, 3, '4d6', '+1d8 contundente por nivel'),
(501, 4, '12d6', '+1d6 por nivel de ranura'),
(502, 3, '8d8', '+1d8 por nivel de ranura'),
(505, 4, '4d6', '+1d6 fuego y radiante por nivel'),
(505, 11, '4d6', NULL),
(601, 6, '10d8', '+1d8 por nivel de ranura'),
(801, 2, '0', 'Daño por estructuras derrumbadas'),
(802, 8, '4d10', NULL),
(901, 0, '0', NULL),
(902, 0, '0', 'Muerte instantánea'),
(903, 13, '6d10', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `spell_save`
--

CREATE TABLE `spell_save` (
  `spell_id` int(6) NOT NULL,
  `skill_id` int(1) NOT NULL,
  `save_effect` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `spell_save`
--

INSERT INTO `spell_save` (`spell_id`, `skill_id`, `save_effect`) VALUES
(103, 5, 'No se duerme'),
(105, 2, 'Mitad del daño'),
(202, 5, 'Ignora la sugestión'),
(301, 2, 'Mitad del daño'),
(303, 5, 'No queda incapacitado'),
(308, 2, 'Mitad del daño'),
(402, 2, 'Mitad del daño'),
(403, 6, 'No queda desterrado'),
(502, 3, 'Mitad del daño'),
(601, 2, 'Mitad del daño'),
(802, 3, 'Mitad del daño'),
(903, 3, 'No queda aturdido');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `spell_school`
--

CREATE TABLE `spell_school` (
  `spell_school_id` int(2) NOT NULL,
  `spell_school_name` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `spell_school`
--

INSERT INTO `spell_school` (`spell_school_id`, `spell_school_name`) VALUES
(1, 'Abjuración'),
(3, 'Adivinación'),
(2, 'Conjuración'),
(4, 'Encantamiento'),
(5, 'Evocación'),
(6, 'Ilusión'),
(7, 'Nigromancia'),
(8, 'Transmutación');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `spell_spell_component`
--

CREATE TABLE `spell_spell_component` (
  `spell_id` int(6) NOT NULL,
  `component_id` int(1) NOT NULL,
  `material_desc` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `spell_spell_component`
--

INSERT INTO `spell_spell_component` (`spell_id`, `component_id`, `material_desc`) VALUES
(1, 1, NULL),
(1, 2, NULL),
(2, 1, NULL),
(2, 2, NULL),
(2, 3, 'Un trozo de cuerda'),
(3, 1, NULL),
(3, 2, NULL),
(4, 1, NULL),
(4, 2, NULL),
(5, 1, NULL),
(6, 1, NULL),
(6, 2, NULL),
(7, 1, NULL),
(7, 2, NULL),
(7, 3, 'Un pequeño cono de cristal o metal'),
(8, 2, NULL),
(8, 3, 'Trozo de lana o pellizco de polvo blanco'),
(9, 2, NULL),
(9, 3, 'Un gusano luciérnaga aplastado'),
(10, 1, NULL),
(10, 2, NULL),
(101, 1, NULL),
(101, 2, NULL),
(102, 1, NULL),
(102, 2, NULL),
(103, 1, NULL),
(103, 2, NULL),
(103, 3, 'Pétalos de rosa o una cigarra'),
(104, 1, NULL),
(104, 2, NULL),
(104, 3, 'Trozo de cuero curtido'),
(105, 1, NULL),
(105, 2, NULL),
(107, 1, NULL),
(107, 2, NULL),
(108, 1, NULL),
(108, 2, NULL),
(201, 1, NULL),
(201, 2, NULL),
(201, 3, 'Un párpado de murciélago'),
(202, 1, NULL),
(202, 2, NULL),
(202, 3, 'Una lengua de serpiente y miel'),
(203, 1, NULL),
(203, 2, NULL),
(203, 3, 'Bola de cristal rellena de agua y ácido'),
(301, 1, NULL),
(301, 2, NULL),
(301, 3, 'Una pequeña bola de guano de murciélnaga y azufre'),
(302, 1, NULL),
(302, 2, NULL),
(308, 1, NULL),
(308, 2, NULL),
(308, 3, 'Trozo de piel de piel de murciélago y cristal'),
(401, 1, NULL),
(401, 2, NULL),
(501, 1, NULL),
(501, 2, NULL),
(501, 3, 'Sulfuro puro'),
(502, 1, NULL),
(502, 2, NULL),
(502, 3, 'Un pequeño cono de cristal'),
(601, 1, NULL),
(601, 2, NULL),
(601, 3, 'Trozos de vidrio y piel de medusa'),
(701, 1, NULL),
(701, 2, NULL),
(701, 3, 'Diamante de 100 po que el conjuro consume'),
(801, 1, NULL),
(801, 2, NULL),
(801, 3, 'Un pellizco de tierra, un pedazo de roca y arcilla'),
(901, 1, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subclass`
--

CREATE TABLE `subclass` (
  `class_id` int(4) NOT NULL,
  `subclass_id` int(4) NOT NULL,
  `subclass_name` varchar(50) NOT NULL DEFAULT '',
  `subclass_desc` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `subclass`
--

INSERT INTO `subclass` (`class_id`, `subclass_id`, `subclass_name`, `subclass_desc`) VALUES
(1, 1, 'Camino del Berserker', 'El bárbaro que sigue el Camino del Berserker canaliza su furia en una frenética violencia. Puede entrar en frenesí para realizar ataques adicionales como acción adicional durante la furia, aunque sufre agotamiento. A niveles superiores gana inmunidad al encanto y el miedo durante la furia.'),
(1, 2, 'Camino del Guerrero Totem', 'El bárbaro forma un vínculo espiritual con un animal tótem (oso, águila, lobo u otros). Cada animal otorga poderes distintos: el oso proporciona resistencia adicional, el águila concede visión de águila y el lobo ayuda a los aliados a derribar enemigos. Permite una conexión profunda con el mundo natural y espiritual.'),
(1, 3, 'Camino de la Magia Salvaje', 'Al entrar en furia, el bárbaro desata oleadas de magia arcana incontrolada. Cada vez que entra en furia se produce un efecto de la tabla de Oleada Mágica (curación, teletransportación, tormenta de elementos, etc.). A nivel 6 puede detectar magia de forma innata y a nivel 10 puede lanzar Disipa Magia.'),
(2, 1, 'Colegio de la Elocuencia', 'Los bardos de la Elocuencia dominan el arte de la persuasión y el engaño. Sus Inspiraciones Bárdicas nunca se pierden si el receptor falla la tirada; en su lugar, el dado se devuelve. A nivel 6 pueden usar la Inspiración como reacción para mejorar una tirada de habilidad de Carisma propia.'),
(2, 2, 'Colegio del Saber', 'El Colegio del Saber prioriza el conocimiento enciclopédico. Sus bardos adquieren competencia en tres habilidades adicionales a nivel 3 y pueden usar Palabras de Puñal para restar a las tiradas de un enemigo (similar a la Inspiración Bárdica). A nivel 6 obtienen acceso a conjuros de cualquier lista.'),
(2, 3, 'Colegio de la Danza', 'Nuevo en 2024. El bardo entrelaza el movimiento artístico con el combate, usando su cuerpo como arma y escudo. Gana un dado de Agilidad que puede usar para mejorar su CA o sus ataques, y puede moverse por los espacios de aliados como si fueran suyos. A nivel 6 su baile es tan fluido que puede evitar ataques de oportunidad.'),
(3, 1, 'Dominio de la Vida', 'El clérigo de la Vida es el curador por excelencia. Sus conjuros de curación restauran el máximo de PG a nivel 1. A nivel 2 puede usar Canal de Divinidad: Preservar Vida para restaurar PG distribuidos entre aliados cercanos. A nivel 6 sus hechizos curativos también curan al propio clérigo cuando los lanza sobre otro.'),
(3, 2, 'Dominio de la Luz', 'El clérigo de la Luz controla el fuego y la luz radiante. Conoce Luz de las Hadas y Llama Sagrada de forma innata. A nivel 2, Canal de Divinidad: Destello Radiante ciega a los no muertos en el área. A nivel 6 puede usar su reacción para imponer desventaja en el ataque de un ser de las sombras o no muerto.'),
(3, 3, 'Dominio de los Trucos', 'El clérigo de los Trucos sirve a deidades de la astucia y la trampa. Sus conjuros incluyen Disfrazarse y Voz de la Mente. A nivel 2, el Canal de Divinidad le permite bendecir a un aliado con Bendición del Embaucador para hacer invisibles sus tiradas de Engaño y Sigilo durante 1 hora.'),
(3, 4, 'Dominio de la Guerra', 'El clérigo de la Guerra es un guerrero sagrado. Gana competencia en armaduras pesadas y armas marciales. A nivel 1, Canal de Divinidad: Golpe Guiado permite añadir +10 a una tirada de ataque. A nivel 6, el clérigo de la Guerra puede realizar un ataque con arma como acción adicional al lanzar un conjuro de nivel 1 o superior.'),
(3, 5, 'Dominio de la Naturaleza', 'El clérigo de la Naturaleza actúa como vínculo entre la divinidad y el mundo natural. Gana competencia en armadura pesada y un truco druídico adicional. A nivel 2, Canal de Divinidad: Encanto de Animales y Plantas calma o encanta a bestias y plantas en un área. A nivel 6, gana resistencia a un tipo de daño elemental.'),
(3, 6, 'Dominio de la Tempestad', 'El clérigo de la Tempestad controla el viento, el rayo y las tormentas. Gana competencia en armaduras pesadas y armas marciales. A nivel 2, Canal de Divinidad: Ira Destructora potencia al máximo el daño de eléctrico o trueno. A nivel 6, cuando un ser le golpea, puede usar su reacción para causar daño eléctrico al atacante.'),
(3, 7, 'Dominio de los Conocimientos', 'El clérigo de los Conocimientos es un erudito divino. A nivel 1 aprende dos idiomas adicionales y puede leer pensamientos superficiales una vez por descanso. A nivel 2, Canal de Divinidad: Conocimiento de las Edades otorga competencia temporal en cualquier habilidad o herramienta. A nivel 6 puede usar Visión del Conocimiento para saber cómo usar un objeto.'),
(3, 8, 'Dominio de la Muerte', 'El clérigo de la Muerte (generalmente maligno o antipaladin) controla la energía necromantica. Conoce el truco Toque de Muerte y puede infligir daño necrótico adicional. A nivel 2, Canal de Divinidad: Toque Necrótico inflige daño necrótico con un toque. A nivel 6 puede infligir ese toque a distancia y evita que los muertos se levanten en el área.'),
(4, 1, 'Círculo de la Luna', 'Los druidas del Círculo de la Luna maestrean la Forma Salvaje combativa. Pueden transformarse en bestias más poderosas (hasta VD 1 a nivel 2, sin límite de VD a nivel 20) y obtener formas de criatura de elementales a nivel 10. Su Forma Salvaje dura más y conserva puntos de concentración al transformarse.'),
(4, 2, 'Círculo de la Tierra', 'Los druidas del Círculo de la Tierra se sincronizan con un terreno específico (ártico, costa, desierto, bosque, pradera, montaña, pantano o Infraoscuridad). Obtienen conjuros adicionales según el terreno y recuperan ranuras de conjuro con los descansos cortos a nivel 2. Su habilidad de Magia Natural permite ignorar ciertos terrenos difíciles.'),
(4, 3, 'Círculo de las Esporas', 'Los druidas del Círculo de las Esporas ven la muerte como parte del ciclo natural. Pueden infundir sus Formas Salvajes con esporas que causan daño necrótico, levantar cadáveres como zombis de esporas, y a nivel 6 crear un aura de esporas que daña a quienes entren. A nivel 10, las esporas pueden controlar brevemente a los no muertos.'),
(5, 1, 'Campeón', 'El Campeón lleva las capacidades de combate físico a su extremo. Obtiene Crítico Mejorado (golpe crítico con 19-20 natural) a nivel 3, y con 18-20 a nivel 15. A nivel 7 puede elegir un segundo Estilo de Combate. A nivel 10 gana el rasgo Atleta Adicional, que le permite recuperar PG mediante un descanso corto. Es el arquetipo más sencillo y directo.'),
(5, 2, 'Maestro de Batalla', 'El Maestro de Batalla estudia combate como un arte marcial y académico. A nivel 3 aprende cuatro Maniobras que gastan dados de superioridad (d8). Las maniobras incluyen Golpe de Precisión, Derribo, Provocar y muchas más. A nivel 7 aprende más maniobras y los dados mejoran a d10, y a nivel 15 a d12.'),
(5, 3, 'Caballero Arcano', 'El Caballero Arcano combina habilidades marciales con magia arcana. Puede lanzar conjuros de abjuración y evocación de la lista del mago. A nivel 3, lanza conjuros de nivel 1. A nivel 7 puede invocar su arma vinculada a su mano con acción adicional. A nivel 10 puede lanzar un truco como acción adicional tras atacar.'),
(6, 1, 'Escuela de Abjuración', 'El mago abjurador se especializa en conjuros protectores. A nivel 2 obtiene Escudo Arcano: un muro de magia que absorbe daño (igual a nivel de mago + modificador de INT, se recarga con descanso largo). A nivel 6 el escudo protege también a aliados cercanos con un muro menor. A nivel 10 puede lanzar Disipa Magia sin gastar ranura.'),
(6, 2, 'Escuela de Conjuración', 'El mago conjurador domina la invocación de criaturas y materiales. A nivel 2 obtiene Alteración Menor para crear pequeños objetos no mágicos durante 1 hora. A nivel 6 puede teletransportarse hasta 9 m como acción adicional una vez por turno. A nivel 10 sus conjuros de invocación concentran criaturas más poderosas.'),
(6, 3, 'Escuela de Adivinación', 'El mago adivinador predice y manipula el destino. A nivel 2 obtiene Augurio: tira dos d20 al preparar conjuros; estos dados (Presagios) pueden sustituir cualquier tirada de un ser en el área de juego antes del próximo descanso largo. A nivel 6 puede lanzar Augurio sin gastar recursos. A nivel 10 obtiene un tercer Presagio.'),
(6, 4, 'Escuela de Encantamiento', 'El mago encantador controla mentes y emociones. A nivel 2, Hipnótico puede encantar brevemente a un ser con un susurro como acción adicional. A nivel 6 puede crear un Encanto que afecta a dos objetivos con el mismo conjuro de encantamiento. A nivel 10 puede borrar la memoria de haber sido encantado de las víctimas de sus hechizos.'),
(6, 5, 'Escuela de Evocación', 'El mago evocador lanza los conjuros ofensivos más devastadores. A nivel 2 puede Esculpir Hechizos para excluir automáticamente a aliados del área de daño. A nivel 6 puede añadir su modificador de INT al daño de un conjuro de evocación una vez por turno. A nivel 10 sus conjuros ignorar la resistencia al tipo de daño que infligen.'),
(6, 6, 'Escuela de Ilusión', 'El mago ilusionista manipula la percepción. A nivel 2 puede crear una Ilusión Menor mejorada que incluye sonido, olor y temperatura. A nivel 6 puede animar su ilusión para que se mueva hasta 18 m por turno. A nivel 10 puede hacer que sus ilusiones dañen físicamente a quienes crean que son reales mediante choque psíquico.'),
(6, 7, 'Escuela de Nigromancia', 'El mago nigromante controla la muerte y los no muertos. A nivel 2 puede lanzar conjuros de nigromancia con más eficacia, y los no muertos que crea ganan PG extra. A nivel 6 puede drenar la vitalidad de una criatura que acabe de morir para recuperar PG. A nivel 10 sus no muertos son más resistentes y obedientes.'),
(6, 8, 'Escuela de Transmutación', 'El mago transmutador altera la materia y la forma. A nivel 2 crea una Piedra del Transmutador que almacena un beneficio (visión en la oscuridad, resistencia, velocidad extra u otro). A nivel 6 puede Mutar a una criatura alterando un tipo de daño temporalmente. A nivel 10 puede transformarse en cualquier bestia como Forma Salvaje del druida.'),
(7, 1, 'Tradición de la Mano Abierta', 'La Mano Abierta es la tradición monástica más pura, enfocada en el combate desarmado. A nivel 3, tras un Golpe de Flurry, puede realizar maniobras de empuje, derribo o privación de reacciones. A nivel 6, Plenitud del Cuerpo permite curar todos los PG una vez por descanso largo. A nivel 11, puede hacer ataques que atraviesan conjuros de protección.'),
(7, 2, 'Tradición de la Sombra', 'Los monjes de la Sombra usan la oscuridad como arma. A nivel 3 aprenden conjuros de hechicero (Paso de Sombras, Silencio, Oscuridad, etc.) usando puntos de Ki. A nivel 6 pueden moverse en penumbra o oscuridad sin provocar ataques de oportunidad. A nivel 11 pueden crear un clon sombrío de sí mismos.'),
(7, 3, 'Tradición de los Cuatro Elementos', 'El monje de los Cuatro Elementos controla el fuego, la tierra, el agua y el aire mediante el Ki. A nivel 3 aprende disciplinas elementales que emulan conjuros. Puede caminar sobre agua, respirar bajo ella, crear explosiones de fuego, mover tierra y muchas otras hazañas. Cada disciplina tiene un coste en puntos de Ki.'),
(8, 1, 'Juramento de Devoción', 'El Juramento de Devoción representa al paladín clásico de virtud y rectitud. Conjuros adicionales: Protección del Mal y el Bien, Santuario, Hoja de Llama, Zona de la Verdad. Canal de Divinidad: Arma Sagrada (añade CAR al ataque) y Expulsar al Mal (expulsa elementales y no muertos). A nivel 7, Aura Sagrada protege a aliados cercanos.'),
(8, 2, 'Juramento de los Ancestros', 'El paladín de los Ancestros protege la belleza y el gozo de la vida. Conjuros: Hechizo de Amistad, Hablar con los Animales, Hoja de Llamas Feéricas, Paso Brumoso. Canal de Divinidad: Gracia Natural (curar un aliado) y Expulsar a los Infieles (afecta a celestes, fey y elementales). A nivel 7, Aura Feérica otorga ventaja en salvaciones contra encantamiento.'),
(8, 3, 'Juramento de la Venganza', 'El paladín de la Venganza persigue implacablemente a los malvados. Conjuros: Maldición, Detección del Bien y del Mal, Inmovilizar Persona, Rayo de Tinieblas. Canal de Divinidad: Ojo por Ojo (castiga al que golpee al paladín) y Voto de Enemistad (ventaja en ataques contra un objetivo). A nivel 7, Aura de Wrath potencia el daño de todos los paladines cercanos.'),
(8, 4, 'Juramento de la Gloria', 'El paladín de la Gloria inspira a sus aliados a grandes hazañas heroicas. Conjuros: Salto, Velocidad del Heraldo, Mejora de Característica, Velocidad. Canal de Divinidad: Impulso Inspirador (bonificador de competencia al daño de aliados) y Peroración de la Victoria (discurso que da PG temporales). Nuevo en 2024.'),
(9, 1, 'Ladrón', 'El pícaro Ladrón perfecciona el arte del robo y el hurto. A nivel 3, Manos Rápidas le permite usar las Herramientas de Ladrón, hacer una prueba de Prestidigitación o usar un objeto como parte de su Acción Astucia. Usa Artefacto para activar objetos mágicos independientemente de su clase. A nivel 9 puede escalar superficies difíciles y trepar cabeza abajo.'),
(9, 2, 'Asesino', 'El pícaro Asesino se especializa en eliminar objetivos rápidamente. A nivel 3, los ataques en el primer turno de combate contra enemigos sorprendidos son siempre un crítico. A nivel 9 puede infiltrarse adoptando identidades falsas que sean casi perfectas. A nivel 13 puede imitar la voz, el lenguaje corporal y la escritura de cualquier persona observada.'),
(9, 3, 'Embaucador Arcano', 'El pícaro Embaucador estudia magia ilusoria y de encantamiento. A nivel 3 aprende trucos y conjuros de nivel 1-4 de la lista del mago (solo ilusión y encantamiento más uno de cualquier escuela). A nivel 9 puede robar hechizos de otro lanzador (usarlos él mismo). A nivel 13 puede crear un doble ilusorio que lo protege de los ataques.'),
(10, 1, 'Cazador', 'El Cazador se especializa en técnicas de caza y combate contra múltiples objetivos o criaturas poderosas. A nivel 3 elige una Presa de Cazador: Destructor de Hordas (daño en área contra grupos), Matador de Gigantes (ataque de oportunidad cuando el enemigo se aleja) o Aniquilador Colosal (daño adicional a grandes objetivos). A nivel 7 elige una Defensa de Cazador.'),
(10, 2, 'Amo de Bestias', 'El Amo de Bestias forma un vínculo profundo con un animal compañero de combate. A nivel 3 gana un Compañero Primal que actúa en su turno (Presas Bestia, Buitre Primal o Serpiente Primal). Puede darle órdenes para que ataque, ayude o se defienda. A nivel 7 el vínculo se fortalece: el animal puede lanzar un ataque adicional.'),
(10, 3, 'Acechador', 'El Acechador es un maestro del combate en terrenos extremos y camuflaje perfecto. A nivel 3 puede ocultarse incluso cuando solo está levemente cubierto y su velocidad no disminuye al rastrear. A nivel 7 puede desaparecer de la vista de un enemigo en cada turno, incluso sin cobertura, usando su reacción.'),
(11, 1, 'Sangre de Dragón', 'La magia del hechicero de Sangre de Dragón proviene de un ancestro dragón. A nivel 1 elige un tipo de dragón que determina el tipo de daño adicional. Gana resistencia a ese tipo de daño, y a nivel 6 puede añadir su CAR al daño de conjuros de ese tipo. A nivel 14 crece alas que le permiten volar 18 m.'),
(11, 2, 'Alma Salvaje', 'La magia del Alma Salvaje es impredecible e incontrolable. Cuando lanza un conjuro de nivel 1 o superior, puede producir efectos aleatorios de la Tabla de Oleada de Magia Salvaje. A nivel 6 puede tirar en la tabla intencionalmente usando un punto de Fuente. A nivel 14 puede estabilizar la magia salvaje o desestabilizarla deliberadamente.'),
(11, 3, 'Alma de la Tormenta', 'Nuevo en 2024. La magia del Alma de la Tormenta está ligada a los vientos y relámpagos. A nivel 1 puede elegir entre daño de trueno o eléctrico como tipo de daño adicional. A nivel 6 puede volar (no planear) usando puntos de Fuente. A nivel 14 genera una tormenta que golpea automáticamente a todos los enemigos cercanos al inicio de su turno.'),
(12, 1, 'El Archidiablo', 'El patrón es un señor del Averno o un archidiablo poderoso. Los conjuros adicionales incluyen Comando, Manos Ardientes, Llamarada Abrasal, Oscuridad. A nivel 1, Bendición del Oscuro añade el CAR a las tiradas de daño de fuego. A nivel 6, el brujo puede llamar a un barón de los demonios o un emisario infernal para cumplir una tarea menor.'),
(12, 2, 'El Gran Anciano', 'El patrón es una entidad de conocimiento prohibido de más allá de las estrellas. Conjuros adicionales: Disipar Ilusión, Detectar Pensamientos, Mensaje Telepático. A nivel 1, el brujo puede comunicarse telepáticamente con cualquier criatura en 27 m. A nivel 6, el patrón susurra secretos que permiten lanzar un conjuro adicional de Magia de Pacto al día.'),
(12, 3, 'La Hada', 'El patrón es un ser feérico poderoso (una reina de las hadas, un señor feérico, etc.). Conjuros adicionales: Disfrazarse, Dormir, Calmar Emociones, Phantasmal Force. A nivel 1, el brujo aprende el truco Luz de las Hadas y puede lanzar Paso Brumoso usando una ranura de Pacto. A nivel 6 puede engañar a una criatura para que lo vea como una presencia amistosa durante 24 horas.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subrace`
--

CREATE TABLE `subrace` (
  `race_id` int(4) NOT NULL,
  `subrace_id` int(4) NOT NULL,
  `subrace_name` varchar(50) NOT NULL DEFAULT '',
  `subrace_desc` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `subrace`
--

INSERT INTO `subrace` (`race_id`, `subrace_id`, `subrace_name`, `subrace_desc`) VALUES
(2, 1, 'Elfo del Bosque', 'Los elfos del bosque tienen reflejos rápidos y sigilo excepcional. Poseen la habilidad Paso por el Bosque, que les permite moverse por terreno no mágico de vegetación difícil sin gastar movimiento extra. Su velocidad base es 35 pies (10,5 m). Tienen visión en la oscuridad y las competencias típicas de los elfos del bosque, como el arco largo.'),
(2, 2, 'Elfo Alto', 'Los elfos altos tienen una mente aguda y dominio innato de la magia básica. Conocen un truco adicional del listado de conjuros de mago. Son elegantes y de porte orgulloso, a menudo asociados con civilizaciones avanzadas. Hablan élfico fluidamente y suelen aprender idiomas adicionales.'),
(2, 3, 'Drow (Elfo Oscuro)', 'Los drow proceden de los Reinos Subterráneos. Poseen visión en la oscuridad superior (120 pies / 36 m), competencia en espada corta, ballesta de mano y estoque, y el rasgo Legado Drow: conocen el truco Luz de las Hadas; al nivel 3 pueden lanzar Oscuridad y al nivel 5 Contrahechizo, una vez cada uno con descanso largo. Son sensibles a la luz solar (desventaja en ataques y percepción cuando están en luz solar directa).'),
(3, 1, 'Mediano Fornido', 'Los medianos fornidos son robustos y resistentes. Tienen el rasgo Resistencia de Fornido: cuando se determina el daño recibido, pueden repetir cualquier dado con resultado de 1 y deben usar el nuevo resultado. Son conocidos por su practicidad y su sentido común. Se establecen con frecuencia en comunidades rurales prósperas.'),
(3, 2, 'Mediano Piesligeros', 'Los medianos piesligeros son los más viajeros de su especie. Tienen el rasgo Camuflarse con Otros: pueden intentar ocultarse incluso cuando solo están parcialmente cubiertos por una criatura de tamaño Mediano o mayor. Son curiosos, amistosos y adaptables, a menudo encontrados en ciudades humanas donde se mezclan con facilidad.'),
(4, 1, 'Enano de las Colinas', 'Los enanos de las colinas son conocidos por su extraordinaria vitalidad. Ganan +1 PG por nivel y tienen resistencia al veneno. Son sociables en comparación con sus primos de la montaña y suelen actuar como intermediarios entre los enanos y otras razas. Tienen competencia en hachas de mano, martillos ligeros y mazas.'),
(4, 2, 'Enano de la Montaña', 'Los enanos de la montaña son físicamente poderosos y tienen una larga historia como guerreros. Ganan competencia en armaduras ligeras y medias, y +2 a FUE. Son más grandes que los enanos de las colinas y viven en ciudades-fortaleza excavadas en las montañas. Son conocidos por su habilidad con las hachas de batalla y picos de guerra.'),
(5, 1, 'Linaje Negro (Ácido)', 'Escamas negro brillante. Daño: Ácido. Aliento: línea 5×30 pies (tSalv DES). Resistencia al ácido. Los dracónidos negros suelen habitar pantanos y zonas oscuras y húmedas. Son sigilosos y vengativos.'),
(5, 2, 'Linaje Azul (Eléctrico)', 'Escamas azul índigo. Daño: Eléctrico. Aliento: línea 5×30 pies (tSalv DES). Resistencia al daño eléctrico. Son orgullosos y metódicos, asociados a tormentas del desierto.'),
(5, 3, 'Linaje Verde (Veneno)', 'Escamas verde esmeralda. Daño: Veneno. Aliento: cono 15 pies (tSalv CON). Resistencia al veneno. Son manipuladores y astutos, aficionados a los bosques densos y los enredos políticos.'),
(5, 4, 'Linaje Rojo (Fuego)', 'Escamas rojo escarlata. Daño: Fuego. Aliento: cono 15 pies (tSalv DES). Resistencia al fuego. Los más arrogantes y temidos de los cromáticos; dominantes y explosivos.'),
(5, 5, 'Linaje Blanco (Frío)', 'Escamas blanco nacarado. Daño: Frío. Aliento: cono 15 pies (tSalv CON). Resistencia al frío. Los más instintivos de los cromáticos, adaptados a entornos árticos.'),
(5, 6, 'Linaje de Latón (Fuego)', 'Escamas amarillo dorado cobrizo. Daño: Fuego. Aliento: línea 5×30 pies (tSalv DES). Resistencia al fuego. Los más conversadores de los metálicos; curiosos y amistosos.'),
(5, 7, 'Linaje de Bronce (Eléctrico)', 'Escamas marrón cobrizo con reflejos verdosos. Daño: Eléctrico. Aliento: línea 5×30 pies (tSalv DES). Resistencia eléctrica. Leales y honorables, luchan junto a causas justas.'),
(5, 8, 'Linaje de Cobre (Ácido)', 'Escamas marrón rojizo cobrizo. Daño: Ácido. Aliento: línea 5×30 pies (tSalv DES). Resistencia al ácido. Bromistas y astutos, aficionados a los acertijos.'),
(5, 9, 'Linaje de Oro (Fuego)', 'Escamas dorado brillante. Daño: Fuego. Aliento: cono 15 pies (tSalv DES). Resistencia al fuego. Los más nobles y sabios de los metálicos, dedicados al bien.'),
(5, 10, 'Linaje de Plata (Frío)', 'Escamas plateado brillante. Daño: Frío. Aliento: cono 15 pies (tSalv CON). Resistencia al frío. Empáticos y protectores, los metálicos más cercanos a los humanos.'),
(6, 1, 'Gnomo de las Rocas', 'Los gnomos de las rocas son inventores natos. Tienen el rasgo Constructor: competencia en herramientas de artesano de su elección y en Historia cuando se trate de objetos mágicos, objetos alquímicos o mecanismos tecnológicos. También pueden comunicarse con pequeños animales mecánicos que construyan. Son los gnomos más comunes en mundo de fantasía.'),
(6, 2, 'Gnomo del Bosque', 'Los gnomos del bosque son esquivos y mágicos por naturaleza. Conocen el truco Ilusión menor de forma innata. Además, pueden hablar con animales Pequeños o más pequeños: ardillas, topos, conejos, etc. Son criaturas silvestres que viven entre árboles y raramente se aventuran lejos de su hogar en el bosque.'),
(7, 1, 'Aasimar Protector', 'Destinado a defender a los inocentes. Revelación Celestial (nivel 3): alas de luz, velocidad de vuelo = velocidad terrestre durante 1 minuto, daño radiante adicional (bonificador de competencia) una vez por turno. 1/descanso largo.'),
(7, 2, 'Aasimar Vengador', 'Llamado a erradicar el mal. Revelación Celestial (nivel 3): llamas de energía radiante, velocidad de vuelo durante 1 minuto, daño radiante adicional (bonificador de competencia) una vez por turno. Aura de juicio. 1/descanso largo.'),
(7, 3, 'Aasimar Caído', 'Lleva el peso de una corrupción celestial. Revelación Celestial (nivel 3): energía necróticamente cargada; los enemigos en 3 m reciben daño necrótico (bonificador de competencia) al inicio del turno del aasimar durante 1 minuto. 1/descanso largo.'),
(8, 1, 'Descendiente de Gigante de Piedra', 'Legado: conoce Moldear la Tierra a voluntad. Al nivel 5 puede lanzar Pasar sin Rastro 1/descanso largo. Piel con vetas grises o marrones como el granito.'),
(8, 2, 'Descendiente de Gigante de Escarcha', 'Resistencia al frío. Legado: conoce Armadura de Agathys 1/descanso largo sin gastar ranura. Piel blanquecina o azulada, ojos de azul glacial.'),
(8, 3, 'Descendiente de Gigante de Fuego', 'Resistencia al fuego. Legado: conoce Manos Ardientes 1/descanso largo sin gastar ranura (CON como característica). Piel rojiza o anaranjada, cabello negro azabache.'),
(9, 1, 'Linaje de Asmodeo', 'El más común. Inteligentes y calculadores. Truco: Taumaturgia. Nivel 3: Represalia Infernal. Nivel 5: Oscuridad. Ojos completamente rojos o negros.'),
(9, 2, 'Linaje de Baalzebul', 'Señor de las Moscas. Manipuladores natos. Truco: Taumaturgia. Nivel 3: Rayo de Corona (daño eléctrico). Nivel 5: Cazatalentos. Piel oscura con venas brillantes.'),
(9, 3, 'Linaje de Dispater', 'Señor de Dis. Espías y maestros del engaño. Truco: Taumaturgia. Nivel 3: Disfrazarse. Nivel 5: Detectar Pensamientos. Rasgos físicos sutiles y elegantes.'),
(9, 4, 'Linaje de Fierna', 'Hija de Belial. Extremadamente carismáticos y seductores. Truco: Amigos. Nivel 3: Encantamiento de Persona. Nivel 5: Dominar Persona.'),
(9, 5, 'Linaje de Glasya', 'Hija de Asmodeo. Ladrones y espías de élite. Truco: Ilusión Menor. Nivel 3: Invisibilidad. Nivel 5: Sitio Invisible. Piel en tonos lila o grisáceos.'),
(9, 6, 'Linaje de Levistus', 'Atrapado en hielo eterno. Estoicos y calculadores. Resistencia adicional al frío. Truco: Rayo de Escarcha. Nivel 3: Armadura de Agathys. Nivel 5: versión reforzada.'),
(9, 7, 'Linaje de Mammon', 'Señor de Minauros. Codiciosos y ambiciosos. Truco: Taumaturgia. Nivel 3: Tensión de Tensor. Nivel 5: Arcano Flotante. Ojos con tono áureo.'),
(9, 8, 'Linaje de Mefistófeles', 'El más inteligente de los Archiduques. Gran afinidad arcana. Truco: Llama Sagrada (daño fuego). Nivel 3: Ráfaga de Manos. Nivel 5: Llama Infernal.'),
(9, 9, 'Linaje de Zariel', 'General caída del Avernus. Guerreros natos. Truco: Llama Sagrada. Nivel 3: Represalia Infernal. Nivel 5: Branding Smite. Alas vestigiales visibles.'),
(9, 10, 'Linaje Abismal (Demoniaco)', 'Desciende de demonios, no de diablos. Caótico e impredecible. Resistencia al veneno además del fuego. Truco: Toque de Muerte. Nivel 3: Risa Horrible. Nivel 5: Ráfaga de Llamas.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `trait`
--

CREATE TABLE `trait` (
  `trait_id` int(5) NOT NULL,
  `trait_name` varchar(50) NOT NULL,
  `trait_desc` varchar(3000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `trait`
--

INSERT INTO `trait` (`trait_id`, `trait_name`, `trait_desc`) VALUES
(1, 'Versatilidad Humana', 'Ganas +1 a todas las características. Además, ganas competencia en una habilidad adicional a tu elección.'),
(2, 'Visión en la Oscuridad (Elfo)', 'Puedes ver en luz tenue hasta 18 metros como si fuera luz brillante, y en oscuridad como si fuera luz tenue.'),
(3, 'Ascendencia Feérica', 'Tienes ventaja en las tiradas de salvación contra encantamiento y no puedes ser hechizado.'),
(4, 'Sigilo del Mediano', 'Puedes intentar ocultarte incluso cuando solo estás cubierto por una criatura de al menos un tamaño mayor que el tuyo.'),
(5, 'Resistencia Enana', 'Tienes ventaja en las tiradas de salvación contra veneno y resistencia contra daño por veneno.'),
(6, 'Robusto', 'Tus puntos de golpe aumentan en 1 y aumentan en 1 cada vez que subes de nivel.'),
(7, 'Aliento de Dragón (Draconido)', 'Puedes exhalar energía destructiva. El tipo de daño (ácido, frío, fuego, eléctrico o veneno) depende de tu ascendencia.'),
(8, 'Astucia de Gnomo', 'Tienes ventaja en todas las tiradas de salvación de INT, SAB y CAR contra magia.'),
(9, 'Legado Infernal (Tiefling)', 'Conoces el truco Taumaturgia. Al nivel 3 puedes lanzar Represalia Infernal una vez, recuperándola con descanso largo. Al nivel 5 puedes lanzar Oscuridad una vez.'),
(10, 'Resistencia Celestial (Aasimar)', 'El aasimar tiene resistencia al daño necrótico y al daño radiante.'),
(11, 'Constitución Poderosa (Goliat)', 'El Goliat cuenta como un tamaño mayor para determinar la capacidad de carga y para empujar, arrastrar o levantar objetos y criaturas.'),
(12, 'Curación de Manos (Aasimar)', 'Como acción, el aasimar toca a una criatura y restaura un número de PG igual a su nivel de personaje. Una vez por descanso largo.'),
(13, 'Revelación Celestial: Protector', 'Nivel 3: el Aasimar Protector extiende alas de energía radiante (acción adicional). Durante 1 minuto: velocidad de vuelo igual a su velocidad terrestre y una vez por turno añade su bonificador de competencia como daño radiante adicional. 1/descanso largo.'),
(14, 'Revelación Celestial: Vengador', 'Nivel 3: el Aasimar Vengador se envuelve en llamas de energía radiante (acción adicional). Durante 1 minuto: velocidad de vuelo y añade su bonificador de competencia como daño radiante a un objetivo por turno. 1/descanso largo.'),
(15, 'Revelación Celestial: Caído', 'Nivel 3: el Aasimar Caído emana energía necróticamente cargada. Durante 1 minuto: todos los enemigos en 3 m reciben daño necrótico (bonificador de competencia) al inicio del turno del aasimar. 1/descanso largo.'),
(16, 'Resistencia de Gigante (Goliat)', 'Una vez por descanso corto, cuando el Goliat recibe daño, puede usar su reacción para reducir ese daño a la mitad.'),
(17, 'Legado de Gigante de Piedra', 'El Goliat conoce el conjuro Moldear la Tierra de forma innata (a voluntad). Al nivel 5 puede lanzar Pasar sin Rastro una vez por descanso largo.'),
(18, 'Legado de Gigante de Escarcha', 'El Goliat tiene resistencia al daño de frío y conoce el conjuro Armadura de Agathys de forma innata (1/descanso largo, sin gastar ranura).'),
(19, 'Legado de Gigante de Fuego', 'El Goliat tiene resistencia al daño de fuego y conoce el conjuro Manos Ardientes de forma innata (1/descanso largo, sin gastar ranura, característica CON).'),
(20, 'Aguante Atroz (Orco)', 'Una vez por descanso largo, cuando el orco sufre daño que lo reduciría a 0 PG pero no lo mata instantáneamente, puede en su lugar quedar en 1 PG.'),
(21, 'Presencia Intimidante (Orco)', 'El orco tiene competencia en la habilidad Intimidación. Si ya la tenía, puede elegir cualquier otra habilidad.'),
(22, 'Poderoso Físico (Orco)', 'El orco cuenta como un tamaño mayor para determinar la capacidad de carga y para empujar, arrastrar o levantar.'),
(30, 'Resistencia de Dragón (Dracónido)', 'El dracónido tiene resistencia al tipo de daño de su linaje (ácido, eléctrico, veneno, fuego o frío).'),
(31, 'Instinto de Dragón (Dracónido)', 'El dracónido añade 1d4 a sus pruebas de Intimidación o Persuasión (a elección al crear el personaje).'),
(40, 'Legado de Asmodeo', 'Truco: Taumaturgia (innato). Nivel 3: Represalia Infernal 1/descanso largo. Nivel 5: Oscuridad 1/descanso largo. Característica: Carisma.'),
(41, 'Legado de Baalzebul', 'Truco: Taumaturgia (innato). Nivel 3: Rayo de Corona 1/descanso largo. Nivel 5: Cazatalentos 1/descanso largo.'),
(42, 'Legado de Dispater', 'Truco: Taumaturgia (innato). Nivel 3: Disfrazarse 1/descanso largo. Nivel 5: Detectar Pensamientos 1/descanso largo.'),
(43, 'Legado de Fierna', 'Truco: Amigos (innato). Nivel 3: Encantamiento de Persona 1/descanso largo. Nivel 5: Dominar Persona 1/descanso largo.'),
(44, 'Legado de Glasya', 'Truco: Ilusión Menor (innato). Nivel 3: Invisibilidad 1/descanso largo. Nivel 5: Sitio Invisible 1/descanso largo.'),
(45, 'Legado de Levistus', 'Resistencia adicional al daño de frío. Truco: Rayo de Escarcha. Nivel 3: Armadura de Agathys 1/descanso largo. Nivel 5: Armadura de Agathys reforzada.'),
(46, 'Legado de Mammon', 'Truco: Taumaturgia (innato). Nivel 3: Tensión de Tensor 1/descanso largo. Nivel 5: Arcano Flotante 1/descanso largo.'),
(47, 'Legado de Mefistófeles', 'Truco: Llama Sagrada (daño fuego). Nivel 3: Ráfaga de Manos 1/descanso largo. Nivel 5: Llama Infernal 1/descanso largo.'),
(48, 'Legado de Zariel', 'Truco: Llama Sagrada (innato). Nivel 3: Represalia Infernal 1/descanso largo. Nivel 5: Branding Smite 1/descanso largo.'),
(49, 'Legado Abismal (Demoniaco)', 'Resistencia adicional al daño de veneno. Truco: Toque de Muerte. Nivel 3: Risa Horrible de Tasha 1/descanso largo. Nivel 5: Ráfaga de Llamas 1/descanso largo.'),
(50, 'Trance (Elfo/Aasimar)', 'En lugar de dormir, medita profundamente durante 4 horas por descanso largo. Es consciente del entorno mientras medita. Queda tan descansado como tras 8 horas de sueño.'),
(51, 'Sentidos Agudos (Elfo)', 'El elfo tiene competencia en la habilidad Percepción.'),
(52, 'Valiente (Mediano)', 'El mediano tiene ventaja en las tiradas de salvación para no ser asustado.'),
(53, 'Suerte del Mediano', 'Cuando el mediano saca un 1 en una tirada de ataque, prueba de característica o tirada de salvación, puede repetir la tirada y debe usar el nuevo resultado.'),
(54, 'Visión en la Oscuridad 120 pies (Drow/Orco)', 'Puedes ver en luz tenue hasta 36 m como si fuera luz brillante, y en oscuridad como si fuera luz tenue. En oscuridad solo percibes escala de grises.'),
(55, 'Sensibilidad a la Luz Solar (Drow)', 'Tienes desventaja en tiradas de ataque y pruebas de Percepción que dependan de la vista cuando tú o tu objetivo estáis en luz solar directa.'),
(56, 'Legado Drow (Conjuros)', 'Conoces el truco Luz de las Hadas. Al nivel 3 puedes lanzar Oscuridad 1/descanso largo. Al nivel 5 puedes lanzar Contemplar Tinieblas 1/descanso largo. Característica: Carisma.'),
(57, 'Paso por el Bosque (Elfo del Bosque)', 'Puedes moverte por vegetación no mágica difícil sin gastar movimiento extra y sin recibir daño por espinas u otras plantas no mágicas similares.'),
(58, 'Máscara de la Naturaleza (Elfo del Bosque)', 'Puedes intentar ocultarte incluso cuando solo estás ligeramente cubierto por follaje, lluvia intensa, nieve, niebla u otros fenómenos naturales.'),
(59, 'Truco de Mago (Elfo Alto)', 'Conoces un truco adicional del listado de conjuros de mago. La Inteligencia es tu característica de lanzamiento para él.'),
(60, 'Tenacidad Enana (Enano de las Colinas)', 'Tus PG máximos aumentan en 1 y aumentan en 1 adicional cada vez que subes un nivel de personaje.'),
(61, 'Competencia en Armadura (Enano de Montaña)', 'Tienes competencia en armaduras ligeras y medianas.'),
(62, 'Constructor (Gnomo de Rocas)', 'Tienes competencia en herramientas de artesano a elección y ventaja en pruebas de Historia sobre objetos mágicos, alquímicos o mecánicos. Puedes comunicarte de forma rudimentaria con pequeñas bestias mecánicas que construyas.'),
(63, 'Hablar con Animales Pequeños (Gnomo del Bosque)', 'Puedes comunicarte de forma sencilla con bestias de tamaño Pequeño o menor. Pueden darte información de su entorno pero no hablan de ideas abstractas.'),
(64, 'Ilusión Natural (Gnomo del Bosque)', 'Conoces el truco Ilusión menor de forma innata. La Inteligencia es tu característica de lanzamiento para él.'),
(65, 'Resistencia de Fornido (Mediano Fornido)', 'Cuando sufres daño, puedes repetir cualquier dado de daño con resultado 1 y debes usar el nuevo resultado (incluso si vuelve a ser 1).'),
(66, 'Camuflaje Urbano (Mediano Piesligeros)', 'Puedes intentar ocultarte incluso cuando solo estás cubierto por una criatura de tamaño Mediano o mayor.'),
(67, 'Fortaleza Enana', 'Tienes competencia en un tipo de herramientas de artesano a tu elección.'),
(68, 'Combate Enano', 'Tienes competencia con el hacha de mano, el hacha de batalla, el martillo ligero y el martillo de guerra.'),
(69, 'Astucia de Gnomo (Extendida)', 'Tienes ventaja en todas las tiradas de salvación de INT, SAB y CAR contra magia.'),
(101, 'Furia (Bárbaro)', 'En combate, puedes entrar en furia como acción adicional. Mientras estés furioso, ganas ventaja en pruebas y tSalv de FUE, resistencia a daño físico y bonus a daño cuerpo a cuerpo.'),
(102, 'Inspiración Bárdica (Bardo)', 'Puedes inspirar a otros con palabras o música. Otorgas un dado de inspiración (d6 al nivel 1) que puede usarse en pruebas, ataques o salvaciones.'),
(103, 'Canal de Divinidad (Clérigo)', 'Puedes canalizar energía divina directamente de tu deidad. Número de usos y efectos según dominio y nivel.'),
(104, 'Forma Salvaje (Druida)', 'Puedes usar tu acción para transformarte mágicamente en un animal que hayas visto antes. Límites según tu nivel de druida.'),
(105, 'Segundo Viento (Guerrero)', 'Puedes usar una acción adicional para recuperar 1d10 + nivel de guerrero puntos de golpe (1 uso/descanso corto o largo).'),
(106, 'Recuperación Arcana (Mago)', 'Una vez al día, al terminar un descanso corto, puedes recuperar ranuras de conjuro gastadas con un nivel total no mayor a la mitad de tu nivel de mago.'),
(107, 'Defensa sin Armadura (Monje)', 'Mientras no lleves armadura ni escudo, tu CA es igual a 10 + modificador de DES + modificador de SAB.'),
(108, 'Imposición de Manos (Paladín)', 'Tienes una reserva de poder curativo. Puedes gastar puntos de la reserva para restaurar PG (1 punto = 1 PG). Reserva: nivel de paladín × 5.'),
(109, 'Ataque Furtivo (Pícaro)', 'Una vez por turno, puedes infligir 1d6 de daño adicional (por cada 2 niveles de pícaro) a una criatura a la que tengas ventaja o haya aliado adyacente.'),
(110, 'Enemigo Predilecto (Explorador)', 'Has aprendido a cazar ciertos tipos de enemigos. Elige un tipo de favorito: tienes ventaja en tSalv de SAB (Supervivencia) para rastrearlos.'),
(111, 'Origen Sorcérico (Hechicero)', 'Tu magia innata proviene de una fuente especial. El origen determina rasgos que obtienes a nivel 1, 6, 14 y 18.'),
(112, 'Invocaciones Sobrenaturales (Brujo)', 'Ganas una habilidad mágica especial otorgada por tu patrón sobrenatural. Puedes elegir invocaciones adicionales al subir de nivel.'),
(1001, 'Crítico Mejorado (Campeón)', 'Tus ataques con armas obtienen un golpe crítico con 19 o 20 natural en el dado.'),
(1002, 'Maniobras (Maestro de Batalla)', 'Conoces cuatro maniobras de combate y una reserva de dados de superioridad (d8). Ganas más maniobras al subir de nivel.'),
(1003, 'Magia de Combate (Cab. Arcano)', 'Cuando usas tu acción para lanzar un conjuro, puedes realizar un ataque con arma como acción adicional.'),
(2001, 'Esculpir Hechizos (Evocación)', 'Puedes crear zonas de seguridad en tus conjuros de área para proteger aliados automáticamente.'),
(2002, 'Potenciar Hechizo (Evocación)', 'Puedes añadir tu modificador de INT al daño de un conjuro de evocación que normalmente no añade dicho modificador.'),
(2003, 'Abjurador Arcano (Abjuración)', 'Tienes un escudo mágico que absorbe daño (máx. tu nivel de mago + modificador de INT). Se regenera con descanso largo.'),
(2004, 'Proyección Astroversal (Adivinación)', 'Puedes lanzar el conjuro Augurio sin gastar ranuras de conjuro ni componentes. Se recupera con descanso corto.'),
(3001, 'Golpe Divino (Paladín)', 'Cuando impactas con un arma, puedes gastar ranuras de hechizo para añadir daño radiante adicional: 2d8 por nivel de ranura.'),
(3002, 'Esquiva Sobrenatural (Pícaro)', 'Cuando un atacante que puedes ver te impacta, puedes usar tu reacción para reducir el daño a la mitad.'),
(3003, 'Trance Féerica (Elfo del Bosque)', 'En lugar de dormir, meditas profundamente 4 horas por descanso largo. Eres consciente del entorno mientras meditas.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `trait_class`
--

CREATE TABLE `trait_class` (
  `trait_id` int(5) NOT NULL,
  `class_id` int(4) NOT NULL,
  `class_lv` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `trait_class`
--

INSERT INTO `trait_class` (`trait_id`, `class_id`, `class_lv`) VALUES
(101, 1, 1),
(102, 2, 1),
(103, 3, 2),
(104, 4, 2),
(105, 5, 1),
(106, 6, 1),
(107, 7, 1),
(108, 8, 1),
(109, 9, 1),
(110, 10, 1),
(111, 11, 1),
(112, 12, 1),
(1001, 5, 3),
(1002, 5, 3),
(1003, 5, 3),
(2001, 6, 2),
(2002, 6, 6),
(2003, 6, 2),
(2004, 6, 2),
(3001, 8, 7),
(3002, 9, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `trait_race`
--

CREATE TABLE `trait_race` (
  `trait_id` int(5) NOT NULL,
  `race_id` int(4) NOT NULL,
  `race_lv` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `trait_race`
--

INSERT INTO `trait_race` (`trait_id`, `race_id`, `race_lv`) VALUES
(1, 1, 1),
(2, 2, 1),
(2, 7, 1),
(3, 2, 1),
(4, 3, 1),
(5, 4, 1),
(6, 4, 1),
(7, 5, 1),
(8, 6, 1),
(9, 9, 1),
(10, 7, 1),
(11, 8, 1),
(12, 7, 1),
(16, 8, 1),
(20, 10, 1),
(21, 10, 1),
(22, 10, 1),
(30, 5, 1),
(31, 5, 1),
(50, 2, 1),
(50, 7, 1),
(51, 2, 1),
(52, 3, 1),
(53, 3, 1),
(54, 10, 1),
(67, 4, 1),
(68, 4, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `trait_subclass`
--

CREATE TABLE `trait_subclass` (
  `trait_id` int(5) NOT NULL,
  `class_id` int(4) NOT NULL,
  `subclass_id` int(4) NOT NULL,
  `subclass_lv` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `trait_subclass`
--

INSERT INTO `trait_subclass` (`trait_id`, `class_id`, `subclass_id`, `subclass_lv`) VALUES
(1001, 5, 1, 3),
(1002, 5, 2, 3),
(1003, 5, 3, 3),
(2001, 6, 5, 2),
(2002, 6, 5, 6),
(2003, 6, 1, 2),
(2004, 6, 3, 2),
(3001, 8, 1, 7),
(3002, 9, 1, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `trait_subrace`
--

CREATE TABLE `trait_subrace` (
  `trait_id` int(5) NOT NULL,
  `race_id` int(4) NOT NULL,
  `subrace_id` int(4) NOT NULL,
  `subrace_lv` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `trait_subrace`
--

INSERT INTO `trait_subrace` (`trait_id`, `race_id`, `subrace_id`, `subrace_lv`) VALUES
(2, 2, 1, 1),
(2, 2, 2, 1),
(2, 2, 3, 1),
(3, 2, 1, 1),
(3, 2, 2, 1),
(3, 2, 3, 1),
(4, 3, 1, 1),
(4, 3, 2, 1),
(5, 4, 1, 1),
(5, 4, 2, 1),
(6, 4, 1, 1),
(7, 5, 1, 1),
(7, 5, 2, 1),
(7, 5, 3, 1),
(7, 5, 4, 1),
(7, 5, 5, 1),
(7, 5, 6, 1),
(7, 5, 7, 1),
(7, 5, 8, 1),
(7, 5, 9, 1),
(7, 5, 10, 1),
(8, 6, 1, 1),
(8, 6, 2, 1),
(9, 9, 1, 1),
(9, 9, 2, 1),
(9, 9, 3, 1),
(9, 9, 4, 1),
(9, 9, 5, 1),
(9, 9, 6, 1),
(9, 9, 7, 1),
(9, 9, 8, 1),
(9, 9, 9, 1),
(9, 9, 10, 1),
(10, 7, 1, 1),
(10, 7, 2, 1),
(10, 7, 3, 1),
(11, 8, 1, 1),
(11, 8, 2, 1),
(11, 8, 3, 1),
(12, 7, 1, 1),
(12, 7, 2, 1),
(12, 7, 3, 1),
(13, 7, 1, 3),
(14, 7, 2, 3),
(15, 7, 3, 3),
(16, 8, 1, 1),
(16, 8, 2, 1),
(16, 8, 3, 1),
(17, 8, 1, 1),
(18, 8, 2, 1),
(19, 8, 3, 1),
(30, 5, 1, 1),
(30, 5, 2, 1),
(30, 5, 3, 1),
(30, 5, 4, 1),
(30, 5, 5, 1),
(30, 5, 6, 1),
(30, 5, 7, 1),
(30, 5, 8, 1),
(30, 5, 9, 1),
(30, 5, 10, 1),
(31, 5, 1, 1),
(31, 5, 2, 1),
(31, 5, 3, 1),
(31, 5, 4, 1),
(31, 5, 5, 1),
(31, 5, 6, 1),
(31, 5, 7, 1),
(31, 5, 8, 1),
(31, 5, 9, 1),
(31, 5, 10, 1),
(40, 9, 1, 1),
(41, 9, 2, 1),
(42, 9, 3, 1),
(43, 9, 4, 1),
(44, 9, 5, 1),
(45, 9, 6, 1),
(46, 9, 7, 1),
(47, 9, 8, 1),
(48, 9, 9, 1),
(49, 9, 10, 1),
(50, 2, 1, 1),
(50, 2, 2, 1),
(50, 2, 3, 1),
(51, 2, 1, 1),
(51, 2, 2, 1),
(51, 2, 3, 1),
(52, 3, 1, 1),
(52, 3, 2, 1),
(53, 3, 1, 1),
(53, 3, 2, 1),
(54, 2, 3, 1),
(55, 2, 3, 1),
(56, 2, 3, 1),
(57, 2, 1, 1),
(58, 2, 1, 1),
(59, 2, 2, 1),
(60, 4, 1, 1),
(61, 4, 2, 1),
(62, 6, 1, 1),
(63, 6, 2, 1),
(64, 6, 2, 1),
(65, 3, 1, 1),
(66, 3, 2, 1),
(67, 4, 1, 1),
(67, 4, 2, 1),
(68, 4, 1, 1),
(68, 4, 2, 1),
(3003, 2, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `user_nick` varchar(30) NOT NULL,
  `user_name` varchar(30) NOT NULL,
  `user_mail` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`user_nick`, `user_name`, `user_mail`) VALUES
('admin', 'Administrador del Sistema', 'admin@dndcampaign.com'),
('dm_carlos', 'Carlos, el Dungeon Master', 'carlos@dndcampaign.com'),
('jugador_ana', 'Ana, la Guerrero', 'ana@dndcampaign.com'),
('jugador_luis', 'Luis, el Mago', 'luis@dndcampaign.com'),
('jugador_sofia', 'Sofía, la Clériga', 'sofia@dndcampaign.com'),
('pako', 'Pako', 'administracion@geograma.com');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users_groups`
--

CREATE TABLE `users_groups` (
  `user_nick` varchar(30) NOT NULL,
  `group_id` int(11) NOT NULL,
  `rol_id` char(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `users_groups`
--

INSERT INTO `users_groups` (`user_nick`, `group_id`, `rol_id`) VALUES
('admin', 3, 'A'),
('admin', 4, 'J'),
('jugador_ana', 1, 'J'),
('jugador_luis', 1, 'J'),
('jugador_sofia', 1, 'J'),
('dm_carlos', 1, 'M'),
('dm_carlos', 2, 'M'),
('pako', 4, 'M');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `ability`
--
ALTER TABLE `ability`
  ADD PRIMARY KEY (`ability_id`);

--
-- Indices de la tabla `armor_type`
--
ALTER TABLE `armor_type`
  ADD PRIMARY KEY (`armor_type_id`);

--
-- Indices de la tabla `background`
--
ALTER TABLE `background`
  ADD PRIMARY KEY (`background_id`),
  ADD KEY `bundle_id` (`bundle_id`);

--
-- Indices de la tabla `background_ability`
--
ALTER TABLE `background_ability`
  ADD PRIMARY KEY (`background_id`,`ability_id`),
  ADD KEY `ability_id` (`ability_id`);

--
-- Indices de la tabla `background_feat`
--
ALTER TABLE `background_feat`
  ADD KEY `background_id` (`background_id`),
  ADD KEY `feat_id` (`feat_id`);

--
-- Indices de la tabla `background_prof`
--
ALTER TABLE `background_prof`
  ADD PRIMARY KEY (`background_id`,`prof_id`),
  ADD KEY `prof_id` (`prof_id`);

--
-- Indices de la tabla `background_skill`
--
ALTER TABLE `background_skill`
  ADD PRIMARY KEY (`background_id`,`skill_id`),
  ADD KEY `skill_id` (`skill_id`);

--
-- Indices de la tabla `bundle`
--
ALTER TABLE `bundle`
  ADD PRIMARY KEY (`bundle_id`),
  ADD UNIQUE KEY `bundle_name` (`bundle_name`);

--
-- Indices de la tabla `bundle_item`
--
ALTER TABLE `bundle_item`
  ADD PRIMARY KEY (`bundle_id`,`item_id`),
  ADD KEY `item_id` (`item_id`);

--
-- Indices de la tabla `character`
--
ALTER TABLE `character`
  ADD PRIMARY KEY (`character_id`),
  ADD UNIQUE KEY `unique_character` (`user_nick`,`character_name`),
  ADD KEY `race_id` (`race_id`),
  ADD KEY `class_id` (`class_id`);

--
-- Indices de la tabla `character_feat`
--
ALTER TABLE `character_feat`
  ADD PRIMARY KEY (`character_id`,`feat_id`),
  ADD KEY `feat_id` (`feat_id`);

--
-- Indices de la tabla `character_inventory`
--
ALTER TABLE `character_inventory`
  ADD PRIMARY KEY (`character_id`,`item_id`),
  ADD KEY `item_id` (`item_id`);

--
-- Indices de la tabla `character_proficiency`
--
ALTER TABLE `character_proficiency`
  ADD PRIMARY KEY (`character_id`,`prof_id`),
  ADD KEY `prof_id` (`prof_id`);

--
-- Indices de la tabla `character_skill_proficiency`
--
ALTER TABLE `character_skill_proficiency`
  ADD PRIMARY KEY (`character_id`,`skill_id`),
  ADD KEY `skill_id` (`skill_id`);

--
-- Indices de la tabla `character_spell`
--
ALTER TABLE `character_spell`
  ADD PRIMARY KEY (`character_id`,`spell_id`),
  ADD KEY `character_spell_fk_2` (`spell_id`);

--
-- Indices de la tabla `class`
--
ALTER TABLE `class`
  ADD PRIMARY KEY (`class_id`),
  ADD KEY `safe1_ability_id` (`safe1_ability_id`) USING BTREE,
  ADD KEY `safe2_ability_id` (`safe2_ability_id`) USING BTREE,
  ADD KEY `spellcasting_ability` (`spellcasting_ability`) USING BTREE;

--
-- Indices de la tabla `class_level_progression`
--
ALTER TABLE `class_level_progression`
  ADD PRIMARY KEY (`class_id`,`level`),
  ADD KEY `class_id` (`class_id`);

--
-- Indices de la tabla `damage`
--
ALTER TABLE `damage`
  ADD PRIMARY KEY (`damage_id`);

--
-- Indices de la tabla `feat`
--
ALTER TABLE `feat`
  ADD PRIMARY KEY (`feat_id`);

--
-- Indices de la tabla `feat_ability`
--
ALTER TABLE `feat_ability`
  ADD PRIMARY KEY (`feat_id`,`ability_id`),
  ADD KEY `ability_id` (`ability_id`);

--
-- Indices de la tabla `feat_prerequisite`
--
ALTER TABLE `feat_prerequisite`
  ADD KEY `feat_id` (`feat_id`);

--
-- Indices de la tabla `groups`
--
ALTER TABLE `groups`
  ADD PRIMARY KEY (`group_id`);

--
-- Indices de la tabla `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`item_id`);

--
-- Indices de la tabla `item_armor`
--
ALTER TABLE `item_armor`
  ADD KEY `item_id` (`item_id`),
  ADD KEY `armor_type_id` (`armor_type_id`);

--
-- Indices de la tabla `item_wand`
--
ALTER TABLE `item_wand`
  ADD KEY `item_id` (`item_id`);

--
-- Indices de la tabla `item_weapon`
--
ALTER TABLE `item_weapon`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `mastery_id` (`mastery_id`),
  ADD KEY `damage_id` (`damage_id`),
  ADD KEY `skill_id` (`skill_id`);

--
-- Indices de la tabla `mastery`
--
ALTER TABLE `mastery`
  ADD PRIMARY KEY (`mastery_id`);

--
-- Indices de la tabla `pass`
--
ALTER TABLE `pass`
  ADD PRIMARY KEY (`user_nick`);

--
-- Indices de la tabla `prof`
--
ALTER TABLE `prof`
  ADD PRIMARY KEY (`prof_id`);

--
-- Indices de la tabla `prof_class`
--
ALTER TABLE `prof_class`
  ADD PRIMARY KEY (`prof_id`,`class_id`),
  ADD KEY `race_id` (`class_id`),
  ADD KEY `class_lv` (`class_lv`);

--
-- Indices de la tabla `prof_race`
--
ALTER TABLE `prof_race`
  ADD PRIMARY KEY (`prof_id`,`race_id`),
  ADD KEY `race_id` (`race_id`);

--
-- Indices de la tabla `prof_subclass`
--
ALTER TABLE `prof_subclass`
  ADD PRIMARY KEY (`prof_id`,`class_id`,`subclass_id`),
  ADD KEY `class_id` (`class_id`,`subclass_id`);

--
-- Indices de la tabla `prof_subrace`
--
ALTER TABLE `prof_subrace`
  ADD KEY `prof_id` (`prof_id`),
  ADD KEY `race_id` (`race_id`,`subrace_id`);

--
-- Indices de la tabla `race`
--
ALTER TABLE `race`
  ADD PRIMARY KEY (`race_id`),
  ADD KEY `size_id` (`size_id`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`rol_id`);

--
-- Indices de la tabla `size`
--
ALTER TABLE `size`
  ADD PRIMARY KEY (`size_id`);

--
-- Indices de la tabla `skill`
--
ALTER TABLE `skill`
  ADD PRIMARY KEY (`skill_id`),
  ADD KEY `ability_id` (`ability_id`);

--
-- Indices de la tabla `spell`
--
ALTER TABLE `spell`
  ADD PRIMARY KEY (`spell_id`),
  ADD KEY `spell_level_id` (`spell_level`),
  ADD KEY `spell_school_id` (`spell_school_id`);

--
-- Indices de la tabla `spell_attack`
--
ALTER TABLE `spell_attack`
  ADD PRIMARY KEY (`spell_id`);

--
-- Indices de la tabla `spell_class`
--
ALTER TABLE `spell_class`
  ADD PRIMARY KEY (`spell_id`,`class_id`),
  ADD KEY `spell_class_ibfk_2` (`class_id`);

--
-- Indices de la tabla `spell_component`
--
ALTER TABLE `spell_component`
  ADD PRIMARY KEY (`component_id`),
  ADD UNIQUE KEY `component_short` (`component_short`);

--
-- Indices de la tabla `spell_damage`
--
ALTER TABLE `spell_damage`
  ADD PRIMARY KEY (`spell_id`,`damage_id`),
  ADD KEY `spell_damage_ibfk_2` (`damage_id`);

--
-- Indices de la tabla `spell_save`
--
ALTER TABLE `spell_save`
  ADD PRIMARY KEY (`spell_id`),
  ADD KEY `spell_save_ibfk_2` (`skill_id`);

--
-- Indices de la tabla `spell_school`
--
ALTER TABLE `spell_school`
  ADD PRIMARY KEY (`spell_school_id`),
  ADD UNIQUE KEY `spell_school_name` (`spell_school_name`);

--
-- Indices de la tabla `spell_spell_component`
--
ALTER TABLE `spell_spell_component`
  ADD PRIMARY KEY (`spell_id`,`component_id`),
  ADD KEY `spell_spell_component_ibfk_2` (`component_id`);

--
-- Indices de la tabla `subclass`
--
ALTER TABLE `subclass`
  ADD PRIMARY KEY (`class_id`,`subclass_id`);

--
-- Indices de la tabla `subrace`
--
ALTER TABLE `subrace`
  ADD PRIMARY KEY (`race_id`,`subrace_id`);

--
-- Indices de la tabla `trait`
--
ALTER TABLE `trait`
  ADD PRIMARY KEY (`trait_id`);

--
-- Indices de la tabla `trait_class`
--
ALTER TABLE `trait_class`
  ADD PRIMARY KEY (`trait_id`,`class_id`),
  ADD KEY `class_id` (`class_id`);

--
-- Indices de la tabla `trait_race`
--
ALTER TABLE `trait_race`
  ADD PRIMARY KEY (`trait_id`,`race_id`),
  ADD KEY `race_id` (`race_id`);

--
-- Indices de la tabla `trait_subclass`
--
ALTER TABLE `trait_subclass`
  ADD KEY `trait_id` (`trait_id`),
  ADD KEY `class_id` (`class_id`,`subclass_id`);

--
-- Indices de la tabla `trait_subrace`
--
ALTER TABLE `trait_subrace`
  ADD PRIMARY KEY (`trait_id`,`race_id`,`subrace_id`),
  ADD KEY `race_id` (`race_id`,`subrace_id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_nick`);

--
-- Indices de la tabla `users_groups`
--
ALTER TABLE `users_groups`
  ADD PRIMARY KEY (`user_nick`,`group_id`),
  ADD KEY `group_id` (`group_id`),
  ADD KEY `rol_id` (`rol_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `character`
--
ALTER TABLE `character`
  MODIFY `character_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `groups`
--
ALTER TABLE `groups`
  MODIFY `group_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `item`
--
ALTER TABLE `item`
  MODIFY `item_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=743;

--
-- AUTO_INCREMENT de la tabla `mastery`
--
ALTER TABLE `mastery`
  MODIFY `mastery_id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `prof`
--
ALTER TABLE `prof`
  MODIFY `prof_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=191;

--
-- AUTO_INCREMENT de la tabla `spell`
--
ALTER TABLE `spell`
  MODIFY `spell_id` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=904;

--
-- AUTO_INCREMENT de la tabla `spell_school`
--
ALTER TABLE `spell_school`
  MODIFY `spell_school_id` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `background`
--
ALTER TABLE `background`
  ADD CONSTRAINT `background_ibfk_1` FOREIGN KEY (`bundle_id`) REFERENCES `bundle` (`bundle_id`);

--
-- Filtros para la tabla `background_ability`
--
ALTER TABLE `background_ability`
  ADD CONSTRAINT `background_ability_ibfk_1` FOREIGN KEY (`background_id`) REFERENCES `background` (`background_id`),
  ADD CONSTRAINT `background_ability_ibfk_2` FOREIGN KEY (`ability_id`) REFERENCES `ability` (`ability_id`);

--
-- Filtros para la tabla `background_feat`
--
ALTER TABLE `background_feat`
  ADD CONSTRAINT `background_feat_ibfk_1` FOREIGN KEY (`background_id`) REFERENCES `background` (`background_id`),
  ADD CONSTRAINT `background_feat_ibfk_2` FOREIGN KEY (`feat_id`) REFERENCES `feat` (`feat_id`);

--
-- Filtros para la tabla `background_prof`
--
ALTER TABLE `background_prof`
  ADD CONSTRAINT `background_prof_ibfk_1` FOREIGN KEY (`background_id`) REFERENCES `background` (`background_id`),
  ADD CONSTRAINT `background_prof_ibfk_2` FOREIGN KEY (`prof_id`) REFERENCES `prof` (`prof_id`);

--
-- Filtros para la tabla `background_skill`
--
ALTER TABLE `background_skill`
  ADD CONSTRAINT `background_skill_ibfk_1` FOREIGN KEY (`background_id`) REFERENCES `background` (`background_id`),
  ADD CONSTRAINT `background_skill_ibfk_2` FOREIGN KEY (`skill_id`) REFERENCES `skill` (`skill_id`);

--
-- Filtros para la tabla `bundle_item`
--
ALTER TABLE `bundle_item`
  ADD CONSTRAINT `bundle_item_ibfk_1` FOREIGN KEY (`bundle_id`) REFERENCES `bundle` (`bundle_id`),
  ADD CONSTRAINT `bundle_item_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `item` (`item_id`);

--
-- Filtros para la tabla `character`
--
ALTER TABLE `character`
  ADD CONSTRAINT `character_ibfk_1` FOREIGN KEY (`user_nick`) REFERENCES `users` (`user_nick`),
  ADD CONSTRAINT `character_ibfk_2` FOREIGN KEY (`race_id`) REFERENCES `race` (`race_id`),
  ADD CONSTRAINT `character_ibfk_3` FOREIGN KEY (`class_id`) REFERENCES `class` (`class_id`);

--
-- Filtros para la tabla `character_feat`
--
ALTER TABLE `character_feat`
  ADD CONSTRAINT `character_feat_ibfk_1` FOREIGN KEY (`character_id`) REFERENCES `character` (`character_id`),
  ADD CONSTRAINT `character_feat_ibfk_2` FOREIGN KEY (`feat_id`) REFERENCES `feat` (`feat_id`);

--
-- Filtros para la tabla `character_inventory`
--
ALTER TABLE `character_inventory`
  ADD CONSTRAINT `character_inventory_ibfk_1` FOREIGN KEY (`character_id`) REFERENCES `character` (`character_id`),
  ADD CONSTRAINT `character_inventory_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `item` (`item_id`);

--
-- Filtros para la tabla `character_proficiency`
--
ALTER TABLE `character_proficiency`
  ADD CONSTRAINT `character_proficiency_ibfk_1` FOREIGN KEY (`character_id`) REFERENCES `character` (`character_id`),
  ADD CONSTRAINT `character_proficiency_ibfk_2` FOREIGN KEY (`prof_id`) REFERENCES `prof` (`prof_id`);

--
-- Filtros para la tabla `character_skill_proficiency`
--
ALTER TABLE `character_skill_proficiency`
  ADD CONSTRAINT `character_skill_proficiency_ibfk_1` FOREIGN KEY (`character_id`) REFERENCES `character` (`character_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `character_skill_proficiency_ibfk_2` FOREIGN KEY (`skill_id`) REFERENCES `skill` (`skill_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `character_spell`
--
ALTER TABLE `character_spell`
  ADD CONSTRAINT `character_spell_fk_1` FOREIGN KEY (`character_id`) REFERENCES `character` (`character_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `character_spell_fk_2` FOREIGN KEY (`spell_id`) REFERENCES `spell` (`spell_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `class`
--
ALTER TABLE `class`
  ADD CONSTRAINT `class_ibfk_1` FOREIGN KEY (`safe1_ability_id`) REFERENCES `ability` (`ability_id`),
  ADD CONSTRAINT `class_ibfk_2` FOREIGN KEY (`safe2_ability_id`) REFERENCES `ability` (`ability_id`),
  ADD CONSTRAINT `class_ibfk_3` FOREIGN KEY (`spellcasting_ability`) REFERENCES `ability` (`ability_id`);

--
-- Filtros para la tabla `class_level_progression`
--
ALTER TABLE `class_level_progression`
  ADD CONSTRAINT `class_level_progression_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `class` (`class_id`);

--
-- Filtros para la tabla `feat_ability`
--
ALTER TABLE `feat_ability`
  ADD CONSTRAINT `feat_ability_ibfk_1` FOREIGN KEY (`feat_id`) REFERENCES `feat` (`feat_id`),
  ADD CONSTRAINT `feat_ability_ibfk_2` FOREIGN KEY (`ability_id`) REFERENCES `ability` (`ability_id`);

--
-- Filtros para la tabla `feat_prerequisite`
--
ALTER TABLE `feat_prerequisite`
  ADD CONSTRAINT `feat_prerequisite_ibfk_1` FOREIGN KEY (`feat_id`) REFERENCES `feat` (`feat_id`);

--
-- Filtros para la tabla `item_armor`
--
ALTER TABLE `item_armor`
  ADD CONSTRAINT `item_armor_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `item` (`item_id`),
  ADD CONSTRAINT `item_armor_ibfk_2` FOREIGN KEY (`armor_type_id`) REFERENCES `armor_type` (`armor_type_id`);

--
-- Filtros para la tabla `item_wand`
--
ALTER TABLE `item_wand`
  ADD CONSTRAINT `item_wand_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `item` (`item_id`);

--
-- Filtros para la tabla `item_weapon`
--
ALTER TABLE `item_weapon`
  ADD CONSTRAINT `item_weapon_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `item` (`item_id`),
  ADD CONSTRAINT `item_weapon_ibfk_2` FOREIGN KEY (`mastery_id`) REFERENCES `mastery` (`mastery_id`),
  ADD CONSTRAINT `item_weapon_ibfk_3` FOREIGN KEY (`damage_id`) REFERENCES `damage` (`damage_id`),
  ADD CONSTRAINT `item_weapon_ibfk_4` FOREIGN KEY (`skill_id`) REFERENCES `skill` (`skill_id`);

--
-- Filtros para la tabla `pass`
--
ALTER TABLE `pass`
  ADD CONSTRAINT `pass_ibfk_1` FOREIGN KEY (`user_nick`) REFERENCES `users` (`user_nick`);

--
-- Filtros para la tabla `prof_class`
--
ALTER TABLE `prof_class`
  ADD CONSTRAINT `prof_class_ibfk_1` FOREIGN KEY (`prof_id`) REFERENCES `prof` (`prof_id`),
  ADD CONSTRAINT `prof_class_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `class` (`class_id`);

--
-- Filtros para la tabla `prof_race`
--
ALTER TABLE `prof_race`
  ADD CONSTRAINT `prof_race_ibfk_1` FOREIGN KEY (`prof_id`) REFERENCES `prof` (`prof_id`),
  ADD CONSTRAINT `prof_race_ibfk_2` FOREIGN KEY (`race_id`) REFERENCES `race` (`race_id`);

--
-- Filtros para la tabla `prof_subclass`
--
ALTER TABLE `prof_subclass`
  ADD CONSTRAINT `prof_subclass_ibfk_1` FOREIGN KEY (`prof_id`) REFERENCES `prof` (`prof_id`),
  ADD CONSTRAINT `prof_subclass_ibfk_3` FOREIGN KEY (`class_id`,`subclass_id`) REFERENCES `subclass` (`class_id`, `subclass_id`);

--
-- Filtros para la tabla `prof_subrace`
--
ALTER TABLE `prof_subrace`
  ADD CONSTRAINT `prof_subrace_ibfk_1` FOREIGN KEY (`prof_id`) REFERENCES `prof` (`prof_id`),
  ADD CONSTRAINT `prof_subrace_ibfk_3` FOREIGN KEY (`race_id`,`subrace_id`) REFERENCES `subrace` (`race_id`, `subrace_id`);

--
-- Filtros para la tabla `race`
--
ALTER TABLE `race`
  ADD CONSTRAINT `race_ibfk_1` FOREIGN KEY (`size_id`) REFERENCES `size` (`size_id`);

--
-- Filtros para la tabla `skill`
--
ALTER TABLE `skill`
  ADD CONSTRAINT `skill_abfk_1` FOREIGN KEY (`ability_id`) REFERENCES `ability` (`ability_id`);

--
-- Filtros para la tabla `spell`
--
ALTER TABLE `spell`
  ADD CONSTRAINT `spell_ibfk_2` FOREIGN KEY (`spell_school_id`) REFERENCES `spell_school` (`spell_school_id`);

--
-- Filtros para la tabla `spell_attack`
--
ALTER TABLE `spell_attack`
  ADD CONSTRAINT `spell_attack_ibfk_1` FOREIGN KEY (`spell_id`) REFERENCES `spell` (`spell_id`);

--
-- Filtros para la tabla `spell_class`
--
ALTER TABLE `spell_class`
  ADD CONSTRAINT `spell_class_ibfk_1` FOREIGN KEY (`spell_id`) REFERENCES `spell` (`spell_id`),
  ADD CONSTRAINT `spell_class_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `class` (`class_id`);

--
-- Filtros para la tabla `spell_damage`
--
ALTER TABLE `spell_damage`
  ADD CONSTRAINT `spell_damage_ibfk_1` FOREIGN KEY (`spell_id`) REFERENCES `spell` (`spell_id`),
  ADD CONSTRAINT `spell_damage_ibfk_2` FOREIGN KEY (`damage_id`) REFERENCES `damage` (`damage_id`);

--
-- Filtros para la tabla `spell_save`
--
ALTER TABLE `spell_save`
  ADD CONSTRAINT `spell_save_ibfk_1` FOREIGN KEY (`spell_id`) REFERENCES `spell` (`spell_id`),
  ADD CONSTRAINT `spell_save_ibfk_2` FOREIGN KEY (`skill_id`) REFERENCES `skill` (`skill_id`);

--
-- Filtros para la tabla `spell_spell_component`
--
ALTER TABLE `spell_spell_component`
  ADD CONSTRAINT `spell_spell_component_ibfk_1` FOREIGN KEY (`spell_id`) REFERENCES `spell` (`spell_id`),
  ADD CONSTRAINT `spell_spell_component_ibfk_2` FOREIGN KEY (`component_id`) REFERENCES `spell_component` (`component_id`);

--
-- Filtros para la tabla `subclass`
--
ALTER TABLE `subclass`
  ADD CONSTRAINT `subclass_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `class` (`class_id`);

--
-- Filtros para la tabla `subrace`
--
ALTER TABLE `subrace`
  ADD CONSTRAINT `subrace_ibfk_1` FOREIGN KEY (`race_id`) REFERENCES `race` (`race_id`);

--
-- Filtros para la tabla `trait_race`
--
ALTER TABLE `trait_race`
  ADD CONSTRAINT `trait_race_ibfk_1` FOREIGN KEY (`trait_id`) REFERENCES `trait` (`trait_id`),
  ADD CONSTRAINT `trait_race_ibfk_2` FOREIGN KEY (`race_id`) REFERENCES `race` (`race_id`);

--
-- Filtros para la tabla `trait_subclass`
--
ALTER TABLE `trait_subclass`
  ADD CONSTRAINT `trait_subclass_ibfk_1` FOREIGN KEY (`trait_id`) REFERENCES `trait` (`trait_id`),
  ADD CONSTRAINT `trait_subclass_ibfk_2` FOREIGN KEY (`class_id`,`subclass_id`) REFERENCES `subclass` (`class_id`, `subclass_id`);

--
-- Filtros para la tabla `trait_subrace`
--
ALTER TABLE `trait_subrace`
  ADD CONSTRAINT `trait_subrace_ibfk_1` FOREIGN KEY (`trait_id`) REFERENCES `trait` (`trait_id`),
  ADD CONSTRAINT `trait_subrace_ibfk_2` FOREIGN KEY (`race_id`,`subrace_id`) REFERENCES `subrace` (`race_id`, `subrace_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
