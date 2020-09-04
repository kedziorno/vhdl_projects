# simple convert hex digits in glcdfont.c to VHDL hex table
# src file : https://github.com/adafruit/Adafruit-GFX-Library/blob/master/glcdfont.c
# usage : awk -f this_file.awk glcdfont.c


BEGIN {
 FPAT="(0x[0-9ABCDEF]+[0-9ABCDEF]+[, ]+{0,5})";
 global_index = 0;
 table_name = "GLCDFONTC";
}
{
 #printf("%d:\t%s\n",NR,$0);
 array_line[global_index] = $0;
 if (NF > 0) {
   #print "NF = ", NF
   for (i = 1; i <= NF; i++) {
    #printf("$%d = <%s>\n", i, $i)
    array_hex[global_index] = substr($i,3,2); # "0xXX, -> XX"
    #printf("x\"%s\",\n",temp[global_index]); 
    global_index++;
   }
   #printf("\n");
  }
}
END {
 printf("constant NUMBER_%s : natural := %d;\n",table_name,global_index);
 printf("type ARRAY_%s is array (0 to NUMBER_%s-1) of std_logic_vector(7 downto 0);\n",table_name,table_name);
 printf("signal %s : ARRAY_%s :=\n",table_name,table_name);
 printf("(\n");
 for (i = 0; i < length(array_hex); i++) {
  if (i % 5 == 0) {
   printf("\n\t -- %s\n",array_line[i]);
  }
  if (i == length(array_hex)-1) {
   printf("\tx\"%s\"\n",array_hex[i]);
  } else {
   printf("\tx\"%s\",\n",array_hex[i]);
  }
 }
 printf(");\n");
}
