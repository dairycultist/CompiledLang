# CompiledLang

Compiler that takes in a text file, tokenizes it, parses it to a parse tree, interprets that tree to produce NASM code (Mac assembly), assembles it to a binary, and runs it.

https://stackoverflow.com/questions/42619995/running-assembly-code-for-mac-os-x

ASM functions just assume stuff is where it should be, which means you have to set it up so that what it assumes is there *is* there
```
int fizz(uint8 x, uint8 y) {
  return x + y;
}
fizz(10, 20);

push 10
push 20
;compiled code inserted for fizz
pop
pop
```
