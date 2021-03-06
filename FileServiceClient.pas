unit FileServiceClient;
{GEN}
{TYPE CLIENT}
{CLASS TFileServiceClient}
{IMPLIB FileServiceServerImplib}
{TEMPLATE RDTP_gen_client_template.pas}
{RQFILE FileServiceRQs.txt}
{ANCESTOR TGenericRDTPClient}
{END}


interface


uses
  Dir, DirFile, Classes, rdtp_file, packet, betterobject, systemx, genericRDTPClient, variants, packethelpers, debug, typex, exceptions;



type
  TFileServiceClient = class(TGenericRDTPClient)
  public
    procedure Init;override;
    destructor Destroy;override;

    
    function PutFile(oFile:TFileTransferReference):boolean;overload;virtual;
    procedure PutFile_Async(oFile:TFileTransferReference);overload;virtual;
    function PutFile_Response():boolean;
    function GetFile(var oFile:TFileTransferReference):boolean;overload;virtual;
    procedure GetFile_Async(var oFile:TFileTransferReference);overload;virtual;
    function GetFile_Response(var oFile:TFileTransferReference):boolean;
    function OpenFile(sFile:string; out oFile:TFileTransferReference; iMode:integer):boolean;overload;virtual;
    procedure OpenFile_Async(sFile:string; iMode:integer);overload;virtual;
    function OpenFile_Response(out oFile:TFileTransferReference):boolean;
    function CloseFile(oFile:TFileTransferReference):boolean;overload;virtual;
    procedure CloseFile_Async(oFile:TFileTransferReference);overload;virtual;
    function CloseFile_Response():boolean;
    function Dir(sRemotePath:string):TDirectory;overload;virtual;
    procedure Dir_Async(sRemotePath:string);overload;virtual;
    function Dir_Response():TDirectory;
    function GetUpgradePath(sProgramName:string):string;overload;virtual;
    procedure GetUpgradePath_Async(sProgramName:string);overload;virtual;
    function GetUpgradePath_Response():string;
    function GetUpgradeScript(sProgramName:string; iFromVersion:integer; iToVersion:integer):string;overload;virtual;
    procedure GetUpgradeScript_Async(sProgramName:string; iFromVersion:integer; iToVersion:integer);overload;virtual;
    function GetUpgradeScript_Response():string;
    function GetUpgradeVersion(sProgramName:string; bBeta:boolean):integer;overload;virtual;
    procedure GetUpgradeVersion_Async(sProgramName:string; bBeta:boolean);overload;virtual;
    function GetUpgradeVersion_Response():integer;
    function GetFileChecksum(sFile:string):TAdvancedFileChecksum;overload;virtual;
    procedure GetFileChecksum_Async(sFile:string);overload;virtual;
    function GetFileChecksum_Response():TAdvancedFileChecksum;
    function BuildHueFile(sFile:string; LengthInSeconds:real):boolean;overload;virtual;
    procedure BuildHueFile_Async(sFile:string; LengthInSeconds:real);overload;virtual;
    function BuildHueFile_Response():boolean;
    function DeleteFile(sFile:string):boolean;overload;virtual;
    procedure DeleteFile_Async(sFile:string);overload;virtual;
    function DeleteFile_Response():boolean;
    function Execute(sPath:string; sProgram:string; sParams:string):boolean;overload;virtual;
    procedure Execute_Async(sPath:string; sProgram:string; sParams:string);overload;virtual;
    function Execute_Response():boolean;
    function BuildHueFileFromStream(str:TStream; sExt:string; LengthInSeconds:real):TStream;overload;virtual;
    procedure BuildHueFileFromStream_Async(str:TStream; sExt:string; LengthInSeconds:real);overload;virtual;
    function BuildHueFileFromStream_Response():TStream;
    function EchoStream(strin:TStream):TStream;overload;virtual;
    procedure EchoStream_Async(strin:TStream);overload;virtual;
    function EchoStream_Response():TStream;
    function AppendTextFile(filename:string; text:string):boolean;overload;virtual;
    procedure AppendTextFile_Async(filename:string; text:string);overload;virtual;
    function AppendTextFile_Response():boolean;
    function GetFileSize(filename:string):int64;overload;virtual;
    procedure GetFileSize_Async(filename:string);overload;virtual;
    function GetFileSize_Response():int64;
    function ExecuteAndCapture(sPath:string; sProgram:string; sParams:string):string;overload;virtual;
    procedure ExecuteAndCapture_Async(sPath:string; sProgram:string; sParams:string);overload;virtual;
    function ExecuteAndCapture_Response():string;
    function GetFileList(sRemotePath:string; sFileSpec:string; attrmask:integer; attrresult:integer):TRemoteFileArray;overload;virtual;
    procedure GetFileList_Async(sRemotePath:string; sFileSpec:string; attrmask:integer; attrresult:integer);overload;virtual;
    function GetFileList_Response():TRemoteFileArray;


    function DispatchCallback: boolean;override;

  end;

