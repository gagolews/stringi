benchmark_description <- "Extract signle code points from a string "%+%
                         "[ASCII+Polish letters, native encoding]"


benchmark_do <- function() {
   library('stringi')
   library('stringr')

   plletters <- stri_enc_fromutf32(list(97L, 98L, 99L, 100L, 101L, 102L, 103L,
      104L, 105L, 106L, 107L,  108L, 109L, 110L, 111L, 112L, 113L, 114L, 115L,
      116L, 117L, 118L,  119L, 120L, 121L, 122L, 261L, 263L, 281L, 322L, 324L,
      243L, 347L,  378L, 380L))
   plletters <- enc2native(plletters)

   set.seed(123)
   x <- paste(sample(plletters, 2500L, replace=TRUE), collapse='')

   gc(reset=TRUE)
   benchmark2(
      str_sub(x, 1L:250L, 1L:250L),
      stri_sub(x, 1L:250L, 1L:250L),
      replications=1000L
   )
}
