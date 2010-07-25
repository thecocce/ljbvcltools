unit Ping;

{$IFDEF VER80}
// This source file is *NOT* compatible with Delphi 1 because it uses
// Win 32 features.
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils, Classes, Winsock, Icmp;

const
  PingVersion           = 111;
  CopyRight : String    = ' TPing (c) 1997-2000 F. Piette V1.11 ';
  WM_ASYNCGETHOSTBYNAME = WM_USER + 2;

type
  TDnsLookupDone = procedure (Sender: TObject; Error: Word) of object;
  TPingDisplay   = procedure(Sender: TObject; Icmp: TObject; Msg : String) of object;
  TPingReply     = procedure(Sender: TObject; Icmp: TObject; Error : Integer) of object;
  TPingRequest   = procedure(Sender: TObject; Icmp: TObject) of object;
  TPing = class(TComponent)
  private
    FIcmp             : TICMP;
    FWindowHandle     : HWND;
    FDnsLookupBuffer  : array [0..MAXGETHOSTSTRUCT] of char;
    FDnsLookupHandle  : THandle;
    FDnsResult        : String;
    FOnDnsLookupDone  : TDnsLookupDone;
    FOnEchoRequest    : TPingRequest;
    FOnEchoReply      : TPingReply;
    FOnDisplay        : TPingDisplay;
  protected
    procedure   WndProc(var MsgRec: TMessage);
    procedure   WMAsyncGetHostByName(var msg: TMessage); message WM_ASYNCGETHOSTBYNAME;
    procedure   SetAddress(Value : String);
    function    GetAddress : String;
    procedure   SetSize(Value : Integer);
    function    GetSize : Integer;
    procedure   SetTimeout(Value : Integer);
    function    GetTimeout : Integer;
    function    GetReply : TIcmpEchoReply;
    function    GetErrorCode : Integer;
    function    GetErrorString : String;
    function    GetHostName : String;
    function    GetHostIP : String;
    procedure   SetTTL(Value : Integer);
    function    GetTTL : Integer;
    procedure   Setflags(Value : Integer);
    function    Getflags : Integer;
//    procedure   SetOnDisplay(Value : TICMPDisplay);
//    function    GetOnDisplay : TICMPDisplay;
//    procedure   SetOnEchoRequest(Value : TNotifyEvent);
//    function    GetOnEchoRequest : TNotifyEvent;
//    procedure   SetOnEchoReply(Value : TICMPReply);
//    function    GetOnEchoReply : TICMPReply;
    procedure   IcmpEchoReply(Sender: TObject; Error : Integer);
    procedure   IcmpEchoRequest(Sender: TObject);
    procedure   IcmpDisplay(Sender: TObject; Msg: String);
  public
    constructor Create(Owner : TComponent); override;
    destructor  Destroy; override;
    function    Ping : Integer;
    procedure   DnsLookup(HostName : String); virtual;
    procedure   CancelDnsLookup;

    property    Reply       : TIcmpEchoReply read GetReply;
    property    ErrorCode   : Integer        read GetErrorCode;
    property    ErrorString : String         read GetErrorString;
    property    HostName    : String         read GetHostName;
    property    HostIP      : String         read GetHostIP;
    property    Handle      : HWND           read FWindowHandle;
    property    DnsResult   : String         read FDnsResult;
  published
    property    Address     : String         read  GetAddress
                                             write SetAddress;
    property    Size        : Integer        read  GetSize
                                             write SetSize;
    property    Timeout     : Integer        read  GetTimeout
                                             write SetTimeout;
    property    TTL         : Integer        read  GetTTL
                                             write SetTTL;
    property    Flags       : Integer        read  Getflags
                                             write SetFlags;
    property    OnDisplay   : TPingDisplay   read  FOnDisplay
                                             write FOnDisplay;
    property    OnEchoRequest : TPingRequest read  FOnEchoRequest
                                             write FOnEchoRequest;
    property    OnEchoReply   : TPingReply   read  FOnEchoReply
                                             write FOnEchoReply;
    property    OnDnsLookupDone : TDnsLookupDone
                                             read  FOnDnsLookupDone
                                             write FOnDnsLookupDone;
  end;

procedure Register;

