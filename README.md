# GraceLanguage

![](https://img.shields.io/badge/license-MIT-green) ![](https://img.shields.io/badge/maintained%3F-Yes-green) ![](https://img.shields.io/badge/swift-5.4-green) ![](https://img.shields.io/badge/iOS-17.0-red) ![](https://img.shields.io/badge/macOS-14.0-red) ![](https://img.shields.io/badge/tvOS-17.0-red) ![](https://img.shields.io/badge/watchOS-10.0-red) ![](https://img.shields.io/badge/dependency-LogManager-orange) ![](https://img.shields.io/badge/dependency-SimpleSerializer-orange) ![](https://img.shields.io/badge/dependency-SwiftletUtilities-orange)

`GraceLanguage` provides a Turning-Complete scripting language can be used in applications such as spreadsheet calculations, database manipulations or game engines. 

## Overview

Grace is a [Turning-Complete](https://en.wikipedia.org/wiki/Turing_completeness) scripting language written 100% in pure Swift that can be used in applications such as spreadsheet calculations, database manipulations or game engines.

Grace supports features such as global & local variables, enumerations, libraries, functions, and limited structure support (see *Grace Variables > Working with Structures* documentation). Additionally, Grace was designed to be easily extended by **Registering** external functions. This allow Grace to be fully interoperable with its host language and program.

Grace was named in honor of [Rear Admiral Grace M. Hopper](https://en.wikipedia.org/wiki/Grace_Hopper). Not only did she come up with the idea of high-level computer programming languages, but we also have her to thank for the term "debugging".

From Wikipedia:

> One of the first programmers of the Harvard Mark I computer, she was a pioneer of computer programming. Hopper was the first to devise the theory of machine-independent programming languages, and the FLOW-MATIC programming language she created using this theory was later extended to create COBOL, an early high-level programming language still in use today.

## Support

If you find `GraceLanguage` useful and would like to help support its continued development and maintenance, please consider making a small donation, especially if you are using it in a commercial product:

<a href="https://www.buymeacoffee.com/KevinAtAppra" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

It's through the support of contributors like yourself, I can continue to build, release and maintain high-quality, well documented Swift Packages like `GraceLanguage` for free.

## Installation

**Swift Package Manager** (Xcode 11 and above)

1. In Xcode, select the **File** > **Add Package Dependency…** menu item.
2. Paste `https://github.com/Appracatappra/GraceLanguage.git` in the dialog box.
3. Follow the Xcode's instruction to complete the installation.

> Why not CocoaPods, or Carthage, or etc?

Supporting multiple dependency managers makes maintaining a library exponentially more complicated and time consuming.

Since, the **Swift Package Manager** is integrated with Xcode 11 (and greater), it's the easiest choice to support going further.


# Basic Syntax And Structure

In Grace **Enumerations**, **Structures** and **Functions** are defined in the **Global Space** along with a special function `main` that acts as the main entry point into the program.

Additionally, library **Imports** and **Variables** can be defined in the **Global Space** and they will be available in everywhere throughout the Grace program. The StandardLib contains built-in functions such as `print` and `printf`. StringLib contains string manipulation functions such as `leftString` and `midString`.

Let's take a look at a simple Grace program to see how this works:

```swift
import StandardLib;

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
* `@` is used to dereference a function (either internal or external).
* `$` is used to dereference a variable.
* `#` is used to dereference an `enumeration`.
* `~` is used to dereference a property of an `enumeration` or `structure`.
* The functions `@print`, `@printf` and `@count` are defined in the `StandardLib` imported at the start of the program.


## Why Use The Special Dereference Characters?

When designing the Grace Language, one of my driving factors was to keep the language small, light and fast. To achieve this goal, I chose to use *decorators* when dereferencing **Functions**, **Variables** and **Enumerations**.

This allowed me to keep the `GraceCompiler` quick and small, since the *decorator* tells compiler exactly what it is processing, while not putting to much effort on the developer and not cluttering the language too much.

This is also why you use the `let` and `call` keywords for modifying variables and calling functions and why expressions always follow the form `(value operator value)`.

These concessions keep the `GraceCompiler` from having to determine the developer's intent, thus speeding up the compile process.

# Compiling and Executing Grace

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

main{
	// Your code goes here...
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

Upon executing the above code `result` will be a `GraceVariable` containing `10`. 

### Expanding String Macros

The `GraceRuntime.expandMacros` function can expand **Grace Function Macros** inside of a given string by executing the named function and inserting the result in the string. For example:

```swift
let text = GraceRuntime.shared.expandMacros(in: "The answer is: @intMath(40,'+',2)")
```

After running the above code, the value of `text` will be `The answer is: 42`.

For more information, please see the included documentation.

# Documentation

The **Package** includes full **DocC Documentation** for all features.
