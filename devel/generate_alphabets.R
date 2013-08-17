require('stringi')


alphabets <- list(
   
   "pl" = c("AĄBCĆDEĘFGHIJKLŁMNŃOÓPRSŚTUWXYZŹŻ",
            "aąbcćdeęfghijklłmnńoóprsśtuwxyzźż"),
   
   "cz" = c("AÁBCČDĎEÉĚFGHChIÍJKLMNŇOÓPQRŘSŠTŤUÚŮVWXYÝZŽ",
            "aábcčdďeéěfghchiíjklmnňoópqrřsštťuúůvwxyýzž"),
   
   "sk" = c("AÁÄBCČDĎEÉFGHIÍJKLĹĽMNŇOÓÔPQRŔSŠTŤUÚVWXYÝZŽ",
            "aáäbcčdďeéfghiíjklĺľmnňoóôpqrŕsštťuúvwxyýzž"),
   
   "hu" = c("AÁBCDEÉFGHIÍJKLMNOÓÖŐPRSTUÚÜŰVZ", 
            "aábcdeéfghiíjklmnoóöőprstuúüűvz")
      
)

for (i in seq_along(alphabets))
   alphabets[[i]] <- stri_escape_unicode(alphabets[[i]])

print(alphabets)
