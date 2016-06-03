Panel_Window_BlackSpiritAdventure:SetShow ( false )	
Panel_Window_BlackSpiritAdventure:setMaskingChild( true )
Panel_Window_BlackSpiritAdventure:setGlassBackground( true )
Panel_Window_BlackSpiritAdventure:SetDragAll( true )

Panel_Window_BlackSpiritAdventure:RegisterShowEventFunc( true, 'BlackSpiritAdventure_ShowAni()' )
Panel_Window_BlackSpiritAdventure:RegisterShowEventFunc( false, 'BlackSpiritAdventure_HideAni()' )

local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local isBlackSpiritAdventure = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 1015 )	-- 흑정령의 모험(펄마블)

------------------------------------------------------
--					창 애니메이션
------------------------------------------------------
function BlackSpiritAdventure_ShowAni()
	UIAni.fadeInSCR_Down( Panel_Window_BlackSpiritAdventure )
	-- audioPostEvent_SystemUi(01,00)
	
	local aniInfo1 = Panel_Window_BlackSpiritAdventure:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.2)
	aniInfo1.AxisX = Panel_Window_BlackSpiritAdventure:GetSizeX() / 2
	aniInfo1.AxisY = Panel_Window_BlackSpiritAdventure:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_Window_BlackSpiritAdventure:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.2)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_Window_BlackSpiritAdventure:GetSizeX() / 2
	aniInfo2.AxisY = Panel_Window_BlackSpiritAdventure:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function BlackSpiritAdventure_HideAni()
	Panel_Window_BlackSpiritAdventure:SetAlpha( 1 )
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_Window_BlackSpiritAdventure, 0.0, 0.1 )
	aniInfo:SetHideAtEnd(true)
end

local btnClose = UI.getChildControl( Panel_Window_BlackSpiritAdventure, "Button_Win_Close" )
btnClose:addInputEvent( "Mouse_LUp", "BlackSpiritAd_Hide()")

local btnQuestion = UI.getChildControl( Panel_Window_BlackSpiritAdventure, "Button_Question" )
btnQuestion:SetShow( false )

local	_Web	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_Window_BlackSpiritAdventure, 'WebControl_EventNotify_WebLink' )
		_Web	:SetShow( true )
		_Web	:SetPosX(11)
		_Web	:SetPosY(50)
		_Web	:SetSize( 918, 655 )
		_Web	:ResetUrl()

function BlackSpiritAd_Show()
	if isBlackSpiritAdventure then
		Panel_Window_BlackSpiritAdventure:SetShow( true, true )
		Panel_Window_BlackSpiritAdventure:SetPosX( getScreenSizeX()/2 - Panel_Window_BlackSpiritAdventure:GetSizeX()/2)
		Panel_Window_BlackSpiritAdventure:SetPosY( getScreenSizeY()/2 - Panel_Window_BlackSpiritAdventure:GetSizeY()/2)
	else
		return
	end
	
	local myUserNo		= getSelfPlayer():get():getUserNo()
	local cryptKey		= getSelfPlayer():get():getWebAuthenticKeyCryptString()
	local bAdventureWebUrl	= blackSpiritUrlByServiceType()
	
	if nil ~= bAdventureWebUrl then
		local url	= bAdventureWebUrl .. "?userNo=" .. tostring(myUserNo) .. "&certKey=" .. tostring(cryptKey)
		_Web:SetUrl( 918, 655, url )
	end
end

function BlackSpiritAd_Hide()
	Panel_Window_BlackSpiritAdventure:SetShow( false, false )
end

function FGlobal_BlackSpiritAdventure_Open()
	BlackSpiritAd_Show()
end

function blackSpiritUrlByServiceType()
	local url = nil
	if CppEnums.CountryType.DEV == getGameServiceType() then				-- 내부 개발
		-- url = "https://192.168.2.72/boardgame/boardgame.pa"
		--url = "https://127.0.0.1/boardgame/boardgame.pa"
		url = "https://192.168.0.61/boardgame/boardgame.pa"
	elseif CppEnums.CountryType.KOR_ALPHA == getGameServiceType() then		-- 다음 QA
		url = "https://182.162.18.71:8885/boardgame/boardgame.pa"
	elseif CppEnums.CountryType.KOR_REAL == getGameServiceType() then		-- 다음 라이브
		url = "https://117.52.6.25:8885/boardgame/boardgame.pa"
	end
	return url
end
