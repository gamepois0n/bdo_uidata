
local Button_Close = UI.getChildControl(Panel_CustomizationVoice, 			"Button_Close")
local Frame_ContentImage    = UI.getChildControl(Panel_CustomizationVoice,	"Frame_Content_Image")
local Static_PayMark    	= UI.getChildControl(Panel_CustomizationVoice,	"Static_PayMark")
local StaticText_Title		= UI.getChildControl(Panel_CustomizationVoice,	"StaticText_Title")
local Static_SelectMark 	= UI.getChildControl(Panel_CustomizationVoice,	"Static_SelectMark" )
local StaticText_Slider 	= UI.getChildControl(Panel_CustomizationVoice,	"StaticText_VoiceTitle" )
local Slider_Voice 			= UI.getChildControl(Panel_CustomizationVoice,	"Slider_VoiceSelectControl")
local Slider_Voice_Btn 		= UI.getChildControl(Slider_Voice,				"Slider_VoiceSelect_CtrlButton")
local PlayVoice_Ctrl 		= UI.getChildControl(Panel_CustomizationVoice,	"Button_ApplyVoice")
local voiceCountText		= UI.getChildControl(Panel_CustomizationVoice,	"StaticText_VoiceCount" )

local text = PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_VOICE")
StaticText_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_VOICE")) -- 포즈 취하기

-- Button Event
Button_Close:addInputEvent("Mouse_LUp", "closeVoiceUI()")
Slider_Voice:addInputEvent("Mouse_LPress", "updatePitchSlider()")
Slider_Voice_Btn:addInputEvent("Mouse_LPress",	"updatePitchSlider()")
PlayVoice_Ctrl:addInputEvent("Mouse_LUp", "playVoice()")

-- event Regis
registerEvent("EventCloseVoiceUI", "closeVoiceUI()")
---------------------------------------------------------------------------------------------------------------
local NoCashType 	= CppEnums.CustomizationNoCashType
local NoCashMesh 	= CppEnums.CustomizationNoCashMesh
local NoCashDeco 	= CppEnums.CustomizationNoCashDeco
local NoCashVoice 	= CppEnums.CustomizationNoCashVoice

local textureColumnCount = 4
local ColumnCount = 5
local ImageGap = 5
local columnWidth = Frame_ContentImage:GetSizeX() + ImageGap
local columnHeight = Frame_ContentImage:GetSizeY() +ImageGap

local contentsOffsetX = 20
local contentsOffsetY = 60
local VoiceCount = 1;
local ContentImage = {}
local currentVoiceIndex = 1;

local selectedClassType 	= nil
local selectedIndex 		= nil
local selectedInGameMode	= nil

local UpdateMarkPosition = function(index) 
	if index ~= -1 then
		Static_SelectMark:SetShow(true)
		Static_SelectMark:SetPosX( index%ColumnCount * columnWidth + contentsOffsetX )
		Static_SelectMark:SetPosY( math.floor(index/ColumnCount)  * columnHeight + contentsOffsetY )
	else
		Static_SelectMark:SetShow(false)
	end
end

local clearContentList = function()
	for _, content in pairs( ContentImage ) do
		content:SetShow(false)
		UI.deleteControl(content)
	end
	ContentImage = {}
end

