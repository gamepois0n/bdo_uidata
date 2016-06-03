-----------------------------------------------------------
-- Local 변수 설정
-----------------------------------------------------------
local UI_PUCT 		= CppEnums.PA_UI_CONTROL_TYPE
local UI_color 		= Defines.Color
local UI_TM			= CppEnums.TextMode
local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UIMode		= Defines.UIMode
local IM 			= CppEnums.EProcessorInputMode

local QuestListUIPool = 
{
	_listGroupBG					= {}
	,_listGroupBG1					= {}
	,_listGroupBG2					= {}
	,_listExtendCheck				= {}
	,_listGroupTitle				= {}
	,_listGroupTitleSub				= {}
	,_listQuestTypeIcon				= {}
	,_listQuestTitle				= {}
	,_listQuestTitleBG				= {}
	,_listQuestCompleteDest			= {}
	,_listWidgetGroupTitle			= {}
	,_listQuestCondition			= {}
	,_listQuestConditionGaugeBG		= {}
	,_listQuestConditionGauge		= {}
	,_listQuestImage				= {}
	,_listQuestImageBoarder			= {}
	,_listQuestAutoNaviButton		= {}
	,_listQuestNaviButton			= {}
	,_listQuestGiveupButton			= {}
	,_listQuestRewardButton			= {}
	,_listQuestHideButton			= {}
	,_listQuestClearIcon			= {}
	,_listQuestNaviEffect			= {}	
	
	,_countGroupBG					= 0	,_maxcountGroupBG				= 15 
	,_countGroupBG1					= 0	,_maxcountGroupBG1				= 15 
	,_countGroupBG2					= 0	,_maxcountGroupBG2				= 15 
	,_countExtendCheck				= 0	,_maxcountExtendCheck			= 20 
	,_countGroupTitle				= 0 ,_maxcountGroupTitle			= 20
	,_countGroupTitleSub			= 0 ,_maxcountGroupTitleSub			= 20
	,_countQuestTypeIcon			= 0	,_maxcountQuestTypeIcon			= 30	
	,_countQuestTitle				= 0 ,_maxcountQuestTitle			= 30
	,_countQuestTitleBG				= 0 ,_maxcountQuestTitleBG			= 30
	,_countQuestCompleteDest		= 0 ,_maxcountQuestCompleteDest		= 20
	,_countWidgetGroupTitle			= 0 ,_maxcountWidgetGroupTitle		= 20
	,_countQuestCondition			= 0 ,_maxcountQuestCondition		= 30
	,_countQuestConditionGaugeBG	= 0 ,_maxcountQuestConditionGaugeBG	= 30
	,_countQuestConditionGauge		= 0 ,_maxcountQuestConditionGauge	= 30
	,_countQuestImage				= 0 ,_maxcountQuestImage			= 20
	,_countQuestImageBoarder		= 0 ,_maxcountQuestImageBoarder		= 20
	,_countQuestAutoNaviButton		= 0	,_maxcountQuestAutoNaviButton	= 20	
	,_countQuestNaviButton			= 0	,_maxcountQuestNaviButton		= 20	
	,_countQuestGiveupButton		= 0	,_maxcountQuestGiveupButton		= 20	
	,_countQuestRewardButton		= 0 ,_maxcountQuestRewardButton		= 20
	,_countQuestHideButton			= 0 ,_maxcountQuestHideButton		= 20
	,_countQuestClearIcon			= 0 ,_maxcountQuestClearIcon		= 20
	,_countQuestNaviEffect			= 0	,_maxcountQuestNaviEffect		= 20	
}

function QuestListUIPool:prepareControl(Panel, parantControl, createdCotrolList, controlType, controlName, createCount)
	local styleUI = UI.getChildControl(Panel, controlName)
	 for index = 0, createCount, 1 do		
		createdCotrolList[index]	= UI.createControl( controlType, parantControl, controlName .. index)
		CopyBaseProperty(styleUI, createdCotrolList[index])
		createdCotrolList[index]:SetShow(true)
	 end
end

function QuestListUIPool:initialize(stylePanel, parantControl)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listGroupBG,				UI_PUCT.PA_UI_CONTROL_STATIC,		"Static_GroupBG", 							self._maxcountGroupBG	)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listGroupBG1,				UI_PUCT.PA_UI_CONTROL_STATIC,		"Static_SelectedQuestBG", 					self._maxcountGroupBG1	)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listGroupBG2,				UI_PUCT.PA_UI_CONTROL_STATIC,		"Static_SelectedQuestBG_2", 					self._maxcountGroupBG2	)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listExtendCheck,			UI_PUCT.PA_UI_CONTROL_CHECKBUTTON, 	"Checkbox_GroupQuest_ClearedQuest_Show", 	self._maxcountExtendCheck		)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestCompleteDest,	UI_PUCT.PA_UI_CONTROL_STATICTEXT,	"StaticText_Quest_ClearNpc", 				self._maxcountQuestCompleteDest	)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listWidgetGroupTitle,		UI_PUCT.PA_UI_CONTROL_STATICTEXT,	"StaticText_WidgetGroupTitle", 				self._maxcountWidgetGroupTitle	)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listGroupTitle,			UI_PUCT.PA_UI_CONTROL_STATICTEXT, 	"StaticText_GroupQuest_Title", 				self._maxcountGroupTitle		)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listGroupTitleSub,		UI_PUCT.PA_UI_CONTROL_STATICTEXT, 	"StaticText_GroupQuest_Progress", 			self._maxcountGroupTitleSub		)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestTitleBG,			UI_PUCT.PA_UI_CONTROL_STATIC,		"Static_Quest_Title_BG", 					self._maxcountQuestTitleBG		)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestTypeIcon,		UI_PUCT.PA_UI_CONTROL_STATIC, 		"Static_Quest_Type", 						self._maxcountQuestTypeIcon		)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestTitle,			UI_PUCT.PA_UI_CONTROL_STATICTEXT,	"StaticText_Quest_Title", 					self._maxcountQuestTitle		)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestCondition,		UI_PUCT.PA_UI_CONTROL_STATICTEXT,	"StaticText_Quest_Demand", 					self._maxcountQuestCondition	)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestConditionGaugeBG,UI_PUCT.PA_UI_CONTROL_STATIC,		"Static_ConditionGauge_BG", 				self._maxcountQuestConditionGaugeBG	)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestConditionGauge,	UI_PUCT.PA_UI_CONTROL_PROGRESS2,	"CircularProgress_ConditionCount", 			self._maxcountQuestConditionGauge	)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestImage,			UI_PUCT.PA_UI_CONTROL_STATIC,		"Static_Quest_Image", 						self._maxcountQuestImage		)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestImageBoarder,	UI_PUCT.PA_UI_CONTROL_STATIC,		"Static_Quest_ImageBoarder", 				self._maxcountQuestImageBoarder	)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestNaviEffect,		UI_PUCT.PA_UI_CONTROL_STATIC,		"Static_Quest_Icon_NaviEffect", 			self._maxcountQuestNaviEffect	)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestAutoNaviButton,	UI_PUCT.PA_UI_CONTROL_CHECKBUTTON,	"CheckButton_AutoNavi", 					self._maxcountQuestAutoNaviButton	)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestNaviButton,		UI_PUCT.PA_UI_CONTROL_CHECKBUTTON,	"Checkbox_Quest_Navi", 						self._maxcountQuestNaviButton	)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestGiveupButton,	UI_PUCT.PA_UI_CONTROL_BUTTON,		"Checkbox_Quest_Giveup", 					self._maxcountQuestGiveupButton	)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestRewardButton,	UI_PUCT.PA_UI_CONTROL_BUTTON,		"Checkbox_Quest_Reward", 					self._maxcountQuestRewardButton	)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestHideButton,		UI_PUCT.PA_UI_CONTROL_BUTTON,		"Checkbox_Quest_Hide", 						self._maxcountQuestHideButton	)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestClearIcon,		UI_PUCT.PA_UI_CONTROL_STATIC,		"Static_Quest_Icon_ClearCheck", 			self._maxcountQuestClearIcon	)
	QuestListUIPool:clear()
end


-----------------------------------------------------------
-- 오브젝트 생성
-----------------------------------------------------------
function QuestListUIPool:newGroupBG()
	self._countGroupBG = self._countGroupBG + 1 
	return self._listGroupBG[self._countGroupBG - 1]
end
function QuestListUIPool:newGroupBG1()
	self._countGroupBG1 = self._countGroupBG1 + 1 
	return self._listGroupBG1[self._countGroupBG1 - 1]
end
function QuestListUIPool:newGroupBG2()
	self._countGroupBG2 = self._countGroupBG2 + 1 
	return self._listGroupBG2[self._countGroupBG2 - 1]
end
function QuestListUIPool:newExtendButton()
	self._countExtendCheck = self._countExtendCheck + 1 
	return self._listExtendCheck[self._countExtendCheck - 1]
end
function QuestListUIPool:newGroupTitle()
	self._countGroupTitle = self._countGroupTitle + 1 
	return self._listGroupTitle[self._countGroupTitle - 1]
end
function QuestListUIPool:newGroupTitleSub()
	self._countGroupTitleSub = self._countGroupTitleSub + 1 
	return self._listGroupTitleSub[self._countGroupTitleSub - 1]
end
function QuestListUIPool:newQuestTypeIcon()
	self._countQuestTypeIcon = self._countQuestTypeIcon + 1 
	return self._listQuestTypeIcon[self._countQuestTypeIcon - 1]
end
function QuestListUIPool:newQuestTitle()
	self._countQuestTitle = self._countQuestTitle + 1 
	return self._listQuestTitle[self._countQuestTitle - 1]
end
function QuestListUIPool:newQuestTitleBG()
	self._countQuestTitleBG = self._countQuestTitleBG + 1 
	return self._listQuestTitleBG[self._countQuestTitleBG - 1]
end
function QuestListUIPool:newCompleteDest()
	self._countQuestCompleteDest = self._countQuestCompleteDest + 1 
	return self._listQuestCompleteDest[self._countQuestCompleteDest - 1]
end
function QuestListUIPool:WidgetGroupTitle()
	self._countWidgetGroupTitle = self._countWidgetGroupTitle + 1 
	return self._listWidgetGroupTitle[self._countWidgetGroupTitle - 1]
end
function QuestListUIPool:newQuestCondition()
	self._countQuestCondition = self._countQuestCondition + 1 
	return self._listQuestCondition[self._countQuestCondition - 1]
end
function QuestListUIPool:newQuestConditionGauge()
	self._countQuestConditionGauge = self._countQuestConditionGauge + 1 
	return self._listQuestConditionGauge[self._countQuestConditionGauge - 1]
end
function QuestListUIPool:newQuestConditionGaugeBG()
	self._countQuestConditionGaugeBG = self._countQuestConditionGaugeBG + 1 
	return self._listQuestConditionGaugeBG[self._countQuestConditionGaugeBG - 1]
end
function QuestListUIPool:newQuestImage()
	self._countQuestImage = self._countQuestImage + 1 
	return self._listQuestImage[self._countQuestImage - 1]
end
function QuestListUIPool:newQuestImageBoarder()
	self._countQuestImageBoarder = self._countQuestImageBoarder + 1 
	return self._listQuestImageBoarder[self._countQuestImageBoarder - 1]
end
function QuestListUIPool:newQuestAutoNaviButton()
	self._countQuestAutoNaviButton = self._countQuestAutoNaviButton + 1 
	return self._listQuestAutoNaviButton[self._countQuestAutoNaviButton - 1]
end
function QuestListUIPool:newQuestNaviButton()
	self._countQuestNaviButton = self._countQuestNaviButton + 1 
	return self._listQuestNaviButton[self._countQuestNaviButton - 1]
end
function QuestListUIPool:newQuestNaviEffect()
	self._countQuestNaviEffect = self._countQuestNaviEffect + 1 
	return self._listQuestNaviEffect[self._countQuestNaviEffect - 1]
end
function QuestListUIPool:newQuestGiveupButton()
	self._countQuestGiveupButton = self._countQuestGiveupButton + 1 
	return self._listQuestGiveupButton[self._countQuestGiveupButton - 1]
end
function QuestListUIPool:newQuestRewardButton()
	self._countQuestRewardButton = self._countQuestRewardButton + 1 
	return self._listQuestRewardButton[self._countQuestRewardButton - 1]
end
function QuestListUIPool:newQuestHideButton()
	self._countQuestHideButton = self._countQuestHideButton + 1 
	return self._listQuestHideButton[self._countQuestHideButton - 1]
end
function QuestListUIPool:newQuestClearIcon()
	self._countQuestClearIcon = self._countQuestClearIcon + 1 
	return self._listQuestClearIcon[self._countQuestClearIcon - 1]
end


-----------------------------------------------------------
-- 버튼 초기화
-----------------------------------------------------------
function QuestListUIPool:clear()
	self._countGroupBG					= 0
	self._countGroupBG1					= 0
	self._countGroupBG2					= 0
	self._countExtendCheck				= 0
	self._countGroupTitle				= 0
	self._countGroupTitleSub			= 0
	self._countQuestTypeIcon			= 0	
	self._countQuestTitle				= 0
	self._countQuestTitleBG				= 0
	self._countQuestCompleteDest		= 0
	self._countWidgetGroupTitle			= 0
	self._countQuestCondition			= 0
	self._countQuestConditionGauge		= 0
	self._countQuestConditionGaugeBG	= 0
	self._countQuestImage				= 0
	self._countQuestImageBoarder		= 0
	self._countQuestAutoNaviButton		= 0	
	self._countQuestNaviButton			= 0	
	self._countQuestGiveupButton		= 0	
	self._countQuestRewardButton		= 0
	self._countQuestHideButton			= 0
	self._countQuestClearIcon			= 0	
	self._countQuestNaviEffect			= 0
	QuestListUIPool:hideNotUse()
end


-----------------------------------------------------------
-- (사용하지 않는) 버튼 숨김
-----------------------------------------------------------
function QuestListUIPool:hideNotUse()
	for index = self._countGroupBG, self._maxcountGroupBG, 1 do
		self._listGroupBG[index]:SetShow(false)
	end
	for index = self._countGroupBG1, self._maxcountGroupBG1, 1 do
		self._listGroupBG1[index]:SetShow(false)
	end
	for index = self._countGroupBG2, self._maxcountGroupBG2, 1 do
		self._listGroupBG2[index]:SetShow(false)
	end
	for index = self._countExtendCheck, self._maxcountExtendCheck, 1 do
		self._listExtendCheck[index]:SetShow(false)
	end
	for index = self._countGroupTitle, self._maxcountGroupTitle, 1 do
		self._listGroupTitle[index]:SetShow(false)
	end
	for index = self._countGroupTitleSub, self._maxcountGroupTitleSub, 1 do
		self._listGroupTitleSub[index]:SetShow(false)
	end
	for index = self._countQuestTypeIcon, self._maxcountQuestTypeIcon, 1 do
		self._listQuestTypeIcon[index]:SetShow(false)
	end
	for index = self._countQuestTitle, self._maxcountQuestTitle, 1 do
		self._listQuestTitle[index]:SetShow(false)
	end
	for index = self._countQuestTitleBG, self._maxcountQuestTitleBG, 1 do
		self._listQuestTitleBG[index]:SetShow(false)
	end
	for index = self._countQuestCompleteDest, self._maxcountQuestCompleteDest, 1 do
		self._listQuestCompleteDest[index]:SetShow(false)
	end
	for index = self._countWidgetGroupTitle, self._maxcountWidgetGroupTitle, 1 do
		self._listWidgetGroupTitle[index]:SetShow(false)
	end
	for index = self._countQuestCondition, self._maxcountQuestCondition, 1 do
		self._listQuestCondition[index]:SetShow(false)
	end
	for index = self._countQuestConditionGauge, self._maxcountQuestConditionGauge, 1 do
		self._listQuestConditionGauge[index]:SetShow(false)
	end
	for index = self._countQuestConditionGaugeBG, self._maxcountQuestConditionGaugeBG, 1 do
		self._listQuestConditionGaugeBG[index]:SetShow(false)
	end
	for index = self._countQuestImage, self._maxcountQuestImage, 1 do
		self._listQuestImage[index]:SetShow(false)
	end
	for index = self._countQuestImageBoarder, self._maxcountQuestImageBoarder, 1 do
		self._listQuestImageBoarder[index]:SetShow(false)
	end
	for index = self._countQuestAutoNaviButton, self._maxcountQuestAutoNaviButton, 1 do
		self._listQuestAutoNaviButton[index]:SetShow(false)
	end
	for index = self._countQuestNaviButton, self._maxcountQuestNaviButton, 1 do
		self._listQuestNaviButton[index]:SetShow(false)
	end
	for index = self._countQuestNaviEffect, self._maxcountQuestNaviEffect, 1 do
		self._listQuestNaviEffect[index]:SetShow(false)
	end
	for index = self._countQuestGiveupButton, self._maxcountQuestGiveupButton, 1 do
		self._listQuestGiveupButton[index]:SetShow(false)
	end
	for index = self._countQuestRewardButton, self._maxcountQuestRewardButton, 1 do
		self._listQuestRewardButton[index]:SetShow(false)
	end
	for index = self._countQuestHideButton, self._maxcountQuestHideButton, 1 do
		self._listQuestHideButton[index]:SetShow(false)
	end
	for index = self._countQuestClearIcon, self._maxcountQuestClearIcon, 1 do
		self._listQuestClearIcon[index]:SetShow(false)
	end	
end


-----------------------------------------------------------
-- Panel 설정
-----------------------------------------------------------
-- { 패널 설정
	Panel_CheckedQuest:ActiveMouseEventEffect(true)
	Panel_CheckedQuest:SetShow(true)
	Panel_CheckedQuest:setMaskingChild(true)
	Panel_CheckedQuest:setGlassBackground( true )
	Panel_CheckedQuest:SetDragEnable( false )
	-- Panel_CheckedQuest:setFlushAble( false )

	Panel_CheckedQuest:RegisterShowEventFunc( true, 'QuestListShowAni()' )
	Panel_CheckedQuest:RegisterShowEventFunc( false, 'QuestListHideAni()' )

	Panel_CheckedQuest:addInputEvent( "Mouse_DownScroll",	"QuestWidget_ScrollEvent( true )"		)
	Panel_CheckedQuest:addInputEvent( "Mouse_UpScroll", 	"QuestWidget_ScrollEvent( false )" 	)
	Panel_CheckedQuest:addInputEvent( "Mouse_LUp", 			"ResetPos_WidgetButton()" )					-- 메인UI 위젯 위치 초기화
	Panel_CheckedQuest:addInputEvent( "Mouse_On", 			"questWidget_MouseOver( true )" )
	Panel_CheckedQuest:addInputEvent( "Mouse_Out", 			"questWidget_MouseOver( false )" )
-- }

-- { 리사이즈/스크롤 컨트롤
	local QuestList_ScrollBar 			= UI.getChildControl( Panel_CheckedQuest, 	"Scroll_CheckQuestList" )
	QuestList_ScrollBar:SetShow( false )
	QuestList_ScrollBar:SetControlTop()
	QuestList_ScrollBar:addInputEvent( "Mouse_LPress", "QuestWidget_ScrollLPress()" )

	local QuestList_ScrollBar_CtrBT 	= UI.getChildControl( QuestList_ScrollBar, 	"Scroll_CtrlButton" 	)
	QuestList_ScrollBar_CtrBT:SetNotAbleMasking( true )
	QuestList_ScrollBar_CtrBT:addInputEvent( "Mouse_LPress", "QuestWidget_ScrollLPress()" )

	local panelResizeButton				= UI.getChildControl( Panel_CheckedQuest, 	"Button_Size" 	)
	panelResizeButton:SetNotAbleMasking( true )
	panelResizeButton:SetShow( false )
	panelResizeButton:addInputEvent( "Mouse_LPress",	"HandleClicked_QuestWidgetPanelResize()" )
	panelResizeButton:addInputEvent( "Mouse_LDown",		"HandleClicked_QuestWidgetPanelSize()" )
	panelResizeButton:addInputEvent( "Mouse_LUp",		"HandleClicked_QuestWidgetSaveResize()" )
	panelResizeButton:addInputEvent( "Mouse_On",		"HandleOn_QuestWidgetPanelResize( true )" )
	panelResizeButton:addInputEvent( "Mouse_Out",		"HandleOn_QuestWidgetPanelResize( false )" )
	panelResizeButton:SetPosY( Panel_CheckedQuest:GetSizeY() + 10 )
	panelResizeButton:SetPosX( 150 )
-- }

-- { 투명 배경?
	local questWidget_TransBG			= UI.getChildControl( Panel_CheckedQuest, 	"Static_TransBG" 	)
	questWidget_TransBG:SetNotAbleMasking( true )
	questWidget_TransBG:SetPosX( -5 )
	questWidget_TransBG:SetPosY( -15 )
-- }

