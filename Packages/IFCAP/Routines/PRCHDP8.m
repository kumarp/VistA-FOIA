PRCHDP8 ;WISC/DJM-PRINT AMENDMENT,ROUTINE #4 ;6/23/94  8:44 AM ;5/13/94  10:37 AM
V ;;5.1;IFCAP;**74**;Oct 20, 2000
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
E24 ;SOURCE CODE Edit PRINT
 N CHANGE,OLD,NEW,LCNT,DATA
 D LCNT^PRCHDP9(.LCNT)
 S CHANGE=$O(^PRC(442,PRCHPO,6,PRCHAM,3,"AC",24,8,0)) Q:CHANGE'>0
 S OLD=^PRC(442,PRCHPO,6,PRCHAM,3,CHANGE,1,1,0),OLD=$P(^PRCD(420.8,OLD,0),U)
 S NEW=$P(^PRC(442,PRCHPO,1),U,7),NEW=$P(^PRCD(420.8,NEW,0),U)
 D LINE^PRCHDP9(.LCNT,2) S DATA="Source Code was changed from "_OLD_" to "_NEW D DATA^PRCHDP9(.LCNT,DATA),LCNT1^PRCHDP9(LCNT)
 Q
 ;
E30 ;F.C.P. Edit PRINT
 N CHANGE,OLD,FCP,LCNT,DATA
 S CHANGE=0 D LCNT^PRCHDP9(.LCNT)
 F  S CHANGE=$O(^PRC(442,PRCHPO,6,PRCHAM,3,"AC",AMEND,1,CHANGE)) Q:CHANGE'>0  D
 .S OLD=^PRC(442,PRCHPO,6,PRCHAM,3,CHANGE,1,1,0)
 .S FCP=$P(^PRC(442,PRCHPO,0),U,3)
 .D LINE^PRCHDP9(.LCNT,2) S DATA="The FUND CONTROL POINT of "_OLD D DATA^PRCHDP9(.LCNT,DATA)
 .S DATA="has been changed to "_FCP
 .D DATA^PRCHDP9(.LCNT,DATA),LCNT1^PRCHDP9(LCNT)
 Q
 ;
E31 ;Change VENDOR PRINT
 N CHANGE,OLD,VEN,LCNT,DATA,CNT,CNT1,CNT2,AA
 S CHANGE=0,CNT=0,CNT2=0 D LCNT^PRCHDP9(.LCNT)
 ;
 ;Check for multiple vendor changes
 F  S CNT=$O(^PRC(442,PRCHPO,6,CNT)) Q:'CNT  D
 . S CNT1=0
 . F  S CNT1=$O(^PRC(442,PRCHPO,6,CNT,3,CNT1)) Q:'CNT1  D
 . . S TYPE=$G(^PRC(442,PRCHPO,6,CNT,3,CNT1,0))
 . . S TYPE=$P(TYPE,U,2) I TYPE'=31 Q
 . . S VEN=$G(^PRC(442,PRCHPO,6,CNT,3,CNT1,1,1,0))
 . . Q:VEN=""
 . . S CNT2=CNT2+1,AA(CNT)=VEN ;Count/track vendor changes
 ;
 F  S CHANGE=$O(^PRC(442,PRCHPO,6,PRCHAM,3,"AC",AMEND,5,CHANGE)) Q:CHANGE'>0  D
 .;Print vendor amendments.
 .I CNT2>1 D E31A Q
 .S OLD=^PRC(442,PRCHPO,6,PRCHAM,3,CHANGE,1,1,0),OLD=$P(^PRC(440,OLD,0),U)
 .S VEN=$P(^PRC(442,PRCHPO,1),U),VEN=$P(^PRC(440,VEN,0),U)
 .D LINE^PRCHDP9(.LCNT,2) S DATA="Vendor "_OLD_" has been changed to "_VEN
 .D DATA^PRCHDP9(.LCNT,DATA),LCNT1^PRCHDP9(LCNT)
 Q
 ;
E31A ;Print multiple vendor changes.
 S OLD=$P(^PRC(440,AA(PRCHAM),0),U)
 S VEN=$O(AA(PRCHAM))
 I VEN="" S VEN=$P(^PRC(442,PRCHPO,1),U)
 E  S VEN=AA(VEN)
 S VEN=$P(^PRC(440,VEN,0),U)
 ;
 D LINE^PRCHDP9(.LCNT,2)
 S DATA="Vendor "_OLD_" has been changed to "_VEN
 D DATA^PRCHDP9(.LCNT,DATA),LCNT1^PRCHDP9(LCNT)
 Q
 ;
