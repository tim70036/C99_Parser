
%{
    #include <stdio.h>
    #include <stdlib.h>

    int FunctionNum = 0;
    int FunctionCall = 0;
%}

%start Translation_Unit

%left PLUSPLUS_OP MINUSMINUS_OP
%left MUL_OP DIV_OP MOD_OP
%left MINUS_OP PLUS_OP
%left LT_OP LE_OP GT_OP GE_OP EQUAL_OP NEQUAL_OP
%left NOT_OP
%left AND_OP
%left OR_OP

%token VOID INT CHAR BOOL DOUBLE CONST NUL STRUCT TRUE FALSE
%token CASE DEFAULT DO WHILE FOR IF ELSE SWITCH
%token CONTINUE BREAK RETURN
%token INT_CONSTANT
%token DOUBLE_CONSTANT
%token CHAR_CONSTANT
%token STRING_CONSTANT
%token ID
/*%token ';' '=' '{' '}' '[' ']' '?' ':' ','*/

%%

Translation_Unit:   External_Declaration
                |   Translation_Unit External_Declaration
                ;

External_Declaration:   Function_Definition { FunctionNum++; }
                    |   Declaration
                    ;

Function_Definition:    Non_Void_Type_Specifier ID '(' ')' Compound_Statement
                   |    Non_Void_Type_Specifier ID '(' Parameter_List ')' Compound_Statement
                   |    VOID ID '(' ')' Compound_Statement
                   |    VOID ID '(' Parameter_List ')' Compound_Statement
                   ;

Declaration:    Function_Declaration
           |    Const_Declaration
           |    Normal_Declaration
           ;

Function_Declaration:    Non_Void_Type_Specifier ID '(' ')' ';'
                    |    Non_Void_Type_Specifier ID '(' Parameter_List ')' ';'
                    |    VOID ID '(' ')' ';'
                    |    VOID ID '(' Parameter_List ')' ';'
                    ;

Const_Declaration:    CONST Non_Void_Type_Specifier Const_Declarator_List ';'
                 ;

Const_Declarator_List:    Const_Declarator
                     |    Const_Declarator_List ',' Const_Declarator
                     ;

Const_Declarator:    ID '=' INT_CONSTANT
                |    ID '=' DOUBLE_CONSTANT
                |    ID '=' CHAR_CONSTANT
                |    ID '=' STRING_CONSTANT
                |    ID '=' TRUE
                |    ID '=' FALSE
                ;

Normal_Declaration:    Non_Void_Type_Specifier Normal_Declarator_List ';'
                  ;

Normal_Declarator_List:    Normal_Declarator
                      |    Normal_Declarator_List ',' Normal_Declarator
                      ;

Normal_Declarator:    ID
                 |    Array
                 |    ID '=' Expression
                 |    Array '=' Array_Content
                 ;


Parameter_List:    Parameter
              |    Parameter_List ',' Parameter
              ;

Parameter:    Non_Void_Type_Specifier ID
         |    Non_Void_Type_Specifier Array
         ;

Array:   ID Array_Paranthesis
      ;

Array_Paranthesis:    '[' INT_CONSTANT ']'
                 |    Array_Paranthesis '[' INT_CONSTANT ']'
                 ;

Array_Content:    '{' '}'
             |    '{' Expression_List '}'
             ;

Array_Expression:    '[' Expression ']'
                |    Array_Expression '[' Expression ']'
                ;

Var:    ID
   |    ID Array_Expression
   ;

Non_Void_Type_Specifier:    INT
                       |    CHAR
                       |    BOOL
                       |    DOUBLE
                       ;






Compound_Statement:   '{' '}'
                  |   '{' Block_Item_List '}'
                  ;

Block_Item_List:    Block_Item
               |    Block_Item_List Block_Item
               ;

Block_Item:    Declaration
          |    Statement
          ;

Statement:    Simple_Statement
         |    Switch_Statement
         |    Selection_Statement
         |    Iteration_Statement
         |    Jump_Statement
         ;

Simple_Statement:    Var '=' Expression ';'
                ;

