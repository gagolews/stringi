/* g++ -std=c++11 icu_test_bug_ucol_caselevel.cpp -licui18n -licuuc -licudata  && ./a.out */

/* This is a known issue: https://unicode-org.atlassian.net/browse/ICU-21338 */

#include <unicode/ustring.h>
#include <unicode/rbbi.h>
#include <unicode/coll.h>
#include <unicode/ucol.h>
#include <unicode/stsearch.h>
#include <cstdio>
using namespace icu;


#define WITH_CHECK_STATUS(f) \
    status = U_ZERO_ERROR; \
    f; \
    if (U_FAILURE(status)) {printf("error %s!\n", u_errorName(status));return 1;}


int main()
{
    const char* haystacks[] = {
        "mario", "Mario", "MARIO", "MÁRIO", "Mário", "mário", "dario"
    };

    const char* needle = "mario";


    UErrorCode status;
    UCollator* col;
    UStringSearch* matcher;
    int v;

    printf("U_ICU_VERSION=%s\n", U_ICU_VERSION);

    WITH_CHECK_STATUS(col = ucol_open("pt_BR", &status))

    WITH_CHECK_STATUS(ucol_setAttribute(col, UCOL_STRENGTH, UCOL_PRIMARY, &status))
    WITH_CHECK_STATUS(ucol_setAttribute(col, UCOL_CASE_LEVEL, UCOL_ON, &status))

    UnicodeString _needle = UnicodeString::fromUTF8(needle);
    UnicodeString haystack = UnicodeString::fromUTF8("whatever");

    WITH_CHECK_STATUS(matcher = usearch_openFromCollator(
        _needle.getBuffer(),
        _needle.length(),
        haystack.getBuffer(),
        haystack.length(),
        col, NULL, &status
    ))

    for (int i=0; i<sizeof(haystacks)/sizeof(haystacks[0]); ++i) {
        printf("%s vs. %s: ", needle, haystacks[i]);
        haystack = UnicodeString::fromUTF8(haystacks[i]);

        WITH_CHECK_STATUS(
            usearch_setText(matcher, haystack.getBuffer(), haystack.length(), &status)
        )

        usearch_reset(matcher);

        WITH_CHECK_STATUS(v = ((int)USEARCH_DONE!=usearch_first(matcher, &status)))
        printf(" usearch=%d", v);

        WITH_CHECK_STATUS(v = (int)UCOL_EQUAL==ucol_strcollUTF8(col,
            haystacks[i], -1, needle, -1, &status))
        printf(" ucol=%d", v);

        RuleBasedCollator* rbc = RuleBasedCollator::rbcFromUCollator(col);
        WITH_CHECK_STATUS(StringSearch matcher2(needle, haystack, rbc, NULL, status))
        WITH_CHECK_STATUS(v = ((int)USEARCH_DONE!=matcher2.first(status)))
        printf(" StringSearch=%d", v);

        printf("\n");
    }

    ucol_close(col);
    usearch_close(matcher);

    return 0;
}

