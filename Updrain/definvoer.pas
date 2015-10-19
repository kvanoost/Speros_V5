unit definvoer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, Buttons, ExtCtrls, Grids, Dialogs;

type
  Tinput = class(TForm)
    BitBtn1: TBitBtn;          BitBtn2: TBitBtn;
    GroupBox1: TGroupBox;      Panel2: TPanel;
    Edit3: TEdit;              GroupBox2: TGroupBox;
    Edit1: TEdit;              Panel1: TPanel;
    OpenDialog1: TOpenDialog;    GroupBox3: TGroupBox;
    Panel3: TPanel;              Edit10: TEdit;
    Panel4: TPanel;              Edit11: TEdit;
    Panel5: TPanel;              Edit12: TEdit;
    Edit2: TEdit;                Panel6: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Edit1DblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Edit2DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure writedocfile(pncol,pnrow : Integer;
                         pminx,pmaxx,pminy,pmaxy,pres,pminz,pmaxz : double);
  end;

var
  input: Tinput;
  dumstr,datadir : string;
  DTM : array[0..3000,0..3000] of single;
  PRC : array[0..3000,0..3000] of SmallInt;
  NROW,NCOL,hulpgetal : integer;
  RES, MINX, MAXX, MINY, MAXY, MINZ, MAXZ : double;
  implementation

uses start;

{$R *.DFM}

function filecompcheck (col1,row1,col2,row2: integer): integer;
begin
if (col1<>col2) or (row1<>row2) then
   begin
   ShowMessage('Files are not compatible');
   filecompcheck := 0;
   end
else filecompcheck := 1;
end;

procedure Tinput.writedocfile(pncol,pnrow : Integer;
                         pminx,pmaxx,pminy,pmaxy,pres,pminz,pmaxz : double);
begin
 assignfile(output, dumstr); rewrite(output);
 writeln(output,'file title  : '); writeln(output,'datatype    : real');
 writeln(output,'filetype    : ascii'); dumstr := 'columns     : ' + inttostr(pNCOL);
 writeln(output, dumstr); dumstr := 'rows        : ' + inttostr(pNROW);
 writeln(output, dumstr); writeln(output, 'ref. system : plane');
 writeln(output, 'ref. units  : m'); writeln(output, 'unit dist.  : 1');
 dumstr := 'min. X      : ' + floattostr(pMINX); writeln(output, dumstr);
 dumstr := 'max. X      : ' + floattostr(pMAXX); writeln(output, dumstr);
 dumstr := 'min. Y      : ' + floattostr(pMINY); writeln(output, dumstr);
 dumstr := 'max. Y      : ' + floattostr(pMAXY); writeln(output, dumstr);
 writeln(output, 'posnn error : unknown'); dumstr := 'resolution  : ' + floattostr(pRES);
 writeln(output, dumstr); dumstr := 'min. value  : ' + floattostr(pMINZ);
 writeln(output, dumstr); dumstr := 'max. value  : ' + floattostr(pMAXZ);
 writeln(output, dumstr); writeln(output,'value units : unspecified');
 writeln(output,'value error : unknown'); writeln(output,'flag value  : none');
 writeln(output,'flag defnn  : none');   writeln(output,'legend cats : 0');
end;

procedure Tinput.FormActivate(Sender: TObject);
var
environ : textfile;
begin
//Inlezen van idrisi.env voor data pad te kennen//
  If startscherm.checkbox1.state = cbchecked then
  begin
  If fileExists('c:\idrisi\idrisi.env') = true then dumstr := 'c:\idrisi\Idrisi.env'
  else
  if fileExists('c:\idrisiw\idrisi.env') = true then
  dumstr := 'c:\idrisiw\Idrisi.env'  else
  If fileExists('c:\programs\idrisiw\idrisi.env') = true then dumstr := 'c:\programs\idrisiw\Idrisi.env'
  else
  If fileExists('c:\program files\idrisiw\idrisi.env') = true then dumstr := 'c:\program files\idrisiw\Idrisi.env'
  else
  dumstr := inputbox('Could not find Idrisi directory',
 'Idrisi environ path:','c:\idrisi\idrisi.env');
  AssignFile(environ, dumstr);    Reset(environ);
    readln (environ,dumstr);      readln (environ,dumstr) ;
    readln(environ,datadir);      delete(datadir,1,40);
    readln(environ,dumstr);       delete(dumstr,1,40);
    datadir:=datadir+dumstr;      CloseFile(environ);
  end
  else // Idrisi non compatible
    datadir := 'c:\';
// Output is het datapad van idrisi: datadir
end;

procedure Tinput.Edit1DblClick(Sender: TObject);
var
i,j: integer;
docfileIMG,fileIMG : textfile;
docnfileIMG,NfileIMG : string;
begin
    opendialog1.title := 'Open DTM';    opendialog1.initialdir := datadir;
    opendialog1.execute;                dumstr := opendialog1.filename;
    hulpgetal := length(dumstr)-2;      delete(dumstr,hulpgetal,3);
    docNfileIMG := dumstr + 'doc' ;     NfileIMG := dumstr + 'img';
    edit1.text := NfileIMG;
