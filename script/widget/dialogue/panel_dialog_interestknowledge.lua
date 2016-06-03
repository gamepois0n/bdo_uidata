-------------------------- Panel 설정 -------------------------
Panel_Interest_Knowledge:SetShow(false, false)
Panel_Interest_Knowledge:RegisterShowEventFunc( true,	'InterestKnowledgeShowAni()' )
Panel_Interest_Knowledge:RegisterShowEventFunc( false,	'InterestKnowledgeHideAni()' )

local	UI_TM				= CppEnums.TextMode
local 	UI_PUCT				= CppEnums.PA_UI_CONTROL_TYPE
local	uiBackGround		= UI.getChildControl( Panel_Interest_Knowledge, "Static_Interest_KnowledgeBG" )
local	needKnowledgeText	= UI.getChildControl( Panel_Interest_Knowledge, "StaticText_Need_Knowledge" )
local	_knowledgeList		= UI.getChildControl( Panel_Interest_Knowledge,	"StaticText_Knowledge_List" )
local	_scroll				= UI.getChildControl( Panel_Interest_Knowledge,	"VerticalScroll" )
local	_scrollCtrlBtn		= UI.getChildControl( _scroll,					"VerticalScroll_CtrlButton" )
local	uiText 				= {}								-- create 컨트롤 위한 structure 생성
local	scrollIndex			= 0									-- 스크롤 값 저장 변수
local 	Panel_Interest_Knowledge_Value_elementCount = 0			-- 컨트롤 맥스 index값 저장용

needKnowledgeText	:SetTextMode( UI_TM.eTextMode_AutoWrap )
needKnowledgeText	:SetAutoResize( true )
needKnowledgeText	:SetFontColor(Defines.Color.C_FF96D4FC)

function 	InterestKnowledgeShowAni()
end

function 	InterestKnowledgeHideAni()
end

function 	Dialog_InterestKnowledgeUpdate()
	local talker 					= dialog_getTalker()

	if nil == talker then
		return
	end

	local actorKeyRaw 				= talker:getActorKey()														-- 대상의 액터키로우
	local npcActorProxyWrapper		= getNpcActor( actorKeyRaw )												-- 래퍼 지정
	local knowledge					= getSelfPlayer():get():getMentalKnowledge()								-- 내 지식
	local mentalObject 				= knowledge:getThemeByKeyRaw( npcActorProxyWrapper:getNpcThemeKey() )		-- 관심사에 해당하는 내 지식

	if ( nil == mentalObject ) then
		Panel_Interest_Knowledge_Hide()
		return
	end

	InterestKnowledge_SetText( mentalObject, npcActorProxyWrapper )
end

local	constSizeX					= Panel_Interest_Knowledge:GetSizeX()
local	constSizeY					= Panel_Interest_Knowledge:GetSizeY()
local	_listPosY					= _knowledgeList:GetPosY()
local	_scrollSize 				= _knowledgeList:GetSizeY()
local	uiBG_PosY					= uiBackGround:GetPosY()
local	_scroll_PosY				= _scroll:GetPosY()
local	_needKnowledgeTextSize		= needKnowledgeText:GetSizeY()
local	_needKnowledgeTextGap		= 19
local	_knowledgeMaxCount			= 9

