unit start;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, ComCtrls, Math, ExtCtrls;

type
  TStartscherm = class(TForm)
    Kinvoer: TButton;    Kverw: TButton;
    BitBtn1: TBitBtn;    BitBtn2: TBitBtn;
    GroupBox1: TGroupBox;  CheckBox1: TCheckBox;
    Progres: TGroupBox;   ProgressBar1: TProgressBar;
    RG1: TRadioGroup;          RG3: TRadioGroup;
    GroupBox2: TGroupBox;      Edit1: TEdit;
    UpDown1: TUpDown;          Panel2: TPanel;
    Label1: TLabel;            Label3: TLabel;
    Label2: TLabel;            Label4: TLabel;
    Label5: TLabel;            Label6: TLabel;
    Button1: TButton;
    procedure KinvoerClick(Sender: TObject);
    procedure KverwClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure sort(var Z : array of single; iLo,iHi:Integer);
  end;
var
  Startscherm: TStartscherm;
  UPAREA :array[0..3000,0..3000] of single;
  ROW, COLUMN : array[1..9000000] of SmallInt;
  H : array[1..9000000] of single;
  PART1, PART2,slope,aspect : double;

implementation

uses definvoer, help, about, Intro;

{$R *.DFM}
procedure Tstartscherm.sort(var Z : array of single; iLo,iHi:Integer);
var
    helpcol, helprow,Lo, Hi: Integer;
    Mid,T : double;
begin
    Lo := iLo;
    Hi := iHi;
    Mid := H[(Lo + Hi) div 2];
    repeat
      while H[Lo] < Mid do Inc(Lo);
      while H[Hi] > Mid do Dec(Hi);
      if Lo <= Hi then
      begin
        T := H[Lo];
        H[Lo] := H[Hi];
        H[Hi] := T;
        helprow := row[lo];
        row[lo]:=row[hi];
        row[hi]:=helprow;
        helpcol := column[lo];
        column[lo]:=column[hi];
        column[hi]:=helpcol;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then Sort(H, iLo, Hi);
    if Lo < iHi then Sort(H, Lo, iHi);
end;

procedure TStartscherm.KinvoerClick(Sender: TObject);
begin
input.show;
end;

procedure TStartscherm.KverwClick(Sender: TObject);
var
number,i,j,w,number1,K,L,K1,K2,L1,L2,ROWmin,COLmin,TF : integer;
SN,CSN,DIFFX,DIFFY,SLOPEX,SLOPEY,GRAD,AREA,
D,OPPCOR,MINIMUM,ADJUST,B,hulp,SUM : double;
FINISH : array[0..3000,0..3000] of SmallInt;
WEIGTH,PART : array[1..8] of double;
begin
 bitbtn1.enabled := false;
 TF:=strtoint(edit1.text);

WEIGTH[1]:=SQRT(2.0)/4.0;     WEIGTH[2]:=0.5;
WEIGTH[3]:=SQRT(2.0)/4.0;     WEIGTH[4]:=0.5;
WEIGTH[5]:=0.5;               WEIGTH[6]:=SQRT(2.0)/4.0;
WEIGTH[7]:=0.5;               WEIGTH[8]:=SQRT(2.0)/4.0;

 Progressbar1.min := 0;
 progressbar1.max := nrow;
 Progres.visible := true;
 number1:=0;
 label5.caption := 'Reading';
 progres.repaint;
 for i := 1 to nrow do
 for j := 1 to ncol do begin
 progressbar1.position := i;
 number1:=number1+1; H[number1]:= DTM[i,j];
 ROW[number1]:=i; COLUMN[number1]:=j;
 UPAREA[i,j]:=0.0; FINISH[i,j]:=0;
 end;

 progressbar1.position := 0;
 sort(H,1,nrow*ncol);
 progressbar1.max := 100;
 label5.caption := 'Calculating';
 progres.repaint;
