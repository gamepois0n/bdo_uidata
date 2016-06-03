

-------------------------- Local 변수 설정 --------------------
local 	UI_RewardType					= CppEnums.RewardType
local 	UI_TM 							= CppEnums.TextMode
local	UI_color						= Defines.Color
local _questrewardSlotConfig =
{	-- 일단 아이콘, 테두리, 카운트(숫자) 만 적용한다!
	createIcon			= true,
	createBorder		= true,
	createCount			= true,
	createClassEquipBG	= true,
	createCash			= true
}

local 	_baseRewardCount				= 0
local	_maxBaseSlotCount				= 12
local	_uiBackBaseReward				= {}
local	_listBaseRewardSlots			= {}

local 	_selectRewardCount				= 0
local	_maxSelectSlotCount				= 6
local	_uiButtonSelectRewardSlots		= {}
local	_listSelectRewardSlots			= {}
local 	_isSelectReward					= false
local	_selectRewardItemNameArry		= {}
local	_selectRewardItemName			= nil
local	_equipRewardItemCount			= 0

local 	questDescPosY 					= 0
local 	questDescSizeY 					= 0
local 	questDescgap 					= 0

---------------------------------------------------------------

-------------------------- Control 생성 및 획득 -----------------------

local	_uiCheckButton				= UI.getChildControl( Panel_Npc_Quest_Reward,	"CheckButton_0")
local	_uiQuestTitle				= UI.getChildControl( Panel_Npc_Quest_Reward,	"StaticText_Quest_Title")
local	_uiQuestNpc					= UI.getChildControl( Panel_Npc_Quest_Reward,	"StaticText_ClearNpc")
local	_uiQuestDesc				= UI.getChildControl( Panel_Npc_Quest_Reward,	"StaticText_Quest_Desc")
local	reward_CloseButton			= UI.getChildControl( Panel_Npc_Quest_Reward, 	"Button_Win_Close" )		-- 퀘스트 리워드 닫기

local	defaultRewardText			= UI.getChildControl( Panel_Npc_Quest_Reward, "Static_Menu_Reward")
local	selectRewardText			= UI.getChildControl( Panel_Npc_Quest_Reward, "Static_Menu_Reward_Select")

local	expTooltipBase 				= UI.getChildControl ( Panel_CheckedQuest, "StaticText_Notice_2")
local	expTooltip					= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Npc_Quest_Reward, "expTooltip" )
CopyBaseProperty( expTooltipBase, expTooltip )
expTooltip:SetColor( ffffffff )
expTooltip:SetAlpha( 1.0 )
expTooltip:SetFontColor( UI_color.C_FFFFFFFF )
expTooltip:SetAutoResize( true )
expTooltip:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
expTooltip:SetTextHorizonCenter()
expTooltip:SetShow( false )

local	checkButtonOnTexture		= _uiCheckButton:getOnTexture()
local	checkButtonClickTexture		= _uiCheckButton:getClickTexture()

reward_CloseButton:addInputEvent( "Mouse_LUp", "FGlobal_ShowRewardList(false, " .. 0 .. ")" )		-- 퀘스트 리워드 닫기

-- 기본 보상
for index = 0, _maxBaseSlotCount-1, 1 do
	local backBaseReward = UI.getChildControl( Panel_Npc_Quest_Reward, "Static_Slot_"..index )
	backBaseReward:SetIgnore(true)

	_uiBackBaseReward[index] = backBaseReward

	local slot = {}
	SlotItem.new( slot, 'BaseReward_' .. index, index, backBaseReward, _questrewardSlotConfig )
	slot:createChild()
	slot.icon:SetPosX(-2)
	slot.icon:SetPosY(-2)
	-- slot.icon:addInputEvent( "Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(".. index .. ",\"Dialog_QuestReward_Base\",true)" )
	-- slot.icon:addInputEvent( "Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(".. index .. ",\"Dialog_QuestReward_Base\",false)" )

	_listBaseRewardSlots[index] = slot

	Panel_Tooltip_Item_SetPosition( index, slot, "Dialog_QuestReward_Base" )
