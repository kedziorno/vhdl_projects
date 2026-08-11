<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="spartan3e" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="XLXN_1" />
        <signal name="clk_in" />
        <signal name="enable" />
        <signal name="clk_out" />
        <signal name="XLXN_8" />
        <port polarity="Input" name="clk_in" />
        <port polarity="Input" name="enable" />
        <port polarity="Output" name="clk_out" />
        <blockdef name="ld_1">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <rect width="256" x="64" y="-320" height="256" />
            <line x2="40" y1="-128" y2="-128" x1="0" />
            <circle r="12" cx="52" cy="-128" />
            <line x2="64" y1="-256" y2="-256" x1="0" />
            <line x2="320" y1="-256" y2="-256" x1="384" />
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
        <block symbolname="ld_1" name="XLXI_9">
            <blockpin signalname="enable" name="D" />
            <blockpin signalname="clk_in" name="G" />
            <blockpin signalname="XLXN_1" name="Q" />
        </block>
        <block symbolname="and2" name="XLXI_10">
            <blockpin signalname="clk_in" name="I0" />
            <blockpin signalname="XLXN_1" name="I1" />
            <blockpin signalname="clk_out" name="O" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <instance x="560" y="1328" name="XLXI_9" orien="R0" />
        <branch name="clk_in">
            <wire x2="544" y1="1200" y2="1200" x1="528" />
            <wire x2="560" y1="1200" y2="1200" x1="544" />
            <wire x2="544" y1="1200" y2="1280" x1="544" />
            <wire x2="976" y1="1280" y2="1280" x1="544" />
        </branch>
        <branch name="enable">
            <wire x2="560" y1="1072" y2="1072" x1="528" />
        </branch>
        <iomarker fontsize="28" x="528" y="1072" name="enable" orien="R180" />
        <branch name="clk_out">
            <wire x2="1248" y1="1248" y2="1248" x1="1232" />
        </branch>
        <iomarker fontsize="28" x="528" y="1200" name="clk_in" orien="R180" />
        <instance x="976" y="1344" name="XLXI_10" orien="R0" />
        <branch name="XLXN_1">
            <wire x2="960" y1="1072" y2="1072" x1="944" />
            <wire x2="960" y1="1072" y2="1216" x1="960" />
            <wire x2="976" y1="1216" y2="1216" x1="960" />
        </branch>
        <iomarker fontsize="28" x="1248" y="1248" name="clk_out" orien="R0" />
    </sheet>
</drawing>