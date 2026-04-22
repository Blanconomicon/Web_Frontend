document.addEventListener("DOMContentLoaded", () => {
    //Crear nuevo grupo
    const btnNuevoGrupo = document.getElementById("btnNuevoGrupo");
    const dialogCrear = document.getElementById("dialogCrear");
    const btnCancelar = document.getElementById("btnCancelar");
    //Aniadir persona al grupo
    const btnAniadir = document.getElementById("btnAniadir");
    const dialigAniadir = document.getElementById("dialogAniadir");
    const btnCancelarAniadir = document.getElementById("btnCancelarAnaidir");

    //Aniadir eventos
    btnNuevoGrupo.addEventListener("click", () => {
        dialogCrear.showModal();
    });

    btnCancelar.addEventListener("click", () => {
        dialogCrear.close();
    })

    btnAniadir.addEventListener("click", () => {
        dialigAniadir.showModal();
    })

    btnCancelarAniadir.addEventListener("click", () => {
        dialigAniadir.close();
    })

});
