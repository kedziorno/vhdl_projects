<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="spartan3e" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="XLXN_1" />
        <signal name="XLXN_6" />
        <signal name="XLXN_8" />
        <signal name="XLXN_7" />
        <signal name="XLXN_10" />
        <signal name="XLXN_11" />
        <signal name="clk_in" />
        <signal name="XLXN_19" />
        <signal name="XLXN_20" />
        <signal name="XLXN_21" />
        <signal name="XLXN_23" />
        <signal name="XLXN_25" />
        <signal name="clk_out" />
        <port polarity="Input" name="clk_in" />
        <port polarity="Output" name="clk_out" />
        <blockdef name="inv">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-32" y2="-32" x1="0" />
            <line x2="160" y1="-32" y2="-32" x1="224" />
            <line x2="128" y1="-64" y2="-32" x1="64" />
            <line x2="64" y1="-32" y2="0" x1="128" />
            <line x2="64" y1="0" y2="-64" x1="64" />
            <circle r="16" cx="144" cy="-32" />
        </blockdef>
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
        <blockdef name="and2">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-64" y2="-64" x1="0" />
            <line x2="64" y1="-128" y2="-128" x1="0" />
            <line x2="192" y1="-96" y2="-96" x1="256" />
            <arc ex="144" ey="-144" sx="144" sy="-48" r="48" cx="144" cy="-96" />
            <line x2="64" y1="-48" y2="-48" x1="144" />
            <line x2="144" y1="-144" y2="-144" x1="64" />
            <line x2="64" y1="-48" y2="-144" x1="64" />
        </blockdef>
        <blockdef name="and2b1">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-48" y2="-144" x1="64" />
            <line x2="144" y1="-144" y2="-144" x1="64" />
            <line x2="64" y1="-48" y2="-48" x1="144" />
            <arc ex="144" ey="-144" sx="144" sy="-48" r="48" cx="144" cy="-96" />
            <line x2="192" y1="-96" y2="-96" x1="256" />
            <line x2="64" y1="-128" y2="-128" x1="0" />
            <line x2="40" y1="-64" y2="-64" x1="0" />
            <circle r="12" cx="52" cy="-64" />
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
        <block symbolname="fdc" name="LSB">
            <blockpin signalname="clk_in" name="C" />
            <blockpin signalname="XLXN_19" name="CLR" />
            <blockpin signalname="XLXN_8" name="D" />
            <blockpin signalname="XLXN_11" name="Q" />
        </block>
        <block symbolname="inv" name="XLXI_7">
            <blockpin signalname="XLXN_11" name="I" />
            <blockpin signalname="XLXN_8" name="O" />
        </block>
        <block symbolname="inv" name="XLXI_8">
            <blockpin signalname="XLXN_21" name="I" />
            <blockpin signalname="XLXN_10" name="O" />
        </block>
        <block symbolname="fdc_1" name="MSB">
            <blockpin signalname="XLXN_11" name="C" />
            <blockpin signalname="XLXN_19" name="CLR" />
            <blockpin signalname="XLXN_10" name="D" />
            <blockpin signalname="XLXN_21" name="Q" />
        </block>
        <block symbolname="and2" name="XLXI_11">
            <blockpin signalname="XLXN_11" name="I0" />
            <blockpin signalname="XLXN_21" name="I1" />
            <blockpin signalname="XLXN_19" name="O" />
        </block>
        <block symbolname="and2b1" name="XLXI_12">
            <blockpin signalname="XLXN_11" name="I0" />
            <blockpin signalname="XLXN_21" name="I1" />
            <blockpin signalname="XLXN_23" name="O" />
        </block>
        <block symbolname="fd_1" name="XLXI_13">
            <blockpin signalname="clk_in" name="C" />
            <blockpin signalname="XLXN_23" name="D" />
            <blockpin signalname="XLXN_25" name="Q" />
        </block>
        <block symbolname="or2" name="XLXI_14">
            <blockpin signalname="XLXN_25" name="I0" />
            <blockpin signalname="XLXN_23" name="I1" />
            <blockpin signalname="clk_out" name="O" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <instance x="160" y="400" name="LSB" orien="R0" />
        <instance x="576" y="176" name="XLXI_7" orien="R0" />
        <branch name="XLXN_8">
            <wire x2="832" y1="64" y2="64" x1="128" />
            <wire x2="832" y1="64" y2="144" x1="832" />
            <wire x2="128" y1="64" y2="144" x1="128" />
            <wire x2="160" y1="144" y2="144" x1="128" />
            <wire x2="832" y1="144" y2="144" x1="800" />
        </branch>
        <instance x="1520" y="176" name="XLXI_8" orien="R0" />
        <instance x="1104" y="400" name="MSB" orien="R0" />
        <branch name="XLXN_10">
            <wire x2="1776" y1="64" y2="64" x1="1072" />
            <wire x2="1776" y1="64" y2="144" x1="1776" />
            <wire x2="1072" y1="64" y2="144" x1="1072" />
            <wire x2="1104" y1="144" y2="144" x1="1072" />
            <wire x2="1776" y1="144" y2="144" x1="1744" />
        </branch>
        <branch name="XLXN_11">
            <wire x2="560" y1="144" y2="144" x1="544" />
            <wire x2="576" y1="144" y2="144" x1="560" />
            <wire x2="560" y1="144" y2="272" x1="560" />
            <wire x2="1104" y1="272" y2="272" x1="560" />
            <wire x2="560" y1="272" y2="400" x1="560" />
            <wire x2="1392" y1="400" y2="400" x1="560" />
            <wire x2="1392" y1="400" y2="464" x1="1392" />
            <wire x2="560" y1="400" y2="656" x1="560" />
            <wire x2="1104" y1="656" y2="656" x1="560" />
            <wire x2="1392" y1="464" y2="464" x1="1360" />
        </branch>
        <branch name="clk_in">
            <wire x2="48" y1="256" y2="272" x1="48" />
            <wire x2="160" y1="272" y2="272" x1="48" />
            <wire x2="48" y1="272" y2="752" x1="48" />
            <wire x2="1536" y1="752" y2="752" x1="48" />
        </branch>
        <instance x="1360" y="400" name="XLXI_11" orien="R180" />
        <branch name="XLXN_19">
            <wire x2="128" y1="368" y2="496" x1="128" />
            <wire x2="1072" y1="496" y2="496" x1="128" />
            <wire x2="1104" y1="496" y2="496" x1="1072" />
            <wire x2="160" y1="368" y2="368" x1="128" />
            <wire x2="1104" y1="368" y2="368" x1="1072" />
            <wire x2="1072" y1="368" y2="496" x1="1072" />
        </branch>
        <iomarker fontsize="28" x="48" y="256" name="clk_in" orien="R270" />
        <instance x="1104" y="720" name="XLXI_12" orien="R0" />
        <branch name="XLXN_21">
            <wire x2="1104" y1="592" y2="592" x1="1040" />
            <wire x2="1040" y1="592" y2="720" x1="1040" />
            <wire x2="1504" y1="720" y2="720" x1="1040" />
            <wire x2="1504" y1="528" y2="528" x1="1360" />
            <wire x2="1504" y1="528" y2="720" x1="1504" />
            <wire x2="1504" y1="144" y2="144" x1="1488" />
            <wire x2="1520" y1="144" y2="144" x1="1504" />
            <wire x2="1504" y1="144" y2="528" x1="1504" />
        </branch>
        <instance x="1536" y="880" name="XLXI_13" orien="R0" />
        <branch name="XLXN_23">
            <wire x2="1520" y1="624" y2="624" x1="1360" />
            <wire x2="1536" y1="624" y2="624" x1="1520" />
            <wire x2="1520" y1="480" y2="624" x1="1520" />
            <wire x2="1936" y1="480" y2="480" x1="1520" />
            <wire x2="1936" y1="480" y2="560" x1="1936" />
            <wire x2="1952" y1="560" y2="560" x1="1936" />
        </branch>
        <branch name="XLXN_25">
            <wire x2="1952" y1="624" y2="624" x1="1920" />
        </branch>
        <instance x="1952" y="688" name="XLXI_14" orien="R0" />
        <branch name="clk_out">
            <wire x2="2240" y1="592" y2="592" x1="2208" />
        </branch>
        <iomarker fontsize="28" x="2240" y="592" name="clk_out" orien="R0" />
    </sheet>
</drawing>