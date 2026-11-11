# Grace Expressions

Write multi-operator calculations and comparisons while preserving Grace's explicit, beginner-friendly grouping rules.

## Runtime Identifier Resolution

Grace continues to support its explicit dereference characters:

- `$` dereferences a variable.
- `@` dereferences a function.
- `#` dereferences an enumeration.

These characters preserve existing source compatibility and provide the most direct lookup path. They may also be omitted:

```swift
main {
    var first:int = 2;
    var second:int = 3;
    let first = (first + second);
    return first;
}
```

The compiler stores an omitted identifier as a runtime-resolved expression. Runtime resolution is required because a precompiled executable can be attached to a different executable chain before it runs.

Ordinary lookup favors a variable, then a function, then an enumeration. Once a binding is selected, type checking and evaluation continue without trying another symbol kind. A function selected by a bare name must take no parameters.

Syntax can require or favor a particular kind:

- `calculate(a, b)` favors a function.
- `Colors~red` favors an enumeration.
- `let result = 10;` requires an assignable variable.
- `items[position]` requires a variable.

Lookup follows Grace's existing scope and executable-chain rules. An unresolved omitted name compiles successfully and produces a runtime “symbol not found” error only if it remains unavailable when executed.

## Multi-Operator Expressions

Every expression containing a binary arithmetic, comparison, or logical operator must have dedicated outer parentheses:

```swift
let result = (a + b * c - d);
return (result > minimum and enabled);
```

There is no artificial operand or operator count limit. Existing nested binary expressions remain valid:

```swift
let result = (($a + $b) + $c);
```

Unary operations such as `not enabled` do not require dedicated parentheses.

## Precedence and Grouping

Grace applies these precedence levels from highest to lowest:

1. `*`, `/`
2. `+`, `-`
3. `=`, `!=`, `<`, `>`, `<=`, `>=`
4. `&`, `and`
5. `|`, `or`

Operators at the same level associate from left to right. Add inner parentheses to override precedence:

```swift
let natural = (a + b * c);
let overridden = ((a + b) * c);
```

Call parentheses, array brackets, and collection brackets do not substitute for an expression's required parentheses:

```swift
calculate((a + b));
return values[(position + 1)];
```

## Logical and Comparison Rules

`and` and `or` use short-circuit evaluation. The right side is evaluated only when its value is needed:

```swift
if (divisor != 0 and (value / divisor) > 2) {
    print("Matched");
}
```

Chained comparisons are a compile-time error:

```swift
// Invalid
(a < b < c)

// Valid
(a < b and b < c)
```

This explicit form keeps comparison intent clear for beginning programmers.