for number1:= ncol*nrow downto 1 do begin // begin lus
 progressbar1.position := round(((ncol*nrow-number1)/(ncol*nrow))*100);
 i:=row[number1];
 j:=column[number1];
{*******************************************************************************
               HELLING (in radialen)
*******************************************************************************}
     DIFFX := abs(DTM[i-1,j]-DTM[i+1,j])/(2*RES);
     DIFFY := abs(DTM[i,j-1]-DTM[i,j+1])/(2*RES);
     slope := arctan((sqrt(sqr(DIFFX)+sqr(DIFFY))));

{*******************************************************************************
                   ASPECT  (in radialen)
*******************************************************************************}
//IF PRC[i,j]=0 then continue;
     ASPECT := 0;
     DIFFX := DTM[i-1,j]-DTM[i+1,j];  DIFFY := DTM[i,j-1]-DTM[i,j+1];
     SLOPEX := DIFFX/RES; SLOPEY := DIFFY/RES;
     if SLOPEX = 0.0 then
        begin
        if diffy > 0.0 then
           ASPECT := 90.0;
        if diffy < 0.0 then
           ASPECT := 270.0;
        end
     else
     begin
          if slopey = 0.0 then
             begin
             if diffx > 0.0 then
             ASPECT := 180.0;
             if diffx < 0.0 then
             ASPECT := 0.0;
             end
          else
          begin
            GRAD := SLOPEX/SLOPEY;
            aspect := -(arctan(GRAD)*(180/PI));
            if (diffx > 0.0) and (diffy > 0.0) then
            ASPECT := ABS(ASPECT) + 90.0
            else
              begin
               if (diffx > 0.0) and (diffy < 0.0) then
               ASPECT := 270.0 - ASPECT
               else
                 begin
                   if (diffx < 0.0) and (diffy<0.0) then
                   ASPECT := 270.0 - ASPECT
                   else
                    ASPECT := 90.0 - ASPECT;
                 end;
              end;
          end;
        end;
  ASPECT:=ASPECT*(PI/180.0);
{*******************************************************************************
              Hellingopwaartse oppervlakte
*******************************************************************************}

OPPCOR := (RES*RES)/(cos(SLOPE));

case RG1.itemindex of
{Flux Decomposition************************************************************}
1:begin
 AREA := UPAREA[I,J]+OPPCOR;
 PART1 := 0.0; PART2 := 0.0;
 k1:=0;l1:=0;k2:=0;l2:=0;
 CSN:=(ABS(cos(aspect)))/(ABS(SIN(aspect))+ABS(COS(aspect)));
 SN :=(ABS(sin(aspect)))/(ABS(SIN(aspect))+ABS(COS(aspect)));
 IF (aspect >= 0.0) AND (aspect <= (PI/2)) THEN  BEGIN
        PART1 := AREA*CSN;
	PART2 := AREA*SN;
	K1 := -1;L1 := 0 ;K2 := 0 ;L2 := 1 ;  END else
 BEGIN
      IF (aspect > (PI/2)) AND (aspect < PI) THEN BEGIN
	  PART1 := AREA*SN;
	  PART2 := AREA*CSN;
	  K1 := 0; L1 := 1; K2 := 1; L2 := 0; END else
      BEGIN
       IF (aspect >= PI)AND (aspect<= (PI*1.5)) THEN  BEGIN
	    PART1 := AREA*CSN;
	    PART2 := AREA*SN;
	    K1 := 1; L1 := 0; K2 := 0; L2 := -1; end else
       BEGIN
        IF (aspect>(PI*1.5))then begin
	    PART1 := AREA*SN;
	    PART2 := AREA*CSN;
	    K1 := 0; L1 := -1;K2 := -1; L2 := 0; END;
       END;END;END;

