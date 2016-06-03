local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color		= Defines.Color
local IM			= CppEnums.EProcessorInputMode
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE
local UI_TM 		= CppEnums.TextMode

Panel_MovieGuide:ActiveMouseEventEffect( true )
Panel_MovieGuide:setGlassBackground( true )

Panel_MovieGuide:RegisterShowEventFunc( true, 'Panel_MovieGuide_ShowAni()' )
Panel_MovieGuide:RegisterShowEventFunc( false, 'Panel_MovieGuide_HideAni()' )

Panel_HuntingAlertButton:ActiveMouseEventEffect( true )
Panel_HuntingAlertButton:setGlassBackground( true )

Panel_AutoTraining:SetShow( false )
Panel_AutoTraining:ActiveMouseEventEffect( true )
Panel_AutoTraining:setGlassBackground( true )

-----------------------------------------------------------------------------------------------------------------------------------------------
local _btn_MovieGuide		= UI.getChildControl ( Panel_MovieGuideButton, "Button_MovieTooltip" )
local _moviePlus			= UI.getChildControl ( Panel_MovieGuideButton, "StaticText_MoviePlus" )

local ui_PanelWindow = 
{
	_title				= UI.getChildControl ( Panel_MovieGuide, "StaticText_MovieTitle" ),
	_btn_Close			= UI.getChildControl ( Panel_MovieGuide, "Button_Close" ),
	_bgBox				= UI.getChildControl ( Panel_MovieGuide, "Static_MovieToolTipPanel_BG" ),

	_movieBG			= UI.getChildControl ( Panel_MovieGuide, "Static_MovieBG" ),
	_movieDesc			= UI.getChildControl ( Panel_MovieGuide, "StaticText_MovieDesc" ),

	_btn_Copy			= UI.getChildControl ( Panel_MovieGuide, "Button_Movie_0" ),

	_scroll				= UI.getChildControl ( Panel_MovieGuide, "VerticalScroll" ),

	NowMovieInterval	= 0,
	MinMovieInterval	= 0,
	CurrentListCount	= 0,
}

local _btn_HuntingAlert = UI.getChildControl( Panel_HuntingAlertButton, "Button_HuntingAlert" )
local _huntingPlus = UI.getChildControl( Panel_HuntingAlertButton, "StaticText_MoviePlus" )
_btn_HuntingAlert:addInputEvent( "Mouse_On", "Hunting_ToolTip_ShowToggle(true)" )
_btn_HuntingAlert:addInputEvent( "Mouse_Out", "Hunting_ToolTip_ShowToggle()" )


--------------------------------------------------------------------------------------
-- 흑정령 수련 부분
--------------------------------------------------------------------------------------

local _btn_AutoTraining	= UI.getChildControl( Panel_AutoTraining, "Button_AutoTraining" )
local _trainingText		= UI.getChildControl( Panel_AutoTraining, "StaticText_Training" )

_trainingText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_AUTOTRAINING_MESSAGE_9") )

_btn_AutoTraining:addInputEvent( "Mouse_LUp",	"AutoTraining_Set()" )
_btn_AutoTraining:addInputEvent( "Mouse_On",	"AutoTraining_ToolTip( true )" )
_btn_AutoTraining:addInputEvent( "Mouse_Out",	"AutoTraining_ToolTip()" )

local trainableMinLev = 50		-- 흑정령의 수련 가능 레벨
local autoTrain = false
local autoTraining_Init = function()
	if not ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 57 ) then
		return
	end
	autoTrain = false
	_trainingText:SetShow( autoTrain )					-- 텍스트 끔
	FGlobal_MovieGuideButton_Position()
end

function AutoTraining_Set()
	if Panel_Global_Manual:GetShow() then
		Proc_ShowMessage_Ack( "미니게임 중에는 흑정령의 수련을 이용할 수 없습니다." )
		return
	end
	
	local pcPosition = getSelfPlayer():get():getPosition()
	local regionInfo = getRegionInfoByPosition(pcPosition)	
	
	if not regionInfo:get():isSafeZone() then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_AUTOTRAINING_MESSAGE_1") ) -- "안전 지역에서만 흑정령의 수련을 사용할 수 있습니다." )
		return
	end
	
	local needExp		= Int64toInt32(getSelfPlayer():get():getNeedExp_s64())
	local currentexp	= Int64toInt32(getSelfPlayer():get():getExp_s64())
	local expRate		= currentexp * 100 / needExp
	local e1			= 10000
	local msg			= ""
	
	-- ToClient_GetAutoLevelUpMaxExpPercent() : 흑정령 수련으로 올릴 수 있는 최대 경험치 % (현재 80%로 세팅돼 있음, contentOption - etcOption )
	if ToClient_GetAutoLevelUpMaxExpPercent() < (expRate * e1) then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_AUTOTRAINING_MESSAGE_2") ) -- "흑정령의 수련을 통해 더 이상 경험치를 얻을 수 없습니다." )
		return
	end
	
	if ToClient_RequestSetAutoLevelUp( not autoTrain ) then
		autoTrain = not autoTrain
		_trainingText:SetShow( autoTrain )
		
		if autoTrain then
			msg = PAGetString(Defines.StringSheet_GAME, "LUA_AUTOTRAINING_MESSAGE_3") -- "흑정령의 수련을 시작합니다."
			_btn_AutoTraining:AddEffect("fUI_Soul_Training01", true, 0.0, 0.0)
		else
			msg = PAGetString(Defines.StringSheet_GAME, "LUA_AUTOTRAINING_MESSAGE_4") -- "흑정령의 수련을 종료합니다."
			_btn_AutoTraining:EraseAllEffect()
		end
		Proc_ShowMessage_Ack( msg )
	end
