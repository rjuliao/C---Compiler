
/*Declaraciones*/
%{
	#include <stdio.h>
	#include "y.tab.h"
	#include <string.h>
	#include <stdbool.h>
	int i = 0, j = 0, lc = 0;
	const char* id[10000];
	const char* b[10000];
	const char* err[1000000];
	void counter(const char* val);
	void errtable();
	void idtable();
	void count(const char* val);
	extern FILE *yyin, *yyout;
%}

abc				[A-Za-z]
dig 			[0-9]
signo			[+-]?
exp				[Ee]{signo}{dig}+
opcl			\"


/*Reglas de traducción*/
%%
main				{fprintf(yyout, "MAIN \n"); return(MAIN);}
void				{fprintf(yyout, "VOID "); return(VOID);}
int					{fprintf(yyout, "INT "); return(INT);}
float				{fprintf(yyout, "FLOAT "); return(FLOAT);}
char				{fprintf(yyout, "CHAR "); return(CHAR);}
double				{fprintf(yyout, "DOUBLE "); return(DOUBLE);}
printf				{fprintf(yyout, "PRINTF "); return(PRINTF);}
scanf				{fprintf(yyout, "SCANF "); return(SCANF);}
if					{fprintf(yyout, "IF "); return(IF);}
else				{fprintf(yyout, "ELSE "); return(ELSE);}
for					{fprintf(yyout, "FOR "); return(FOR);}
while				{fprintf(yyout, "WHILE "); return(WHILE);}
do					{fprintf(yyout, "DO "); return(DO);}
switch				{fprintf(yyout, "SWITCH"); return(SWITCH);}
case				{fprintf(yyout, "CASE"); return(CASE);}
return				{fprintf(yyout, "RETURN "); return(RETURN);}
true				{fprintf(yyout, "TRUE "); return(TRUE);}
false				{fprintf(yyout, "FALSE "); return(FALSE);}
break				{fprintf(yyout, "BREAK "); return(BREAK_ST);}
"#"include			{fprintf(yyout, "#INCLUDE "); return(INCLUDE);}		

"="					{fprintf(yyout," Op-asig= %s ", yytext);return('=');}
"/"					{fprintf(yyout," Op-div= %s ", yytext);return('/');}
":"					{fprintf(yyout," Op-dospuntos= %s ", yytext);return(':');}
"*"					{fprintf(yyout," Op-mult= %s ", yytext);return('*');}
"+"					{fprintf(yyout," Op-sum= %s ", yytext);return('+');}
"-"					{fprintf(yyout," Op-resta= %s ", yytext);return('-');}
"--"				{fprintf(yyout," Op-Decrementar= %s ", yytext);return(MINUST_OP);}
"++"				{fprintf(yyout," Op-Aumentar= %s ", yytext);return(INC_OP);}
"^"					{fprintf(yyout," Op-exp= %s", yytext);return('^');}
";"					{fprintf(yyout," Punto-coma= %s", yytext);return(';');}
"<="				{fprintf(yyout," Menor-igual= %s ", yytext);return(LESSEQ_OP);}
">="				{fprintf(yyout," Mayor-igual= %s ", yytext);return(GRETAEQ_OP);}
"<"					{fprintf(yyout," Menor= %s ", yytext);return('<');}
">"					{fprintf(yyout," Mayor= %s ", yytext);return('>');}
"=="				{fprintf(yyout," Igual= %s ", yytext);return(EQUAL);}
"!="				{fprintf(yyout," Diferente= %s ", yytext);return(DIF_OP);}
"&&"				{fprintf(yyout," Op-Y= %s",yytext);return(AND_OP);}
"||"				{fprintf(yyout," Op-O= %s",yytext);return(OR_OP);}
"!"					{fprintf(yyout," Op-No= %s",yytext);return('!');}
"("					{fprintf(yyout," parent-a= %s ", yytext);return('(');}
")"					{fprintf(yyout," parent-c= %s ", yytext);return(')');}
"{"					{fprintf(yyout," Inicio= %s\n", yytext);return('{');}
"}"					{fprintf(yyout," Fin= %s\n", yytext);return('}');}
" "					
","					{fprintf(yyout,",");return(',');}
"	"				{fprintf(yyout,"	");}

[t ]+
{abc}({abc}|{dig})*				{count(yytext);fprintf(yyout," ID=%s",yytext);return(IDENTIFICADOR);}
{dig}+							{fprintf(yyout,"Cte entera= %s ", yytext);return(ENTERO);}
{dig}+("."{dig}*)?({exp})?		{fprintf(yyout,"Cte real= %s ", yytext);return(REAL);}
{opcl}.*{opcl} 					{fprintf(yyout,"Cte cadena= %s ",yytext);return(STRING);}
"//".*     						{fprintf(yyout,"COMENTARIO DE LÍNEA INDEPENDIENTE");return(COMENTARIO1);}
"/*".*"*/"     					{fprintf(yyout,"COMENTARIO DE  LÍNEA");return(COMENTARIO2);}
[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/] 	{
								fprintf(yyout,"COMENTARIO DE BLOQUE");return(COMENTARIO3);}
[/][*]							{fprintf(yyout,"COMENTARIO NO TERMINADO");return(COMENTARIO4);}
({abc}*)?({dig}*)?[$%&\@?¡¿#]({abc}*)?({dig}*)? 		{
								counter(yytext);fprintf(yyout,"error");}
"<"{abc}+"."{abc}+">"			{fprintf(yyout,"Librería = %s ", yytext);return(LIBRERIA);}
\n								lc++;

<<EOF>>							{idtable();errtable();return 0;}

%%
/*Procedimientos auxiliares*/


void idtable(){
	fprintf(yyout,"\n");
	fprintf(yyout,"TABLA DE IDENTIFICADORES: \n");
	fprintf(yyout,"Se encontraron %d identificadores \n", i);
	
	fprintf(yyout,"%s",id);
}

void errtable(){
	fprintf(yyout,"\n");
	fprintf(yyout,"TABLA DE ERRORES: \n");
	fprintf(yyout,"Se encontraron %d errores \n", j);
	
	fprintf(yyout,"%s",err);
}

void counter(const char* val){
	
	char e[100] = "  Error en: ";
	strcat(e, val);
	strcat(err, e);
	j++;
}

void count(const char* val){
	char a[100];
	char s[10] = " ID=";
	strcpy(b, id);
	strcat(a,val);
 	char *token;	
	bool sw = true;

	//obtengo cada id del array de id
	token = strtok(id, s);
   
	if(i == 0){
		strcpy(a,s);
		strcat(a,val); 
		strcat(id, a);
		i++;
	} else {
		while( token != NULL && sw ) {
		
       		if(strcoll(token, val) == 0){
				sw = false;
       		}
      		token = strtok(NULL, s);
   		}
		if(sw){
			strcpy(a,s);
			strcat(a,val);
           	strcat(b,a);
			i++;
       	}
	
		strcpy(id,b);		
	}	

}
