setMode -bs
setCable -port auto
Identify -inferir
identifyMPM
assignFile -p 1 -file top.bit
Program -p 1
closeCable
quit
