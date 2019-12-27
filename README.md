# `wait`
Waits for a value to become true or a function to return true.  
Emulates built-in `WinWait`, `KeyWait`, etc. but supports any kind of check.

## Definition
```autohotkey
ret := wait(value, timeout := 0, interval := 100)
```
* `value`: The value continuously checked
or the function whose return value is continuously checked.
    * `value` is being called (used as a function),
    [if it is considered callable](#Remarks).
* `timeout` – _integer_: Number of milliseconds to wait for at most.
`0` (the default) will cause it to wait indefinitely.
* `interval` – _integer_: Number of milliseconds to wait before retrying.
`100` is the default.
Specifying `0` is valid and causes a [`Sleep 0`](https://lexikos.github.io/v2/docs/commands/Sleep.htm#Remarks).
* `ret`: The return value.
    * If `timeout` was reached, `ret` is an empty string.
    * Otherwise (if `value` became true), `ret` is
    `value` itself if it is not callable[⁽¹⁾](#Remarks), or otherwise
    the return value of the last call to `value.call()`.

#### Remarks
1. `value` is considered callable when either of these conditions is met:
    * `type(value) == "Func"` – `value` is a [Func Object](https://lexikos.github.io/v2/docs/objects/Func.htm).
    * `type(value) == "BoundFunc"` – `value` is a [BoundFunc Object](https://lexikos.github.io/v2/docs/objects/Functor.htm#BoundFunc).
    * `value.hasMethod("Call")` – `value` is a [Functor](https://lexikos.github.io/v2/docs/objects/Functor.htm) or any other object that implements a `Call` method.

    These conditions are tested for in the order specified above,
    with short-circuit evaluation.
    If either test throws an exception
    (though only the last one is expected to do so),
    `value` is considered not callable.

2. `wait` is able to throw an exception if the input arguments are invalid.
`timeout` and `interval` must both be a _pure Integer_ and be `0` or greater.
Any other exception is unintended and should be reported. Thank you!


## Examples
```autohotkey
; Example #1
; This will wait 1 second before setting x to true.
setTimer () => x := true, -1000

; This will consequently wait at least 1 second before continuing.
wait x
```
```autohotkey
; Example #2
; This will wait until the Spacebar is pressed,
; but will check for it much more frequently than KeyWait would.
wait () => getKeyState("Space"),, 10
```
```autohotkey
; Example #3
; This is exactly equivalent to the previous example.
wait func("getKeyState").bind("Space"),, 10
```
```autohotkey
; Example #4
; This will wait for Joystick #1 to be plugged in
; and display its name on the screen.
msgbox "Joystick '" wait(() => getKeyState("1JoyName")) "' has been plugged in!"
```