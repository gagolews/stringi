# about_arguments: Passing Arguments to Functions in <span class="pkg">stringi</span>

## Description

Below we explain how <span class="pkg">stringi</span> deals with its functions\' arguments.

If some function violates one of the following rules (for a very important reason), this is clearly indicated in its documentation (with discussion).

## Coercion of Arguments

When a character vector argument is expected, factors and other vectors coercible to characters vectors are silently converted with [`as.character`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/character.html), otherwise an error is generated. Coercion from a list which does not consist of length-1 atomic vectors issues a warning.

When a logical, numeric, or integer vector argument is expected, factors are converted with `as.*(as.character(...))`, and other coercible vectors are converted with `as.*`, otherwise an error is generated.

## Vectorization

Almost all functions are vectorized with respect to all their arguments and the recycling rule is applied whenever necessary. Due to this property you may, for instance, search for one pattern in each given string, search for each pattern in one given string, and search for the i-th pattern within the i-th string.

We of course took great care of performance issues: e.g., in regular expression searching, regex matchers are reused from iteration to iteration, as long as it is possible.

Functions with some non-vectorized arguments are rare: e.g., regular expression matcher\'s settings are established once per each call.

Some functions assume that a vector with one element is given as an argument (like `collapse` in [`stri_join`](stri_join.md)). In such cases, if an empty vector is given you will get an error and for vectors with more than 1 elements - a warning will be generated (only the first element will be used).

You may find details on vectorization behavior in the man pages on each particular function of your interest.

## Handling Missing Values (`NA`s)

<span class="pkg">stringi</span> handles missing values consistently. For any vectorized operation, if at least one vector element is missing, then the corresponding resulting value is also set to `NA`.

## Preserving Object Attributes

Generally, all our functions drop input objects\' attributes (e.g., [`names`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/names.html), [`dim`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/dim.html), etc.). This is due to deep vectorization as well as for efficiency reasons. If the preservation of attributes is needed, important attributes can be manually copied. Alternatively, the notation `x[] <- stri_...(x, ...)` can sometimes be used too.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, doi:<https://dx.doi.org/10.18637/jss.v103.i02>

Other stringi_general_topics: [`about_encoding`](about_encoding.md), [`about_locale`](about_locale.md), [`about_search_boundaries`](about_search_boundaries.md), [`about_search_charclass`](about_search_charclass.md), [`about_search_coll`](about_search_coll.md), [`about_search_fixed`](about_search_fixed.md), [`about_search_regex`](about_search_regex.md), [`about_search`](about_search.md), [`about_stringi`](about_stringi.md)
