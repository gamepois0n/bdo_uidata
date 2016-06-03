local UI_TM = CppEnums.TextMode
local VCK = CppEnums.VirtualKeyCode
local UI_color 		= Defines.Color
Panel_Movie_KeyViewer:SetDragAll( false )
Panel_Movie_KeyViewer:SetIgnore( true )
		
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local ui = {
	_button_Q 			= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_Btn_Q" ),

	_button_W 			= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_Btn_W" ),
	_button_A 			= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_Btn_A" ),
	_button_S			= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_Btn_S" ),
	_button_D 			= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_Btn_D" ),

	_button_E 			= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_Btn_E" ),
	_button_F 			= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_Btn_F" ),

	_button_Tab 		= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_Btn_Tab" ),
	_button_Shift 		= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_Btn_Shift" ),
	_button_Space 		= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_Btn_Space" ),

	_m0 				= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_M0" ),
	_m1 				= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_M1" ),
	_mBody 				= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_Mouse_Body" ),

	_buttonLock 		= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_Button_Lock" ),
	_m0_Lock 			= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_M0_Lock" ),
	_m1_Lock 			= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_M1_Lock" ),
}

local ui_2 = {
	_button_Q 			= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_Btn_Q_2" ),

	_button_W 			= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_Btn_W_2" ),
	_button_A			= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_Btn_A_2" ),
	_button_S			= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_Btn_S_2" ),
	_button_D			= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_Btn_D_2" ),

	_button_E			= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_Btn_E_2" ),
	_button_F			= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_Btn_F_2" ),

	_button_Tab			= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_Btn_Tab_2" ),
	_button_Shift		= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_Btn_Shift_2" ),
	_button_Space 		= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_Btn_Space_2" ),

	_m0 				= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_M0_2" ),
	_m1 				= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_M1_2" ),
	_mBody 				= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_Mouse_Body_2" ),

	_buttonLock			= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_Button_Lock_2" ),
	_m0_Lock			= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_M0_Lock_2" ),
	_m1_Lock			= UI.getChildControl ( Panel_Movie_KeyViewer, "StaticText_M1_Lock_2" ),
}

local uvSet = {
		_m0 			= { on = { 1, 66, 74, 143 } , 	click = { 75, 65, 148, 143 }, 	off = { 149, 66, 222, 143 }},
		_m1 			= { on = { 1, 144, 74, 221 } , 	click = { 75, 143, 148, 221 }, 	off = { 149, 144, 222, 221 }},
		_button_W 		= { on = { 1, 1, 63, 65 } , 	click = { 63, 0, 126, 65 }, 	off = { 127, 1, 189, 65 }},
		_button_A 		= { on = { 1, 1, 63, 65 } , 	click = { 63, 0, 126, 65 }, 	off = { 127, 1, 189, 65 }},
		_button_S		= { on = { 1, 1, 63, 65 } , 	click = { 63, 0, 126, 65 }, 	off = { 127, 1, 189, 65 }},
		_button_D 		= { on = { 1, 1, 63, 65 } , 	click = { 63, 0, 126, 65 }, 	off = { 127, 1, 189, 65 }},
		_button_E 		= { on = { 1, 1, 63, 65 } , 	click = { 63, 0, 126, 65 }, 	off = { 127, 1, 189, 65 }},
		_button_F 		= { on = { 1, 1, 63, 65 } , 	click = { 63, 0, 126, 65 }, 	off = { 127, 1, 189, 65 }},
		_button_Tab 	= { on = { 1, 1, 63, 65 } , 	click = { 63, 0, 126, 65 }, 	off = { 127, 1, 189, 65 }},
		_button_Shift 	= { on = { 1, 1, 63, 65 } , 	click = { 63, 0, 126, 65 }, 	off = { 127, 1, 189, 65 }},
		_button_Space 	= { on = { 1, 1, 63, 65 } , 	click = { 63, 0, 126, 65 }, 	off = { 127, 1, 189, 65 }},
		_button_Q 		= { on = { 1, 1, 63, 65 } , 	click = { 63, 0, 126, 65 }, 	off = { 127, 1, 189, 65 }},
}

