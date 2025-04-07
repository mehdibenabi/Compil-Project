%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "syntax.tab.h"
    #include "ts.h"
    int nb_ligne = 1;
    int yyligne=1;
    int yycolno=1;

    extern YYSTYPE yylval;
%}
lettre [a-z]
chiffre [0-9]
IDF [A-Z]({lettre}|{chiffre})*
INT_CST \([+-]{chiffre}+\)|{chiffre}+
FLOAT_CST ({chiffre}+,{chiffre}+)|(\([+-]{chiffre}+,{chiffre}+\))
CHAR_CST '.'
STRING_CST \".*\"
COMMENT \§.

%%
"DATA"       {printf("DATA"); return MC_DATA;}
"END"       {printf("END"); return MC_END;}
"CODE"       {printf("CODE"); return MC_CODE;}
"VECTOR"       {printf("VECTOR"); return MC_VECTOR;}
"INTEGER"       {printf("INTEGER"); return MC_INT;}
"CHAR"       {printf("CHAR"); return MC_CHAR;}
"STRING"       {printf("STRING"); return MC_STR;}
"FLOAT"       {printf("FLOAT"); return MC_FLOAT;}
"CONST"       {printf("CONST"); return MC_CST;}
"READ"       {printf("READ"); return MC_READ;}
"DISPLAY"       {printf("DISPLAY"); return MC_DISPLAY;}
"AND"       {printf("AND"); return MC_AND;}
"OR"        {printf("OR"); return MC_OR;}
"NOT"       {printf("NOT"); return MC_NOT;}
"G"       {printf(">"); return MC_G;}
"L"       {printf("<"); return MC_L;}
"GE"       {printf(">="); return MC_GE;}
"LE"       {printf("=<"); return MC_LE;}
"EQ"       {printf("="); return MC_EQ;}
"DI"       {printf("<>"); return MC_DI;}
"IF"       {printf("IF"); return MC_IF;}
"ELSE"       {printf("ELSE"); return MC_ELSE;}
"FOR"       {printf("FOR"); return MC_FOR;}
"TRUE"      {printf("true");return MC_TRUE;}
"FALSE"     {printf("false");return MC_FALSE;}
","         {printf("virgule");return VRG;}
"="         {printf("affectation");return AFF;}
"+"         {printf("plus");return PLUS; }
"-"         {printf("minus");return MOIN; }
"*"         {printf("times");return MULT; }
"/"         {printf("divide");return DIV; }
";"         {printf("point vergule");return PVG; }
":"         {printf("deux points");return DEPOINT; }
"("         {printf("left par"); return PAR_OUV; }
")"         {printf("right par"); return PAR_FER; }
"["         {printf("left croch"); return CRO_OUV; }
"]"         {printf("right croch"); return CRO_FER; }
"{"         {printf("left acco"); return ACC_OUV; }
"}"         {printf("right acco"); return ACC_FER; }
"%"         {printf("percentage");return PERCENT; }
"$"         {printf("dolar");return DOLAR; }
"#"         {printf("diaz");return DIAZ; }
"&"         {printf("and commercial");return AND_COM; }
"@"         {printf("@");return AROB; }
"\."        { printf(".\n");return point;}
"\'"        { printf("' ");return apos;}
"\""        { printf("\"");return dbl_apos; }

{COMMENT}   {printf("commentaire\n");}
{INT_CST}   {printf("int");return INT_CST;}
{FLOAT_CST}  {yylval.f = atof(yytext); return FLOAT_CST;}
{CHAR_CST}   {yylval.c = yytext[0]; return CHAR_CST;}
{STRING_CST} {yylval.s = yytext; return STRING_CST;}
{IDF}        {yylval.s = yytext; return IDF;}

[ \t] { nb_ligne++ ; yycolno++;} 
\n { yyligne++; yycolno=1; } 
. { yycolno++; printf("Erreur lexicale dans la ligne %d \n",nb_ligne);}
%%