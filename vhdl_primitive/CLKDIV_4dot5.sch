<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="spartan3e" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="XLXN_59" />
        <signal name="XLXN_60" />
        <signal name="XLXN_62" />
        <signal name="XLXN_63" />
        <signal name="XLXN_64" />
        <signal name="XLXN_65" />
        <signal name="XLXN_66" />
        <signal name="XLXN_67" />
        <signal name="clk_in" />
        <signal name="XLXN_78" />
        <signal name="XLXN_80" />
        <signal name="XLXN_83" />
        <signal name="clk_out" />
        <signal name="XLXN_81" />
        <signal name="XLXN_84" />
        <port polarity="Input" name="clk_in" />
        <port polarity="Output" name="clk_out" />
        <blockdef name="fd">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <rect width="256" x="64" y="-320" height="256" />
            <line x2="64" y1="-128" y2="-128" x1="0" />
            <line x2="64" y1="-256" y2="-256" x1="0" />
            <line x2="320" y1="-256" y2="-256" x1="384" />
            <line x2="64" y1="-128" y2="-144" x1="80" />
            <line x2="80" y1="-112" y2="-128" x1="64" />
        </blockdef>
        <blockdef name="fd_1">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="40" y1="-128" y2="-128" x1="0" />
            <circle r="12" cx="52" cy="-128" />
            <line x2="64" y1="-256" y2="-256" x1="0" />
            <line x2="320" y1="-256" y2="-256" x1="384" />
            <rect width="256" x="64" y="-320" height="256" />
            <line x2="80" y1="-112" y2="-128" x1="64" />
            <line x2="64" y1="-128" y2="-144" x1="80" />
        </blockdef>
        <blockdef name="or3">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="48" y1="-64" y2="-64" x1="0" />
            <line x2="72" y1="-128" y2="-128" x1="0" />
            <line x2="48" y1="-192" y2="-192" x1="0" />
            <line x2="192" y1="-128" y2="-128" x1="256" />
            <arc ex="192" ey="-128" sx="112" sy="-80" r="88" cx="116" cy="-168" />
            <arc ex="48" ey="-176" sx="48" sy="-80" r="56" cx="16" cy="-128" />
            <line x2="48" y1="-64" y2="-80" x1="48" />
            <line x2="48" y1="-192" y2="-176" x1="48" />
            <line x2="48" y1="-80" y2="-80" x1="112" />
            <arc ex="112" ey="-176" sx="192" sy="-128" r="88" cx="116" cy="-88" />
            <line x2="48" y1="-176" y2="-176" x1="112" />
        </blockdef>
        <blockdef name="or2">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-64" y2="-64" x1="0" />
            <line x2="64" y1="-128" y2="-128" x1="0" />
            <line x2="192" y1="-96" y2="-96" x1="256" />
            <arc ex="192" ey="-96" sx="112" sy="-48" r="88" cx="116" cy="-136" />
            <arc ex="48" ey="-144" sx="48" sy="-48" r="56" cx="16" cy="-96" />
            <line x2="48" y1="-144" y2="-144" x1="112" />
            <arc ex="112" ey="-144" sx="192" sy="-96" r="88" cx="116" cy="-56" />
            <line x2="48" y1="-48" y2="-48" x1="112" />
        </blockdef>
        <block symbolname="fd" name="XLXI_1">
            <attr value="1" name="INIT">
                <trait verilog="all:0 dp:1" />
                <trait vhdl="all:0 gm:1" />
                <trait valuetype="Bit" />
            </attr>
            <blockpin signalname="clk_in" name="C" />
            <blockpin signalname="XLXN_67" name="D" />
            <blockpin signalname="XLXN_59" name="Q" />
        </block>
        <block symbolname="fd" name="XLXI_8">
            <blockpin signalname="clk_in" name="C" />
            <blockpin signalname="XLXN_59" name="D" />
            <blockpin signalname="XLXN_60" name="Q" />
        </block>
        <block symbolname="fd" name="XLXI_2">
            <blockpin signalname="clk_in" name="C" />
            <blockpin signalname="XLXN_60" name="D" />
            <blockpin signalname="XLXN_62" name="Q" />
        </block>
        <block symbolname="fd" name="XLXI_4">
            <blockpin signalname="clk_in" name="C" />
            <blockpin signalname="XLXN_62" name="D" />
            <blockpin signalname="XLXN_63" name="Q" />
        </block>
        <block symbolname="fd" name="XLXI_3">
            <blockpin signalname="clk_in" name="C" />
            <blockpin signalname="XLXN_63" name="D" />
            <blockpin signalname="XLXN_64" name="Q" />
        </block>
        <block symbolname="fd" name="XLXI_5">
            <blockpin signalname="clk_in" name="C" />
            <blockpin signalname="XLXN_64" name="D" />
            <blockpin signalname="XLXN_65" name="Q" />
        </block>
        <block symbolname="fd" name="XLXI_7">
            <blockpin signalname="clk_in" name="C" />
            <blockpin signalname="XLXN_65" name="D" />
            <blockpin signalname="XLXN_66" name="Q" />
        </block>
        <block symbolname="fd" name="XLXI_6">
            <blockpin signalname="clk_in" name="C" />
            <blockpin signalname="XLXN_66" name="D" />
            <blockpin signalname="XLXN_67" name="Q" />
        </block>
        <block symbolname="fd_1" name="XLXI_18">
            <blockpin signalname="clk_in" name="C" />
            <blockpin signalname="XLXN_64" name="D" />
            <blockpin signalname="XLXN_80" name="Q" />
        </block>
        <block symbolname="fd_1" name="XLXI_19">
            <blockpin signalname="clk_in" name="C" />
            <blockpin signalname="XLXN_65" name="D" />
            <blockpin signalname="XLXN_81" name="Q" />
        </block>
        <block symbolname="fd_1" name="XLXI_17">
            <blockpin signalname="clk_in" name="C" />
            <blockpin signalname="XLXN_59" name="D" />
            <blockpin signalname="XLXN_78" name="Q" />
        </block>
        <block symbolname="or3" name="XLXI_20">
            <blockpin signalname="XLXN_60" name="I0" />
            <blockpin signalname="XLXN_59" name="I1" />
            <blockpin signalname="XLXN_78" name="I2" />
            <blockpin signalname="XLXN_83" name="O" />
        </block>
        <block symbolname="or3" name="XLXI_21">
            <blockpin signalname="XLXN_65" name="I0" />
            <blockpin signalname="XLXN_81" name="I1" />
            <blockpin signalname="XLXN_80" name="I2" />
            <blockpin signalname="XLXN_84" name="O" />
        </block>
        <block symbolname="or2" name="XLXI_22">
            <blockpin signalname="XLXN_84" name="I0" />
            <blockpin signalname="XLXN_83" name="I1" />
            <blockpin signalname="clk_out" name="O" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="5440" height="3520">
        <instance x="288" y="400" name="XLXI_1" orien="R0">
            <attrtext style="fontsize:28;fontname:Arial;displayformat:NAMEEQUALSVALUE" attrname="INIT" x="0" y="-408" type="instance" />
        </instance>
        <instance x="288" y="720" name="XLXI_8" orien="R0" />
        <instance x="288" y="1040" name="XLXI_2" orien="R0" />
        <instance x="288" y="1360" name="XLXI_4" orien="R0" />
        <instance x="288" y="1680" name="XLXI_3" orien="R0" />
        <instance x="288" y="2000" name="XLXI_5" orien="R0" />
        <instance x="288" y="2320" name="XLXI_7" orien="R0" />
        <branch name="XLXN_59">
            <wire x2="224" y1="368" y2="464" x1="224" />
            <wire x2="288" y1="464" y2="464" x1="224" />
            <wire x2="752" y1="368" y2="368" x1="224" />
            <wire x2="1424" y1="368" y2="368" x1="752" />
            <wire x2="752" y1="144" y2="144" x1="672" />
            <wire x2="752" y1="144" y2="368" x1="752" />
            <wire x2="1024" y1="144" y2="144" x1="752" />
            <wire x2="1424" y1="208" y2="368" x1="1424" />
            <wire x2="1456" y1="208" y2="208" x1="1424" />
        </branch>
        <branch name="XLXN_60">
            <wire x2="752" y1="688" y2="688" x1="224" />
            <wire x2="224" y1="688" y2="784" x1="224" />
            <wire x2="288" y1="784" y2="784" x1="224" />
            <wire x2="752" y1="464" y2="464" x1="672" />
            <wire x2="752" y1="464" y2="688" x1="752" />
            <wire x2="1440" y1="464" y2="464" x1="752" />
            <wire x2="1440" y1="272" y2="464" x1="1440" />
            <wire x2="1456" y1="272" y2="272" x1="1440" />
        </branch>
        <branch name="XLXN_62">
            <wire x2="752" y1="1008" y2="1008" x1="224" />
            <wire x2="224" y1="1008" y2="1104" x1="224" />
            <wire x2="288" y1="1104" y2="1104" x1="224" />
            <wire x2="752" y1="784" y2="784" x1="672" />
            <wire x2="752" y1="784" y2="1008" x1="752" />
        </branch>
        <branch name="XLXN_63">
            <wire x2="752" y1="1328" y2="1328" x1="224" />
            <wire x2="224" y1="1328" y2="1424" x1="224" />
            <wire x2="288" y1="1424" y2="1424" x1="224" />
            <wire x2="752" y1="1104" y2="1104" x1="672" />
            <wire x2="752" y1="1104" y2="1328" x1="752" />
        </branch>
        <branch name="XLXN_64">
            <wire x2="224" y1="1648" y2="1744" x1="224" />
            <wire x2="288" y1="1744" y2="1744" x1="224" />
            <wire x2="752" y1="1648" y2="1648" x1="224" />
            <wire x2="752" y1="1424" y2="1424" x1="672" />
            <wire x2="752" y1="1424" y2="1648" x1="752" />
            <wire x2="1024" y1="1424" y2="1424" x1="752" />
        </branch>
        <branch name="XLXN_65">
            <wire x2="752" y1="1968" y2="1968" x1="224" />
            <wire x2="1440" y1="1968" y2="1968" x1="752" />
            <wire x2="224" y1="1968" y2="2064" x1="224" />
            <wire x2="288" y1="2064" y2="2064" x1="224" />
            <wire x2="752" y1="1744" y2="1744" x1="672" />
            <wire x2="752" y1="1744" y2="1968" x1="752" />
            <wire x2="1024" y1="1744" y2="1744" x1="752" />
            <wire x2="1440" y1="1552" y2="1968" x1="1440" />
            <wire x2="1456" y1="1552" y2="1552" x1="1440" />
        </branch>
        <instance x="288" y="2640" name="XLXI_6" orien="R0" />
        <branch name="XLXN_66">
            <wire x2="224" y1="2288" y2="2384" x1="224" />
            <wire x2="288" y1="2384" y2="2384" x1="224" />
            <wire x2="752" y1="2288" y2="2288" x1="224" />
            <wire x2="752" y1="2064" y2="2064" x1="672" />
            <wire x2="752" y1="2064" y2="2288" x1="752" />
        </branch>
        <branch name="XLXN_67">
            <wire x2="288" y1="144" y2="144" x1="208" />
            <wire x2="208" y1="144" y2="2608" x1="208" />
            <wire x2="752" y1="2608" y2="2608" x1="208" />
            <wire x2="752" y1="2384" y2="2384" x1="672" />
            <wire x2="752" y1="2384" y2="2608" x1="752" />
        </branch>
        <branch name="clk_in">
            <wire x2="192" y1="272" y2="272" x1="160" />
            <wire x2="288" y1="272" y2="272" x1="192" />
            <wire x2="192" y1="272" y2="592" x1="192" />
            <wire x2="288" y1="592" y2="592" x1="192" />
            <wire x2="192" y1="592" y2="912" x1="192" />
            <wire x2="288" y1="912" y2="912" x1="192" />
            <wire x2="192" y1="912" y2="1232" x1="192" />
            <wire x2="288" y1="1232" y2="1232" x1="192" />
            <wire x2="192" y1="1232" y2="1552" x1="192" />
            <wire x2="288" y1="1552" y2="1552" x1="192" />
            <wire x2="192" y1="1552" y2="1872" x1="192" />
            <wire x2="288" y1="1872" y2="1872" x1="192" />
            <wire x2="192" y1="1872" y2="2192" x1="192" />
            <wire x2="288" y1="2192" y2="2192" x1="192" />
            <wire x2="192" y1="2192" y2="2512" x1="192" />
            <wire x2="288" y1="2512" y2="2512" x1="192" />
            <wire x2="192" y1="2512" y2="2624" x1="192" />
            <wire x2="1008" y1="2624" y2="2624" x1="192" />
            <wire x2="1024" y1="272" y2="272" x1="1008" />
            <wire x2="1008" y1="272" y2="1552" x1="1008" />
            <wire x2="1024" y1="1552" y2="1552" x1="1008" />
            <wire x2="1008" y1="1552" y2="1872" x1="1008" />
            <wire x2="1024" y1="1872" y2="1872" x1="1008" />
            <wire x2="1008" y1="1872" y2="2624" x1="1008" />
        </branch>
        <instance x="1024" y="1680" name="XLXI_18" orien="R0" />
        <instance x="1024" y="2000" name="XLXI_19" orien="R0" />
        <instance x="1024" y="400" name="XLXI_17" orien="R0" />
        <branch name="XLXN_78">
            <wire x2="1456" y1="144" y2="144" x1="1408" />
        </branch>
        <branch name="XLXN_80">
            <wire x2="1456" y1="1424" y2="1424" x1="1408" />
        </branch>
        <branch name="XLXN_83">
            <wire x2="1760" y1="208" y2="208" x1="1712" />
        </branch>
        <branch name="clk_out">
            <wire x2="2048" y1="240" y2="240" x1="2016" />
        </branch>
        <instance x="1456" y="336" name="XLXI_20" orien="R0" />
        <instance x="1456" y="1616" name="XLXI_21" orien="R0" />
        <branch name="XLXN_81">
            <wire x2="1424" y1="1744" y2="1744" x1="1408" />
            <wire x2="1456" y1="1488" y2="1488" x1="1424" />
            <wire x2="1424" y1="1488" y2="1744" x1="1424" />
        </branch>
        <instance x="1760" y="336" name="XLXI_22" orien="R0" />
        <branch name="XLXN_84">
            <wire x2="1744" y1="1488" y2="1488" x1="1712" />
            <wire x2="1760" y1="272" y2="272" x1="1744" />
            <wire x2="1744" y1="272" y2="1488" x1="1744" />
        </branch>
        <iomarker fontsize="28" x="160" y="272" name="clk_in" orien="R180" />
        <iomarker fontsize="28" x="2048" y="240" name="clk_out" orien="R0" />
    </sheet>
</drawing>