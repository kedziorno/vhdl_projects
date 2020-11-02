#!/bin/sh
fuse -intstyle ise -incremental -o ./tb_top_isim_beh.exe -prj ./tb_top_beh.prj work.tb_top
./tb_top_isim_beh.exe -intstyle ise -gui -tclbatch isim.cmd  -wdb ./tb_top_isim.beh.wdb -view ./tb_top.wcfg
