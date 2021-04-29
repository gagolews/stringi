require("stringi")

local({

   encodings <- stri_enclist()

   encinfo <- as.data.frame(stri_encinfo(encodings[[1]][1]),
                            stringsAsFactors=FALSE)

   for (i in seq_along(encodings)[-1]) {
      encinfo <- rbind(encinfo,
         stri_encinfo(encodings[[i]][1])
      )
   }

   encinfo <- encinfo[order(encinfo[[1]]), ]

   # Note that the "HZ" encoding treats "~" (#126) specially


   cat("Listing supported 8-bit encodings:\n\n")

   encinfo8bit <- encinfo[encinfo$"CharSize.8bit",
                          c(-(3:(ncol(encinfo)-5)),
                            -(ncol(encinfo)-0:2))]
   rownames(encinfo8bit) <- NULL
   print(encinfo8bit)

   # iso-2022-jp
})