end

function AutoTraining_Stop()
	autoTrain = false
	_trainingText:SetShow( autoTrain )
	-- if ToClient_RequestSetAutoLevelUp( autoTrain ) then
		-- Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_AUTOTRAINING_MESSAGE_5") ) -- "더 이상 경험치를 얻을 수 없어 흑정령의 수련을 종료합니다." )
	-- end
end

function AutoTraining_ToolTip( isShow )
	if nil == isShow then
		TooltipSimple_Hide()
		return
	end
	local name, desc, uiControl = PAGetString(Defines.StringSheet_GAME, "LUA_AUTOTRAINING_MESSAGE_8"), nil, _btn_AutoTraining
	local maxExpPercent = ToClient_GetAutoLevelUpMaxExpPercent() / 10000
	
	if autoTrain then
		desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_AUTOTRAINING_MESSAGE_6", "percent", maxExpPercent) -- "흑정령의 수련은 현재 레벨 경험치의 " .. maxExpPercent .. "%까지만 진행할 수 있습니다. 버튼 클릭 시 흑정령의 수련을 종료합니다."
	else
		desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_AUTOTRAINING_MESSAGE_7", "percent", maxExpPercent) -- "버튼 클릭 시 흑정령의 수련을 진행합니다. 흑정령의 수련은 현재 경험치가 " .. maxExpPercent .. "% 이내일 때 안전 지대에서만 가능합니다."
	end
	
	registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
	TooltipSimple_Show( uiControl, name, desc )	
end

function Init_AutoTraining()
	autoTraining_Init()
end

registerEvent( "EventSelfPlayerLevelUp", "Init_AutoTraining" )
registerEvent( "FromClient_CantIncreaseExpWithAutoLevelUp", "AutoTraining_Stop" )

-----------------------------------------------------------------------------------------
-- 버스터콜 세팅
-----------------------------------------------------------------------------------------

local _btn_BusterCall	= UI.getChildControl( Panel_BusterCall, "Button_BusterCall" )

_btn_BusterCall:addInputEvent( "Mouse_LUp", "Click_BusterCall()" )
_btn_BusterCall:addInputEvent( "Mouse_On", "BusterCall_ToolTip( true )" )
_btn_BusterCall:addInputEvent( "Mouse_Out", "BusterCall_ToolTip()" )

-- 길드 스킬 집결 명령
function BusterCall_ToolTip( isShow )
	if nil == isShow then
		TooltipSimple_Hide()
		return
	end
	
	local usableTime64 = ToClient_GetGuildBustCallTime();
	local descStr = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_BUSTERCALL_TOOLTIP_DESC", "time", convertStringFromDatetime(getLeftSecond_TTime64(usableTime64)) )
	
	local name, desc, uiControl = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_BUSTERCALL_TOOLTIP_NAME"), descStr, _btn_BusterCall
	
	registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
	TooltipSimple_Show( uiControl, name, desc )
end

function Click_BusterCall()
	ToClient_RequestTeleportGuildBustCall()
	TooltipSimple_Hide()
	Panel_BusterCall_Close()
end

function Response_GuildBusterCall( sendType )

	if( 0 == sendType ) then -- 사용 가능함
		Panel_BusterCall_Open()
		luaTimer_AddEvent( Panel_BusterCall_Close, 600000, false, 0 )
	else -- 사용한 상태
		Panel_BusterCall_Close()
	end

end

function Panel_BusterCall_Open()
	local isGuildMaster		= getSelfPlayer():get():isGuildMaster()
	if isGuildMaster then		-- 길드마스터는 버튼을 띄우지 않는다!
		Panel_BusterCall_Close()
		return
	end
	
	Panel_BusterCall:SetShow( true )
	_btn_BusterCall:EraseAllEffect()
	_btn_BusterCall:AddEffect("fUI_Buster_Call01", true, 0.0, 0.0)
end

function Panel_BusterCall_Close()
	if Panel_BusterCall:GetShow() then
		_btn_BusterCall:EraseAllEffect()
		Panel_BusterCall:SetShow( false )
	end
end

