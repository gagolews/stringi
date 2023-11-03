# ICU 52.1 Patching Info


1. replace Collator::EComparisonResult with UCollationResult (for Solaris CC) in:
   * unicode/coll.h
   * unicode/sortkey.h
   * i18n/sortkey.cpp
   * i18n/coll.cpp
