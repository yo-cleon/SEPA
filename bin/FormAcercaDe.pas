unit FormAcercaDe;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, acPNG, Vcl.ExtCtrls, JvExExtCtrls,
  JvImage, JvLinkLabel, JvExControls, JvLabel, ShellAPI;

type
  TAcercaDe = class(TForm)
    logo: TJvImage;
    JvLabel1: TJvLabel;
    linkLabel: TJvLinkLabel;
    Image1: TImage;
    Image2: TImage;
    JvLabel2: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel4: TJvLabel;
    JvLinkLabel1: TJvLinkLabel;
    procedure linkLabelClick(Sender: TObject);
    procedure linkLabelLinkClick(Sender: TObject; LinkNumber: Integer; LinkText,
      LinkParam: string);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AcercaDe: TAcercaDe;

implementation

{$R *.dfm}

procedure TAcercaDe.linkLabelClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, PChar('open'), PChar(linkLabel.Hint),
   nil, nil, SW_SHOW);
end;

procedure TAcercaDe.linkLabelLinkClick(Sender: TObject; LinkNumber: Integer;
  LinkText, LinkParam: string);
begin
  ShellExecute(Application.Handle, PChar('open'), PChar(linkLabel.Hint),
   nil, nil, SW_SHOW);
end;

end.
