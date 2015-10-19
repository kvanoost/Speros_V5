unit help;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  THelpform = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    BitBtn1: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Helpform: THelpform;

implementation

uses about;

{$R *.DFM}


procedure THelpform.FormClose(Sender: TObject; var Action: TCloseAction);
begin
helpform.hide;
end;

procedure THelpform.Button1Click(Sender: TObject);
begin
about.aboutbox.show;
end;

procedure THelpform.BitBtn1Click(Sender: TObject);
begin
helpform.hide;
end;

end.
