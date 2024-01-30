# Grace StandardLib

The Grace `StandardLib` defines a common library of `functions` that you might find useful in your Grace Programs.

## Overview

The `StandardLib` defines common `functions` such as `print` and `printf` that write output to the debugging console. To use `StandardLib` in your Grace Program, use `import StandardLib;` at the start of your code. For example:

```swift
import StandardLib;

main {
    var n:int = 2;
    var word:string = "points";
    
    call @printf("You have {0} {1}.", [$n, $word]);
}
```

This program loads the `StandardLib` so it has access to the `printf function` (or *Print Formatted*). When run, it will write "You have 2 points." to the debugging console.

> The `StandardLib` is contained inside of the `GraceCompiler` using the `register` feature. If you want to see how to use the `register` feature or expand the library, this is where to look.

## StandardLib Functions

The `StandardLib` defines the following `functions`:

### print

Writes a simple `string` message to the debugging console. It has the following calling structure:

```swift
call @print("Message");
```

### printf

The `printf function` takes a formatting `string` and a list of variables and inserts the variables in the `string` by replacing keys in the form `{0}` where the number is the index of the desired value in the passed in array. For Example:

```swift
var n:int = 2;
var word:string = "points";
call @printf("You have {0} {1}.", [$n, $word]);
```

### count

Returns the number of elements in a passed in array:

```swift
var colors:string array = ["Red", "Yellow", "Green"];
var items:int = @count($colors);
```

### random

Returns a random `int` from a given range of integers:

```swift
var n:int = @random(1,10);
```

### arrayContains

Returns `true` if the given `array` contains the given value:

```swift
var colors:string array = ["Red", "Yellow", "Green"];
var hasRed:bool = @arrayContains($colors, "Red");
```

### negateInt

Returns the passed in value as a negated `int` (eg n = n * -1):

```swift
var n:int = 10;
call @negateInt($n); // n = -10
```

### negateFloat

Returns the passed in value as a negated `float` (eg n = n * -1):

```swift
var n:float = 10.0;
call @negateFloat($n); // n = -10.0
```

### Type Casting

Given that Grace Variables are loosely typed, they can typically be automatically cast to the correct value. That said there are specific cases where you might need to forcibly cast a Variable.

If those cases you can use the following functions:

```swift
var x:string = "true";
var s:string = @toString($x); // Force to string
var b:bool = @toBool($x); // Force to bool
var i:int = @toInt($x); // Force to int
var f:float = @toFloat($x); // Force to float
```


> In the event that the value cannot be cast, the result will be the default for the variable type. For example, both `i` and `f` would equal `0` after running the code above.