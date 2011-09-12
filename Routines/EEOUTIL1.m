EEOUTIL1 ;HISC/JWR - COMPLAINT STATUS & TYPE COMPUTATIONS ;Apr 20, 1995
 ;;2.0;EEO Complaint Tracking;;Apr 27, 1995
STATUS ;COMPUTATON TO DETERMINE COMPLAINT STATUS
 S (CLO,FAD,INP,ADV,HEA)=""
 F CN=1,2,3,4,5,12 S EEO1(CN)=$G(^EEO(785,D0,CN))
 S ACP=$P(EEO1(1),U,3),ACR=$P(EEO1(2),U,2),DTO=$P(EEO1(12),U)
 S:$P(EEO1(2),U,4)>0!($P(EEO1(2),U,3)>0)!($P(EEO1(2),U,5)>0) INP=1
 S INV=$P(EEO1(3),U,6) S:$P(EEO1(2),U,6)>0!($P(EEO1(5),U,10)>0) ADV=1
 S:$P(EEO1(2),U,9)>0!($P(EEO1(2),U,10)>0) HEA=1
 S:$P(EEO1(2),U,13)>0 FAD=1 S DEL=$P(EEO1(12),U,2)
 S:$P(EEO1(4),U)>0 CLO=1
 S X=$S(DEL'="":"DELETED",CLO'="":"CLOSED",FAD'="":"FAD PND",HEA'="":"HEARING PND",ADV'="":"ADVISED/RIGHTS",INV'="":"INVESTIGATION",INP'="":"INV PND",DTO'="":"OGC DISMISSED",ACR'="":"ACC REV @ OGC",ACP'="":"ACC PND FIELD",1:"INFORMAL")
 I ACP'>0 S X="INFORMAL"
 Q
TYPE ;COMPUTATION TO DETERMINE TYPE OF INVESTIGATOR
 S (EEOTYPE,EEODATE)="" Q:X=""  N AEE S EEOTMP=$P($G(^EEO(785,D0,11,DA,0)),U)
 Q:EEOTMP=""
 Q:'$D(^EEO(787.5,EEOTMP,1))  S EEOCN=0 F  S EEOCN=$O(^EEO(787.5,EEOTMP,1,EEOCN)) Q:EEOCN'=+EEOCN  S AEE=$G(^(EEOCN,0)) D
 .I $P(AEE,U,2)<X&(($P(AEE,U,3)>X)!($P(AEE,U,3)="")) I EEODATE'>$P(AEE,U,2) S EEOTYPE=$P(AEE,U),EEODATE=$P(AEE,U,3)
 S EEOTYPE=$S(EEOTYPE=1:"ADHOC",EEOTYPE=2:"RETIRED ANNUITANT",EEOTYPE=3:"REGIONAL SPECIALIST",1:"")
 K EEODATE,EEOCN,EEOTMP Q
INACT ;DETERMINES IF THE INVESTIGATOR SELECTED IS CURRENTLY ACTIVE
 Q:$D(XMZ)!($G(X)'>0)  I $D(^EEO(787.5,X)) S FLAG=+$G(^(X,3))
 Q:FLAG'>0
 S DIR(0)="YAO",DIR("A")="  Are you sure, VACO lists this investigator as inactive  ",DIR("B")="NO"
 S DIR("?")="Inactive status is assigned by VACO to investigators who are not currently investigating EEO Complaints."
 S EEOX1=X W ! D ^DIR K:Y=0 X S:Y>0 X=EEOX1 K DIR,FLAG Q
ACCEPT ;Calculates the days acceptance field
 F CNT1=2,4,5,12 S @("EEOI"_CNT1)=$S($D(^EEO(785,D0)):$G(^(D0,CNT1)),1:"")
 S EEOBEG=$P(EEOI5,U,9),EEOTOGC=$P(EEOI2,U,2),EEODAS=$P(EEOI2,U,4)
 S EEODIR=$P(EEOI2,U,5),EEOAO=$S($P(EEOI2,U,3)>0:$P(EEOI2,U,3),1:+EEOI12)
 S EEOCLO=+EEOI4,EEOFAD=$P(EEOI2,U,13)
 I EEOBEG'>0 S X="" Q
 S (EEOX11,X1)=$S(EEODAS:EEODAS,EEODIR:EEODIR,EEOFAD:EEOFAD,EEOCLO:EEOCLO,1:DT)
 S X2=EEOBEG D ^%DTC S EEOAC1=X
 S X2=EEOTOGC,(EEOX2,X1)=$S(EEOAO:EEOAO,+EEOI12:+EEOI12,EEODAS:EEODAS,EEODIR:EEODIR,EEOFAD:EEOFAD,EEOCLO:EEOCLO,1:DT) D ^%DTC S EEOAC2=X
 S X=EEOAC1-EEOAC2 S:EEOAC1'>EEOAC2 X="" S:EEOX11=DT&(X>0)&(EEOX2=DT) X=X_"*"
 K EEOBEG,EEOCLO,EEODAS,EEODIR,EEOFAD,EEOTOGC,EEOI2,EEOI4,EEOI5,EEOI12,EEOX1,EEOX2,EEOX11,EEOAC1,EEOAC2,EEOAO