local keyIndexSet = {
	_m0 					= ( 4 )		,
	_m1 					= ( 5 )		,
	_button_Q 				= ( 12 )	,
	_button_W 				= ( 0 )		,
	_button_A 				= ( 2 )		,
	_button_S				= ( 1 )		,
	_button_D 				= ( 3 )		,
	_button_E 				= ( 13 )	,
	_button_F 				= ( 14 )	,
	_button_T 				= ( 9 )		,
	_button_Tab 			= ( 10 )	,
	_button_Shift 			= ( 6 )		,
	_button_Space 			= ( 7 )		,
}

local keyToVirtualKey = {
	_m0 					= ( 4 )		,
	_m1 					= ( 5 )		,
	_button_Q 				= ( 12 )	,
	_button_W 				= ( 0 )		,
	_button_A 				= ( 2 )		,
	_button_S				= ( 1 )		,
	_button_D 				= ( 3 )		,
	_button_E 				= ( 13 )	,
	_button_F 				= ( 14 )	,
	_button_T 				= ( 9 )		,
	_button_Tab 			= ( 10 )	,
	_button_Shift 			= ( 6 )		,
	_button_Space 			= ( 7 )		,
}

local keyIsUpdate = {
	_m0 				= "off",
	_m1 				= "off",
	_button_W 			= "off",
	_button_A 			= "off",
	_button_S			= "off",
	_button_D 			= "off",
	_button_E 			= "off",
	_button_F 			= "off",
	_button_Tab 		= "off",
	_button_Shift 		= "off",
	_button_Space 		= "off",
	_button_Q 			= "off",
}