E32 ;REPLACE P.O. NUMBER PRINT
 N CHANGE,NPO,OPO,LCNT,DATA
 S CHANGE=0 D LCNT^PRCHDP9(.LCNT)
 F  S CHANGE=$O(^PRC(442,PRCHPO,6,PRCHAM,3,"AC",AMEND,28,CHANGE)) Q:CHANGE'>0  D
 .S NPO=$P(^PRC(442,PRCHPO,23),U,4),NPO=$P(^PRC(442,NPO,0),U)
 .S OPO=$P(^PRC(442,PRCHPO,0),U)
 .D LINE^PRCHDP9(.LCNT,2) S DATA="Purchase Order number "_OPO_" has been changed to "_NPO
 .D DATA^PRCHDP9(.LCNT,DATA),LCNT1^PRCHDP9(LCNT)
 Q
 ;
E33 ;PROMPT PAYMENT Edit PRINT
 ;N CHANGE,CHANGES,FIELD,OLD,PAY,LCNT,DATA,PCT,PCT1,PCT2,DAYS,DAYS1,DAYS2,TERMS,NPCT,NDAYS1
 S FIELD=0 K PAY D LCNT^PRCHDP9(.LCNT)
 F  S FIELD=$O(^PRC(442,PRCHPO,6,PRCHAM,3,"AC",AMEND,FIELD)) Q:FIELD'>0  D
 .S CHANGE=0 F  S CHANGE=$O(^PRC(442,PRCHPO,6,PRCHAM,3,"AC",AMEND,FIELD,CHANGE)) Q:CHANGE'>0  D
 ..S CHANGES=^PRC(442,PRCHPO,6,PRCHAM,3,CHANGE,0),OLD=^PRC(442,PRCHPO,6,PRCHAM,3,CHANGE,1,1,0)
 ..S:FIELD=.01 PCT2=OLD S:FIELD=1 DAYS2=OLD
 ..S PAY=$P(CHANGES,U,4) Q:$D(PAY(PAY))  S PAY(PAY)=1
 ..I FIELD'=1 S DAYS=0 F  S DAYS=$O(^PRC(442,PRCHPO,6,PRCHAM,3,"AC",33,1,DAYS)) Q:DAYS'>0  S DAYS1=$P(^PRC(442,PRCHPO,6,PRCHAM,3,DAYS,0),U,4) I DAYS1=PAY D  Q
 ...S DAYS2=^PRC(442,PRCHPO,6,PRCHAM,3,DAYS,1,1,0) Q
 ..I FIELD'=.01 S PCT=0 F  S PCT=$O(^PRC(442,PRCHPO,6,PRCHAM,3,"AC",33,.01,PCT)) Q:PCT'>0  S PCT1=$P(^PRC(442,PRCHPO,6,PRCHAM,3,PCT,0),U,4) I PCT1=PAY D  Q
 ...S PCT2=^PRC(442,PRCHPO,6,PRCHAM,3,PCT,1,1,0) Q
 ..S TERMS=^PRC(442,PRCHPO,5,PAY,0),NPCT=$P(TERMS,U),NDAYS1=$P(TERMS,U,2)
 ..D LINE^PRCHDP9(.LCNT,2)
 ..S DAYS2=$G(DAYS2),PCT2=$G(PCT2)
 ..I DAYS2'=0,PCT2'=0 S DATA="Prompt Payment "_PCT2_$S(PCT2=+PCT2:"%",1:"")_"/"_DAYS2_$S(DAYS2=+DAYS2:" days",1:"") D
 ...S DATA=DATA_" has been changed to "_NPCT_$S(NPCT=+NPCT:"%",1:"")_"/"_NDAYS1_$S(NDAYS1=+NDAYS1:" days",1:"")
 ...D DATA^PRCHDP9(.LCNT,DATA) Q
 ..I DAYS2=0,PCT2=0 S DATA="  *ADDED THROUGH AMENDMENT*" D DATA^PRCHDP9(.LCNT,DATA) D
 ...S DATA="Prompt Payment "_NPCT_$S(NPCT=+NPCT:"%",1:"")_"/"_NDAYS1_$S(NDAYS1=+NDAYS1:" days",1:"")_" has been added"
 ...D DATA^PRCHDP9(.LCNT,DATA) Q
 ..Q
 .Q
 D LCNT1^PRCHDP9(LCNT)
 Q