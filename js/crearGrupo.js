function abrirPrompt() {
    document.getElementById("modal").style.display = "block";
}

function crearGrupo() {
    const nombreGrupo = document.getElementById("nombre").value;
    console.log(nombreGrupo);
    location.href="./grupos.php?nombreGrupo="+nombreGrupo;
    document.getElementById("modal").style.display = "none";
}

document.getElementById("btnNuevoGrupo").addEventListener("click", abrirPrompt);
document.getElementById("btnCrearGrupo").addEventListener("click",crearGrupo)
