
unit LjbDosMove;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  //改变原有的声明方法。
  //原声明方式导致moEnter,moUpDn实际使用中为互斥，而不是共用。
  //增加左右键处理
  TMoveOption = (moEnter,moUpDn,moLeftRight);
  TMoveOptions = set of TMoveOption;
  // 即将移动的时间, OldComp, NewComp代表当前的和即将移到的组件, Down 表示是否已经处理, 为True将中止移动
  TWillMove = procedure( Sender: TObject; OldActiveControl: TWinControl; var Down: Boolean) of object;

  TLjbDosMove = class(TComponent)
  private
    FActive        : boolean;
    FMoved         : Boolean;   // 是否已经移动了
    FOptions       : TMoveOptions;
    FEditNoBeep    : boolean;
    FOwnerKeyDown  : TKeyEvent;
    FOwnerKeyPress : TKeyPressEvent;
    FLastWasEdit   : boolean;
    FOnWillMove    : TWillMove;
  protected
    procedure NewKeyDown(Sender : TObject;var Key : word;Shift : TShiftState);
    procedure NewKeyPress(Sender : Tobject;var Key : char);
  public
    constructor Create(AOwner : TComponent); override;
  published
    property Active : boolean read FActive write FActive 
      default false;
    property Options : TMoveOptions read FOptions write FOptions 
      default [moEnter,moUpDn];
    property EditNoBeep : boolean read FEditNoBeep write FEditNoBeep
      default true;

    property OnWillMove: TWillMove read FOnWillMove write FOnWillMove;
  end;

procedure Register;

implementation

//-----------------------------------------------------------------------------
procedure Register;
begin
  RegisterComponents('LjbTools', [TLjbDosMove]);
end;

//-----------------------------------------------------------------------------
constructor TLjbDosMove.Create(AOwner : TComponent);
var
  Loop : integer;
begin
  // First check to see no other TLjbDosMove exists on the form
  for Loop:=0 to AOwner.ComponentCount-1 do
    if AOwner.Components[Loop] is TLjbDosMove then raise
      EInvalidOperation.Create('TLjbDosMove can have only one instance per form');

  // Create component and set default properties
  inherited Create(AOwner);
  FActive:=false;
  FMoved := False;
  FOptions:=[moEnter];
  FEditNoBeep:=true;
  
  // Intercept with OnKeyDown event and OnKeyPress event of 'Owner'
  (AOwner as TForm).KeyPreview:=true;
  FOwnerKeyDown:=(AOwner as TForm).OnKeyDown;
  (AOwner as TForm).OnKeyDown:=NewKeyDown;
  FOwnerKeyPress:=(AOwner as TForm).OnKeyPress;
  (AOwner as TForm).OnKeyPress:=NewKeyPress;
  
end; // Create

//-----------------------------------------------------------------------------
procedure TLjbDosMove.NewKeyDown(Sender : TObject;var Key : word;
  Shift : TShiftState);
var bIsDown: Boolean;
begin
  FMoved := False;
  // When Shift/Alt/Ctrl Is Down, then cancel Handle
  if FActive and (not((ssShift	in Shift) or (ssAlt	in Shift) or (ssctrl in Shift))) then begin
  
    // true if last active control is TCustomEdit and above
    FLastWasEdit:=(Owner as TForm).ActiveControl is TCustomEdit;

    if (FOptions<>[]) then begin
      bIsDown := False;
      // Handle the specials keys
      if ((Key=VK_DOWN) and (moUpDn in FOptions)) or
         ((Key=VK_RIGHT) and (moLeftRight in FOptions)) or
         ((Key=VK_RETURN) and (moEnter in FOptions)) then begin
        // Handle Will Move Event
        if Assigned(FOnWillMove) then
          FOnWillMove(Sender, (Owner as TForm).ActiveControl, bIsDown);
        // End .
        if not bIsDown then begin
          (Owner as TForm).Perform(WM_NEXTDLGCTL,0,0);
          FMoved := True;
        end;

      end
      else if (Key=VK_LEFT) and (moLeftRight in FOptions) or
              (Key=VK_UP) and (moUpDn in FOptions) then begin
        // Handle Will Move Event
        if Assigned(FOnWillMove) then
          FOnWillMove(Sender, (Owner as TForm).ActiveControl, bIsDown);
        // End .
        if not bIsDown then begin
         (Owner as TForm).Perform(WM_NEXTDLGCTL,1,0);
         FMoved := True;
        end;
      end;
    end; // if Options<>[] ...

  end; // if FActive ...

  // Call owner OnKeyDown if it's assigned
  if assigned(FOwnerKeyDown) then FOwnerKeyDown(Sender,Key,Shift);
end; // NewKeyDown

//-----------------------------------------------------------------------------
procedure TLjbDosMove.NewKeyPress(Sender : TObject;var Key : char);
begin
  if FActive and FMoved then begin
    FMoved := False;
    // Handle 'Enter' key that makes Edits beep
    if FEditNoBeep and FLastWasEdit and (Key=#13) then Key:=#0;
    
  end; // if FActive ...
        
  // Call owner OnKeyPress if it's assigned
  if assigned(FOwnerKeyPress) then FOwnerKeyPress(Sender,Key);
end; // NewKeyPress

end.
