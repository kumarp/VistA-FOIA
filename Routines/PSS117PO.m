PSS117PO ;BIR/RTR-Post Install routine for patch PSS*1*117 ;11/22/08
 ;;1.0;PHARMACY DATA MANAGEMENT;**117**;9/30/97;Build 101
 ;
 ;
EN ;Do Mail Message
 ;
 D MNUADD D BMES^XPDUTL("Generating Mail Message....") D MAIL D BMES^XPDUTL("Mail message sent.")
 Q
 ;
 ;
MAIL ;Send mail message
 N PSS17REC,PSS17PLP,XMTEXT,XMY,XMSUB,XMDUZ,XMMG,XMSTRIP,XMROU,XMYBLOB,XMZ,XMDUN
 K ^TMP($J,"PSS17PTX")
 F PSS17PLP=0:0 S PSS17PLP=$O(@XPDGREF@("PSSMLMSG",PSS17PLP)) Q:'PSS17PLP  S ^TMP($J,"PSS17PTX",PSS17PLP)=@XPDGREF@("PSSMLMSG",PSS17PLP)
 S XMSUB="PSS*1*117 Installation Complete"
 S XMDUZ="PSS*1*117 Install"
 S XMTEXT="^TMP($J,""PSS17PTX"","
 ;F PSSFDS=0:0 S PSSFDS=$O(@XPDGREF@("PSSVJARX",PSSFDS)) Q:'PSSFDS  S XMY(PSSFDS)=""
 ;S XMY("G.PSS ORDER CHECKS")=""
 S PSS17REC="" F  S PSS17REC=$O(@XPDGREF@("PSSMLMDZ",PSS17REC)) Q:PSS17REC=""  S XMY(PSS17REC)=""
 N DIFROM D ^XMD
 K ^TMP($J,"PSS17PTX")
 Q
 ;
 ;
MNUADD ;Add PSS ORDER CHECK MANAGEMENT Sub-Menu to PSS MGR Menu option
 D BMES^XPDUTL("Linking New PSS Menus....")
 N PSSMNUA,PSSMNUAF,PSSMNUA1,PSSMNUA2
 S PSSMNUA2=0
 F PSSMNUA1=0:0 S PSSMNUA1=$O(@XPDGREF@("PSSMLMSG",PSSMNUA1)) Q:'PSSMNUA1  S PSSMNUA2=PSSMNUA2+1
 ;I PSSMNUA2>2 S PSSMNUA2=PSSMNUA2+1 S @XPDGREF@("PSSMLMSG",PSSMNUA2)=" "
 S PSSMNUA2=PSSMNUA2+1 S PSSMNUAF=1
 K PSSMNUA S PSSMNUA=$$ADD^XPDMENU("PSS MGR","PSS ORDER CHECK MANAGEMENT",,4) I 'PSSMNUA D MNUADD1
 K PSSMNUA S PSSMNUA=$$ADD^XPDMENU("PSS ORDER CHECK MANAGEMENT","PSS ORDER CHECK CHANGES",,1) I 'PSSMNUA D MNUADD2
 K PSSMNUA S PSSMNUA=$$ADD^XPDMENU("PSS ORDER CHECK MANAGEMENT","PSS REPORT LOCAL INTERACTIONS",,2) I 'PSSMNUA D MNUADD3
 K PSSMNUA S PSSMNUA=$$ADD^XPDMENU("PSS PEPS SERVICES","PSS SCHEDULE PEPS INTERFACE CK",,3) I 'PSSMNUA D MNUADD4
 K PSSMNUA S PSSMNUA=$$ADD^XPDMENU("PSS ADDITIVE/SOLUTION","PSS IV ADDITIVE REPORT",,1) I 'PSSMNUA D MNUADD11
 K PSSMNUA S PSSMNUA=$$ADD^XPDMENU("PSS ADDITIVE/SOLUTION","PSS IV SOLUTION REPORT",,2) I 'PSSMNUA D MNUADD12
 K PSSMNUA S PSSMNUA=$$ADD^XPDMENU("PSS ADDITIVE/SOLUTION","PSS MARK PREMIX SOLUTIONS",,3) I 'PSSMNUA D MNUADD13
 D REB I PSSMNUAF D BMES^XPDUTL("All Menu options linked successfully....")
 ;D TASKIT^PSSHRIT(15)
 Q
 ;
 ;
MNUADD1 ;
 S PSSMNUAF=0
 D BMES^XPDUTL("Unable to link PSS ORDER CHECK MANAGEMENT Menu Option....")
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)="Unable to link PSS ORDER CHECK MANAGEMENT Menu Option to PSS MGR Menu" S PSSMNUA2=PSSMNUA2+1
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)="Please Log a Remedy Ticket and refer to this message." S PSSMNUA2=PSSMNUA2+1
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)=" " S PSSMNUA2=PSSMNUA2+1
 Q
 ;
 ;
MNUADD2 ;
 S PSSMNUAF=0
 D BMES^XPDUTL("Unable to link PSS ORDER CHECK CHANGES Option....")
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)="Unable to link PSS ORDER CHECK CHANGES to PSS ORDER CHECK MANAGEMENT Menu" S PSSMNUA2=PSSMNUA2+1
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)="Please Log a Remedy Ticket and refer to this message." S PSSMNUA2=PSSMNUA2+1
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)=" " S PSSMNUA2=PSSMNUA2+1
 Q
 ;
 ;
MNUADD3 ;
 S PSSMNUAF=0
 D BMES^XPDUTL("Unable to link PSS REPORT LOCAL INTERACTIONS Option....")
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)="Unable to link PSS REPORT LOCAL INTERACTIONS to PSS ORDER CHECK MANAGEMENT Menu" S PSSMNUA2=PSSMNUA2+1
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)="Please Log a Remedy Ticket and refer to this message." S PSSMNUA2=PSSMNUA2+1
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)=" " S PSSMNUA2=PSSMNUA2+1
 Q
