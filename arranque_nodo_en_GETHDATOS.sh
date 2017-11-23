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
