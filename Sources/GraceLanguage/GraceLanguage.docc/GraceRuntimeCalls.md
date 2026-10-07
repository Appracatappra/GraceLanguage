# GraceRuntime Calls

The Grace Runtime executes Grace Script in the host app and optionally returns a result.

## Overview

The `GraceRuntime` provides several functions for running either pre-compiled script or text scripts in the host app and optionally receive a result from the execution.

### `run(executable:GraceExecutable)`

Runs a pre-complied Grace Script and optionally returns a value from the execution. The script is expected to contain a `main` function.

### `run(program:String)`

Compiles a Grace Script, runs it and optionally returns a value from the execution. The script is expected to contain a `main` function.

### `execute(function:String, against executable:GraceExecutable, with parameters:[GraceVariable] = [])`

Runs a pre-complied Grace Script and optionally returns a value from the execution. You specify the name of the function to execute against the pre-compiled script and optionally pass in any parameters as an array`GraceVariables`. 

The number of items in the parameter array must match the count and type of the parameters specified for the function.

### `run(script:String)` or `evaluate(script:String)`

Wraps the incomming script snippet in the following:

```swift
let program:String = "import StandardLib; import StringLib; import MacroLib; main{\(script);}"
```

Compiles a Grace Script, runs it and optionally returns a value from the execution.

### `run(script:String, against executable:GraceExecutable)` or `evaluate(script:String, against executable:GraceExecutable)`


Wraps the incomming script snippet in the following:

```swift
let program:String = "main{\(script);}"
```

Compiles a Grace Script, runs it against the passsed in executable and optionally returns a value from the execution.

### `expandMacros(in text:String)`

Expands any macros written as Grace Function Calls in the given string and inserts the result of executing the function into the output string. For example:

```swift
let text = GraceRuntime.shared.expandMacros(in: "The answer is: @intMath(40,'+',2)")
```

### `expandMacros(in text:String, against executable:GraceExecutable)`

Expands any macros written as Grace Function Calls against the given executable. in the given string and inserts the result of executing the function into the output string.

```swift
let executable = try GraceCompiler.shared.compile(program: someProgram)
let text = GraceRuntime.shared.expandMacros(in: "The answer is: @intMath(40,'+',2)", against: executable)
```



