# Grace Flow Control

Grace supports `if-then-else` and `switch-case-default` statements to control the flow of the program.

## Overview

If-then statements in a Grace Program are in the form:

```swift
if (value operator value) {
	instruction;
	...
} [else {
	instruction;
	...
}]
```

Grace comparisons must always be in parenthesis and be in the form `(value operator value)`. The following operators are supported:

* `=` - Test for equality.
* `!=` - Does not equal.
* `<` - Less than.
* `>` - Greater than.
* `<=` - Less than or equal to.
* `>=` - Greater than or equal to.
* `&` - And two boolean values.
* `|` - Or two boolean values.

If the condition is met, all of the instructions are executed else all instructions in the optional `else` statement are executed.

To negate an operation, use the `not` statement. For example:

```swift
if not $user.isRegistered {
	let $user.isRegistered = true;
}
```


## The Switch Statement

The `switch` statement allows you to compare a value against a list of possible options and take action if an option is met. It takes the form:

```swift
switch variable {
	case value {
		instruction;
	}
	case value {
		instruction;
	}
	...
	
	[default {
		instruction;
	}]
}
```

Where `variable` is the variable that you are comparing and `case value` is the possible matching options. If the optional `default` statement is include, its instructions will be executed if the value doesn't match any other `case`. For Example:

```swift
var first:bool = true;
var flag:string = "off";
...

switch $flag {
	case "on" {
		let $first = true;
	}
	case "off" {
		let $first = false;
	}
	default {
		print("Nope!")
	}
}

```

When executed, the value of the variable `first` will be set to `false`.