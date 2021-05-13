codes <- 1:55295
x <- stringi::stri_enc_fromutf32(as.list(codes))
w1 <- nchar(x, type="width")
# cat(w1, sep="\n", file="width-nchar.csv")
w2 <- scan("devel/width-stringi-1.5.3.csv")
w3 <- scan("devel/width-stringi-1.6.1.csv")
w4 <- stringi::stri_width(x)
cat(w4, sep="\n",
    file=sprintf("devel/width-stringi-%s.csv", as.character(packageVersion("stringi"))))

# d <- which(w2 != w3)
# cbind.data.frame(x[d], nchar=w1[d], `1.5.3`=w2[d], w3[d])

d <- (w4 != w2 | w4 != w1)
y <- cbind.data.frame(
    code=codes[d],
    ucode=stringi::stri_trans_general(x[d], "Any-Hex/C"),
    char=x[d],
    name=stringi::stri_trans_general(x[d], "Any-Name"),
    nchar=w1[d], `1.5.3`=w2[d],
    #`1.6.1`=w3[d],
    current=w4[d])

write.csv(y, "devel/delme-width-diff.csv", row.names=FALSE)
