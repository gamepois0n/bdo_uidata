Panel_Challenge_Reward:SetShow(false)
Panel_Challenge_Reward:setGlassBackground(true)
Panel_Challenge_Reward:SetPosX(200)
Panel_Challenge_Reward:SetPosY(300)

-------------------------- Local 변수 설정 --------------------
local 	UI_RewardType					= CppEnums.RewardType
local 	UI_TM 							= CppEnums.TextMode
local	UI_color						= Defines.Color
local _questrewardSlotConfig =
{	-- 일단 아이콘, 테두리, 카운트(숫자) 만 적용한다!
	createIcon	= true,
	createBorder= true,
	createCount	= true,
	createClassEquipBG = true,
	createCash	= true
}

local	_remainRewardCount				= 0
local 	_baseRewardCount				= 0
local	_maxBaseSlotCount				= 12
local	_uiBackBaseReward				= {}
local	_listBaseRewardSlots			= {}

local 	_selectRewardCount				= 0
local	_maxSelectSlotCount				= 6
local	_uiButtonSelectRewardSlots		= {}
local	_listSelectRewardSlots			= {}
local	isHaveSelectReward				= false

local 	questDescPosY 					= 0
local 	questDescSizeY 					= 0
local 	questDescgap 					= 0

local	currentReward					= 0
local	selectedRewardSlotIndex			= 0
local	acceptButton_isShow				= true
local	isSpecialReward					= false
local	specialRewardWrapper			= {}
local	normalRewardWrapper				= {}

---------------------------------------------------------------

-------------------------- Control 생성 및 획득 -----------------------

--local	_uiCheckButton				= UI.getChildControl( Panel_Challenge_Reward,	"CheckButton_0" )
--local	_uiRewardTitle				= UI.getChildControl( Panel_Challenge_Reward,	"Static_Text_Title" )
local	challengeTitleText			= UI.getChildControl( Panel_Challenge_Reward,	"StaticText_ChallengeReward_TitleText" )
local	remainRewardCount			= UI.getChildControl( Panel_Challenge_Reward,	"StaticText_RemainRewardCountText" )

local	reward_CloseButton			= UI.getChildControl( Panel_Challenge_Reward, 	"Button_Win_Close" )		-- 퀘스트 리워드 닫기
local	reward_AcceptButton			= UI.getChildControl( Panel_Challenge_Reward, 	"Button_AcceptReward" )		-- 보상 받기 버튼
local	reward_CancelButton			= UI.getChildControl( Panel_Challenge_Reward,	"Button_Cancel" )

local	expTooltipBase 				= UI.getChildControl ( Panel_CheckedQuest, 		"StaticText_Notice_2")
local	expTooltip					= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Challenge_Reward, "expTooltip" )
CopyBaseProperty( expTooltipBase, expTooltip )
expTooltip:SetColor( ffffffff )
expTooltip:SetAlpha( 1.0 )
expTooltip:SetFontColor( UI_color.C_FFFFFFFF )
expTooltip:SetAutoResize( true )
expTooltip:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
expTooltip:SetTextHorizonCenter()
expTooltip:SetShow( false )
challengeTitleText:SetAutoResize( true )
challengeTitleText:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )

