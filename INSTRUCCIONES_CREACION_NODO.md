Por si puede serle de utilidad a alguien he recogido en este post los pasos que he seguido para arrancar con éxito el Nodo Ethereum. Asimismo he creado un script `bash` para poder rearrancar el nodo en cada sucesiva sesión.

La instrucciones que muestro las he realizado en una máquina virtual Linux Ubuntu 17.04 (_que está a disposición de quien le pudiera venir bien__). 

```
devel1@vbxub1704:~$ uname -a
Linux vbxub1704 4.10.0-38-generic #42-Ubuntu SMP Tue Oct 10 13:24:27 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
devel1@vbxub1704:~$ cat /etc/*release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=17.04
DISTRIB_CODENAME=zesty
DISTRIB_DESCRIPTION="Ubuntu 17.04"
NAME="Ubuntu"
VERSION="17.04 (Zesty Zapus)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 17.04"
VERSION_ID="17.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=zesty
UBUNTU_CODENAME=zesty
```

> Nota: La descripción de los pasos las detallo a bastante bajo nivel para aquellos que puedan tener poca o nula familiaridad con un entorno Linux. Para quien tenga más familiaridad con linux le puede servir igualmente como bitácora de los pasos seguidos.


#### Paso 1) Asegurar posicionarnos en el directorio HOME del usuario con el que nos hemos logado:
```
devel1@vbxub1704:~$ echo $HOME
/home/devel1
devel1@vbxub1704:~$ cd $HOME
devel1@vbxub1704:~$ pwd
/home/devel1
devel1@vbxub1704:~$ 
```

#### Paso 2) Comprobamos si en la carpeta HOME del usuario existe un directorio '**bin**'. 
Si no es así: lo crearemos. La recomendación de disponer de una carpeta 'bin' estriba en que es un lugar adecuado para ubicar nuestros 'scripts' de usuario.

##### Comprobación:
* Si No existe ==> lo crearemos.

> (Nota: en mi ejemplo **$HOME** se resuelve a '**/home/devel1**'):
```
devel1@vbxub1704:~$ ls -la $HOME/bin
ls: no se puede acceder a '/home/devel1/bin': No existe el archivo o el directorio

devel1@vbxub1704:~$ mkdir --verbose $HOME/bin
mkdir: se ha creado el directorio '/home/devel1/bin'
```
* Si ya existe ==> simplemente pasamos al siguiente paso
```
devel1@vbxub1704:~$ ls -la $HOME/bin
total 8
drwxr-xr-x  2 devel1 devel1 4096 nov 17 21:24 .
drwxr-xr-x 24 devel1 devel1 4096 nov 17 21:24 ..
... ... ... ...
```
#### Paso 3) Comprobamos si el directorio **$HOME/bin** (en mi caso `/home/devel1/bin`) se encuentra incluido en el **PATH** asignado al usuario, pues de esta manera podremos invocar nuestros 'scripts' de utilidad directamente sin necesidad de especificar el directorio donde se encuentran en el momento de su invocación:

##### **Posibilidad 1: invocando `echo $PATH` el directorio HOME ( en mi caso `/home/devel1/bin` ) NO está presente**

```
devel1@vbxub1704:~$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/local/go/bin
```
En este ejemplo puede observarse que **NO SE ENCUENTRA ninguna entrada para** `/home/devel1/bin` en la lista de directorios (separados por el caracter de separacion '**:**') ==>  Lo que haremos entonces es asegurar que se incluya de forma permanente en las siguientes veces que entremos en una sesión de terminal. Para ello es necesario incluir  **_AL FINAL_** del archivo `.bashrc` que reside en el directorio HOME del usuario la ampliación de la variable de entorno **PATH** para que incluya el direcorio '**bin'**.

