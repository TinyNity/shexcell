#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MAXVALUE 100
#define stringSize 6

#define lines 15
#define cols 5

char* random_char(n) {
    char* res = malloc(sizeof(char)*n);
    for (int i = 0; i<n; i++) {
        res[i] = (unsigned char)random() % MAXVALUE;
    }
    return res;
}

int main(void) {
    const char scin = ':'; // Séparateur de colonnes
    const char slin = '\n'; // Séparateur de lignes

    srand(time(NULL));
    FILE* table = NULL;
    table = fopen("sampleTable", "w");
    for (int i = 0; i<lines; i++) {
        for (int j = 0; i<cols; i++) {
            fprintf(table, "%s", random_char(stringSize));
            fprintf(table, '');
        }
    }

}