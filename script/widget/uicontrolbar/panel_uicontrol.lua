local UI_ANI_ADV	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM 			= CppEnums.EProcessorInputMode
local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color 		= Defines.Color
local VCK 			= CppEnums.VirtualKeyCode
local UI_IT 		= CppEnums.UiInputType


Panel_UIControl:SetShow( false )
Panel_UIControl:RegisterShowEventFunc( true, 'UI_Control_ShowAni()' )
Panel_UIControl:RegisterShowEventFunc( false, 'UI_Control_HideAni()' )
------------------------------------------------------------------
--					임의로 만든다 (에러)
------------------------------------------------------------------
function UI_Control_ShowAni()
	Panel_UIControl:SetShow(true)
end
function UI_Control_HideAni()
	Panel_UIControl:SetShow(false)
end


-- 각 위젯 텍스트 메뉴얼
--local buffText 				= UI.getChildControl ( Panel_AppliedBuffList,		"StaticText_buffText" )
local expText 				= UI.getChildControl ( Panel_SelfPlayerExpGage,		"StaticText_EXPText" )
local mainBarText 			= UI.getChildControl ( Panel_MainStatus_User_Bar,	"StaticText_MainBarText" )
local quickSlotText 		= UI.getChildControl ( Panel_QuickSlot,				"StaticText_quickSlot" )
local questListText 		= UI.getChildControl ( Panel_CheckedQuest,			"StaticText_questText")
local fieldViewText 		= UI.getChildControl ( Panel_FieldViewMode,			"StaticText_viewModeText" )
local raderText 			= UI.getChildControl ( Panel_Radar,					"StaticText_raderText" )
local npcNaviText 			= UI.getChildControl ( Panel_NpcNavi,				"StaticText_npcNaviText" )
local pvpText 				= UI.getChildControl ( Panel_PvpMode,				"StaticText_pvpText" )
local servantText 			= UI.getChildControl ( Panel_Window_Servant,		"StaticText_servantText" )
local skillCmdText 			= UI.getChildControl ( Panel_SkillCommand,			"StaticText_skillCmdText" )
--local chatText 			= UI.getChildControl ( Panel_Chatting,				"StaticText_chattingText" )
local questResizeButton		= UI.getChildControl( Panel_CheckedQuest,			"Button_Size" 	)

------------------------------------------------------------------
--				드래그 가능한 UI로 만들어주기
------------------------------------------------------------------
function Movable_UI()
	mainBarText:SetShow ( false )
	Panel_MainStatus_User_Bar:SetIgnore( false )
	Panel_MainStatus_User_Bar:SetDragEnable( true )
	Panel_MainStatus_User_Bar:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_isWidget.dds" )
	
	-- 버프리스트
	PaGlobalAppliedBuffList:setMovableUIForControlMode()

	quickSlotText:SetShow( false )
	Panel_QuickSlot:SetIgnore( false )
	Panel_QuickSlot:SetDragEnable( true )
	Panel_QuickSlot:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_isWidget.dds" )
	
	servantText:SetShow( false )
	Panel_Window_Servant:SetDragEnable( true )
	Panel_Window_Servant:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_isWidget.dds" )
	
	pvpText:SetShow ( false )
	Panel_PvpMode:SetIgnore( false )
	_pvpButton:SetIgnore(true)
	Panel_PvpMode:SetDragEnable( true )
	Panel_PvpMode:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_isWidget.dds" )
	
	Panel_ClassResource:SetIgnore( false )
	Panel_ClassResource:SetDragEnable( true )
	Panel_ClassResource:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_isWidget.dds" )
		
	-- Panel_Widget_PotenGradeInfo:SetIgnore( false )
	-- Panel_Widget_PotenGradeInfo:SetDragEnable( true )
	-- Panel_Widget_PotenGradeInfo:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_isWidget.dds" )

	-- Panel_Widget_CraftLevInfo:SetIgnore( false )
	-- Panel_Widget_CraftLevInfo:SetDragEnable( true )
	-- Panel_Widget_CraftLevInfo:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_isWidget.dds" )

	npcNaviText:SetShow( false )
	Panel_NpcNavi:SetDragEnable( true )

	-- expText:SetShow( true )
	-- Panel_SelfPlayerExpGage:SetIgnore( false )
	-- Panel_SelfPlayerExpGage:SetDragEnable( true )
	-- Panel_SelfPlayerExpGage:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_isWidget.dds" )
	
	Panel_Party:SetDragAll( true )
	Panel_Party:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_isWidget.dds" )
	
	-- 레이더 설정
	FGlobal_Panel_Radar_Movable_UI()
	
	-- 퀘스트 위젯 처리
	-- Panel_CheckedQuest:SetIgnore( false )
	Panel_CheckedQuest:SetDragEnable( true )							-- 이동 시킬 수 있다.
	Panel_CheckedQuest:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_isWidget.dds" )
	questResizeButton:SetShow( true )									-- 리사이즈 버튼 활성

	-- -- 채팅창
	-- for poolIndex = 0, 4, 1 do
	-- 	local chatPanel = FGlobal_getChattingPanel( poolIndex )
	-- 	chatPanel:SetDragAll( true )
	-- end

	-- local chattingPanelCount = ToClient_getChattingPanelCount()
	-- for panelIndex = 0, chattingPanelCount - 1, 1 do
	-- 	local chatPanel = ToClient_getChattingPanel( panelIndex )
	-- 	if ( chatPanel:isOpen() ) then
	-- 		local currentUIPool = FGlobal_getChattingPanelUIPool( panelIndex )
	-- 		currentUIPool._list_ResizeButton[0]:SetShow( true )
	-- 	end
	-- end
	-- 새 상위 아이템
	Panel_NewEquip:SetDragAll( true )


	fieldViewText:SetShow ( false )
	Panel_FieldViewMode:SetIgnore( false )
	Panel_FieldViewMode:SetDragAll( true )
	Panel_FieldViewMode:SetDragEnable( true )
	Panel_FieldViewMode:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_isWidget.dds" )

	skillCmdText:SetShow ( false )
	Panel_SkillCommand:SetIgnore ( false )
	Panel_SkillCommand:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_isWidget.dds" )
	
	FGlobal_SetMovableMode(true)
