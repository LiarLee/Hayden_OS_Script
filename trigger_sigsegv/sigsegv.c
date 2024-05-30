#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int *p = NULL; // 定义一个空指针
    *p = 42; // 对空指针进行解引用，导致段错误
    return 0;
}
