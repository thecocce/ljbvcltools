unit LjbHddInfo;

(*

TLjbHddInfo 


--------------------------------------------------------------------------------

TLjbHddInfo - nonvisual Delphi component provided low level information about IDE, ATAPI and SCSI devices
Version: 2.1 (2006 July 19)


Supports both Win9x and WinNT platforms, provided information about IDE and ATAPI devices, also provided information about SCSI devices 

Provided information: 

device type 
Model sting 
Firmware revision 
Serial number 
For IDE drives also: 
drive geometry (cylinders, heads, sectors per track) 
LBA sectors count 
drive size (nonformatted) 
controller buffer size 

--------------------------------------------------------------------------------
Description 
Properties: 

property HDDType : TDriveType; - Device type (Fixed, Removable, CD-Rom, Unknown, Tape, Optical disk, Array device). 

TDriveType = (dtFixed, dtRemovable, dtCDROM, dtUnknown, dtTape, dtOptical, dtArray); 

property Serial : string; - Serial number. 

property Revision : string; - Firmware revision. 

property Model : string; - Model string. 

property CylsTotal : word; - Cylinders (IDE only). 

property HeadTotal : word; - Heads (IDE only). 

property BPT : word; - Bytes per track (IDE only). 

property BPS : word; - Bytes per sector (IDE only). 

property SPT : word; - Sectors per track (IDE only). 

property BufSize : DWord; - Controller buffer size (IDE only). 

property ECC : Word; - ECC code (IDE only). 

property LBASectors: dword; - LBA sectors count (IDE only). 

property Size : int64; - Nonformatted disk size (IDE only). 

property Vendor : TVendor; - Vendor data (IDE only). 

TVendor = array[0..2] of word; 

property isIDE: boolean; - Specifies whether specified device is IDE device. 

property ScsiInfo : TScsiInfo; - Holds information about Scsi device. 

TScsiInfo = record
 PathId, - Indicates the number of the bus the device is located on.
 TargetId, - Indicates the number of the device on the bus. 
 Lun : byte; - Indicates the logical unit number of the logical unit on the target device.
 DeviceClaimed : boolean; - When true, indicates that the device has been claimed by a class driver. 
 HDDType : TDriveType; - Indicates device type;
 Data : string; - Contains device info (as a rule the name and first several bytes of firmware revision).
end; 

property ScsiPort : integer; - Specifies Scsi port number to get information. 

property ScsiBus : integer; - Specifies Scsi bus number to get information (should be from 0 to ScsiBusCount-1). 

property ScsiDevice : integer; - Specifies Scsi device number to get information (should be from 0 to ScsiDevCount-1). 

property ScsiBusCount : word; - Contains number of buses for specified Scsi port. 

property ScsiDevCount : word; - Contains number of devices for specified Scsi bus. 

property isNT : boolean; - Specifies whether OS is WinNT. 

Published properties: 

property Drive : TDrive; - Specifies drive to get information about. On change, calls GetInfo procedure. 

TDrive = (dPrimaryMaster, dPrimarySlave, dSecondaryMaster, dSecondarySlave, dTertiaryMaster, dTertiarySlave, dQuaternaryMaster, dQuaternarySlave); 

property DeviceName : string; - Specifies device name (for gimByName retrieving information method). 

property Method : TGetInfoMethod; - Specifies retrieving information method. 

TGetInfoMethod = (gimAuto, gimNT, gimScsi, gim9x, gimByName, gimASPI); 

gimAuto: determine OS, for Win9x proceed with gim9x, for WinNT with gimScsi 
gimNT: use DeviceIoControl and PhysicalDrive device to get information (WinNT platform only). Requires admin rights. 
Important: gimNT method deal with logical numbering of physical drives regardless of IDE interface, i.e. dPrimaryMaster corresponds to PhysicalDrive0, dPrimarySlave to PhysicalDrive1 etc. For instance if you system has one drive connected as Secondary Master, set Drive property to dPrimaryMaster to get info about this drive. 

gimNT method useful when you need to obtain information about first (second, etc.) drive in system and don't want to puzzle over IDE device numbering. If you need to obtain information about specific IDE port use gimScsi instead.


gimScsi: use Scsi miniport driver (WinNT platform only). Do not require admin rights. 
gim9x: use direct port access (Win9x platform only). 
gimByName: use DeviceIoControl to send SCSIOP_INQUIRY command to the device (WinNT platform only). Requires admin rights. Support IDE, SCSI and ATAPI devices. You can use device name (e.g. "PhisicalDrive0", "Tape1", "CDROM3") or logical disc name (e.g. "C:"). 
gimASPI : use ASPI API to get info about devices. ASPI is native for Win9x. On WinNT it is possible to use wnaspi32.dll delivered with Nero. 
property CanonicalScsiAddressing : boolean; - For gimASPI. If true, LjbHddInfo uses predefined addresses for IDE devices ((0,0,0) - for Primary Master, (0,1,0) - for Primary Slave, (1,0,0) - for Secondary Master and so on.). If false, LjbHddInfo will treat Drive property as the number of found device (dPrimaryMaster - first found device, dPrimarySlave - second and so on). 

Procedures: 

procedure GetInfo; - retrieves information about drive, specified by Drive property. On error raises exception. 


--------------------------------------------------------------------------------
How to use 
Simply set Drive or DeviceName property to desirable value. Also you can use GetInfo procedure. Use try-except block to catch exceptions. See demo. 

To scan Scsi bus: 

Set ScsiPort to desirable value. TLjbHddInfo inquires Scsi port and sets ScsiBusCount. 
Set ScsiBus to value from 0 to ScsiBusCount-1. TLjbHddInfo inquire Scsi bus and sets ScsiDevCount 
Set ScsiDevice to value from 0 to ScsiDevCount-1. TLjbHddInfo inquires Scsi bus and returns information about device in ScisiInfo property. 
Note: ScsiPort=0 and ScsiPort=1 correspond to IDE Primary and IDE Secondary controllers. 


--------------------------------------------------------------------------------
History 
Version 2.1: Added ASPI support (new get info method gimASPI). Many thanks to Bill Mudd (mcmudd@earthlink.net). 
Version 2.0: Added Scsi bus scan features. gimScsi now returns info about ATAPI devices. gimAuto behavior changed (due to Vassilis Papanikolaou (billy@ee.auth.gr) bug report), see note about gimNT. Some minor bugs fixed. 
Version 1.22: D5 compatibility added (thanks to Marcelo Castro abusemg-jan@yahoo.com.br) 
Version 1.21: Some bugs removed. 
Version 1.2: Added new method gimByName (NT only), provided info about IDE, SCSI and ATAPI devices 
Version 1.1: Added ATAPI support for Win9x procedure 
Version 1.0: First working version 

--------------------------------------------------------------------------------
Author 
Artem V. Parlyuk, e-mail:artsoft@nm.ru, http://artsoft.nm.ru 

Partially based on Lynn McGuire C++ source (diskid32.cpp) 

CallRing0 function based on Andrey Jdanov (rivitna@mailru.com) asm source (Ring0.asm) 


--------------------------------------------------------------------------------
License and disclaimer agreement 
IMPORTANT - READ CAREFULLY 

This license and disclaimer statement constitutes a legal agreement ("License Agreement") between you (either as an individual or a single entity) and Artem Parlyuk (the "Author"), for this software product in this particular case TLjbHddInfo Delphi component ("Software"), including any software, media, and accompanying on-line or printed documentation. 

BY DOWNLOADING, INSTALLING, COPYING, OR OTHERWISE USING THE SOFTWARE, YOU AGREE TO BE BOUND BY ALL OF THE TERMS AND CONDITIONS OF THIS LICENSE AND DISCLAIMER AGREEMENT. If you do not agree with the terms and conditions of this agreement, you must promptly cease all use of the software and destroy all copies of this software and all of its component parts in your possession or under your control. 

This Software is owned by Author and is protected by copyright law and international copyright treaty. 

This Software is freeware. You are granted the permission to use Software in your own applications for private purposes. You are granted the permission to use Software in your own applications for commercial purposes, provided your software contains the copyright notice "TLjbHddInfo Delphi component Copyright (c) by Artem Parlyuk" and link to the Author site (http://artsoft.nm.ru) and Author e-mail (mailto:artsoft@nm.ru). 

You can freely distribute copies of the main archive as long as no alterations are made to the contents and no charge is raised except a reasonable fee for distributing costs. You may not remove copyright notices from copies of the Software. You may not claim this Software as written by anyone but Author, Artem Parlyuk. 

The author has taken all possible care to ensure the software is error-free, however the author disavows any potential liability arising from any use of the software. This software is provided "as is" and without any warranties expressed or implied, including, but not limited to, implied warranties of fitness for a particular purpose, and non-infringement. You expressly acknowledge and agree that use of the Software is at your sole risk. 

In no event shall the author be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use this software or documentation, even if the author has been advised of the possibility of such damages. 

Any feedback given to the Author will be treated as non-confidential. The Author may use any feedback free of charge without limitation. 
*)

interface

uses windows,Classes;

type

 TDrive = (dPrimaryMaster, dPrimarySlave, dSecondaryMaster,
               dSecondarySlave, dTertiaryMaster, dTertiarySlave,
               dQuaternaryMaster, dQuaternarySlave);

 TGetInfoMethod = (gimAuto, gimNT, gimScsi, gim9x, gimByName, gimASPI);
 TDriveType = (dtFixed, dtRemovable, dtCDROM, dtUnknown, dtTape, dtOptical, dtArray);

 TVendor = array[0..2] of word;

 TScsiInfo = record
  PathId, TargetId, Lun : byte;
  DeviceClaimed : boolean;
  HDDType : TDriveType;
  Model,
  Revision,
  Serial : string
 end;

 TLjbHddInfo = class(TComponent)
  protected
    fhinstWNASPI32 : Cardinal;
    fType         : TDriveType;
    fCylsTotal    : word;
    fHeadTotal    : word;
    fBPT          : word;
    fBPS          : word;
    fSPT          : word;
    fVendor       : TVendor;
    fSerial       : string;
    fBufSize      : DWord;
    fECC          : Word;
    fRevision     : string;
    fModel        : string;
    fLBASectors   : dword;
    fSize         : int64;
    fDrive        : TDrive;
    fMethod       : TGetInfoMethod;
    fName         : string;
    fIde          : boolean;
    fScsiInfo     : TScsiInfo;
    fScsiPort     : integer;
    fScsiBus      : integer;
    fScsiDevice   : integer;
    fScsiBusCount : word;
    fScsiDevCount : word;
    fScsiName : string;
    fisNT : boolean;
    fcanonical : boolean;
    procedure SetDrive(drv : TDrive);
    procedure SetDriveName(dname : string);
    procedure SetScsiPort(n : integer);
    procedure SetScsiBus(n : integer);
    procedure SetScsiDev(n : integer);
    procedure GetInfoASPI(devno : integer);
   public
    procedure GetInfo;
    constructor Create(AOwner:TComponent); override;
    property HDDType    : TDriveType read fType;
    property CylsTotal  : word read fCylsTotal;
    property HeadTotal  : word read fHeadTotal;
    property BPT        : word read fBPT;
    property BPS        : word read fBPS;
    property SPT        : word read fSPT;
    property Serial     : string read fSerial;
    property BufSize    : DWord read fBufSize;
    property ECC        : Word read fECC;
    property Revision   : string read fRevision;
    property Model      : string read fModel;
    property LBASectors : dword read fLBASectors;
    property Size       : int64 read fSize;
    property ScsiInfo   : TScsiInfo read fScsiInfo;
    property ScsiPort   : integer read fScsiPort write SetScsiPort;
    property ScsiBus    : integer read fScsiBus write SetScsiBus;
    property ScsiDevice   : integer read fScsiDevice write SetScsiDev;
    property ScsiBusCount : word read fScsiBusCount;
    property ScsiDevCount : word read fScsiDevCount;
    property isNT : boolean read fisNT;

{$IFNDEF BCB}
    property Vendor     : TVendor read fVendor;
{$ENDIF}
    property isIDE      : boolean read fIde;
   published
    property Drive      : TDrive read fDrive write SetDrive default dPrimaryMaster;
    property DeviceName : string read fName write SetDriveName;
    property Method     : TGetInfoMethod read fMethod write fMethod default gimAuto;
    property CanonicalScsiAddressing : boolean read fcanonical write fcanonical;
 end;

procedure Register;

implementation

uses sysutils, forms;

var
 InfoArray : array[0..255] of word;
 scsiflag : boolean;

type
 IDSECTOR  = packed record
    Config    : word;
    CylsTotal : word;
    Unused    : word;
    HeadTotal : word;
    BPT       : word;
    BPS       : word;
    SPT       : word;
    Vendor    : array[0..2] of word;
    Serial    : array[1..20] of char;
    BufType   : Word;
    BufSize   : Word;
    ECC       : Word;
    Revision  : array[1..8] of char;
    Model     : array[1..40] of char;
    MoreVendorUnique,
    DoubleWordIO,
    Capabilities,
    Reserved1,
    PIOTiming,
    DMATiming,
    BS,
    NumCurrentCyls,
    NumCurrentHeads,
    NumCurrentSectorsPerTrack : word;
    CurrentSectorCapacity : dword;
    MultSectorStuff : word;
    LBASectors: dword;
    SingleWordDMA,
    MultiWordDMA : word;
    Reserved : array [0..127] of byte;
  end;

 PIDSECTOR = ^IDSECTOR;

var
 IdeInfo : IDSECTOR absolute InfoArray;

const
SMART_GET_VERSION		      =	$74080;
SMART_SEND_DRIVE_COMMAND	=	$7C084;
SMART_RCV_DRIVE_DATA		  =	$7C088;

FILE_DEVICE_SCSI             =  $0000001b;
IOCTL_SCSI_MINIPORT_IDENTIFY =  ((FILE_DEVICE_SCSI shl 16) + $0501);
IOCTL_SCSI_MINIPORT          =  $0004D008;
IOCTL_SCSI_PASS_THROUGH      =  $0004D004;

CDB6GENERIC_LENGTH  = 6;
SCSI_IOCTL_DATA_IN  = 1;
SCSIOP_INQUIRY      = $12;

type

GETVERSIONINPARAMS	= packed record
	gvip_bVersion,
	gvip_bRevision,
	gvip_bReserved,
	gvip_bIDEDeviceMap  :	Byte;
	gvip_dwCapabilities	: Dword;
	gvip_dwReserved	    : array [0..3] of dword
end;

IDEREGS	=	packed record
	ir_bFeaturesReg,
	ir_bSectorCountReg,
	ir_bSectorNumberReg,
	ir_bCylLowReg,
	ir_bCylHighReg,
	ir_bDriveHeadReg,
	ir_bCommandReg,
	ir_bReserved : byte;
end;

const
ATAPI_ID_CMD		=	$0A1;
ID_CMD			    =	$0EC;
SMART_CMD		    =	$0B0;

type
SENDCMDINPARAMS	= packed record
	scip_dwBufferSize : dword;
	scip_irDriveRegs  :	IDEREGS;
	scip_bDriveNumber : byte;
	scip_bReserved		: array [0..2] of byte;
	scip_dwReserved		: array [0..3] of dword;
end;
PSENDCMDINPARAMS = ^SENDCMDINPARAMS;


DRIVERSTATUS = packed record
	ds_bDriverError,
	ds_bIDEError : byte;
  ds_bReserved		: array [0..1] of	byte;
	ds_dwReserved		: array [0..1] of dword;
end;

SCSIPASSTHROUGH = record
		spt_Length             : Word;
		spt_ScsiStatus         : Byte;
		spt_PathId             : Byte;
		spt_TargetId           : Byte;
		spt_Lun                : Byte;
		spt_CdbLength          : Byte;
		spt_SenseInfoLength    : Byte;
		spt_DataIn             : Byte;
		spt_DataTransferLength : ULong;
		spt_TimeOutValue       : ULong;
		spt_DataBufferOffset   : DWord;
		spt_SenseInfoOffset    : ULong;
		spt_Cdb                : array[0..15] of Byte;
	end;

SCSIPASSTHROUGHWITHBUFFERS = record
		sptwb_spt       : SCSIPASSTHROUGH;
		sptwb_bSenseBuf : array[0..31] of Byte;
		sptwb_bDataBuf  : array[0..191] of Byte;
	end;

const
DRVERR_NO_ERROR		      =	0;
DRVERR_IDE_ERROR	      =	1;
DRVERR_INVALID_FLAG	    =	2;
DRVERR_INVALID_COMMAND  =	3;
DRVERR_INVALID_BUFFER	  =	4;
DRVERR_INVALID_DRIVE	  =	5;
DRVERR_INVALID_IOCTL	  =	6;
DRVERR_ERROR_NO_MEM	    =	7;
DRVERR_INVALID_REGISTER	=	8;
DRVERR_NOT_SUPPORTED	  =	9;
DRVERR_NO_IDE_DEVICE	  =	10;

type
SENDCMDOUTPARAMS = packed record
	scop_dwBufferSize   :	Dword;
	scop_dsDriverStatus :	DRIVERSTATUS;
	scop_bBuffer : array [0..511] of char;
end;
PSENDCMDOUTPARAMS = ^SENDCMDOUTPARAMS;

SRB_IO_CONTROL = packed record
   HeaderLength : dword;
   Signature : array [0..7] of char;
   Timeout,
   ControlCode,
   ReturnCode,
   Length : dword;
end;

type
 GDT_DESCRIPTOR = packed record
  Limit_0_15,
  Base_0_15 :  word;
  Base_16_23 : byte;
  bAR : byte;
  {
  BYTE Type         : 4;
  BYTE System       : 1;
  BYTE DPL          : 2;
  BYTE Present      : 1;
  }
  Limit_16_19 : byte;
  {
  BYTE Limit_16_19  : 4;
  BYTE Available    : 1;
  BYTE Reserved     : 1;
  BYTE D_B          : 1;
  BYTE Granularity  : 1;
  }
  Base_24_31 : byte;
 end;

 PGDT_DESCRIPTOR = ^GDT_DESCRIPTOR;

 CALLGATE_DESCRIPTOR = packed record
  Offset_0_15,
  Selector : word;
  bAR : word;
  {
  WORD ParamCount   : 5;
  WORD Unused       : 3;
  WORD Type         : 4;
  WORD System       : 1;
  WORD DPL          : 2;
  WORD Present      : 1;
  }
  Offset_16_31 : word;
 end;

 PCALLGATE_DESCRIPTOR = ^CALLGATE_DESCRIPTOR;

 GDTR = packed record
  wGDTLimit : word;
  dwGDTBase : dword;
 end;

type

 SCSI_BUS_DATA =  record
  NumberOfLogicalUnits,
  InitiatorBusId : byte;
  InquiryDataOffset : dword;
 end;
 PSCSI_BUS_DATA = ^SCSI_BUS_DATA;

 SCSI_INQUIRY_DATA = packed record
  PathId,
  TargetId,
  Lun,
  DeviceClaimed : byte;
  InquiryDataLength,
  NextInquiryDataOffset : dword;
  InquiryData : array [0..0] of char;
 end;
 PSCSI_INQUIRY_DATA = ^SCSI_INQUIRY_DATA;


 SCSI_ADAPTER_BUS_INFO = record
  NumberOfBuses : byte;
  BusData : array[0..0] of SCSI_BUS_DATA;
 end;
 PSCSI_ADAPTER_BUS_INFO = ^SCSI_ADAPTER_BUS_INFO;

 SCSI_INQUIRY_RET = record
	    perfdt : byte;	 // Peripheral Deice Type
	    devtq  : byte;	 // Device Type Qualifier &  Removable Media Bit
	    version : byte; // Version
	    reserved : byte;	// Reserved
	    addlen : byte;		// Additional Length
	    rsvd : array [0..2] of byte;	// Reserved
	    vndrid : array [1..8] of char;	// Vendor ID (ASCII)
	    prodid : array[1..16] of char;	// Product ID (ASCII)
	    revlvl : array [1..4] of char;	// Revision level (ASCII)
	    revdata : array [1..8] of char;	// Revision data (ASCII)
	end;
  PSCSI_INQUIRY_RET = ^SCSI_INQUIRY_RET;

const
  IOCTL_SCSI_GET_INQUIRY_DATA = $4100C;

var inqbuff : array [0..2048] of char;
var scsi_businfo : SCSI_ADAPTER_BUS_INFO absolute inqbuff;


// ASPI Errors
const
  SS_PENDING = 0;
  SS_COMP = 1;
  SS_ABORTED = 2;
  SS_ERR = 4;
  SS_INVALID_CMD = $80;
  SS_INVALID_HA = $81;
  SS_NO_DEVICE = $82;
  SS_INVALID_SRB = $E0;
  SS_BUFFER_ALIGN = $E1;
  SS_ILLEGAL_MODE = $E2;
  SS_NO_ASPI = $E3;
  SS_FAILED_INIT = $E4;
  SS_ASPI_IS_BUSY = $E5;
  SS_BUFFER_TO_BIG = $E6;
  SS_MISMATCHED_COMPONENTS = $E7;
  SS_NO_ADAPTERS = $E8;
  SS_INSUFFICIENT_RESOURCES = $E9;

  SC_HA_INQUIRY = 0;
  SC_GET_DEV_TYPE = 1;
  SC_EXEC_SCSI_CMD = 2;
  SC_ABORT_SRB = 3;
  SC_RESET_DEV = 4;
  SC_GET_DISK_INFO = 6;
  SC_RESCAN_SCSI_BUS = 7;
  SC_GETSET_TIMEOUTS = 8;

  SENSE_LEN = 14;

  SRB_DIR_IN = 8;
  SRB_EVENT_NOTIFY = $40;

type
  SRB_HAInquiry = packed record
    SRB_Cmd: Byte; //   ASPI ( SC_HA_INQUIRY = $00)
    SRB_Status, //   ASPI 
    SRB_HaId, //   ASPI
    SRB_Flags: Byte; // ,   0
    SRB_Hdr_Rsvd: Dword; // ,   0
    HA_Count: Byte; //  
    HA_SCSI_ID: Byte; // ID SCSI-
    HA_ManagerId, // ,  
    HA_Identifier: array [0..15] of Byte; // ,  

   SRB_BufAlign  : Word;        // Buffer alignment mask: 0=byte, 1=word,
                                // 3=dword, 7=8-byte, etc. 65536 bytes max
   SRB_Residual  : Byte;        // Bit1 = residual count support flag
   SRB_Targets   : Byte;        // Max target count for selected HA
   SRB_TransfLen : Dword;       // Max transfer length in bytes
   SRB_Rsvd : array[0..9] of byte;

   // HA_Unique: array [0..15] of Byte; //   
   // HA_Rsvd1: Word; // ,   0
  end;

  PSRB_HAInquiry = ^SRB_HAInquiry;

type
  SRB_GDEVBlock = packed record
    SRB_Cmd, //   ASPI ( SC_GET_DEV_TYPE = $01);
    SRB_Status, //   ASPI ;
    SRB_HaId, //   ASPI;
    SRB_Flags: Byte; // ,   0;
    SRB_Hdr_Rsvd: Dword; // ,   0;
    SRB_Target, // ID  SCSI;
    SRB_Lun, // Logical Unit Number (LUN -   );
    SRB_DeviceType, //   ;
    SRB_Rsvd1: Byte; // ,   0;
  end;

  PSRB_GDEVBlock = ^SRB_GDEVBlock;

  pGetASPI32SupportInfo = function :dword; cdecl;
  pSendASPI32Command = function (LPSRB:pointer):dword; cdecl;

type
  SRB_ExecSCSICmd = packed record
    SRB_Cmd, //   ASPI ( SC_EXEC_SCSI_CMD = $02)
    SRB_Status, //   ASPI 
    SRB_HaId, //   ASPI
    SRB_Flags: Byte; //   ASPI
    SRB_Hdr_Rsvd: Dword; // ,   0
    SRB_Target, // ID  SCSI
    SRB_Lun: Byte; // Logical Unit Number (LUN -   )
    SRB_Rsvd1: Word; //   
    SRB_BufLen: Dword; //  
    SRB_BufPointer: Pointer; //    
    SRB_SenseLen, //  ;
    SRB_CDBLen, //  Command Descriptor Block -   
    SRB_HaStat, //  
    SRB_TargStat: Byte; //  
    SRB_PostProc : THandle; //     (.)
    SRB_Rsvd2: Pointer; // ,   0;
    SRB_Rsvd3, //   
    CDBByte: array [0..15] of byte; // SCSI Command Descriptor Block
    //    SCSI-
    SenseArea: array [0..SENSE_LEN + 1] of byte;
  end;

  PSRB_ExecSCSICmd = ^SRB_ExecSCSICmd;

  SRB_GetDevType = packed record
   SRB_Cmd,             // ASPI command code = SC_GET_DEV_TYPE
   SRB_Status,          // ASPI command status byte
   SRB_HaId,            // ASPI host adapter number
   SRB_Flags : BYTE;    // Reserved
   SRB_Hdr_Rsvd : DWORD; // Reserved
   SRB_Target,          // Target's SCSI ID
   SRB_Lun,             // Target's LUN number
   SRB_DeviceType,      // Target's peripheral device type
   SRB_Rsvd1 : BYTE;
  end;

  SRB_Int13info = packed record  // for Win9x/ME Only
   SRB_Cmd        : BYTE;              // ASPI command code = SC_GET_DISK_INFO
   SRB_Status     : BYTE;              // ASPI command status byte
   SRB_HaId       : BYTE;              // ASPI host adapter number
   SRB_Flags      : BYTE;              // Reserved
   SRB_Hdr_Rsvd   : DWORD;             // Reserved
   SRB_Target     : BYTE;              // Target's SCSI ID
   SRB_Lun        : BYTE;              // Target's LUN number
   SRB_DriveFlags : BYTE;              // Driver flags
   SRB_Int13Drive : BYTE;              // Host Adapter Status
   SRB_Heads      : BYTE;              // Preferred number of heads translation
   SRB_Sectors    : BYTE;              // Preferred number of sectors translation
   SRB_Rsvd       : array[0..9] of BYTE;  // Reserved
  end;

  TScsiAddr = record
   Ha, Target, Lun : byte;
  end;

const
 CanonicalAddrs : array[0..7] of TScsiAddr = (
     (Ha:0; Target:0; Lun:0),
     (Ha:0; Target:1; Lun:0),
     (Ha:1; Target:0; Lun:0),
     (Ha:1; Target:1; Lun:0),
     (Ha:2; Target:0; Lun:0),
     (Ha:2; Target:1; Lun:0),
     (Ha:3; Target:0; Lun:0),
     (Ha:3; Target:1; Lun:0)
    );
var
  GetASPI32SupportInfo : pGetASPI32SupportInfo;
  SendASPI32Command : pSendASPI32Command;
  Addrs : array of TScsiAddr;

procedure Ring0GetPortVal();
asm
    cmp cl, 1
    je @ByteVal
    cmp cl, 2
    je @WordVal
    cmp cl, 4
    je @DWordVal

@ByteVal:

    in al, dx
    mov [ebx], al
    retf

@WordVal:

    in ax, dx
    mov [ebx], ax
    retf

@DWordVal:

    in eax, dx
    mov [ebx], eax
    retf
end;


procedure Ring0SetPortVal;
asm
    cmp cl, 1
    je @ByteVal
    cmp cl, 2
    je @WordVal
    cmp cl, 4
    je @DWordVal

@ByteVal:

    mov al, [ebx]
    out dx, al
    retf

@WordVal:

    mov ax, [ebx]
    out dx, ax
    retf

@DWordVal:

    mov eax, [ebx]
    out dx, eax
    retf
end;



function CallRing0(lpRing0Proc : pointer; dwParams : word;
              lpdwRetValue:pdword; bSize:byte) : boolean; stdcall;
asm
		push	esi
		//sldt	ax			    //AX =  LDT
    	db 0fh, 0, 0c0h
		and	eax,0FFF8h		//EAX =   LDT
          						// GDT

		jz	@@NoFreeEntries

		push	esi
    	//sgdt	FWORD PTR [esp-2]
    	db 0fh, 01h, 44h, 24h, 0feh
		pop	esi			    //ESI =   GDT
		add	esi,eax			//ESI ->  LDT
		movzx	ecx,WORD PTR [esi]	//ECX =  LDT
		inc	ecx
		shr	ecx,3			  //ECX =    LDT
		mov	edx,[esi+1]
		mov	dl,[esi+7]
		ror	edx,8			  //EDX =   LDT
		mov	esi,edx			//ESI =   LDT

//    LDT

@@EntryLoop:

    cmp	[(GDT_DESCRIPTOR PTR esi).bAR],0
		je	@@FoundFreeEntry
		add	esi,8
		loop	@@EntryLoop

@@NoFreeEntries:

		xor	eax,eax			//EAX=0
		jmp	@@Exit

@@FoundFreeEntry:

//   LDT
//  LDT   
		mov	eax,[lpRing0Proc]
		mov	DWORD PTR [esi],eax
		mov	DWORD PTR [esi+4],eax
		mov	DWORD PTR [esi+2],0EC000028h	//Selector = 28h
							//WC       = 0
							//AR       = 11101100b
//    
		mov	eax,esi
		sub	eax,edx
		or	al,7			    //AX =   
		push	ax
		push	eax			    //ESP ->    
		mov	dx,[dwParams]	//EDX =  
		mov ebx, [lpdwRetValue]
		mov cL, [bSize]
    db 0ffh,1ch,24h 		//call	FWORD PTR [esp]
                        // 
						            //EAX =  
		add	esp,6
//  LDT
		xor	eax,eax
		mov	DWORD PTR [esi],eax
		mov	DWORD PTR [esi+4],eax
		inc	eax			//EAX=1

@@Exit:
    pop	esi			// 
		pop	ebp
		ret	$10
end;

function GetPortVal(wPortAddr : word; pdwPortVal: pdWord; bSize: byte): boolean;
begin
   if not CallRing0(@Ring0GetPortVal, wPortAddr, pdwPortVal, bSize) then
   begin
      result := false;
      exit;
    end;
  result := true;
end;

function SetPortVal(wPortAddr : word; dwPortVal : dword; bSize : byte) : boolean;
begin
    result := CallRing0(@Ring0SetPortVal, wPortAddr, @dwPortVal, bSize);
end;

procedure CorrectDevInfo(buff: pchar);
var i,idx:integer;
    x : word;
begin
    for i:=0 to 9 do
    begin
     idx := $14+i+i;
     x := pword(buff+idx)^;
     pword(buff+idx)^ := swap(x);
    end;

    for i := 0 to $17 do
    begin
     idx := $14+26+i+i;
     x := pword(buff+idx)^;
     pword(buff+idx)^ := swap(x);
    end;
end;

procedure GetDevInfoWin9x(devno : byte);
var
   port : word;   //  Base address of drive controller
   portValue : dword;
   i: integer;
begin
   scsiflag := false;
   portValue := 0;
   case devno div 2 of
        0: port := $1f0;
        1: port := $170;
        2: port := $1e8;
        3: port := $168;
    end;

 //  Wait for controller not busy

//    SetPortVal(word(port + $206 + devno mod 2),4,1);

    i := 100000;
    while i > 0 do
    begin
       GetPortVal(word(port + 7), @portValue, 1);
       //  drive is ready
       if (portValue and $40) = $40 then break;
       //  previous drive command ended in error
       if (portValue and $01) = $01 then break;
       dec(i);
    end;

    if (i < 1) or ((portValue and $01)<>0) then raise Exception.Create('No device!');

    //  Set Master or Slave drive
    if (devno mod 2) = 0 then
       SetPortVal(word(port + 6), $A0, 1)
    else
       SetPortVal(word(port + 6), $B0, 1);

      i := 100000;
      while i > 0 do
      begin
         GetPortVal(port + 7, @portValue, 1);
         if (portValue and $40) = $40 then break;
         if (portValue and $01) = $01 then break;
         dec(i);
      end;
      if i < 1 then raise Exception.Create('No device!');


  SetPortVal(port + 7, ID_CMD, 1);

  i := 100000;
      while i > 0 do
      begin
         GetPortVal(port + 7, @portValue, 1);
         if (portValue and $40) = $40 then break;
         if (portValue and $01) = $01 then break;
         dec(i);
      end;
      if i < 1 then raise Exception.Create('No device!');


     SetPortVal (port + 7, ATAPI_ID_CMD, 1);

    i := 100000;
    while i > 0 do
    begin
       GetPortVal(word(port + 7), @portValue, 1);
          //  see if the drive is ready and has it's info ready for us
       if (portValue and $48) = $48 then break;
          //  see if there is a drive error
       if (portValue and $01) = $01 then break;
       dec(i);
    end;

    //  check for time out or other error
    if (i < 1) or ((portValue and $01)<>0) then raise Exception.Create('No device!');

    fillchar(IdeInfo,sizeof(IdeInfo),0);
    for i := 0 to 255 do
    begin
       GetPortVal(port, @(InfoArray[i]), 2);
    end;
   CorrectDevInfo(@IdeInfo);
end;

procedure GetDevInfoNTScsibyName(devname : string);
var
   gvip:GETVERSIONINPARAMS;
	 scip : SENDCMDINPARAMS;
   scop : SENDCMDOUTPARAMS;
   devno, cmd:BYTE;
	 dwBytesReturned:DWORD;
   h:Cardinal;
   len : DWord;
   i,j:integer;
   sptwbuffer : Array[0..SizeOf(SCSIPASSTHROUGHWITHBUFFERS)+SizeOf(SCSIPASSTHROUGH)-1] of Byte;
	 sptwb : SCSIPASSTHROUGHWITHBUFFERS absolute sptwbuffer;
begin
 scsiflag := true;
 h := CreateFile (PChar('\\.\'+devname),
                  GENERIC_READ or GENERIC_WRITE,
                  FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
                  OPEN_EXISTING, 0, 0);
 if h = INVALID_HANDLE_VALUE then raise Exception.Create('Can''t create device handle!');
 try
  fillchar(InfoArray,sizeof(InfoArray),#0);
	fillchar(sptwbuffer,SizeOf(sptwbuffer),#0);
	sptwb.sptwb_spt.spt_Length     := sizeof(SCSIPASSTHROUGH);
  sptwb.sptwb_spt.spt_TargetId   := 1;
  sptwb.sptwb_spt.spt_CdbLength  := CDB6GENERIC_LENGTH;
	sptwb.sptwb_spt.spt_SenseInfoLength := 24;
	sptwb.sptwb_spt.spt_DataIn  := SCSI_IOCTL_DATA_IN;
	sptwb.sptwb_spt.spt_DataTransferLength := 192;
	sptwb.sptwb_spt.spt_TimeOutValue := 2;
	sptwb.sptwb_spt.spt_DataBufferOffset := PChar(@sptwb.sptwb_bDataBuf)-PChar(@sptwb);
	sptwb.sptwb_spt.spt_SenseInfoOffset  := PChar(@sptwb.sptwb_bSenseBuf)-PChar(@sptwb);
	sptwb.sptwb_spt.spt_Cdb[0] := SCSIOP_INQUIRY;
	sptwb.sptwb_spt.spt_Cdb[4] := 192;
	len := sptwb.sptwb_spt.spt_DataBufferOffset+sptwb.sptwb_spt.spt_DataTransferLength;
	if DeviceIoControl(h, IOCTL_SCSI_PASS_THROUGH , @sptwb, SizeOf(SCSIPASSTHROUGH), @sptwb, len, dwBytesReturned, nil )
  then
  begin             
   IdeInfo.Config := sptwb.sptwb_bDataBuf[0];
   j := 1;
   for i := 8 to 15 do
   begin
    if sptwb.sptwb_bDataBuf[i] = 0 then break;
    if sptwb.sptwb_bDataBuf[i] > 32 then
    begin
     Ideinfo.Model[j] := char(sptwb.sptwb_bDataBuf[i]);
     inc(j);
    end; 
   end;
   Ideinfo.Model[j] := ' ';
   inc(j);
   for i := 16 to 31 do
   begin
    if sptwb.sptwb_bDataBuf[i] = 0 then break;
    if sptwb.sptwb_bDataBuf[i] > 32 then
    begin
     Ideinfo.Model[j] := char(sptwb.sptwb_bDataBuf[i]);
     inc(j);
    end; 
   end;

   for i := 32 to 35 do
   begin
    if sptwb.sptwb_bDataBuf[i] = 0 then break;
    Ideinfo.Revision[i-31] := char(sptwb.sptwb_bDataBuf[i]);
   end;

   for i := 36 to 55 do
   begin
    if sptwb.sptwb_bDataBuf[i] = 0 then break;
    Ideinfo.Serial[i-35] := char(sptwb.sptwb_bDataBuf[i]);
   end;

  end;

  devno := 255;
  if lowercase(copy(devname,1,length(devname)-1)) = 'physicaldrive' then
    devno := ord(devname[length(devname)])-ord('0');

  if (devno >= 0) and (devno <= 3) then
  begin
   fillchar(gvip,sizeof(GETVERSIONINPARAMS),#0);
   fillchar(scip,sizeof(SENDCMDINPARAMS),#0);
   fillchar(scop,sizeof(SENDCMDOUTPARAMS),#0);

   if not DeviceIoControl(h,SMART_GET_VERSION,nil,0,@gvip,
                   sizeof(GETVERSIONINPARAMS),dwBytesReturned,nil)
   then
     if IdeInfo.Model[1] = #0 then raise Exception.Create('GetDevInfoNTScsibyName filed!')
     else
     begin
      exit
     end
   else
   begin
    cmd := ID_CMD;

    scip.scip_dwBufferSize := 512;
    scip.scip_bDriveNumber := devno;
    scip.scip_irDriveRegs.ir_bSectorCountReg := 1;
    scip.scip_irDriveRegs.ir_bSectorNumberReg := 1;
    scip.scip_irDriveRegs.ir_bDriveHeadReg := ((devno + 1) shl 4) or $a0;
    scip.scip_irDriveRegs.ir_bCommandReg := cmd;
    if not DeviceIoControl(h,SMART_RCV_DRIVE_DATA,@scip,sizeof(SENDCMDINPARAMS),
       @scop,sizeof(SENDCMDOUTPARAMS),dwBytesReturned,nil)
    then raise Exception.Create('DeviceIoControl filed!');
    if scop.scop_dsDriverStatus.ds_bDriverError <> DRVERR_NO_ERROR
    then raise Exception.Create('DeviceIoControl returned error!');

    scsiflag := false;
    CorrectDevInfo(scop.scop_bBuffer);
    move(scop.scop_bBuffer, IdeInfo, 512);
   end
  end
  else
  if IdeInfo.Model[1] = #0 then raise Exception.Create('GetDevInfoNTScsibyName filed!');
 finally
 CloseHandle(h);
 end;


end;

procedure GetDevInfoNTScsi(devno : integer);
var
   controller, drive : integer;
   hScsiDriveIOCTL : THandle;
   buffer : array [0..sizeof (SRB_IO_CONTROL) + sizeof (SENDCMDOUTPARAMS)] of char;
   p : SRB_IO_CONTROL absolute buffer;
   pin : PSENDCMDINPARAMS;
   dummy : dword;
   pOut : PSENDCMDOUTPARAMS;
   pId : PIDSECTOR;
   data : PSCSI_INQUIRY_DATA;
   inq : PSCSI_INQUIRY_RET;
   i,k : integer;
begin
      scsiflag := false;
      controller := devno div 2;
         //  Try to get a handle to PhysicalDrive IOCTL
         //  Windows NT, Windows 2000, any rights should do
      hScsiDriveIOCTL := CreateFile (pchar('\\.\Scsi'+inttostr(controller)+':'),
                               GENERIC_READ or GENERIC_WRITE,
                               FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
                               OPEN_EXISTING, 0, 0);

{
      hScsiDriveIOCTL := CreateFile (pchar('\\.\PhysicalDrive'+inttostr(devno)),
                               GENERIC_READ or GENERIC_WRITE,
                               FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
                               OPEN_EXISTING, 0, 0);
}
      if hScsiDriveIOCTL = INVALID_HANDLE_VALUE then
       raise Exception.Create('Can''t create device handle!');
      try
            drive := devno mod 2;
            dword(pin) := dword(@buffer) + sizeof (SRB_IO_CONTROL);

            fillchar(buffer, sizeof (buffer), 0);
            p.HeaderLength := sizeof (SRB_IO_CONTROL);
            p.Timeout := 1000;
            p.Length := sizeof (SENDCMDOUTPARAMS);
            p.ControlCode := IOCTL_SCSI_MINIPORT_IDENTIFY;
            p.Signature := 'SCSIDISK';

            pin.scip_dwBufferSize := sizeof(SENDCMDOUTPARAMS);
            pin.scip_irDriveRegs.ir_bCommandReg := ID_CMD;
            pin.scip_irDriveRegs.ir_bDriveHeadReg := $A0 or ((drive and 1) shl 4);
            pin.scip_irDriveRegs.ir_bSectorCountReg := 1;
            pin.scip_irDriveRegs.ir_bSectorNumberReg := 1;

            pin.scip_bDriveNumber := drive;
            dword(pOut) := dword(@buffer) + sizeof (SRB_IO_CONTROL);
            pId := PIDSECTOR(@pOut.scop_bBuffer);

            if DeviceIoControl (hScsiDriveIOCTL, IOCTL_SCSI_MINIPORT,
                                 @buffer,
                                 sizeof (SRB_IO_CONTROL) +
                                         sizeof (SENDCMDINPARAMS) - 1,
                                 @buffer,
                                 sizeof (SRB_IO_CONTROL) + sizeof (SENDCMDOUTPARAMS),
                                 dummy, nil) then
            begin
               if pId.Model[1] <> #0 then
               begin
                  IdeInfo := pId^;
                  CorrectDevInfo(@IdeInfo);
               end;
            end
            else
            begin
              if not DeviceIoControl(hScsiDriveIOCTL,IOCTL_SCSI_GET_INQUIRY_DATA,
                 nil,0,@inqbuff,sizeof(inqbuff),dummy,nil) then
                 Exception.Create('DeviceIoControl filed!');
              if scsi_businfo.busdata[0].numberoflogicalunits < drive+1 then
              raise Exception.Create('SCSI_GET_INQUIRY_DATA failed!');
              dword(data) := dword(@scsi_businfo) +
                   scsi_businfo.busdata[0].InquiryDataOffset;
              if drive = 1 then dword(data) := dword(@scsi_businfo) + data.NextInquiryDataOffset;
              dword(inq) := dword(@data.InquiryData[0]);
              case inq.perfdt of
               0: IdeInfo.Config := $0040;
               1,7: IdeInfo.Config := $0080;
               5: IdeInfo.Config := $8000;
              end;
              for  i:=1 to high(inq.vndrid) do
              begin
               IdeInfo.Model[i] := inq.vndrid[i];
               if IdeInfo.Model[i] = #0 then break;
               k := i;
              end;
              for  i:=1 to high(inq.prodid) do
              begin
               IdeInfo.Model[i+k] := inq.prodid [i];
               if IdeInfo.Model[i+k] = #0 then break;
              end;
              for  i:=1 to high(inq.revlvl) do
              begin
               IdeInfo.Revision[i] := inq.revlvl[i];
               if IdeInfo.Revision[i] = #0 then break;
              end;


            end;
   finally
         CloseHandle(hScsiDriveIOCTL);
   end;
end;


procedure GetDevInfoNT(devno : byte);
var	gvip:GETVERSIONINPARAMS;
		scip : SENDCMDINPARAMS;
    scop : SENDCMDOUTPARAMS;
    cmd:BYTE;
		dwBytesReturned:DWORD;
    h:Cardinal;
begin
 scsiflag := false;
 h := Createfile( pchar('\\.\PhysicalDrive'+inttostr(devno)), GENERIC_READ or GENERIC_WRITE,
        FILE_SHARE_READ or FILE_SHARE_WRITE,nil,OPEN_EXISTING,0,0);


 if h = INVALID_HANDLE_VALUE then raise Exception.Create('Can''t create device handle!');

 try
  fillchar(gvip,sizeof(GETVERSIONINPARAMS),#0);
  fillchar(scip,sizeof(SENDCMDINPARAMS),#0);
  fillchar(scop,sizeof(SENDCMDOUTPARAMS),#0);

  if not DeviceIoControl(h,SMART_GET_VERSION,nil,0,@gvip,
                  sizeof(GETVERSIONINPARAMS),dwBytesReturned,nil)
  then raise Exception.Create('DeviceIoControl filed!');
//  if ((gvip.gvip_bIDEDeviceMap shr devno) and 1) = 1 then
   cmd := ID_CMD;
//  else
//   cmd :=  ATAPI_ID_CMD;

  scip.scip_dwBufferSize := 512;
  scip.scip_bDriveNumber := devno;
  scip.scip_irDriveRegs.ir_bSectorCountReg := 1;
  scip.scip_irDriveRegs.ir_bSectorNumberReg := 1;
  scip.scip_irDriveRegs.ir_bDriveHeadReg := ((devno + 1) shl 4) or $a0;
  scip.scip_irDriveRegs.ir_bCommandReg := cmd;
  if not DeviceIoControl(h,SMART_RCV_DRIVE_DATA,@scip,sizeof(SENDCMDINPARAMS),
     @scop,sizeof(SENDCMDOUTPARAMS),dwBytesReturned,nil)
  then raise Exception.Create('DeviceIoControl filed!');
  if scop.scop_dsDriverStatus.ds_bDriverError <> DRVERR_NO_ERROR
  then raise Exception.Create('DeviceIoControl returned error!');

  CorrectDevInfo(scop.scop_bBuffer);
  move(scop.scop_bBuffer, IdeInfo, 512);

 finally
  CloseHandle(h);
 end;
end;


procedure ASPI_Enumerate;
var SupportInfo : DWORD;
    HACount, ASPIStatus, MaxTargs, Ha, Target, Lun : Byte;
    HAinfo : SRB_HAInquiry;
    DevTypeInfo : SRB_GetDevType;
begin
   Addrs := nil;

   SupportInfo := GetASPI32SupportInfo;
   ASPIStatus := HiByte(LoWord(SupportInfo));

   if ASPIStatus = SS_COMP then
   begin
     HACount := LoByte(LoWord(SupportInfo));

     // check for no host adapters found
     if HACount = 0 then
     begin
       Exit;
     end;

     for Ha := 0 to HACount -1 do     // host adapters
     begin

      FillChar( HAInfo, SizeOf(SRB_HAInquiry), 0 );
      HAInfo.SRB_Cmd := SC_HA_INQUIRY;
      HAInfo.SRB_HaID := Ha;

      if SendASPI32Command(@HAInfo) = 0 then Sleep(200);
      if HaInfo.SRB_Status = SS_COMP then
      begin
       MaxTargs := HaInfo.SRB_Targets;
       if MaxTargs = 0 then MaxTargs := 8;

      for Target := 0 to MaxTargs do  // targets
      begin                           // Luns
        for Lun := 0 to 7 do
        begin
          FillChar(DevTypeInfo, SizeOf(SRB_GetDevType), 0 );

          with DevTypeInfo do
          begin
           SRB_Cmd := SC_GET_DEV_TYPE;
           SRB_HaId := Ha;
           SRB_Target := Target;
           SRB_Lun := Lun;
          end;

          if SendASPI32Command(@DevTypeInfo) = 0 then Sleep(200);
          if DevTypeInfo.SRB_Status = SS_NO_DEVICE then Break;
          if DevTypeInfo.SRB_Status = SS_COMP then
          begin
            // ASPI get device type
            if DevTypeInfo.SRB_DeviceType > 10 then break;
            setlength(Addrs, High(Addrs)+2);
            Addrs[High(Addrs)].Ha := Ha;
            Addrs[High(Addrs)].Target := Target;
            Addrs[High(Addrs)].Lun := Lun;
          end;
        end;  // for Lun
      end;  // for Target
      end;
     end; // for HA
   end;
end;


procedure GetDevInfoASPI(addr : TScsiAddr);
var ScsiInqCommand : SRB_ExecSCSIcmd;
    InqBuf : array[1..59] of AnsiChar;
    AspiEvent : THandle;
    DevTypeInfo : SRB_GetDevType;
//    DiskInfo : SRB_Int13info;
    i : Integer;
begin

  if (@GetASPI32SupportInfo = nil) or (@SendASPI32Command = nil) then
   raise Exception.Create('ASPI not Supported!');
  AspiEvent := CreateEvent(nil, TRUE, FALSE, nil);
  if AspiEvent = 0 then Exit;
  ResetEvent(AspiEvent);

  FillChar(ScsiInqCommand, Sizeof(SRB_ExecSCSIcmd), 0);
  FillChar(InqBuf, Sizeof(InqBuf), 0);

  with ScsiInqCommand do
  begin
    SRB_Cmd := SC_EXEC_SCSI_CMD;
    SRB_HaID := addr.Ha;
    SRB_Target := addr.Target;
    SRB_Lun := addr.Lun;
    SRB_Flags := SRB_DIR_IN or SRB_EVENT_NOTIFY;
    SRB_BufLen := SizeOf(InqBuf);
    SRB_BufPointer := @InqBuf;
    SRB_SenseLen := SENSE_LEN;
    SRB_CDBLen := 6;
    SRB_PostProc := AspiEvent;
    CDBByte[4] := LoWord(SizeOf(InqBuf));
    CDBByte[3] := HiWord(SizeOf(InqBuf));
    CDBByte[0] := SCSIOP_INQUIRY;
  end;

  SendASPI32Command(@ScsiInqCommand);

  if ScsiInqCommand.SRB_Status = SS_PENDING then
     WaitForSingleObject(AspiEvent, INFINITE);


  if ScsiInqCommand.SRB_Status = SS_COMP then
  begin
    fillchar(IdeInfo,sizeof(IdeInfo),0);
    for i := 9 to 32 do IdeInfo.Model[i-8] :=  Inqbuf[i];
    for i := 33 to 36 do IdeInfo.Revision[i-32] := Inqbuf[i];
    for i := 37 to 56 do IdeInfo.Serial[i-36] := Inqbuf[i];

    FillChar(DevTypeInfo, SizeOf(SRB_GetDevType), 0 );

          with DevTypeInfo do
          begin
           SRB_Cmd := SC_GET_DEV_TYPE;
           SRB_HaId := addr.Ha;
           SRB_Target := addr.Target;
           SRB_Lun := addr.Lun;
          end;

          if SendASPI32Command(@DevTypeInfo) = 0 then Sleep(200);
          if DevTypeInfo.SRB_Status = SS_COMP then
          begin
            case DevTypeInfo.SRB_DeviceType of
               0: IdeInfo.Config := $0040;
               1,7: IdeInfo.Config := $0080;
               5: IdeInfo.Config := $8000;
            end;
          end;
{
   FillChar(DiskInfo, Sizeof(SRB_Int13info), 0);
   with DiskInfo do
   begin
     SRB_Cmd := SC_GET_DISK_INFO;
     SRB_HaID := addr.Ha;
     SRB_Target := addr.Target;
     SRB_Lun := addr.Lun;
   end;

  ResetEvent(AspiEvent);
  SendASPI32Command(@DiskInfo);

  if ScsiInqCommand.SRB_Status = SS_PENDING then
     WaitForSingleObject(AspiEvent, INFINITE);

  if ScsiInqCommand.SRB_Status = SS_COMP then
  begin
    IdeInfo.HeadTotal := DiskInfo.SRB_Heads;
    IdeInfo.SPT := DiskInfo.SRB_Sectors;
  end;
}
  end
  else
  begin
   CloseHandle(AspiEvent);
   raise Exception.Create('ASPI error!');
  end;
  CloseHandle(AspiEvent);
end;


procedure myTrim(var s:string);
var a,b:integer;
begin
 a := 1;
 b := length(s);
 while (ord(s[a]) < 33) and (a <= b) do inc(a);
 while (ord(s[b]) < 33) and (b >= a) do dec(b);
 s := copy(s,a,b-a+1);
end;

procedure TLjbHddInfo.GetInfoASPI(devno : integer);
begin
  if fcanonical then GetDevInfoASPI(CanonicalAddrs[devno])
  else if devno <= high(Addrs) then GetDevInfoASPI(Addrs[devno])
  else raise Exception.Create('Wrong devno!');
end;

procedure TLjbHddInfo.GetInfo;
var devno : byte;
begin
    devno := ord(fdrive);
    fillchar(IdeInfo, sizeof (IdeInfo), 0);
     case fmethod of
     gimAuto:
     begin
  		if fisNT then
       try
        GetDevInfoNT(devno);
       except
        GetDevInfoNTScsi(devno)
       end
      else
      try
       GetDevInfoWin9x(devno)
      except
       GetInfoASPI(devno);
      end;
     end;
     gimNT:
        GetDevInfoNT(devno);
     gimScsi:
        GetDevInfoNTScsi(devno);
     gim9x:
      GetDevInfoWin9x(devno);
     gimByName:
      GetDevInfoNTScsibyName(fName);
     gimASPI:
      GetInfoASPI(devno);
   end;

   fIde := not scsiflag;

   if scsiflag then
    case IdeInfo.Config of
      0: fType := dtFixed;
      1: fType := dtTape;
      5: fType := dtCDROM;
      7: fType := dtOptical;
     $c: fType := dtArray;
    else
         fType := dtUnknown;
    end
   else
    if (IdeInfo.Config and $8000) <> 0 then
      fType := dtCDROM
    else if (IdeInfo.Config and $0080) <> 0 then
      fType := dtRemovable
    else if (IdeInfo.Config and $0040) <> 0 then
      fType := dtFixed
    else fType := dtUnknown;

    fCylsTotal := IdeInfo.CylsTotal;
    fHeadTotal := IdeInfo.HeadTotal;
    fBPT       := IdeInfo.BPT;
    fBPS       := IdeInfo.BPS;
    fSPT       := IdeInfo.SPT;

    fSerial    := IdeInfo.Serial;
    fRevision  := IdeInfo.Revision;
    fModel     := IdeInfo.Model;
    myTrim(fSerial);
    myTrim(fRevision);
    myTrim(fModel);

    fBufSize   := IdeInfo.BufSize shl 9;
    fECC       := IdeInfo.ECC;
    fLBASectors:= IdeInfo.LBASectors;
    fSize := fLBASectors;
    if fSize < 16515072 then
    begin
     fSize := fCylsTotal * fHeadTotal * fSPT;
    end;

    fSize := fSize shl 9;

end;

procedure TLjbHddInfo.SetDrive(drv : TDrive);
begin
 fDrive := drv;
 fName := 'PhysicalDrive'+inttostr(ord(drv));
 GetInfo;
end;

procedure TLjbHddInfo.SetDriveName(dname : string);
begin
 fName := dname;
 GetInfo;
end;


constructor TLjbHddInfo.Create(AOwner:TComponent);
var osvi:_OSVERSIONINFOA;
begin
 inherited Create(AOwner);
 fMethod := gimAuto;
 fDrive := dPrimaryMaster;
 fScsiPort := -1;
 fScsiBus := -1;
 fScsiDevice := -1;
 osvi.dwOSVersionInfoSize := sizeof(osvi);
 GetVersionEx(osvi);
 fisNT := osvi.dwPlatformId = VER_PLATFORM_WIN32_NT;
 Addrs := nil;
// if not fisNT then
 begin
  fhinstWNASPI32 := LoadLibrary('WNASPI32.DLL');
  if fhinstWNASPI32<>0 then
  begin
   GetASPI32SupportInfo := GetProcAddress(fhinstWNASPI32, 'GetASPI32SupportInfo');
   SendASPI32Command := GetProcAddress(fhinstWNASPI32, 'SendASPI32Command');
   if (@GetASPI32SupportInfo <> nil) and (@SendASPI32Command <> nil) then
    ASPI_Enumerate;
  end;
 end;
end;

procedure TLjbHddInfo.SetScsiPort(n : integer);
var
   hScsiDriveIOCTL : THandle;
   dummy : dword;
   i, j, k, cn, cb : integer;
begin
 if (n <> fscsiport) and (n >= 0) then
 begin
  if fisNT then
  begin
   fscsiport := n;
   fscsiname := '\\.\Scsi'+inttostr(n)+':';
   hScsiDriveIOCTL := CreateFile (pchar(fscsiname),
                                GENERIC_READ or GENERIC_WRITE,
                                FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
                                OPEN_EXISTING, 0, 0);
   if hScsiDriveIOCTL = INVALID_HANDLE_VALUE then
     raise Exception.Create('Can''t create device handle!');
   if DeviceIoControl(hScsiDriveIOCTL,IOCTL_SCSI_GET_INQUIRY_DATA,
                   nil,0,@inqbuff,sizeof(inqbuff),dummy,nil) then
   begin
    fscsibuscount := scsi_businfo.NumberOfBuses;
    fscsibus := -1;
    fscsidevice := -1;
    fscsidevcount := 0;
   end
   else
   raise Exception.Create('DeviceIoControl filed!');
  end
  else
  begin
   if high(Addrs) = -1 then raise Exception.Create('Wrong port number!');
   k := 0;
   cn := Addrs[0].Ha;
   fscsiport := n;
   for i := 0 to high(Addrs) do
   begin
    if Addrs[i].Ha <> cn then
    begin
     inc(k);
     cn := Addrs[i].Ha;
    end;
    if n = k then
    begin
     fscsibuscount := 1;
     cb := Addrs[i].Target;
     j := i+1;
     while (j <= high(Addrs)) and (Addrs[j].Ha = cn) do
     begin
      if Addrs[j].Target <> cb then
      begin
       inc(fscsibuscount);
       cb := Addrs[i].Target;
      end;
      inc(j);
     end;

     fscsibus := -1;
     fscsidevice := -1;
     fscsidevcount := 0;
     Exit;
    end;
   end;
   raise Exception.Create('Wrong port number!');
  end;
 end;
end;

procedure TLjbHddInfo.SetScsiBus(n : integer);
var
   hScsiDriveIOCTL : THandle;
   dummy : dword;
   i : integer;
begin
 if (n <> fscsibus) and (n >= 0) then
 begin
  if n >= fscsibuscount then
    raise Exception.Create('Wrong bus number!');
  fscsibus := n;
 if fisNT then
 begin
  hScsiDriveIOCTL := CreateFile (pchar(fscsiname),
                               GENERIC_READ or GENERIC_WRITE,
                               FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
                               OPEN_EXISTING, 0, 0);
  if hScsiDriveIOCTL = INVALID_HANDLE_VALUE then
    raise Exception.Create('Can''t create device handle!');
  if DeviceIoControl(hScsiDriveIOCTL,IOCTL_SCSI_GET_INQUIRY_DATA,
                  nil,0,@inqbuff,sizeof(inqbuff),dummy,nil) then
  begin
   fscsidevice := -1;
   fscsidevcount := scsi_businfo.busdata[n].NumberOfLogicalUnits;
  end
  else
  raise Exception.Create('DeviceIoControl filed!');
 end
 else
  begin
   i := 0;
   while (Addrs[i].Ha <> fscsiport) or (Addrs[i].Target <> n) do
     inc(i);
   fscsidevice := -1;
   fscsidevcount := 1;
   inc(i);
   while (i <= high(Addrs)) and (Addrs[i].Ha = fscsiport) and (Addrs[i].Target = n) do
   begin
    inc(i);
    inc(fscsidevcount);
   end;
  end;
 end;
end;

procedure TLjbHddInfo.SetScsiDev(n : integer);
var
   hScsiDriveIOCTL : THandle;
   dummy : dword;
   data : PSCSI_INQUIRY_DATA;
   i : integer;
   addr : TScsiAddr;
begin
 if (n <> fscsidevice) and (n >= 0) then
 begin
  if n >= fscsidevcount then
    raise Exception.Create('Wrong device number!');
  fscsidevice := n;

 if fisNT then
 begin
  hScsiDriveIOCTL := CreateFile (pchar(fscsiname),
                               GENERIC_READ or GENERIC_WRITE,
                               FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
                               OPEN_EXISTING, 0, 0);
  if hScsiDriveIOCTL = INVALID_HANDLE_VALUE then
    raise Exception.Create('Can''t create device handle!');
  if DeviceIoControl(hScsiDriveIOCTL,IOCTL_SCSI_GET_INQUIRY_DATA,
                  nil,0,@inqbuff,sizeof(inqbuff),dummy,nil) then
  begin
   dword(data) := dword(@scsi_businfo) +  scsi_businfo.busdata[fscsibus].InquiryDataOffset;
   fscsiInfo.Model := '';
   for i := 1 to n do dword(data) := dword(@scsi_businfo) + data.NextInquiryDataOffset;
    case ord(data.InquiryData[0]) of
      0: fScsiInfo.HDDType := dtFixed;
      1: fScsiInfo.HDDType := dtTape;
      5: fScsiInfo.HDDType := dtCDROM;
      7: fScsiInfo.HDDType := dtOptical;
     $c: fScsiInfo.HDDType := dtArray;
    end;
    fScsiInfo.PathId := Data.PathId;
    fScsiInfo.TargetId := data.TargetId;
    fScsiInfo.Lun := data.Lun;
    fScsiInfo.DeviceClaimed := data.DeviceClaimed <> 0;
    for  i:=0 to data.InquiryDataLength-9 do
    begin
      fScsiInfo.Model := fScsiInfo.Model + pchar(@data.InquiryData[0])[i+8];
      if pchar(@data.InquiryData[0])[i+8] = #0 then break;
    end;
    mytrim(fscsiinfo.Model);
  end
  else
  raise Exception.Create('DeviceIoControl filed!');
 end
 else
  begin
   addr.Ha := fscsiport;
   addr.Target := fscsibus;
   addr.Lun := fscsidevice;
   GetDevInfoASPI(addr);
   if (IdeInfo.Config and $8000) <> 0 then
      fScsiInfo.HDDType := dtCDROM
   else if (IdeInfo.Config and $0080) <> 0 then
      fScsiInfo.HDDType := dtRemovable
   else if (IdeInfo.Config and $0040) <> 0 then
      fScsiInfo.HDDType := dtFixed
   else fScsiInfo.HDDType := dtUnknown;
   fScsiInfo.PathId := fscsiport;
   fScsiInfo.TargetId := fscsibus;
   fScsiInfo.Lun := fscsidevice;
   fscsiInfo.Model := IdeInfo.Model;
   mytrim(fscsiinfo.model);
   fscsiInfo.Revision := IdeInfo.Revision;
   mytrim(fscsiinfo.revision);
   fscsiInfo.Serial := IdeInfo.Serial;
   mytrim(fscsiinfo.serial);
  end;
 end;
end;

procedure Register;
begin
  RegisterComponents('LjbTools', [TLjbHddInfo]);
end;

end.




