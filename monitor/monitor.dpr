program monitor;

uses
  Vcl.Forms,
  frmmain in 'frmmain.pas' {MainForm},
  dmusb in 'dmusb.pas' {USBdm: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TUSBdm, USBdm);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
