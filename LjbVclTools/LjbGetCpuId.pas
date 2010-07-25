unit LjbGetCpuId;

interface

uses
    SysUtils, Classes;

type
    TLjbGetCpuId = class(TComponent)
    private
    { Private declarations }
        strCpuId: string;
    protected
    { Protected declarations }
    public
    { Public declarations }
        constructor Create(AOwner: TComponent); override;
        procedure Loaded; override;
        destructor Destroy; override;
    published
    { Published declarations }
        property GetCPUID: string read strCpuId;
    end;

procedure Register;

implementation
const ID_BIT = $200000; // EFLAGS ID bit
type TCPUID = array[1..4] of Longint;
//--------------------------------------------------

procedure Register;
begin
    RegisterComponents('LjbTools', [TLjbGetCpuId]);
end;
//--------------------------------------------------

constructor TLjbGetCpuId.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);

end;
//--------------------------------------------------

destructor TLjbGetCpuId.Destroy;
begin
    inherited Destroy;
end;
//--------------------------------------------------

function IsCPUID_Available: Boolean; register;
asm
  PUSHFD       {direct access to flags no possible, only via stack}
  POP     EAX     {flags to EAX}
  MOV     EDX,EAX   {save current flags}
  XOR     EAX,ID_BIT {not ID bit}
  PUSH    EAX     {onto stack}
  POPFD        {from stack to flags, with not ID bit}
  PUSHFD       {back to stack}
  POP     EAX     {get back to EAX}
  XOR     EAX,EDX   {check if ID bit affected}
  JZ      @exit    {no, CPUID not availavle}
  MOV     AL,True   {Result=True}
@exit:
end;
//--------------------------------------------------

function GetCPUIDSN: TCPUID; assembler; register;
asm
  PUSH    EBX         {Save affected register}
  PUSH    EDI
  MOV     EDI,EAX     {@Resukt}
  MOV     EAX,1
  DW      $A20F       {CPUID Command}
  STOSD             {CPUID[1]}
  MOV     EAX,EBX
  STOSD               {CPUID[2]}
  MOV     EAX,ECX
  STOSD               {CPUID[3]}
  MOV     EAX,EDX
  STOSD               {CPUID[4]}
  POP     EDI     {Restore registers}
  POP     EBX
end;

//--------------------------------------------------

procedure TLjbGetCpuId.Loaded;
var
    CPUID: TCPUID;
    i: integer;
begin
    if IsCPUID_Available then
        CPUID := GetCPUIDSN
    else
    begin
//ÔçÆÚCPUÎÞID
        CPUID[1] := 1528;
        CPUID[4] := 24682468;
    end;
    strCpuId := IntToHex((CPUID[1] + CPUID[4]), 8);
end;


//--------------------------------------------------

end.

 