end

function Movable_UI_Cancel()
	mainBarText:SetShow ( false )
	Panel_MainStatus_User_Bar:SetIgnore( true )
	Panel_MainStatus_User_Bar:SetDragEnable( false )
	Panel_MainStatus_User_Bar:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_empty.dds" )
	MainStatusBar_PosX = Panel_MainStatus_User_Bar:GetPosX()
	MainStatusBar_PosY = Panel_MainStatus_User_Bar:GetPosY()

	quickSlotText:SetShow( false )
	Panel_QuickSlot:SetIgnore( true )
	Panel_QuickSlot:SetDragEnable( false )
	Panel_QuickSlot:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_empty.dds" )
	
	Panel_ClassResource:SetIgnore( true )
	Panel_ClassResource:SetDragEnable( false )
	Panel_ClassResource:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_empty.dds" )
	
	-- Panel_Widget_PotenGradeInfo:SetIgnore( true )
	-- Panel_Widget_PotenGradeInfo:SetDragEnable( false )
	-- Panel_Widget_PotenGradeInfo:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_empty.dds" )

	-- Panel_Widget_CraftLevInfo:SetIgnore( true )
	-- Panel_Widget_CraftLevInfo:SetDragEnable( false )
	-- Panel_Widget_CraftLevInfo:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_empty.dds" )

	pvpText:SetShow ( false )
	Panel_PvpMode:SetIgnore( true )
	Panel_PvpMode:SetDragEnable( false )
	_pvpButton:SetIgnore(false)
	Panel_PvpMode:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_empty.dds" )
	
	npcNaviText:SetShow( false )
	Panel_NpcNavi:SetDragEnable( false )

	-- 레이더 설정
	FGlobal_Panel_Radar_Movable_UI_Cancel()
	
	-- Panel_CheckedQuest:SetIgnore( true )
	Panel_CheckedQuest:SetDragEnable( false )
	Panel_CheckedQuest:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_empty.dds" )
	questResizeButton:SetShow( false )
	
	-- 채팅창
	-- for poolIndex = 0, 4, 1 do
	-- 	local chatPanel = FGlobal_getChattingPanel( poolIndex )
	-- 	chatPanel:SetDragAll( false )
	-- end

	-- local chattingPanelCount = ToClient_getChattingPanelCount()
	-- for panelIndex = 0, chattingPanelCount - 1, 1 do
	-- 	local chatPanel = ToClient_getChattingPanel( panelIndex )
	-- 	if ( chatPanel:isOpen() ) then
	-- 		local currentUIPool = FGlobal_getChattingPanelUIPool( panelIndex )
	-- 		currentUIPool._list_ResizeButton[0]:SetShow( false )
	-- 	end
	-- end

	-- 새 상위 아이템
	Panel_NewEquip:SetDragAll( false )

	PaGlobalAppliedBuffList:cancelMovableUIForControlMode()
	--buffText:SetShow( false )
	--Panel_AppliedBuffList:SetDragEnable( false )
	--Panel_AppliedBuffList:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_empty.dds" )
	
	servantText:SetShow( false )
	Panel_Window_Servant:SetDragEnable( false )
	Panel_Window_Servant:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_empty.dds" )
	
	local	temporaryWrapper= getTemporaryInformationWrapper()
	if	(nil == temporaryWrapper) or  (( nil == temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Vehicle ) ) and  ( nil == temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Ship ) ) and  ( nil == temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Pet ) )) 	then
		Panel_Window_Servant:SetShow( false )
	end
	
	fieldViewText:SetShow ( false )
	Panel_FieldViewMode:SetIgnore( true )
	Panel_FieldViewMode:SetDragAll( false )
	Panel_FieldViewMode:SetDragEnable( false )
	Panel_FieldViewMode:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_empty.dds" )
	
	Panel_Party:SetDragEnable( false )
	Panel_Party:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_empty.dds" )

	skillCmdText:SetShow ( false )
	Panel_SkillCommand:SetIgnore ( true )
	Panel_SkillCommand:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_empty.dds" )
	
	FGlobal_SetMovableMode(false)
end


function Panel_UIControl_SetShow( bShow )
	-- 같은 상황이면 애니를 반복하지 않는다!
	if bShow == Panel_UIControl:GetShow() then
		return
	end

	if bShow then
		FieldViewMode_ShowToggle( true )
		Panel_UIControl:SetShow(true, true)
		Movable_UI()
		-- UIMain_initWidgetButtons()		-- 메인 UI 위젯 토글
		ResetPos_WidgetButton()		-- 메인 UI 위젯 위치 변경
	else
		-- MenuBar 가 사라질때, PC HP/MP 바의 위치를 갱신해준다!
		FieldViewMode_ShowToggle( false )
		SelfPlayerStatusBar_RefleshPosition()
		Movable_UI_Cancel()
		Panel_UIControl:SetShow(false, true)
		-- UIMain_initWidgetButtons()		-- 메인 메뉴 텍스트버튼 토글
		ResetPos_WidgetButton()		-- 메인 UI 위젯 위치 변경
	end
end