implementation


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure Register;
begin
    RegisterComponents('LjbTools', [TLjbPing]);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This function is a callback function. It means that it is called by       }
{ windows. This is the very low level message handler procedure setup to    }
{ handle the message sent by windows (winsock) to handle messages.          }
function XSocketWindowProc(
    ahWnd   : HWND;
    auMsg   : Integer;
    awParam : WPARAM;
    alParam : LPARAM): Integer; stdcall;
var
    Obj    : TPing;
    MsgRec : TMessage;
begin
    { At window creation ask windows to store a pointer to our object       }
    Obj := TPing(GetWindowLong(ahWnd, 0));

    { If the pointer is not assigned, just call the default procedure       }
    if not Assigned(Obj) then
        Result := DefWindowProc(ahWnd, auMsg, awParam, alParam)
    else begin
        { Delphi use a TMessage type to pass paramter to his own kind of    }
        { windows procedure. So we are doing the same...                    }
        MsgRec.Msg    := auMsg;
        MsgRec.wParam := awParam;
        MsgRec.lParam := alParam;
        Obj.WndProc(MsgRec);
        Result := MsgRec.Result;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This global variable is used to store the windows class characteristic    }
{ and is needed to register the window class used by TWSocket               }
var
    XSocketWindowClass: TWndClass = (
        style         : 0;
        lpfnWndProc   : @XSocketWindowProc;
        cbClsExtra    : 0;
        cbWndExtra    : SizeOf(Pointer);
        hInstance     : 0;
        hIcon         : 0;
        hCursor       : 0;
        hbrBackground : 0;
        lpszMenuName  : nil;
        lpszClassName : 'ICSPingWindowClass');


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Allocate a window handle. This means registering a window class the first }
{ time we are called, and creating a new window each time we are called.    }
function XSocketAllocateHWnd(Obj : TObject): HWND;
var
    TempClass       : TWndClass;
    ClassRegistered : Boolean;
begin
    { Check if the window class is already registered                       }
    XSocketWindowClass.hInstance := HInstance;
    ClassRegistered := GetClassInfo(HInstance,
                                    XSocketWindowClass.lpszClassName,
                                    TempClass);
    if not ClassRegistered then begin
       { Not yet registered, do it right now                                }
       Result := Windows.RegisterClass(XSocketWindowClass);
       if Result = 0 then
           Exit;
    end;

    { Now create a new window                                               }
    Result := CreateWindowEx(WS_EX_TOOLWINDOW,
                           XSocketWindowClass.lpszClassName,
                           '',        { Window name   }
                           WS_POPUP,  { Window Style  }
                           0, 0,      { X, Y          }
                           0, 0,      { Width, Height }
                           0,         { hWndParent    }
                           0,         { hMenu         }
                           HInstance, { hInstance     }
                           nil);      { CreateParam   }

    { if successfull, the ask windows to store the object reference         }
    { into the reserved byte (see RegisterClass)                            }
    if (Result <> 0) and Assigned(Obj) then
        SetWindowLong(Result, 0, Integer(Obj));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Free the window handle                                                    }
procedure XSocketDeallocateHWnd(Wnd: HWND);
begin
    DestroyWindow(Wnd);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPing.WndProc(var MsgRec: TMessage);
begin
     with MsgRec do begin
         if Msg = WM_ASYNCGETHOSTBYNAME then
             WMAsyncGetHostByName(MsgRec)
         else
             Result := DefWindowProc(Handle, Msg, wParam, lParam);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPing.WMAsyncGetHostByName(var msg: TMessage);
var
    Phe     : Phostent;
    IPAddr  : TInAddr;
    Error   : Word;
begin
    if msg.wParam <> LongInt(FDnsLookupHandle) then
        Exit;
    FDnsLookupHandle := 0;
    Error := Msg.LParamHi;
    if Error = 0 then begin
        Phe        := PHostent(@FDnsLookupBuffer);
        IPAddr     := PInAddr(Phe^.h_addr_list^)^;
        FDnsResult := StrPas(inet_ntoa(IPAddr));
    end;
    if Assigned(FOnDnsLookupDone) then
        FOnDnsLookupDone(Self, Error);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TPing.Create(Owner : TComponent);
