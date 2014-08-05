benchmark_description <- stri_c("calculates various 'lengths' of strings ",
                         "(ASCII, UTF-8, Native, NA)")

benchmark_do  <- function() {
   library('stringi')

   plletters <- stri_enc_fromutf32(rep(c(97L, 98L, 99L, 100L, 101L, 102L, 103L,
      104L, 105L, 106L, 107L,  108L, 109L, 110L, 111L, 112L, 113L, 114L, 115L,
      116L, 117L, 118L,  119L, 120L, 121L, 122L, 261L, 263L, 281L, 322L, 324L,
      243L, 347L,  378L, 380L), 10000))
   plletters <- enc2native(plletters)

   x <- c(
      paste(rep(letters, 1000), collapse=''), # ASCII
      stri_dup('a\u0105b', 10000),            # UTF-8
      plletters,                              # native
      NA_character_
   )

   gc(reset=TRUE)
   microbenchmark2( # very fast - don't use benchmark2
      stri_length(x),
      stri_isempty(x),
      stri_numbytes(x),
      nzchar(x),
      nchar(x),
      nchar(x, 'bytes')
   )
}
