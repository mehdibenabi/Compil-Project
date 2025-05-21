%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "syntax.tab.h"
    #include "table_symbole.h"
    #include "pgm.h"

    extern int nb_ligne;
    extern int nb_colonne;

    extern YYSTYPE yylval;
%}
lettre [a-z]
chiffre [0-9]
IDF [A-Z]({lettre}|{chiffre})*
INT_CST    (\([+-]?[0-9]+\))|([+-]?[0-9]+)
FLOAT_CST ({chiffre}+\.{chiffre}+)|(\([+-]{chiffre}+\.{chiffre}+\))
CHAR_CST '[a-zA-Z]'
STRING_CST \"[^\"]*\"
COMMENT \§.*

%%
"DATA"       {  int len = strlen(yytext);nb_colonne=nb_colonne+len; insert(yytext, "MC_DATA", "", 2); return MC_DATA;}
"END"        { int len = strlen(yytext);nb_colonne=nb_colonne+len; insert(yytext, "MC_END", "", 2);return MC_END;}
"CODE"       { int len = strlen(yytext);nb_colonne=nb_colonne+len; insert(yytext, "MC_CODE", "", 2);return MC_CODE;}
"VECTOR"     { int len = strlen(yytext);nb_colonne=nb_colonne+len;yylval.str="Vector"; insert(yytext, "MC_VECTOR", "", 2);return MC_VECTOR;}
"INTEGER"    {  int len = strlen(yytext);nb_colonne=nb_colonne+len;yylval.str="Integer"; insert(yytext, "MC_INT", "", 2); return MC_INT;}
"CHAR"       {  int len = strlen(yytext);nb_colonne=nb_colonne+len;yylval.str="char" ;insert(yytext, "MC_CHAR", "", 2);  return MC_CHAR;}
"STRING"     { int len = strlen(yytext);nb_colonne=nb_colonne+len;yylval.str="String"; insert(yytext, "MC_STR", "", 2); return MC_STR;}
"FLOAT"      { int len = strlen(yytext);nb_colonne=nb_colonne+len;yylval.str="Float" ;insert(yytext, "MC_FLOAT", "", 2);return MC_FLOAT;}
"CONST"      { int len = strlen(yytext);nb_colonne=nb_colonne+len;yylval.str="Constant"; insert(yytext, "MC_CST", "", 2);return MC_CST;}
"READ"       { int len = strlen(yytext);nb_colonne=nb_colonne+len; insert(yytext, "MC_READ", "", 2); return MC_READ;}
"DISPLAY"    { int len = strlen(yytext);nb_colonne=nb_colonne+len; insert(yytext, "MC_DISPLAY", "", 2);  return MC_DISPLAY;}
"IF"         { int len = strlen(yytext);nb_colonne=nb_colonne+len; insert(yytext, "MC_IF", "", 2);return MC_IF;}
"ELSE"       { int len = strlen(yytext);nb_colonne=nb_colonne+len; insert(yytext, "MC_ELSE", "", 2);return MC_ELSE;}
"FOR"        { int len = strlen(yytext);nb_colonne=nb_colonne+len; insert(yytext, "MC_FOR", "", 2); return MC_FOR;}
"TRUE"       { int len = strlen(yytext);nb_colonne=nb_colonne+len; insert(yytext, "MC_TRUE", "", 2); return MC_TRUE;}
"FALSE"      { int len = strlen(yytext);nb_colonne=nb_colonne+len; insert(yytext, "MC_FALSE", "", 2); return MC_FALSE;}



".AND."      {  int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, "and logique ", "", 1); return MC_AND;}
".OR."         { int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, "or logique ", "", 1);return MC_OR;}
".NOT."        { int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, "not logique ", "", 1); return MC_NOT;}
".G."          { int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, "grater then ", "", 1);return MC_G;}
".L."          { int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, "lower then ", "", 1);return MC_L;}
".GE."         { int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, "grater or equal ", "", 1);return MC_GE;}
".LE."         { int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, "lower or equal ", "", 1);return MC_LE;}
".EQ."         { int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, "equal ", "", 1);return MC_EQ;}
".DI."         { int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, "diffirent ", "", 1);return MC_DI;}
","          { int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, "virgule", "", 1);return VRG;}
"="          { int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, "affectation", "", 1);return AFF;}
"+"          { int len = strlen(yytext);nb_colonne=nb_colonne+len;yylval.str=strdup(yytext);insert(yytext, "operation de laddition ", "", 1);return PLUS;}
"-"          { int len = strlen(yytext);nb_colonne=nb_colonne+len;yylval.str=strdup(yytext);insert(yytext, "operation de la soustraction ", "", 1);return MOIN;}
"*"          { int len = strlen(yytext);nb_colonne=nb_colonne+len;yylval.str=strdup(yytext);insert(yytext, "opeartion de multiplication", "", 1);return MULT;}
"/"          { int len = strlen(yytext);nb_colonne=nb_colonne+len;yylval.str=strdup(yytext);insert(yytext, "operation de la division ", "", 1);return DIV;}
";"          { int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, "point virgule ", "", 1);return PVG;}
":"          { int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, "deux point ", "", 1);return DEPOINT;}
"("          { int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, " paronthes ouvrant ", "", 1); return PAR_OUV;}
")"          { int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, "üaronthes ferment ", "", 1);return PAR_FER;}
"["          { int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, "crouchi ouvrnate ", "", 1);return CRO_OUV;}
"]"          { int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, "crouchi ferment ", "", 1);return CRO_FER;}
"{"          { int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, "accolad ouvrant ", "", 1); return ACC_OUV;}
"}"          { int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, "accolad ferment ", "", 1);return ACC_FER;}
"%"          {  int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, "percentage %", "", 1);return PERCENT;}
"$"          {  int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, " dolar $", "", 1);return DOLAR;}
"#"          { int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, " diaz #", "", 1);return DIAZ;}
"|"          { int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, " bar | ", "", 1);return BAR;}
"&"          { int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, " and commerceille &", "", 1); return AND_COM;}
"@"          { int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, " arobaz @ ", "", 1);return AROB;}
"."          { int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, "point .", "", 1);return point;}
"'"          { int len = strlen(yytext);nb_colonne=nb_colonne+len;insert(yytext, "apostrophe  ' ", "", 1);return apos;}

{COMMENT}    {/* Ignore line comments */}
{INT_CST} {
    char temp[100];
    strcpy(temp, yytext);

    // Remove parentheses if they exist
    if (temp[0] == '(' && temp[strlen(temp) - 1] == ')') {
        temp[strlen(temp) - 1] = '\0'; // remove last ')'
        memmove(temp, temp + 1, strlen(temp)); // shift to remove first '('
    }

    int value = atoi(temp);
    if (value >= -32768 && value <= 32767) {
        yylval.entier = value;
        
        return INT_CST;
    } else {   
        printf("Integer constant out of range\n");
    }
}

{FLOAT_CST}  { return FLOAT_CST;}
{CHAR_CST}   { return CHAR_CST;}
{STRING_CST} { return STRING_CST;}
{IDF}        { int len = strlen(yytext);nb_colonne=nb_colonne+len;yylval.str=strdup(yytext);insert(yytext, "idf", "", 0);return IDF;}

[ \t]+           {int len = strlen(yytext);nb_colonne=nb_colonne+len; /* Ignore whitespace */ }
\n               { nb_ligne++;nb_colonne=0; }

.                { printf("Erreur lexiqual, line %d, colonne %d, entite: %s\n",nb_ligne,nb_colonne,yytext); }
%%