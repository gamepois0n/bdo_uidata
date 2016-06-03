local UI_color			= Defines.Color
local UI_TM				= CppEnums.TextMode
local UI_RewardType		= CppEnums.RewardType
local UI_ANI_ADV 		= CppEnums.PAUI_ANIM_ADVANCE_TYPE

Panel_CheckedQuestInfo:ActiveMouseEventEffect(true)
Panel_CheckedQuestInfo:setGlassBackground(true)
Panel_CheckedQuestInfo:SetShow( false, false )

Panel_CheckedQuestInfo:RegisterShowEventFunc( true, 'Panel_CheckedQuestInfo_ShowAni()' )
Panel_CheckedQuestInfo:RegisterShowEventFunc( false, 'Panel_CheckedQuestInfo_HideAni()' )



function Panel_CheckedQuestInfo_ShowAni()
	-- ♬ 켜질 때 소리
	audioPostEvent_SystemUi(01,00)
	
	Panel_CheckedQuestInfo:SetAlpha( 0 )
	UIAni.AlphaAnimation( 1, Panel_CheckedQuestInfo, 0.0, 0.15 )

	local aniInfo1 = Panel_CheckedQuestInfo:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.12)
	aniInfo1.AxisX = Panel_CheckedQuestInfo:GetSizeX() / 2
	aniInfo1.AxisY = Panel_CheckedQuestInfo:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_CheckedQuestInfo:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.12)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_CheckedQuestInfo:GetSizeX() / 2
	aniInfo2.AxisY = Panel_CheckedQuestInfo:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function Panel_CheckedQuestInfo_HideAni()
	-- ♬ 꺼질 때 소리
	audioPostEvent_SystemUi(01,01)
	
	Panel_CheckedQuestInfo:SetAlpha( 1 )
	local aniInfo1 = UIAni.AlphaAnimation( 0, Panel_CheckedQuestInfo, 0.0, 0.1 )
	aniInfo1:SetHideAtEnd(true)
end

-----------------------------------------------------------
-- 퀘스트 정보창
-----------------------------------------------------------
local   questInfoWindow_questTitle           = UI.getChildControl ( Panel_CheckedQuestInfo, "StaticText_QuestTitle" )
local   questInfoWindow_questCondition       = UI.getChildControl ( Panel_CheckedQuestInfo, "StaticText_QuestCondition" )
local   questInfoWindow_questDesc            = UI.getChildControl ( Panel_CheckedQuestInfo, "StaticText_QuestDesc" )
local   questInfoWindow_questIcon            = UI.getChildControl ( Panel_CheckedQuestInfo, "Static_QuestIcon" )
local   questInfoWindow_questIconBG          = UI.getChildControl ( Panel_CheckedQuestInfo, "Static_IconBackground" )
local   questInfoWindow_questTitleBG         = UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Quest_QuestTitle_BG" )
local   questInfoWindow_groupTitle           = UI.getChildControl ( Panel_CheckedQuestInfo, "StaticText_GroupTitle" )
local   questInfoWindow_completeNpc          = UI.getChildControl ( Panel_CheckedQuestInfo, "StaticText_QuestCompleteNpc" )
local   questInfoWindow_naviButton           = UI.getChildControl ( Panel_CheckedQuestInfo, "Checkbox_Quest_Navi" )
local   questInfoWindow_giveupButton         = UI.getChildControl ( Panel_CheckedQuestInfo, "Checkbox_Quest_Giveup" )
local   questInfoWindow_questButtonClose     = UI.getChildControl ( Panel_CheckedQuestInfo, "Button_Win_Close" )
questInfoWindow_questButtonClose:addInputEvent( "Mouse_LUp", "FGlobal_QuestInfoDetail_Close()" )

local	button_Giveup_QuestInfoWindow		 = UI.getChildControl ( Panel_CheckedQuestInfo, "Button_Quest_GiveUp" )
local	button_CallSpirit_QuestInfoWindow	 = UI.getChildControl ( Panel_CheckedQuestInfo, "Button_Quest_CallSpirit" )
local	button_Navi_QuestInfoWindow			 = UI.getChildControl ( Panel_CheckedQuestInfo, "CheckBtn_Quest_Navi" )
local	button_AutoNavi_QuestInfoWindow		 = UI.getChildControl ( Panel_CheckedQuestInfo, "CheckBtn_Quest_AutoNavi" )

