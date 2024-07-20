#include <stdio.h>

int main() {

  char num1, num2;

  printf("Enter a number: ");
  scanf("%c", &num1);
  printf("Enter another: ");
  scanf("%c", &num2);
  printf("%c + %c\n", num1, num2);

  return 0;

}
