# Merge or split geographic codes

Convert geographic codes by managing splits and merges. The number of
rows in a data frame or the dimension of a vector are not preserved.

## Usage

``` r
codes_to_many(
  data,
  codes_ini,
  codes_fin,
  extra = NULL,
  from = NULL,
  to = NULL,
  ...
)
```

## Arguments

- data:

  Data frame or vector

- codes_ini:

  Initial geographic codes

- codes_fin:

  Final geographic codes

- extra:

  Other geographic codes

- from:

  Initial column (in a data frame)

- to:

  Final column (in a data frame)

- ...:

  Arguments passed to or from other methods.

## Value

A data frame with an equal or greater number of rows or a vector with an
equal or greater dimension.

## Examples

``` r
# Region codes changing in 2016
new_reg <- c("27", "27", "28", "28", "32", "32", "44", "44", "44", "75", "75",
             "75", "76", "76", "84", "84")
old_reg <- c("26", "43", "25", "23", "22", "31", "21", "41", "42", "54", "74",
             "72", "73", "91", "82", "83")

# A data frame with some new regions
data <- data.frame(REG = c("11", "27", "84"))

# Convert into old regions
data |> codes_to_many(
   codes_ini = new_reg,
   codes_fin = old_reg,
   from = "REG",
   to = "OLD_REG",
   extra = function(x){x}
)
#>   REG OLD_REG
#> 1  11      11
#> 2  27      26
#> 3  27      43
#> 4  84      82
#> 5  84      83

# With a vector
codes_to_many(
  data = c("11", "27", "84"),
  codes_ini = new_reg,
  codes_fin = old_reg,
  extra = function(x){x}
)
#> [1] "11" "26" "43" "82" "83"
```
