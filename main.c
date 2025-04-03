#include <stdio.h>

// gcc -S -fverbose-asm -O2 main.c
// gcc main.s (using capital S makes it do preprocessing)

// https://cs.lmu.edu/~ray/notes/nasmtutorial/
// https://github.com/pkivolowitz/asm_book

// ASM functions just assume stuff is where it should be, which means you have
// to set it up so that what it assumes is there *is* there

// registers are used for calculations and return values, the stack is used for
// storing stuff like variables

// push 10
// push 20
// ;compiled code inserted for the function call
// ;accesses x and y by referencing positions in stack relative to stack pointer
// pop
// pop

int main() {

    int x = 50;
    while (x > 0) {
        printf("%d\n", x);
        x--;
    }
    return 0;

}