end

-- 선택 보상
for index = 0, _maxSelectSlotCount-1, 1 do
	local buttonSelectRewardSlot = UI.getChildControl( Panel_Npc_Quest_Reward, "CheckButton_"..index )
	buttonSelectRewardSlot:addInputEvent( "Mouse_LUp", "HandleClickedSelectedReward("..index..")" )
	-- buttonSelectRewardSlot:addInputEvent( "Mouse_On",  "HandleOnSelectedReward(".. index .. ")" )
	-- buttonSelectRewardSlot:addInputEvent( "Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(".. index .. ",\"Dialog_QuestReward_Select\",false)" )

	_uiButtonSelectRewardSlots[index] = buttonSelectRewardSlot

	local slot = {}
	SlotItem.new( slot, 'SelectReward_' .. index, index, buttonSelectRewardSlot, _questrewardSlotConfig )
	slot:createChild()
	slot.icon:SetPosX(3)
	slot.icon:SetPosY(3)
	slot.icon:SetIgnore(true)

	_listSelectRewardSlots[index] = slot

	Panel_Tooltip_Item_SetPosition( index, slot, "Dialog_QuestReward_Select" )
end
---------------------------------------------------------------------
function QuestReward_Init()
	defaultRewardText	:SetTextMode(UI_TM.eTextMode_AutoWrap)
	defaultRewardText	:SetText( PAGetString(Defines.StringSheet_RESOURCE, "DIALOGUE_REWARD_TXT_REWARD") )
	defaultRewardText	:SetAutoResize(true)
	selectRewardText	:SetTextMode(UI_TM.eTextMode_AutoWrap)
	selectRewardText	:SetText( PAGetString(Defines.StringSheet_RESOURCE, "DIALOGUE_REWARD_TXT_SREWARD") )
	selectRewardText	:SetAutoResize(true)
end
-------------------------- 보상창 --------------------
-- 보상 선택
function HandleClickedSelectedReward(selectIndex)
	for index=0 , 5, 1 do
		_uiButtonSelectRewardSlots[index]:SetCheck(false)
		_uiButtonSelectRewardSlots[index]:EraseAllEffect()
	end
	_uiButtonSelectRewardSlots[selectIndex]:AddEffect( "UI_Quest_Compensate_Loop", true, 0, 0 )
	_uiButtonSelectRewardSlots[selectIndex]:SetCheck(true)
	_uiButtonSelectRewardSlots[selectIndex]:setRenderTexture(checkButtonClickTexture)
	_isSelectReward = true
	ReqeustDialog_selectReward(selectIndex)
	if _equipRewardItemCount ~= 0 then
		_selectRewardItemName = _selectRewardItemNameArry[selectIndex]
	else
		_selectRewardItemName = nil
	end
end

function FGlobal_SelectedRewardConfirm()
	if _selectRewardItemName ~= nil then
		return _selectRewardItemName
	else
		return false
	end
end

function FGlobal_SelectRewardItemNameClear()
	_selectRewardItemName = nil;
end

-- 보상 확인
function HandleOnSelectedReward(index)
	Panel_Tooltip_Item_Show_GeneralStatic(index,"Dialog_QuestReward_Select",true)
	_uiButtonSelectRewardSlots[index]:setRenderTexture(checkButtonOnTexture)
end

