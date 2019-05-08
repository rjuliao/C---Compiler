%{
    #include <stdio.h>
    extern FILE *yyin, *yyout;
    extern int lc;
    extern char *yytext;
    extern int yyparse();
%}

%token INT FLOAT CHAR DOUBLE
%token MAIN VOID
%token RETURN
%token LIBRERIA INCLUDE
%token PRINTF SCANF
%token IF ELSE FOR WHILE DO SWITCH CASE BREAK_ST DEFAULT
%token TRUE FALSE
%token LESSEQ_OP GRETAEQ_OP EQUAL DIF_OP AND_OP OR_OP MINUST_OP INC_OP
%token IDENTIFICADOR ENTERO REAL STRING

%start init

%%

init: 
    INCLUDE LIBRERIA init
    | init func_dcl 
    | func_dcl
    ;

func_dcl: 
    specific_type key_word parameters block 
    ;

block: 
    '{' '}'
    | '{' list '}'
    | '{' list RETURN '}'
    ;

list: 
    statementb_list
    | list statementb_list
    ;

statementb_list: 
    expression_st
    | conditional_st
    | loop_st
    | s_st
    | p_st
    | sw_st
    ;


expression_st: 
    assg_st ';'   
    | assig_st ';'
    | assg_sst ';' 
    | incdec_exp ';'
    ;

conditional_st: 
    IF '(' expression ')' block
    | IF '(' expression ')' block ELSE block
    | SWITCH  expression  block
    ;

loop_st: 
    WHILE '(' expression ')' block
    | DO block WHILE '(' expression ')' ';'
    | FOR '(' assg_st ';' compare_exp ';' incdec_exp  ')' block
    ;

s_st: 
    SCANF '(' STRING var_aft ')' ';'
    ;

p_st: 
    PRINTF '(' STRING var_aft ')' ';'
    ;



//------------------------------------------------------------------------------------------------

expression: 
    conditional_expr
    | compare_exp
    ;

compare_exp: 
    '(' compare_exp ')'
    | expression_simple LESSEQ_OP expression_simple
    | expression_simple GRETAEQ_OP expression_simple
    | expression_simple DIF_OP expression_simple
    | expression_simple EQUAL expression_simple
    | expression_simple '<' expression_simple
    | expression_simple '>' expression_simple
    | IDENTIFICADOR
    | conditional_expr
    ;

conditional_expr: 
    or_expr
    | and_expr
    | no_exp
    ;

no_exp: 
    '!' compare_exp
    ;

or_expr: 
compare_exp OR_OP compare_exp
    | OR_OP conditional_expr
    ;

and_expr: 
    compare_exp AND_OP compare_exp
    | AND_OP conditional_expr
    ;

incdec_exp: 
    IDENTIFICADOR MINUST_OP 
    | IDENTIFICADOR INC_OP
    | MINUST_OP IDENTIFICADOR
    | IDENTIFICADOR INC_OP
    | IDENTIFICADOR '=' incdec_exp
    ;

sw_st: 
    CASE expression_simple ':' statementb_list BREAK_ST ';' sw_st
    | dftl
    ;

dftl: 
    DEFAULT ':' statementb_list BREAK_ST ';'
    | DEFAULT ':' BREAK_ST ';'
    |
    ;

var_aft
    : ',' IDENTIFICADOR
    | var_aft ',' IDENTIFICADOR
    |
    ;


assg_st: 
    specific_type IDENTIFICADOR
    | assg_st '=' expression_simple 
    | assg_st '=' assig_st
    | assg_st '=' anidar
    | assg_st ',' assg_st
    ;

assg_sst: 
    IDENTIFICADOR '=' assig_st
    | IDENTIFICADOR '=' anidar
    ;

assig_st: 
    expression_simple
    | assig_st operator complex_assg
    ;

anidar:
    '(' complex_assg ')'
    | anidar operator anidar
    ;

complex_assg: 
    expression_simple
    | complex_assg operator complex_assg
    | anidar operator complex_assg
    | complex_assg operator anidar
    ;

operator: 
    '*'
    | '+'
    | '-'
    | '/'
    | '^'
    ;

expression_simple: 
    STRING
    | ENTERO
    | REAL
    | IDENTIFICADOR 
    ;

specific_type:
    VOID
    | INT
    | FLOAT
    | CHAR
    | DOUBLE
    |
    ;

key_word:
    IDENTIFICADOR
    | MAIN
    ;

parameters:
    '(' statementp_list ')'
    | '(' ')'
    ;

statementp_list:
    specific_type IDENTIFICADOR
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
    fprintf(yyout,"Error Sintactico en línea  %d, caracter: '%s'.", lc, yytext);
    
}

yywrap(){
    return(1);
}

