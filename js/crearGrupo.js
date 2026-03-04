document.addEventListener("DOMContentLoaded", () => {
    const btnNuevoGrupo = document.getElementById("btnNuevoGrupo");
    const dialog = document.getElementById("dialog");
    const btnCancelar = document.getElementById("btnCancelar")

    btnNuevoGrupo.addEventListener("click", () => {
        dialog.showModal();
    });

    btnCancelar.addEventListener("click", () => {
        dialog.close();
    })

});