-----------------------------------------------------------
-- 퀘스트 보상 설정
-----------------------------------------------------------
local 	_baseReward						= {}
local	_maxBaseSlotCount				= 12
local	_uiBackBaseReward				= {}
local	_listBaseRewardSlots			= {}
local 	_selectReward					= {}
local 	_selectRewardCount				= 0
local	_maxSelectSlotCount				= 6
local	_uiButtonSelectRewardSlots		= {}
local	_listSelectRewardSlots			= {}
local _questrewardSlotConfig =
{	-- 일단 아이콘, 테두리, 카운트(숫자) 만 적용한다!
	createIcon			= true,
	createBorder		= true,
	createCount			= true,
	createClassEquipBG	= true,
	createCash			= true
}

-- 아이템 외 툴팁용도
local	expTooltipBase 				= UI.getChildControl ( Panel_CheckedQuest, "StaticText_Notice_2")
local	expTooltip					= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_CheckedQuestInfo, "expTooltip_ForQuestWidgetInfo" )
CopyBaseProperty( expTooltipBase, expTooltip )
expTooltip:SetColor( ffffffff )
expTooltip:SetAlpha( 1.0 )
expTooltip:SetFontColor( UI_color.C_FFFFFFFF )
expTooltip:SetAutoResize( true )
expTooltip:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
expTooltip:SetTextHorizonCenter()
expTooltip:SetShow( false )


-----------------------------------------------------------
-- 퀘스트 보상 슬롯 설정
-----------------------------------------------------------

local reward_TitleBG	= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_RewardTitleBG" )
local reward_Title		= UI.getChildControl ( Panel_CheckedQuestInfo, "StaticText_RewardTitle" )
local baseRewardBG		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_BG_0" )
local lineHeight		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Line_Height" )
local baseRewardTitle	= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Menu_Reward" )
local lineWidth			= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Line_0" )
local selectRewardTitle	= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Menu_Reward_Select" )
local selectRewardBG	= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_BG_1" )

local baseSlotBG0		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Reward_Slot_0" )
local baseSlotBG1		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Reward_Slot_1" )
local baseSlotBG2		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Reward_Slot_2" )
local baseSlotBG3		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Reward_Slot_3" )
local baseSlotBG4		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Reward_Slot_4" )
local baseSlotBG5		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Reward_Slot_5" )
local baseSlotBG6		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Reward_Slot_6" )
local baseSlotBG7		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Reward_Slot_7" )
local baseSlotBG8		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Reward_Slot_8" )
local baseSlotBG9		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Reward_Slot_9" )
local baseSlotBG10		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Reward_Slot_10" )
local baseSlotBG11		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Reward_Slot_11" )
local baseSlot0			= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Slot_0" )
local baseSlot1			= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Slot_1" )
local baseSlot2			= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Slot_2" )
local baseSlot3			= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Slot_3" )
local baseSlot4			= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Slot_4" )
local baseSlot5			= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Slot_5" )
local baseSlot6			= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Slot_6" )
local baseSlot7			= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Slot_7" )
local baseSlot8			= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Slot_8" )
local baseSlot9			= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Slot_9" )
local baseSlot10		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Slot_10" )
local baseSlot11		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_Slot_11" )

local selectSlotBG0		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_SelectSlotBG_0" )
local selectSlotBG1		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_SelectSlotBG_1" )
local selectSlotBG2		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_SelectSlotBG_2" )
local selectSlotBG3		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_SelectSlotBG_3" )
local selectSlotBG4		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_SelectSlotBG_4" )
local selectSlotBG5		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_SelectSlotBG_5" )
local selectSlot0		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_SelectSlot_0" )
local selectSlot1		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_SelectSlot_1" )
local selectSlot2		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_SelectSlot_2" )
local selectSlot3		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_SelectSlot_3" )
local selectSlot4		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_SelectSlot_4" )
local selectSlot5		= UI.getChildControl ( Panel_CheckedQuestInfo, "Static_SelectSlot_5" )

