�
 TFSTORAGEEDITOR 0�	  TPF0TFStorageEditorFStorageEditorLeft� Top� BorderStylebsDialogCaptionTFileStorage.FilesClientHeight� ClientWidth
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style PositionpoScreenCenterOnClose	FormCloseOnShowFormShowPixelsPerInch`
TextHeight 	TGroupBox	GroupBox1Left Top WidthHeight� AlignalTopCaption Currently Stored Files: TabOrder  	TListViewListViewLeftTopWidth� Height� AlignalLeftColumnsCaption	File nameWidth�  Caption	File SizeWidthF  ReadOnly	HideSelectionMultiSelect	OnChangeListViewChange	PopupMenu	PopupMenuTabOrder 	ViewStylevsReport  TButtonAddBtnLeft� TopWidthCHeightHintE|Uploads new file onto form and add it to the FileStorage.Files list.Caption&Add file(s)...TabOrderOnClickAddBtnClick  TButton	DeleteBtnLeft� Top(WidthCHeightHint7|Deletes selected file from the FileStorage.Files list.Caption&Delete file(s)EnabledTabOrderOnClickDeleteBtnClick  TButtonClearBtnLeft� Top@WidthCHeightHint?|Click to clear all uploaded files from FileStorage.Files list.Caption&Clear listEnabledTabOrderOnClickClearBtnClick  TButton
ExtractBtnLeft� Top� WidthCHeightHintN|Extracts selected file from the FileStorage.Files list to specified location.Caption&Extract...EnabledTabOrderOnClickExtractBtnClick   TButtonCloseBtnLeft� Top� WidthYHeightHint�|Closes the FileStorage property editor. All files uploaded onto form will be stored in Files property and could be extracted or auto-extracted at run-time.CaptionClose
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style ModalResult
ParentFontTabOrderOnClickCloseBtnClick  TOpenDialog
OpenDialogFileEditStylefsEditFilterAny File (*.*)|*.*OptionsofHideReadOnlyofAllowMultiSelectofPathMustExistofFileMustExist Title&Please point file to upload in StorageLeftTopd  
TPopupMenu	PopupMenuLeft@Topd 	TMenuItem
UploadItemCaption&Upload FileEnabledShortCutU@  	TMenuItem
DeleteItemCaption&Delete FileEnabledShortCutD@  	TMenuItemN1Caption-ShortCut   	TMenuItemExtractItemCaptionE&xtract...EnabledShortCutX@  	TMenuItemN2Caption-ShortCut   	TMenuItem
SelectAll1CaptionSelect &AllShortCutA@OnClickSelectAll1Click   TSaveDialog
SaveDialogFileEditStylefsEditFilterAny File (*.*)|*.*Title,Please point location to Extract Stored FileLeft$Topd   