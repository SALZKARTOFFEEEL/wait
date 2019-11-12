# `wait`
Waits for a value to become true or a function to return true.
Emulates `WinWait` and similar but supports any kind of check.

## Definition
```autohotkey
info := wait(value, timeout := -1, interval := 100)
```
* `value`: The value continuously checked
or the function whose return value is continuously checked.
* `timeout` – _integer_: Number of milliseconds to wait for at most.
* `interval` – _integer_: Number of milliseconds to wait before retrying.
* `info` – _object_: The return object.
Can have the following two properties:
  * `val`[⁽¹⁾](#remarks):
    * The return value of the last call to `value`,
    if `value` is considered callable[⁽²⁾](#remarks),
    * `value` itself, otherwise.
  * `condition`:
    * `"timeout"` if the `timeout` being reached caused `wait` to terminate.
    * `"true"`: if `wait` was terminated because value evaluated to `true`.

#### Remarks
1.  `info.val` is present only if `info.condition` is `"true"`

2. `value` is considered callable when either of these conditions is met:
  * `type(value) == "Func"` – `value` is a [Func Object](https://lexikos.github.io/v2/docs/objects/Func.htm).
  * `type(value) == "BoundFunc` – `value` is a [BoundFunc Object](https://lexikos.github.io/v2/docs/objects/Functor.htm#BoundFunc).
  * `value.hasMethod("Call")` – `value` is a [Functor](https://lexikos.github.io/v2/docs/objects/Functor.htm) or any other object that implements a `Call` method.

  These conditions are tested for in the order specified above,
  with short-circuit evaluation.
  If either test throws an exception
  (though only the last one is expected to do so),
  `value` is considered not callable.


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