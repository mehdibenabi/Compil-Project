%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    extern int yyligne;
    extern int yycolno;

    int yylex();
    int yyerror(char* msg);
    char sauvType[20];
%}

%union{
    int entier;
}

%token MC_DATA MC_END MC_CODE MC_VECTOR MC_INT MC_CHAR MC_STR MC_FLOAT MC_CST MC_READ MC_DISPLAY MC_AND MC_OR MC_NOT MC_G MC_L MC_GE MC_LE MC_EQ MC_DI MC_IF MC_ELSE MC_FOR MC_TRUE MC_FALSE VRG AFF PLUS MOIN MULT DIV PVG DEPOINT PAR_OUV PAR_FER CRO_OUV CRO_FER ACC_OUV ACC_FER PERCENT DOLAR DIAZ AND_COM AROB point apos dbl_apos INT_CST FLOAT_CST CHAR_CST STRING_CST IDF BAR FORMAT_AMP FORMAT_HASH FORMAT_DOLLAR FORMAT_PERCENT

/* Définition des priorités et des associativités pour résoudre les conflits */
%left MC_OR
%left MC_AND
%right MC_NOT
%nonassoc MC_G MC_L MC_GE MC_LE MC_EQ MC_DI
%left PLUS MOIN
%left MULT DIV
%nonassoc UMINUS

%%

S: IDF MC_DATA list_dec MC_END MC_CODE list_code MC_END MC_END  
    {  
        printf("Programme valide\n");
        YYACCEPT;
    }
;

list_dec: dec_var list_dec 
        | dec_cst list_dec
        | dec_vec list_dec 
        | /* epsilon */
;

type: MC_INT 
    | MC_CHAR 
    | MC_STR 
    | MC_FLOAT
;

dec_var: type DEPOINT list_var PVG
;

list_var: IDF 
        | IDF BAR list_var 
;

dec_cst: MC_CST DEPOINT IDF AFF idf_cst PVG
;

idf_cst: INT_CST 
       | FLOAT_CST 
       | CHAR_CST 
       | STRING_CST
;

dec_vec: MC_VECTOR DEPOINT IDF CRO_OUV INT_CST VRG INT_CST DEPOINT type CRO_FER PVG
;

expression_arth: IDF
                | idf_cst
                | expression_arth PLUS expression_arth
                | expression_arth MOIN expression_arth
                | expression_arth MULT expression_arth
                | expression_arth DIV expression_arth
                | PAR_OUV expression_arth PAR_FER
;

expression_log: expression_comp
              | expression_log  MC_AND expression_comp
              | expression_log  MC_OR expression_comp
              | expression_log_not
;

expression_log_not: MC_NOT PAR_OUV expression_log PAR_FER
;

expression_comp: expression_arth
               | expression_arth  MC_G expression_arth
               | expression_arth  MC_L expression_arth
               | expression_arth  MC_GE expression_arth
               | expression_arth  MC_LE expression_arth
               | expression_arth  MC_EQ expression_arth
               | expression_arth  MC_DI expression_arth
;

inst_aff: IDF AFF expression_arth PVG ;

inst_read: MC_READ PAR_OUV STRING_CST DEPOINT AROB IDF PAR_FER PVG
;

inst_display: MC_DISPLAY PAR_OUV STRING_CST DEPOINT IDF PAR_FER PVG
;

inst_if: MC_IF PAR_OUV expression_log PAR_FER DEPOINT list_code MC_ELSE DEPOINT list_code MC_END 
       | MC_IF PAR_OUV expression_log PAR_FER DEPOINT list_code MC_END
;

inst_for: MC_FOR PAR_OUV IDF DEPOINT INT_CST DEPOINT IDF PAR_FER list_code MC_END
;

list_code: inst_aff list_code
        | inst_read list_code
        | inst_display list_code
        | inst_if list_code
        | inst_for list_code
        | expression_log_not list_code
        | expression_comp list_code
        | /* epsilon */
;

%%
int yyerror(char*msg)
{
    printf("Erreur syntaxique: %s à la ligne %d et colonne %d\n",msg,yyligne,yycolno);
    return 1;
}

int main() {
    yyparse();
    return 0;
}








