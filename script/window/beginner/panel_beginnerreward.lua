Panel_BeginnerReward:SetShow( false )
local _buttonRewardGet			= UI.getChildControl( Panel_BeginnerReward, "Button_Reward_Get" )			-- 보상받기 아이콘
local _btn_Close		 		= UI.getChildControl( Panel_BeginnerReward,	"Button_Win_Close" )

function beginnerReward_Init()
	Panel_BeginnerReward:SetShow( true )
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
	Panel_BeginnerReward:SetShow(false)
end

function beginnerReward_Close()
	-- ♬ 창이 꺼질 때 소리
	audioPostEvent_SystemUi(13,05)
	Panel_BeginnerReward:SetShow( false, false )
end

function HandleClicked_beginnerReward_Close()
	beginnerReward_Close()
end

function beginnerReward:registEventHandler()
	_btn_Close		:addInputEvent( "Mouse_LUp", "HandleClicked_beginnerReward_Close()" )
	_buttonRewardGet:addInputEvent( "Mouse_LUp", "HandleClickedChallengeReward()" )
end

if ToClient_GetUserPlayMinute() < 1440 then		-- 접속시간(분)이 1,440분을 넘지 않는 유저만 보여준다.
	beginnerReward_Init()
end

beginnerReward:registEventHandler()