-- 기본 보상
for index = 0, _maxBaseSlotCount-1, 1 do
	local backBaseReward = UI.getChildControl( Panel_CheckedQuestInfo, "Static_Slot_"..index )
	backBaseReward:SetIgnore(true)

	_uiBackBaseReward[index] = backBaseReward

	local slot = {}
	SlotItem.new( slot, 'BaseReward_' .. index, index, backBaseReward, _questrewardSlotConfig )
	slot:createChild()
	slot.icon:SetPosX(1)
	slot.icon:SetPosY(1)
	slot.border:SetSize(41,41)
	slot.icon:SetIgnore( false )
	-- slot.icon:addInputEvent( "Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(".. index .. ",\"QuestReward_Base\",true)" )
	-- slot.icon:addInputEvent( "Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(".. index .. ",\"QuestReward_Base\",false)" )

	_listBaseRewardSlots[index] = slot

	Panel_Tooltip_Item_SetPosition( index, slot, "QuestReward_Base" )
end

-- 선택 보상
for index = 0, _maxSelectSlotCount-1, 1 do
	local buttonSelectRewardSlot = UI.getChildControl( Panel_CheckedQuestInfo, "Static_SelectSlot_"..index )
	
	_uiButtonSelectRewardSlots[index] = buttonSelectRewardSlot

	local slot = {}
	SlotItem.new( slot, 'SelectReward_' .. index, index, buttonSelectRewardSlot, _questrewardSlotConfig )
	slot:createChild()
	slot.icon:SetPosX(1)
	slot.icon:SetPosY(1)
	slot.border:SetSize(41,41)
	slot.icon:SetIgnore( false )
	-- slot.icon:addInputEvent( "Mouse_On",  "Panel_Tooltip_Item_Show_GeneralStatic(".. index .. ",\"QuestReward_Select\",true)" )
	-- slot.icon:addInputEvent( "Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(".. index .. ",\"QuestReward_Select\",false)" )

	_listSelectRewardSlots[index] = slot

	Panel_Tooltip_Item_SetPosition( index, slot, "QuestReward_Select" )
end


