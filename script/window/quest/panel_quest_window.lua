-----------------------------------------------------------
-- Local 변수 설정
-----------------------------------------------------------
local UI_PUCT       = CppEnums.PA_UI_CONTROL_TYPE
local UI_color      = Defines.Color
local UI_TM         = CppEnums.TextMode
local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM 			= CppEnums.EProcessorInputMode

local isContentsEnableMedia		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 3 )
local isContentsEnableValencia	= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 4 )

local QuestListUIPool = 
{
	_listGroupBG				= {}
	,_listExtendCheck			= {}
	,_listGroupTitle			= {}
	,_listGroupTitleSub			= {}
	,_listQuestTypeIcon			= {}
	,_listQuestTitle			= {}
	,_listQuestTitleBG			= {}
	,_listQuestCompleteDest		= {}
	,_listQuestCondition		= {}
	,_listQuestImage			= {}
	,_listQuestImageBoarder		= {}
	,_listQuestNaviButton		= {}
	,_listQuestAutoNaviButton	= {}
	,_listQuestGiveupButton		= {}
	,_listQuestRewardButton		= {}
	,_listQuestClearIcon		= {}
	,_listQuestNaviEffect		= {}	
	
	,_countGroupBG				= 0	,_maxcountGroupBG				= 20 
	,_countExtendCheck			= 0	,_maxcountExtendCheck			= 20 
	,_countGroupTitle			= 0 ,_maxcountGroupTitle			= 20
	,_countGroupTitleSub		= 0 ,_maxcountGroupTitleSub			= 20
	,_countQuestTypeIcon		= 0	,_maxcountQuestTypeIcon			= 30	
	,_countQuestTitle			= 0 ,_maxcountQuestTitle			= 30
	,_countQuestTitleBG			= 0 ,_maxcountQuestTitleBG			= 30
	,_countQuestCompleteDest	= 0 ,_maxcountQuestCompleteDest		= 20
	,_countQuestCondition		= 0 ,_maxcountQuestCondition		= 30
	,_countQuestImage			= 0 ,_maxcountQuestImage			= 20
	,_countQuestImageBoarder	= 0 ,_maxcountQuestImageBoarder		= 20
	,_countQuestNaviButton		= 0	,_maxcountQuestNaviButton		= 20
	,_countQuestAutoNaviButton	= 0	,_maxcountQuestAutoNaviButton	= 20
	,_countQuestGiveupButton	= 0	,_maxcountQuestGiveupButton		= 20	
	,_countQuestRewardButton	= 0 ,_maxcountQuestRewardButton		= 20
	,_countQuestClearIcon		= 0 ,_maxcountQuestClearIcon		= 20
	,_countQuestNaviEffect		= 0	,_maxcountQuestNaviEffect		= 20	
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
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestCompleteDest,	UI_PUCT.PA_UI_CONTROL_STATICTEXT,	"StaticText_Quest_ClearNpc", 				self._maxcountQuestCompleteDest	)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listGroupTitle,			UI_PUCT.PA_UI_CONTROL_STATICTEXT, 	"StaticText_GroupQuest_Title", 				self._maxcountGroupTitle		)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listGroupTitleSub,		UI_PUCT.PA_UI_CONTROL_STATICTEXT, 	"StaticText_GroupQuest_Progress", 			self._maxcountGroupTitleSub		)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listExtendCheck,			UI_PUCT.PA_UI_CONTROL_CHECKBUTTON, 	"Checkbox_GroupQuest_ClearedQuest_Show", 	self._maxcountExtendCheck		)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestTitleBG,			UI_PUCT.PA_UI_CONTROL_STATIC,		"Static_Quest_Title_BG", 					self._maxcountQuestTitleBG		)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestTitle,			UI_PUCT.PA_UI_CONTROL_STATICTEXT,	"StaticText_Quest_Title", 					self._maxcountQuestTitle		)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestTypeIcon,		UI_PUCT.PA_UI_CONTROL_STATIC, 		"Static_Quest_Type", 						self._maxcountQuestTypeIcon		)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestCondition,		UI_PUCT.PA_UI_CONTROL_STATICTEXT,	"StaticText_Quest_Demand", 					self._maxcountQuestCondition	)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestImage,			UI_PUCT.PA_UI_CONTROL_STATIC,		"Static_Quest_Image", 						self._maxcountQuestImage		)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestImageBoarder,	UI_PUCT.PA_UI_CONTROL_STATIC,		"Static_Quest_ImageBoarder", 				self._maxcountQuestImageBoarder	)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestNaviEffect,		UI_PUCT.PA_UI_CONTROL_STATIC,		"Static_Quest_Icon_NaviEffect", 			self._maxcountQuestNaviEffect	)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestNaviButton,		UI_PUCT.PA_UI_CONTROL_CHECKBUTTON,	"Checkbox_Quest_Navi", 						self._maxcountQuestNaviButton	)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestAutoNaviButton,	UI_PUCT.PA_UI_CONTROL_CHECKBUTTON,	"CheckButton_AutoNavi", 						self._maxcountQuestAutoNaviButton	)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestGiveupButton,	UI_PUCT.PA_UI_CONTROL_BUTTON,		"Checkbox_Quest_Giveup", 					self._maxcountQuestGiveupButton	)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestRewardButton,	UI_PUCT.PA_UI_CONTROL_BUTTON,		"Checkbox_Quest_Reward", 					self._maxcountQuestRewardButton	)
	QuestListUIPool:prepareControl(stylePanel,	parantControl,	self._listQuestClearIcon,		UI_PUCT.PA_UI_CONTROL_STATIC,		"Static_Quest_Icon_ClearCheck", 			self._maxcountQuestClearIcon	)
	--Static_Quest_Icon_NaviEffect
	QuestListUIPool:clear()
end

-----------------------------------------------------------
-- 오브젝트 생성
-----------------------------------------------------------
function QuestListUIPool:newGroupBG()
	self._countGroupBG = self._countGroupBG + 1 
	return self._listGroupBG[self._countGroupBG - 1]
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
function QuestListUIPool:newQuestCondition()
	self._countQuestCondition = self._countQuestCondition + 1 
	return self._listQuestCondition[self._countQuestCondition - 1]
end
function QuestListUIPool:newQuestImage()
	self._countQuestImage = self._countQuestImage + 1 
	return self._listQuestImage[self._countQuestImage - 1]
end
function QuestListUIPool:newQuestImageBoarder()
	self._countQuestImageBoarder = self._countQuestImageBoarder + 1 
	return self._listQuestImageBoarder[self._countQuestImageBoarder - 1]
end
function QuestListUIPool:newQuestNaviButton()
	self._countQuestNaviButton = self._countQuestNaviButton + 1 
	return self._listQuestNaviButton[self._countQuestNaviButton - 1]
end
function QuestListUIPool:newQuestAutoNaviButton()
	self._countQuestAutoNaviButton = self._countQuestAutoNaviButton + 1 
	return self._listQuestAutoNaviButton[self._countQuestAutoNaviButton - 1]
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
function QuestListUIPool:newQuestClearIcon()
	self._countQuestClearIcon = self._countQuestClearIcon + 1 
	return self._listQuestClearIcon[self._countQuestClearIcon - 1]
end


-----------------------------------------------------------
-- 버튼 초기화
-----------------------------------------------------------
function QuestListUIPool:clear()
	self._countGroupBG				= 0
	self._countExtendCheck			= 0
	self._countGroupTitle			= 0
	self._countGroupTitleSub		= 0
	self._countQuestTypeIcon		= 0	
	self._countQuestTitle			= 0
	self._countQuestTitleBG			= 0
	self._countQuestCompleteDest	= 0
	self._countQuestCondition		= 0
	self._countQuestImage			= 0
	self._countQuestImageBoarder	= 0
	self._countQuestNaviButton		= 0	
	self._countQuestAutoNaviButton	= 0	
	self._countQuestGiveupButton	= 0	
	self._countQuestRewardButton	= 0
	self._countQuestClearIcon		= 0	
	self._countQuestNaviEffect		= 0
	QuestListUIPool:hideNotUse()
end