local busterCallCheck = function()
	if isFlushedUI() then
		return
	end
	
	local leftTime = Int64toInt32(getLeftSecond_TTime64(ToClient_GetGuildBustCallTime()))
	if 0 < leftTime then
		Panel_BusterCall_Open()
	else
		Panel_BusterCall_Close()
	end
end
busterCallCheck()

registerEvent( "FromClient_ResponseBustCall",			"Response_GuildBusterCall")

-----------------------------------------------------------------------------------------
-- if getEnableSimpleUI() then
-- 	Panel_MovieGuideButton:SetShow( false )
-- 	Panel_MovieGuide:SetShow( false )
-- end

-- function MovieGuide_EnableSimpleUI()
-- 	Panel_MovieGuideButton:SetShow( false )
-- 	Panel_MovieGuide:SetShow( false )
-- end
function MovieGuide_DisableSimpleUI()
	if ( (5 == getGameServiceType() or 6 == getGameServiceType()) and getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_CBT ) then
		Panel_MovieGuideButton:SetShow( false )
	end
end
-- registerEvent( "EventSimpleUIEnable",			"MovieGuide_EnableSimpleUI")
registerEvent( "EventSimpleUIDisable",			"MovieGuide_DisableSimpleUI")

local _btn_Scroll			= UI.getChildControl ( ui_PanelWindow._scroll, "VerticalScroll_CtrlButton" )

_btn_MovieGuide				:addInputEvent( "Mouse_LUp", "Panel_MovieGuide_ShowToggle()" )
ui_PanelWindow._btn_Close	:addInputEvent( "Mouse_LUp", "Panel_MovieGuide_ShowToggle()" )

ui_PanelWindow._scroll		:addInputEvent("Mouse_LUp",		"HandleClick_MovieGuide()")
_btn_Scroll					:addInputEvent("Mouse_LUp",		"HandleClick_MovieGuide()")
_btn_Scroll					:addInputEvent("Mouse_LPress",	"HandleClick_MovieGuide()")

ui_PanelWindow._movieBG   	:SetShow( false )
ui_PanelWindow._movieDesc   :SetShow( false )
ui_PanelWindow._btn_Copy   	:SetShow( false )

local NowTitleInterval			= 0
local MinTitleInterval			= 0
local MaxTitleInterval			= 0

--------------------------------------------------------
-------- 영상 추가될 때마다 단계 추가 해줘야한다!
-------- 이 곳에 영상이 추가되면 \WorldMap\New_WorldMap_Panel.lua 에도 수정해줘야한다.(목록은 아래 참조)
-------- 공헌도로 거점 연결/회수, 공헌도로 집 용도 변경/회수, 일꾼 고용 및 일 시키기, 주거지 배치 및 이사 안내 
--------------------------------------------------------
local movieDesc = nil
if isGameTypeKorea() or isGameTypeJapan()  then
	movieDesc = {
		[0] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_0"), -- 캐릭터 기본 이동
		[1] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_1"), -- 의뢰 수행하기
				
		[2] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_2"), -- 길 찾기 방법
		[3] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_3"), -- 기술 습득 방법
		[4] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_4"), -- 의뢰 목표물 구분하기
		
		[5] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_5"), -- 전투의 기본 - 워리어
		[6] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_6"), -- 전투의 기본 - 레인저
		[7] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_7"), -- 전투의 기본 - 소서러
		[8] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_8"), -- 전투의 기본 - 자이언트
		[9] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_9"), -- 전투의 기본 - 금수랑
		[10] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_27"), -- 전투의 기본 - 무사
		[11] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_28"), -- 전투의 기본 - 발키리
		[12] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_29"), -- 전투의 기본 - 매화
		[13] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_30"), -- 전투의 기본 - 위자드
		[14] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_31"), -- 전투의 기본 - 위치
		[15] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_32"), -- 전투의 기본 - 쿠노이치
		[16] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_33"), -- 전투의 기본 - 닌자
				
		[17] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_10"), -- 채집과 가공 방법
		[18] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_11"), -- 공헌도 : 거점 연결 및 회수
		[19] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_12"), -- 공헌도 : 집 용도 변경 및 회수
		[20] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_13"), -- 공헌도 : 대여 아이템 활용
		[21] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_14"), -- 말 조련 및 마구간 등록
		[22] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_15"), -- 일꾼 고용 및 일 시키기
		[23] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_16"), -- 낚시하기
		[24] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_17"), -- NPC 지식 모으기
		[25] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_18"), -- NPC 발견 조건
		[26] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_19"), -- 이야기 교류 및 친밀도 상점
		[27] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_20"), -- 주거지 배치 및 이사 안내
		[28] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_21"), -- 요리 방법
		[29] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_22"), -- 연금술 방법
		[30] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_23"), -- 텃밭 설치 및 가꾸기
		[31] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_24"), -- 의뢰 유형 설정 방법
		[32] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_25"), -- NPC 찾는 방법
		[33] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_26"), -- 흑정령의 분노 사용 방법
	}