IF FINISH[i+K1,j+L1]=1 then
 begin
   IF FINISH[i+K2,j+L2]=1 then
     begin part1 := 0.0; part2:=0.0; end
   else
     begin  part2 := part2+part1; part1:=0;end;
 end
 else
 begin
   IF FINISH[i+K2,j+L2]=1 then
   begin part1:=part1+part2; part2:=0; end;
 end;

 IF DTM[i+k1,j+l1]>DTM[i,j] then
  begin
     IF DTM[i+k2,j+l2] > DTM[i,j] then
      begin part1 :=0.0; part2:=0.0; end
     else
      begin
       IF PRC[i+k2,j+l2]<>PRC[i,j] then
       part1:=0.0
       else
        begin
         PART2:=PART2+PART1; PART1:=0.0;
         UPAREA[i+k2,j+l2]:=UPAREA[i+k2,j+l2]+PART2;
        end;
      end;
  end
  else
   begin
     IF DTM[i+k2,j+l2]>DTM[i,j] then
      begin
        IF PRC[i+k1,j+l1] <> PRC[i,j] then
         part2:=0.0
        else
         begin
          part1:=part1+part2;
          part2:=0.0;
          UPAREA[i+k1,j+l1]:=UPAREA[i+k1,j+l1]+part1;
         end;
      end
      else
       begin
        IF PRC[i+k1,j+l1]<>PRC[i,j] then
         begin
          IF PRC[i+k2,j+l2]<>PRC[i,j] then
           begin
            PART1:=PART1*TF/100.0;
            PART2:=PART2*TF/100.0;
           end
          else
           begin
           UPAREA[i+k2,j+l2]:=UPAREA[i+k2,j+l2]+PART2;
           UPAREA[i+k1,j+l1]:=UPAREA[i+k1,j+l1]+(PART1*TF/100.0);
           end;
         end
         else
          begin
           IF PRC[i+k2,j+l2]<>PRC[i,j] then
            begin
             UPAREA[i+k1,j+l1]:=UPAREA[i+k1,j+l1]+part1;
             UPAREA[i+k2,j+l2]:=UPAREA[i+k2,j+l2]+(part2*TF/100.0);
            end
           else
            begin
             UPAREA[I+K1,J+L1]:=UPAREA[I+K1,J+L1] + PART1;
             UPAREA[I+K2,J+L2]:=UPAREA[I+K2,J+L2] + PART2;
            end;
          end;
       end;
   end;

IF ((PART1=0.0)AND(PART2=0.0)) THEN
       BEGIN
            ROWMIN:= 0;
            COLMIN:= 0;
            MINIMUM := 99999.0;
	    for K := -1 to 1 do
	    for L := -1 to 1 do
            begin
	         IF ((K=0)AND(L=0)) then CONTINUE;
	         IF ((DTM[I+K,J+L]<MINIMUM)AND(DTM[I+K,J+L]<DTM[I,J])AND(FINISH[I+K,J+L]=0)
                 AND(PRC[I+ROWMIN,J+COLMIN]=PRC[i,j]))THEN
                 begin
	              MINIMUM := DTM[I+K,J+L];
	              ROWMIN := K;
	              COLMIN := L;
	         end;
            end;
        IF ((ROWMIN <>0)OR(COLMIN<>0))then begin
          IF(PRC[I+ROWMIN,J+COLMIN]=PRC[i,j]) THEN
          UPAREA[I+ROWMIN,J+COLMIN]:=UPAREA[I+ROWMIN,J+COLMIN]+AREA
          ELSE UPAREA[I+ROWMIN,J+COLMIN]:=(UPAREA[I+ROWMIN,J+COLMIN]+AREA)*TF/100.0;end;
       END;
UPAREA[i,j]:=UPAREA[i,j]+(RES*RES/2)
end;
2: {Multiple Flow *************************************************************}
begin
number:=0; sum:=0.0;
FOR k:=-1 to 1 do
FOR l := -1 to 1 do begin
    IF (k=0) and (l=0) then continue;
    number:=number+1;
    IF DTM[i+k,j+l]<DTM[i,j] then
    BEGIN
      IF (ABS(k)=1)and(ABS(l)=1) then D:=RES*SQRT(2.0) else D:=RES;
      IF (PRC[i,j]=0) then PART[number]:=0.0 else
      begin
       IF FINISH[i+k,j+l]<>1 then
       begin
         PART[number]:=(DTM[i,j]-DTM[i+k,j+l])/D;
         SUM:=SUM+PART[number]*WEIGTH[number];
         IF PRC[i+k,j+l]<>PRC[i,j] then
         PART[number]:=TF*((DTM[i,j]-DTM[i+k,j+l])/D)/100
       end
       else part[number]:=0.0;
      end;
    END
    ELSE
    PART[number]:=0.0;
