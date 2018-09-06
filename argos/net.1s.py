#!/usr/bin/env python3
import psutil
import time

count = psutil.net_io_counters()
recv, sent = count.bytes_recv, count.bytes_sent
time.sleep(1)
count = psutil.net_io_counters()
recv, sent = count.bytes_recv - recv, count.bytes_sent - sent

stats = psutil.net_if_stats()


def size(bytes, high, medium):
    suffix = 'B'
    if bytes > 1024:
        bytes /= 1024
        suffix = 'K'
    if bytes > 1024:
        bytes /= 1024
        suffix = 'M'
    if bytes > 1024:
        bytes /= 1024
        suffix = 'G'
    color = '#cc575d' if bytes > high else '#d19a66' \
        if bytes > medium else '#68b382'
    return "<span color='%s'>%3d%s</span>" % (color, bytes, suffix)


print("%4s↓ %4s↑" %
      (size(recv, 1000000, 500000), size(sent, 750000, 350000)))
print("---")
for key in stats:
    print("%s (%s)|font=monospace"
          % (key, 'up' if stats[key].isup else 'down'))
print("---")
print("Network connections|iconName=preferences-system-network-symbolic" +
      " bash=nm-connection-editor terminal=false")