procedure LocalDebug(s: string; sFilter: string = '');


implementation

uses
  sysutils;

procedure LocalDebug(s: string; sFilter: string = '');
begin
  Debug.Log(nil, s, sFilter);
end;



{ TFileServiceClient }


destructor TFileServiceClient.destroy;
begin

  inherited;
end;


//------------------------------------------------------------------------------
function TFileServiceClient.PutFile(oFile:TFileTransferReference):boolean;
var
  packet: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try try
    packet.AddVariant($6000);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WriteTFileTransferReferenceToPacket(packet, oFile);
    if not Transact(packet) then raise ECritical.create('transaction failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    GetbooleanFromPacket(packet, result);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
procedure TFileServiceClient.PutFile_Async(oFile:TFileTransferReference);
var
  packet,outpacket: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try
    packet.AddVariant($6000);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WriteTFileTransferReferenceToPacket(packet, oFile);
    BeginTransact2(packet, outpacket,nil, false);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.PutFile_Response():boolean;
var
  packet: TRDTPPacket;
begin
  packet := nil;
  try
    if not EndTransact2(packet, packet,nil, false) then raise ECritical.create('Transaction Failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    //packet.SeqRead;//read off the service name and forget it (it is already known)
    GetbooleanFromPacket(packet, result);
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.GetFile(var oFile:TFileTransferReference):boolean;
var
  packet: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try try
    packet.AddVariant($6001);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WriteTFileTransferReferenceToPacket(packet, oFile);
    if not Transact(packet) then raise ECritical.create('transaction failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    GetbooleanFromPacket(packet, result);
    GetTFileTransferReferenceFromPacket(packet, oFile);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
procedure TFileServiceClient.GetFile_Async(var oFile:TFileTransferReference);
var
  packet,outpacket: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try
    packet.AddVariant($6001);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WriteTFileTransferReferenceToPacket(packet, oFile);
    BeginTransact2(packet, outpacket,nil, false);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.GetFile_Response(var oFile:TFileTransferReference):boolean;
var
  packet: TRDTPPacket;
begin
  packet := nil;
  try
    if not EndTransact2(packet, packet,nil, false) then raise ECritical.create('Transaction Failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    //packet.SeqRead;//read off the service name and forget it (it is already known)
    GetbooleanFromPacket(packet, result);
    GetTFileTransferReferenceFromPacket(packet, oFile);
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.OpenFile(sFile:string; out oFile:TFileTransferReference; iMode:integer):boolean;
var
  packet: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try try
    packet.AddVariant($6002);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, sFile);
    WriteintegerToPacket(packet, iMode);
    if not Transact(packet) then raise ECritical.create('transaction failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    GetbooleanFromPacket(packet, result);
    GetTFileTransferReferenceFromPacket(packet, oFile);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
procedure TFileServiceClient.OpenFile_Async(sFile:string; iMode:integer);
var
  packet,outpacket: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try
    packet.AddVariant($6002);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, sFile);
    WriteintegerToPacket(packet, iMode);
    BeginTransact2(packet, outpacket,nil, false);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.OpenFile_Response(out oFile:TFileTransferReference):boolean;
var
  packet: TRDTPPacket;
begin
  packet := nil;
  try
    if not EndTransact2(packet, packet,nil, false) then raise ECritical.create('Transaction Failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    //packet.SeqRead;//read off the service name and forget it (it is already known)
    GetbooleanFromPacket(packet, result);
    GetTFileTransferReferenceFromPacket(packet, oFile);
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.CloseFile(oFile:TFileTransferReference):boolean;
var
  packet: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try try
    packet.AddVariant($6003);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WriteTFileTransferReferenceToPacket(packet, oFile);
    if not Transact(packet) then raise ECritical.create('transaction failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    GetbooleanFromPacket(packet, result);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
procedure TFileServiceClient.CloseFile_Async(oFile:TFileTransferReference);
var
  packet,outpacket: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try
    packet.AddVariant($6003);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WriteTFileTransferReferenceToPacket(packet, oFile);
    BeginTransact2(packet, outpacket,nil, false);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.CloseFile_Response():boolean;
var
  packet: TRDTPPacket;
begin
  packet := nil;
  try
    if not EndTransact2(packet, packet,nil, false) then raise ECritical.create('Transaction Failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    //packet.SeqRead;//read off the service name and forget it (it is already known)
    GetbooleanFromPacket(packet, result);
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.Dir(sRemotePath:string):TDirectory;
var
  packet: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try try
    packet.AddVariant($6004);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, sRemotePath);
    if not Transact(packet) then raise ECritical.create('transaction failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    GetTDirectoryFromPacket(packet, result);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
procedure TFileServiceClient.Dir_Async(sRemotePath:string);
var
  packet,outpacket: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try
    packet.AddVariant($6004);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, sRemotePath);
    BeginTransact2(packet, outpacket,nil, false);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.Dir_Response():TDirectory;
var
  packet: TRDTPPacket;
begin
  packet := nil;
  try
    if not EndTransact2(packet, packet,nil, false) then raise ECritical.create('Transaction Failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    //packet.SeqRead;//read off the service name and forget it (it is already known)
    GetTDirectoryFromPacket(packet, result);
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.GetUpgradePath(sProgramName:string):string;
var
  packet: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try try
    packet.AddVariant($6005);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, sProgramName);
    if not Transact(packet) then raise ECritical.create('transaction failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    GetstringFromPacket(packet, result);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
procedure TFileServiceClient.GetUpgradePath_Async(sProgramName:string);
var
  packet,outpacket: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try
    packet.AddVariant($6005);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, sProgramName);
    BeginTransact2(packet, outpacket,nil, false);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.GetUpgradePath_Response():string;
var
  packet: TRDTPPacket;
begin
  packet := nil;
  try
    if not EndTransact2(packet, packet,nil, false) then raise ECritical.create('Transaction Failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    //packet.SeqRead;//read off the service name and forget it (it is already known)
    GetstringFromPacket(packet, result);
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.GetUpgradeScript(sProgramName:string; iFromVersion:integer; iToVersion:integer):string;
var
  packet: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try try
    packet.AddVariant($6006);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, sProgramName);
    WriteintegerToPacket(packet, iFromVersion);
    WriteintegerToPacket(packet, iToVersion);
    if not Transact(packet) then raise ECritical.create('transaction failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    GetstringFromPacket(packet, result);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
procedure TFileServiceClient.GetUpgradeScript_Async(sProgramName:string; iFromVersion:integer; iToVersion:integer);
var
  packet,outpacket: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try
    packet.AddVariant($6006);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, sProgramName);
    WriteintegerToPacket(packet, iFromVersion);
    WriteintegerToPacket(packet, iToVersion);
    BeginTransact2(packet, outpacket,nil, false);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.GetUpgradeScript_Response():string;
var
  packet: TRDTPPacket;
begin
  packet := nil;
  try
    if not EndTransact2(packet, packet,nil, false) then raise ECritical.create('Transaction Failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    //packet.SeqRead;//read off the service name and forget it (it is already known)
    GetstringFromPacket(packet, result);
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.GetUpgradeVersion(sProgramName:string; bBeta:boolean):integer;
var
  packet: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try try
    packet.AddVariant($6007);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, sProgramName);
    WritebooleanToPacket(packet, bBeta);
    if not Transact(packet) then raise ECritical.create('transaction failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    GetintegerFromPacket(packet, result);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
procedure TFileServiceClient.GetUpgradeVersion_Async(sProgramName:string; bBeta:boolean);
var
  packet,outpacket: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try
    packet.AddVariant($6007);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, sProgramName);
    WritebooleanToPacket(packet, bBeta);
    BeginTransact2(packet, outpacket,nil, false);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.GetUpgradeVersion_Response():integer;
var
  packet: TRDTPPacket;
begin
  packet := nil;
  try
    if not EndTransact2(packet, packet,nil, false) then raise ECritical.create('Transaction Failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    //packet.SeqRead;//read off the service name and forget it (it is already known)
    GetintegerFromPacket(packet, result);
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.GetFileChecksum(sFile:string):TAdvancedFileChecksum;
var
  packet: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try try
    packet.AddVariant($6008);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, sFile);
    if not Transact(packet) then raise ECritical.create('transaction failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    GetTAdvancedFileChecksumFromPacket(packet, result);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
procedure TFileServiceClient.GetFileChecksum_Async(sFile:string);
var
  packet,outpacket: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try
    packet.AddVariant($6008);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, sFile);
    BeginTransact2(packet, outpacket,nil, false);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.GetFileChecksum_Response():TAdvancedFileChecksum;
var
  packet: TRDTPPacket;
begin
  packet := nil;
  try
    if not EndTransact2(packet, packet,nil, false) then raise ECritical.create('Transaction Failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    //packet.SeqRead;//read off the service name and forget it (it is already known)
    GetTAdvancedFileChecksumFromPacket(packet, result);
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.BuildHueFile(sFile:string; LengthInSeconds:real):boolean;
var
  packet: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try try
    packet.AddVariant($6009);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, sFile);
    WriterealToPacket(packet, LengthInSeconds);
    if not Transact(packet) then raise ECritical.create('transaction failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    GetbooleanFromPacket(packet, result);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
procedure TFileServiceClient.BuildHueFile_Async(sFile:string; LengthInSeconds:real);
var
  packet,outpacket: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try
    packet.AddVariant($6009);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, sFile);
    WriterealToPacket(packet, LengthInSeconds);
    BeginTransact2(packet, outpacket,nil, false);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.BuildHueFile_Response():boolean;
var
  packet: TRDTPPacket;
begin
  packet := nil;
  try
    if not EndTransact2(packet, packet,nil, false) then raise ECritical.create('Transaction Failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    //packet.SeqRead;//read off the service name and forget it (it is already known)
    GetbooleanFromPacket(packet, result);
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.DeleteFile(sFile:string):boolean;
var
  packet: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try try
    packet.AddVariant($6010);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, sFile);
    if not Transact(packet) then raise ECritical.create('transaction failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    GetbooleanFromPacket(packet, result);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
procedure TFileServiceClient.DeleteFile_Async(sFile:string);
var
  packet,outpacket: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try
    packet.AddVariant($6010);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, sFile);
    BeginTransact2(packet, outpacket,nil, false);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.DeleteFile_Response():boolean;
var
  packet: TRDTPPacket;
begin
  packet := nil;
  try
    if not EndTransact2(packet, packet,nil, false) then raise ECritical.create('Transaction Failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    //packet.SeqRead;//read off the service name and forget it (it is already known)
    GetbooleanFromPacket(packet, result);
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.Execute(sPath:string; sProgram:string; sParams:string):boolean;
var
  packet: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try try
    packet.AddVariant($6011);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, sPath);
    WritestringToPacket(packet, sProgram);
    WritestringToPacket(packet, sParams);
    if not Transact(packet) then raise ECritical.create('transaction failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    GetbooleanFromPacket(packet, result);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
procedure TFileServiceClient.Execute_Async(sPath:string; sProgram:string; sParams:string);
var
  packet,outpacket: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try
    packet.AddVariant($6011);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, sPath);
    WritestringToPacket(packet, sProgram);
    WritestringToPacket(packet, sParams);
    BeginTransact2(packet, outpacket,nil, false);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.Execute_Response():boolean;
var
  packet: TRDTPPacket;
begin
  packet := nil;
  try
    if not EndTransact2(packet, packet,nil, false) then raise ECritical.create('Transaction Failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    //packet.SeqRead;//read off the service name and forget it (it is already known)
    GetbooleanFromPacket(packet, result);
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.BuildHueFileFromStream(str:TStream; sExt:string; LengthInSeconds:real):TStream;
var
  packet: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try try
    packet.AddVariant($6012);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WriteTStreamToPacket(packet, str);
    WritestringToPacket(packet, sExt);
    WriterealToPacket(packet, LengthInSeconds);
    if not Transact(packet) then raise ECritical.create('transaction failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    GetTStreamFromPacket(packet, result);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
procedure TFileServiceClient.BuildHueFileFromStream_Async(str:TStream; sExt:string; LengthInSeconds:real);
var
  packet,outpacket: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try
    packet.AddVariant($6012);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WriteTStreamToPacket(packet, str);
    WritestringToPacket(packet, sExt);
    WriterealToPacket(packet, LengthInSeconds);
    BeginTransact2(packet, outpacket,nil, false);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.BuildHueFileFromStream_Response():TStream;
var
  packet: TRDTPPacket;
begin
  packet := nil;
  try
    if not EndTransact2(packet, packet,nil, false) then raise ECritical.create('Transaction Failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    //packet.SeqRead;//read off the service name and forget it (it is already known)
    GetTStreamFromPacket(packet, result);
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.EchoStream(strin:TStream):TStream;
var
  packet: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try try
    packet.AddVariant($6013);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WriteTStreamToPacket(packet, strin);
    if not Transact(packet) then raise ECritical.create('transaction failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    GetTStreamFromPacket(packet, result);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
procedure TFileServiceClient.EchoStream_Async(strin:TStream);
var
  packet,outpacket: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try
    packet.AddVariant($6013);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WriteTStreamToPacket(packet, strin);
    BeginTransact2(packet, outpacket,nil, false);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.EchoStream_Response():TStream;
var
  packet: TRDTPPacket;
begin
  packet := nil;
  try
    if not EndTransact2(packet, packet,nil, false) then raise ECritical.create('Transaction Failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    //packet.SeqRead;//read off the service name and forget it (it is already known)
    GetTStreamFromPacket(packet, result);
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.AppendTextFile(filename:string; text:string):boolean;
var
  packet: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try try
    packet.AddVariant($6014);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, filename);
    WritestringToPacket(packet, text);
    if not Transact(packet) then raise ECritical.create('transaction failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    GetbooleanFromPacket(packet, result);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
procedure TFileServiceClient.AppendTextFile_Async(filename:string; text:string);
var
  packet,outpacket: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try
    packet.AddVariant($6014);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, filename);
    WritestringToPacket(packet, text);
    BeginTransact2(packet, outpacket,nil, false);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.AppendTextFile_Response():boolean;
var
  packet: TRDTPPacket;
begin
  packet := nil;
  try
    if not EndTransact2(packet, packet,nil, false) then raise ECritical.create('Transaction Failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    //packet.SeqRead;//read off the service name and forget it (it is already known)
    GetbooleanFromPacket(packet, result);
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.GetFileSize(filename:string):int64;
var
  packet: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try try
    packet.AddVariant($6015);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, filename);
    if not Transact(packet) then raise ECritical.create('transaction failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    Getint64FromPacket(packet, result);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
procedure TFileServiceClient.GetFileSize_Async(filename:string);
var
  packet,outpacket: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try
    packet.AddVariant($6015);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, filename);
    BeginTransact2(packet, outpacket,nil, false);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.GetFileSize_Response():int64;
var
  packet: TRDTPPacket;
begin
  packet := nil;
  try
    if not EndTransact2(packet, packet,nil, false) then raise ECritical.create('Transaction Failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    //packet.SeqRead;//read off the service name and forget it (it is already known)
    Getint64FromPacket(packet, result);
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.ExecuteAndCapture(sPath:string; sProgram:string; sParams:string):string;
var
  packet: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try try
    packet.AddVariant($6016);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, sPath);
    WritestringToPacket(packet, sProgram);
    WritestringToPacket(packet, sParams);
    if not Transact(packet) then raise ECritical.create('transaction failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    GetstringFromPacket(packet, result);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
procedure TFileServiceClient.ExecuteAndCapture_Async(sPath:string; sProgram:string; sParams:string);
var
  packet,outpacket: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try
    packet.AddVariant($6016);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, sPath);
    WritestringToPacket(packet, sProgram);
    WritestringToPacket(packet, sParams);
    BeginTransact2(packet, outpacket,nil, false);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.ExecuteAndCapture_Response():string;
var
  packet: TRDTPPacket;
begin
  packet := nil;
  try
    if not EndTransact2(packet, packet,nil, false) then raise ECritical.create('Transaction Failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    //packet.SeqRead;//read off the service name and forget it (it is already known)
    GetstringFromPacket(packet, result);
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.GetFileList(sRemotePath:string; sFileSpec:string; attrmask:integer; attrresult:integer):TRemoteFileArray;
var
  packet: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try try
    packet.AddVariant($6017);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, sRemotePath);
    WritestringToPacket(packet, sFileSpec);
    WriteintegerToPacket(packet, attrmask);
    WriteintegerToPacket(packet, attrresult);
    if not Transact(packet) then raise ECritical.create('transaction failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    GetTRemoteFileArrayFromPacket(packet, result);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
  finally
    packet.free;
  end;
end;
//------------------------------------------------------------------------------
procedure TFileServiceClient.GetFileList_Async(sRemotePath:string; sFileSpec:string; attrmask:integer; attrresult:integer);
var
  packet,outpacket: TRDTPPacket;
begin
  if not connect then
     raise ETransportError.create('Failed to connect');
  packet := NeedPacket;
  try
    packet.AddVariant($6017);
    packet.AddVariant(0);
    packet.AddString('FileService');
    WritestringToPacket(packet, sRemotePath);
    WritestringToPacket(packet, sFileSpec);
    WriteintegerToPacket(packet, attrmask);
    WriteintegerToPacket(packet, attrresult);
    BeginTransact2(packet, outpacket,nil, false);
  except
    on E:Exception do begin
      e.message := 'RDTP Call Failed:'+e.message;
      raise;
    end;
  end;
end;
//------------------------------------------------------------------------------
function TFileServiceClient.GetFileList_Response():TRemoteFileArray;
var
  packet: TRDTPPacket;
begin
  packet := nil;
  try
    if not EndTransact2(packet, packet,nil, false) then raise ECritical.create('Transaction Failure');
    if not packet.result then raise ECritical.create('server error: '+packet.message);
    packet.SeqSeek(PACKET_INDEX_RESULT_DETAILS);
    //packet.SeqRead;//read off the service name and forget it (it is already known)
    GetTRemoteFileArrayFromPacket(packet, result);
  finally
    packet.free;
  end;
end;



function TFileServiceClient.DispatchCallback: boolean;
var
  iRQ: integer;
begin

  result := false;

  iRQ := callback.request.data[0];
  callback.request.seqseek(3);
  case iRQ of
    0: begin
        //beeper.Beep(100,100);
        result := true;
       end;
  
  end;

  if not result then
    result := Inherited DispatchCallback;
end;



procedure TFileServiceClient.Init;
begin
  inherited;
  ServiceName := 'FileService';
end;

end.