END;
number:=0;
FOR k:=-1 to 1 do
FOR l := -1 to 1 do begin
    IF (k=0) and (l=0) then continue;
    number:=number+1;
    IF (k=0) and (l=0) then continue;
    IF  (part[number]>0.0) then
    begin
      AREA:=((UPAREA[i,j]+OPPCOR)*PART[number]*WEIGTH[number])/SUM;
      UPAREA[i+k,j+l]:=UPAREA[i+k,j+l]+AREA
    end;

END;
UPAREA[i,j]:=UPAREA[i,j]+(RES*RES/2)
end;
{Steepest Descent**************************************************************}
0: begin
 AREA := UPAREA[I,J]+OPPCOR;
            ROWMIN:= 0;
            COLMIN:= 0;
            MINIMUM := 9999999.0;
	    for K := -1 to 1 do
	    for L := -1 to 1 do
            begin
	         IF ((K=0)AND(L=0)) then CONTINUE;
	         IF ((DTM[I+K,J+L]<MINIMUM)AND(DTM[I+K,J+L]<DTM[I,J])AND(FINISH[I+K,J+L]=0))THEN
                 begin
	              MINIMUM := DTM[I+K,J+L];
	              ROWMIN := K;
	              COLMIN := L;
	         end;
            end;
        IF ((ROWMIN <>0)OR(COLMIN<>0))then
        begin
        IF (PRC[i+ROWMIN,j+COLMIN]=PRC[i,j]) THEN
             UPAREA[I+ROWMIN,J+COLMIN]:=UPAREA[I+ROWMIN,J+COLMIN]+AREA
        ELSE UPAREA[I+ROWMIN,J+COLMIN]:=UPAREA[I+ROWMIN,J+COLMIN]+(AREA*TF/100.0);
        END;
UPAREA[i,j]:=UPAREA[i,j]+(RES*RES/2)
end;

end;  {einde van de routing algortimes*****************************************}
FINISH[I,J] := 1;
IF RG3.ItemIndex = 0 then
begin
UPAREA[i,j]:=UPAREA[i,j]/(RES*(ABS(sin(aspect))+ABS(cos(aspect))));
end;

end;   // einde lus ************************************************************

progressbar1.Position :=0;
progressbar1.max :=nrow;
minZ := 9999999.0;
maxZ := -9999999.0;
 label5.caption := 'Writing output';
 startscherm.repaint;
for i:=1 to nrow do
for j:=1 to ncol do begin
IF PRC[i,j]=0 then UPAREA[i,j]:=0;
writeln(output, UPAREA[i,j]);
IF UPAREA[i,j]<minz then minz:=uparea[i,j];
IF UPAREA[i,j]>maxz then maxz:=uparea[i,j];
progressbar1.Position :=i;
end;
progres.visible := false;
closefile(output);
Assignfile(output, dumstr);
input.writedocfile(ncol,nrow,minx,maxx,miny,maxy,res,minz,maxz);
closefile(output);
ShowMessage('All Done !');
bitbtn1.enabled := true;
kinvoer.Enabled := true;
end;

procedure TStartscherm.BitBtn2Click(Sender: TObject);
begin
Application.CreateForm(Thelpform, helpform);
help.Helpform.visible:=true;
end;

procedure TStartscherm.Button1Click(Sender: TObject);
begin
Application.CreateForm(Taboutbox, aboutbox);
about.aboutbox.visible:=true;
end;

end.


