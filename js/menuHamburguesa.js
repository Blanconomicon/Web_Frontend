const hamburguesa = document.getElementById('menu-hamburguesa');
const menu = document.getElementById('menu');
if (hamburguesa) {
    hamburguesa.addEventListener('click', () => {
        hamburguesa.classList.toggle('active'); // animación de X
        menu.classList.toggle('show'); // mostrar/ocultar menú
    });
}