elseif isGameTypeRussia() then
	movieDesc = {
		[0] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_0"), -- 캐릭터 기본 이동
		[1] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_1"), -- 의뢰 수행하기

		[2] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_2"), -- 길 찾기 방법
		[3] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_3"), -- 기술 습득 방법
		[4] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_4"), -- 의뢰 목표물 구분하기

		[5] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_5"), -- 전투의 기본 - 워리어
		[6] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_6"), -- 전투의 기본 - 레인저
		[7] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_7"), -- 전투의 기본 - 소서러
		[8] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_8"), -- 전투의 기본 - 자이언트
		[9] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_9"), -- 전투의 기본 - 금수랑
		[10] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_27"), -- 전투의 기본 - 무사
		[11] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_28"), -- 전투의 기본 - 발키리
		[12] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_30"), -- 전투의 기본 - 위자드
		[13] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_31"), -- 전투의 기본 - 위치

		[14] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_10"), -- 채집과 가공 방법
		[15] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_11"), -- 공헌도 : 거점 연결 및 회수
		[16] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_12"), -- 공헌도 : 집 용도 변경 및 회수
		[17] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_13"), -- 공헌도 : 대여 아이템 활용
		[18] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_14"), -- 말 조련 및 마구간 등록
		[19] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_15"), -- 일꾼 고용 및 일 시키기
		[20] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_16"), -- 낚시하기
		[21] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_17"), -- NPC 지식 모으기
		[22] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_18"), -- NPC 발견 조건
		[23] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_19"), -- 이야기 교류 및 친밀도 상점
		[24] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_20"), -- 주거지 배치 및 이사 안내
		[25] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_21"), -- 요리 방법
		[26] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_22"), -- 연금술 방법
		[27] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_23"), -- 텃밭 설치 및 가꾸기
		[28] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_24"), -- 의뢰 유형 설정 방법
		[29] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_25"), -- NPC 찾는 방법
		[30] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_26"), -- 흑정령의 분노 사용 방법
	}
elseif isGameTypeEnglish() then
	movieDesc = {
		[0] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_0"), -- 캐릭터 기본 이동
		[1] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_1"), -- 의뢰 수행하기
				
		[2] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_2"), -- 길 찾기 방법
		[3] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_3"), -- 기술 습득 방법
		[4] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_4"), -- 의뢰 목표물 구분하기
				
		[5] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_5"), -- 전투의 기본 - 워리어
		[6] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_6"), -- 전투의 기본 - 레인저
		[7] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_7"), -- 전투의 기본 - 소서러
		[8] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_8"), -- 전투의 기본 - 자이언트
		[9] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_9"), -- 전투의 기본 - 금수랑
		[10] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_28"), -- 전투의 기본 - 발키리
		[11] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_30"), -- 전투의 기본 - 위자드
		[12] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_31"), -- 전투의 기본 - 위치
		[13] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_27"), -- 전투의 기본 - 무사
		[14] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_29"), -- 전투의 기본 - 매화
						
		[15] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_10"), -- 채집과 가공 방법
		[16] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_11"), -- 공헌도 : 거점 연결 및 회수
		[17] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_12"), -- 공헌도 : 집 용도 변경 및 회수
		[18] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_13"), -- 공헌도 : 대여 아이템 활용
		[19] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_14"), -- 말 조련 및 마구간 등록
		[20] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_15"), -- 일꾼 고용 및 일 시키기
		[21] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_16"), -- 낚시하기
		[22] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_17"), -- NPC 지식 모으기
		[23] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_18"), -- NPC 발견 조건
		[24] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_19"), -- 이야기 교류 및 친밀도 상점
		[25] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_20"), -- 주거지 배치 및 이사 안내
		[26] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_21"), -- 요리 방법
		[27] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_22"), -- 연금술 방법
		[28] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_23"), -- 텃밭 설치 및 가꾸기
		[29] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_24"), -- 의뢰 유형 설정 방법
		[30] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_25"), -- NPC 찾는 방법
		[31] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_26"), -- 흑정령의 분노 사용 방법
	}
end
----------------------------------------------------------------------------------------------------------------

------------------------------------------------------------
--				켜고 꺼주는 애니메이션 함수
------------------------------------------------------------
function Panel_MovieGuide_ShowAni()
	UIAni.AlphaAnimation( 1, Panel_MovieGuide, 0.0, 0.15 )
	
	local aniInfo1 = Panel_MovieGuide:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.1)
	aniInfo1.AxisX = Panel_MovieGuide:GetSizeX() / 2
	aniInfo1.AxisY = Panel_MovieGuide:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_MovieGuide:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.1)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_MovieGuide:GetSizeX() / 2
	aniInfo2.AxisY = Panel_MovieGuide:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function Panel_MovieGuide_HideAni()
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_MovieGuide, 0.0, 0.1 )
	aniInfo:SetHideAtEnd( true )
