Panel_Manufacture:ActiveMouseEventEffect(true)
Panel_Manufacture:SetShow(false,false)
Panel_Manufacture:setGlassBackground(true)

Panel_Manufacture:RegisterShowEventFunc( true, 'ManufactureShowAni()' )
Panel_Manufacture:RegisterShowEventFunc( false, 'ManufactureHideAni()' )

registerEvent("Event_ManufactureUpdateSlot", "Manufacture_Response") -- 개수 모자람
registerEvent("EventShowManufactureWindow",	"Manufacture_ToggleWindow")
registerEvent("Event_ManufactureResultList", "Manufacture_ResponseResultItem")

local IM 			= CppEnums.EProcessorInputMode
local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color
local UIMode 		= Defines.UIMode

local territorySupply	= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 22 )		-- 황실 제작 납품
local contentsOption	= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 36 )

local manufacture_Init = function()
	local screenSizeX = getScreenSizeX()
	local screenSizeY = getScreenSizeY()
	Panel_Manufacture:SetPosX( (screenSizeX - Panel_Manufacture:GetSizeX()) / 2 )
	Panel_Manufacture:SetPosY( (screenSizeY - Panel_Manufacture:GetSizeY()) / 2 )
end
manufacture_Init()

function manufacture_Repos()
	local screenSizeX = getScreenSizeX()
	local screenSizeY = getScreenSizeY()
	Panel_Manufacture:SetPosX( (screenSizeX - Panel_Manufacture:GetSizeX()) / 2 )
	Panel_Manufacture:SetPosY( (screenSizeY - Panel_Manufacture:GetSizeY()) / 2 )
end

-- 스택이 아닌 아이템 반복 처리용.
local noneStackItemList				= Array.new()
local noneStackItemCheck			= false
local hasNoneStackItem				= false
local selectedWarehouseItemKey		= -1
local selectedWarehouseItemSlotNo	= -1
local targetWarehouseSlotNo			= -1


local noneStackItem_ChkBtn	= UI.getChildControl(Panel_Manufacture, "CheckButton_Action2")
noneStackItem_ChkBtn:SetShow(false)
noneStackItem_ChkBtn:SetCheck(false)
noneStackItem_ChkBtn:addInputEvent( "Mouse_LUp",  "noneStackItemCheckBT()" )


-- 액션 차트에 있는 액션과 이름이 같아야한다~!!!!
local _ACTIONNAME_SHAKE 			= "MANUFACTURE_SHAKE"
local _ACTIONNAME_GRIND 			= "MANUFACTURE_GRIND"
local _ACTIONNAME_FIREWOOD 			= "MANUFACTURE_FIREWOOD"
local _ACTIONNAME_DRY 				= "MANUFACTURE_DRY"
local _ACTIONNAME_THINNING 			= "MANUFACTURE_THINNING"
local _ACTIONNAME_HEAT				= "MANUFACTURE_HEAT"
local _ACTIONNAME_RAINWATER			= "MANUFACTURE_RAINWATER"
local _ACTIONNAME_REPAIR			= "REPAIR_ITEM"
local _ACTIONNAME_ALCHEMY			= "MANUFACTURE_ALCHEMY"
local _ACTIONNAME_COOK				= "MANUFACTURE_COOK"
local _ACTIONNAME_RG_COOK			= "MANUFACTURE_ROYALGIFT_COOK"
local _ACTIONNAME_RG_ALCHEMY		= "MANUFACTURE_ROYALGIFT_ALCHEMY"
local _ACTIONNAME_GUILDMANUFACTURE	= "MANUFACTURE_GUILD"

local CURRENT_ACTIONNAME		= ""
local MAX_ACTION_BTN			= 13 --9
local SUBTEXT_OFFSETX			= 60
local SUBTEXT_OFFSETY			= 17
local ACTION_BTN_HEIGHT			= 50
local waypointKey_ByWareHouse	= 0


local invenShow					= false
local isEnableMsg				= {}
local materialItemWhereType		= CppEnums.ItemWhereType.eInventory		-- 가공할 재료템의 whereType

local INSTALLATIONTYPE_ACTIONNAME = {}
INSTALLATIONTYPE_ACTIONNAME[ CppEnums.InstallationType.eType_Mortar ] = _ACTIONNAME_GRIND
INSTALLATIONTYPE_ACTIONNAME[ CppEnums.InstallationType.eType_Stump ] = _ACTIONNAME_FIREWOOD
INSTALLATIONTYPE_ACTIONNAME[ CppEnums.InstallationType.eType_FireBowl ] = _ACTIONNAME_HEAT
INSTALLATIONTYPE_ACTIONNAME[ CppEnums.InstallationType.eType_Anvil ] = _ACTIONNAME_REPAIR

local _defaultSlotNo = 255

local _materialSlotNoList = { [0] = _defaultSlotNo, _defaultSlotNo, _defaultSlotNo, _defaultSlotNo, _defaultSlotNo }
local _materialSlotNoListItemIn = { [0] = false, false, false, false, false }

local _actionIndex	   = -1 
-- 0. 흔들어 섞기 1. 빻기 2. 장작 패기 3. 말리기 4. 솎아내기 5. 가열하기 6. 빗물 받기 7. 수리하기 8. 간이연금 9. 간이요리 10. 황실요리 11. 황실연금 12. 길드가공

local _actionName	   = "NONE"

local _usingInstallationType = CppEnums.InstallationType.TypeCount

local _listAction = {}
local manufactureAction =
{
	_radioBtn,
	_actionName
}

local manufactureListDesc =
{
	[0] = "GAME_MANUFACTURE_DESC_SHAKE",
	[1] = "GAME_MANUFACTURE_DESC_GRIND",
	[2] = "GAME_MANUFACTURE_DESC_FIREWOOD",
	[3] = "GAME_MANUFACTURE_DESC_DRY",
	[4] = "GAME_MANUFACTURE_DESC_THINNING",
	[5] = "GAME_MANUFACTURE_DESC_HEAT",
	[6] = "GAME_MANUFACTURE_DESC_RAINWATER", 
	[7] = "GAME_MANUFACTURE_DESC_REPAIR",
	[8] = "GAME_MANUFACTURE_DESC_ALCHEMY",
	[9] = "GAME_MANUFACTURE_DESC_COOK",
	[10] = "GAME_MANUFACTURE_DESC_ROYALGIFT_COOK",
	[11] = "GAME_MANUFACTURE_DESC_ROYALGIFT_ALCHEMY",
	[12] = "LUA_MANUFACTURE_GUILDMANURACTURE_NAME",
}

local manufactureListName =
{
	[0] = "ALCHEMY_MANUFACTURE_SHAKE",
	[1] = "ALCHEMY_MANUFACTURE_GRIND",
	[2] = "ALCHEMY_MANUFACTURE_WOODSPLITTING",
	[3] = "ALCHEMY_MANUFACTURE_DRY",
	[4] = "ALCHEMY_MANUFACTURE_THINNING",
	[5] = "ALCHEMY_MANUFACTURE_HEATING",
	[6] = "", 
	[7] = "ALCHEMY_MANUFACTURE_REPAIR",
	[8] = "LUA_ALCHEMY_MANUFACTURE_ALCHEMY",
	[9] = "LUA_ALCHEMY_MANUFACTURE_COOK",
	[10] = "LUA_ALCHEMY_MANUFACTURE_ROYALGIFT_COOK",
	[11] = "LUA_ALCHEMY_MANUFACTURE_ROYALGIFT_ALCHEMY",
	[12] = "LUA_MANUFACTURE_GUILDMANURACTURE_NAME",
}

local _usingItemSlotCount	= 0 
-- 0. 흔들어 섞기(2) 1. 빻기(1) 2. 장작 패기(1) 3. 말리기(1) 4. 솎아내기(1) 5. 가열하기(2) 6. 빗물 받기(1) 7. 수리하기(1) 8. 간이연금(2) 9. 간이요리(2) 10. 황실요리(2) 11. 황실연금(2) 12. 길드 공작(5)
local _whiteCircle = UI.getChildControl ( Panel_Manufacture, "Static_WhiteCircle" )

local _slotConfig =
{	-- 일단 아이콘, 테두리, 카운트(숫자) 만 적용한다!
	createIcon		= true,
	createBorder	= false,
	createCount		= true,
	createCash		= true
}

local _slotCount = 5
local _pointList = {}

local contentsOptionCheck = function()
	if contentsOption then
		MAX_ACTION_BTN = 13
	else
		MAX_ACTION_BTN = 12
	end
end
contentsOptionCheck()

for ii=0 , _slotCount-1 do
	_pointList[ii] = UI.getChildControl ( Panel_Manufacture, "Static_Point_" ..ii+1 )
	_pointList[ii]:SetShow(false)
end

local _slotList = {}
for index = 0, _slotCount-1, 1 do
	local createdSlot = {}
	SlotItem.new( createdSlot, 'ItemIconSlot'..index , 0, Panel_Manufacture, _slotConfig )
	createdSlot:createChild()
	createdSlot.icon:addInputEvent( "Mouse_RUp",  "Material_Mouse_RUp(" ..index.. ")" )
	-- createdSlot.icon:addInputEvent( "Mouse_On",  "Material_Mouse_On(" ..index.. ")" )
	-- createdSlot.icon:addInputEvent( "Mouse_Out", "Material_Mouse_Out(" ..index.. ")" )
	_slotList[index] = createdSlot
end

local SLOT_POSITION = {}
-- 사용하는 슬롯이 하나일때 첫번째 X,Y
SLOT_POSITION[0] = { [0] = {106, 66}  }
-- 사용하는 슬롯이 두개
SLOT_POSITION[1] = { [0] = {32, 139}, [1] = {180, 139} } 
-- 사용하는 슬롯이 세개
SLOT_POSITION[2] = { [0] = {106, 66}, [1] = {35, 165}, [2] = {177, 165} } 
-- 사용하는 슬롯이 네개
SLOT_POSITION[3] = { [0] = {39, 110}, [1] = {174, 110}, [2] = {60, 200}, [3] = {151, 200} }
-- 사용하는 슬롯이 다섯개
SLOT_POSITION[4] = { [0] = {106, 66}, [1] = {39, 110}, [2] = {174, 110}, [3] = {60, 200}, [4] = {151, 200} }

--[[ 가공법 control create ]]--
local _manufactureText = UI.getChildControl ( Panel_Manufacture, "StaticText_CircleName" )
_manufactureText:SetShow(false)

local _uiButtonManufacture = UI.getChildControl( Panel_Manufacture, "Button_Manufacture")	-- 가공 시작 버튼
_uiButtonManufacture:addInputEvent( "Mouse_LUp",  "Manufacture_RepeatAction()" )
_uiButtonManufacture:addInputEvent( "Mouse_On",  "Manufacture_Mouse_On()" )


local _uiButtonClose = UI.getChildControl( Panel_Manufacture, "Button_Close" )
_uiButtonClose:addInputEvent( "Mouse_LUp",  "Manufacture_Close()" )

local _buttonQuestion = UI.getChildControl( Panel_Manufacture, "Button_Question" )	-- 물음표 버튼
_buttonQuestion:addInputEvent( "Mouse_LUp",  "Panel_WebHelper_ShowToggle( \"PanelManufacture\" )" )	-- 물음표 마우스 좌클릭
_buttonQuestion:addInputEvent( "Mouse_On",  "HelpMessageQuestion_Show( \"PanelManufacture\", \"true\")" )		-- 물음표 마우스오버
_buttonQuestion:addInputEvent( "Mouse_Out",  "HelpMessageQuestion_Show( \"PanelManufacture\", \"false\")" )		-- 물음표 마우스아웃

local _currentActionIcon = UI.getChildControl( Panel_Manufacture, "Static_CurrentActionIcon" )	-- 가공 선택 아이콘
_currentActionIcon:SetShow(false)
_currentActionIcon:SetIgnore(true)

local _manufactureName 		= UI.getChildControl( Panel_Manufacture, "StaticText_ManufactureName" )	-- 가공 이름
_manufactureName:SetShow(false)
_manufactureName:SetIgnore(true)
_manufactureName:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )

local _textTemp 			= UI.getChildControl( Panel_Manufacture, "StaticText_Template" )		-- 가공 설명
_textTemp:SetShow(false)
_textTemp:SetIgnore(true)
_textTemp:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )

local _textDesc 			= UI.getChildControl( Panel_Manufacture, "StaticText_Desc" )			-- 가공 설명 두번째
_textDesc:SetIgnore(true)
_textDesc:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
_textDesc:SetText("")

-- local _frame 				= UI.getChildControl( Panel_Manufacture, "Frame_Manufacture" )
-- local _frameContents 		= UI.getChildControl( _frame, 			"Frame_Contents" )
-- local _frameScroll			= UI.getChildControl( _frame, 			"Frame_Scroll" )
-- local _frameScroll_Btn		= UI.getChildControl( _frameScroll, 	"Scroll_Bar_CtrlButton" )

local Manufacture_Notify =
{
	_progress_BG 		= UI.getChildControl ( Panel_Manufacture_Notify, "Static_Progress_BG" ),
	_progress_Bar 		= UI.getChildControl ( Panel_Manufacture_Notify, "Progress2_Manufacture" ),
	_progress_Text 		= UI.getChildControl ( Panel_Manufacture_Notify, "StaticText_Manufacture_Progress" ),
	_progress_Effect	= UI.getChildControl ( Panel_Manufacture_Notify, "Static_Progress_Effect" ),
	_type_Name	 		= UI.getChildControl ( Panel_Manufacture_Notify, "StaticText_Manufacture_Type" ),	
	_result_Title 		= UI.getChildControl ( Panel_Manufacture_Notify, "StaticText_Result_Title" ),	
	
	_item_Resource 		= {},
	_icon_ResourceBG 	= {},
	_icon_Resource 		= {},
	_item_Result 		= {},
	_icon_ResultBG 		= {},
	_icon_Result 		= {},
	
	 _templat =
	{
		_item_Resource 		= UI.getChildControl ( Panel_Manufacture_Notify, "StaticText_ResourceItem" ),
		_icon_ResourceBG 	= UI.getChildControl ( Panel_Manufacture_Notify, "Static_ResourceIcon_BG" ),
		_icon_Resource 		= UI.getChildControl ( Panel_Manufacture_Notify, "Static_ResourceIcon" ),
		_item_Result 		= UI.getChildControl ( Panel_Manufacture_Notify, "StaticText_ResultItem" ),
		_icon_ResultBG 		= UI.getChildControl ( Panel_Manufacture_Notify, "Static_ResultIcon_BG" ),
		_icon_Result 		= UI.getChildControl ( Panel_Manufacture_Notify, "Static_ResultIcon" ),
	},
	
	_data_Resource 		= {},
	_data_Result 		= {},
	
	_gapY				= 20,
	_defalutSpanY		= 0,
	
	_failCount 			= 0,
	_successCount 		= 0,
}


