%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdbool.h>
    #include "pile.h"
    // #include "table_symbole.h"
    extern int nb_ligne;
    extern int nb_colonne;

    int yylex();
    // int yyerror(char* msg);
    char saveType[20];
    char saveValue[20];
    char descValue[20];
    int check_division = 0;
    int i, j, taille, nb, and = 0, end_if, deb_else, fin_cond, fin_cond_while;
    char str[50], str1[50], op1[50], op2[50], res[100], end_AND[50], end_OR[50], deb_for[10];
    char tmp[20]; // Déclaration de tmp pour fix error

    pile* p = NULL;
    pile* q = NULL, *qdr_and = NULL, *qdr_or = NULL;
    int qc = 0; // Counter for quadruples, was undefined

    extern char* yytext; // Fixed type
    
    void yyerror(const char *s) {
        printf("Erreur syntaxique, line %d, colonne %d, entite %s\n", nb_ligne, nb_colonne, yytext);
    }

    // Function to create temporary variables
    char* creer_temp() {
        static int tmp_counter = 0;
        char* temp = (char*)malloc(10);
        sprintf(temp, "T%d", tmp_counter++);
        return temp;
    }

    // Declaration of quadr and ajour_quad functions
    void quadr(char* op, char* op1, char* op2, char* res);
    void ajour_quad(int pos, int col, char* val);

    // Helper function to create a proper string from an integer for the quadruples
    void assign_constant(char* var_name, int value) {
        char value_str[20];
        sprintf(value_str, "%d", value);  // Convert integer to string
        quadr("=", value_str, "vide", var_name);
    }
%}

%union{
    int entier;
    char* str;
    float reel;
    struct {
        char nom[50];
        char type[20];
    } exp;
}

%token MC_DATA MC_END MC_CODE <str>MC_VECTOR <str>MC_INT <str>MC_CHAR <str>MC_STR <str>MC_FLOAT <str>MC_CST MC_READ MC_DISPLAY MC_AND MC_OR MC_NOT MC_G MC_L MC_GE MC_LE MC_EQ MC_DI MC_IF MC_ELSE MC_FOR MC_TRUE MC_FALSE VRG AFF <str>PLUS <str>MOIN <str>MULT <str>DIV PVG DEPOINT PAR_OUV PAR_FER CRO_OUV CRO_FER ACC_OUV ACC_FER PERCENT DOLAR DIAZ AND_COM AROB point apos dbl_apos <entier>INT_CST <reel>FLOAT_CST <str>CHAR_CST <str>STRING_CST <str>IDF BAR FORMAT_AMP FORMAT_HASH FORMAT_DOLLAR FORMAT_PERCENT

%type <exp> expression
%type <exp> expression_log
%type <exp> expression_comp
%type <exp> expression_arth
%type <exp> idf_cst
%type <exp> debut_for
%type <str> debut_if

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
        printf("Programme correct lexicalement et syntaxiquement.\n");
        YYACCEPT;
    }
;

list_dec: dec_var list_dec 
        | dec_cst list_dec
        | dec_vec list_dec 
        | /* epsilon */
;

type: MC_INT {strcpy(saveType, $1);}
    | MC_CHAR {strcpy(saveType, $1);}
    | MC_STR {strcpy(saveType, $1);}
    | MC_FLOAT{strcpy(saveType, $1);}
;

dec_var: type DEPOINT list_var PVG
;

list_var: IDF {
    if(check_declaration($1)==0){
        insert_type($1, saveType);
    }else{
        printf("erreur semantique variable deja declaree, line %d, colonne %d, entite %s \n",nb_ligne,nb_colonne,$1);
    }
}
        | IDF BAR list_var  {
    if(check_declaration($1)==0){
        insert_type($1, saveType);
    }else{
        printf("erreur semantique variable deja declaree, line %d, colonne %d, entite %s \n",nb_ligne,nb_colonne,$1);
    }
}
;

dec_cst: MC_CST DEPOINT IDF AFF idf_cst PVG{
        
        if(check_cst($3)==-1){
            insert_type($3, saveType);
            insert_value($3, saveValue);
            set_cst($3);
        }else{
            printf("erreur semantique variable deja declaree constante, line %d, colonne %d, entite %s \n",nb_ligne,nb_colonne,$3);
        }
    }
;

