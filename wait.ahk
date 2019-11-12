wait(byref value, timeout := -1, interval := 100) {
  try if !(timeout && type(timeout) == "Integer")
    throw exception("Invalid timeout (param #2) specified.", -1)
  catch
    throw exception("Invalid timeout (param #2) specified.", -1)

  try if !(interval && type(interval) == "Integer" && interval >= 0)
    throw exception("Invalid interval (param #3) specified.", -1)
  catch
    throw exception("Invalid interval (param #3) specified.", -1)

  try if (type(value) == "Func" || type(value) == "BoundFunc" || value.hasMethod("Call"))
    funcObj := value

  end := 0
  if (timeout > 0)
    end := A_TickCount + timeout
  loop {
    if isSet(funcObj)
      val := funcObj.call()
    else
      val := value
    if (val)
      return val

    if (end && A_TickCount + interval > end) {
      sleep end - A_TickCount
      return
    }
    else {
      sleep interval
    }
    if (end && A_TickCount >= end)
      return
  }
}