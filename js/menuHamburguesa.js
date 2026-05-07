//definir constantes
const hamburguesa = document.getElementById('menu-hamburguesa');
const menu = document.getElementById('menu');

//si existe el menu de hamburguesa darle el evento
if (hamburguesa) {
    hamburguesa.addEventListener('click', () => {
        hamburguesa.classList.toggle('active'); // animación de X
        menu.classList.toggle('show'); // mostrar/ocultar menú
    });
}