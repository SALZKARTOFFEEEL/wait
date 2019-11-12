wait(byref value, timeout := "", interval := "") {
  if (timeout != "") {
    if !(type(timeout) == "Integer" && timeout >= 0)
      throw exception("Invalid timeout (param #2) specified.", -1)
  }
  else
    timeout := 0 ; default value

  if (interval != "") {
    if !(interval != "" && type(interval) == "Integer" && interval >= 0)
      throw exception("Invalid interval (param #3) specified.", -1)
  }
  else
    interval := 100 ; default value  

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