--------------------------------------------------------------------
-- 퀘스트 정보창
--------------------------------------------------------------------
function FGlobal_QuestInfoDetail( groupId, questId, condition, groupTitle, questGroupCount, fromQuestWidget )
	if _questInfoDetailGroupId == groupId and _questInfoDetailQuestId == questId then
		FGlobal_QuestInfoDetail_Close()
		Panel_Window_QuestNew_Show( false )
		-- FGlobal_QuestHistoryClose()
		-- _questInfoDetailGroupId = 0
		-- _questInfoDetailQuestId = 0
		return
		-- ESC에서 지워야 한다.
	end
	
	Panel_Window_QuestNew_Show( true, fromQuestWidget )
	FGlobal_QuestHistoryOpen()

	
	_questInfoDetailGroupId = groupId
	_questInfoDetailQuestId = questId

	local questInfo = questList_getQuestStatic( groupId, questId )
	local completeNpc = questInfo:getCompleteDisplay()

	local PosY = 45

	questInfoWindow_groupTitle:SetShow( true )
	if "nil" ~= groupTitle then
		local tempValue = groupTitle .. " (" .. questId .. "/" .. questGroupCount .. " "
		questInfoWindow_groupTitle:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_QUESTWIDGET_QUESTINFO_GROUP_TITLE", "value", tempValue ) )
	else
		questInfoWindow_groupTitle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_QUESTINFO_NORMAL_TITLE") )
	end
	questInfoWindow_groupTitle:SetPosY( PosY )
	questInfoWindow_groupTitle:SetFontColor( UI_color.C_FFEEBA3E )
	PosY = PosY + questInfoWindow_groupTitle:GetSizeY() + 5

	questInfoWindow_questTitleBG:SetShow( true )
	questInfoWindow_questTitleBG:SetPosY( PosY )
	questInfoWindow_questTitle:SetShow( true )
	questInfoWindow_questTitle:SetText( questInfo:getTitle() )
	questInfoWindow_questTitle:SetPosY( PosY )

	questInfoWindow_naviButton:SetShow( true )
	questInfoWindow_naviButton:SetPosY( PosY + 2 )
	questInfoWindow_naviButton:addInputEvent("Mouse_LUp",	"HandleClicked_QuestWidget_FindTarget( " .. groupId .. ", " .. questId .. ", " .. condition .. ", false )")
	questInfoWindow_giveupButton:SetShow( true )
	questInfoWindow_giveupButton:SetPosY( PosY + 2 )
	questInfoWindow_giveupButton:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_QuestGiveUp(" .. groupId .. "," ..questId .. ")")
	
	button_Giveup_QuestInfoWindow		:SetShow( true )
	button_Giveup_QuestInfoWindow		:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_QuestGiveUp(" .. groupId .. "," ..questId .. ")")
	button_CallSpirit_QuestInfoWindow	:SetShow( false )
	button_CallSpirit_QuestInfoWindow	:addInputEvent("Mouse_LUp", "HandleClicked_CallSpirit()")
	button_Navi_QuestInfoWindow			:SetShow( true )
	button_Navi_QuestInfoWindow			:addInputEvent("Mouse_LUp",	"HandleClicked_QuestWidget_FindTarget( " .. groupId .. ", " .. questId .. ", " .. condition .. ", false )")
	button_AutoNavi_QuestInfoWindow		:SetShow( true )
	button_AutoNavi_QuestInfoWindow		:addInputEvent("Mouse_LUp",	"HandleClicked_QuestWidget_FindTarget( " .. groupId .. ", " .. questId .. ", " .. condition .. ", true )")


	local _questGroupId, _questId, _naviInfoAgain = _QuestWidget_ReturnQuestState()
	if _questGroupId == groupId and _questId == questId then
		if true == _naviInfoAgain then
			questInfoWindow_naviButton:SetCheck( false )
			button_Navi_QuestInfoWindow:SetCheck( false )
		else
			questInfoWindow_naviButton:SetCheck( true )
			button_Navi_QuestInfoWindow:SetCheck( true )
		end
	else
		questInfoWindow_naviButton:SetCheck( false )
		button_Navi_QuestInfoWindow:SetCheck( false )
	end

	if 0 == condition and 0 == questInfo:getQuestType() then    -- 흑정령 완료퀘 = 네비 버튼을 숨김
		questInfoWindow_naviButton:SetShow( false )
		button_Navi_QuestInfoWindow:SetShow( false )
		button_AutoNavi_QuestInfoWindow:SetShow( false )
		
		-- 네비 버튼을 흑정령 소환으로 바꾸자.
		button_CallSpirit_QuestInfoWindow:SetShow( true )
	end
	local questPosCount = questInfo:getQuestPositionCount()

	if 0 ~= condition and 0 == questPosCount then
		questInfoWindow_naviButton:SetShow( false )
		button_Navi_QuestInfoWindow:SetShow( false )
		button_AutoNavi_QuestInfoWindow:SetShow( false )
	end

	PosY = PosY + questInfoWindow_questTitle:GetSizeY()

	questInfoWindow_questIcon:SetShow( true )
	questInfoWindow_questIcon:SetPosY( PosY + 3 )
	questInfoWindow_questIcon:ChangeTextureInfoName( questInfo:getIconPath() )

	questInfoWindow_questIconBG:SetShow( true )
	questInfoWindow_questIconBG:SetPosY( PosY + 1 )

	questInfoWindow_completeNpc:SetShow( true )
	questInfoWindow_completeNpc:SetPosY( PosY )
	questInfoWindow_completeNpc:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "QUESTLIST_COMPLETETARGET", "getCompleteDisplay", completeNpc ) )
	
	PosY = PosY + questInfoWindow_completeNpc:GetSizeY()

	local demandCount = questInfo:getDemadCount()
	local demandString = '' ;
	for demandIndex = 0, demandCount-1,1 do
		local demand = questInfo:getDemandAt(demandIndex);
		demandString = demandString .. "- " .. demand._desc .. '\n'
	end
	questInfoWindow_questCondition:SetShow( true )
	questInfoWindow_questCondition:SetTextMode( UI_TM.eTextMode_AutoWrap )
	questInfoWindow_questCondition:SetAutoResize( true )
	questInfoWindow_questCondition:SetText ( tostring ( demandString ) )
	questInfoWindow_questCondition:SetPosY( PosY )

	local imgENDPosY		= questInfoWindow_questIcon:GetPosY() + questInfoWindow_questIcon:GetSizeY()
	local conditionENDPosY	= questInfoWindow_questCondition:GetPosY() + questInfoWindow_questCondition:GetSizeY()
	
	if imgENDPosY < conditionENDPosY then
		PosY = conditionENDPosY + 5
	else
		PosY = imgENDPosY + 5
	end

	questInfoWindow_questDesc:SetShow( true )
	questInfoWindow_questDesc:SetTextMode( UI_TM.eTextMode_AutoWrap )
	questInfoWindow_questDesc:SetAutoResize( true )
	questInfoWindow_questDesc:SetText ( tostring ( questInfo:getDesc() ) )
	questInfoWindow_questDesc:SetSize ( questInfoWindow_questDesc:GetSizeX(), questInfoWindow_questDesc:GetSizeY() + 10 )
	questInfoWindow_questDesc:SetPosX( 20 )
	questInfoWindow_questDesc:SetPosY( PosY )
	questInfoWindow_questDesc:ComputePos()
	PosY = PosY + questInfoWindow_questDesc:GetSizeY()

	-- 10레벨이 안되면 퀘스트는 포기할 수 없다!!! 앙!
	if 10 > getSelfPlayer():get():getLevel() then
		button_Giveup_QuestInfoWindow:SetShow(false)
		questInfoWindow_giveupButton:SetShow( false )
		if 0 == condition and 0 == questInfo:getQuestType() then
			button_CallSpirit_QuestInfoWindow:SetPosX( Panel_CheckedQuestInfo:GetSizeX()/2 - button_CallSpirit_QuestInfoWindow:GetSizeX()/2 )
		else
			button_Navi_QuestInfoWindow:SetPosX( Panel_CheckedQuestInfo:GetSizeX()/2 - button_Navi_QuestInfoWindow:GetSizeX() - 5 )
			button_AutoNavi_QuestInfoWindow:SetPosX( Panel_CheckedQuestInfo:GetSizeX()/2 + 5 )
		end
	else
		if 0 == condition and 0 == questInfo:getQuestType() then
			button_Giveup_QuestInfoWindow:SetPosX( Panel_CheckedQuestInfo:GetSizeX()/2 - button_Giveup_QuestInfoWindow:GetSizeX() - 5 )
			button_CallSpirit_QuestInfoWindow:SetPosX( Panel_CheckedQuestInfo:GetSizeX()/2 + 5 )
		else
			button_Giveup_QuestInfoWindow:SetPosX( Panel_CheckedQuestInfo:GetSizeX()/2 - button_Giveup_QuestInfoWindow:GetSizeX() * 1.5 - 5 )
			button_Navi_QuestInfoWindow:SetPosX( Panel_CheckedQuestInfo:GetSizeX()/2 - button_Navi_QuestInfoWindow:GetSizeX()/2 )
			button_AutoNavi_QuestInfoWindow:SetPosX( Panel_CheckedQuestInfo:GetSizeX()/2 + button_AutoNavi_QuestInfoWindow:GetSizeX()/2 + 5 )
		end
	end

	-- 보상을 뿌리자
	local rewardPosY = _QuestDetail_ShowReward( questInfo, PosY )

	Panel_CheckedQuestInfo:SetSize( Panel_CheckedQuestInfo:GetSizeX(), rewardPosY + 40 )

	if ( nil == checkedQuestInfo_PosX ) then
		checkedQuestInfo_PosX = Panel_CheckedQuest:GetPosX() - Panel_CheckedQuestInfo:GetSizeX() - 10
		checkedQuestInfo_PosY = getMousePosY() - Panel_CheckedQuestInfo:GetSizeY()
	end	

	-- FGlobal_QuestInfoDetail_Close()
	if Panel_Window_Quest_New:GetShow() then
		Panel_CheckedQuestInfo:SetPosX( Panel_Window_Quest_New:GetPosX() + Panel_Window_Quest_New:GetSizeX() )
		Panel_CheckedQuestInfo:SetPosY( Panel_Window_Quest_New:GetPosY() + 25 )
	else
		Panel_CheckedQuestInfo:SetPosX( getScreenSizeX() - (getScreenSizeX()/2) - (Panel_CheckedQuestInfo:GetSizeX()/2) )
		Panel_CheckedQuestInfo:SetPosY( getScreenSizeY() - (getScreenSizeY()/2) - (Panel_CheckedQuestInfo:GetSizeY()/2) )
	end
	Panel_CheckedQuestInfo:SetShow( true, true )
	
	-- 아래 버튼을 posY 정렬
	button_Giveup_QuestInfoWindow:SetPosY( Panel_CheckedQuestInfo:GetSizeY() - button_Giveup_QuestInfoWindow:GetSizeY() - 5)
	button_CallSpirit_QuestInfoWindow:SetPosY( Panel_CheckedQuestInfo:GetSizeY() - button_CallSpirit_QuestInfoWindow:GetSizeY() - 5)
	button_Navi_QuestInfoWindow:SetPosY( Panel_CheckedQuestInfo:GetSizeY() - button_Navi_QuestInfoWindow:GetSizeY() - 5)
	button_AutoNavi_QuestInfoWindow:SetPosY( Panel_CheckedQuestInfo:GetSizeY() - button_AutoNavi_QuestInfoWindow:GetSizeY() - 5)

