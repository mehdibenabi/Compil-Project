#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include<stdbool.h>




typedef struct qdr{

    char oper[100]; 
    char op1[100];   
    char op2[100];   
    char res[100];  
    
  }qdr;
  qdr quad[1000];
extern int qc;

void optimiser();
void propagation_copie();
void elimination_redondantes();
void simplification_algebrique();
void elimination_code_inutile();




void quadr(char opr[],char op1[],char op2[],char res[])
{

	strcpy(quad[qc].oper,opr);
	strcpy(quad[qc].op1,op1);
	strcpy(quad[qc].op2,op2);
	strcpy(quad[qc].res,res);
	
	
qc++;

}

void ajour_quad(int num_quad, int colon_quad, char val [])
{
if (colon_quad==0) strcpy(quad[num_quad].oper,val);
else if (colon_quad==1) strcpy(quad[num_quad].op1,val);
         else if (colon_quad==2) strcpy(quad[num_quad].op2,val);
                   else if (colon_quad==3) strcpy(quad[num_quad].res,val);

}

void afficher_qdr()
{
printf("*********************Les Quadruplets***********************\n");

int i;

for(i=0;i<qc;i++)
		{

 printf("\n %d - ( %s  ,  %s  ,  %s  ,  %s )",i,quad[i].oper,quad[i].op1,quad[i].op2,quad[i].res); 
 printf("\n--------------------------------------------------------\n");

}
}

// Indicateur pour relancer l'optimisation si une modif a eu lieu
int boolqc = 0;

// Vérifie si une variable est temporaire (ex: t0, t1, ...)
int is_temp_var(const char *var) {
    return var[0] == 't' && var[1] >= '0' && var[1] <= '9';
}

// Vérifie si c'est un opérateur de contrôle de flux ou autre (à adapter si besoin)
int is_sep(const char *op) {
    return (
        strcmp(op, "BOUNDS") == 0 ||
        strcmp(op, "ADEC") == 0 ||
        strcmp(op, "BR") == 0 ||
        strcmp(op, "BZ") == 0
    );
}

// Propagation de copie
void propagation_copie() {
  int i,j;
    for (i = 0; i < qc; i++) {
        if (strcmp(quad[i].oper, "=") == 0 && strcmp(quad[i].op2, "vide") == 0) {
            for ( j = i + 1; j < qc; j++) {
                if (strcmp(quad[j].op1, quad[i].res) == 0 && !is_sep(quad[j].oper)) {
                    strcpy(quad[j].op1, quad[i].op1);
                    boolqc = 1;
                }
                if (strcmp(quad[j].op2, quad[i].res) == 0 && !is_sep(quad[j].oper)) {
                    strcpy(quad[j].op2, quad[i].op1);
                    boolqc = 1;
                }
                if (strcmp(quad[j].res, quad[i].res) == 0) break;
            }
        }
    }
}

// Elimination des quadruplets redondants
void elimination_redondantes() {
  int i,j,k;
    for (i = 0; i < qc; i++) {
        for ( j = i + 1; j < qc; j++) {
            if (strcmp(quad[i].oper, quad[j].oper) == 0 &&
                strcmp(quad[i].op1, quad[j].op1) == 0 &&
                strcmp(quad[i].op2, quad[j].op2) == 0 &&
                !is_sep(quad[i].oper) && !is_sep(quad[j].oper)) {
                // Remplacer toutes les utilisations de quad[j].res par quad[i].res
                for ( k = j + 1; k < qc; k++) {
                    if (strcmp(quad[k].op1, quad[j].res) == 0)
                        strcpy(quad[k].op1, quad[i].res);
                    if (strcmp(quad[k].op2, quad[j].res) == 0)
                        strcpy(quad[k].op2, quad[i].res);
                }
                // Supprimer le quadruplet j
                for (k = j; k < qc - 1; k++)
                    quad[k] = quad[k + 1];
                qc--;
                j--;
                boolqc = 1;
            }
        }
    }
}

