QAMC18 ;HISC/DAD-CONDITION: ON WARD ;4/30/93  12:35
 ;;1.0;Clinical Monitoring System;;09/13/1993
EN1 ; *** CONDITION CODE
 S QAMGRP=$S($D(^QA(743,QAMD0,"COND",QAMD1,"P1"))#2:+^("P1"),1:0)
 S QAMSMPSZ=$S($D(^QA(743,QAMD0,"COND",QAMD1,"P2"))#2:","_^("P2")_",",1:0)
 D EN^QAMTIME0 S QAMXREF="AMV3"
 F QAMMOV=QAMTODAY-.0000001:0 S QAMMOV=$O(^DGPM("AMV3",QAMMOV)) Q:(QAMMOV'>0)!(QAMMOV>(QAMTODAY+.9999999))!(QAMMOV\1'?7N)  F QAMDFN=0:0 S QAMDFN=$O(^DGPM("AMV3",QAMMOV,QAMDFN)) Q:QAMDFN'>0  D
 . F QAMMOVD0=0:0 S QAMMOVD0=$O(^DGPM("AMV3",QAMMOV,QAMDFN,QAMMOVD0)) Q:QAMMOVD0'>0  S QAMCORAD=$P($G(^DGPM(QAMMOVD0,0)),"^",14) D:QAMCORAD LOOP1
 . Q
 S (QAMWRD,QAMXREF)=""
 F  S QAMWRD=$O(^DPT("CN",QAMWRD)) Q:QAMWRD=""  F QAMDFN=0:0 S QAMDFN=$O(^DPT("CN",QAMWRD,QAMDFN)) Q:QAMDFN'>0  S QAMCORAD=^DPT("CN",QAMWRD,QAMDFN) D LOOP1
 K FLG,QAMCORAD,QAMDGPM,QAMGRP,QAMIMOV,QAMMOV,QAMMOVD0,QAMMOVDT,QAMMOVS0,QAMMOVTY,QAMSMPSZ,QAMWRD,QAMXREF,WARD
 Q
LOOP1 ;
 S FLG=0
 F QAMIMOV=9999999.9999999-(QAMTODAY+.24):0 S QAMIMOV=$O(^DGPM("APMV",QAMDFN,QAMCORAD,QAMIMOV)) Q:(QAMIMOV'>0)!(QAMIMOV\1'?7N)!FLG  F QAMMOVS0=0:0 S QAMMOVS0=$O(^DGPM("APMV",QAMDFN,QAMCORAD,QAMIMOV,QAMMOVS0)) Q:QAMMOVS0'>0!FLG  D
 . S QAMDGPM=$G(^DGPM(QAMMOVS0,0))
 . S QAMMOVDT=+QAMDGPM,QAMMOVTY=$P(QAMDGPM,"^",2),WARD=+$P(QAMDGPM,"^",6)
 . Q:"^1^2^"'[("^"_QAMMOVTY_"^")  ;  ADMISSIONS & TRANSFERS ONLY
 . I QAMGRP Q:$O(^QA(743.5,QAMGRP,"GRP","AB",+WARD,0))'>0
 . I (QAMSMPSZ[",1,")!(QAMMOVTY=1) S ^UTILITY($J,"QAM CONDITION",QAMD1,QAMDFN)="" ;   *** ADM
 . I (QAMSMPSZ[",2,")!(QAMMOVTY=2) S ^UTILITY($J,"QAM CONDITION",QAMD1,QAMDFN)="" ;   *** TRF
 . I (QAMSMPSZ[",3,")!(QAMXREF="AMV3") S ^UTILITY($J,"QAM CONDITION",QAMD1,QAMDFN)="" ;    *** D/C
 . I (QAMSMPSZ[",4,")!(QAMTODAY=QAMSTART) S ^UTILITY($J,"QAM CONDITION",QAMD1,QAMDFN)="" ; *** IN-HOUSE BEGINING
 . I (QAMSMPSZ[",5,")!(QAMTODAY=QAMEND) S ^UTILITY($J,"QAM CONDITION",QAMD1,QAMDFN)="" ;   *** IN-HOUSE ENDING
 . S ^UTILITY($J,"QAM CONDITION",QAMD1,QAMDFN,QAMMOVDT)=QAMMOVS0,FLG=1
 . Q
 Q
EN2 ; *** PARAMETER CODE
21 K DIC,DIR,DIRUT S DIC=743.5,DIC(0)="EMNQZ",DIC("S")="I $P(^QA(743.5,+Y,0),""^"",2)=42"
 S DIC("A")="WARD GROUP: ",DIC("B")=$S($D(^QA(743,QAMD0,"COND",QAMD1,"P1"))#2:$P(^("P1"),"^",2),1:"") K:DIC("B")="" DIC("B")
 S DIR("?",1)="Enter a GROUP name that contains MAS ward locations,",DIR("?")="or press 'RETURN' for all ward locations."
 S QAMPARAM="P1" D EN2^QAMUTL1 I $D(DIRUT) S Y=-1 G Y
 S:Y]"" ^QA(743,QAMD0,"COND",QAMD1,"P1")=+Y_"^"_Y(0,0)
22 K DIR S DIR(0)="LO^1:5^K:X[""."" X",DIR("A")="COUNT SAMPLE SIZE BY",DIR("B")=$S($D(^QA(743,QAMD0,"COND",QAMD1,"P2"))#2:^("P2"),1:"") K:DIR("B")="" DIR("B")
 S DIR("?",1)="Choose one or more of the following:",DIR("?",2)="   1  Admissions",DIR("?",3)="   2  Transfers to (interward)",DIR("?",4)="   3  Discharges",DIR("?",5)="   4  # in-house at beginning of time frame"
 S DIR("?",6)="   5  # in-house at ending of time frame",DIR("?",7)="",DIR("?")="Enter your selections separated by commas, e.g., 1,4"
 S QAMPARAM="P2" D EN3^QAMUTL1 I $D(DIRUT) S Y=-1 G Y
 S:Y]"" ^QA(743,QAMD0,"COND",QAMD1,"P2")=$S($E(Y,$L(Y))=",":$E(Y,1,$L(Y)-1),1:Y)
EXIT K Y
 K QAMPARAM,QAMY
Y Q