#!/usr/bin/python3.6
import psutil
cpu_usage = psutil.cpu_percent(interval=1)
#print(cpu_usage)
print('%s%s' % (int(cpu_usage),'%'))