-- { 가이드 버튼 처리용
	local guideQuestButton				= UI.getChildControl( Panel_CheckedQuest, 	"Button_Guide" 	)
	local guideQuestButton_Desc			= UI.getChildControl( Panel_CheckedQuest, 	"StaticText_Guide_Desc" )
	local guideQuestNumber				= UI.getChildControl( Panel_CheckedQuest, 	"StaticText_Number" )
	guideQuestButton:addInputEvent( "Mouse_On", "HandleClicked_QuestWidget_GuideQuest_MouseOver( true )" )
	guideQuestButton:addInputEvent( "Mouse_Out", "HandleClicked_QuestWidget_GuideQuest_MouseOver( false )" )
	guideQuestButton:addInputEvent( "Mouse_LUp", "HandleClicked_QuestWidget_GuideQuest()" )
	guideQuestButton:SetShow( false )
	guideQuestButton:SetNotAbleMasking( true )
	guideQuestButton_Desc:SetNotAbleMasking( true )
	guideQuestNumber:SetNotAbleMasking( true )
	guideQuestButton:ActiveMouseEventEffect( true )
	guideQuestButton:SetCheck( false )
	guideQuestButton_Desc:SetShow( false )
	guideQuestNumber:SetShow( false )

	local historyButton					= UI.getChildControl( Panel_CheckedQuest, 	"Button_History" )
	local historyButton_Desc			= UI.getChildControl( Panel_CheckedQuest, 	"StaticText_Detail_Desc" )
	historyButton:addInputEvent( "Mouse_On",	"HandleClicked_QuestNew_MouseOver( true )" )
	historyButton:addInputEvent( "Mouse_Out",	"HandleClicked_QuestNew_MouseOver( false )" )
	historyButton:addInputEvent( "Mouse_LUp",	"Panel_Window_QuestNew_Toggle()" )
	historyButton:SetShow( false )
	historyButton:SetNotAbleMasking( true )
	historyButton_Desc:SetNotAbleMasking( true )
	historyButton_Desc:SetShow( false )
	historyButton:ActiveMouseEventEffect( true )
-- }

-- { 길드 찾기
	local findGuild				= UI.getChildControl( Panel_CheckedQuest, 	"Button_WantGuild" 	)
	findGuild:SetShow( false )
	findGuild:SetNotAbleMasking( true )
	findGuild:addInputEvent( "Mouse_On",	"HandleOn_CheckedQuest_WantJoinGuild( true )" )
	findGuild:addInputEvent( "Mouse_Out",	"HandleOn_CheckedQuest_WantJoinGuild( false )" )
	
	findGuild:addInputEvent( "Mouse_On",	"FindGuild_Button_Simpletooltips( true )" ) -- 길드추천 버튼 툴팁
	findGuild:addInputEvent( "Mouse_Out",	"FindGuild_Button_Simpletooltips( false )" )
	
	findGuild:addInputEvent( "Mouse_LUp",	"HandleClieked_CheckedQuest_WantJoinGuild()" )
	
	findGuild:SetCheck( false )
-- }

-- { 버튼 설명용 버블창
	local _darkSpirit 					= UI.getChildControl ( Panel_CheckedQuest, "Static_DarkSpirit")
	local _darkSpirit_Notice			= UI.getChildControl ( Panel_CheckedQuest, "StaticText_DarkSpirit_Notice")
	local _Notice_NpcNavi 				= UI.getChildControl ( Panel_CheckedQuest, "StaticText_Notice_1")
	local _Notice_GiveUp 				= UI.getChildControl ( Panel_CheckedQuest, "StaticText_Notice_2")
	local _Notice_Reward 				= UI.getChildControl ( Panel_CheckedQuest, "StaticText_Notice_3")
	_Notice_NpcNavi:SetAlpha(0)
	_Notice_NpcNavi:SetFontAlpha(0)
	_Notice_GiveUp:SetAlpha(0)
	_Notice_GiveUp:SetFontAlpha(0)
	_Notice_Reward:SetAlpha(0)
	_Notice_Reward:SetFontAlpha(0)
-- }

-- { 마우스 클릭 도움말
	local _mouseOn_BG 		= UI.getChildControl( Panel_CheckedQuest, "StaticText_Mouse_On")
	local _mouseLeft		= UI.getChildControl( Panel_CheckedQuest, "StaticText_Mouse_Left")
	local _mouseRight		= UI.getChildControl( Panel_CheckedQuest, "StaticText_Mouse_Right")
	local _mouseLeftIcon	= UI.getChildControl( Panel_CheckedQuest, "Static_Mouse_Left")
	local _mouseRightIcon	= UI.getChildControl( Panel_CheckedQuest, "Static_Mouse_Right")
	_mouseOn_BG:SetShow(false)
	_mouseLeft:SetShow(false)
	_mouseRight:SetShow(false)
	_mouseLeftIcon:SetShow(false)
	_mouseRightIcon:SetShow(false)

	local helpWidget = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_CheckedQuest, "HelpWindow_For_QuestWidget" )
	CopyBaseProperty( _Notice_NpcNavi, helpWidget )
	helpWidget:SetColor( ffffffff )
	helpWidget:SetAlpha( 1.0 )
	helpWidget:SetFontColor( UI_color.C_FFC4BEBE )
	helpWidget:SetAutoResize( true )
	helpWidget:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
	helpWidget:SetShow( false )
	helpWidget:SetNotAbleMasking( true )
-- }

-- { 정렬
	local _sortLineBG		= UI.getChildControl( Panel_CheckedQuest, "Static_SortBG" )
	local _sortType			= UI.getChildControl( Panel_CheckedQuest, "button_SortType" )
	local _sortDistanceNear	= UI.getChildControl( Panel_CheckedQuest, "button_SortDistanceNear" )
	local _sortTimeRecent	= UI.getChildControl( Panel_CheckedQuest, "button_SortTimeRecent" )

	_sortLineBG			:SetShow( false )
	_sortType			:SetShow( false )
	_sortDistanceNear	:SetShow( false )
	_sortTimeRecent		:SetShow( false )

	local _sortList	= {
		Distance	= 0,
		TimeRecent	= 1,
		Type		= 2,
	}
	local _sortTexture = {
		[_sortList.Distance] 	= { [0] = { 421, 445, 441, 465 }, { 400, 445, 420, 465 }, { 379, 445, 399, 465 }  },	-- 거리
		[_sortList.TimeRecent]	= { [0] = { 357, 445, 377, 465 }, { 336, 445, 356, 465 }, { 315, 445, 335, 465 }  },	-- 시간
		[_sortList.Type] 		= { [0] = { 485, 445, 505, 465 }, { 464, 445, 484, 465 }, { 443, 445, 463, 465 }  },	-- 타입
	}
	local _sortState = {
		none 		= 0,
		desc		= 1,
		asc			= 2,
	}
	local _sortButtonState = {
		[_sortList.Distance] 	= ToClient_GetCheckedQuestSortType(0),
		[_sortList.TimeRecent]	= ToClient_GetCheckedQuestSortType(1),
		[_sortList.Type] 		= ToClient_GetCheckedQuestSortType(2),
	}

	_sortDistanceNear	:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_SortToggle( " .. 0 .. " )")
	_sortTimeRecent		:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_SortToggle( " .. 1 .. " )")
	_sortType			:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_SortToggle( " .. 2 .. " )")

	_sortDistanceNear	:addInputEvent("Mouse_On",	"QuestWidget_SortTooltip( true,		" .. 0 .. " )")
	_sortDistanceNear	:addInputEvent("Mouse_Out",	"QuestWidget_SortTooltip( false )")
	_sortTimeRecent		:addInputEvent("Mouse_On",	"QuestWidget_SortTooltip( true,		" .. 1 .. " )")
	_sortTimeRecent		:addInputEvent("Mouse_Out",	"QuestWidget_SortTooltip( false )")
	_sortType			:addInputEvent("Mouse_On",	"QuestWidget_SortTooltip( true,		" .. 2 .. " )")
	_sortType			:addInputEvent("Mouse_Out",	"QuestWidget_SortTooltip( false )")

	function HandleClicked_QuestWidget_SortToggle( sortType )
		local controlTypeNo = nil
		if _sortList.Distance == sortType then
			local controlCheck = _sortButtonState[_sortList.Distance]
			if _sortState.none == controlCheck then
				_sortButtonState[_sortList.Distance] = _sortState.desc
			elseif _sortState.desc == controlCheck then
				_sortButtonState[_sortList.Distance] = _sortState.asc
			elseif _sortState.asc == controlCheck then
				_sortButtonState[_sortList.Distance] = _sortState.none
			end
			_QuestWidget_Sort_ChangeTexture( _sortDistanceNear, _sortList.Distance, _sortButtonState[_sortList.Distance] )

		elseif _sortList.TimeRecent == sortType then
			local controlCheck = _sortButtonState[_sortList.TimeRecent]
			if _sortState.none == controlCheck then
				_sortButtonState[_sortList.TimeRecent] = _sortState.desc
			elseif _sortState.desc == controlCheck then
				_sortButtonState[_sortList.TimeRecent] = _sortState.asc
			elseif _sortState.asc == controlCheck then
				_sortButtonState[_sortList.TimeRecent] = _sortState.none
			end
			_QuestWidget_Sort_ChangeTexture( _sortTimeRecent, _sortList.TimeRecent, _sortButtonState[_sortList.TimeRecent] )

		elseif _sortList.Type == sortType then
			local controlCheck = _sortButtonState[_sortList.Type]
			if _sortState.none == controlCheck then
				_sortButtonState[_sortList.Type] = _sortState.desc
			elseif _sortState.desc == controlCheck then
				_sortButtonState[_sortList.Type] = _sortState.asc
			elseif _sortState.asc == controlCheck then
				_sortButtonState[_sortList.Type] = _sortState.none
			end
			_QuestWidget_Sort_ChangeTexture( _sortType, _sortList.Type, _sortButtonState[_sortList.Type] )
		end
		ToClient_SetCheckedQuestSort(_sortButtonState[_sortList.Type], _sortButtonState[_sortList.Distance], _sortButtonState[_sortList.TimeRecent])
	end

	function _QuestWidget_Sort_ChangeTexture( sortControl, controlTypeNo, state )
		sortControl:ChangeTextureInfoName( "New_UI_Common_forLua/Widget/Quest/Quests_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( sortControl, _sortTexture[controlTypeNo][state][1], _sortTexture[controlTypeNo][state][2], _sortTexture[controlTypeNo][state][3], _sortTexture[controlTypeNo][state][4] )
		sortControl:getBaseTexture():setUV(  x1, y1, x2, y2  )
		sortControl:setRenderTexture(sortControl:getBaseTexture())
	end

	function QuestWidget_DefaultTextureFunction()
		_sortButtonState = {
			[_sortList.Distance] 	= ToClient_GetCheckedQuestSortType(0),
			[_sortList.TimeRecent]	= ToClient_GetCheckedQuestSortType(1),
			[_sortList.Type] 		= ToClient_GetCheckedQuestSortType(2),
		}
		_QuestWidget_Sort_ChangeTexture( _sortDistanceNear,	_sortList.Distance,		_sortButtonState[_sortList.Distance] )
		_QuestWidget_Sort_ChangeTexture( _sortTimeRecent,	_sortList.TimeRecent,	_sortButtonState[_sortList.TimeRecent] )
		_QuestWidget_Sort_ChangeTexture( _sortType,			_sortList.Type,			_sortButtonState[_sortList.Type] )
		ToClient_SetCheckedQuestSort(_sortButtonState[_sortList.Type], _sortButtonState[_sortList.Distance], _sortButtonState[_sortList.TimeRecent])
	end
	QuestWidget_DefaultTextureFunction()

	function QuestWidget_SortTooltip( isShow, buttonNo )
		local control	= nil
		local name		= nil
		local desc		= nil
		if true == isShow then
			if 0 == buttonNo then
				control = _sortDistanceNear
				name	= PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_SORTDISTANCENEAR_NAME") -- "정렬 : 거리"
				desc	= PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_SORTDISTANCENEAR_DESC") -- "플레이어의 위치를 기준으로 가장 가까운/먼 순서대로 정렬됩니다."
			elseif 1 == buttonNo then
				control = _sortTimeRecent
				name	= PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_SORTTIMERECENT_NAME") -- "정렬 : 의뢰 수락일"
				desc	= PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_SORTTIMERECENT_DESC") -- "의뢰 수락일이 최근/오래된 순서로 정렬됩니다."
			elseif 2 == buttonNo then
				control = _sortType
				name	= PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_SORTTYPE_NAME") -- "정렬 : 선호 타입"
				desc	= PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_SORTTYPE_DESC") -- "선호하는 타입 단위로 의뢰 목록이 정렬됩니다."
			end
			TooltipSimple_Show( control, name, desc )
		else
			questWidget_MouseOver( false )
			TooltipSimple_Hide()
		end
	end

	function _sortQuest_ButtonSet()
		_sortLineBG			:AddChild( _sortDistanceNear )
		_sortLineBG			:AddChild( _sortTimeRecent )
		_sortLineBG			:AddChild( _sortType )
		Panel_CheckedQuest	:RemoveControl( _sortDistanceNear )
		Panel_CheckedQuest	:RemoveControl( _sortTimeRecent )
		Panel_CheckedQuest	:RemoveControl( _sortType )

		_sortLineBG			:SetPosX( 0 )
		_sortLineBG			:SetPosY( -4 )
		-- _sortLineBG			:SetText( "정렬" )

		_sortType			:SetPosX( 5 )
		_sortDistanceNear	:SetPosX( _sortType:GetPosX() + _sortType:GetSizeX() + 3 )
		_sortTimeRecent		:SetPosX( _sortDistanceNear:GetPosX() + _sortDistanceNear:GetSizeX() + 3 )

		_sortType			:SetPosY( 4 )
		_sortDistanceNear	:SetPosY( 4 )
		_sortTimeRecent		:SetPosY( 4 )

		_sortLineBG			:SetSize( Panel_CheckedQuest:GetSizeX(), _sortLineBG:GetSizeY() )
	end
	_sortQuest_ButtonSet()	
--}

-- { 선호 의뢰 관련 }
	-----------------------------------------------------------
	-- 퀘스트 종류 아이콘 6가지
	-----------------------------------------------------------
	local _favorLineBG		= UI.getChildControl( Panel_CheckedQuest, "Static_FavorLineBG" )
	_favorLineBG		:SetShow( false )

	local MAX_QUEST_FAVOR_TYPE = 6
	local questFavorType = {}
	for ii = 0, MAX_QUEST_FAVOR_TYPE-1, 1 do
		local controlIdNumber = ii+1
		local controlId = "CheckButton_FavorType_" .. tostring(controlIdNumber)
		local control = UI.getChildControl( Panel_CheckedQuest, controlId )
		control:addInputEvent( "Mouse_LUp",	"QuestWidget_SelectQuestFavorType(" .. ii .. ")" )
		control:addInputEvent( "Mouse_On",	"QuestWidget_FavorTypeTooltip( true, " .. ii .. ")" )
		control:addInputEvent( "Mouse_Out",	"QuestWidget_FavorTypeTooltip( false, " .. ii .. ")" )
		control:SetShow( false )
		questFavorType[ii] = control
	end

	function QuestWidget_SelectQuestFavorType(selectType)
		if 0 == selectType then
			_update_QuestWidgetSetCheckAll()
		else
			ToClient_ToggleQuestSelectType( selectType )
		end

		-- 상단 체크 버튼 클릭 시 사운드
		-- audioPostEvent_SystemUi(00,00)	-- 중복됨
		FGlobal_UpdateQuestFavorType()
	end

	function QuestWidget_FavorTypeTooltip( isShow, buttonNo )
		local control	= nil
		local name		= nil
		local desc		= nil
		if true == isShow then
			control = questFavorType[buttonNo]
			if 0 == buttonNo then
				name	= PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_QUESTTYPE_ALL_NAME") -- "의뢰 : 전체"
				desc	= PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_QUESTTYPE_ALL_DESC") -- "NPC에게 받을 수 있는 의뢰 종류를 전체로 설정됩니다."
			elseif 1 == buttonNo then
				name	= PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_QUESTTYPE_COMBAT_NAME") -- "의뢰 : 전투"
				desc	= PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_QUESTTYPE_COMBAT_DESC") -- "NPC에게 받을 수 있는 의뢰 종류를 [전투]로 한정됩니다. 복수 선택 가능."
			elseif 2 == buttonNo then
				name	= PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_QUESTTYPE_LIFE_NAME") -- "의뢰 : 생활"
				desc	= PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_QUESTTYPE_LIFE_DESC") -- "NPC에게 받을 수 있는 의뢰 종류를 [생활]로 한정됩니다. 복수 선택 가능."
			elseif 3 == buttonNo then
				name	= PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_QUESTTYPE_FISH_NAME") -- "의뢰 : 낚시"
				desc	= PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_QUESTTYPE_FISH_DESC") -- "NPC에게 받을 수 있는 의뢰 종류를 [낚시]로 한정됩니다. 복수 선택 가능."
			elseif 4 == buttonNo then
				name	= PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_QUESTTYPE_TRADE_NAME") -- "의뢰 : 탐험/무역"
				desc	= PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_QUESTTYPE_TRADE_DESC") -- "NPC에게 받을 수 있는 의뢰 종류를 [탐험/무역]으로 한정됩니다. 복수 선택 가능."
			elseif 5 == buttonNo then
				name	= PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_QUESTTYPE_ETC_NAME") -- "의뢰 : 기타"
				desc	= PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_QUESTTYPE_ETC_DESC") -- "NPC에게 받을 수 있는 의뢰 종류를 [반복]으로 한정됩니다. 복수 선택 가능."
			end
			TooltipSimple_Show( control, name, desc )
		else
			questWidget_MouseOver( false )
			TooltipSimple_Hide()
		end
	end

	function QuestWidget_ShowSelectQuestFavorType(selectType)
		
		if 0 == selectType then
			local QuestListInfo = ToClient_GetQuestList()
			for ii = 0, MAX_QUEST_FAVOR_TYPE-1, 1 do
				QuestListInfo:setQuestSelectType(ii, true)
				questFavorType[ii]:SetCheck( true )
			end
		else
			local QuestListInfo = ToClient_GetQuestList()
			for ii = 0, MAX_QUEST_FAVOR_TYPE-1, 1 do
				if ii == selectType  then
					QuestListInfo:setQuestSelectType(ii, true)
					questFavorType[ii]:SetCheck( true )
				else
					QuestListInfo:setQuestSelectType(ii, false)
					questFavorType[ii]:SetCheck( false )
				end	
				
			end
			QuestListInfo:setQuestSelectType(0, true)
		end

		FGlobal_UpdateQuestFavorType()
	end

	function _update_QuestWidgetSetCheckAll()
		local isCheck = questFavorType[0]:IsCheck()
		for i = 1, MAX_QUEST_FAVOR_TYPE - 1 do
			if isCheck == ( not questFavorType[i]:IsCheck() ) then
				ToClient_ToggleQuestSelectType( i )
				questFavorType[i]:SetCheck( isCheck )
			end
		end
	end

	function QuestWidget_NationalCheck()
		if isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_RUS ) then
			_update_QuestWidgetSetCheckAll()
		end
	end

	function _updateQuestFavorType()
		if isLuaLoadingComplete then
			updateQuestWindowFavorType()
		end
		updateQuestWidgetFavorType()
	end

	function FGlobal_UpdateQuestFavorType()
		updateQuestWindowFavorType()
		updateQuestWidgetFavorType()
	end

	function updateQuestWidgetFavorType()
		local allButtonCheck = true
		local QuestListInfo = ToClient_GetQuestList()
		for ii = 1, MAX_QUEST_FAVOR_TYPE-1, 1 do
			local bChecked = QuestListInfo:isQuestSelectType(ii)
			questFavorType[ii]:SetCheck(bChecked)
			questFavorType[ii]:SetMonoTone(bChecked)
			if false == bChecked then
				questFavorType[0]:SetMonoTone( true )
				allButtonCheck = false
			end
			if allButtonCheck == true then
				questFavorType[ii]:SetMonoTone( false )
				questFavorType[0]:SetMonoTone( false )
			else
				if bChecked == true then
					questFavorType[ii]:SetMonoTone( false )
				else
					questFavorType[ii]:SetMonoTone( true )
				end
			end
		end
		questFavorType[0]:SetCheck(allButtonCheck)
	end

	function _favorQuest_ButtonSet()
		_favorLineBG		:AddChild( questFavorType[0] )
		_favorLineBG		:AddChild( questFavorType[1] )
		_favorLineBG		:AddChild( questFavorType[2] )
		_favorLineBG		:AddChild( questFavorType[3] )
		_favorLineBG		:AddChild( questFavorType[4] )
		_favorLineBG		:AddChild( questFavorType[5] )

		Panel_CheckedQuest	:RemoveControl( questFavorType[0] )
		Panel_CheckedQuest	:RemoveControl( questFavorType[1] )
		Panel_CheckedQuest	:RemoveControl( questFavorType[2] )
		Panel_CheckedQuest	:RemoveControl( questFavorType[3] )
		Panel_CheckedQuest	:RemoveControl( questFavorType[4] )
		Panel_CheckedQuest	:RemoveControl( questFavorType[5] )

		_favorLineBG		:SetPosX( 165 )
		_favorLineBG		:SetPosY( _sortLineBG:GetPosY() )
		-- _favorLineBG		:SetText( "선호 의뢰" )

		_favorLineBG		:SetShow( true )

		for ii = 0, MAX_QUEST_FAVOR_TYPE-1, 1 do
			if 0 == ii then
				questFavorType[ii]:SetPosX( 0 )
			else
				questFavorType[ii]:SetPosX( questFavorType[ii-1]:GetPosX() + questFavorType[ii-1]:GetSizeX() + 3 )
			end
			questFavorType[ii]:SetPosY( 4 )
		end
		_favorLineBG:SetSize( ( questFavorType[MAX_QUEST_FAVOR_TYPE-1]:GetPosX() + questFavorType[MAX_QUEST_FAVOR_TYPE-1]:GetSizeX() ), _favorLineBG:GetSizeY() )
	end
	_favorQuest_ButtonSet()
	
	function checkedquestIcon( favorIndex )
		ToClient_ToggleQuestSelectType( favorIndex )
	end
