program Updrain;

uses
  Forms,
  start in 'start.pas' {Startscherm},
  definvoer in 'definvoer.pas' {input},
  help in 'help.pas' {Helpform},
  about in 'about.pas' {AboutBox},
  Intro in 'Intro.pas' {Introform};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Updrain';
  Application.CreateForm(TStartscherm, Startscherm);
  Application.CreateForm(Tinput, input);
  Application.CreateForm(THelpform, Helpform);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TIntroform, Introform);
  Application.Run;
end.
