#include <iostream>
using namespace std;

int main() {
#ifdef _XOPEN_SOURCE
   cout << "_XOPEN_SOURCE=" << _XOPEN_SOURCE << endl;
#endif
#ifdef _XPG6
   cout << "_XPG6=" << _XPG6 << endl;
#endif
#ifdef _XPG4
   cout << "_XPG4=" << _XPG4 << endl;
#endif
#ifdef _POSIX_C_SOURCE
   cout << "_POSIX_C_SOURCE=" << _POSIX_C_SOURCE << endl;
#endif
#ifdef _STRICT_STDC
   cout << "_STRICT_STDC=" << _STRICT_STDC << endl;
#endif
#ifdef __STRICT_ANSI__
   cout << "__STRICT_ANSI__=" << __STRICT_ANSI__ << endl;
#endif
#ifdef _STDC_C99
   cout << "_STDC_C99=" << _STDC_C99 << endl;
#endif
   return 0;
}
