local UI_TM			= CppEnums.TextMode
local UI_PUCT 		= CppEnums.PA_UI_CONTROL_TYPE
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_TISNU 		= CppEnums.TInventorySlotNoUndefined
local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color 		= Defines.Color

local isRide = false

-- 하단에 블랙스톤 띄우기! (NEW QUEST 알림)
local _blackStone 			= UI.getChildControl ( Panel_NewQuest, "Static_blackDust_0" )
local _newQuestTextBubble 	= UI.getChildControl ( Panel_NewQuest, "Static_NewQuestBubble" )
local _newQuestText 		= UI.getChildControl ( Panel_NewQuest, "StaticText_newQuestText" )
local _callingYou 			= UI.getChildControl ( Panel_NewQuest, "StaticText_Purpose" )
local _callingYou_Sub		= UI.getChildControl ( Panel_NewQuest, "StaticText_Purpose_Sub" )

_newQuestTextBubble	:SetShow(false)
_newQuestText		:SetShow(false)
_newQuestText		:SetText("")
_blackStone			:SetIgnore (true)

-- Panel_NewQuest:addInputEvent( "Mouse_LUp",	"HandleClicked_NewQuestBlackSpritOpen()" )	-- 누루지 못하게 한다.
-- Panel_NewQuest:addInputEvent( "Mouse_On",	"Panel_NewQuest_MouseEventFunc( true )" )
-- Panel_NewQuest:addInputEvent( "Mouse_Out",	"Panel_NewQuest_MouseEventFunc( false )" )
Panel_NewQuest:SetDragEnable( false )			-- 예외처리 최초에는 드래그가 안되게 설정한다(효)
Panel_NewQuest:SetIgnore( true )
-- function HandleClicked_NewQuestBlackSpritOpen()
-- 	if not IsSelfPlayerWaitAction() then
-- 		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_SUMMON_BLACKSPIRIT") )
-- 		return
-- 	end
-- 	-- 흑정령 아이콘 누를 때 소리(임시)
-- 	audioPostEvent_SystemUi(00,05)
-- 	ToClient_AddBlackSpiritFlush();
-- end

Panel_NewQuest:RegisterShowEventFunc( true, 'newQuest_ShowAnimation()' )
Panel_NewQuest:RegisterShowEventFunc( false, 'newQuest_HideAnimation()' )

local _cumulatedTime = 0
local _bubbleCount = 0
local _startAnimation = false
local _isBubbleCount = _bubbleCount + 1


local _blackStone_BeforCallingTime = 0
_blackStone_CallingTime = 0	-- 흑정령이 부른 횟 수.

function FGlobal_NewMainQuest_Alarm_Check()
	if not ToClient_getIsBlackSpiritNotice() then
		Panel_NewQuest:SetShow ( false, false )
	end
end

