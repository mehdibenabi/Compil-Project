%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    extern int yyligne;
    extern int yycolno;

    int yylex();
    void yyerror(char *s){
        printf("erreur syntaxique dans la ligne %d et dans la colonne %d\n",yyligne,yycolno);
    }

    char sauvType [20];
%}

%union{
    int entier;
    float reel;
    char* str;
}

%token MC_DATA MC_END MC_CODE MC_VECTOR MC_INT MC_CHAR MC_STR MC_FLOAT MC_CST MC_READ MC_DISPLAY MC_AND MC_OR MC_NOT MC_G MC_L MC_GE MC_LE MC_EQ MC_DI MC_IF MC_ELSE MC_FOR MC_TRUE MC_FALSE VRG AFF PLUS MOIN MULT DIV PVG DEPOINT PAR_OUV PAR_FER CRO_OUV CRO_FER ACC_OUV ACC_FER PERCENT DOLAR DIAZ AND_COM AROB point apos dbl_apos INT_CST FLOAT_CST CHAR_CST STRING_CST IDF

%%
S: 
%%