##### Alternativas:
1. Editar con **vi** / **nano** / **emacs** el archivo **.bashrc** (_no recomendable para no iniciados en Linux_) 
2. Si se está utilizando el entorno grafico  puede usuarse el editor de texto **gedit** 
(_más recomendable para no iniciados en Linux_) `gedit .bashrc`
3.  Hacer un '**append**' sobre el fichero **.bashrc** (_igualmente recomendable para no iniciados en Linux_):
3.1 Primero hacer una copia de seguridad por si acaso: `cp --verbose $HOME/.bashrc $HOME/.bashrc_BACKUP_$(date +"%Y-%m-%d")`
3.2 Agregar al final del archivo [ **OJO** usar '**>>**' (append) y nó '**>**' ("machacar" el archivo) ] `echo 'export PATH=$PATH:$HOME/bin' >> $HOME/.bashrc`
3.3 Comprobar que efectivamente la instrucción `export $PATH=$PATH:$HOME/bin` es la última linea del archivo. Mediante: `tail -1 $HOME/.bashrc` debe indicar: `export PATH=$PATH:$HOME/bin`
3.4. Salir de la sesión de consola y iniciar una nueva de sesión de consola (con `exit` o `CRTL+D`).
3.5. Verificar que el nuevo valor de la variable de entorno PATH incluye el directorio '**bin**' en el directorio **HOME** del usuario (_en mi ejemplo: /home/devel1/bin_). Invocamos nuevamente `echo $PATH` y esta vez ya deberá aparecer el directorio. Por ejemplo: `/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/local/go/bin:/home/devel1/bin`


##### **Posibilidad 2: invocando `echo $PATH` el directorio HOME ( en mi caso `/home/devel1/bin` ) NO está presente**
```
devel1@vbxub1704:~$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/local/go/bin:/home/devel1/bin
```
En este caso seguimos con el siguiente paso.


#### Paso 4) Vamos a crear un directorio para alojar los datos (parámetro `datadir` en lo sucesivo) del nodo Ethereum.

En este ejemplo voy a usar un directorio con nombre `GETHDATOS` en el directorio HOME del usuario es decir, que podrá ser referenciado en lo sucesivo como `$HOME/GETHDATOS`. 

> Nota:  el nombre en mayusculas es intencional para reducir la posibilidad que el nombre "colisione" con algun otro directorio que casualmente pudiera existir: no es nada común la práctica de usar un nombre en mayusculas para directorios en Linux


##### Comprobación:

- Si No existe ==> lo crearemos:

```
devel1@vbxub1704:~$ ls -la $HOME/GETHDATOS
ls: no se puede acceder a '/home/devel1/GETHDATOS': No existe el archivo o el directorio

devel1@vbxub1704:~$ mkdir --verbose $HOME/GETHDATOS
mkdir: se ha creado el directorio '/home/devel1/GETHDATOS'
```

- Si ya existe ==> simplemente deberíamos escoger otro nombre y repetir el paso (y en los siguientes usar el nuevo nombre)

```
devel1@vbxub1704:~$ ls -la $HOME/GETHDATOS
total 20
drwxr-xr-x  4 devel1 devel1 4096 nov 15 20:50 .
drwxr-xr-x 25 devel1 devel1 4096 nov 17 21:26 ..
-rw-r--r--  1 devel1 devel1  692 nov 15 19:08 bloque_genesis.json
drwxr-xr-x  4 devel1 devel1 4096 nov 15 20:02 geth
drwx------  2 devel1 devel1 4096 nov 15 19:05 keystore
... ... ... ...
```
==> **EL DIRECTORIO YA EXISTE !!!** ==> deberemos escoger otro nombre.

#### Paso 5) Creación INICIAL del nodo Ethereum y, por ejemplo, hasta 4 cuentas de usuarios para los ejercicios.

Para poder "registrar" en un fichero de log los comandos ejecutados así cómo el resultado de lo que se muestra en pantalla (necesitaremos guardar los identificadores de las cuentas tanto para usarlas en los ejercicios posteriormente) usaremos la utilidad de `script` de BASH que nos permite precisamente eso: registrar los comandos usados y el resultado de los mismos en un archivo de log HASTA que se 'salga' de la 'shell' mediante el comado `exit` o pulsando la combinación `CTRL+D`:


