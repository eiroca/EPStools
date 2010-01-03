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
unit uEPSUtil;

interface

uses
  INIFiles, Classes;

const
  ID_ICONROOT = pointer(1);
  ID_ICONNODE = pointer(2);
  ID_IMAGEROOT = pointer(3);
  ID_IMAGENODE = pointer(4);
  ID_LINKROOT = pointer(5);
  ID_LINKNODE = pointer(6);

  ID_PORTALROOT = 0;
  ID_PORTALCATEGORY = 1;
  ID_PORTALLINK = 2;
  ID_PORTALFILLER = 3;

type

  TCallBack = procedure (const msg: string) of object;

  TPortalNodeClass = class of TCollectionItem;
  TPortalNode = class(TCollectionItem)
    public
     kind: integer;
     cat: string;
     pos: integer;
  end;

  TPortalConfig = class
    public
     iconConf: TMemINIFile;
     imageConf: TMemINIFile;
     linkConf: TMemINIFile;
     portalConf: TMemIniFile;
     portalNodes: TCollection;
    public
     constructor Create(fromPath: string);
     procedure UpdateConfig;
     destructor Destroy; override;
  end;

implementation

constructor TPortalConfig.Create(fromPath: string);
begin
  iconConf:= TMemINIFile.Create(fromPath+'\portal\data\TIcon.ini');
  imageConf:= TMemINIFile.Create(fromPath+'\portal\data\TImage.ini');
  linkConf:= TMemINIFile.Create(fromPath+'\portal\data\TLink.ini');
  portalConf:= TMemINIFile.Create(fromPath+'\portal\data\HP\portal.ini');
  portalNodes:= TCollection.Create(TPortalNode);
end;

procedure TPortalConfig.UpdateConfig;
begin
  iconConf.UpdateFile;
  imageConf.UpdateFile;
  linkConf.UpdateFile;
  portalConf.UpdateFile;
end;

destructor TPortalConfig.Destroy;
begin
  portalNodes.Free;
  iconConf.Free;
  imageConf.Free;
  linkConf.Free;
  portalConf.Free;
end;

end.