function FGlobal_NewMainQuest_Alarm_Open()
	if not ToClient_getIsBlackSpiritNotice() then
		Panel_NewQuest:SetShow ( false, true )
		return
	end
	if Panel_LocalWarTeam:GetShow() then
		Panel_NewQuest:SetShow ( false, false )
		return
	end

	local isColorBlindMode = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(CppEnums.GlobalUIOptionType.ColorBlindMode)

	if isRide == false then		-- 말 내린 상태
		if not Panel_Npc_Dialog:GetShow() then 
			_blackStone_CallingTime = _blackStone_CallingTime + 1	-- 흑정령이 부른 수를 +1 한다.

			Panel_NewQuest:SetShow(true, true)
			if Panel_LocalWar:GetShow() then
				Panel_NewQuest:SetPosY( 140 )
			else
				Panel_NewQuest:SetPosY( 120 )
			end

			-- 흑정령 호출 메시지가 깜빡인다.
			Panel_NewQuest:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
			local QuickSlotClose_Alpha = Panel_NewQuest:addColorAnimation( 2.0, 3.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
			QuickSlotClose_Alpha:SetStartColor( UI_color.C_FFFFFFFF )
			QuickSlotClose_Alpha:SetEndColor( UI_color.C_00FFFFFF )
			QuickSlotClose_Alpha.IsChangeChild = true
			QuickSlotClose_Alpha:SetHideAtEnd(true)
			QuickSlotClose_Alpha:SetDisableWhileAni(true)

			Panel_NewQuest:SetIgnore(true)
			_blackStone:SetShow(true)
			_blackStone:SetIgnore(true)
			newQuest_ShowAnimation()
									
			-- 시작 애니메이션 준다! 한번만!
			if _startAnimation == false	then
				-- ♬ 흑정령이 나왔을 때 사운드 추가
				audioPostEvent_SystemUi(04,05)
			
				Panel_NewQuest:ComputePos()
				-- Panel_NewQuest_ScreenResize()
				
				_blackStone:ResetVertexAni()
				_blackStone:SetVertexAniRun("Ani_Scale_StoneShow", true)
				_blackStone:SetVertexAniRun("Ani_Color_StoneShow", true)

				-- UIMain_QuestUpdate()
			
				_startAnimation = true
				
				-- dialog_applyEffectBlackSpirit()
			else
				return
			end
			
			-- _callingYou:SetPosX( ( getScreenSizeX() - _callingYou:GetSizeX() ) / 2  - Panel_NewQuest:GetPosX() )
			-- _callingYou:SetPosY( _callingYou:GetSpanSize().y - Panel_NewQuest:GetPosY() )
			_callingYou:SetShow( true )
			if (0 == isColorBlindMode) then
				_callingYou:SetFontColor( UI_color.C_FFEE5555 )
			elseif (1 == isColorBlindMode) then
				_callingYou:SetFontColor( UI_color.C_FF0096FF )
			elseif (2 == isColorBlindMode) then
				_callingYou:SetFontColor( UI_color.C_FF0096FF )
			end
			_callingYou:SetText( PAGetString(Defines.StringSheet_GAME, "PANEL_QUESTLIST_CALLINGYOUT") )	-- 흑정령이 당신에게 의뢰를 요청하려 합니다.

			-- _callingYou_Sub:SetPosX( ( getScreenSizeX() - _callingYou_Sub:GetSizeX() ) / 2  - Panel_NewQuest:GetPosX() )
			-- _callingYou_Sub:SetPosY( _callingYou_Sub:GetSpanSize().y - Panel_NewQuest:GetPosY() )
			local blackSpiritKeyString = keyCustom_GetString_UiKey( CppEnums.UiInputType.UiInputType_BlackSpirit )
			_callingYou_Sub:SetShow( true )
			_callingYou_Sub:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_QUESTLIST_CALLINGYOU_SUB", "keyString", blackSpiritKeyString ) )	-- <PAColor0xFFFFD649>'/ 키'<PAOldColor> 를 입력하여 소환하세요.

			_cumulatedTime = 0
		end
	else		-- 말 탄 상태
		Panel_NewQuest:SetShow ( false, true )
	end
end


function newQuest_ShowAnimation()
	_blackStone:ResetVertexAni()
	_blackStone:SetAlpha(1)
end

function newQuest_HideAnimation()
	if _startAnimation == true then
		_blackStone:ResetVertexAni()
		_blackStone:SetVertexAniRun("Ani_Scale_StoneHide", true)
		_blackStone:SetVertexAniRun("Ani_Color_StoneHide", true)
		_newQuestTextBubble:SetShow(false)
		_newQuestText:SetShow(false)
		Panel_NewQuest:EraseAllEffect()
		_startAnimation = false
	end
end


-- function Panel_NewQuest_MouseEventFunc( isOn )
-- 	if ( isOn == true ) then
-- 		_newQuestText:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_QUESTLIST_BLACKSOUL" ) .. "-".. PAGetString( Defines.StringSheet_GAME, "PANEL_QUESTLIST_MOVE_DRAG" ) )
-- 	else
-- 		_newQuestText:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_QUESTLIST_BLACKSOUL" ) )
-- 	end
-- end

function Panel_NewQuest_ScreenResize()
	Panel_NewQuest:SetPosX( getScreenSizeX() - (getScreenSizeX()/2) - (Panel_NewQuest:GetSizeX() / 2)  )
	Panel_NewQuest:SetPosY( 120 )
end


-----------------------------------------------------------------------------------------------------------------------------
Panel_NewQuest:RegisterUpdateFunc( "updateNewQuestOpenRate" )

function updateNewQuestOpenRate( deltaTime )
	_cumulatedTime = _cumulatedTime + deltaTime

	if 3.5 < _cumulatedTime then
		Panel_NewQuest:SetShow( false, true )
		_cumulatedTime = 0
	end
end

-- 말 탔을 때, 내렸을 때 처리를 위한 펑션
function SelfPlayer_RideOn()
	HideUseTab_Func()
	isRide = true
end
function SelfPlayer_RideOff()
	isRide = false
end

registerEvent("onScreenResize",				"Panel_NewQuest_ScreenResize")
registerEvent("EventSelfPlayerRideOn",		"SelfPlayer_RideOn")
registerEvent("EventSelfPlayerRideOff",		"SelfPlayer_RideOff")
-------------------------------------------------------------------------------