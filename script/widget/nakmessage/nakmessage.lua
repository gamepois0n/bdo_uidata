--[[ 순서 :   --]]
local MessageData =
{
	_Msg = {}					-- 메시지 인덱스 저장
}

local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color

local curIndex = 0							-- 세이브 인덱스
local processIndex = 0						-- 처리 인덱스
local animationEndTime = 2.3
local elapsedTime = 2.3													-- 메모리용 타이머

local _text_Msg = UI.getChildControl( Panel_NakMessage, "MsgText" )
Panel_NakMessage:setFlushAble(false);

function Proc_ShowMessage_Ack(message, showRate)
	Proc_ShowMessage_Ack_WithOut_ChattingMessage(message, showRate)	
	chatting_sendMessage( "", message , CppEnums.ChatType.System )
end

function Proc_ShowBigMessage_Ack_WithOut_ChattingMessage(message)
	local messages = message
	if 'table' ~= type(message) then
		messages = { main = message, sub = PAGetString(Defines.StringSheet_GAME, "LUA_NAKMESSAGE_SELECTREWARD_MSG_SUB"), addMsg ="" }
	end

	Proc_ShowMessage_Ack_For_RewardSelect( messages, 3, 4 )
end

function Proc_ShowMessage_Ack_WithOut_ChattingMessage(message, showRate)
	-- ♬ 시스템 메시지가 나올 때 사운드 추가
	audioPostEvent_SystemUi(08,01)
	
	if ( nil == showRate ) then
		animationEndTime = 2.3
		elapsedTime = 2.3
	else
		animationEndTime = showRate
		elapsedTime = showRate
	end
	
	curIndex = curIndex + 1
	MessageData._Msg[curIndex] = message
	Panel_NakMessage:SetShow(true, false)
end


local frameEventMessageIds =
{
	[0] = "LUA_FRAMEEVENT_TOO_LESS_HP",					-- 체력이 부족합니다.
	"LUA_FRAMEEVENT_TOO_MANY_DETERMINATION",			-- 투지가 가득 찼습니다.
	"LUA_FRAMEEVENT_TOO_MANY_HP",						-- 체력이 가득 찼습니다.
	"LUA_FRAMEEVENT_TOO_LESS_MP",						-- 마력이 부족 합니다.
	"LUA_FRAMEEVENT_NOT_EXIST_COMBINE_WAVE_TARGET",		-- 파동의 대상이 없습니다.
	"LUA_FRAMEEVENT_NOT_EXIST_EQUIPITEM",				-- 행동에 필요한 아이템이 장착되지 않았습니다.
	"LUA_FRAMEEVENT_NOT_TAMING_1",						-- 길들인 말이 이미 존재합니다.
	"LUA_FRAMEEVENT_NOT_PHANTOMCOUNT",					-- 어둠의 조각이 부족합니다.
	"LUA_FRAMEEVENT_NOT_CANNON_SHOT",					-- 포신이 뜨거워 발사를 할 수 없습니다.
	"LUA_FRAMEEVENT_NOT_CANNON_BALL_SHOT",				-- 포탄이 없어 발사할 수 없습니다.
	"LUA_FRAMEEVENT_NOT_HORES_HP_UP",					-- 말과의 교감으로 말의 체력이 회복됩니다.
	"LUA_FRAMEEVENT_NOT_HORES_MP_UP",					-- 말과의 교감으로 말의 스태미너가 회복됩니다.
	"LUA_FRAMEEVENT_NOT_HORES_SPEED_UP",				-- 말과의 교감으로 일정 시간동안 이동속도가 증가합니다.
	"LUA_FRAMEEVENT_NOT_SORCERESS_GROGGY",				-- 어둠의 기운이 너무 많이 흡수되어 어지러움을 느낍니다.
	"LUA_FRAMEEVENT_NOT_MANY_HOLY",						-- 신성력이 가득 찼습니다.
}

function Proc_ShowMessage_FrameEvent( messageNum )
	Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, frameEventMessageIds[ messageNum ] ) )
end

