#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TABLE_SIZE 100

typedef struct IDF_CST {
    char name[20];
    char code[20];
    char type[20];
    char value[20];
    int cst;
    struct IDF_CST* next;
} IDF_CST;

typedef struct SEP_KW {
    char name[20];
    char code[20];
    struct SEP_KW* next;
} SEP_KW;

// Déclaration des tables de hachage
IDF_CST* ts_idf_cst[TABLE_SIZE];
SEP_KW* ts_sep[TABLE_SIZE];
SEP_KW* ts_kw[TABLE_SIZE];

int nb_ligne = 1;
int nb_colonne = 0;

// Fonction de hachage simple
unsigned int hash(const char* str) {
    unsigned int hash = 0;
    while (*str) {
        hash = (hash * 31) + (*str++);
    }
    return hash % TABLE_SIZE;
}

// Recherche dans la table de hachage
int search(char entity[], int t) {
    unsigned int index = hash(entity);
    if (t == 0) {
        IDF_CST* current = ts_idf_cst[index];
        while (current) {
            if (strcmp(current->name, entity) == 0) return 1;
            current = current->next;
        }
    } else if (t == 1) {
        SEP_KW* current = ts_sep[index];
        while (current) {
            if (strcmp(current->name, entity) == 0) return 1;
            current = current->next;
        }
    } else if (t == 2) {
        SEP_KW* current = ts_kw[index];
        while (current) {
            if (strcmp(current->name, entity) == 0) return 1;
            current = current->next;
        }
    }
    return 0;
}

// Insertion dans la table de hachage
void insert(char entity[], char code[], char type[], int t) {
    unsigned int index = hash(entity);

    if (t == 0) { // Identifiant ou Constante
        if (!search(entity, 0)) {
            IDF_CST* new_node = (IDF_CST*)malloc(sizeof(IDF_CST));
            strcpy(new_node->name, entity);
            strcpy(new_node->code, code);
            strcpy(new_node->type, type);
            strcpy(new_node->value, "");
            new_node->cst = 0;
            new_node->next = ts_idf_cst[index];
            ts_idf_cst[index] = new_node;
        }
    } else if (t == 1) { // Séparateur
        if (!search(entity, 1)) {
            SEP_KW* new_node = (SEP_KW*)malloc(sizeof(SEP_KW));
            strcpy(new_node->name, entity);
            strcpy(new_node->code, code);
            new_node->next = ts_sep[index];
            ts_sep[index] = new_node;
        }
    } else if (t == 2) { // Mot-clé
        if (!search(entity, 2)) {
            SEP_KW* new_node = (SEP_KW*)malloc(sizeof(SEP_KW));
            strcpy(new_node->name, entity);
            strcpy(new_node->code, code);
            new_node->next = ts_kw[index];
            ts_kw[index] = new_node;
        }
    }
}

// Affichage de la table
void print() {
    printf("\n/******************Table des symboles IDF*******************");
    printf("\n-------------------------------------------------------------\n");
    printf("\t|    Name   |      Code    |   Type    |    Value   |\n");
    printf("-------------------------------------------------------------\n");
int i;
    for ( i = 0; i < TABLE_SIZE; i++) {
        IDF_CST* current = ts_idf_cst[i];
        while (current) {
            printf("\t|%10s | %15s |%12s | %12s |\n",
                   current->name, current->code, current->type, current->value);
            current = current->next;
        }
    }

    printf("\n/**Table des symboles Separateurs**");
    printf("\n------------------------------\n");
    printf("\t|    Name   |      Code    |\n");
    printf("------------------------------\n");

    for ( i = 0; i < TABLE_SIZE; i++) {
        SEP_KW* current = ts_sep[i];
        while (current) {
            printf("\t|%10s | %12s |\n", current->name, current->code);
            current = current->next;
        }
    }

    printf("\n/**Table des symboles mots clés**");
    printf("\n------------------------------\n");
    printf("\t|    Name   |      Code    |\n");
    printf("------------------------------\n");

    for ( i = 0; i < TABLE_SIZE; i++) {
        SEP_KW* current = ts_kw[i];
        while (current) {
            printf("\t|%10s | %12s |\n", current->name, current->code);
            current = current->next;
        }
    }
}

// Modifier le type d'un identifiant
void insert_type(char entity[], char type[]) {
    unsigned int index = hash(entity);
    IDF_CST* current = ts_idf_cst[index];
    while (current) {
        if (strcmp(current->name, entity) == 0) {
            strcpy(current->type, type);
            break;
        }
        current = current->next;
    }
}

// Modifier la valeur d'un identifiant
void insert_value(char entity[], char value[]) {
    unsigned int index = hash(entity);
    IDF_CST* current = ts_idf_cst[index];
    while (current) {
        if (strcmp(current->name, entity) == 0) {
            strcpy(current->value, value);
            break;
        }
        current = current->next;
    }
}

// Obtenir le type d'un identifiant
int get_type(char entity[]) {
    unsigned int index = hash(entity);
    IDF_CST* current = ts_idf_cst[index];
    while (current) {
        if (strcmp(current->name, entity) == 0) {
            if (strcmp(current->type, "Integer") == 0) return 0;
            if (strcmp(current->type, "Float") == 0) return 1;
        }
        current = current->next;
    }
    return -1;
}

// Vérifier si une variable est déclarée
int check_declaration(char entity[]) {
    unsigned int index = hash(entity);
    IDF_CST* current = ts_idf_cst[index];
    while (current) {
        if (strcmp(current->name, entity) == 0 && strcmp(current->type, "") == 0)
            return 0;
        current = current->next;
    }
    return -1;
}

// Vérifier si une variable est constante
int check_cst(char entity[]) {
    unsigned int index = hash(entity);
    IDF_CST* current = ts_idf_cst[index];
    while (current) {
        if (strcmp(current->name, entity) == 0 && current->cst == 1)
            return 0;
        current = current->next;
    }
    return -1;
}

// Définir une variable comme constante
int set_cst(char entity[]) {
    unsigned int index = hash(entity);
    IDF_CST* current = ts_idf_cst[index];
    while (current) {
        if (strcmp(current->name, entity) == 0) {
            current->cst = 1;
            return 0;
        }
        current = current->next;
    }
    return -1;
}