local _defaultMSG1 	= UI.getChildControl ( Panel_Manufacture, "StaticText_DefaultMSG1" )	-- 가공 지식 설명 desc
_defaultMSG1:SetShow( false )
local _defaultMSG2 	= UI.getChildControl ( Panel_Manufacture, "StaticText_DefaultMSG2" )	-- 가공 지식 목록 desc
_defaultMSG2:SetShow( false )

local _uiButtonNote = UI.getChildControl( Panel_Manufacture, "Button_Note" )				-- 제작노트 버튼

_uiButtonNote:addInputEvent( "Mouse_LUp", "Note_Mouse_LUp()" )
_uiButtonNote:addInputEvent( "Mouse_On", "Note_Mouse_On()" )


-------------------------------------------------------------------------------------
-- 지식 리스트
-------------------------------------------------------------------------------------

--[[ 가공 지식 설명 control create ]]--
local _frameManufactureDesc		= UI.getChildControl ( Panel_Manufacture, 		"Frame_ManufactureDesc" )
local _frameContent				= UI.getChildControl ( _frameManufactureDesc, 	"Frame_1_Content" )
local _frameDescScroll			= UI.getChildControl ( _frameManufactureDesc, 	"VerticalScroll" )
local _frameDescScroll_Btn		= UI.getChildControl ( _frameDescScroll, 		"VerticalScroll_CtrlButton" )

local _uiKnowledgeDesc			= UI.getChildControl( _frameContent, "StaticText_KnowledgeDesc" )
_uiKnowledgeDesc:SetAutoResize(true)

local _uiKnowledgeIcon 			= UI.getChildControl( Panel_Manufacture, "Static_KnoeledgeIcon" )

--[[ 가공 지식 목록 control create ]]--
local _uiListBG					= UI.getChildControl( Panel_Manufacture, "Static_ListBG" )
-- local _uiKnowledgeBG			= UI.getChildControl( Panel_Manufacture, "Static_KnowledgeBG" )

local _uiListScroll				= UI.getChildControl( Panel_Manufacture, "Scroll_Bar" )
_uiListScroll:GetControlButton():addInputEvent("Mouse_LPress","ManufactureKnowledge_ScrollEvent()" )
local _uiListScrollOriginPosX 	= _uiListScroll:GetPosX()

local _uiListSelect				= UI.getChildControl( Panel_Manufacture, "Static_SelectList" )
_uiListSelect:SetShow(false)
_uiListSelect:SetIgnore(true)

local TEMPLATE_KNOWLEDGE_TEXT = UI.getChildControl( Panel_Manufacture, "StaticText_KnowledgeRecipe" )
TEMPLATE_KNOWLEDGE_TEXT:SetShow(false)

local KNOWLEDGE_TEXT_COUNT = 14
local _uiListText	=	{}
for index = 0, KNOWLEDGE_TEXT_COUNT-1 do

	local tempText = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, _uiListBG, 'StaticText_AlchemyRecipe_' .. (index) )
	CopyBaseProperty( TEMPLATE_KNOWLEDGE_TEXT, tempText )

	tempText:SetPosX( 7 )
	tempText:SetPosY( 7 + (index*tempText:GetSizeY() ) )
	tempText:SetTextMode( CppEnums.TextMode.eTextMode_Limit_AutoWrap )
	tempText:addInputEvent( "Mouse_UpScroll",	"ManufactureKnowledge_ScrollEvent( true )" )
	tempText:addInputEvent( "Mouse_DownScroll",	"ManufactureKnowledge_ScrollEvent( false )" )
	tempText:addInputEvent( "Mouse_LUp",  		"Manufacture_KnowledgeList_SelectKnowledge("..index..")" )
	tempText:addInputEvent( "Mouse_On",  		"Manufacture_KnowledgeList_Tooltip( true, "..index..")" )
	tempText:addInputEvent( "Mouse_Out",  		"Manufacture_KnowledgeList_Tooltip( false, "..index..")" )
	tempText:SetIgnore( false )

	_uiListText[index] = tempText
end

local _startKnowledgeIndex = 0

local SHAKE_MENTALTHEMEKEY 				= 30200
local DRY_MENTALTHEMEKEY 				= 30300
local THINNING_MENTALTHEMEKEY 			= 30400
local GRIND_MENTALTHEMEKEY 				= 30500
local HEAT_MENTALTHEMEKEY				= 30600
local FIREWOOD_MENTALTHEMEKEY			= 30700
local COOK_MENTALTHEMEKEY				= 30109
local ALCHEMY_MENTALTHEMEKEY			= 31009
local ROYALCOOK_MENTALTHEMEKEY			= 30110
local ROYALALCHEMY_MENTALTHEMEKEY		= 31012
local GUILDMANUFACTURE_MENTALTHEMEKEY	= 31013

--  > 30110 황실요리
 -- > 31012 황실연금

-- 나중에 넣어준다. 현재 없음
local RAINWATER_MENTALTHEMEKEY	= 30800

-- local _defaultMessage = nil

-------------------------------------------------------------------------------------
------
--------------------------------------------------------------------------------------
function ManufactureControlInit()
	local manufactureAction1 = {}
	manufactureAction1._actionName = _ACTIONNAME_SHAKE
	manufactureAction1._radioBtn = UI.getChildControl( Panel_Manufacture, "RadioButton_Action1" )
	manufactureAction1._radioBtn:addInputEvent( "Mouse_LUp",  "Manufacture_Button_LUp_Shake(true)" )
	_listAction[0] = manufactureAction1

	local manufactureAction2 = {}
	manufactureAction2._actionName = _ACTIONNAME_GRIND
	manufactureAction2._radioBtn = UI.getChildControl( Panel_Manufacture, "RadioButton_Action2" )
	manufactureAction2._radioBtn:addInputEvent( "Mouse_LUp",  "Manufacture_Button_LUp_Grind(true)" )
	_listAction[1] = manufactureAction2

	local manufactureAction3 = {}
	manufactureAction3._actionName = _ACTIONNAME_FIREWOOD
	manufactureAction3._radioBtn = UI.getChildControl( Panel_Manufacture, "RadioButton_Action3" )
	manufactureAction3._radioBtn:addInputEvent( "Mouse_LUp",  "Manufacture_Button_LUp_FireWood(true)" )
	_listAction[2] = manufactureAction3

	local manufactureAction4 = {}
	manufactureAction4._actionName = _ACTIONNAME_DRY
	manufactureAction4._radioBtn = UI.getChildControl( Panel_Manufacture, "RadioButton_Action4" )
	manufactureAction4._radioBtn:addInputEvent( "Mouse_LUp",  "Manufacture_Button_LUp_Dry(true)" )
	_listAction[3] = manufactureAction4

	local manufactureAction5 = {}
	manufactureAction5._actionName = _ACTIONNAME_THINNING
	manufactureAction5._radioBtn = UI.getChildControl( Panel_Manufacture, "RadioButton_Action5" )
	manufactureAction5._radioBtn:addInputEvent( "Mouse_LUp",  "Manufacture_Button_LUp_Thinning(true)" )
	_listAction[4] = manufactureAction5

	local manufactureAction6 = {}
	manufactureAction6._actionName = _ACTIONNAME_HEAT
	manufactureAction6._radioBtn = UI.getChildControl( Panel_Manufacture, "RadioButton_Action6" )
	manufactureAction6._radioBtn:addInputEvent( "Mouse_LUp",  "Manufacture_Button_LUp_Heat(true)" )
	_listAction[5] = manufactureAction6

	local manufactureAction7 = {}
	manufactureAction7._actionName = _ACTIONNAME_RAINWATER
	manufactureAction7._radioBtn = UI.getChildControl( Panel_Manufacture, "RadioButton_Action7" )
	manufactureAction7._radioBtn:addInputEvent( "Mouse_LUp",  "Manufacture_Button_LUp_Rainwater(true)" )
	_listAction[6] = manufactureAction7

	local manufactureAction8 = {}
	manufactureAction8._actionName = _ACTIONNAME_REPAIR
	manufactureAction8._radioBtn = UI.getChildControl( Panel_Manufacture, "RadioButton_RepairItem" )
	manufactureAction8._radioBtn:addInputEvent( "Mouse_LUp",  "Manufacture_Button_LUp_RepairItem(true)" )
	_listAction[7] = manufactureAction8
	
	local manufactureAction9 = {}
	manufactureAction9._actionName = _ACTIONNAME_ALCHEMY
	manufactureAction9._radioBtn = UI.getChildControl( Panel_Manufacture, "RadioButton_Action9" )
	manufactureAction9._radioBtn:addInputEvent( "Mouse_LUp",  "Manufacture_Button_LUp_Alchemy(true)" )
	_listAction[8] = manufactureAction9
	
	local manufactureAction10 = {}
	manufactureAction10._actionName = _ACTIONNAME_COOK
	manufactureAction10._radioBtn = UI.getChildControl( Panel_Manufacture, "RadioButton_Action10" )
	manufactureAction10._radioBtn:addInputEvent( "Mouse_LUp",  "Manufacture_Button_LUp_Cook(true)" )
	_listAction[9] = manufactureAction10

	-- 황실 요리/연금
	local manufactureAction11 = {}
	manufactureAction11._actionName = _ACTIONNAME_RG_COOK
	manufactureAction11._radioBtn = UI.getChildControl( Panel_Manufacture, "RadioButton_Action11" )
	manufactureAction11._radioBtn:addInputEvent( "Mouse_LUp",  "Manufacture_Button_LUp_RGCook(true)" )
	_listAction[10] = manufactureAction11

	local manufactureAction12 = {}
	manufactureAction12._actionName = _ACTIONNAME_RG_ALCHEMY
	manufactureAction12._radioBtn = UI.getChildControl( Panel_Manufacture, "RadioButton_Action12" )
	manufactureAction12._radioBtn:addInputEvent( "Mouse_LUp",  "Manufacture_Button_LUp_RGAlchemy(true)" )
	_listAction[11] = manufactureAction12

	if contentsOption then
		local manufactureAction13 = {}
		manufactureAction13._actionName = _ACTIONNAME_GUILDMANUFACTURE
		manufactureAction13._radioBtn = UI.getChildControl( Panel_Manufacture, "RadioButton_Action13" )
		manufactureAction13._radioBtn:addInputEvent( "Mouse_LUp",  "Manufacture_Button_LUp_GuildManufacture(true)" )
		_listAction[12] = manufactureAction13
		
		_frameManufactureDesc:UpdateContentScroll()		-- 스크롤 감도 동일하게
		_frameDescScroll:SetInterval(3)
	else
		manufactureAction13._radioBtn = UI.getChildControl( Panel_Manufacture, "RadioButton_Action13" )
		manufactureAction13._radioBtn:SetShow( false )
	end
end

function ManufactureControlEnable( control, isEnable )

	if( true == isEnable ) then
		control:SetIgnore( false )
		control:SetEnable( true )
		control:SetDisableColor( false )
	else
		control:SetIgnore( false )
		control:SetEnable( false )
		control:SetDisableColor( true )
	end

end

