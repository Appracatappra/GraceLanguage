# Grace Loops

Grace provides the following types of looping statements: `iterate-in`, `for-in`, `while` and `repeat-until`.

## Overview

Grace contains four main types of looping mechanisms:

* `iterate-in` - Loops through all of the items in an array.
* `for-in` - Loops through all values in a from/to range.
* `while` - Loops while a condition is `true`.
* `repeat-until` - Loops until a condition is `true`.

The following sections will go over each in detail.

### Iterate-In

`Iterate` takes the form:

```
iterate variable in array {
	instruction;
}
```

Where `variable` will be created and filled with the current item in the loop. For example:

```
var words:string array = ["Hello", "World"];

iterate word in $words {
	print($word)
}
```

The above will print all of the string in the array to the standard output.

### For-in

A `for` statement loops between a from and to number range and takes the form:

```
for variable in value to value {
	instruction;
}
```

The variable will hold the current value for the loop. For example:

```
var words:string array = ["Hello", "World"];

for n in 0 to (@count($words) - 1) {
	print($words[$n])
}
```

This is functionally equivalent to the `iterate` function above.

> **NOTE:** The `to` value must be greater than the `from` value currently. This will be addressed in future releases.

### While

A `while` statement will execute a list of instruction while a condition is met and takes the form:

```
while (value operation value) {
	instruction;
}
```

For example:


```
var n:int = 10;

while ($n > 0) {
	print(("Number: " + $n))
	decrement $n;
}
```

This code will print 10 to 1 backwards and then exit the loop.

### Repeat-Until

A `repeat-until` statement will execute a list of instructions until a condition is met and takes the form:

```
repeat {
	instruction;
} (value operation value)
```

For example:

```
var n:int = 0;

repeat {
	increment $n;
} until ($n == 10)
```

Prints 1 to 10 and then exits the loop.