// Simplification algébrique (ex: a * 2 => a + a)
void simplification_algebrique() {
  int i;
    for ( i = 0; i < qc; i++) {
        if (strcmp(quad[i].oper, "*") == 0 && strcmp(quad[i].op2, "2") == 0) {
            strcpy(quad[i].oper, "+");
            strcpy(quad[i].op2, quad[i].op1);
            boolqc = 1;
        }
    }
}

// Elimination du code inutile (quadruplets dont le résultat n'est jamais utilisé)
void elimination_code_inutile() {
  int i,j;
    int used[1000] = {0};
    for ( i = 0; i < qc; i++) {
        for (j = i + 1; j < qc; j++) {
            if (strcmp(quad[j].op1, quad[i].res) == 0 || strcmp(quad[j].op2, quad[i].res) == 0)
                used[i] = 1;
        }
    }
    for ( i = 0; i < qc; i++) {
        if (!used[i] && is_temp_var(quad[i].res) && !is_sep(quad[i].oper)) {
            for ( j = i; j < qc - 1; j++)
                quad[j] = quad[j + 1];
            qc--;
            i--;
            boolqc = 1;
        }
    }
}

// Fonction principale d'optimisation
void optimiser() {
    do {
        boolqc = 0;
        propagation_copie();
        elimination_redondantes();
        simplification_algebrique();
        elimination_code_inutile();
    } while (boolqc);
}



// 
void generer_code_objet() {
    FILE *f = fopen("code.asm", "w");
    if (!f) {
        printf("Erreur : impossible de créer code.asm\n");
        return;
    }

    // Écrire les segments
    fprintf(f, "DATA SEGMENT\n");
    fprintf(f, "A DW 0\nB DW 0\nC DW 327\nD DW 0\nI DW 0\nN DW 0\nT0 DW 0\nT1 DW 0\nT2 DW 0\nT3 DW 0\nT4 DW 0\nT5 DW 0\n");
    fprintf(f, "DATA ENDS\n\n");

    fprintf(f, "CODE SEGMENT\n");
    fprintf(f, "ASSUME CS:CODE, DS:DATA\n");
    fprintf(f, "START:\n");
    fprintf(f, "MOV AX, DATA\nMOV DS, AX\n\n");

    int i;
    for ( i = 0; i < qc; i++) {
        char *op = quad[i].oper;
        char *op1 = quad[i].op1;
        char *op2 = quad[i].op2;
        char *res = quad[i].res;

        if (strcmp(op, "+") == 0) {
            fprintf(f, "; %s = %s + %s\n", res, op1, op2);
            fprintf(f, "MOV AX, %s\n", op1);
            fprintf(f, "ADD AX, %s\n", op2);
            fprintf(f, "MOV %s, AX\n\n", res);
        } else if (strcmp(op, "*") == 0) {
            fprintf(f, "; %s = %s * %s\n", res, op1, op2);
            fprintf(f, "MOV AX, %s\n", op1);
            fprintf(f, "MOV BX, %s\n", op2);
            fprintf(f, "MUL BX\n");
            fprintf(f, "MOV %s, AX\n\n", res);
        } else if (strcmp(op, "=") == 0) {
            if (isdigit(op1[0])) {
                fprintf(f, "; %s = %s\n", res, op1);
                fprintf(f, "MOV AX, %s\n", op1);
            } else {
                fprintf(f, "; %s = %s\n", res, op1);
                fprintf(f, "MOV AX, %s\n", op1);
            }
            fprintf(f, "MOV %s, AX\n\n", res);
        } else {
            fprintf(f, "; Opération non supportée: (%s, %s, %s, %s)\n\n", op, op1, op2, res);
        }
    }

    // Fin du programme
    fprintf(f, "MOV AH, 4CH\nINT 21H\n");
    fprintf(f, "CODE ENDS\nEND START\n");
    fclose(f);

    printf("✅ Fichier 'code.asm' généré avec succès (compatible EMU8086).\n");
}



