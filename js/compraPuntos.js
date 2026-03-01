///////////////////////////////////////////////////////////////////////////
//variables necesarias
///////////////////////////////////////////////////////////////////////////
let restantes = 27;
let tdCompraPuntos = document.getElementById("tdCompraPuntos");
let txtRestantes = document.getElementById("txtRestantes");

let selectFuerza = document.getElementById("selectFuerza");
let txtFuerzaTotal = document.getElementById("txtFuerzaTotal");
let txtFuerzaModificador = document.getElementById("txtFuerzaModificador")

let selectDesteza = document.getElementById("selectDesteza");
let txtDestezaTotal = document.getElementById("txtDestezaTotal");
let txtDestezaModificador = document.getElementById("txtDestezaModificador")

let selectConstitucion = document.getElementById("selectConstitucion");
let txtConstitucionTotal = document.getElementById("txtConstitucionTotal");
let txtConstitucionModificador = document.getElementById("txtConstitucionModificador")

let selectInteligencia = document.getElementById("selectInteligencia");
let txtInteligenciaTotal = document.getElementById("txtInteligenciaTotal");
let txtInteligenciaModificador = document.getElementById("txtInteligenciaModificador")

let selectSabiduria = document.getElementById("selectSabiduria");
let txtSabiduriaTotal = document.getElementById("txtSabiduriaTotal");
let txtSabiduriaModificador = document.getElementById("txtSabiduriaModificador")

let selectCarisma = document.getElementById("selectCarisma");
let txtCarismaTotal = document.getElementById("txtCarismaTotal");
let txtCarismaModificador = document.getElementById("txtCarismaModificador")

//los selects agrupados
let selects = [
    selectFuerza,
    selectDesteza,
    selectConstitucion,
    selectInteligencia,
    selectSabiduria,
    selectCarisma
];
//los totales agrupados
let totales = [
    txtFuerzaTotal,
    txtDestezaTotal,
    txtConstitucionTotal,
    txtInteligenciaTotal,
    txtSabiduriaTotal,
    txtCarismaTotal
];
//los modificadores agrupados
let modificadores = [
    txtFuerzaModificador,
    txtDestezaModificador,
    txtConstitucionModificador,
    txtInteligenciaModificador,
    txtSabiduriaModificador,
    txtCarismaModificador
];
//los costes de puntos
    const costes = {
        8: 0,
        9: 1,
        10: 2,
        11: 3,
        12: 4,
        13: 5,
        14: 7,
        15: 9
    };
///////////////////////////////////////////////////////////////////////////
//funciones
///////////////////////////////////////////////////////////////////////////
//funcion para cargar los selects y los textos con los valores por defecto
function cargarPuntuaciones() {
    selects.forEach(select => {
        select.innerHTML = "";
        for (let i = 8; i <= 15; i++) {
            let option = document.createElement("option");
            option.value = i;
            option.textContent = i;
            select.appendChild(option);
        }
        select.value = 8;

        // Pasamos el evento automáticamente
        select.addEventListener("change", fijarValorTotal);
    });
}

//funcion para poner el valor del campo de total y su modificador
function fijarValorTotal(event) {
    let selectCambiado = event.target;
    let index = selects.indexOf(selectCambiado);
    totales[index].textContent = selectCambiado.value;
    modificadores[index].textContent =
        Math.floor((selectCambiado.value - 10) / 2);
    calcularRestantes();
}

//funcion para calcular los puntos restantes
function calcularRestantes() {
    let totalGastado = 0;
    selects.forEach(select => {
        let valor = parseInt(select.value);
        totalGastado += costes[valor];
    });

    restantes = 27 - totalGastado;
    txtRestantes.textContent = restantes + "/27";
    actualizarOpcionesDisponibles();
}

function actualizarOpcionesDisponibles() {
    selects.forEach(select => {
        let valorActual = parseInt(select.value);
        let costeActual = obtenerCoste(valorActual);
        select.querySelectorAll("option").forEach(option => {
            let valorOpcion = parseInt(option.value);
            let costeOpcion = obtenerCoste(valorOpcion);
            let diferencia = costeOpcion - costeActual;
            if (diferencia > restantes) {
                option.disabled = true;
            } else {
                option.disabled = false;
            }
        });
    });

}

function obtenerCoste(valor) {
    return costes[valor];
}

///////////////////////////////////////////////////////////////////////////
//codigo a ejecutar
///////////////////////////////////////////////////////////////////////////
cargarPuntuaciones();