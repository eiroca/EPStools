(****************************************************************************)
(*  Copyright (C) 1996-2008 eIrOcA Enrico Croce & Simona Burzio             *)
(*                                                                          *)
(*  This program is free software: you can redistribute it and/or modify    *)
(*  it under the terms of the GNU General Public License as published by    *)
(*  the Free Software Foundation, either version 3 of the License, or       *)
(*  (at your option) any later version.                                     *)
(*                                                                          *)
(*  This program is distributed in the hope that it will be useful,         *)
(*  but WITHOUT ANY WARRANTY; without even the implied warranty of          *)
(*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *)
(*  GNU General Public License for more details.                            *)
(*                                                                          *)
(*  You should have received a copy of the GNU General Public License       *)
(*  along with this program.  If not, see <http://www.gnu.org/licenses/>.   *)
(*                                                                          *)
(*--------------------------------------------------------------------------*)
(*                                                                          *)
(* Author :  Enrico Croce                                                   *)
(*                                                                          *)
(****************************************************************************)
unit FPortal;

interface

uses
  uEPSUtil, SysUtils, Classes,
  Forms, Dialogs, ImgList, Controls, Menus, StdCtrls, ExtCtrls, ComCtrls;

const
  MAIN_NODE = 'category_0';

type
  TfmPortal = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    Load1: TMenuItem;
    pcData: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet5: TTabSheet;
    tvIcon: TTreeView;
    Splitter1: TSplitter;
    pnIconEdit: TPanel;
    lbIconImages: TListBox;
    Label2: TLabel;
    iIconName: TEdit;
    btUpdateIcon: TButton;
    Saveconfiguration1: TMenuItem;
    PopupMenu1: TPopupMenu;
    AddIcon1: TMenuItem;
    AddImage1: TMenuItem;
    AddLink1: TMenuItem;
    miResource: TMenuItem;
    miNewIcon: TMenuItem;
    miNewImage: TMenuItem;
    miNewLink: TMenuItem;
    btDeleteIcon: TButton;
    pnImageEdit: TPanel;
    iImageName: TEdit;
    btImageUpdate: TButton;
    btimageDelete: TButton;
    iImageURL: TLabeledEdit;
    iImageMIME: TLabeledEdit;
    iImageFormat: TLabeledEdit;
    iImageAltText: TLabeledEdit;
    iImageWidth: TLabeledEdit;
    iImageHeigth: TLabeledEdit;
    pnLinkEdit: TPanel;
    btLinkDelete: TButton;
    btLinkUpdate: TButton;
    iLinkName: TEdit;
    iLinkURL: TLabeledEdit;
    iLinkCaption: TLabeledEdit;
    iLinkIFProperty: TLabeledEdit;
    iLinkStyle: TLabeledEdit;
    cbLinkIcon: TComboBox;
    Label3: TLabel;
    tvPortal: TTreeView;
    Splitter2: TSplitter;
    ilPortal: TImageList;
    pnPortalEdit: TPanel;
    iPortalTitle: TLabeledEdit;
    iPortalWelcome: TLabeledEdit;
    iPortalNews: TLabeledEdit;
    procedure Exit1Click(Sender: TObject);
    procedure Load1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tvIconChange(Sender: TObject; Node: TTreeNode);
    procedure tvIconChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure Saveconfiguration1Click(Sender: TObject);
    procedure AddIcon1Click(Sender: TObject);
    procedure btUpdateIconClick(Sender: TObject);
    procedure btDeleteIconClick(Sender: TObject);
    procedure btimageDeleteClick(Sender: TObject);
    procedure miNewImageClick(Sender: TObject);
    procedure btImageUpdateClick(Sender: TObject);
    procedure btLinkDeleteClick(Sender: TObject);
    procedure btLinkUpdateClick(Sender: TObject);
    procedure miNewLinkClick(Sender: TObject);
    procedure tvPortalChange(Sender: TObject; Node: TTreeNode);
    procedure tvPortalDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure tvPortalDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tvPortalStartDrag(Sender: TObject;
      var DragObject: TDragObject);
  private
    { Private declarations }
    curNode: TTreeNode;
    iconRoot: TTreeNode;
    imageRoot: TTreeNode;
    linkRoot: TTreeNode;
    portalRoot: TTreeNode;
    dragNode: TTreeNode;
    portalConfig: TPortalConfig;
    procedure UpdateViewResource;
    procedure UpdateViewPortal;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfmPortal.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfmPortal.Load1Click(Sender: TObject);
var
  path: string;
begin
  path:= '.';
  portalConfig:= TPortalConfig.Create(path);
  pcData.Visible:= true;
  miResource.Enabled:= true;
  UpdateViewResource;
  UpdateViewPortal;
end;

procedure TfmPortal.UpdateViewResource;
var
 S: TStrings;
 i: integer;
begin
  pnIconEdit.Visible:= false;
  pnImageEdit.Visible:= false;
  pnLinkEdit.Visible:= false;
  S:= TStringList.Create;
  try
    tvIcon.Items.Clear;
    iconRoot:= tvIcon.Items.AddChildObjectFirst(nil, 'Icons', ICONROOT);
    portalConfig.iconConf.ReadSections(S);
    for i:= 0 to S.Count-1 do begin
      tvIcon.Items.AddChildObject(iconRoot, S[i], ID_ICONNODE);
    end;
    imageRoot:= tvIcon.Items.AddChildObjectFirst(nil, 'Images', ID_IMAGEROOT);
    portalConfig.imageConf.ReadSections(S);
    for i:= 0 to S.Count-1 do begin
      tvIcon.Items.AddChildObject(imageRoot, S[i], ID_IMAGENODE);
    end;
    linkRoot:= tvIcon.Items.AddChildObjectFirst(nil, 'Links', ID_LINKROOT);
    portalConfig.linkConf.ReadSections(S);
    for i:= 0 to S.Count-1 do begin
      tvIcon.Items.AddChildObject(linkRoot, S[i], ID_LINKNODE);
    end;
  finally
    S.Free;
  end;
end;

procedure TfmPortal.UpdateViewPortal;
  procedure processMenu(const parent, menu: string; const root: TTreeNode);
  var
    S: TStrings;
    i: integer;
    tmp: string;
    newroot: TTreeNode;
    newmenu: string;
    pn: TPortalNode;
  begin
    S:= TStringList.Create;
    try
      S.Delimiter:= ' ';
      S.DelimitedText:= menu;
      for i:= 0 to S.Count-1 do begin
        tmp:= S[i];
        if (tmp='-') then begin
          pn:= portalConfig.portalNodes.Add as TPortalNode;
          pn.kind:= ID_PORTALFILLER;
          pn.cat:= parent;
          pn.pos:= i;
          tvPortal.Items.AddChildObject(root, tmp, pn).ImageIndex:= 3;
        end
        else begin
          if portalConfig.linkConf.SectionExists(tmp) then begin
            pn:= portalConfig.portalNodes.Add as TPortalNode;
            pn.kind:= ID_PORTALLINK;
            pn.cat:= parent;
            pn.pos:= i;
            tvPortal.Items.AddChildObject(root, portalConfig.linkConf.ReadString(tmp, 'caption', tmp), pn).ImageIndex:= 2;
          end
          else begin
            pn:= portalConfig.portalNodes.Add as TPortalNode;
            pn.kind:= ID_PORTALCATEGORY;
            pn.cat:= parent;
            pn.pos:= i;
            newroot:= tvPortal.Items.AddChildObject(root, portalConfig.portalConf.ReadString(tmp, 'caption', ''), pn);
            newroot.ImageIndex:= 1;
            newmenu:= portalConfig.portalConf.ReadString(tmp, 'menu', '');
            processMenu(tmp, newmenu, newroot);
          end;
        end;
      end;
    finally
      S.Free;
    end;
  end;
var
  pn: TPortalNode;
begin
  pnPortalEdit.Visible:= false;
  tvPortal.Items.Clear;
  pn:= portalConfig.portalNodes.Add as TPortalNode;
  pn.kind:= ID_PORTALROOT;
  pn.cat:= '';
  pn.pos:= 0;
  portalRoot:= tvPortal.Items.AddChildObjectFirst(nil, '/', pn);
  portalRoot.ImageIndex:= 1;
  processMenu('', portalConfig.portalConf.ReadString(MAIN_NODE, 'menu', ''), portalRoot);
end;

procedure TfmPortal.FormCreate(Sender: TObject);
begin
  portalConfig:= nil;
  pcData.Visible:= false;
  miResource.Enabled:= false;
  pnLinkEdit.Align:= alClient;
  pnIconEdit.Align:= alClient;
  pnImageEdit.Align:= alClient;
  pnPortalEdit.Align:= alClient;
end;

procedure TfmPortal.FormDestroy(Sender: TObject);
begin
  portalConfig.Free;
end;

procedure TfmPortal.tvIconChange(Sender: TObject; Node: TTreeNode);
var
  name, images: string;
  i, ps: integer;
  S1, S2: TStrings;
begin
  S1:= TStringList.Create;
  S2:= TStringList.Create;
  try
    curNode:= nil;
    if Node.Data = ID_ICONNODE then begin
      curNode:= Node;
      pnIconEdit.Visible:= true;
      lbIconImages.Items.Clear;
      name:= Node.Text;
      iIconName.Text:= name;
      images:= portalConfig.iconConf.ReadString(name, 'images', '');
      portalConfig.imageConf.ReadSections(S2);
      S1.Delimiter:= ' ';
      S1.DelimitedText:= images;
      lbIconImages.Items.AddStrings(S2);
      for i:= 0 to S1.Count-1 do begin
       ps:= lbIconImages.Items.IndexOf(S1[i]);
       if (ps>=0) then begin
         lbIconImages.Selected[ps]:= true;
       end;
      end;
    end
    else begin
      pnIconEdit.Visible:= false;
    end;
    if Node.Data = ID_IMAGENODE then begin
      curNode:= Node;
      pnImageEdit.Visible:= true;
      name:= Node.Text;
      iImageName.Text:= name;
      iImageURL.Text:= portalConfig.imageConf.ReadString(name, 'url', '');
      iImageMIME.Text:= portalConfig.imageConf.ReadString(name, 'mime_type', '');
      iImageFormat.Text:= portalConfig.imageConf.ReadString(name, 'format', '');
      iImageAltText.Text:= portalConfig.imageConf.ReadString(name, 'alt_text', '');
      iImageWidth.Text:= portalConfig.imageConf.ReadString(name, 'width', '');
      iImageHeigth.Text:= portalConfig.imageConf.ReadString(name, 'height', '');
    end
    else begin
      pnImageEdit.Visible:= false;
    end;
    if Node.Data = ID_LINKNODE then begin
      curNode:= Node;
      pnLinkEdit.Visible:= true;
      name:= Node.Text;
      iLinkName.Text:= name;
      iLinkCaption.Text:= portalConfig.linkConf.ReadString(name, 'caption', '');
      iLinkURL.Text:= portalConfig.linkConf.ReadString(name, 'url', '');
      iLinkIFProperty.Text:= portalConfig.linkConf.ReadString(name, 'ifproperty', '');
      iLinkStyle.Text:= portalConfig.linkConf.ReadString(name, 'style', '');
      cbLinkIcon.Items.Clear;
      portalConfig.iconConf.ReadSections(cbLinkIcon.Items);
      cbLinkIcon.Text:= portalConfig.linkConf.ReadString(name, 'icon', '');
    end
    else begin
      pnLinkEdit.Visible:= false;
    end;
  finally
    S1.Free;
    S2.free;
  end;
end;

procedure TfmPortal.tvIconChanging(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);
begin
  if Node.Data = ICONROOT then AllowChange:= false
  else if Node.Data = IMAGEROOT then AllowChange:= false
  else if Node.Data = LInKROOT then AllowChange:= false;
end;

procedure TfmPortal.Saveconfiguration1Click(Sender: TObject);
begin
  portalConfig.UpdateConfig;
end;

procedure TfmPortal.AddIcon1Click(Sender: TObject);
begin
  if not portalConfig.iconConf.SectionExists('newicon') then begin
    portalConfig.iconConf.WriteString('newicon', 'images', '');
    tvIcon.Items.AddChildObjectFirst(iconRoot, 'newicon', ID_ICONNODE);
  end;
end;

procedure TfmPortal.btUpdateIconClick(Sender: TObject);
var
  oldName, newName: string;
  S: TStrings;
  i: integer;
begin
  if curNode = nil then exit;
  newName:= iIconName.text;
  for i:= length(newName) downto 1 do begin
    if not (newName[i] in ['A'..'Z', 'a'..'z', '0'..'9', '_']) then begin
      delete(newName, i, 1);
    end;
  end;
  iIconName.Text:= newName;
  oldName:= curNode.Text;
  if (portalConfig.iconConf.SectionExists(newName)) then begin
    ShowMessage('Invalid icon name');
  end
  else begin
    S:= TStringList.Create;
    try
      curNode.Text:= newName;
      portalConfig.iconConf.EraseSection(oldName);
      S.Delimiter:= ' ';
      for i:= 0 to lbIconImages.Items.Count-1 do begin
        if lbIconImages.Selected[i] then begin
          S.Add(lbIconImages.Items[i]);
        end;
      end;
      portalConfig.iconConf.WriteString(newName, 'images', S.DelimitedText);
    finally
      S.Free;
    end;
  end;
end;

procedure TfmPortal.btDeleteIconClick(Sender: TObject);
begin
  if (curNode = nil) then exit;
  portalConfig.iconConf.EraseSection(curNode.Text);
  curNode.Delete;
end;

procedure TfmPortal.btimageDeleteClick(Sender: TObject);
begin
  if (curNode = nil) then exit;
  portalConfig.imageConf.EraseSection(curNode.Text);
  curNode.Delete;
end;

procedure TfmPortal.miNewImageClick(Sender: TObject);
begin
  if not portalConfig.imageConf.SectionExists('newimage') then begin
    portalConfig.imageConf.WriteString('newimage', 'url', '');
    tvIcon.Items.AddChildObjectFirst(imageRoot, 'newimage', ID_IMAGENODE);
  end;
end;

procedure TfmPortal.btImageUpdateClick(Sender: TObject);
var
  oldName, newName: string;
  i: integer;
begin
  if curNode = nil then exit;
  newName:= iImageName.text;
  for i:= length(newName) downto 1 do begin
    if not (newName[i] in ['A'..'Z', 'a'..'z', '0'..'9', '_']) then begin
      delete(newName, i, 1);
    end;
  end;
  iImageName.Text:= newName;
  oldName:= curNode.Text;
  if (portalConfig.imageConf.SectionExists(newName)) then begin
    ShowMessage('Invalid Image Name');
  end
  else begin
    curNode.Text:= newName;
    portalConfig.imageConf.EraseSection(oldName);
    portalConfig.imageConf.WriteString(newName, 'url', iImageURL.Text);
    portalConfig.imageConf.WriteString(newName, 'mime_type', iImageMIME.Text);
    portalConfig.imageConf.WriteString(newName, 'format', iImageFormat.Text);
    portalConfig.imageConf.WriteString(newName, 'alt_text', iImageAltText.Text);
    portalConfig.imageConf.WriteString(newName, 'width', iImageWidth.Text);
    portalConfig.imageConf.WriteString(newName, 'height', iImageHeigth.Text);
  end;
end;

procedure TfmPortal.btLinkDeleteClick(Sender: TObject);
begin
  if (curNode = nil) then exit;
  portalConfig.linkConf.EraseSection(curNode.Text);
  curNode.Delete;
end;

procedure TfmPortal.btLinkUpdateClick(Sender: TObject);
var
  oldName, newName: string;
  i: integer;
  tmp: string;
begin
  if curNode = nil then exit;
  newName:= iLinkName.text;
  for i:= length(newName) downto 1 do begin
    if not (newName[i] in ['A'..'Z', 'a'..'z', '0'..'9', '_']) then begin
      delete(newName, i, 1);
    end;
  end;
  iLinkName.Text:= newName;
  oldName:= curNode.Text;
  if (portalConfig.linkConf.SectionExists(newName)) then begin
    ShowMessage('Invalid link name');
  end
  else begin
    curNode.Text:= newName;
    portalConfig.linkConf.EraseSection(oldName);
    portalConfig.linkConf.WriteString(newName, 'url', iLinkURL.Text);
    portalConfig.linkConf.WriteString(newName, 'caption', iLinkCaption.Text);
    tmp:= trim(iLinkIFProperty.Text);
    if (tmp <> '') then begin
      portalConfig.linkConf.WriteString(newName, 'ifproperty', tmp);
    end;
    tmp:= trim(iLinkStyle.Text);
    if (tmp <> '') then begin
      portalConfig.linkConf.WriteString(newName, 'style', tmp);
    end;
    portalConfig.linkConf.WriteString(newName, 'icon', cbLinkIcon.Text);
  end;
end;

procedure TfmPortal.miNewLinkClick(Sender: TObject);
begin
  if not portalConfig.imageConf.SectionExists('newlink') then begin
    portalConfig.linkConf.WriteString('newlink', 'url', '');
    tvIcon.Items.AddChildObjectFirst(linkRoot, 'newlink', ID_LINKNODE);
  end;
end;

procedure TfmPortal.tvPortalChange(Sender: TObject; Node: TTreeNode);
var
  S1, S2: TStrings;
  pn: TPortalNode;
begin
  S1:= TStringList.Create;
  S2:= TStringList.Create;
  try
    curNode:= nil;
    pn:= TPortalNode(Node.Data);
    if (pn=nil)then begin
      if pn.kind = ID_PORTALROOT then begin
        curNode:= Node;
        pnPortalEdit.Visible:= true;
        iPortalTitle.Text:= portalConfig.portalConf.ReadString(MAIN_NODE, 'title', '');
        iPortalNews.Text:= portalConfig.portalConf.ReadString(MAIN_NODE, 'news', '');
        iPortalWelcome.Text:= portalConfig.portalConf.ReadString(MAIN_NODE, 'welcome', '');
      end
      else begin
        pnPortalEdit.Visible:= false;
      end;
    end;
  finally
    S1.Free;
    S2.free;
  end;
end;

procedure TfmPortal.tvPortalDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  node: TTreeNode;
begin
  Accept:= false;
  if (Source = tvPortal) then begin
    node:= tvPortal.GetNodeAt(X, Y);
    if (node = nil) then Accept:= true
    else if (TPortalNode(node.Data).kind<>ID_PORTALROOT) then Accept:= true
    else Accept:= false;
  end;
end;

procedure TfmPortal.tvPortalDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  node: TTreeNode;
begin
   node:= tvPortal.GetNodeAt(X, Y);
   if (node=nil) then begin
     dragNode.MoveTo(portalRoot, naAddChild);
   end
   else begin
     dragNode.MoveTo(node, naInsert);
   end;
end;

procedure TfmPortal.tvPortalStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  dragNode:= tvPortal.Selected;
end;

end.

