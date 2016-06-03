local _buttonRewardBG	= UI.getChildControl( Panel_Event_100Day, "Button_Reward_BG" )			-- 보상받기 아이콘
local _buttonRewardGet	= UI.getChildControl( Panel_Event_100Day, "Button_Reward_Get" )			-- 보상받기 아이콘
local _StaticText_Title	= UI.getChildControl( Panel_Event_100Day, "StaticText_Title" )
local _btn_Close		= UI.getChildControl( Panel_Event_100Day, "Button_Win_Close" )
local _EventUserName	= UI.getChildControl( Panel_Event_100Day, "EventUserName" )
local _EventItemIcon	= UI.getChildControl( Panel_Event_100Day, "Static_EventItemIcon" )
local _EventBeginnerBG	= UI.getChildControl( Panel_Event_100Day, "EventBeginnerBG" )
local _EventGameExit	= UI.getChildControl( Panel_Event_100Day, "Button_GameExit" )
local _EventCancle		= UI.getChildControl( Panel_Event_100Day, "Button_GameExitCancle" )


function FGlobal_Event_100Day_Init()
	local player = getSelfPlayer()
	local classType = getSelfPlayer():getClassType()
	if( nil == player ) then
		return;
	end
	-- local ChaName = player:getOriginalName()
	-- _EventUserName	: SetText(tostring(ChaName).." 님!")
	-- _EventItemIcon	: ChangeTextureInfoName ( "New_UI_Common_forLua/Window/Event/Aaswell_"..classType..".dds" )
	_EventItemIcon:SetShow( false )
	_EventUserName:SetShow( false )

	Panel_Event_100Day:SetShow( false )
end

function FGlobal_Event_100Day_Open()
	Panel_Event_100Day:SetShow( true )
end

function FGlobal_Event_100Day_GameExitOpen()
	_EventBeginnerBG	: ChangeTextureInfoName ( "New_UI_Common_forLua/Window/Event/eventBeginnerExitBG.dds" )
	Panel_Event_100Day	: SetSize ( 770, 630 )
	_EventGameExit		: SetShow( true )
	_EventCancle		: SetShow( true )
	Panel_Event_100Day	: ComputePos()
	_EventBeginnerBG	: ComputePos()
	_EventGameExit		: ComputePos()
	_EventCancle		: ComputePos()
	_btn_Close			: ComputePos()
	_StaticText_Title	: ComputePos()
	
	_EventItemIcon		: SetPosX ( 85 )
	_EventUserName		: SetPosX ( 94 )
	Panel_Event_100Day	: SetPosY ( Panel_Event_100Day: GetPosY() - 100 )
	Panel_Event_100Day	: SetShow( true )
	_buttonRewardGet	: SetShow( false )
	_buttonRewardBG		: SetShow( false )
end

function HandleClickedChallengeReward()
	-- 도전 과제 아이콘 누를 때 소리(임시)
	audioPostEvent_SystemUi(00,05)

	if not Panel_Window_CharInfo_Status:GetShow() then
		Panel_Window_CharInfo_Status:SetShow( true )
		-- ♬ 창을 켤 때 소리
		audioPostEvent_SystemUi(01,34)
	end
	HandleClicked_CharacterInfo_Tab(3)
	HandleClickedTapButton( 2 )
	Panel_Event_100Day:SetShow(false)
end

function FGlobal_Event_100Day_Close()
	-- ♬ 창이 꺼질 때 소리
	audioPostEvent_SystemUi(13,05)
	Panel_Event_100Day:SetShow( false, false )
end

function HandleClicked_event_100Day_Close()
	FGlobal_Event_100Day_Close()
end

function HandleClicked_GameOff_Yes()
	FGlobal_Event_100Day_Close()
	Panel_GameExit_GameOff_Yes()
end

function registEventHandler()
	_btn_Close		:addInputEvent( "Mouse_LUp", "HandleClicked_event_100Day_Close()" )
	_buttonRewardGet:addInputEvent( "Mouse_LUp", "HandleClickedChallengeReward()" )
	_EventGameExit	:addInputEvent( "Mouse_LUp", "HandleClicked_GameOff_Yes()" )
	_EventCancle	:addInputEvent( "Mouse_LUp", "HandleClicked_event_100Day_Close()" )
end
FGlobal_Event_100Day_Init()

if true == isGameTypeKorea() and ToClient_GetUserPlayMinute() < 2880 then		-- 접속시간(분)이 2880분을 넘지 않는 유저만 보여준다.
	-- FGlobal_Event_100Day_Open()
end

registEventHandler()