```
devel1@vbxub1704:~$ script $HOME/LOG_USUARIOS_CREADOS
Script iniciado; el fichero es /home/devel1/LOG_USUARIOS_CREADOS
devel1@vbxub1704:~$ geth --datadir /home/devel1/GETHDATOS account new
WARN [11-17|22:01:39] No etherbase set and no accounts found as default 
Your new account is locked with a password. Please give a password. Do not forget this password.
Passphrase: 
Repeat passphrase: 
Address: {e5614d52c36da907ed903d7b10ce802c6bdcc751}
devel1@vbxub1704:~$ geth --datadir /home/devel1/GETHDATOS account new
Your new account is locked with a password. Please give a password. Do not forget this password.
Passphrase: 
Repeat passphrase: 
Address: {0153bdafc52115991b9c28619015f3bd5e549783}
devel1@vbxub1704:~$ geth --datadir /home/devel1/GETHDATOS account new
Your new account is locked with a password. Please give a password. Do not forget this password.
Passphrase: 
Repeat passphrase: 
Address: {cebc3f74f2317aaa8985be899d67e4f9e6bf2d99}
devel1@vbxub1704:~$ geth --datadir /home/devel1/GETHDATOS account new
Your new account is locked with a password. Please give a password. Do not forget this password.
Passphrase: 
Repeat passphrase: 
Address: {1d3a1e8f498f2b3ce7af010f0efd6a8c26e4bc85}
devel1@vbxub1704:~$ exit
exit
Script terminado; el fichero es /home/devel1/LOG_USUARIOS_CREADOS
```

En mi ejemplo el archivo `/home/devel1/LOG_USUARIOS_CREADOS` que se obtuvo tiene el siguiente contenido:

```
Script iniciado (vie 17 nov 2017 22:01:19 CET
)]0;devel1@vbxub1704: ~[01;32mdevel1@vbxub1704[00m:[01;34m~[00m$ geth --datadir /home/devel1/GETHDATOS account new
[33mWARN [0m[11-17|22:01:39] No etherbase set and no accounts found as default 
Your new account is locked with a password. Please give a password. Do not forget this password.
Passphrase: 
Repeat passphrase: 
Address: {e5614d52c36da907ed903d7b10ce802c6bdcc751}
]0;devel1@vbxub1704: ~[01;32mdevel1@vbxub1704[00m:[01;34m~[00m$ geth --datadir /home/devel1/GETHDATOS account new
Your new account is locked with a password. Please give a password. Do not forget this password.
Passphrase: 
Repeat passphrase: 
Address: {0153bdafc52115991b9c28619015f3bd5e549783}
]0;devel1@vbxub1704: ~[01;32mdevel1@vbxub1704[00m:[01;34m~[00m$ geth --datadir /home/devel1/GETHDATOS account new
Your new account is locked with a password. Please give a password. Do not forget this password.
Passphrase: 
Repeat passphrase: 
Address: {cebc3f74f2317aaa8985be899d67e4f9e6bf2d99}
]0;devel1@vbxub1704: ~[01;32mdevel1@vbxub1704[00m:[01;34m~[00m$ geth --datadir /home/devel1/GETHDATOS account new
Your new account is locked with a password. Please give a password. Do not forget this password.
Passphrase: 
Repeat passphrase: 
Address: {1d3a1e8f498f2b3ce7af010f0efd6a8c26e4bc85}
]0;devel1@vbxub1704: ~[01;32mdevel1@vbxub1704[00m:[01;34m~[00m$ exit
exit

Script terminado (vie 17 nov 2017 22:02:27 CET
)
``` 

Del mismo se pueden extraer las 'direcciones'/'Address' siguientes para los usuarios creados:

```
Address: {e5614d52c36da907ed903d7b10ce802c6bdcc751}
Address: {0153bdafc52115991b9c28619015f3bd5e549783}
Address: {cebc3f74f2317aaa8985be899d67e4f9e6bf2d99}
Address: {1d3a1e8f498f2b3ce7af010f0efd6a8c26e4bc85}
```

> Nota: Adviértase que estos valores serán diferentes de los que se obtengan al reproducir estos pasos en otra ejecución.

#### Paso 6) Preparación del `"Bloque Génesis"` del nuevo nodo Ethereum

