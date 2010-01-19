#!/usr/bin/env python

# based on sample code from http://jimmydo.wordpress.com/2007/04/27/timer-applet-20/

import dbus

from sys import argv

op = argv[1]

bus = dbus.SessionBus()
timer_manager = bus.get_object('net.sourceforge.timerapplet.TimerApplet', '/net/sourceforge/timerapplet/TimerApplet/TimerManager')
timer_id_list = timer_manager.GetTimerIDList()
if len(timer_id_list) > 0:
  first_timer_id = timer_id_list[0]
  print 'Got timer with ID: %s' % first_timer_id

  timer = bus.get_object('net.sourceforge.timerapplet.TimerApplet', '/net/sourceforge/timerapplet/TimerApplet/Timers/' + first_timer_id)

  if "start" == op:
    # Start() takes: name, hours, minutes, seconds
    # Name can be an empty string.
    time_args = [int(arg) for arg in argv[2:]]
    timer.Start("cli %s" % "-".join(str(i) for i in time_args), *time_args)
  elif "stop" == op:
    timer.Stop()
  else:
    raise ValueError("wtf is '%s'?" % op)
else:
  print 'There are no Timer Applets in the panel.'
