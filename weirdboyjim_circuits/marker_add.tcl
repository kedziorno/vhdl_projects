# based on https://support.xilinx.com/s/article/35500?language=en_US
# script add markers from source_file
set source_file "wbj_ts.txt"
if { [catch { open "$source_file" r } hfset] } {
	puts "error, could not open file $source_file"
} else {
	set line "0 ps"
	while { ![eof $hfset] } {
		set line [gets $hfset]
		set sl [string bytelength $line]
		if { $sl > 0 } {
			set re_line ""
			regexp {^[^0]([0-9]{1,}).([pm]s)} $line re_line
			set rel [string bytelength $re_line]
			if { $rel > 0 } {
				puts "marker add $re_line"
				marker add "$re_line"
			}
		}
	}
	catch { close $hfset }
	puts "markers add ok"
}
