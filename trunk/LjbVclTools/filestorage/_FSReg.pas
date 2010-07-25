{*******************************************************************************

  FILE: _FSReg.pas - Components Registration and Property Editors.

  Copyright (c) 1998-2004 UtilMind Solutions
  All rights reserved.
  E-Mail: info@utilmind.com
  WWW: http://www.utilmind.com, http://www.appcontrols.com

  The entire contents of this file is protected by International Copyright
Laws. Unauthorized reproduction, reverse-engineering, and distribution of all
or any portion of the code contained in this file is strictly prohibited and
may result in severe civil and criminal penalties and will be prosecuted to
the maximum extent possible under the law.

  Restrictions

  The source code contained within this file and all related files or any
portion of its contents shall at no time be copied, transferred, sold,
distributed, or otherwise made available to other individuals without express
written consent and permission from the UtilMind Solutions.

  Consult the End User License Agreement (EULA) for information on additional
restrictions.

*******************************************************************************}
{$I fsDefines.inc}

unit _FSReg;

interface

procedure Register;

implementation

uses Windows, Classes, Controls, Forms, Dialogs, SysUtils,
     {$IFDEF D6}
     DesignIntf, DesignEditors,
     {$ELSE}
     DsgnIntf,
     {$ENDIF}
     FileStorage, WavPlayer, FileStorageEditor;

type
{*******************************************************************************
  StoredFiles property editor for FileStorage component
*******************************************************************************}
 { TStoredFilesProperty }
 TStoredFilesProperty = class(TPropertyEditor)
 public
   procedure Edit; override;
   function GetValue: String; override;
   function GetAttributes: TPropertyAttributes; override;
 end;

{*******************************************************************************
  StoredFiles component editor for FileStorage component
*******************************************************************************}
 { TFileStorageCompEditor }
 TFileStorageCompEditor = class(TComponentEditor)
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer): string; override;
  end;

{*******************************************************************************
  WaveFile PROPERTY editor for WavPlayer
*******************************************************************************}
 { TWavPlayerProperty }
  TWavPlayerWavFileProperty = class(TClassProperty)
  public
    function GetValue: String; override;
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

{*******************************************************************************
  WavFile COMPONENT editor for WavPlayer
*******************************************************************************}
 { TWavPlayerCompEditor }
  TWavPlayerCompEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer): String; override;
  end;


{ *** implementation for property editors *** }


{ StoredFiles Property Editor }
procedure TStoredFilesProperty.Edit;
begin
  ShowFileStorageDesigner(Designer, TFileStorage(GetComponent(0)));
end;

function TStoredFilesProperty.GetValue: String;
begin
  if TFileStorage(GetComponent(0)).Files.Count = 0 then
    Result := '(None)'
  else
    Result := '(TStoredFiles)';
end;

function TStoredFilesProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

{ acFileStorage Component Editor }
procedure TFileStorageCompEditor.ExecuteVerb(Index: Integer);
begin
  if Index = GetVerbCount - 1 then
    ShowFileStorageDesigner(Designer, TFileStorage(Component))
  else inherited ExecuteVerb(Index);
end;

function TFileStorageCompEditor.GetVerb(Index: Integer): String;
begin
  if Index = GetVerbCount - 1 then
    Result := '&Files Designer...'
  else
    Result := inherited GetVerb(Index);
end;

function TFileStorageCompEditor.GetVerbCount: Integer;
begin
  Result := inherited GetVerbCount + 1;
end;


{ TWavPlayerWavFileProperty Editor }
function TWavPlayerWavFileProperty.GetValue: String;
var
  WaveSound: TStoredFile;
begin
  WaveSound := TWavPlayer(GetComponent(0)).WaveSound;
  if WaveSound.Data.Memory = nil then
    Result := '(None)'
  else
    Result := '(WAV Sound)'
end;

function TWavPlayerWavFileProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TWavPlayerWavFileProperty.Edit;
var
  Dialog: TOpenDialog;
  WaveSound: TStoredFile;
begin
  WaveSound := TWavPlayer(GetComponent(0)).WaveSound;

  Dialog := TOpenDialog.Create(Application);
  with Dialog do
  try
    FileName   := WaveSound.FileName;
    InitialDir := ExtractFilePath(FileName);
    FileName   := ExtractFileName(FileName);
    Filter     := 'WAV files (*.wav)|*.wav|All files (*.*)|*.*';
    Options    := Options + [ofHideReadOnly];
    if Execute then
     begin
      WaveSound.Upload(FileName);
      TWavPlayer(GetComponent(0)).SoundType := stCustom;
      Designer.Modified;
     end;
  finally
    Free;
  end;
end;


{ TWavPlayerEditor }
procedure TWavPlayerCompEditor.ExecuteVerb(Index: Integer);
var
  Dialog: TOpenDialog;
  WaveSound: TStoredFile;
begin
  if Index = GetVerbCount - 3 then
    TWavPlayer(Component).Play
  else
    if Index = GetVerbCount - 1 then
     begin
      WaveSound := TWavPlayer(Component).WaveSound;

      Dialog := TOpenDialog.Create(Application);
      with Dialog do
      try
        FileName   := WaveSound.FileName;
        InitialDir := ExtractFilePath(FileName);
        FileName   := ExtractFileName(FileName);
        Filter     := 'WAV files (*.wav)|*.wav|All files (*.*)|*.*';
        Options    := Options + [ofHideReadOnly];
        if Execute then
         begin
          WaveSound.Upload(FileName);
          TWavPlayer(Component).SoundType := stCustom;
          Designer.Modified;
         end;
      finally
        Free;
      end;
     end
    else inherited ExecuteVerb(Index);
end;

function TWavPlayerCompEditor.GetVerbCount: Integer;
begin
  Result := inherited GetVerbCount + 3;
end;

function TWavPlayerCompEditor.GetVerb(Index: Integer): String;
begin
  if Index = GetVerbCount - 3 then
    Result := '&Test!'
  else
    if Index = GetVerbCount - 2 then
      Result := '-'
    else
      if Index = GetVerbCount - 1 then
        Result := '&Upload WAV Sound...'
      else
        Result := inherited GetVerb(Index);
end;


procedure Register;
begin
  RegisterComponents('LjbTools', [TFileStorage, TWavPlayer]);

  RegisterComponentEditor(TFileStorage, TFileStorageCompEditor);
  RegisterComponentEditor(TWavPlayer, TWavPlayerCompEditor);
  RegisterPropertyEditor(TypeInfo(TStoredFiles), TFileStorage, 'Files', TStoredFilesProperty);
  RegisterPropertyEditor(TypeInfo(TStoredFile), TWavPlayer, 'WaveSound', TWavPlayerWavFileProperty);
end;

end.
