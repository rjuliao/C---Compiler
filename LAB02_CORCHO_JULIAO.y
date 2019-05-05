%{
    #include <stdio.h>
    extern FILE *yyin, *yyout;
    extern int lc;
    extern char *yytext;
%}

%token INT FLOAT CHAR DOUBLE
%token MAIN VOID
%token RETURN
%token LIBRERIA INCLUDE
%token PRINTF SCANF
%token IF ELSE FOR WHILE DO SWITCH CASE BREAK_ST
%token TRUE FALSE
%token LESSEQ_OP GRETAEQ_OP EQUAL DIF_OP AND_OP OR_OP MINUST_OP INC_OP
%token IDENTIFICADOR ENTERO REAL STRING
%token COMENTARIO1 COMENTARIO2 COMENTARIO3 COMENTARIO4

%start init

%%

init 
    : INCLUDE LIBRERIA init
    | init func_dcl 
    | func_dcl
    ;

func_dcl
    : specific_type key_word parameters block
    ;

block
    : '{' '}'
    | '{' statementb_list '}'
    | '{' statementb_list RETURN '}'
    ;

statementb_list
    : expression_st
    | conditional_st
    | loop_st
    | ps_st
    ;

expression_st
    : ';'
    | assg_st ';'
    | assig_st ';'
    | assg_sst ';'
    ;

conditional_st
    : IF '(' expression ')' block
    | IF '(' expression ')' block ELSE block
    | SWITCH '(' expression ')' sw_st
    ;

loop_st
    : WHILE '(' expression ')' block
    | DO block WHILE '(' expression ')' ';'
    | FOR '(' assg_st ';' compare_exp ';' incdec_exp  ')' block
    ;

ps_st
    : PRINTF '(' var_bf STRING var_aft ')' ';'
    | SCANF '(' STRING var_aft ')' ';'
    ;

//------------------------------------------------------------------------------------------------

expression
    : conditional_expr
    | compare_exp
    ;

compare_exp
    : '(' compare_exp ')'
    | expression_simple LESSEQ_OP expression_simple
    | expression_simple GRETAEQ_OP expression_simple
    | expression_simple DIF_OP expression_simple
    | expression_simple EQUAL expression_simple
    | expression_simple '<' expression_simple
    | expression_simple '>' expression_simple
    | IDENTIFICADOR
    | conditional_expr
    ;

conditional_expr
    : or_expr
    | and_expr
    | no_exp
    ;

no_exp
    : '!' compare_exp
    ;

or_expr
    : compare_exp OR_OP compare_exp
    | OR_OP conditional_expr
    ;

and_expr
    : compare_exp AND_OP compare_exp
    | AND_OP conditional_expr
    ;

incdec_exp
    : MINUST_OP IDENTIFICADOR
    | INC_OP IDENTIFICADOR
    ;

sw_st
    : sw_st CASE expression_simple ':' statementb_list BREAK_ST
    | CASE expression_simple ':' statementb_list BREAK_ST
    ;

var_aft
    : ',' IDENTIFICADOR
    | var_aft ',' IDENTIFICADOR
    |
    ;

var_bf 
    : IDENTIFICADOR ','
    |
    ;

assg_st
    : specific_type IDENTIFICADOR
    | assg_st '=' expression_simple
    | assg_st '=' assig_st
    | assg_st ',' assg_st
    ;

assg_sst
    : IDENTIFICADOR '=' assig_st
    ;

assig_st
    : expression_simple
    | assig_st operator complex_assg
    ;

complex_assg
    : expression_simple
    | complex_assg operator complex_assg
    | complex_assg error complex_assg
    ;

operator
    : '*'
    | '+'
    | '-'
    | '/'
    | '^'
    ;

expression_simple
    : STRING
    | ENTERO
    | REAL
    | IDENTIFICADOR
    ;

specific_type
    : VOID
    | INT
    | FLOAT
    | CHAR
    | DOUBLE
    |
    ;

key_word
    : IDENTIFICADOR
    | MAIN
    ;

parameters
    : '(' statementp_list ')'
    | '(' ')'
    ;

statementp_list
    : specific_type IDENTIFICADOR
    | statementp_list ',' statementp_list
    | ',' error
    ;

%%

main(int argc, char** argv){

	
	if(!(yyin = fopen(argv[1], "r"))){
		perror("error: ");
		return(-1);
	}
	yyset_in(yyin);
	yyout = fopen("Salida.txt","w");	
	yyparse();
	fclose(yyin);
	
	return(0);
}


yyerror(char *s)
{
    fprintf(yyout,"Error en línea  %d, caracter: '%s' \n",lc, yytext);
    
}

yywrap(){
    return(1);
}