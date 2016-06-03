local 	UI_RewardType					= CppEnums.RewardType

local reward = {
	currentBenefitReward	=	-1,
	currentRewardCount		=	-1,
}


local pcRoomGift_icon = UI.getChildControl ( Panel_NewEventProduct_Alarm, "Static_Icon" )
local pcRoomGift_Text = UI.getChildControl ( Panel_NewEventProduct_Alarm, "StaticText_SumText" )
Panel_NewEventProduct_Alarm:SetShow( false )
local nextPcRoomGiftRewardTime	= toInt64(0,0)

local messagePosition = function()
	Panel_ChallengeReward_Alert		:SetSpanSize( 0, 10 )
	Panel_SpecialReward_Alert		:SetSpanSize( 50, 10 )
	-- Panel_NewMail_Alarm				:SetSpanSize( 110, 30 )
	-- Panel_NewQuest_Alarm			:SetSpanSize( 80, 0 )
	Panel_NewEventProduct_Alarm		:SetSpanSize( 110, 10 )
	Panel_ChallengeReward_Alert		:ComputePos()
	Panel_SpecialReward_Alert		:ComputePos()
	Panel_NewMail_Alarm				:ComputePos()
	Panel_NewQuest_Alarm			:ComputePos()
	Panel_NewEventProduct_Alarm		:ComputePos()
end

local isNewbie = function()	-- todo : 나중에 다른 방식으로 신규 유저와 기존 유저 모두 만족하는 프로세스 변경이 필요합니다. 2014.12.17 창욱
	return questList_hasProgressQuest(118, 1) or questList_hasProgressQuest(138, 1) or questList_hasProgressQuest(120, 1) or questList_hasProgressQuest(121, 1) or questList_hasProgressQuest(161, 1) or questList_hasProgressQuest(160, 1)	-- 나중엔 바꿔야 할 방식이다.
end

