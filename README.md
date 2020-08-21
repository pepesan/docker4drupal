# Revisión de Docker4Drupal

Descargado de [Repositorio Docker4Drupal](https://github.com/wodby/docker4drupal)

Revisionado en [Repositorio pepesan Docker4Drupal](https://github.com/pepesan/docker4drupal)

# Requisitos
* Docker
* docker-compose
* composer
* drush
# Arraque de los servicios
El proceso de arranque se ha modificado para disponer de una serie de scripts que permiten la instalación de drupal
# Entorno de Desarrollo
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
# Entorno de Producción
## Fichero .env
En el fichero .env tenemos la variables de entorno que definen la instalación de los entornos, revísalo para que esté todo correcto
## Ojo esto sólo deberá hacerse la primera vez que de despliega en producción, ya que machacará la bbdd
## Creamos las imágenes
./crea_imagen_prod.sh
## Lanza el script
./lanza_produccion.sh
### ¿Qué hace?
* Crea las imágenes de producción
* Crea los directorios de los volumenes para producción
* Ejecuta del docker-compose -f docker-compose-prod.yaml up -d
* Espera a que esté disponible el servicio 10 segundos
* importa la bbdd en producción
# Para entrar al drupal en producción ya instalado 
[http://localhost:8080/](http://localhost:8080/)