function 	InterestKnowledge_SetText( theme, npcActorProxyWrapper )
	local _needKnowledge 			= npcActorProxyWrapper:getNpcTheme()										-- 필요 지식 네임
	local _needCount 				= npcActorProxyWrapper:getNeedCount()										-- 필요 지식수
	local _currCount 				= getKnowledgeCountMatchTheme(npcActorProxyWrapper:getNpcThemeKey())		-- 현재 지식수
	local _currentKnowledge			= ""
	
	for index=0, _knowledgeMaxCount -1 do
		local _childCard  = theme:getChildCardByIndex(index + scrollIndex)
		if ( nil == _childCard ) then
			uiText[index]:SetShow( false )
		else
			uiText[index]:SetText( _childCard:getName() )
			uiText[index]:SetPosY( _listPosY + _needKnowledgeTextGap * index )
			uiText[index]:SetShow( true )
		end
	end

	needKnowledgeText:SetText( _needKnowledge .. " ( " .. _currCount .. "/" .. theme:getChildCardCount() .. " ) " )
	Panel_Interest_Knowledge_Show()

	Panel_Interest_Knowledge_Value_elementCount = theme:getChildCardCount()
	
	if ( _needKnowledgeTextSize < needKnowledgeText:GetSizeY() ) then			-- 설명 텍스트가 2줄이 되면 패널 사이즈 키운다
		Panel_Interest_Knowledge:SetSize( constSizeX, constSizeY + _needKnowledgeTextGap )
		uiBackGround:SetPosY( uiBG_PosY + _needKnowledgeTextGap )
		_scroll:SetPosY( _scroll_PosY + _needKnowledgeTextGap )
		uiText_RePosY( _knowledgeMaxCount, true )
	else
		Panel_Interest_Knowledge:SetSize( constSizeX, constSizeY )
		uiBackGround:SetPosY( uiBG_PosY )
		_scroll:SetPosY( _scroll_PosY )
		uiText_RePosY( _knowledgeMaxCount, false )
	end
	
	if ( Panel_Interest_Knowledge_Value_elementCount > _knowledgeMaxCount ) then
		_scroll:SetShow( true )
	else
		_scroll:SetShow( false )
	end
	
	UIScroll.SetButtonSize( _scroll, _knowledgeMaxCount, Panel_Interest_Knowledge_Value_elementCount )
end

function uiText_RePosY( count, isReposition )
	if true == isReposition then
		for i = 0, count -1 do
			uiText[i]:SetPosY( uiBG_PosY + 6 + _needKnowledgeTextGap + _needKnowledgeTextGap * i )
		end
	else
		for i = 0, count -1 do
			uiText[i]:SetPosY( uiBG_PosY + 6  + _needKnowledgeTextGap * i )
		end
	end
end

function	InterestKnowledge_Scroll( isUp)
	scrollIndex = UIScroll.ScrollEvent( _scroll, isUp, _knowledgeMaxCount, Panel_Interest_Knowledge_Value_elementCount, scrollIndex, 1 )
	Dialog_InterestKnowledgeUpdate()
end

function 	Panel_Interest_Knowledge_Show()
	Panel_Interest_Knowledge:SetShow( true, true )
end

function 	Panel_Interest_Knowledge_Hide()
	Panel_Interest_Knowledge:SetShow( false, false )
	scrollIndex	= 0						-- 스크롤 인덱스 초기화
	_scrollCtrlBtn:SetPosY( 0 )			-- 스크롤 버튼 위치 초기화
end

function 	InterestKnowledge_onScreenResize()
	local scrY = getScreenSizeY()
	Panel_Interest_Knowledge:SetPosY( scrY - (Panel_Npc_Dialog:GetSizeY() + Panel_Interest_Knowledge:GetSizeY() + 50 ))
end

-- 컨트롤 생성
function 	InterestKnowledge_Init()
	for index = 0, _knowledgeMaxCount -1 do
		uiText[index] = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_Interest_Knowledge, 'StaticText_InterestKnowledgeList_' .. index )
		CopyBaseProperty( _knowledgeList, uiText[index] )
	end
	
	Panel_Interest_Knowledge:RemoveControl( _knowledgeList )
	_knowledgeList = nil
	
	UIScroll.InputEvent( _scroll, 					"InterestKnowledge_Scroll" )
	uiBackGround:addInputEvent( "Mouse_UpScroll",	"InterestKnowledge_Scroll( true )"	)
	uiBackGround:addInputEvent( "Mouse_DownScroll",	"InterestKnowledge_Scroll( false )"	)
end

InterestKnowledge_Init()
InterestKnowledge_onScreenResize()

local 	_buttonQuestion = UI.getChildControl( Panel_Interest_Knowledge, "Button_Question" )			-- 물음표 버튼
_buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelImportantKnowledge\" )" )						-- 물음표 좌클릭
_buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"PanelImportantKnowledge\", \"true\")" )			-- 물음표 마우스오버
_buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"PanelImportantKnowledge\", \"false\")" )			-- 물음표 마우스오버
