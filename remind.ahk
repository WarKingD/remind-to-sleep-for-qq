#Persistent

; Env here
EnvSet, winTitle, REPLACEWITHWINDOWTITLE

calc_nexttime() {
  nextTime = % A_NowUTC
  nextTime += 1, days
  nextTime += -%A_Hour%, hours
  nextTime += -%A_Min%, minutes
  nextTime += -%A_Sec%, seconds
  nextTime += -5, minutes
  return nextTime
}

calc_leftsec() {
  nextTime = % calc_nexttime()
  nextTime -= 19700101000000, S
  currentTime = % A_NowUTC
  currentTime -= 19700101000000, S
  leftSec = % nextTime - currentTime
  return leftSec
}

send_msg() {
  id := WinExist(winTitle)
  if (id) {
    WinActivate, ahk_id %id%
    Click, 2, 10
	file := FileOpen(".\round.txt", "rw")
    roundCount := file.Read()
    if (!roundCount) {
      roundCount = 1
    }
    roundCount += 1
    generate_msg(roundCount)
	file.Seek(0)
    file.Write(roundCount)
    file.Close()
  }
}

generate_msg(roundCount)
{
  FormatTime, currentTime, , yyyy-MM-dd HH:mm:ss
  Send 大家好，我是本群的“提醒睡觉小助手(alpha)”，现在是北京时间%currentTime%，第%roundCount%轮。希望此刻看到消息的人可以和我一起来睡觉。二十四小时后的我继续提醒大家睡觉。和我一起成为早睡不熬夜的人吧！
  Send {Enter}
}

;send_msg()

Loop {
  leftMs = % calc_leftsec() * 1000
  sleep leftMs
  send_msg()
  sleep 10 * 60 * 1000
}


