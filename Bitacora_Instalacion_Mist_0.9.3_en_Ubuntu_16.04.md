## Instalacion de Mist 0.9.3 en Ubuntu 16.04
Bitácora de pasos realizados para instalar  Mist 0.9.3 en una máquina virtual Ubuntu 16.04

## Paso 1 - Cambiar a `root` para realizar los pasos siguientes y crear directorio donde alojar el paquete .deb de instalación

```
$ su -
$ mkdir ~/Descargas
```

## Paso 1 - Descargar Mist desde https://github.com/ethereum/mist/releases

```
$ cd ~/Descargas
$ wget --verbose https://github.com/ethereum/mist/releases/download/v0.9.3/Mist-linux64-0-9-3.deb
```

## Paso 2 - Instalación previa de dependencias

La instalación de Mist 0-9-3 requiere de algunas dependencias previas:

```
apt-get install libindicator7 libappindicator1 gconf2
```
## Paso 3 - Instalación del paquete .deb

```
$ cd ~/Descargas
$ dpkg -i Mist-linux64-0-9-3.deb
$ exit
```
>Nota: No olvidar utilizar `exit` o `CTRL+D` para retornar al usuario de trabajo.


## Paso 4 - Añadir entrada en `.bash_aliases` del usuario de trabajo para acceso rápido a Mist

```
# gedit ~/.bash_aliases  
```
Incorporar la entrada de alias:

```
alias MIST='mist --rpc $HOME/GETHDATA/geth.ipc'
``` 

>Nota: donde `$HOME/GETHDATA/` debe ajustarse al directorio de DATOS real donde se ha arrancado el nodo ethereum. OJO: el nodo debería estar previamente arrancado y minando antes de arrancar MIST desde otro terminal/sesión de trabajo.