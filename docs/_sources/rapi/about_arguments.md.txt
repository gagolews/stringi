# about\_arguments: Passing Arguments to Functions in <span class="pkg">stringi</span>

## Description

Below we explain how <span class="pkg">stringi</span> deals (in most of the cases) with its functions\' arguments.

## Coercion of Arguments

When a character vector argument is expected, factors and other vectors coercible to characters vectors are silently converted with [`as.character`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/character.html), otherwise an error is generated. Coercion from a list of non-atomic vectors each of length 1 issues a warning.

When a logical, numeric, or integer vector argument is expected, factors are converted with `as.*(as.character(...))`, and other coercible vectors are converted with `as.*`, otherwise an error is generated.

## Vectorization

Almost all functions are vectorized with respect to all their arguments and the recycling rule is applied whenever necessary. Due to this property you may, for instance, search for one pattern in each given string, search for each pattern in one given string, and search for the i-th pattern within the i-th string. This behavior sometimes leads to peculiar results - we assume you know what you are doing.

We of course took great care of performance issues: e.g., in regular expression searching, regex matchers are reused from iteration to iteration, as long it is possible.

Functions with some non-vectorized arguments are rare: e.g., regular expression matcher\'s settings are established once per each call.

Some functions assume that a vector with one element is given as an argument (like `collapse` in [`stri_join`](stri_join.md)). In such cases, if an empty vector is given you will get an error and for vectors with more than 1 elements - a warning will be generated (only the first element will be used).

You may find details on vectorization behavior in the man pages on each particular function of your interest.

## Handling Missing Values (`NA`s)

<span class="pkg">stringi</span> handles missing values consistently. For any vectorized operation, if at least one vector element is missing, then the corresponding resulting value is also set to `NA`.

## Preserving Input Objects\' Attributes

Generally, all our functions drop input objects\' attributes (e.g., [`names`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/names.html), [`dim`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/dim.html), etc.). This is generally because of advanced vectorization and for efficiency reasons. Thus, if arguments\' preserving is needed, please remember to copy important attributes manually or use, e.g., the subsetting operation like `x[] <- stri_...(x, ...)`.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other stringi\_general\_topics: [`about_encoding`](about_encoding.md), [`about_locale`](about_locale.md), [`about_search_boundaries`](about_search_boundaries.md), [`about_search_charclass`](about_search_charclass.md), [`about_search_coll`](about_search_coll.md), [`about_search_fixed`](about_search_fixed.md), [`about_search_regex`](about_search_regex.md), [`about_search`](about_search.md), [`about_stringi`](about_stringi.md)
