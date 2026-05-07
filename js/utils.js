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

//funcion para dar el evento al formulario
function cargarPericias(formId, divId) {
    let formulario = document.getElementById(formId);
    formulario.addEventListener("change", () => {
        mostrarPericias(formulario, divId);
    });
}

//funcion para mostrar las pericias disponibles
function mostrarPericias(formulario, divId) {
    let div = document.getElementById(divId);
    let checkboxes = formulario.querySelectorAll(
        'input[type="checkbox"]'
    );
    let txtMostrar = "";
    checkboxes.forEach(checkbox => {
        if (checkbox.checked) {
            txtMostrar += `
                <input 
                    type="checkbox"
                    name="pericias[]"
                    value="${checkbox.value-100}"
                >
                ${checkbox.id}
                <br>
            `;
        }
    });
    div.innerHTML = txtMostrar;
}