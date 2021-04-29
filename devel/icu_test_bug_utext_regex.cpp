#include <unicode/regex.h>
#include <cstdio>
#include <cstring>

/*
   g++ -std=c++11 icu_utext_regex_bug.cpp -licui18n -licuuc -licudata  && ./a.out
   
   g++ -std=c++11 icu_utext_regex_bug.cpp -licui18n -licuuc -licudata  -I/opt/icu4c-54_1/include/ -L/opt/icu4c-54_1/lib/  && LD_LIBRARY_PATH="/opt/icu4c-54_1/lib/" ./a.out

*/

int main() {
   printf("U_ICU_VERSION=%s\n", U_ICU_VERSION);
   
   UErrorCode        status    = U_ZERO_ERROR;
   const char* m = "(?<=aą)spam";
   UText* str_m = utext_openUTF8(NULL, m, strlen(m), &status);
   if (U_FAILURE(status)) {
      printf("1error %s!\n", u_errorName(status));
      return 1;
   }
   
   status    = U_ZERO_ERROR;
   RegexMatcher *matcher = new RegexMatcher(str_m, 0, status);
   if (U_FAILURE(status)) {
      printf("2error %s!\n", u_errorName(status));
      return 1;
   }

   
   status    = U_ZERO_ERROR;
   const char* stringToTest = "**aąspam**";
   UText* str_text = utext_openUTF8(NULL, stringToTest, strlen(stringToTest), &status);
   if (U_FAILURE(status)) {
      printf("3error %s!\n", u_errorName(status));
      return 1;
   }
   
   
   matcher->reset(str_text);

   if (matcher->find()) {
      // We found a match.
      int startOfMatch = matcher->start(status);   // string index of start of match.
      printf("match at = %d\n", startOfMatch);
   }
   else
      printf("no match\n");
      
   return 0;
}