idf_cst:
     INT_CST { 
        
        sprintf(saveValue, "%d", $1); 
        strcpy(saveType, "Integer"); 
        sprintf($$.nom, "%d", $1);
        strcpy($$.type, "Integer");
        sprintf(res, "%d", $1);
        empiler(&p, res); 
     }
   | FLOAT_CST { 
        
        sprintf(saveValue, "%.2f", $1); 
        strcpy(saveType, "Float");  
        sprintf($$.nom, "%.2f", $1);
        strcpy($$.type, "Float");
        sprintf(res, "%.2f", $1);
        empiler(&p, res);
     }
   | CHAR_CST { 
        
        saveValue[0] = $1[0]; // Fixed this assuming CHAR_CST is a string
        saveValue[1] = '\0'; 
        strcpy(saveType, "Char");
        strcpy($$.nom, $1);
        strcpy($$.type, "Char");
     }
   | STRING_CST { 
            
        int len = strlen($1);
        if (len >= 2) {
            strncpy(saveValue, $1 + 1, len - 2); // enlever les guillemets
            saveValue[len-2] = '\0';
        } else {
            strcpy(saveValue, "");
        }
        strcpy(saveType, "String");
        strcpy($$.nom, $1);
        strcpy($$.type, "String");
     }
;

dec_vec: MC_VECTOR DEPOINT IDF {
    if(check_declaration($3)==0){
        insert_type($3, saveType);
    }else{
        printf("erreur semantique variable deja declaree, line %d, colonne %d, entite %s \n",nb_ligne,nb_colonne,$3);
    }
     
} CRO_OUV INT_CST VRG INT_CST DEPOINT type CRO_FER PVG {
   int a = $6 + $8; // Using directly the int values
   sprintf(tmp, "%d", a);
   quadr("BOUNDS", "", "", tmp);
   quadr("ADEC", $3, "empty", "empty");
}
;

expression: expression_arth 
          | expression_log
;

expression_log: expression_comp
              | expression_log MC_AND expression_comp  { 
                  sprintf($$.nom, "and%d", qc);
                  strcpy($$.type, "Bool");
                  quadr("AND", $1.nom, $3.nom, $$.nom);
              }
              | expression_log MC_OR expression_comp { 
                  sprintf($$.nom, "or%d", qc);
                  strcpy($$.type, "Bool");
                  quadr("OR", $1.nom, $3.nom, $$.nom);
              }
              | MC_NOT PAR_OUV expression_log PAR_FER {
                  sprintf($$.nom, "not%d", qc);
                  strcpy($$.type, "Bool");
                  quadr("NOT", $3.nom, "", $$.nom);
              }
;

expression_comp: 
               expression_arth MC_G expression_arth {
                   sprintf($$.nom, "gt%d", qc);
                   strcpy($$.type, "Bool");
                   quadr(">", $1.nom, $3.nom, $$.nom);
               }
               | expression_arth MC_L expression_arth {
                   sprintf($$.nom, "lt%d", qc);
                   strcpy($$.type, "Bool");
                   quadr("<", $1.nom, $3.nom, $$.nom);
               }
               | expression_arth MC_GE expression_arth {
                   sprintf($$.nom, "ge%d", qc);
                   strcpy($$.type, "Bool");
                   quadr(">=", $1.nom, $3.nom, $$.nom);
               }
               | expression_arth MC_LE expression_arth {
                   sprintf($$.nom, "le%d", qc);
                   strcpy($$.type, "Bool");
                   quadr("<=", $1.nom, $3.nom, $$.nom);
               }
               | expression_arth MC_EQ expression_arth {
                   sprintf($$.nom, "eq%d", qc);
                   strcpy($$.type, "Bool");
                   quadr("==", $1.nom, $3.nom, $$.nom);
               }
               | expression_arth MC_DI expression_arth {
                   sprintf($$.nom, "ne%d", qc);
                   strcpy($$.type, "Bool");
                   quadr("!=", $1.nom, $3.nom, $$.nom);
               }
;

