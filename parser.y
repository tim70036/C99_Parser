
%{
    #include <stdio.h>
    #include <stdlib.h>
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
%token CASE DEFAULT DO WHILE FOR IF SWITCH
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

External_Declaration:   Function_Definition
                    |   Declaration
                    ;

Function_Definition:    Declaration_Specifiers Declarator Compound_Statement
                    |   Declaration_Specifiers Declarator Declaration_List Compound_Statement
                    ;

Declaration_List:   Declaration
                |   Declaration Declaration_List
                ;

Declaration:    Declaration_Specifiers ';'
           |    Declaration_Specifiers Init_Declarator_List ';'
           ;

Declaration_Specifiers: Type_Specifier
                      | Type_Qualifier
                      | Type_Specifier Declaration_Specifiers
                      | Type_Qualifier Declaration_Specifiers
                      ;

Init_Declarator_List: Init_Declarator
                    | Init_Declarator_List ',' Init_Declarator
                    ;

Init_Declarator:    Declarator
               |    Declarator '=' Initializer
               ;

Declarator:    ID
          |    Declarator '(' Identifier_List ')'
          |    Declarator '(' Parameter_List ')'
          |    Declarator '('   ')'
          |    Declarator '['   ']'
          |    Declarator '['  INT_CONSTANT  ']'
          ;

Parameter_List:    Declaration_Specifiers Declarator
                   |    Parameter_List ',' Declaration_Specifiers Declarator

Identifier_List:   ID
               |   Identifier_List  ',' ID
               ;

Initializer:   Assignment_Expression
           |   '{'  Initializer_List '}'
           |   '{'  Initializer_List ',' '}'
           ;

Initializer_List:   Initializer
                |   Initializer_List ',' Initializer
                ;

Type_Specifier:    VOID
              |    INT
              |    CHAR
              |    BOOL
              |    DOUBLE
              ;

Type_Qualifier:    CONST;












Compound_Statement:   '{' '}'
                  |   '{' Block_Item_List '}'
                  ;

Block_Item_List:    Block_Item
               |    Block_Item_List Block_Item
               ;

Block_Item:    Declaration
          |    Statement
          ;

Statement:    Labeled_Statement
         |    Compound_Statement
         |    Expression_Statement
         |    Selection_Statement
         |    Iteration_Statement
         |    Jump_Statement
         ;

Labeled_Statement:    CASE Conditional_Expression ':' Statement
                 |    DEFAULT ':' Statement
                 ;

Expression_Statement:   ';'
                    |   Expression ';'
                    ;

Selection_Statement:    IF '(' Expression ')' Statement
                   |    IF '(' Expression ')' Statement ELSE Statement
                   |    SWITCH '(' Expression ')' Statement
                   ;

Iteration_Statement:    WHILE '(' Expression ')' Statement
                   |    DO Statement WHILE '(' Expression ')' ';'
                   |    FOR '(' Expression_Statement Expression_Statement ')' Statement
                   |    FOR '(' Expression_Statement Expression_Statement Expression ')' Statement
                   ;

Jump_Statement:     CONTINUE ';'
              |     BREAK ';'
              |     RETURN Expression ';'
              |     RETURN ';'
              ;






Expression:   Assignment_Expression
          |   Expression ',' Assignment_Expression
          ;

Assignment_Expression:    Conditional_Expression
                     |    Unary_Expression Assignment_Operator Assignment_Expression
                     ;

Conditional_Expression:    Logical_Or_Expression
                      |    Logical_Or_Expression '?' Expression ':' Conditional_Expression
                      ;

Logical_Or_Expression:    Logical_And_Expression
                     |    Logical_Or_Expression OR_OP Logical_And_Expression
                     ;

Logical_And_Expression:    Equality_Expression
                      |    Logical_And_Expression AND_OP Equality_Expression
                      ;

Equality_Expression:    Relational_Expression
                   |    Equality_Expression EQUAL_OP Relational_Expression
                   |    Equality_Expression NEQUAL_OP Relational_Expression
                   ;

Relational_Expression:    Additive_Expression
                     |    Relational_Expression LT_OP Additive_Expression
                     |    Relational_Expression LE_OP Additive_Expression
                     |    Relational_Expression GT_OP Additive_Expression
                     |    Relational_Expression GE_OP Additive_Expression
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
                |    PLUSPLUS_OP Unary_Expression
                |    MINUSMINUS_OP Unary_Expression
                |    Unary_Operator Unary_Expression
                ;

Postfix_Expression:    Primary_Expression
                  |    Postfix_Expression PLUSPLUS_OP
                  |    Postfix_Expression MINUSMINUS_OP
                  |    Postfix_Expression '[' Expression ']'
                  |    Postfix_Expression '(' ')'
                  |    Postfix_Expression '(' Argument_Expression_List ')'
                  ;

Primary_Expression:    ID
                  |    INT_CONSTANT
                  |    DOUBLE_CONSTANT
                  |    STRING_CONSTANT
                  |    '(' Expression ')'
                  ;




Argument_Expression_List:    Assignment_Expression
                        |    Argument_Expression_List ',' Assignment_Expression
                        ;

Unary_Operator:    NOT_OP
              |    MINUS_OP
              ;

Assignment_Operator:    '=';

%%

int main(void) {
  yyparse();
  return 0;
}

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
