ALPBCBU ;OIFO-DALLAS/SED/KC/MW  BCMA-BCBU INPT TO HL7 ;5/2/2002
 ;;3.0;BAR CODE MED ADMIN;**8**;Mar 2004
 ;This is the main routine for the BCBU software.
 ;It handles all the entries points for the BCBU software. 
 ;It also handles error checking.
IPH(ALPMSG) ;CAPTURE MESSAGE ARRAY FROM PHARMACY
 N ALPRSLT
 Q:'$D(ALPMSG)
 ;CHECK IF BCBU IS ACTIVE AT PACKAGE LEVEL
 Q:+$$GET^XPAR("PKG.BAR CODE MED ADMIN","PSB BKUP ONLINE",1,"Q")'>0
 S ALPRSLT=$$IPH^ALPBINP(.ALPMSG)
 ;I $P(ALPRSLT,U,2)'="" D ERRLG
 Q
MEDL(ALPML) ;Use this entry to send MedLog messages
 N ALPRSLT
 ;ALPML is the IEN of the MedLog for file #53.79
 Q:'$D(ALPML)
 ;CHECK IF BCBU IS ACTIVE AT PACKAGE LEVEL
 Q:+$$GET^XPAR("PKG.BAR CODE MED ADMIN","PSB BKUP ONLINE",1,"Q")'>0
 S ALPRSLT=$$MEDL^ALPBINP(ALPML)
 I $P(ALPRSLT,U,2)'="" D ERRLG
 Q
NURV(ALDFN,ALPORD) ;Use this entry to send verifying nursing.
 N ALPRSLT
 ;ALDFN is the IEN of the patient
 ;ALPORDR is the order number
 Q:'$D(ALDFN)
 Q:'$D(ALPORD)
 ;CHECK IF BCBU IS ACTIVE AT PACKAGE LEVEL
 Q:+$$GET^XPAR("PKG.BAR CODE MED ADMIN","PSB BKUP ONLINE",1,"Q")'>0
 K ALPB
 D EN^PSJBCBU(ALDFN,ALPORD,.ALPB)
 S ALPBI=0
 F  S ALPBI=$O(ALPB(ALPBI)) Q:ALPBI'>0  D
 . I $E(ALPB(ALPBI),1,3)="MSH" S MSH=ALPBI
 . I $E(ALPB(ALPBI),1,3)="PID" S PID=ALPBI
 . I $E(ALPB(ALPBI),1,3)="PV1" S PV1=ALPBI
 . I $E(ALPB(ALPBI),1,3)="ORC" S ORC=ALPBI
 I +$G(MSH)'>0 Q   ;MISSING MSH SEGMENT BAD MESSAGE
 S MSCTR=$E(ALPB(MSH),4,8)
 S ALPRSLT=$$INI^ALPBINP()
 ;I $P(ALPRSLT,U,2)'="" D ERRLG
 K ALPB,ALPBI
 Q
PMOV ;Entry Point to send patient movement
 N ALPRSLT
 ;CHECK IF BCBU IS ACTIVE AT PACKAGE LEVEL
 Q:+$$GET^XPAR("PKG.BAR CODE MED ADMIN","PSB BKUP ONLINE",1,"Q")'>0
 Q:'$D(DFN)!'$D(DGPMTYP)!'$D(DGPMUC)
 ;Screen out Lodgers
 Q:DGPMUC["LODGER"
 S ALPRSLT=$$PMOV^ALPBINP(DFN,DGPMTYP,DGPMUC,$P($G(DGPMA),U))
 I $P(ALPRSLT,U,2)'="" D ERRLG
 Q
ERRLG ;Error Log Message
 ;Alert
 K XQA,XQAMSG,XQAOPT,XQAROU,XQAID,XQADATA,XQAFLAG
 S XQA("G.PSB BCBU ERRORS")=""
 S XQAMSG="BCBU Contingency Error"
 S XQADATA=ALPRSLT
 S XQAROU="PERR^ALPBCBU"
 ;S XQAOPT="PSB BCBU ERROR LOG"
 ;S ALPBFERR("DIERR",1)=9999
 ;I $D(ALPMSG) M ALPBFERR("DIERR",1,"TEXT")=ALPMSG
 ;D ERRLOG^ALPBUTL1(9999,0,0,$P(XQADATA,U,2),$P(XQADATA,U,3),.ALPBFERR)
 D SETUP^XQALERT
 Q
PERR ;Process the error
 W @IOF,!,"PSB BCBU Contingency Error",!
 W ?10,$P(XQADATA,U,2)_" / "_$P(XQADATA,U,3)
 Q