begin
    Inherited Create(Owner);
    FIcmp               := TICMP.Create;
    FIcmp.OnDisplay     := IcmpDisplay;
    FIcmp.OnEchoRequest := IcmpEchoRequest;
    FIcmp.OnEchoReply   := IcmpEchoReply;
    { Delphi 32 bits has threads and VCL is not thread safe.                }
    { We need to do our own way to be thread safe.                          }
    FWindowHandle := XSocketAllocateHWnd(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TPing.Destroy;
begin
    CancelDnsLookup;                 { Cancel any pending dns lookup      }
    XSocketDeallocateHWnd(FWindowHandle);
    if Assigned(FIcmp) then begin
        FIcmp.Destroy;
        FIcmp := nil;
    end;
    inherited Destroy;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPing.IcmpDisplay(Sender: TObject; Msg: String);
begin
    if Assigned(FOnDisplay) then
        FOnDisplay(Self, Sender, Msg);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPing.IcmpEchoReply(Sender: TObject; Error : Integer);
begin
    if Assigned(FOnEchoReply) then
        FOnEchoReply(Self, Sender, Error);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPing.IcmpEchoRequest(Sender: TObject);
begin
    if Assigned(FOnEchoRequest) then
        FOnEchoRequest(Self, Sender);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPing.Ping : Integer;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.Ping
    else
        Result := 0;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPing.CancelDnsLookup;
begin
    if FDnsLookupHandle = 0 then
        Exit;
    if WSACancelAsyncRequest(FDnsLookupHandle) <> 0 then
        raise Exception.CreateFmt('WSACancelAsyncRequest failed, error #%d',
                               [WSAGetLastError]);
    FDnsLookupHandle := 0;
    if Assigned(FOnDnsLookupDone) then
        FOnDnsLookupDone(Self, WSAEINTR);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPing.DnsLookup(HostName : String);
var
    IPAddr  : TInAddr;
begin
    { Cancel any pending lookup }
    if FDnsLookupHandle <> 0 then
        WSACancelAsyncRequest(FDnsLookupHandle);

    FDnsResult := '';

    IPAddr.S_addr := Inet_addr(@HostName[1]);
    if IPAddr.S_addr <> u_long(INADDR_NONE) then begin
        FDnsResult := StrPas(inet_ntoa(IPAddr));
        if Assigned(FOnDnsLookupDone) then
            FOnDnsLookupDone(Self, 0);
        Exit;
    end;

    FDnsLookupHandle := WSAAsyncGetHostByName(FWindowHandle,
                                              WM_ASYNCGETHOSTBYNAME,
                                              @HostName[1],
                                              @FDnsLookupBuffer,
                                              SizeOf(FDnsLookupBuffer));
    if FDnsLookupHandle = 0 then
        raise Exception.CreateFmt(
                  '%s: can''t start DNS lookup, error #%d',
                  [HostName, WSAGetLastError]);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPing.SetAddress(Value : String);
begin
    if Assigned(FIcmp) then
        FIcmp.Address := Value;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPing.GetAddress : String;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.Address
    else
        Result := '';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPing.SetSize(Value : Integer);
begin
    if Assigned(FIcmp) then
        FIcmp.Size := Value;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPing.GetSize : Integer;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.Size
    else
        Result := 0;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPing.SetTimeout(Value : Integer);
begin
    if Assigned(FIcmp) then
        FIcmp.Timeout := Value;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPing.GetTimeout : Integer;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.Timeout
    else
        Result := 0;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPing.SetTTL(Value : Integer);
begin
    if Assigned(FIcmp) then
        FIcmp.TTL := Value;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPing.GetTTL : Integer;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.TTL
    else
        Result := 0;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPing.SetFlags(Value : Integer);
begin
    if Assigned(FIcmp) then
        FIcmp.Flags := Value;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPing.GetFlags : Integer;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.flags
    else
        Result := 0;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPing.GetReply : TIcmpEchoReply;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.Reply
    else
        FillChar(Result, SizeOf(Result), 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPing.GetErrorCode : Integer;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.ErrorCode
    else
        Result := -1;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPing.GetErrorString : String;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.ErrorString
    else
        Result := '';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPing.GetHostName : String;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.HostName
    else
        Result := '';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPing.GetHostIP : String;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.HostIP
    else
        Result := '';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{procedure TPing.SetOnDisplay(Value : TICMPDisplay);
begin
    if Assigned(FIcmp) then
        FIcmp.OnDisplay := Value;
end;
}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{function TPing.GetOnDisplay : TICMPDisplay;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.OnDisplay
    else
        Result := nil;
end;
}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{procedure TPing.SetOnEchoRequest(Value : TNotifyEvent);
begin
    if Assigned(FIcmp) then
        FIcmp.OnEchoRequest := Value;
end;
}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{function TPing.GetOnEchoRequest : TNotifyEvent;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.OnEchoRequest
    else
        Result := nil;
end;
}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{procedure TPing.SetOnEchoReply(Value : TICMPReply);
begin
    if Assigned(FIcmp) then
        FIcmp.OnEchoReply := Value;
end;
}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{function TPing.GetOnEchoReply : TICMPReply;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.OnEchoReply
    else
        Result := nil;
end;
}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

end.
 
 
来自：didaland, 时间：2001-11-8 22:57:00, ID：717853 
多谢高手!
 
 
来自：didaland, 时间：2001-11-8 23:02:00, ID：717857 
还差一个Icmp.pas文件。
 
 
来自：DelphiFish, 时间：2001-11-8 23:07:00, ID：717862 
unit Icmp;

interface

{$IFDEF VER80}
// This source file is *NOT* compatible with Delphi 1 because it uses
// Win 32 features.
{$ENDIF}

uses
  Windows, SysUtils, Classes, WinSock;

const
  IcmpVersion = 102;
  IcmpDLL     = 'icmp.dll';

  // IP status codes returned to transports and user IOCTLs.
  IP_SUCCESS                  = 0;
  IP_STATUS_BASE              = 11000;
  IP_BUF_TOO_SMALL            = (IP_STATUS_BASE + 1);
  IP_DEST_NET_UNREACHABLE     = (IP_STATUS_BASE + 2);
  IP_DEST_HOST_UNREACHABLE    = (IP_STATUS_BASE + 3);
  IP_DEST_PROT_UNREACHABLE    = (IP_STATUS_BASE + 4);
  IP_DEST_PORT_UNREACHABLE    = (IP_STATUS_BASE + 5);
  IP_NO_RESOURCES             = (IP_STATUS_BASE + 6);
  IP_BAD_OPTION               = (IP_STATUS_BASE + 7);
  IP_HW_ERROR                 = (IP_STATUS_BASE + 8);
  IP_PACKET_TOO_BIG           = (IP_STATUS_BASE + 9);
  IP_REQ_TIMED_OUT            = (IP_STATUS_BASE + 10);
  IP_BAD_REQ                  = (IP_STATUS_BASE + 11);
  IP_BAD_ROUTE                = (IP_STATUS_BASE + 12);
  IP_TTL_EXPIRED_TRANSIT      = (IP_STATUS_BASE + 13);
  IP_TTL_EXPIRED_REASSEM      = (IP_STATUS_BASE + 14);
  IP_PARAM_PROBLEM            = (IP_STATUS_BASE + 15);
  IP_SOURCE_QUENCH            = (IP_STATUS_BASE + 16);
  IP_OPTION_TOO_BIG           = (IP_STATUS_BASE + 17);
  IP_BAD_DESTINATION          = (IP_STATUS_BASE + 18);

  // status codes passed up on status indications.
  IP_ADDR_DELETED             = (IP_STATUS_BASE + 19);
  IP_SPEC_MTU_CHANGE          = (IP_STATUS_BASE + 20);
  IP_MTU_CHANGE               = (IP_STATUS_BASE + 21);

  IP_GENERAL_FAILURE          = (IP_STATUS_BASE + 50);

  MAX_IP_STATUS               = IP_GENERAL_FAILURE;

  IP_PENDING                  = (IP_STATUS_BASE + 255);

  // IP header flags
  IP_FLAG_DF                  = $02;         // Don't fragment this packet.

  // IP Option Types
  IP_OPT_EOL                  = $00;         // End of list option
  IP_OPT_NOP                  = $01;         // No operation
  IP_OPT_SECURITY             = $82;         // Security option.
  IP_OPT_LSRR                 = $83;         // Loose source route.
  IP_OPT_SSRR                 = $89;         // Strict source route.
  IP_OPT_RR                   = $07;         // Record route.
  IP_OPT_TS                   = $44;         // Timestamp.
  IP_OPT_SID                  = $88;         // Stream ID (obsolete)
  MAX_OPT_SIZE                = $40;

type
  // IP types
  TIPAddr   = LongInt;   // An IP address.
  TIPMask   = LongInt;   // An IP subnet mask.
  TIPStatus = LongInt;   // Status code returned from IP APIs.

  PIPOptionInformation = ^TIPOptionInformation;
  TIPOptionInformation = packed record
     TTL:         Byte;      // Time To Live (used for traceroute)
     TOS:         Byte;      // Type Of Service (usually 0)
     Flags:       Byte;      // IP header flags (usually 0)
     OptionsSize: Byte;      // Size of options data (usually 0, max 40)
     OptionsData: PChar;     // Options data buffer
  end;

  PIcmpEchoReply = ^TIcmpEchoReply;
  TIcmpEchoReply = packed record
     Address:       TIPAddr;              // Replying address
     Status:        DWord;                // IP status value
     RTT:           DWord;                // Round Trip Time in milliseconds
     DataSize:      Word;                 // Reply data size
     Reserved:      Word;                 // Reserved
     Data:          Pointer;              // Pointer to reply data buffer
     Options:       TIPOptionInformation; // Reply options
  end;

  // IcmpCreateFile:
  //     Opens a handle on which ICMP Echo Requests can be issued.
  // Arguments:
  //     None.
  // Return Value:
  //     An open file handle or INVALID_HANDLE_VALUE. Extended error information
  //     is available by calling GetLastError().
  TIcmpCreateFile  = function: THandle; stdcall;

  // IcmpCloseHandle:
  //     Closes a handle opened by ICMPOpenFile.
  // Arguments:
  //     IcmpHandle  - The handle to close.
  // Return Value:
  //     TRUE if the handle was closed successfully, otherwise FALSE. Extended
  //     error information is available by calling GetLastError().
  TIcmpCloseHandle = function(IcmpHandle: THandle): Boolean; stdcall;

  // IcmpSendEcho:
  //     Sends an ICMP Echo request and returns one or more replies. The
  //     call returns when the timeout has expired or the reply buffer
  //     is filled.
  // Arguments:
  //     IcmpHandle         - An open handle returned by ICMPCreateFile.
  //     DestinationAddress - The destination of the echo request.
  //     RequestData        - A buffer containing the data to send in the
  //                          request.
  //     RequestSize        - The number of bytes in the request data buffer.
  //     RequestOptions     - Pointer to the IP header options for the request.
  //                          May be NULL.
  //     ReplyBuffer        - A buffer to hold any replies to the request.
  //                          On return, the buffer will contain an array of
  //                          ICMP_ECHO_REPLY structures followed by options
  //                          and data. The buffer should be large enough to
  //                          hold at least one ICMP_ECHO_REPLY structure
  //                          and 8 bytes of data - this is the size of
  //                          an ICMP error message.
  //     ReplySize          - The size in bytes of the reply buffer.
  //     Timeout            - The time in milliseconds to wait for replies.
  // Return Value:
  //     Returns the number of replies received and stored in ReplyBuffer. If
  //     the return value is zero, extended error information is available
  //     via GetLastError().
  TIcmpSendEcho    = function(IcmpHandle:          THandle;
                              DestinationAddress:  TIPAddr;
                              RequestData:         Pointer;
                              RequestSize:         Word;
                              RequestOptions:      PIPOptionInformation;
                              ReplyBuffer:         Pointer;
                              ReplySize:           DWord;
                              Timeout:             DWord
                             ): DWord; stdcall;

  // Event handler type declaration for TICMP.OnDisplay event.
  TICMPDisplay = procedure(Sender: TObject; Msg : String) of object;
  TICMPReply   = procedure(Sender: TObject; Error : Integer) of object;

  // The object wich encapsulate the ICMP.DLL
  TICMP = class(TObject)
  private
    hICMPdll :        HModule;                    // Handle for ICMP.DLL
    IcmpCreateFile :  TIcmpCreateFile;
    IcmpCloseHandle : TIcmpCloseHandle;
    IcmpSendEcho :    TIcmpSendEcho;
    hICMP :           THandle;                    // Handle for the ICMP Calls
    FReply :          TIcmpEchoReply;             // ICMP Echo reply buffer
    FAddress :        String;                     // Address given
    FHostName :       String;                     // Dotted IP of host (output)
    FHostIP :         String;                     // Name of host      (Output)
    FIPAddress :      TIPAddr;                    // Address of host to contact
    FSize :           Integer;                    // Packet size (default to 56)
    FTimeOut :        Integer;                    // Timeout (default to 4000mS)
    FTTL :            Integer;                    // Time To Live (for send)
    FFlags :          Integer;                    // Options flags
    FOnDisplay :      TICMPDisplay;               // Event handler to display
    FOnEchoRequest :  TNotifyEvent;
    FOnEchoReply :    TICMPReply;
    FLastError :      DWORD;                      // After sending ICMP packet
    FAddrResolved :   Boolean;
    procedure ResolveAddr;
  public
    constructor Create; virtual;
    destructor  Destroy; override;
    function    Ping : Integer;
    procedure   SetAddress(Value : String);
    function    GetErrorString : String;

    property Address       : String         read  FAddress   write SetAddress;
    property Size          : Integer        read  FSize      write FSize;
    property Timeout       : Integer        read  FTimeout   write FTimeout;
    property Reply         : TIcmpEchoReply read  FReply;
    property TTL           : Integer        read  FTTL       write FTTL;
    Property Flags         : Integer        read  FFlags     write FFlags;
    property ErrorCode     : DWORD          read  FLastError;
    property ErrorString   : String         read  GetErrorString;
    property HostName      : String         read  FHostName;
    property HostIP        : String         read  FHostIP;
    property OnDisplay     : TICMPDisplay   read  FOnDisplay write FOnDisplay;
    property OnEchoRequest : TNotifyEvent   read  FOnEchoRequest
                                            write FOnEchoRequest;
    property OnEchoReply   : TICMPReply     read  FOnEchoReply
                                            write FOnEchoReply;
  end;

  TICMPException = class(Exception);

implementation

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TICMP.Create;
var
    WSAData: TWSAData;
begin
    hICMP    := INVALID_HANDLE_VALUE;
    FSize    := 56;
    FTTL     := 64;
    FTimeOut := 4000;

    // initialise winsock
    if WSAStartup($101, WSAData) <> 0 then
        raise TICMPException.Create('Error initialising Winsock');

    // register the icmp.dll stuff
    hICMPdll := LoadLibrary(icmpDLL);
    if hICMPdll = 0 then
        raise TICMPException.Create('Unable to register ' + icmpDLL);

    @ICMPCreateFile  := GetProcAddress(hICMPdll, 'IcmpCreateFile');
    @IcmpCloseHandle := GetProcAddress(hICMPdll, 'IcmpCloseHandle');
    @IcmpSendEcho    := GetProcAddress(hICMPdll, 'IcmpSendEcho');

    if (@ICMPCreateFile = Nil) or
       (@IcmpCloseHandle = Nil) or
       (@IcmpSendEcho = Nil) then
          raise TICMPException.Create('Error loading dll functions');

    hICMP := IcmpCreateFile;
    if hICMP = INVALID_HANDLE_VALUE then
        raise TICMPException.Create('Unable to get ping handle');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TICMP.Destroy;
begin
    if hICMP <> INVALID_HANDLE_VALUE then
        IcmpCloseHandle(hICMP);
    if hICMPdll <> 0 then
        FreeLibrary(hICMPdll);
    WSACleanup;
    inherited Destroy;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function MinInteger(X, Y: Integer): Integer;
begin
    if X >= Y then
        Result := Y
    else
        Result := X;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TICMP.ResolveAddr;
var
    Phe : PHostEnt;             // HostEntry buffer for name lookup
begin
    // Convert host address to IP address
    FIPAddress := inet_addr(PChar(FAddress));
    if FIPAddress <> LongInt(INADDR_NONE) then
        // Was a numeric dotted address let it in this format
        FHostName := FAddress
    else begin
        // Not a numeric dotted address, try to resolve by name
        Phe := GetHostByName(PChar(FAddress));
        if Phe = nil then begin
            FLastError := GetLastError;
            if Assigned(FOnDisplay) then
                FOnDisplay(Self, 'Unable to resolve ' + FAddress);
            Exit;
        end;

        FIPAddress := longint(plongint(Phe^.h_addr_list^)^);
        FHostName  := Phe^.h_name;
    end;

    FHostIP       := StrPas(inet_ntoa(TInAddr(FIPAddress)));
    FAddrResolved := TRUE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TICMP.SetAddress(Value : String);
begin
    // Only change if needed (could take a long time)
    if FAddress = Value then
        Exit;
    FAddress      := Value;
    FAddrResolved := FALSE;
//    ResolveAddr;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TICMP.GetErrorString : String;
begin
    case FLastError of
    IP_SUCCESS:               Result := 'No error';
    IP_BUF_TOO_SMALL:         Result := 'Buffer too small';
    IP_DEST_NET_UNREACHABLE:  Result := 'Destination network unreachable';
    IP_DEST_HOST_UNREACHABLE: Result := 'Destination host unreachable';
    IP_DEST_PROT_UNREACHABLE: Result := 'Destination protocol unreachable';
    IP_DEST_PORT_UNREACHABLE: Result := 'Destination port unreachable';
    IP_NO_RESOURCES:          Result := 'No resources';
    IP_BAD_OPTION:            Result := 'Bad option';
    IP_HW_ERROR:              Result := 'Hardware error';
    IP_PACKET_TOO_BIG:        Result := 'Packet too big';
    IP_REQ_TIMED_OUT:         Result := 'Request timed out';
    IP_BAD_REQ:               Result := 'Bad request';
    IP_BAD_ROUTE:             Result := 'Bad route';
    IP_TTL_EXPIRED_TRANSIT:   Result := 'TTL expired in transit';
    IP_TTL_EXPIRED_REASSEM:   Result := 'TTL expired in reassembly';
    IP_PARAM_PROBLEM:         Result := 'Parameter problem';
    IP_SOURCE_QUENCH:         Result := 'Source quench';
    IP_OPTION_TOO_BIG:        Result := 'Option too big';
    IP_BAD_DESTINATION:       Result := 'Bad Destination';
    IP_ADDR_DELETED:          Result := 'Address deleted';
    IP_SPEC_MTU_CHANGE:       Result := 'Spec MTU change';
    IP_MTU_CHANGE:            Result := 'MTU change';
    IP_GENERAL_FAILURE:       Result := 'General failure';
    IP_PENDING:               Result := 'Pending';
    else
        Result := 'ICMP error #' + IntToStr(FLastError);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TICMP.Ping : Integer;
var
  BufferSize:        Integer;
  pReqData, pData:   Pointer;
  pIPE:              PIcmpEchoReply;       // ICMP Echo reply buffer
  IPOpt:             TIPOptionInformation; // IP Options for packet to send
  Msg:               String;
begin
    Result     := 0;
    FLastError := 0;

    if not FAddrResolved then
        ResolveAddr;

    if FIPAddress = LongInt(INADDR_NONE) then begin
        FLastError := IP_BAD_DESTINATION;
        if Assigned(FOnDisplay) then
            FOnDisplay(Self, 'Invalid host address');
        Exit;
    end;

    // Allocate space for data buffer space
    BufferSize := SizeOf(TICMPEchoReply) + FSize;
    GetMem(pReqData, FSize);
    GetMem(pData,    FSize);
    GetMem(pIPE,     BufferSize);

    try
        // Fill data buffer with some data bytes
        FillChar(pReqData^, FSize, $20);
        Msg := 'Pinging from Delphi code written by F. Piette';
        Move(Msg[1], pReqData^, MinInteger(FSize, Length(Msg)));

        pIPE^.Data := pData;
        FillChar(pIPE^, SizeOf(pIPE^), 0);

        if Assigned(FOnEchoRequest) then
            FOnEchoRequest(Self);

        FillChar(IPOpt, SizeOf(IPOpt), 0);
        IPOpt.TTL   := FTTL;
        IPOpt.Flags := FFlags;
        Result      := IcmpSendEcho(hICMP, FIPAddress, pReqData, FSize,
                                    @IPOpt, pIPE, BufferSize, FTimeOut);
        FLastError  := GetLastError;
        FReply      := pIPE^;

        if Assigned(FOnEchoReply) then
            FOnEchoReply(Self, Result);
    finally
        // Free those buffers
        FreeMem(pIPE);
        FreeMem(pData);
        FreeMem(pReqData);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

end.
 
 
