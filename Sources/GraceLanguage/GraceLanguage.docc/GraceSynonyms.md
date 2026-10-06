# GraceSynonyms

The Grace Language provides a number of synonyms to its common built-in keywords.


## Synonyms

Several of the Grace keywords have different synonyms that can be used instead of the base keyword (example: `func` for `function`). Here are a list of accepted synonyms:

* `enum` - `enumeration`
* `struct` - `structure`
* `variable`, `define` - `var`
* `integer` - `int`
* `boolean`, `true_false`, `yes_no` - `bool`
* `number` - `float`
* `yes` - `true`
* `no` - `false`
* `func`, `on` - `function`
* `send` - `call`
* `begin` - `{`
* `end` - `}`
* `as` - `:`
* `equal`, `equals` - `=`
* `and` - `&`
* `or` - `|`
* `not_equal` - `!=`
* `less_than` - `<`
* `greater_than` - `>`
* `less_or_equal` - `<=`
* `greater_or_equal` - `>=`
* `plus`- `+`
* `minus` - `-`
* `times` - `*`
* `divided_by` - `/`

Useing the synonyms, you could write a Grace function as:

```swift
on ItemC() returns string begin
    define first as string equals "Hello ";
    define last as string equals "World!";
    
    return ($first plus $last);
end
```
