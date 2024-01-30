# Grace MacroLib

The Grace `MacroLib` defines a common library of `functions` that you might find useful in your Grace Programs or when expanding macros in a string using the `expandMacros` function.

## Overview

The `MacroLib` defines common `functions` such as `if` and `randomString` that change the output of the given string. To use `MacroLib` in your Grace Program, use `import MacroLib;` at the start of your code. For example:

```swift
import MacroLib;

main {
    return @randomString(["One", "Two", "Three"]);
}
```

This program loads the `MacroLib ` so it has access to the `randomString function`. When run, it will return "One", "Two" or "Three" to the caller at random.

### Expanding String Macros

The `GraceRuntime.expandMacros` function can expand **Grace Function Macros** inside of a given string by executing the named function and inserting the result in the string. For example:

```swift
let text = GraceRuntime.shared.expandMacros(in: "The answer is: @intMath(40,'+',2)")
```

When calling `expandMacros`, the `StandardLib`, `StringLib` and `MacroLib` will automatically be imported into the Grace Program before execution.

> The `MacroLib` is contained inside of the `GraceCompiler` using the `register` feature. If you want to see how to use the `register` feature or expand the library, this is where to look.

## MacroLib Functions

The `MacroLib` defines the following `functions`:

### if

The `if` function evaluates the given `condition` and returns the given `isTrue` value if the result is `true`. If the result is `false` and the optional `isFalse` value is provided, it will be returned instead. It has the following calling structure:

```swift
let text = GraceRuntime.shared.expandMacros(in: "The answer is: @if((2 > 4), `Greater Than`, `Less Than`)")
```

### randomString

The `randomString` function returns one of the passed in string array items at random. It has the following calling structure:

```swift
let text = GraceRuntime.shared.expandMacros(in: "The answer is: @randomString(['one','two','three'])")
```

### selectString

The `selectString` function returns one of the passed in string array items at based on the passed in index. It has the following calling structure:

```swift
let text = GraceRuntime.shared.expandMacros(in: "The answer is: @selectString(2,['zero','one','two','three'])")
```

### intMath

The `intMath` function performs the given `operation` on two passed in `int` values. It has the following calling structure:

```swift
let text = GraceRuntime.shared.expandMacros(in: "The answer is: @intMath(40,'+',2)")
```

The possible `operations` are:

* `'+'` - Add the two numbers.
* `'-'` - Subtract the second number from the first.
* `'*'` - Multiply the two numbers.
* `'/'` - Divide the first number by the second.

### floatMath

The `floatMath` function performs the given `operation` on two passed in `float` values. It has the following calling structure:

```swift
let text = GraceRuntime.shared.expandMacros(in: "The answer is: @floatMath(2.5,'+',2.5)")
```

The possible `operations` are:

* `'+'` - Add the two numbers.
* `'-'` - Subtract the second number from the first.
* `'*'` - Multiply the two numbers.
* `'/'` - Divide the first number by the second.

### formatFloat

The `formatFloat` function returns the given `float` value formatted with two decimal places and a comma as a thousands separator. It has the following calling structure:

```swift
let text = GraceRuntime.shared.expandMacros(in: "The answer is: @formatFloat(5000)")
```

### expandMacros

The `expandMacros` function returns the given `string` with any **Grace Function Macros** expanded. It has the following calling structure:

```swift
import MacroLib;

main {
    var text:string = @expandMacros("Result: @intMath(40,'+',2)");
    call @print(text);
}
```