Para ello usaremos un nuevo 'truco' para poder tener dos ficheros abiertos al mismo tiempo como dos 'pestañas' en el editor `gedit`: invocar el comando `gedit` _'en fondo'_ con un `&` al final:
```
devel1@vbxub1704:~$ gedit $HOME/GETHDATOS/bloque_genesis.json &
[1] 4844
devel1@vbxub1704:~$ gedit $HOME/LOG_USUARIOS_CREADOS &
[2] 4861
```
>Nota: los numeros que se muestran son los identificadores de 'job' en fondo y sus
respectivos 'PROCESS ID / PIDs' en el sistema. Serán diferentes que los que se 
obtendrán al seguir estas instrucciones en una nueva ejecución.

Para el archivo `$HOME/GETHDATOS/bloque_genesis.json` he usado la plantilla siguiente:
>Nota: esta plantilla está guardada igualmente en este mismo proyecto en GitHub.

```
{
  "timestamp": "0x00",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "extraData": "0x00",
  "gasLimit": "0x8000000",
  "difficulty": "0x400",
  "alloc": {
    "0xe5614d52c36da907ed903d7b10ce802c6bdcc751": { "balance": "50000000000000000000000000" },
    "0x0153bdafc52115991b9c28619015f3bd5e549783": { "balance": "50000000000000000000000000" },
    "0xcebc3f74f2317aaa8985be899d67e4f9e6bf2d99": { "balance": "50000000000000000000000000" },
    "0x1d3a1e8f498f2b3ce7af010f0efd6a8c26e4bc85": { "balance": "50000000000000000000000000" }
  },
  "config": {
    "chainId": 15,
    "homesteadBlock": 0,
    "eip155Block": 0,
    "eip158Block": 0
  }
} 
```
>Nota: obsérvese que los identificadores en la sección **'alloc'** corresponden a las 
direcciones (**'Address'**) de los usuarios creados en el paso anterior.
Address: {e5614d52c36da907ed903d7b10ce802c6bdcc751}
Address: {0153bdafc52115991b9c28619015f3bd5e549783}
Address: {cebc3f74f2317aaa8985be899d67e4f9e6bf2d99}
Address: {1d3a1e8f498f2b3ce7af010f0efd6a8c26e4bc85}

Salvamos y cerramos ambos archivos en `gedit` y cerramos el editor `gedit` (los 'jobs' en fondo finalizan):

```
devel1@vbxub1704:~$ jobs
[1]-  Hecho                   gedit $HOME/GETHDATOS/bloque_genesis.json
[2]+  Hecho                   gedit $HOME/LOG_USUARIOS_CREADOS
```

#### Paso 7) Comprobamos que hemos creado correctamente el archivo que contiene el **"Bloque Génesis"**:

```
devel1@vbxub1704:~$ cat $HOME/GETHDATOS/bloque_genesis.json
{
  "timestamp": "0x00",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "extraData": "0x00",
  "gasLimit": "0x8000000",
  "difficulty": "0x400",
  "alloc": {
    "0xe5614d52c36da907ed903d7b10ce802c6bdcc751": { "balance": "50000000000000000000000000" },
    "0x0153bdafc52115991b9c28619015f3bd5e549783": { "balance": "50000000000000000000000000" },
    "0xcebc3f74f2317aaa8985be899d67e4f9e6bf2d99": { "balance": "50000000000000000000000000" },
    "0x1d3a1e8f498f2b3ce7af010f0efd6a8c26e4bc85": { "balance": "50000000000000000000000000" }
  },
  "config": {
    "chainId": 15,
    "homesteadBlock": 0,
    "eip155Block": 0,
    "eip158Block": 0
  }
}
```

#### Paso 8) Inicializamos el NODO Ethereum con el 'Bloque Genesis' creado en el paso anterior

Para ello utilizaremos el parametro `init`de `geth` ==> `geth --identity "test00" --datadir $HOME/GETHDATOS init $HOME/GETHDATOS/bloque_genesis.json`:
```
devel1@vbxub1704:~$ geth --identity "test00" --datadir $HOME/GETHDATOS init $HOME/GETHDATOS/bloque_genesis.json
INFO [11-23|11:58:51] Allocated cache and file handles         database=/home/devel1/GETHDATOS/geth/chaindata cache=16 handles=16
INFO [11-23|11:58:51] Writing custom genesis block 
INFO [11-23|11:58:51] Successfully wrote genesis state         database=chaindata                             hash=51300b…aa3c65
INFO [11-23|11:58:51] Allocated cache and file handles         database=/home/devel1/GETHDATOS/geth/lightchaindata cache=16 handles=16
INFO [11-23|11:58:51] Writing custom genesis block 
INFO [11-23|11:58:51] Successfully wrote genesis state         database=lightchaindata                             hash=51300b…aa3c65
```

