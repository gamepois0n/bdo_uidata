local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM			= CppEnums.EProcessorInputMode

Panel_GuildWebInfo:SetShow( false )
Panel_GuildWebInfo:setGlassBackground( true )
Panel_GuildWebInfo:ActiveMouseEventEffect( true )

Panel_GuildWebInfo:RegisterShowEventFunc( true, 'Panel_GuildWebInfo_ShowAni()' )
Panel_GuildWebInfo:RegisterShowEventFunc( false, 'Panel_GuildWebInfo_HideAni()' )

local isBeforeShow = false

local eCountryType		= CppEnums.CountryType
local gameServiceType	= getGameServiceType()
local isNaver			= ( CppEnums.MembershipType.naver == getMembershipType() )

function Panel_GuildWebInfo_ShowAni()
	UIAni.fadeInSCR_Down( Panel_GuildWebInfo )
	
	local aniInfo1 = Panel_GuildWebInfo:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.1)
	aniInfo1.AxisX = Panel_GuildWebInfo:GetSizeX() / 2
	aniInfo1.AxisY = Panel_GuildWebInfo:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_GuildWebInfo:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.1)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_GuildWebInfo:GetSizeX() / 2
	aniInfo2.AxisY = Panel_GuildWebInfo:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function Panel_GuildWebInfo_HideAni()
	Panel_GuildWebInfo:SetAlpha( 1 )
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_GuildWebInfo, 0.0, 0.1 )
	aniInfo:SetHideAtEnd(true)
end


--------------------------------------------------------------------------------
local _btn_Close 			= UI.getChildControl( Panel_GuildWebInfo,	"Button_Close" )
local _btnHelp				= UI.getChildControl( Panel_GuildWebInfo,	"Button_Question" )
local _Web 					= nil
local isShowGuildWebInfo 	= false
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--					최초 초기화 함수
--------------------------------------------------------------------------------
function Panel_GuildWebInfo_Initialize()
	_Web		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_GuildWebInfo, 'WebControl_GuildWebInfo_WebLink' )
	_Web:SetShow( true )
	_Web:SetPosX( 43 )
	_Web:SetPosY( 63 )
	_Web:SetSize( 870, 600 )	-- 849, 488
	_Web:ResetUrl()
end
Panel_GuildWebInfo_Initialize()

--------------------------------------------------------------------------------
--						오픈
--------------------------------------------------------------------------------
function FGlobal_GuildWebInfo_Open( listIdx )
	local guildRanker	= ToClient_GetGuildRankingInfoAt( listIdx )
	local GuildNo_str	= tostring(guildRanker:getGuildNo_s64())

	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		return
	end

	if CppEnums.ContryCode.eContryCode_KOR ~= getContryTypeLua() then
		return
	end

	-- ♬ 창이 켜질 때 소리
	audioPostEvent_SystemUi(13,06)

	local curChannelData	= getCurrentChannelServerData()
	local serverNo			= curChannelData._worldNo
	local url				= ""

	if 0 == gameServiceType or 1 == gameServiceType or 2 == gameServiceType or 4 == gameServiceType then
		url = "http://dev.pub.game.daum.net/black/world/guild/guestBbs.daum?id=" .. GuildNo_str .. "&serverId=" .. serverNo .. "#1"
	elseif 3 == gameServiceType then	-- 다음 한국 서비스
		url = "http://black.game.daum.net/black/world/guild/guestBbs.daum?id=" .. GuildNo_str .. "&serverId=" .. serverNo .. "#1"
	else
		return	-- 한국이 아니다.
	end

	if true == isNaver then
		Proc_ShowMessage_Ack( "준비중입니다." )
		return
	end

	FGlobal_SetCandidate()
	_Web:SetSize( 870, 600 )
	_Web:SetUrl( 870, 600, url )
	_Web:SetIME(true)

	Panel_GuildWebInfo:SetPosX( (getScreenSizeX()/2) - (Panel_GuildWebInfo:GetSizeX()/2) )
	Panel_GuildWebInfo:SetPosY( (getScreenSizeY()/2) - (Panel_GuildWebInfo:GetSizeY()/2) )

	Panel_GuildWebInfo:SetShow( true, true )
end

function GuildWebInfo_Close()
	FGlobal_ClearCandidate()
	_Web:ResetUrl()
	-- ♬ 창이 꺼질 때 소리
	ClearFocusEdit();
	audioPostEvent_SystemUi(13,05)
	Panel_GuildWebInfo:SetShow( false, false )
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
end

function FGlobal_GuildWebInfoClose()
	GuildWebInfo_Close()
end

function HandleClicked_GuildWebInfo_Close()
	GuildWebInfo_Close()
end

_btn_Close			:addInputEvent( "Mouse_LUp", "HandleClicked_GuildWebInfo_Close()" )

_btnHelp:SetShow(false)	-- 도움말 추가시 삭제 및 아래 3라인 주석해제
-- _btnHelp			:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"GuildWebInfo\" )" )			--물음표 좌클릭
-- _btnHelp			:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"GuildWebInfo\", \"true\")" )	--물음표 마우스오버
-- _btnHelp			:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"GuildWebInfo\", \"false\")" )	--물음표 마우스아웃
