# Grace Variables

Grace features "loosely typed" variables that are highly mutable and interchangeable. The `var` keyword is used to define a variable and variables are scoped to the level they are created in.

## Overview

In Grace, the `var` keyword is used to define a variable and variables are scoped to the level they are created in. So a variable created inside of a `function` would not be accessible inside another `function`. Additionally, a variable created inside of a `if` statement would not be accessible outside of that `if` statement.

The exception to this rule is variables created inside of the **Global Space**, they accessible everywhere inside of the Grace program.

It should also be noted that creating a variable of the same name as a variable at the same scope level will replace the existing variable with the new one.

Grace supports the following variable types:

* `string` - A string of characters inside of either single `'` or double `"` quotes.
* `bool` - A `true` or `false` value.
* `int` - An integer value.
* `float` - A float value.
* `enumeration` - An enumeration, followed by the name of an enumeration defined in the **Global Space**.
* `structure` - A structure, followed by the name of an enumeration defined in the **Global Space**.
* `any` - Can hold any type of value.

Additionally, you have the following special types:

* `null` - A variable that contains "nothing".
* `void` - The lack of a variable, mainly used for defining external function return types.

The base types can be turned into arrays using the `array` keyword after the type. For example: `var n:int array;` would define an integer array called `n`.

### Creating Variables

As stated above, variables are created using the `var` keyword and take the form:

`var` name `:` type [`=` default value] `;`

The minimal requirement is name and type, the default value is optional. Default values can be specified as:

* A constant `var n:int = 5;`
* Another variable `var x:int = $n;`
* The result of a function `var y:int = @add($n, $x);`
* An enumeration value `var color:enumeration Colors = #Color~red;`
* The result of an expression `var z:int = ($y - $n);`

### Mofidying Variables

When modifying a variable, start with the `let` keyword and use the following form:

`let $` name `=` expression `;`

The following types of expressions are supported:

* Constants `let $n = 10;`
* Variables `let $n = $z;`
* Functions `let $y = @add($n, $x);`
* Enumerations `let $color = #Colors~blue;`
* Expressions `let $z = ($n + $y);`

### Working With Arrays

Arrays are created using the `array` keyword after the base type in the form:

`var` name `:` type `array` [`=` default value] `;`

For arrays, default values are specified in the form:

`[` value `,` value `,` ... `]`

For example `var colors:string array = ["red", "yellow", "green"];` would create a string array called `colors` with the default values of red, yellow and green.

To access the items in an array, use the form:

`$` name `[` index `]`

Given the example above `$colors[1]` would return "yellow", since Grace arrays are zero based. You can modify an array item in the same way. So `let $colors[2] = "lime";` would change the last value in the array from "green" to "lime".

#### Modifying Arrays

You can either append a new value to the end of an array, or insert it at a specific index using the `add` keyword in the follow format:

`add` value `to $` array name [`at index` value] `;`

Using the same `colors` example above, `add "olive" to $colors;` would append "olive" to the end of the array and `add "pink" to $colors at index 1;` would insert "pink" after "red".

Use the `delete` keyword to remove an item from an array in the form:

`delete index` value `from $` array name `;`

So `delete index 0 from $colors;` would remove "red" from our array.

You can completely empty an array using the `empty` keyword, for example `empty $colors;`.

If you import the `StandardLib` into your Grace Program, you can use the `@count` function to get the number of items in an array, for example "@count($colors)".

### Working With Enumerations

Grace features `enumerations` that are defined in the **Global Space** outside of `main` or a `function` definition that can be used to create variables that are checked against the values in the `enumeration` and must contain a property of their parent enumeration.

#### Defining An Enumeration

In the **Global Space** outside of `main` or a `function` use the following syntax to define an `enumeration`:

`enumeration` name `{` property `,` property `,` ... `};`

Take the following example:

```
enumeration Colors {
    red,
    orange,
    yellow,
    green,
    blue,
    indigo,
    violet
}
```

This creates an `enumeration` called `Colors` with the given list of properties.

#### Using Enumerations

First you must create a variable that conforms to the `enumeration` type in the form:

`var` name `:enumeration` enumeration name [`=` default value] `;`

Given our example above, look at the following code:

```
main {
	var background:enumeration Colors = #Colors~green;
}
```

It creates a variable called `background` that conforms to the `Colors` `enumeration` and sets the default value to `green`.

> **NOTE:** When dereferencing an `enumeration` you'll use the `#` character just before the `enumeration's` name. Additionally, use the `~` to separate the `enumeration` name from the property name.

Since the Grace Compiler knows which `enumeration` variable `background` belongs to, we could have used the shortcut syntax:

```
main {
	var background:enumeration Colors = green;
}
```

### Working with Structures

Grace `structures` define a way to group related data together in one Grace Variable.

#### Defining A Structure

In the **Global Space** outside of `main` or a `function` use the following syntax to define an `structure`:

```
structure name {
	property name:type,
	property name:type,
	...
}
```

> **NOTE:** Grace only supports simple `structures` at this time that are only composed of `string`, `bool`, `int` or `float` types with no substructures or arrays.

Take the following example:

```
structure UserAccount {
    name:string,
    email:string,
    phone:string
}
```

It defines a `structure` called `UserAccount` with three `string` properties.

#### Using Structures

First you must create a variable that conforms to the `structure` type in the form:

`var` name `:structure` structure name [`=` new structure name()] `;`

Given our example above, look at the following code:

```
main {
	var user:structure UserAccount = new UserAccount(name:"Jane Doe", email:"jdoe@mac.com", phone:"713-555-1212");
}
```

It creates a variable `user` that conforms to the `structure UserAccount` and creates a `new` instance of the `UserAccount` structure and populates it with default values. Could can also create a new "empty" `structure` using `new()`.

You can also do just one or more default value, for example `new UserAccount(name:"Jane Doe")` the missing properties will be there default "empty" values.

To set or access `structure` properties, use code like the following:

```
let $user~name = "John Doe";
call @printf("User Name = {0}, email: {1}", [$user~name, $user~email]);
``` 

> **NOTE:** When dereferencing a `structure` you'll use the `$` character just before the `structure's` name (just like any other Grace Variable). Additionally, use the `~` to separate the `structure` variable name from the property name.
