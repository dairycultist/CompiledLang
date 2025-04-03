#include <stdio.h>

// gcc -S -fverbose-asm -O2 main.c
// gcc main.s (using capital S makes it do preprocessing)

// https://cs.lmu.edu/~ray/notes/nasmtutorial/
// https://github.com/pkivolowitz/asm_book

int main() {

    printf("cats\n");
    return 0;

}