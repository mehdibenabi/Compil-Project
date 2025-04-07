
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     MC_DATA = 258,
     MC_END = 259,
     MC_CODE = 260,
     MC_VECTOR = 261,
     MC_INT = 262,
     MC_CHAR = 263,
     MC_STR = 264,
     MC_FLOAT = 265,
     MC_CST = 266,
     MC_READ = 267,
     MC_DISPLAY = 268,
     MC_AND = 269,
     MC_OR = 270,
     MC_NOT = 271,
     MC_G = 272,
     MC_L = 273,
     MC_GE = 274,
     MC_LE = 275,
     MC_EQ = 276,
     MC_DI = 277,
     MC_IF = 278,
     MC_ELSE = 279,
     MC_FOR = 280,
     MC_TRUE = 281,
     MC_FALSE = 282,
     VRG = 283,
     AFF = 284,
     PLUS = 285,
     MOIN = 286,
     MULT = 287,
     DIV = 288,
     PVG = 289,
     DEPOINT = 290,
     PAR_OUV = 291,
     PAR_FER = 292,
     CRO_OUV = 293,
     CRO_FER = 294,
     ACC_OUV = 295,
     ACC_FER = 296,
     PERCENT = 297,
     DOLAR = 298,
     DIAZ = 299,
     AND_COM = 300,
     AROB = 301,
     point = 302,
     apos = 303,
     dbl_apos = 304,
     INT_CST = 305,
     FLOAT_CST = 306,
     CHAR_CST = 307,
     STRING_CST = 308,
     IDF = 309,
     BAR = 310
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 13 "syntax.y"

    int entier;
    float reel;
    char* str;



/* Line 1676 of yacc.c  */
#line 115 "syntax.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


