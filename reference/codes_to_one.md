# Merge geographic codes

Convert geographic codes while preserving the number of rows in a data
frame or the dimension of a vector. Merging is handled, but not
splitting.

## Usage

``` r
codes_to_one(
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

a data frame with the same number of rows or a vector of equal dimension

## Examples

``` r
# Region codes changing in 2016
new_reg <- c("27", "27", "28", "28", "32", "32", "44", "44", "44", "75", "75",
             "75", "76", "76", "84", "84")
old_reg <- c("26", "43", "25", "23", "22", "31", "21", "41", "42", "54", "74",
             "72", "73", "91", "82", "83")

# A data frame with some old regions
data <- data.frame(REG = c("11", "26", "43", "82", "83"))

# Convert into new regions
data |> codes_to_one(
   codes_ini = old_reg,
   codes_fin = new_reg,
   from = "REG",
   to = "NEW_REG",
   extra = function(x){x}
)
#>   REG NEW_REG
#> 1  11      11
#> 2  26      27
#> 3  43      27
#> 4  82      84
#> 5  83      84

# With a vector
codes_to_one(
  data = c("11", "26", "43", "82", "83"),
  codes_ini = old_reg,
  codes_fin = new_reg,
  extra = function(x){x}
)
#> [1] "11" "27" "27" "84" "84"
```
