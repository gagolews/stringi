# do spell check
require('stringi')

x <- aspell_package_Rd_files(".")
print(x)
print(levels(as.factor(x$Original)))