--}

-- { 기본 조작 퀘스트에서 재접하는 경우!
	local battleTutorial = {
		{ groupKey = 1017, questKey = 1 },
		{ groupKey = 1025, questKey = 1 },
		{ groupKey = 1029, questKey = 1 },
		{ groupKey = 1021, questKey = 1 },
		{ groupKey = 1033, questKey = 1 },
		{ groupKey = 1037, questKey = 1 },
	}
-- }

-- { 길드 퀘스트 설정
	local guildQuest	= {
		_ControlBG	= UI.getChildControl( Panel_CheckedQuest, "GuildQuest_Static_BG"), 
		_Title		= UI.getChildControl( Panel_CheckedQuest, "GuildQuest_StaticText_Title"), 
		_AutoNavi	= UI.getChildControl( Panel_CheckedQuest, "GuildQuest_CheckButton_AutoNavi"), 
		_Navi		= UI.getChildControl( Panel_CheckedQuest, "GuildQuest_Checkbox_Quest_Navi"), 
		_Reward		= UI.getChildControl( Panel_CheckedQuest, "GuildQuest_Checkbox_Quest_Reward"), 
		_Giveup		= UI.getChildControl( Panel_CheckedQuest, "GuildQuest_Checkbox_Quest_Giveup"), 
		_LimitTime	= UI.getChildControl( Panel_CheckedQuest, "GuildQuest_StaticText_LimitTime"), 
		_Condition	= {
			UI.getChildControl( Panel_CheckedQuest, "GuildQuest_StaticText_Condition1"), 
			UI.getChildControl( Panel_CheckedQuest, "GuildQuest_StaticText_Condition2"), 
			UI.getChildControl( Panel_CheckedQuest, "GuildQuest_StaticText_Condition3"), 
			UI.getChildControl( Panel_CheckedQuest, "GuildQuest_StaticText_Condition4"), 
			UI.getChildControl( Panel_CheckedQuest, "GuildQuest_StaticText_Condition5"), 
		}
		
	}

	guildQuest._ControlBG	:AddChild( guildQuest._Title )
	guildQuest._ControlBG	:AddChild( guildQuest._AutoNavi )
	guildQuest._ControlBG	:AddChild( guildQuest._Navi )
	guildQuest._ControlBG	:AddChild( guildQuest._Reward )
	guildQuest._ControlBG	:AddChild( guildQuest._Giveup )
	guildQuest._ControlBG	:AddChild( guildQuest._LimitTime )
	guildQuest._ControlBG	:AddChild( guildQuest._Condition[1] )
	guildQuest._ControlBG	:AddChild( guildQuest._Condition[2] )
	guildQuest._ControlBG	:AddChild( guildQuest._Condition[3] )
	guildQuest._ControlBG	:AddChild( guildQuest._Condition[4] )
	guildQuest._ControlBG	:AddChild( guildQuest._Condition[5] )
	Panel_CheckedQuest		:RemoveControl( guildQuest._Title )
	Panel_CheckedQuest		:RemoveControl( guildQuest._AutoNavi )
	Panel_CheckedQuest		:RemoveControl( guildQuest._Navi )
	Panel_CheckedQuest		:RemoveControl( guildQuest._Reward )
	Panel_CheckedQuest		:RemoveControl( guildQuest._Giveup )
	Panel_CheckedQuest		:RemoveControl( guildQuest._LimitTime )
	Panel_CheckedQuest		:RemoveControl( guildQuest._Condition[1] )
	Panel_CheckedQuest		:RemoveControl( guildQuest._Condition[2] )
	Panel_CheckedQuest		:RemoveControl( guildQuest._Condition[3] )
	Panel_CheckedQuest		:RemoveControl( guildQuest._Condition[4] )
	Panel_CheckedQuest		:RemoveControl( guildQuest._Condition[5] )
	guildQuest._ControlBG	:SetShow( true )
	guildQuest._ControlBG	:SetAlpha(0)

	for idx = 1, 5 do
		guildQuest._Condition[idx]	:SetShow( false )
		guildQuest._Condition[idx]	:SetAutoResize( true )
		guildQuest._Condition[idx]	:SetTextMode( UI_TM.eTextMode_AutoWrap )
		
		guildQuest._Title:SetFontColor( 4293712127 )
		guildQuest._Title:useGlowFont( true, "BaseFont_10_Glow", 4283243897 )	-- GLOW:길드퀘 의뢰제목
	end

	guildQuest._ControlBG		:addInputEvent("Mouse_On",	"guildQuestWidget_MouseOn( true )")
	guildQuest._ControlBG		:addInputEvent("Mouse_Out",	"guildQuestWidget_MouseOn( false )")
	guildQuest._Reward			:addInputEvent("Mouse_LUp", "HandleCliekedGuildQuestReward()")
	guildQuest._Giveup			:addInputEvent("Mouse_LUp", "HandleClieked_GuildQuestWidget_Giveup()")

	guildQuest._Title			:ComputePos()
	guildQuest._AutoNavi		:ComputePos()
	guildQuest._Navi			:ComputePos()
	guildQuest._Reward			:ComputePos()
	guildQuest._Giveup			:ComputePos()
	guildQuest._LimitTime		:ComputePos()
	guildQuest._Condition[1]	:ComputePos()
	guildQuest._Condition[2]	:ComputePos()
	guildQuest._Condition[3]	:ComputePos()
	guildQuest._Condition[4]	:ComputePos()
	guildQuest._Condition[5]	:ComputePos()
-- }

-- { 기타 설정
	local widgetMouseOn = false
	local groupBGWrapper = {}
	local naviUpdateSkip = false
-- }

function HandleClieked_GuildQuestWidget_Giveup()		-- 길드 퀘스트 포기
	local isGuildMaster		= getSelfPlayer():get():isGuildMaster()
	local isGuildSubMaster	= getSelfPlayer():get():isGuildSubMaster()
	if not isGuildMaster and not isGuildSubMaster then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_GUILDQUEST_GIVEUP") ) -- "길드 대장/부대장만 포기할 수 있습니다.")
		return
	end

	local messageboxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_GIVERUP_MESSAGE_0" ), content = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_GIVERUP_MESSAGE_1" ), functionYes = ToClient_RequestGuildQuestGiveup, functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
	MessageBox.showMessageBox(messageboxData)	
end

function FindGuild_Button_Simpletooltips( isShow )
	local name, desc, control = nil, nil, nil
	if isShow == true then
		control = UI.getChildControl( Panel_CheckedQuest, 	"Button_WantGuild" 	)
		name 	= PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_SIMPLE_TOOLTIP_FINDGUILD_TITLE") -- "길드 추천"
		desc	= PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_SIMPLE_TOOLTIP_FINDGUILD_DESC") -- "길드 추천 목록에 강조되어 표시됩니다."
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end

---------------------------
-- 저장된 위치 획득
---------------------------
function checkedQuestPanel_Init()
	local haveServerPosotion = 0 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_CheckedQuest, chatIndex, CppEnums.PanelSaveType.PanelSaveType_IsSaved)
	if not haveServerPosotion then
		Panel_CheckedQuest:SetSize( 305, 300 )
		local newEquipGap	= 0
		local posY			= 0

		if ( true == Panel_NewEquip:GetShow() ) then
			newEquipGap = Panel_NewEquip:GetSizeY() + 15
		end
		Panel_CheckedQuest	:SetPosY( FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY() + 40 + newEquipGap )
		Panel_CheckedQuest	:SetPosX( getScreenSizeX() - Panel_CheckedQuest:GetSizeX() - 20 )

		panelResizeButton	:SetPosY( Panel_CheckedQuest:GetSizeY() + 10 )
		guideQuestButton	:SetPosY( Panel_CheckedQuest:GetSizeY() - 5 )
		historyButton		:SetPosY( Panel_CheckedQuest:GetSizeY() - 5 )
		findGuild			:SetPosY( Panel_CheckedQuest:GetSizeY() - 5 )
	end
end
checkedQuestPanel_Init()
changePositionBySever(Panel_CheckedQuest, CppEnums.PAGameUIType.PAGameUIPanel_CheckedQuest, true, true, true)

local CheckedQuest_SizeY = Panel_CheckedQuest:GetSizeY()				-- 최대 사이즈 저장용 변수

-----------------------------------------------------------
-- local 임시 변수 설정
-----------------------------------------------------------
QuestListUIPool:initialize(Panel_CheckedQuest, Panel_CheckedQuest)

local _startPosition			= 0				-- 리스트에 첫 번째 퀘스트 번호
local _setLastQuestOfList		= 0				-- 리스트에 마지막 퀘스트 번호
local _questGroupCount			= 0				-- 퀘스트 마지막 그룹 값 저장용
local _next_QuestPosY			= 0				-- 다음 퀘스트 리스트 위치 저장용
local list_Space				= 10			-- 퀘스트 리스트 간격 기본 값
local temp_GroupSizeY			= 200			-- 스크롤 컨트롤 버튼 사이즈 계산을 위한 변수
local _isDontDownScroll 		= false			-- 스크롤을 더 이상 내리지 못하게 만드는 용도
local scrollBarStartPosition	= 20			-- 스크롤바 시작 위치(높이)

local _questGroupId				= 0				-- 네비 체크 전달을 위한 변수
local _questId					= 0				-- 네비 체크 전달을 위한 변수
local _naviInfoAgain			= false			-- 네비 체크 전달을 위한 변수
local _questInfoDetailGroupId	= 0				-- 의뢰 정보창을 위한 변수
local _questInfoDetailQuestId	= 0				-- 의뢰 정보창을 위한 변수
local guideQuestChechk			= false			-- 가이드 퀘스트 체크 해제를 위한 변수
local hasGuildQuest				= false			-- 길드 퀘스트가 있나?
local haveTutorialQuest			= false			-- 조건을 완료했을 때, 리액션을 위한 변수.
local tutorialQuestData			= {
	{groupId = 1017, questId = 3},
	{groupId = 1021, questId = 3},
	{groupId = 1025, questId = 3},
	{groupId = 1029, questId = 3},
	{groupId = 1033, questId = 3},
	{groupId = 1037, questId = 3},
	{groupId = 1002, questId = 3},
}
local haveTutorialQuestList		= {}
local positionList				= {}			-- 선택한 퀘스트 수행 포인트 저장 값.
local autoNaviSelect			= false			-- 퀘스트가 1개일 때, 자동 네비처리용.
local isAutoRun					= false
local isReconnectTutorial		= false
local autoNaviGuide				= {
	groupKey	= 0,
	questKey	= 0,
}


-----------------------------------------------------------
-- 위젯 애니메이션
-----------------------------------------------------------
function QuestListShowAni()
	Panel_CheckedQuest:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_IN)
	local QuestListOpen_Alpha = Panel_CheckedQuest:addColorAnimation( 0.0, 0.35, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	QuestListOpen_Alpha:SetStartColor( UI_color.C_00FFFFFF )
	QuestListOpen_Alpha:SetEndColor( UI_color.C_FFFFFFFF )
	QuestListOpen_Alpha.IsChangeChild = true
end

function QuestListHideAni()
	Panel_CheckedQuest:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
	local QuestListClose_Alpha = Panel_CheckedQuest:addColorAnimation( 0.0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	QuestListClose_Alpha:SetStartColor( UI_color.C_FFFFFFFF )
	QuestListClose_Alpha:SetEndColor( UI_color.C_00FFFFFF )
	QuestListClose_Alpha.IsChangeChild = true
	QuestListClose_Alpha:SetHideAtEnd(true)
	QuestListClose_Alpha:SetDisableWhileAni(true)
end


-----------------------------------------------------------
-- 스크롤 관련
-----------------------------------------------------------
function QuestWidget_ScrollEvent( UpDown )
	local prevPos = _startPosition

	if true == UpDown then							-- 휠을 아래로 돌리면,
		if (true == _isDontDownScroll) then
			return 
		end
		_startPosition = _startPosition + 1
	else											-- 휠을 위로 돌리면, 
		if _startPosition <= 0 then
			return
		end
		_startPosition = _startPosition - 1
	end
	
	if( prevPos ~= _startPosition ) then
		updateQuestWidgetList( _startPosition )
		questWidget_updateScrollPosition()
	end
end

local _scrollBar_LPress_Pos 	= 0 
local _maxscrollBarPos			= 0
function QuestWidget_ScrollLPress()
	-- 스크롤바 위치를 시작 값으로 변환.(반올림=0.5를 더하고 버림)
	local prevPos = _startPosition
	local currentPos = math.floor( ( QuestList_ScrollBar:GetControlPos() * ( _questGroupCount - 1 ) ) + 0.5 )

	if prevPos ~= currentPos then
		if(prevPos < _startPosition and _isDontDownScroll) then
			return 
		end
		_startPosition = currentPos
		updateQuestWidgetList( _startPosition )
	end
end

function questWidget_updateScrollButtonSize()	-- 스크롤바 사이즈를 정한다.
	QuestList_ScrollBar:SetPosY( scrollBarStartPosition )
	QuestList_ScrollBar:SetSize( QuestList_ScrollBar:GetSizeX(), Panel_CheckedQuest:GetSizeY() - scrollBarStartPosition )
	local defaultGap = 0
	if true == hasGuildQuest then
		defaultGap = 90
	else
		defaultGap = 60
	end

	local scrollButtonSizePercent = ( (Panel_CheckedQuest:GetSizeY() / defaultGap ) / _questGroupCount ) * 100
	if( scrollButtonSizePercent < 10) then scrollButtonSizePercent = 10
	elseif( 99 < scrollButtonSizePercent ) then scrollButtonSizePercent = 99 
	end

	QuestList_ScrollBar_CtrBT:SetSize( QuestList_ScrollBar_CtrBT:GetSizeX(), ( (QuestList_ScrollBar:GetSizeY() / 100) * scrollButtonSizePercent) )
end

function questWidget_updateScrollPosition()
	local posY 		= QuestList_ScrollBar:GetSizeY() * ( _startPosition / _questGroupCount )
	local maxPosY	= QuestList_ScrollBar:GetSizeY() -  QuestList_ScrollBar_CtrBT:GetSizeY()
	if( maxPosY < posY ) then
		QuestList_ScrollBar_CtrBT:SetPosY( maxPosY )
	else
		QuestList_ScrollBar_CtrBT:SetPosY( posY )
	end
end


-----------------------------------------------------------
-- 리스트 업데이트
-----------------------------------------------------------
function FromClient_QuestWidget_Update( check )
	_updateQuestFavorType()
	questWidget_updateScrollButtonSize()
	updateQuestWidgetList( _startPosition )
	
	FGlobal_Tutorial_BossSummon_Close()
end

function GuideQuestButton_MouseOnOut( isOut )
	if not getEnableSimpleUI() then
		return;
	end
	
	if isOut then
		guideQuestButton:SetAlpha( 0.7 )
		guideQuestButton:SetFontAlpha( 0.8 )
		historyButton:SetAlpha( 0.7 )
		historyButton:SetFontAlpha( 0.8 )
	else
		guideQuestButton:SetAlpha( 1.0 )
		guideQuestButton:SetFontAlpha( 1.0 )
		historyButton:SetAlpha( 1.0 )
		historyButton:SetFontAlpha( 1.0 )
	end
end

--------------------------------------------------------------------
-- 퀘스트 위젯에서 숨기기
--------------------------------------------------------------------
function HandleClicked_QuestShowCheck( groupId, questId )
	ToClient_ToggleCheckShow( groupId, questId )
	if true == Panel_CheckedQuestInfo:GetShow() then
		Panel_CheckedQuestInfo:SetShow( false )
	end
	_questWidgetHelpPop( false, 0, "hide", 0  )
	-- _questWidgetMouseButton( false )
end

local questNoSaveForTutorial = { _questGroupIndex, _questGroupIdx }		-- 튜토리얼 시작할 때 이전에 갖고 있던 퀘스트 넘버 저장용
local welcomeToTheWorld = true
function updateQuestWidgetList( startPosition )
	if( 0 ~= _maxscrollBarPos ) and ( _maxscrollBarPos < startPosition) then
		startPosition = _maxscrollBarPos
	end
	QuestListUIPool:clear()														-- UIPool 초기화
	helpWidget:SetShow( false )													-- over 된 툴팁 초기화
	-- questWidget_MouseOver( false )												-- over 된 퀘스트 BG 초기화
	
	local doGuideQuestCount		= questList_getDoGuideQuestCount()				-- 가이드 퀘스트 체크
	if 0 < doGuideQuestCount then												-- 가이드 퀘스트 안내 버튼 켜기
		-- guideQuestButton:SetShow( true )
		-- guideQuestNumber:SetShow( true )
		guideQuestButton:SetTextHorizonCenter()
		guideQuestNumber:SetText( doGuideQuestCount ) -- 수행 가능한 의뢰 X개
		-- guideQuestButton:SetPosX( 0 )
		guideQuestButton:SetPosY( Panel_CheckedQuest:GetSizeY() - 5 )
		guideQuestNumber:SetPosX( ( guideQuestButton:GetPosX() + guideQuestButton:GetSizeX() ) - ( guideQuestNumber:GetSizeX() / 2 ) - 7 )
		guideQuestNumber:SetPosY( ( guideQuestButton:GetPosY() + guideQuestButton:GetSizeY() ) - ( guideQuestNumber:GetSizeY() / 2 ) - 7 )
		
		if getEnableSimpleUI() then
			guideQuestButton:SetAlpha( 0.7 )
			guideQuestButton:SetFontAlpha( 0.8 )
			
			guideQuestButton:addInputEvent("Mouse_On", 	"GuideQuestButton_MouseOnOut( false )")
			guideQuestButton:addInputEvent("Mouse_Out", "GuideQuestButton_MouseOnOut( true )")
		end
	else
		guideQuestButton:SetShow( false )
		guideQuestNumber:SetShow( false )
	end

	local isWantGuildJoin = ToClient_GetJoinedMode()
	if 0 == isWantGuildJoin then
		findGuild:SetCheck( true )
	elseif 1 == isWantGuildJoin then
		findGuild:SetCheck( false )
	end

	-- 퀘스트 갯수에 상관 없이 띄워야 하는 버튼은 미리 자리를 잡아 놓는다.
	historyButton:SetPosX( Panel_CheckedQuest:GetSizeX() - historyButton:GetSizeX() )
	historyButton:SetPosY( Panel_CheckedQuest:GetSizeY() - 5 )

	findGuild:SetPosX( 0 )
	findGuild:SetPosY( Panel_CheckedQuest:GetSizeY() - 5  )
	panelResizeButton:SetPosY( historyButton:GetPosY() + 10 )

	local questListInfo 		= ToClient_GetQuestList()
	-- { 한 바퀴 돌려서 진행중인 퀘스트 수를 구한다.
		local temp_questGroupCount	= questListInfo:getQuestCheckedGroupCount()
		local temp_progressCount	= 0
		for questGroupIndex = 0, temp_questGroupCount - 1 do
			questNoSaveForTutorial[temp_progressCount] = { _questGroupIndex, _questGroupIdx }
			local temp_questGroupInfo = questListInfo:getQuestCheckedGroupAt( questGroupIndex )
			if nil ~= temp_questGroupInfo then
				if ( true == temp_questGroupInfo:isGroupQuest() ) then
					local tempGroupCount = temp_questGroupInfo:getQuestCount()
					for questGroupIdx = 0, tempGroupCount - 1 do
						local tempQuestInfo = temp_questGroupInfo:getQuestAt( questGroupIdx )
						local recommandLevel = tempQuestInfo:getRecommendLevel()
						local selfLevel = getSelfPlayer():get():getLevel() + 10
						-- 진행중이냐?
						if tempQuestInfo._isProgressing and not tempQuestInfo._isCleared then
							-- 튜토리얼을 완료하지 않은 캐릭터가 접속 시 탐험/무역/생산/반복 퀘를 갖고 있다면 체크 해제하기 위해 퀘스트 번호를 저장(한 번만 체크)
							if welcomeToTheWorld and not TutorialQuestCompleteCheck() and ( 3 == tempQuestInfo:getQuestType() 
							or 4 == tempQuestInfo:getQuestType() or 5 == tempQuestInfo:getQuestType() or 6 == tempQuestInfo:getQuestType() or selfLevel < recommandLevel ) then
								questNoSaveForTutorial[temp_progressCount]._questGroupIndex = tempQuestInfo:getQuestNo()._group
								questNoSaveForTutorial[temp_progressCount]._questGroupIdx = tempQuestInfo:getQuestNo()._quest
							end
							temp_progressCount = temp_progressCount + 1
						end
					end
				else
					local tempQuestInfo = temp_questGroupInfo:getQuestAt( questGroupIdx )
					local recommandLevel = tempQuestInfo:getRecommendLevel()
					local selfLevel = getSelfPlayer():get():getLevel() + 10
					-- 진행중이냐?
					if tempQuestInfo._isProgressing and not tempQuestInfo._isCleared then
						-- 튜토리얼을 완료하지 않은 캐릭터가 접속 시 탐험/무역/생산/반복 퀘를 갖고 있다면 체크 해제하기 위해 퀘스트 번호를 저장(한 번만 체크)
						if welcomeToTheWorld and not TutorialQuestCompleteCheck() and ( 3 == tempQuestInfo:getQuestType() 
						or 4 == tempQuestInfo:getQuestType() or 5 == tempQuestInfo:getQuestType() or 6 == tempQuestInfo:getQuestType() or selfLevel < recommandLevel ) then
							questNoSaveForTutorial[temp_progressCount]._questGroupIndex = tempQuestInfo:getQuestNo()._group
							questNoSaveForTutorial[temp_progressCount]._questGroupIdx = tempQuestInfo:getQuestNo()._quest
						end
						temp_progressCount = temp_progressCount + 1
					end
				end
			end
		end
		
		-- 접속할 때 이미 체크돼 있는 퀘스트를 체크해제 한다!(튜토리얼용)
		if welcomeToTheWorld and not TutorialQuestCompleteCheck() and 0 < temp_progressCount then
			welcomeToTheWorld = false
			for index = 0, temp_progressCount - 1 do
				ToClient_ToggleCheckShow( questNoSaveForTutorial[index]._questGroupIndex, questNoSaveForTutorial[index]._questGroupIdx ) 
			end
		end
		welcomeToTheWorld = false

		local selfPlayerWrapper = getSelfPlayer()
		if 1 == temp_progressCount and ( nil ~= selfPlayerWrapper ) and (selfPlayerWrapper:get():getLevel() <= 15) then
			autoNaviSelect = true
		elseif false == TutorialQuestCompleteCheck() then
			autoNaviSelect = true
		else
			autoNaviSelect = false
		end
	-- }

	_questGroupCount 			= ( questListInfo:getQuestCheckedGroupCount() - 1 )

	QuestList_ScrollBar:SetInterval( _questGroupCount - 2 )

	_next_QuestPosY = QuestWidget_SetPosition_questFavorTypeY()					-- 선호 퀘스트 위치
	_next_QuestPosY	= QuestWidget_ProgressingGuildQuest( _next_QuestPosY )		-- 길드 퀘스트 위젯을 처리한다.	-- 이게 있으면, 스크롤 사이즈가 달라진다.

	if 0 == ( _questGroupCount + 1) then										-- 새 캐릭터용
		Panel_CheckedQuest:SetIgnore( false )
		-- QuestList_ScrollBar:SetShow( false )
		questWidget_TransBG:SetSize( Panel_CheckedQuest:GetSizeX() + 12, Panel_CheckedQuest:GetSizeY() + 20 )
		return
	else
		Panel_CheckedQuest:SetIgnore( false )

		-- 여기서 스크롤의 위치와 크기를 잡아줘야 한다.
		scrollBarStartPosition = _next_QuestPosY

		for questGroupIndex = startPosition, _questGroupCount, 1 do
			local questGroupInfo 	= questListInfo:getQuestCheckedGroupAt( questGroupIndex )	-- 그룹정보
			if nil == questGroupInfo then
				return
			end
			if ( true == questGroupInfo:isGroupQuest() ) then
				_next_QuestPosY = QuestWidget_GroupQuestInfo( questGroupInfo, _next_QuestPosY, questGroupIndex )
			else
				local uiQuestInfo = questGroupInfo:getQuestAt( 0 )
				_next_QuestPosY = QuestWidget_QuestInfo( questGroupInfo, uiQuestInfo, _next_QuestPosY, true, questGroupIndex, 0, nil, 0 )
			end

			if ( 0 == startPosition ) then
				if ( _next_QuestPosY <= CheckedQuest_SizeY ) then					-- 스크롤바 나오기 전에 리사이즈
					guideQuestButton:SetPosY( Panel_CheckedQuest:GetSizeY() - 5 )
					historyButton:SetPosY( Panel_CheckedQuest:GetSizeY() - 5 )
					findGuild:SetPosY( Panel_CheckedQuest:GetSizeY() - 5 )
					panelResizeButton:SetPosY( Panel_CheckedQuest:GetSizeY() + 10 )
				else
					guideQuestButton:SetPosY( CheckedQuest_SizeY - 5 )
					historyButton:SetPosY( CheckedQuest_SizeY - 5 )
					findGuild:SetPosY( CheckedQuest_SizeY - 5 )
					panelResizeButton:SetPosY( CheckedQuest_SizeY + 10 )
				end
			end

			if (_next_QuestPosY > CheckedQuest_SizeY) then
				_maxscrollBarPos = 0
				_isDontDownScroll = false
				-- QuestList_ScrollBar:SetShow( true )
				break
			else
				_maxscrollBarPos = startPosition
				_isDontDownScroll = true
				if 0 ~= startPosition then
					-- QuestList_ScrollBar:SetShow( true )
				else
					-- QuestList_ScrollBar:SetShow( false )
				end
			end
		end

		QuestList_ScrollBar:SetPosX( Panel_CheckedQuest:GetSizeX()- QuestList_ScrollBar:GetSizeX() )
		questWidget_TransBG:SetSize( Panel_CheckedQuest:GetSizeX() + 12, Panel_CheckedQuest:GetSizeY() + 20 )
		_scrollBar_LPress_Pos	= 0		
	end

	if(0 == _startPosition) then
		questWidget_updateScrollButtonSize()
	end
end

function QuestWidget_ProgressingGuildQuest( _next_QuestPosY )	-- 길드 퀘스트 정보 처리
	local ControlBG_sizeY			= _next_QuestPosY
	local isProgressingGuildQuest	= ToClient_isProgressingGuildQuest()
	local questConditionDefaultPosY	= 40
	if isProgressingGuildQuest then
		guildQuest._AutoNavi		:ComputePos()
		guildQuest._Navi			:ComputePos()
		guildQuest._Reward			:ComputePos()
		guildQuest._Giveup			:ComputePos()

		local isGuildMaster		= getSelfPlayer():get():isGuildMaster()
		local isGuildSubMaster	= getSelfPlayer():get():isGuildSubMaster()
		if isGuildMaster or isGuildSubMaster then
			guildQuest._Giveup:SetShow( true )
		else
			guildQuest._Giveup:SetShow( false )
		end

		for index = 1, 5 do -- 조건 초기화
			guildQuest._Condition[index]:SetShow( false )
			guildQuest._Condition[index]:SetText("")
		end

		guildQuest._ControlBG:SetShow( true )
		guildQuest._ControlBG:SetPosY( ControlBG_sizeY - 5 )

		local guildQuestName	= ToClient_getCurrentGuildQuestName()
		guildQuest._Title:SetText( guildQuestName )

		local remainTime		= ToClient_getCurrentGuildQuestRemainedTime()
		local strMinute			= math.floor(remainTime/60)

		if remainTime <= 0 then
			guildQuest._LimitTime:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_TIMEOUT") ) -- "시간 초과"
		else
			guildQuest._LimitTime:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_REMAINTIME", "time_minute", strMinute ) )
		end

		local questConditionCount		= ToClient_getCurrentGuildQuestConditionCount()
		local completeConditionCount	= 0
		for index = 1, 5 do
			if index <= questConditionCount then
				local currentGuildQuestInfo = ToClient_getCurrentGuildQuestConditionAt( index - 1 )	-- 1번이 0이니까 -1
				guildQuest._Condition[index]:SetShow(true)
				guildQuest._Condition[index]:SetText( "- " .. currentGuildQuestInfo._desc.."("..currentGuildQuestInfo._currentCount.."/"..currentGuildQuestInfo._destCount..")" )
				guildQuest._Condition[index]:SetPosY( questConditionDefaultPosY )

				if currentGuildQuestInfo._destCount <= currentGuildQuestInfo._currentCount  then	-- 조건이 완료됐으면 회색으로!
					guildQuest._Condition[index]:SetFontColor( UI_color.C_FF626262 )
					-- guildQuest._Condition[index]:SetLineRender( true )
					completeConditionCount	= completeConditionCount + 1
				else
					guildQuest._Condition[index]:SetFontColor( UI_color.C_FFC4BEBE )
					-- guildQuest._Condition[index]:SetLineRender( false )
				end
				questConditionDefaultPosY = questConditionDefaultPosY + guildQuest._Condition[index]:GetTextSizeY() + 5
			end
		end

		if completeConditionCount == questConditionCount then
			for index = 1, 5 do
				if index <= questConditionCount then
					guildQuest._Condition[index]:SetFontColor( UI_color.C_FFF26A6A )
					guildQuest._Condition[index]:SetText( "" )
					-- guildQuest._Condition[index]:SetLineRender( true )
				end
			end
			guildQuest._Title:EraseAllEffect()
			guildQuest._Title:AddEffect("UI_Quest_Complete_GoldAura", true, -10, 0)
			
			-- 길드 퀘스트 조건을 모두 완료하면 조건을 지우고 경고 문구를 띄운다
			if 1 < questConditionCount then
				for ii = questConditionCount, 2, -1 do
					questConditionDefaultPosY = questConditionDefaultPosY - guildQuest._Condition[ii]:GetTextSizeY() - 5
				end
			end
			guildQuest._Condition[1]:SetFontColor( Defines.Color.C_FFF26A6A)
			guildQuest._Condition[1]:SetText( " " .. PAGetString(Defines.StringSheet_GAME, "GUILDQUEST_COMPLETE" ))		-- "완료 : 남은 시간 안에만 보상을 받을 수 있습니다.")
		end

		-- 시간 초과 시 퀘스트 컨디션 문구를 바꿔준다.
		if remainTime <= 0 then
			if 1 < questConditionCount then
				for ii = questConditionCount, 2, -1 do
					questConditionDefaultPosY = questConditionDefaultPosY - guildQuest._Condition[ii]:GetTextSizeY() - 5
				end
			end
		
			guildQuest._Condition[1]:SetFontColor( Defines.Color.C_FFF26A6A)
			guildQuest._Condition[1]:SetText( PAGetString(Defines.StringSheet_GAME, "GUILDQUEST_TIMEOVER" )) -- "- 시간을 초과해 더 이상 임무를 진행할 수 없습니다." )
		end

		guildQuest._ControlBG:SetSize( guildQuest._ControlBG:GetSizeX(), questConditionDefaultPosY ) -- 배경을 잡는다.
		hasGuildQuest = true

		return guildQuest._ControlBG:GetSizeY() + 50, hasGuildQuest
	else
		guildQuest._ControlBG:SetShow( false )
		hasGuildQuest = false
		return _next_QuestPosY, hasGuildQuest
	end