MNUADD4 ;
 S PSSMNUAF=0
 D BMES^XPDUTL("Unable to link PSS SCHEDULE PEPS INTERFACE CK Option....")
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)="Unable to link PSS SCHEDULE PEPS INTERFACE CK to PSS PEPS SERVICES Menu" S PSSMNUA2=PSSMNUA2+1
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)="Please Log a Remedy Ticket and refer to this message." S PSSMNUA2=PSSMNUA2+1
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)=" " S PSSMNUA2=PSSMNUA2+1
 Q
 ;
 ;
REB ;Rebuild Menus
 N PSSMNUR
 ;S PSSMNUR=$$DELETE^XPDMENU("PSS MGR","PSS ADDITIVE/SOLUTION REPORTS")
 S PSSMNUR=$$DELETE^XPDMENU("PSS MGR","PSS WARNING BUILDER")
 S PSSMNUR=$$DELETE^XPDMENU("PSS MGR","PSS WARNING MAPPING")
 S PSSMNUR=$$DELETE^XPDMENU("PSS MGR","PSS PEPS SERVICES")
 K PSSMNUA S PSSMNUA=$$ADD^XPDMENU("PSS MGR","PSS ADDITIVE/SOLUTION",,17) I 'PSSMNUA D MNUADD5
 K PSSMNUA S PSSMNUA=$$ADD^XPDMENU("PSS MGR","PSS WARNING BUILDER",,18) I 'PSSMNUA D MNUADD6
 K PSSMNUA S PSSMNUA=$$ADD^XPDMENU("PSS MGR","PSS WARNING MAPPING",,19) I 'PSSMNUA D MNUADD7
 K PSSMNUA S PSSMNUA=$$ADD^XPDMENU("PSS MGR","PSS PEPS SERVICES",,20) I 'PSSMNUA D MNUADD8
 Q
 ;
 ;
MNUADD5 ;
 S PSSMNUAF=0
 D BMES^XPDUTL("Unable to link PSS ADDITIVE/SOLUTION Option....")
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)="Unable to link PSS ADDITIVE/SOLUTION to PSS MGR Menu" S PSSMNUA2=PSSMNUA2+1
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)="Please Log a Remedy Ticket and refer to this message." S PSSMNUA2=PSSMNUA2+1
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)=" " S PSSMNUA2=PSSMNUA2+1
 Q
 ;
 ;
MNUADD6 ;
 S PSSMNUAF=0
 D BMES^XPDUTL("Unable to re-link PSS WARNING BUILDER Option....")
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)="Unable to RE-link PSS WARNING BUILDER to PSS MGR Menu" S PSSMNUA2=PSSMNUA2+1
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)="Please Log a Remedy Ticket and refer to this message." S PSSMNUA2=PSSMNUA2+1
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)=" " S PSSMNUA2=PSSMNUA2+1
 Q
 ;
 ;
MNUADD7 ;
 S PSSMNUAF=0
 D BMES^XPDUTL("Unable to re-link PSS WARNING MAPPING CK Option....")
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)="Unable to re-link PSS WARNING MAPPING to PSS MGR Menu" S PSSMNUA2=PSSMNUA2+1
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)="Please Log a Remedy Ticket and refer to this message." S PSSMNUA2=PSSMNUA2+1
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)=" " S PSSMNUA2=PSSMNUA2+1
 Q
 ;
 ;
MNUADD8 ;
 S PSSMNUAF=0
 D BMES^XPDUTL("Unable to re-link PSS PEPS SERVICES Option....")
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)="Unable to re-link PSS PEPS SERVICES to PSS MGR Menu" S PSSMNUA2=PSSMNUA2+1
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)="Please Log a Remedy Ticket and refer to this message." S PSSMNUA2=PSSMNUA2+1
 Q
 ;
 ;
MNUADD11 ;
 S PSSMNUAF=0
 D BMES^XPDUTL("Unable to link PSS IV ADDITIVE REPORT Option....")
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)="Unable to link PSS IV ADDITIVE REPORT to PSS ADDITIVE/SOLUTION Menu" S PSSMNUA2=PSSMNUA2+1
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)="Please Log a Remedy Ticket and refer to this message." S PSSMNUA2=PSSMNUA2+1
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)=" " S PSSMNUA2=PSSMNUA2+1
 Q
 ;
 ;
MNUADD12 ;
 S PSSMNUAF=0
 D BMES^XPDUTL("Unable to link PSS IV SOLUTION REPORT Option....")
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)="Unable to link PSS IV SOLUTION REPORT to PSS ADDITIVE/SOLUTION Menu" S PSSMNUA2=PSSMNUA2+1
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)="Please Log a Remedy Ticket and refer to this message." S PSSMNUA2=PSSMNUA2+1
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)=" " S PSSMNUA2=PSSMNUA2+1
 Q
 ;
 ;
MNUADD13 ;
 S PSSMNUAF=0
 D BMES^XPDUTL("Unable to link PSS MARK PREMIX SOLUTIONS Option....")
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)="Unable to link PSS MARK PREMIX SOLUTIONS to PSS ADDITIVE/SOLUTION Menu" S PSSMNUA2=PSSMNUA2+1
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)="Please Log a Remedy Ticket and refer to this message." S PSSMNUA2=PSSMNUA2+1
 S @XPDGREF@("PSSMLMSG",PSSMNUA2)=" " S PSSMNUA2=PSSMNUA2+1
 Q