function ManufactureShowAni()
	UIAni.fadeInSCR_Down( Panel_Manufacture )
	_whiteCircle:SetShow( true )
	_whiteCircle:SetAlpha( 0 )
	UIAni.AlphaAnimation( 1, _whiteCircle, 0.0, 0.2 )
	
	local aniInfo1 = Panel_Manufacture:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.1)
	aniInfo1.AxisX = Panel_Manufacture:GetSizeX() / 2
	aniInfo1.AxisY = Panel_Manufacture:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_Manufacture:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.1)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_Manufacture:GetSizeX() / 2
	aniInfo2.AxisY = Panel_Manufacture:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function ManufactureHideAni()
	Panel_Manufacture:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo1 = Panel_Manufacture:addColorAnimation( 0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
	
	local alphaAni = UIAni.AlphaAnimation( 0, _whiteCircle, 0.0, 0.12 )
	alphaAni:SetHideAtEnd(true)
end

function Manufacture_SetRadioBtnFontColor( control )
	if control:IsChecked() then
		control:SetFontColor (UI_color.C_FFFFFFFF)
	else
		control:SetFontColor (UI_color.C_FFC4BEBE)
	end
end

function Manufacture_UpdateCheckRadioButton( isClear )
	for i=0, MAX_ACTION_BTN-1 do
		if( nil ~= isClear) and ( true == isClear ) then
			_listAction[i]._radioBtn:SetCheck( false )
		end
		Manufacture_SetRadioBtnFontColor( _listAction[i]._radioBtn )
	end
end

function Manufacture_UpdateVisibleRadioButton( installationType )
	-- visible 검증, 특정 설비도구를 이용할 경우, 그 설비도구에 해당하는 액션만 검증하고 나머지는 안보이게 한다..
	if( nil ~= installationType and CppEnums.InstallationType.TypeCount ~= installationType ) then
		local tempActionName = INSTALLATIONTYPE_ACTIONNAME[installationType]
		for i=0, MAX_ACTION_BTN-1 do
			if ( tempActionName == _listAction[i]._actionName ) then
				local isVisible = isVisibleManufactureAction( _listAction[i]._actionName )
				_listAction[i]._radioBtn:SetShow( isVisible )
			else
				_listAction[i]._radioBtn:SetShow( false )
			end
		end
	else
		for i=0, MAX_ACTION_BTN-1 do
			local isVisible = isVisibleManufactureAction( _listAction[i]._actionName )
			_listAction[i]._radioBtn:SetShow( isVisible )
		end
	end
	
	if not territorySupply then
		_listAction[10]._radioBtn:SetShow( false )
		_listAction[11]._radioBtn:SetShow( false )
	end

	local isNearAnvil = isNearInstallation( CppEnums.InstallationType.eType_Anvil ) -- 모루
	local isNearMortar = true 
	local isNearStump = true
	local isNearFireBowl = true
	
	
	for i=0, MAX_ACTION_BTN-1 do	-- 아이콘 클릭 여부 셋팅
		if( true == _listAction[i]._radioBtn:GetShow() ) then
			local isEnable = isEnableManufactureAction( _listAction[i]._actionName )

			if( _ACTIONNAME_GRIND == _listAction[i]._actionName ) then
				ManufactureControlEnable( _listAction[i]._radioBtn, isEnable and isNearMortar )
				isEnableMsg[i] = (isEnable and isNearMortar) and true or false
			elseif( _ACTIONNAME_FIREWOOD == _listAction[i]._actionName ) then
				ManufactureControlEnable( _listAction[i]._radioBtn, isEnable and isNearStump )
				isEnableMsg[i] = (isEnable and isNearStump) and true or false
			elseif( _ACTIONNAME_HEAT == _listAction[i]._actionName ) then
				ManufactureControlEnable( _listAction[i]._radioBtn, isEnable and isNearFireBowl )
				isEnableMsg[i] = (isEnable and isNearFireBowl) and true or false
			elseif( _ACTIONNAME_REPAIR == _listAction[i]._actionName ) then
				ManufactureControlEnable( _listAction[i]._radioBtn, isEnable and isNearAnvil )
				isEnableMsg[i] = (isEnable and isNearAnvil) and true or false
			else
				ManufactureControlEnable( _listAction[i]._radioBtn, isEnable )
				isEnableMsg[i] = true
			end
		end
	end
end


local slideBtnSize = 0
function Manufacture_Show( installationType, materialWhereType, isClear, showType, waypointKey )
	if Panel_AlchemyFigureHead:GetShow() then
		FGlobal_AlchemyFigureHead_Close()
	end
	
	if Panel_AlchemyStone:GetShow() then
		FGlobal_AlchemyStone_Close()
	end

	if Panel_DyePalette:GetShow() then
		FGlobal_DyePalette_Close()
	end
	
	local noticeText = ""
	invenShow = showType
	StopManufactureAction()
	
	Manufacture_Reset_ContinueGrindJewel()
	
	-- 재료템의 whereType 체크
	if nil == materialWhereType then
		return
	end
	if (materialWhereType ~= CppEnums.ItemWhereType.eInventory) and
		(materialWhereType ~= CppEnums.ItemWhereType.eCashInventory) and
	   (materialWhereType ~= CppEnums.ItemWhereType.eWarehouse) then
	   return
	end
	materialItemWhereType = materialWhereType

	if materialWhereType == CppEnums.ItemWhereType.eWarehouse then
		if nil == waypointKey then
			return
		end
	end

	if CppEnums.ItemWhereType.eInventory == materialWhereType or CppEnums.ItemWhereType.eCashInventory == materialWhereType then
		InventoryWindow_Show()
		Inventory_SetFunctor( Manufacture_SelectCheck1, Manufacture_SelectCheck2, Manufacture_Close, nil )
	else
		waypointKey_ByWareHouse = waypointKey
		InventoryWindow_Close()
		Warehouse_OpenPanelFromManufacture()
		Warehouse_SetFunctor( nil, nil )
	end
	ReconstructionAlchemyKnowledge()
	Panel_Manufacture:SetShow(true,true)

	if( nil ~= isClear and true == isClear ) then
		Manufacture_ClearMaterial()
	end

	Manufacture_UpdateVisibleRadioButton( installationType )

	-- 설비도구 사용시, 선택시키기.
	if( nil ~= installationType ) then
		local isEnable =  false
		if( installationType  == CppEnums.InstallationType.eType_Mortar ) then
			-- 절구 - GRIND
			isEnable = isEnableManufactureAction( _listAction[1]._actionName )
			_listAction[1]._radioBtn:SetCheck(true)
			Manufacture_Button_LUp_Grind(false)
			if( not isEnable ) then
				_textDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_NEED_KNOWLEDGE_MORTAR"))
			end
		elseif(  installationType  == CppEnums.InstallationType.eType_Anvil ) then
			-- 모루 - Repair
			isEnable = isEnableManufactureAction( _listAction[7]._actionName )
			_listAction[7]._radioBtn:SetCheck(true)
			Manufacture_Button_LUp_RepairItem(false)
			if( not isEnable ) then
				_textDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_NEED_KNOWLEDGE_ANVIL"))
			end
		elseif( installationType == CppEnums.InstallationType.eType_Stump ) then
			-- 그루터기 - FireWood
			isEnable = isEnableManufactureAction( _listAction[2]._actionName )
			_listAction[2]._radioBtn:SetCheck(true)
			Manufacture_Button_LUp_FireWood(false)
			if( not isEnable ) then
				_textDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_NEED_KNOWLEDGE_STUMP"))
			end
		elseif( installationType  == CppEnums.InstallationType.eType_FireBowl ) then
			-- 화로 -- Heat
			isEnable = isEnableManufactureAction( _listAction[5]._actionName )
			_listAction[5]._radioBtn:SetCheck(true)
			Manufacture_Button_LUp_Heat(false)
			if( not isEnable ) then
				_textDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_NEED_KNOWLEDGE_FIREBOWL"))
			end
		else
			_textDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_SELECT_TYPE"))	-- 원하는 가공 방식을 ...
		end

		Manufacture_UpdateCheckRadioButton()

		-- 현재 액션이 사용가능?
		if( isEnable ) then

		else

		end
		_uiButtonManufacture:SetShow(isEnable)

	else
		Manufacture_UpdateCheckRadioButton(true)
		ManufactureKnowledge_ShowList(true)
		_uiButtonManufacture:SetShow(false)
	end

	local houseWrapper = housing_getHouseholdActor_CurrentPosition()
	if contentsOption then
		if( nil ~= houseWrapper ) then
			local isMyGuildHouse = houseWrapper:isMyGuildHouse()
			if true == isMyGuildHouse then
				_listAction[12]._radioBtn:SetIgnore( false )
				_listAction[12]._radioBtn:SetMonoTone( false )
			else
				_listAction[12]._radioBtn:SetIgnore( true )
				_listAction[12]._radioBtn:SetMonoTone( true )
			end
		else
			_listAction[12]._radioBtn:SetIgnore( true )
			_listAction[12]._radioBtn:SetMonoTone( true )
		end
	end

	_frameDescScroll:SetControlPos(0)
	_frameManufactureDesc:UpdateContentScroll()		-- 스크롤 감도 동일하게
	_frameManufactureDesc:UpdateContentPos()

	_uiListScroll:SetShow(false)
end

function Manufacture_Close()
	-- if Panel_Win_System:GetShow() then
	-- 	return
	-- end
	
	Panel_Manufacture:SetShow(false,false)
	Inventory_SetFunctor( nil, nil, nil, nil )
	Warehouse_SetFunctor( nil, nil )

	if true == invenShow then
		Panel_Equipment:SetShow(true)
		Panel_Window_Inventory:SetShow(true)
		invenShow = false
	else
		Panel_Equipment:SetShow(false)
		InventoryWindow_Close()	
		HelpMessageQuestion_Out()		-- 물음표 버튼 툴팁 끄기
	end
	
	TooltipSimple_Hide()
	_manufactureName:SetShow(false)
	_textTemp:SetShow(false)
	_currentActionIcon:SetShow(false)
end


function Manufacture_ClearMaterial()
	audioPostEvent_SystemUi(10,3)

	_materialSlotNoList = { [0] = _defaultSlotNo, _defaultSlotNo, _defaultSlotNo, _defaultSlotNo, _defaultSlotNo }
	_materialSlotNoListItemIn = { [0] = false, false, false, false }

	_actionIndex = -1
	_usingInstallationType = CppEnums.InstallationType.TypeCount
	_usingItemSlotCount = 0

	for ii=0 , _slotCount-1 do
		_pointList[ii]:SetShow(false)
	end

	_manufactureText:SetText("")
	_manufactureText:SetShow(false)
	_textDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_SELECT_TYPE"))

	_uiButtonManufacture:SetText(PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE" ))

	Manufacture_UpdateSlot()
end

function Manufacture_SelectCheck1()
	return true
end

function Manufacture_SelectCheck2()
	Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_SELECTCHECK2") ) -- "먼저 원하는 가공 방식을 선택하세요." )
end

function Manufacture_PushItemFromInventory(slotNo, itemWrapper, count, inventoryType)	-- 각 가공 인벤 우클릭 함수
	if( checkManufactureAction() ) then
		if 0 == #noneStackItemList or nil == #noneStackItemList then
			Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_DONT_CHANGE_ACTION" ) )
			return
		end
	end
	local inventory = getSelfPlayer():get():getInventory()
	local invenSize = inventory:size()

	for ii=0, _usingItemSlotCount-1   do
		if( slotNo == _materialSlotNoList[ii] ) then
			break
		end

		if( _defaultSlotNo == _materialSlotNoList[ii] ) then
			_materialSlotNoList[ii] = slotNo
			audioPostEvent_SystemUi(13,08)									 -- 인벤토리에서 아이템 넣을 때 사운드
			break
		end
	end
	materialItemWhereType = inventoryType
	
	if ( 0 == #noneStackItemList or nil == #noneStackItemList ) and (true ~= _materialSlotNoListItemIn[0] or true ~= _materialSlotNoListItemIn[1] or true ~= _materialSlotNoListItemIn[2] or true ~= _materialSlotNoListItemIn[3]) then	-- 1 == _actionIndex and 
		noneStackItemList	= Array.new()
		local	selectedItemWrapper		= getInventoryItemByType( inventoryType, slotNo )
		local	selectedItemKey			= selectedItemWrapper:get():getKey():getItemKey()
		local	inventory				= Inventory_GetCurrentInventory()
		local	curentInventoryType		= Inventory_GetCurrentInventoryType()
		local	invenMaxSize			= inventory:sizeXXX()

		for ii = 2, invenMaxSize - 1 do	-- 인벤을 돌아서 체크한다.
			local itemWrapper = getInventoryItemByType( inventoryType, ii )
			
			if nil ~= itemWrapper then
				local itemKey = itemWrapper:get():getKey():getItemKey()
				if selectedItemKey == itemKey and not selectedItemWrapper:getStaticStatus():isStackable() then
					if slotNo ~= ii then	-- 처음 세팅 슬롯은 저장하면 안된다.
						noneStackItemList:push_back( ii )
					end
				end
			end
		end

		if 0 < #noneStackItemList then
			noneStackItem_ChkBtn:	SetCheck( false )
			noneStackItem_ChkBtn:	SetShow(true)
		end
	end

	Manufacture_UpdateSlot()
end

function Manufacture_PushItemFromWarehouse(slotNo, itemWrapper, count)					-- 각 가공 창고 우클릭 함수
	if( checkManufactureAction() ) then
		if 0 == #noneStackItemList or nil == #noneStackItemList then
			Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_DONT_CHANGE_ACTION" ) )
			return
		end
	end

	for ii=0, _usingItemSlotCount-1   do
		if( slotNo == _materialSlotNoList[ii] ) then
			break
		end

		if( _defaultSlotNo == _materialSlotNoList[ii] ) then
			_materialSlotNoList[ii] = slotNo
			audioPostEvent_SystemUi(13,08)									 -- 인벤토리에서 아이템 넣을 때 사운드
			break
		end
	end
	Manufacture_UpdateSlotWarehouse()
	Manufacture_HasNoneStackItem( slotNo )
end

function Manufacture_HasNoneStackItem( slotNo )	-- 창고에 연속 빻기를 할 수 있는 아이템이 있는지 검증
	hasNoneStackItem			= false
	selectedWarehouseItemSlotNo	= slotNo

	local	warehouseWrapper= warehouse_get( waypointKey_ByWareHouse )
	local	useMaxCount		= warehouseWrapper:getUseMaxCount() 				-- 최대 (현재 뚫려있는) 슬롯 개수 -1(돈)

	local	selectedItemWrapper		= warehouseWrapper:getItem( slotNo )
	selectedWarehouseItemKey		= selectedItemWrapper:get():getKey():getItemKey()
	local	hasNoneStackItemCount	= 0
	for ii = 1, useMaxCount - 1 do	-- 창고를 돌면서 체크한다.
		local itemWrapper	= warehouseWrapper:getItem( ii )
		if nil ~= itemWrapper then
			local itemKey = itemWrapper:get():getKey():getItemKey()
			if selectedWarehouseItemKey == itemKey and not selectedItemWrapper:getStaticStatus():isStackable() then
				if slotNo ~= ii then
					hasNoneStackItemCount = hasNoneStackItemCount + 1
				end
			end
		end
	end
	if 0 < hasNoneStackItemCount then
		hasNoneStackItem		= true
		noneStackItem_ChkBtn:	SetCheck( false )
		noneStackItem_ChkBtn:	SetShow(true)
	end
end

function Manufacture_GetNextNoneStackItemSlotNo_ByWarehouse()	-- 창고의 다음 빻기 슬롯 번호 구하기.
	local	warehouseWrapper= warehouse_get( waypointKey_ByWareHouse )
	local	useMaxCount		= warehouseWrapper:getUseMaxCount() 				-- 최대 (현재 뚫려있는) 슬롯 개수 -1(돈)

	for ii = 1, useMaxCount - 1 do	-- 창고를 돌면서 체크한다.
		local itemWrapper	= warehouseWrapper:getItem( ii )
		if nil ~= itemWrapper then
			local itemKey = itemWrapper:get():getKey():getItemKey()
			if selectedWarehouseItemKey == itemKey then
				targetWarehouseSlotNo = ii
				hasNoneStackItem	= true
				break
			end
		end
	end

	return hasNoneStackItem
end

function Manufacture_ShowPointEffect()
	for ii=0 , _slotCount-1 do
		if( ii < _usingItemSlotCount ) then
			_pointList[ii]:SetShow(true)
			_pointList[ii]:AddEffect("fUI_Light", true, 0.0, 0.0 )
		else
			_pointList[ii]:SetShow(false)
		end
	end
end

function Manufacture_UpdateSlotPos()
	local posIndex = _usingItemSlotCount-1
	if( posIndex < 0 ) then
		return
	end

	local posArray = SLOT_POSITION[posIndex]

	for ii=0 , posIndex do
		local pos = posArray[ii]
		_slotList[ii].icon:SetPosX( pos[1] + 14 )
		_slotList[ii].icon:SetPosY( pos[2] + 9 )

		_pointList[ii]:SetPosX( pos[1] + 28 )
		_pointList[ii]:SetPosY( pos[2] + 18 )
	end
end

function Manufacture_UpdateSlotWarehouse()
	_whiteCircle:EraseAllEffect()

	local warehouseSize = 0
	local warehouseWrapper	= Warehouse_GetWarehouseWarpper()
	
	if nil == warehouseWrapper then
		return
	end
	warehouseSize = warehouseWrapper:getUseMaxCount()
	
	for ii = 0, _slotCount-1 do
		_slotList[ii].icon:SetShow(false)
		_slotList[ii].icon:addInputEvent( "Mouse_On", "" )
		_slotList[ii].icon:addInputEvent( "Mouse_Out", "" )
		if( nil ~= _materialSlotNoList[ii] and  _materialSlotNoList[ii] <= warehouseSize ) then
			local itemWrapper = warehouseWrapper:getItem(_materialSlotNoList[ii])
			if nil ~= itemWrapper then
				_slotList[ii]:setItemByStaticStatus( itemWrapper:getStaticStatus(), itemWrapper:get():getCount_s64() )
				_slotList[ii].icon:SetShow(true)
				_slotList[ii].icon:AddEffect( "fUI_ItemInstall_Produce", false, 0.0, 0.0 )
				_slotList[ii].icon:addInputEvent( "Mouse_On", "Material_Mouse_On( " .. ii .. " )" )
				_slotList[ii].icon:addInputEvent( "Mouse_Out", "Material_Mouse_Out( " .. ii .. " )" )
				
				_whiteCircle:AddEffect( "UI_ItemInstall_ProduceRing", false, 0.0, 0.0 )
				_materialSlotNoListItemIn[ii] = true
			else
				_materialSlotNoList[ii] = _defaultSlotNo
				_materialSlotNoListItemIn[ii] = false
			end
		end
	end
	
	local isEnable = false
	for i=0, MAX_ACTION_BTN-1 do
		if( true == _listAction[i]._radioBtn:IsCheck() ) then
			isEnable = true
		end
	end
	
	_uiButtonManufacture:SetShow(isEnable)
end

function Manufacture_UpdateSlot()
	_whiteCircle:EraseAllEffect()
	
	local inventory = Inventory_GetCurrentInventory()
	local invenSize = inventory:size()

	for ii = 0, _slotCount-1  do
		_slotList[ii].icon:SetShow(false)
		_slotList[ii].icon:addInputEvent( "Mouse_On", "" )
		_slotList[ii].icon:addInputEvent( "Mouse_Out", "" )
		if( nil ~= _materialSlotNoList[ii] and _materialSlotNoList[ii] <= invenSize ) then
			local curentInventoryType	= Inventory_GetCurrentInventoryType()
			local itemWrapper			= getInventoryItemByType( curentInventoryType, _materialSlotNoList[ii] )
			if( nil ~= itemWrapper ) then
				_slotList[ii]:setItemByStaticStatus( itemWrapper:getStaticStatus(), itemWrapper:get():getCount_s64() )
				_slotList[ii].icon:SetShow(true)
				_slotList[ii].icon:AddEffect( "fUI_ItemInstall_Produce", false, 0.0, 0.0 )
				_slotList[ii].icon:addInputEvent( "Mouse_On", "Material_Mouse_On( " .. ii .. " )" )
				_slotList[ii].icon:addInputEvent( "Mouse_Out", "Material_Mouse_Out( " .. ii .. " )" )
				
				_whiteCircle:AddEffect( "UI_ItemInstall_ProduceRing", false, 0.0, 0.0 )
				_materialSlotNoListItemIn[ii] = true
			else
				_materialSlotNoList[ii] = _defaultSlotNo
				_materialSlotNoListItemIn[ii] = false
			end
		end
	end

	local isEnable = false
	for i=0, MAX_ACTION_BTN-1 do
		if( true == _listAction[i]._radioBtn:IsCheck() ) then
			isEnable = true
		end
	end
	
	_uiButtonManufacture:SetShow(isEnable)
end

function Manufacture_Response()
	local _uiMode = GetUIMode()
	
	-- 보석 연속 빻기중에는 창을 열지 않는다.
	if nil ~= #noneStackItemList and 0 < #noneStackItemList and true == noneStackItemCheck then
		return
	end
	
	if _uiMode == Defines.UIMode.eUIMode_Default then
		Manufacture_Show( nil, materialItemWhereType, true)
	end
end

-- function FGlobal_isContinueGrindJewel()
-- 	return noneStackItemCheck
-- end

function Manufacture_RepeatManufacture()
	if -1 == _actionIndex then
		return
	end

	if 0 == _actionIndex then
		Manufacture_Button_LUp_Shake(true)
	elseif 1 == _actionIndex then
		Manufacture_Button_LUp_Grind(true)
	elseif 2 == _actionIndex then
		Manufacture_Button_LUp_FireWood(true)
	elseif 3 == _actionIndex then
		Manufacture_Button_LUp_Dry(true)
	elseif 4 == _actionIndex then
		Manufacture_Button_LUp_Thinning(true)
	elseif 5 == _actionIndex then
		Manufacture_Button_LUp_Heat(true)
	elseif 6 == _actionIndex then
		Manufacture_Button_LUp_Rainwater(true)
	elseif 7 == _actionIndex then
		Manufacture_Button_LUp_RepairItem(true)
	elseif 8 == _actionIndex then
		Manufacture_Button_LUp_Alchemy(true)
	elseif 9 == _actionIndex then
		Manufacture_Button_LUp_Cook(true)
	elseif 10 == _actionIndex then
		Manufacture_Button_LUp_RGCook(true)
	elseif 11 == _actionIndex then
		Manufacture_Button_LUp_RGAlchemy(true)
	elseif 12 == _actionIndex then
		Manufacture_Button_LUp_GuildManufacture(true)
	end
end

function Manufacture_ContinueGrindJewel()
	if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then	-- 가공을 실행한 위치가 가방라면
		if nil ~= #noneStackItemList and 0 < #noneStackItemList and true == noneStackItemCheck then
			
			-- 이전 액션 인덱스에 따라, 재실행한다.
			Manufacture_RepeatManufacture()

			local	nextSlotNo				= noneStackItemList[1]
			local	curentInventoryType		= Inventory_GetCurrentInventoryType()
			local	itemWrapper				= getInventoryItemByType( curentInventoryType, nextSlotNo )
			if( nil == itemWrapper ) then
				return
			end

			local	itemCount	= itemWrapper:get():getCount_s64()
		
			Manufacture_PushItemFromInventory(nextSlotNo, itemWrapper, itemCount, curentInventoryType)	-- 다음 재료를 넣는다.
			Manufacture_Mouse_LUp()	-- 가공하기를 누른다.
			
			noneStackItemList:pop_front()
		end
	else		-- 가공을 실행한 위치가 창고라면
		local hasNext = Manufacture_GetNextNoneStackItemSlotNo_ByWarehouse()
		if true == hasNext and (true == hasNoneStackItem and true == noneStackItemCheck) then	-- 1 == _actionIndex and 
			local warehouseWrapper	= warehouse_get( waypointKey_ByWareHouse )
			if nil == warehouseWrapper then
				return
			end
			local itemWrapper		= warehouseWrapper:getItem( targetWarehouseSlotNo )
			if nil == itemWrapper then
				return
			end
			-- 이전 액션 인덱스에 따라, 재실행한다.
			Manufacture_RepeatManufacture()

			Manufacture_PushItemFromWarehouse(targetWarehouseSlotNo, itemWrapper, 1)
			Manufacture_Mouse_LUp()	-- 가공하기를 누른다.
		end
	end
end

function Manufacture_ResponseResultItem( itemDynamicListWrapper, failReason )
	local size = itemDynamicListWrapper:getSize()

	if( 0 < size ) then --성공
		Manufacture_Notify._failCount = 0
		Manufacture_Notify._successCount = Manufacture_Notify._successCount + 1
		for index = 0, size-1, 1 do
			local itemDynamicInformationWrapper		= itemDynamicListWrapper:getElement(index)
			local ItemEnchantStaticStatusWrapper	= itemDynamicInformationWrapper:getStaticStatus()
			local itemKey							= ItemEnchantStaticStatusWrapper:get()._key
			local s64_stackCount 					= Int64toInt32(itemDynamicInformationWrapper:getCount_s64())
			
			local idx = nil
			
			for key, value in pairs (Manufacture_Notify._data_Result) do
				if value._key:getItemKey() == itemKey:getItemKey() then
					idx = key
				end
			end
			
			if nil == idx then
				idx = #Manufacture_Notify._data_Result + 1
				Manufacture_Notify._data_Result[idx] = {}
				Manufacture_Notify._data_Result[idx]._key 			= itemKey
				Manufacture_Notify._data_Result[idx]._name			= ItemEnchantStaticStatusWrapper:getName()
				Manufacture_Notify._data_Result[idx]._iconPath		= "Icon/" .. ItemEnchantStaticStatusWrapper:getIconPath()
				Manufacture_Notify._data_Result[idx]._currentCnt	= s64_stackCount
			else
				Manufacture_Notify._data_Result[idx]._currentCnt	= Manufacture_Notify._data_Result[idx]._currentCnt + s64_stackCount
			end
		
		end
		
		for key, value in pairs (Manufacture_Notify._data_Resource) do
			local itemWrapper = nil
			local count = 0
			
			if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
				local	curentInventoryType		= Inventory_GetCurrentInventoryType()
				itemWrapper				= getInventoryItemByType( curentInventoryType, value._slotNo )
			else
				local warehouseWrapper	= warehouse_get( waypointKey_ByWareHouse )
				itemWrapper				= warehouseWrapper:getItem( value._slotNo )
			end
			
			if nil ~= itemWrapper then
				local itemStaticWrapper = itemWrapper:getStaticStatus()
				count = Int64toInt32(itemWrapper:get():getCount_s64())
			end
			
			value._currentCnt = count
		end
		
		-- 쥬얼의 연속 빻기 중이면...
		if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then	-- 가공을 실행한 위치가 가방라면
			if nil ~= #noneStackItemList and 0 < #noneStackItemList and true == noneStackItemCheck then
				StopManufactureAction()
				luaTimer_AddEvent( Manufacture_ContinueGrindJewel, 500, false, 0)
			else
				if noneStackItemCheck then
					Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_COMPLETE_REPEAT") )	-- "연속 가공이 완료됐습니다." 
				end
				Manufacture_Reset_ContinueGrindJewel()	-- 연속 가공 관련 초기화
				--StopManufactureAction()
			end
			Manufacture_Progress_Update( materialItemWhereType )
		else	-- 가공을 실행한 위치가 창고라면
			if true == hasNoneStackItem then
				StopManufactureAction()
				luaTimer_AddEvent( Manufacture_ContinueGrindJewel, 500, false, 0)
			else
				if noneStackItemCheck then
					Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_COMPLETE_REPEAT") )	-- "연속 가공이 완료됐습니다." 
				end
				Manufacture_Reset_ContinueGrindJewel()	-- 연속 가공 관련 초기화
				--StopManufactureAction()
			end
			Manufacture_Progress_Update( materialItemWhereType )
		end
		
	else -- 실패
		
		--[[
			0 은 성공이다.
			1 : 아이템이 부족합니다.
			2 : 빈슬롯입니다.
			3 : 조건에 맞지 않습니다.
			4 : 결과 아이템이 없습니다.( 재료와 액션에 부합하는 가공식이 없다)
			5 : 사용해야하는 설비도구가 없다.
			6 : 가공시간이 비정상이다.
			7 : 가공의 확률에 의해 실패했다			
			8 : 빈슬롯이 없습니다.
			9 : 너무 무겁습니다.
			10 : 기운이 모자랍니다.
		]]--
		
		--[[
			실패시 가공을 멈춰야 될경우 밑의 두 함수를 호출해준다.
			Manufacture_ClearValues() -- 클라이언트에서 캐싱하고 있는 가공 변수들을 클리어한다.
			Manufacture_Response()	  -- 가공창을 새로 열어준다.
		]]--
		
		local message = nil
		if( 0 == failReason ) then
			
		elseif( 1 == failReason ) then
			message = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_FAILREASON1") -- "가공을 완료했다. 재료가 부족해서 연속 가공을 진행할 수 없다."
			Manufacture_Response()	  -- 가공창을 새로 열어준다.
		elseif( 2 == failReason ) then
			message = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_FAILREASON2") -- "가진 재료를 모두 소모해 가공을 완료했다."
			Manufacture_ClearValues() -- 클라이언트에서 캐싱하고 있는 가공 변수들을 클리어한다.
			Manufacture_Response()	  -- 가공창을 새로 열어준다.
		elseif( 3 == failReason ) then
			message = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_FAILREASON3") -- "지금은 가공을 진행할 수 없다. 가공 조건을 확인해보자."
		elseif( 4 == failReason ) then
			message = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_FAILREASON4") -- "이대로는 아무 것도 만들 수 없을 것 같다."
		elseif( 5 == failReason ) then
			message = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_FAILREASON5") -- "근처에 가공을 위한 도구가 없다. 가공 도구가 필요하다."
		elseif( 6 == failReason ) then
			--message = "가공 시간이 비정상적이다."--
		elseif( 7 == failReason ) then
			message = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_FAILREASON7") -- "가공이 생각대로 잘 되지 않는다."
		elseif( 8 == failReason ) then
			message = PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_INVENTORY_LEAST_ONE")	-- 가방에 2칸 이상 공간이 필요합니다.
			Manufacture_ClearValues() -- 클라이언트에서 캐싱하고 있는 가공 변수들을 클리어한다.
			Manufacture_Response()	  -- 가공창을 새로 열어준다.
		elseif( 9 == failReason ) then
			message = PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_INVENTORY_WEIGHTOVER")	-- 너무 무거운 상태입니다.
			Manufacture_ClearValues() -- 클라이언트에서 캐싱하고 있는 가공 변수들을 클리어한다.
			Manufacture_Response()	  -- 가공창을 새로 열어준다.
		elseif( 10 == failReason ) then
			message = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_WP_IS_LACK")	-- 기운이 부족합니다.
			Manufacture_ClearValues() -- 클라이언트에서 캐싱하고 있는 가공 변수들을 클리어한다.
			Manufacture_Response()	  -- 가공창을 새로 열어준다.
		end
		
		if( 6 ~= failReason ) and ( nil ~= message ) then
			Proc_ShowMessage_Ack( message )
		end
		
		Manufacture_Notify._failCount = Manufacture_Notify._failCount + 1

		-- 가공 확률이 적어지면서 실패가 많아졌다. 그래서 실패 횟수를 늘림(20->30)
		if Manufacture_Notify._failCount >= 30 then
			Proc_ShowMessage_Ack(PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_DONT_THIS_WAY" ))
			Manufacture_Notify._failCount = 0
			Manufacture_Response()
		end
	end
end

function Manufacture_Reset_ContinueGrindJewel()
	-- 연속 빻기 초기화
	noneStackItemList				= Array.new()
	noneStackItemCheck				= false
	hasNoneStackItem				= false
	selectedWarehouseItemKey		= -1
	selectedWarehouseItemSlotNo		= -1
	targetWarehouseSlotNo			= -1
	noneStackItem_ChkBtn:SetCheck(false)
	noneStackItem_ChkBtn:SetShow(false)
end

function Manufacture_ToggleWindow( installationType, isClear )
	if( Panel_Manufacture:GetShow() ) then
		Manufacture_Close()
	else
		InventoryWindow_Show()
		local	curentInventoryType		= Inventory_GetCurrentInventoryType()
		Manufacture_Show(installationType, curentInventoryType, isClear)	-- 커런트 타입을 구해와서 해야 한다.
	end

end

function Manufacture_Mouse_LUp()
	if( _actionIndex == -1 ) then
		return
	end

	local houseWrapper = housing_getHouseholdActor_CurrentPosition()
	if( nil == houseWrapper and 12 == _actionIndex ) then
		Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_INNTER_GUILDHOUSE_USE"))
		return
	end

	-- 결과템은 무조건 인벤토리로 들어간다.
	-- { 인벤 여유 슬롯 체크
	local inventory			= getSelfPlayer():get():getInventory()
	local cashInventory		= getSelfPlayer():get():getInventoryByType( CppEnums.ItemWhereType.eCashInventory )
	local freeCount	= inventory:getFreeCount()
	local size = 0
	
	if CppEnums.ItemWhereType.eInventory == materialItemWhereType then
		size = inventory:size()
	elseif CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
		size = cashInventory:size()
	else
		local warehouseWrapper		= warehouse_get( waypointKey_ByWareHouse )
		size = warehouseWrapper:getSize()
	end

	if freeCount < 2  then
		-- 결과템이 들어갈 빈 공간이 없으면, 가공은 실패한다! 스택형으로 이미 가방에 있다면 성공한다!
		Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_INVENTORY_LEAST_ONE" ) ) -- String (가방에 빈 공간이 없습니다.)
		return
	end

	---- 무게 체크
	local selfPlayerWrapper		= getSelfPlayer()
	local selfPlayer			= selfPlayerWrapper:get()
	local s64_allWeight			= selfPlayer:getCurrentWeight_s64()
	local s64_maxWeight			= selfPlayer:getPossessableWeight_s64()
	local allWeight				= Int64toInt32( s64_allWeight ) / 10000
	local maxWeight				= Int64toInt32( s64_maxWeight ) / 10000
	local playerWeightPercent	= allWeight / maxWeight * 100
	local s64_moneyWeight		= selfPlayer:getInventory():getMoneyWeight_s64()
	local s64_equipmentWeight	= selfPlayer:getEquipment():getWeight_s64()
	local s64_allWeight			= selfPlayer:getCurrentWeight_s64()
	local s64_maxWeight			= selfPlayer:getPossessableWeight_s64()
	local moneyWeight			= Int64toInt32( s64_moneyWeight ) / 10000
	local equipmentWeight		= Int64toInt32( s64_equipmentWeight ) / 10000
	local allWeight				= Int64toInt32( s64_allWeight ) / 10000
	local maxWeight				= Int64toInt32( s64_maxWeight ) / 10000
	local invenWeight			= allWeight - equipmentWeight - moneyWeight
	--local totalWeight			= ( string.format( "%.0f", (invenWeight/maxWeight)*100) + string.format( "%.0f", (moneyWeight/maxWeight)*100) + string.format( "%.0f", (equipmentWeight/maxWeight)*100) )
	local totalWeight			=  (allWeight / maxWeight) * 100
	
	if 100 <= totalWeight then
		Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_INVENTORY_WEIGHTOVER" ) )
		return
	end
	
	local sum_MaterialSlot = {} -- 재료 슬롯을 체크한다.
	Manufacture_Notify:clear()
	
	for index = 0, _usingItemSlotCount - 1, 1 do
		_PA_LOG("김창욱", "체크 : " .. index .. "/" .. tostring(_materialSlotNoList[index] <= size) .. "/" .. _materialSlotNoList[index] .. ":" .. size )
		if true == _materialSlotNoListItemIn[index] and _materialSlotNoList[index] <= size then		-- 가공 조건에 따른 슬롯 수-1 만큼  for문을 돌리면서 index에 1씩 더함.
			sum_MaterialSlot[#sum_MaterialSlot + 1] = _materialSlotNoList[index]
			
			local itemWrapper = nil
			if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
				local	curentInventoryType		= Inventory_GetCurrentInventoryType()
				itemWrapper				= getInventoryItemByType( curentInventoryType, _materialSlotNoList[index] )
			else
				local warehouseWrapper	= warehouse_get( waypointKey_ByWareHouse )
				itemWrapper				= warehouseWrapper:getItem( _materialSlotNoList[index] )
			end

			local itemStaticWrapper = itemWrapper:getStaticStatus()
			local idx = #Manufacture_Notify._data_Resource + 1
			Manufacture_Notify._data_Resource[idx] = {}
			Manufacture_Notify._data_Resource[idx]._slotNo 		= _materialSlotNoList[index]
			Manufacture_Notify._data_Resource[idx]._key 		= itemStaticWrapper:get()._key
			Manufacture_Notify._data_Resource[idx]._name 		= itemStaticWrapper:getName()
			Manufacture_Notify._data_Resource[idx]._iconPath 	= "Icon/" .. itemStaticWrapper:getIconPath()
			Manufacture_Notify._data_Resource[idx]._originalCnt = Int64toInt32(itemWrapper:get():getCount_s64())
			Manufacture_Notify._data_Resource[idx]._currentCnt 	= Manufacture_Notify._data_Resource[idx]._originalCnt
		end
	end

	if #sum_MaterialSlot == 0 then 
		if _actionIndex == 0 or _actionIndex == 5 then
			Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_SLOT_LEAST_ONE" ) )
		else
			Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_SLOT_EMPTY" ) )
		end
		return
	end
	
	_whiteCircle:AddEffect( "UI_ItemInstall_Spin", true, 0.0, 0.0 )
	
	-- 수리는 따로 처리한다.
	if( _actionIndex == 7 ) then
		for key, value in pairs (sum_MaterialSlot) do
			local rv = repair_RepairItemBySelf( value )	-- return 값(rv)이 0이면 정상적으로 진행!
			if rv == 0 then
				break
			end
		end
	else
		-- 창고 가공일 경우 NPC Dialog 를 닫는다.
		if CppEnums.ItemWhereType.eWarehouse == materialItemWhereType then
			FGlobal_HideDialog()
		end
		
		CURRENT_ACTIONNAME = _listAction[_actionIndex]._actionName
		local rv = Manufacture_Do( _usingInstallationType, CURRENT_ACTIONNAME, materialItemWhereType, _materialSlotNoList[0], _materialSlotNoList[1], _materialSlotNoList[2], _materialSlotNoList[3], _materialSlotNoList[4])
	end

	audioPostEvent_SystemUi(00,00)

	Manufacture_Notify._failCount		= 0		-- 가공 실패 횟수 체크용 변수
	Manufacture_Notify._successCount	= 0		-- 가공 실패 횟수 체크용 변수

	-- 가공 시작하면 닫아준다.
	Manufacture_Close()
	Interaction_Close()
	audioPostEvent_SystemUi(13,11)								-- 가공하기 시작버튼 누를 때 사운드
end

function Manufacture_Mouse_On()
	audioPostEvent_SystemUi(01,13)								-- 가공하기 시작버튼 마우스오버 시 사운드
end

function Manufacture_UpdateRepairTime()
	local repairTime = repair_getRepairTime( _materialSlotNoList[0] )
	if( toUint64(0,0) < repairTime ) then
		local tempString = PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_REPAIR_TOTAL_TIME" ) .." : " ..( convertStringFromMillisecondtime( repairTime ) )
		_manufactureText:SetText(tempString )
	end
end

function Material_Mouse_RUp( index )
	if Panel_Win_System:GetShow() then
		return
	end
	
	audioPostEvent_SystemUi(13,12)								-- 가공하기 창에서 재료 뺄 때 사운드~
	StopManufactureAction()

	-- 재료 뺄 때 연속 빻기 초기화
	noneStackItemList					= Array.new()
	noneStackItemCheck					= false
	hasNoneStackItem					= false
	selectedWarehouseItemKey			= -1
	selectedWarehouseItemSlotNo			= -1
	targetWarehouseSlotNo				= -1
	noneStackItem_ChkBtn:SetCheck(false)
	noneStackItem_ChkBtn:SetShow(false)
	
	if( index < _usingItemSlotCount ) then		
		_materialSlotNoList[index] = _defaultSlotNo
		_materialSlotNoListItemIn[index] = false		
		for ii = index, _usingItemSlotCount - 1 do -- 슬롯에서 재료를 빼면 뒷 슬롯에서 한 칸씩 당겨서 빈 슬롯 채움. 3슬롯 이상 쓰는 가공 나왔을 때 정상 작동하는지 다시 확인해봐야 함. (수정일: 2015. 5. 13.)
			if 255 == _materialSlotNoList[ii] and 255 ~= _materialSlotNoList[ii+1] then
				_materialSlotNoList[ii] 	= _materialSlotNoList[ii+1]
				_materialSlotNoList[ii+1]	= _defaultSlotNo
			else
				break
			end
		end
	end
	Panel_Tooltip_Item_hideTooltip()
	Manufacture_UpdateSlot()
end

function Material_Mouse_On( index )		-- 툴팁
	local itemWrapper = nil
	
	if materialItemWhereType == CppEnums.ItemWhereType.eInventory or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
		local	curentInventoryType		= Inventory_GetCurrentInventoryType()
		itemWrapper				= getInventoryItemByType( curentInventoryType, _materialSlotNoList[index] )
	else
		itemWrapper = Warehouse_GetWarehouseWarpper():getItem(_materialSlotNoList[index])
	end

	local slot = _slotList[index].icon
	
	Panel_Tooltip_Item_Show( itemWrapper, slot, false, true, false, nil, nil )
end

function Material_Mouse_Out( index )
	Panel_Tooltip_Item_hideTooltip()

end

------------------------------------------------
-- 				클릭했을 때의 함수
------------------------------------------------
function Manufacture_Button_LUp_Shake( isClear )
	if Panel_Win_System:GetShow() then
		return
	end
	-- ♬ 
	audioPostEvent_SystemUi(13,10)

	if( nil ~= isClear and true == isClear ) then
		Manufacture_ClearMaterial()
	end
	StopManufactureAction()

	_actionIndex = 0
	_usingItemSlotCount = 2
	-- 사용하는 슬롯의 갯수가 바뀌면 위치도 업데이트해줘야한다.
	Manufacture_UpdateSlotPos()
	Manufacture_ShowPointEffect()

	_usingInstallationType = CppEnums.InstallationType.TypeCount
	_currentActionIcon:SetShow(true)
	manufactureClickSetTextureUV( _currentActionIcon, 172, 58, 228, 114)
	_manufactureText:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_SHAKE" ) )
	_manufactureText:SetShow(true)
	_manufactureName:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_SHAKE" ) )
	_manufactureName:SetShow(true)
	_textDesc:SetText( PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC2_SHAKE" ) )
	_textTemp:SetText( PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_SHAKE" ))
	_textTemp:SetShow(true)

	_uiButtonManufacture:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE" ) )

	Manufacture_UpdateCheckRadioButton()

	-- 지식리스트 업데이트
	_startKnowledgeIndex = 0
	_uiListScroll:SetControlPos(0)
	_uiListSelect:SetShow(false)	
	ReconstructionAlchemyKnowledge( SHAKE_MENTALTHEMEKEY )
	ManufactureKnowledge_UpdateList()

	_defaultMSG1:SetShow( false )
	_defaultMSG2:SetShow( false )
	Material_Update( _usingItemSlotCount )
	
	if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
		-- 버튼 조건이 필요함.
		Inventory_SetFunctor( ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil  )
		Inventory_updateSlotData()
	else
		Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
		Warehouse_updateSlotData()
	end
end

function Manufacture_Button_LUp_Grind( isClear )
	if Panel_Win_System:GetShow() then
		return
	end
	
	audioPostEvent_SystemUi(13,02)

	if( nil ~= isClear and true == isClear ) then
		Manufacture_ClearMaterial()
	end
	
	StopManufactureAction()

	_actionIndex = 1
	_usingItemSlotCount = 1
	-- 사용하는 슬롯의 갯수가 바뀌면 위치도 업데이트해줘야한다.
	Manufacture_UpdateSlotPos()
	Manufacture_ShowPointEffect()

	_usingInstallationType = CppEnums.InstallationType.TypeCount
	_currentActionIcon:SetShow(true)
	manufactureClickSetTextureUV( _currentActionIcon, 115, 1, 171, 57)
	_manufactureText:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_GRIND" ) )
	_manufactureText:SetShow(true)
	_manufactureName:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_GRIND" ) )
	_manufactureName:SetShow(true)
	_textDesc:SetText( PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC2_GRIND" ) )
	_textTemp:SetText( PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_GRIND" ))
	_textTemp:SetShow(true)

	_uiButtonManufacture:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE" ) )

	Manufacture_UpdateCheckRadioButton()

	_startKnowledgeIndex = 0
	_uiListScroll:SetControlPos(0)
	_uiListSelect:SetShow(false)
	ReconstructionAlchemyKnowledge( GRIND_MENTALTHEMEKEY )
	ManufactureKnowledge_UpdateList()

	_defaultMSG1:SetShow( false )
	_defaultMSG2:SetShow( false )
	Material_Update( _usingItemSlotCount )
	
	if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
		-- 버튼 조건이 필요함.
		Inventory_SetFunctor( ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil  )
		Inventory_updateSlotData()
	else
		Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
		Warehouse_updateSlotData()
	end
end

function Manufacture_Button_LUp_FireWood(isClear)
	if Panel_Win_System:GetShow() then
		return
	end
	
	audioPostEvent_SystemUi(13,00)

	if( nil ~= isClear and true == isClear ) then
		Manufacture_ClearMaterial()
	end
	StopManufactureAction()

	_actionIndex = 2
	_usingItemSlotCount = 1
	-- 사용하는 슬롯의 갯수가 바뀌면 위치도 업데이트해줘야한다.
	Manufacture_UpdateSlotPos()
	Manufacture_ShowPointEffect()

	_usingInstallationType = CppEnums.InstallationType.TypeCount
	_currentActionIcon:SetShow(true)
	manufactureClickSetTextureUV( _currentActionIcon, 1, 58, 57, 114)
	_manufactureText:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_WOODSPLITTING" ) )
	_manufactureText:SetShow(true)
	_manufactureName:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_WOODSPLITTING" ) )
	_manufactureName:SetShow(true)
	_textDesc:SetText( PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC2_FIREWOOD" ) )
	_textTemp:SetText( PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_FIREWOOD" ))
	_textTemp:SetShow(true)

	_uiButtonManufacture:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE" ) )

	Manufacture_UpdateCheckRadioButton()

	_startKnowledgeIndex = 0
	_uiListScroll:SetControlPos(0)
	_uiListSelect:SetShow(false)
	ReconstructionAlchemyKnowledge( FIREWOOD_MENTALTHEMEKEY )
	ManufactureKnowledge_UpdateList()

	_defaultMSG1:SetShow( false )
	_defaultMSG2:SetShow( false )
	Material_Update( _usingItemSlotCount )
	
	if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
		-- 버튼 조건이 필요함.
		Inventory_SetFunctor( ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil  )
		Inventory_updateSlotData()
	else
		Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
		Warehouse_updateSlotData()
	end
end

function Manufacture_Button_LUp_Dry(isClear)
	if Panel_Win_System:GetShow() then
		return
	end
	
	audioPostEvent_SystemUi(13,01)

	if( nil ~= isClear and true == isClear ) then
		Manufacture_ClearMaterial()
	end
	StopManufactureAction()

	_actionIndex = 3
	_usingItemSlotCount = 1
	-- 사용하는 슬롯의 갯수가 바뀌면 위치도 업데이트해줘야한다.
	Manufacture_UpdateSlotPos()
	Manufacture_ShowPointEffect()

	_usingInstallationType = CppEnums.InstallationType.TypeCount
	_currentActionIcon:SetShow(true)
	manufactureClickSetTextureUV( _currentActionIcon, 286, 1, 342, 58)
	_manufactureText:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_DRY" ) )
	_manufactureText:SetShow(true)
	_manufactureName:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_DRY" ) )
	_manufactureName:SetShow(true)
	_textDesc:SetText( PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC2_DRY" ) )
	_textTemp:SetText( PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_DRY" ))
	_textTemp:SetShow(true)

	_uiButtonManufacture:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE" ) )

	Manufacture_UpdateCheckRadioButton()

	_startKnowledgeIndex = 0
	_uiListScroll:SetControlPos(0)
	_uiListSelect:SetShow(false)
	ReconstructionAlchemyKnowledge( DRY_MENTALTHEMEKEY )
	ManufactureKnowledge_UpdateList()

	_defaultMSG1:SetShow( false )
	_defaultMSG2:SetShow( false )
	Material_Update( _usingItemSlotCount )
	
	if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
		-- 버튼 조건이 필요함.
		Inventory_SetFunctor( ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil  )
		Inventory_updateSlotData()
	else
		Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
		Warehouse_updateSlotData()
	end
end

function Manufacture_Button_LUp_Thinning(isClear)
	if Panel_Win_System:GetShow() then
		return
	end
	
	audioPostEvent_SystemUi(13,03)

	if( nil ~= isClear and true == isClear ) then
		Manufacture_ClearMaterial()
	end
	StopManufactureAction()

	_actionIndex = 4
	_usingItemSlotCount = 1
	-- 사용하는 슬롯의 갯수가 바뀌면 위치도 업데이트해줘야한다.
	Manufacture_UpdateSlotPos()
	Manufacture_ShowPointEffect()

	_usingInstallationType = CppEnums.InstallationType.TypeCount
	_currentActionIcon:SetShow(true)
	manufactureClickSetTextureUV( _currentActionIcon, 58, 115, 114, 171)
	_manufactureText:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_THINNING" ) )
	_manufactureText:SetShow(true)
	_manufactureName:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_THINNING" ) )
	_manufactureName:SetShow(true)
	_textDesc:SetText( PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC2_THINNING" ) )
	_textTemp:SetText( PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_THINNING" ))
	_textTemp:SetShow(true)

	_uiButtonManufacture:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE" ) )

	Manufacture_UpdateCheckRadioButton()


	_startKnowledgeIndex = 0
	_uiListScroll:SetControlPos(0)
	_uiListSelect:SetShow(false)
	ReconstructionAlchemyKnowledge( THINNING_MENTALTHEMEKEY )
	ManufactureKnowledge_UpdateList()

	_defaultMSG1:SetShow( false )
	_defaultMSG2:SetShow( false )
	Material_Update( _usingItemSlotCount )
	
	if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
		-- 버튼 조건이 필요함.
		Inventory_SetFunctor( ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil  )
		Inventory_updateSlotData()
	else
		Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
		Warehouse_updateSlotData()
	end
end

function Manufacture_Button_LUp_Heat(isClear)
	if Panel_Win_System:GetShow() then
		return
	end
	
	audioPostEvent_SystemUi(13,04)

	if( nil ~= isClear and true == isClear ) then
		Manufacture_ClearMaterial()
	end
	StopManufactureAction()

	_actionIndex = 5
	_usingItemSlotCount = 2
	-- 사용하는 슬롯의 갯수가 바뀌면 위치도 업데이트해줘야한다.
	Manufacture_UpdateSlotPos()
	Manufacture_ShowPointEffect()

	_usingInstallationType = CppEnums.InstallationType.TypeCount
	_currentActionIcon:SetShow(true)
	manufactureClickSetTextureUV( _currentActionIcon, 343, 58, 399, 114)
	_manufactureText:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_HEATING" ) )
	_manufactureText:SetShow(true)
	_manufactureName:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_HEATING" ) )
	_manufactureName:SetShow(true)
	_textDesc:SetText( PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC2_HEAT" ) )
	_textTemp:SetText( PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_HEAT" ))
	_textTemp:SetShow(true)

	_uiButtonManufacture:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE" ) )

	Manufacture_UpdateCheckRadioButton()

	_startKnowledgeIndex = 0
	_uiListScroll:SetControlPos(0)
	_uiListSelect:SetShow(false)
	ReconstructionAlchemyKnowledge( HEAT_MENTALTHEMEKEY )
	ManufactureKnowledge_UpdateList()

	_defaultMSG1:SetShow( false )
	_defaultMSG2:SetShow( false )
	Material_Update( _usingItemSlotCount )
	
	if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
		-- 버튼 조건이 필요함.
		Inventory_SetFunctor( ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil )
		Inventory_updateSlotData()
	else
		Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
		Warehouse_updateSlotData()
	end
end

function Manufacture_Button_LUp_Rainwater(isClear)
	if Panel_Win_System:GetShow() then
		return
	end
	
	audioPostEvent_SystemUi(00,00)

	if( nil ~= isClear and true == isClear ) then
		Manufacture_ClearMaterial()
	end
	StopManufactureAction()

	_actionIndex = 6
	_usingItemSlotCount = 1
	-- 사용하는 슬롯의 갯수가 바뀌면 위치도 업데이트해줘야한다.
	Manufacture_UpdateSlotPos()
	Manufacture_ShowPointEffect()

	_usingInstallationType = CppEnums.InstallationType.TypeCount
	_currentActionIcon:SetShow(true)
	manufactureClickSetTextureUV( _currentActionIcon, 400, 115, 456, 171)
	_manufactureText:SetText( PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_RAINWATER" ) )
	_manufactureText:SetShow(true)
	_manufactureName:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_RAINWATER" ) )
	_manufactureName:SetShow(true)
	_textDesc:SetText( PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC2_RAINWATER" ) )
	_textTemp:SetText( PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_RAINWATER" ))
	_textTemp:SetShow(true)

	_uiButtonManufacture:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE" ) )

	Manufacture_UpdateCheckRadioButton()


	_startKnowledgeIndex = 0
	_uiListScroll:SetControlPos(0)
	_uiListSelect:SetShow(false)
	ReconstructionAlchemyKnowledge( RAINWATER_MENTALTHEMEKEY )
	ManufactureKnowledge_UpdateList()

	_defaultMSG1:SetShow( false )
	_defaultMSG2:SetShow( false )
	
	if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
		-- 버튼 조건이 필요함.
		Inventory_SetFunctor( ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil  )
		Inventory_updateSlotData()
	else
		Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
		Warehouse_updateSlotData()
	end
end

function Manufacture_Button_LUp_RepairItem(isClear)
	if Panel_Win_System:GetShow() then
		return
	end
	
	audioPostEvent_SystemUi(13,09)

	if( nil ~= isClear and true == isClear ) then
		Manufacture_ClearMaterial()
	end

	StopManufactureAction()

	_actionIndex = 7
	_usingItemSlotCount = 1
	-- 사용하는 슬롯의 갯수가 바뀌면 위치도 업데이트해줘야한다.
	Manufacture_UpdateSlotPos()
	Manufacture_ShowPointEffect()

	_usingInstallationType = CppEnums.InstallationType.eType_Anvil
	_currentActionIcon:SetShow(true)
	manufactureClickSetTextureUV( _currentActionIcon, 229, 115, 285, 171)
	_manufactureText:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_REPAIR" ) )
	_manufactureText:SetShow(true)
	_manufactureName:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_REPAIR" ) )
	_manufactureName:SetShow(true)
	_textDesc:SetText( PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC2_REPAIR" ) )
	_textTemp:SetText( PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_REPAIR" ))
	_textTemp:SetShow(true)

	_uiButtonManufacture:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_REPAIR" ) )

	Manufacture_UpdateCheckRadioButton()

	ManufactureKnowledge_ClearList()
	
	_defaultMSG1:SetShow( false )
	_defaultMSG2:SetShow( false )
	
	if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
		-- 버튼 조건이 필요함.
		Inventory_SetFunctor( ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil  )
		Inventory_updateSlotData()
	else
		Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
		Warehouse_updateSlotData()
	end
end

function Manufacture_Button_LUp_Alchemy(isClear)
	if Panel_Win_System:GetShow() then
		return
	end
	
	audioPostEvent_SystemUi(13,13)

	if( nil ~= isClear and true == isClear ) then
		Manufacture_ClearMaterial()
	end
	StopManufactureAction()

	_actionIndex = 8
	_usingItemSlotCount = 2
	-- 사용하는 슬롯의 갯수가 바뀌면 위치도 업데이트해줘야한다.
	Manufacture_UpdateSlotPos()
	Manufacture_ShowPointEffect()

	_usingInstallationType = CppEnums.InstallationType.TypeCount
	_currentActionIcon:SetShow(true)
	manufactureClickSetTextureUV( _currentActionIcon, 400, 115, 456, 171)
	_manufactureText:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_ALCHEMY_MANUFACTURE_ALCHEMY" ) )
	_manufactureText:SetShow(true)
	_manufactureName:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_ALCHEMY_MANUFACTURE_ALCHEMY" ) )
	_manufactureName:SetShow(true)
	_textDesc:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_GAME_MANUFACTURE_DESC2_ALCHEMY" ) )
	_textTemp:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_GAME_MANUFACTURE_DESC_ALCHEMY" ))
	_textTemp:SetShow(true)

	_uiButtonManufacture:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE" ) )

	Manufacture_UpdateCheckRadioButton()

	_startKnowledgeIndex = 0
	_uiListScroll:SetControlPos(0)
	_uiListSelect:SetShow(false)
	ReconstructionAlchemyKnowledge( ALCHEMY_MENTALTHEMEKEY )
	ManufactureKnowledge_UpdateList()

	_defaultMSG1:SetShow( false )
	_defaultMSG2:SetShow( false )
	
	if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
		-- 버튼 조건이 필요함.
		Inventory_SetFunctor( ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil  )
		Inventory_updateSlotData()
	else
		Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
		Warehouse_updateSlotData()
	end
end

function Manufacture_Button_LUp_Cook(isClear)
	if Panel_Win_System:GetShow() then
		return
	end
	
	audioPostEvent_SystemUi(13,14)

	if( nil ~= isClear and true == isClear ) then
		Manufacture_ClearMaterial()
	end
	StopManufactureAction()

	_actionIndex = 9
	_usingItemSlotCount = 2
	-- 사용하는 슬롯의 갯수가 바뀌면 위치도 업데이트해줘야한다.
	Manufacture_UpdateSlotPos()
	Manufacture_ShowPointEffect()

	_usingInstallationType = CppEnums.InstallationType.TypeCount
	_currentActionIcon:SetShow(true)
	manufactureClickSetTextureUV( _currentActionIcon, 115, 172, 171, 228)
	_manufactureText:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_ALCHEMY_MANUFACTURE_COOK" ) )
	_manufactureText:SetShow(true)
	_manufactureName:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_ALCHEMY_MANUFACTURE_COOK" ) )
	_manufactureName:SetShow(true)
	_textDesc:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_GAME_MANUFACTURE_DESC2_COOK" ) )
	_textTemp:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_GAME_MANUFACTURE_DESC_COOK" ))
	_textTemp:SetShow(true)

	_uiButtonManufacture:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE" ) )

	Manufacture_UpdateCheckRadioButton()

	_startKnowledgeIndex = 0
	_uiListScroll:SetControlPos(0)
	_uiListSelect:SetShow(false)
	ReconstructionAlchemyKnowledge( COOK_MENTALTHEMEKEY )
	ManufactureKnowledge_UpdateList()

	_defaultMSG1:SetShow( false )
	_defaultMSG2:SetShow( false )
	
	if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
		-- 버튼 조건이 필요함.
		Inventory_SetFunctor( ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil  )
		Inventory_updateSlotData()
	else
		Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
		Warehouse_updateSlotData()
	end
end

function Manufacture_Button_LUp_RGCook(isClear)
	if Panel_Win_System:GetShow() then
		return
	end
	
	audioPostEvent_SystemUi(13,14)

	if( nil ~= isClear and true == isClear ) then
		Manufacture_ClearMaterial()
	end
	StopManufactureAction()

	_actionIndex = 10
	_usingItemSlotCount = 2
	-- 사용하는 슬롯의 갯수가 바뀌면 위치도 업데이트해줘야한다.
	Manufacture_UpdateSlotPos()
	Manufacture_ShowPointEffect()

	_usingInstallationType = CppEnums.InstallationType.TypeCount
	_currentActionIcon:SetShow(true)
	manufactureClickSetTextureUV( _currentActionIcon, 345, 456, 401, 512)
	_manufactureText:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_ALCHEMY_MANUFACTURE_ROYALGIFT_COOK" ) )
	_manufactureText:SetShow(true)
	_manufactureName:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_ALCHEMY_MANUFACTURE_ROYALGIFT_COOK" ) )
	_manufactureName:SetShow(true)
	_textDesc:SetText( PAGetString( Defines.StringSheet_RESOURCE, "GAME_MANUFACTURE_DESC_ROYALGIFT_COOK" ) )
	_textTemp:SetText( PAGetString( Defines.StringSheet_RESOURCE, "LUA_GAME_MANUFACTURE_DESC2_ROYALGIFT_COOK" ) )
	_textTemp:SetShow(true)

	_uiButtonManufacture:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE" ) )

	Manufacture_UpdateCheckRadioButton()

	_startKnowledgeIndex = 0
	_uiListScroll:SetControlPos(0)
	_uiListSelect:SetShow(false)
	ReconstructionAlchemyKnowledge( ROYALCOOK_MENTALTHEMEKEY )
	ManufactureKnowledge_UpdateList()

	_defaultMSG1:SetShow( false )
	_defaultMSG2:SetShow( false )
	
	if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
		-- 버튼 조건이 필요함.
		Inventory_SetFunctor( ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil  )
		Inventory_updateSlotData()
	else
		Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
		Warehouse_updateSlotData()
	end
end

function Manufacture_Button_LUp_RGAlchemy(isClear)
	if Panel_Win_System:GetShow() then
		return
	end
	
	audioPostEvent_SystemUi(13,13)

	if( nil ~= isClear and true == isClear ) then
		Manufacture_ClearMaterial()
	end
	StopManufactureAction()

	_actionIndex = 11
	_usingItemSlotCount = 2
	-- 사용하는 슬롯의 갯수가 바뀌면 위치도 업데이트해줘야한다.
	Manufacture_UpdateSlotPos()
	Manufacture_ShowPointEffect()

	_usingInstallationType = CppEnums.InstallationType.TypeCount
	_currentActionIcon:SetShow(true)
	manufactureClickSetTextureUV( _currentActionIcon, 400, 172, 456, 228)
	_manufactureText:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_ALCHEMY_MANUFACTURE_ROYALGIFT_ALCHEMY" ) )
	_manufactureText:SetShow(true)
	_manufactureName:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_ALCHEMY_MANUFACTURE_ROYALGIFT_ALCHEMY" ) )
	_manufactureName:SetShow(true)
	_textDesc:SetText( PAGetString( Defines.StringSheet_RESOURCE, "GAME_MANUFACTURE_DESC_ROYALGIFT_ALCHEMY" ) )
	_textTemp:SetText( PAGetString( Defines.StringSheet_RESOURCE, "LUA_GAME_MANUFACTURE_DESC2_ROYALGIFT_ALCHEMY" ) )
	_textTemp:SetShow(true)

	_uiButtonManufacture:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE" ) )

	Manufacture_UpdateCheckRadioButton()

	_startKnowledgeIndex = 0
	_uiListScroll:SetControlPos(0)
	_uiListSelect:SetShow(false)
	ReconstructionAlchemyKnowledge( ROYALALCHEMY_MENTALTHEMEKEY )
	ManufactureKnowledge_UpdateList()

	_defaultMSG1:SetShow( false )
	_defaultMSG2:SetShow( false )
	
	if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
		-- 버튼 조건이 필요함.
		Inventory_SetFunctor( ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil  )
		Inventory_updateSlotData()
	else
		Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
		Warehouse_updateSlotData()
	end
end

function Manufacture_Button_LUp_GuildManufacture( isClear )
	if Panel_Win_System:GetShow() then
		return
	end
	
	local houseWrapper = housing_getHouseholdActor_CurrentPosition()
	if nil == houseWrapper then
		Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_INNTER_GUILDHOUSE_USE"))
		return
	end

	audioPostEvent_SystemUi(13,13)

	if( nil ~= isClear and true == isClear ) then
		Manufacture_ClearMaterial()
	end
	StopManufactureAction()

	_actionIndex = 12
	_usingItemSlotCount = 5
	-- 사용하는 슬롯의 갯수가 바뀌면 위치도 업데이트해줘야한다.
	Manufacture_UpdateSlotPos()
	Manufacture_ShowPointEffect()

	_usingInstallationType = CppEnums.InstallationType.TypeCount
	_currentActionIcon:SetShow(true)
	manufactureClickSetTextureUV( _currentActionIcon, 400, 172, 456, 228)
	_manufactureText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_GUILDMANURACTURE_NAME") )
	_manufactureText:SetShow(true)
	_manufactureName:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_GUILDMANURACTURE_NAME") )
	_manufactureName:SetShow(true)
	_textDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_GUILDMANUFACTURE_DESC") )
	_textTemp:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_GUILDMANUFACTURE_SUBDESC") )
	_textTemp:SetShow(true)

	_uiButtonManufacture:SetText( PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_BTN_MANUFACTURE" ) )

	Manufacture_UpdateCheckRadioButton()

	_startKnowledgeIndex = 0
	_uiListScroll:SetControlPos(0)
	_uiListSelect:SetShow(false)
	ReconstructionAlchemyKnowledge( GUILDMANUFACTURE_MENTALTHEMEKEY )
	ManufactureKnowledge_UpdateList()

	_defaultMSG1:SetShow( false )
	_defaultMSG2:SetShow( false )
	
	if CppEnums.ItemWhereType.eInventory == materialItemWhereType or CppEnums.ItemWhereType.eCashInventory == materialItemWhereType then
		-- 버튼 조건이 필요함.
		Inventory_SetFunctor( ManufactureAction_InvenFiler, Manufacture_PushItemFromInventory, Manufacture_Close, nil  )
		Inventory_updateSlotData()
	else
		Warehouse_SetFunctor(ManufactureAction_WarehouseFilter, Manufacture_PushItemFromWarehouse)
		Warehouse_updateSlotData()
	end
end

------------------------------------------------------------------------------------
-- 지식 리스트 관련
-------------------------------------------------------------------------------------
function ManufactureKnowledge_ScrollEvent( isUp )
	if( false == _uiListScroll:IsEnable() ) then
		return
	end

	local count = getCountAlchemyKnowledge()

	if ( count == 0 ) or ( count <= KNOWLEDGE_TEXT_COUNT) then
		return
	end

	local maxStartSlotCount = count - KNOWLEDGE_TEXT_COUNT
	local divideScroll = 1 / maxStartSlotCount

	if( nil ~= isUp ) then
		if (true == isUp) then
			_startKnowledgeIndex	= _startKnowledgeIndex - 1
			_uiListScroll:ControlButtonUp()
		else
			_startKnowledgeIndex	= _startKnowledgeIndex + 1
			_uiListScroll:ControlButtonDown()
		end

		if	_startKnowledgeIndex < 0	then
			_startKnowledgeIndex	= 0
		end

		if	maxStartSlotCount  < _startKnowledgeIndex	then
			_startKnowledgeIndex	= maxStartSlotCount
		end
	else
		local	currentScrollPos	= _uiListScroll:GetControlPos()
		local	startSlotIndexString	= string.format( "%.0f", currentScrollPos / divideScroll )
		_startKnowledgeIndex	= tonumber(startSlotIndexString)
	end

	_uiListScroll:SetControlPos(  divideScroll * _startKnowledgeIndex )

	ManufactureKnowledge_UpdateList()
end

function Manufacture_KnowledgeList_SelectKnowledge( index )
	if Panel_Win_System:GetShow() then
		return
	end
	
	local posX = _uiListBG:GetPosX() + _uiListText[index]:GetPosX()
	local posY = _uiListBG:GetPosY() + _uiListText[index]:GetPosY()
	_uiListSelect:SetPosX( posX - 7 )
	_uiListSelect:SetPosY( posY - 1 )
	_uiListSelect:SetShow(true)

	local knowledgeIndex = _startKnowledgeIndex + index
	local mentalCardStaticWrapper = getAlchemyKnowledge(knowledgeIndex)
	if( nil ~= mentalCardStaticWrapper ) then
		local isLearn = isLearnMentalCardForAlchemy( mentalCardStaticWrapper:getKey() )
		if( true == isLearn ) then
			_uiKnowledgeDesc:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
			_uiKnowledgeDesc:SetText( mentalCardStaticWrapper:getDesc() )
			_frameContent:SetSize( _frameContent:GetSizeX(), _uiKnowledgeDesc:GetSizeY() )
			if ( 110 < _uiKnowledgeDesc:GetSizeY() ) then
				_frameDescScroll:SetShow(true)
				_frameDescScroll:SetControlPos(0)
			else
				_frameDescScroll:SetShow(false)
			end

			_uiKnowledgeIcon:ChangeTextureInfoName( mentalCardStaticWrapper:getImagePath() )
			local x1, y1, x2, y2 = setTextureUV_Func( _uiKnowledgeIcon, 0, 0, 360, 360 )
			_uiKnowledgeIcon:getBaseTexture():setUV(  x1, y1, x2, y2  )
			_uiKnowledgeIcon:setRenderTexture(_uiKnowledgeIcon:getBaseTexture())
		else
			_uiKnowledgeDesc:SetText( " " )
			_uiKnowledgeIcon:ChangeTextureInfoName( "UI_Artwork/Unkown_Intelligence.dds" )
			_frameContent:SetSize( _frameContent:GetSizeX(), _uiKnowledgeDesc:GetSizeY() )
			_frameDescScroll:SetShow(false)
		end
	end
end

function Manufacture_KnowledgeList_Tooltip( isShow, index )
	local knowledgeIndex = _startKnowledgeIndex + index
	local mentalCardStaticWrapper = getAlchemyKnowledge(knowledgeIndex)

	if isShow then
		if( nil ~= mentalCardStaticWrapper ) then
			local isLearn = isLearnMentalCardForAlchemy( mentalCardStaticWrapper:getKey() )
			if not isLearn then
				local uiControl = _uiListText[index]
				local name = "???"
				local desc = mentalCardStaticWrapper:getKeyword()
				TooltipSimple_Show( uiControl, name, desc )
			end
		end
	else
		TooltipSimple_Hide()
	end
end

function ManufactureKnowledge_UpdateList( )
	-- 열려진 리스트를 꺼야 한다.
	ManufactureKnowledge_ClearList( )
	local count = getCountAlchemyKnowledge()

	if( KNOWLEDGE_TEXT_COUNT < count ) then
		_uiListScroll:SetShow(true)
		_uiListScroll:SetMonoTone(false)
	else
		_uiListScroll:SetShow(false)
		_uiListScroll:SetMonoTone(true)
	end

	if ( count <= 0 ) then
		return
	end
	
	local endIndex = _startKnowledgeIndex + (KNOWLEDGE_TEXT_COUNT-1)
	if( count-1 < endIndex ) then
		endIndex = count-1
	end

	local ctrlIndex = 0
	for index=_startKnowledgeIndex, endIndex do
		local mentalCardStaticWrapper = getAlchemyKnowledge(index)
		if( nil ~= mentalCardStaticWrapper ) then
			local isLearn = isLearnMentalCardForAlchemy( mentalCardStaticWrapper:getKey() )
			if( true == isLearn ) then
				_uiListText[ctrlIndex]:SetFontColor( UI_color.C_FF84FFF5 ) -- 하늘색
				_uiListText[ctrlIndex]:SetText( mentalCardStaticWrapper:getName() )
			else
				_uiListText[ctrlIndex]:SetFontColor( UI_color.C_FF888888 ) -- 회색
				_uiListText[ctrlIndex]:SetText( "??? ( " .. mentalCardStaticWrapper:getKeyword() .. " )" ) -- 미확인 지식
			end
			_uiListText[ctrlIndex]:SetShow(true)
		else
			_uiListText[ctrlIndex]:SetShow(false)
		end
		ctrlIndex = ctrlIndex + 1
	end
	
	UIScroll.SetButtonSize( _uiListScroll, KNOWLEDGE_TEXT_COUNT, count )		-- 스크롤 컨트롤들 , UI에서 보여주는 최대개수 , 실제 리스트의 수
end

function ManufactureKnowledge_ShowList( isShow )

	for index=0, KNOWLEDGE_TEXT_COUNT-1 do
		_uiListText[index]:SetText("")
		_uiListText[index]:SetShow(false)
	end

	if( isShow ) then
		_uiListScroll:SetPosX(_uiListScrollOriginPosX)
		
		-- 창 열고 가공 선택하지 않았을 경우에 우측 패널에 메시지 표시
		_defaultMSG1:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_MANUFACTURE_DEFAULT_MSG_1" ) )
		_defaultMSG2:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_MANUFACTURE_DEFAULT_MSG_2" ) )
		_defaultMSG1:SetShow( true )
		_defaultMSG2:SetShow( true )
	end

	_uiListBG:SetShow( isShow )
	_uiListScroll:SetShow( isShow )

	_uiListBG:ComputePos()
	_uiListScroll:ComputePos()
	_uiListSelect:ComputePos()
	_uiKnowledgeIcon:ComputePos()
	
	_uiKnowledgeIcon:ReleaseTexture()
	_uiKnowledgeIcon:SetShow(isShow)

	_uiKnowledgeDesc:SetText("")
	_uiKnowledgeDesc:SetShow(isShow)
	_frameDescScroll:SetShow(false)
	_frameContent:SetSize( _frameContent:GetSizeX(), _uiKnowledgeDesc:GetSizeY() )
	_uiListSelect:SetShow(false)

	UI.getChildControl( Panel_Manufacture, "Button_Close" ):ComputePos()
	UI.getChildControl( Panel_Manufacture, "Button_Question" ):ComputePos()
	UI.getChildControl( Panel_Manufacture, "StaticText_Title" ):ComputePos()
end



function ManufactureKnowledge_ClearList( )

	for index=0, KNOWLEDGE_TEXT_COUNT-1 do
		_uiListText[index]:SetText("")
		_uiListText[index]:SetShow(false)
	end

	_uiListBG:SetShow( true )
	_uiListScroll:SetShow( false )

	_uiKnowledgeIcon:ReleaseTexture()
	_uiKnowledgeIcon:SetShow(true)

	_uiKnowledgeDesc:SetText("")
	_frameContent:SetSize( _frameContent:GetSizeX(), _uiKnowledgeDesc:GetSizeY() )
	_uiKnowledgeDesc:SetShow(true)
	_uiListSelect:SetShow(false)

end

function Note_Mouse_LUp()
	if Panel_Win_System:GetShow() then
		return
	end
	Panel_ProductNote_ShowToggle()
end

function Note_Mouse_On()
	audioPostEvent_SystemUi(01,13)							-- 제작노트 버튼에 마우스 오버 시 사운드
end

-- 초기화
ManufactureControlInit()
Manufacture_Reset_ContinueGrindJewel()

function Material_Update( slotCount )
	local inventory = getSelfPlayer():get():getInventory()
	local invenSize = inventory:size()

	for ii = 0, slotCount-1  do
		if( nil ~= _materialSlotNoList[ii] and  _materialSlotNoList[ii] <= invenSize ) then
			local curentInventoryType	= Inventory_GetCurrentInventoryType()
			local itemWrapper			= getInventoryItemByType( curentInventoryType, _materialSlotNoList[ii] )
			if( nil ~= itemWrapper ) then
				_slotList[ii]:setItemByStaticStatus( itemWrapper:getStaticStatus(), itemWrapper:get():getCount_s64() )
			end
		end
	end
end

------------------------------------------------------------------------------------------------------------


function Manufacture_Notify:Init()
	for key, value in pairs (self._templat) do
		value:SetShow(false)
	end	

	self._defalutSpanY = Panel_Manufacture_Notify:GetSpanSize().y	
	self._result_Title:SetText(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_RESULT"))
	self._progress_Effect:AddEffect("UI_Quest_Complete_GreenAura", true, 15, 0)
end
Manufacture_Notify:Init()

function Manufacture_Notify:createResultControl(index)
	if nil == self._item_Result[index] or nil == self._icon_ResultBG[index] or nil == self._icon_Result[index] then
		self._item_Result[index] 		= UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Manufacture_Notify, "item_Result_"..index )
		self._icon_ResultBG[index] 		= UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC,	 Panel_Manufacture_Notify, "icon_ResultBG_"..index )
		self._icon_Result[index] 		= UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC,	 Panel_Manufacture_Notify, "icon_Result_"..index )

		CopyBaseProperty( self._templat._item_Result, 		self._item_Result[index] )
		CopyBaseProperty( self._templat._icon_ResultBG, 	self._icon_ResultBG[index] )
		CopyBaseProperty( self._templat._icon_Result, 		self._icon_Result[index] )
		
		self._item_Result[index]		:SetSpanSize(self._item_Result[index]		:GetSpanSize().x, 	self._item_Result[index]		:GetSpanSize().y - self._gapY * (index - 1) )
		self._icon_ResultBG[index]		:SetSpanSize(self._icon_ResultBG[index]		:GetSpanSize().x, 	self._icon_ResultBG[index]		:GetSpanSize().y - self._gapY * (index - 1) )
		self._icon_Result[index]		:SetSpanSize(self._icon_Result[index]		:GetSpanSize().x,	self._icon_Result[index]		:GetSpanSize().y - self._gapY * (index - 1) )
		self._icon_ResultBG[index]		:addInputEvent("Mouse_On","Manufacture_Tooltip_Item_Show(" .. index .. ", true)")
		self._icon_ResultBG[index]		:addInputEvent("Mouse_Out","Panel_Tooltip_Item_hideTooltip()")
	end
end

function Manufacture_Notify:createResourceControl(index)
	if nil == self._item_Resource[index] or nil == self._icon_ResourceBG[index] or nil == self._icon_Resource[index] then
		self._item_Resource[index] 		= UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Manufacture_Notify, "item_Resource_"..index )
		self._icon_ResourceBG[index]	= UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC,	 Panel_Manufacture_Notify, "icon_ResourceBG_"..index )
		self._icon_Resource[index] 		= UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC,	 Panel_Manufacture_Notify, "icon_Resource_"..index )
		
		CopyBaseProperty( self._templat._item_Resource, 	self._item_Resource[index] )
		CopyBaseProperty( self._templat._icon_ResourceBG, 	self._icon_ResourceBG[index] )
		CopyBaseProperty( self._templat._icon_Resource, 	self._icon_Resource[index] )
		
		self._item_Resource[index]		:SetSpanSize(self._templat._item_Resource	:GetSpanSize().x, 	self._templat._item_Resource	:GetSpanSize().y + self._gapY * (index - 1) )
		self._icon_ResourceBG[index]	:SetSpanSize(self._templat._icon_ResourceBG	:GetSpanSize().x, 	self._templat._icon_ResourceBG	:GetSpanSize().y + self._gapY * (index - 1) )
		self._icon_Resource[index]		:SetSpanSize(self._templat._icon_Resource	:GetSpanSize().x,	self._templat._icon_Resource	:GetSpanSize().y + self._gapY * (index - 1) )
		self._icon_ResourceBG[index]	:addInputEvent("Mouse_On","Manufacture_Tooltip_Item_Show(" .. index .. ", false)")
		self._icon_ResourceBG[index]	:addInputEvent("Mouse_Out","Panel_Tooltip_Item_hideTooltip()")
	end
end

function Manufacture_Notify:clear()
	Manufacture_Notify._data_Resource = {}
	Manufacture_Notify._data_Result = {}
	Manufacture_Notify._progress_Bar:SetSmoothMode(false)
	Manufacture_Notify._progress_Bar:SetProgressRate(0)
	
	for key, value in pairs (self._item_Resource) do
		value:SetShow(false)
	end	
	for key, value in pairs (self._icon_ResourceBG) do
		value:SetShow(false)
	end	
	for key, value in pairs (self._icon_Resource) do
		value:SetShow(false)
	end	
	for key, value in pairs (self._item_Result) do
		value:SetShow(false)
	end	
	for key, value in pairs (self._icon_ResultBG) do
		value:SetShow(false)
	end	
	for key, value in pairs (self._icon_Result) do
		value:SetShow(false)
	end	
end

function Manufacture_Notify:SetPos()
	local gapCnt = #self._data_Resource
	Panel_Manufacture_Notify:SetSpanSize(Panel_Manufacture_Notify:GetSpanSize().x, self._defalutSpanY + self._gapY * gapCnt)
end

function Manufacture_Progress_Update( materialItemWhereType )
	local progressRate = 0
	local currentInventoryType = Inventory_GetCurrentInventoryType()

	for key, value in pairs (Manufacture_Notify._data_Resource) do
		local index = key
		local _name = value._name
		local _originalCnt = value._originalCnt
		local _currentCnt = value._currentCnt
		local _iconPath = value._iconPath
		local _param = Manufacture_Notify._successCount / math.floor(_originalCnt / ( (_originalCnt - _currentCnt) / Manufacture_Notify._successCount ))		
		local _rate = math.floor( _param * 100 )
		
		Manufacture_Notify:createResourceControl(index)
		
		Manufacture_Notify._item_Resource[index]	:SetText(_name .. " (" .. _currentCnt ..")")
		Manufacture_Notify._icon_Resource[index]	:ChangeTextureInfoName(_iconPath)
		local width
		
		Manufacture_Notify._item_Resource[index]	:SetShow(true)
		Manufacture_Notify._icon_Resource[index]	:SetShow(true)		
		Manufacture_Notify._icon_ResourceBG[index]	:SetShow(true)		
		Manufacture_Notify._icon_ResourceBG[index]	:SetEnableArea(0.0, 0.0, Manufacture_Notify._icon_ResourceBG[index]:GetSizeX() + Manufacture_Notify._item_Resource[index]:GetTextSizeX(), Manufacture_Notify._icon_ResourceBG[index]:GetSizeY())		
		 
		if progressRate < _rate then
			progressRate = _rate
		end
	end	
	
	if Manufacture_Notify._successCount > 0 then
			Manufacture_Notify._progress_Bar:SetSmoothMode(true)
	end
	Manufacture_Notify._progress_Bar:SetProgressRate(progressRate)
	Manufacture_Notify._progress_Text:SetText(progressRate .. "%")

	-- 가공 도중에 서로 다른 가방을 선택하게되면 가공이 꼬이기 때문에 인벤토리 타입 체크를 꼭 해준다!
	if materialItemWhereType ~= currentInventoryType then
		if currentInventoryType ~= 0 then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_BAG_TABSELECT") ) -- 가방에 펄 탭을 선택하면 연속 가공이 취소됩니다.
			Manufacture_ClearValues()
			Manufacture_Response()
		end
	end
	for key, value in pairs (Manufacture_Notify._data_Result) do
		local index = key
		local _name			= value._name	
		local _iconPath		= value._iconPath
		local _currentCnt	= value._currentCnt		

		Manufacture_Notify:createResultControl(index)
		
		Manufacture_Notify._item_Result[index] 		:SetText(_name .. " (" .. _currentCnt ..")")
		Manufacture_Notify._icon_Result[index] 		:ChangeTextureInfoName(_iconPath)
		
		Manufacture_Notify._item_Result[index] 		:SetShow(true)
		Manufacture_Notify._icon_Result[index] 		:SetShow(true)
		Manufacture_Notify._icon_ResultBG[index] 	:SetShow(true)
		Manufacture_Notify._icon_ResultBG[index] 	:SetEnableArea(- Manufacture_Notify._item_Result[index]:GetTextSizeX(), 0.0, Manufacture_Notify._icon_ResultBG[index]:GetSizeX() , Manufacture_Notify._icon_ResultBG[index]:GetSizeY())		
	end

	if #Manufacture_Notify._data_Result > 0 then
		Manufacture_Notify._result_Title:SetSpanSize(Manufacture_Notify._result_Title:GetSpanSize().x, Manufacture_Notify._templat._item_Result:GetSpanSize().y - Manufacture_Notify._gapY * #Manufacture_Notify._data_Result )
		Manufacture_Notify._result_Title:SetShow(true)
	else
		Manufacture_Notify._result_Title:SetShow(false)
	end
end

function Manufacture_Tooltip_Item_Show(index, isResult)
	local itemKey = nil
	local uiBase = nil
	if isResult then
		itemKey = Manufacture_Notify._data_Result[index]._key
		uiBase = Manufacture_Notify._icon_ResultBG[index]
	elseif false == isResult then
		itemKey = Manufacture_Notify._data_Resource[index]._key
		uiBase = Manufacture_Notify._icon_ResourceBG[index]
	end
	
	if itemKey == nil or nil == uiBase then
		return
	end

	local staticStatusWrapper = getItemEnchantStaticStatus( itemKey )
	
	Panel_Tooltip_Item_Show(staticStatusWrapper, uiBase, true, false)
end

-- registerEvent로 EventChangedSelfPlayerActionVariable 를 체크하면 값이 2개로 온다.
function IsManufacture_Chk(variableName, value)
	-- 가공 시작하면, 가공 중임을 알린다.
	if variableName == "IsManufactureChk"  then
		if value == 0 then
			Panel_Manufacture_Notify:SetShow(false)
			Manufacture_Notify:clear()
		else
			Panel_Manufacture_Notify:SetShow(true)
			Manufacture_Notify._type_Name:SetText(PAGetString(Defines.StringSheet_GAME, manufactureListName[_actionIndex]))
			Manufacture_Notify:SetPos()
			Manufacture_Progress_Update( materialItemWhereType )
		end
		
		if( AllowChangeInputMode() ) then
			if( check_ShowWindow() ) then
				UI.Set_ProcessorInputMode( IM.eProcessorInputMode_UiMode )
			else
				UI.Set_ProcessorInputMode( IM.eProcessorInputMode_GameMode)
			end
		else
			SetFocusChatting()
		end
	else
		Panel_Manufacture_Notify:SetShow(false)
		Manufacture_Notify:clear()
	end
end

function Manufacture_Notify_Check()
	if true == Panel_Manufacture_Notify:GetShow() and 0 == #Manufacture_Notify._data_Resource then
		Panel_Manufacture_Notify:SetShow(false)
	end
end

function ManufactureAction_InvenFiler( slotNo, itemWrapper, inventoryType )	-- 각 가공 인벤 필터
	if( -1 == _actionIndex ) then
		return false;
	end
	
	local isVested			= itemWrapper:get():isVested()
	local isPersonalTrade	= itemWrapper:getStaticStatus():isPersonalTrade()

	if (isUsePcExchangeInLocalizingValue()) then
		local isFilter = ( isVested and isPersonalTrade )
		if( isFilter ) then
			return isFilter
		end
	end
	
	local actionName = _listAction[_actionIndex]._actionName;
	local isEnable = nil
	-- if isNormalInvenCheck() then -- 이 것이 없으면 펄 인벤까지 필터가 먹는다.
		if 7 == _actionIndex then
			isEnable = itemWrapper:checkToRepairItem();
		else
			isEnable = isManufactureItem( inventoryType, slotNo, actionName );
		end
		return ( not isEnable )
	-- else
	-- 	return true
	-- end

end

function ManufactureAction_WarehouseFilter( slotNo, itemWrapper, stackCount )	-- 각 가공 창고 필터
	if( -1 == _actionIndex ) then
		return false;
	end
	
	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		return false
	end
	
	local isVested			= itemWrapper:get():isVested()
	local isPersonalTrade	= itemWrapper:getStaticStatus():isPersonalTrade()

	if (isUsePcExchangeInLocalizingValue()) then
		local isFilter = ( isVested and isPersonalTrade )
		if( isFilter ) then
			return isFilter
		end
	end

	local regionKey = selfPlayer:getRegionKey()
	local actionName = _listAction[_actionIndex]._actionName;
	local isEnable = nil
	if 7 == _actionIndex then
		isEnable = itemWrapper:checkToRepairItem();
	else
		isEnable = isManufactureItemInWareHouse( regionKey, slotNo, actionName );
	end
	return ( not isEnable )
end

function manufactureClickSetTextureUV( uiBase, x1, y1, x2, y2)
	local x1, y1, x2, y2 = setTextureUV_Func( uiBase, x1, y1, x2, y2 )
	uiBase:getBaseTexture():setUV( x1, y1, x2, y2 )
	uiBase:setRenderTexture(uiBase:getBaseTexture())
	uiBase:SetShow(true)
end

function manufacture_ShowIconToolTip( isShow, idx )
	local name = nil
	local desc = nil
	if isShow == true then
		audioPostEvent_SystemUi(01,13)
		if idx == 0 then
			name = PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_SHAKE" )
			desc = PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_SHAKE" )
		elseif 1 == idx then
			name = PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_GRIND" )
			desc = PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_GRIND" )
		elseif 2 == idx then
			name = PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_WOODSPLITTING" )
			desc = PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_FIREWOOD" )
		elseif 3 == idx then
			name = PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_DRY" )
			desc = PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_DRY" )
		elseif 4 == idx then
			name = PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_THINNING" )
			desc = PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_THINNING" )
		elseif 5 == idx then
			name = PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_HEATING" )
			desc = PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_HEAT" )
		elseif 6 == idx then
			name = PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_RAINWATER" )
			desc = PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_RAINWATER" )
		elseif 7 == idx then
			name = PAGetString( Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_REPAIR" )
			desc = PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_REPAIR" )
		elseif 8 == idx then
			name = PAGetString( Defines.StringSheet_GAME, "LUA_ALCHEMY_MANUFACTURE_ALCHEMY" )
			desc = PAGetString( Defines.StringSheet_GAME, "LUA_GAME_MANUFACTURE_DESC_ALCHEMY" )
		elseif 9 == idx then
			name = PAGetString( Defines.StringSheet_GAME, "LUA_ALCHEMY_MANUFACTURE_COOK" )
			desc = PAGetString( Defines.StringSheet_GAME, "LUA_GAME_MANUFACTURE_DESC_COOK" )
		elseif 10 == idx then
			name = PAGetString( Defines.StringSheet_GAME, "LUA_ALCHEMY_MANUFACTURE_ROYALGIFT_COOK" )
			desc = PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_ROYALGIFT_COOK" )
		elseif 11 == idx then
			name = PAGetString( Defines.StringSheet_GAME, "LUA_ALCHEMY_MANUFACTURE_ROYALGIFT_ALCHEMY" )
			desc = PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_ROYALGIFT_ALCHEMY" )
		elseif 12 == idx then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_GUILDMANURACTURE_NAME")
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_GUILDMANUFACTURE_SUBDESC")
		end

		if false == isEnableMsg[idx] then
			desc = desc .. "\n" .. PAGetString( Defines.StringSheet_GAME, "LUA_MANUFACTURE_NEED_KNOWLEDGE" )
		end

		registTooltipControl(_listAction[idx]._radioBtn, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( _listAction[idx]._radioBtn, name, desc )
	else

		TooltipSimple_Hide()
	end
end

function noneStackItemCheckBT()	-- 빻기 반복 체크버튼 체크여부 저장 (가공시 창이 닫히기 때문)
	if Panel_Manufacture:GetShow() then
		noneStackItemCheck = noneStackItem_ChkBtn:IsCheck()
	end
end

function Manufacture_RepeatAction()
	if Panel_Win_System:GetShow() then
		return
	end
	
	if (nil ~= #noneStackItemList and 0 < #noneStackItemList and true == noneStackItemCheck) or (true == hasNoneStackItem and true == noneStackItemCheck) then	-- and 1 == _actionIndex
	-- if (nil ~= #noneStackItemList and 0 < #noneStackItemList and true == noneStackItemCheck and 1 == _actionIndex) then
		---- "알 림", "동일한 아이템이 모두 가공 됩니다.\n이대로 진행하시겠습니까?"
		local messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE"), content = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_CONTINUEGRIND_MSGBOX_DESC"), functionYes = Manufacture_Mouse_LUp, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.
		PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData, "middle")
	else
		Manufacture_Mouse_LUp()
	end

end

function registEventHandler()
	for i=0, MAX_ACTION_BTN-1 do
		_listAction[i]._radioBtn:addInputEvent("Mouse_On",	"manufacture_ShowIconToolTip( true, " .. i .. " )")
		_listAction[i]._radioBtn:addInputEvent("Mouse_Out",	"manufacture_ShowIconToolTip( false )")
	end
end
-- Pc_Common.xml과 각 클래스 ??_Basic.xml 내 FrameEvent의  Event 값이 Variable 이 변하면, isManufacture_Chk 함수를 실행한다.

registerEvent("onScreenResize", 						"manufacture_Repos" )
registerEvent("EventChangedSelfPlayerActionVariable",	"IsManufacture_Chk")

Panel_Manufacture_Notify:RegisterUpdateFunc( "Manufacture_Notify_Check" )
registEventHandler()