#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MAXVALUE 26
#define stringSize 6

char* random_char(int n) {
    char* res = malloc(sizeof(char) * n);
    for (int i = 0; i < n; i++) {
        res[i] = (unsigned char)random() % MAXVALUE + 'A';
    }
    return res;
}

int main(void) {
    const char scin = ':';   // Séparateur de colonnes
    const char slin = '\n';  // Séparateur de lignes

    srand(time(NULL));

    FILE* table;
    table = fopen("sampleTable.txt", "w");

    int lines = 5;
    int cols = 5;

    for (int i = 0; i < lines; i++) {
        for (int j = 0; j < cols; j++) {
            fprintf(table, "%s", random_char(stringSize));  // (rand() % stringSize) + 1
            if (j != cols - 1) {
                fprintf(table, "%c", scin);
            }
        }
        fprintf(table, "%c", slin);
    }
}