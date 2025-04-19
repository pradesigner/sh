#!/bin/bash
# find what is on here

echo 'CPU, MEM, HD, CD info: '
dmesg | grep -e cpu0: -e "real mem" -e 'wd.:' -e 'cd. '
echo ' '
#echo 'VGA, AUDIO info: '
#dmesg |grep -e vga -e audio
#echo ' '
#echo 'ALL info: '
#dmesg

#echo 'BIOS,APM,PCIBIOS info: ' 
#dmesg |grep -e bios -e apm -e pcibios  
