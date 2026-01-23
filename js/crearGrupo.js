document.addEventListener("DOMContentLoaded", () => {
    const btnNuevoGrupo = document.getElementById("btnNuevoGrupo");

    btnNuevoGrupo.addEventListener("click", () => {
        const ventana = window.open(
            "crearGrupo.php",
            "crearGrupo",
            "width=400,height=250,resizable=no"
        );

        // Bloquea la página hasta que se cierre la ventana
        const bloqueo = setInterval(() => {
            if (ventana.closed) {
                clearInterval(bloqueo);
                location.reload(); // recarga para ver el nuevo grupo
            }
        }, 500);
    });
});