local	ChallengeSelectReward =
{
	_textTitle			=	UI.getChildControl( Panel_Challenge_Reward, "Static_Text_Title" ),
	_uiRewardSlot_0		=	UI.getChildControl( Panel_Challenge_Reward, "Static_Reward_Slot_0_0" ),
	_uiRewardSlot_1		=	UI.getChildControl( Panel_Challenge_Reward, "Static_Reward_Slot_0_1" ),	
	_uiRewardSlot_2		=	UI.getChildControl( Panel_Challenge_Reward, "Static_Reward_Slot_0_2" ),
	_uiRewardSlot_3		=	UI.getChildControl( Panel_Challenge_Reward, "Static_Reward_Slot_0_3" ),
	_uiRewardSlot_4		=	UI.getChildControl( Panel_Challenge_Reward, "Static_Reward_Slot_0_4" ),
	_uiRewardSlot_5		=	UI.getChildControl( Panel_Challenge_Reward, "Static_Reward_Slot_0_5" ),
	_uiCheckButton_0	=	UI.getChildControl( Panel_Challenge_Reward, "CheckButton_0" ),
	_uiCheckButton_1	=	UI.getChildControl( Panel_Challenge_Reward, "CheckButton_1" ),
	_uiCheckButton_2	=	UI.getChildControl( Panel_Challenge_Reward, "CheckButton_2" ),
	_uiCheckButton_3	=	UI.getChildControl( Panel_Challenge_Reward, "CheckButton_3" ),
	_uiCheckButton_4	=	UI.getChildControl( Panel_Challenge_Reward, "CheckButton_4" ),
	_uiCheckButton_5	=	UI.getChildControl( Panel_Challenge_Reward, "CheckButton_5" ),
	
	_staticLine			=	UI.getChildControl( Panel_Challenge_Reward, "Static_Line_0" ),
	_selectRewardBG		=	UI.getChildControl( Panel_Challenge_Reward, "Static_BG_1" ),
	_staticSelectText	=	UI.getChildControl( Panel_Challenge_Reward, "Static_Menu_Reward_Select" )
}

local	checkButtonOnTexture		=	ChallengeSelectReward._uiCheckButton_0:getOnTexture()
local	checkButtonClickTexture		=	ChallengeSelectReward._uiCheckButton_0:getClickTexture()

local	rewardPanelSizeY			=	Panel_Challenge_Reward:GetSizeY()
local	noSelectPanelSizeY			=	ChallengeSelectReward._staticLine:GetPosY() + reward_AcceptButton:GetSizeY() + 10
local	buttonPosY					=	reward_AcceptButton:GetPosY()

reward_CloseButton:addInputEvent( "Mouse_LUp", "FGlobal_ShowChallengeRewardList(false)" )
reward_AcceptButton:addInputEvent( "Mouse_LUp", "FGlobal_AcceptReward_Clicked()" )
reward_CancelButton:addInputEvent( "Mouse_LUp", "FGlobal_ShowChallengeRewardList(false)" )

-- 기본 보상 ( 슬롯 세팅 )
for index = 0, _maxBaseSlotCount-1, 1 do
	local backBaseReward = UI.getChildControl( Panel_Challenge_Reward, "Static_Slot_"..index )
	backBaseReward:SetIgnore(true)

	_uiBackBaseReward[index] = backBaseReward

	local slot = {}
	SlotItem.new( slot, 'BaseReward_' .. index, index, backBaseReward, _questrewardSlotConfig )
	slot:createChild()
	slot.icon:SetPosX(-2)
	slot.icon:SetPosY(-2)
	-- slot.icon:addInputEvent( "Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(".. index .. ",\"Dialog_ChallengeReward_Base\",true)" )
	-- slot.icon:addInputEvent( "Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(".. index .. ",\"Dialog_ChallengeReward_Base\",false)" )

	_listBaseRewardSlots[index] = slot

	Panel_Tooltip_Item_SetPosition( index, slot, "Dialog_ChallengeReward_Base" )
end

-- 선택 보상 ( 슬롯 세팅 )
for index = 0, _maxSelectSlotCount-1, 1 do
	local buttonSelectRewardSlot = UI.getChildControl( Panel_Challenge_Reward, "CheckButton_"..index )
	buttonSelectRewardSlot:addInputEvent( "Mouse_LUp", "HandleSelectedRewardClicked("..index..")" )
	-- buttonSelectRewardSlot:addInputEvent( "Mouse_On",  "HandleOnSelectedChallengeReward(".. index .. ")" )
	-- buttonSelectRewardSlot:addInputEvent( "Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(".. index .. ",\"Dialog_ChallengeReward_Select\",false)" )

	_uiButtonSelectRewardSlots[index] = buttonSelectRewardSlot

	local slot = {}
	SlotItem.new( slot, 'SelectReward_' .. index, index, buttonSelectRewardSlot, _questrewardSlotConfig )
	slot:createChild()
	slot.icon:SetPosX(4)
	slot.icon:SetPosY(4)
	slot.icon:SetIgnore(true)

	_listSelectRewardSlots[index] = slot

	Panel_Tooltip_Item_SetPosition( index, slot, "Dialog_ChallengeReward_Select" )