-- {기본 위치 설정
Panel_Movie_KeyViewer:SetPosX( getScreenSizeX() - ( getScreenSizeX() - Panel_Movie_KeyViewer:GetSizeX() ) - Panel_Movie_KeyViewer:GetSizeX() / 1.5 )
Panel_Movie_KeyViewer:SetPosY( getScreenSizeY() - ( getScreenSizeY() -  Panel_Movie_KeyViewer:GetSizeY() * 2.3 ) )

local panelKeyViewerPosX = Panel_Movie_KeyViewer:GetPosX()
local panelKeyViewerPosY = Panel_Movie_KeyViewer:GetPosY()
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 화면 리사이즈
function Panel_KeyViewer_ScreenRePosition()
	local scrX = getScreenSizeX()
	local scrY = getScreenSizeY()

	changePositionBySever(Panel_Movie_KeyViewer, CppEnums.PAGameUIType.PAGameUIPanel_KeyViewer, true, true, false)

	if scrX < (Panel_Movie_KeyViewer:GetPosX() + Panel_Movie_KeyViewer:GetSizeX()) then
		Panel_Movie_KeyViewer:SetPosX( scrX - Panel_Movie_KeyViewer:GetSizeX() )
	end
	if Panel_Movie_KeyViewer:GetPosX() < 0 then
		Panel_Movie_KeyViewer:SetPosX( 0 )
	end
	if scrY < (Panel_Movie_KeyViewer:GetPosY() + Panel_Movie_KeyViewer:GetSizeY()) then
		Panel_Movie_KeyViewer:SetPosX( scrY - Panel_Movie_KeyViewer:GetSizeY() )
	end
	if Panel_Movie_KeyViewer:GetPosY() < 0 then
		Panel_Movie_KeyViewer:SetPosY( 0 )
	end

	-- ui 안에 놈들 알아서 정렬
	for key, value in pairs(ui) do
		value:ComputePos()
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 공용 : 버튼 눌렀을 때 색 바꿔주기!!
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local ButtonToggle = function( key, isOn )
	local aUI 	= ui[key]
	local aUI2 = ui_2[key]
	local keyName = "on"
	aUI:SetFontColor ( UI_color.C_FFC4BEBE )
	
	----------------------------------------
	--			키를 떼었을 때 (여기로 안온다)		---- 나중에 처리해야함
	if ( false == isOn ) then
		keyName = "off"
		aUI:SetShow(true)
		aUI2:SetShow(false)

		if ( keyIsUpdate[key] ~= "off" ) then
			keyIsUpdate[key] = "off"
		end
		
	----------------------------------------
	--			키를 눌렀을 때
	elseif ( true == isOn ) and ( keyCustom_IsPressed_Action( keyToVirtualKey[key] ) ) then
		keyName = "click"
		aUI2:SetFontColor ( UI_color.C_FFFFCE22 )
		aUI:SetShow(false)
		aUI2:SetShow(true)

		if ( keyIsUpdate[key] ~= "click" ) then
			keyIsUpdate[key] = "click"
			
			-- aUI:ResetVertexAni()
			-- aUI2:ResetVertexAni()
			aUI:SetAlpha(0)
			aUI2:SetAlpha(1)
			--aUI:SetVertexAniRun("Ani_Color_Alpha100_0", true)
			--aUI2:SetVertexAniRun("Ani_Color_Alpha0_100", true)
		end
	else
		--on
		aUI:SetShow(true)
		
		----------------------------------------
		--			키를 뗐을 때
		if ( keyIsUpdate[key] ~= "on" ) then
			keyIsUpdate[key] = "on"
			
			aUI:SetShow(true)
			-- aUI2:SetShow(false)
			
			--aUI:ResetVertexAni()
			--aUI2:ResetVertexAni()
			aUI:SetAlpha(1)
			aUI2:SetAlpha(0)
			-- aUI:SetVertexAniRun("Ani_Color_Alpha0_100", true)
			-- aUI2:SetVertexAniRun("Ani_Color_Alpha100_0", true)
		end
	end

	if ( isOn ) then
		if ( "_m0" == key ) then
			aUI:SetText("L")
			aUI2:SetText("L")
		elseif ( "_m1" == key ) then
			aUI:SetText("R")
			aUI2:SetText("R")
		else
			local actionString = "";
			if getGamePadEnable() then
				actionString = keyCustom_GetString_ActionPad( keyIndexSet[key] );
			else
				actionString = keyCustom_GetString_ActionKey( keyIndexSet[key] );
			end
			aUI:SetText(actionString)
			aUI2:SetText(actionString)
		end
	else
		aUI:SetText(" ")
		aUI2:SetText(" ")
	end
end

local ButtonToggleAll = function(isOn)
	for key, value in pairs(uvSet) do
		ButtonToggle(key, isOn)
	end
end


-- function Panel_KeyViewer_MainFunc()
-- 	if ( false == Panel_Movie_KeyViewer:GetShow() ) then
-- 		Panel_KeyViewer_Show()

-- 	else
-- 		Panel_KeyViewer_Hide()
-- 	end
-- end

function FGlobal_KeyViewer_Show()
	Panel_Movie_KeyViewer:SetShow( true )
	Panel_KeyViewer_KeyUpdate()
end

function FGlobal_KeyViewer_Hide()
	Panel_Movie_KeyViewer:SetShow( false )
end

function Panel_KeyViewer_Show()
	Panel_Movie_KeyViewer:SetShow( true )
	Panel_KeyViewer_KeyUpdate()
end

function Panel_KeyViewer_Hide()
	Panel_Movie_KeyViewer:SetShow( false )
end

function Panel_KeyViewer_KeyUpdate()
	ui._m0:SetText ("L")
	ui._m1:SetText ("R")
	
	ButtonToggleAll(true)
end

local forMovieRecord = function()
	Panel_MainStatus_User_Bar:SetShow( false )
	Panel_SelfPlayerExpGage:SetShow( false )
	Panel_Chat0:SetShow( false )
	Panel_QuickSlot:SetShow( false )
	Panel_UIMain:SetShow( false )
	Panel_CheckedQuest:SetShow( false )
	
	--Panel_RadarRealLine.panel:SetShow( false )
	--Panel_Radar:SetShow( false )
	FGlobal_Panel_RadarRealLine_Show( false )
	FGlobal_Panel_Radar_Show(false)
	
	Panel_SkillCommand:SetShow( false )
	Panel_TimeBar:SetShow( false )
	Panel_NpcNavi:SetShow( false )
end

function PanelMovieKeyViewer_RestorePosition()
	Panel_Movie_KeyViewer:SetPosX( panelKeyViewerPosX )
	Panel_Movie_KeyViewer:SetPosY( panelKeyViewerPosY )	
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

registerEvent("onScreenResize", "Panel_KeyViewer_ScreenRePosition")
Panel_Movie_KeyViewer:RegisterUpdateFunc("Panel_KeyViewer_KeyUpdate")

-- forMovieRecord()
-- Panel_KeyViewer_Show()


-- 동영상 촬영용 
if ( ToClient_developmentUtility_MovieCaptureMode() == true ) then
	-- Panel_Movie_KeyViewer:SetScaleChild(1.3, 1.3)
	
	-- Panel_Movie_KeyViewer:SetDragAll( true)
	-- Panel_Movie_KeyViewer:SetIgnore( false )
end