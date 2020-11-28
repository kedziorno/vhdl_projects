#!/bin/sh

mkdir -p xst/projnav.tmp/

xst -intstyle ise -ifn ./top.xst -ofn ./top.syr
if [ $? -ne 0 ];
then
	echo "error on xst";
	exit;
else
	ngdbuild -intstyle ise -dd _ngo -nt timestamp -uc Nexys2_1200General.ucf -p xc3s1200e-fg320-4 top.ngc top.ngd
	if [ $? -ne 0 ];
	then
		echo "error on ngdbuild";
		exit;
	else
		map -intstyle ise -p xc3s1200e-fg320-4 -ol std -timing -cm balanced -ir off -pr off -o top_map.ncd top.ngd top.pcf
		if [ $? -ne 0 ];
		then
			echo "error on map";
			exit;
		else
			par -w -intstyle ise -ol std -rl std -t 1 top_map.ncd top.ncd top.pcf
			if [ $? -ne 0 ];
			then
				echo "error on par";
				exit;
			else
				trce -intstyle ise -v 3 -s 4 -n 3 -fastpaths -xml top.twx top.ncd -o top.twr top.pcf -ucf Nexys2_1200General.ucf
				if [ $? -ne 0 ];
				then
					echo "error on trce";
					exit;
				else
					bitgen -intstyle ise -f top.ut top.ncd
					if [ $? -ne 0 ];
					then
						echo "error on bitgen";
						exit;
					fi
				fi
			fi
		fi
	fi
fi

