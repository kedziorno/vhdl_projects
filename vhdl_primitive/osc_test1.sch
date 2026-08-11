<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="spartan3e" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="XLXN_1" />
        <signal name="ip" />
        <signal name="XLXN_6" />
        <signal name="XLXN_8" />
        <signal name="XLXN_9" />
        <signal name="op" />
        <signal name="XLXN_11" />
        <port polarity="Input" name="ip" />
        <port polarity="Output" name="op" />
        <blockdef name="inv">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-32" y2="-32" x1="0" />
            <line x2="160" y1="-32" y2="-32" x1="224" />
            <line x2="128" y1="-64" y2="-32" x1="64" />
            <line x2="64" y1="-32" y2="0" x1="128" />
            <line x2="64" y1="0" y2="-64" x1="64" />
            <circle r="16" cx="144" cy="-32" />
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
        <blockdef name="bufg">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-64" y2="0" x1="64" />
            <line x2="64" y1="-32" y2="-64" x1="128" />
            <line x2="128" y1="0" y2="-32" x1="64" />
            <line x2="128" y1="-32" y2="-32" x1="224" />
            <line x2="64" y1="-32" y2="-32" x1="0" />
        </blockdef>
        <block symbolname="inv" name="XLXI_1">
            <blockpin signalname="XLXN_8" name="I" />
            <blockpin signalname="XLXN_9" name="O" />
        </block>
        <block symbolname="inv" name="XLXI_2">
            <blockpin signalname="XLXN_1" name="I" />
            <blockpin signalname="XLXN_6" name="O" />
        </block>
        <block symbolname="xor2" name="XLXI_3">
            <blockpin signalname="ip" name="I0" />
            <blockpin signalname="op" name="I1" />
            <blockpin signalname="XLXN_1" name="O" />
        </block>
        <block symbolname="bufg" name="XLXI_7">
            <blockpin signalname="XLXN_9" name="I" />
            <blockpin signalname="op" name="O" />
        </block>
        <block symbolname="bufg" name="XLXI_11">
            <blockpin signalname="XLXN_6" name="I" />
            <blockpin signalname="XLXN_8" name="O" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <instance x="1696" y="1040" name="XLXI_3" orien="R0" />
        <branch name="ip">
            <wire x2="1696" y1="976" y2="976" x1="1664" />
        </branch>
        <iomarker fontsize="28" x="1664" y="976" name="ip" orien="R180" />
        <iomarker fontsize="28" x="2544" y="944" name="op" orien="R0" />
        <instance x="1520" y="1200" name="XLXI_2" orien="R0" />
        <branch name="XLXN_1">
            <wire x2="1440" y1="1072" y2="1168" x1="1440" />
            <wire x2="1520" y1="1168" y2="1168" x1="1440" />
            <wire x2="1968" y1="1072" y2="1072" x1="1440" />
            <wire x2="1968" y1="944" y2="944" x1="1952" />
            <wire x2="1968" y1="944" y2="1072" x1="1968" />
        </branch>
        <branch name="XLXN_8">
            <wire x2="2016" y1="1168" y2="1168" x1="2000" />
            <wire x2="2032" y1="1168" y2="1168" x1="2016" />
        </branch>
        <instance x="2032" y="1200" name="XLXI_1" orien="R0" />
        <branch name="XLXN_9">
            <wire x2="2288" y1="1168" y2="1168" x1="2256" />
        </branch>
        <branch name="op">
            <wire x2="1632" y1="880" y2="912" x1="1632" />
            <wire x2="1696" y1="912" y2="912" x1="1632" />
            <wire x2="2464" y1="880" y2="880" x1="1632" />
            <wire x2="2464" y1="880" y2="944" x1="2464" />
            <wire x2="2464" y1="944" y2="1072" x1="2464" />
            <wire x2="2576" y1="1072" y2="1072" x1="2464" />
            <wire x2="2576" y1="1072" y2="1168" x1="2576" />
            <wire x2="2544" y1="944" y2="944" x1="2464" />
            <wire x2="2576" y1="1168" y2="1168" x1="2512" />
        </branch>
        <branch name="XLXN_6">
            <wire x2="1760" y1="1168" y2="1168" x1="1744" />
            <wire x2="1776" y1="1168" y2="1168" x1="1760" />
        </branch>
        <instance x="2288" y="1200" name="XLXI_7" orien="R0" />
        <instance x="1776" y="1200" name="XLXI_11" orien="R0" />
    </sheet>
</drawing>