-----------------------------------------------------------
-- (사용하지 않는) 버튼 숨김
-----------------------------------------------------------
function QuestListUIPool:hideNotUse()
	for index = self._countGroupBG, self._maxcountGroupBG, 1 do
		self._listGroupBG[index]:SetShow(false)
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
	for index = self._countQuestCondition, self._maxcountQuestCondition, 1 do
		self._listQuestCondition[index]:SetShow(false)
	end
	for index = self._countQuestImage, self._maxcountQuestImage, 1 do
		self._listQuestImage[index]:SetShow(false)
	end
	for index = self._countQuestImageBoarder, self._maxcountQuestImageBoarder, 1 do
		self._listQuestImageBoarder[index]:SetShow(false)
	end
	for index = self._countQuestNaviButton, self._maxcountQuestNaviButton, 1 do
		self._listQuestNaviButton[index]:SetShow(false)
	end
	for index = self._countQuestAutoNaviButton, self._maxcountQuestAutoNaviButton, 1 do
		self._listQuestAutoNaviButton[index]:SetShow(false)
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
	for index = self._countQuestClearIcon, self._maxcountQuestClearIcon, 1 do
		self._listQuestClearIcon[index]:SetShow(false)
	end	
end


-----------------------------------------------------------
-- Panel 설정
-----------------------------------------------------------
Panel_Window_Quest_New:SetShow( false )
Panel_Window_Quest_New:setGlassBackground( true )
Panel_Window_Quest_New:ActiveMouseEventEffect(true)
Panel_Window_Quest_New:setMaskingChild( true )

Panel_Window_Quest_New:RegisterShowEventFunc( true, 'Panel_QuestListShowAni()' )
Panel_Window_Quest_New:RegisterShowEventFunc( false, 'Panel_QuestListHideAni()' )
Panel_Window_Quest_New:addInputEvent( "Mouse_DownScroll",   "QuestWindow_ScrollEvent(true)"      )
Panel_Window_Quest_New:addInputEvent( "Mouse_UpScroll",     "QuestWindow_ScrollEvent(false)"     )

Panel_Window_Quest_New:SetPosX( getScreenSizeX() - (getScreenSizeX()/2) )

local _buttonClose						= UI.getChildControl( Panel_Window_Quest_New,		"Button_Win_Close" )
_buttonClose:addInputEvent( "Mouse_LUp", "Panel_Window_QuestNew_Show( false )" )

local _buttonQuestion					= UI.getChildControl( Panel_Window_Quest_New,		"Button_Question" )
_buttonQuestion:addInputEvent( "Mouse_LUp", "" )

local questListWindow_BG				= UI.getChildControl( Panel_Window_Quest_New,		"Static_BG" )
questListWindow_BG:SetNotAbleMasking( true )
questListWindow_BG:setGlassBackground( true )

-- 퀘스트 선호 타입
local MAX_QUEST_FAVOR_TYPE = 6
local questFavorType = {}
for ii = 0, MAX_QUEST_FAVOR_TYPE-1, 1 do
	local controlIdNumber = ii+1
	local controlId = "CheckButton_FavorType_" .. tostring(controlIdNumber)
	local control = UI.getChildControl( Panel_Window_Quest_New, controlId )
	control:addInputEvent( "Mouse_LUp", "QuestWindow_SelectQuestFavorType(" .. ii .. ")" )
	questFavorType[ii] = control
end
-- questFavorType[0]:SetMonoTone( true )
-- questFavorType[0]:SetIgnore( true )
-- questFavorType[0]:SetCheck( true )

function QuestWindow_SelectQuestFavorType( selectType )
	if 0 == selectType then
		_update_QuestWindowSetCheckAll()
	else
		ToClient_ToggleQuestSelectType( selectType )
	end
	FGlobal_UpdateQuestFavorType()
end

function _update_QuestWindowSetCheckAll()
	local isCheck = questFavorType[0]:IsCheck()
	for i = 1, MAX_QUEST_FAVOR_TYPE - 1 do
		if isCheck == ( not questFavorType[i]:IsCheck() ) then
			ToClient_ToggleQuestSelectType( i )
			questFavorType[i]:SetCheck( isCheck )
		end
	end
end

function QuestWindow_NationalCheck()
	if isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_RUS ) then
		_update_QuestWindowSetCheckAll()
	end
end

function updateQuestWindowFavorType()
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

local questListWindow_ContentBG			= UI.getChildControl( Panel_Window_Quest_New,		"Static_LineBG" )
questListWindow_ContentBG:SetNotAbleMasking( true )
questListWindow_ContentBG:SetAlpha(0.8)
questListWindow_ContentBG:SetIgnore( false )
questListWindow_ContentBG:addInputEvent( "Mouse_DownScroll", "QuestWindow_ScrollEvent(true)"      )
questListWindow_ContentBG:addInputEvent( "Mouse_UpScroll",   "QuestWindow_ScrollEvent(false)"      )

local questCount						= UI.getChildControl( Panel_Window_Quest_New,		"StaticText_QuestCount" )

local filter_Zone						= UI.getChildControl( Panel_Window_Quest_New,		"Combobox_Filter_Zone" )
local filter_Zone_Box					= UI.getChildControl( filter_Zone,		"Combobox_List" )
local filter_Zone_Scroll				= UI.getChildControl( filter_Zone_Box,		"Combobox_List_Scroll" )
filter_Zone:addInputEvent( "Mouse_LUp", "_questWindow_ToggleFilterZone()" )

local filter_QuestType					= UI.getChildControl( Panel_Window_Quest_New,		"Combobox_Filter_QuestType" )
local filter_QuestType_Box				= UI.getChildControl( filter_QuestType,		"Combobox_List" )
local filter_QuestType_Scroll			= UI.getChildControl( filter_QuestType_Box,		"Combobox_List_Scroll" )
filter_QuestType:addInputEvent( "Mouse_LUp", "_questWindow_ToggleFilterQuestType()" )

local questListWindow_ScrollBar			= UI.getChildControl( Panel_Window_Quest_New,		"Scroll_CheckQuestList" )
questListWindow_ScrollBar:SetShow( true )
questListWindow_ScrollBar:SetControlTop()
questListWindow_ScrollBar:addInputEvent( "Mouse_LPress", "QuestWindow_ScrollLPress()" )
questListWindow_ScrollBar:SetPosX( Panel_Window_Quest_New:GetSizeX() - questListWindow_ScrollBar:GetSizeX() - 15 )

local questListWindow_ScrollBar_CtrBT	= UI.getChildControl( questListWindow_ScrollBar,	"Scroll_CtrlButton"	)
questListWindow_ScrollBar_CtrBT:addInputEvent( "Mouse_LPress", "QuestWindow_ScrollLPress()" )
-- questListWindow_ScrollBar_CtrBT:SetNotAbleMasking( true )

local helpWidgetBase 	= UI.getChildControl ( Panel_CheckedQuest, "StaticText_Notice_1")
local ButtonTooltip	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_Quest_New, "HelpWindow_For_QuestWindow" )
CopyBaseProperty( helpWidgetBase, ButtonTooltip )
ButtonTooltip:SetColor( ffffffff )
ButtonTooltip:SetAlpha( 1.0 )
ButtonTooltip:SetFontColor( UI_color.C_FFC4BEBE )
ButtonTooltip:SetAutoResize( true )
ButtonTooltip:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
ButtonTooltip:SetShow( false )

local 	_buttonQuestion = UI.getChildControl( Panel_Window_Quest_New, "Button_Question" )								-- 물음표 버튼
	_buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelQuestHistory\" )" )				-- 물음표 좌클릭
	_buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"PanelQuestHistory\", \"true\")" )		-- 물음표 마우스오버
	_buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"PanelQuestHistory\", \"false\")" )		-- 물음표 마우스아웃

-----------------------------------------------------------
-- local 임시 변수 설정
-----------------------------------------------------------
QuestListUIPool:initialize(Panel_CheckedQuest, Panel_Window_Quest_New)

local _startPosition			= 0			-- 리스트에 첫 번째 퀘스트 번호
local _setLastQuestOfList		= 0			-- 리스트에 마지막 퀘스트 번호
local _questGroupCount			= 0			-- 퀘스트 마지막 그룹 값 저장용
local _next_QuestPosY			= 0			-- 다음 퀘스트 리스트 위치 저장용
local list_Space				= 10		-- 퀘스트 리스트 간격 기본 값
local temp_GroupSizeY			= 110		-- 스크롤 컨트롤 버튼 사이즈 계산을 위한 변수
local questObjectCount			= 0
local displayGroupQuestCount	= 0
local _scrollBar_MoveOneStep	= 0
local _isDontDownScroll 		= false
local filterZone_id				= -1		-- 지역 필터 변수
local filterQuestType_id		= -1		-- 타입 필터 변수

