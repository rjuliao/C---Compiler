#!/bin/bash
echo "LABORATORIO 02"
echo ""
rm -rf lex.yy.c y.tab.c y.tab.h Salida.txt
lex LAB01_CORCHO_JULIAO.l
bison -d -y LAB02_CORCHO_JULIAO.y
echo "Generando ejecutable"
gcc lex.yy.c y.tab.c -o LAB02_exe
echo "EJECUCIÓN TERMINADA"
ls -l 


