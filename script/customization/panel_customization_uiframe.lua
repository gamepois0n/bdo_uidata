
local StaticText_Category_Template 	= UI.getChildControl(Panel_CustomizationFrame, "StaticText_Category_Template")
local Button_ShowDetail_Template	= UI.getChildControl(Panel_CustomizationFrame, "Button_ShowDetail_Template")
local Button_Close	= UI.getChildControl(Panel_CustomizationFrame, "Button_Close")
local Panel_Child = UI.getChildControl(Panel_CustomizationFrame, "Panel_Child")
local CheckButton_UseFaceCustomizationHair = UI.getChildControl(Panel_CustomizationFrame, "CheckButton_UseFaceCustomizationHair")
local StaticText_UseFaceCustomizationHair = UI.getChildControl(Panel_CustomizationFrame, "StaticText_UseFaceCustomizationHair")
 
StaticText_UseFaceCustomizationHair:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONFRAME_USEFACECUSTOMIZATIONHAIR"))	-- 올림 머리 보기
 

 
Button_Close:addInputEvent("Mouse_LUp", "CloseFrame()")
registerEvent("EventCloseFrame", "CloseFrame" )
----------------------------------------------------------------------------------------------------
-- 새로 추가된 함수, 작업 완료 후 위의 두 registerEvent 지울것
registerEvent("EventOpenCustomizationUiGroupFrame", "OpenCustomizationUiGroupFrame")
registerEvent("EventCloseCustomizationUiGroupFrame", "CloseCustomizationUiGroupFrame")


----------------------------------------------------------------------------------------------------
CheckButton_UseFaceCustomizationHair:addInputEvent("Mouse_LUp", "CheckFaceCustomizationHair()")

CheckButton_UseFaceCustomizationHair:SetCheck(false)
 
g_selectedPart = 0
g_selectedPanel = nil

local panelGapWidth = 10
local panelGapHeight = 8

local customizationPartControl = {}
local partNum = 0
local partControlButtonHeight = StaticText_Category_Template:GetSizeY();
local radioButtonTextureName = "new_ui_common_forlua/Window/Lobby/cus_buttons.dds"

----------------------------------------------------------------------------------
--                                   local functions
----------------------------------------------------------------------------------

local clearGroupFrame = function()
	for partIndex = 1, partNum do
		customizationPartControl[partIndex].button:SetShow(false)
		customizationPartControl[partIndex].text:SetShow(false)
		UI.deleteControl( customizationPartControl[partIndex].button )
		UI.deleteControl( customizationPartControl[partIndex].text )
	end
	partNum = 0
	g_selectedPart = 0
	g_selectedPanel = nil
	customizationPartControl = {}
end

local radioButtonOnOff = function( part, on )
	--UI.debugMessage("radioButtonOnOff")
	if part == 0 or part > partNum then
		return 
	end 
	
	local selectedButtonControl = customizationPartControl[ part ].button
	
	if on == true then	
		selectedButtonControl:ChangeTextureInfoName( radioButtonTextureName )
		local x1, y1, x2, y2 = setTextureUV_Func( selectedButtonControl, 1, 23, 21, 43 )
		selectedButtonControl:getBaseTexture():setUV( x1, y1, x2, y2 )
		selectedButtonControl:setRenderTexture(selectedButtonControl:getBaseTexture())
		
		selectedButtonControl:ChangeOnTextureInfoName ( radioButtonTextureName )
		local x1, y1, x2, y2 = setTextureUV_Func( selectedButtonControl, 22, 23, 42, 43 )
		selectedButtonControl:getOnTexture():setUV(  x1, y1, x2, y2  )
			
		selectedButtonControl:ChangeClickTextureInfoName ( radioButtonTextureName )
		local x1, y1, x2, y2 = setTextureUV_Func( selectedButtonControl, 43, 23, 63, 43 )
		selectedButtonControl:getClickTexture():setUV(  x1, y1, x2, y2  )
	else
		selectedButtonControl:ChangeTextureInfoName( radioButtonTextureName )
		local x1, y1, x2, y2 = setTextureUV_Func( selectedButtonControl, 1, 1, 21, 21 )
		selectedButtonControl:getBaseTexture():setUV( x1, y1, x2, y2 )
		selectedButtonControl:setRenderTexture(selectedButtonControl:getBaseTexture())
		
		selectedButtonControl:ChangeOnTextureInfoName ( radioButtonTextureName )
		local x1, y1, x2, y2 = setTextureUV_Func( selectedButtonControl, 22, 1, 42, 21 )
		selectedButtonControl:getOnTexture():setUV(  x1, y1, x2, y2  )
			
		selectedButtonControl:ChangeClickTextureInfoName ( radioButtonTextureName )
		local x1, y1, x2, y2 = setTextureUV_Func( selectedButtonControl, 43, 1, 63, 21 )
		selectedButtonControl:getClickTexture():setUV(  x1, y1, x2, y2  )
	end
