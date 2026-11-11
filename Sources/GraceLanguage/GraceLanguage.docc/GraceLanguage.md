# ``GraceLanguage``

Grace is a [Turning-Complete](https://en.wikipedia.org/wiki/Turing_completeness) scripting language written 100% in pure Swift that can be used in applications such as spreadsheet calculations, database manipulations or game engines.

## Overview

Grace supports features such as global & local variables, enumerations, libraries, functions, and limited structure support (see *Grace Variables > Working with Structures* documentation). Additionally, Grace was designed to be easily extended by **Registering** external functions. This allow Grace to be fully interoperable with its host language and program.

Grace was named in honor of [Rear Admiral Grace M. Hopper](https://en.wikipedia.org/wiki/Grace_Hopper). Not only did she come up with the idea of high-level computer programming languages, but we also have her to thank for the term "debugging".

From Wikipedia:

> One of the first programmers of the Harvard Mark I computer, she was a pioneer of computer programming. Hopper was the first to devise the theory of machine-independent programming languages, and the FLOW-MATIC programming language she created using this theory was later extended to create COBOL, an early high-level programming language still in use today.


## Basic Syntax And Structure

In Grace **Enumerations**, **Structures** and **Functions** are defined in the **Global Space** along with a special function `main` that acts as the main entry point into the program.

Additionally, library **Imports** and **Variables** can be defined in the **Global Space** and they will be available everywhere throughout the Grace program. The `StandardLib` contains built-in `functions` such as `print` and `printf`, `StringLib` contains string manipulation `functions` such as `leftString` and `midString`, and `MathLib` contains mathematical `functions` such as `squareRoot`, `sine`, and `round`.


Let's take a look at a simple Grace program to see how this works:

```swift
import StandardLib;
import StringLib;
import MathLib;

enumeration Colors {
    red,
    orange,
    yellow,
    green,
    blue,
    indigo,
    violet
}

structure FullName {
    first:string,
    last:string
}

main {
    var n:int;
    var words:string array = ["One", "Two", "Three", "Four"];
    var color:enumeration Colors = #Color~green;
    var person:structure FullName = new FullName(first:"Jane", last:"Doe");
    var name:string = @join($person~first, "!");
    
    let $n = (@count($words) - 1);
    
    if ($words[$n] = "Four") {
        call @print("It is four.");
    } else {
        call @print("It is not four.");
    }
    
    iterate word in $words {
        call @print($word);
    }
    
    call @sayHello($name);
}

function join(a:string, b:string) returns string {
    return ($a + $b);
}

function sayHello($name:string) {
    call @printf("Hello {0}", [$name]);
}
```

So a few things to point out here:

* `var` is used to define a variable.
* `let` is used to modify a variable.
* All instructions end with a semicolon `;`.
* `@` explicitly dereferences a function (either internal or external).
* `$` explicitly dereferences a variable.
* `#` explicitly dereferences an `enumeration`.
* `~` is used to dereference a property of an `enumeration` or `structure`.
* The functions `@print`, `@printf` and `@count` are defined in the `StandardLib` imported at the start of the program.
* Dereference characters can be omitted when runtime inference is desired.


## Why Use The Special Dereference Characters?

When designing the Grace Language, one of my driving factors was to keep the language small, light and fast. To achieve this goal, I chose to use *decorators* when dereferencing **Functions**, **Variables** and **Enumerations**.

This keeps the explicit path through the `GraceCompiler` and `GraceRuntime` quick and small, since the *decorator* identifies exactly what is being processed.

The explicit characters remain supported for performance and backward compatibility. Grace can also compile an omitted identifier into a runtime lookup, allowing it to resolve symbols exposed by a chained executable after compilation.

See <doc:Grace-Expressions> for runtime resolution rules, multi-operator expressions, precedence, grouping, and short-circuit behavior.

## Compiling and Executing Grace

The **GraceLanguage Package** has the tools to compile and run programs written in Grace.

## GraceCompiler

The `GraceCompiler` converts a `string` or text file containing the Grace Program into byte code for faster execution.

You can either precompile your Grace Program using the `GraceCompiler` or you can call methods of the `GraceRuntime` to compile and execute a Grace Program in one step.

Additionally, you can either create your own instance of the `GraceCompiler` or use the common shared instance `GraceCompiler.shared`.

The following is an example of precompiling a Grace Program:

```swift
import GraceLanguage;

var program:String {
    return """
    main {
    	call @print("Hello World!");
    }
    """
}

do {
	let executable = try GraceCompiler.shared.compile(program: program)
} catch {
	print("Error: \(error)")
}
```

Additionally, you can extend an existing **Grace Executable** using the `compileSegment` command. With this function you can include new **Global Variables**, **Enumerations**, **Structures** or **Functions** from an external script or a library written in Grace. For Example:

```swift
import GraceLanguage;

var program:String {
    return """
    main {
        call @print("Hello World!");
    }
    """
}

do {
    var exe = try GraceCompiler.shared.compile(program: program)
    
    let library = """
        function OnItemB() returns string {
            return "Item B";
        }
        """
        
    exe = try GraceCompiler.shared.compileSegment(executable: exe, programSegment: library)
} catch {
    print("Error: \(error)")
}
```

You can also chain compiled Grace scripts together using the `base` property of **Grace Compiler** `compile(program:String, against base:GraceExecutable? = nil)`. 

Using a `base` executable allows the compilation to be broken into sections, with each section acting as its own "namespace". If a variable, function, enum or container is not defines in the current executable, the Grace Runtime will walk up the list of compiled scripts looking for it. Inversly, an element defined in the current executable will take presidence over elements from the base executable.

For more information, please see the included documentation.

## GraceRuntime

The `GraceRuntime` can either execute a precompiled Grace Program or it can compile and execute the program in one step.

The following is an example of compiling and executing a program in one step:

```swift
import GraceLanguage;

var program:String {
    return """
    main {
    	call @print("Hello World!");
    }
    """
}

do {
	try GraceRuntime.shared.run(program: program)
} catch {
	print("Error: \(error)")
}
```

Additionally, you can run a snippet of Grace Code without the required `main function` using:

```swift
do {
	try GraceRuntime.shared.run(script: "call @print('Hello World!');")
} catch {
	print("Error: \(error)")
}
```

Using this function, the snippet of code will be wrapped in the following Grace code before compiling and executing:

```swift
import StandardLib;
import StringLib;
import MacroLib;
import MathLib;

main{
	// Your code goes here...
}
```

Additionally, you can run a snippet of Grace Code without the required `main function` using:

```swift
do {
    try GraceRuntime.shared.run(script: "call @print('Hello World!');")
} catch {
    print("Error: \(error)")
}
```

### Returning An Execution Result

All of the execution methods built into the `GraceCompiler` can return a result to the calling program. For example:

```swift
let code = """
import StandardLib;
    
main {
    var n:int = 5;
    var x:int = 5;
    
    return ($n + $x);
}
"""
    
let result = try GraceRuntime.shared.run(program: code)
print("The result is: \(result?.int)")
```

Upon executing the above code `result` will be a `GraceVariable` containing `10`. As above, you can also run this against a precompiled Grace Executable.

### Expanding String Macros

The `GraceRuntime.expandMacros` function can expand **Grace Function Macros** inside of a given string by executing the named function and inserting the result in the string. For example:

```swift
let text = GraceRuntime.shared.expandMacros(in: "The answer is: @intMath(40,'+',2)")
```

After running the above code, the value of `text` will be `The answer is: 42`. Again, you can also run this against a precompiled **Grace Executable**.

For more information, please see the included documentation.

# Documentation

The **GraceLanguage Package** includes full **DocC Documentation** for all of Grace's features.

## Topics

### Language Guide

- <doc:Grace-Expressions>
- <doc:Grace-Variables>
- <doc:Grace-Functions>
- <doc:Grace-Flow-Control>
