unit uPSI_Funktionen_Beleg;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

}
interface
 

 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_Funktionen_Beleg = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TRegelErgebnis(CL: TPSPascalCompiler);
procedure SIRegister_Funktionen_Beleg(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TRegelErgebnis(CL: TPSRuntimeClassImporter);
procedure RIRegister_Funktionen_Beleg_Routines(S: TPSExec);

procedure Register;

implementation


uses
   IB_Components
  ,IB_Access
  ,IBExportTable
  ,anfix32
  ,globals
  ,gplists
  ,Funktionen.Beleg
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Funktionen_Beleg]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TRegelErgebnis(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TRegelErgebnis') do
  with CL.AddClassN(CL.FindClass('TObject'),'TRegelErgebnis') do
  begin
    RegisterProperty('gewicht', 'integer', iptrw);
    RegisterProperty('OUT_PERSON_R', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Funktionen_Beleg(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('eSuchSubs', '( eSS_Titel, eSS_Numero, eSS_PaperColor, eSS_Verlag'
   +', eSS_Serie, eSS_Komponist, eSS_Arranger, eSS_Preis, eSS_Schwer, eSS_Land,'
   +' eSS_Menge, eSS_Lager, eSS_VersendeTag, eSS_Rang, eSS_MengeProbe, eSS_Meng'
   +'eDemo, eSS_VerlagNo, eSS_Count )');
// CL.AddConstantN('sAugesetzteBelege','TgpIntegerList').SetString());
 CL.AddDelphiFunction('Function e_r_sqlArtikelWhere( AUSGABEART_R, ARTIKEL_R : integer; TableName : string) : string');
 CL.AddDelphiFunction('Function e_r_Artikel( AUSGABEART_R, ARTIKEL_R : integer) : string');
 CL.AddDelphiFunction('Procedure e_r_ArtikelSortieren( RIDS : TList)');
 CL.AddDelphiFunction('Function e_r_ArtikelLink( ARTIKEL_R : integer) : string');
 CL.AddDelphiFunction('Function ResolveSQL( VarName : ShortString) : ShortString');
 CL.AddDelphiFunction('Procedure e_x_dereference( dependencies : TStringList; fromref : string; toref : string)');
 CL.AddDelphiFunction('Procedure e_x_dereference2( dependencies : string; fromref : string; toref : string);');
 CL.AddDelphiFunction('Function e_r_ErwarteteMenge( AUSGABEART_R, ARTIKEL_R : integer; sDetails : TStringList) : integer');
 CL.AddDelphiFunction('Function e_r_AgentMenge( AUSGABEART_R, ARTIKEL_R : integer) : integer');
 CL.AddDelphiFunction('Function e_r_OffeneMenge( AUSGABEART_R, ARTIKEL_R : integer) : integer');
 CL.AddDelphiFunction('Function e_r_UnbestellteMenge( AUSGABEART_R, ARTIKEL_R : integer) : integer');
 CL.AddDelphiFunction('Function e_r_VorschlagMenge( AUSGABEART_R, ARTIKEL_R : integer) : integer');
 CL.AddDelphiFunction('Function e_r_Localize( RID, LAND_R : integer) : string');
 CL.AddDelphiFunction('Function e_r_Localize2( RID, LANGUAGE : integer) : string');
 CL.AddDelphiFunction('Function e_r_text( RID : integer; LAND_R : integer) : TStringList');
 CL.AddDelphiFunction('Function e_w_Stempel( STEMPEL_R : integer) : integer');
 CL.AddDelphiFunction('Function e_r_Bearbeiter( BEARBEITER_R : integer) : string');
 CL.AddDelphiFunction('Function e_r_UngelieferteMengeUeberBedarf( AUSGABEART_R, ARTIKEL_R : integer) : integer');
 CL.AddDelphiFunction('Function e_r_MindestMenge( AUSGABEART_R, ARTIKEL_R : integer) : integer');
 CL.AddDelphiFunction('Procedure e_w_MehrBedarfsAnzeige( AUSGABEART_R, ARTIKEL_R, POSTEN_R, MENGE : integer; Motivation : integer)');
 CL.AddDelphiFunction('Procedure e_w_MinderBedarfsAnzeige( AUSGABEART_R, ARTIKEL_R, POSTEN_R, MENGE : integer)');
 CL.AddDelphiFunction('Function e_w_SetFolge( AUSGABEART_R, ARTIKEL_R : integer) : integer');
 CL.AddDelphiFunction('Function e_w_Wareneingang( AUSGABEART_R, ARTIKEL_R, MENGE : integer) : integer');
 CL.AddDelphiFunction('Function e_r_ZahlungText( ZAHLUNGTYP_R : integer; PERSON_R : integer; MoreInfo : TStringList) : string');
 CL.AddDelphiFunction('Function e_r_ZahlungRID( PERSON_R : integer) : integer');
 CL.AddDelphiFunction('Function e_r_ZahlungFrist( PERSON_R : integer) : integer');
 CL.AddDelphiFunction('Function e_r_ZahlungBezeichnung( PERSON_R : integer) : string');
 CL.AddDelphiFunction('Function e_r_Versender( BELEG_R : integer; TEILLIEFERUNG : integer) : string');
 CL.AddDelphiFunction('Function e_r_PackformGewicht( BELEG_R : integer) : integer');
 CL.AddDelphiFunction('Function e_r_VERLAG_R_fromVerlag( Verlag : string) : integer');
 CL.AddDelphiFunction('Function e_r_Verlag( VERLAG_R : integer) : string');
 CL.AddDelphiFunction('Function e_r_Lieferant( ARTIKEL_R, MENGE : integer) : integer');
 CL.AddDelphiFunction('Procedure e_d_Belege');
 CL.AddDelphiFunction('Function e_w_BestellBeleg( PERSON_R : integer) : integer');
 CL.AddDelphiFunction('Function e_w_JoinBeleg( BELEG_R_FROM, BELEG_R_TO : integer) : integer');
 CL.AddDelphiFunction('Function e_w_JoinPerson( PERSON_R_FROM, PERSON_R_TO : integer) : integer');
 CL.AddDelphiFunction('Procedure e_w_ensurePersonPWD( PERSON_R : integer)');
 CL.AddDelphiFunction('Function e_w_MoveBeleg( BELEG_R_FROM, PERSON_R_TO : integer) : integer');
 CL.AddDelphiFunction('Function e_w_CopyBeleg( BELEG_R_FROM, PERSON_R_TO : integer; sTexte : TStringList) : integer');
 CL.AddDelphiFunction('Procedure e_w_MergeBeleg( BELEG_R_FROM, BELEG_R_TO : integer; sTexte : TStringList)');
 CL.AddDelphiFunction('Function e_r_MengenAusgabe( MENGE, EINHEIT_R : integer; FormatStr : string) : string');
 CL.AddDelphiFunction('Function e_r_EinzelPreisAusgabe( PREIS : double; EINHEIT_R : integer) : string');
 CL.AddDelphiFunction('Function e_r_PostenPreis( EinzelPreis : double; Anz, EINHEIT_R : integer) : double');
 CL.AddDelphiFunction('Function e_c_Rabatt( PREIS, Rabatt : double) : double');
 CL.AddDelphiFunction('Procedure e_r_PostenInfo( IBQ : TIB_DataSet; NurGeliefertes : boolean; EinzelpreisNetto : boolean; var _Anz, _AnzAuftrag, _AnzGeliefert, _AnzStorniert, _AnzAgent : integer; var _Rabatt, _EinzelPreis, _MwStSatz : double)');
 CL.AddDelphiFunction('Function e_w_AusgabeBeleg( BELEG_R : integer; NurGeliefertes : boolean; AlsLieferschein : boolean) : TStringList');
 CL.AddDelphiFunction('Procedure e_w_DruckBeleg( BELEG_R : integer)');
 CL.AddDelphiFunction('Function e_r_Ausgabeart( AUSGABEART_R : integer) : string');
 CL.AddDelphiFunction('Function e_r_Menge( EINHEIT_R, AUSGABEART_R, ARTIKEL_R : integer) : integer');
 CL.AddDelphiFunction('Function e_r_PreisTabelle( PREIS_R : integer) : double');
 CL.AddDelphiFunction('Function e_r_PreisValid( p : double) : boolean');
 CL.AddDelphiFunction('Function e_r_Preis( EINHEIT_R, AUSGABEART_R, ARTIKEL_R : integer; var Satz : double; var Netto : boolean; var NettoWieBrutto : boolean) : double');
 CL.AddDelphiFunction('Function e_r_PreisText( AUSGABEART_R, ARTIKEL_R : integer) : string');
 CL.AddDelphiFunction('Function e_r_PreisBrutto( AUSGABEART_R, ARTIKEL_R : integer) : double');
 CL.AddDelphiFunction('Function e_r_PreisNativ( AUSGABEART_R, ARTIKEL_R : integer) : double');
 CL.AddDelphiFunction('Function e_r_EndPreis( PERSON_R, AUSGABEART_R, ARTIKEL_R : integer) : double');
 CL.AddDelphiFunction('Function e_r_PreisNetto( AUSGABEART_R, ARTIKEL_R : integer) : double');
 CL.AddDelphiFunction('Function e_r_PaketPreis( AUSGABEART_R, ARTIKEL_R : integer) : double');
 CL.AddDelphiFunction('Function e_r_Umsatz( POSTEN_R : integer) : double');
 CL.AddDelphiFunction('Function e_r_USD( ARTIKEL_R : integer) : double');
 CL.AddDelphiFunction('Function e_r_RabattCode( PERSON_R : integer) : string');
 CL.AddDelphiFunction('Function e_r_RabattFaehig( PERSON_R : integer) : boolean');
 CL.AddDelphiFunction('Function e_r_Rabatt( ARTIKEL_R, PERSON_R : integer; var Netto : boolean; var NettoWieBrutto : boolean) : double');
 CL.AddDelphiFunction('Function e_r_VerlagsRabatt( VERLAG_R, PERSON_R : integer) : double');
 CL.AddDelphiFunction('Function e_r_ekRabatt( ARTIKEL_R : integer) : double');
 CL.AddDelphiFunction('Function e_r_ObtainISOfromRID( LAND_R : integer) : string');
 CL.AddDelphiFunction('Function e_r_MwSt( AUSGABEART_R, ARTIKEL_R : integer) : double');
 CL.AddDelphiFunction('Function e_r_MwSt2( SORTIMENT_R : integer) : double;');
 CL.AddDelphiFunction('Function e_r_Prozent( nSteuer : integer; mDatum : TAnfixDate) : double');
 CL.AddDelphiFunction('Function e_r_Satz( Prozent : double; mDatum : TAnfixDate) : integer');
 CL.AddDelphiFunction('Function e_w_EinLagern( ARTIKEL_R : integer) : integer');
 CL.AddDelphiFunction('Procedure e_w_Zwischenlagern( BELEG_R : integer; LAGER_R : integer)');
 CL.AddDelphiFunction('Function e_r_LagerVorschlag( SORTIMENT_R : integer; PERSON_R : integer) : integer');
 CL.AddDelphiFunction('Function e_r_LagerDiversitaet( LAGER_R : integer) : integer');
 CL.AddDelphiFunction('Function e_r_IsUebergangsfach( LAGER_R : integer) : boolean');
 CL.AddDelphiFunction('Function e_r_Uebergangsfach_VERLAG_R : integer');
 CL.AddDelphiFunction('Function e_r_Lager( SORTIMENT_R : integer) : boolean');
 CL.AddDelphiFunction('Function e_r_FreiesLager_VERLAG_R : integer');
 CL.AddDelphiFunction('Function e_r_LagerPlatzNameFromLAGER_R( LAGER_R : integer) : string');
 CL.AddDelphiFunction('Function e_r_UebergangsfachFromPerson( PERSON_R : integer) : integer');
 CL.AddDelphiFunction('Procedure e_w_LagerFreigeben');
 CL.AddDelphiFunction('Function e_w_Menge( EINHEIT_R, AUSGABEART_R, ARTIKEL_R, MENGE : integer; BELEG_R : integer; POSTEN_R : integer) : integer');
 CL.AddDelphiFunction('Function e_w_NeuerMahnlauf( ForceNew : boolean) : boolean');
 CL.AddDelphiFunction('Function e_w_KontoInfo( PERSON_R : integer; sOptionen : TStringList) : TStringList');
 CL.AddDelphiFunction('Function e_r_BestellInfo( PERSON_R : integer) : integer');
 CL.AddDelphiFunction('Procedure e_w_WarenkorbLeeren( PERSON_R : integer)');
 CL.AddDelphiFunction('Function e_w_WarenkorbEinfuegen( BELEG_R : integer) : integer');
 CL.AddDelphiFunction('Function e_w_buchen( BELEG_R, PERSON_R : TDOM_Reference) : integer');
 CL.AddDelphiFunction('Function e_r_Stempel( PERSON_R, BELEG_R : integer) : integer');
 CL.AddDelphiFunction('Function e_r_RechnungsNummerAnzahlDerStellen : integer');
 CL.AddDelphiFunction('Function e_r_Rechnungen( BELEG_R : integer) : TStringList');
 CL.AddDelphiFunction('Function e_r_Rechnung( BELEG_R, TEILLIEFERUNG : integer) : string');
 CL.AddDelphiFunction('Function e_w_Rechnung( BELEG_R : integer) : integer');
 CL.AddDelphiFunction('Function e_r_Versandfertig( ib_q : TIB_DataSet) : boolean');
 CL.AddDelphiFunction('Function e_r_Versandfaehig( ib_q : TIB_DataSet) : boolean');
 CL.AddDelphiFunction('Function e_w_BelegVersand( BELEG_R : integer; Summe : double; gewicht : integer) : integer');
 CL.AddDelphiFunction('Function e_w_BelegDrittlandAusfuhr( BELEG_R : integer) : boolean');
 CL.AddDelphiFunction('Function e_r_StandardVersender : integer');
 CL.AddDelphiFunction('Function e_r_LeerGewicht( PACKFORM_R : integer) : integer');
 CL.AddDelphiFunction('Function e_r_Gewicht( AUSGABEART_R, ARTIKEL_R : integer) : integer');
 CL.AddDelphiFunction('Function e_r_ArtikelVersendetag( AUSGABEART_R, ARTIKEL_R : integer) : integer');
 CL.AddDelphiFunction('Function e_r_Lieferzeit( AUSGABEART_R, ARTIKEL_R : integer) : integer');
 CL.AddDelphiFunction('Function e_w_ArtikelNeu( SORTIMENT_R : integer) : integer');
 CL.AddDelphiFunction('Function e_w_Artikel( EINHEIT_R, AUSGABEART_R, ARTIKEL_R : integer) : boolean');
 CL.AddDelphiFunction('Function e_w_PersonNeu : integer');
 CL.AddDelphiFunction('Function e_w_SetStandardVersandData( qVERSAND : TIB_Query) : integer');
 CL.AddDelphiFunction('Function e_r_VersandKosten( BELEG_R : integer) : integer');
 CL.AddDelphiFunction('Function e_r_PortoFreiAbBrutto( PERSON_R : integer) : double');
 CL.AddDelphiFunction('Function e_r_IsVersandKosten( ARTIKEL_R : integer) : boolean');
 CL.AddDelphiFunction('Function e_w_VersandKostenClear( BELEG_R : integer) : integer');
 CL.AddDelphiFunction('Function e_r_KontoInhaber( PERSON_R : integer) : string');
 CL.AddDelphiFunction('Function e_r_ArtikelDokument( AUSGABEART_R, ARTIKEL_R, MEDIUM_R : integer) : integer');
 CL.AddDelphiFunction('Function e_r_ArtikelBild( AUSGABEART_R, ARTIKEL_R : integer; DoFileCheck : boolean) : string');
 CL.AddDelphiFunction('Function e_r_ArtikelVorschaubild( AUSGABEART_R, ARTIKEL_R : integer; DoFileCheck : boolean) : string');
 CL.AddDelphiFunction('Function e_r_ArtikelMusik( AUSGABEART_R, ARTIKEL_R : integer) : string');
 CL.AddDelphiFunction('Function e_r_ArtikelKontext( AUSGABEART_R, ARTIKEL_R : integer) : string');
 CL.AddDelphiFunction('Function e_r_Aktion( Name : String; BELEG_R : integer) : boolean');
 CL.AddDelphiFunction('Function e_r_BelegFName( PERSON_R : integer; BELEG_R : integer; TEILLIEFERUNG : integer) : string');
 CL.AddDelphiFunction('Function e_r_BelegInfo( BELEG_R : integer; TEILLIEFERUNG : integer) : TStringList');
 CL.AddDelphiFunction('Function e_r_BelegeAusgeglichen( BELEG_R : integer) : boolean');
 CL.AddDelphiFunction('Function e_r_BelegSaldo( BELEG_R : integer; TEILLIEFERUNG : integer) : double');
 CL.AddDelphiFunction('Function e_w_BerechneBeleg( BELEG_R : integer; NurGeliefertes : boolean) : TStringList');
 CL.AddDelphiFunction('Function e_w_VertragBuchen( VERTRAG_R : integer; sSettings : TStringList) : TStringList');
 CL.AddDelphiFunction('Function e_w_VertragBuchen2( VERTRAG_R : integer; Erzwingen : boolean) : TStringList;');
 CL.AddDelphiFunction('Function e_w_VertragBuchen3 : TStringList;');
 CL.AddDelphiFunction('Function e_r_VertragBuchen( VERTRAG_R : integer) : boolean');
 CL.AddDelphiFunction('Function e_w_BelegBuchen( BELEG_R : integer; LabelDatensatz : boolean) : string');
 CL.AddDelphiFunction('Function e_w_BelegNeu( PERSON_R : integer) : integer');
 CL.AddDelphiFunction('Function e_w_BelegNeuAusWarenkorb( PERSON_R : integer) : integer');
 CL.AddDelphiFunction('Function e_w_BelegNeuAusKasse( EREIGNIS_R : integer) : integer');
 CL.AddDelphiFunction('Function e_r_LohnKalkulation( Betrag : double; Datum : TAnfixDate) : string');
 CL.AddDelphiFunction('Function e_r_LandRID( ISO : string) : integer');
 CL.AddDelphiFunction('Function e_r_LohnFName( RID : integer) : string');
 CL.AddDelphiFunction('Function e_r_LadeParameter : TStringList');
 CL.AddDelphiFunction('Procedure e_r_Anschrift( PERSON_R : integer; sl : TStringList; Prefix : string)');
 CL.AddDelphiFunction('Procedure e_r_Bank( PERSON_R : integer; sl : TStringList; Prefix : string)');
 CL.AddDelphiFunction('Function e_r_Adressat( PERSON_R : integer) : TStringList');
 CL.AddDelphiFunction('Function e_r_Ort( PERSON_R : integer) : string');
 CL.AddDelphiFunction('Function e_r_Ort2( ib_q : TIB_DataSet) : string;');
 CL.AddDelphiFunction('Function e_r_Name( ib_q : TIB_DataSet) : string');
 CL.AddDelphiFunction('Function e_r_Name2( PERSON_R : integer) : string;');
 CL.AddDelphiFunction('Function e_r_land( ib_q : TIB_DataSet) : string');
 CL.AddDelphiFunction('Function e_r_PLZlength( ib_q : TIB_DataSet) : integer');
 CL.AddDelphiFunction('Function e_r_plz( ib_q : TIB_DataSet; PLZlength : integer) : string');
 CL.AddDelphiFunction('Function e_r_fax( ib_q : TIB_DataSet) : string');
 CL.AddDelphiFunction('Function e_r_fax2( PERSON_R : integer) : string;');
 CL.AddDelphiFunction('Function e_r_telefon( ib_q : TIB_DataSet) : string');
 CL.AddDelphiFunction('Procedure e_w_preDeletePosten( POSTEN_R : integer)');
 CL.AddDelphiFunction('Procedure e_w_preDeleteBPosten( BPOSTEN_R : integer)');
 CL.AddDelphiFunction('Procedure e_w_preDeleteBeleg( BELEG_R : integer)');
 CL.AddDelphiFunction('Procedure e_w_preDeleteBBeleg( BBELEG_R : integer)');
 CL.AddDelphiFunction('Procedure e_w_preDeleteArtikel( ARTIKEL_R : integer)');
 CL.AddDelphiFunction('Procedure e_w_preDeletePerson( PERSON_R : integer)');
 CL.AddDelphiFunction('Procedure e_w_preDeleteVerlag( VERLAG_R : integer)');
 CL.AddDelphiFunction('Procedure e_w_preDeleteTier( TIER_R : integer)');
 CL.AddDelphiFunction('Function e_w_BelegStatusBuchen( BELEG_R : integer) : boolean');
 CL.AddDelphiFunction('Function e_w_BBelegStatusBuchen( BBELEG_R : integer) : boolean');
 CL.AddDelphiFunction('Procedure e_w_SetPostenData( ARTIKEL_R, PERSON_R : integer; qPosten : TIB_Query)');
 CL.AddDelphiFunction('Procedure e_w_SetPostenPreis( EINHEIT_R, AUSGABEART_R, ARTIKEL_R, PERSON_R : integer; qPosten : TIB_Query)');
 CL.AddDelphiFunction('Procedure e_w_InvalidateCaches');
 CL.AddDelphiFunction('Function q_r_PersonWarnung( PERSON_R : integer) : TStringList');
 CL.AddDelphiFunction('Procedure e_f_PersonInfo( PERSON_R : integer; AusgabePfad : string)');
 CL.AddDelphiFunction('Function t_r_Beleg( BELEG_R : integer) : boolean');
 CL.AddDelphiFunction('Function e_r_AuftragNummer( BAUSTELLE_R : integer) : integer');
 CL.AddDelphiFunction('Function e_r_Schritte( AUFTRAG_R : integer) : TStringList');
 CL.AddDelphiFunction('Function e_r_AuftragPlausi( AUFTRAG_R : integer) : string');
 CL.AddDelphiFunction('Function e_r_Sparte( Art : string) : string');
 CL.AddDelphiFunction('Procedure e_w_Ticket( sContext : string)');
 CL.AddDelphiFunction('Procedure e_w_Ticket2( slContext : TStringList);');
  SIRegister_TRegelErgebnis(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TRegelErgebnisOUT_PERSON_R_W(Self: TRegelErgebnis; const T: integer);
Begin Self.OUT_PERSON_R := T; end;

(*----------------------------------------------------------------------------*)
procedure TRegelErgebnisOUT_PERSON_R_R(Self: TRegelErgebnis; var T: integer);
Begin T := Self.OUT_PERSON_R; end;

(*----------------------------------------------------------------------------*)
procedure TRegelErgebnisgewicht_W(Self: TRegelErgebnis; const T: integer);
Begin Self.gewicht := T; end;

(*----------------------------------------------------------------------------*)
procedure TRegelErgebnisgewicht_R(Self: TRegelErgebnis; var T: integer);
Begin T := Self.gewicht; end;

(*----------------------------------------------------------------------------*)
Procedure e_w_Ticket2_P( slContext : TStringList);
Begin e_w_Ticket(slContext); END;

(*----------------------------------------------------------------------------*)
Function e_r_fax2_P( PERSON_R : integer) : string;
Begin Result := e_r_fax(PERSON_R); END;

(*----------------------------------------------------------------------------*)
Function e_r_Name2_P( PERSON_R : integer) : string;
Begin Result := e_r_Name(PERSON_R); END;

(*----------------------------------------------------------------------------*)
Function e_r_Ort2_P( ib_q : TIB_DataSet) : string;
Begin Result := e_r_Ort(ib_q); END;

(*----------------------------------------------------------------------------*)
Function e_w_VertragBuchen3_P : TStringList;
Begin Result := e_w_VertragBuchen; END;

(*----------------------------------------------------------------------------*)
Function e_w_VertragBuchen2_P( VERTRAG_R : integer; Erzwingen : boolean) : TStringList;
Begin Result := e_w_VertragBuchen(VERTRAG_R, Erzwingen); END;

(*----------------------------------------------------------------------------*)
Function e_r_MwSt2_P( SORTIMENT_R : integer) : double;
Begin Result := e_r_MwSt(SORTIMENT_R); END;

(*----------------------------------------------------------------------------*)
Procedure e_x_dereference2_P( dependencies : string; fromref : string; toref : string);
Begin e_x_dereference(dependencies, fromref, toref); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRegelErgebnis(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRegelErgebnis) do
  begin
    RegisterPropertyHelper(@TRegelErgebnisgewicht_R,@TRegelErgebnisgewicht_W,'gewicht');
    RegisterPropertyHelper(@TRegelErgebnisOUT_PERSON_R_R,@TRegelErgebnisOUT_PERSON_R_W,'OUT_PERSON_R');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Funktionen_Beleg_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@e_r_sqlArtikelWhere, 'e_r_sqlArtikelWhere', cdRegister);
 S.RegisterDelphiFunction(@e_r_Artikel, 'e_r_Artikel', cdRegister);
 S.RegisterDelphiFunction(@e_r_ArtikelSortieren, 'e_r_ArtikelSortieren', cdRegister);
 S.RegisterDelphiFunction(@e_r_ArtikelLink, 'e_r_ArtikelLink', cdRegister);
 S.RegisterDelphiFunction(@ResolveSQL, 'ResolveSQL', cdRegister);
 S.RegisterDelphiFunction(@e_x_dereference, 'e_x_dereference', cdRegister);
 S.RegisterDelphiFunction(@e_x_dereference2_P, 'e_x_dereference2', cdRegister);
 S.RegisterDelphiFunction(@e_r_ErwarteteMenge, 'e_r_ErwarteteMenge', cdRegister);
 S.RegisterDelphiFunction(@e_r_AgentMenge, 'e_r_AgentMenge', cdRegister);
 S.RegisterDelphiFunction(@e_r_OffeneMenge, 'e_r_OffeneMenge', cdRegister);
 S.RegisterDelphiFunction(@e_r_UnbestellteMenge, 'e_r_UnbestellteMenge', cdRegister);
 S.RegisterDelphiFunction(@e_r_VorschlagMenge, 'e_r_VorschlagMenge', cdRegister);
 S.RegisterDelphiFunction(@e_r_Localize, 'e_r_Localize', cdRegister);
 S.RegisterDelphiFunction(@e_r_Localize2, 'e_r_Localize2', cdRegister);
 S.RegisterDelphiFunction(@e_r_text, 'e_r_text', cdRegister);
 S.RegisterDelphiFunction(@e_w_Stempel, 'e_w_Stempel', cdRegister);
 S.RegisterDelphiFunction(@e_r_UngelieferteMengeUeberBedarf, 'e_r_UngelieferteMengeUeberBedarf', cdRegister);
 S.RegisterDelphiFunction(@e_r_MindestMenge, 'e_r_MindestMenge', cdRegister);
 S.RegisterDelphiFunction(@e_w_MehrBedarfsAnzeige, 'e_w_MehrBedarfsAnzeige', cdRegister);
 S.RegisterDelphiFunction(@e_w_MinderBedarfsAnzeige, 'e_w_MinderBedarfsAnzeige', cdRegister);
 S.RegisterDelphiFunction(@e_w_SetFolge, 'e_w_SetFolge', cdRegister);
 S.RegisterDelphiFunction(@e_w_Wareneingang, 'e_w_Wareneingang', cdRegister);
 S.RegisterDelphiFunction(@e_r_ZahlungText, 'e_r_ZahlungText', cdRegister);
 S.RegisterDelphiFunction(@e_r_ZahlungRID, 'e_r_ZahlungRID', cdRegister);
 S.RegisterDelphiFunction(@e_r_ZahlungFrist, 'e_r_ZahlungFrist', cdRegister);
 S.RegisterDelphiFunction(@e_r_ZahlungBezeichnung, 'e_r_ZahlungBezeichnung', cdRegister);
 S.RegisterDelphiFunction(@e_r_Versender, 'e_r_Versender', cdRegister);
 S.RegisterDelphiFunction(@e_r_PackformGewicht, 'e_r_PackformGewicht', cdRegister);
 S.RegisterDelphiFunction(@e_r_VERLAG_R_fromVerlag, 'e_r_VERLAG_R_fromVerlag', cdRegister);
 S.RegisterDelphiFunction(@e_r_Verlag, 'e_r_Verlag', cdRegister);
 S.RegisterDelphiFunction(@e_r_Lieferant, 'e_r_Lieferant', cdRegister);
 S.RegisterDelphiFunction(@e_d_Belege, 'e_d_Belege', cdRegister);
 S.RegisterDelphiFunction(@e_w_BestellBeleg, 'e_w_BestellBeleg', cdRegister);
 S.RegisterDelphiFunction(@e_w_JoinBeleg, 'e_w_JoinBeleg', cdRegister);
 S.RegisterDelphiFunction(@e_w_JoinPerson, 'e_w_JoinPerson', cdRegister);
 S.RegisterDelphiFunction(@e_w_MoveBeleg, 'e_w_MoveBeleg', cdRegister);
 S.RegisterDelphiFunction(@e_w_CopyBeleg, 'e_w_CopyBeleg', cdRegister);
 S.RegisterDelphiFunction(@e_w_MergeBeleg, 'e_w_MergeBeleg', cdRegister);
 S.RegisterDelphiFunction(@e_r_MengenAusgabe, 'e_r_MengenAusgabe', cdRegister);
 S.RegisterDelphiFunction(@e_r_EinzelPreisAusgabe, 'e_r_EinzelPreisAusgabe', cdRegister);
 S.RegisterDelphiFunction(@e_r_PostenPreis, 'e_r_PostenPreis', cdRegister);
 S.RegisterDelphiFunction(@e_c_Rabatt, 'e_c_Rabatt', cdRegister);
 S.RegisterDelphiFunction(@e_r_PostenInfo, 'e_r_PostenInfo', cdRegister);
 S.RegisterDelphiFunction(@e_w_AusgabeBeleg, 'e_w_AusgabeBeleg', cdRegister);
 S.RegisterDelphiFunction(@e_w_DruckBeleg, 'e_w_DruckBeleg', cdRegister);
 S.RegisterDelphiFunction(@e_r_Ausgabeart, 'e_r_Ausgabeart', cdRegister);
 S.RegisterDelphiFunction(@e_r_Menge, 'e_r_Menge', cdRegister);
 S.RegisterDelphiFunction(@e_r_PreisTabelle, 'e_r_PreisTabelle', cdRegister);
 S.RegisterDelphiFunction(@e_r_PreisValid, 'e_r_PreisValid', cdRegister);
 S.RegisterDelphiFunction(@e_r_Preis, 'e_r_Preis', cdRegister);
 S.RegisterDelphiFunction(@e_r_PreisText, 'e_r_PreisText', cdRegister);
 S.RegisterDelphiFunction(@e_r_PreisBrutto, 'e_r_PreisBrutto', cdRegister);
 S.RegisterDelphiFunction(@e_r_PreisNativ, 'e_r_PreisNativ', cdRegister);
 S.RegisterDelphiFunction(@e_r_EndPreis, 'e_r_EndPreis', cdRegister);
 S.RegisterDelphiFunction(@e_r_PreisNetto, 'e_r_PreisNetto', cdRegister);
 S.RegisterDelphiFunction(@e_r_PaketPreis, 'e_r_PaketPreis', cdRegister);
 S.RegisterDelphiFunction(@e_r_Umsatz, 'e_r_Umsatz', cdRegister);
 S.RegisterDelphiFunction(@e_r_USD, 'e_r_USD', cdRegister);
 S.RegisterDelphiFunction(@e_r_RabattCode, 'e_r_RabattCode', cdRegister);
 S.RegisterDelphiFunction(@e_r_RabattFaehig, 'e_r_RabattFaehig', cdRegister);
 S.RegisterDelphiFunction(@e_r_Rabatt, 'e_r_Rabatt', cdRegister);
 S.RegisterDelphiFunction(@e_r_VerlagsRabatt, 'e_r_VerlagsRabatt', cdRegister);
 S.RegisterDelphiFunction(@e_r_ekRabatt, 'e_r_ekRabatt', cdRegister);
 S.RegisterDelphiFunction(@e_r_ObtainISOfromRID, 'e_r_ObtainISOfromRID', cdRegister);
 S.RegisterDelphiFunction(@e_r_MwSt, 'e_r_MwSt', cdRegister);
 S.RegisterDelphiFunction(@e_r_MwSt2_P, 'e_r_MwSt2', cdRegister);
 S.RegisterDelphiFunction(@e_r_Prozent, 'e_r_Prozent', cdRegister);
 S.RegisterDelphiFunction(@e_r_Satz, 'e_r_Satz', cdRegister);
 S.RegisterDelphiFunction(@e_w_EinLagern, 'e_w_EinLagern', cdRegister);
 S.RegisterDelphiFunction(@e_w_Zwischenlagern, 'e_w_Zwischenlagern', cdRegister);
 S.RegisterDelphiFunction(@e_r_LagerVorschlag, 'e_r_LagerVorschlag', cdRegister);
 S.RegisterDelphiFunction(@e_r_LagerDiversitaet, 'e_r_LagerDiversitaet', cdRegister);
 S.RegisterDelphiFunction(@e_r_IsUebergangsfach, 'e_r_IsUebergangsfach', cdRegister);
 S.RegisterDelphiFunction(@e_r_Uebergangsfach_VERLAG_R, 'e_r_Uebergangsfach_VERLAG_R', cdRegister);
 S.RegisterDelphiFunction(@e_r_LagerVorhanden, 'e_r_Lager', cdRegister);
 S.RegisterDelphiFunction(@e_r_FreiesLager_VERLAG_R, 'e_r_FreiesLager_VERLAG_R', cdRegister);
 S.RegisterDelphiFunction(@e_r_LagerPlatzNameFromLAGER_R, 'e_r_LagerPlatzNameFromLAGER_R', cdRegister);
 S.RegisterDelphiFunction(@e_r_UebergangsfachFromPerson, 'e_r_UebergangsfachFromPerson', cdRegister);
 S.RegisterDelphiFunction(@e_w_LagerFreigeben, 'e_w_LagerFreigeben', cdRegister);
 S.RegisterDelphiFunction(@e_w_Menge, 'e_w_Menge', cdRegister);
 S.RegisterDelphiFunction(@e_w_NeuerMahnlauf, 'e_w_NeuerMahnlauf', cdRegister);
 S.RegisterDelphiFunction(@e_w_KontoInfo, 'e_w_KontoInfo', cdRegister);
 S.RegisterDelphiFunction(@e_r_BestellInfo, 'e_r_BestellInfo', cdRegister);
 S.RegisterDelphiFunction(@e_w_WarenkorbLeeren, 'e_w_WarenkorbLeeren', cdRegister);
 S.RegisterDelphiFunction(@e_w_WarenkorbEinfuegen, 'e_w_WarenkorbEinfuegen', cdRegister);
 S.RegisterDelphiFunction(@e_w_buchen, 'e_w_buchen', cdRegister);
 S.RegisterDelphiFunction(@e_r_Stempel, 'e_r_Stempel', cdRegister);
 S.RegisterDelphiFunction(@e_r_RechnungsNummerAnzahlDerStellen, 'e_r_RechnungsNummerAnzahlDerStellen', cdRegister);
 S.RegisterDelphiFunction(@e_r_Rechnungen, 'e_r_Rechnungen', cdRegister);
 S.RegisterDelphiFunction(@e_r_Rechnung, 'e_r_Rechnung', cdRegister);
 S.RegisterDelphiFunction(@e_w_Rechnung, 'e_w_Rechnung', cdRegister);
 S.RegisterDelphiFunction(@e_r_Versandfertig, 'e_r_Versandfertig', cdRegister);
 S.RegisterDelphiFunction(@e_r_Versandfaehig, 'e_r_Versandfaehig', cdRegister);
 S.RegisterDelphiFunction(@e_w_BelegVersand, 'e_w_BelegVersand', cdRegister);
 S.RegisterDelphiFunction(@e_w_BelegDrittlandAusfuhr, 'e_w_BelegDrittlandAusfuhr', cdRegister);
 S.RegisterDelphiFunction(@e_r_StandardVersender, 'e_r_StandardVersender', cdRegister);
 S.RegisterDelphiFunction(@e_r_LeerGewicht, 'e_r_LeerGewicht', cdRegister);
 S.RegisterDelphiFunction(@e_r_Gewicht, 'e_r_Gewicht', cdRegister);
 S.RegisterDelphiFunction(@e_r_ArtikelVersendetag, 'e_r_ArtikelVersendetag', cdRegister);
 S.RegisterDelphiFunction(@e_r_Lieferzeit, 'e_r_Lieferzeit', cdRegister);
 S.RegisterDelphiFunction(@e_w_ArtikelNeu, 'e_w_ArtikelNeu', cdRegister);
 S.RegisterDelphiFunction(@e_w_Artikel, 'e_w_Artikel', cdRegister);
 S.RegisterDelphiFunction(@e_w_PersonNeu, 'e_w_PersonNeu', cdRegister);
 S.RegisterDelphiFunction(@e_w_SetStandardVersandData, 'e_w_SetStandardVersandData', cdRegister);
 S.RegisterDelphiFunction(@e_r_VersandKosten, 'e_r_VersandKosten', cdRegister);
 S.RegisterDelphiFunction(@e_r_PortoFreiAbBrutto, 'e_r_PortoFreiAbBrutto', cdRegister);
 S.RegisterDelphiFunction(@e_r_IsVersandKosten, 'e_r_IsVersandKosten', cdRegister);
 S.RegisterDelphiFunction(@e_w_VersandKostenClear, 'e_w_VersandKostenClear', cdRegister);
 S.RegisterDelphiFunction(@e_r_KontoInhaber, 'e_r_KontoInhaber', cdRegister);
 S.RegisterDelphiFunction(@e_r_ArtikelDokument, 'e_r_ArtikelDokument', cdRegister);
 S.RegisterDelphiFunction(@e_r_ArtikelBild, 'e_r_ArtikelBild', cdRegister);
 S.RegisterDelphiFunction(@e_r_ArtikelVorschaubild, 'e_r_ArtikelVorschaubild', cdRegister);
 S.RegisterDelphiFunction(@e_r_ArtikelMusik, 'e_r_ArtikelMusik', cdRegister);
 S.RegisterDelphiFunction(@e_r_ArtikelKontext, 'e_r_ArtikelKontext', cdRegister);
 S.RegisterDelphiFunction(@e_r_Aktion, 'e_r_Aktion', cdRegister);
 S.RegisterDelphiFunction(@e_r_BelegFName, 'e_r_BelegFName', cdRegister);
 S.RegisterDelphiFunction(@e_r_BelegInfo, 'e_r_BelegInfo', cdRegister);
 S.RegisterDelphiFunction(@e_r_BelegeAusgeglichen, 'e_r_BelegeAusgeglichen', cdRegister);
 S.RegisterDelphiFunction(@e_r_BelegSaldo, 'e_r_BelegSaldo', cdRegister);
 S.RegisterDelphiFunction(@e_w_BerechneBeleg, 'e_w_BerechneBeleg', cdRegister);
 S.RegisterDelphiFunction(@e_w_VertragBuchen, 'e_w_VertragBuchen', cdRegister);
 S.RegisterDelphiFunction(@e_w_VertragBuchen2_P, 'e_w_VertragBuchen2', cdRegister);
 S.RegisterDelphiFunction(@e_w_VertragBuchen3_P, 'e_w_VertragBuchen3', cdRegister);
 S.RegisterDelphiFunction(@e_r_VertragBuchen, 'e_r_VertragBuchen', cdRegister);
 S.RegisterDelphiFunction(@e_w_BelegBuchen, 'e_w_BelegBuchen', cdRegister);
 S.RegisterDelphiFunction(@e_w_BelegNeu, 'e_w_BelegNeu', cdRegister);
 S.RegisterDelphiFunction(@e_w_BelegNeuAusWarenkorb, 'e_w_BelegNeuAusWarenkorb', cdRegister);
 S.RegisterDelphiFunction(@e_w_BelegNeuAusKasse, 'e_w_BelegNeuAusKasse', cdRegister);
 S.RegisterDelphiFunction(@e_r_LohnKalkulation, 'e_r_LohnKalkulation', cdRegister);
 S.RegisterDelphiFunction(@e_r_LandRID, 'e_r_LandRID', cdRegister);
 S.RegisterDelphiFunction(@e_r_LohnFName, 'e_r_LohnFName', cdRegister);
 S.RegisterDelphiFunction(@e_r_LadeParameter, 'e_r_LadeParameter', cdRegister);
 S.RegisterDelphiFunction(@e_r_Anschrift, 'e_r_Anschrift', cdRegister);
 S.RegisterDelphiFunction(@e_r_Bank, 'e_r_Bank', cdRegister);
 S.RegisterDelphiFunction(@e_r_Adressat, 'e_r_Adressat', cdRegister);
 S.RegisterDelphiFunction(@e_r_Ort, 'e_r_Ort', cdRegister);
 S.RegisterDelphiFunction(@e_r_Ort2_P, 'e_r_Ort2', cdRegister);
 S.RegisterDelphiFunction(@e_r_Name, 'e_r_Name', cdRegister);
 S.RegisterDelphiFunction(@e_r_Name2_P, 'e_r_Name2', cdRegister);
 S.RegisterDelphiFunction(@e_r_land, 'e_r_land', cdRegister);
 S.RegisterDelphiFunction(@e_r_PLZlength, 'e_r_PLZlength', cdRegister);
 S.RegisterDelphiFunction(@e_r_plz, 'e_r_plz', cdRegister);
 S.RegisterDelphiFunction(@e_r_fax, 'e_r_fax', cdRegister);
 S.RegisterDelphiFunction(@e_r_fax2_P, 'e_r_fax2', cdRegister);
 S.RegisterDelphiFunction(@e_r_telefon, 'e_r_telefon', cdRegister);
 S.RegisterDelphiFunction(@e_w_preDeletePosten, 'e_w_preDeletePosten', cdRegister);
 S.RegisterDelphiFunction(@e_w_preDeleteBPosten, 'e_w_preDeleteBPosten', cdRegister);
 S.RegisterDelphiFunction(@e_w_preDeleteBeleg, 'e_w_preDeleteBeleg', cdRegister);
 S.RegisterDelphiFunction(@e_w_preDeleteBBeleg, 'e_w_preDeleteBBeleg', cdRegister);
 S.RegisterDelphiFunction(@e_w_preDeleteArtikel, 'e_w_preDeleteArtikel', cdRegister);
 S.RegisterDelphiFunction(@e_w_preDeletePerson, 'e_w_preDeletePerson', cdRegister);
 S.RegisterDelphiFunction(@e_w_preDeleteVerlag, 'e_w_preDeleteVerlag', cdRegister);
 S.RegisterDelphiFunction(@e_w_preDeleteTier, 'e_w_preDeleteTier', cdRegister);
 S.RegisterDelphiFunction(@e_w_BelegStatusBuchen, 'e_w_BelegStatusBuchen', cdRegister);
 S.RegisterDelphiFunction(@e_w_BBelegStatusBuchen, 'e_w_BBelegStatusBuchen', cdRegister);
 S.RegisterDelphiFunction(@e_w_SetPostenData, 'e_w_SetPostenData', cdRegister);
 S.RegisterDelphiFunction(@e_w_SetPostenPreis, 'e_w_SetPostenPreis', cdRegister);
 S.RegisterDelphiFunction(@e_w_InvalidateCaches, 'e_w_InvalidateCaches', cdRegister);
 S.RegisterDelphiFunction(@q_r_PersonWarnung, 'q_r_PersonWarnung', cdRegister);
 S.RegisterDelphiFunction(@e_f_PersonInfo, 'e_f_PersonInfo', cdRegister);
 S.RegisterDelphiFunction(@t_r_Beleg, 't_r_Beleg', cdRegister);
 S.RegisterDelphiFunction(@e_r_AuftragNummer, 'e_r_AuftragNummer', cdRegister);
 S.RegisterDelphiFunction(@e_r_Schritte, 'e_r_Schritte', cdRegister);
 S.RegisterDelphiFunction(@e_r_AuftragPlausi, 'e_r_AuftragPlausi', cdRegister);
 S.RegisterDelphiFunction(@e_r_Sparte, 'e_r_Sparte', cdRegister);
 S.RegisterDelphiFunction(@e_w_Ticket, 'e_w_Ticket', cdRegister);
 S.RegisterDelphiFunction(@e_w_Ticket2_P, 'e_w_Ticket2', cdRegister);
//  RIRegister_TRegelErgebnis(CL);
end;

 
 
{ TPSImport_Funktionen_Beleg }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Funktionen_Beleg.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Funktionen_Beleg(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Funktionen_Beleg.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Funktionen_Beleg_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
