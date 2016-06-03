local UI_TM 		= CppEnums.TextMode
local UI_classType 	= CppEnums.ClassType
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color		= Defines.Color
local IM			= CppEnums.EProcessorInputMode
local UIMode 		= Defines.UIMode


Panel_SkillCommand:setMaskingChild(true)
Panel_SkillCommand:ActiveMouseEventEffect(true)
Panel_SkillCommand:setGlassBackground(true)

Panel_SkillCommand:RegisterShowEventFunc( true, 'Panel_SkkillCommand_ShowAni()' )
Panel_SkillCommand:RegisterShowEventFunc( false, 'Panel_SkkillCommand_HideAni()' )

local _close_SkillCmd = UI.getChildControl ( Panel_SkillCommand, "Button_Win_Close" )
_close_SkillCmd:SetShow(false)


function Panel_SkkillCommand_ShowAni()
end
function Panel_SkkillCommand_HideAni()
end

-- 0 = 좌클릭
-- 1 = 우클릭
-- 2 = W
-- 3 = A
-- 4 = S
-- 5 = D
-- 6 = Q
-- 7 = E
-- 8 = R
-- 9 = F
-- 10 = Z
-- 11 = X
-- 12 = C
-- 13 = V
-- 14 = SHIFT
-- 15 = SPACE
-- 16 = TAB
-- 17 = T

