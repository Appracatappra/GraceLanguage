# ``GraceLanguage``

Grace is a [Turning-Complete](https://en.wikipedia.org/wiki/Turing_completeness) scripting language written 100% in pure Swift that can be used in applications such as spreadsheet calculations, database manipulations or game engines.

## Overview

Grace supports features such as global & local variables, enumerations, libraries, functions, and limited structure support (see Structures details). Additionally, Grace was designed to be easily extended by **Registering** external functions. This allow Grace to be fully interoperable with its host language and program.

Grace was named in honor of [Rear Admiral Grace M. Hopper](https://en.wikipedia.org/wiki/Grace_Hopper). Not only did she come up with the idea of high-level computer programming languages, but we also have her to thank for the term "debugging".

From Wikipedia:

> One of the first programmers of the Harvard Mark I computer, she was a pioneer of computer programming. Hopper was the first to devise the theory of machine-independent programming languages, and the FLOW-MATIC programming language she created using this theory was later extended to create COBOL, an early high-level programming language still in use today.


## Basic Syntax And Structure

In Grace **Enumerations**, **Structures** and **Functions** are defined in the **Global Space** along with a special function `main` that acts as the main entry point into the program.

Additionally, library **Imports** and **Variables** can be defined in the **Global Space** and they will be available in everywhere throughout the Grace program. Let's take a look at a simple Grace program to see how this works:

```
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

This allowed me to keep the `GraceCompiler` quick and small, since the *decorator* tells compiler exactly what it is processing, while not putting to much effort on the developer and not cluttering the langauge too much.

This is also why you use the `let` and `call` keywords for modifying variables and calling functions and why expressions always follow the form `(value operator value)`.

These consessions keep the `GraceCompiler` from having to determine the developer's intent, thus speeding up the compile process.

