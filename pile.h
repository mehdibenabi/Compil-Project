#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include<stdbool.h>
typedef struct pile pile;
struct pile
{
    char info[50];
    pile* suiv;
};

void empiler(pile** sommet,char x[])
{
    pile* nouv;
    nouv=(pile*)malloc(sizeof(pile));
    strcpy(nouv->info,x);
    nouv->suiv=*sommet;
    *sommet=nouv;

}
bool pilevide(pile* sommet)
{
    if(sommet==NULL)
        return true;
    else return false;

}
char* depiler(pile** sommet)
{
    char* x=(char*)malloc(50* sizeof(char));
    strcpy(x,(*sommet)->info);
    pile* nouv=*sommet;
    (*sommet)=(*sommet)->suiv;
    free(nouv);
    return x;
}
void initpile(pile** p)
{
    *p=NULL;
}