local descriptionList = {
	[0] = PAGetString( Defines.StringSheet_GAME, "PANEL_SKILL_COMMAND_BATTLE_CHANGE" ), 	-- "전투 전환"
	[1] = PAGetString( Defines.StringSheet_GAME, "PANEL_SKILL_COMMAND_NON_BATTLE" ), 		-- "비전투 전환"
	[2] = PAGetString( Defines.StringSheet_GAME, "PANEL_SKILL_COMMAND_FORWARD_MOVE" ),	 	-- "전방 이동"
	[3] = PAGetString( Defines.StringSheet_GAME, "PANEL_SKILL_COMMAND_AUTO_RUN" ), 			-- "자동 달리기"
	[4] = PAGetString( Defines.StringSheet_GAME, "PANEL_SKILL_COMMAND_ALL_RUN" ), 			-- "전력 질주"
	[5] = PAGetString( Defines.StringSheet_GAME, "PANEL_SKILL_COMMAND_JUMP" ), 				-- "점프"
	[6] = PAGetString( Defines.StringSheet_GAME, "PANEL_SKILL_COMMAND_SITDOWN" ), 			-- "앉기"
	[7] = PAGetString( Defines.StringSheet_GAME, "PANEL_SKILL_COMMAND_STANDUP" ), 			-- "일어서기"
	[8] = PAGetString( Defines.StringSheet_GAME, "PANEL_SKILL_COMMAND_DROP" ), 				-- "내리기"
	[9] = PAGetString( Defines.StringSheet_GAME, "PANEL_SKILL_COMMAND_LIFTING" ), 			-- "앞발들기"
	[10] = PAGetString( Defines.StringSheet_GAME, "PANEL_SKILL_COMMAND_STOP" ), 			-- "정지"
	[11] = PAGetString( Defines.StringSheet_GAME, "PANEL_SKILL_COMMAND_DIVE" ), 			-- "뛰어 내리기"
	[12] = PAGetString( Defines.StringSheet_GAME, "PANEL_SKILL_COMMAND_CRAWL" ), 			-- "포복 자세"
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local UIgr ={
[0] = {
		_skillBG 			= UI.getChildControl ( Panel_SkillCommand, "Static_CommandBG_0" ),
		_skillBG_Disabled 	= UI.getChildControl ( Panel_SkillCommand, "Static_Disable_BG_0" ),
		_skillIcon 			= UI.getChildControl ( Panel_SkillCommand, "Static_SkillIcon_0" ),
		_skillName 			= UI.getChildControl ( Panel_SkillCommand, "StaticText_SkillName_0" ),

		Key_0				= UI.getChildControl ( Panel_SkillCommand, "StaticText_Key_Square_0_0" ),
		Key_1				= UI.getChildControl ( Panel_SkillCommand, "StaticText_Key_Square_0_1" ),
		Key_2				= UI.getChildControl ( Panel_SkillCommand, "StaticText_Key_Square_0_2" ),
		Key_3				= UI.getChildControl ( Panel_SkillCommand, "StaticText_Key_Square_0_3" ),

		_key_MouseL 		= UI.getChildControl ( Panel_SkillCommand, "Static_Key_MouseL_0" ),
		_key_MouseR 		= UI.getChildControl ( Panel_SkillCommand, "Static_Key_MouseR_0" ),
		},
		
[1] = {	
		_skillBG 			= UI.getChildControl ( Panel_SkillCommand, "Static_CommandBG_1" ),
		_skillBG_Disabled 	= UI.getChildControl ( Panel_SkillCommand, "Static_Disable_BG_1" ),
		_skillIcon 			= UI.getChildControl ( Panel_SkillCommand, "Static_SkillIcon_1" ),
		_skillName 			= UI.getChildControl ( Panel_SkillCommand, "StaticText_SkillName_1" ),

		Key_0				= UI.getChildControl ( Panel_SkillCommand, "StaticText_Key_Square_1_0" ),
		Key_1				= UI.getChildControl ( Panel_SkillCommand, "StaticText_Key_Square_1_1" ),
		Key_2				= UI.getChildControl ( Panel_SkillCommand, "StaticText_Key_Square_1_2" ),
		Key_3				= UI.getChildControl ( Panel_SkillCommand, "StaticText_Key_Square_1_3" ),
	
		_key_MouseL 		= UI.getChildControl ( Panel_SkillCommand, "Static_Key_MouseL_1" ),
		_key_MouseR 		= UI.getChildControl ( Panel_SkillCommand, "Static_Key_MouseR_1" ),
		},
		
[2] = {	
		_skillBG 			= UI.getChildControl ( Panel_SkillCommand, "Static_CommandBG_2" ),
		_skillBG_Disabled	= UI.getChildControl ( Panel_SkillCommand, "Static_Disable_BG_2" ),
		_skillIcon 			= UI.getChildControl ( Panel_SkillCommand, "Static_SkillIcon_2" ),
		_skillName 			= UI.getChildControl ( Panel_SkillCommand, "StaticText_SkillName_2" ),

		Key_0				= UI.getChildControl ( Panel_SkillCommand, "StaticText_Key_Square_2_0" ),
		Key_1				= UI.getChildControl ( Panel_SkillCommand, "StaticText_Key_Square_2_1" ),
		Key_2				= UI.getChildControl ( Panel_SkillCommand, "StaticText_Key_Square_2_2" ),
		Key_3				= UI.getChildControl ( Panel_SkillCommand, "StaticText_Key_Square_2_3" ),

		_key_MouseL 		= UI.getChildControl ( Panel_SkillCommand, "Static_Key_MouseL_2" ),
		_key_MouseR 		= UI.getChildControl ( Panel_SkillCommand, "Static_Key_MouseR_2" ),
		},
		
[3] = {	
		_skillBG 			= UI.getChildControl ( Panel_SkillCommand, "Static_CommandBG_3" ),
		_skillBG_Disabled	= UI.getChildControl ( Panel_SkillCommand, "Static_Disable_BG_3" ),
		_skillIcon 			= UI.getChildControl ( Panel_SkillCommand, "Static_SkillIcon_3" ),
		_skillName 			= UI.getChildControl ( Panel_SkillCommand, "StaticText_SkillName_3" ),

		Key_0				= UI.getChildControl ( Panel_SkillCommand, "StaticText_Key_Square_3_0" ),
		Key_1				= UI.getChildControl ( Panel_SkillCommand, "StaticText_Key_Square_3_1" ),
		Key_2				= UI.getChildControl ( Panel_SkillCommand, "StaticText_Key_Square_3_2" ),
		Key_3				= UI.getChildControl ( Panel_SkillCommand, "StaticText_Key_Square_3_3" ),

		_key_MouseL 		= UI.getChildControl ( Panel_SkillCommand, "Static_Key_MouseL_3" ),
		_key_MouseR 		= UI.getChildControl ( Panel_SkillCommand, "Static_Key_MouseR_3" ),
		},
	
	
}

local UI_else =
{
	_system_Ctrl 		= UI.getChildControl ( Panel_SkillCommand, "StaticText_Ctrl" ),
	_system_CtrlTxt		= UI.getChildControl ( Panel_SkillCommand, "StaticText_CtrlText" ),
	_system_Esc 		= UI.getChildControl ( Panel_SkillCommand, "StaticText_Esc" ),
	_system_EscTxt 		= UI.getChildControl ( Panel_SkillCommand, "StaticText_EscText" ),
	
	_system_M	 		= UI.getChildControl ( Panel_SkillCommand, "StaticText_M" ),
	_system_MTxt 		= UI.getChildControl ( Panel_SkillCommand, "StaticText_MText" ),
	
	_system_Obsidian	= UI.getChildControl ( Panel_SkillCommand, "StaticText_Obsidian" ),
	_system_ObsidianTxt	= UI.getChildControl ( Panel_SkillCommand, "StaticText_ObsidianText" ),

	_system_Inter		= UI.getChildControl ( Panel_SkillCommand, "StaticText_Inter" ),				-- 인터렉션 버튼
	_system_Inter_T		= UI.getChildControl ( Panel_SkillCommand, "StaticText_Inter_T" ),				-- 인터렉션 R 텍스트
}

local skillCommand_totalPosY = 0
local skillCommand_posYGab = 5

local skillDataGroup = {}
-- index : index Number  0 to 2
-- .skillNo:
-- .key_0:
-- .key_1:
-- .key_2:
-- .key_3:
-- .uniqueKey : 
-- .descIndex : 
-- .isHighLight : 하이라이트 되어있는지 boolean

local prevSkillDataGroup = {}
-- skillDataGroup 과 동일
local animationEndTime = 0.45	-- 종료시간
local elapsedTime = 0			-- 종료까지 흐른시간
local isProcessing = true		-- false : 종료처리해야함, true : 종료처리 됨.
local commandChanged = true		-- true : 커멘드가 바뀜 , false : 안바뀜

local _ui_staticText = CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT



local GetBottomPos = function(control)
	if ( nil == control ) then
		UI.ASSERT(false, "GetBottomPos(control) , control nil")
		return
	end
	return control:GetPosY() + control:GetSizeY()
end

function SkillCmd_ChangeTexture_On()
	Panel_SkillCommand:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_drag.dds")
	_close_SkillCmd:SetShow( true )
end
function SkillCmd_ChangeTexture_Off()
	_close_SkillCmd:SetShow( false )
	if Panel_UIControl:IsShow() then
		Panel_SkillCommand:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_isWidget.dds")
	else
		Panel_SkillCommand:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_empty.dds")
	end
end

local init = function()
	for groupKey, uiOneGroup in pairs(UIgr) do
		for index = 0, 3 do
			local keyString = "Key_" .. index

			uiOneGroup[keyString]:SetPosY(uiOneGroup._skillBG:GetPosY())
			uiOneGroup[keyString]:SetShow(false)
			uiOneGroup[keyString]:SetIgnore(false)
		end
		uiOneGroup._key_MouseL:SetPosY(uiOneGroup._skillBG:GetPosY())
		uiOneGroup._key_MouseR:SetPosY(uiOneGroup._skillBG:GetPosY())
	end
	Panel_SkillCommand:addInputEvent( "Mouse_On", "SkillCmd_ChangeTexture_On()" )
	Panel_SkillCommand:addInputEvent( "Mouse_Out", "SkillCmd_ChangeTexture_Off()" )

end

init()

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local setAlphaAll = function( alpha )
	for _,value in pairs(UIgr) do
		for k,v in pairs(value) do
			if ( k == "_skillName" ) then
				v:SetFontAlpha(alpha)
			elseif ( k == "Key_0" ) or ( k == "Key_1" ) or ( k == "Key_2" ) or ( k == "Key_3" ) then
				v:SetFontAlpha(alpha)
				v:SetAlpha(alpha)
			else
				v:SetAlpha(alpha)
			end
		end
	end
	
	for _,value in pairs(UI_else) do
		if ( _ == "_system_Ctrl" ) or ( _ == "_system_CtrlTxt" ) or ( _ == "_system_Esc" ) or ( _ == "_system_EscTxt" ) or ( _ == "_system_M" ) or ( _ == "_system_MTxt" ) or ( _ == "_system_Obsidian" ) or ( _ == "_system_ObsidianTxt" ) or ( _ == "_system_Inter" ) or ( _ == "_system_Inter_T" ) then
			value:SetAlpha(alpha)
			value:SetFontAlpha(alpha)
		else
			value:SetAlpha(alpha)
		end
	end
	Panel_SkillCommand:SetAlpha(alpha)
end

function ScreenReisze_RePosCommand()
	local scrX = getScreenSizeX()
	local scrY = getScreenSizeY()

	Panel_SkillCommand:SetPosX( scrX / 2 + 200 )
	Panel_SkillCommand:SetPosY ( scrY / 2 * 0.95 )
	
	changePositionBySever(Panel_SkillCommand, CppEnums.PAGameUIType.PAGameUIPanel_SkillCommand, true, true, false)
end

local isChanged = function ( index )
	if ( nil ~= skillDataGroup[index] ) and ( nil ~= prevSkillDataGroup[index] ) then
		if ( skillDataGroup[index].skillNo == prevSkillDataGroup[index].skillNo ) and
			( skillDataGroup[index].Key_0 == prevSkillDataGroup[index].Key_0 ) and
			( skillDataGroup[index].Key_1 == prevSkillDataGroup[index].Key_1 ) and
			( skillDataGroup[index].Key_2 == prevSkillDataGroup[index].Key_2 ) and
			( skillDataGroup[index].uniqueKey == prevSkillDataGroup[index].uniqueKey ) and
			( skillDataGroup[index].descIndex == prevSkillDataGroup[index].descIndex ) and
			( skillDataGroup[index].isVehicle == prevSkillDataGroup[index].isVehicle ) and
			( skillDataGroup[index].branchId == prevSkillDataGroup[index].branchId ) then
			return false
		end
		return true
	else
		return true
	end
end

local insertCommand = function( _skillNo, _Key_0, _Key_1, _Key_2, _Key_3, uniqueKey, descIndex, isVehicle, branchId )
	--dataGroup insert 한다.
	for index = 0 , 3 do
		if ( skillDataGroup[index] == nil ) then
			skillDataGroup[index] = { 
				skillNo = _skillNo, 
				Key_0 = _Key_0, 
				Key_1 = _Key_1, 
				Key_2 = _Key_2, 
				uniqueKey = uniqueKey,
				descIndex = descIndex, 
				isHighLight = false,
				isVehicle = isVehicle,
				branchId = branchId,
			}
			commandChanged = commandChanged or isChanged(index)
			return
		end
	end
end

local isCommandEmpty = function()
	-- dataGroup이 비어있으면 true
	for k, v in pairs(skillDataGroup) do
		if ( v ~= nil ) then
			return false
		end
	end
	return true
end

local setColorWithoutAlpha = function ( ui, colorKey )
	local buffer = ui:GetAlpha()
	ui:SetColor(colorKey)
	ui:SetAlpha(buffer)
	return ui
end

------------------------------------------------------
--				스킬 아이콘을 눌렀다!!
------------------------------------------------------
function commandClick_UseSkillEvent( branchId )
	-- ♬ 커맨드를 마우스로 눌렀을 때 효과음 추가
	audioPostEvent_SystemUi(8,2)
	commandGuide_StartAction( branchId )
end

local updateCommandOne = function( skillData, ui, index )
	-- nil이면 안됨 콜하기전에 체크하고 콜할것
	------------------------------------------------------
	--					아이콘과 이름
	------------------------------------------------------
	local descriptionString = descriptionList[skillData.descIndex]

	--ui.Key_0:addInputEvent( "Mouse_LUp", "commandClick_UseSkillEvent("..skillData.branchId..")" )
	--ui.Key_1:addInputEvent( "Mouse_LUp", "commandClick_UseSkillEvent("..skillData.branchId..")" )
	--ui.Key_2:addInputEvent( "Mouse_LUp", "commandClick_UseSkillEvent("..skillData.branchId..")" )
	--ui.Key_3:addInputEvent( "Mouse_LUp", "commandClick_UseSkillEvent("..skillData.branchId..")" )
	--ui._key_MouseL:addInputEvent( "Mouse_LUp", "commandClick_UseSkillEvent("..skillData.branchId..")" )
	--ui._key_MouseR:addInputEvent( "Mouse_LUp", "commandClick_UseSkillEvent("..skillData.branchId..")" )
	ui._skillBG:addInputEvent( "Mouse_LUp", "commandClick_UseSkillEvent("..skillData.branchId..")" )

	ui._skillIcon:SetShow(false)
	ui._skillName:SetShow(false)

	------------------------------------------------------
	--					버튼들 처리
	------------------------------------------------------
	local uiInterval = 3
	local sumInterval = 20
	local mouseOn = false
	for keyIndex = 0 , 3 do
		local stringIndex = "Key_" .. keyIndex
		local keyData	= skillData[stringIndex]
		local keyUI		= ui[stringIndex]
		
		if ( nil ~= keyData ) and ( keyData < 18 ) then
			if ( 0 == keyData ) or ( 1 == keyData ) then
				keyUI:SetShow(false)
				ui._key_MouseL:SetShow(true)
				ui._key_MouseR:SetShow(true)

				if ( 0 == keyData ) then
					keyUI = ui._key_MouseL
				else
					keyUI = ui._key_MouseR
				end

				if ( false == mouseOn ) then
					ui._key_MouseL:SetPosX( sumInterval )
					sumInterval = sumInterval + ui._key_MouseL:GetSizeX()
					ui._key_MouseR:SetPosX( sumInterval )

					if ( 0 == keyData ) then
						setColorWithoutAlpha( ui._key_MouseR, UI_color.C_FF444444 )
					else
						setColorWithoutAlpha( ui._key_MouseL, UI_color.C_FF444444 )
					end
					sumInterval = sumInterval + ui._key_MouseR:GetSizeX() + uiInterval
				end

				setColorWithoutAlpha( keyUI, UI_color.C_FFFFFFFF )

				mouseOn = true
			else
				if getGamePadEnable() then
					keyUI:SetText( keyCustom_GetString_CustomizedPad(keyData) )
				else
					if 8 == keyData then
						keyUI:SetFontColor( UI_color.C_FFF601FF )
					else
						keyUI:SetFontColor( UI_color.C_FF00C0D7 )
					end
					keyUI:SetText( keyCustom_GetString_CustomizedKey(keyData) )
				end
				
				keyUI:SetSize( keyUI:GetTextSizeX() + 20, keyUI:GetSizeY() )
				keyUI:SetPosX( sumInterval )
				keyUI:SetShow(true)
				sumInterval = sumInterval + keyUI:GetSizeX() + uiInterval
			end
		else
			keyUI:SetShow(false)
		end
	end

	local playerLevel = getSelfPlayer():get():getLevel()
	if ( nil ~= descriptionString ) then
		-- if ( 1 <= playerLevel ) and ( playerLevel < 21 ) then
			ui._skillIcon:SetShow(false)
			ui._skillName:SetShow(true)
			ui._skillName:SetText( descriptionString )
			ui._skillName:SetSize( ui._skillName:GetTextSizeX(), ui._skillName:GetSizeY() )
			ui._skillName:SetPosX( sumInterval )
		-- else
			-- ui._skillIcon:SetShow(false)
			-- ui._skillName:SetShow(false)
			-- ui._skillBG:SetShow(false)
			-- ui.Key_0:SetShow(false)
			-- ui.Key_1:SetShow(false)
			-- ui.Key_2:SetShow(false)
			-- ui.Key_3:SetShow(false)
		-- end
	else
		ui._skillIcon:SetShow(true)
		ui._skillIcon:SetPosX( sumInterval )
		sumInterval = sumInterval + ui._skillIcon:GetSizeX() + uiInterval

		ui._skillName:SetShow(true)
		ui._skillName:SetPosX( sumInterval )

		if ( skillData.isVehicle ) then
			local vehicleSkillSSW = getVehicleSkillStaticStatus( skillData.skillNo )
			if ( nil ~= vehicleSkillSSW ) then
				ui._skillIcon:ChangeTextureInfoName("icon/" .. vehicleSkillSSW:getIconPath())
				ui._skillName:SetText( vehicleSkillSSW:getName() )
				ui._skillName:SetSize( ui._skillName:GetTextSizeX(), ui._skillName:GetSizeY() )
			end
		else
			local skillStatic = getSkillStaticStatus( skillData.skillNo, 1 )
			if ( nil ~= skillStatic ) then
				local skillTypeSSW = skillStatic:getSkillTypeStaticStatusWrapper()
				ui._skillIcon:SetIgnore( false )
				ui._skillIcon:ChangeTextureInfoName("icon/" .. skillTypeSSW:getIconPath())
				ui._skillName:SetText( skillTypeSSW:getName() )
				ui._skillName:SetSize( ui._skillName:GetTextSizeX(), ui._skillName:GetSizeY() )
			end
		end
	end
	sumInterval = sumInterval + ui._skillName:GetSizeX() + uiInterval

	------------------------------------------------------
	--						배경 바
	------------------------------------------------------
	ui._skillBG:SetSize( sumInterval - ui._skillBG:GetPosX() + 10, ui._skillBG:GetSizeY() )
	ui._skillBG_Disabled:SetSize( sumInterval - ui._skillBG_Disabled:GetPosX() + 13, ui._skillBG_Disabled:GetSizeY() )
	if ( skillData.isHighLight ) then
		------------------------------------------------------
		-- 누를 수 있는 놈
		setColorWithoutAlpha( ui._skillBG, UI_color.C_FF002A56 )
		ui._skillBG_Disabled:SetShow( false )
		ui._skillName:SetFontColor(UI_color.C_FFFFFFFF )
		
	else
		------------------------------------------------------
		-- 누를 수 없는 놈
		setColorWithoutAlpha( ui._skillBG, UI_color.C_FF797979 )
		ui._skillBG_Disabled:SetShow( true )
		ui._skillName:SetFontColor(UI_color.C_FF797979 )
	end
	
	skillCommand_totalPosY = GetBottomPos( UIgr[index]._skillBG )
end


------------------------------------------------------
--				커맨드 업데이트 시점!
------------------------------------------------------
local updateCommand = function()
	for index = 0 , 3 do
		for k, v in pairs(UIgr[index]) do
			v:SetShow(false)
			v:SetPosY( index * 40 )		-- 각자 위치를 설정해준다
		end
		local isNotNil = skillDataGroup[index] ~= nil
		UIgr[index]._skillBG:SetShow(isNotNil)
		UIgr[index]._skillIcon:SetShow(isNotNil)
		UIgr[index]._skillName:SetShow(isNotNil)
	
		UIgr[index]._skillName:SetPosY( UIgr[index]._skillIcon:GetPosY() + 8 )		-- 이름은 따로 Y값을 설정해줘야한다~!!

		if ( isNotNil ) then
			updateCommandOne(skillDataGroup[index], UIgr[index], index)
		end
	end
end

function EventCommandGuide_Add( skillNo, Key_0, Key_1, Key_2, Key_3, uniqueKey, descIndex, branchId )
	insertCommand( skillNo, Key_0, Key_1, Key_2, Key_3, uniqueKey, descIndex, false, branchId )
	isProcessing = true
	elapsedTime = 0
	updateCommand()
	setAlphaAll(1)
	if ( false == isCommandEmpty() and  false == Panel_SkillCommand:GetShow() and GetUIMode() == UIMode.eUIMode_Default ) and ( true == isChecked_SkillCommand ) and ( Panel_Tutorial:IsShow() == false ) then
		Panel_SkillCommand:SetShow( true )
		changePositionBySever(Panel_SkillCommand, CppEnums.PAGameUIType.PAGameUIPanel_SkillCommand, true, true, false)
	end
end

function EventCommandGuide_AddVehicleSkill( skillNo, Key_0, Key_1, Key_2, Key_3, uniqueKey, descIndex, branchId )
	insertCommand( skillNo, Key_0, Key_1, Key_2, Key_3, uniqueKey, descIndex, true, branchId )
	isProcessing = true
	elapsedTime = 0
	updateCommand()
	setAlphaAll(1)
	if ( false == isCommandEmpty() and  false == Panel_SkillCommand:GetShow() and GetUIMode() == UIMode.eUIMode_Default ) and ( true == isChecked_SkillCommand ) and ( Panel_Tutorial:IsShow() == false ) then
		Panel_SkillCommand:SetShow( true)
		changePositionBySever(Panel_SkillCommand, CppEnums.PAGameUIType.PAGameUIPanel_SkillCommand, true, true, false)
	end
end

function EventCommandGuide_Clear()
	if ( isProcessing and Panel_SkillCommand:GetShow() and false == isCommandEmpty() ) then
		isProcessing = false
		elapsedTime = 0
		prevSkillDataGroup = skillDataGroup
		skillDataGroup = {}
	end
end

function EventCommandGuide_Highlight( uniqueKey )
	for index = 0 , 3 do
		if ( skillDataGroup[index].uniqueKey == uniqueKey ) then
			skillDataGroup[index].isHighLight = true
			updateCommand()
			return
		end
	end

end

function EventCommandGuide_Unhighlight( uniqueKey )
	for index = 0 , 3 do
		if ( skillDataGroup[index].uniqueKey == uniqueKey ) then
			skillDataGroup[index].isHighLight = false
			updateCommand()
			return
		end
	end
	
end

--------------------------------------------------------------------------------------------------------
-- 흑정령 텍스트 클릭하면 뜬다!
-- UI_else._system_Obsidian:	addInputEvent("Mouse_LUp", "New_Quest_Open()")

function New_Quest_Open()
	-- if not IsSelfPlayerWaitAction() then
		-- Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_SUMMON_BLACKSPIRIT") )
		-- return
	-- end
	-- local preUIMode = GetUIMode()
	-- SetUIMode( UIMode.eUIMode_NpcDialog_Dummy )
	-- local callSummon = RequestBeginTalkToClientNpc()
	-- -- true 를 리턴하면, 정령을 소환한 것이다!
	-- -- false 이면 정령이 아직 소환해제 되지 않았거나, 이미 소환요청을 한 상태라서 재소환을 할 수 없는 것이다.!
	-- if callSummon then
		-- UI.flushAndClearUI()				-- 일단 모든 창을 숨긴다

		-- UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
		-- -- 아무 키 입력도 받지 않는 State 로 전환
		-- -- 그 이후에 클라에서 메시지가 와서 NpcDialog 가 뜨면, 키 입력이 재개 될것이다!
		-- -- UIMain_QuestUpdateRemove()
	-- else
		-- SetUIMode( preUIMode )
	-- end
end
--------------------------------------------------------------------------------------------------------

local INTERACTABLE_ACTOR_KEY = 0
local INTERACTABLE_FRAG = 0
local isObsidianEffect = false
local isInteractionEffect = false

function EventCommandGuide_CommandUpdate( updateTime )
	elapsedTime = elapsedTime + updateTime
	
	if getSelfPlayer() == nil then
		return
	end
	
	-- 튜토리얼이 끝나지 않았거나, 7레벨이 되지 않았다면 꺼준다.
	if ( 7 > getSelfPlayer():get():getLevel() and false == isTutorialEnd() ) then
		Panel_SkillCommand:SetShow( false )
		changePositionBySever(Panel_SkillCommand, CppEnums.PAGameUIType.PAGameUIPanel_SkillCommand, true, true, false)
		return
	end

	local playerLevel 		= getSelfPlayer():get():getLevel()
	local actor				= interaction_getInteractable()
	local actorKey			= 0
	local interactableFrag	= 0
		
	------------------------------------------------------------
	-- 		상호작용 이벤트가 있을 경우 표시해준다!
	------------------------------------------------------------
	if ( nil ~= actor ) then
		actorKey				= actor:getActorKey()
		interactableFrag		= actor:getSettedFirstInteractionType()
	end
	
	if ( actorKey ~= INTERACTABLE_ACTOR_KEY ) or ( interactableFrag ~= INTERACTABLE_FRAG ) then
		INTERACTABLE_ACTOR_KEY	= actorKey
		INTERACTABLE_FRAG		= interactableFrag

		if ( 0 ~= interactableFrag and 3 ~= interactableFrag ) then
			UI_else._system_Inter:SetText( INETRACTION_BUTTON_TEXT[interactableFrag] )
			-- R 키 좌표를 보정. XML 수정이 있었음.
			UI_else._system_Inter:SetPosX(16)
		end
	end

	if ( 0 ~= INTERACTABLE_FRAG and 3 ~= INTERACTABLE_FRAG ) then	--  and ( 1 <= playerLevel ) and ( playerLevel < 21 )
		UI_else._system_Inter:SetPosY( - 30 )

		UI_else._system_Inter_T:SetPosX( UI_else._system_Inter:GetPosX() )
		UI_else._system_Inter_T:SetPosY( UI_else._system_Inter:GetPosY() )
		UI_else._system_Inter_T:SetSpanSize( 15, 0 )
		UI_else._system_Inter:SetSize( UI_else._system_Inter_T:GetTextSizeX() + UI_else._system_Inter_T:GetSpanSize().x, 25 )
	
		UI_else._system_Inter:SetShow(true)
		UI_else._system_Inter_T:SetShow(true)
		
		if ( UI_else._system_Inter:GetShow() == true ) and ( isInteractionEffect == false ) then
			UI_else._system_Inter:EraseAllEffect()
			UI_else._system_Inter:AddEffect("UI_ButtonLineRight_WhiteLong", true, 50, 0 )
			isInteractionEffect = true
		end
		
	else
		UI_else._system_Inter:SetShow( false )
		UI_else._system_Inter_T:SetShow( false )
		UI_else._system_Inter:EraseAllEffect()
		isInteractionEffect = false
	end
	

	------------------------------------------------------------
	--			흑정령을 소환할 수 있을 때 나온다!
	------------------------------------------------------------
	local _txt_Obsidian = UI_else._system_ObsidianTxt
	if ( questList_doHaveNewQuest() ) then	-- and ( 1 <= playerLevel ) and ( playerLevel < 21 ) 
		local blackSpiritKeyString = keyCustom_GetString_UiKey( CppEnums.UiInputType.UiInputType_BlackSpirit )
		UI_else._system_Obsidian:SetPosY( - 60 )
		_txt_Obsidian:SetPosX( UI_else._system_Obsidian:GetPosX() )
		_txt_Obsidian:SetPosY( UI_else._system_Obsidian:GetPosY() )
		_txt_Obsidian:SetSpanSize( 20, 0 )
		_txt_Obsidian:SetText( blackSpiritKeyString )
		UI_else._system_Obsidian:SetSize( _txt_Obsidian:GetTextSizeX() + _txt_Obsidian:GetSpanSize().x, 25 )
		_txt_Obsidian:SetSize( UI_else._system_Obsidian:GetSizeX(), UI_else._system_Obsidian:GetSizeY() )
		
		UI_else._system_Obsidian:SetShow(true)
		_txt_Obsidian:SetShow( true )
		
		UI_else._system_Obsidian:SetTextSpan( UI_else._system_Obsidian:GetSizeX() + 5, 0 )
		UI_else._system_Obsidian:SetEnableArea( 0, 0, UI_else._system_Obsidian:GetTextSizeX() + UI_else._system_Obsidian:GetSizeX() + 10, UI_else._system_Obsidian:GetSizeY() )
			
		if ( UI_else._system_Obsidian:GetShow() == true ) and ( isObsidianEffect == false ) then
			UI_else._system_Obsidian:EraseAllEffect()
			UI_else._system_Obsidian:AddEffect("UI_ButtonLineRight_WhiteLong", true, 50, 0 )
			isObsidianEffect = true
		end
		
	else
		UI_else._system_Obsidian:SetShow(false)
		_txt_Obsidian:SetShow(false)
		UI_else._system_Obsidian:EraseAllEffect()
		isObsidianEffect = false
	end
	
	
	local _txt_Ctrl = UI_else._system_CtrlTxt
	local _txt_Esc 	= UI_else._system_EscTxt
	local _txt_M 	= UI_else._system_MTxt
	------------------------------------------------------------
	--			1초 뒤 CTRL 키와 ESC 키를 보여준다
	------------------------------------------------------------
	if ( elapsedTime >= 1 ) then
		local worldMapKeyString = keyCustom_GetString_UiKey( CppEnums.UiInputType.UiInputType_WorldMap )
		local cursorString = keyCustom_GetString_UiKey( CppEnums.UiInputType.UiInputType_CursorOnOff )
		-- CTRL 버튼 재설정
		UI_else._system_Ctrl:SetShow( true )
		_txt_Ctrl:SetShow( true )
		_txt_Ctrl:SetText( cursorString )
		_txt_Ctrl:SetSize( _txt_Ctrl:GetTextSizeX(), _txt_Ctrl:GetSizeY() )
		_txt_Ctrl:SetPosX( UI_else._system_Ctrl:GetPosX() + 10 )
		UI_else._system_Ctrl:SetSize( _txt_Ctrl:GetSizeX() + 20, UI_else._system_Ctrl:GetSizeY() )
		UI_else._system_Ctrl:SetTextSpan( UI_else._system_Ctrl:GetSizeX() + 5, 0 )
		
		-- ESC 버튼 재설정
		UI_else._system_Esc:SetShow( true )
		_txt_Esc:SetShow( true )
		_txt_Esc:SetText( "Esc" )
		_txt_Esc:SetSize( _txt_Esc:GetTextSizeX(), _txt_Esc:GetSizeY() )
		_txt_Esc:SetPosX( UI_else._system_Esc:GetPosX() + 3 )
		UI_else._system_Esc:SetSize( _txt_Esc:GetSizeX() + 7, UI_else._system_Esc:GetSizeY() )
		UI_else._system_Esc:SetTextSpan( UI_else._system_Esc:GetSizeX() + 5, 0 )
		
		-- M 버튼 재설정
		UI_else._system_M:SetShow( true )
		_txt_M:SetShow( true )
		_txt_M:SetText( worldMapKeyString )
		_txt_M:SetSize( _txt_M:GetTextSizeX(), _txt_M:GetSizeY() )
		_txt_M:SetPosX( UI_else._system_M:GetPosX() + 3 )
		UI_else._system_M:SetSize( _txt_M:GetSizeX() + 7, UI_else._system_M:GetSizeY() )
		UI_else._system_M:SetTextSpan( UI_else._system_M:GetSizeX() + 5, 0 )

		commandChanged = false
	else
		_txt_Ctrl:SetShow(not commandChanged)
		_txt_Esc:SetShow(not commandChanged)
		_txt_M:SetShow(not commandChanged)
		UI_else._system_Ctrl:SetShow(not commandChanged)
		UI_else._system_Esc:SetShow(not commandChanged)
		UI_else._system_M:SetShow(not commandChanged)

		UI_else._system_Ctrl:SetPosY( skillCommand_totalPosY + skillCommand_posYGab )
		_txt_Ctrl:SetPosY( UI_else._system_Ctrl:GetPosY()  )
		UI_else._system_Esc:SetPosY( UI_else._system_Ctrl:GetPosY() + 23 )
		_txt_Esc:SetPosY( UI_else._system_Esc:GetPosY()   )
		UI_else._system_M:SetPosY( UI_else._system_Ctrl:GetPosY() + 46 )
		_txt_M:SetPosY( UI_else._system_M:GetPosY()   )
	end
	
	
	------------------------------------------------------------
	--			창을 끄고 켜는 것을 관리해준다
	------------------------------------------------------------
	if ( false == isProcessing ) then
		if elapsedTime >= animationEndTime then
			isProcessing = true
			updateCommand()
			if ( isCommandEmpty() and Panel_SkillCommand:GetShow() ) or ( Panel_Tutorial:IsShow() == true ) then
				Panel_SkillCommand:SetShow( false )
				changePositionBySever(Panel_SkillCommand, CppEnums.PAGameUIType.PAGameUIPanel_SkillCommand, true, true, false)
			end
		elseif ( elapsedTime >= animationEndTime / 2 ) then
			setAlphaAll((animationEndTime - (elapsedTime - animationEndTime / 2) * 2 ) / animationEndTime)
		else
			Panel_SkillCommand:SetShow( true )
			changePositionBySever(Panel_SkillCommand, CppEnums.PAGameUIType.PAGameUIPanel_SkillCommand, true, true, false)
		end
	end
end

FGlobal_SkillCommand_LevelCheck()

registerEvent( "EventCommandGuide_Add", "EventCommandGuide_Add" )
registerEvent( "EventCommandGuide_Clear", "EventCommandGuide_Clear" )
registerEvent( "EventCommandGuide_Highlight", "EventCommandGuide_Highlight" )
registerEvent( "EventCommandGuide_Unhighlight" , "EventCommandGuide_Unhighlight" )
registerEvent( "EventCommandGuide_AddVehicleSkill", "EventCommandGuide_AddVehicleSkill")

Panel_SkillCommand:RegisterUpdateFunc("EventCommandGuide_CommandUpdate")

registerEvent( "onScreenResize", "ScreenReisze_RePosCommand" )
ScreenReisze_RePosCommand()