expression_arth : IDF  {
        if(check_declaration($1)==0){
            printf("erreur semantique variable non declaree, line %d, colonne %d, entite %s \n",nb_ligne,nb_colonne,$1);
        } else {
            
            if(get_type($1)==0){
                strcpy(saveType,"Integer");
                strcpy($$.type, "Integer");
            } else if(get_type($1)==1){
                strcpy(saveType,"Float");
                strcpy($$.type, "Float");
            }
        }
        // Check if it's a numeric value that's zero
        char *endptr;
        long val = strtol($1, &endptr, 10);
        if (*endptr == '\0' && val == 0) {
            check_division = 1;
        }
        
        // Check if it's a float value that's zero
        double fval = strtod($1, &endptr);
        if (*endptr == '\0' && fval == 0.0) {
            check_division = 1;
        }   
        strcpy($$.nom, $1);
        empiler(&p, $1); // Store in q stack for later use
    };
    |INT_CST { 
        sprintf(saveValue, "%d", $1); 
        strcpy(saveType, "Integer"); 
        sprintf($$.nom, "%d", $1);
        strcpy($$.type, "Integer");
        sprintf(res, "%d", $1);
        empiler(&p, res); 
     }
   | FLOAT_CST { 
        sprintf(saveValue, "%.2f", $1); 
        strcpy(saveType, "Float");  
        sprintf($$.nom, "%.2f", $1);
        strcpy($$.type, "Float");
        sprintf(res, "%.2f", $1);
        empiler(&p, res);
     }
   | CHAR_CST { 
        saveValue[0] = $1[0]; // Fixed this assuming CHAR_CST is a string
        saveValue[1] = '\0'; 
        strcpy(saveType, "Char");
        strcpy($$.nom, $1);
        strcpy($$.type, "Char");
        
     }
   | STRING_CST { 
        int len = strlen($1);
        if (len >= 2) {
            strncpy(saveValue, $1 + 1, len - 2); // enlever les guillemets
            saveValue[len-2] = '\0';
        } else {
            strcpy(saveValue, "");
        }
        strcpy(saveType, "String");
        strcpy($$.nom, $1);
        strcpy($$.type, "String");
        
     };
    
    | expression_arth PLUS expression_arth {
        
        strcpy(op2, depiler(&p));
        strcpy(op1, depiler(&p));
        strcpy(res, "");
        sprintf(res, "t%d", qc); // Create temporary result
        quadr("+", op1, op2, res);
        empiler(&p, res);
        strcpy($$.nom, res);
        
        // Handle types
        if (strcmp($1.type, "Float") == 0 || strcmp($3.type, "Float") == 0) {
            strcpy($$.type, "Float");
        } else {
            strcpy($$.type, "Integer");
        }
    }
    | expression_arth MOIN expression_arth {
        
        strcpy(op2, depiler(&p));
        strcpy(op1, depiler(&p));
        strcpy(res, "");
        sprintf(res, "t%d", qc); // Create temporary result
        quadr("-", op1, op2, res);
        empiler(&p, res);
        strcpy($$.nom, res);
        
        // Handle types
        if (strcmp($1.type, "Float") == 0 || strcmp($3.type, "Float") == 0) {
            strcpy($$.type, "Float");
        } else {
            strcpy($$.type, "Integer");
        }
    }
    | expression_arth MULT expression_arth {
        
        strcpy(op2, depiler(&p));
        strcpy(op1, depiler(&p));
        strcpy(res, "");
        sprintf(res, "t%d", qc); // Create temporary result
        quadr("*", op1, op2, res);
        empiler(&p, res);
        strcpy($$.nom, res);
        
        // Handle types
        if (strcmp($1.type, "Float") == 0 || strcmp($3.type, "Float") == 0) {
            strcpy($$.type, "Float");
        } else {
            strcpy($$.type, "Integer");
        }
    }
    | expression_arth DIV expression_arth {
        
        if(check_division == 1){
            printf("erreur semantique division par zero, line %d, colonne %d, entite %s \n",nb_ligne,nb_colonne,"");
            check_division = 0;
        }else{
            
            strcpy(op2, depiler(&p));
        strcpy(op1, depiler(&p));
        strcpy(res, "");
        sprintf(res, "t%d", qc); // Create temporary result
        quadr("/", op1, op2, res);
        empiler(&p, res);
        strcpy($$.nom, res);
        
        // Handle types
        if (strcmp($1.type, "Float") == 0 || strcmp($3.type, "Float") == 0) {
            strcpy($$.type, "Float");
        } else {
            strcpy($$.type, "Integer");
        }
        }
        
    }
    | PAR_OUV expression_arth PAR_FER {
        $$=$2;
        strcpy($$.nom, $2.nom);
        strcpy($$.type, $2.type);
    }
;

inst_aff: IDF AFF expression_arth {
        if (check_declaration($1) == 0) {
            printf("erreur semantique variable non declaree, line %d, colonne %d, entite %s \n", nb_ligne, nb_colonne, $1);
        } else if (check_cst($1) == 0) {
            printf("erreur semantique variable constante, line %d, colonne %d, entite %s \n", nb_ligne, nb_colonne, $1);
        }
        
        if (get_type($1) == 0 && strcmp($3.type, "Float") == 0) {
            printf("erreur semantique type incompatible, line %d, colonne %d, entite %s \n", nb_ligne, nb_colonne, $1);
        } else {
            // Check if the right side is a numeric constant (handle the "D=5" case)
            if (strcmp($3.type, "Integer") == 0 && $3.nom[0] >= '0' && $3.nom[0] <= '9') {
                int val = atoi($3.nom);
                assign_constant($1, val);
            } else {
                quadr("=", $3.nom, "vide", $1);
            }
        }
    } PVG
