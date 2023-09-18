<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="spartan3e" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="CLK" />
        <signal name="CLR" />
        <signal name="XLXN_3" />
        <signal name="XLXN_4" />
        <signal name="D" />
        <signal name="XLXN_6" />
        <signal name="XLXN_7" />
        <signal name="Q" />
        <signal name="XLXN_9" />
        <signal name="XLXN_10" />
        <signal name="XLXN_11" />
        <port polarity="Input" name="CLK" />
        <port polarity="Input" name="CLR" />
        <port polarity="Input" name="D" />
        <port polarity="Output" name="Q" />
        <blockdef name="fdc">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-128" y2="-128" x1="0" />
            <line x2="64" y1="-32" y2="-32" x1="0" />
            <line x2="64" y1="-256" y2="-256" x1="0" />
            <line x2="320" y1="-256" y2="-256" x1="384" />
            <rect width="256" x="64" y="-320" height="256" />
            <line x2="80" y1="-112" y2="-128" x1="64" />
            <line x2="64" y1="-128" y2="-144" x1="80" />
            <line x2="192" y1="-64" y2="-32" x1="192" />
            <line x2="64" y1="-32" y2="-32" x1="192" />
        </blockdef>
        <blockdef name="fdc_1">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="40" y1="-128" y2="-128" x1="0" />
            <circle r="12" cx="52" cy="-128" />
            <line x2="80" y1="-112" y2="-128" x1="64" />
            <line x2="64" y1="-128" y2="-144" x1="80" />
            <line x2="320" y1="-256" y2="-256" x1="384" />
            <line x2="64" y1="-256" y2="-256" x1="0" />
            <line x2="64" y1="-32" y2="-32" x1="0" />
            <rect width="256" x="64" y="-320" height="256" />
            <line x2="192" y1="-64" y2="-32" x1="192" />
            <line x2="64" y1="-32" y2="-32" x1="192" />
        </blockdef>
        <blockdef name="xor2">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-64" y2="-64" x1="0" />
            <line x2="60" y1="-128" y2="-128" x1="0" />
            <line x2="208" y1="-96" y2="-96" x1="256" />
            <arc ex="44" ey="-144" sx="48" sy="-48" r="56" cx="16" cy="-96" />
            <arc ex="64" ey="-144" sx="64" sy="-48" r="56" cx="32" cy="-96" />
            <line x2="64" y1="-144" y2="-144" x1="128" />
            <line x2="64" y1="-48" y2="-48" x1="128" />
            <arc ex="128" ey="-144" sx="208" sy="-96" r="88" cx="132" cy="-56" />
            <arc ex="208" ey="-96" sx="128" sy="-48" r="88" cx="132" cy="-136" />
        </blockdef>
        <block symbolname="fdc" name="XLXI_1">
            <blockpin signalname="CLK" name="C" />
            <blockpin signalname="CLR" name="CLR" />
            <blockpin signalname="XLXN_3" name="D" />
            <blockpin signalname="XLXN_6" name="Q" />
        </block>
        <block symbolname="fdc_1" name="XLXI_2">
            <blockpin signalname="CLK" name="C" />
            <blockpin signalname="CLR" name="CLR" />
            <blockpin signalname="XLXN_4" name="D" />
            <blockpin signalname="XLXN_11" name="Q" />
        </block>
        <block symbolname="xor2" name="XLXI_3">
            <blockpin signalname="XLXN_11" name="I0" />
            <blockpin signalname="D" name="I1" />
            <blockpin signalname="XLXN_3" name="O" />
        </block>
        <block symbolname="xor2" name="XLXI_5">
            <blockpin signalname="D" name="I0" />
            <blockpin signalname="XLXN_6" name="I1" />
            <blockpin signalname="XLXN_4" name="O" />
        </block>
        <block symbolname="xor2" name="XLXI_6">
            <blockpin signalname="XLXN_11" name="I0" />
            <blockpin signalname="XLXN_6" name="I1" />
            <blockpin signalname="Q" name="O" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <instance x="1104" y="1024" name="XLXI_1" orien="R0" />
        <instance x="1104" y="1472" name="XLXI_2" orien="R0" />
        <branch name="CLK">
            <wire x2="736" y1="896" y2="896" x1="656" />
            <wire x2="736" y1="896" y2="1344" x1="736" />
            <wire x2="1104" y1="1344" y2="1344" x1="736" />
            <wire x2="1104" y1="896" y2="896" x1="736" />
        </branch>
        <branch name="CLR">
            <wire x2="752" y1="992" y2="992" x1="656" />
            <wire x2="1104" y1="992" y2="992" x1="752" />
            <wire x2="752" y1="992" y2="1440" x1="752" />
            <wire x2="1104" y1="1440" y2="1440" x1="752" />
        </branch>
        <branch name="XLXN_3">
            <wire x2="1104" y1="768" y2="768" x1="1040" />
        </branch>
        <instance x="784" y="1312" name="XLXI_5" orien="R0" />
        <instance x="784" y="864" name="XLXI_3" orien="R0" />
        <branch name="XLXN_4">
            <wire x2="1104" y1="1216" y2="1216" x1="1040" />
        </branch>
        <branch name="D">
            <wire x2="720" y1="736" y2="736" x1="656" />
            <wire x2="784" y1="736" y2="736" x1="720" />
            <wire x2="720" y1="736" y2="1248" x1="720" />
            <wire x2="784" y1="1248" y2="1248" x1="720" />
        </branch>
        <branch name="XLXN_6">
            <wire x2="784" y1="1184" y2="1184" x1="704" />
            <wire x2="704" y1="1184" y2="1472" x1="704" />
            <wire x2="1584" y1="1472" y2="1472" x1="704" />
            <wire x2="1584" y1="768" y2="768" x1="1488" />
            <wire x2="1584" y1="768" y2="976" x1="1584" />
            <wire x2="1632" y1="976" y2="976" x1="1584" />
            <wire x2="1584" y1="976" y2="1472" x1="1584" />
        </branch>
        <branch name="Q">
            <wire x2="1904" y1="1008" y2="1008" x1="1888" />
        </branch>
        <iomarker fontsize="28" x="656" y="736" name="D" orien="R180" />
        <iomarker fontsize="28" x="656" y="896" name="CLK" orien="R180" />
        <iomarker fontsize="28" x="656" y="992" name="CLR" orien="R180" />
        <branch name="XLXN_11">
            <wire x2="688" y1="608" y2="800" x1="688" />
            <wire x2="784" y1="800" y2="800" x1="688" />
            <wire x2="1568" y1="608" y2="608" x1="688" />
            <wire x2="1568" y1="608" y2="1040" x1="1568" />
            <wire x2="1632" y1="1040" y2="1040" x1="1568" />
            <wire x2="1568" y1="1040" y2="1216" x1="1568" />
            <wire x2="1568" y1="1216" y2="1216" x1="1488" />
        </branch>
        <iomarker fontsize="28" x="1904" y="1008" name="Q" orien="R0" />
        <instance x="1632" y="1104" name="XLXI_6" orien="R0" />
    </sheet>
</drawing>