-----------------------------------------------------------
-- 윈도우 애니메이션
-----------------------------------------------------------
function Panel_QuestListShowAni()
	local aniInfo1 = Panel_Window_Quest_New:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.05)
	aniInfo1.AxisX = Panel_Window_Quest_New:GetSizeX() / 2
	aniInfo1.AxisY = Panel_Window_Quest_New:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_Window_Quest_New:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.05)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_Window_Quest_New:GetSizeX() / 2
	aniInfo2.AxisY = Panel_Window_Quest_New:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function Panel_QuestListHideAni()
	Panel_Window_Quest_New:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo1 = Panel_Window_Quest_New:addColorAnimation( 0.0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
end


-----------------------------------------------------------
-- 스크롤 초기화
-----------------------------------------------------------
function QuestWindow_ScrollBar_initialize()
	questListWindow_ScrollBar:SetInterval( _questGroupCount - 1 )
end


-----------------------------------------------------------
-- 스크롤 롤링 이벤트
-----------------------------------------------------------
function QuestWindow_ScrollEvent( UpDown )
	local prevPos = _startPosition

	if true == UpDown then
	-- 휠을 아래로 돌리면,
		if (true == _isDontDownScroll) then
			return 
		end
		_startPosition = _startPosition + 1
	else
	-- 휠을 위로 돌리면, 
		if _startPosition <= 0 then
			return
		end
		_startPosition = _startPosition - 1
	end
	
	if( prevPos ~= _startPosition ) then
		-- QuestWindowNpcNavi_ClearCheckBox()
		updateQuestWindowList( _startPosition )
		questWindow_updateScrollPosition()
	end
end


-----------------------------------------------------------
-- 스크롤 LPress 이벤트
-----------------------------------------------------------
local _scrollBar_LPress_Pos 	= 0 
local _maxscrollBarPos			= 0
function QuestWindow_ScrollLPress()
	-- 스크롤바 위치를 시작 값으로 변환.(반올림=0.5를 더하고 버림)
	local prevPos = _startPosition
	local currentPos = math.floor( ( questListWindow_ScrollBar:GetControlPos() * ( _questGroupCount - 1 ) ) + 0.5 )

	if prevPos ~= currentPos then
		if(prevPos < _startPosition and _isDontDownScroll) then
			return 
		end
		_startPosition = currentPos
		updateQuestWindowList( _startPosition )
	end
end

function questWindow_updateScrollButtonSize()
	questListWindow_ScrollBar:SetSize( questListWindow_ScrollBar:GetSizeX(), Panel_Window_Quest_New:GetSizeY() - 80 - 20 )
	local scrollButtonSizePercent = ( ((Panel_Window_Quest_New:GetSizeY()-80) / temp_GroupSizeY ) / _questGroupCount ) * 100
	
	if( scrollButtonSizePercent < 10) then scrollButtonSizePercent = 10
	elseif( 99 < scrollButtonSizePercent ) then scrollButtonSizePercent = 99 
	end

	questListWindow_ScrollBar_CtrBT:SetSize( questListWindow_ScrollBar_CtrBT:GetSizeX(), ((questListWindow_ScrollBar:GetSizeY() / 100) * scrollButtonSizePercent) )
end

function questWindow_updateScrollPosition()
	local posY 		= questListWindow_ScrollBar:GetSizeY() * ( _startPosition / _questGroupCount )
	local maxPosY	= questListWindow_ScrollBar:GetSizeY() -  questListWindow_ScrollBar_CtrBT:GetSizeY()
	if( maxPosY < posY ) then
		questListWindow_ScrollBar_CtrBT:SetPosY( maxPosY )
	else
		questListWindow_ScrollBar_CtrBT:SetPosY( posY )
	end
end

-----------------------------------------------------------
-- 필터 생성
-----------------------------------------------------------
local create_QuestFilter = function()
	-- -1 : 필터 없음 ~ 8 : 발렌시아
	filter_Zone:AddItem( " " .. PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_WINDOW_FILTER_ZONE_1"))							-- 0, -1
	filter_Zone:AddItem( " " .. PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_WINDOW_FILTER_ZONE_2"), UI_color.C_FFC4BEBE )		-- 1, 1
	filter_Zone:AddItem( " " .. PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_WINDOW_FILTER_ZONE_3"), UI_color.C_FFC4BEBE )		-- 2, 2
	filter_Zone:AddItem( " " .. PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_WINDOW_FILTER_ZONE_4"), UI_color.C_FFC4BEBE )		-- 3, 3
	filter_Zone:AddItem( " " .. PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_WINDOW_FILTER_ZONE_5"), UI_color.C_FFC4BEBE )		-- 4, 4
	filter_Zone:AddItem( " " .. PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_WINDOW_FILTER_ZONE_6"), UI_color.C_FFC4BEBE )		-- 5, 5
	filter_Zone:AddItem( " " .. PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_WINDOW_FILTER_ZONE_7"), UI_color.C_FFC4BEBE )		-- 6, 6
	if isContentsEnableMedia then
		filter_Zone:AddItem( " " .. PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_WINDOW_FILTER_ZONE_15"), UI_color.C_FFC4BEBE )		-- 7, 7
	end
	if isContentsEnableValencia then
		filter_Zone:AddItem( " " .. PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_WINDOW_FILTER_ZONE_16"), UI_color.C_FFC4BEBE )		-- 8, 8
	end

	filter_QuestType:AddItem( " " .. PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_WINDOW_FILTER_ZONE_1"),	UI_color.C_FFC4BEBE )		-- 0, -1
	filter_QuestType:AddItem( " " .. PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_WINDOW_FILTER_ZONE_8"),	UI_color.C_FFC4BEBE )		-- 1, 0
	filter_QuestType:AddItem( " " .. PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_WINDOW_FILTER_ZONE_9"),	UI_color.C_FFC4BEBE )		-- 2, 1
	filter_QuestType:AddItem( " " .. PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_WINDOW_FILTER_ZONE_10"),	UI_color.C_FFC4BEBE )		-- 3, 2
	filter_QuestType:AddItem( " " .. PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_WINDOW_FILTER_ZONE_11"),	UI_color.C_FFC4BEBE )		-- 4, 3
	filter_QuestType:AddItem( " " .. PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_WINDOW_FILTER_ZONE_12"),	UI_color.C_FFC4BEBE )		-- 5, 4
	filter_QuestType:AddItem( " " .. PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_WINDOW_FILTER_ZONE_13"),	UI_color.C_FFC4BEBE )		-- 6, 5
	filter_QuestType:AddItem( " " .. PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_WINDOW_FILTER_ZONE_14"),	UI_color.C_FFC4BEBE )		-- 7, 6
	-- filter_QuestType:AddItem( "완료",		UI_color.C_FFFFFFFF )		-- 8, 7
end
create_QuestFilter()

local filterZoneSelectedId = -1
function _questWindow_ToggleFilterZone()
	Panel_Window_Quest_New:SetChildIndex(filter_Zone, 9999 )
	local	list = filter_Zone:GetListControl()
	list:addInputEvent( "Mouse_LUp", "_questWindow_ToggleFilterZoneSelect()" )
	if -1 ~= filterZoneSelectedId then
		filter_Zone:SetSelectItemKey( filterZoneSelectedId )
	end
	local tmp = filter_Zone:GetListControl()
	local listCount = tmp:GetItemSize()
	tmp:SetSize( tmp:GetSizeX(), listCount*20 )
	filter_Zone_Scroll:SetSize( filter_QuestType_Scroll:GetSizeX(), tmp:GetSizeY() )
	tmp:SetItemQuantity(listCount)
	filter_Zone:ToggleListbox()
end
function _questWindow_ToggleFilterZoneSelect()
	local	selectIndex		= filter_Zone:GetSelectIndex()
	if		0 ==	selectIndex	then	filterZone_id = -1;	filterZoneSelectedId = 0
	elseif	1 ==	selectIndex then	filterZone_id = 1;	filterZoneSelectedId = 1
	elseif	2 ==	selectIndex then	filterZone_id = 2;	filterZoneSelectedId = 2
	elseif	3 ==	selectIndex then	filterZone_id = 3;	filterZoneSelectedId = 3
	elseif	4 ==	selectIndex then	filterZone_id = 4;	filterZoneSelectedId = 4
	elseif	5 ==	selectIndex then	filterZone_id = 5;	filterZoneSelectedId = 5
	elseif	6 ==	selectIndex then	filterZone_id = 6;	filterZoneSelectedId = 6
	elseif	7 ==	selectIndex then	filterZone_id = 7;	filterZoneSelectedId = 7
	elseif	8 ==	selectIndex then	filterZone_id = 8;	filterZoneSelectedId = 8
	else
		filterZone_id = -1;	filterZoneSelectedId = 0
	end
	ToClient_SetQuestRegionFilter( filterZone_id )
	filter_Zone:SetSelectItemKey( filterZoneSelectedId )
	_questWindow_ToggleFilterZone()
end

local filterQuestTypeSelectedId = -1
function _questWindow_ToggleFilterQuestType()
	Panel_Window_Quest_New:SetChildIndex(filter_QuestType, 9999 )
	local	list = filter_QuestType:GetListControl()
	list:addInputEvent( "Mouse_LUp", "_questWindow_ToggleFilterQuestTypeSelect()" )
	if -1 ~= filterQuestTypeSelectedId then
		filter_QuestType:SetSelectItemKey( filterQuestTypeSelectedId )
	end
	local tmp = filter_QuestType:GetListControl()
	local listCount = tmp:GetItemSize()
	tmp:SetSize( tmp:GetSizeX(), listCount*20 )
	filter_QuestType_Scroll:SetSize( filter_QuestType_Scroll:GetSizeX(), tmp:GetSizeY() )
	tmp:SetItemQuantity(listCount)
	filter_QuestType:ToggleListbox()
end
function _questWindow_ToggleFilterQuestTypeSelect()
	local	selectIndex		= filter_QuestType:GetSelectIndex()
	if		0 ==	selectIndex	then	filterQuestType_id = -1;	filterQuestTypeSelectedId = 0
	elseif	1 ==	selectIndex then	filterQuestType_id = 0;		filterQuestTypeSelectedId = 1
	elseif	2 ==	selectIndex then	filterQuestType_id = 1;		filterQuestTypeSelectedId = 2
	elseif	3 ==	selectIndex then	filterQuestType_id = 2;		filterQuestTypeSelectedId = 3
	elseif	4 ==	selectIndex then	filterQuestType_id = 3;		filterQuestTypeSelectedId = 4
	elseif	5 ==	selectIndex then	filterQuestType_id = 4;		filterQuestTypeSelectedId = 5
	elseif	6 ==	selectIndex then	filterQuestType_id = 5;		filterQuestTypeSelectedId = 6
	elseif	7 ==	selectIndex then	filterQuestType_id = 6;		filterQuestTypeSelectedId = 7
	elseif	8 ==	selectIndex then	filterQuestType_id = 7;		filterQuestTypeSelectedId = 8
	elseif	9 ==	selectIndex then	filterQuestType_id = 8;		filterQuestTypeSelectedId = 9
	else
		filterQuestType_id = -1;	filterQuestTypeSelectedId = 0
	end
	ToClient_SetQuestTypeFilter( filterQuestType_id )
	_questWindow_ToggleFilterQuestType()
end
-----------------------------------------------------------
-- 리스트 업데이트
-----------------------------------------------------------

function FromClient_QuestWindow_Update()
	-- _startPosition = 0
	-- questListWindow_ScrollBar:SetControlTop()
	questWindow_updateScrollButtonSize()
	updateQuestWindowList( _startPosition )
end

function questWindow_GetProgressCount()													-- 실제 진행중인 의뢰수
	local questListInfo 		= ToClient_GetQuestList()								-- 퀘스트 정보를 담는다.
	local temp_questGroupCount	= questListInfo:getQuestGroupCount()
	local temp_progressCount	= 0
	for questGroupIndex = 0, temp_questGroupCount - 1 do
		local temp_questGroupInfo = questListInfo:getQuestGroupAt( questGroupIndex )
		if ( true == temp_questGroupInfo:isGroupQuest() ) then
			local tempGroupCount = temp_questGroupInfo:getQuestCount()
			for questGroupIdx = 0, tempGroupCount - 1 do
				local tempQuestInfo = temp_questGroupInfo:getQuestAt( questGroupIdx )
				-- 진행중이냐?
				if tempQuestInfo._isProgressing and not tempQuestInfo._isCleared then
					temp_progressCount = temp_progressCount + 1
				end
			end
		else
			local tempQuestInfo = temp_questGroupInfo:getQuestAt( questGroupIdx )
			-- 진행중이냐?
			if tempQuestInfo._isProgressing and not tempQuestInfo._isCleared then
				temp_progressCount = temp_progressCount + 1
			end
		end
	end
	return temp_progressCount
end

function updateQuestWindowList( startPosition )
	if( 0 ~= _maxscrollBarPos ) and ( _maxscrollBarPos < startPosition) then
		startPosition = _maxscrollBarPos
	end

	-- 초기화!
	QuestListUIPool:clear()																-- UIPool 초기화
	_next_QuestPosY 			= 135													-- 다음 퀘스트 위치 초기화
	displayGroupQuestCount		= 0

	local questListInfo 		= ToClient_GetQuestList()								-- 퀘스트 정보를 담는다.
	_questGroupCount 			= ( questListInfo:getQuestGroupCount() - 1 )			-- 체크 된 퀘스트 수
	
	questListWindow_ScrollBar:SetInterval( _questGroupCount - 2 )						-- 그룹 개수에 따라 인터벌 갱신

	if 0 == ( _questGroupCount + 1) then												-- 캐릭터 생성 대비! 켜있긴 하지만, 선택되지 않는다.
		questListWindow_ScrollBar:SetShow( false )
		return
	else
		questListWindow_ScrollBar:SetShow( true )

		for questGroupIndex = startPosition, _questGroupCount, 1 do
			local questGroupInfo 	= questListInfo:getQuestGroupAt( questGroupIndex )	-- 그룹정보

			local uiGroupCheckBTN = QuestListUIPool:newExtendButton()
			uiGroupCheckBTN:SetPosY( _next_QuestPosY - 5 )
			uiGroupCheckBTN:SetPosX( 15 )
			if 10 < getSelfPlayer():get():getLevel() then
				uiGroupCheckBTN:SetShow( true )
			else
				uiGroupCheckBTN:SetShow( false )
			end
			uiGroupCheckBTN:addInputEvent( "Mouse_LUp", "HandleClicked_QuestShowCheck(" .. questGroupInfo:getQuestNo()._group .. "," ..questGroupInfo:getQuestNo()._quest .. ")" )

			if true == questGroupInfo:isCheckShow() then
				uiGroupCheckBTN:SetCheck( true )
			else
				uiGroupCheckBTN:SetCheck( false )
			end

			if ( true == questGroupInfo:isGroupQuest() ) then
				_next_QuestPosY = QuestWindow_GroupQuestInfo( questGroupInfo, _next_QuestPosY, questGroupIndex )
			else
				local uiQuestInfo = questGroupInfo:getQuestAt( 0 )
				_next_QuestPosY = QuestWindow_QuestInfo( questGroupInfo, uiQuestInfo, _next_QuestPosY, true, questGroupIndex, 0, nil, 0 )
			end

			if (_next_QuestPosY > Panel_Window_Quest_New:GetSizeY()) then
				_maxscrollBarPos = 0
				_isDontDownScroll = false
				questListWindow_ScrollBar:SetShow( true )
				break
			else
				_maxscrollBarPos = startPosition
				_isDontDownScroll = true
				if 0 == startPosition then
					questListWindow_ScrollBar:SetShow( false )
				end
			end
		end
		questCount:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_QUESTWINDOW_COUNTQUEST", "count", questWindow_GetProgressCount() ) ) -- 의뢰수 : 9

		
		questObjectCount		= 0
		_scrollBar_LPress_Pos	= 0		
	end

	if(0 == _startPosition) then
		questWindow_updateScrollButtonSize()
	end
end

function QuestWindow_GroupQuestInfo( questGroupInfo, _next_QuestPosY, questGroupIndex )

	local tmp_next_GroupPosY 	= _next_QuestPosY
	local tmp_Quest_ClearCount 	= 0									-- 퀘스트 완료수 체크용 변수
	local tmp_Quest_Clear 		= 0									-- 퀘스트 함수에서 넘어오는 완료수 임시 변수

	--------------------------------------------------------------------
	-- 그룹 퀘스트 타이틀 설정
	--------------------------------------------------------------------
	local questGroupTitle	= questGroupInfo:getTitle()	
	local questGroupCount	= questGroupInfo:getTotalQuestCount()				
	local uiGroupTitle		= QuestListUIPool:newGroupTitle()
	uiGroupTitle:SetFontColor( UI_color.C_FFEEBA3E )
	uiGroupTitle:SetAutoResize(true)
	uiGroupTitle:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
	uiGroupTitle:SetText( questGroupTitle )
	uiGroupTitle:SetTextSpan( 10, -1 )
	uiGroupTitle:SetShow( true )
	uiGroupTitle:SetPosY( tmp_next_GroupPosY - 4 )
	uiGroupTitle:SetPosX( 35 )
	uiGroupTitle:SetSize( 400, uiGroupTitle:GetSizeY() )
	uiGroupTitle:SetIgnore( false )
	uiGroupTitle:addInputEvent( "Mouse_DownScroll", "QuestWindow_ScrollEvent(true)"      )
	uiGroupTitle:addInputEvent( "Mouse_UpScroll",   "QuestWindow_ScrollEvent(false)"      )

	local uiGroupProgress = QuestListUIPool:newGroupTitleSub()
	uiGroupProgress:SetTextSpan( 10, 1 )
	uiGroupProgress:SetShow(true)
	uiGroupProgress:SetPosY( tmp_next_GroupPosY - 5 )
	uiGroupProgress:SetPosX( uiGroupTitle:GetPosX() + uiGroupTitle:GetSizeX() - uiGroupProgress:GetSizeX() )

	tmp_next_GroupPosY = tmp_next_GroupPosY + uiGroupTitle:GetSizeY() + 5

	--------------------------------------------------------------------
	-- 퀘스트 정보
	--------------------------------------------------------------------
	for questIndex = 0, questGroupInfo:getQuestCount() - 1, 1 do
		-- 퀘스트 정보
		local uiQuestInfo = questGroupInfo:getQuestAt( questIndex )
		tmp_next_GroupPosY, tmp_Quest_Clear = QuestWindow_QuestInfo( questGroupInfo, uiQuestInfo, tmp_next_GroupPosY, false, questGroupIndex, questIndex, questGroupTitle, questGroupCount )
		tmp_Quest_ClearCount = tmp_Quest_ClearCount + tmp_Quest_Clear				-- 퀘스트 완료수 카운트
	end
	uiGroupProgress:SetText( tmp_Quest_ClearCount .. "/" .. questGroupInfo:getTotalQuestCount() .. " " .. PAGetString(Defines.StringSheet_GAME, "DIALOG_BUTTON_QUEST_COMPLETE") )
	return tmp_next_GroupPosY
end

function QuestWindow_QuestInfo( questGroupInfo, uiQuestInfo, _next_QuestPosY, isSingle, questGroupIndex, questIndex, groupTitle, questGroupCount )

	local tmp_next_QuestPosY 		= _next_QuestPosY

	local questCondition_Check		= {}
	local questCondition_AllCheck	= 0
	local tmp_Quest_Clear 			= 0															-- 퀘스트 완료 여부 저장 변수

	questObjectCount 				= questObjectCount + 1										-- 퀘스트 오브젝트 카운트

	local QuestGroupId			= uiQuestInfo:getQuestNo()._group
	local QuestId				= uiQuestInfo:getQuestNo()._quest
	
	if true == uiQuestInfo._isCleared then														-- 클리어 했으면

		tmp_next_QuestPosY, tmp_Quest_Clear = _questWindownInfo_Cleared( uiQuestInfo, tmp_next_QuestPosY, tmp_Quest_Clear )

	elseif (false == uiQuestInfo._isCleared) and (false == uiQuestInfo._isProgressing) then 	-- 클리어 안했고 진행중도 아니면

		-- tmp_next_QuestPosY = _questWindowInfo_Next( uiQuestInfo, QuestGroupId, QuestId, tmp_next_QuestPosY )

	else																						-- 진행 중이면

		tmp_next_QuestPosY = _questWindowInfo_Progressing( questGroupInfo, uiQuestInfo, QuestGroupId, QuestId, tmp_next_QuestPosY, isSingle, groupTitle, questGroupCount )

	end

	return tmp_next_QuestPosY, tmp_Quest_Clear
end
function _questWindownInfo_Cleared( uiQuestInfo, tmp_next_QuestPosY, tmp_Quest_Clear )
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
	uiQuestTitle:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_QUEST_WINDOW_COMPLETEQUEST", "questTitle", questTitle ) ) -- questTitle .. "(완료)" )
	uiQuestTitle:SetFontColor( UI_color.C_FF888888 )
	uiQuestTitle:SetPosY( tmp_next_QuestPosY - list_Space )
	uiQuestTitle:SetLineRender(true)
	uiQuestTitle:SetShow( true )
	
	if true == isSingle then													-- 단일 퀘스트면 들여쓰기
		uiQuestTitleBG		:SetPosX( 30 )
		uiQuestTitle		:SetPosX( 55 )
		uiQuestTypeIcon		:SetPosX( 35 )
	else
		uiQuestTitleBG		:SetPosX( 60 )
		uiQuestTitle		:SetPosX( 85 )
		uiQuestTypeIcon		:SetPosX( 65 )
	end

	tmp_Quest_Clear		= tmp_Quest_Clear + 1										-- 퀘스트 클리어 카운트
	tmp_next_QuestPosY	= tmp_next_QuestPosY + ( list_Space * 2 )

	return tmp_next_QuestPosY, tmp_Quest_Clear
end
function _questWindowInfo_Next( uiQuestInfo, questGroupId, questId, tmp_next_QuestPosY )

	local uiQuestTypeIcon 			= QuestListUIPool:newQuestTypeIcon()
	uiQuestTypeIcon:SetPosY( tmp_next_QuestPosY - 6 )
	uiQuestTypeIcon:SetShow( true )

	FGlobal_ChangeOnTextureForDialogQuestIcon(uiQuestTypeIcon, uiQuestInfo:getQuestType())		-- 타입에 맞춰 아이콘 변경
	
	tmp_next_QuestPosY = tmp_next_QuestPosY + 4

	local uiQuestTitleBG 	= QuestListUIPool:newQuestTitleBG()
	local uiQuestTitle 		= QuestListUIPool:newQuestTitle()
	uiQuestTitleBG		:SetPosY( tmp_next_QuestPosY - 10 )
	uiQuestTitleBG		:SetShow( true )
	if 0 == uiQuestInfo:getQuestType() then
		uiQuestTitle	:SetFontColor( 4290209076 )	-- UI_color.C_FF88DF00
		uiQuestTitle	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_NEXTQUEST_NOTYET_BLACKSPIRIT") )
		-- 조건이 만족되면 흑정령에게 받을 수 있습니다.
	else
		uiQuestTitle	:SetFontColor( 4287405590 )	-- UI_color.C_FFFFEEA0
		uiQuestTitle	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_NEXTQUEST_NOTYET_OTHER") )
		-- 아직 의뢰 받지 않았습니다.
	end
	
	uiQuestTitle		:SetPosY( tmp_next_QuestPosY - list_Space )
	uiQuestTitle		:SetLineRender(false)
	uiQuestTitle		:SetShow( true )

	local uiQuestNaviButton 	= QuestListUIPool:newQuestNaviButton()
	local uiQuestAutoNaviButton = QuestListUIPool:newQuestAutoNaviButton()

	-- 흑정령 퀘스트가 아니라면 노출
	if 0 ~= uiQuestInfo:getQuestType() then
		-- 길찾기버튼
		uiQuestNaviButton		:SetPosY( tmp_next_QuestPosY - 8 )									-- 나머지 세팅은 아래에서
		uiQuestNaviButton		:SetShow( true )
		uiQuestAutoNaviButton	:SetPosY( tmp_next_QuestPosY - 8 )									-- 나머지 세팅은 아래에서
		uiQuestAutoNaviButton	:SetShow( true )
		
		local _questGroupId, _questId, _naviInfoAgain = _QuestWidget_ReturnQuestState()
		-- 네비 클릭 판별
		if _questGroupId == questGroupId and _questId == questId then
			if true == _naviInfoAgain then
				uiQuestNaviButton		:SetCheck( false )
				uiQuestAutoNaviButton	:SetCheck( false )
			else
				if ( uiQuestAutoNaviButton:IsCheck() == true ) then
					uiQuestAutoNaviButton	:SetCheck( true )
					uiQuestNaviButton		:SetCheck( true )
				else
					uiQuestAutoNaviButton	:SetCheck( false )
					uiQuestNaviButton		:SetCheck( true )
				end
			end
		else
			uiQuestNaviButton		:SetCheck( false )
			uiQuestAutoNaviButton	:SetCheck( false )
		end

		uiQuestNaviButton:addInputEvent("Mouse_On", "QuestWindow_questButtonToolTip( true, \"navi\" )")
		uiQuestNaviButton:addInputEvent("Mouse_Out", "QuestWindow_questButtonToolTip( false, \"navi\" )")
		uiQuestNaviButton:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_FindTarget( " .. questGroupId .. ", " .. questId .. ", " .. 99 .. ", false)")
	end

	if true == isSingle then													-- 단일 퀘스트면 들여쓰기
		uiQuestTitleBG	:SetPosX( 30 )
		uiQuestTitle	:SetPosX( 55 )
		uiQuestTypeIcon	:SetPosX( 35 )
	else
		uiQuestTitleBG	:SetPosX( 60 )
		uiQuestTitle	:SetPosX( 85 )
		uiQuestTypeIcon	:SetPosX( 65 )
	end

	tmp_next_QuestPosY = tmp_next_QuestPosY + ( list_Space * 2 )

	return tmp_next_QuestPosY
end
function _questWindowInfo_Progressing( questGroupInfo, uiQuestInfo, questGroupId, questId, tmp_next_QuestPosY, isSingle, groupTitle, questGroupCount )
	local selfLevel = getSelfPlayer():get():getLevel()
	if nil == groupTitle then
		groupTitle = "nil"
	end
	local progressingStartPosY		= tmp_next_QuestPosY						-- 각 진행중인 퀘스트의 BG 사이즈 조절용 변수.
	local uigroupBG					= QuestListUIPool:newGroupBG()				-- 퀘스트별 BG를 만든다.
	uigroupBG:SetShow( true )
	uigroupBG:SetPosY( tmp_next_QuestPosY - 6 )
	uigroupBG:addInputEvent( "Mouse_DownScroll", "QuestWindow_ScrollEvent(true)"      )
	uigroupBG:addInputEvent( "Mouse_UpScroll",   "QuestWindow_ScrollEvent(false)"      )

	local uiQuestTypeIcon 			= QuestListUIPool:newQuestTypeIcon()
	uiQuestTypeIcon:SetPosY( tmp_next_QuestPosY - 6 )
	uiQuestTypeIcon:SetPosX( 5 )
	uiQuestTypeIcon:SetShow( true )
	
	FGlobal_ChangeOnTextureForDialogQuestIcon(uiQuestTypeIcon, uiQuestInfo:getQuestType())		-- 타입에 맞춰 아이콘 변경
	
	tmp_next_QuestPosY = tmp_next_QuestPosY + 4

	local uiQuestTitleBG 			= QuestListUIPool:newQuestTitleBG()

	local questTitle 				= uiQuestInfo:getTitle()
	local recommandLevel			= uiQuestInfo:getRecommendLevel()
	local selfPlayerLevel			= getSelfPlayer():get():getLevel()
	if nil ~= recommandLevel and 0 ~= recommandLevel then
		questTitle = questTitle .. "(Lv." .. recommandLevel .. ")"
	end
	
	local uiQuestTitle 				= QuestListUIPool:newQuestTitle()
	uiQuestTitleBG:SetPosY( tmp_next_QuestPosY - 10 )
	uiQuestTitleBG:SetShow( true )	
	
	if 0 == uiQuestInfo:getQuestType() then
		uiQuestTitle:SetFontColor( 4290209076 )	-- UI_color.C_FF88DF00
	else
		uiQuestTitle:SetFontColor( 4287405590 )	-- UI_color.C_FFFFEEA0
	end
	uiQuestTitle:SetText( questTitle )
	uiQuestTitle:SetPosY( tmp_next_QuestPosY - list_Space )
	uiQuestTitle:SetLineRender(false)
	uiQuestTitle:SetShow( true )
	uiQuestTitle:addInputEvent( "Mouse_DownScroll", "QuestWindow_ScrollEvent(true)"      )
	uiQuestTitle:addInputEvent( "Mouse_UpScroll",   "QuestWindow_ScrollEvent(false)"      )

	local questCompleteNpc 			= uiQuestInfo:getCompleteDisplay()
	local uiQuestCompleteNpc 		= QuestListUIPool:newCompleteDest()
	uiQuestCompleteNpc:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "QUESTLIST_COMPLETETARGET", "getCompleteDisplay", questCompleteNpc ) ) -- 완료 대상 : 이고르
	uiQuestCompleteNpc:SetPosY( tmp_next_QuestPosY + list_Space )
	uiQuestCompleteNpc:SetShow( true )
	uiQuestCompleteNpc:addInputEvent( "Mouse_DownScroll",   "QuestWindow_ScrollEvent(true)"      )
	uiQuestCompleteNpc:addInputEvent( "Mouse_UpScroll",   	"QuestWindow_ScrollEvent(false)"      )

	local uiQuestRewardButton 		= QuestListUIPool:newQuestRewardButton()
	uiQuestRewardButton:SetPosY( tmp_next_QuestPosY - 8 )
	uiQuestRewardButton:SetShow( true )
	uiQuestRewardButton:addInputEvent("Mouse_On", 	"QuestWindow_questButtonToolTip( true, \"reward\" )")
	uiQuestRewardButton:addInputEvent("Mouse_Out", 	"QuestWindow_questButtonToolTip( false, \"reward\" )")
	uiQuestRewardButton:addInputEvent("Mouse_LUp",	"HandleClicked_QuestReward_Show(" .. questGroupId .. "," ..questId .. ")")
	uiQuestRewardButton:SetPosX( 350 )

	local uiQuestGiveupButton 		= QuestListUIPool:newQuestGiveupButton()
	uiQuestGiveupButton:SetPosY( tmp_next_QuestPosY - 8 )
	uiQuestGiveupButton:SetShow( true )
	uiQuestGiveupButton:addInputEvent("Mouse_On", 	"QuestWindow_questButtonToolTip( true, \"giveup\" )")
	uiQuestGiveupButton:addInputEvent("Mouse_Out", 	"QuestWindow_questButtonToolTip( false, \"giveup\" )")
	uiQuestGiveupButton:addInputEvent("Mouse_LUp",	"HandleClicked_QuestWindow_QuestGiveUp(" .. questGroupId .. "," ..questId .. ")")
	uiQuestGiveupButton:SetPosX( 370 )
	-- if 10 < selfLevel then
		uiQuestGiveupButton:SetMonoTone( false )
		uiQuestGiveupButton:SetEnable( true )
	-- else
		-- uiQuestGiveupButton:SetMonoTone( true )
		-- uiQuestGiveupButton:SetEnable( false )
	-- end

	local uiQuestNaviButton 		= QuestListUIPool:newQuestNaviButton()
	uiQuestNaviButton:SetPosY( tmp_next_QuestPosY - 8 )						-- 나머지 세팅은 아래에서
	uiQuestNaviButton:SetPosX( 390 )

	local uiQuestAutoNaviButton 	= QuestListUIPool:newQuestAutoNaviButton()
	uiQuestAutoNaviButton:SetPosY( tmp_next_QuestPosY - 8 )						-- 나머지 세팅은 아래에서
	uiQuestAutoNaviButton:SetPosX( 410 )

	local uiQuestImage 				= QuestListUIPool:newQuestImage()
	uiQuestImage:SetPosY( tmp_next_QuestPosY + 11 )
	uiQuestImage:ChangeTextureInfoName( uiQuestInfo:getIconPath() )
	uiQuestImage:SetShow( true )
	-- uiQuestImage:addInputEvent("Mouse_On",	"_QuestWidget_QuestToolTipShow(" .. questGroupId ..  "," .. questId .. ", true)")
	-- uiQuestImage:addInputEvent("Mouse_Out",	"_QuestWidget_QuestToolTipHide()")
	uiQuestImage:addInputEvent( "Mouse_DownScroll", "QuestWindow_ScrollEvent(true)"      )
	uiQuestImage:addInputEvent( "Mouse_UpScroll",   "QuestWindow_ScrollEvent(false)"      )

	local uiQuestImageBoarder 		= QuestListUIPool:newQuestImageBoarder()
	uiQuestImageBoarder:SetPosY( tmp_next_QuestPosY + 11 )
	uiQuestImageBoarder:SetShow( true )

	local uiQuestNaviEffect 		= QuestListUIPool:newQuestNaviEffect()
	uiQuestNaviEffect:SetPosY( tmp_next_QuestPosY - 3 )
	
	local playerLevel = getSelfPlayer():get():getLevel()
	if nil == playerLevel then
		-- _PA_LOG("Lua error", "getSelfPlayer():get():getLevel() 값이 없습니다. ")
		return
	end
	if ( playerLevel <= 4 ) then
		uiQuestNaviEffect:SetNotAbleMasking( true )
		uiQuestNaviEffect:EraseAllEffect()
		uiQuestNaviEffect:AddEffect( "fUI_Alarm01", true, 0, 0 )
	else
		uiQuestNaviEffect:EraseAllEffect()
	end

	local uiQuestClearIcon			= QuestListUIPool:newQuestClearIcon()
	uiQuestClearIcon:SetPosY( tmp_next_QuestPosY + 13 )
	uiQuestClearIcon:SetShow( false )

	if true == isSingle then													-- 단일 퀘스트면 들여쓰기
		uigroupBG			:SetPosX( 32 )
		uiQuestTitleBG		:SetPosX( 35 )
		uiQuestTitle		:SetPosX( 60 )
		uiQuestTypeIcon		:SetPosX( 40 )
		uiQuestCompleteNpc	:SetPosX( 85 )
		uiQuestImage		:SetPosX( 35 )
		uiQuestImageBoarder	:SetPosX( 35 )
		uiQuestNaviEffect	:SetPosX( 20 )
		uiQuestClearIcon	:SetPosX( 35 )
	else
		uigroupBG			:SetPosX( 57 )
		uiQuestTitleBG		:SetPosX( 60 )
		uiQuestTitle		:SetPosX( 85 )
		uiQuestTypeIcon		:SetPosX( 65 )
		uiQuestCompleteNpc	:SetPosX( 110 )
		uiQuestImage		:SetPosX( 60 )
		uiQuestImageBoarder	:SetPosX( 60 )
		uiQuestNaviEffect	:SetPosX( 45 )
		uiQuestClearIcon	:SetPosX( 60 )
	end
	
	tmp_next_QuestPosY = tmp_next_QuestPosY + uiQuestCompleteNpc:GetSizeY() + 8

	local questCondition_Chk = nil
	if true == uiQuestInfo:isSatisfied() then
		questCondition_Chk = 0
	else
		questCondition_Chk = 1
	end

	--------------------------------------------------------------------
	-- 퀘스트 완료 조건
	--------------------------------------------------------------------
	for conditionIndex = 0, uiQuestInfo:getDemandCount() - 1, 1 do
		local questCondition = uiQuestInfo:getDemandAt( conditionIndex )
		local uiQuestCondition = QuestListUIPool:newQuestCondition()
		uiQuestCondition:SetAutoResize(true)
		uiQuestCondition:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
		if (questCondition._currentCount == questCondition._destCount) or ( questCondition._destCount <= questCondition._currentCount ) then
			uiQuestCondition:SetText( questCondition._desc .. "(" .. PAGetString(Defines.StringSheet_GAME, "PANEL_QUESTLIST_COMPLETE") .. ")" )
			uiQuestCondition:SetLineRender( true )
			uiQuestCondition:SetFontColor( UI_color.C_FF626262 )
		elseif 1 == questCondition._destCount then
			uiQuestCondition:SetText( questCondition._desc .. "(" .. PAGetString(Defines.StringSheet_GAME, "PANEL_QUESTLIST_TARGETONLY") .. ")" )
			uiQuestCondition:SetLineRender( false )
		else
			uiQuestCondition:SetText( questCondition._desc .. "(" .. questCondition._currentCount .. "/" .. questCondition._destCount .. ")" )
			uiQuestCondition:SetLineRender( false )
		end

		uiQuestCondition:SetPosY( tmp_next_QuestPosY )
		uiQuestCondition:addInputEvent( "Mouse_DownScroll", "QuestWindow_ScrollEvent(true)"      )
		uiQuestCondition:addInputEvent( "Mouse_UpScroll",   "QuestWindow_ScrollEvent(false)"     )
		uiQuestCondition:addInputEvent( "Mouse_LUp", 	"FGlobal_QuestInfoDetail( " .. questGroupId .. ", " .. questId .. ", " .. questCondition_Chk .. ", \"" .. groupTitle .. "\", " .. questGroupCount .. " )" )
		uiQuestCondition:addInputEvent("Mouse_RUp",	"HandleClicked_QuestWidget_FindTarget( " .. questGroupId .. ", " .. questId .. ", " .. questCondition_Chk .. ", false )")
		if true == isSingle then												-- 단일 퀘스트면 들여쓰기
			uiQuestCondition:SetPosX( 85 )
		else
			uiQuestCondition:SetPosX( 110 )
		end
		uiQuestCondition:SetShow( true )
		tmp_next_QuestPosY = tmp_next_QuestPosY + uiQuestCondition:GetSizeY()
	end

	local questPosCount = uiQuestInfo:getQuestPositionCount()
		
	uiQuestNaviButton:SetShow( true )
	uiQuestAutoNaviButton:SetShow( true )

	local _questGroupId, _questId, _naviInfoAgain = _QuestWidget_ReturnQuestState()
	-- 네비 클릭 판별
	if _questGroupId == questGroupId and _questId == questId then
		if true == _naviInfoAgain then
			uiQuestNaviButton:SetCheck( false )
			uiQuestAutoNaviButton:SetCheck( false )
			uiQuestNaviEffect:SetShow( false )
		else
			if ( uiQuestAutoNaviButton:IsCheck() == true ) then
				uiQuestAutoNaviButton:SetCheck( true )
				uiQuestNaviButton:SetCheck( true )
			else
				uiQuestAutoNaviButton:SetCheck( false )
				uiQuestNaviButton:SetCheck( true )
			end
		end
	else
		uiQuestNaviButton:SetCheck( false )
		uiQuestAutoNaviButton:SetCheck( false )
		uiQuestNaviEffect:SetShow( false )
	end

	uigroupBG			:addInputEvent( "Mouse_LUp", 	"FGlobal_QuestInfoDetail( " .. questGroupId .. ", " .. questId .. ", " .. questCondition_Chk .. ", \"" .. groupTitle .. "\", " .. questGroupCount .. " )" )
	uiQuestTypeIcon		:addInputEvent( "Mouse_LUp", 	"FGlobal_QuestInfoDetail( " .. questGroupId .. ", " .. questId .. ", " .. questCondition_Chk .. ", \"" .. groupTitle .. "\", " .. questGroupCount .. " )" )
	uiQuestTitleBG		:addInputEvent( "Mouse_LUp", 	"FGlobal_QuestInfoDetail( " .. questGroupId .. ", " .. questId .. ", " .. questCondition_Chk .. ", \"" .. groupTitle .. "\", " .. questGroupCount .. " )" )
	uiQuestTitle		:addInputEvent( "Mouse_LUp", 	"FGlobal_QuestInfoDetail( " .. questGroupId .. ", " .. questId .. ", " .. questCondition_Chk .. ", \"" .. groupTitle .. "\", " .. questGroupCount .. " )" )
	uiQuestCompleteNpc	:addInputEvent( "Mouse_LUp", 	"FGlobal_QuestInfoDetail( " .. questGroupId .. ", " .. questId .. ", " .. questCondition_Chk .. ", \"" .. groupTitle .. "\", " .. questGroupCount .. " )" )
	uiQuestImage		:addInputEvent( "Mouse_LUp", 	"FGlobal_QuestInfoDetail( " .. questGroupId .. ", " .. questId .. ", " .. questCondition_Chk .. ", \"" .. groupTitle .. "\", " .. questGroupCount .. " )" )
	uigroupBG			:addInputEvent("Mouse_RUp",	"HandleClicked_QuestWidget_FindTarget( " .. questGroupId .. ", " .. questId .. ", " .. questCondition_Chk .. ", false )")
	uiQuestTypeIcon		:addInputEvent("Mouse_RUp",	"HandleClicked_QuestWidget_FindTarget( " .. questGroupId .. ", " .. questId .. ", " .. questCondition_Chk .. ", false )")
	uiQuestTitleBG		:addInputEvent("Mouse_RUp",	"HandleClicked_QuestWidget_FindTarget( " .. questGroupId .. ", " .. questId .. ", " .. questCondition_Chk .. ", false )")
	uiQuestTitle		:addInputEvent("Mouse_RUp",	"HandleClicked_QuestWidget_FindTarget( " .. questGroupId .. ", " .. questId .. ", " .. questCondition_Chk .. ", false )")
	uiQuestCompleteNpc	:addInputEvent("Mouse_RUp",	"HandleClicked_QuestWidget_FindTarget( " .. questGroupId .. ", " .. questId .. ", " .. questCondition_Chk .. ", false )")
	uiQuestImage:addInputEvent("Mouse_RUp",	"HandleClicked_QuestWidget_FindTarget( " .. questGroupId .. ", " .. questId .. ", " .. questCondition_Chk .. ", false )")


	uiQuestNaviButton:addInputEvent("Mouse_On",		"QuestWindow_questButtonToolTip( true, \"navi\" )")
	uiQuestNaviButton:addInputEvent("Mouse_Out",	"QuestWindow_questButtonToolTip( false, \"navi\" )")
	uiQuestNaviButton:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_FindTarget( " .. questGroupId .. ", " .. questId .. ", " .. questCondition_Chk .. ", false )")

	uiQuestAutoNaviButton:addInputEvent("Mouse_On",		"QuestWindow_questButtonToolTip( true, \"Autonavi\" )")
	uiQuestAutoNaviButton:addInputEvent("Mouse_Out",	"QuestWindow_questButtonToolTip( false, \"Autonavi\" )")
	uiQuestAutoNaviButton:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_FindTarget( " .. questGroupId .. ", " .. questId .. ", " .. questCondition_Chk .. ", true )")

	if 0 == questCondition_Chk then
		uiQuestClearIcon:SetShow( true )
		uiQuestImage:SetMonoTone( true )
	else
		uiQuestClearIcon:SetShow( false )
		uiQuestImage:SetMonoTone( false )
	end

	if 0 == _questCondition and 0 == uiQuestInfo:getQuestType() then	-- 흑정령 완료퀘 = 네비 버튼을 숨김
		uiQuestNaviButton:SetShow( false )
		uiQuestAutoNaviButton:SetShow( false )
	end

	if 0 ~= _questCondition and 0 == questPosCount then
		uiQuestNaviButton:SetShow( false )
		uiQuestAutoNaviButton:SetShow( false )
		uiQuestImage:addInputEvent("Mouse_LUp",	"")
	end

	--------------------------------------------------------------------
	-- 퀘스트 완료 조건 복수에 대한 줄간격 조절
	--------------------------------------------------------------------
	if ( uiQuestImage:GetPosY() + uiQuestImage:GetSizeY() ) > tmp_next_QuestPosY then
		tmp_next_QuestPosY = uiQuestImage:GetPosY() + uiQuestImage:GetSizeY() + 13
	else
		tmp_next_QuestPosY = tmp_next_QuestPosY + 10
	end

	-- 각 진행중인 퀘스트의 BG 사이즈 조절.
	local progressingEndPosY		= tmp_next_QuestPosY + 5
	local uigroupBGSizeX			= questListWindow_ContentBG:GetSizeX() - uigroupBG:GetPosX()
	uigroupBG:SetSize( uigroupBGSizeX, progressingEndPosY - progressingStartPosY - 3 )

	displayGroupQuestCount 		= displayGroupQuestCount + 1				-- 그려지는 퀘스트 카운트

	return tmp_next_QuestPosY + 5, displayGroupQuestCount
end

function FGlobal_QuestWindowGetStartPosition()
	return _startPosition
end

function Panel_Window_QuestNew_Show( show, fromWidget )
	if false == show then
		if Panel_CheckedQuestInfo:GetShow() then
			-- FGlobal_QuestInfoDetail_ResetInfo()
			FGlobal_QuestInfoDetail_Close()
		end

		Panel_Window_Quest_New:SetShow( false, true )
		_QuestWidget_QuestToolTipHide()
		FGlobal_QuestHistoryClose()

	else
		Panel_Window_Quest_New:SetShow( true, true )
		updateQuestWindowList( FGlobal_QuestWindowGetStartPosition() )
		updateQuestWidgetList( FGlobal_QuestWidgetGetStartPosition() )
		updateQuestWindowFavorType()

		-- Panel_Window_Quest_New:SetPosX( getScreenSizeX()/2 - (Panel_Window_Quest_New:GetSizeX() + Panel_Window_Quest_History:GetSizeX() )/2 )
		-- Panel_Window_Quest_New:SetPosY( getScreenSizeY()/2 - Panel_Window_Quest_New:GetSizeY()/2 - 30 )
		FGlobal_QuestHistoryOpen()
	end
end

function Panel_Window_QuestNew_Toggle()
	Panel_Window_QuestNew_Show( not Panel_Window_Quest_New:GetShow() )
end


function HandleClicked_QuestWindowList_GroupList_Show( groupId, questId )
	ToClient_ToggleCheckShow( groupId, questId )
end

function QuestWindowNpcNavi_ClearCheckBox()
	for naviIndex = 0, QuestListUIPool._maxcountQuestNaviButton, 1 do			-- 모든 네비 버튼 체크 해제
			QuestListUIPool._listQuestNaviButton[naviIndex]:SetCheck( false )
			QuestListUIPool._listQuestNaviEffect[naviIndex]:SetShow( false )
	end
	ToClient_DeleteNaviGuideByGroup(0);
end

--registerEvent("clearDrawLine", "QuestWindowNpcNavi_ClearCheckBox")

function QuestWindow_questButtonToolTip( show, target )
	if true == show then
		if "giveup" == target then
			ButtonTooltip:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_QUESTLIST_GIVEUP_HELP" ) )
		elseif "reward" == target then
			ButtonTooltip:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_QUESTLIST_REWARD_HELP" ) )
		elseif "navi" == target then
			ButtonTooltip:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_QUESTLIST_NPCNAVI_HELP" ) )
		elseif "Autonavi" == target then
			ButtonTooltip:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_QUESTWIDGET_AUTONAVITOOLTIP" ) )
		end
		ButtonTooltip:SetShow( true )
		ButtonTooltip:SetPosX( getMousePosX() - Panel_Window_Quest_New:GetPosX() - ButtonTooltip:GetSizeX() )
		ButtonTooltip:SetPosY( getMousePosY() - Panel_Window_Quest_New:GetPosY() - ButtonTooltip:GetSizeY()*2 )
	else
		ButtonTooltip:SetShow( false )
	end
end

--------------------------------------------------------------------
-- 퀘스트 포기
--------------------------------------------------------------------
function HandleClicked_QuestWindow_QuestGiveUp( groupId, questId  )
	FGlobal_PassGroupIdQuestId( groupId, questId )
	local messageboxTitle	= PAGetString(Defines.StringSheet_GAME, "GUILD_MESSAGEBOX_TITLE")
	local messageboxContent	= PAGetString( Defines.StringSheet_GAME, "PANEL_QUESTLIST_REAL_GIVEUP_QUESTION" )		--	 정말 의뢰받은 일을 포기하시겠습니까?
	local messageboxData	= { title = messageboxTitle, content = messageboxContent, functionYes = QuestWidget_QuestGiveUp_Confirm, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
end

function Panel_Window_QuestNew_OnScreenResize()
	Panel_Window_Quest_New		:SetPosX( getScreenSizeX()/2 - (Panel_Window_Quest_New:GetSizeX() /2 ) )
	Panel_Window_Quest_New		:SetPosY( getScreenSizeY()/2 - Panel_Window_Quest_New:GetSizeY()/2 - 30 )

	Panel_Window_Quest_History	:SetPosX( Panel_Window_Quest_New:GetPosX() - Panel_Window_Quest_History:GetSizeX() )
	Panel_Window_Quest_History	:SetPosY( Panel_Window_Quest_New:GetPosY() )
end


QuestListUIPool:clear()
QuestWindow_NationalCheck()
FromClient_QuestWindow_Update()
Panel_Window_Quest_New:SetChildIndex(ButtonTooltip, 9999 )

registerEvent("FromClient_UpdateQuestList", "FromClient_QuestWindow_Update")
registerEvent("onScreenResize", 			"Panel_Window_QuestNew_OnScreenResize" )
