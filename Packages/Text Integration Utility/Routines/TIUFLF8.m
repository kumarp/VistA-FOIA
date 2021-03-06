TIUFLF8 ; SLC/MAM - Library; File 8925.1 Related: SELTYPE(FILEDA,DEFLT), EDOWN(DA,XFLG) ;7/1/97  20:39
 ;;1.0;TEXT INTEGRATION UTILITIES;**2**;Jun 20, 1997
 ;
SELTYPE(FILEDA,DEFLT) ; Function Prompts for Type, Returns Selected Type: CL, DC, TL, CO, O, [N for NONE], "" if nothing selected or @ entered.
 ; Optional FILEDA: if not received, include 'NONE' as selectable Type.
 ; Optional DEFLT = 'CLASS', 'TITLE' etc.
 ; FILEDA, DEFLT are needed when editing Type; NOT needed when selecting Type for SORT.  Assume for SORT if FILEDA is not received.
 ; If used for editing Type, requires TIUFTLST as set in TYPELIST
 N DIR,X,Y,TYPE,CHOICE,TMP
 K DIRUT,DUOUT,DIROUT
 S FILEDA=+$G(FILEDA)
 S DIR(0)=$S(TIUFXNOD["Sort"!(TIUFXNOD["Change View"):"FA0^1:14",1:"FA^1:9"),(DIR("?"),DIR("??"))="^D TYPE^TIUFXHLX"
 I $D(DEFLT) S DIR("B")=DEFLT
 S CHOICE=""
 I FILEDA F TYPE="CL","DC","DOC","CO","O" D
 . I TIUFTLST[(U_TYPE_U) S:TYPE="DOC" TYPE="TL" S CHOICE=CHOICE_$S(CHOICE'="":"/"_TYPE,1:TYPE)
 I 'FILEDA S CHOICE="CL/DC/TL/CO/O/N"
 S CHOICE="("_CHOICE_")"
 S DIR("A")=$S('FILEDA:"Select TYPE",1:"TYPE")_": "_CHOICE_": "
 D ^DIR I $D(DTOUT)!$D(DUOUT) S TYPE="" G SELTX
 S TYPE=$$UPPER^TIULS(Y)
 D
 . I $E(TYPE,1,2)="CL","CLASS"[TYPE W:(TYPE'="CLASS") "  CLASS" S TYPE="CL" Q
 . I TYPE="DC" W "  DOCUMENT CLASS" Q
 . I $E(TYPE,1,2)="DO","DOCUMENT CLASS"[TYPE W:(TYPE'="DOCUMENT CLASS") "  DOCUMENT CLASS" S TYPE="DC" Q
 . I TYPE="TL" W "  TITLE" Q
 . I $E(TYPE,1,2)="TI","TITLE"[TYPE W:(TYPE'="TITLE") "  TITLE" S TYPE="TL" Q
 . I $E(TYPE,1,2)="CO","COMPONENT"[TYPE W:(TYPE'="COMPONENT") "  COMPONENT" S TYPE="CO" Q
 . I TYPE="O" W "  OBJECT" Q
 . I $E(TYPE,1,2)="OB","OBJECT"[TYPE W:(TYPE'="OBJECT") "  OBJECT" S TYPE="O" Q
 . I 'FILEDA,$E(TYPE)="N","NONE"[TYPE W:(TYPE'="NONE") "  NONE" S TYPE="NONE" Q
 . S TYPE=""
 I FILEDA D
 . S TMP=TYPE I TMP="TL" S TMP="DOC"
 . I TMP'="",TIUFTLST'[(U_TMP_U) S TYPE="" ; User entered something not permitted.
SELTX Q TYPE
 ;
EDOWN(DA,XFLG) ; User edit Owner.
 ; Returns XFLG=1 if user ^exited, else as received.
 N DR,DIE,X,Y,NODE0,POWNER,COWNER
 D GET(DA,.NODE0,.POWNER,.COWNER)
 D FULL^VALM1 S TIUFFULL=1,DIE=8925.1 K DUOUT
 I POWNER,'COWNER D OWNPERS(DA,.NODE0,.POWNER,.COWNER) G:$D(DTOUT)!$D(DUOUT) EDOWX D:'POWNER OWNCLAS(DA,.NODE0,.POWNER,.COWNER) G EDOWX
 I COWNER,'POWNER D OWNCLAS(DA,.NODE0,.POWNER,.COWNER) G:$D(DTOUT)!$D(DUOUT) EDOWX D:'COWNER OWNPERS(DA,.NODE0,.POWNER,.COWNER) G EDOWX
 I 'POWNER,'COWNER D OWNCLAS(DA,.NODE0,.POWNER,.COWNER) G:$D(DTOUT)!$D(DUOUT) EDOWX D:'COWNER OWNPERS(DA,.NODE0,.POWNER,.COWNER) G EDOWX
 I POWNER,COWNER D OWNCLAS(DA,.NODE0,.POWNER,.COWNER) G:$D(DTOUT)!$D(DUOUT) EDOWX D:COWNER OWNPERS(DA,.NODE0,.POWNER,.COWNER) G EDOWX
EDOWX S:$D(DUOUT)!$D(DTOUT) XFLG=1
 D OWNCHEC(DA)
 Q
 ;
OWNCHEC(DA) ; Check for no owners, both owners, stuff personal owner if problem
 N NODE0,POWNER,COWNER,DR,DIE,X,Y
 D GET(DA,.NODE0,.POWNER,.COWNER) S DIE=8925.1
 I 'POWNER,'COWNER W !!,"Since Entry has no Owner, you have been made the Personal Owner.",!! D:'$D(DTOUT) PAUSE^TIUFXHLX S DR=".05////^S X=DUZ" D ^DIE
 I POWNER,COWNER W !!,"Since Entry has both Personal and Class Owners, Class Owner has been deleted",!,"and you have been made the Personal Owner.",!! D:'$D(DTOUT) PAUSE^TIUFXHLX S DR=".05////^S X=DUZ;.06///@" D ^DIE
 Q
 ;
GET(DA,NODE0,POWNER,COWNER) ; Get Owner data
 S NODE0=^TIU(8925.1,DA,0),POWNER=$P(NODE0,U,5),COWNER=$P(NODE0,U,6)
 Q
 ;
OWNCLAS(FILEDA,NODE0,POWNER,COWNER) ; Edit Owner Class
 N DIR,X,Y,ANS,DIE,DR,DA
 I 'COWNER,$G(^TMP("TIUF",$J,"CLPAC")) S DIR("B")="CLINICAL COORDINATOR"
 S DA=FILEDA
 S DIR(0)="8925.1,.06O",DIE=8925.1 D ^DIR I $D(DTOUT)!$D(DUOUT) Q
 S:X="@" Y=X S:Y Y=+Y S ANS=Y ; Y was returned like 17^CLINICAL COORDINATOR
 S DR=".06////^S X=ANS" D ^DIE
 D GET(FILEDA,.NODE0,.POWNER,.COWNER)
 Q
 ;
OWNPERS(FILEDA,NODE0,POWNER,COWNER) ; Edit Personal Owner
 N DIR,X,Y,ANS,DIE,DR
 S DA=FILEDA,DIR(0)="8925.1,.05O",DIE=8925.1 D ^DIR I $D(DTOUT)!$D(DUOUT) Q
 S:X="@" Y=X S:Y Y=+Y S ANS=Y
 S DR=".05////^S X=ANS" D ^DIE
 D GET(FILEDA,.NODE0,.POWNER,.COWNER)
 Q
 ;
