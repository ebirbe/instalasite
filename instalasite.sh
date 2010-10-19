#!/bin/sh

###############################################################################
#                                                                             #
# Copyright (C) 2010  Erick Birbe                                             #
#                                                                             #
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
#                                                                             #
###############################################################################

# Creacion de Constantes
EXITO=0
ERR_ARGUMENTO=1
ERR_DIRECTORIO=2
ERR_ROOT=3
ERR_APLICACION=4
ERR_IMPORT=5

# Muestra los mensajes de error
error()
{
	echo "$0: ERROR $1" 1>&2
	return $EXITO
}

# Verifica si quien ejecuta el script es "root"
esroot()
{
	if [ $(id -u) -ne 0 ]
	then
	   error "Este script debe ser ejecutado como root"
	   exit $ERR_ROOT
	fi
	
	return $EXITO	
}
# Verifica que el numero de argumentos introducido sea correcto
numeroarg()
{
# $1 numero de argumentos ingresados
# $2 numero maximo
	if [ $1 -lt $2 ]
	then
		error "Argumentos insuficientes."
		echo "USO:"
		echo "\t$0 carpeta_origen carpeta_servidor usuario clave script"
		exit $ERR_ARGUMENTO
	fi
}

# Verifica si un directorio existe
direxiste()
{
	if [ -d "$1" ]
	then
		return $EXITO
	else
		error "'$1' no es un directorio valido."
	fi
	
	return $ERR_DIRECTORIO

}

# Verifica si una aplicacion existe
appexiste()
{
	echo "$0: Buscando $1 ..."
	IFS=:
	for dir in $PATH
	do
		if  test -f $dir/$1
		then
			echo "$0: $1 encontrada... Exito!"
			return $ERR_APLICACION
		fi
	done
	
	error "La aplicación $1 no existe por favor verifique que esté instalada"
	return $EXITO
}

# Importa un script a mysql
mysqlimport()
{
	usr=$1
	psw=$2
	scr=$3
	
	if mysql -u$usr -p$psw < $src
	then
		return $EXITO
	else
		return $ERR_IMPORT
	fi
}

# $# es el numero de parametros ingresados
# $1 es la carpeta fuente
# $2 es la carpeta destino o la ruta del servidor

# Validaciones Generales

esroot
numeroarg

# Inicializando variables
if direxiste $1
then
	dir_origen=$1
fi

if direxiste $2 
then
	dir_destino=$2
fi

if ( cp -vR $dir_origen $dir_destino )
then
	if appexiste mysql
	then
		if mysqlimport $usuario $clave $script_bd
	fi
fi