end

-- 흑정령 띄우기용
function HandleClicked_CallSpirit()
	if not IsSelfPlayerWaitAction() then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_SUMMON_BLACKSPIRIT") )
		return
	end
	ToClient_AddBlackSpiritFlush()
	return
end

function FGlobal_QuestInfoDetail_Close()
	Panel_CheckedQuestInfo:SetShow( false, false )
	checkedQuestInfo_PosX = Panel_CheckedQuestInfo:GetPosX()
	checkedQuestInfo_PosY = Panel_CheckedQuestInfo:GetPosY()
	expTooltip:SetShow( false )
	FGlobal_QuestInfoDetail_ResetInfo()
end
function FGlobal_QuestInfoDetail_ResetInfo()
	_questInfoDetailGroupId	= 0
	_questInfoDetailQuestId	= 0
end

function _QuestDetail_ShowReward( questInfo, PosY )
 
	local baseCount		= questInfo:getQuestBaseRewardCount()		
	local selectCount	= questInfo:getQuestSelectRewardCount()

	_baseReward = {}
	for baseReward_index = 1, baseCount, 1 do
		local baseReward = questInfo:getQuestBaseRewardAt( baseReward_index - 1 )
		_baseReward[baseReward_index] = {}
		_baseReward[baseReward_index]._type = baseReward:getType()
		if (CppEnums.RewardType.RewardType_Exp == baseReward:getType()) then
			_baseReward[baseReward_index]._exp = baseReward:getExperience()
		elseif (CppEnums.RewardType.RewardType_SkillExp == baseReward:getType()) then
			_baseReward[baseReward_index]._exp = baseReward:getSkillExperience()
		elseif (CppEnums.RewardType.RewardType_ProductExp == baseReward:getType()) then
			_baseReward[baseReward_index]._exp = baseReward:getProductExperience()
		elseif (CppEnums.RewardType.RewardType_Item	 == baseReward:getType()) then
			_baseReward[baseReward_index]._item = baseReward:getItemEnchantKey()
			_baseReward[baseReward_index]._count = baseReward:getItemCount()
		elseif (CppEnums.RewardType.RewardType_Intimacy	 == baseReward:getType()) then
			_baseReward[baseReward_index]._character = baseReward:getIntimacyCharacter()
			_baseReward[baseReward_index]._value = baseReward:getIntimacyValue()
		end
	end

	_selectReward = {}
	for selectReward_index = 1, selectCount, 1 do
		local selectReward = questInfo:getQuestSelectRewardAt( selectReward_index - 1 )
		_selectReward[selectReward_index] = {}
		_selectReward[selectReward_index]._type = selectReward:getType()
		if (CppEnums.RewardType.RewardType_Exp == selectReward:getType()) then
			_selectReward[selectReward_index]._exp = selectReward:getExperience()
		elseif (CppEnums.RewardType.RewardType_SkillExp == selectReward:getType()) then
			_selectReward[selectReward_index]._exp = selectReward:getSkillExperience()
		elseif (CppEnums.RewardType.RewardType_ProductExp == selectReward:getType()) then
			_selectReward[selectReward_index]._exp = selectReward:getProductExperience()
		elseif (CppEnums.RewardType.RewardType_Item	 == selectReward:getType()) then
			_selectReward[selectReward_index]._item = selectReward:getItemEnchantKey()
			_selectReward[selectReward_index]._count = selectReward:getItemCount()
		elseif (CppEnums.RewardType.RewardType_Intimacy	 == selectReward:getType()) then
			_selectReward[selectReward_index]._character = selectReward:getIntimacyCharacter()
			_selectReward[selectReward_index]._value = selectReward:getIntimacyValue()
		end
	end
	
	reward_TitleBG:SetPosY( PosY + 10 )
	reward_Title:SetPosY( PosY + 10 )
	PosY = PosY + reward_Title:GetSizeY() + 20

	baseRewardBG:SetPosY( PosY )
	lineHeight:SetPosY( PosY )

	baseRewardTitle:SetPosY( PosY + 10 )

	baseSlotBG0:SetPosY( PosY + 7 )
	baseSlotBG1:SetPosY( PosY + 7 )
	baseSlotBG2:SetPosY( PosY + 7 )
	baseSlotBG3:SetPosY( PosY + 7 )
	baseSlotBG4:SetPosY( PosY + 7 )
	baseSlotBG5:SetPosY( PosY + 7 )
	baseSlotBG6:SetPosY( PosY + 50 )
	baseSlotBG7:SetPosY( PosY + 50 )
	baseSlotBG8:SetPosY( PosY + 50 )
	baseSlotBG9:SetPosY( PosY + 50 )
	baseSlotBG10:SetPosY( PosY + 50 )
	baseSlotBG11:SetPosY( PosY + 50 )

	baseSlot0:SetPosY( PosY + 7 )
	baseSlot1:SetPosY( PosY + 7 )
	baseSlot2:SetPosY( PosY + 7 )
	baseSlot3:SetPosY( PosY + 7 )
	baseSlot4:SetPosY( PosY + 7 )
	baseSlot5:SetPosY( PosY + 7 )
	baseSlot6:SetPosY( PosY + 50 )
	baseSlot7:SetPosY( PosY + 50 )
	baseSlot8:SetPosY( PosY + 50 )
	baseSlot9:SetPosY( PosY + 50 )
	baseSlot10:SetPosY( PosY + 50 )
	baseSlot11:SetPosY( PosY + 50 )

	PosY = PosY + baseRewardBG:GetSizeY()

	lineWidth:SetPosY( PosY + 5 )
	PosY = PosY + lineWidth:GetSizeY() + 10

	selectRewardTitle:SetPosY( PosY )

	selectRewardBG:SetPosY( PosY )

	selectSlotBG0:SetPosY( PosY + 4 )
	selectSlotBG1:SetPosY( PosY + 4 )
	selectSlotBG2:SetPosY( PosY + 4 )
	selectSlotBG3:SetPosY( PosY + 4 )
	selectSlotBG4:SetPosY( PosY + 4 )
	selectSlotBG5:SetPosY( PosY + 4 )

	selectSlot0:SetPosY( PosY + 4 )
	selectSlot1:SetPosY( PosY + 4 )
	selectSlot2:SetPosY( PosY + 4 )
	selectSlot3:SetPosY( PosY + 4 )
	selectSlot4:SetPosY( PosY + 4 )
	selectSlot5:SetPosY( PosY + 4 )

	PosY = PosY + selectRewardBG:GetSizeY() + 5

	_questWidget_SetRewardList( _baseReward, _selectReward  )

	return PosY