--------------------------------------------------------------------------------
-- 특별보상 조건 달성
--------------------------------------------------------------------------------
function completeBenefitReward_ShowMessage()
	local self			= reward
	if -1 == self.currentBenefitReward then
		return
	end

	local rewardWrapper	= ToClient_GetBenefitRewardInfoWrapper( self.currentBenefitReward )
	if( nil ~= rewardWrapper ) then
		if ( 0 == rewardWrapper:getType() ) then
			local message = { main = PAGetString(Defines.StringSheet_GAME, "LUA_SPECIAL_REWARD_BENEFITREWARD_MAIN"), sub = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SPECIAL_REWARD_ARCHIVEMENT", "specialRewardName", rewardWrapper:getName() ) }
			Proc_ShowBigMessage_Ack_WithOut_ChattingMessage( message )
		end
	end
end

function FromClient_CompleteBenefitReward()
	if( isFlushedUI() ) then
		return
	end
	
	local self					= reward
	local rewardCount			= ToClient_GetBenefitRewardInfoCount()

	if 0 == rewardCount or nil == rewardCount then
		self.currentBenefitReward	= - 1
		return
	end

	self.currentBenefitReward	= rewardCount - 1

	if isNewbie() or ( 5 < getSelfPlayer():get():getLevel() ) then
		Panel_SpecialReward_Alert:SetShow( true )
		completeBenefitReward_ShowMessage()
		FromClient_SpecialReward_UpdateText()
	end
	messagePosition()
end

-- { UI모드가 기본이 아니면, 플러시가 끝날 때 다시 실행한다.
	function check_BenefitRewardAlert_Hide()
		if 1 < getSelfPlayer():get():getLevel() then
			return
		end
		Panel_SpecialReward_Alert:SetShow(false)
		TooltipSimple_Hide()
	end
	UI.addRunPostFlushFunction(check_BenefitRewardAlert_Hide)
	function check_BenefitRewardAlert_PostEvent()
		local self = reward
		if isNewbie() or 5 < getSelfPlayer():get():getLevel() then
			if self.currentBenefitReward == (ToClient_GetBenefitRewardInfoCount() - 1)then
				return	-- 이전과 같으니까 나타나지 않는다.
			end
		end
		FromClient_CompleteBenefitReward()
	end
	UI.addRunPostRestorFunction( check_BenefitRewardAlert_PostEvent )
-- }


--------------------------------------------------------------------------------
-- 도전 과제 달성
--------------------------------------------------------------------------------
function completeChallengeReward_ShowMessage()
	local self			= reward
	if -1 == self.currentRewardCount then
		return
	end

	local rewardWrapper	= ToClient_GetChallengeRewardInfoWrapper( self.currentRewardCount )
	if( nil ~= rewardWrapper ) then
		local message = { main = PAGetString(Defines.StringSheet_GAME, "LUA_SPECIAL_REWARD_CHALLENGEREWARD_MAIN"), sub = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHALLENGE_REWARD_ARCHIVEMENT", "challengeName", rewardWrapper:getName() ) }
		Proc_ShowBigMessage_Ack_WithOut_ChattingMessage( message )
	end
end

-- 
function FromClient_CompleteChallengeReward()
	if( isFlushedUI() ) then
		return
	end

	local self			= reward
	local rewardCount	= ToClient_GetChallengeRewardInfoCount()
	self.currentRewardCount	= rewardCount - 1

	if isNewbie() or ( 5 < getSelfPlayer():get():getLevel() ) then
		Panel_ChallengeReward_Alert:SetShow( true )
		completeChallengeReward_ShowMessage()		-- 메세지를 뿌린다.
		FromClient_ChallengeReward_UpdateText()
		-- pc방도 체크한다.
		PcRoomGift_TimeCheck()
	end
	
	messagePosition()
end

-- { UI모드가 기본이 아니면, 플러시가 끝날 때 다시 실행한다.
	function check_CompleteChallengeRewardAlert_Hide()
		if 1 < getSelfPlayer():get():getLevel() then
			return
		end
		Panel_ChallengeReward_Alert:SetShow(false)
	end
	UI.addRunPostFlushFunction(check_CompleteChallengeRewardAlert_Hide)

	function check_CompleteChallengeRewardAlert_PostEvent()
		local self = reward

		if isNewbie() or 1 < getSelfPlayer():get():getLevel() then
			if self.currentRewardCount == (ToClient_GetChallengeRewardInfoCount() - 1)then
				return	-- 이전과 같으니까 나타나지 않는다.
			end
		end
		FromClient_CompleteChallengeReward()
	end
	UI.addRunPostRestorFunction( check_CompleteChallengeRewardAlert_PostEvent )
-- }

--{ PC방 도전과제 체크}
	function PcRoomGift_TimeCheck()
		-- pc방도 체크한다.
		local nowPlayedTime	= ToClient_GetPcRoomPlayTime()
		local checkCount	= ToClient_GetProgressChallengeCount( 4 )
		if 0 == checkCount then
			nextPcRoomGiftRewardTime = toInt64(0,0)
			Panel_NewEventProduct_Alarm:SetShow( false )
			return
		end
		for checkIdx = 0, checkCount - 1 do
			local progressInfo = ToClient_GetProgressChallengeAt( 4, checkIdx )
			local remainedTime = toInt64(0, progressInfo:getNeedTimeForPcRoom() * 60 ) - nowPlayedTime -- + toInt64(0, 180)
			if( toInt64(0,0) == nextPcRoomGiftRewardTime ) then
				nextPcRoomGiftRewardTime = remainedTime
			elseif( remainedTime < nextPcRoomGiftRewardTime ) then
				nextPcRoomGiftRewardTime = remainedTime
			end
		end
		
		local temporaryPCRoomWrapper	= getTemporaryInformationWrapper()
		local isPremiumPcRoom			= temporaryPCRoomWrapper:isPremiumPcRoom()
		local selfPlayer = getSelfPlayer()
		if nil == selfPlayer then
			return
		end
		if isPremiumPcRoom and not Panel_NewEventProduct_Alarm:GetShow() and 0 ~= checkCount then
			Panel_NewEventProduct_Alarm:SetShow( true )
			messagePosition()
		end
	end
	UI.addRunPostRestorFunction( PcRoomGift_TimeCheck )
-- }
PcRoomGift_TimeCheck()

local tempTime = 0
function PcRoomGiftPanel_UpdatePerFrame( deltaTime )
	tempTime =  tempTime + deltaTime
	if 1 < tempTime then
		nextPcRoomGiftRewardTime = nextPcRoomGiftRewardTime - toInt64(0,tempTime)
		pcRoomGift_Text:SetText( convertStringFromDatetime( nextPcRoomGiftRewardTime ) ) 
		tempTime = 0
	end
	if ( nextPcRoomGiftRewardTime <= toInt64(0,0) ) then
		nextPcRoomGiftRewardTime = toInt64(0,0)
		PcRoomGift_TimeCheck()
	end
end

function HandleClicked_PcRoomJackPotBox()
	if not Panel_Window_CharInfo_Status:GetShow() then
		FGlobal_CharInfoStatusShowAni()
		Panel_Window_CharInfo_Status:SetShow( true )
		-- ♬ 창을 켤 때 소리
		-- audioPostEvent_SystemUi(01,34)
	end
	HandleClicked_CharacterInfo_Tab(3)
	HandleClickedTapButton( 4 )
end

function AlarmIcon_SimpleTooltips( isShow )
	name = PAGetString(Defines.StringSheet_GAME, "LUA_SPECIAL_REWARD_ALARMICON_TOOLTIP_NAME") -- "PC방 대박 상자"
	-- desc = "PC방에서 접속하면 일정시간마다 PC방 대박 상자를 얻을 수 있습니다.\n하루 최대 3개까지 획득 가능합니다."
	desc = PAGetString(Defines.StringSheet_GAME, "LUA_SPECIAL_REWARD_ALARMICON_TOOLTIP_DESC") -- "PC방에서 접속하면 일정 시간마다 특정 선물을 받게 됩니다.\n더욱 오래 접속할수록 좋은 선물이 지급됩니다.\n아이콘을 클릭하면 선물을 구체적으로 확인할 수 있습니다!"
	uiControl = pcRoomGift_icon

	if true == isShow then
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function SpecialReward_registEventHandler()
	registerEvent("FromClient_CompleteBenefitReward",		"FromClient_CompleteBenefitReward")						-- 특별 보상 조건 달성 시 실행
	registerEvent("FromClient_CompleteChallengeReward",		"FromClient_CompleteChallengeReward")					-- 도전 과제 달성 시 실행
	registerEvent("FromClient_LoadCompleteMsg",				"PcRoomGift_TimeCheck")
end
function SpecialReward_registMessageHandler()
	pcRoomGift_icon:addInputEvent("Mouse_On", "AlarmIcon_SimpleTooltips( true )" )
	pcRoomGift_icon:addInputEvent("Mouse_Out", "AlarmIcon_SimpleTooltips( false )" )
	pcRoomGift_icon:addInputEvent("Mouse_LUp", "HandleClicked_PcRoomJackPotBox()" )
end

Panel_NewEventProduct_Alarm:RegisterUpdateFunc("PcRoomGiftPanel_UpdatePerFrame")


FromClient_CompleteBenefitReward()
FromClient_CompleteChallengeReward()
-- FromClient_CashShop_PossibleBuyEventItem()
SpecialReward_registEventHandler()
SpecialReward_registMessageHandler()
-- registerEvent("FromClient_UpdateCashShop",				"FromClient_CashShop_PossibleBuyEventItem")				-- 마일리지 아이템을 살 수 있다?