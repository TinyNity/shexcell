#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MAXVALUE 26
#define stringSize 6

#define lines 15
#define cols 5

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
    FILE* table = NULL;
    table = fopen("sampleTable.txt", "w");
    for (int i = 0; i < lines; i++) {
        for (int j = 0; j < cols; j++) {
            fprintf(table, "%s", random_char(stringSize));
            if (j != cols - 1) {
                fprintf(table, "%c", scin);
            }
        }
        fprintf(table, "%c", slin);
    }
}