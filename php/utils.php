<?php
session_start();

//LOGOUT
if(isset($_GET['logout'])){
    session_destroy();
    header("Location: ./login.php");
}

?>