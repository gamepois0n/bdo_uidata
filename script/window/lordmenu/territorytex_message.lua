Panel_TerritoryTex_Message:RegisterShowEventFunc( true, 'TerritoryTex_MessageShowAni()' )
Panel_TerritoryTex_Message:RegisterShowEventFunc( false, 'TerritoryTex_MessageHideAni()' )

function  TerritoryTex_MessageShowAni()
end
function TerritoryTex_MessageHideAni()
end



--[[ 순서 :   --]]
local MessageData =
{
	_Msg = {}					-- 메시지 인덱스 저장
}

local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color

local curIndex 			= 0									-- 세이브 인덱스
local processIndex 		= 0									-- 처리 인덱스
local animationEndTime 	= 4.0								-- 플레이 타임
local elapsedTime 		= 5.0								-- 메모리용 타이머

local msgBG 	= UI.getChildControl( Panel_TerritoryTex_Message, "Static_TerritoryTex_MsgBorder" )
local _text_Msg = UI.getChildControl( Panel_TerritoryTex_Message, "StaticText_TerritoryTex_Message" )

function TerritoryTex_ShowMessage_Ack(message)
	TerritoryTex_ShowMessage_Ack_WithOut_ChattingMessage(message)	
	chatting_sendMessage( "", message , CppEnums.ChatType.System )
end

function TerritoryTex_ShowMessage_Ack_WithOut_ChattingMessage(message)
	msgBG:EraseAllEffect()
	curIndex = curIndex + 1
	MessageData._Msg[curIndex] = message
	Panel_TerritoryTex_Message:SetShow(true, true)
end

-- 애니메이션
local MessageOpen = function()

	-- 켜기
	local aniInfo = Panel_TerritoryTex_Message:addColorAnimation( 0.0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo.IsChangeChild = true

	local aniInfo1 = Panel_TerritoryTex_Message:addScaleAnimation( 0.5, 0.65, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.0)
	aniInfo1.AxisX = Panel_TerritoryTex_Message:GetSizeX() / 2
	aniInfo1.AxisY = Panel_TerritoryTex_Message:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true

	-- 남아있고
	local aniInfo2 = Panel_TerritoryTex_Message:addScaleAnimation( 0.15, 3.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_PI)
	aniInfo2:SetStartScale(1.0)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.IsChangeChild = true

	-- 꺼준다
	local aniInfo3 = Panel_TerritoryTex_Message:addColorAnimation( 3.0, 4.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo3:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo3.IsChangeChild = true

	local aniInfo4 = Panel_TerritoryTex_Message:addScaleAnimation( 3.5, 3.65, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo4:SetStartScale(1.0)
	aniInfo4:SetEndScale(1.0)
	aniInfo4.AxisX = Panel_TerritoryTex_Message:GetSizeX() / 2
	aniInfo4.AxisY = Panel_TerritoryTex_Message:GetSizeY() / 2
	aniInfo4.ScaleType = 2
	aniInfo4.IsChangeChild = true
end

local tempMsg = nil;

function TerrirotyTex_MessageUpdate(updateTime)
	elapsedTime = elapsedTime + updateTime;					-- 애니메이션 타임과 메모리용 타이머를 비교하기 위한 변수

	-- 메시지 들어오자마자
	if elapsedTime >= animationEndTime then
		if processIndex < curIndex then
			-- ♬ 시스템 메시지가 나올 때 사운드 추가
			audioPostEvent_SystemUi(08,01)
			MessageOpen()													-- 나올 때 애니메이션 (3.6초)
			processIndex = processIndex  + 1
			Panel_TerritoryTex_Message:SetShow(false, true)				-- 소리 재생을 위해 껐다 켜준다!
			Panel_TerritoryTex_Message:SetShow(true, true)
			tempMsg = MessageData._Msg[processIndex]
			_text_Msg:SetText ( MessageData._Msg[processIndex] )
			local _txtSize = _text_Msg:GetTextSizeX()
			
			MessageData._Msg[processIndex] = nil							-- 메시지 인덱스 리셋
			elapsedTime = 0.0												-- 처리 후 애니메이션 시간 리셋
			
		else
			Panel_TerritoryTex_Message:SetShow(false, false)				-- 기존에 남아있던 애 꺼주기

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

function TerrirotyTex_MessagePanel_Resize()
	local scrX = getScreenSizeX()
	msgBG		:SetPosX(( scrX - msgBG:GetSizeX() ) * 0.5 )
end

TerrirotyTex_MessagePanel_Resize()

--[[ *************************** 메시지 처리 *************************** --]]
Panel_TerritoryTex_Message:RegisterUpdateFunc("TerrirotyTex_MessageUpdate")
registerEvent( "onScreenResize", "TerrirotyTex_MessagePanel_Resize()" )

--[[ *************************** 메시지 가 데이터 *************************** --]]
-- Proc_ShowMessage_Ack("메시지!")
-- Proc_ShowMessage_Ack("메시지!")
-- Proc_ShowMessage_Ack("메시지!")