#!/bin/sh

###############################################################################
# Este programa es Sofware Libre; puedes redistribuirlo y/o modificarlo bajo  #
# los terminos de la GNU General Public License como la publica la Free       #
# Software Fundation; en la version 2 de la licencia, o (a su elección)	      #
# cualquer version siguiente.                                                 #
#                                                                             #
# Este programa se publica esperando que sea útil, pero SIN NINGUNA GARANTIA; #
# ni siquiera la garantía implícita de COMERCIALIZACIÓN o IDONEIDAD PARA UN   #
# PROPÓSITO PARTICULAR. Consulte la GNU General Public License para más       #
# detalles.                                                                   #
#                                                                             #
# instalasite.sh -- Un programa para instalar facilmente aplicaciones web que #
# requieran de una base de datos MySQL en un servidor desde un CD, unidad     #
# removible o cualquier carpeta externa.                                      #
#                                                                             #
# Pagina Principal: http://github.com/erickcion/instalasite                   #
# Creado por: Erick Birbe <erickcion@gmail.com>                               #
# Fecha Creación: 18 de Abril de 2010                                         #
###############################################################################

EXITO=0
ERR_ARGUMENTO=1
ERR_DIRECTORIO=2

# Verifica si quien ejecuta el script es "root"
esroot()
{
	if [[ $EUID -ne 0 ]]; then
	   error "Este script debe ser ejecutado como root"
	   exit 1
	fi	
}

# Muestra los mensajes de error
error()
{
	echo $1 1>&2
	return 0
}

# Verifica si un directorio existe
direxiste()
{
	if [ -d "$1" ]
	then
		return $EXITO
	else
		error "$0: '$1' no es un directorio valido."
	fi
	
	return $ERR_DIRECTORIO

}

# $# es el numero de parametros ingresados
# $1 es la carpeta fuente
# $2 es la carpeta destino o la ruta del servidor

# Validaciones Generales
if [ $# -lt 2 ] 
then
	error "$0: Argumentos insuficientes."
	echo "USO: $0 carpeta_origen carpeta_servidor"
	exit $ERR_ARGUMENTO
fi

# Inicializando variables por defecto
if  direxiste $1
then
	DIR_ORIGEN=$1
fi

if direxiste $2
then
	DIR_DESTINO=$2
fi