end


function FGlobal_MovieGuideButton_Position()
	local _btn_TownNpcNavi = UI.getChildControl(Panel_Widget_TownNpcNavi, "Button_FindNavi")

	-- if getEnableSimpleUI() then
	-- 	Panel_MovieGuideButton:SetShow( false )
	-- 	Panel_MovieGuide:SetShow( false )
	-- end
	-- CBT일 때는 무조건 무비가이드 영상을 보여주지 않는다. 만약 CBT 때 까지 영상이 준비되어서 오픈한다면 별도 조건을 추가하자!
	if ( getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_CBT ) then
		if isGameTypeEnglish() then
			Panel_MovieGuideButton:SetShow( true )
		else
			Panel_MovieGuideButton:SetShow( false )
		end
	else
		Panel_MovieGuideButton:SetShow( true )
	end
	
	local RadarPosX 	 = Panel_Radar:GetPosX()
	local RadarPosY 	 = Panel_Radar:GetPosY()
	local RadarSpanSizeY = Panel_Radar:GetSpanSize().y
	
	Panel_MovieGuideButton:SetPosX( RadarPosX - (_btn_TownNpcNavi:GetSizeX()*2) - 15 )
	-- Panel_MovieGuideButton:SetPosX( _btn_TownNpcNavi:GetSpanSize().x )
	Panel_MovieGuideButton:SetPosY( RadarSpanSizeY - (RadarPosY/1.5) )
	-- Panel_MovieGuide:SetPosX( _btn_MovieGuide:GetPosX()- _btn_MovieGuide:GetSizeX() )
	Panel_MovieGuide:SetPosX( RadarPosX - (Panel_MovieGuide:GetSizeX()) -100 )
	Panel_MovieGuide:SetPosY( _btn_MovieGuide:GetPosY()+25 )
	Panel_MovieGuide:SetShow( false )
	-- Panel_MovieGuideButton:ComputePos()
	-- Panel_MovieGuideButton:SetSpanSize( Panel_MovieGuideButton:GetSpanSize().x, Panel_Widget_TownNpcNavi:GetPosY() )
	if ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 28 ) then
		Panel_HuntingAlertButton:SetShow( true )
		Panel_HuntingAlertButton:SetPosX(Panel_MovieGuideButton:GetPosX() - Panel_HuntingAlertButton:GetSizeX() - 5 )
		Panel_HuntingAlertButton:SetPosY(Panel_MovieGuideButton:GetPosY())
	else
		Panel_HuntingAlertButton:SetShow( false )
	end
	
	if ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 57 ) and trainableMinLev <= getSelfPlayer():get():getLevel() then		-- 흑정령의 수련 컨텐츠
		Panel_AutoTraining:SetShow( true )
		Panel_AutoTraining:SetPosX( Panel_HuntingAlertButton:GetPosX() - Panel_HuntingAlertButton:GetSizeX() - 5 )
		Panel_AutoTraining:SetPosY( Panel_HuntingAlertButton:GetPosY() )
	else
		Panel_AutoTraining:SetShow( false )
	end

	-- 버스터콜 포지션
	if Panel_AutoTraining:GetShow() then
		Panel_BusterCall:SetPosX( Panel_AutoTraining:GetPosX() - Panel_AutoTraining:GetSizeX() - 5 )
		Panel_BusterCall:SetPosY( Panel_AutoTraining:GetPosY() )
	elseif Panel_HuntingAlertButton:GetShow() then
		Panel_BusterCall:SetPosX( Panel_HuntingAlertButton:GetPosX() - Panel_HuntingAlertButton:GetSizeX() - 5 )
		Panel_BusterCall:SetPosY( Panel_HuntingAlertButton:GetPosY() )
	elseif Panel_MovieGuideButton:GetShow() then
		Panel_BusterCall:SetPosX( Panel_MovieGuideButton:GetPosX() - Panel_BusterCall:GetSizeX() - 5 )
		Panel_BusterCall:SetPosY( Panel_MovieGuideButton:GetPosY() )
	else
		Panel_BusterCall:SetPosX( RadarPosX - (_btn_TownNpcNavi:GetSizeX()*2) - 15 )
		Panel_BusterCall:SetPosY( RadarSpanSizeY - (RadarPosY/1.5) )
	end
	
	busterCallCheck()
end

---------------------------------------------------------------------------------
-- 지역변수 설정
---------------------------------------------------------------------------------

local maxCount = 10			-- 한 페이지에 보여줄 수 있는 최대 값
local maxMovieCount = 33
local currentPos	= 0
local movieInterval = 0
local guideMovieList = {}

------------------------------------------------------------
--				최초 셋팅해주는 함수
------------------------------------------------------------
function Panel_MovieGuide_Initialize()
	local player = getSelfPlayer()
	if( nil == player ) then
		return
	end