-- 보상 아이콘 설정 
local setReward = function( uiSlot, reward, index, questType )
	uiSlot._type = reward._type
	if	UI_RewardType.RewardType_Exp ==	reward._type then						-- 경험치			{type=%#, exp=%#}
		uiSlot.count:SetText( '' )
		uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
		uiSlot.icon:addInputEvent( "Mouse_On", "rewardTooltip( \"Exp\", true, \"" .. questType .. "\", " .. index .. " )" )
		uiSlot.icon:addInputEvent( "Mouse_Out", "rewardTooltip( \"Exp\", false, \"" .. questType .. "\", " .. index .. " )" )
	elseif	UI_RewardType.RewardType_SkillExp == reward._type then				-- 스킬 경험치	{type=%#, exp=%#}
		uiSlot.count:SetText( '' )
		uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/SkillExp.dds")
		uiSlot.icon:addInputEvent( "Mouse_On", "rewardTooltip( \"SkillExp\", true, \"" .. questType .. "\", " .. index .. " )" )
		uiSlot.icon:addInputEvent( "Mouse_Out", "rewardTooltip( \"SkillExp\", false, \"" .. questType .. "\", " .. index .. " )" )
	elseif	UI_RewardType.RewardType_ProductExp == reward._type then			-- 생산 경험치	{type=%#, exp=%#}
		uiSlot.count:SetText( '' )
		uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
		uiSlot.icon:addInputEvent( "Mouse_On", "rewardTooltip( \"ProductExp\", true, \"" .. questType .. "\", " .. index .. " )" )
		uiSlot.icon:addInputEvent( "Mouse_Out", "rewardTooltip( \"ProductExp\", false, \"" .. questType .. "\", " .. index .. " )" )
	elseif	UI_RewardType.RewardType_Item == reward._type then				-- 아이템		{type=%#, item=%#, count=%#}
		local itemStatic = getItemEnchantStaticStatus( ItemEnchantKey(reward._item) );
		uiSlot:setItemByStaticStatus( itemStatic, reward._count );
		uiSlot._item = reward._item
		if "main" == questType then
			uiSlot.icon:addInputEvent( "Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(".. index .. ",\"Dialog_QuestReward_Base\",true)" )
			uiSlot.icon:addInputEvent( "Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(".. index .. ",\"Dialog_QuestReward_Base\",false)" )
		else
			uiSlot.icon:addInputEvent( "Mouse_On", "" )
			uiSlot.icon:addInputEvent( "Mouse_Out", "" )
			_uiButtonSelectRewardSlots[index]:addInputEvent( "Mouse_On",  "HandleOnSelectedReward(".. index .. ")" )
			_uiButtonSelectRewardSlots[index]:addInputEvent( "Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(".. index .. ",\"Dialog_QuestReward_Select\",false)" )
		end
		return reward._isEquipable
	elseif	UI_RewardType.RewardType_Intimacy == reward._type then				-- 친밀도		{type=%#, character=%#, value=%#}
		uiSlot.count:SetText( tostring(reward._value) )
		uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/00000000_Special_Contributiveness.dds")
		uiSlot.icon:addInputEvent( "Mouse_On", "rewardTooltip( \"Intimacy\", true, \"" .. questType .. "\", " .. index .. " )" )
		uiSlot.icon:addInputEvent( "Mouse_Out", "rewardTooltip( \"Intimacy\", false, \"" .. questType .. "\", " .. index .. " )" )
	else
		uiSlot.icon:addInputEvent( "Mouse_On", "" )
		uiSlot.icon:addInputEvent( "Mouse_Out", "" )
	end
	return false;
end

function rewardTooltip( type, show, questtype, index )
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

-- 보상 설정
function	FGlobal_SetRewardList( baseReward, selectReward, questData )
	_baseRewardCount	= #baseReward
	_selectRewardCount	= #selectReward
	FGlobal_SelectRewardItemNameClear()
	
	for index = 0, _maxBaseSlotCount-1, 1 do
		_uiBackBaseReward[index]:EraseAllEffect()
		if index < _baseRewardCount then
			setReward( _listBaseRewardSlots[index], baseReward[index + 1], index, "main" )
			_uiBackBaseReward[index]:SetShow(true)
		else
			_uiBackBaseReward[index]:SetShow(false)
		end
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
			local isEquipable = setReward(	_listSelectRewardSlots[index], selectReward[index + 1], index, "sub" )
			
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
		if index < _selectRewardCount then
			if true then
				local itemStatic = getItemEnchantStaticStatus( ItemEnchantKey(selectReward[index+1]._item) )
				_selectRewardItemNameArry[index] = itemStatic:getName()
			else
				_selectRewardItemNameArry[index] = nil
			end
		end
	end
	_equipRewardItemCount = _equipRewardCount	-- 선택보상의 장착가능템 갯수 local변수에 담기

	------------------------------------
	-- 	장비 가능한 보상이 1개인 경우 체크해준다
	if _equipRewardCount == 1 then
		if nil ~= _equipEnableSlot then
			
			-- 직업 전용 장비인지 체크. default는 워리어, 워리어인 경우 레인저로 체크
			local classType = getSelfPlayer():getClassType()

			if 0 == classType or 24 == classType then
				classType = 4
			else
				classType = 0
			end
			
			local itemStatic = getItemEnchantStaticStatus( ItemEnchantKey(selectReward[_equipEnableSlot+1]._item) )
			if false == itemStatic:get()._usableClassType:isOn( classType ) then
				HandleClickedSelectedReward(_equipEnableSlot)
			end
		end
	end
	------------------------------------
	-- 			퀘스트 표시
	if	(nil ~= questData)	then
		_uiQuestTitle:SetText( questData:getTitle() )
		_uiQuestTitle:ChangeTextureInfoName( questData:getIconPath() )
		_uiQuestNpc:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "QUESTLIST_COMPLETETARGET", "getCompleteDisplay", questData:getCompleteDisplay() ) ) --"완료 대상 : "..questData:getCompleteDisplay()
		_uiQuestDesc:SetAutoResize( true )
		_uiQuestDesc:SetTextMode( UI_TM.eTextMode_AutoWrap )
		_uiQuestDesc:SetText( questData:getDesc() )
		
		_uiQuestDesc:SetPosY(-49)											-- 포지션 초기화
		_uiQuestNpc:SetPosY(-94)											--
		_uiQuestTitle:SetPosY(-74)											--
		
		questDescSizeY = _uiQuestDesc:GetSizeY()
		questDescPosY = _uiQuestDesc:GetPosY()
		questDescgap = questDescSizeY + questDescPosY + 5

		if 0 < questDescSizeY + questDescPosY then							-- 퀘스트 설명이 3줄 이상이면 실행
			_uiQuestDesc:SetPosY( (-49) - questDescgap)
			_uiQuestNpc:SetPosY( (-94) - questDescgap)
			_uiQuestTitle:SetPosY( (-74) - questDescgap)
		end

		_uiQuestTitle:ComputePos()
		_uiQuestNpc:ComputePos()
		_uiQuestDesc:ComputePos()
		_uiQuestTitle:SetShow(true)
		_uiQuestNpc:SetShow(true)
		_uiQuestDesc:SetShow(true)
	else
		_uiQuestTitle:SetShow(false)
		_uiQuestNpc:SetShow(false)
		_uiQuestDesc:SetShow(false)
	end
end


-- 보상 아이템 노출
function FGlobal_ShowRewardList( isVisible, isManualClick )
	if isVisible then
		if (0 < _baseRewardCount) or (0 < _selectRewardCount) then
			-- 사운드 추가 필요
			Panel_Npc_Quest_Reward:SetShow(true)
		else
			Panel_Npc_Quest_Reward:SetShow(false)
		end
	else
		if isFlushedUI() and getSelfPlayer():get():getLevel() < 11 and ( nil ~= isManualClick and 0 == isManualClick ) then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_REWARD_SHOWREWARDLIST") ) -- "10 레벨 이하는 대화창에서 보상창을 임의로 닫을 수 없습니다." )
			return
		end
		Panel_Npc_Quest_Reward:SetShow(false)
	end

end

local _buttonQuestion = UI.getChildControl ( Panel_Npc_Quest_Reward, "Button_Question" )						-- 물음표 버튼
_buttonQuestion:addInputEvent( "Mouse_LUp",  "Panel_WebHelper_ShowToggle( \"PanelQuestReward\" )" )				-- 물음표 좌클릭
_buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"PanelQuestReward\", \"true\")" )		-- 물음표 마우스오버
_buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"PanelQuestReward\", \"false\")" )		-- 물음표 마우스아웃
QuestReward_Init()