end

local elapsedTime = 0
function QuestWidget_ProgressingGuildQuest_UpdateRemainTime( deltaTime )
	elapsedTime = elapsedTime + deltaTime

	if elapsedTime < 5 then
		return
	end

	if not ToClient_isProgressingGuildQuest() then
		return
	end

	local remainTime		= ToClient_getCurrentGuildQuestRemainedTime()
	local strMinute			= math.floor(remainTime/60)
	if remainTime <= 0 then
		guildQuest._LimitTime:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_TIMEOUT") ) -- "시간 초과"
	else
		guildQuest._LimitTime:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_REMAINTIME", "time_minute", strMinute ) )
	end

	elapsedTime = 0
end
Panel_CheckedQuest:RegisterUpdateFunc("QuestWidget_ProgressingGuildQuest_UpdateRemainTime")


function QuestWidget_SetPosition_questFavorTypeY()
	return _favorLineBG:GetPosY() + _favorLineBG:GetSizeY() + 10
end


-----------------------------------------------------------
-- 그룹 퀘스트의 그룹 정보
-----------------------------------------------------------
function QuestWidget_GroupQuestInfo( questGroupInfo, _next_QuestPosY, questGroupIndex )
	local tmp_next_GroupPosY 	= _next_QuestPosY
	local tmp_Quest_ClearCount 	= 0									-- 퀘스트 완료수 체크용 변수
	local tmp_Quest_Clear 		= 0									-- 퀘스트 함수에서 넘어오는 완료수 임시 변수

	--------------------------------------------------------------------
	-- 그룹 퀘스트 타이틀 설정
	--------------------------------------------------------------------		
	local questGroupTitle			= questGroupInfo:getTitle()
	local questGroupCount			= questGroupInfo:getTotalQuestCount()

	--------------------------------------------------------------------
	-- 퀘스트 정보
	--------------------------------------------------------------------
	for questIndex = 0, questGroupInfo:getQuestCount() - 1, 1 do
		-- 퀘스트 정보
		local uiQuestInfo = questGroupInfo:getQuestAt( questIndex )
		tmp_next_GroupPosY, tmp_Quest_Clear = QuestWidget_QuestInfo( questGroupInfo, uiQuestInfo, tmp_next_GroupPosY, false, questGroupIndex, questIndex, questGroupTitle, questGroupCount )
		tmp_Quest_ClearCount = tmp_Quest_ClearCount + tmp_Quest_Clear				-- 퀘스트 완료수 카운트
	end

	return tmp_next_GroupPosY
end
-----------------------------------------------------------
-- 퀘스트 정보
-----------------------------------------------------------
function QuestWidget_QuestInfo( questGroupInfo, uiQuestInfo, _next_QuestPosY, isSingle, questGroupIndex, questIndex, groupTitle, questGroupCount )
	local tmp_next_QuestPosY 		= _next_QuestPosY
	local questCondition_Check		= {}
	local questCondition_AllCheck	= 0
	local tmp_Quest_Clear 			= 0											-- 퀘스트 완료 여부 저장 변수
	
	local questGroupId				= uiQuestInfo:getQuestNo()._group
	local questId					= uiQuestInfo:getQuestNo()._quest
	-- for chkIdx = 1, #tutorialQuestData do
		-- if tutorialQuestData[chkIdx].groupId == questGroupId and tutorialQuestData[chkIdx].questId == questId then
			-- if uiQuestInfo:isSatisfied() and nil == haveTutorialQuestList[questGroupId] then
				-- haveTutorialQuestList[questGroupId]				= {}
				-- haveTutorialQuestList[questGroupId][questId]	= true
				-- questWidget_Play_Tutorial_NaviCtrl()
			-- end
		-- end
	-- end

	if true == uiQuestInfo._isCleared then										-- 클리어 했으면
		tmp_Quest_Clear = tmp_Quest_Clear + 1
		-- tmp_next_QuestPosY, tmp_Quest_Clear = _questWidgetInfo_Cleared( uiQuestInfo, tmp_next_QuestPosY, tmp_Quest_Clear )
		-- 나중을 위해 지우지 않음
	elseif (false == uiQuestInfo._isCleared) and (false == uiQuestInfo._isProgressing) then 	-- 클리어 안했고 진행중도 아니면
		-- tmp_next_QuestPosY = _questWidgetInfo_Next( uiQuestInfo, questGroupId, questId, tmp_next_QuestPosY )
		-- 나중을 위해 지우지 않음
	else																		-- 진행 중이면		
		tmp_next_QuestPosY = _questWidgetInfo_Progressing( questGroupInfo, uiQuestInfo, questGroupId, questId, tmp_next_QuestPosY, isSingle, groupTitle, questGroupCount, questGroupIndex )
	end

	return tmp_next_QuestPosY, tmp_Quest_Clear
end

-----------------------------------------------------------
-- 퀘스트 정보(완료된 경우)
-----------------------------------------------------------
function _questWidgetInfo_Cleared( uiQuestInfo, tmp_next_QuestPosY, tmp_Quest_Clear )
	-- 퀘스트 제목
	local uiQuestTypeIcon 			= QuestListUIPool:newQuestTypeIcon()
	uiQuestTypeIcon:SetPosY( tmp_next_QuestPosY - 6 )
	uiQuestTypeIcon:SetShow( true )

	FGlobal_ChangeOnTextureForDialogQuestIcon(uiQuestTypeIcon, uiQuestInfo:getQuestType())		-- 타입에 맞춰 아이콘 변경
	
	tmp_next_QuestPosY = tmp_next_QuestPosY + 4

	local uiQuestTitleBG 			= QuestListUIPool:newQuestTitleBG()
	local questTitle 				= uiQuestInfo:getTitle()
	local uiQuestTitle 				= QuestListUIPool:newQuestTitle()
	uiQuestTitleBG:SetPosY( tmp_next_QuestPosY - 10 )
	uiQuestTitleBG:SetShow( true )
	uiQuestTitle:SetText( questTitle )
	uiQuestTitle:SetFontColor( UI_color.C_FFC4BEBE )
	uiQuestTitle:SetPosY( tmp_next_QuestPosY - list_Space )
	uiQuestTitle:SetLineRender(true)
	uiQuestTitle:SetShow( true )

	if true == isSingle then													-- 단일 퀘스트면 들여쓰기
		uiQuestTitleBG:SetPosX( 40 )
		uiQuestTitle:SetPosX( 65 )
		uiQuestTypeIcon:SetPosX( 45 )
	else
		uiQuestTitleBG:SetPosX( 50 )
		uiQuestTitle:SetPosX( 75 )
		uiQuestTypeIcon:SetPosX( 55 )
	end

	tmp_Quest_Clear = tmp_Quest_Clear + 1										-- 퀘스트 클리어 카운트
	tmp_next_QuestPosY = tmp_next_QuestPosY + ( list_Space * 2 )

	return tmp_next_QuestPosY, tmp_Quest_Clear									-- 다음 위치 값과 클리어 카운트 반환
end
-----------------------------------------------------------
-- 퀘스트 정보(받지 않은 다음 퀘스트)
-----------------------------------------------------------
function _questWidgetInfo_Next( uiQuestInfo, questGroupId, questId, tmp_next_QuestPosY )
	local uiQuestTypeIcon 			= QuestListUIPool:newQuestTypeIcon()
	uiQuestTypeIcon:SetPosY( tmp_next_QuestPosY - 6 )
	uiQuestTypeIcon:SetShow( true )
	FGlobal_ChangeOnTextureForDialogQuestIcon(uiQuestTypeIcon, uiQuestInfo:getQuestType())		-- 타입에 맞춰 아이콘 변경
	tmp_next_QuestPosY = tmp_next_QuestPosY + 4

	local uiQuestTitleBG 			= QuestListUIPool:newQuestTitleBG()
	local uiQuestTitle 				= QuestListUIPool:newQuestTitle()
	uiQuestTitleBG:SetPosY( tmp_next_QuestPosY - 10 )
	uiQuestTitleBG:SetShow( true )
	uiQuestTitle:SetPosY( tmp_next_QuestPosY - list_Space )
	uiQuestTitle:SetLineRender(false)
	uiQuestTitle:SetShow( true )

	if 0 == uiQuestInfo:getQuestType() then
		uiQuestTitle:SetFontColor( UI_color.C_FF88DF00 )
		uiQuestTitle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_NEXTQUEST_NOTYET_BLACKSPIRIT") ) -- 조건이 만족되면 흑정령에게 받을 수 있습니다.
	else
		uiQuestTitle:SetFontColor( UI_color.C_FFFFEEA0 )
		uiQuestTitle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_NEXTQUEST_NOTYET_OTHER") ) -- 아직 의뢰 받지 않았습니다.
		-- 이 부분을 수정.
	end

	local uiQuestAutoNaviButton 	= QuestListUIPool:newQuestAutoNaviButton()
	local uiQuestNaviButton 		= QuestListUIPool:newQuestNaviButton()

	-- 흑정령 퀘스트가 아니라면 노출
	-- 오토 런
	if 0 ~= uiQuestInfo:getQuestType() then
		uiQuestAutoNaviButton:SetPosY( tmp_next_QuestPosY - 8 )
		uiQuestAutoNaviButton:SetShow( true )
		uiQuestAutoNaviButton:addInputEvent("Mouse_On", "QuestAutoNpcNavi_Over( true )")
		uiQuestAutoNaviButton:addInputEvent("Mouse_Out", "QuestAutoNpcNavi_Over( false )")
		uiQuestAutoNaviButton:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_FindTarget( " .. questGroupId .. ", " .. questId .. ", " .. 99 .. ", true )")
		if _questGroupId == questGroupId and _questId == questId then
			if true == _naviInfoAgain then
				uiQuestTitleBG:SetShow( false )
				uiQuestAutoNaviButton:SetCheck( false )
				uiQuestNaviButton:SetCheck( false )
				groupBG1:SetShow( false )
			else
				groupBG1:SetShow( true )
				uiQuestTitleBG:SetShow( true )
				if ( uiQuestAutoNaviButton:IsCheck() == true ) then
					uiQuestAutoNaviButton:SetCheck( true )
					uiQuestNaviButton:SetCheck( true )
				else
					uiQuestAutoNaviButton:SetCheck( false )
					uiQuestNaviButton:SetCheck( true )
				end
			end
		else
			uiQuestTitleBG:SetShow( false )
			uiQuestAutoNaviButton:SetCheck( false )
			uiQuestNaviButton:SetCheck( false )
		end
	end
	
	-- 길만 찾기
	if 0 ~= uiQuestInfo:getQuestType() then
		uiQuestNaviButton:SetPosY( tmp_next_QuestPosY - 8 )
		uiQuestNaviButton:SetShow( true )
		uiQuestNaviButton:addInputEvent("Mouse_On", "QuestNpcNavi_Over( true )")
		uiQuestNaviButton:addInputEvent("Mouse_Out", "QuestNpcNavi_Over( false )")
		uiQuestNaviButton:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_FindTarget( " .. questGroupId .. ", " .. questId .. ", " .. 99 .. ", false )")
		
		if _questGroupId == questGroupId and _questId == questId then
			if true == _naviInfoAgain then
				uiQuestTitleBG:SetShow( false )
				uiQuestAutoNaviButton:SetCheck( false )
				uiQuestNaviButton:SetCheck( false )
				groupBG1:SetShow( false )
			else
				uiQuestTitleBG:SetShow( true )
				groupBG1:SetShow( true )
				if ( uiQuestAutoNaviButton:IsCheck() == true ) then
					uiQuestAutoNaviButton:SetCheck( true )
					uiQuestNaviButton:SetCheck( true )
				else
					uiQuestAutoNaviButton:SetCheck( false )
					uiQuestNaviButton:SetCheck( true )
				end
			end
		else
			uiQuestTitleBG:SetShow( false )
			uiQuestAutoNaviButton:SetCheck( false )
			uiQuestNaviButton:SetCheck( false )
		end
	end

	if true == isSingle then													-- 단일 퀘스트면 들여쓰기
		uiQuestTitleBG:SetPosX( 40 )
		uiQuestTitle:SetPosX( 65 )
		uiQuestTypeIcon:SetPosX( 45 )
	else
		uiQuestTitleBG:SetPosX( 50 )
		uiQuestTitle:SetPosX( 75 )
		uiQuestTypeIcon:SetPosX( 55 )
	end

	tmp_next_QuestPosY = tmp_next_QuestPosY + ( list_Space * 2 )

	return tmp_next_QuestPosY													-- 다음 위치 값 반환
