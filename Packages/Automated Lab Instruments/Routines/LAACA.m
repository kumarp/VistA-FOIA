LAACA ;SLC/RWF/CJS - 'ACA3' ROUTINE FOR AUTOMATED DATA  ;8/16/90  14:52 ;
 ;;5.2;AUTOMATED LAB INSTRUMENTS;;Sep 27, 1994
 ;CROSS LINK BY IDE = CARD READER DATA, ID = SAMPLE SEQUENCE #
LA1 S LANM=$T(+0),TSK=$O(^LAB(62.4,"C",LANM,0)) Q:TSK<1  S X=^LAB(62.4,TSK,0),U="^"
 Q:'$D(^LA(TSK,"I",0))
 S IDT=0 K LRTOP D ^LASET Q:'TSK  S (PID,PSPEC,TP)=0,SS="CH",X="TRAP^"_LANM,@^%ZOSF("TRAP")
LA2 S TOUT=0,BAD=0 F A=1 D IN S Y(1)=IN D QC G QUIT:TOUT
 I BAD G LA2
 K TV
 S ACA=+$E(Y(1),31,32),TC=$S($D(^LAB(62.4,TSK,3,ACA,0)):^(1),1:"TV(1,1)")
 S V=$S($E(Y(1),42)]" ":+$E(Y(1),42,49),1:+$E(Y(1),43,49)),DIL=+$E(Y(1),18)_$E(Y(1),19) S:DIL>1 V=V*DIL
 S @TC=$S(TC["99,":"TEST NOT FOUND "_$E(Y(1),34,37)_" ",1:"")_V
 S IDE=+$E(Y(1),21,29),ID=+$E(Y(1),6,9),CUP=ID,TRAY=1,SPEC=$P(^LAB(69.9,1,1),U,3),RT=NOW
LA3 I (IDE'=PID)!(PSPEC'=SPEC) X LAGEN S PID=IDE,PSPEC=SPEC
 F I=0:0 S I=$O(TV(I)) Q:I<1  D LA4
 G LA2
LA4 S R=$S($D(TV(I,1)):TV(I,1),1:"") S:R]"" ^LAH(LWL,1,ISQN,I)=R
 Q
QC ;QC TESTING HERE; S BAD=1 IF DONT STORE
 S:$E(Y(1),51,52)]"  " BAD=1 S:$E(Y(1),17)]" " BAD=1
 S:$L(Y(1))'=60 BAD=1 Q
IN S CNT=^LA(TSK,"I",0)+1 IF '$D(^(CNT)) S TOUT=TOUT+1 Q:TOUT>9  H 5 G IN
 S ^LA(TSK,"I",0)=CNT,IN=^(CNT),TOUT=0
 S:IN["~" CTRL=$P(IN,"~",2),IN=$P(IN,"~",1)
 Q
OUT S CNT=^LA(TSK,"O")+1,^("O")=CNT,^("O",CNT)=OUT
 LOCK ^LA("Q") S Q=^LA("Q")+1,^("Q")=Q,^("Q",Q)=TSK LOCK
 Q
QUIT LOCK ^LA(TSK) H 1 K ^LA(TSK),^LA("LOCK",TSK),^TMP($J),^TMP("LA",$J) S:$D(ZTQUEUED) ZTREQ="@"
 Q
TRAP D ^LABERR S T=TSK D SET^LAB G @("LA2^"_LANM) ;ERROR TRAP
