%{
#include <stdio.h>
#include <stdlib.h>
int yylex(void);
void yyerror(char* s);
extern int yylineno;
%}

// ---Do the Token assignments below----
%token MAIN
%token RETURN
%token PASS
%token IF
%token ELSE 
%token LP
%token RP
%token LB
%token RB 
%token UNDERSCORE
%token COMMA
%token DOT
%token INTEGER
%token COLON
%token COMMENT_SIGN
%token ASSING_OP
%token NEW_KEYWORD
%token SET
%token DELETE
%token BOOLEAN
%token CARTESIAN
%token ADD
%token UNION
%token IS_SUBSET
%token CONSOLE_IN
%token IS_SUPERSET
%token INTERSECTION
%token ELEMENT_IN
%token CONSOLE_OUT
%token CONTAIN_KEY
%token WHILE
%token FOR
%token FUNCTION
%token LOOP_ASSIGN_OP
%token EQUAL
%token NOT_EQUAL
%token GREATER_OR_EQUAL
%token LOWER_OR_EQUAL
%token GREATER
%token LOWER
%token OR
%token AND
%token IDENTIFIER
%token ALPHANUMERIC
%token SET_TYPE
%token END_STMT

//%start program
%start program
%right ASSIGN_OP

%%

//Start Rule

//Program
program:
	main

main:
	MAIN LP RP LB statements RB

statements: 
	statement
	|statements statement

statement:
	comment_line 
	|expr  
	|loops 
	|funct_dec
	|if_stmt




// ****** Comment Line *****
comment_symbol:
	COMMENT_SIGN
comment_line:
	comment_symbol comment_symbol
	|comment_symbol sentence comment_symbol

sentence:
	ALPHANUMERIC sentence
	| ALPHANUMERIC	
	
// ***** DECLERATIONS *****
expr:
	element_expr
	|int_expr
	|bool_expr
	|set_expr_list
	|indetifier_dec
	|fuct_call_dec
indetifier_dec:
	IDENTIFIER ASSING_OP IDENTIFIER END_STMT
fuct_call_dec:
	IDENTIFIER ASSING_OP funct_call END_STMT


element_expr:
	IDENTIFIER ASSING_OP ALPHANUMERIC END_STMT

int_expr:
	IDENTIFIER ASSING_OP INTEGER END_STMT
bool_expr:
	|IDENTIFIER ASSING_OP BOOLEAN END_STMT
	|IDENTIFIER ASSING_OP set_logical_expr END_STMT

set_expr_list:
	set_expr
	| set_delete_op
	| set_add_op
	|set_logical_expr
	|input_set_expr
	|input_element_expr
	|output_expr

set_expr:
	set_init
	|set_union_op
	|set_intersection_op
	|cartesian_expr

set_logical_expr:
	set_contain_expr
	|superset_expr
	|subset_expr


set_contain_expr: 
	SET_TYPE DOT CONTAIN_KEY LP IDENTIFIER RP END_STMT
	|SET_TYPE DOT CONTAIN_KEY LP ALPHANUMERIC RP END_STMT
	|SET_TYPE DOT CONTAIN_KEY LP INTEGER RP END_STMT

superset_expr:
	// $set.isSuperset($set)
	SET_TYPE DOT IS_SUPERSET LP SET_TYPE RP END_STMT
subset_expr:
	// $set.isSubset($set)
	SET_TYPE DOT IS_SUBSET LP SET_TYPE RP END_STMT


// ***** INITIALIZE *****
set_init: 
	// $set <== new Set
	SET_TYPE ASSIGN_OP NEW_KEYWORD SET END_STMT


// ***** SETS *****
set_add_op:
	// $set.add(identifier)
	SET_TYPE DOT ADD LP IDENTIFIER RP END_STMT
	|SET_TYPE DOT ADD LP ALPHANUMERIC RP END_STMT
	|SET_TYPE DOT ADD LP INTEGER RP END_STMT

set_delete_op:
	// $set.delete();
	SET_TYPE DOT DELETE LP RP END_STMT

set_union_op:
	// $set1<==$set2.union($set3);
	SET_TYPE ASSIGN_OP SET_TYPE DOT UNION LP SET_TYPE RP END_STMT

set_intersection_op:
	// $set1<==$set2.intersection($set3);
	SET_TYPE ASSIGN_OP SET_TYPE DOT INTERSECTION LP SET_TYPE RP END_STMT
cartesian_expr:
	// $set1<==$set2.cartesian($set2,$set3);
	SET_TYPE ASSIGN_OP SET_TYPE DOT CARTESIAN LP SET_TYPE COMMA SET_TYPE RP END_STMT
	
// ******* LOOPS *********
loops:
	while_stmt
	|for_stmt 

while_stmt: 
	// while(logical_expr){block_stmts}
	WHILE LP logical_expr RP LB block_stmts RB

for_stmt: 
	// for(i=12:200){block_stmts}
	FOR LP IDENTIFIER LOOP_ASSIGN_OP INTEGER COLON INTEGER LB block_stmts RB 


block_stmts:
	// pass;
	// return;
	PASS END_STMT
	|RETURN END_STMT

logical_expr: 
	// 4 < 89
	// true && false
	// a >= b
	INTEGER LOWER INTEGER
	|INTEGER GREATER INTEGER 
	|INTEGER LOWER_OR_EQUAL INTEGER 
	|INTEGER GREATER_OR_EQUAL INTEGER 
	|IDENTIFIER LOWER IDENTIFIER
	|IDENTIFIER GREATER IDENTIFIER
	|IDENTIFIER LOWER_OR_EQUAL IDENTIFIER
	|IDENTIFIER GREATER_OR_EQUAL IDENTIFIER
	|IDENTIFIER AND IDENTIFIER
	|IDENTIFIER OR IDENTIFIER
	|BOOLEAN AND BOOLEAN
	|BOOLEAN OR BOOLEAN
	|BOOLEAN EQUAL BOOLEAN
	|BOOLEAN NOT_EQUAL BOOLEAN
	|IDENTIFIER EQUAL IDENTIFIER
	|IDENTIFIER NOT_EQUAL IDENTIFIER

//********* If Statement ******//
if_stmt:
	IF LP logical_expr RP LB block_stmts RB
//******** FUnction ********//
funct_dec:
	FUNCTION IDENTIFIER LP args RP LB block_stmts RB
funct_call:
	IDENTIFIER LP funct_call_args RP
args:
	IDENTIFIER
	|
	|composite_args
composite_args:
	IDENTIFIER COMMA composite_args
	|IDENTIFIER
funct_call_arg_type:
 	IDENTIFIER
	|BOOLEAN
	|INTEGER
	|ALPHANUMERIC
funct_call_args:
	funct_call_arg_type
	|funct_call_args COMMA funct_call_arg_type
// ******* INPUTS ********
input_set_expr:
	// $set1 <== inputElements();
	SET_TYPE ASSIGN_OP CONSOLE_IN LP RP END_STMT
	
input_element_expr:
 	// $set1.input();
	SET_TYPE DOT ELEMENT_IN LP RP END_STMT

// ******* OUTPUTS ********
output_expr:
 	// $set1.print();
	SET_TYPE DOT CONSOLE_OUT LP RP END_STMT

%%



void yyerror(char *s) {
	fprintf(stdout, "line %d: %s\n", yylineno,s);
}
int main(void){
 yyparse();
if(yynerrs < 1){
		printf("Parsing: SUCCESSFUL!\n");
	}
 return 0;
}

