#!/bin/sh
PROJECT="tb_memory2"
fuse -intstyle ise -incremental -o ./${PROJECT}_isim_beh.exe -prj ./${PROJECT}_beh.prj work.${PROJECT}
./${PROJECT}_isim_beh.exe -intstyle ise -gui -tclbatch isim.cmd  -wdb ./${PROJECT}_isim.beh.wdb -view ./${PROJECT}.wcfg
