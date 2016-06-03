-- FileExplorer_Customization.lua

local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE;

-----------------------------------------------------------------------------------------------------------------------
-- 	탐색기 기본 UI control

local StaticText_Title	= UI.getChildControl( Panel_FileExplorer,	"StaticText_Title")
local btn_Question		= UI.getChildControl( Panel_FileExplorer,	"Button_Question" )

local btn_Close			= UI.getChildControl( Panel_FileExplorer,	"Button_Win_Close" )
local btn_Confirm		= UI.getChildControl( Panel_FileExplorer,	"Button_Confirm")
local btn_Cancle		= UI.getChildControl( Panel_FileExplorer,	"Button_Cancle")
local btn_Refresh		= UI.getChildControl( Panel_FileExplorer,	"Button_Refresh")

local combo_Ext			= UI.getChildControl( Panel_FileExplorer,	"Combobox_Filter_Zone")
local list_Ext			= combo_Ext:GetListControl();

local btn_Back			= UI.getChildControl( Panel_FileExplorer,	"Button_Back")
local btn_Forward		= UI.getChildControl( Panel_FileExplorer,	"Button_Forward")
local text_EditBox		= UI.getChildControl( Panel_FileExplorer,	"Static_EditBox")

btn_Close:addInputEvent( "Mouse_LUp", "closeExplorer()")
btn_Confirm:addInputEvent( "Mouse_LUp", "FileExplorer_Confirm()")
btn_Cancle:addInputEvent( "Mouse_LUp", "closeExplorer()")
btn_Refresh:addInputEvent( "Mouse_LUp", "refreshFileList()")

combo_Ext:addInputEvent( "Mouse_LUp", "Toggle_ExtBox()")
list_Ext:addInputEvent( "Mouse_LUp", "SlectExtListIndex()")
btn_Back:addInputEvent( "Mouse_LUp", "goToParentFolder()")
btn_Forward:addInputEvent( "Mouse_LUp", "gotoPrevFolder()")

local btn_Open			= UI.getChildControl( Panel_FileExplorer,	"Button_Open")
local static_FilePath	= UI.getChildControl( Panel_FileExplorer,	"StaticText_FilePath")

local frame_FileList	= UI.getChildControl( Panel_FileExplorer,	"Frame_FileList")
local frame_Content		= UI.getChildControl( frame_FileList,		"Frame_1_Content")
local frame_Scroll		= UI.getChildControl( frame_FileList,		"Frame_1_VerticalScroll")
local frame_ScrollBtn	= UI.getChildControl( frame_Scroll,			"Frame_1_VerticalScroll_CtrlButton")

local frame_FileList2	= UI.getChildControl( Panel_FileExplorer,	"Frame_2_FileList");
local frame_Content2	= UI.getChildControl( frame_FileList2,		"Frame_2_Content")
local frame_Scroll2		= UI.getChildControl( frame_FileList2,		"Frame_2_VerticalScroll")
local frame_ScrollBtn2	= UI.getChildControl( frame_Scroll2,		"Frame_2_VerticalScroll_CtrlButton")

local temp_ItemBase		= UI.getChildControl( Panel_FileExplorer,	"Static_Item")
local temp_IconBase		= UI.getChildControl( Panel_FileExplorer,	"Static_Icon")
local temp_PathBase		= UI.getChildControl( Panel_FileExplorer,	"StaticText_FileName")


local _fileExplorer		= ToClient_getFileExplorer()
local _itemYGap			= 6;

local _currentFrame		= 
{
	frame 				= frame_FileList,
	content				= frame_Content,
	scroll				= frame_Scroll,
	scroll_Btn			= frame_ScrollBtn
};

local _swapFrame		= 
{
	frame				= frame_FileList2,
	content				= frame_Content2,
	scroll				= frame_Scroll2,
	scroll_Btn			= frame_ScrollBtn2
};

local _textureSize		= 128;

_ext_type_customize = 0;

local _type_image		= 0
local _type_customize	= 1

local _folder_textureInfo = { x = 0,	y = 0,	endX = 32,	endY = 32 }
local _ext_arr = 
{
	[_ext_type_customize]	=
	{
		[_type_image]		= { x = 136,	y = 9, 	endX = 254,	endY = 137 },
		[_type_customize]	= { x = 5,		y = 9, 	endX = 133,	endY = 137 },
	};
}

local _current_ext_type = 0;
local _openWithFunction = nil; 
local _btn_ConfirmFunction = nil;
local _listItemHeight = 12;
local _cusomizeText = "Customization File";
local _bDirectorySerch = true;

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
--	function