end
---------------------------------------------------------------------

-------------------------- 보상창 --------------------
-- 보상 선택 ( 보상을 선택하였을때 실행 )
function HandleSelectedRewardClicked(selectIndex)
	selectedRewardSlotIndex = selectIndex
	
	for index=0 , 5, 1 do
		_uiButtonSelectRewardSlots[index]:SetCheck(false)
		_uiButtonSelectRewardSlots[index]:EraseAllEffect()
	end
	_uiButtonSelectRewardSlots[selectIndex]:AddEffect( "UI_Quest_Compensate_Loop", true, 0, 0 )
	_uiButtonSelectRewardSlots[selectIndex]:SetCheck(true)
	_uiButtonSelectRewardSlots[selectIndex]:setRenderTexture(checkButtonClickTexture)
	--ReqeustDialog_selectReward(selectIndex)
end

-- 보상 확인 ( 툴팁에서 보상아이템을 보여줌 )
function HandleOnSelectedChallengeReward(index)
	Panel_Tooltip_Item_Show_GeneralStatic(index,"Dialog_ChallengeReward_Select",true)
	_uiButtonSelectRewardSlots[index]:setRenderTexture(checkButtonOnTexture)
end

-- 보상 아이콘 설정 
function	setChallengeReward( uiSlot, reward, index, questType )
	uiSlot._type = reward._type
	if	UI_RewardType.RewardType_Exp ==	reward._type then						-- 경험치			{type=%#, exp=%#}
		uiSlot.count:SetText( '' )
		uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
		uiSlot.icon:addInputEvent( "Mouse_On", "ChallengeRewardTooltip( \"Exp\", true, \"" .. questType .. "\", " .. index .. " )" )
		uiSlot.icon:addInputEvent( "Mouse_Out", "ChallengeRewardTooltip( \"Exp\", false, \"" .. questType .. "\", " .. index .. " )" )
	elseif	UI_RewardType.RewardType_SkillExp == reward._type then				-- 스킬 경험치	{type=%#, exp=%#}
		uiSlot.count:SetText( '' )
		uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/SkillExp.dds")
		uiSlot.icon:addInputEvent( "Mouse_On", "ChallengeRewardTooltip( \"SkillExp\", true, \"" .. questType .. "\", " .. index .. " )" )
		uiSlot.icon:addInputEvent( "Mouse_Out", "ChallengeRewardTooltip( \"SkillExp\", false, \"" .. questType .. "\", " .. index .. " )" )
	elseif	UI_RewardType.RewardType_ProductExp == reward._type then			-- 생산 경험치	{type=%#, exp=%#}
		uiSlot.count:SetText( '' )
		uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
		uiSlot.icon:addInputEvent( "Mouse_On", "ChallengeRewardTooltip( \"ProductExp\", true, \"" .. questType .. "\", " .. index .. " )" )
		uiSlot.icon:addInputEvent( "Mouse_Out", "ChallengeRewardTooltip( \"ProductExp\", false, \"" .. questType .. "\", " .. index .. " )" )
	elseif	UI_RewardType.RewardType_Item == reward._type then				-- 아이템		{type=%#, item=%#, count=%#}
		local itemStatic = getItemEnchantStaticStatus( ItemEnchantKey(reward._item) );
		uiSlot:setItemByStaticStatus( itemStatic, reward._count );
		uiSlot._item = reward._item
		if "main" == questType then
			uiSlot.icon:addInputEvent( "Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(".. index .. ",\"Dialog_ChallengeReward_Base\",true)" )
			uiSlot.icon:addInputEvent( "Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(".. index .. ",\"Dialog_ChallengeReward_Base\",false)" )
		else
			uiSlot.icon:addInputEvent( "Mouse_On", "" )
			uiSlot.icon:addInputEvent( "Mouse_Out", "" )
			_uiButtonSelectRewardSlots[index]:addInputEvent( "Mouse_On",  "HandleOnSelectedChallengeReward(".. index .. ")" )
			_uiButtonSelectRewardSlots[index]:addInputEvent( "Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(".. index .. ",\"Dialog_ChallengeReward_Select\",false)" )
		end
		return reward._isEquipable
	elseif	UI_RewardType.RewardType_Intimacy == reward._type then				-- 친밀도		{type=%#, character=%#, value=%#}
		uiSlot.count:SetText( tostring(reward._value) )
		uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/00000000_Special_Contributiveness.dds")
		uiSlot.icon:addInputEvent( "Mouse_On", "ChallengeRewardTooltip( \"Intimacy\", true, \"" .. questType .. "\", " .. index .. " )" )
		uiSlot.icon:addInputEvent( "Mouse_Out", "ChallengeRewardTooltip( \"Intimacy\", false, \"" .. questType .. "\", " .. index .. " )" )
	else
		uiSlot.icon:addInputEvent( "Mouse_On", "" )
		uiSlot.icon:addInputEvent( "Mouse_Out", "" )
	end
	return false;
end

function ChallengeRewardTooltip( type, show, questtype, index )
	if true == show then
		if "Exp" == type then
			expTooltip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_EXP") )
		elseif "SkillExp" == type then
			expTooltip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_SKILLEXP") )
		elseif "ProductExp" == type then
			expTooltip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_PRODUCTEXP") )
		elseif "Intimacy" == type then
			expTooltip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_INTIMACY") )
		end

		if "main" == questtype then
			expTooltip:SetPosX( _uiBackBaseReward[index]:GetPosX() - (expTooltip:GetSizeX()/2) )
			expTooltip:SetPosY( _uiBackBaseReward[index]:GetPosY() - expTooltip:GetSizeY() - 10 )
		else
			expTooltip:SetPosX( _uiButtonSelectRewardSlots[index]:GetPosX() - (expTooltip:GetSizeX()/2) )
			expTooltip:SetPosY( _uiButtonSelectRewardSlots[index]:GetPosY() - expTooltip:GetSizeY() )
		end
		expTooltip:SetShow( true )
	else
		expTooltip:SetShow( false )
	end
end

function FromClient_ChallengeReward_UpdateText()

	isSpecialReward = false
	local specialRewardCount = 0
	local normalRewardCount = 0
	for i=0, ToClient_GetChallengeRewardInfoCount()-1 do
		local rewardWrapper = ToClient_GetChallengeRewardInfoWrapper(i)
		if 0 == rewardWrapper:getType() then
			specialRewardWrapper[specialRewardCount] = rewardWrapper
			specialRewardCount = specialRewardCount + 1
		else
			normalRewardWrapper[normalRewardCount] = rewardWrapper
			normalRewardCount = normalRewardCount + 1
		end
	end
	
	if ( 0 < specialRewardCount ) then
		isSpecialReward = true
	end
	--_PA_LOG("이문종", "특별 보상 == " .. specialRewardCount .. " 개")
	--_PA_LOG("이문종", "그냥 보상 == " .. normalRewardCount .. " 개")

	-- 스페셜 보상이 있으면..
	if ( nil ~= specialRewardWrapper[currentReward] ) then
		local baseCount 	= specialRewardWrapper[currentReward]:getBaseRewardCount()
		challengeTitleText:SetText( specialRewardWrapper[currentReward]:getName() ) 				-- rewardWrapper:getName() : 과제명
		remainRewardCount:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CHALLENGE_REWARD_REMAINREWARDCOUNT", "normalRewardCount", normalRewardCount ) ) -- "남은 보상 : " .. normalRewardCount .. " 개" )  				-- _remainRewardCount 개 남음.
		
		local _baseReward = {}
		for idx=1, baseCount, 1 do
			local baseReward = specialRewardWrapper[currentReward]:getBaseRewardAt(idx-1)
			_baseReward[idx] = {}
			_baseReward[idx]._type = baseReward._type
			if (CppEnums.RewardType.RewardType_Exp == baseReward._type) then
				_baseReward[idx]._exp = baseReward._experience
			elseif (CppEnums.RewardType.RewardType_SkillExp == baseReward._type) then
				_baseReward[idx]._exp = baseReward._skillExperience
			elseif (CppEnums.RewardType.RewardType_ProductExp == baseReward._type) then
				_baseReward[idx]._exp = baseReward._productExperience
			elseif (CppEnums.RewardType.RewardType_Item	 == baseReward._type) then
				_baseReward[idx]._item = baseReward:getItemEnchantKey()
				_baseReward[idx]._count = baseReward._itemCount
			elseif (CppEnums.RewardType.RewardType_Intimacy	 == baseReward._type) then
				_baseReward[idx]._character = baseReward:getIntimacyCharacter()
				_baseReward[idx]._value = baseReward._intimacyValue
			end
		end
		
		local selectCount 	= specialRewardWrapper[currentReward]:getSelectRewardCount()
		local _selectReward = {}
		if ( 0 < selectCount ) then
			isHaveSelectReward = true
			for idx=1, selectCount, 1 do
				local selectReward = specialRewardWrapper[currentReward]:getSelectRewardAt(idx-1)
				_selectReward[idx] = {}
				_selectReward[idx]._type = selectReward._type
				if (CppEnums.RewardType.RewardType_Exp == selectReward._type) then
					_selectReward[idx]._exp = selectReward._experience
				elseif (CppEnums.RewardType.RewardType_SkillExp == selectReward._type) then
					_selectReward[idx]._exp = selectReward._skillExperience
				elseif (CppEnums.RewardType.RewardType_ProductExp == selectReward._type) then
					_selectReward[idx]._exp = selectReward._productExperience
				elseif (CppEnums.RewardType.RewardType_Item	 == selectReward._type) then
					_selectReward[idx]._item = selectReward:getItemEnchantKey()
					_selectReward[idx]._count = selectReward._itemCount
					local selfPlayer = getSelfPlayer()
					if nil ~= selfPlayer then
						local classType = selfPlayer:getClassType() 
						_selectReward[idx]._isEquipable = selectReward:isEquipable(classType)
					end
				elseif (CppEnums.RewardType.RewardType_Intimacy	 == selectReward._type) then
					_selectReward[idx]._character = selectReward:getIntimacyCharacter()
					_selectReward[idx]._value = selectReward._intimacyValue
				end
			end
		else
			isHaveSelectReward = false
			_selectReward = nil
		end
		
		FGlobal_SetChallengeRewardList( _baseReward, _selectReward )
		Fglobal_Challenge_UpdateData()
		if ( 4 < getSelfPlayer():get():getLevel() ) then
			Panel_SpecialReward_Alert:SetShow( true )
			Panel_SpecialReward_Alert:SetSpanSize( -33, 95 )
		end
	else
		Panel_SpecialReward_Alert:SetShow( false )
		
	end
	
	-- 일반 도전과제 보상이 있으면
	if( nil ~= normalRewardWrapper[currentReward] ) then
		local baseCount 	= normalRewardWrapper[currentReward]:getBaseRewardCount()
		challengeTitleText:SetText( normalRewardWrapper[currentReward]:getName() ) 				-- rewardWrapper:getName() : 과제명
		remainRewardCount:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CHALLENGE_REWARD_REMAINREWARDCOUNT", "normalRewardCount", normalRewardCount ) ) -- "남은 보상 : " .. normalRewardCount .. " 개" )  				-- _remainRewardCount 개 남음.
		
		local _baseReward = {}
		for idx=1, baseCount, 1 do
			local baseReward = normalRewardWrapper[currentReward]:getBaseRewardAt(idx-1)
			_baseReward[idx] = {}
			_baseReward[idx]._type = baseReward._type
			if (CppEnums.RewardType.RewardType_Exp == baseReward._type) then
				_baseReward[idx]._exp = baseReward._experience
			elseif (CppEnums.RewardType.RewardType_SkillExp == baseReward._type) then
				_baseReward[idx]._exp = baseReward._skillExperience
			elseif (CppEnums.RewardType.RewardType_ProductExp == baseReward._type) then
				_baseReward[idx]._exp = baseReward._productExperience
			elseif (CppEnums.RewardType.RewardType_Item	 == baseReward._type) then
				_baseReward[idx]._item = baseReward:getItemEnchantKey()
				_baseReward[idx]._count = baseReward._itemCount
			elseif (CppEnums.RewardType.RewardType_Intimacy	 == baseReward._type) then
				_baseReward[idx]._character = baseReward:getIntimacyCharacter()
				_baseReward[idx]._value = baseReward._intimacyValue
			end
		end
		
		local selectCount 	= normalRewardWrapper[currentReward]:getSelectRewardCount()
		local _selectReward = {}
		if ( 0 < selectCount ) then
			isHaveSelectReward = true
			for idx=1, selectCount, 1 do
				local selectReward = normalRewardWrapper[currentReward]:getSelectRewardAt(idx-1)
				_selectReward[idx] = {}
				_selectReward[idx]._type = selectReward._type
				if (CppEnums.RewardType.RewardType_Exp == selectReward._type) then
					_selectReward[idx]._exp = selectReward._experience
				elseif (CppEnums.RewardType.RewardType_SkillExp == selectReward._type) then
					_selectReward[idx]._exp = selectReward._skillExperience
				elseif (CppEnums.RewardType.RewardType_ProductExp == selectReward._type) then
					_selectReward[idx]._exp = selectReward._productExperience
				elseif (CppEnums.RewardType.RewardType_Item	 == selectReward._type) then
					_selectReward[idx]._item = selectReward:getItemEnchantKey()
					_selectReward[idx]._count = selectReward._itemCount
					local selfPlayer = getSelfPlayer()
					if nil ~= selfPlayer then
						local classType = selfPlayer:getClassType() 
						_selectReward[idx]._isEquipable = selectReward:isEquipable(classType)
					end
				elseif (CppEnums.RewardType.RewardType_Intimacy	 == selectReward._type) then
					_selectReward[idx]._character = selectReward:getIntimacyCharacter()
					_selectReward[idx]._value = selectReward._intimacyValue
				end
			end
		else
			isHaveSelectReward = false
			_selectReward = nil
		end
		
		FGlobal_SetChallengeRewardList( _baseReward, _selectReward )
		Fglobal_Challenge_UpdateData()
		if ( 4 < getSelfPlayer():get():getLevel() ) then
			if (7 == getGameServiceType() or 8 == getGameServiceType()) and getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_CBT then
				Panel_ChallengeReward_Alert:SetShow( false )
			else
				Panel_ChallengeReward_Alert:SetShow( true )
			end
			Panel_ChallengeReward_Alert:SetSpanSize( -33, 84 )
		end
	else
		Panel_ChallengeReward_Alert:SetShow( false )
	end
	
	-- 남은 보상이 아무것도 없다면
	if ( 0 == ToClient_GetChallengeRewardInfoCount() ) then
		FGlobal_ShowChallengeRewardList( false )
		Panel_ChallengeReward_Alert:SetShow( false )
		Fglobal_Challenge_UpdateData()
	end
end

-- 보상 받기 버튼
function	FGlobal_AcceptReward_Clicked()
	local rewardWrapper = ToClient_GetChallengeRewardInfoWrapper(currentReward)
	local challengeKey = rewardWrapper:getKey()
	local	selectCount	=	rewardWrapper:getSelectRewardCount()		-- 선택 보상 개수
	if ( 0 < selectCount ) then
		local isCheck = false
		for i = 0, selectCount -1 do
			if ( _uiButtonSelectRewardSlots[i]:IsCheck() ) then
			isCheck = true
			end
		end
		
		if ( false == isCheck ) then
			-- "보상을 선택해 주세요!"
			local msg = { main = PAGetString(Defines.StringSheet_GAME, "DIALOG_MESSAGE_SELECT_REWARD"), sub = PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGEREWARD_GETITEMTOSELECT") }-- main = "보상 아이템을 선택해 주세요", sub = "받을 아이템을 선택해야 합니다." }
			Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect( msg, 6, 4 )
			--Proc_ShowMessage_Ack_WithOut_ChattingMessage( "보상 아이템을 선택해 주세요" )
			return
		end
	end
	
	ToClient_AcceptReward_ButtonClicked(challengeKey,selectedRewardSlotIndex)
	FromClient_ChallengeReward_UpdateText()
	FGlobal_ShowChallengeRewardList( Panel_Challenge_Reward:GetShow() )
end

-- 보상 패널 보이기 / 리포지션
function	FGlobal_SetShowChallengeRewardList( isShow )
	if Panel_Window_CharInfo_Status:GetShow() then
		local posX	=	Panel_Window_CharInfo_Status:GetPosX()
		local posY	=	Panel_Window_CharInfo_Status:GetPosY()
		local posY	=	Panel_Window_CharInfo_Status:GetPosY()
		local sizeX	=	Panel_Window_CharInfo_Status:GetSizeX()
		local sizeY	=	Panel_Window_CharInfo_Status:GetSizeY()
		
		local rewardPosX = posX + sizeX + 20
		local rewardPosY = posY + sizeY/4
		
		if ( getScreenSizeX() < rewardPosX + Panel_Challenge_Reward:GetSizeX() ) then
			rewardPosX = posX - Panel_Challenge_Reward:GetSizeX() - 20
		end
		
		if ( getScreenSizeY() < rewardPosY + Panel_Challenge_Reward:GetSizeY() ) then
			rewardPosY = getScreenSizeY() - Panel_Challenge_Reward:GetSizeY() - 20
		end
		
		Panel_Challenge_Reward:SetPosX( rewardPosX )
		Panel_Challenge_Reward:SetPosY( rewardPosY )
	else
		Panel_Challenge_Reward:SetPosX( Panel_CheckedQuest:GetPosX() - Panel_Challenge_Reward:GetSizeX() )
		Panel_Challenge_Reward:SetPosY( getScreenSizeY()/2 - Panel_Challenge_Reward:GetSizeY()/2 )
	end
	
	Panel_Challenge_Reward:SetShow(isShow)
	if ( false == acceptButton_isShow ) then
		remainRewardCount:SetShow( false )
		reward_AcceptButton:SetShow( false )
		reward_CancelButton:SetPosX( Panel_Challenge_Reward:GetSizeX()/2 - reward_CancelButton:GetSizeX()/2 )
	else
		remainRewardCount:SetShow( true )
		reward_AcceptButton:SetShow( true )
		reward_CancelButton:SetPosX( Panel_Challenge_Reward:GetSizeX()/2 + reward_CancelButton:GetSizeX()/2 - 35 )
		FromClient_ChallengeReward_UpdateText()
	end
	acceptButton_isShow = true
end

-- 선택 보상이 없으면 해당 부분을 숨긴다
function FGlobal_SelectReward_IsShow( isShow )
	if ( false == isShow ) then
		-- 선택 보상과 관련된 컨트롤을 꺼준다
		Challenge_SelectReward_IsShow( false )
		Panel_Challenge_Reward	:	SetSize( Panel_Challenge_Reward:GetSizeX(), noSelectPanelSizeY )
		reward_AcceptButton		:	SetPosY( noSelectPanelSizeY - reward_AcceptButton:GetSizeY() - 10 )
		reward_CancelButton		:	SetPosY( noSelectPanelSizeY - reward_AcceptButton:GetSizeY() - 10 )
	else
		-- 선택 보상과 관련된 컨트롤을 켜준다
		Challenge_SelectReward_IsShow( true )
		Panel_Challenge_Reward	:	SetSize( Panel_Challenge_Reward:GetSizeX(), rewardPanelSizeY )
		reward_AcceptButton		:	SetPosY( buttonPosY )
		reward_CancelButton		:	SetPosY( buttonPosY )
	end
	
end

function Challenge_SelectReward_IsShow( isShow )
	for _, control in pairs ( ChallengeSelectReward ) do
		control:SetShow( isShow )
	end
end

-- 보상 설정 ( 기본보상과 선택보상 )
function	FGlobal_SetChallengeRewardList( baseReward, selectReward )
	_baseRewardCount	= #baseReward
	
	for index = 0, _maxBaseSlotCount-1, 1 do
		_uiBackBaseReward[index]:EraseAllEffect()
		if index < _baseRewardCount then
			setChallengeReward( _listBaseRewardSlots[index], baseReward[index + 1], index, "main" )
			_uiBackBaseReward[index]:SetShow(true)
		else
			_uiBackBaseReward[index]:SetShow(false)
		end
	end
	
	-- 선택 보상이 없으면 리턴
	if ( nil == selectReward ) then
		FGlobal_SelectReward_IsShow( false )
		return
	else
		_selectRewardCount	= #selectReward
	end

	------------------------------------
	-- 	기본적으로 체크를 풀어준다!
	for index = 0 , 5, 1 do
		_uiButtonSelectRewardSlots[index]:SetCheck(false)
	end
	local 	_equipRewardCount 				= 0
	local 	_equipEnableSlot				= nil

	for index = 0, _maxSelectSlotCount-1, 1 do
		_uiButtonSelectRewardSlots[index]:EraseAllEffect()
		if index < _selectRewardCount then
			local isEquipable = setChallengeReward(	_listSelectRewardSlots[index], selectReward[index + 1], index, "sub" )
			if isEquipable then
				_equipRewardCount = _equipRewardCount + 1
				_equipEnableSlot = index
			end
			_uiButtonSelectRewardSlots[index]:SetShow(true)
			_uiButtonSelectRewardSlots[index]:SetCheck(false)
			_uiButtonSelectRewardSlots[index]:AddEffect( "UI_Quest_Compensate", true, 0, 0 )
			_uiButtonSelectRewardSlots[index]:AddEffect( "fUI_Light", false, 0, 0 )
		else
			_uiButtonSelectRewardSlots[index]:SetShow(false)
		end
	end
	------------------------------------
	-- 	장비 가능한 보상이 1개인 경우 체크해준다
	if _equipRewardCount == 1 then
		if nil ~= _equipEnableSlot then
			HandleSelectedRewardClicked(_equipEnableSlot)
		end
	end

	FGlobal_SelectReward_IsShow( true )
end


-- 보상 아이템 노출
function FGlobal_ShowChallengeRewardList(isVisible)
	if isVisible then
		if (0 < ToClient_GetChallengeRewardInfoCount() ) then				-- 보상을 받지 않은 도전과제가 있다면
			-- 사운드 추가 필요
			FGlobal_SetShowChallengeRewardList( true )
			Panel_Challenge_Reward:SetShow(true)
		else
			Panel_Challenge_Reward:SetShow(false)
		end
	else
		Panel_Challenge_Reward:SetShow(false)
	end

end

function Panel_Challenge_Reward_JustShow( rewardWrapper )
	challengeTitleText:SetText( rewardWrapper:getName() )
	acceptButton_isShow = false
	FGlobal_SetShowChallengeRewardList( true )
end

function FromClient_CompleteChallengeReward()
	local rewardCount = ToClient_GetChallengeRewardInfoCount()
	if nil == rewardCount or 0 == rewardCount then
		return
	end
	local rewardWrapper = ToClient_GetChallengeRewardInfoWrapper(rewardCount-1)
	if( nil ~= rewardWrapper ) then
		if ( 0 == rewardWrapper:getType() ) then
			isSpecialReward = true
			--_PA_LOG("이문종", "특별 보상 도착" )
		else
			local message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHALLENGE_REWARD_ARCHIVEMENT", "challengeName", rewardWrapper:getName() )
			-- 도전 과제 : {challengeName} 달성!
			Proc_ShowBigMessage_Ack_WithOut_ChattingMessage(message)
			--_PA_LOG("이문종", message)
		end
	end
	FromClient_ChallengeReward_UpdateText()
end

FromClient_ChallengeReward_UpdateText()

local _buttonQuestion = UI.getChildControl ( Panel_Challenge_Reward, "Button_Question" )						-- 물음표 버튼
_buttonQuestion:addInputEvent( "Mouse_LUp",  "Panel_WebHelper_ShowToggle( \"PanelQuestReward\" )" )				-- 물음표 좌클릭
_buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"PanelQuestReward\", \"true\")" )		-- 물음표 마우스오버
_buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"PanelQuestReward\", \"false\")" )		-- 물음표 마우스아웃
registerEvent("FromClient_ChallengeReward_UpdateText",	"FromClient_ChallengeReward_UpdateText")				-- 로그인 시 실행
registerEvent("FromClient_CompleteChallengeReward",	"FromClient_CompleteChallengeReward")						-- 도전 과제 달성 시 실행