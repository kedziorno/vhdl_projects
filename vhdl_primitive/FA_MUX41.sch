<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="spartan3e" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="Sum" />
        <signal name="Carry_out" />
        <signal name="XLXN_3" />
        <signal name="XLXN_4" />
        <signal name="XLXN_5" />
        <signal name="Carry_in" />
        <signal name="XLXN_7" />
        <signal name="XLXN_8" />
        <signal name="A" />
        <signal name="B" />
        <signal name="XLXN_11" />
        <signal name="XLXN_13" />
        <signal name="XLXN_14" />
        <port polarity="Output" name="Sum" />
        <port polarity="Output" name="Carry_out" />
        <port polarity="Input" name="Carry_in" />
        <port polarity="Input" name="A" />
        <port polarity="Input" name="B" />
        <blockdef name="m4_1e">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="96" y1="-416" y2="-416" x1="0" />
            <line x2="96" y1="-352" y2="-352" x1="0" />
            <line x2="96" y1="-288" y2="-288" x1="0" />
            <line x2="96" y1="-224" y2="-224" x1="0" />
            <line x2="96" y1="-32" y2="-32" x1="0" />
            <line x2="256" y1="-320" y2="-320" x1="320" />
            <line x2="96" y1="-160" y2="-160" x1="0" />
            <line x2="96" y1="-96" y2="-96" x1="0" />
            <line x2="96" y1="-96" y2="-96" x1="176" />
            <line x2="176" y1="-208" y2="-96" x1="176" />
            <line x2="96" y1="-32" y2="-32" x1="224" />
            <line x2="224" y1="-216" y2="-32" x1="224" />
            <line x2="96" y1="-224" y2="-192" x1="256" />
            <line x2="256" y1="-416" y2="-224" x1="256" />
            <line x2="256" y1="-448" y2="-416" x1="96" />
            <line x2="96" y1="-192" y2="-448" x1="96" />
            <line x2="96" y1="-160" y2="-160" x1="128" />
            <line x2="128" y1="-200" y2="-160" x1="128" />
        </blockdef>
        <blockdef name="inv">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-32" y2="-32" x1="0" />
            <line x2="160" y1="-32" y2="-32" x1="224" />
            <line x2="128" y1="-64" y2="-32" x1="64" />
            <line x2="64" y1="-32" y2="0" x1="128" />
            <line x2="64" y1="0" y2="-64" x1="64" />
            <circle r="16" cx="144" cy="-32" />
        </blockdef>
        <blockdef name="vcc">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-32" y2="-64" x1="64" />
            <line x2="64" y1="0" y2="-32" x1="64" />
            <line x2="32" y1="-64" y2="-64" x1="96" />
        </blockdef>
        <blockdef name="gnd">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-64" y2="-96" x1="64" />
            <line x2="52" y1="-48" y2="-48" x1="76" />
            <line x2="60" y1="-32" y2="-32" x1="68" />
            <line x2="40" y1="-64" y2="-64" x1="88" />
            <line x2="64" y1="-64" y2="-80" x1="64" />
            <line x2="64" y1="-128" y2="-96" x1="64" />
        </blockdef>
        <block symbolname="m4_1e" name="XLXI_1">
            <blockpin signalname="Carry_in" name="D0" />
            <blockpin signalname="XLXN_3" name="D1" />
            <blockpin signalname="XLXN_4" name="D2" />
            <blockpin signalname="Carry_in" name="D3" />
            <blockpin signalname="XLXN_7" name="E" />
            <blockpin signalname="B" name="S0" />
            <blockpin signalname="A" name="S1" />
            <blockpin signalname="Sum" name="O" />
        </block>
        <block symbolname="m4_1e" name="XLXI_2">
            <blockpin signalname="XLXN_13" name="D0" />
            <blockpin signalname="Carry_in" name="D1" />
            <blockpin signalname="Carry_in" name="D2" />
            <blockpin signalname="XLXN_11" name="D3" />
            <blockpin signalname="XLXN_8" name="E" />
            <blockpin signalname="B" name="S0" />
            <blockpin signalname="A" name="S1" />
            <blockpin signalname="Carry_out" name="O" />
        </block>
        <block symbolname="inv" name="XLXI_3">
            <blockpin signalname="Carry_in" name="I" />
            <blockpin signalname="XLXN_3" name="O" />
        </block>
        <block symbolname="inv" name="XLXI_4">
            <blockpin signalname="Carry_in" name="I" />
            <blockpin signalname="XLXN_4" name="O" />
        </block>
        <block symbolname="vcc" name="XLXI_5">
            <blockpin signalname="XLXN_7" name="P" />
        </block>
        <block symbolname="vcc" name="XLXI_6">
            <blockpin signalname="XLXN_8" name="P" />
        </block>
        <block symbolname="vcc" name="XLXI_7">
            <blockpin signalname="XLXN_11" name="P" />
        </block>
        <block symbolname="gnd" name="XLXI_8">
            <blockpin signalname="XLXN_13" name="G" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <instance x="1168" y="1072" name="XLXI_1" orien="R0" />
        <instance x="1168" y="1600" name="XLXI_2" orien="R0" />
        <branch name="Sum">
            <wire x2="1520" y1="752" y2="752" x1="1488" />
        </branch>
        <iomarker fontsize="28" x="1520" y="752" name="Sum" orien="R0" />
        <branch name="Carry_out">
            <wire x2="1520" y1="1280" y2="1280" x1="1488" />
        </branch>
        <iomarker fontsize="28" x="1520" y="1280" name="Carry_out" orien="R0" />
        <branch name="XLXN_3">
            <wire x2="1168" y1="720" y2="720" x1="1136" />
        </branch>
        <instance x="912" y="752" name="XLXI_3" orien="R0" />
        <branch name="XLXN_4">
            <wire x2="1168" y1="784" y2="784" x1="1136" />
        </branch>
        <instance x="912" y="816" name="XLXI_4" orien="R0" />
        <branch name="Carry_in">
            <wire x2="880" y1="656" y2="656" x1="784" />
            <wire x2="896" y1="656" y2="656" x1="880" />
            <wire x2="896" y1="656" y2="720" x1="896" />
            <wire x2="912" y1="720" y2="720" x1="896" />
            <wire x2="896" y1="720" y2="784" x1="896" />
            <wire x2="912" y1="784" y2="784" x1="896" />
            <wire x2="1168" y1="656" y2="656" x1="896" />
            <wire x2="880" y1="656" y2="848" x1="880" />
            <wire x2="1168" y1="848" y2="848" x1="880" />
            <wire x2="880" y1="848" y2="1248" x1="880" />
            <wire x2="1152" y1="1248" y2="1248" x1="880" />
            <wire x2="1168" y1="1248" y2="1248" x1="1152" />
            <wire x2="1152" y1="1248" y2="1312" x1="1152" />
            <wire x2="1168" y1="1312" y2="1312" x1="1152" />
        </branch>
        <branch name="XLXN_7">
            <wire x2="1168" y1="1040" y2="1040" x1="1136" />
        </branch>
        <instance x="1136" y="1104" name="XLXI_5" orien="R270" />
        <branch name="XLXN_8">
            <wire x2="1168" y1="1568" y2="1568" x1="1136" />
        </branch>
        <instance x="1136" y="1632" name="XLXI_6" orien="R270" />
        <branch name="B">
            <wire x2="816" y1="912" y2="912" x1="784" />
            <wire x2="816" y1="912" y2="1440" x1="816" />
            <wire x2="1168" y1="1440" y2="1440" x1="816" />
            <wire x2="1168" y1="912" y2="912" x1="816" />
        </branch>
        <branch name="XLXN_11">
            <wire x2="1168" y1="1376" y2="1376" x1="1136" />
        </branch>
        <instance x="1136" y="1440" name="XLXI_7" orien="R270" />
        <branch name="A">
            <wire x2="832" y1="976" y2="976" x1="784" />
            <wire x2="1168" y1="976" y2="976" x1="832" />
            <wire x2="832" y1="976" y2="1504" x1="832" />
            <wire x2="1168" y1="1504" y2="1504" x1="832" />
        </branch>
        <branch name="XLXN_13">
            <wire x2="1168" y1="1184" y2="1184" x1="1136" />
        </branch>
        <instance x="1008" y="1120" name="XLXI_8" orien="R90" />
        <iomarker fontsize="28" x="784" y="976" name="A" orien="R180" />
        <iomarker fontsize="28" x="784" y="912" name="B" orien="R180" />
        <iomarker fontsize="28" x="784" y="656" name="Carry_in" orien="R180" />
    </sheet>
</drawing>