--[[	FileExplorer 최초 생성시 매개변수 사용방법
function FileExplorerOpen(	strExplorerTitleName 	// 탐색기 용도에 따라 TitleName을 설정 합니다.
							iExtensionType 			// 일단 0으로 사용.
							strExtensionTypeList	// 탐색기 List에 추가될 파일확장자를 지정 합니다. ( ex) "jpg,txt" 로 사용시 jpg,txt 현재 탐색할 폴더 내의 jpg,txt파일만 등록 됩니다. )
							)
]]--
function FileExplorer_Open(ExplorerTitleName, ExtensionType, ExtensionTypeList)
	_fileExplorer:init();
	
	text_EditBox:SetEditText("")
	
	StaticText_Title:SetText( ExplorerTitleName )
	_current_ext_type = ExtensionType;
	--_openWithFunction = openFunction;

	combo_Ext:DeleteAllItem();
	combo_Ext:SetText("FileType");
		
	local count = #ExtensionTypeList;
	list_Ext:SetItemQuantity( count );
	
	for extIndex = 1, #ExtensionTypeList do
		local text = ExtensionTypeList[extIndex];

		_PA_LOG("LUA", "파일 Type = " .. text)
		
		if( text == "Customization" ) then			-- CustomData란 구분을 따로 하지 않는다. 차후 customData 확장자를 추가 해야 한다. ( 현재는 모든 파일과 확장자까지 보이도록 한다 )
			-- _PA_LOG("LUA", "AddItem = " .. text)
			-- combo_Ext:AddItem( "Customization File" );
		else
			combo_Ext:AddItem( ExtensionTypeList[extIndex] );
		end
	end
	
	refreshFileList()
	Panel_FileExplorer:SetShow( true )
end

function FileExplorer_getCurrentPath()
	return _fileExplorer:getCurrentPath()
end

function FileExplorer_setEditTextMaxInput( inputsize )
	text_EditBox:SetMaxInput(inputsize)
end

function FileExplorer_NotUseFilterComboBox( bUseBox )
	combo_Ext:SetShow(bUseBox)
end

function FileExplorer_NotUsePrevNextBtn( bUseBtn )
	btn_Back:SetShow(bUseBtn)
	btn_Forward:SetShow(bUseBtn)	
end

function FileExplorer_NotUseEditText( bUseEditText )
	text_EditBox:SetShow(bUseEditText)
end

-- CurrentPath + addPath ( CurrentPath는 C:\Users\MyPC\Documents\Black Desert 입니다. )
function FileExplorerAddPathToCurrentPath( addPath )
	_fileExplorer:setAddPathToCurrentPath( addPath )
end

-- FilterBox의 내부 목록에서 index로 선택 합니다.
function FileExplorerSetFilterBoxAtIndex( index )
	if( index ~= nil) then
		combo_Ext:SetSelectItemIndex(index)
	else
		combo_Ext:SetSelectItemIndex(0)
	end
end

local Init = function ()	
	_fileExplorer:init();
end

local swapFrame = function()
	local frame = _currentFrame.frame;
	local content = _currentFrame.content;
	local scroll = _currentFrame.scroll;
	local scroll_Btn = _currentFrame.scroll_Btn;
	
	_currentFrame.frame = _swapFrame.frame;
	_currentFrame.content = _swapFrame.content;
	_currentFrame.scroll = _swapFrame.scroll;
	_currentFrame.scroll_Btn = _swapFrame.scroll_Btn;
	
	_swapFrame.frame = frame;
	_swapFrame.content = content;
	_swapFrame.scroll = scroll;
	_swapFrame.scroll_Btn = scroll_Btn;
end

local MakeFileItem = function( name )
	local fileItem = {};

	fileItem._item = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, _currentFrame.content, name );
	CopyBaseProperty( temp_ItemBase, fileItem._item );
	
	fileItem._icon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, fileItem._item, name .. "_icon" );
	CopyBaseProperty( temp_IconBase, fileItem._icon )
	
	fileItem._text = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, fileItem._item, name .. "_text" );	
	CopyBaseProperty( temp_PathBase, fileItem._text )

	fileItem._item:SetPosX(0)
	fileItem._item:SetPosY(0)
	fileItem._icon:SetPosX( 5 )
	fileItem._icon:SetPosY( 0 )
	fileItem._text:SetPosX( fileItem._icon:GetSizeX() + 10 )
	fileItem._text:SetPosY( 0 )

	return fileItem;
end