#### Paso 9) Ahora prepararemos el 'comando' de arranque efectivo del NODO Ethereum. 

1) Lo que voy a hacer PRIMERO es '_preparar_' sin '_ejecutar_' realmente el comando y, en su lugar crear un **archivo de script** en el directorio `$HOME/bin` (que creamos al principio) y así poder volver a lanzar la ejecución del NODO en sucesivas ocasiones lanzando EXACTAMENTE la misma instrucción.

Para ello, una vez más, usaremos `gedit` para crear el siguiente archivo de 'script':`
```
devel1@vbxub1704:~$ gedit $HOME/bin/arranque_nodo_en_GETHDATOS.sh &
```
==> se abrirá el editor 'gedit' y en él se podrá crear la siguiente plantilla:
> OJO: al copiar/teclear esta plantilla el caracter de escape '**\**' 
debe venir seguido de un INTRO/Salto de linea EXCLUSIVAMENTE.

```
#!/bin/bash
# ============================================
# Script de Inicio del NODO Ethereum
# ============================================
set -x
geth --identity "test00" \
--mine --minerthreads=4 \
--datadir $HOME/GETHDATOS/ \
--port 30310 --rpc --rpcport 8110 \
--networkid 4567890 \
--nodiscover --maxpeers 0 \
--vmdebug --verbosity 6 \
--pprof --pprofport 6110
set +x
```
>Nota: esta archivo de 'script' de está guardado igualmente en este mismo proyecto en GitHub.

Salvamos el archivo y lo cerramos en 'gedit' y cerramos el editor.

2) Cambiamos los permisos al archivo de script para que tenga permisos de 
'ejecución':

```
devel1@vbxub1704:~$ chmod --verbose ugo+x $HOME/bin/arranque_nodo_en_GETHDATOS.sh 
el modo de '/home/devel1/bin/arranque_nodo_en_GETHDATOS.sh' cambia de 0644 (rw-r--r--) a 0755 (rwxr-xr-x)
```

Puede verse que ya es un nuevo '_comando_' ejecutable con 
```
devel1@vbxub1704:~$ which arranque_nodo_en_GETHDATOS.sh
/home/devel1/bin/arranque_nodo_en_GETHDATOS.sh
```

####Paso 9) Usamos el script creado para arrancar el NODO Ethereum creado en `$HOME/GETHDATOS` (esta primera vez y sucesivas veces cada vez que lo hayamos parado y queramos reanudarlo)

```
devel1@vbxub1704:~$ arranque_nodo_en_GETHDATOS.sh
+ geth --identity test00 --mine --minerthreads=4 --datadir /home/devel1/GETHDATOS/ --port 30310 --rpc --rpcport 8110 --networkid 4567890 --nodiscover --maxpeers 0 --vmdebug --verbosity 6 --pprof --pprofport 6110
INFO [11-17|22:54:33] Starting pprof server                    addr=http://127.0.0.1:6110/debug/pprof
DEBUG[11-17|22:54:33] FS scan times                            list=41.051µs set=4.834µs diff=5.555µs
TRACE[11-17|22:54:33] Handled keystore changes                 time=191.325µs
INFO [11-17|22:54:33] Starting peer-to-peer node               instance=Geth/test00/v1.7.2-stable-1db4ecdc/linux-amd64/go1.9
TRACE[11-17|22:54:33] Started watching keystore folder         path=/home/devel1/GETHDATOS/keystore
DEBUG[11-17|22:54:33] FS scan times                            list=62.662µs set=7.296µs diff=7.425µs
TRACE[11-17|22:54:33] Handled keystore changes                 time=677ns
INFO [11-17|22:54:33] Allocated cache and file handles         database=/home/devel1/GETHDATOS/geth/chaindata cache=128 handles=1024
INFO [11-17|22:54:33] Writing default main-net genesis block 
DEBUG[11-17|22:54:33] Trie cache stats after commit            misses=0 unloads=0
INFO [11-17|22:54:33] Initialised chain configuration          config="{ChainID: 1 Homestead: 1150000 DAO: 1920000 DAOSupport: true EIP150: 2463000 EIP155: 2675000 EIP158: 2675000 Byzantium: 4370000 Engine: ethash}"
INFO [11-17|22:54:33] Disk storage enabled for ethash caches   dir=/home/devel1/GETHDATOS/geth/ethash count=3
INFO [11-17|22:54:33] Disk storage enabled for ethash DAGs     dir=/home/devel1/.ethash               count=2
INFO [11-17|22:54:33] Initialising Ethereum protocol           versions="[63 62]" network=4567890
INFO [11-17|22:54:33] Loaded most recent local header          number=0 hash=d4e567…cb8fa3 td=17179869184
INFO [11-17|22:54:33] Loaded most recent local full block      number=0 hash=d4e567…cb8fa3 td=17179869184
INFO [11-17|22:54:33] Loaded most recent local fast block      number=0 hash=d4e567…cb8fa3 td=17179869184
DEBUG[11-17|22:54:33] Reinjecting stale transactions           count=0
INFO [11-17|22:54:33] Regenerated local transaction journal    transactions=0 accounts=0
INFO [11-17|22:54:33] Starting P2P networking 
DEBUG[11-17|22:54:33] InProc registered *node.PrivateAdminAPI under 'admin' 
DEBUG[11-17|22:54:33] InProc registered *node.PublicAdminAPI under 'admin' 
DEBUG[11-17|22:54:33] InProc registered *debug.HandlerT under 'debug' 
DEBUG[11-17|22:54:33] InProc registered *node.PublicDebugAPI under 'debug' 
DEBUG[11-17|22:54:33] InProc registered *node.PublicWeb3API under 'web3' 
DEBUG[11-17|22:54:33] InProc registered *ethapi.PublicEthereumAPI under 'eth' 
DEBUG[11-17|22:54:33] InProc registered *ethapi.PublicBlockChainAPI under 'eth' 
DEBUG[11-17|22:54:33] InProc registered *ethapi.PublicTransactionPoolAPI under 'eth' 
DEBUG[11-17|22:54:33] InProc registered *ethapi.PublicTxPoolAPI under 'txpool' 
DEBUG[11-17|22:54:33] InProc registered *ethapi.PublicDebugAPI under 'debug' 
DEBUG[11-17|22:54:33] InProc registered *ethapi.PrivateDebugAPI under 'debug' 
DEBUG[11-17|22:54:33] InProc registered *ethapi.PublicAccountAPI under 'eth' 
DEBUG[11-17|22:54:33] InProc registered *ethapi.PrivateAccountAPI under 'personal' 
DEBUG[11-17|22:54:33] InProc registered *eth.PublicEthereumAPI under 'eth' 
DEBUG[11-17|22:54:33] InProc registered *eth.PublicMinerAPI under 'eth' 
DEBUG[11-17|22:54:33] InProc registered *downloader.PublicDownloaderAPI under 'eth' 
DEBUG[11-17|22:54:33] InProc registered *eth.PrivateMinerAPI under 'miner' 
DEBUG[11-17|22:54:33] InProc registered *filters.PublicFilterAPI under 'eth' 
DEBUG[11-17|22:54:33] InProc registered *eth.PrivateAdminAPI under 'admin' 
DEBUG[11-17|22:54:33] InProc registered *eth.PublicDebugAPI under 'debug' 
DEBUG[11-17|22:54:33] InProc registered *eth.PrivateDebugAPI under 'debug' 
DEBUG[11-17|22:54:33] InProc registered *ethapi.PublicNetAPI under 'net' 
DEBUG[11-17|22:54:33] IPC registered *node.PrivateAdminAPI under 'admin'

.....
```

Espero que os sea de utilidad.


> Elaborado en Markdown utilizando [StackEdit](https://stackedit.io/).
