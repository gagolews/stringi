#include <unicode/unistr.h>
#include <unicode/uvernum.h>
#include <unicode/ptypes.h>
#include <unicode/uchar.h>
#include <unicode/utypes.h>
#include <stdio.h>
using namespace icu;

int main() {
    // base tests
    UnicodeString x("abc");
    x = x+x;
    printf(U_ICU_VERSION);

    return 0;
}
