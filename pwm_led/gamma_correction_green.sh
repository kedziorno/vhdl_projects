#!/bin/sh

LD_LIBRARY_PATH=""

echo "" | awk '
BEGIN {
	a = 256; # PWM for 8 bit
	b = 1; # step
	c=0; # start counter
	gamma=0.4; # use GAMMA
	table[0]=""; # array for hex variables
	s="GAMMA_CORRECTION"; # script name
	n="GREEN"; # color name
}
{
	for (c=0;c<a-1;c=c+b) {
		#printf("%d ",int(a*(c/a)^(1/gamma)));
		table[c] = sprintf("x\"%02X\"",int(a*(c/a)^(1/gamma)));
	}
	#print "\n";
}
END {
	printf("constant NUMBER_%s_%s : natural := %d;\n",s,n,a-1);
	printf("type ARRAY_%s_%s is array (0 to NUMBER_%s_%s-1) of std_logic_vector(7 downto 0);\n",s,n,s,n);
	printf("signal %s_%s : ARRAY_%s_%s :=\n",s,n,s,n);
	printf("(\n");
	for (i = 0; i < length(table); i++) {
		if (i == length(table)-1) {
			printf("%s\n",table[i]);
		} else {
			printf("%s,",table[i]);
		}
	}
	printf(");\n");
}
'

