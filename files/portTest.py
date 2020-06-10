#!/usr/bin/python

# THIS FILE IS MANAGED BY PUPPET - DO NOT MANUALLY EDIT

import sys
import socket
import time

if len(sys.argv) < 3:
    print "Syntax Error: " + sys.argv[0] + " [hostname] [port] [tcp or udp]"
    sys.exit(1)

timeout = sys.argv[2]
print ("timeout = "+timeout)
i = 1
hosts = sys.argv[1].split(',')
for host in hosts:
  print("host "+str(i)+" = "+host)
  arr = host.split(':')
  hostname = arr[0]
  port = int(arr[1])
  print(" hostname: "+hostname)
  print(" port: "+str(port))

  s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  s.settimeout(float(timeout))
  try:
    s.connect((hostname, port))
    s.shutdown(2)
    print "Success connecting to " + hostname + " on TCP port: " + str(port)
    sys.exit(0)

  except Exception, e:
    try:
      errno, errtxt = e
    except ValueError:
      print "Cannot connect to " + hostname + " on port: " + str(port)
      sys.exit(1)
    else:
      if errno == 107:
        print "Success connecting to " + hostname + " on UDP port: " + str(port)
        sys.exit(0)
      else:
        print "Cannot connect to " + hostname + " on port: " + str(port)
        #print e
        sys.exit(1)

  s.close
  time.sleep(1)


  i += 1
  # end for loop

exit()

host = arr[0]
port = arr[1]


print(sys.argv[1:])
print("host: "+host+" port: "+port+" timeout: "+timeout+"\n")



exit()

port = int(sys.argv[2])
# type => ["tcp" or "udp"]
type = sys.argv[3].lower()


while 1 :
  if type == "udp":
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
  else:
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  s.settimeout(5)
  try:
    if type == "udp":
      s.sendto("--TEST LINE--", (host, port))
      recv, svr = s.recvfrom(255)
      s.shutdown(2)
      print "Success connecting to " + host + " on UDP port: " + str(port)
      sys.exit(0)
    else:
      s.connect((host, port))
      s.shutdown(2)
      print "Success connecting to " + host + " on TCP port: " + str(port)
      sys.exit(0)
  except Exception, e:
    try:
      errno, errtxt = e
    except ValueError:
      print "Cannot connect to " + host + " on port: " + str(port)
      sys.exit(1)
    else:
      if errno == 107:
        print "Success connecting to " + host + " on UDP port: " + str(port)
        sys.exit(0)
      else:
        print "Cannot connect to " + host + " on port: " + str(port)
        #print e
        sys.exit(1)

  s.close
  time.sleep(1)
