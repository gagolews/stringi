#include <stdio.h>
#include <math.h>

int main()
{
    float vals1[] = {-INFINITY, -1.0, -0.0, 0.0, 0.5, 1.0, 1.5, 2.0, INFINITY, NAN};
    for (int i=0; i<sizeof(vals1)/sizeof(float); ++i) {
        float v = vals1[i];
        printf("[%6.0f]\t[%0+6.1f]\t[%0 6.1f]\t[%-+6.1f]\t[%- 6.1f]\t[%.1f]\t[%6.1f]\n", v, v, v, v, v, v, v);
    }

    int vals3[] = {-1, 0, 1};
    for (int i=0; i<sizeof(vals3)/sizeof(int); ++i) {
        int v = vals3[i];
        printf("[% 3d]\t[%+3d]\t[%03d]\t[% 03d]\t[%+03d]\t[%5.3d]\t[% 5.3d]\t[%+5.3d]\n", v, v, v, v, v, v, v, v);
        printf("[%# 3X]\t[%#+3X]\t[%#03X]\t[%# 03X]\t[%#+03X]\t[%#5.3X]\t[%# 5.3X]\t[%#+5.3X]\n", v, v, v, v, v, v, v, v);
    }

    const char* vals2[] = {"", "abc", "abcdef", "abcdefghi"};
    for (int i=0; i<sizeof(vals2)/sizeof(const char*); ++i) {
        const char* v = vals2[i];
        printf("[%05s]\t[% s]\t[%+s][%- 5s]\t[%5.3s]\n", v, v, v, v, v);
    }

    printf("%000001$#- *0000002$.*000003$f", 1.23456, 10, 3);
    printf("%100000.100000f", 1.23456);
    return 0;
}
