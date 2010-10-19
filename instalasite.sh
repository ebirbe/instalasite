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
ERR_COPIAR=6

NOMBRE_SCRIPT=`basename $0`

# Muestra los mensajes de error
error()
{
	echo "$NOMBRE_SCRIPT: ERROR $1" 1>&2
	return $EXITO
}

# Verifica si quien ejecuta el script es "root"
esroot()
{
	if [ $(id -u) -ne 0 ]
	then
	   error "$NOMBRE_SCRIPT debe ser ejecutado como root"
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
	
	exit $ERR_DIRECTORIO

}

# Verifica si una aplicacion existe
appexiste()
{
	echo "Buscando '$1' ..."
	IFS=:
	for dir in $PATH
	do
		if  test -f $dir/$1
		then
			echo "$NOMBRE_SCRIPT: '$1' encontrada... Exito!"
			return $EXITO
		fi
	done
	
	error "La aplicación '$1' no existe por favor verifique que esté instalada"
	return $ERR_APLICACION
}

# Importa un script a mysql
mysqlimport()
{
	usr=$1
	psw=$2
	src=`cat $3`
	echo $src
	mysql -u$usr -p$psw -e "$src"

	if [ $? -eq 0 ]
	then
		return $EXITO
	else
		error "Hubo un problema al cargar la nueva base de datos."
		exit $ERR_IMPORT
	fi
}

# $# es el numero de parametros ingresados
# $1 es la carpeta fuente
# $2 es la carpeta destino o la ruta del servidor
# $3 usuario del MySQL
# $4 clave del MySQL
# $5 script SQL

esroot

numeroarg $# 5

if (! appexiste mysql)
then
	exit $ERR_APLICACION
fi

# Inicializando variables
if direxiste $1
then
	dir_origen=$1
fi

if direxiste $2 
then
	dir_destino=$2
fi

usuario=$3
clave=$4
script_bd=$5

# Comienza el copiado
cp -R $dir_origen $dir_destino
if [ $? -eq 0 ]
then
	if mysqlimport $usuario $clave $script_bd
	then
		echo "$0: EXITO! el sistema ya esta instalado."
		return $EXITO
	fi
else
	error "Hubo un error y no se pudo instalar"
fi

return $ERR_COPIAR