Switch_Statement:    SWITCH '(' ID ')' '{' Switch_Content '}'
                ;

Switch_Content:    Case_List
              |    Case_List  Default_Content
              ;

Case_List:    Case_Content
         |    Case_List Case_Content
         ;

Case_Content:     CASE INT_CONSTANT ':' Statement_List
            |     CASE CHAR_CONSTANT ':' Statement_List
            |     CASE INT_CONSTANT ':'
            |     CASE CHAR_CONSTANT ':'
            ;

Default_Content:    DEFAULT ':' Statement_List
               |    DEFAULT ':'
               ;

Statement_List:    Statement
              |    Statement_List Statement
              ;

Selection_Statement:    IF '(' Expression ')' Compound_Statement
                   |    IF '(' Expression ')' Compound_Statement ELSE Compound_Statement
                   ;

Iteration_Statement:    WHILE '(' Expression ')' Compound_Statement
                   |    DO Compound_Statement WHILE '(' Expression ')' ';'
                   |    FOR '(' Expression_Statement Expression_Statement ')' Compound_Statement
                   |    FOR '(' Expression_Statement Expression_Statement Expression ')' Compound_Statement
                   ;

Expression_Statement:   ';'
                    |   Expression ';'
                    ;

Jump_Statement:     CONTINUE ';'
              |     BREAK ';'
              |     RETURN Expression ';'
              |     RETURN ';'
              ;






Expression:   Conditional_Expression
          ;

Conditional_Expression:    Logical_Or_Expression
                      |    Logical_Or_Expression '?' Expression ':' Conditional_Expression
                      ;

Logical_Or_Expression:    Logical_And_Expression
                     |    Logical_Or_Expression OR_OP Logical_And_Expression
                     ;

Logical_And_Expression:    Not_Expression
                      |    Logical_And_Expression AND_OP Not_Expression
                      ;

Not_Expression:    Relational_Expression
              |    NOT_OP Relational_Expression
              ;

Relational_Expression:    Additive_Expression
                     |    Relational_Expression LT_OP Additive_Expression
                     |    Relational_Expression LE_OP Additive_Expression
                     |    Relational_Expression GT_OP Additive_Expression
                     |    Relational_Expression GE_OP Additive_Expression
                     |    Relational_Expression EQUAL_OP Additive_Expression
                     |    Relational_Expression NEQUAL_OP Additive_Expression
                     ;

Additive_Expression:    Multiplicative_Expression
                   |    Additive_Expression PLUS_OP Multiplicative_Expression
                   |    Additive_Expression MINUS_OP Multiplicative_Expression
                   ;

Multiplicative_Expression:    Unary_Expression
                         |    Multiplicative_Expression MUL_OP Unary_Expression
                         |    Multiplicative_Expression DIV_OP Unary_Expression
                         |    Multiplicative_Expression MOD_OP Unary_Expression
                         ;

Unary_Expression:    Postfix_Expression
                |    MINUS_OP Postfix_Expression
                ;

Postfix_Expression:    Primary_Expression
                  |    Primary_Expression PLUSPLUS_OP
                  |    Primary_Expression MINUSMINUS_OP
                  ;

Primary_Expression:    Var
                  |    INT_CONSTANT
                  |    DOUBLE_CONSTANT
                  |    CHAR_CONSTANT
                  |    STRING_CONSTANT
                  |    TRUE
                  |    FALSE
                  |    '(' Expression ')'
                  |    ID '(' ')'
                  |    ID '(' Expression_List ')'
                  ;

Expression_List:    Expression
               |    Expression_List ',' Expression
               ;

%%

extern int numL;
extern char buf[1000];
extern char *yytext;

int yyerror( char *msg ) {
	fprintf( stderr, "*** Error at line %d: %s\n", numL, buf );
	fprintf( stderr, "\n" );
	fprintf( stderr, "Unmatched token: %s\n", yytext );
	fprintf( stderr, "*** syntax error\n");
	exit(-1);
}

int main(void) {
  yyparse();
  if (FunctionNum == 0) yyerror(NULL);
  printf("No syntax error!\n");
  return 0;
}
