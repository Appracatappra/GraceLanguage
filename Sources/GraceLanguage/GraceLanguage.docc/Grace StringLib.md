# Grace StringLib

The Grace `StringLib` defines a common library of `functions` for working with `strings` that you might find useful in your Grace Programs.

## Overview

The `StringLib` defines common `functions` such as `format`, `leftString` and `rightString`. To use `StringLib` in your Grace Program, use `import StringLib;` at the start of your code. For example:

```swift
import StringLib;

main {
    var n:int = 2;
    var word:string = "points";
    var result:string = @format("You have {0} {1}.", [$n, $word]);
}
```

This program loads the `StringLib` so it has access to the `format function`. When run, it will write "You have 2 points." to `result`.

> The `StringLib` is contained inside of the `GraceCompiler` using the `register` feature. If you want to see how to use the `register` feature or expand the library, this is where to look.

## StringLib Functions

The `StringLib` defines the following `functions`:


### format

The `format function` takes a formatting `string` and a list of variables and inserts the variables in the `string` by replacing keys in the form `{0}` where the number is the index of the desired value in the passed in array. For Example:

```swift
var n:int = 2;
var word:string = "points";
var result:string = @format("You have {0} {1}.", [$n, $word]);
```

### char

The `char function` returns the character at a given index from the given string. For example:

```swift
var phrase:string = "Hello World";
var c:string = @char($phrase, 1);
```

Since Grace `strings` are zero based, the value of `c` would be `e`.

### length

The `length function` returns the length of the given `string`. For example:

```swift
var phrase:string = "Hello World";
var n:int = @length($phrase);
```

The value of `n` would be `11`.

### stringContains

The `stringContains function` returns `true` if the given `string` contains another `string`. For example:

```swift
var phrase:string = "Hello World";
var hasWorld:bool = @stringContains($phrase, "World");
```

### replace

The `replace function` replaces a given `string` inside another `string` with the new `string` value. For example:

```swift
var phrase:string = "Hello World";
call @replace($phrase, "Hello", "Hi");
```

### concat

The `concat function` adds the given `string` to another `string` using the given delimiter `string`. For example:

```swift
var words:string = "one";
call @concat($words, "two", ",");
```

The value of `words` would be `one,two`. If `words` had been empty, its value would have been `two`, without the delimiter.

### uppercase

The `uppercase function` converts the given `string` value to all uppercase. For example:

```swift
var word:string = "one";
call @uppercase($word);
```

### lowercase

The `lowercase function` converts the given `string` value to all lowercase. For example:

```swift
var word:string = "ONE";
call @lowercase($word);
```

### titlecase

The `titlecase function` capitalizes the first letter of every word in the given `string` value. For example:

```swift
var word:string = "hello world!";
call @titlecase($word);
```

### split

The `split function` returns an `array` of `strings` split out of the given `string` using the given delimiter `string`. For example:

```swift
var phrase:string ="one,two,three";
var parts:string array = @split($phrase, ",");
```

### leftString

The `leftString function` returns the left n characters from the given string. For example:

```swift
var word:string = "hello world!";
var part:string = @leftString($word, 5);
```

The value of `part` is `hello`.

### rightString

The `rightString function` returns the right n characters from the given `string`. For example:

```swift
var word:string = "hello world!";
var part:string = @rightString($word, 6);
```

The value of `part` is `world!`.

### midString

The `midString function` returns the middle n characters from the given `string` from a starting index. For example:

```swift
var word:string = "hello world!";
var part:string = @midString($word, 6, 5);
```

The value of `part` is `world`.
