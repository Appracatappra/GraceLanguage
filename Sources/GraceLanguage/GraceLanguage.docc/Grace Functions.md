# Grace Functions

Grace supports a full range of `function` types, including external functions written in Swift in the host app that the `GraceRuntime` is running in. Additionally, the special `main` function is used to define the **Main Entry Point** into the program and is called to do all of the work.


## Overview

As stated above, Grace `functions` can be of three different types:

* `main` - The main enter point of the Grace program.
* `function` - A subroutine written in Grace in the **Global Space** that can optionally take parameters and return an optional value.
* `register` - Registers an external `function` with either the `GraceCompiler` or a `GraceExecutable` created by a compiler.

### Working With Main

As stated above, a Grace app must include a `main` "function" that acts as the **Main Entry Point** into the program in the **Global Space**. This function is called when the program is run by the `GraceRuntime`.

The `main` function is defined as follows:

```
main {
	instruction;
	instruction;
	...
}
```

For example:

```
main {
var colors:string array = ["Red", "Orange", "Yellow", "Green", "Blue", "Indigo", "Violet"];
var background:enumeration Colors = #Colors~green;
var user:structure UserAccount = new UserAccount(name:"Jane Doe", email:"jdoe@mac.com", phone:"713-555-1212");
}
```

> **NOTE:** There can one be one `main function` in a Grace Program.

### Grace Functions

Grace contains functions defined in the **Global Space** that support optional parameters and return an optional value with full recursion support as well. Grace does not support sub functions, sub structures or sub enumerations at this time.

Functions are defined in the form:

```
function name([parameter:type, parameter:type, ...]) [returns type] {
	instruction;
	instruction;
	...
}
```

For example:

```
function sayHello() {
	call @print("Hello World");
}

function sayHi(name:string) {
    if ($name = "") {
        call @print("Hi World!");
        return;
    }
    
    call @printf("Hi {0}!",[$name]);
}
    
function hasColor(colors:string array, color:string) returns bool {
    iterate item in $colors {
        if ($item = $color) {
            return true;
        }
    }
    
    return false;
}
```

Function `sayHello` takes no parameters and returns no value. Control returns to the caller when the end of the function is reached.

Function `sayHi` takes a single parameter `name` and does not return a value. The `return` statement stops execution and returns control back to the caller.

Function `hasColor` takes a two parameters `colors` & `colors` and returns a `bool` value. The `return true;` & `return false;` statements stops execution and returns control back to the caller with the given Grace Variable.

The following is an example of calling the defined `functions` above from `main`:

```
main {
    var colors:string array = ["Red", "Orange", "Yellow", "Green", "Blue", "Indigo", "Violet"];
    
    if @hasColor($colors, "Orange") {
        call @print("Array has color.");
    } else {
        call @print("Array does not have color.");
    }
    
    if ($background = #Colors~green) {
        call @print("The background is green.");
    }
    
    call @sayHello();
    
    call @sayHi("Bob");
}
```

> **NOTE** When calling a Grace `function` you simply list the property values without the names in the order that they were defined.

Grace `functions` fully support recursion such as the following example:

```
function recurse(index:int) {
    var num:int = ($index + 1);
    
    call @printf("Index = {0}", [$num]);
    
    if ($num < 5) {
        call @recurse($num);
        call @printf("Backtrace is {0}", [$num]);
    }
}
```

## Registering External Functions

Grace can provide two way communication with the host environment by **registering** an external `function` written in Swift with either the `GraceCompiler` or a `GraceExecutable` created by the compiler.

If you want to include the given functionality with every app that an instance of the `GraceCompiler` compiles, register the external function here.

If you only want the functionality in a given app, register it with the `GraceExecutable`.

No matter where you `register` the `function` you'll use the same syntax:

```
.register(name: function name, parameterNames:["parameter1", "parameter2"], parameterTypes[.type, .type], returnType: .type ) { parameters in

}
```

Let's take a look at an example from the `StandardLib`:

```
// Add array item count.
executable.register(name: "count", parameterNames: ["array"], parameterTypes: [.any], returnType: .int) { parameters in
    var length:Int = 0
    
    if let array = parameters["array"] {
        length = array.count
    }
    
    return GraceVariable(name: "result", value: "\(length)", type: .int)
}
    
// Add random number generator.
executable.register(name: "random", parameterNames: ["to", "from"], parameterTypes: [.int, .int], returnType: .int) { parameters in
    var value:Int = 0
    
    if let to = parameters["to"] {
        if let from = parameters["from"] {
            value = Int.random(in: to.int...from.int)
        }
    }
    
    return GraceVariable(name: "result", value: "\(value)", type: .int)
}
```

The first one registers an external `function` called `count` that takes a single parameter `array` of type `.any` and returns a `.int` containing the number of items in the array.

The second one registers an external `function` called `random` that takes two parameters `to` & `from` of type `.int` and returns an `.int` containing a random number between the two values.

A `parameters` dictionary is passed to the function containing entries as `GraceVariable` types with the names given in `parameterNames`.

If the function returns a value, it will be in a `GraceVariable` type. For functions that don't return a value, just return `nil`. For example:

```
// Add print
executable.register(name: "print", parameterNames: ["message"], parameterTypes: [.any]) { parameters in
    
    if let message = parameters["message"] {
        Debug.info(subsystem: "Grace Runtime", category: "Print", message.string)
    }
    
    return nil
}
```

> **NOTE:** A `GraceVariable` always stores the `rawValue` as a `String`, however their are properties such as `.bool`, `.int` and `.float` to deal with the variable as other types. See `GraceVariable` for more details.