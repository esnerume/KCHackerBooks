# PREGUNTAS SOBRE LA PRACTICA HACKER BOOKS

En general, he ido comentando el código, cosa bastante inusual en mi, pero como es mi primera App en **Swift 3**, he creido conveniente comentarlo para en el futuro comentar porqué hice lo que hice.

Seguramente en el futuro me sacaré millones de pegas a la solución que he dado en este caso, pero bueno, nadie nace enseñado ;-).

## ¿ Dónde guardarías las imágenes de portada y los pdf ?

En mi opinión la zona correcta para almacenar este tipo de datos es la cache. Según recuerdo del curso online, la cache puede ser limpiada (lo hace el dispositivo/sistema operativo sin necesidad de una programación específica) en caso de que nos estemos quedando sin recursos.

En el caso de mi implementación, al estar haciendo uso de **AsyncData**, los ficheros de recursos los almacena lo guarda en el directorio de cache ella solita.


## Cuando se añade o se quita un libro de favoritos, hay que persistir esta información cuando se cierra la App y cuando se abre. ¿ Cómo harías esto ? ¿ Se te ocurre más de una manera de hacerlo ?

En mi caso, (no se si soy especialmente paranoico) estoy almacenando en **UserDefaults**, cada vez que añado o quito de favoritos. No lo estoy haciéndolo al cerrar la App. Quizás para el curso avanzado pueda meterme en control de **memoryWarnings** etc controlando los posibles casos en los que se cierra un App en un dispositivo real, para hacer el guardado en ese momento. Eso es hilar bastante fino.

Creo que usar **UserDefaults** es lo suyo, ya que es algo que está pensado para guardar datos personalizados del usuario (como es el caso de saber si un libro es favorito o no). Estoy guardando como clave el hash del objeto Book en cuestión, y como valor un booleano dependiendo de si está marcado o no como favorito.

Otra opción para almacenarlo sería en ficheros o en base de datos, pero para el volumen de esta app, creo que es más que suficiente.


## Cuando cambia el valor de isFavorite, la tabla debe reflejar el cambio ¿ Cómo lo harías ?

El único punto en la que cambia un estado de favorito, es en el **IBAction** de Favorito (Botón con el corazón). En este caso, avisamos al delegado (**La tabla de LibraryTableViewController**) de que ha cambiado el estado **"bookDidChangeFavoriteStatus"**. El delegado, se encargará de actualizar el multi diccionario y recargar la tabla.


## ¿ Es una aberración recargar la tabla con Reload data desde el punto de vista de rendimiento ? ¿ Hay alguna alternativa? ¿ cuando conviene utilizarlo ?

He estado monitorizando el procesador del emulador, y no parece una tarea especialmente costosa, especialmente si lo comparamos con la apertura de PDF desde la **WebView**.  Además, si nos vamos a la documentación, vemos que por eficiencia solo actualiza las filas que están visibles, por lo que para nada sería una aberración llamar ante cualquier cambio a **reloadData**.

Quizás la forma optima de hacer esto (Contando que realmente única sección que cambia es la sección de Favoritos y que el Json es siempre el mismo), sería utilizar la función reloadSections siempre cuando la sección ya exista, en caso contrario, utilizaría el **reloadData**, que tampoco es especialmente costoso ya que está muy bien optimizado.

## Cuando el usuario cambia el libro en la tabla, el PDF debe actualizarse ¿ Cómo hacerlo ?

Dado que la tabla sólo puede tener un delegado (Que en este caso es el **BookViewController**), la única manera es a través de una notificación. En el controlador de la tableView al hacer el **didSelectBook**, mandamos la notificación que en este caso será recogido por el **PDFViewController**, que sincronizará la vista con el Modelo **(Book)**, recargando su **WebView** con la url del nuevo libro.


# Extras

## ¿ Qué funcionalidades le añadirías antes de subirla a la App Store ?

Quizás para que fuera realmente util y reutilizable, haría que la url del Json fuera configurable para poder cambiarla cuando el usuario quiera. Además haría un mapeador de campos para que cualquier Json que venga con la info que necesita la aplicación (independientemente de como se llamen sus campos) pueda ser utilizado para mostrarse.

Además incluiría opciones de compartir en redes sociales, para poder decir que estás leyendo tal libro en ese momento.

También sería deseable tener una forma de buscar los libros, ya que a mediada que el Json sea más grande, puede ser relativamente complicado encontrar un libro (Aunque el que estén ordenados alfabéticamente)

## ¿ Qué otras versiones se me ocurren con la misma plantilla ?

Aprovechando la base de esta App, sería bastante fácil crear un visualizador de catálogos de cualquier cosa (Coches, Muebles).
Con algunas pequeñas modificaciones (Bastaria cambiar que el **Webview** visualice un mp4, en lugar de abrir el PDF) podríamos adaptarlo para ver Trailers/Películas de DVD (Siendo los DVD el sustituto de los libros)

## ¿ Como pueder ganar dinero con HackerBooks ?

Hay dos formas principales tal y como comentabas en las clases. **Cobrar por la App** (Cosa poco probable porque aunque es muy chula, no hace nada realmente especial que haga que alguien pague por ella), o poniendo publi con **Admob** por ejemplo.