function refreshFileList()
	local selectText = combo_Ext:GetSelectItem();
	if( selectText == "None" ) then
		selectText = "";
	end

	local count = _fileExplorer:getCurrentFoloderFileList(selectText);
	local sizeY = temp_ItemBase:GetSizeY()	
	local sizeX = frame_FileList:GetSizeX()
	local foldercount = _fileExplorer:getChildFolderList()

	_currentFrame.frame:SetShow(false);	
	_currentFrame.scroll:SetControlPos(0)
	swapFrame();
	_currentFrame.content:DestroyAllChild();
	_currentFrame.frame:SetShow(true)

	static_FilePath:SetText( _fileExplorer:getCurrentFolderName() )
		
	for index = 0, foldercount - 1 do
		local item = MakeFileItem( "folder_" .. tostring(index) )
		item._item:SetPosY( (index * sizeY)  + _itemYGap );
		item._text:SetText( _fileExplorer:getChildFolderNameAtIndex( index ) )
		item._item:SetSize( sizeX, item._item:GetSizeY() )
		item._item:SetShow(true)
		item._icon:SetShow(true)
		item._text:SetShow(true)
		
		local x1, y1, x2, y2 = setTextureUV_Func( item._icon, _folder_textureInfo.x, _folder_textureInfo.y, _folder_textureInfo.endX, _folder_textureInfo.endY )
		item._icon:getBaseTexture():setUV(  x1, y1, x2, y2  )		
		item._icon:setRenderTexture(item._icon:getBaseTexture())
		item._item:addInputEvent( "Mouse_LDClick", "goToChildFolderAtIndex(" .. index .. ")" )
	end
	
	local selectType = list_Ext:GetSelectIndex();
	if( 0 <= selectType ) then
		for index = 0, count - 1 do
			local item = MakeFileItem( tostring(index) )
			
			if( _bDirectorySerch ) then
				item._item:SetPosY( ( ( foldercount + index ) * sizeY)  + _itemYGap );
			else
				item._item:SetPosY( (index  * sizeY)  + _itemYGap );
			end

			item._text:SetTextMode( CppEnums.TextMode.eTextMode_LimitText )
			item._text:SetText( _fileExplorer:getFileNameAtIndex( index ) )
			item._item:SetSize( sizeX, item._item:GetSizeY() )
			item._item:SetShow(true)
			item._icon:SetShow(true)
			item._text:SetShow(true)

			local x1, y1, x2, y2 = setTextureUV_Func( item._icon, _ext_arr[_current_ext_type][selectType].x, _ext_arr[_current_ext_type][selectType].y, _ext_arr[_current_ext_type][selectType].endX, _ext_arr[_current_ext_type][selectType].endY )
			item._icon:getBaseTexture():setUV(  x1, y1, x2, y2  )
			item._icon:setRenderTexture(item._icon:getBaseTexture())

			item._item:addInputEvent( "Mouse_LUp", "ClickItem(" .. index .. ")" );
			--item._item:addInputEvent( "Mouse_LDClick", "callOpenFunction(" .. index .. ")" );
		end
	end

	_currentFrame.frame:UpdateContentPos()
	
	_currentFrame.frame:UpdateContentScroll()
end

function FileExplorer_SetDirectorySerch( bUse )
	_bDirectorySerch = bUse
end

function Toggle_ExtBox()
	combo_Ext:ToggleListbox()
end

function FileExplorer_SetNameToBtn_Confirm( name )
	btn_Confirm:SetText( name )
end

-- Link Function to confirm Button 
function FileExplorer_CustomConfirmFunction( func )
	_btn_ConfirmFunction = func;
end

-- run Confirm Button
function FileExplorer_Confirm( index )
	if( _btn_ConfirmFunction == nil ) then
		return
	end
		
	_btn_ConfirmFunction( text_EditBox:GetEditText() )	
end

function FileExplorer_clearPrevPathList()
	ClearPrevPathlist()
end

function FileExplorer_SetEditText( text )
	text_EditBox:SetEditText( text )
end

function FileExplorer_GetEditText()
	return text_EditBox:GetEditText()
end

function closeExplorer()
	Panel_FileExplorer:SetShow( false )
end

function goToParentFolder()
	_fileExplorer:gotoParentPath()
	refreshFileList()
end

function gotoPrevFolder()
	-- PrevPath가 비었다면 더이상 앞으로 가지 않는다.
	-- if (EmptyPrevPath()) then
		-- return;
	-- end

	_fileExplorer:gotoPrevPath();
	refreshFileList()
end

function goToChildFolderAtIndex( index )
	_fileExplorer:ClearPrevPathlist()
	_fileExplorer:gotoChildPathAtIndex( index )
	refreshFileList()
end

function ClickItem( index )
	local FileName = _fileExplorer:getFileNameAtIndex(index)
				
	text_EditBox:SetEditText(FileName)
end

function SlectExtListIndex()
	local selectIndex = list_Ext:GetSelectIndex();
	combo_Ext:SetSelectItemIndex( selectIndex );
		
	refreshFileList();
end

function callOpenFunction( index )
	closeExplorer()
	if( nil == _openWithFunction ) then
		return;
	end

	local text = _fileExplorer:getCurrentPath();
	text = "" .. text .. "\\" .. _fileExplorer:getFileNameAtIndex(index);
	_openWithFunction(text);
end