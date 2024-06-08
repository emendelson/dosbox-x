@echo off
mount x ~/Library/Preferences
mkdir x:\DOSBOX-X
mount -u x
SET yr=%@RIGHT[2,%_year]
SET mo=%@RIGHT[2,%_month]
SET da=%@RIGHT[2,%_day]
set NOW=%yr-%mo-%da-%_TIME
set da=
set mo=
set yr=
set CONF=DOSBox-X-%NOW
@echo on
config -wc DOSBOX-X/%CONF.conf
@echo off
exit