-- 애니메이션
local MessageOpen = function()

	local	axisX = Panel_NakMessage:GetSizeX() / 2
	local 	axisY = Panel_NakMessage:GetSizeY() / 2
	-- 켜기
	local aniInfo = Panel_NakMessage:addColorAnimation( 0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo.IsChangeChild = true

	local aniInfo1 = Panel_NakMessage:addScaleAnimation( 0.0, 3.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartScale(0.85)
	aniInfo1:SetEndScale(1.0)
	aniInfo1.AxisX = axisX
	aniInfo1.AxisY = axisY
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true

	-- 남아있고
	local aniInfo2 = Panel_NakMessage:addScaleAnimation( 0.15, animationEndTime - 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_PI)
	aniInfo2:SetStartScale(1.0)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = axisX
	aniInfo2.AxisY = axisY
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true

	-- 꺼준다
	local aniInfo3 = Panel_NakMessage:addColorAnimation( animationEndTime - 0.15, animationEndTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo3:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo3.IsChangeChild = true

	local aniInfo4 = Panel_NakMessage:addScaleAnimation( animationEndTime - 0.15, animationEndTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo4:SetStartScale(1.0)
	aniInfo4:SetEndScale(0.7)
	aniInfo4.AxisX = axisX
	aniInfo4.AxisY = axisY
	aniInfo4.ScaleType = 2
	aniInfo4.IsChangeChild = true
end

local tempMsg = nil;

function NakMessageUpdate(updateTime)
	elapsedTime = elapsedTime + updateTime;					-- 애니메이션 타임과 메모리용 타이머를 비교하기 위한 변수

	--_PA_LOG("최대호", "update time : " ..tostring( updateTime ) .. "  elapsedTime : "..tostring( elapsedTime ) );
-- 메시지 시작 이후 2.3초가 되었을 경우
	if elapsedTime >= animationEndTime then
		if processIndex < curIndex then
			MessageOpen()													-- 나올 때 애니메이션 (2.3초)
			processIndex = processIndex  + 1
			
			Panel_NakMessage:SetShow(true, false)
			tempMsg = MessageData._Msg[processIndex]
			_text_Msg:SetText ( MessageData._Msg[processIndex] )

			MessageData._Msg[processIndex] = nil				-- 메시지 인덱스 리셋
			elapsedTime = 0.0												-- 처리 후 애니메이션 시간 리셋
			
		else
			Panel_NakMessage:SetShow(false, false)				-- 기존에 남아있던 애 꺼주기

			curIndex = 0
			processIndex = 0
		end
	else
		if processIndex < curIndex then
			if (tempMsg ==  MessageData._Msg[processIndex+1]) then   -- 애니메이션이 동작 중 같은 메시지가 들어오는 것 삭제
				processIndex = processIndex  + 1		
				MessageData._Msg[processIndex] = nil
			end
		end
	end
end

function NakMessagePanel_Resize()
	Panel_NakMessage:SetPosX( ( getScreenSizeX() - Panel_NakMessage:GetSizeX() ) * 0.5 )
end

local PostRestoreFunction = function()
	if( 0 ~= processIndex ) then
		Panel_NakMessage:SetShow( true, false );
	end
end

UI.addRunPostRestorFunction( PostRestoreFunction );

NakMessagePanel_Resize()

--[[ *************************** 메시지 처리 *************************** --]]
Panel_NakMessage:RegisterUpdateFunc("NakMessageUpdate")
registerEvent("showMessage_ack", "Proc_ShowMessage_Ack_WithOut_ChattingMessage")
registerEvent("showBigMessage_ack", "Proc_ShowBigMessage_Ack_WithOut_ChattingMessage")
registerEvent("showMessage_FrameEvent", "Proc_ShowMessage_FrameEvent")
registerEvent( "onScreenResize", "NakMessagePanel_Resize" )

--[[ *************************** 메시지 가 데이터 *************************** --]]
-- Proc_ShowMessage_Ack("메시지!")
-- Proc_ShowMessage_Ack("메시지!")
-- Proc_ShowMessage_Ack("메시지!")