end
-----------------------------------------------------------
-- 퀘스트 정보(진행중인 퀘스트)
-----------------------------------------------------------
function _questWidgetInfo_Progressing( questGroupInfo, uiQuestInfo, questGroupId, questId, tmp_next_QuestPosY, isSingle, groupTitle, questGroupCount, questGroupIndex )
	if nil == getSelfPlayer() then
		return
	end

	----------------------------------------------------------------------------
	-- 배틀 튜토리얼 중 나갔나?
	----------------------------------------------------------------------------
	if false == isReconnectTutorial then
		for battleTutorial_Idx = 1, #battleTutorial do
			local chkGroupKey = battleTutorial[battleTutorial_Idx].groupKey
			local chkQuestKey = battleTutorial[battleTutorial_Idx].questKey

			if chkGroupKey == questGroupId and chkQuestKey == questId then
				isReconnectTutorial = true
				break
			else
				isReconnectTutorial = false
			end
		end
	end

	if (true == isReconnectTutorial) and (not isFlushedUI() ) and ( true == isLuaLoadingComplete ) then
		if false == FGlobal_BattleTutorial_CompleteCheck() then
			FirstTime_Tutorial()
			Panel_Tutorial_Battle_Start()
			Panel_MovieTheater_LowLevel_WindowClose()
			if nil ~= getSelfPlayer() then
				if CppEnums.ClassType.ClassType_Sorcerer == getSelfPlayer():getClassType() then		 -- 소서러만 어둠의 조각 카운트 UI를 켜줌
					Panel_ClassResource:SetShow( true  )
				else
					Panel_ClassResource:SetShow( false )
				end
			end
		end
	end
	-- 배틀 튜토리얼 체크 끝
	----------------------------------------------------------------------------

	local selfLevel = getSelfPlayer():get():getLevel()
	local groupBGSizeY = 0
	local questCondition_Chk = nil												-- 퀘스트 컨디션 체크
	if true == uiQuestInfo:isSatisfied() then
		questCondition_Chk = 0
	else
		questCondition_Chk = 1
	end

	if nil == groupTitle then
		groupTitle = "nil"
	end

	local groupBG = QuestListUIPool:newGroupBG()								-- 퀘스트별 BG를 만든다.
	groupBG:SetAlpha (0)
	local groupBG_StartPosY = tmp_next_QuestPosY - 7
	groupBG:SetPosX( 3 )
	groupBG:SetPosY( groupBG_StartPosY )
	
	local groupBG1 = QuestListUIPool:newGroupBG1()								-- 퀘스트별 BG를 만든다.
	groupBG1:SetPosX( 3 )
	groupBG1:SetPosY( groupBG_StartPosY )

	local groupBG2 = QuestListUIPool:newGroupBG2()								-- 퀘스트별 BG를 만든다.
	groupBG2:SetPosX( 3 )
	groupBG2:SetPosY( groupBG_StartPosY )
	--groupBG2:SetShow( false )

	groupBG:ChangeTextureInfoName ( "New_UI_Common_forLua/Default/BlackPanel_Series.dds" )
	local x1, y1, x2, y2 = setTextureUV_Func( groupBG, 127, 127, 189, 189 )
	groupBG:getBaseTexture():setUV(  x1, y1, x2, y2  )
	groupBG:setRenderTexture(groupBG:getBaseTexture())

	-- groupBG1:ChangeTextureInfoName( "New_UI_Common_forLua/Default/BlackPanel_Series.dds" )
	-- local x1, y1, x2, y2 = setTextureUV_Func( groupBG1, 1, 64, 63, 126 )
	-- groupBG1:getBaseTexture():setUV(  x1, y1, x2, y2  )
	-- groupBG1:setRenderTexture(groupBG1:getBaseTexture())

	local uiQuestTypeIcon 			= QuestListUIPool:newQuestTypeIcon()
	uiQuestTypeIcon:EraseAllEffect()
	uiQuestTypeIcon:SetPosY( tmp_next_QuestPosY - 6 )
	uiQuestTypeIcon:SetShow( true )
	uiQuestTypeIcon:SetIgnore( true )
	FGlobal_ChangeOnTextureForDialogQuestIcon(uiQuestTypeIcon, uiQuestInfo:getQuestType())		-- 타입에 맞춰 아이콘 변경

	local uiQuestTitleBG 			= QuestListUIPool:newQuestTitleBG()

	local questTitle 				= uiQuestInfo:getTitle()
	local recommandLevel			= uiQuestInfo:getRecommendLevel()
	local selfPlayerLevel			= getSelfPlayer():get():getLevel()
	
	if nil ~= recommandLevel and 0 ~= recommandLevel then
		questTitle = "[Lv." .. recommandLevel .. "] " .. questTitle
	end

	local uiQuestTitle 				= QuestListUIPool:newQuestTitle()
	uiQuestTitleBG:SetPosY( tmp_next_QuestPosY - 6 )
	uiQuestTitleBG:SetShow( false )

	if 0 == uiQuestInfo:getQuestType() then
		uiQuestTitle:SetFontColor( 4294565318 )
		uiQuestTitle:useGlowFont( true, "BaseFont_8_Glow", 4287317548 )	-- GLOW:흑정령 퀘스트 의뢰제목
	else
		uiQuestTitle:SetFontColor( 4294574047 )
		uiQuestTitle:useGlowFont( true, "BaseFont_8_Glow", 4283917312 )	-- GLOW:일반 퀘스트 의뢰제목
	end
	
	uiQuestTitle:SetAutoResize(true)
	-- uiQuestTitle:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
	uiQuestTitle:SetTextMode( CppEnums.TextMode.eTextMode_LimitText )
	uiQuestTitle:SetSize( 200, uiQuestTitle:GetSizeY() )
	uiQuestTitle:SetText( questTitle )
	uiQuestTitle:SetPosY( tmp_next_QuestPosY - 6 )
	uiQuestTitle:SetLineRender(false)
	uiQuestTitle:SetShow( true )
	uiQuestTitle:SetIgnore( true )

	uiQuestTitle:SetFontColor( UI_color.C_FFEFEFEF )
	uiQuestTitle:useGlowFont( true, "BaseFont_10_Glow", 4287655978 )	-- GLOW:의뢰제목

	local uiQuestHideButton 		= QuestListUIPool:newQuestHideButton()
	uiQuestHideButton:SetPosY( tmp_next_QuestPosY - 6 )
	if 10 < selfLevel then
		uiQuestHideButton:SetShow( widgetMouseOn )
	else
		uiQuestHideButton:SetShow( false )
	end
	-- 버튼 UI idx 필요함.

	if true == isSingle then	-- 그룹 퀘스트는 0으로 넘겨야 한다.
		uiQuestHideButton:addInputEvent( "Mouse_LUp", "HandleClicked_QuestShowCheck(" .. questGroupId .. "," .. questId .. ")" )
		-- if false == TutorialQuestCompleteCheck() and haveQuestCheck( questGroupId, questId ) then	-- 튜토리얼을 마치지 않았으면, 이전퀘는 체크 해제
			-- HandleClicked_QuestShowCheck( questGroupId, questId )
		-- end
	else
		uiQuestHideButton:addInputEvent( "Mouse_LUp", "HandleClicked_QuestShowCheck(" .. questGroupId .. "," .. 0 .. ")" )
		-- if false == TutorialQuestCompleteCheck() and haveQuestCheck( questGroupId, 0 ) then
			-- HandleClicked_QuestShowCheck( questGroupId, 0 )
		-- end
	end
	
	
	local _uiQuestHideButtonPosY = uiQuestHideButton:GetPosY()
	uiQuestHideButton:addInputEvent("Mouse_On", 		"_questWidgetHelpPop( true," .. _uiQuestHideButtonPosY .. ", \"hide\", " .. QuestListUIPool._countGroupBG .. "  )")
	uiQuestHideButton:addInputEvent("Mouse_Out", 		"_questWidgetHelpPop( false," .. _uiQuestHideButtonPosY .. ", \"hide\", " .. QuestListUIPool._countGroupBG .. "  )")

	local uiQuestGiveupButton			= QuestListUIPool:newQuestGiveupButton()
	uiQuestGiveupButton:SetPosY( tmp_next_QuestPosY - 6 )
	if 10 < selfLevel then
		uiQuestGiveupButton:SetShow( widgetMouseOn )
	else
		uiQuestGiveupButton:SetShow( false )
	end
	local _uiQuestGiveupButtonPosY = uiQuestGiveupButton:GetPosY()
	uiQuestGiveupButton:addInputEvent( "Mouse_LUp", "HandleClicked_QuestWidget_QuestGiveUp( " .. questGroupId .. "," .. questId .. " )")
	uiQuestGiveupButton:addInputEvent("Mouse_On", 		"_questWidgetHelpPop( true," .. _uiQuestGiveupButtonPosY .. ", \"giveup\", " .. QuestListUIPool._countGroupBG .. "  )")
	uiQuestGiveupButton:addInputEvent("Mouse_Out", 		"_questWidgetHelpPop( false," .. _uiQuestGiveupButtonPosY .. ", \"giveup\", " .. QuestListUIPool._countGroupBG .. "  )")

	local uiQuestAutoNaviButton 		= QuestListUIPool:newQuestAutoNaviButton()		-- 나머지 세팅은 아래에서
	uiQuestAutoNaviButton:SetPosY( tmp_next_QuestPosY - 6 )
	
	local uiQuestNaviButton 		= QuestListUIPool:newQuestNaviButton()		-- 나머지 세팅은 아래에서
	uiQuestNaviButton:SetPosY( tmp_next_QuestPosY - 6 )
	tmp_next_QuestPosY = tmp_next_QuestPosY + 7

	if ( IsNaviTutorial() ) then				-- 길찾기 튜토리얼 퀘스트에서 <ctrl> 누른 순간에 true / 길찾기 버튼 누르면 false
		uiQuestAutoNaviButton:EraseAllEffect()
		uiQuestNaviButton:EraseAllEffect()
		uiQuestAutoNaviButton:AddEffect( "fUI_FindRoute_Light02", true, 0, 0 )
		-- uiQuestNaviButton:AddEffect( "fUI_FindRoute_Light01", true, 0, 0 )			-- 안내선이 자동으로 뿌려져 오토내비에만 이펙트
		FGlobal_Tutorial_QuestMasking_Show( uiQuestAutoNaviButton:GetPosX(), uiQuestAutoNaviButton:GetPosY())
	else
		uiQuestAutoNaviButton:EraseAllEffect()
		uiQuestNaviButton:EraseAllEffect()
	end

	local uiGroupInfomation
	if false == isSingle then
		local groupQuestTitleInfo = groupTitle .. " (" .. questId .. "/" .. questGroupCount .. ")"
		uiGroupInfomation		= QuestListUIPool:WidgetGroupTitle()
		uiGroupInfomation:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_QUESTWIDGET_GROUPTITLEINFO", "titleinfo", groupQuestTitleInfo ) ) -- [연속] 타이틀명(2/3)
		uiGroupInfomation:SetSize( 230, uiQuestTitle:GetSizeY() )
		uiGroupInfomation:SetAutoResize(true)
		uiGroupInfomation:SetTextMode( CppEnums.TextMode.eTextMode_LimitText )
		uiGroupInfomation:SetPosX( 25 )
		uiGroupInfomation:SetPosY( tmp_next_QuestPosY + list_Space )
		uiGroupInfomation:SetFontColor( UI_color.C_FFEDE699 )
		uiGroupInfomation:SetShow( true )
		uiGroupInfomation:SetIgnore( true )
		tmp_next_QuestPosY = tmp_next_QuestPosY + uiGroupInfomation:GetSizeY()
	end

	-- X좌표 보정(퀘스트 창과 같이 쓰기 때문)
	uiQuestTitleBG:SetPosX( 0 )
	uiQuestTitle:SetPosX( 25 )
	uiQuestTypeIcon:SetPosX( 5 )

	-- 마우스 포인터 위치를 감지해 올려 있다면, 확대한 위치에 둔다.
	local panelPosX = Panel_CheckedQuest:GetPosX()
	local panelPosY = Panel_CheckedQuest:GetPosY()
	local bgPosX	= groupBG:GetPosX() + panelPosX
	local bgPosY	= groupBG:GetPosY() + panelPosY
	local bgSizeX	= groupBG:GetSizeX()
	local bgSizeY	= groupBG:GetSizeY()
	local mousePosX	= getMousePosX()
	local mousePosY	= getMousePosY()
	if( (bgPosX <= mousePosX) and (mousePosX <= (bgPosX + bgSizeX) )
		and (bgPosY <= mousePosY) and (mousePosY <= (bgPosY + bgSizeY)) ) then
		uiQuestHideButton		:SetPosX( 192 )
		uiQuestGiveupButton		:SetPosX( 219 )
		uiQuestNaviButton		:SetPosX( 246 )
		uiQuestAutoNaviButton	:SetPosX( 273 )
	else
		uiQuestHideButton		:SetPosX( 220 )
		uiQuestGiveupButton		:SetPosX( 240 )
		uiQuestAutoNaviButton	:SetPosX( 280 )
		uiQuestNaviButton		:SetPosX( 260 )
	end
	
	tmp_next_QuestPosY = tmp_next_QuestPosY + list_Space

	--------------------------------------------------------------------
	-- 퀘스트 완료 조건
	--------------------------------------------------------------------
	local uiQuestCondition
	if 1 == questCondition_Chk then
		for conditionIndex = 0, uiQuestInfo:getDemandCount() - 1, 1 do
			local questCondition = uiQuestInfo:getDemandAt( conditionIndex )
			uiQuestCondition = QuestListUIPool:newQuestCondition()
			uiQuestCondition:SetAutoResize(true)
			uiQuestCondition:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
			uiQuestCondition:SetFontColor( UI_color.C_FFC4BEBE )
			local conditionText = nil
			if (questCondition._currentCount == questCondition._destCount) or ( questCondition._destCount <= questCondition._currentCount ) then
				conditionText = "- " .. questCondition._desc .. " (" .. PAGetString(Defines.StringSheet_GAME, "DIALOG_BUTTON_QUEST_COMPLETE") .. ")"
				uiQuestCondition:SetText( conditionText )
				uiQuestCondition:SetLineRender( true )
				uiQuestCondition:SetFontColor( UI_color.C_FF626262 )
				uiQuestCondition:SetPosY( tmp_next_QuestPosY )
			elseif 1 == questCondition._destCount then
				conditionText = "- " .. questCondition._desc
				uiQuestCondition:SetText( conditionText )
				uiQuestCondition:SetLineRender( false )
				uiQuestCondition:SetPosY( tmp_next_QuestPosY )
			else
				conditionText = "- " .. questCondition._desc .. " (" .. questCondition._currentCount .. "/" .. questCondition._destCount .. ")"
				uiQuestCondition:SetText( conditionText )
				uiQuestCondition:SetLineRender( false )
				uiQuestCondition:SetPosY( tmp_next_QuestPosY + 2 )
			end
			
			uiQuestCondition:SetPosX( 25 )
			uiQuestCondition:SetSize( 250, uiQuestCondition:GetTextSizeY() )
			uiQuestCondition:SetShow( true )
			uiQuestCondition:SetIgnore( true )
			tmp_next_QuestPosY = tmp_next_QuestPosY + uiQuestCondition:GetSizeY() + 2
			groupBGSizeY = groupBGSizeY + uiQuestCondition:GetSizeY()
		end
	elseif 0 == questCondition_Chk then
		local questCompleteNpc 			= uiQuestInfo:getCompleteDisplay()
		local uiQuestCompleteNpc 		= QuestListUIPool:newCompleteDest()
		
		-- 완료된 퀘스트 돋보이게!
		if 0 == uiQuestInfo:getQuestType() then
			uiQuestTypeIcon:AddEffect("UI_Quest_Complete_GoldAura", true, 130, 0)
			uiQuestCompleteNpc:SetText( " " .. PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_QUESTCOMPLETENPC") ) -- ' 완료 : 우클릭으로, 길을 찾거나 완료하세요.' ) -- 완료 대상 : 이고르
			-- uiQuestCompleteNpc:SetFontColor( Defines.Color.C_FFF26A6A )			-- 흑정령인 경우
			uiQuestCompleteNpc:SetFontColor( Defines.Color.C_FFF26A6A )			-- 흑정령인 경우
			-- _questWidget_ChangeTextureForBlackSpirit( 1, uiQuestCompleteNpc )
		elseif 0 < uiQuestInfo:getQuestType() then
			uiQuestTypeIcon:AddEffect("UI_Quest_Complete_GreenAura", true, 130, 0)
			uiQuestCompleteNpc:SetText( " " .. PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_QUESTCOMPLETENPC") ) -- " 완료 : 우클릭으로, 길을 찾거나 완료하세요." ) -- 완료 대상 : 이고르	
			uiQuestCompleteNpc:SetFontColor( Defines.Color.C_FFF26A6A )		-- 완료 대상의 경우
			-- _questWidget_ChangeTextureForBlackSpirit( 2, uiQuestCompleteNpc )
		end
		

		if questGroupId == positionList._questGroupId and questId == positionList._questId then	-- 찍어 놓은 퀘스트 조건을 완료했다면, 네비를 지운다.
			-- ToClient_DeleteNaviGuideByGroup(0);
			positionList = {}
			
			if not uiQuestInfo:isCompleteBlackSpirit() then	-- 완료 NPC가 흑정령이 아니라면 네비를 찍어주자.
				_questGroupId	= 0
				_questId		= 0
				HandleClicked_QuestWidget_FindTarget( questGroupId, questId, 0, false )
			end
		end

		uiQuestCompleteNpc:SetPosY( tmp_next_QuestPosY )
		uiQuestCompleteNpc:SetPosX( 25 )
		uiQuestCompleteNpc:SetShow( true )
		
		uiQuestCompleteNpc:SetLineRender( true )
		uiQuestCompleteNpc:SetIgnore( true )
		FGlobal_ChangeOnTextureForDialogQuestIcon(uiQuestTypeIcon, 7)	-- 완료 아이콘으로 변경

		if false == isSingle then
			uiGroupInfomation:SetFontColor( UI_color.C_FFF26A6A )
		end

		tmp_next_QuestPosY = tmp_next_QuestPosY + uiQuestCompleteNpc:GetSizeY() + 2
	end

	local questPosCount = uiQuestInfo:getQuestPositionCount()

	-- 네비 클릭 판별
	if _questGroupId == questGroupId and _questId == questId then
		if true == _naviInfoAgain then
			groupBG1:SetShow( false )
			uiQuestAutoNaviButton:SetCheck( false )
			uiQuestNaviButton:SetCheck( false )
		else
			groupBG1:SetShow( true )
			groupBG1:SetIgnore( true )
			uiQuestNaviButton:SetCheck( true )
			-- if ( true == uiQuestAutoNaviButton:IsCheck() ) then
			-- 	uiQuestAutoNaviButton:SetCheck( false )
			-- 	uiQuestNaviButton:SetCheck( true )
			-- else
			-- 	uiQuestAutoNaviButton:SetCheck( true )
			-- 	uiQuestNaviButton:SetCheck( true )
			-- end
		end
	else
		groupBG1:SetShow( false )
		uiQuestAutoNaviButton:SetCheck( false )
		uiQuestNaviButton:SetCheck( false )
	end
	
	-- 내비 버튼 표시 여부 체크용(심플UI는 기능이 살아있으므로 제외)
	local naviBtnShow = 0				-- show
	if 0 ~= questCondition_Chk and 0 == questPosCount then
		naviBtnShow = 1					-- hide
	end

	--------------------------------------------------------------------
	-- 퀘스트가 1개라면 자동으로 네비를 찍는다. / 튜토리얼 중이라면 기존 퀘는 체크해제되므로 카운트 되지 않는다.
	-- 기존 룰 무시하기 때문에 나중에 선언되어야 한다.
	--------------------------------------------------------------------
	if true == autoNaviSelect and ( autoNaviGuide.groupKey .. "-" .. autoNaviGuide.questKey ~= questGroupId .. "-" .. questId ) then -- and false == haveQuestCheck( questGroupId, questId ) then
		if not naviUpdateSkip then			-- 마우스 오버로 인한 업데이트 시 스킵(자동이동 달리기 멈추는 현상 해결 위해)
			_QuestWidget_FindTarget_Auto( questGroupId, questId, questCondition_Chk, isAutoRun, QuestListUIPool._countGroupBG )
		else
			naviUpdateSkip = false
		end
	end
	
	uiQuestAutoNaviButton:SetShow( widgetMouseOn )
	local _uiQuestAutoNaviButtonPosY = uiQuestAutoNaviButton:GetPosY()
	uiQuestAutoNaviButton:addInputEvent("Mouse_On", 		"_questWidgetHelpPop( true," .. _uiQuestAutoNaviButtonPosY .. ", \"Autonavi\", " .. QuestListUIPool._countGroupBG .. "  )")
	uiQuestAutoNaviButton:addInputEvent("Mouse_Out", 		"_questWidgetHelpPop( false," .. _uiQuestAutoNaviButtonPosY .. ", \"Autonavi\", " .. QuestListUIPool._countGroupBG .. "  )")
	uiQuestAutoNaviButton:addInputEvent("Mouse_LUp", 		"HandleClicked_QuestWidget_FindTarget( " .. questGroupId .. ", " .. questId .. ", " .. questCondition_Chk .. ", true, " .. QuestListUIPool._countGroupBG .. " )")

	uiQuestNaviButton:SetShow( widgetMouseOn )
	local _uiQuestNaviButtonPosY = uiQuestNaviButton:GetPosY()
	uiQuestNaviButton:addInputEvent("Mouse_On", 		"_questWidgetHelpPop( true," .. _uiQuestNaviButtonPosY .. ", \"navi\", " .. QuestListUIPool._countGroupBG .. "  )")
	uiQuestNaviButton:addInputEvent("Mouse_Out", 		"_questWidgetHelpPop( false," .. _uiQuestNaviButtonPosY .. ", \"navi\", " .. QuestListUIPool._countGroupBG .. "  )")
	uiQuestNaviButton:addInputEvent("Mouse_LUp", 		"HandleClicked_QuestWidget_FindTarget( " .. questGroupId .. ", " .. questId .. ", " .. questCondition_Chk .. ", false )")


	--------------------------------------------------------------------
	-- 퀘스트 배경에 이벤트 걸기
	--------------------------------------------------------------------
	groupBG:addInputEvent( "Mouse_LUp", 			"HandleClicked_ShowQuestInfo( " .. questGroupId .. ", " .. questId .. ", " .. questCondition_Chk .. ", \"" .. groupTitle .. "\", " .. questGroupCount .. " )" )
	groupBG:addInputEvent( "Mouse_RUp", 			"HandleClicked_QuestWidget_FindTarget( " .. questGroupId .. ", " .. questId .. ", " .. questCondition_Chk .. ", false )" )
	groupBG:addInputEvent( "Mouse_DownScroll",		"QuestWidget_ScrollEvent( true )"		)
	groupBG:addInputEvent( "Mouse_UpScroll", 		"QuestWidget_ScrollEvent( false )" 	)
	
	groupBG:addInputEvent( "Mouse_On", 				"questWidget_QuestOver( true, " .. QuestListUIPool._countGroupBG .. ", " .. questGroupId .. ", " .. questId .. ", " .. naviBtnShow .. " )" 	)
	groupBG:addInputEvent( "Mouse_Out", 			"questWidget_QuestOver( false, " .. QuestListUIPool._countGroupBG .. ", " .. questGroupId.. " )" 	)
	groupBG:setTooltipEventRegistFunc( "questWidget_ShowTooptip(" .. questGroupId .. ", " .. questId .. ", " .. naviBtnShow .. " )" )
	groupBG:SetSize( Panel_CheckedQuest:GetSizeX() - 5, tmp_next_QuestPosY - groupBG_StartPosY )
	groupBG:SetShow( true )
	
	groupBG1:SetSize( Panel_CheckedQuest:GetSizeX() - 5, tmp_next_QuestPosY - groupBG_StartPosY )
	groupBG2:SetSize( Panel_CheckedQuest:GetSizeX() - 5, tmp_next_QuestPosY - groupBG_StartPosY )

	if 0 == questCondition_Chk and uiQuestInfo:isCompleteBlackSpirit() then
		uiQuestAutoNaviButton	:addInputEvent("Mouse_LUp", 	"HandleClicked_CallBlackSpirit()")
		uiQuestNaviButton		:addInputEvent("Mouse_LUp", 	"HandleClicked_CallBlackSpirit()")
		groupBG					:addInputEvent( "Mouse_RUp", 	"HandleClicked_CallBlackSpirit()" )
	end

	if 0 ~= questCondition_Chk and 0 == questPosCount then
		uiQuestAutoNaviButton	:SetShow( false )
		uiQuestNaviButton		:SetShow( false )
	end
	
	-- 간소화 해도 내비 버튼 나오도록 수정
	-- if getEnableSimpleUI() then
		-- uiQuestTitle:SetFontAlpha( 0.9 )
		-- uiQuestHideButton:SetPosX( uiQuestHideButton:GetPosX() )
		-- uiQuestAutoNaviButton:SetShow( false )
		-- uiQuestNaviButton:SetShow( false )
	-- end

	tmp_next_QuestPosY			= tmp_next_QuestPosY + list_Space + 5
	
	return tmp_next_QuestPosY
end

local blackQuestTexture = {
		{ 70, 70, 115, 115 },	-- 흑정령
		{ 197, 197, 250, 250},		-- 아님
	}
function _questWidget_ChangeTextureForBlackSpirit( isBlack, control )
	control:ChangeTextureInfoName( "New_ui_common_forlua/default/blackpanel_series.dds" )
	local x1, y1, x2, y2 = setTextureUV_Func( control, blackQuestTexture[isBlack][1], blackQuestTexture[isBlack][2], blackQuestTexture[isBlack][3], blackQuestTexture[isBlack][4] )
	control:getBaseTexture():setUV( x1, y1, x2, y2 )
	control:setRenderTexture(control:getBaseTexture())
end

function haveQuestCheck( questGroupId, questId )
	local questListInfo 		= ToClient_GetQuestList()
	local temp_questGroupCount	= questListInfo:getQuestGroupCount()
	local haveQuest = false

	for temp_progressCount = 0, temp_questGroupCount - 1 do
		if nil ~= questNoSaveForTutorial[temp_progressCount] then
			if questNoSaveForTutorial[temp_progressCount]._questGroupIndex == questGroupId
			and questNoSaveForTutorial[temp_progressCount]._questGroupIdx == questId then
				haveQuest = true
			end
		end
	end
	return haveQuest
end
	
--------------------------------------------------------------------------------
-- 						마우스 올렸을 때의 효과!
--------------------------------------------------------------------------------
function _questWidgetHelpPop( show, posY, target, idx )
	Panel_CheckedQuest:SetChildIndex( helpWidget, 9999 )
	if ( true == show ) then
		--helpWidget:SetPosX( ( getScreenSizeX() - Panel_CheckedQuest:GetSizeX() - Panel_CheckedQuest:GetPosX() ) - helpWidget:GetSizeX() - 40 )
		--helpWidget:SetPosY( getMousePosY() - Panel_CheckedQuest:GetPosY() - 10 )
		local _buttonPosX = 0
		local _buttonPosY = 0
		if "navi" == target then
			helpWidget:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_NAVITOOLTIP") ) -- 버튼을 클릭하면 의뢰 위치를 안내 받을 수 있습니다.
		elseif "Autonavi" == target then
			helpWidget:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_AUTONAVITOOLTIP") ) -- 버튼을 클릭하면 의뢰 위치를 안내 받는 것과 동시에 해당 위치로 자동 이동 합니다.
		elseif "hide" == target then
			helpWidget:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_HIDETOOLTIP") ) -- 버튼을 클릭하면 해당 의뢰를 위젯에서 감출 수 있습니다.
		elseif "giveup" == target then
			helpWidget:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_GIVEUPTOOLTIP") ) -- 버튼을 클릭하면 해당 의뢰를 위젯에서 감출 수 있습니다.
		end
		_questWidgetBubblePos( posY )
		helpWidget:SetShow( true )

		QuestListUIPool._listQuestHideButton[idx-1]		:SetSize(25, 25)
		QuestListUIPool._listQuestHideButton[idx-1]		:SetPosX( 192 )
		QuestListUIPool._listQuestGiveupButton[idx-1]	:SetSize(25, 25)
		QuestListUIPool._listQuestGiveupButton[idx-1]	:SetPosX( 219 )
		QuestListUIPool._listQuestNaviButton[idx-1]		:SetSize(25, 25)
		QuestListUIPool._listQuestNaviButton[idx-1]		:SetPosX( 246 )
		QuestListUIPool._listQuestAutoNaviButton[idx-1]	:SetSize(25, 25)
		QuestListUIPool._listQuestAutoNaviButton[idx-1]	:SetPosX( 273 )
	else
		questWidget_MouseOver( false )
		helpWidget:SetShow( false )
	end
end

function _questWidgetBubblePos( posY )
	local screenY = getScreenSizeY()
	local panelPosY = Panel_CheckedQuest:GetPosY()
	local helpWidgetSizeY = helpWidget:GetSizeY()
	local buttonSizeY = QuestListUIPool._listQuestHideButton[0]:GetSizeY()
	if ( screenY < panelPosY + posY + helpWidgetSizeY ) then
		helpWidget:SetPosY( posY - helpWidgetSizeY - 5 )
	else
		helpWidget:SetPosY( posY + buttonSizeY + 5 )
	end
	helpWidget:SetPosX( Panel_CheckedQuest:GetSizeX() - helpWidget:GetSizeX() + 5 )
end

--------------------------------------------------------------------
-- 퀘스트 위젯 배경 켜기
--------------------------------------------------------------------
local IM = CppEnums.EProcessorInputMode

function Common_WidgetMouseOut()
	if( IM.eProcessorInputMode_GameMode ~= UI.Get_ProcessorInputMode() ) then
		local panelPosX		= Panel_CheckedQuest:GetPosX()
		local panelPosY		= Panel_CheckedQuest:GetPosY()
		local panelSizeX	= Panel_CheckedQuest:GetSizeX()
		local panelSizeY	= Panel_CheckedQuest:GetSizeY() + 25
		local mousePosX		= getMousePosX()
		local mousePosY		= getMousePosY()
		if( (panelPosX < mousePosX) and (mousePosX < (panelPosX + panelSizeX) )
			and (panelPosY < mousePosY) and (mousePosY < (panelPosY + panelSizeY)) ) then
			return false
		end
	end
	return true
end

function questWidget_MouseOver( show )
	naviUpdateSkip = true
	if true == show then
		questWidget_TransBG	:SetShow( true )
		
		if ( CheckedQuest_SizeY < _next_QuestPosY ) then
			QuestList_ScrollBar:SetShow( true )
		else
			QuestList_ScrollBar:SetShow( false )
		end

		_sortLineBG			:SetShow( true )
		_sortType			:SetShow( true )
		_sortDistanceNear	:SetShow( true )
		_sortTimeRecent		:SetShow( true )

		for ii = 0, MAX_QUEST_FAVOR_TYPE-1, 1 do
			local control = questFavorType[ii]
			control:SetShow( true )
		end

		panelResizeButton	:SetShow( true )
		guideQuestButton	:SetShow( true )
		guideQuestNumber	:SetShow( true )
		historyButton		:SetShow( true )

		local myGuildInfo = ToClient_GetMyGuildInfoWrapper();
		if nil == myGuildInfo then
			findGuild:SetShow( true )
		end

		widgetMouseOn		= true
		updateQuestWidgetList( _startPosition )
	else
		if( false == Common_WidgetMouseOut() ) then
			return;
		end

		questWidget_TransBG	:SetShow( false )
		QuestList_ScrollBar	:SetShow( false )	-- 켜져 있을 때만.
		_sortLineBG			:SetShow( false )
		_sortType			:SetShow( false )
		_sortDistanceNear	:SetShow( false )
		_sortTimeRecent		:SetShow( false )

		for ii = 0, MAX_QUEST_FAVOR_TYPE-1, 1 do
			local control = questFavorType[ii]
			control:SetShow( false )
		end

		panelResizeButton	:SetShow( false )
		guideQuestButton	:SetShow( false )
		guideQuestNumber	:SetShow( false )
		historyButton		:SetShow( false )
		findGuild			:SetShow( false )

		widgetMouseOn		= false
		updateQuestWidgetList( _startPosition )
	end
end

function questWidget_ShowTooptip(questGroupId, questId, isMouseShow)
	local mousePosX	= getMousePosX()
	local mousePosY	= getMousePosY()
	
	questInfo_TooltipShow( true, questGroupId, questId, mousePosX, mousePosY, isMouseShow )
end

--------------------------------------------------------------------
-- 각 퀘스트 배경 켜기
--------------------------------------------------------------------
function questWidget_QuestOver( show, bgIndex, questGroupId, questId, isMouseShow )
	local mousePosX	= getMousePosX()
	local mousePosY	= getMousePosY()
	local bg_Idx	= bgIndex-1
	if true == show then
		questWidget_MouseOver( true )	-- 위젯 자체 배경을 켠다. false에서는 일부러 넣지 않는다. 위젯 아웃으로만 조절하기 위해.
		
		-- 퀘스트 툴팁을 켠다.
		registTooltipControl( QuestListUIPool._listGroupBG[bg_Idx], Panel_QuestInfo )
		questWidget_ShowTooptip( questGroupId, questId, isMouseShow )	-- 퀘스트 툴팁.
		
		if false == QuestListUIPool._listQuestNaviButton[bg_Idx]:IsCheck() then
			QuestListUIPool._listGroupBG2[bg_Idx]:SetShow( true )
		end
		
		QuestListUIPool._listQuestHideButton[bg_Idx]		:SetSize(25, 25)
		QuestListUIPool._listQuestHideButton[bg_Idx]		:SetPosX( 192 )
		QuestListUIPool._listQuestGiveupButton[bg_Idx]		:SetSize(25, 25)
		QuestListUIPool._listQuestGiveupButton[bg_Idx]		:SetPosX( 219 )
		QuestListUIPool._listQuestNaviButton[bg_Idx]		:SetSize(25, 25)
		QuestListUIPool._listQuestNaviButton[bg_Idx]		:SetPosX( 246 )
		QuestListUIPool._listQuestAutoNaviButton[bg_Idx]	:SetSize(25, 25)
		QuestListUIPool._listQuestAutoNaviButton[bg_Idx]	:SetPosX( 273 )

	else
		QuestListUIPool._listGroupBG2[bg_Idx]:SetShow( false )
		questInfo_TooltipShow( false )
		questWidget_MouseOver( false )

		-- todo 아웃 이벤트 정리 후에 삭제해야 함.
		local panelPosX		= Panel_CheckedQuest:GetPosX()
		local panelPosY		= Panel_CheckedQuest:GetPosY()
		local panelSizeX	= Panel_CheckedQuest:GetSizeX()
		local panelSizeY	= Panel_CheckedQuest:GetSizeY()
		if( ( mousePosX < panelPosX ) or ( (panelPosX + panelSizeX) < mousePosX )
			and ( mousePosY < panelPosY ) or ( (panelPosY + panelSizeY) < mousePosY ) ) then
			questWidget_TransBG:SetShow( false )
		end
		
		local bgPosX	= QuestListUIPool._listGroupBG[bg_Idx]:GetPosX() + panelPosX
		local bgPosY	= QuestListUIPool._listGroupBG[bg_Idx]:GetPosY() + panelPosY
		local bgSizeX	= QuestListUIPool._listGroupBG[bg_Idx]:GetSizeX()
		local bgSizeY	= QuestListUIPool._listGroupBG[bg_Idx]:GetSizeY()
		if( (bgPosX <= mousePosX) and (mousePosX <= (bgPosX + bgSizeX) )
			and (bgPosY <= mousePosY) and (mousePosY <= (bgPosY + bgSizeY)) ) then
			return
		end

		QuestListUIPool._listQuestHideButton[bg_Idx]		:SetSize(18, 18)
		QuestListUIPool._listQuestHideButton[bg_Idx]		:SetPosX( 220 )
		QuestListUIPool._listQuestGiveupButton[bg_Idx]		:SetSize(18, 18)
		QuestListUIPool._listQuestGiveupButton[bg_Idx]		:SetPosX( 240 )
		QuestListUIPool._listQuestNaviButton[bg_Idx]		:SetSize(18, 18)
		QuestListUIPool._listQuestNaviButton[bg_Idx]		:SetPosX( 260 )
		QuestListUIPool._listQuestAutoNaviButton[bg_Idx]	:SetSize(18, 18)
		QuestListUIPool._listQuestAutoNaviButton[bg_Idx]	:SetPosX( 280 )
	end
end

-- function questWidget_Play_Tutorial_NaviCtrl()
	-- Panel_Tutorial_NaviCtrl_Start()
-- end

--------------------------------------------------------------------
-- 퀘스트 위젯, 스크롤 시작점 반환
--------------------------------------------------------------------
function FGlobal_QuestWidgetGetStartPosition()
	return _startPosition
end

--------------------------------------------------------------------
-- 퀘스트 위젯 온오프 토글
--------------------------------------------------------------------
function HandleClicked_QuestWidget_Show()
	if Panel_CheckedQuest:GetShow() then
		Panel_CheckedQuest:SetShow( false, false )
	else
		Panel_CheckedQuest:SetShow( true, true )
	end
end

function FGlobal_QuestWidget_Open()
	Panel_CheckedQuest:SetShow( true, true )

	if ToClient_WorldMapIsShow() then
		WorldMapPopupManager:increaseLayer(true)
		WorldMapPopupManager:push( Panel_CheckedQuest, true )
	end
end
function FGlobal_QuestWidget_Close()
	Panel_CheckedQuest:SetShow( false, false )
	questInfo_TooltipShow( false )

	if ToClient_WorldMapIsShow() then
		WorldMapPopupManager:pop()
	end
end



--------------------------------------------------------------------
-- 퀘스트 정보창 띄우기
--------------------------------------------------------------------
function HandleClicked_ShowQuestInfo( questGroupId, questId, questCondition_Chk, groupTitle, questGroupCount )
	local fromQuestWidget = true
	FGlobal_QuestInfoDetail( questGroupId, questId, questCondition_Chk, groupTitle, questGroupCount, fromQuestWidget )
	--UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
	
	--그룹 퀘스트 클릭 시 사운드
	audioPostEvent_SystemUi(00,00)

end


--------------------------------------------------------------------
-- 네비 버튼 눌림 초기화
--------------------------------------------------------------------
function QuestNpcNavi_ClearCheckBox()
	for naviIndex = 0, QuestListUIPool._maxcountQuestAutoNaviButton, 1 do			-- 모든 네비 버튼 체크 해제
			QuestListUIPool._listQuestAutoNaviButton[naviIndex]:SetCheck( false )
			QuestListUIPool._listQuestAutoNaviEffect[naviIndex]:SetShow( false )
	end
	
	for naviIndex = 0, QuestListUIPool._maxcountQuestNaviButton, 1 do			-- 모든 네비 버튼 체크 해제
			QuestListUIPool._listQuestNaviButton[naviIndex]:SetCheck( false )
			QuestListUIPool._listQuestNaviEffect[naviIndex]:SetShow( false )
	end
	
	ToClient_DeleteNaviGuideByGroup(0);
end

--registerEvent("clearDrawLine", "QuestNpcNavi_ClearCheckBox")

--------------------------------------------------------------------
-- 네비 클릭
--------------------------------------------------------------------
function HandleClicked_QuestWidget_FindTarget( questGroupId, questId, condition, isAuto )
	if Panel_Masking_Tutorial:GetShow() then 
		FGlobal_Tutorial_QuestMasking_Hide()
	end
	if ( Panel_Tutorial:GetShow() ) then
		Panel_Tutorial_NaviCtrl_IsNaviDone = false
	end

	if (_questGroupId == questGroupId) and (_questId == questId) then --  and false == autoNaviSelect
		if false == _naviInfoAgain then
			ToClient_DeleteNaviGuideByGroup(0)
			audioPostEvent_SystemUi(00,15)
			_naviInfoAgain = true
			if true == autoNaviSelect then	-- 자동 선택이면 취소할 수 없다!
				_QuestWidget_FindTarget_Auto( questGroupId, questId, condition, isAuto, 1 )
			end
		else
			_naviInfoAgain	= false
			_QuestWidget_FindTarget_DrawMapPath( questGroupId, questId, condition, isAuto )
		end
	else
		_questGroupId	= questGroupId
		_questId		= questId
		_naviInfoAgain	= false
		_QuestWidget_FindTarget_DrawMapPath( questGroupId, questId, condition, isAuto )
	end
	-- isManualClick = true
	isAutoRun = isAuto
	updateQuestWidgetList( FGlobal_QuestWidgetGetStartPosition() )
	updateQuestWindowList( FGlobal_QuestWindowGetStartPosition() )
end

function _QuestWidget_FindTarget_Auto( questGroupId, questId, condition, isAutoRun, bgIdx )
	autoNaviGuide.groupKey = questGroupId
	autoNaviGuide.questKey = questId
	
	_questGroupId	= questGroupId
	_questId		= questId
	_naviInfoAgain	= false
	if nil ~= QuestListUIPool._listQuestNaviButton[bgIdx-1] then 
		QuestListUIPool._listQuestNaviButton[bgIdx-1]	:SetCheck( true )
		QuestListUIPool._listGroupBG1[bgIdx-1]			:SetShow( true )
		_QuestWidget_FindTarget_DrawMapPath( questGroupId, questId, condition, isAutoRun )
	end
end

--------------------------------------------------------------------
-- 네비 그리기
--------------------------------------------------------------------

-- 매번 생성하는것보다 그냥 미리 하나 만들어 놓는다. 
local navigationGuideParam = NavigationGuideParam()
function _QuestWidget_FindTarget_DrawMapPath( questGroupId, questId, condition, isAuto )
	-- 네비 초기화
	ToClient_DeleteNaviGuideByGroup(0);
	guideQuestButton:SetCheck( false )

	local questInfo = questList_getQuestStatic( questGroupId, questId )
	local isGuideAutoErase = questInfo:isGuideAutoErase()
	--변할수 있는 값들은 무조건 다 채워준다.----
	navigationGuideParam._questGroupNo	= questGroupId
	navigationGuideParam._questNo		= questId
	navigationGuideParam._isAutoErase	= isGuideAutoErase
	--------------------------------------------
	
	if 0 == condition then													-- 완료 NPC
		local npcData = npcByCharacterKey_getNpcInfo(questInfo:getCompleteNpc(), questInfo:getCompleteDialogIndex())
		if nil ~= npcData then
			if npcData:hasTimeSpawn() and (false == npcData:isTimeSpawn( math.floor( getIngameTime_minute() / 60 ) )) then
				local _errorMsg = PAGetString( Defines.StringSheet_GAME, "PANEL_QUESTLIST_NPC_VACATION" )
				Proc_ShowMessage_Ack( _errorMsg )
			end
			posX = npcData:getPosition().x
			posY = npcData:getPosition().y
			posZ = npcData:getPosition().z
			worldmapNavigatorStart( float3(posX, posY, posZ), navigationGuideParam, isAuto, false, true)
			audioPostEvent_SystemUi(00,14)
		end
	elseif 99 == condition then												-- 시작 NPC
		local npcData = npcByCharacterKey_getNpcInfo(questInfo:getAccecptNpc(), questInfo:getAccecptDialogIndex())
		if nil ~= npcData then
			if npcData:hasTimeSpawn() and (false == npcData:isTimeSpawn( math.floor( getIngameTime_minute() / 60 ) )) then
				local _errorMsg = PAGetString( Defines.StringSheet_GAME, "PANEL_QUESTLIST_NPC_VACATION" )
				Proc_ShowMessage_Ack( _errorMsg )
			end
			posX = npcData:getPosition().x
			posY = npcData:getPosition().y
			posZ = npcData:getPosition().z
			worldmapNavigatorStart( float3(posX, posY, posZ), navigationGuideParam, isAuto, false, true)
			audioPostEvent_SystemUi(00,14)
		end
	else																	-- 조건 지역
		local questPosCount = questInfo:getQuestPositionCount()
		if 0 ~= questPosCount then											-- 위치 값이 있다면
			positionList = {};												-- 저장 값을 초기화.
			positionList._questGroupId	= questGroupId
			positionList._questId		= questId

			local totalLength = 0.0;
			for questPositionIndex = 0, questPosCount -1, 1 do
				local questPosInfo = questInfo:getQuestPositionAt( questPositionIndex )
				posX = questPosInfo._position.x
				posY = questPosInfo._position.y
				posZ = questPosInfo._position.z
				positionList[questPositionIndex] = {};
				positionList[questPositionIndex]._key 		= worldmapNavigatorStart( float3(posX, posY, posZ), navigationGuideParam, isAuto, false, true)
				positionList[questPositionIndex]._radius	= questPosInfo._radius;
				positionList[questPositionIndex]._startRate	= totalLength;
				
				totalLength = totalLength + positionList[questPositionIndex]._radius;
			end
			
			if (questPosCount - 1 > 0) then
				local randomRate 	= math.random(0, 100) / 100.0;
				local randomIndex 	= 0;
				
				for idx = 0, questPosCount -1, 1 do
					if ( ( positionList[idx]._startRate / totalLength ) < randomRate ) and ( randomRate < ( (positionList[idx]._startRate + positionList[idx]._radius) / totalLength ) )  then
						randomIndex	= idx;
						break;
					end
				end

				local selfPlayer = getSelfPlayer():get()
				if ( selfPlayer:getNavigationMovePathIndex() ~= positionList[randomIndex]._key ) then
					if ToClient_GetNaviGuideGroupNo(positionList[randomIndex]._key) ~= 0 then
						ToClient_DeleteNaviGuideByGroup(0);
					end	
					selfPlayer:setNavigationMovePath(positionList[randomIndex]._key)
					selfPlayer:checkNaviPathUI(positionList[randomIndex]._key)
				end
			end
			if TutorialQuestCompleteCheck() then
				audioPostEvent_SystemUi(00,14)
			end
		else																-- 위치 값이 없다면
			-- QuestListUIPool._listQuestNaviButton[nabiIndex]:SetShow( false )
		end
	end
	-- _askAutoRun_FromNaviClick()
end


local questConditionType = {
	eQuestProgressingState_yetAccept = 0,
	eQuestProgressingState_Accept = 1,
	eQuestProgressingState_Complete = 2,
	eQuestProgressingState_AlreadyComplete = 3,
	
	eQuestProgressingState_Count = 4,
}
local convertQuestConditionToNaviFindType = {
	[questConditionType.eQuestProgressingState_yetAccept] = 99,
	[questConditionType.eQuestProgressingState_Accept] = 1,
	[questConditionType.eQuestProgressingState_Complete] = 0,
	[questConditionType.eQuestProgressingState_AlreadyComplete] = 99,
}

function FromClient_SetQuestNavigationByServer( questGroupId, questId, condition )
	local questCondition = convertQuestConditionToNaviFindType[condition]
	if ( nil == questCondition ) then
		return
	end

	_QuestWidget_FindTarget_DrawMapPath( questGroupId, questId, questCondition, false )
end

--------------------------------------------------------------------
-- 자동 이동할까?
--------------------------------------------------------------------
function _askAutoRun_FromNaviClick()
	local	messageboxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
	local	messageboxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_ASKAUTORUN_MSG")
	local	messageboxData	= { title = messageboxTitle, content = messageboxMemo, functionYes = _doAutoRun_FromNaviClick, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
end
function _doAutoRun_FromNaviClick()
	
end

--------------------------------------------------------------------
-- 네비 클릭 여부 반환
--------------------------------------------------------------------
function _QuestWidget_ReturnQuestState()
	return _questGroupId, _questId, _naviInfoAgain
end


function HandleClicked_CallBlackSpirit()
	 if false == Panel_Window_Exchange:GetShow() then
	 	if not IsSelfPlayerWaitAction() then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_SUMMON_BLACKSPIRIT") )
			return
		end
		ToClient_AddBlackSpiritFlush()
	end
end


--------------------------------------------------------------------
-- 가이드 퀘스트 창 띄우기
--------------------------------------------------------------------
function HandleClicked_QuestWidget_GuideQuest_MouseOver( isOn )
	guideQuestButton_Desc:SetPosX( ( guideQuestButton:GetPosX() - guideQuestButton_Desc:GetSizeX() ) + 35 )
	guideQuestButton_Desc:SetPosY( guideQuestButton:GetPosY() + 35 )
	if ( isOn ) then
		guideQuestButton_Desc:SetShow( true )
		guideQuestButton_Desc:SetAlpha( 0 )
		guideQuestButton_Desc:SetFontAlpha( 0 )
		guideQuestButton_Desc:ResetVertexAni()
		UIAni.AlphaAnimation( 1, guideQuestButton_Desc, 0.0, 0.15 )
	else
		guideQuestButton_Desc:ResetVertexAni()
		local AniInfo = UIAni.AlphaAnimation( 0, guideQuestButton_Desc, 0.0, 0.1 )
		AniInfo:SetHideAtEnd( true )
	end
	questWidget_MouseOver( isOn )
end


--------------------------------------------------------------------
-- 가이드 퀘스트 창 띄우기
--------------------------------------------------------------------
function HandleClicked_QuestNew_MouseOver( isOn )
	historyButton_Desc:SetPosX( ( historyButton:GetPosX() - historyButton_Desc:GetSizeX() ) + 35 )
	historyButton_Desc:SetPosY( historyButton:GetPosY() + 35 )
	if ( isOn ) then
		historyButton_Desc:SetShow( true )
		historyButton_Desc:SetAlpha( 0 )
		historyButton_Desc:SetFontAlpha( 0 )
		historyButton_Desc:ResetVertexAni()
		UIAni.AlphaAnimation( 1, historyButton_Desc, 0.0, 0.15 )
	else
		historyButton_Desc:ResetVertexAni()
		local AniInfo1 = UIAni.AlphaAnimation( 0, historyButton_Desc, 0.0, 0.1 )
		AniInfo1:SetHideAtEnd( true )
	end
	questWidget_MouseOver( isOn )
end


--------------------------------------------------------------------
-- 가이드 퀘스트 창 띄우기
--------------------------------------------------------------------
function HandleClicked_QuestWidget_GuideQuest()
	if GlobalKeyBinder_CheckProgress_chk() then
		return
	end

	--- 미니게임 중에는 실행되지 않도록
	if Panel_Global_Manual:GetShow() then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAMING_DO_NOT_USE") )	-- "미니게임 중에는 사용할 수 없습니다."
		return
	end
	
	local doGuideQuestCount		= questList_getDoGuideQuestCount()
	if false == guideQuestChechk then
		ToClient_DeleteNaviGuideByGroup(0);
		for guideIndex = 1, doGuideQuestCount do
			local doGuideQuest	= questList_getDoGuideQuestAt(guideIndex - 1)
			if(questList_isSelectQuest(doGuideQuest:getSelectType())) then
				local spawnData		= npcByCharacterKey_getNpcInfo(doGuideQuest:getAccecptNpc(), doGuideQuest:getAccecptDialogIndex())
				local guideQuestPos
				if(nil ~= spawnData) then
					local npcPosition = spawnData:getPosition()
					guideQuestPos = float3(npcPosition.x, npcPosition.y, npcPosition.z)
				end

				ToClient_WorldMapNaviStart( guideQuestPos, NavigationGuideParam(), false, false )
			end
		end
		guideQuestChechk = true
		guideQuestButton:SetCheck( true )
		if ToClient_WorldMapIsShow() then
			return
		end
		FGlobal_PushOpenWorldMap()
	else
		if ToClient_WorldMapIsShow() then
			return
		end
		ToClient_DeleteNaviGuideByGroup(0);
		guideQuestChechk = false
		guideQuestButton:SetCheck( false )
	end
end

--------------------------------------------------------------------
-- 퀘스트 오버 툴팁(퀘스트 창에서 사용)
--------------------------------------------------------------------
function _QuestWidget_QuestToolTipShow( questGroupIndex, questIndex )
	QuestInfoData.questCheckDescShowWindow2( questGroupIndex, questIndex )
end
function _QuestWidget_QuestToolTipHide()
	QuestInfoData.questDescHideWindow()
end



--------------------------------------------------------------------
-- 길드 퀘스트 툴팁
--------------------------------------------------------------------
function guildQuestWidget_MouseOn( isShow )
	local control = guildQuest._ControlBG
	if true == isShow then
		QuestInfoData.guildQuestDescShowWindow()
		-- guildQuest._Reward:SetSize( 25, 25 )
		-- guildQuest._Giveup:SetSize( 25, 25 )
		
		control:ChangeTextureInfoName ( "New_UI_Common_forLua/Default/BlackPanel_Series.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 1, 64, 63, 126 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())
		control:SetAlpha(1)
	else
		QuestInfoData.questDescHideWindow()
		-- guildQuest._Reward:SetSize( 18, 18 )
		-- guildQuest._Giveup:SetSize( 18, 18 )

		control:ChangeTextureInfoName ( "New_UI_Common_forLua/Default/BlackPanel_Series.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 127, 127, 189, 189 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())
		control:SetAlpha(0)
	end
end


--------------------------------------------------------------------
-- 퀘스트 위젯 창 크키 조절
--------------------------------------------------------------------
local orgMouseY		= 0
local orgPanelSizeY	= 0
local orgPanelPosY	= 0
function HandleClicked_QuestWidgetPanelSize()
	local panel 	= Panel_CheckedQuest
	orgMouseY 		= getMousePosY()
	orgPanelPosY	= panel:GetPosY()
	orgPanelSizeY	= panel:GetSizeY()
end

function HandleClicked_QuestWidgetPanelResize()
	local panel 		= Panel_CheckedQuest
	local currentY		= getMousePosY()
	local deltaY 		= currentY - orgMouseY

	local panelPosY 	= panel:GetPosY()
	local panelSizeX	= panel:GetSizeX()
	local panelSizeY	= panel:GetSizeY()
	local mousePosY		= getMousePosY()

	if 300 < (orgPanelSizeY + deltaY) and (orgPanelSizeY + deltaY) < 800 then
		Panel_CheckedQuest:SetSize( panelSizeX, orgPanelSizeY + deltaY )
		questWidget_TransBG:SetSize( panelSizeX, orgPanelSizeY + deltaY )
		questWidget_updateScrollButtonSize()
	end
	if 300 < panel:GetSizeY() then
		CheckedQuest_SizeY = panel:GetSizeY()					-- 사이즈 키우면 최대 사이즈 저장
	end
	questWidget_updateScrollButtonSize()

	-- guideQuestButton:SetPosY( Panel_CheckedQuest:GetSizeY() + 10 )
	-- historyButton:SetPosY( guideQuestButton:GetPosY() )
	-- findGuild:SetPosY( guideQuestButton:GetPosY() )
	-- panelResizeButton:SetPosY( historyButton:GetPosY() )

	panelResizeButton:SetPosY( Panel_CheckedQuest:GetSizeY() + 10 )
	guideQuestButton:SetPosY( Panel_CheckedQuest:GetSizeY() - 5 )
	historyButton:SetPosY( Panel_CheckedQuest:GetSizeY() - 5 )
	findGuild:SetPosY( Panel_CheckedQuest:GetSizeY() - 5 )

	updateQuestWidgetList( _startPosition )
	ToClient_SaveUiInfo(false)
end

function HandleClicked_QuestWidgetSaveResize()
	ToClient_SaveUiInfo( true )	-- 위치를 잡고 저장해야 한다.
end

function HandleOn_QuestWidgetPanelResize( isShow )
	questWidget_MouseOver( isShow )
end
--------------------------------------------------------------------
-- 퀘스트 인덱스 반환용
--------------------------------------------------------------------
local _tmpGroupId = nil
local _tmpQuestId = nil
function FGlobal_PassGroupIdQuestId( groupId, questId )
	if (nil == groupId) and (nil == questId) then
		return _tmpGroupId, _tmpQuestId
	else
		_tmpGroupId = groupId
		_tmpQuestId = questId
	end
end

--------------------------------------------------------------------
-- 퀘스트 포기
--------------------------------------------------------------------
function HandleClicked_QuestWidget_QuestGiveUp( groupId, questId  )
	FGlobal_PassGroupIdQuestId( groupId, questId )
	local messageboxTitle	= PAGetString(Defines.StringSheet_GAME, "GUILD_MESSAGEBOX_TITLE")
	local messageboxContent	= PAGetString( Defines.StringSheet_GAME, "PANEL_QUESTLIST_REAL_GIVEUP_QUESTION" )		--	 정말 의뢰받은 일을 포기하시겠습니까?
	local messageboxData	= { title = messageboxTitle, content = messageboxContent, functionYes = QuestWidget_QuestGiveUp_Confirm, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
end
function QuestWidget_QuestGiveUp_Confirm()
	local groupId, questId = FGlobal_PassGroupIdQuestId()
	ToClient_GiveupQuest( groupId, questId )
	
	-- 퀘스트 포기 시 이 부분이 업데이트 되기 때문에, 기본 스킬 튜토리얼 체크를 여기서 해준다!!
	if Panel_Tutorial:GetShow() then
		FGlobal_BaseSkill_TutorialClose()
	end

	if true == Panel_CheckedQuestInfo:GetShow() then
		Panel_CheckedQuestInfo:SetShow( false )
	end
end

--------------------------------------------------------------------
-- 퀘스트 보상 보기
--------------------------------------------------------------------
function HandleClicked_QuestReward_Show( groupId, questId, window )
	local questReward	= questList_getQuestStatic( groupId, questId )
	local baseCount		= questReward:getQuestBaseRewardCount()		
	local selectCount	= questReward:getQuestSelectRewardCount()

	local _baseReward = {}
	for baseReward_index = 1, baseCount, 1 do
		local baseReward = questReward:getQuestBaseRewardAt( baseReward_index - 1 )
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

	local _selectReward = {}
	for selectReward_index = 1, selectCount, 1 do
		local selectReward = questReward:getQuestSelectRewardAt( selectReward_index - 1 )
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

	FGlobal_ShowRewardList( false )
	FGlobal_SetRewardList( _baseReward, _selectReward, nil )
	Panel_Npc_Quest_Reward:SetPosX( getMousePosX() - Panel_Npc_Quest_Reward:GetSizeX() - 10 )
	Panel_Npc_Quest_Reward:SetPosY( getMousePosY() )

	FGlobal_ShowRewardList( true )
end


-----------------------------------------------------------------------------
--					퀘스트 리스트 업데이트 함수!!
-----------------------------------------------------------------------------
local darkSpiritFirstTime = true

-----------------------------------------------------------------------------------------------
-- 								흑정령 나오는 튜토리얼
-----------------------------------------------------------------------------------------------
function FromClient_Panel_updateBlackSpirit()
	local playerLevel = getSelfPlayer():get():getLevel()
	---------------------------------------------------------------
	--				버튼 설명을 흑정령이 해주는 구간!!
	
	if ( darkSpiritFirstTime == true ) and ( isClearedQuest == true ) then
		_darkSpirit:SetShow( true )
		_darkSpirit:AddEffect( "fUI_DarkSpirit_Tutorial", true, 0, 0 )
		_darkSpirit_Notice:SetShow( true )
		_darkSpirit_Notice:SetAutoResize( true )
		_darkSpirit_Notice:SetSize( 220, 86 )
		_darkSpirit_Notice:SetTextMode( UI_TM.eTextMode_AutoWrap )
		_darkSpirit_Notice:SetText( PAGetString( Defines.StringSheet_GAME,  "LUA_QUESTLIST_DARKSPIRIT_HELP") )
		_darkSpirit_Notice:SetSize ( _darkSpirit_Notice:GetSizeX() + 5, _darkSpirit_Notice:GetSizeY() + 30 )
		_darkSpirit_Notice:SetPosX( _darkSpirit:GetPosX() + 140 )
		_darkSpirit_Notice:SetPosY( _darkSpirit:GetPosY() + 50 )

		darkSpiritFirstTime = false
	elseif ( playerLevel >= 5 ) then
		_darkSpirit:SetShow( false )
		_darkSpirit:EraseAllEffect()

		_darkSpirit_Notice:SetShow( false )
	end
end
registerEvent("EventCharacterInfoUpdate", 	"FromClient_Panel_updateBlackSpirit")


-------------------------------------------
-- 			위치 찾기 도움말. 길드 퀘스트, 퀘스트 창 등에서 사용
-------------------------------------------
function QuestAutoNpcNavi_Over( isNpcNaviShow )
	local playerLevel = getSelfPlayer():get():getLevel()
	--------------------------------------------------------
	--		레벨 5가 되기 전까지는 흑정령이 설명해준다
	if ( 4 <= playerLevel ) then
		if ( isNpcNaviShow == true ) then
			_questListMessage = PAGetString( Defines.StringSheet_GAME, "LUA_QUESTLIST_AUTONPCNAVI_HELP" )
			_Notice_NpcNavi:SetTextMode( UI_TM.eTextMode_AutoWrap )
			_Notice_NpcNavi:SetAutoResize( true )
			_Notice_NpcNavi:SetText(_questListMessage)

			_Notice_NpcNavi:SetPosX( getMousePosX() - Panel_CheckedQuest:GetPosX() - 150)
			_Notice_NpcNavi:SetPosY( getMousePosY() - Panel_CheckedQuest:GetPosY() - 60)
			_Notice_NpcNavi:ComputePos()
			_Notice_NpcNavi:SetSize ( _Notice_NpcNavi:GetSizeX(), _Notice_NpcNavi:GetSizeY() )

			_Notice_NpcNavi:SetAlpha(0)
			_Notice_NpcNavi:SetFontAlpha(0)
			UIAni.AlphaAnimation( 1, _Notice_NpcNavi, 0.0, 0.2 )
			_Notice_NpcNavi:SetShow(true)
		else
			local aniInfo = UIAni.AlphaAnimation( 0, _Notice_NpcNavi, 0.0, 0.2 )
			aniInfo:SetHideAtEnd(true)
		end

	elseif ( 1 <= playerLevel ) and ( isClearedQuest == true ) then
		if ( isNpcNaviShow == true ) then
			_darkSpirit_Notice:SetTextMode( UI_TM.eTextMode_AutoWrap )
			_darkSpirit_Notice:SetAutoResize( true )
			_darkSpirit_Notice:SetSize( 220, 86 )
			_darkSpirit_Notice:SetText( PAGetString( Defines.StringSheet_GAME,  "LUA_QUESTLIST_DARKSPIRIT_NPCNAVI") )		-- 앞으로 길을 잃어버릴 일은 없겠지?
			_darkSpirit_Notice:SetSize ( _darkSpirit_Notice:GetSizeX() + 5, _darkSpirit_Notice:GetSizeY() + 30 )
		else
			_darkSpirit_Notice:SetAutoResize( true )
			_darkSpirit_Notice:SetSize( 220, 86 )
			_darkSpirit_Notice:SetTextMode( UI_TM.eTextMode_AutoWrap )
			_darkSpirit_Notice:SetText( PAGetString( Defines.StringSheet_GAME,  "LUA_QUESTLIST_DARKSPIRIT_HELP") )
			_darkSpirit_Notice:SetSize ( _darkSpirit_Notice:GetSizeX() + 5, _darkSpirit_Notice:GetSizeY() + 30 )
			_darkSpirit_Notice:SetPosX( _darkSpirit:GetPosX() + 140 )
			_darkSpirit_Notice:SetPosY( _darkSpirit:GetPosY() + 50 )

			darkSpiritFirstTime = false
		end
	end
end


-------------------------------------------
-- 			위치 찾기 도움말. 길드 퀘스트, 퀘스트 창 등에서 사용
-------------------------------------------
function QuestNpcNavi_Over( isNpcNaviShow )
	local playerLevel = getSelfPlayer():get():getLevel()
	--------------------------------------------------------
	--		레벨 5가 되기 전까지는 흑정령이 설명해준다
	if ( 4 <= playerLevel ) then

		if Panel_Help:GetShow() then					-- 흑정령 도움말이 켜 있으면, 도움말 말풍선을 띄운다.
			if  isNpcNaviShow == true then
				Button_NpcNaviOn()						-- 포기 흑정령 도움말  // Panel_Help.lua에 있음.
			else
				Button_NpcNaviOut()
			end
		end

		if ( isNpcNaviShow == true ) then
			_questListMessage = PAGetString( Defines.StringSheet_GAME, "LUA_QUESTLIST_NPCNAVI_HELP" )
			_Notice_NpcNavi:SetTextMode( UI_TM.eTextMode_AutoWrap )
			_Notice_NpcNavi:SetAutoResize( true )
			_Notice_NpcNavi:SetText(_questListMessage)

			_Notice_NpcNavi:SetPosX( getMousePosX() - Panel_CheckedQuest:GetPosX() - 150)
			_Notice_NpcNavi:SetPosY( getMousePosY() - Panel_CheckedQuest:GetPosY() - 60)
			_Notice_NpcNavi:ComputePos()
			_Notice_NpcNavi:SetSize ( _Notice_NpcNavi:GetSizeX(), _Notice_NpcNavi:GetSizeY() )

			_Notice_NpcNavi:SetAlpha(0)
			_Notice_NpcNavi:SetFontAlpha(0)
			UIAni.AlphaAnimation( 1, _Notice_NpcNavi, 0.0, 0.2 )
			_Notice_NpcNavi:SetShow(true)
		else
			local aniInfo = UIAni.AlphaAnimation( 0, _Notice_NpcNavi, 0.0, 0.2 )
			aniInfo:SetHideAtEnd(true)
		end

	elseif ( 1 <= playerLevel ) and ( isClearedQuest == true ) then
		if ( isNpcNaviShow == true ) then
			_darkSpirit_Notice:SetTextMode( UI_TM.eTextMode_AutoWrap )
			_darkSpirit_Notice:SetAutoResize( true )
			_darkSpirit_Notice:SetSize( 220, 86 )
			_darkSpirit_Notice:SetText( PAGetString( Defines.StringSheet_GAME,  "LUA_QUESTLIST_DARKSPIRIT_NPCNAVI") )		-- 앞으로 길을 잃어버릴 일은 없겠지?
			_darkSpirit_Notice:SetSize ( _darkSpirit_Notice:GetSizeX() + 5, _darkSpirit_Notice:GetSizeY() + 30 )
		else
			_darkSpirit_Notice:SetAutoResize( true )
			_darkSpirit_Notice:SetSize( 220, 86 )
			_darkSpirit_Notice:SetTextMode( UI_TM.eTextMode_AutoWrap )
			_darkSpirit_Notice:SetText( PAGetString( Defines.StringSheet_GAME,  "LUA_QUESTLIST_DARKSPIRIT_HELP") )
			_darkSpirit_Notice:SetSize ( _darkSpirit_Notice:GetSizeX() + 5, _darkSpirit_Notice:GetSizeY() + 30 )
			_darkSpirit_Notice:SetPosX( _darkSpirit:GetPosX() + 140 )
			_darkSpirit_Notice:SetPosY( _darkSpirit:GetPosY() + 50 )

			darkSpiritFirstTime = false
		end
	end
end

-------------------------------------------
-- 			퀘스트 포기 도움말. 길드 퀘스트, 퀘스트 창 등에서 사용
-------------------------------------------
function questGiveUp_Over( isGiveShow )
	local playerLevel = getSelfPlayer():get():getLevel()
	--------------------------------------------------------
	--		레벨 5가 되기 전까지는 흑정령이 설명해준다
	if ( playerLevel >= 4 ) then
		if ( isGiveShow == true ) then
			_questListMessage = PAGetString( Defines.StringSheet_GAME, "LUA_QUESTLIST_GIVEUP_HELP" )

			_Notice_GiveUp:SetTextMode( UI_TM.eTextMode_AutoWrap )
			_Notice_GiveUp:SetAutoResize( true )
			_Notice_GiveUp:SetText(_questListMessage)
			_Notice_GiveUp:SetSpanSize(10,0)

			_Notice_GiveUp:SetPosX(getMousePosX() - Panel_CheckedQuest:GetPosX() - _Notice_GiveUp:GetSizeX())
			_Notice_GiveUp:SetPosY(getMousePosY() - Panel_CheckedQuest:GetPosY() - 60)
			_Notice_GiveUp:ComputePos()
			_Notice_GiveUp:SetSize ( _Notice_GiveUp:GetSizeX(), _Notice_GiveUp:GetSizeY() )

			_Notice_GiveUp:SetAlpha(0)
			_Notice_GiveUp:SetFontAlpha(0)
			UIAni.AlphaAnimation( 1, _Notice_GiveUp, 0.0, 0.2 )
			_Notice_GiveUp:SetShow(true)
		else
			local aniInfo = UIAni.AlphaAnimation( 0, _Notice_GiveUp, 0.0, 0.2 )
			aniInfo:SetHideAtEnd(true)
		end
	elseif ( playerLevel >= 1 ) and ( isClearedQuest == true ) then
		if ( isGiveShow == true ) then
			_darkSpirit_Notice:SetTextMode( UI_TM.eTextMode_AutoWrap )
			_darkSpirit_Notice:SetAutoResize( true )
			_darkSpirit_Notice:SetSize( 220, 86 )
			_darkSpirit_Notice:SetText( PAGetString( Defines.StringSheet_GAME,  "LUA_QUESTLIST_DARKSPIRIT_GIVEUP") )
			-- 귀찮으면 포기해도 되지만...\n이건 내가 책임 안 져.
			_darkSpirit_Notice:SetSize ( _darkSpirit_Notice:GetSizeX() + 5, _darkSpirit_Notice:GetSizeY() + 30 )
		else
			_darkSpirit_Notice:SetAutoResize( true )
			_darkSpirit_Notice:SetSize( 220, 86 )
			_darkSpirit_Notice:SetTextMode( UI_TM.eTextMode_AutoWrap )
			_darkSpirit_Notice:SetText( PAGetString( Defines.StringSheet_GAME,  "LUA_QUESTLIST_DARKSPIRIT_HELP") )
			_darkSpirit_Notice:SetSize ( _darkSpirit_Notice:GetSizeX() + 5, _darkSpirit_Notice:GetSizeY() + 30 )
			_darkSpirit_Notice:SetPosX( _darkSpirit:GetPosX() + 140 )
			_darkSpirit_Notice:SetPosY( _darkSpirit:GetPosY() + 50 )

			darkSpiritFirstTime = false
		end

	end
end

-------------------------------------------
-- 			퀘스트 보상 도움말. 길드 퀘스트, 퀘스트 창 등에서 사용
-------------------------------------------
function QuestReward_Over( isRewardShow )
	local playerLevel = getSelfPlayer():get():getLevel()
	--------------------------------------------------------
	--		레벨 5가 되기 전까지는 흑정령이 설명해준다
	if ( playerLevel >= 4 ) then
		if ( isRewardShow == true ) then
			_questListMessage = PAGetString( Defines.StringSheet_GAME, "LUA_QUESTLIST_REWARD_HELP" )
			_Notice_Reward:SetTextMode( UI_TM.eTextMode_AutoWrap )
			_Notice_Reward:SetAutoResize( true )
			_Notice_Reward:SetText(_questListMessage)

			_Notice_Reward:SetPosX(getMousePosX() - Panel_CheckedQuest:GetPosX() - _Notice_Reward:GetSizeX())
			_Notice_Reward:SetPosY(getMousePosY() - Panel_CheckedQuest:GetPosY() - 60)
			_Notice_Reward:ComputePos()
			_Notice_Reward:SetSize ( _Notice_Reward:GetSizeX(), _Notice_Reward:GetSizeY() )

			_Notice_Reward:SetAlpha(0)
			_Notice_Reward:SetFontAlpha(0)
			UIAni.AlphaAnimation( 1, _Notice_Reward, 0.0, 0.2 )
			_Notice_Reward:SetShow(true)
		else
			local aniInfo = UIAni.AlphaAnimation( 0, _Notice_Reward, 0.0, 0.2 )
			aniInfo:SetHideAtEnd(true)
		end
	elseif ( playerLevel >= 1 ) and ( isClearedQuest == true ) then
		if ( isRewardShow == true ) then
			_darkSpirit_Notice:SetTextMode( UI_TM.eTextMode_AutoWrap )
			_darkSpirit_Notice:SetAutoResize( true )
			_darkSpirit_Notice:SetSize( 220, 86 )
			_darkSpirit_Notice:SetText( PAGetString( Defines.StringSheet_GAME,  "LUA_QUESTLIST_DARKSPIRIT_REWARD") )	
			-- 원하는 걸 해주면\n네게도 득이 될 거야.
			_darkSpirit_Notice:SetSize ( _darkSpirit_Notice:GetSizeX() + 5, _darkSpirit_Notice:GetSizeY() + 30 )
		else
			_darkSpirit_Notice:SetAutoResize( true )
			_darkSpirit_Notice:SetSize( 220, 86 )
			_darkSpirit_Notice:SetTextMode( UI_TM.eTextMode_AutoWrap )
			_darkSpirit_Notice:SetText( PAGetString( Defines.StringSheet_GAME,  "LUA_QUESTLIST_DARKSPIRIT_HELP") )
			-- 인간들은 안 가본 길은 잘 모르는 것 같아. 힘들면 반짝이는 걸 눌러봐.
			_darkSpirit_Notice:SetSize ( _darkSpirit_Notice:GetSizeX() + 5, _darkSpirit_Notice:GetSizeY() + 30 )
			_darkSpirit_Notice:SetPosX( _darkSpirit:GetPosX() + 140 )
			_darkSpirit_Notice:SetPosY( _darkSpirit:GetPosY() + 50 )

			darkSpiritFirstTime = false
		end
	end
end

function FromClient_SetQuestType(questType)
	local QuestListInfo = ToClient_GetQuestList()
	QuestListInfo:setQuestSelectType(questType, true)
				
	FGlobal_UpdateQuestFavorType()
end

--------------------------------------------------------------------------------
-- 	길드 가입 희망
--------------------------------------------------------------------------------
function HandleClieked_CheckedQuest_WantJoinGuild()
	if findGuild:IsCheck() then
		ToClient_SetJoinedMode( 0 )
	else
		ToClient_SetJoinedMode( 1 )
	end
end

function HandleOn_CheckedQuest_WantJoinGuild( isShow )
	questWidget_MouseOver( isShow )
end

--------------------------------------------------------------------
-- 옮기기 퀘스트 자동 길찾기 실행
--------------------------------------------------------------------
function EventRadingOnQuest( questStaticWrapper, index )
	if ( nil == questStaticWrapper ) then
		return
	end
	local uiQuestInfo = questStaticWrapper

	local npcData = npcByCharacterKey_getNpcInfo(uiQuestInfo:getCompleteNpc(), uiQuestInfo:getCompleteDialogIndex())
	if nil ~= npcData then
		HandleClicked_QuestWidget_FindTarget( uiQuestInfo:getQuestNo()._group, uiQuestInfo:getQuestNo()._quest, 0, false )
	end
end
function EventUnradingOnQuest( questStaticWrapper, index )
	-- ♬ 네비게이션을 끄는 사운드
	audioPostEvent_SystemUi(00,15)
	ToClient_DeleteNaviGuideByGroup(0);
end
registerEvent("EventRadingOnQuest", 		"EventRadingOnQuest")			-- 양 들거나, 수레를 잡으면 목적지로 안내
registerEvent("EventUnradingOnQuest", 		"EventUnradingOnQuest")			-- 양 들거나, 수레를 잡으면 목적지로 안내

local checkQuest_posX = 0
local checkQuest_posY = 0
-- 길드 퀘스트 받을 시에 퀘스트 리스트 위치 변경------------------------------
function FromClient_UpdateQuestSetPos()
	-- 퀘스트를 업데이트 한다.
	updateQuestWidgetList( _startPosition )

	local newEquipGap = 0
	if ( true == Panel_NewEquip:GetShow() ) then
		newEquipGap = Panel_NewEquip:GetSizeY()

		local _x1 = Panel_NewEquip:GetPosX()
		local _x2 = Panel_NewEquip:GetPosX() + Panel_NewEquip:GetSizeX()
		local _y1 = Panel_NewEquip:GetPosY()
		local _y2 = Panel_NewEquip:GetPosY() + Panel_NewEquip:GetSizeY()
		
		local x1 = Panel_CheckedQuest:GetPosX()
		local x2 = Panel_CheckedQuest:GetPosX() + Panel_CheckedQuest:GetSizeX()
		local y1 = Panel_CheckedQuest:GetPosY()
		local y2 = Panel_CheckedQuest:GetPosY() + Panel_CheckedQuest:GetSizeY()
		
		for xx = x1, x2, 10 do						-- 10픽셀씩 체크
			for yy = y1, y2, 10 do
				if (_x1 <= xx ) and ( xx <= _x2 ) and ( _y1 <= yy ) and ( yy <= _y2 ) then
					Panel_CheckedQuest:SetPosY( FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY() + 15 + newEquipGap )
				end
			end
		end
	end
	
	local haveServerPosotion = 0 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_CheckedQuest, chatIndex, CppEnums.PanelSaveType.PanelSaveType_IsSaved)	-- 서버 값이 있나?
	if not haveServerPosotion then
		Panel_CheckedQuest:SetPosX( getScreenSizeX() - Panel_CheckedQuest:GetSizeX() - 20 )
		Panel_CheckedQuest:SetPosY( FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY() + 15 + newEquipGap )
	end
	
	-- 스케일 조절로 퀘스트 창이 화면밖으로 넘어갈 때에 대한 처리 > 밖으로 나간 부분이 있으면 위치 초기화
	if ( getScreenSizeX() < Panel_CheckedQuest:GetPosX() + Panel_CheckedQuest:GetSizeX() ) or ( getScreenSizeY() < Panel_CheckedQuest:GetPosY() + Panel_CheckedQuest:GetSizeY() ) then
		Panel_CheckedQuest:SetPosX( getScreenSizeX() - Panel_CheckedQuest:GetSizeX() - 20 )
		Panel_CheckedQuest:SetPosY( FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY() + 15 + newEquipGap )
	end
end


function QuestListChecked_EnableSimpleUI()
	updateQuestWidgetList( _startPosition )
end
registerEvent( "EventSimpleUIEnable",			"QuestListChecked_EnableSimpleUI")
registerEvent( "EventSimpleUIDisable",			"QuestListChecked_EnableSimpleUI")

--------------------------------------------------------------------
-- 위치 초기화, 스크린 리사이즈 대응
--------------------------------------------------------------------
local rateValue = nil
function FGlobal_QuestWindowRateSetting()
	rateValue = {}
	local sizeWithOutPanelX = getScreenSizeX() - Panel_CheckedQuest:GetSizeX()
	local sizeWithOutPanelY = getScreenSizeY() - Panel_CheckedQuest:GetSizeY()
	rateValue.x = math.max(math.min(Panel_CheckedQuest:GetPosX() / sizeWithOutPanelX, 1), 0)
	rateValue.y = math.max(math.min(Panel_CheckedQuest:GetPosY() / sizeWithOutPanelY, 1), 0)
end

function FromClient_questWidget_ResetPosition()
	isReconnectTutorial = false	-- 전투 튜토리얼 중 재접 처리용.
	local newEquipGap = 0
	if ( true == Panel_NewEquip:GetShow() ) then	-- 펄상점 스케일 변경 때문에 임시로 막는다.
		newEquipGap = Panel_NewEquip:GetSizeY()

		local _x1 = Panel_NewEquip:GetPosX()
		local _x2 = Panel_NewEquip:GetPosX() + Panel_NewEquip:GetSizeX()
		local _y1 = Panel_NewEquip:GetPosY()
		local _y2 = Panel_NewEquip:GetPosY() + Panel_NewEquip:GetSizeY()
		
		local x1 = Panel_CheckedQuest:GetPosX()
		local x2 = Panel_CheckedQuest:GetPosX() + Panel_CheckedQuest:GetSizeX()
		local y1 = Panel_CheckedQuest:GetPosY()
		local y2 = Panel_CheckedQuest:GetPosY() + Panel_CheckedQuest:GetSizeY()
		
		for xx = x1, x2, 20 do						-- 20픽셀씩 체크
			for yy = y1, y2, 20 do
				if (_x1 <= xx ) and ( xx <= _x2 ) and ( _y1 <= yy ) and ( yy <= _y2 ) then
					Panel_CheckedQuest:SetPosX( getScreenSizeX() - Panel_CheckedQuest:GetSizeX() - 20 )
					Panel_CheckedQuest:SetPosY( Panel_Radar:GetPosY() + Panel_Radar:GetSizeY() + 15 + newEquipGap )
					break;
				end
			end
		end
	end
	
	local haveServerPosotion = 0 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_CheckedQuest, chatIndex, CppEnums.PanelSaveType.PanelSaveType_IsSaved)	-- 서버 값이 있나?

	-- 길드 퀘스트를 받을 때, 겹치는 영역이 있으면 리포지션 / 아니면 그대로 둔다
	if not haveServerPosotion then
		Panel_CheckedQuest:SetPosX( getScreenSizeX() - Panel_CheckedQuest:GetSizeX() - 20 )
		Panel_CheckedQuest:SetPosY( FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY() + 15 + newEquipGap )
	end
	
	-- 스케일 조절로 퀘스트 창이 화면밖으로 넘어갈 때에 대한 처리 > 밖으로 나간 부분이 있으면 위치 초기화
	-- if ( nil ~= rateValue ) then
	-- 	local posX = ( getScreenSizeX() - Panel_CheckedQuest:GetSizeX() )  * rateValue.x
	-- 	local posY = ( getScreenSizeY() - Panel_CheckedQuest:GetSizeY() )  * rateValue.y
	-- 	Panel_CheckedQuest:SetPosX( posX )
	-- 	Panel_CheckedQuest:SetPosY( posY )
	-- 	rateValue = nil
	-- end

	-- isManualClick = false
	
	changePositionBySever(Panel_CheckedQuest, CppEnums.PAGameUIType.PAGameUIPanel_CheckedQuest, false, true, false)
end
UI.addRunPostRestorFunction( FromClient_questWidget_ResetPosition )

function TutorialQuestCompleteCheck()
	local questInfo = questList_isClearQuest(1038, 2) or 7 <= getSelfPlayer():get():getLevel()
	return questInfo
end

registerEvent("updateProgressQuestList", 					"FromClient_UpdateQuestSetPos")
registerEvent("FromClient_UpdateProgressGuildQuestList", 	"FromClient_UpdateQuestSetPos")
registerEvent("FromClient_UpdateQuestList", 				"FromClient_QuestWidget_Update")
registerEvent("onScreenResize", 							"FromClient_questWidget_ResetPosition" )
registerEvent("FromClient_SetQuestNavigationByServer",		"FromClient_SetQuestNavigationByServer" )
registerEvent("FromClient_SetQuestType",					"FromClient_SetQuestType" )
registerEvent("FromClient_UpdateQuestSortType",				"QuestWidget_DefaultTextureFunction" )

QuestListUIPool:clear()
QuestWidget_NationalCheck()
FromClient_QuestWidget_Update( false )

Panel_CheckedQuest:SetChildIndex(panelResizeButton, 9999 )	-- 리사이즈 버튼 맨 위로
Panel_CheckedQuest:SetChildIndex(guideQuestButton, 9999 )	-- 리사이즈 버튼 맨 위로
Panel_CheckedQuest:SetChildIndex(guideQuestNumber, 9999 )	-- 리사이즈 버튼 맨 위로
Panel_CheckedQuest:SetChildIndex(historyButton, 9999 )	-- 리사이즈 버튼 맨 위로
Panel_CheckedQuest:SetChildIndex(findGuild, 9999 )	-- 리사이즈 버튼 맨 위로

FGlobal_PanelMove(Panel_CheckedQuest, true)
