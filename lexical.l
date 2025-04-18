%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "syntax.tab.h"

    int nb_ligne = 1;
    int yyligne = 1;
    int yycolno = 1;

    extern YYSTYPE yylval;
%}
lettre [a-z]
chiffre [0-9]
IDF [A-Z]({lettre}|{chiffre})*
INT_CST \([+-]{chiffre}+\)|{chiffre}+
FLOAT_CST ({chiffre}+,{chiffre}+)|(\([+-]{chiffre}+,{chiffre}+\))
CHAR_CST '[a-zA-Z]'
STRING_CST \"[^\"]*\"
COMMENT \§[^\n]

%%
"DATA"       { return MC_DATA;}
"END"        { return MC_END;}
"CODE"       { return MC_CODE;}
"VECTOR"     { return MC_VECTOR;}
"INTEGER"    { return MC_INT;}
"CHAR"       { return MC_CHAR;}
"STRING"     { return MC_STR;}
"FLOAT"      { return MC_FLOAT;}
"CONST"      { return MC_CST;}
"READ"       { printf("READ token recognized\n"); return MC_READ;}
"DISPLAY"    { printf("mot cle display\n "); return MC_DISPLAY;}
".AND."        { return MC_AND;}
".OR."         { return MC_OR;}
".NOT."        { return MC_NOT;}
".G."          { return MC_G;}
".L."          { return MC_L;}
".GE."         { return MC_GE;}
".LE."         { return MC_LE;}
".EQ."         { return MC_EQ;}
".DI."         { return MC_DI;}
"IF"         { return MC_IF;}
"ELSE"       { return MC_ELSE;}
"FOR"        { return MC_FOR;}
"TRUE"       { return MC_TRUE;}
"FALSE"      { return MC_FALSE;}

","          { return VRG;}
"="          { return AFF;}
"+"          { return PLUS;}
"-"          { return MOIN;}
"*"          { return MULT;}
"/"          { return DIV;}
";"          { return PVG;}
":"          { return DEPOINT;}
"("          {printf("par ouv \n"); return PAR_OUV;}
")"          { return PAR_FER;}
"["          { return CRO_OUV;}
"]"          { return CRO_FER;}
"{"          { return ACC_OUV;}
"}"          { return ACC_FER;}
"%"          { printf("PERCENT recognized\n"); return PERCENT;}
"$"          { printf("DOLLAR recognized\n"); return DOLAR;}
"#"          { printf("HASH recognized\n"); return DIAZ;}
"|"          { return BAR;}
"&"          { printf("AMPERSAND recognized\n"); return AND_COM;}
"@"          { return AROB;}
"."          { return point;}
"'"          { return apos;}

{COMMENT}    {printf("commentaire\n");}
{INT_CST}    { return INT_CST;}
{FLOAT_CST}  { return FLOAT_CST;}
{CHAR_CST}   { return CHAR_CST;}
{STRING_CST} { return STRING_CST;}
{IDF}        { return IDF;}

[ \t]       {yycolno++;}
\n          {yyligne++; yycolno=1;}
.           {yycolno++; printf("Erreur lexicale dans la ligne %d \n",nb_ligne);}
%%