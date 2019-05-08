#!/bin/bash
echo "LABORATORIO 02"
echo ""
rm -rf lex.yy.c y.tab.c y.tab.h Salida.txt
lex LAB01_CORCHO_JULIAO.l
yacc -d LAB02_CORCHO_JULIAO.y

echo "--------------------------------------------------"
echo "Generando ejecutable"
gcc lex.yy.c y.tab.c -o lab02_executable

echo "EJECUCIÓN TERMINADA"
echo "Lista de archivos"
ls -l 


