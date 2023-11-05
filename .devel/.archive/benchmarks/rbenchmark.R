## mod of rbenchmark::benchmark by Wacek Kusnierczyk <mailto:waku@idi.ntnu.no>
## mod Copyright (C) 2013-2015, Marek Gagolewski

benchmark2 <- function (...,
   replications = 100L, environment = parent.frame(), warmup = 2L)
{
   if (length(list(...)) == 0) {
      warning("benchmark called with no expressions to be evaluated.")
      return(invisible(data.frame()))
   }

   ..arguments  <- match.call()[-1]
   ..parameters <- names(..arguments)

    if (is.null(..parameters))
        ..parameters <- as.character(..arguments)
    else {
        ..keep = !..parameters %in% c("replications",
            "environment", "warmup")
        ..arguments  <- ..arguments[..keep]
        ..parameters <- ..parameters[..keep]
    }

   ..n            <- length(..arguments)
   ..labels       <- ifelse(..parameters == "",
                           as.character(..arguments),
                           ..parameters)
   ..values       <- list(...)


   for (..i in 1L:..n)
      if (is.expression(..values[[..i]]))
         ..arguments[..i] <- ..values[..i]

   ..iters <- 1L:replications

   ..bmarks <- sapply(..arguments,
            function(..test) {
               gc(reset=TRUE)
               for (..i in 1L:warmup)
                  eval(..test, environment)

               system.time(
                  for (..i in ..iters)
                     eval(..test, environment)
               )
            })

   result <- data.frame(
         row.names = NULL,
         expr = ..labels,
         t(..bmarks),
         n = replications
      )

   result
}
