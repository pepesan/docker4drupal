# Revisión de Docker4Drupal

Descargado de [Repositorio Docker4Drupal](https://github.com/wodby/docker4drupal)

Revisionado en [Repositorio pepesan Docker4Drupal](https://github.com/pepesan/docker4drupal)

# Requisitos
* Docker
* docker-compose
* composer
# Arraque de los servicios
El proceso de arranque se ha modificado para disponer de una serie de scripts que permiten la instalación de drupal
# QuickStart
## Fichero .env
En el fichero .env tenemos la variables de entorno que definen la instalación del entorno de desarrollo, revísalo para que esté todo correcto
## Creamos las imágenes
./crea_imagen.sh
## Lanza el script
./instala_y_lanza.sh
### ¿Qué hace?
* descarga_drupal.sh: descarga drupal en el directorio drupal
* Ejecuta del docker-compose up -d
* Espera a que esté disponible el servicio 10 segundos
* instala_drupal.sh: realiza la instalación de drupal 
# Para entrar al drupal ya instalado 
[http://localhost/](http://localhost)

