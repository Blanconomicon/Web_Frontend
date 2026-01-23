function abrirPrompt() {
    document.getElementById("modal").style.display = "block";
}

function crearGrupo() {
    document.getElementById("modal").style.display = "none";
}

document.getElementById("btnNuevoGrupo").addEventListener("click", abrirPrompt);
document.getElementById("btnCrearGrupo").addEventListener("click",crearGrupo)