function createVoiceList( inGameMode, classType )
	clearContentList()
	VoiceCount 			= getClassVoiceCount();
	selectedInGameMode	= inGameMode
	selectedClassType 	= classType
	local texWidth 		= 48;
	local texHeight 	= 48;
	local texColumCount = 4;
	for itemIdx = 0, VoiceCount - 1 do
		local tempContentImage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_CustomizationVoice, "Frame_Image_" .. itemIdx )
		CopyBaseProperty ( Frame_ContentImage, tempContentImage )
		--tempContentImage:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_Voice.dds")
		
		local tempVoiceCount = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempContentImage, "Frame_VoiceCount_" .. itemIdx )
		CopyBaseProperty ( voiceCountText, tempVoiceCount )
		
		local staticPayMark = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempContentImage, "Static_PayMark_" .. itemIdx )
		CopyBaseProperty ( Static_PayMark, staticPayMark )
		
		--local texCol = itemIdx % texColumCount;
		--local texRow = math.floor(itemIdx / texColumCount);
		--local x1, y1, x2, y2 = setTextureUV_Func( tempContentImage, 
												--( (texCol * texWidth) + 1 ),
												--( (texRow * texHeight) + 1 ),
												--( ( texCol + 1 ) * texWidth ),
												--( ( texRow + 1 ) * texHeight) )
		--tempContentImage:getBaseTexture():setUV(x1, y1, x2, y2 )
		tempContentImage:addInputEvent("Mouse_LUp", "UpdateVoiceMessage(" .. itemIdx .. ")")
		tempContentImage:SetPosX( itemIdx%ColumnCount * columnWidth + contentsOffsetX )
		tempContentImage:SetPosY( math.floor(itemIdx/ColumnCount) * columnHeight + contentsOffsetY )
		tempContentImage:setRenderTexture( tempContentImage:getBaseTexture() )
		if ( not FGlobal_IsInGameMode() ) and (not isNormalCustomizingIndex(classType, NoCashType.eCustomizationNoCashType_Voice, NoCashVoice.eCustoimzationNoCashVoice_Type, itemIdx)) and ( isServerFixedCharge() ) then
			tempContentImage:SetShow( false )
		else
			tempContentImage:SetShow( true )
		end
		tempVoiceCount:SetText( itemIdx + 1 )
		tempVoiceCount:SetShow( true )

		if(not isNormalCustomizingIndex(classType, NoCashType.eCustomizationNoCashType_Voice, NoCashVoice.eCustoimzationNoCashVoice_Type, itemIdx)) then
			staticPayMark:SetShow( true )
		else
			staticPayMark:SetShow( false )
		end
		
		ContentImage[itemIdx] = tempContentImage
	end		
end

function UpdateVoiceMessage( index )
	selectedIndex	= index
--{ 메시지 박스를 두개를 띄웠을 때 두번쨰 띄운 정렬이 middle로 고정되어서 allClearMessageData() 해줌.
	if Panel_Win_System:GetShow() then
		MessageBox_Empty_function()
		allClearMessageData()
	end	
--}
	if ((not selectedInGameMode) and (not isNormalCustomizingIndex(selectedClassType, NoCashType.eCustomizationNoCashType_Voice, NoCashVoice.eCustoimzationNoCashVoice_Type, index))) then
		local	messageBoxMemo = PAGetString ( Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MSGBOX_APPLY_CASHITEM")
		local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = UpdateVoice, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData, "top")
	else
		UpdateVoice()
	end
	
end

function UpdateVoice()
	UpdateMarkPosition( selectedIndex )

	currentVoiceIndex = selectedIndex + 1;
	playVoice()
end

function playVoice()
	applyVoice( currentVoiceIndex )
end

function showVoiceUI( show )
	Panel_CustomizationVoice:SetShow( show )
	if true == show then
		CloseFrameForPoseUI()
		Panel_CustomizationVoice:SetPosX( Panel_CustomizationFrame:GetPosX() )
		Panel_CustomizationVoice:SetPosY( Panel_CustomizationFrame:GetPosY() )
		selectedIndex = getVoiceType() - 1
		UpdateVoice() -- 0 이 default
		Slider_Voice:SetControlPos( getVoicePitch())
		updatePitchSlider()
	end
end

function closeVoiceUI()
	if(	Panel_CustomizationImage:GetShow() ) then	
		CloseTextureUi()
		return
	end
	
	if( Panel_CustomizationVoice:GetShow() == true ) then
		Panel_CustomizationFrame:SetPosX( Panel_CustomizationVoice:GetPosX() )
		Panel_CustomizationFrame:SetPosY( Panel_CustomizationVoice:GetPosY() )
		showVoiceUI( false )
		clearContentList()
		CustomizationMainUIShow( true )
		selectPoseControl(0)
	end
--	selectCustomizationControlPart(-1)
--	selectCustomizationControlGroup(-1)
end

function updatePitchSlider()
	local range = 100;
	local ratio = Slider_Voice:GetControlPos()
	applyVoicePitch( ratio * range )
end