end

function rewardTooltip_ForQuestWidgetInfo( type, show, questtype, index )
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

local setReward = function( uiSlot, reward, index, questType )
	uiSlot._type = reward._type
	if	UI_RewardType.RewardType_Exp ==	reward._type then						-- 경험치			{type=%#, exp=%#}
		uiSlot.count:SetText( '' )
		uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
		uiSlot.icon:addInputEvent( "Mouse_On", "rewardTooltip_ForQuestWidgetInfo( \"Exp\", true, \"" .. questType .. "\", " .. index .. " )" )
		uiSlot.icon:addInputEvent( "Mouse_Out", "rewardTooltip_ForQuestWidgetInfo( \"Exp\", false, \"" .. questType .. "\", " .. index .. " )" )
	elseif	UI_RewardType.RewardType_SkillExp == reward._type then				-- 스킬 경험치	{type=%#, exp=%#}
		uiSlot.count:SetText( '' )
		uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/SkillExp.dds")
		uiSlot.icon:addInputEvent( "Mouse_On", "rewardTooltip_ForQuestWidgetInfo( \"SkillExp\", true, \"" .. questType .. "\", " .. index .. " )" )
		uiSlot.icon:addInputEvent( "Mouse_Out", "rewardTooltip_ForQuestWidgetInfo( \"SkillExp\", false, \"" .. questType .. "\", " .. index .. " )" )
	elseif	UI_RewardType.RewardType_ProductExp == reward._type then			-- 생산 경험치	{type=%#, exp=%#}
		uiSlot.count:SetText( '' )
		uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
		uiSlot.icon:addInputEvent( "Mouse_On", "rewardTooltip_ForQuestWidgetInfo( \"ProductExp\", true, \"" .. questType .. "\", " .. index .. " )" )
		uiSlot.icon:addInputEvent( "Mouse_Out", "rewardTooltip_ForQuestWidgetInfo( \"ProductExp\", false, \"" .. questType .. "\", " .. index .. " )" )
	elseif	UI_RewardType.RewardType_Item == reward._type then				-- 아이템		{type=%#, item=%#, count=%#}
		local itemStatic = getItemEnchantStaticStatus( ItemEnchantKey(reward._item) );
		uiSlot:setItemByStaticStatus( itemStatic, reward._count );
		uiSlot._item = reward._item
		if "main" == questType then
			uiSlot.icon:addInputEvent( "Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(".. index .. ",\"QuestReward_Base\",true)" )
			uiSlot.icon:addInputEvent( "Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(".. index .. ",\"QuestReward_Base\",false)" )
		else
			uiSlot.icon:addInputEvent( "Mouse_On",  "Panel_Tooltip_Item_Show_GeneralStatic(".. index .. ",\"QuestReward_Select\",true)" )
			uiSlot.icon:addInputEvent( "Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(".. index .. ",\"QuestReward_Select\",false)" )
		end
		return reward._isEquipable
	elseif	UI_RewardType.RewardType_Intimacy == reward._type then				-- 친밀도		{type=%#, character=%#, value=%#}
		uiSlot.count:SetText( tostring(reward._value) )
		uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/00000000_Special_Contributiveness.dds")
		uiSlot.icon:addInputEvent( "Mouse_On", "rewardTooltip_ForQuestWidgetInfo( \"Intimacy\", true, \"" .. questType .. "\", " .. index .. " )" )
		uiSlot.icon:addInputEvent( "Mouse_Out", "rewardTooltip_ForQuestWidgetInfo( \"Intimacy\", false, \"" .. questType .. "\", " .. index .. " )" )
	else
		uiSlot.icon:addInputEvent( "Mouse_On", "" )
		uiSlot.icon:addInputEvent( "Mouse_Out", "" )
	end
	return false;
end


function	_questWidget_SetRewardList( baseReward, selectReward )
	_baseRewardCount	= #baseReward
	_selectRewardCount	= #selectReward

	for index = 0, _maxBaseSlotCount-1, 1 do
		if index < _baseRewardCount then
			setReward( _listBaseRewardSlots[index], baseReward[index + 1], index, "main" )
			_uiBackBaseReward[index]:SetShow(true)
		else
			_uiBackBaseReward[index]:SetShow(false)
		end
	end

	------------------------------------
	-- 	기본적으로 체크를 풀어준다!
	for index = 0, _maxSelectSlotCount-1, 1 do
		if index < _selectRewardCount then
			local isEquipable = setReward(	_listSelectRewardSlots[index], selectReward[index + 1], index, "sub" )
			if isEquipable then
				_equipRewardCount = _equipRewardCount + 1
				_equipEnableSlot = index
			end
			_uiButtonSelectRewardSlots[index]:SetShow(true)
		else
			_uiButtonSelectRewardSlots[index]:SetShow(false)
		end
	end
end

-- 포지션 유지용 변수
local checkedQuestInfo_PosX = nil
local checkedQuestInfo_PosY = nil