--{	일본의 경우 동영상 갯수가 모자르기때문에(전투의 기본 때문에) 갯수 조절해준다.
	if isGameTypeRussia() then
		maxMovieCount = 30
	elseif isGameTypeEnglish() then
		maxMovieCount = 31
	else
		maxMovieCount = 33
	end
--}
	local UI_classType = CppEnums.ClassType
	local myClassType = getSelfPlayer():getClassType() 

	local guideStartY	= 5
	local guideGapY		= 42

	for idx = 0, maxCount - 1, 1 do
		
		local createMovieBox = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, ui_PanelWindow._bgBox, 'Static_MovieBox_' .. idx )
		CopyBaseProperty( ui_PanelWindow._movieBG, createMovieBox )
		createMovieBox:SetPosX( 5 )
		createMovieBox:SetPosY( guideStartY )
		createMovieBox:SetShow( true )
		
		local createMovieDesc = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, createMovieBox, 'StaticText_MovieDesc_' .. idx )
		CopyBaseProperty( ui_PanelWindow._movieDesc, createMovieDesc )
		createMovieDesc:SetShow( true )
		createMovieDesc:SetFontColor( UI_color.C_FF888888 )
		createMovieDesc:SetText( movieDesc[idx] )
	
		local createMovieButton = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, createMovieBox, 'Button_GuideMovie_' .. idx )
		CopyBaseProperty( ui_PanelWindow._btn_Copy, createMovieButton )
		createMovieButton:SetShow( true )
		createMovieButton:SetIgnore( true )
		createMovieButton:SetFontColor( UI_color.C_FF515151 )
		createMovieButton:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(".. idx .. ")" )
		createMovieButton:ActiveMouseEventEffect( true )
		
		guideMovieList[idx] = {}
		guideMovieList[idx]._movieBox = createMovieBox
		guideMovieList[idx]._movieDesc = createMovieDesc
		guideMovieList[idx]._btn_Movie = createMovieButton
		
		guideMovieList[idx]._movieBox:addInputEvent("Mouse_DownScroll", "Panel_MovieGuide_ListUpdate( false )")
		guideMovieList[idx]._movieBox:addInputEvent("Mouse_UpScroll", "Panel_MovieGuide_ListUpdate( true )")
		guideMovieList[idx]._btn_Movie:addInputEvent("Mouse_DownScroll", "Panel_MovieGuide_ListUpdate( false )")
		guideMovieList[idx]._btn_Movie:addInputEvent("Mouse_UpScroll", "Panel_MovieGuide_ListUpdate( true )")

		guideStartY				= guideStartY + guideGapY
	end
	
end

------------------------------------------------------------
--					스크롤 처리 함수
------------------------------------------------------------
function Panel_MovieGuide_ListUpdate( UpDown )
	if( UpDown ) then
		currentPos = currentPos - 1
		if( currentPos < 0 ) then
			currentPos = 0
		end
	else
		currentPos = currentPos + 1
		if( currentPos > movieInterval ) then
			currentPos = movieInterval
		end
	end
	
	ui_PanelWindow._scroll:SetControlPos(currentPos/movieInterval)
	
	CalcMovieIndex( currentPos )
end

function HandleClick_MovieGuide()
	local maxMovieInterval		= maxMovieCount - maxCount
	local posByMovieInterval	= 1 / maxMovieInterval
	local currentMovieInterval	= math.floor( ( ui_PanelWindow._scroll:GetControlPos() / posByMovieInterval ) + 0.5 )
	
	currentPos		= currentMovieInterval
	
	CalcMovieIndex( currentPos )
end