end

----------------------------------------------------------------------------------
--                                   global functions
----------------------------------------------------------------------------------

function SelectControlPart( partIndex )
	Panel_Child:SetShow(false)
	if g_selectedPart ~= 0 then
		radioButtonOnOff( g_selectedPart, false )
	end	
	
	if g_selectedPanel ~= nil then
		g_selectedPanel:MoveChilds(g_selectedPanel:GetID(), Panel_Child )
		g_selectedPanel:SetShow( false )
		g_selectedPanel = nil
	end
	
	if g_selectedPart ~= partIndex +1   then
		g_selectedPart = partIndex +1 
		radioButtonOnOff( g_selectedPart, true )
		selectCustomizationControlPart(partIndex) -- 클라이언트 함수 호출v				
	else
		if( g_selectedPart ~= 0 ) then
			g_selectedPart = 0
			updateGroupFrameControls( 0, nil )
			selectCustomizationControlPart(-1) 
		end
	end 
end

function updateGroupFrameControls( selectedPartSpaceLength , selectedPanel )

	EnableCursor( false )
	if selectedPanel ~= nil then
		--if g_selectedPanel ~= selectedPanel then
			selectedPanel:SetIgnore(true)
			Panel_Child:MoveChilds(Panel_Child:GetID(), selectedPanel )
			Panel_Child:SetShow( true )					
		--end
	end
	
	-- 현재 선택된 패널 저장 // 차후 돌려주기 위해서 
	g_selectedPanel = selectedPanel
	
	-- 첫 버튼 & text 시작 위치
	local textOffsetY = 	customizationPartControl[1].text:GetPosY()
	local buttonGap = 2
	
	for partIndex = 1, partNum do
		local buttonOffsetY = textOffsetY + buttonGap
		customizationPartControl[partIndex].text:SetPosY( textOffsetY )
		customizationPartControl[partIndex].button:SetPosY( buttonOffsetY )
		
		textOffsetY = textOffsetY + partControlButtonHeight
		-- 열려있는 파트 컨트롤 버튼 일 경우 열려있는 크기를 더해준다.
		if partIndex == g_selectedPart then
			local selectedPanelHeight = g_selectedPanel:GetSizeY() 
			Panel_Child:SetPosX( panelGapWidth )
			Panel_Child:SetPosY( panelGapHeight + textOffsetY )
			Panel_Child:SetSize( Panel_Child:GetSizeX(), selectedPanelHeight )
			textOffsetY = textOffsetY + panelGapHeight + selectedPanelHeight + panelGapHeight
		end 		
	end
	Panel_CustomizationFrame:SetSize( Panel_CustomizationFrame:GetSizeX(), textOffsetY + 4 )
	
end

function GetChildPanelPosX()
	return Panel_CustomizationFrame:GetPosX() + Panel_Child:GetPosX()
end

function GetChildPanelPosY()
	return Panel_CustomizationFrame:GetPosY() + Panel_Child:GetPosY()
