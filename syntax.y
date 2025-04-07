%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    extern int yyligne;
    extern int yycolno;

    int yylex();

    char sauvType [20];
%}

%union{
    int entier;
    float reel;
    char* str;
}

%token MC_DATA MC_END MC_CODE MC_VECTOR MC_INT MC_CHAR MC_STR MC_FLOAT MC_CST MC_READ MC_DISPLAY MC_AND MC_OR MC_NOT MC_G MC_L MC_GE MC_LE MC_EQ MC_DI MC_IF MC_ELSE MC_FOR MC_TRUE MC_FALSE VRG AFF PLUS MOIN MULT DIV PVG DEPOINT PAR_OUV PAR_FER CRO_OUV CRO_FER ACC_OUV ACC_FER PERCENT DOLAR DIAZ AND_COM AROB point apos dbl_apos INT_CST FLOAT_CST CHAR_CST STRING_CST IDF BAR

%%
S: IDF MC_DATA list_dec MC_END MC_CODE list_code MC_END MC_END
    {  
        YYACCEPT;
        printf("Programme valide\n");
    }
list_dec: dec_var | dec_cst | dec_vec;
type: MC_INT | MC_CHAR | MC_STR | MC_FLOAT;
dec_var: type DEPOINT list_var PVG dec_var| type DEPOINT list_var PVG;
list_var: IDF | IDF BAR list_var;
dec_cst: MC_CST DEPOINT IDF AFF idf_cst PVG |MC_CST DEPOINT IDF AFF idf_cst PVG dec_cst;
idf_cst: INT_CST | FLOAT_CST | CHAR_CST | STRING_CST;
dec_vec: MC_VECTOR DEPOINT IDF CRO_OUV INT_CST VRG INT_CST DEPOINT type CRO_FER PVG |MC_VECTOR DEPOINT IDF CRO_OUV INT_CST VRG INT_CST DEPOINT type CRO_FER PVG  dec_vec;
operand: PLUS | MOIN | MULT | DIV;
operand_log: MC_AND | MC_OR;
liste_epression_arth: expression_arth PVG liste_epression_arth | expression_arth PVG;
expression_arth : PAR_OUV liste_epression_arth PAR_FER operand liste_epression_arth 
                | idf_cst operand idf_cst | expression_arth operand expression_arth
                | PAR_OUV expression_arth PAR_FER 
                | idf_cst ;
liste_expression_log : expression_log PVG liste_expression_log | expression_log PVG;
expression_log : PAR_OUV liste_expression_log PAR_FER point operand_log point  liste_expression_log 
                | expression_log point operand_log point  expression_log
                | PAR_OUV expression_log PAR_FER
                | idf_cst point operand_log point idf_cst
                |MC_NOT expression_log
                | idf_cst;
%%
int yyerror(char*msg)
{
      printf("Erreur syntaxique: %s à la ligne %d et colonne %d\n",msg,yyligne,yycolno);
	return 1;
}
int main (){
    yyparse();
    }
int yywrap(){
   return 1;
}