function CalcMovieIndex( currentPos )
	local player = getSelfPlayer()
	if( nil == player ) then
		return
	end

	local playerGet = player:get()
	local playerLevel = playerGet:getLevel()
	
	for index = 0, maxCount -1 do
		guideMovieList[index]._movieBox:SetShow(false)
	end
	
	local sizeY = ui_PanelWindow._bgBox:GetSizeY()
	local itemSizeY = guideMovieList[0]._movieBox:GetSizeY()
	
	local visibleItemCount = math.floor( sizeY / itemSizeY )
	
	for index =	0, maxCount - 1 do
		guideMovieList[index]._btn_Movie:SetIgnore( true )
		guideMovieList[index]._movieDesc:SetFontColor( UI_color.C_FF888888 )
		guideMovieList[index]._btn_Movie:SetFontColor( UI_color.C_FF515151 )
	end
	for index =	0, maxCount - 1 do
		if( maxCount < index ) then
			break
		end
		local movieindex =  index + currentPos
		
		guideMovieList[index]._btn_Movie:addInputEvent("Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func("  .. movieindex .. ")")
		
		if( visibleItemCount <= index )then
			--guideMovieList[index]._movieBox:SetShow(false)
			--guideMovieList[index]._btn_Movie:SetShow(false)
		else
			guideMovieList[index]._movieBox:SetShow(true)
			guideMovieList[index]._btn_Movie:SetShow(true)
		end
		
		guideMovieList[index]._movieDesc:SetText( movieDesc[movieindex] )
		-- --		영상이 추가되었다면 여기를 한 번 고려해보자!
		if ( 20 >= playerLevel ) then		
			if ( playerLevel >= 1 ) and ( 4 >= playerLevel ) then
				if( movieindex <= 4	 ) then
					_btn_MovieGuide:SetVertexAniRun( "Ani_Color_New", true )
					guideMovieList[index]._btn_Movie:SetIgnore( false )
					guideMovieList[index]._movieDesc:SetFontColor( UI_color.C_FFEFEFEF )
					guideMovieList[index]._btn_Movie:SetFontColor( UI_color.C_FFC4BEBE )
				end
				
			elseif ( playerLevel >= 5 ) and ( 7 >= playerLevel ) then
				if( movieindex <= 14 ) then
					_btn_MovieGuide:SetVertexAniRun( "Ani_Color_New", true )
					guideMovieList[index]._btn_Movie:SetIgnore( false )
					guideMovieList[index]._movieDesc:SetFontColor( UI_color.C_FFEFEFEF )
					guideMovieList[index]._btn_Movie:SetFontColor( UI_color.C_FFC4BEBE )
				end
				
			elseif ( playerLevel >= 8 ) and ( 12 >= playerLevel ) then
				if( movieindex <= 15 ) then
					_btn_MovieGuide:SetVertexAniRun( "Ani_Color_New", true )
					guideMovieList[index]._btn_Movie:SetIgnore( false )
					guideMovieList[index]._movieDesc:SetFontColor( UI_color.C_FFEFEFEF )
					guideMovieList[index]._btn_Movie:SetFontColor( UI_color.C_FFC4BEBE )
				end
				
			elseif ( playerLevel >= 13 ) and ( 16 >= playerLevel ) then
				if( movieindex <= 18 ) then
					_btn_MovieGuide:SetVertexAniRun( "Ani_Color_New", true )
					guideMovieList[index]._btn_Movie:SetIgnore( false )
					guideMovieList[index]._movieDesc:SetFontColor( UI_color.C_FFEFEFEF )
					guideMovieList[index]._btn_Movie:SetFontColor( UI_color.C_FFC4BEBE )
				end
				
			elseif ( playerLevel >= 17 ) and ( 18 >= playerLevel ) then
				if( movieindex <= 19 ) then
					_btn_MovieGuide:SetVertexAniRun( "Ani_Color_New", true )
					guideMovieList[index]._btn_Movie:SetIgnore( false )
					guideMovieList[index]._movieDesc:SetFontColor( UI_color.C_FFEFEFEF )
					guideMovieList[index]._btn_Movie:SetFontColor( UI_color.C_FFC4BEBE )
				end
				
			elseif ( playerLevel >= 19 ) and ( 22 >= playerLevel ) then
				if( movieindex <= 30 ) then
					_btn_MovieGuide:SetVertexAniRun( "Ani_Color_New", true )
					guideMovieList[index]._btn_Movie:SetIgnore( false )
					guideMovieList[index]._movieDesc:SetFontColor( UI_color.C_FFEFEFEF )
					guideMovieList[index]._btn_Movie:SetFontColor( UI_color.C_FFC4BEBE )
				end
			end
		elseif ( playerLevel >= 23 ) then
			if( movieindex <= 33 ) then
				_btn_MovieGuide:SetVertexAniRun( "Ani_Color_New", true )
				guideMovieList[index]._btn_Movie:SetIgnore( false )
				guideMovieList[index]._movieDesc:SetFontColor( UI_color.C_FFEFEFEF )
				guideMovieList[index]._btn_Movie:SetFontColor( UI_color.C_FFC4BEBE )
			end
		end
	end
end

-- function FGlobal_MovieGuide_Reposition()
-- 	if Panel_Window_PetControl:GetShow() then
-- 		Panel_MovieGuideButton:SetPosX( Panel_Window_PetControl:GetSizeX() + 20 )
-- 	else
-- 		Panel_MovieGuideButton:SetPosX( 20 )
-- 	end
-- end

Panel_MovieGuide_Initialize()

function Panel_MovieGuide_ShowToggle()
	local isShow = Panel_MovieGuide:IsShow()
	
	_btn_MovieGuide:ResetVertexAni()
	_moviePlus:SetShow( false )
	
	if ( isShow == true ) then
		Panel_MovieGuide:SetShow( false, true )
		Panel_MovieTheater640_Reset()
		Panel_MovieTheater_640:SetShow( false, true )
		currentPos = 0
	else
		Panel_MovieGuide:SetShow( true, true )
		Panel_MovieTheater640_Initialize()
		local sizeY = ui_PanelWindow._bgBox:GetSizeY();
	
		ui_PanelWindow._scroll:SetShow( false )
		if( maxCount < maxMovieCount ) then
			movieInterval = maxMovieCount - maxCount
			
			ui_PanelWindow._scroll:SetShow( true )
			ui_PanelWindow._scroll:SetInterval( movieInterval )
			ui_PanelWindow._scroll:SetControlPos( 0 );
		end	
		CalcMovieIndex( 0 )
	end
