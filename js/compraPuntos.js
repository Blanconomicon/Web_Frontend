///////////////////////////////////////////////////////////////////////////
//variables necesarias
///////////////////////////////////////////////////////////////////////////
let restantes = 27;
let txtRestantes = document.getElementById("txtRestantes");

let selectFuerza = document.getElementById("selectFuerza");
let txtFuerzaTotal = document.getElementById("txtFuerzaTotal");
let txtFuerzaModificador = document.getElementById("txtFuerzaModificador")

let selectDesteza = document.getElementById("selectDestreza");
let txtDestezaTotal = document.getElementById("txtDestrezaTotal");
let txtDestezaModificador = document.getElementById("txtDestrezaModificador")

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

let btnSiguiente = document.getElementById("btnSiguiente");

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
//funcion para dar los eventos a los selects
function cargarEventosSelects() {
    calcularRestantes();
    selects.forEach(select => {
        select.addEventListener("change", fijarValorTotal);
    });
    // document.getElementById("trasfondo").addEventListener("change",fijarValorTotal);
}

//funcion para poner el valor del campo de total y su modificador
function fijarValorTotal() {
    let selectHabilidad1 = document.getElementById("habilidad1");
    let selectHabilidad2 = document.getElementById("habilidad2");
    let selectHabilidad3 = document.getElementById("habilidad3");
    for (let i = 0; i < 6; i++) {
        let valorTotal = selects[i].value;

        if (selectHabilidad1.value == i + 1) {
            valorTotal++;
        }
        if (selectHabilidad2.value == i + 1) {
            valorTotal++;
        }
        if (selectHabilidad3.value == i + 1) {
            valorTotal++;
        }
        totales[i].textContent = valorTotal;
        modificadores[i].textContent =
            Math.floor((valorTotal - 10) / 2);
    }
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
//eventos
///////////////////////////////////////////////////////////////////////////
btnSiguiente.addEventListener("click", (event) => {
    if (restantes != 0) {
        event.preventDefault();
        alert("Debes gastar todos los puntos de las caracteristicas")
    }
})

///////////////////////////////////////////////////////////////////////////
//codigo a ejecutar
///////////////////////////////////////////////////////////////////////////
cargarEventosSelects();