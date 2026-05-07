//funcion para cargar una zona de la pagina por el valor que tenga un select
function cargarDesdeSelect(selectId, resultadoId, archivoPhp, parametro) {
    const select = document.getElementById(selectId);

    function cargar() {
        let valor = -1;
        if (select) {
            valor = select.value;
        }

        fetch(`${archivoPhp}?${parametro}=${encodeURIComponent(valor)}`)
            .then(response => response.text())
            .then(data => {
                document.getElementById(resultadoId).innerHTML = data;
            })
            .catch(error => console.error("Error:", error));
    }

    // Se ejecuta al cambiar
    if (select) {
        select.addEventListener("change", cargar);
    }

    // 🔹 Se ejecuta al cargar la página
    cargar();
}