// INLEZEN NCOLS
   Assignfile(docfileIMG, docNfileIMG);   reset(docfileIMG);
   for i := 1 to 4 do
   readln(docfileIMG, dumstr);delete (dumstr,1,14);
   ncol := strtoint(dumstr);  edit10.text := dumstr;
// INLEZEN NROWS
   readln(docfileIMG, dumstr);   delete (dumstr,1,14);
   nrow := strtoint(dumstr);     edit11.text := dumstr;
   readln(docfileIMG);           readln(docfileIMG);
   readln(docfileIMG);           readln(docfileIMG,dumstr);
   delete(dumstr,1,14);          MINX := strtofloat(dumstr);
   readln(docfileIMG,dumstr);   delete(dumstr,1,14);
   MAXX :=  strtofloat(dumstr);  readln(docfileIMG,dumstr);
   delete(dumstr,1,14);           MINY := strtofloat(dumstr);
   readln(docfileIMG,dumstr);   delete(dumstr,1,14);
   MAXY :=  strtofloat(dumstr);   readln(docfileIMG);
   readln(docfileIMG, dumstr);    delete(dumstr,1,14);
   res := strtofloat(dumstr);     edit12.text := dumstr;
// Inlezen gegevens
   cursor:=   crhourglass;        repaint;
   assignfile(FileIMG, NfileIMG);   reset (fileIMG);
    for i := 1 to nrow do
        for j:= 1 to ncol do
        read(fileIMG, DTM[i,j]);
        cursor:=crdefault;         repaint;
end;

procedure Tinput.Edit2DblClick(Sender: TObject);
var
i,j,hulpgetal1, hulpgetal2: integer;
docfileIMG,fileIMG : textfile;
docnfileIMG,NfileIMG : string;
begin
    opendialog1.title := 'Open Parcel';    opendialog1.initialdir := datadir;
    opendialog1.execute;                   dumstr := opendialog1.filename;
    hulpgetal := length(dumstr)-2;         delete(dumstr,hulpgetal,3);
    docNfileIMG := dumstr + 'doc' ;        NfileIMG := dumstr + 'img';
    edit2.text := NfileIMG;
// INLEZEN NCOLS
   Assignfile(docfileIMG, docNfileIMG);   reset(docfileIMG);
   for i := 1 to 4 do
    readln(docfileIMG, dumstr);
    delete (dumstr,1,14);   hulpgetal1 := strtoint(dumstr);
// INLEZEN NROWS
   readln(docfileIMG, dumstr);   delete (dumstr,1,14);
   hulpgetal2 := strtoint(dumstr);
      if filecompcheck(ncol,nrow,hulpgetal1,hulpgetal2)= 1 then
      begin // Inlezen gegevens
      assignfile(FileIMG, NfileIMG);
      reset (fileIMG);
      for i := 1 to nrow do
        for j:= 1 to ncol do
        read(fileIMG, PRC[i,j]);
      end
   else
   edit2.text := '';
end;

procedure Tinput.BitBtn1Click(Sender: TObject);
var i,j : integer;
begin
dumstr := edit3.text;
if edit3.text = '' then
     showmessage('Invalid Output Name !')
     else
       begin
       dumstr := datadir + dumstr + '.IMG';
       assignfile(output, dumstr);
       dumstr := datadir + edit3.text + '.DOC';
       rewrite(output);
       bitbtn1.enabled := true;
       startscherm.kinvoer.enabled := false;
       startscherm.kverw.enabled := true;
       close;
       end;
   DTM[0,0]:= DTM[1,1];
   DTM[0,(ncol+1)] := DTM[1,ncol];
   DTM[nrow+1,0] := DTM[nrow,1];
   DTM[nrow+1,ncol+1] := DTM[nrow,ncol];
   PRC[0,0]:= PRC[1,1];
   PRC[0,(ncol+1)] := PRC[1,ncol];
   PRC[nrow+1,0] := PRC[nrow,1];
   PRC[nrow+1,ncol+1] := PRC[nrow,ncol];
   for j := 1 to ncol do
       begin
         DTM[0,j] := DTM[1,j];
         DTM[(nrow+1),j]:=DTM[nrow,j];
         PRC[0,j] := PRC[1,j];
         PRC[(nrow+1),j]:=PRC[nrow,j];
       end;
   for  i := 1 to nrow do
        begin
          DTM[i,0] := DTM[i,1];
          DTM[i,ncol+1] := DTM[i,ncol];
          PRC[i,0] := PRC[i,1];
          PRC[i,ncol+1] := PRC[i,ncol];
        end;
end;

procedure Tinput.BitBtn2Click(Sender: TObject);
begin
close;
end;

end.



