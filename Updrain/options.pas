unit options;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TOptionsform = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Optionsform: TOptionsform;

implementation

uses invoer;

{$R *.DFM}


procedure TOptionsform.BitBtn1Click(Sender: TObject);
begin
t:=strtofloat(edit1.text);
aexp:=strtofloat(edit2.text);
close;
end;

procedure TOptionsform.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
action:=caFree;
end;

end.
