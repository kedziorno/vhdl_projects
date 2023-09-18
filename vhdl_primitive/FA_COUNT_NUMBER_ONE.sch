<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="spartan3e" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="INPUT(6)" />
        <signal name="INPUT(5)" />
        <signal name="INPUT(3)" />
        <signal name="INPUT(2)" />
        <signal name="INPUT(4)" />
        <signal name="INPUT(1)" />
        <signal name="XLXN_7" />
        <signal name="XLXN_8" />
        <signal name="XLXN_10" />
        <signal name="XLXN_11" />
        <signal name="INPUT(0)" />
        <signal name="XLXN_13" />
        <signal name="OUTPUT(2)" />
        <signal name="OUTPUT(1)" />
        <signal name="OUTPUT(0)" />
        <signal name="INPUT(6:0)" />
        <signal name="OUTPUT(2:0)" />
        <port polarity="Input" name="INPUT(6:0)" />
        <port polarity="Output" name="OUTPUT(2:0)" />
        <blockdef name="FA_MUX41">
            <timestamp>2023-9-18T17:46:49</timestamp>
            <line x2="112" y1="-48" y2="0" x1="112" />
            <line x2="80" y1="-176" y2="-208" x1="80" />
            <line x2="144" y1="-176" y2="-208" x1="144" />
            <line x2="40" y1="-112" y2="-112" x1="0" />
            <rect width="140" x="40" y="-176" height="128" />
            <line x2="180" y1="-112" y2="-112" x1="224" />
        </blockdef>
        <block symbolname="FA_MUX41" name="XLXI_1">
            <blockpin signalname="INPUT(6)" name="A" />
            <blockpin signalname="INPUT(5)" name="B" />
            <blockpin signalname="XLXN_10" name="Carry_out" />
            <blockpin signalname="INPUT(4)" name="Carry_in" />
            <blockpin signalname="XLXN_7" name="Sum" />
        </block>
        <block symbolname="FA_MUX41" name="XLXI_2">
            <blockpin signalname="INPUT(3)" name="A" />
            <blockpin signalname="INPUT(2)" name="B" />
            <blockpin signalname="XLXN_11" name="Carry_out" />
            <blockpin signalname="INPUT(1)" name="Carry_in" />
            <blockpin signalname="XLXN_8" name="Sum" />
        </block>
        <block symbolname="FA_MUX41" name="XLXI_3">
            <blockpin signalname="XLXN_10" name="A" />
            <blockpin signalname="XLXN_11" name="B" />
            <blockpin signalname="OUTPUT(2)" name="Carry_out" />
            <blockpin signalname="XLXN_13" name="Carry_in" />
            <blockpin signalname="OUTPUT(1)" name="Sum" />
        </block>
        <block symbolname="FA_MUX41" name="XLXI_4">
            <blockpin signalname="XLXN_7" name="A" />
            <blockpin signalname="XLXN_8" name="B" />
            <blockpin signalname="XLXN_13" name="Carry_out" />
            <blockpin signalname="INPUT(0)" name="Carry_in" />
            <blockpin signalname="OUTPUT(0)" name="Sum" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <instance x="912" y="1008" name="XLXI_1" orien="R0">
        </instance>
        <instance x="1328" y="1008" name="XLXI_2" orien="R0">
        </instance>
        <branch name="INPUT(6)">
            <attrtext style="alignment:SOFT-TVCENTER;fontsize:28;fontname:Arial" attrname="Name" x="992" y="688" type="branch" />
            <wire x2="992" y1="656" y2="688" x1="992" />
            <wire x2="992" y1="688" y2="720" x1="992" />
            <wire x2="992" y1="720" y2="800" x1="992" />
        </branch>
        <branch name="INPUT(5)">
            <attrtext style="alignment:SOFT-TVCENTER;fontsize:28;fontname:Arial" attrname="Name" x="1056" y="688" type="branch" />
            <wire x2="1056" y1="656" y2="688" x1="1056" />
            <wire x2="1056" y1="688" y2="720" x1="1056" />
            <wire x2="1056" y1="720" y2="800" x1="1056" />
        </branch>
        <branch name="INPUT(3)">
            <attrtext style="alignment:SOFT-TVCENTER;fontsize:28;fontname:Arial" attrname="Name" x="1408" y="688" type="branch" />
            <wire x2="1408" y1="656" y2="688" x1="1408" />
            <wire x2="1408" y1="688" y2="720" x1="1408" />
            <wire x2="1408" y1="720" y2="800" x1="1408" />
        </branch>
        <branch name="INPUT(2)">
            <attrtext style="alignment:SOFT-TVCENTER;fontsize:28;fontname:Arial" attrname="Name" x="1472" y="688" type="branch" />
            <wire x2="1472" y1="656" y2="688" x1="1472" />
            <wire x2="1472" y1="688" y2="720" x1="1472" />
            <wire x2="1472" y1="720" y2="800" x1="1472" />
        </branch>
        <branch name="INPUT(4)">
            <attrtext style="alignment:SOFT-TVCENTER;fontsize:28;fontname:Arial" attrname="Name" x="1152" y="688" type="branch" />
            <wire x2="1152" y1="896" y2="896" x1="1136" />
            <wire x2="1152" y1="656" y2="688" x1="1152" />
            <wire x2="1152" y1="688" y2="720" x1="1152" />
            <wire x2="1152" y1="720" y2="896" x1="1152" />
        </branch>
        <branch name="INPUT(1)">
            <attrtext style="alignment:SOFT-TVCENTER;fontsize:28;fontname:Arial" attrname="Name" x="1568" y="688" type="branch" />
            <wire x2="1568" y1="896" y2="896" x1="1552" />
            <wire x2="1568" y1="656" y2="688" x1="1568" />
            <wire x2="1568" y1="688" y2="720" x1="1568" />
            <wire x2="1568" y1="720" y2="896" x1="1568" />
        </branch>
        <branch name="XLXN_8">
            <wire x2="1440" y1="1008" y2="1088" x1="1440" />
        </branch>
        <instance x="1296" y="1296" name="XLXI_4" orien="R0">
        </instance>
        <branch name="XLXN_7">
            <wire x2="1024" y1="1008" y2="1024" x1="1024" />
            <wire x2="1376" y1="1024" y2="1024" x1="1024" />
            <wire x2="1376" y1="1024" y2="1088" x1="1376" />
        </branch>
        <instance x="816" y="1296" name="XLXI_3" orien="R0">
        </instance>
        <branch name="XLXN_10">
            <wire x2="912" y1="896" y2="896" x1="896" />
            <wire x2="896" y1="896" y2="1088" x1="896" />
        </branch>
        <branch name="XLXN_11">
            <wire x2="960" y1="1072" y2="1088" x1="960" />
            <wire x2="1232" y1="1072" y2="1072" x1="960" />
            <wire x2="1232" y1="896" y2="1072" x1="1232" />
            <wire x2="1328" y1="896" y2="896" x1="1232" />
        </branch>
        <branch name="INPUT(0)">
            <attrtext style="alignment:SOFT-TVCENTER;fontsize:28;fontname:Arial" attrname="Name" x="1648" y="688" type="branch" />
            <wire x2="1648" y1="1184" y2="1184" x1="1520" />
            <wire x2="1648" y1="656" y2="688" x1="1648" />
            <wire x2="1648" y1="688" y2="720" x1="1648" />
            <wire x2="1648" y1="720" y2="1184" x1="1648" />
        </branch>
        <branch name="XLXN_13">
            <wire x2="1296" y1="1184" y2="1184" x1="1040" />
        </branch>
        <branch name="OUTPUT(2)">
            <attrtext style="alignment:SOFT-TVCENTER;fontsize:28;fontname:Arial" attrname="Name" x="800" y="1368" type="branch" />
            <wire x2="816" y1="1184" y2="1184" x1="800" />
            <wire x2="800" y1="1184" y2="1328" x1="800" />
            <wire x2="800" y1="1328" y2="1368" x1="800" />
            <wire x2="800" y1="1368" y2="1408" x1="800" />
        </branch>
        <branch name="OUTPUT(1)">
            <attrtext style="alignment:SOFT-TVCENTER;fontsize:28;fontname:Arial" attrname="Name" x="928" y="1368" type="branch" />
            <wire x2="928" y1="1296" y2="1328" x1="928" />
            <wire x2="928" y1="1328" y2="1368" x1="928" />
            <wire x2="928" y1="1368" y2="1408" x1="928" />
        </branch>
        <branch name="OUTPUT(0)">
            <attrtext style="alignment:SOFT-TVCENTER;fontsize:28;fontname:Arial" attrname="Name" x="1408" y="1368" type="branch" />
            <wire x2="1408" y1="1296" y2="1328" x1="1408" />
            <wire x2="1408" y1="1328" y2="1368" x1="1408" />
            <wire x2="1408" y1="1368" y2="1408" x1="1408" />
        </branch>
        <branch name="INPUT(6:0)">
            <wire x2="976" y1="560" y2="560" x1="960" />
            <wire x2="992" y1="560" y2="560" x1="976" />
            <wire x2="1056" y1="560" y2="560" x1="992" />
            <wire x2="1152" y1="560" y2="560" x1="1056" />
            <wire x2="1408" y1="560" y2="560" x1="1152" />
            <wire x2="1472" y1="560" y2="560" x1="1408" />
            <wire x2="1568" y1="560" y2="560" x1="1472" />
            <wire x2="1648" y1="560" y2="560" x1="1568" />
            <wire x2="1664" y1="560" y2="560" x1="1648" />
        </branch>
        <bustap x2="992" y1="560" y2="656" x1="992" />
        <bustap x2="1056" y1="560" y2="656" x1="1056" />
        <bustap x2="1152" y1="560" y2="656" x1="1152" />
        <bustap x2="1408" y1="560" y2="656" x1="1408" />
        <bustap x2="1472" y1="560" y2="656" x1="1472" />
        <bustap x2="1568" y1="560" y2="656" x1="1568" />
        <bustap x2="1648" y1="560" y2="656" x1="1648" />
        <branch name="OUTPUT(2:0)">
            <wire x2="928" y1="1504" y2="1504" x1="800" />
            <wire x2="1408" y1="1504" y2="1504" x1="928" />
            <wire x2="1440" y1="1504" y2="1504" x1="1408" />
        </branch>
        <bustap x2="800" y1="1504" y2="1408" x1="800" />
        <bustap x2="928" y1="1504" y2="1408" x1="928" />
        <bustap x2="1408" y1="1504" y2="1408" x1="1408" />
        <iomarker fontsize="28" x="1440" y="1504" name="OUTPUT(2:0)" orien="R0" />
        <iomarker fontsize="28" x="960" y="560" name="INPUT(6:0)" orien="R180" />
    </sheet>
</drawing>