end

function CloseFrameSlide()
	SelectControlPart( -1 )
	clearGroupFrame()
	selectCustomizationControlPart(-1)
	selectCustomizationControlGroup(-1)
end

function CloseFrame()	
	if(	Panel_CustomizationImage:GetShow() ) then	
		CloseTextureUi()
		return
	end
	
	EnableCursor( false )
	SelectControlPart( -1 )
	--local aniInfo = UIAni.AlphaAnimation( 0, Panel_CustomizationFrame, 0.0, 0.2 )
	--aniInfo:SetHideAtEnd(true)
	Panel_CustomizationFrame:SetShow( false, false )
	clearGroupFrame()
	selectCustomizationControlPart(-1)
	selectCustomizationControlGroup(-1)
	CustomizationMainUIShow( true )
end

function CloseFrameForPoseUI()
	--local aniInfo = UIAni.AlphaAnimation( 0, Panel_CustomizationFrame, 0.0, 0.2 )
	--aniInfo:SetHideAtEnd(true)
	Panel_CustomizationFrame:SetShow( false )
	clearGroupFrame()
end

function OpenCustomizationUiGroupFrame( classType, uiGroupIndex )
	ClearFocusEdit()
	clearGroupFrame()
	
	if uiGroupIndex == 1 then
		CheckFaceCustomizationHair()
		CheckButton_UseFaceCustomizationHair:SetShow(true)
		StaticText_UseFaceCustomizationHair:SetShow(true)
	else
		CheckButton_UseFaceCustomizationHair:SetShow(false)
		StaticText_UseFaceCustomizationHair:SetShow(false)
	end
	
	partNum = getUiPartCount( classType, uiGroupIndex )
	for uiPartIndex = 0, partNum-1 do 
		local luaUiPartIndex = uiPartIndex + 1 
		
		local partName = getUiPartDescName( classType, uiGroupIndex, uiPartIndex ) 
		
		local tempGroup = 
		{ 
			button, 
			text 
		}
		
		local tempStaticText = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_CustomizationFrame, "StaticText_Category_" .. uiPartIndex )
		CopyBaseProperty( StaticText_Category_Template, tempStaticText)
		tempStaticText:SetText( PAGetString(Defines.StringSheet_GAME, partName ) )
		tempStaticText:SetShow( true )
		tempStaticText:SetPosY(  StaticText_Category_Template:GetPosY() + uiPartIndex * partControlButtonHeight )
		
		local tempButton = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, Panel_CustomizationFrame, "Button_ShowDetail_" .. uiPartIndex )
		CopyBaseProperty( Button_ShowDetail_Template, tempButton)
		tempButton:SetShow( true )
		tempButton:SetPosY(  Button_ShowDetail_Template:GetPosY() + uiPartIndex * partControlButtonHeight )
		tempButton:addInputEvent("Mouse_LUp", "SelectControlPart(" .. uiPartIndex ..  ")" )
		
		tempGroup.text = tempStaticText
		tempGroup.button = tempButton
		
		customizationPartControl[ luaUiPartIndex ] = tempGroup
	end		
	SelectControlPart( 0 );
	
	Panel_CustomizationFrame:SetShow( true, false )

end

function CheckFaceCustomizationHair()
	setUseFaceCustomizationHair( CheckButton_UseFaceCustomizationHair:IsCheck() )	
end

function toggleShowFrameUI( show )
	Panel_CustomizationFrame:SetShow( show )
--[[
	if false == show then
		local aniInfo = UIAni.AlphaAnimation( 0, Panel_CustomizationFrame, 0.0, 0.2 )
		aniInfo:SetHideAtEnd(true)
	else
		Panel_CustomizationFrame:SetShow( true, false )
		Panel_CustomizationFrame:SetAlpha(0)
		local aniInfo = UIAni.AlphaAnimation( 1, Panel_CustomizationFrame, 0.0, 0.2 )
	end
	]]--
end