;

inst_read: MC_READ PAR_OUV STRING_CST DEPOINT AROB IDF {
        if (check_declaration($6) == 0) {
            printf("erreur semantique variable non declaree, line %d, colonne %d, entite %s \n", nb_ligne, nb_colonne, $6);
        } else {
            if (get_type($6) == 0) {
                strcpy(saveType, "Integer");
            } else if (get_type($6) == 1) {
                strcpy(saveType, "Float");
            }
        }
        
    } PAR_FER PVG
;

inst_display: MC_DISPLAY PAR_OUV STRING_CST DEPOINT IDF {
        if (check_declaration($5) == 0) {
            printf("erreur semantique variable non declaree, line %d, colonne %d, entite %s \n", nb_ligne, nb_colonne, $5);
        } else {
            if (get_type($5) == 0) {
                strcpy(saveType, "Integer");
            } else if (get_type($5) == 1) {
                strcpy(saveType, "Float");
            }
        }
        
    } PAR_FER PVG
;

inst_if: debut_if list_code MC_ELSE DEPOINT {
            // After if-body, before else
            deb_else = qc;
            quadr("BR", "", "vide", "vide");    // Jump past the else part
            sprintf(str, "%d", deb_else + 1);
            ajour_quad(fin_cond, 1, str);       // Patch BZ at fin_cond
        } 
        list_code MC_END {
            // After else-body
            end_if = qc;
            sprintf(str, "%d", end_if);
            ajour_quad(deb_else, 1, str);      // Patch BR to end
        }
        | debut_if list_code MC_END {
            // Simple if without else
            end_if = qc;
            sprintf(str, "%d", qc);
            ajour_quad(fin_cond, 1, str);      // Patch BZ to end
        }
;

debut_if: MC_IF PAR_OUV expression_log PAR_FER DEPOINT {
            fin_cond = qc;
            quadr("BZ", "", $3.nom, "vide");    // Jump if false
            
            // Handle OR conditions
            sprintf(end_OR, "%d", qc);
            while (!pilevide(qdr_or)) {
                strcpy(str, depiler(&qdr_or));
                ajour_quad(atoi(str), 1, end_OR);
            }
        }
;

debut_for: MC_FOR PAR_OUV IDF DEPOINT INT_CST DEPOINT INT_CST PAR_FER {
            // 1. Initialize loop counter with proper string representation
            assign_constant($3, $5);
            
            // 2. Save position for loop condition (beginning of loop)
            sprintf(deb_for, "%d", qc);
            
            // 3. Create condition test with proper string representation of limit
            int limit_value = $7;  // Get the actual integer value
            char temp_limit[20];
            sprintf(temp_limit, "%d", limit_value);  // Format as string
            
            char temp_var[20];
            sprintf(temp_var, "t%d", qc);
            quadr("<", $3, temp_limit, temp_var);
            
            // 4. Create conditional exit jump (will be patched later)
            int jump_pos = qc;
            quadr("BZ", "", temp_var, "vide");
            
            // 5. Store jump position for later backpatching
            sprintf(str, "%d", jump_pos);
            empiler(&p, str);
            
            // 6. Pass the loop counter name up to the parent rule
            strcpy($$.nom, $3);
        }
;

inst_for: debut_for list_code MC_END {
            // 1. Get the position of exit jump to patch
            char exit_jump[10];
            strcpy(exit_jump, depiler(&p));
            
            // 2. Increment the counter with proper string representation
            char one_str[5] = "1";  // Properly represent the constant 1
            quadr("+", $1.nom, one_str, $1.nom);
            
            // 3. Jump back to beginning (condition test)
            quadr("BR", "", "vide", deb_for);
            
            // 4. Set exit point and patch the BZ
            sprintf(str, "%d", qc);
            ajour_quad(atoi(exit_jump), 3, str);
        }
;

list_code: code_items
         ;

code_items:
      code_item code_items
    | /* epsilon */
    ;

code_item:
      inst_aff
    | inst_read
    | inst_display
    | inst_if
    | inst_for
    | inst_expr
    ;

inst_expr: expression PVG;

%%

int main() {
    printf("Analyse syntaxique demarre.\n");
    yyparse();
    print();
    optimiser();
    afficher_qdr();
    generer_code_objet();
    return 0;
}