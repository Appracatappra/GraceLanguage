# Grace MathLib

The Grace `MathLib` provides beginner-friendly functions for arithmetic, powers, logarithms, trigonometry, rounding, and floating-point values.

## Overview

Use `import MathLib;` at the start of a complete Grace program. MathLib is imported automatically when using `GraceRuntime.run(script:)` or `GraceRuntime.evaluate(script:)`.

```swift
import MathLib;

main {
    var sideA:float = 3;
    var sideB:float = 4;
    return @hypotenuse($sideA, $sideB);
}
```

MathLib parameters use Grace's loosely typed `any` type. Integers, floats, and numeric strings are accepted. A value that cannot be converted to a number becomes `0`. Mathematical functions return `float`, inspection functions return `bool`, and explicitly integer-producing functions return `int`.

MathLib preserves standard floating-point behavior. An operation with no real-number result can return `NaN`, an unbounded result can return positive or negative infinity, and some operations preserve negative zero.

## Constants

### pi

Returns π as a `float`:

```swift
var value:float = @pi();
```

### e

Returns Euler's number as a `float`: `var value:float = @e();`

### positiveInfinity and negativeInfinity

Return positive or negative infinity:

```swift
var upper:float = @positiveInfinity();
var lower:float = @negativeInfinity();
```

### notANumber

Returns the special `NaN` value: `var value:float = @notANumber();`

## Arithmetic

### absoluteValue

Returns the nonnegative magnitude of a value: `var value:float = @absoluteValue(-5);`

### remainder

Returns the remainder after truncating the quotient toward zero: `var value:float = @remainder(7, 4); // 3`

### ieeeRemainder

Returns the IEEE remainder using the nearest integral quotient: `var value:float = @ieeeRemainder(7, 4); // -1`

### minimum and maximum

Return the smaller or larger value. If only one argument is `NaN`, the numeric argument is returned.

```swift
var low:float = @minimum(3, 8);
var high:float = @maximum(3, 8);
```

### positiveDifference

Returns `a - b` when `a` is greater than `b`, otherwise `0`: `var value:float = @positiveDifference(8, 3);`

### copySign

Returns the magnitude of the first value with the sign of the second: `var value:float = @copySign(2, -1); // -2`

## Powers and Roots

- `power(base, exponent)` raises a base to an exponent.
- `square(value)` multiplies a value by itself.
- `cube(value)` raises a value to the third power.
- `squareRoot(value)` returns a square root.
- `cubeRoot(value)` returns a cube root.
- `hypotenuse(x, y)` returns the length of a right triangle's hypotenuse.

```swift
var area:float = @square(5);
var root:float = @squareRoot(81);
var diagonal:float = @hypotenuse(3, 4);
```

## Exponents and Logarithms

- `naturalExponent(value)` calculates e raised to a value.
- `powerOfTwo(value)` calculates 2 raised to a value.
- `naturalExponentMinusOne(value)` accurately calculates e raised to a value, minus one.
- `naturalLog(value)` calculates the natural logarithm.
- `baseTwoLog(value)` calculates the base-two logarithm.
- `baseTenLog(value)` calculates the base-ten logarithm.
- `naturalLogPlusOne(value)` accurately calculates the natural logarithm of one plus a value.

```swift
var power:float = @powerOfTwo(5); // 32
var exponent:float = @baseTwoLog(32); // 5
```

## Trigonometry

Angles passed to `sine`, `cosine`, and `tangent` are in radians. `inverseSine`, `inverseCosine`, `inverseTangent`, and `angleFromCoordinates` also return radians.

- `sine(radians)` returns the sine.
- `cosine(radians)` returns the cosine.
- `tangent(radians)` returns the tangent.
- `inverseSine(value)` returns the inverse sine.
- `inverseCosine(value)` returns the inverse cosine.
- `inverseTangent(value)` returns the inverse tangent.
- `angleFromCoordinates(vertical, horizontal)` returns the angle from the horizontal axis to a coordinate.
- `degreesToRadians(value)` converts degrees to radians.
- `radiansToDegrees(value)` converts radians to degrees.

```swift
var angle:float = @degreesToRadians(90);
var value:float = @sine($angle); // 1
```

## Rounding

- `roundUp(value)` rounds toward positive infinity and returns a `float`.
- `roundDown(value)` rounds toward negative infinity and returns a `float`.
- `round(value)` rounds halfway values away from zero and returns a `float`.
- `truncate(value)` removes the fractional portion toward zero and returns a `float`.
- `roundToInteger(value)` rounds halfway values away from zero and returns an `int`.

`roundToInteger` returns `0` for `NaN`, infinity, or a value outside the supported integer range.

## Inspecting Numbers

- `isFinite(value)` checks that a value is neither infinite nor `NaN`.
- `isInfinite(value)` checks for positive or negative infinity.
- `isNotANumber(value)` checks for `NaN`.
- `isNormal(value)` checks for a normal, nonzero floating-point value.
- `isNegative(value)` checks the sign bit, so it also detects negative zero.
- `classifyNumber(value)` returns `"normal"`, `"zero"`, `"subnormal"`, `"infinite"`, or `"notANumber"`.

```swift
var invalid:float = @squareRoot(-1);
var isInvalid:bool = @isNotANumber($invalid);
var kind:string = @classifyNumber($invalid);
```

## Floating-Point Utilities

### nextValueToward

Returns the next representable `float` after a value in the requested direction.

### scaleByPowerOfTwo

Multiplies a value by 2 raised to an integer exponent: `var value:float = @scaleByPowerOfTwo(3, 2); // 12`

### combineWithBinaryExponent

Combines a value with a binary exponent: `var value:float = @combineWithBinaryExponent(0.75, 2); // 3`

### binaryExponent

Returns the binary exponent as an `int`. Zero, infinity, and `NaN` return `0`.

### binaryExponentAsFloat

Returns the binary exponent as a `float`, preserving standard infinity and `NaN` behavior.
