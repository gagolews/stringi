# ICU 55 Patching Info

copy common/
copy i18n/
copy stubdata/

move common/unicode and i18n/unicode to unicode/

remove *.rc *.vcproj *.vcxproj and others

mkdir data/

d1 <- dir("src/icu52", recursive=TRUE)
d2 <- dir("src/icu55", recursive=TRUE)
setdiff
