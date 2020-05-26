#include <stdio.h>
#include <cassert>
#include <stdexcept>
#include <stdlib.h>

size_t ScanBuff(const char* FileName, char** CodeBuff) {
  assert(FileName != nullptr);
  FILE* InFile = fopen(FileName, "rb");
  assert(InFile != nullptr);

  fseek(InFile, 0, SEEK_END);
  size_t FileSize = ftell(InFile);
  rewind(InFile);

  char* buffer = (char*)calloc(FileSize + 2, sizeof(char));
  assert(buffer != nullptr);

  *CodeBuff = buffer;

  size_t BuffSize = fread(buffer, sizeof(char), FileSize, InFile);

  fclose(InFile);
  return BuffSize;
}

void MakeFile(const char* FileName, char* Code, size_t CodeSize) {
  assert(FileName != nullptr);
  assert(Code != nullptr);

  FILE* output_file = fopen(FileName, "wb");
  size_t WrittenSize = fwrite(Code, sizeof(char), CodeSize, output_file);

  assert(WrittenSize == CodeSize);

  fclose(output_file);

  free(Code);
}

int main(){
  char* code = nullptr;
  size_t CodeSize = ScanBuff("CrackMe.out", &code);
  assert(code != nullptr);

  printf("CodeSize: %d\n", CodeSize);

  bool Hacked = false;

  int i=0;
  while(i < CodeSize && !Hacked) {
    printf("%08d: %02xh (%c)\n", i, (unsigned char)code[i], code[i]);
    if (code[i] == 117) {
      code[i] = (unsigned char)116;
      printf(";-------------------------\nCheck found: %d\n",i);
      Hacked = true;
    }
    ++i;
  }

  MakeFile("CrackMe_hack.out", code, CodeSize);
  return 0;
}