end


function Panel_MovieGuide_LevelCheck()
	local player = getSelfPlayer()
	if( nil == player ) then
		return
	end

	local playerGet = player:get()
	local playerLevel = playerGet:getLevel()
	
	if ( playerLevel == 1 ) then
		_moviePlus:SetShow( true )
	elseif ( playerLevel == 7 ) then
		_moviePlus:SetShow( true )
	elseif ( playerLevel == 12 ) then
		_moviePlus:SetShow( true )
	elseif ( playerLevel == 15 ) then
		_moviePlus:SetShow( true )
	elseif ( playerLevel == 17 ) then
		_moviePlus:SetShow( true )
	elseif ( playerLevel == 19 ) then
		_moviePlus:SetShow( true )
	end
end

local msg = { name, desc }
function WhaleConditionCheck()
	-- 코드 특성상 아래와 같이 동일한 로직에 종류만 다르게하여 짭니다.(경인씨에게 문의 후 작업하였습니다.)
	msg.name = ""
	msg.desc = ""
	local whaleCount = ToClient_worldmapActorManagerGetActorRegionList(2)		-- 2 : 고래
	if 0 < whaleCount then
		for index = 0, whaleCount -1 do

			local areaName = ToClient_worldmapActorManagerGetActorRegionByIndex( index )		-- 고래가 뜬 지역명
			local count = ToClient_worldmapActorManagerGetActorCountByIndex( index )			-- 고래 숫자
			if nil ~= areaName then
				if 0 == index then
					msg.desc = msg.desc .. PAGetStringParam2( Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_WHALE_FIND", "areaName", tostring(areaName), "count", count ) -- "[" .. tostring(areaName) .. "]에 고래가 " .. count .. " 마리 출현하였습니다."
				else
					msg.desc = msg.desc .. "\n" .. PAGetStringParam2( Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_WHALE_FIND", "areaName", tostring(areaName), "count", count )
				end
			end
		end
		msg.name = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_WHALE_FIND_NAME") -- 고래 발견 :
		_huntingPlus:SetShow( true )
	end

	local gargoyleCount = ToClient_worldmapActorManagerGetActorRegionList(3)		-- 3 : 육상수렵(칼크)
	if 0 < gargoyleCount then
		for index = 0, gargoyleCount -1 do

			local areaName = ToClient_worldmapActorManagerGetActorRegionByIndex( index )		-- 육상수렵이 뜬 지역명
			local count = ToClient_worldmapActorManagerGetActorCountByIndex( index )			-- 육상수렵 숫자
			if nil ~= areaName then
				if 0 == index then
					if 0 < whaleCount then
						msg.desc = msg.desc .. "\n" .. PAGetStringParam2( Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_HUNTING_GARGOYLE", "areaName", tostring(areaName), "count", count ) -- "[" .. tostring(areaName) .. "]에 고래가 " .. count .. " 마리 출현하였습니다."
					else
						msg.desc = msg.desc .. PAGetStringParam2( Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_HUNTING_GARGOYLE", "areaName", tostring(areaName), "count", count ) -- "[" .. tostring(areaName) .. "]에 고래가 " .. count .. " 마리 출현하였습니다."
					end
				else
					msg.desc = msg.desc .. "\n" .. PAGetStringParam2( Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_HUNTING_GARGOYLE", "areaName", tostring(areaName), "count", count )
				end
			end
		end
		msg.name = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_WHALE_FIND_NAME") -- 고래 발견 :
		_huntingPlus:SetShow( true )
	end

	if 0 == gargoyleCount+whaleCount then
		msg.name = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_WHALE") -- 고래 :
		msg.desc = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_WHALE_NOT_FIND") -- 현재 고래가 발견되지 않았습니다.
		_huntingPlus:SetShow( false )
	end
end

function Hunting_ToolTip_ShowToggle( isShow )
	WhaleConditionCheck()
	if nil == isShow then
		TooltipSimple_Hide()
		return
	end
	TooltipSimple_Show( _btn_HuntingAlert, msg.name, msg.desc )
end

function FGlobal_WhaleConditionCheck()
	WhaleConditionCheck()
end


FGlobal_MovieGuideButton_Position()
WhaleConditionCheck()
-- UI.addRunPostRestorFunction( FGlobal_MovieGuide_Reposition )
registerEvent( "onScreenResize", "FGlobal_MovieGuideButton_Position" )
UI.addRunPostRestorFunction(FGlobal_MovieGuideButton_Position)
registerEvent("EventSelfPlayerLevelUp", "Panel_MovieGuide_LevelCheck")