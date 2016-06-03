Panel_Window_Inventory:SetShow(false, false)
Panel_Window_Inventory:ActiveMouseEventEffect(true)
Panel_Window_Inventory:setMaskingChild(true)
Panel_Window_Inventory:setGlassBackground(true)
Panel_Window_Inventory:RegisterShowEventFunc( true, 'InventoryShowAni()' )
Panel_Window_Inventory:RegisterShowEventFunc( false, 'InventoryHideAni()' )

Panel_Invertory_Manufacture_BG:SetShow( false )
Panel_Invertory_ExchangeButton:SetShow( false )

Panel_Window_Inventory:RegisterUpdateFunc('Inventory_UpdatePerFrame')
Panel_Inventory_CoolTime_Effect_Item_Slot:RegisterShowEventFunc( true, 'Inventory_ItemCoolTimeEffect_ShowAni()' )
	
local UI_ANI_ADV 		= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM 				= CppEnums.EProcessorInputMode
local UI_color 			= Defines.Color
local UI_PSFT 			= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_PUCT 			= CppEnums.PA_UI_CONTROL_TYPE
local UCT 				= CppEnums.PA_UI_CONTROL_TYPE
local UI_TISNU 			= CppEnums.TInventorySlotNoUndefined
local UI_TM 			= CppEnums.TextMode
local UCT_STATICTEXT	= CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT
local isFirstTab 		= true

local openUiType = nil

-- 마우스 오버시 배경 이팩트 재생용 변수
local over_SlotEffect

Panel_Inventory_isBlackStone_16001 = false
Panel_Inventory_isBlackStone_16002 = false
Panel_Inventory_isSocketItem = false

local	radioButtonManu			= UI.getChildControl( Panel_Invertory_Manufacture_BG, "Button_Manufacture" )	-- 가공
local	radioButtonNote			= UI.getChildControl( Panel_Invertory_Manufacture_BG, "Button_Note" )			-- 제작노트

local 	btn_AlchemyStone		= UI.getChildControl( Panel_Window_Inventory, "Button_AlchemyStone" )			-- 연금석
local 	btn_AlchemyFigureHead	= UI.getChildControl( Panel_Window_Inventory, "Button_AlchemyFigureHead" )		-- 토템
local	btn_DyePalette			= UI.getChildControl( Panel_Window_Inventory, "Button_Palette" )				-- 팔레트

local isAlchemyStoneEnble = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 35 )		-- 35 =성장형 장비 컨텐츠(연금석 등) 
if isAlchemyStoneEnble then
	btn_AlchemyStone:SetShow( true )
else
	btn_AlchemyStone:SetShow( false )
end

local isAlchemyFigureHeadEnble = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 37 )-- 37 = 토템
if isAlchemyFigureHeadEnble then
	btn_AlchemyFigureHead:SetShow( true )
else
	btn_AlchemyFigureHead:SetShow( false )
end

local 	burnItemTime		= -1;

local effectScene = {
	newItem = {}
}

local inven = {
	slotConfig =
	{
		-- 일단 아이콘, 테두리, 카운트(숫자) 만 적용한다!
		createIcon			= true,
		createBorder		= true,
		createCount			= true,
		createEnchant		= true,
		createCooltime		= true,
		createExpiration	= true,
		createExpirationBG	= true,		-- 기간만료시, 슬롯에 붉은색배경 처리
		createExpiration2h	= true,		-- 쿨타임 2시간 이내 시 붉은색배경 점멸 처리
		createClassEquipBG	= true,		-- 다른 클래스 장비 붉은색배경	
		createEnduranceIcon	= true,		-- 내구도 0인 장비 아이콘 표시
		createCooltimeText	= true,
		createCash			= true,
	},
	config =
	{
		-- 이 값들은 추후에 메시지로 빼어내어 세팅해야 한다!
		slotCount	= 64,	-- 현제 창 크기에 맞췄다.
		slotCols	= 8,
		slotRows	= 0,		-- 계산되는 값
		slotStartX	= 19,
		slotStartY	= 93,
		slotGapX	= 48,
		slotGapY	= 47,
		slotEnchantX= 13,
		slotEnchantY= 76,
	},

	startSlotIndex	= 0,

	-- 컨트롤들
	_slotsBackground= Array.new(),
	slots			= Array.new(),
	slotEtcData		= {},
	
	-- isFirstItem : 처음 생성된 아이템인지 확인용.
	staticTitle		= UI.getChildControl( Panel_Window_Inventory, "Static_Text_Title" ),
	staticCapacity	= UI.getChildControl( Panel_Window_Inventory, "Static_Text_Capacity" ),
	buttonClose		= UI.getChildControl( Panel_Window_Inventory, "Button_Win_Close" ),

	staticMoney		= UI.getChildControl( Panel_Window_Inventory, "Static_Text_Money" ),
	buttonMoney		= UI.getChildControl( Panel_Window_Inventory, "Button_Money" ),

	buttonPearl		= UI.getChildControl( Panel_Window_Inventory, "Static_PearlIcon" ),
	valuePearl		= UI.getChildControl( Panel_Window_Inventory, "StaticText_PearlValue" ),
	buttonMileage	= UI.getChildControl( Panel_Window_Inventory, "Static_MileageIcon" ),
	valueMileage	= UI.getChildControl( Panel_Window_Inventory, "StaticText_MileageValue" ),


	checkButton_Sort= UI.getChildControl( Panel_Window_Inventory, "CheckButton_ItemSort" ),				-- 보기에만 정렬
	--button_ItemSort	= UI.getChildControl( Panel_Window_Inventory, "Button_ItemSort" ),				-- 실제 정렬

	staticTxtWeight	= UI.getChildControl( Panel_Window_Inventory, "StaticText_Weight" ),
	staticWeight	= UI.getChildControl( Panel_Window_Inventory, "Static_Text_Weight" ),
	weightGaugeBG	= UI.getChildControl( Panel_Window_Inventory, "Static_Texture_Weight_Background" ),
	weightItem		= UI.getChildControl( Panel_Window_Inventory, "Progress2_Weight" ),
	weightEquipment	= UI.getChildControl( Panel_Window_Inventory, "Progress2_Equipment" ),
	weightMoney		= UI.getChildControl( Panel_Window_Inventory, "Progress2_Money" ),
	weightIcon		= UI.getChildControl( Panel_Window_Inventory, "Static_WeightIcon" ),
	enchantNumber	= UI.getChildControl( Panel_Window_Inventory, "Static_Text_Slot_Enchant_value" ),
	
	slotBackground	= UI.getChildControl( Panel_Window_Inventory, "Static_Slot_BG" ),
	button_Puzzle	= UI.getChildControl( Panel_Window_Inventory, "Button_Puzzle" ),
	
	radioButtonNormaiInven	= UI.getChildControl( Panel_Window_Inventory, "RadioButton_NormalInventory"	),
	radioButtonCashInven	= UI.getChildControl( Panel_Window_Inventory, "RadioButton_CashInventory"	),

	radioButtonStd		= UI.getChildControl( Panel_Window_Inventory, "RadioButton_Std"			),
	radioButtonTransport= UI.getChildControl( Panel_Window_Inventory, "RadioButton_Transport"	),
	radioButtonHousing	= UI.getChildControl( Panel_Window_Inventory, "RadioButton_Housing"		),
	
	_baseSlot			= UI.getChildControl( Panel_Window_Inventory, "Static_Slot"				),		-- 사용할 수 있는 슬롯
	_baseLockSlot		= UI.getChildControl( Panel_Window_Inventory, "Static_LockedSlot"		),		-- 확장 할 수 있는 슬롯
	_expire2h			= UI.getChildControl( Panel_Window_Inventory, "Static_Expire_2h"		),

	_scroll				= UI.getChildControl( Panel_Window_Inventory, "Scroll_CashInven"		),
	cashScrollArea		= UI.getChildControl( Panel_Window_Inventory, "Scroll_Area"				),
	trashArea			= UI.getChildControl( Panel_Window_Inventory, "Button_Trash"			),
	
	filterFunc			= nil,
	rClickFunc			= nil,
	otherWindowOpenFunc	= nil,
	isHiding			= false,
	effect				= nil,
	
	_tooltipWhereType	= nil,
	_tooltipSlotNo		= nil,
	
	orgPosX 			= Panel_Window_Inventory:GetPosX(),
	orgPosY 			= Panel_Window_Inventory:GetPosY(),
}

local whereUseItemSlotNo	= nil
local whereUseItemSSW		= nil

local	btn_Manufacture		= UI.getChildControl( Panel_Window_Inventory, "Button_Manufacture"		)		-- 인벤토리 창에서 기본으로 보여주는 가공하기 버튼.

local 	_buttonQuestion = UI.getChildControl( Panel_Window_Inventory, "Button_Question" )								-- 물음표 버튼
	_buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelWindowInventory\" )" )				-- 물음표 좌클릭
	_buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"PanelWindowInventory\", \"true\")" )		-- 물음표 마우스오버
	_buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"PanelWindowInventory\", \"false\")" )		-- 물음표 마우스아웃

local helpWidgetBase 	= UI.getChildControl ( Panel_CheckedQuest, "StaticText_Notice_1")
local FilterRadioTooltip= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_Inventory, "HelpWindow_For_InvenFilterRadio" )
CopyBaseProperty( helpWidgetBase, FilterRadioTooltip )
FilterRadioTooltip:SetColor( ffffffff )
FilterRadioTooltip:SetAlpha( 1.0 )
FilterRadioTooltip:SetFontColor( UI_color.C_FFC4BEBE )
FilterRadioTooltip:SetAutoResize( true )
FilterRadioTooltip:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
FilterRadioTooltip:SetShow( false )


-----------------------------------------------------------------
--					무게 도움말 처리 함수들
-----------------------------------------------------------------
inven.staticTxtWeight	:addInputEvent( "Mouse_On", "Panel_Inventory_WeightHelpFunc( true )" )
inven.staticTxtWeight	:addInputEvent( "Mouse_Out", "Panel_Inventory_WeightHelpFunc( false )" )
inven.staticWeight		:addInputEvent( "Mouse_On", "Panel_Inventory_WeightHelpFunc( true )" )
inven.staticWeight		:addInputEvent( "Mouse_Out", "Panel_Inventory_WeightHelpFunc( false )" )
inven.weightGaugeBG		:addInputEvent( "Mouse_On", "Panel_Inventory_WeightHelpFunc( true )" )
inven.weightGaugeBG		:addInputEvent( "Mouse_Out", "Panel_Inventory_WeightHelpFunc( false )" )
inven.weightIcon		:addInputEvent( "Mouse_On", "Panel_Inventory_WeightHelp( true )")
inven.weightIcon		:addInputEvent( "Mouse_Out", "Panel_Inventory_WeightHelp( false )")

local weightHelp = 
{
	_weightHelp_BG	= UI.getChildControl( Panel_Window_Inventory, "Static_WeightHelp_BG" ),
	_weightHelp		= UI.getChildControl( Panel_Window_Inventory, "StaticText_Weight_Help" ),
	_equipHelp		= UI.getChildControl( Panel_Window_Inventory, "StaticText_Equip_Help" ),
	_moneyHelp		= UI.getChildControl( Panel_Window_Inventory, "StaticText_MoneyHelp" ),
}

function Panel_Inventory_WeightHelpFunc( isOn )
	local selfPlayerWrapper		= getSelfPlayer()
	local selfPlayer			= selfPlayerWrapper:get()

	local s64_moneyWeight		= selfPlayer:getInventory():getMoneyWeight_s64()
	local s64_equipmentWeight	= selfPlayer:getEquipment():getWeight_s64()
	local s64_allWeight			= selfPlayer:getCurrentWeight_s64()
	local s64_maxWeight			= selfPlayer:getPossessableWeight_s64()

	local moneyWeight			= Int64toInt32( s64_moneyWeight ) / 10000
	local equipmentWeight		= Int64toInt32( s64_equipmentWeight ) / 10000
	local allWeight				= Int64toInt32( s64_allWeight ) / 10000
	local maxWeight				= Int64toInt32( s64_maxWeight ) / 10000

	local invenWeight			= allWeight - equipmentWeight - moneyWeight
	-- Int64toInt32
	-- string.format( "%.1f", Int64toInt32(s64_equipmentWeight) )
	-- 

	if ( isOn == true ) then
		weightHelp._weightHelp:SetText(	PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_WEIGHTHELP_1") .. string.format( "%.1f", invenWeight ) .. "LT(" .. 	string.format( "%.1f", (invenWeight/maxWeight)*100) .. "%)" )
		weightHelp._equipHelp:SetText(	PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_EQUIPHELP_1") .. string.format( "%.1f", equipmentWeight) .. "LT(".. 	string.format( "%.1f", (equipmentWeight/maxWeight)*100) .. "%)" )
		weightHelp._moneyHelp:SetText(	PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_MONEYHELP_1") .. string.format( "%.1f", moneyWeight) .. "LT(".. 		string.format( "%.1f", (moneyWeight/maxWeight)*100) .. "%)" )
		Panel_Window_Inventory:SetChildIndex( weightHelp._weightHelp_BG, 9000 )
		Panel_Window_Inventory:SetChildIndex( weightHelp._weightHelp, 9999 )
		Panel_Window_Inventory:SetChildIndex( weightHelp._equipHelp, 9999 )
		Panel_Window_Inventory:SetChildIndex( weightHelp._moneyHelp, 9999 )
		for _, value in pairs ( weightHelp ) do 
			value:SetShow( true )
		end
	else
		for _, value in pairs ( weightHelp ) do
			value:SetShow( false )
		end
	end
end

function Panel_Inventory_WeightHelp( bool )
	local _const				= Defines.s64_const
	local selfPlayer			= getSelfPlayer():get()
	local s64_allWeight			= selfPlayer:getCurrentWeight_s64()
	local s64_maxWeight			= selfPlayer:getPossessableWeight_s64()
	local s64_maxWeight_div		= s64_maxWeight / _const.s64_100
	local weightPercent			= Int64toInt32( s64_allWeight / s64_maxWeight_div )
	
	--weightHelp._weightHelp:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_WEIGHTHELP_2", "weightPercent", weightPercent))
	weightHelp._weightHelp:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_WEIGHTHELP", "weightPercent", weightPercent ) ) -- 현재 무게 : " .. weightPercent .. " % | 무게는 최대 170%까지 소지할 수 있습니다.
	weightHelp._equipHelp:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_WEIGHTHELP_3"))
	weightHelp._moneyHelp:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_WEIGHTHELP_4"))
	if ( true == bool ) then
		for _, value in pairs ( weightHelp ) do 
			value:SetShow( true )
		end
	else
		for _, value in pairs ( weightHelp ) do
			value:SetShow( false )
		end
	end
end

local _puzzleMessage
local _puzzleNotice 		= UI.getChildControl ( Panel_Window_Inventory, "Static_Notice")
local _puzzleNoticeStyle 	= UI.getChildControl ( Panel_Window_Inventory, "StaticText_Notice")
local _puzzleNoticeText		= UI.createControl( UCT_STATICTEXT, _puzzleNotice, "puzzleNoticeText")
CopyBaseProperty( _puzzleNoticeStyle, _puzzleNoticeText )
UI.deleteControl(_puzzleNoticeStyle)
_puzzleNoticeStyle = nil
_puzzleNoticeText:SetSpanSize(20,0)


function InventoryShowAni()
	local self = inven
	UIAni.fadeInSCR_Left(Panel_Window_Inventory)
	
	isFirstTab = false
	
	local aniInfo1 = Panel_Window_Inventory:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.05)
	aniInfo1.AxisX = Panel_Window_Inventory:GetSizeX() / 2
	aniInfo1.AxisY = Panel_Window_Inventory:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_Window_Inventory:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.05)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_Window_Inventory:GetSizeX() / 2
	aniInfo2.AxisY = Panel_Window_Inventory:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function InventoryHideAni()
	Panel_Window_Inventory:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo1 = Panel_Window_Inventory:addColorAnimation( 0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)

	-- local scaleAni2 = Panel_Window_Inventory:addScaleAnimation( 0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	-- scaleAni2:SetStartScale(1.0)
	-- scaleAni2:SetEndScale(0.8)
	-- scaleAni2.AxisX = Panel_Window_Inventory:GetPosX()
	-- scaleAni2.AxisY = Panel_Window_Inventory:GetPosY()
	-- scaleAni2.IsChangeChild = true
	
	_puzzleNotice:SetShow(false)
end

function Inventory_ItemCoolTimeEffect_ShowAni()
	local coolTime_Hide = UIAni.AlphaAnimation( 0, Panel_Inventory_CoolTime_Effect_Item_Slot, 0.0, 0.7 )
	coolTime_Hide:SetHideAtEnd(true)
	-- UIAni.AlphaAnimation( 1, Panel_Inventory_CoolTime_Effect_Item_Slot, 0.0, 0.5 )
end


-- 초기화 함수
function inven:init()
	self.config.slotRows = self.config.slotCount / self.config.slotCols
	self.enchantNumber:SetShow(false)

	self.radioButtonNormaiInven	:addInputEvent( "Mouse_LUp", 'Inventory_Tab()' )
	self.radioButtonCashInven	:addInputEvent( "Mouse_LUp", 'Inventory_Tab()' )

	self.radioButtonStd			:addInputEvent( "Mouse_LUp", 'Inventory_TabSound()' )
	self.radioButtonTransport	:addInputEvent( "Mouse_LUp", 'Inventory_TabSound()' )
	self.radioButtonHousing		:addInputEvent( "Mouse_LUp", 'Inventory_TabSound()' )

	self.radioButtonStd			:addInputEvent( "Mouse_On", "Inventory_FilterRadioTooltip_Show( true, " .. 0 .. ")" )
	self.radioButtonTransport	:addInputEvent( "Mouse_On", "Inventory_FilterRadioTooltip_Show( true, " .. 1 .. ")" )
	self.radioButtonHousing		:addInputEvent( "Mouse_On", "Inventory_FilterRadioTooltip_Show( true, " .. 2 .. ")" )

	self.radioButtonStd			:addInputEvent( "Mouse_Out", "Inventory_FilterRadioTooltip_Show( false )" )
	self.radioButtonTransport	:addInputEvent( "Mouse_Out", "Inventory_FilterRadioTooltip_Show( false )" )
	self.radioButtonHousing		:addInputEvent( "Mouse_Out", "Inventory_FilterRadioTooltip_Show( false )" )

	btn_AlchemyStone			:addInputEvent( "Mouse_LUp", "HandleClicked_Inventory_Function( " .. 0 .. " )" )
	btn_AlchemyFigureHead		:addInputEvent( "Mouse_LUp", "HandleClicked_Inventory_Function( " .. 1 .. " )" )
	btn_DyePalette				:addInputEvent( "Mouse_LUp", "HandleClicked_Inventory_Function( " .. 2 .. " )" )
	btn_Manufacture				:addInputEvent( "Mouse_LUp", "HandleClicked_Inventory_Function( " .. 3 .. " )")

	self.trashArea				:addInputEvent( "Mouse_LUp", "HandleClicked_Inventory_ItemDelete()")
	
	UIScroll.InputEvent(			self._scroll,			"Inventory_CashTabScroll"	)
	UIScroll.InputEventByControl(	self.cashScrollArea,	"Inventory_CashTabScroll"	)

	-- if getContentsServiceType() ~= CppEnums.ContentsServiceType.eContentsServiceType_Commercial then
	-- 	self.radioButtonCashInven:SetShow( false )
	-- end
	if isGameTypeJapan() or isGameTypeRussia() then
		self.radioButtonCashInven:SetTextSpan( 40, 7 )
		self.radioButtonNormaiInven:SetTextSpan( 50, 7 )
	elseif 0 == getGameServiceType() or 1 == getGameServiceType() or 2 == getGameServiceType() or 3 == getGameServiceType() or 4 == getGameServiceType() then
		self.radioButtonCashInven:SetTextSpan( 50, 7 )
		self.radioButtonNormaiInven:SetTextSpan( 60, 7 )
	end
	
	local sortBtn_sizeX = self.checkButton_Sort:GetSizeX()
	local sortBtn_TextSizeX = self.checkButton_Sort:GetTextSizeX()
	self.checkButton_Sort:SetEnableArea( 0, 0, 100, self.checkButton_Sort:GetSizeY() )

--{ 인벤토리 버튼 텍스트의 위치를 중앙정렬한다.
	local btnNormalSizeX				= self.radioButtonNormaiInven:GetSizeX()+23
	local btnNormalTextPosX				= (btnNormalSizeX - (btnNormalSizeX/2) - ( self.radioButtonNormaiInven:GetTextSizeX() / 2 ))
	local btnCashSizeX					= self.radioButtonCashInven:GetSizeX()+23
	local btnCashTextPosX				= (btnCashSizeX - (btnCashSizeX/2) - ( self.radioButtonCashInven:GetTextSizeX() / 2 ))
	local btnManufactureSizeX			= btn_Manufacture:GetSizeX()+23
	local btnManufactureTextPosX		= (btnManufactureSizeX - (btnManufactureSizeX/2) - ( btn_Manufacture:GetTextSizeX() / 2 ))
	local btnAlchemyStoneSizeX			= btn_AlchemyStone:GetSizeX()+23
	local btnAlchemyStoneTextPosX		= (btnAlchemyStoneSizeX - (btnAlchemyStoneSizeX/2) - ( btn_AlchemyStone:GetTextSizeX() / 2 ))
	local btnAlchemyFigureSizeX			= btn_AlchemyFigureHead:GetSizeX()+23
	local btnAlchemyFigureTextPosX		= (btnAlchemyFigureSizeX - (btnAlchemyFigureSizeX/2) - ( btn_AlchemyFigureHead:GetTextSizeX() / 2 ))
	local btnDyePaletteSizeX			= btn_DyePalette:GetSizeX()+23
	local btnDyePaletteTextPosX			= (btnDyePaletteSizeX - (btnDyePaletteSizeX/2) - ( btn_DyePalette:GetTextSizeX() / 2 ))

	self.radioButtonNormaiInven			:SetTextSpan( btnNormalTextPosX, 5 )
	self.radioButtonCashInven			:SetTextSpan( btnCashTextPosX, 5 )
	btn_Manufacture						:SetTextSpan( btnManufactureTextPosX, 5 )
	btn_AlchemyStone					:SetTextSpan( btnAlchemyStoneTextPosX, 5 )
	btn_AlchemyFigureHead				:SetTextSpan( btnAlchemyFigureTextPosX, 5 )
	btn_DyePalette						:SetTextSpan( btnDyePaletteTextPosX, 5 )
--}
end

function	Inventory_Tab()
	local self = inven
	self.startSlotIndex	= 0
	if DragManager:isDragging() then
		DragManager:clearInfo()
	end
	Inventory_TabSound()
end

function HandleClicked_Inventory_Function( functionType )
	if DragManager:isDragging() then
		DragManager:clearInfo()
	end

	if 0 == functionType then
		FGlobal_AlchemyStone_Open()
	elseif 1 == functionType then
		FGlobal_AlchemyFigureHead_Open()
	elseif 2 == functionType then
		HandleClicked_Inventory_Palette_Open()
	elseif 3 == functionType then
		Inventory_ManufactureBTN()
	end
end
function Inventory_TabSound()
	if DragManager:isDragging() then
		DragManager:clearInfo()
	end
	
	if isFirstTab == true then
		isFirstTab = false
	else
		-- 탭 버튼 눌렀을 때 소리 들어감!!
		audioPostEvent_SystemUi(00,00)
	end
	
	Inventory_updateSlotData()
	Inventory_CashTabScroll( true )
end

function inven:createSlot()
	-- Slot Background
	for ii = 0, self.config.slotCount -1 do
		local slot = {}
		slot.empty	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC,	Panel_Window_Inventory,	"Inventory_Slot_Base_"	.. ii )
		slot.lock	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, 	Panel_Window_Inventory,	"Inventory_Slot_Lock_"	.. ii )
		
		CopyBaseProperty( self._baseSlot,		slot.empty	)
		CopyBaseProperty( self._baseLockSlot,	slot.lock	)
		UIScroll.InputEventByControl( slot.empty,	"Inventory_CashTabScroll"	)
		
		-- position Set
		local row = math.floor( (ii) / self.config.slotCols )
		local col = (ii) % self.config.slotCols
		slot.empty:SetPosX( self.config.slotStartX + self.config.slotGapX * col )
		slot.empty:SetPosY( self.config.slotStartY + self.config.slotGapY * row )
		slot.lock:SetPosX( self.config.slotStartX + self.config.slotGapX * col )
		slot.lock:SetPosY( self.config.slotStartY + self.config.slotGapY * row )
		
		slot.empty:SetShow( false )
		slot.lock:SetShow( false )
		
		self._slotsBackground[ii]	= slot
	end
	
	local	useStartSlot	= inventorySlotNoUserStart()
	for ii = 0, self.config.slotCount -1 do
		local	slotNo	= ii + useStartSlot
	
		-- create Slot
		-- {
			local	slot	= {}
			SlotItem.new( slot, 'ItemIcon_' .. ii, ii, Panel_Window_Inventory, self.slotConfig )
			slot:createChild()
	
			CopyBaseProperty( self.enchantNumber, slot.enchantText )
			slot.enchantText:SetSize( slot.icon:GetSizeX(), slot.icon:GetSizeY() )
			slot.enchantText:SetPosX( 0 )
			slot.enchantText:SetPosY( 0 )
			slot.enchantText:SetTextHorizonCenter()
			slot.enchantText:SetTextVerticalCenter()
	
			-- set Event Handler
			slot.icon:addInputEvent( "Mouse_RUp",			"Inventory_SlotRClick("		.. ii .. ")" )
			slot.icon:addInputEvent( "Mouse_LDown",			"Inventory_SlotLClick("		.. ii .. ")" )
			slot.icon:addInputEvent( "Mouse_LUp",			"Inventory_DropHandler("	.. ii .. ")" )
			slot.icon:addInputEvent( "Mouse_PressMove",		"Inventory_SlotDrag("		.. ii .. ")" )
			slot.icon:addInputEvent( "Mouse_On",			"Inventory_IconOver("		.. ii .. ")" )
			slot.icon:addInputEvent( "Mouse_Out",			"Inventory_IconOut("		.. ii .. ")" )
			
			-- cashTab Scroll
			UIScroll.InputEventByControl( slot.icon,	"Inventory_CashTabScroll"	)
			
			slot.icon:SetAutoDisableTime( 0.5 )
	
			-- position Set
			local row = math.floor( ii / self.config.slotCols )
			local col = ii % self.config.slotCols
			slot.icon:SetPosX( self.config.slotStartX + self.config.slotGapX * col )
			slot.icon:SetPosY( self.config.slotStartY + self.config.slotGapY * row )
			slot.icon:SetEnableDragAndDrop(true)
--			slot.icon:SetOriginValue()
			slot.isEmpty = true
			
			Panel_Tooltip_Item_SetPosition(ii, slot, "inventory")
			
			slot.background = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Window_Inventory, 'Inventory_Slot_BG_' .. ii )
			CopyBaseProperty( self.slotBackground, slot.background )
			slot.background:SetSize( slot.icon:GetSizeX(), slot.icon:GetSizeY() )
			slot.background:SetPosX( slot.icon:GetPosX() )
			slot.background:SetPosY( slot.icon:GetPosY() )
			slot.background:SetShow( false )
			
			self.slots[ii] = slot
		--}
		
		--{
			local	effectSlot	= {}
			local	puzzle		= UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, slot.icon, 'Puzzle_Control_' .. ii)
			
			CopyBaseProperty(inven.button_Puzzle, puzzle)
			puzzle:SetShow(false)
			puzzle:addInputEvent( "Mouse_LUp",	"MakePuzzle("			.. ii ..	")"	)
			puzzle:addInputEvent( "Mouse_On",	"PuzzleButton_Over("	.. ii ..	")"	)
			puzzle:addInputEvent( "Mouse_Out",	"PuzzleButton_Out("		.. ii ..	")"	)
			Panel_Window_Inventory:SetChildIndex( _puzzleNotice, 9999 )
			Panel_Window_Inventory:SetChildIndex( self.slots[ii].icon, 9998 )
			
			effectSlot.isFirstItem	= false
			effectSlot.puzzleControl= puzzle
			
			self.slotEtcData[ii]	= effectSlot
		--}
	end

	if FGlobal_IsCommercialService() then				-- 상용화가 아닐 경우 펄, 마일리지 관련 텍스쳐를 숨긴다.
		inven.buttonPearl	:SetShow( true )
		inven.valuePearl	:SetShow( true )
		inven.buttonMileage	:SetShow( true )
		inven.valueMileage	:SetShow( true )
	else
		if isGameTypeEnglish() then
			inven.buttonMileage	:SetShow( true )
			inven.valueMileage	:SetShow( true )
			inven.buttonPearl	:SetShow( true )
			inven.valuePearl	:SetShow( true )
		else
			inven.buttonMileage	:SetShow( false )
			inven.valueMileage	:SetShow( false )
			inven.buttonPearl	:SetShow( false )
			inven.valuePearl	:SetShow( false )
		end
		
	end

	--[[
	-- 잠긴 슬롯들은 일단 이그노어
	for iii = 41, 80, 1 do
		self.slots[iii].icon:SetIgnore(true)
		self.slots[iii].icon:SetShow(false)
		self.slots[iii].background:SetShow(false)
	end
	]]
	
	
end

-- 이벤트 핸들러들
function InventoryWindow_Close()
	-- if Panel_Window_Inventory:IsShow() then
		local self = inven

		-- 순서 바꾸면 안됩니다.(20140703:홍민우)
		if	( nil ~= self.otherWindowOpenFunc )	then	
			local callFunc = self.otherWindowOpenFunc
			self.otherWindowOpenFunc = nil
			callFunc()
		end
		
		self.filterFunc	= nil
		self.rClickFunc	= nil
		self.effect		= nil
		
		if ToClient_IsSavedUi() then
			ToClient_SaveUiInfo( true )
			ToClient_SetSavedUi( false )
		end
		
		if Panel_Window_Exchange_Number:IsShow() then
			Panel_NumberPad_Show( false, Defines.s64_const.s64_0, 0, nil)
		end

		-- 꺼준다
		-- ♬ 창 끌 때 소리난다요
		-- audioPostEvent_SystemUi(01,01)
		Panel_Window_Inventory:SetShow( false, false )
		-- UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
		Panel_Tooltip_Item_hideTooltip()
		UIMain_ItemUpdateRemove()

		if Panel_AlchemyStone:GetShow() then
			FGlobal_AlchemyStone_Close()
		end
		
		if Panel_AlchemyFigureHead:GetShow() then
			FGlobal_AlchemyFigureHead_Close()
		end

		if Panel_DyePalette:GetShow() then
			FGlobal_DyePalette_Close()
		end

		for _, value in pairs( self.slotEtcData ) do
			value.isFirstItem = false
		end
		for _, slot in pairs( self.slots ) do
			slot.icon:EraseAllEffect()
			slot.icon:SetEnable( true )
			slot.icon:SetMonoTone( false )
			slot.icon:SetIgnore( false )
		end
	-- end

	if true == openUiType then
		FGlobal_Equipment_SetHide( false )
	elseif false == openUiType then
		FGlobal_Equipment_SetHide( true )
	end
	
	HelpMessageQuestion_Out()		-- 물음표 버튼 툴팁 끄기
	Panel_Invertory_Manufacture_BG:SetShow( false )
	Panel_Invertory_ExchangeButton:SetShow( false )
	
	Panel_Window_Inventory:SetPosX(inven.orgPosX)
	Panel_Window_Inventory:SetPosY(inven.orgPosY)
end


function InventoryWindow_Show( uiType, isCashInven )
	local self = inven
	self.effect = nil
	self.startSlotIndex = 0
	
	openUiType = uiType

	local isSorted = ToClient_IsSortedInventory()
	self.checkButton_Sort:SetCheck( isSorted )

	if nil == isCashInven then
		if Panel_ColorBalance:GetShow() then
			self.radioButtonNormaiInven	:SetCheck(false)
			self.radioButtonCashInven	:SetCheck(true)
		else
			self.radioButtonNormaiInven	:SetCheck(true)
			self.radioButtonCashInven	:SetCheck(false)
		end
		if Panel_Manufacture:GetShow() then
			self.radioButtonCashInven:SetEnable( false )
			self.radioButtonCashInven:SetIgnore( true )
			self.radioButtonCashInven:SetMonoTone( true )
		else
			self.radioButtonCashInven:SetEnable( true )
			self.radioButtonCashInven:SetIgnore( false )
			self.radioButtonCashInven:SetMonoTone( false )
		end
	else
		if isCashInven then
			self.radioButtonNormaiInven	:SetCheck(false)
			self.radioButtonCashInven	:SetCheck(true)
		else
			self.radioButtonNormaiInven	:SetCheck(true)
			self.radioButtonCashInven	:SetCheck(false)
		end
	end
	self.radioButtonStd			:SetCheck(true)
	self.radioButtonTransport	:SetCheck(false)
	self.radioButtonHousing		:SetCheck(false)
	Inventory_updateSlotData()
	
	self._scroll:SetControlTop()

	Panel_Window_Inventory:SetShow( true, true )
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
	-- 창고가 열려 있지 않거나, 서번트 인벤토리가 없다면 버튼을 비활성화 한다.
	if	( (not Panel_Window_Warehouse:GetShow()) and (not Panel_Window_ServantInventory:GetShow()) )	then
		inven.buttonMoney:SetEnable(false)
	else
		inven.buttonMoney:SetEnable(true)
	end

	if isGameTypeRussia() and ((getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_CBT) or (getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_OBT)) then
		btn_DyePalette:SetMonoTone( true )
		btn_DyePalette:SetIgnore( true )
		btn_DyePalette:SetEnable( false )
	else
		btn_DyePalette:SetMonoTone( false )
		btn_DyePalette:SetIgnore( false )
		btn_DyePalette:SetEnable( true )
	end

	if isFlushedUI() then
		btn_Manufacture:SetEnable( false )
		btn_Manufacture:SetMonoTone( true )
		btn_AlchemyStone:SetEnable( false )
		btn_AlchemyStone:SetMonoTone( true )
		btn_AlchemyFigureHead:SetEnable( false )
		btn_AlchemyFigureHead:SetMonoTone( true )
		btn_DyePalette:SetEnable( false )
		btn_DyePalette:SetMonoTone( true )
		
	else
		btn_Manufacture:SetEnable( true )
		btn_Manufacture:SetMonoTone( false )
		btn_AlchemyStone:SetEnable( true )
		btn_AlchemyStone:SetMonoTone( false )
		btn_AlchemyFigureHead:SetEnable( true )
		btn_AlchemyFigureHead:SetMonoTone( false )
		if isGameTypeRussia() and ((getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_CBT) or (getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_OBT)) then
			btn_DyePalette:SetEnable( false )
			btn_DyePalette:SetMonoTone( true )			
		else
			btn_DyePalette:SetEnable( true )
			btn_DyePalette:SetMonoTone( false )
		end
	end
end

function	Inventory_SlotLClick( index )
	local	self			= inven
	local	slotNo			= self.slots[index]._slotNo
	local	inventoryType	= Inventory_GetCurrentInventoryType()
	
	if Panel_Chatting_Input:IsShow() and isKeyPressed(CppEnums.VirtualKeyCode.KeyCode_SHIFT) then
		local focusEdit = GetFocusEdit()
		if ChatInput_CheckCurrentUiEdit(focusEdit) then
			FGlobal_ChattingInput_LinkedItemByInventory( slotNo, inventoryType )
		--elseif ChatMacro_CheckCurrentUiEdit(focusEdit) then
		--	FGlobal_ChattingMacro_LinkedItemByInventory( slotNo )
		end
	elseif isKeyPressed(CppEnums.VirtualKeyCode.KeyCode_SHIFT) then
		-- 그냥 쉬프트 클릭이면 제작 노트를 띄운다. 일본 서비스이면서 CBT상태면 return시킨다.
		if ( ( isGameTypeJapan() or isGameTypeRussia() ) and ( getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_CBT ) )  then
			return
		end
		local	itemWrapper		= getInventoryItemByType( inventoryType, slotNo )
		Note_On( itemWrapper:get():getKey():getItemKey() )
	end
end

function	Inventory_SlotRClick( index, equipSlotNo )
	if FGlobal_Selloff_CondCheck() then
		return
	end
	if Panel_Win_System:GetShow() then
		return
	end
	local	self			= inven
	local	slotNo			= self.slots[index]._slotNo
	Inventory_SlotRClickXXX( slotNo, equipSlotNo, index )
end

function	Inventory_SlotRClickXXX( slotNo, equipSlotNo, index )
	local	self			= inven
	local	selfProxy		= getSelfPlayer():get()
	local	inventoryType	= Inventory_GetCurrentInventoryType()
	local	itemWrapper		= getInventoryItemByType( inventoryType, slotNo )

	-- 비어있지 않으면!
	if	(nil ~= itemWrapper)	then
		local itemEnchantWrapper 	= itemWrapper:getStaticStatus()
		local itemStatic			= itemWrapper:getStaticStatus():get()

		-- 말에 탑승 중이라면
		if	selfProxy:doRideMyVehicle()	then
			if	itemStatic:isUseToVehicle()	then
				inventoryUseItem( inventoryType, slotNo, equipSlotNo, false )
				return
			end
		end

		if nil ~= self.rClickFunc then
			--_PA_LOG("lua_debug", "Inventory_SlotRClick::rClickFunction" )
			self.rClickFunc(slotNo, itemWrapper, itemWrapper:get():getCount_s64(), inventoryType )
			return
		end

		-- 상호작용 할 대상을 선택!!!
		-- if ( nil ~= Panel_Window_Exchange ) and Panel_Window_Exchange:GetShow()	then						-- 개인 거래	-- exchangeWithPC.lua에서 처리.
		-- 	Panel_ExchangePC_InteractionFromInventory( slotNo, itemWrapper, itemWrapper:get():getCount_s64(), inventoryType )
		-- 	return
		-- else
		if ( nil ~= Panel_Auction_Regist_Popup) and Panel_Auction_Regist_Popup:GetShow() then				-- 경매장
			if(itemWrapper:getStaticStatus():isStackable()) then
				Panel_NumberPad_Show(true, itemWrapper:get():getCount_s64(), slotNo,  Auction_RegisterItemFromInventory )
			else
				Auction_RegisterItemFromInventory(1, slotNo)
			end 
			return
		elseif ( nil ~= Panel_Housing_SettingVendingMachine) and Panel_Housing_SettingVendingMachine:GetShow() then
			VendingMachine_RegisterItemFromInventory(slotNo, 1)
			return
		elseif ( nil ~= Panel_Housing_VendingMachineList) and Panel_Housing_VendingMachineList:GetShow() then
			FGlobal_VendingMachineRegisterItemFromInventory(slotNo)
		elseif ( nil ~= Panel_Housing_ConsignmentSale) and Panel_Housing_ConsignmentSale:GetShow() then
			FGlobal_ConsignmentRegisterItemFromInventory(itemWrapper:get():getCount_s64(), slotNo)
		elseif getAuctionState() then
			return
		elseif	(2 == itemEnchantWrapper:get()._vestedType:getItemKey()) and (false == itemWrapper:get():isVested())	then	-- 착용하지 않았던 장착 시 귀속 아이템이라면,
			local bindingItemUse = function()
				Inventory_UseItemTargetSelf( inventoryType, slotNo, equipSlotNo )
			end
			
			local	messageContent	= nil
			if	itemEnchantWrapper:isUserVested()	then
				messageContent	= PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_BINDING_ALERT_CONTENT_USERVESTED" )		-- "해당 아이템 장착 시 아이템 거래소 이용이 불가능해집니다. 장착하시겠습니까?"
			else
				messageContent	= PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_BINDING_ALERT_CONTENT" )				-- "해당 아이템 장착 시 아이템 거래소 및 창고 이용이 불가능해집니다. 장착하시겠습니까?"
			end

			local messageboxData = { title = PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_BINDING_ALERT_TITLE" ), content = messageContent, functionYes = bindingItemUse, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
			MessageBox.showMessageBox(messageboxData)	
		elseif ( itemWrapper:getStaticStatus():getItemType() == 8 ) then				-- 아이템이 제작재료면
			local itemKey = itemWrapper:get():getKey():getItemKey()
			--if 17101 <= itemKey and itemKey <= 17317 then
				-- 염색약이면!
				--Panel_Dye_ShowToggle()
			--else
				-- 그 밖에 재료들이면!
				audioPostEvent_SystemUi(00,14)

				-- Panel_Invertory_Manufacture_BG:SetShow( true )
				Panel_Invertory_Manufacture_BG:SetShow( true )
				Panel_Tooltip_Item_Show_GeneralNormal(slotNo, "inventory", false)			-- 툴팁 꺼줌
				local row = math.floor( (slotNo - 1) / inven.config.slotCols )
				local col = (slotNo - 1) % inven.config.slotCols
				-- Panel_Invertory_Manufacture_BG:SetPosX( getMousePosX() - 120)
				-- Panel_Invertory_Manufacture_BG:SetPosY( getMousePosY() )
				Panel_Invertory_Manufacture_BG:SetPosX( self.slots[index].icon:GetParentPosX()-42 )
				Panel_Invertory_Manufacture_BG:SetPosY( self.slots[index].icon:GetParentPosY()+42 )
				radioButtonManu:SetPosX( 4 )
				radioButtonManu:SetPosY( 4 )
				radioButtonNote:SetPosX( 4 )
				radioButtonNote:SetPosY( 38 )
				
				if ( MiniGame_Manual_Value_FishingStart == true ) then
					radioButtonManu:SetEnable( false )
					radioButtonManu:SetMonoTone( true )
					radioButtonManu:SetAlpha( 0.8 )
				else
					radioButtonManu:SetEnable( true )
					radioButtonManu:SetMonoTone( false )
					radioButtonManu:SetAlpha( 1 )
				end
				
				radioButtonManu:addInputEvent( "Mouse_LUp", "Manufacture_On(".. slotNo ..")" )
				radioButtonNote:addInputEvent( "Mouse_LUp", "Note_On("..itemWrapper:get():getKey():getItemKey()..")" )
				radioButtonManu:addInputEvent( "Mouse_RUp", "Manufacture_Off()" )
				radioButtonNote:addInputEvent( "Mouse_RUp", "Manufacture_Off()" )
				radioButtonNote:addInputEvent( "Mouse_Out", "Manufacture_Off()" )
				radioButtonManu:addInputEvent( "Mouse_Out", "Manufacture_Off()" )
				Panel_Invertory_Manufacture_BG:addInputEvent("Mouse_Out", "Manufacture_Off()")
				--Panel_Manufacture:SetShow(true, true)
			--end
			return
		else--if	not itemWrapper:get():isUseToVehicle()	then
			if itemEnchantWrapper:isPopupItem() then
				Panel_UserItem_PopupItem( itemEnchantWrapper, inventoryType, slotNo, equipSlotNo )
			elseif itemEnchantWrapper:isExchangeItemNPC() then

				-- local wayPointExecute = function( slotNo )
				-- 	Inventory_FindExchangeItemNPC( slotNo )
				-- end

				-- local widgetExecute = function( slotNo )
				-- 	local inventoryType		= Inventory_GetCurrentInventoryType()
				-- 	local itemWrapper		= getInventoryItemByType( inventoryType, slotNo )
				-- 	local itemSSW			= itemWrapper:getStaticStatus()
				-- 	FGlobal_WhereUseITemDirectionOpen( itemSSW, slotNo )
				-- end

				Panel_Invertory_ExchangeButton:SetShow( true )
				Panel_Tooltip_Item_Show_GeneralNormal(slotNo, "inventory", false)			-- 툴팁 꺼줌
								
				local row = math.floor( (slotNo - 1) / inven.config.slotCols )
				local col = (slotNo - 1) % inven.config.slotCols
				-- Panel_Invertory_ExchangeButton:SetPosX( getMousePosX() - 120)
				-- Panel_Invertory_ExchangeButton:SetPosY( getMousePosY() )
				Panel_Invertory_ExchangeButton:SetPosX( self.slots[index].icon:GetParentPosX()-42 )
				Panel_Invertory_ExchangeButton:SetPosY( self.slots[index].icon:GetParentPosY()+42 )
				
				local _btn_WayPoint			= UI.getChildControl( Panel_Invertory_ExchangeButton, "Button_WayPoint")
				local _btn_Widget			= UI.getChildControl( Panel_Invertory_ExchangeButton, "Button_Widget")				

				_btn_WayPoint	:SetPosX( 4 )
				_btn_WayPoint	:SetPosY( 4 )
				_btn_Widget		:SetPosX( 4 )
				_btn_Widget		:SetPosY( 38 )

				_btn_WayPoint					:addInputEvent("Mouse_LUp", "HandleClickedWayPoint( " .. slotNo .. " )" )
				_btn_WayPoint					:addInputEvent("Mouse_Out", "ExchangeButton_Off()" )
				_btn_Widget						:addInputEvent("Mouse_Out", "ExchangeButton_Off()" )
				_btn_Widget						:addInputEvent("Mouse_LUp", "HandleClickedWidget( " .. slotNo .. " )" )
				Panel_Invertory_ExchangeButton	:addInputEvent("Mouse_Out", "ExchangeButton_Off()")
			elseif 	not itemStatic:isUseToVehicle()	then						-- 먹이는 Interaction을 통한 아이템 인벤토리창에서만 사용 할 수 있다.
				local useTradeItem = function()
					Inventory_UseItemTargetSelf( inventoryType, slotNo, equipSlotNo )
				end
				local itemSSW = itemWrapper:getStaticStatus()
				local item_type = itemSSW:getItemType()
				if ( 2 == item_type ) and ( true == itemSSW:get():isForJustTrade() ) then		-- 무역 아이템이면
					local messageContent = PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_TRADEITEMUSE_CONTENT" )
					local messageboxData = { title = PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_TRADEITEMUSE_TITLE" ), content = messageContent, functionYes = useTradeItem, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
					MessageBox.showMessageBox(messageboxData)	

				else
					Inventory_UseItemTargetSelf( inventoryType, slotNo, equipSlotNo )
				end
			else
				Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_CANT_USEITEM" ) )
			end
		end
	end
end

function FGlobal_WhereUseItemExecute()-- itemSSW, slotNo)
	-- whereUseItemSlotNo
	-- whereUseItemSSW
	WhereUseItemDirectionUpdate( whereUseItemSSW, whereUseItemSlotNo )
end

local currentNaviItemKey = nil
function FindExchangeItemNPC( itemSSW )
	local selfProxy = getSelfPlayer():get()
	if nil == selfProxy then
		return
	end
	
	local selfPosition	= float3(selfProxy:getPositionX(), selfProxy:getPositionY(), selfProxy:getPositionZ())
	local itemKey 		= itemSSW:get()._key:get()
	
	local npcPosition	= {}
	local minIndex		= 0
	local minDistance	= 0
	
	ToClient_DeleteNaviGuideByGroup(0)
	if itemKey == currentNaviItemKey then
		currentNaviItemKey = nil
		audioPostEvent_SystemUi(00,15)
	else
		local count = itemSSW:getExchangeItemNPCInfoListCount()
		for index = 0, count-1, 1 do
			local spawnData = npcByCharacterKey_getNpcInfo(itemSSW:getCharacterKeyByIdx(index), itemSSW:getDialogIndexByIdx(index))
			if nil~= spawnData then
				local npcPos 	= spawnData:getPosition()
				npcPosition[index] = npcPos
					
				local distance	= Util.Math.calculateDistance( selfPosition, npcPos )
				if 0 == index then
					minDistance = distance
				else
					if distance < minDistance then
						minIndex 	= index
						minDistance	= distance
					end
				end
			end
		end
			
		for ii = 0, count-1, 1 do
			if ii ~= minIndex and nil ~= npcPosition[ii] then
				worldmapNavigatorStart( float3(npcPosition[ii].x, npcPosition[ii].y, npcPosition[ii].z), NavigationGuideParam(), false, false, true )
			end
		end
		worldmapNavigatorStart( float3(npcPosition[minIndex].x, npcPosition[minIndex].y, npcPosition[minIndex].z), NavigationGuideParam(), false, false, true )
		currentNaviItemKey = itemKey
		audioPostEvent_SystemUi(00,14)
		selfProxy:setCurrentFindExchangeItemEnchantKey(itemKey)
		
	end
end

function Inventory_FindExchangeItemNPC( slotNo )
	local selfProxy		= getSelfPlayer():get()
	if nil == selfProxy then
		return
	end
	
	local inventory		= selfProxy:getInventory()
	
	if not inventory:empty( slotNo ) then
		local itemWrapper = getInventoryItem( slotNo )
		if nil == itemWrapper then
			return
		end
		local itemSSW = itemWrapper:getStaticStatus()
		if nil == itemSSW then	
			return
		end
		FindExchangeItemNPC(itemSSW)
	end
end

function FromClient_FindExchangeItemNPC()
	local itemEnchantKey 	= getSelfPlayer():get():getCurrentFindExchangeItemEnchantKey()
	local itemSSW			= getItemEnchantStaticStatus( ItemEnchantKey(itemEnchantKey) )
	
	if nil == itemSSW then
		return
	end
	
	FindExchangeItemNPC(itemSSW)
end


function Manufacture_On( slotNo )
	if Panel_Manufacture:GetShow() then
		return
	end
	if not IsSelfPlayerWaitAction() then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_MANUFACTURE") )
		return
	end

	Panel_Invertory_Manufacture_BG:SetShow( false )
	Manufacture_Show(nil, CppEnums.ItemWhereType.eInventory, true)
	Manufacture_Off()
end

function Note_On( itemKey )
	ProductNote_Item_ShowToggle(itemKey)
	Panel_Invertory_Manufacture_BG:SetShow( false )
	Manufacture_Off()
end

function Manufacture_Off()
	local panelPosX		= Panel_Invertory_Manufacture_BG:GetPosX()
	local panelPosY		= Panel_Invertory_Manufacture_BG:GetPosY()
	local panelSizeX	= Panel_Invertory_Manufacture_BG:GetSizeX()
	local panelSizeY	= Panel_Invertory_Manufacture_BG:GetSizeY()
	local mousePosX		= getMousePosX()
	local mousePosY		= getMousePosY()
	if( (panelPosX <= mousePosX) and (mousePosX <= (panelPosX + panelSizeX) )
		and (panelPosY <= mousePosY) and (mousePosY <= (panelPosY + panelSizeY)) ) then
		return
	end
	Panel_Invertory_Manufacture_BG:SetShow( false )
end

function HandleClickedWayPoint( slotNo )
	Inventory_FindExchangeItemNPC( slotNo )
	Panel_Invertory_ExchangeButton:SetShow( false )
end

function HandleClickedWidget( slotNo )
	local inventoryType		= Inventory_GetCurrentInventoryType()
	local itemWrapper		= getInventoryItemByType( inventoryType, slotNo )
	local itemSSW			= itemWrapper:getStaticStatus()
	whereUseItemSlotNo		= slotNo
	whereUseItemSSW			= itemSSW
	FGlobal_WhereUseITemDirectionOpen( itemSSW, slotNo )
	Panel_Invertory_ExchangeButton:SetShow( false )
end

function HandleClicked_Inventory_Palette_Open()
	if not inven.radioButtonCashInven:IsCheck() then
		inven.radioButtonNormaiInven	:SetCheck( false )
		inven.radioButtonCashInven		:SetCheck( true )
		Inventory_Tab()
	end

	FGlobal_DyePalette_Open()
end

function HandleClicked_Inventory_ItemDelete()
	if DragManager:isDragging() and Panel_Window_Inventory == DragManager.dragStartPanel then
		local slotNo		= DragManager.dragSlotInfo
		local whereType		= Inventory_GetCurrentInventoryType()
		local itemWrapper	= getInventoryItemByType( whereType, slotNo )
		if	nil == itemWrapper	then
			return
		end
		
		local itemCount		= itemWrapper:get():getCount_s64()

		if( Defines.s64_const.s64_1 ==  itemCount ) then
			Inventory_ItemDelete_Check( Defines.s64_const.s64_1, slotNo, whereType)
		else
			Panel_NumberPad_Show(  true, itemCount, slotNo, Inventory_ItemDelete_Check, nil, whereType) 
		end
	end
end

function ExchangeButton_Off()
	local panelPosX		= Panel_Invertory_ExchangeButton:GetPosX()
	local panelPosY		= Panel_Invertory_ExchangeButton:GetPosY()
	local panelSizeX	= Panel_Invertory_ExchangeButton:GetSizeX()
	local panelSizeY	= Panel_Invertory_ExchangeButton:GetSizeY()
	local mousePosX		= getMousePosX()
	local mousePosY		= getMousePosY()
	if( (panelPosX <= mousePosX) and (mousePosX <= (panelPosX + panelSizeX) )
		and (panelPosY <= mousePosY) and (mousePosY <= (panelPosY + panelSizeY)) ) then
		return
	end
	Panel_Invertory_ExchangeButton:SetShow( false )
end

local	deleteWhereType	= nil
local	deleteSlotNo	= nil
local	itemCount		= nil
local	itemName		= nil
function	Inventory_GroundClick( whereType, slotNo )
	if false == Panel_Window_Inventory:GetShow() or Panel_Win_System:GetShow() then
		return
	end

	local itemWrapper = getInventoryItemByType( whereType, slotNo )
	if	nil == itemWrapper	then
		return
	end
	
	itemCount	= itemWrapper:get():getCount_s64()
	itemName	= itemWrapper:getStaticStatus():getName()
	if( Defines.s64_const.s64_1 ==  itemCount ) then
		Inventory_GroundClick_Message( Defines.s64_const.s64_1, slotNo, whereType)
	else
		if isUseNewQuickSlot() then
			Inventory_GroundClick_Message( Defines.s64_const.s64_1, slotNo, whereType)
		else
			Panel_NumberPad_Show(  true, itemCount, slotNo, Inventory_GroundClick_Message, nil, whereType)
		end
	end
end

function	Inventory_GetToopTipItem()
	local	self	= inven
	
	if	( nil == self._tooltipWhereType)	then
		return(nil)
	end
	
	if	( nil == self._tooltipSlotNo)	then
		return(nil)
	end
	
	return( getInventoryItemByType(self._tooltipWhereType, self._tooltipSlotNo) )
end

function	Inventory_IconOver(index)
	local	self	= inven
	local	slotNo	= self.slots[index]._slotNo
	
	self.slotEtcData[index].isFirstItem = false
	if (nil ~= effectScene.newItem[index]) then
		self.slots[index].icon:EraseEffect(effectScene.newItem[index])
	end

	-- local itemWrapper	= getInventoryItemByType(Inventory_GetCurrentInventoryType(), slotNo)
	-- if (nil == itemWrapper) then
	-- 	-- 빈 슬롯에만 이펙트 처리를 한다.
	-- 	self.slots[index].icon:EraseAllEffect()
	-- 	.slots[index].icon:AddEffect( "UI_Inventory_EmptySlot", false, 0, 0 )
	-- 	return
	-- end
	
	if ( nil ~= over_SlotEffect ) then
		self.slots[index].icon:EraseEffect(over_SlotEffect)
	end
	
	over_SlotEffect = self.slots[index].icon:AddEffect( "UI_Inventory_EmptySlot", false, 0, 0 )	
	
	self._tooltipWhereType	= Inventory_GetCurrentInventoryType()
	self._tooltipSlotNo		= slotNo
	Panel_Tooltip_Item_Show_GeneralNormal(index, "inventory", true)
end

function	Inventory_IconOut( index )
	local	self	= inven
	if ( nil ~= over_SlotEffect ) then
		inven.slots[index].icon:EraseEffect(over_SlotEffect)
	end

	self._tooltipWhereType	= nil
	self._tooltipSlotNo		= nil
	Panel_Tooltip_Item_Show_GeneralNormal( index, "inventory", false)
end

function Inventory_GetFirstItemCount()
	local aCount = 0
	local returnValue = 0
	for _, value in pairs( inven.slotEtcData ) do
		if ( value.isFirstItem ) then
			aCount = aCount + 1
		end
	end

	return aCount
end

function	Inventory_GroundClick_Message(s64_itemCount, slotNo, whereType)
	if( restrictedActionForUseItem() )then
		Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_CANT_REMOVEITEM" ) )
		return(false)
	end
	
	deleteWhereType	= whereType
	deleteSlotNo	= slotNo
	itemCount		= s64_itemCount
	
	if( true == isNearFusionCore() ) then	
		local luaPushItemToCampfireMsg = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_PUSHITEMTOCAMPFIRE_MSG", "itemName", itemName, "itemCount", tostring(itemCount) )
		local luaBurn = PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_BURN")
			
		local messageContent = luaPushItemToCampfireMsg
		local messageboxData = { title = luaBurn, content = messageContent, functionYes = Inventory_BurnItemToActor_Yes, functionNo = Inventory_Delete_No, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData)	
	else
		if isUseNewQuickSlot() then
			-- 새로운 퀵슬롯에 등록한다.
			FGlobal_SetNewQuickSlot_ByGroundClick( s64_itemCount, slotNo, whereType )
		else
			local luaDeleteItemMsg = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_DELETEITEM_MSG", "itemName", itemName, "itemCount", tostring(itemCount) )
			local luaDelete = PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_DELETE")
			
			local messageContent = luaDeleteItemMsg
			local messageboxData = { title = luaDelete, content = messageContent, functionYes = Inventory_Delete_Yes, functionNo = Inventory_Delete_No, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
			MessageBox.showMessageBox(messageboxData)
		end
	end	
end

function Inventory_ItemDelete_Check( count, slotNo, whereType )
	local itemWrapper	= getInventoryItemByType( whereType, slotNo )
	local itemName		= itemWrapper:getStaticStatus():getName()

	deleteWhereType	= whereType
	deleteSlotNo	= slotNo
	itemCount		= count

	DragManager:clearInfo()

	local luaDeleteItemMsg = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_DELETEITEM_MSG", "itemName", itemName, "itemCount", tostring(count) )
	local luaDelete = PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_DELETE")
	
	local messageContent = luaDeleteItemMsg
	local messageboxData = { title = luaDelete, content = messageContent, functionYes = Inventory_Delete_Yes, functionNo = Inventory_Delete_No, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
end

function Inventory_Delete_Yes()
	if deleteSlotNo == nil then
		return
	end
	
	local	itemWrapper	= getInventoryItemByType(deleteWhereType, deleteSlotNo)
	if( nil == itemWrapper )	then
		return
	end
	
	if	( itemWrapper:isCash() )	then
		PaymentPassword( Inventory_Delete_YesXXX )
		return
	end
	
	Inventory_Delete_YesXXX()
end

function Inventory_Delete_YesXXX()
	if deleteSlotNo == nil then
		return
	end
	
	deleteItem( getSelfPlayer():getActorKey(), deleteWhereType, deleteSlotNo, itemCount )
	DragManager:clearInfo()
end

function Inventory_BurnItemToActor_Yes()
	if deleteSlotNo ~= nil then
		burnItemToActor(deleteWhereType, deleteSlotNo, itemCount)
	end
end

function Inventory_Delete_No()
	deleteWhereType	= nil
	deleteSlotNo	= nil
end

local inventoryDragNoUseList = nil
function FGlobal_SetInventoryDragNoUse( pPanel )-- 해당 패널 사용중에 인벤토리가 드래그 되지 않아야 될 경우
	inventoryDragNoUseList = pPanel
end

function	Inventory_SlotDrag( index )
	local	self	= inven
	local	slotNo	= self.slots[index]._slotNo
	if nil ~= inventoryDragNoUseList and inventoryDragNoUseList:IsShow() then	-- 해당 패널 사용중에 인벤토리가 드래그 되지 않아야 될 경우
		return
	end
	
	if Panel_Win_System:GetShow() then
		return
	end
	
	if FGlobal_Selloff_CondCheck() then
		return
	end

	local	whereType	= Inventory_GetCurrentInventoryType()
	local	itemWrapper	= getInventoryItemByType(whereType, slotNo)
	-- UI.debugMessage(slotNo)
	-- 비어있지 않으면!
	if	(nil ~= itemWrapper)	then
		local itemSSW		= itemWrapper:getStaticStatus()
		local itemType		= itemSSW:getItemType()
		local isTradeItem	= itemSSW:isTradeAble()

		DragManager:setDragInfo(Panel_Window_Inventory, whereType, slotNo, "Icon/" .. itemWrapper:getStaticStatus():getIconPath(), Inventory_GroundClick, getSelfPlayer():getActorKey())
		if itemWrapper:getStaticStatus():get():isItemSkill() or itemWrapper:getStaticStatus():get():isUseToVehicle() then
			QuickSlot_ShowBackGround()
		end

	Item_Move_Sound ( itemWrapper )
	end
end

function Inventory_ShowToggle()
	Inventory_SetShow( not Panel_Window_Inventory:GetShow() )
end

function inven:registEventHandler()
	self.buttonClose:addInputEvent(		"Mouse_LUp",	"InventoryWindow_Close()"	)
	self.buttonMoney:addInputEvent(		"Mouse_LUp",	"InventoryWindow_PopMoney()")
	self.checkButton_Sort:addInputEvent("Mouse_LUp",	"Inventory_SetSorted()")
	--self.checkButton_Sort:addInputEvent("Mouse_LUp",	"Inventory_updateSlotData()")	-- 체크 버튼이 눌리면 전체를 다시 update 한다!
end

function Inventory_SetSorted()
	local self = inven
	local bSorted = self.checkButton_Sort:IsCheck()
	ToClient_SetSortedInventory( bSorted )
	
	Inventory_updateSlotData()
end

function InventoryWindow_PopMoney()
	-- 창고
	if	( (not Panel_Window_Warehouse:GetShow()) and (not Panel_Window_ServantInventory:GetShow()) )	then
		inven.buttonMoney:SetEnable(false)
		--inven.buttonMoney:ChangeTextureInfoName ( "New_UI_Common_forLua/Default/window_sample_empty.dds" )
		--inven.buttonMoney:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Default/window_sample_empty.dds" )
		--inven.buttonMoney:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Default/window_sample_empty.dds" )
		return
	end

	local	self		= inven
	local	whereType	= CppEnums.ItemWhereType.eInventory
	local	slotNo		= getMoneySlotNo()

	FGlobal_PopupMoveItem_Init( whereType, slotNo, CppEnums.MoveItemToType.Type_Player, getSelfPlayer():getActorKey(), true )
end

function	Inventory_UpdatePerFrame( fDeltaTime )
	if fDeltaTime <= 0 then
		return
	end

	local selfPlayerWrapper = getSelfPlayer()
	if nil == selfPlayerWrapper then
		return
	end

	local	self				= inven
	local	useStartSlot		= inventorySlotNoUserStart()
	local	currentWhereType	= Inventory_GetCurrentInventoryType()
	-- Inven 0 번 슬롯은 돈이라서 표시하지 않는다.
	-- Lua 는 일반적으로 배열 index 가 1 부터 시작한다.
	for ii = 0, self.config.slotCount - 1	do
		local	slot			= self.slots[ii]
		local	slotNo			= slot._slotNo
		local	remainTime		= 0
		local	itemReuseTime	= 0
		local	realRemainTime	= 0
		local	intRemainTime	= 0
		
		if ( UI_TISNU ~= slotNo ) then
			remainTime		= getItemCooltime( currentWhereType, slotNo )
			itemReuseTime	= getItemReuseCycle( currentWhereType, slotNo ) / 1000
			realRemainTime	= remainTime * itemReuseTime
			intRemainTime	= realRemainTime - realRemainTime % 1 + 1
		end
		
		--local remainTime = getItemCooltime( idx )
		if 0 < remainTime then
			slot.cooltime:UpdateCoolTime( remainTime )
			slot.cooltime:SetShow( true )
			slot.cooltimeText:SetText( Time_Formatting_ShowTop(intRemainTime) )
			if ( intRemainTime <= itemReuseTime ) then
				slot.cooltimeText:SetShow( true )
			else
				slot.cooltimeText:SetShow( false )
			end
		else
			if slot.cooltime:GetShow() then
				----------------------------------------------
				--  인벤토리에 있는 아이템 쿨타임이 끝났다!
				----------------------------------------------
				slot.cooltime:SetShow( false )
				slot.cooltimeText:SetShow( false )
				
				local skillSlotItemPosX = slot.cooltime:GetParentPosX()
				local skillSlotItemPosY = slot.cooltime:GetParentPosY()
				
				-- ♬ 쿨타임이 종료됐을 때 사운드 추가				
				audioPostEvent_SystemUi(02,01)
				
				Panel_Inventory_CoolTime_Effect_Item_Slot:SetShow( true, true )
				Panel_Inventory_CoolTime_Effect_Item_Slot:AddEffect( "UI_Button_Hide", false, 2.5, 7.0 )
				Panel_Inventory_CoolTime_Effect_Item_Slot:AddEffect( "fUI_Button_Hide", false, 2.5, 7.0 )
				Panel_Inventory_CoolTime_Effect_Item_Slot:SetPosX( skillSlotItemPosX - 7 )
				Panel_Inventory_CoolTime_Effect_Item_Slot:SetPosY( skillSlotItemPosY - 10 )
			end
		end
	end
	
	-- 아이템 태우기 쿨타임 주기
	--[[
	if( 0 <= burnItemTime ) then
		burnItemTime = burnItemTime + fDeltaTime
		--_PA_LOG( "luaDebug", " burnItemTime : " ..tostring( burnItemTime ) )
		if ( 4 < burnItemTime ) then
			--_PA_LOG( "luaDebug", " burnItemTime 3초 완~ " ..tostring( burnItemTime ) )
			-- -1은 사용가능하다는 것임
			burnItemTime = -1 
		end		
	end
	--]]
end

-- 인벤 아이템 정렬 Wrapping Function
function Inventory_ItemComparer( ii, jj )
	return Global_ItemComparer( ii, jj, getInventoryItemByType, Inventory_GetCurrentInventoryType() )
end

local _filter_for_NormalTab = function( slotNo, itemWrapper )
	return false
end

local _filter_for_TradeTab = function( slotNo, itemWrapper )
	if( nil ~= itemWrapper ) then
		return (not itemWrapper:getStaticStatus():get():isForJustTrade())
	else
		return true
	end	
end

local _filter_for_HousingTab = function( slotNo, itemWrapper )
	if( nil ~= itemWrapper ) then
		return (not itemWrapper:getStaticStatus():get():isItemInstallation())
	else
		return true
	end
end

local _filter_for_HousingConsignmentSaleManager = function( slotNo, itemWrapper )
	if( nil ~= itemWrapper ) then
		return (not isRegistrableItem(slotNo, itemWrapper))		
	else	
		return true
	end
end

function isRegistrableItem( slotNo, itemWrapper )
	if itemWrapper:get():isVested() or false == itemWrapper:getExpirationDate():isIndefinite() then
		return false
	end
	return ToClient_IsRegistrableItem( slotNo )
end

function FGlobal_UpdateInventorySlotData()
	Inventory_updateSlotData()
end


--------------------------------------------------------------------
-- 마패 처리용
--------------------------------------------------------------------
local _lookAtMe = UI.getChildControl(  Panel_fieldQuest, 'Static_LookAtMe' )


--------------------------------------------------------------------
-- 거래 처리용
--------------------------------------------------------------------
local _exchangeSlotNo = {}
local _exchangeIndex = -1
function Inventory_AddEffect_While_Exchange( invenSlotNo )
	if tradePC_GetMyLock() then return end				-- 잠금 상태라면 이펙트를 추가하지 않는다
	if ( _exchangeIndex < 0 ) then
		_exchangeIndex = _exchangeIndex + 1
	end

	for i = 0, _exchangeIndex do
		if ( nil == _exchangeSlotNo[i] ) then
			_exchangeSlotNo[i] = invenSlotNo
			Inventory_updateSlotData()
			return
		end
	end
	_exchangeIndex = _exchangeIndex + 1
	_exchangeSlotNo[_exchangeIndex] = invenSlotNo
	Inventory_updateSlotData()
end

function Inventory_EraseEffect_While_Exchange( exchangeIndex )
	if tradePC_GetMyLock() then	-- 잠금 상태라면 이펙트를 해제하지 않는다
		return
	end

	-- _exchangeIndex = _exchangeIndex -1		-- #649182 북미 이슈 문제 떄문에 주석처리하지만 무슨 문제가 발생할지 예측되지 않는다.
	_exchangeSlotNo[exchangeIndex] = nil
	Inventory_updateSlotData()
end

function Inventory_Filter_Init()
	for i = _exchangeIndex, -1, -1 do
		_exchangeSlotNo[i] = nil
	end
	_exchangeIndex = -1
end

function	Inventory_IsCurrentNormalInventoryType()
	local	self	= inven
	return( self.radioButtonNormaiInven:IsChecked() )
end

function	Inventory_GetCurrentInventoryType()
	local	self	= inven
	if( Inventory_IsCurrentNormalInventoryType() )	then
		return( CppEnums.ItemWhereType.eInventory )
	else
		return( CppEnums.ItemWhereType.eCashInventory )
	end
	
	return( CppEnums.ItemWhereType.eInventory )
end

function	Inventory_GetCurrentInventory()
	local	selfPlayerWrapper	= getSelfPlayer()
	if nil == selfPlayerWrapper then
		return( nil )
	end
	
	local	selfPlayer	= selfPlayerWrapper:get()
	local	inventory	= selfPlayer:getInventoryByType(Inventory_GetCurrentInventoryType())
	return( inventory )
end

-- 메시지 핸들러들
-- 슬롯 정보 갱신. 한번에 전체를 모두 갱신한다.!
local isFirstSummonItemUse = false
local isNormalInven = true
function	Inventory_updateSlotData()
	local	stdBackGround		= UI.getChildControl ( Panel_Window_Inventory, "Static_Texture_Slot_Background" )
	local	self				= inven
	local	selfPlayerWrapper	= getSelfPlayer()
	local	classType			= selfPlayerWrapper:getClassType() 
	if nil == selfPlayerWrapper then
		return
	end

	local	selfPlayer			= selfPlayerWrapper:get()
	isFirstSummonItemUse = false
	-- 돈 & 펄
	-- 돈 무게에 따라 아이콘 텍스처 교체
	--{
		local	money				= Defines.s64_const.s64_0
		local	pearl				= Defines.s64_const.s64_0
		local	mileage				= Defines.s64_const.s64_0
		local	moneyItemWrapper	= getInventoryItemByType( CppEnums.ItemWhereType.eInventory, getMoneySlotNo() )
		if	( nil ~= moneyItemWrapper )	then
			money	= moneyItemWrapper:get():getCount_s64()
		end
		
		local	pearlItemWrapper	= getInventoryItemByType( CppEnums.ItemWhereType.eCashInventory, getPearlSlotNo() )
		if	( nil ~= pearlItemWrapper )	then
			pearl	= pearlItemWrapper:get():getCount_s64()
		end
		
		local	mileagelItemWrapper	= getInventoryItemByType( CppEnums.ItemWhereType.eCashInventory, getMileageSlotNo() )
		if	( nil ~= mileagelItemWrapper )	then
			mileage	= mileagelItemWrapper:get():getCount_s64()
		end
	
		self.staticMoney	:SetText( makeDotMoney( money ) )
		self.valuePearl		:SetText( makeDotMoney( pearl ) )
		self.valueMileage	:SetText( makeDotMoney( mileage ) )
		
		_Inventory_updateSlotData_ChangeSilverIcon( money )	-- 실버에 따라 실버 아이콘을 바꿈.
		
	--}
	
	local _const				= Defines.s64_const

	-- 무게 설정 ( 일반 일벤토리, 장착 슬롯만 무게가 있다. )
	--{
		local	normalInventory		= selfPlayer:getInventoryByType( CppEnums.ItemWhereType.eInventory )
		local	s64_moneyWeight		= normalInventory:getMoneyWeight_s64()
		local	s64_equipmentWeight	= selfPlayer:getEquipment():getWeight_s64()
		local	s64_allWeight		= selfPlayer:getCurrentWeight_s64()
		local	s64_maxWeight		= selfPlayer:getPossessableWeight_s64()
	
		local	s64_allWeight_div	= s64_allWeight / _const.s64_100
		local	s64_maxWeight_div	= s64_maxWeight / _const.s64_100
		
		local	str_AllWeight 		= string.format("%.1f", Int64toInt32(s64_allWeight_div) / 100 )
		local	str_MaxWeight 		= string.format("%.0f", Int64toInt32(s64_maxWeight_div) / 100 )
		
		if ( Int64toInt32(s64_allWeight) <= Int64toInt32(s64_maxWeight) ) then
			self.weightMoney		:SetProgressRate( Int64toInt32(s64_moneyWeight / s64_maxWeight_div) )
			self.weightEquipment	:SetProgressRate( Int64toInt32((s64_moneyWeight + s64_equipmentWeight) / s64_maxWeight_div) )
			self.weightItem			:SetProgressRate( Int64toInt32(s64_allWeight / s64_maxWeight_div) )
		else
			self.weightMoney		:SetProgressRate( Int64toInt32(s64_moneyWeight / s64_allWeight_div) )
			self.weightEquipment	:SetProgressRate( Int64toInt32((s64_moneyWeight + s64_equipmentWeight) / s64_allWeight_div) )
			self.weightItem			:SetProgressRate( Int64toInt32(s64_allWeight / s64_allWeight_div) )
		end
		
		self.staticWeight		:SetText( str_AllWeight .. " / " .. str_MaxWeight .. " LT" )
		
		-- 무게가 80%가 넘으면 무게 아이콘 바꿔줌
		_Inventory_updateSlotData_ChangeWeightIcon( s64_allWeight, s64_maxWeight_div )
	--}
	
	-- 슬롯 용량 Show ( 돈 슬롯은 뺀다.! )(20130730:홍민우) 
	local	playerLevel 		= getSelfPlayer():get():getLevel()
	local	isNormalInventory	= self.radioButtonNormaiInven:IsChecked()
	isNormalInven = isNormalInventory		-- 가공 필터 부분에서 펄인벤 체크를 위해 필요.
	local	useStartSlot		= inventorySlotNoUserStart()
	local	invenUseSize		= selfPlayer:getInventorySlotCount( not isNormalInventory )	-- 열려있는 인벤토리 사이즈
	local	inventory			= Inventory_GetCurrentInventory()
	local	invenMaxSize		= inventory:sizeXXX()										-- 최대 열수 있는 사이즈
	local	currentWhereType	= Inventory_GetCurrentInventoryType()
	
	-- 스크롤
	--{
		UIScroll.SetButtonSize( self._scroll, self.config.slotCount, (invenMaxSize - useStartSlot) )
		self._scroll:SetShow( true )
	--}
	
	-- 개수 표시
	--{
		local	freeCount	= inventory:getFreeCount()
		self.staticCapacity:SetText( tostring(invenUseSize - freeCount - useStartSlot) .. "/" .. tostring(invenUseSize - useStartSlot) )
	--}
	
	--돈, 펄, 마일리지 제외하고 뿌려준다. 0, 1번 슬롯은 돈, 펄, 마일리지 슬롯 이다.
	local	slotNoList	= Array.new()
	slotNoList:fill( useStartSlot , invenMaxSize - 1 )		--	2 ~ 63

	-- 아이템 정렬
	if self.checkButton_Sort:IsCheck() then
		local	sortList	= Array.new()
		sortList:fill( useStartSlot , invenUseSize - 1 )	-- 2 ~ 17
		sortList:quicksort( Inventory_ItemComparer )
		
		for	ii = 1, invenUseSize - 2	do
			slotNoList[ii]	= sortList[ii]
		end
	end
	
	-- icon 백그라운드
	--{
		for ii = 0, self.config.slotCount -1 do
			local	slot = self._slotsBackground[ii]
			slot.empty:SetShow( false )
			slot.lock:SetShow( false )
			
			if( ii < (invenUseSize-useStartSlot-self.startSlotIndex) )	then
				slot.empty:SetShow( true )
			else
				slot.lock:SetShow( true )
			end
		end
	--}
	
	local isFiltered= false
	local _mapaeBling = {}
	
	Panel_Inventory_isBlackStone_16001 = false
	Panel_Inventory_isBlackStone_16002 = false
	Panel_Inventory_isSocketItem = false
	
	Panel_NewEquip_EffectClear()
	
	--{
		for ii = 0, self.config.slotCount -1 do
			local	slot	= self.slots[ii]
			
			slot:clearItem()
			slot.icon:SetEnable( true )
			slot.icon:SetMonoTone( true )
			slot.isEmpty = true
		end
	--}

	local fixEquipCheck = false
	for ii = 0, self.config.slotCount - 1	do
		local	slot	= self.slots[ii]
		local	slotNo	= slotNoList[ii + 1 + self.startSlotIndex]
		slot._slotNo	= slotNo
	
		slot.icon:EraseAllEffect()
		-- position Set
		local row = math.floor( ii / self.config.slotCols )
		local col = ii % self.config.slotCols
		slot.icon:SetPosX( self.config.slotStartX + self.config.slotGapX * col )
		slot.icon:SetPosY( self.config.slotStartY + self.config.slotGapY * row )

		local itemExist		= false
		local itemWrapper	= getInventoryItemByType( currentWhereType, slotNo )
		if nil ~= itemWrapper then
			-- 데이터 설정
			slot:setItem( itemWrapper )
			slot.isEmpty = false

			if nil ~= self.filterFunc then
				isFiltered = self.filterFunc( slotNo, itemWrapper, currentWhereType )
			else
				-- 아이템 필터 버튼 체인지
				isFiltered = _Inventory_updateSlotData_ChangeFilterBtnTexture( isFiltered, slotNo, stdBackGround )
				
				if ( nil ~= Panel_Housing_ConsignmentSale) and Panel_Housing_ConsignmentSale:GetShow() then
					if false == isFiltered then
						isFiltered = _filter_for_HousingConsignmentSaleManager( slotNo, itemWrapper )
					end
				end
				
			end

			slot.icon:SetEnable( not isFiltered )
			slot.icon:SetMonoTone( isFiltered )
			slot.icon:SetIgnore( isFiltered )
			if	(isFiltered) then -- 필터가 있다면!
				slot.icon:SetAlpha(0.5)
				slot.icon:EraseAllEffect()
			else
				if nil ~= self.filterFunc then
					slot.icon:AddEffect( "UI_Inventory_Filtering" , true, 0, 0)
				end
				--------------------------------------
				--		마패만 필터링하는 부분
				_Inventory_updateSlotData_AddEffectMapea( ii, slotNo )
				
			end	
			itemExist = true

			-- 블랙스톤 아이콘 꾸미기
			Panel_Inventory_isBlackStone_16002 = _Inventory_updateSlotData_AddEffectBlackStone( ii, isFiltered, slotNo )
			
			----------------------------------------
			--	물약이 있으면 슬롯에 자동등록!
			----------------------------------------
			local itemKey = itemWrapper:get():getKey():getItemKey()
			_Inventory_updateSlotData_AutoSetPotion( playerLevel, itemKey, currentWhereType, slotNo )
			
			-- 첫 물약 튜토리얼 시 초보자 회복제에 이펙트 부여(교체 예정)
			if 502 == itemKey and true == isFirstPotionTutorial() then
				slot.icon:AddEffect( "fUI_Tuto_ItemHp_01A" , true, 0, 0)
				FGlobal_Tutorial_InventoryMasking_Show( slot.icon:GetPosX(), slot.icon:GetPosY() )
			end
			
			-- 퀘스트용 임프 대장 소환서(42000)를 갖고 있고, 보스 튜토리얼을 진행중이라면,
			if (42000 == itemKey or 42001 == itemKey) and true == isFirstSummonTutorial() and not FGlobal_FirstSummonItemUse() then
				slot.icon:AddEffect( "fUI_Tuto_ItemHp_01A" , true, 0, 0)
				-- FGlobal_Tutorial_InventoryMasking_Show( slot.icon:GetPosX(), slot.icon:GetPosY() )
			end

			-- 수정을 가져온다
			local itemSSW = itemWrapper:getStaticStatus()
			local item_type = itemSSW:getItemType()
			if item_type == 5 then
				Panel_Inventory_isSocketItem = true
			end
			
			-- 인벤토리 내 장착 아이템 성능 비교를 위한 준비(거래중일 땐 필터 끔)
			-- local equipItemWrapper 		= getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo())
			local offencePoint 			= 0
			local defencePoint 			= 0
			local equipOffencePoint  	= 0
			local equipDefencePoint 	= 0
			local isEquip 				= itemWrapper:getStaticStatus():get():isEquipable()
			local matchEquip			= false
			
			-- { 아이템 성능 비교
			offencePoint, defencePoint, equipOffencePoint, equipDefencePoint, matchEquip = _inventory_updateSlot_compareSpec( currentWhereType, slotNo )
			-- }
			
			local currentEndurance		= itemWrapper:get():getEndurance()
			local isUsableServant 		= itemWrapper:getStaticStatus():isUsableServant()
			-- 인벤토리 내 장착 아이템 성능 비교 및 이펙트 출력(거래중일 땐 필터 끔)
			if not isUsableServant and not Panel_Window_Exchange:GetShow() then
				if isEquip then
					if nil ~= defencePoint and 0 < currentEndurance then							-- 내구도가 0 이상인 장비만 비교
						if true == matchEquip then
							if defencePoint > equipDefencePoint then
								slot.icon:AddEffect("fUI_BetterItemAura01", true, 0, 0)
								local equipPos = itemWrapper:getStaticStatus():getEquipSlotNo()
								-- NewEquipWidget_Show( equipPos )
								Panel_NewEquip_Update( equipPos )
							end
						end
					end
					if nil~= offencePoint and 0 < currentEndurance then							-- 내구도가 0 이상인 장비만 비교
						if true == matchEquip then
							if offencePoint > equipOffencePoint then
								slot.icon:AddEffect("fUI_BetterItemAura01", true, 0, 0)
								local equipPos = itemWrapper:getStaticStatus():getEquipSlotNo()
								-- NewEquipWidget_Show( equipPos )
								Panel_NewEquip_Update( equipPos )
							end
						end
					end
				end

				if ( true == self.slotEtcData[ii].isFirstItem ) then
					local newItemEffectSceneId = slot.icon:AddEffect("fUI_NewItem01", true, 0, 0)
					effectScene.newItem[slotNo] = newItemEffectSceneId
					UIMain_ItemUpdate()
				end
			end

			-----------------------------------------------------------
			-- 내 클래스 무기가 아닐 경우에만 사용 불가 필터 적용 
			local isUsableClass = nil
			if ( nil ~= itemSSW ) then
				if itemSSW:get():isWeapon() or itemSSW:get():isSubWeapon() then
					isUsableClass = itemSSW:get()._usableClassType:isOn( classType )
				else
					isUsableClass = true
				end
			else
				isUsableClass = false
			end
			if ( false == isEquip  ) then
				slot.icon:SetColor( UI_color.C_FFFFFFFF )
			else
				if ( true == isUsableClass ) then
					slot.icon:SetColor( UI_color.C_FFFFFFFF )
				else
					slot.icon:SetColor( UI_color.C_FFD20000 )
				end
			end

			-- 거래중일 때 필터 처리
			for iii = 0, _exchangeIndex do
				if Panel_Window_Exchange:GetShow() and ( slotNo == _exchangeSlotNo[iii] ) then			-- 거래창에 들어간 아이템
					slot.icon:SetColor( UI_color.C_FFD20000 )
				elseif ( slotNo == _exchangeSlotNo[iii] ) and nil == _exchangeSlotNo[iii] then
					slot.icon:SetColor( UI_color.C_FFFFFFFF )
				end
			end
			local itemBindType = itemSSW:get()._vestedType:getItemKey()
			if Panel_Window_Exchange:GetShow() and ( 0 < itemBindType ) then									-- 귀속 아이템
				slot.icon:SetColor( UI_color.C_FFD20000 )
			end
			-----------------------------------------------
			-- 최대 내구도 복구 itemWrapper Update 처리.
			-----------------------------------------------
			if Panel_FixEquip:GetShow() then
				UseCashBtnEffectDelete()
				if isRepeatRepair() then
					if not FixEquip_InvenFiler_SubItem( slotNo, itemWrapper, currentWhereType )  and isFixEquip_SubSlotItemKey() == itemKey then
						if not fixEquipCheck then
							fixEquipCheck = true
							FGlobal_FixEquipContinue( slotNo )
						end
					end
				end
			end
		end
		equipDefencePoint = 0
		equipOffencePoint = 0
		defencePoint = 0
		offencePoint = 0

		if not itemExist then	
			slot:clearItem()
			slot.icon:SetEnable( true )
			slot.icon:SetMonoTone( true )
			slot.icon:SetIgnore( false )
			slot.isEmpty = true
		end
	end
		
	FGlobal_closeFix()
	
	if ( "QuickSlot" == Panel_Tooltip_Item_GetCurrentSlotType() ) then
		Panel_Tooltip_Item_Refresh()
	 end
	
	Inven_FindPuzzle()

	Panel_NewEquip_EffectLastUpdate()
	if true == Panel_Window_Inventory:GetShow() then
		Panel_Tooltip_Item_Refresh()
		-- 이걸 왜 여기서 리프레쉬 하는지 모르겠지만...
		-- "EventCharacterInfoUpdate" Event에서타고 들어와 안 해줘야할 순간에도 Refresh를 해버리니
		-- 일단 예외처리를 추가한다(한선국)
	end
	FGlobal_Inventory_WeightCheck()

	if Panel_Window_Servant:GetShow() then	-- 말 피리가 생겼을 때 텍스쳐를 바꾸기 위해.
		Panel_Window_Servant_Update()
	end

	FGlobal_WhereUseItemExecute()
--{	내 인벤 은화 금액을 업데이트 시키기 위해서 존재.
	FGlobal_Repair_Money_Update()
	FGlobal_ItemRandom_Money_Update()
--}
end

function _inventory_updateSlot_compareSpec( whereType, slotNo )
	local selfPlayerWrapper		= getSelfPlayer()
	local classType				= selfPlayerWrapper:getClassType() 
	local itemWrapper			= getInventoryItemByType( whereType, slotNo )
	local equipItemWrapper 		= getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo())
	local offencePoint 			= 0
	local defencePoint 			= 0
	local equipOffencePoint  	= 0
	local equipDefencePoint 	= 0
	local matchEquip			= false
	local isEquip 				= itemWrapper:getStaticStatus():get():isEquipable()
	if isEquip and not Panel_Window_Exchange:GetShow() then
		local enum_class = CppEnums.ClassType
		local equipType = itemWrapper:getStaticStatus():getEquipType()
		if nil~= equipItemWrapper then
			equipDefencePoint = getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo()):getStaticStatus():getDefence(0)
			if ((enum_class.ClassType_Warrior == classType or enum_class.ClassType_Valkyrie == classType) and (1 == equipType or 8 == equipType or 57 == equipType))
				or 13 == equipType or 9 == equipType or 11 == equipType or 12 == equipType then
				offencePoint = (itemWrapper:getStaticStatus():getMinDamage(0) + itemWrapper:getStaticStatus():getMaxDamage(0)) / 2
				equipOffencePoint = (getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo()):getStaticStatus():getMinDamage(0) + getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo()):getStaticStatus():getMaxDamage(0)) /2
				defencePoint = itemWrapper:getStaticStatus():getDefence(0)
				matchEquip = true
			elseif (enum_class.ClassType_Giant == classType and (29 == equipType or 34 == equipType or 57 == equipType))
				or (((enum_class.ClassType_NinjaWomen == classType or enum_class.ClassType_NinjaMan == classType) and (55 == equipType or 56 == equipType or 57 == equipType)))
				or 13 == equipType or 9 == equipType or 11 == equipType or 12 == equipType then
				offencePoint = (itemWrapper:getStaticStatus():getMinDamage(0) + itemWrapper:getStaticStatus():getMaxDamage(0)) / 2
				equipOffencePoint = (getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo()):getStaticStatus():getMinDamage(0) + getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo()):getStaticStatus():getMaxDamage(0)) /2
				matchEquip = true
			elseif (enum_class.ClassType_Ranger == classType and (31 == equipType or 57 == equipType) )
				or ((enum_class.ClassType_Ranger == classType or enum_class.ClassType_Wizard == classType or enum_class.ClassType_WizardWomen == classType) and (32 == equipType or 57 == equipType))
				or 13 == equipType or 9 == equipType or 11 == equipType or 12 == equipType then
				offencePoint = (itemWrapper:getStaticStatus():getMinDamage(1) + itemWrapper:getStaticStatus():getMaxDamage(1)) / 2
				equipOffencePoint = (getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo()):getStaticStatus():getMinDamage(1) + getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo()):getStaticStatus():getMaxDamage(1)) /2
				matchEquip = true
			elseif (enum_class.ClassType_Sorcerer == classType and (28 == equipType or 33 == equipType or 57 == equipType))
				or 13 == equipType or 9 == equipType or 11 == equipType or 12 == equipType then
				offencePoint = (itemWrapper:getStaticStatus():getMinDamage(2) + itemWrapper:getStaticStatus():getMaxDamage(2)) / 2
				equipOffencePoint = (getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo()):getStaticStatus():getMinDamage(2) + getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo()):getStaticStatus():getMaxDamage(2)) /2
				matchEquip = true
			elseif ((enum_class.ClassType_Tamer == classType or enum_class.ClassType_NinjaWomen == classType or enum_class.ClassType_NinjaMan == classType) and (2 == equipType or 57 == equipType) )
				or (enum_class.ClassType_Tamer == classType and 37 == equipType)
				or 13 == equipType or 9 == equipType or 11 == equipType or 12 == equipType then
				offencePoint = (itemWrapper:getStaticStatus():getMinDamage(2) + itemWrapper:getStaticStatus():getMaxDamage(2)) / 2
				equipOffencePoint = (getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo()):getStaticStatus():getMinDamage(2) + getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo()):getStaticStatus():getMaxDamage(2)) /2
				matchEquip = true
			elseif ((enum_class.ClassType_BladeMaster == classType or enum_class.ClassType_BladeMasterWomen == classType) and (3 == equipType or 36 == equipType))
				or 13 == equipType or 9 == equipType or 11 == equipType or 12 == equipType then
				offencePoint = (itemWrapper:getStaticStatus():getMinDamage(0) + itemWrapper:getStaticStatus():getMaxDamage(0)) / 2
				equipOffencePoint = (getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo()):getStaticStatus():getMinDamage(0) + getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo()):getStaticStatus():getMaxDamage(0)) /2
				matchEquip = true
			elseif ((enum_class.ClassType_Wizard == classType or enum_class.ClassType_WizardWomen == classType) and 6 == equipType)
				or 13 == equipType or 9 == equipType or 11 == equipType or 12 == equipType then
				offencePoint = (itemWrapper:getStaticStatus():getMinDamage(2) + itemWrapper:getStaticStatus():getMaxDamage(2)) / 2
				equipOffencePoint = (getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo()):getStaticStatus():getMinDamage(2) + getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo()):getStaticStatus():getMaxDamage(2)) /2
				matchEquip = true
			end
		else
			if ((enum_class.ClassType_Warrior == classType or enum_class.ClassType_Valkyrie == classType) and (1 == equipType or 8 == equipType or 57 == equipType))
				or 13 == equipType or 9 == equipType or 11 == equipType or 12 == equipType then
				offencePoint = (itemWrapper:getStaticStatus():getMinDamage(0) + itemWrapper:getStaticStatus():getMaxDamage(0)) / 2
				defencePoint = itemWrapper:getStaticStatus():getDefence(0)
				matchEquip = true
			elseif (enum_class.ClassType_Giant == classType and (29 == equipType or 34 == equipType or 57 == equipType))
				or (((enum_class.ClassType_NinjaWomen == classType or enum_class.ClassType_NinjaMan == classType) and (55 == equipType or 56 == equipType or 57 == equipType)))
				or 13 == equipType or 9 == equipType or 11 == equipType or 12 == equipType then
				offencePoint = (itemWrapper:getStaticStatus():getMinDamage(0) + itemWrapper:getStaticStatus():getMaxDamage(0)) / 2
				defencePoint = itemWrapper:getStaticStatus():getDefence(0)
				matchEquip = true
			elseif (enum_class.ClassType_Ranger == classType and (31 == equipType or 57 == equipType ))
				or ((enum_class.ClassType_Ranger == classType or enum_class.ClassType_Wizard == classType or enum_class.ClassType_WizardWomen == classType ) and (32 == equipType or 57 == equipType))
				or 13 == equipType or 9 == equipType or 11 == equipType or 12 == equipType then
				offencePoint = (itemWrapper:getStaticStatus():getMinDamage(1) + itemWrapper:getStaticStatus():getMaxDamage(1)) / 2
				defencePoint = itemWrapper:getStaticStatus():getDefence(0)
				matchEquip = true
			elseif (enum_class.ClassType_Sorcerer == classType and (28 == equipType or 33 == equipType or 57 == equipType))
				or 13 == equipType or 9 == equipType or 11 == equipType or 12 == equipType then
				offencePoint = (itemWrapper:getStaticStatus():getMinDamage(2) + itemWrapper:getStaticStatus():getMaxDamage(2)) / 2
				defencePoint = itemWrapper:getStaticStatus():getDefence(0)
				matchEquip = true
			elseif ((enum_class.ClassType_Tamer == classType or enum_class.ClassType_NinjaWomen == classType or enum_class.ClassType_NinjaMan == classType) and (2 == equipType or 57 == equipType))
				or (enum_class.ClassType_Tamer == classType and (37 == equipType))
				or 13 == equipType or 9 == equipType or 11 == equipType or 12 == equipType then
				offencePoint = (itemWrapper:getStaticStatus():getMinDamage(2) + itemWrapper:getStaticStatus():getMaxDamage(2)) / 2
				defencePoint = itemWrapper:getStaticStatus():getDefence(0)
				matchEquip = true
			elseif ((enum_class.ClassType_BladeMasterWomen == classType or enum_class.ClassType_BladeMasterWomen == classType) and (3 == equipType or 36 == equipType or 57 == equipType))
				or 13 == equipType or 9 == equipType or 11 == equipType or 12 == equipType then
				offencePoint = (itemWrapper:getStaticStatus():getMinDamage(0) + itemWrapper:getStaticStatus():getMaxDamage(0)) / 2
				defencePoint = itemWrapper:getStaticStatus():getDefence(0)
				matchEquip = true
			elseif ((enum_class.ClassType_Wizard == classType or enum_class.ClassType_WizardWomen == classType) and (6 == equipType or 32 == equipType or 57 == equipType))
				or 13 == equipType or 9 == equipType or 11 == equipType or 12 == equipType then
				offencePoint = (itemWrapper:getStaticStatus():getMinDamage(2) + itemWrapper:getStaticStatus():getMaxDamage(2)) / 2
				defencePoint = itemWrapper:getStaticStatus():getDefence(0)
				matchEquip = true
			end
		end
		return offencePoint, defencePoint, equipOffencePoint, equipDefencePoint, matchEquip
	end	
end

function isNormalInvenCheck()
	return isNormalInven
end

function _Inventory_updateSlotData_ChangeSilverIcon( money )
	local	self				= inven
	if ( 100000 <= Int64toInt32(money) ) then
		self.buttonMoney:ChangeTextureInfoName( "new_ui_common_forlua/window/inventory/Silver4.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( self.buttonMoney, 0, 0, 30, 30 )
		self.buttonMoney:getBaseTexture():setUV(  x1, y1, x2, y2  )
		self.buttonMoney:setRenderTexture(self.buttonMoney:getBaseTexture())
		self.buttonMoney:ChangeOnTextureInfoName ( "new_ui_common_forlua/window/inventory/Silver4_Over.dds" )
		self.buttonMoney:ChangeClickTextureInfoName ( "new_ui_common_forlua/window/inventory/Silver4_Over.dds" )
	elseif ( 20000 <= Int64toInt32(money) ) then
		self.buttonMoney:ChangeTextureInfoName( "new_ui_common_forlua/window/inventory/Silver3.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( self.buttonMoney, 0, 0, 30, 30 )
		self.buttonMoney:getBaseTexture():setUV(  x1, y1, x2, y2  )
		self.buttonMoney:setRenderTexture(self.buttonMoney:getBaseTexture())
		self.buttonMoney:ChangeOnTextureInfoName ( "new_ui_common_forlua/window/inventory/Silver3_Over.dds" )
		self.buttonMoney:ChangeClickTextureInfoName ( "new_ui_common_forlua/window/inventory/Silver3_Over.dds" )
	elseif ( 5000 <= Int64toInt32(money) ) then
		self.buttonMoney:ChangeTextureInfoName( "new_ui_common_forlua/window/inventory/Silver2.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( self.buttonMoney, 0, 0, 30, 30 )
		self.buttonMoney:getBaseTexture():setUV(  x1, y1, x2, y2  )
		self.buttonMoney:setRenderTexture(self.buttonMoney:getBaseTexture())
		self.buttonMoney:ChangeOnTextureInfoName ( "new_ui_common_forlua/window/inventory/Silver2_Over.dds" )
		self.buttonMoney:ChangeClickTextureInfoName ( "new_ui_common_forlua/window/inventory/Silver2_Over.dds" )
	else
		self.buttonMoney:ChangeTextureInfoName( "new_ui_common_forlua/window/inventory/Silver1.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( self.buttonMoney, 0, 0, 30, 30 )
		self.buttonMoney:getBaseTexture():setUV(  x1, y1, x2, y2  )
		self.buttonMoney:setRenderTexture(self.buttonMoney:getBaseTexture())
		self.buttonMoney:ChangeOnTextureInfoName ( "new_ui_common_forlua/window/inventory/Silver1_Over.dds" )
		self.buttonMoney:ChangeClickTextureInfoName ( "new_ui_common_forlua/window/inventory/Silver1_Over.dds" )
	end
end

function _Inventory_updateSlotData_ChangeWeightIcon( s64_allWeight, s64_maxWeight_div )
	local	self				= inven
	if ( 80 <= Int64toInt32( s64_allWeight / s64_maxWeight_div ) ) then
		self.weightIcon:ChangeTextureInfoName( "new_ui_common_forlua/window/inventory/WeightOver.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( self.weightIcon, 0, 0, 30, 30 )
		self.weightIcon:getBaseTexture():setUV(  x1, y1, x2, y2  )
		self.weightIcon:setRenderTexture(self.weightIcon:getBaseTexture())
	else
		self.weightIcon:ChangeTextureInfoName( "new_ui_common_forlua/window/inventory/weight.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( self.weightIcon, 0, 0, 30, 30 )
		self.weightIcon:getBaseTexture():setUV(  x1, y1, x2, y2  )
		self.weightIcon:setRenderTexture(self.weightIcon:getBaseTexture())
	end
end

function _Inventory_updateSlotData_ChangeFilterBtnTexture( isFiltered, slotNo, stdBackGround )
	local self			= inven
	local itemWrapper	= getInventoryItemByType( Inventory_GetCurrentInventoryType(), slotNo )

	if self.radioButtonStd:IsChecked() then
		isFiltered = _filter_for_NormalTab( slotNo, itemWrapper )
		stdBackGround:ChangeTextureInfoName ( "New_UI_Common_forLua/Window/Inventory/Inventory_00.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( stdBackGround, 0, 1, 256, 129 )
			stdBackGround:getBaseTexture():setUV(  x1, y1, x2, y2  )
			stdBackGround:setRenderTexture(stdBackGround:getBaseTexture())
	elseif self.radioButtonTransport:IsChecked() then
		isFiltered = _filter_for_TradeTab( slotNo, itemWrapper )
		stdBackGround:ChangeTextureInfoName ( "New_UI_Common_forLua/Window/Inventory/Inventory_00.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( stdBackGround, 256, 1, 512, 129 )
			stdBackGround:getBaseTexture():setUV(  x1, y1, x2, y2  )
			stdBackGround:setRenderTexture(stdBackGround:getBaseTexture())
	elseif self.radioButtonHousing:IsChecked() then
		isFiltered = _filter_for_HousingTab( slotNo, itemWrapper )
		stdBackGround:ChangeTextureInfoName ( "New_UI_Common_forLua/Window/Inventory/Inventory_00.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( stdBackGround, 0, 130, 256, 258 )
			stdBackGround:getBaseTexture():setUV(  x1, y1, x2, y2  )
			stdBackGround:setRenderTexture(stdBackGround:getBaseTexture())
	end
	return isFiltered
end

function _Inventory_updateSlotData_AutoSetPotion( playerLevel, itemKey, currentWhereType, slotNo )
	if ( 10 >= playerLevel ) then
		if ( 502 == itemKey ) 
		or ( 513 == itemKey )
		or ( 514 == itemKey )
		or ( 517 == itemKey )
		or ( 518 == itemKey )
		or ( 519 == itemKey )
		or ( 524 == itemKey )
		or ( 525 == itemKey )
		or ( 528 == itemKey )
		or ( 529 == itemKey )
		or ( 530 == itemKey )
		or ( 538 == itemKey )
		or ( 551 == itemKey )
		or ( 552 == itemKey )
		or ( 553 == itemKey )
		or ( 554 == itemKey )
		or ( 555 == itemKey )
		or ( 17568 == itemKey )
		or ( 17569 == itemKey )
		or ( 19932 == itemKey )
		or ( 19933 == itemKey )
		or ( 19934 == itemKey )
		or ( 19935 == itemKey )	then
			FGlobal_Potion_InvenToQuickSlot( currentWhereType, slotNo, 0 )	-- HP 물약
			
		elseif ( 503 == itemKey )
		or ( 515 == itemKey )
		or ( 516 == itemKey )
		or ( 520 == itemKey )
		or ( 521 == itemKey )
		or ( 522 == itemKey )
		or ( 526 == itemKey )
		or ( 527 == itemKey )
		or ( 531 == itemKey )
		or ( 532 == itemKey )
		or ( 533 == itemKey )
		or ( 540 == itemKey )
		or ( 561 == itemKey )
		or ( 562 == itemKey )
		or ( 563 == itemKey )
		or ( 564 == itemKey )
		or ( 565 == itemKey )
		or ( 17570 == itemKey )
		or ( 17571 == itemKey ) 
		or ( 19936 == itemKey ) 
		or ( 19937 == itemKey ) 
		or ( 19938 == itemKey ) then
			FGlobal_Potion_InvenToQuickSlot( currentWhereType, slotNo, 1 )	-- MP 물약
		end
	end
end

function _Inventory_updateSlotData_AddEffectBlackStone( ii, isFiltered, slotNo )
	local self			= inven
	local slot			= self.slots[ii]
	local itemWrapper	= getInventoryItemByType( Inventory_GetCurrentInventoryType(), slotNo )
	local Panel_Inventory_isBlackStone_16002 = false

	local itemKey = itemWrapper:get():getKey():getItemKey()
	if ( 16001 == itemKey ) then
		if not isFiltered then
			slot.icon:AddEffect("fUI_DarkstoneAura01", false, 0, 0)
		end
		Panel_Inventory_isBlackStone_16001 = true
	elseif ( 16002 == itemKey ) then
		if not isFiltered then
			slot.icon:AddEffect("fUI_DarkstoneAura02", false, 0, 0)
		end
		Panel_Inventory_isBlackStone_16002 = true
	end

	return Panel_Inventory_isBlackStone_16002
end

function _Inventory_updateSlotData_AddEffectMapea( ii, slotNo )
	local self			= inven
	local slot			= self.slots[ii]
	local itemWrapper	= getInventoryItemByType( Inventory_GetCurrentInventoryType(), slotNo )

	if ( GetUIMode() == Defines.UIMode.eUIMode_Stable ) and not EffectFilter_Mapae( slotNo, itemWrapper ) then -- and self.effect() ~= nil 
		-------------------------------------
		-- 	이팩트로 빛나게 함.
		slot.icon:AddEffect( "fUI_HorseNameCard01" , true, 0, 0)
	end
end

function	Inventory_AddItem( itemKey, slotNo, itemCount )
	local	self	= inven
	for ii = 0, self.config.slotCount -1 do
		local	slot	= self.slots[ii]
		if	( slotNo == slot._slotNo )	then
			inven.slotEtcData[ii].isFirstItem = true	
		end
	end
	
	-- ♬ 돈일 경우 짤랑짤랑 소리를 내도록 하자
	if ( itemKey == 1 ) then
		audioPostEvent_SystemUi(03,12)
	elseif ( itemKey == 2 ) then
		audioPostEvent_SystemUi(03,12)
	end
end

function	Inventory_SetShowWithFilter( actorType )
	-- 인터렉션을 통하여 인벤토리를 열었음으로 타겟은 플레이어가 아니다.
	Inventory_SetShow( true )
	
	if	(CppEnums.ActorType.ActorType_Player == actorType ) or (CppEnums.ActorType.ActorType_Deadbody == actorType)	then
		Inventory_SetFunctor( InvenFiler_InterActionDead, Inventory_UseItemTarget, InventoryWindow_Close, nil )
	elseif	(CppEnums.ActorType.ActorType_Vehicle == actorType )	then
		Inventory_SetFunctor( InvenFiler_InterActionFodder, Inventory_UseItemTarget, InventoryWindow_Close, nil )
	
	elseif	(CppEnums.ActorType.ActorType_Npc == actorType)	then
		Inventory_SetFunctor( InvenFiler_InterActionFuel, Inventory_UseFuelItem, InventoryWindow_Close, nil )		
	end
end

function	Inventory_UseItemTargetSelf( whereType, slotNo, equipSlotNo )
	if( restrictedActionForUseItem() )then
		Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_CANT_USEITEM" ) )
		return 
	end

	local	isTargetSelfPlayer	= true
	
	-- 길찾기 아이템 우클릭 시 효과음 출력. 조건이 없어 일단 아이템키로 비교
	local currentWhereType	= Inventory_GetCurrentInventoryType()
	local itemWrapper	= getInventoryItemByType( currentWhereType, slotNo )
	if nil == itemWrapper then
		return
	end
	local itemKey		= itemWrapper:get():getKey():getItemKey()

	if ( 41548 <= itemKey and 41570 >= itemKey ) or ( 42000 <= itemKey and 42010 >= itemKey ) or ( 42034 <= itemKey and 42040 >= itemKey )
		or ( 42053 == itemKey ) or ( 42054 == itemKey ) then
			audioPostEvent_SystemUi(00,14)
	end
	inventoryUseItem( whereType, slotNo, equipSlotNo, isTargetSelfPlayer )
	if (42000 == itemKey or 42001 == itemKey) and Panel_Tutorial:GetShow() then
		isFirstSummonItemUse = true
	end
end

function FGlobal_FirstSummonItemUse()
	return isFirstSummonItemUse
end

function	Inventory_UseItemTarget( slotNo, itemWrapper, count_s64, inventoryType )
	if( restrictedActionForUseItem() )then
		Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_CANT_USEITEM" ) )
		return
	end

	local	isTargetSelfPlayer	= false
	inventoryUseItem( inventoryType, slotNo, isTargetSelfPlayer )
end

function	InvenFiler_InterActionDead( slotNo, itemWrapper )
	if nil == itemWrapper then
		return true
	end
	
	return( itemWrapper:getStaticStatus():get():isItemTargetAlive() or (not itemWrapper:checkConditions()) )
end

function	InvenFiler_InterActionSkill( slotNo, itemWrapper )
	if nil == itemWrapper then
		return true
	end
	
	return( (not itemWrapper:getStaticStatus():get():isItemSkill()) or (not itemWrapper:checkConditions()) )
	--return(not itemWrapper:getStaticStatus():get():isItemInterAction())
end

function	InvenFiler_InterActionFodder( slotNo, itemWrapper )
	if nil == itemWrapper then
		return true
	end
	
	return( (not itemWrapper:getStaticStatus():get():isUseToVehicle()) or (not itemWrapper:checkConditions()) )
	--return(not itemWrapper:getStaticStatus():get():isItemInterAction())
end

function	InvenFiler_InterActionFuel( slotNo, itemWrapper )
	if nil == itemWrapper then
		return true
	end
	
	return( not isFusionItem( Inventory_GetCurrentInventoryType(), slotNo ) )
end

function	Inventory_UseFuelItem( slotNo, itemWrapper, count_s64, inventoryType )

	----------- check
	--if( -1 == burnItemTime  ) then
		burnItemToActor( inventoryType, slotNo, 1, false )
	--	burnItemTime = 0;
	--else
	--	Proc_ShowMessage_Ack( "잠시후에 다시 태우세요" );					
	--end

end

-- 이 액션 상태일 경우 아이템 사용을 못한다.
function 	restrictedActionForUseItem( )
	local isRestricted = checkManufactureAction() or checkAlchemyAction()
	return isRestricted
end


function Inventory_SetShow( isInvenShow )
	local self = inven
	isFirstTab = true
	if	not isInvenShow	then
		InventoryWindow_Close()
		Panel_Tooltip_Item_hideTooltip()
		FGlobal_Tutorial_QuestMasking_Hide()
	else
		if Panel_Manufacture:GetShow() then
			self.radioButtonCashInven:SetIgnore(true)
			self.radioButtonCashInven:SetMonoTone(true)
		else
			self.radioButtonCashInven:SetIgnore(false)
			self.radioButtonCashInven:SetMonoTone(false)
		end
		InventoryWindow_Show()
	end
end

function inven:registMessageHandler()
	--registerEvent("EventCharacterInfoUpdate",				"Inventory_updateSlotData")
	registerEvent("FromClient_WeightChanged",				"Inventory_updateSlotData")
	registerEvent("FromClient_InventoryUpdate",				"Inventory_updateSlotData")
	registerEvent("EventInventorySetShow",					"Inventory_SetShow")
	registerEvent("EventInventorySetShowWithFilter",		"Inventory_SetShowWithFilter")
	registerEvent("EventAddItemToInventory",				"Inventory_AddItem")
	registerEvent("EventUnEquipItemToInventory",			"Inventory_UnequipItem")
	registerEvent("FromClient_UseItemAskFromOtherPlayer",	"UseItemAskFromOtherPlayer")
	registerEvent("onScreenResize", 						"Inventory_RePosition")
	registerEvent("FromClient_FindExchangeItemNPC",			"FromClient_FindExchangeItemNPC")
end

function Inventory_RePosition()
	local scrSizeX = getScreenSizeX()
	local scrSizeY = getScreenSizeY()
	local invenSizeX = Panel_Window_Inventory:GetSizeX()
	local invenSizeY = Panel_Window_Inventory:GetSizeY()
	Panel_Window_Inventory:SetPosX( scrSizeX - invenSizeX )
	Panel_Window_Inventory:SetPosY( (scrSizeY - invenSizeY ) / 2 )
	
	
	inven.orgPosX 	= Panel_Window_Inventory:GetPosX()
	inven.orgPosY 	= Panel_Window_Inventory:GetPosY()
end

-- cashTab Scroll
function	Inventory_GetStartIndex()
	local	self	= inven
	return( self.startSlotIndex )
end

function	Inventory_CashTabScroll( isUp )
	local	self				= inven
	local	useStartSlot= inventorySlotNoUserStart()
	local	inventory	= Inventory_GetCurrentInventory()
	local	maxSize		= inventory:sizeXXX() - useStartSlot
	
	self.startSlotIndex	= UIScroll.ScrollEvent( self._scroll, isUp, self.config.slotRows, maxSize, self.startSlotIndex, self.config.slotCols )
	
	Inventory_updateSlotData()
end


-- filterFunction 의 함수 원형은 다음과 같습니다.
-- bool filterFunction( gc::TInventorySlotNo, ge::Wrapper::ItemWrapper )
-- rClickFunction 의 함수 원형은 다음과 같습니다.
-- void rClickFunction( gc::TInventorySlotNo, ge::Wrapper::ItemWrapper, gc::TStackCount )
-- otherWindowOpenFunction 의 함수 원형은 다음과 같습니다.
-- void otherWindowOpenFunction( )
-- if return true then slot will be grayscale and disable.
function Inventory_SetFunctor( filterFunction, rClickFunction, otherWindowOpenFunction, effect )
	local self = inven
	
	if (nil ~= self.otherWindowOpenFunc) and (nil ~= otherWindowOpenFunction) then 
		local otherWindowOpenFuncDiff = (otherWindowOpenFunction ~= self.otherWindowOpenFunc)
		if otherWindowOpenFuncDiff and (nil ~= filterFunction or nil ~= rClickFunction or nil ~= otherWindowOpenFunction) then
			self.otherWindowOpenFunc()
		end
	end

	if (nil ~= filterFunction) and ('function' ~= type(filterFunction)) then
		filterFunction = nil
		UI.ASSERT( false, 'Param 1 must be Function type' )
	end

	if (nil ~= rClickFunction) and ('function' ~= type(rClickFunction)) then
		rClickFunction = nil
		UI.ASSERT( false, 'Param 1 must be Function type' )
	end
	
	if (nil ~= effect) and ('function' ~= type(effect)) then
		effect = nil
		UI.ASSERT( false, 'Param 1 must be Function type' )
	end

	self.otherWindowOpenFunc= otherWindowOpenFunction
	self.rClickFunc			= rClickFunction
	self.filterFunc			= filterFunction
	self.effect				= effect

	if Panel_Window_Inventory:GetShow() then
		Inventory_updateSlotData()
	end
end

-- 드래그 된 것이 있으면 처리한다.
function	Inventory_DropHandler( index )
	local	self	= inven
	local	slotNo	= self.slots[index]._slotNo
	
	if nil == DragManager.dragStartPanel then
		return(false)
	end
	
	if( restrictedActionForUseItem() )then
		Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_CANT_REPOSITIONITEM" ))
		return(false)
	end
	
	-- 특정 UI 가 열려있을때 아이템의 위치가 변경되면 안된다.
	if( Panel_Window_Exchange:IsShow()  
		or Panel_Manufacture:IsShow() 
		or Panel_Alchemy:IsShow()
		or Panel_Win_System:IsShow()
		) then
		DragManager:clearInfo()
		Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_CANT_REPOSITIONITEM_WHILE_UI" ))
		return(false);
	end

	local	fromSlotNo		= DragManager.dragSlotInfo
	
	--if nil ~= DragManager.dragStartPanel and Panel_QuickSlot ~= DragManager.dragStartPanel and Panel_Window_Skill ~= DragManager.dragStartPanel then
	if	(Panel_Window_Inventory == DragManager.dragStartPanel )	then
		if(DragManager.dragWhereTypeInfo == Inventory_GetCurrentInventoryType()) then
			inventory_swapItem(Inventory_GetCurrentInventoryType(), DragManager.dragSlotInfo, slotNo)
		end
		DragManager:clearInfo()
	else
		return( DragManager:itemDragMove( CppEnums.MoveItemToType.Type_Player, getSelfPlayer():getActorKey() ) )
	end

	return(true)
end

function	Inventory_UnequipItem( whereType, slotNo )
	local	self			= inven
	
	local	itemWrapper		= getInventoryItemByType( whereType, slotNo )
	if( nil == itemWrapper )	then
		return
	end
	
	local	itemStatic	= itemWrapper:getStaticStatus():get()
	if( nil == itemStatic )	then
		return
	end
	
	for ii = 0, self.config.slotCount -1 do
		local	slot	= self.slots[ii]
		if	( slotNo == slot._slotNo )	then
			slot.background:AddEffect("fUI_Item_Clear", false, 0, 0)
		end
	end
	
	audioPostEvent_SystemUi(02,00)
end

--[[ 여기서부터 실행되는 코드 영역 ]]
-- 초기화
inven:init()
inven:createSlot()
inven:registEventHandler()
inven:registMessageHandler()

function	Inven_FindPuzzle()
	local	self		= inven
	for _, value in pairs( inven.slotEtcData ) do
		value.puzzleControl:SetShow(false)
	end
	
	-- 정렬이 아닐때만 아이템 퍼즐이벤트롤 보여주고 사용 할 수 있다.
	--{
		if self.checkButton_Sort:IsCheck() then
			return
		end
	--}
		
	-- slot.icon:EraseAllEffect()
	local	whereType	= Inventory_GetCurrentInventoryType()
	local	isFind		= findPuzzleAndReadyMake(whereType)
	local	useSlotNo	= inventorySlotNoUserStart()
	if	(not isFind )	then
		return
	end

	-- 슬롯 아이콘 이펙트
	--{
		local	count	= getPuzzleSlotCount()
		for ii = 0, count-1 do
			local slotNo= getPuzzleSlotAt(ii)
			for jj = 0, self.config.slotCount -1 do
				local	slot	= self.slots[jj]
				if	( slotNo == slot._slotNo )	then
					slot.icon:AddEffect("UI_Item_MineCraft", true, 0, 0)
				end
			end
		end
	--}

	-- 버튼 출력.
	--{
		local	slotNumber	= getPuzzleSlotAt(0)
		for ii = 0, self.config.slotCount -1 do
			local	slot	= self.slots[ii]
			if	( slotNumber == slot._slotNo )	then
				self.slotEtcData[ii].puzzleControl:SetShow(true)
			end
		end
	--}
end

function PuzzleButton_Over(slotIndex)
	local self	= inven
	local slot	= self.slots[slotIndex]
	Panel_Tooltip_Item_hideTooltip()
	_puzzleNoticeText:SetTextMode( UI_TM.eTextMode_AutoWrap )
	_puzzleNoticeText:SetAutoResize( true )
	_puzzleMessage = PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_DOPUZZLE" ) -- "버튼을 클릭하면 합성을 할 수 있습니다."
	_puzzleNoticeText:SetText(_questListMessage)
	_puzzleNotice:SetPosX(slot.icon:GetPosX() - _puzzleNotice:GetSizeX())
	_puzzleNotice:SetPosY(slot.icon:GetPosY() - 20)
	_puzzleNotice:SetSize(_puzzleNotice:GetSizeX(),_puzzleNoticeText:GetSizeY() + 10)
	_puzzleNotice:SetColor(Defines.Color.C_FF000000)
	_puzzleNotice:ComputePos()
	_puzzleNotice:SetShow(true)
end
function PuzzleButton_Out(slotIndex)
	_puzzleNotice:SetShow(false)
end

function	MakePuzzle( index )
	local	self	= inven
	self.slotEtcData[index].puzzleControl:SetShow(false)
	_puzzleNotice:SetShow(false)
	requestMakePuzzle()
end

function	UseItemAskFromOtherPlayer( fromName )
	local messageboxMemo	= "[<PAColor0xFFE49800>" .. fromName .. PAGetString( Defines.StringSheet_GAME, "LUA_USEITEM_MESSAGEBOX_REQUEST" )	--"님이 아이템을 사용하였습니다. 수락하시겠습니까?"
	local messageboxData	= { title = PAGetString( Defines.StringSheet_GAME, "LUA_USEITEM_MESSAGEBOX_TITLE"), content = messageboxMemo, functionYes = UseItemFromOtherPlayer_Yes, functionCancel = UseItemFromOtherPlayer_No, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
	MessageBox.showMessageBox(messageboxData)
end

function	UseItemFromOtherPlayer_Yes()
	useItemFromOtherPlayer( true )
end

function	UseItemFromOtherPlayer_No()
	useItemFromOtherPlayer( false )
end

function Inventory_FilterRadioTooltip_Show( isShow, target )
	local self = inven
	if true == isShow then
		if FilterRadioTooltip:GetShow() then
			FilterRadioTooltip:SetShow( false )
		end
		local control = nil
		if 0 == target then
			control = self.radioButtonStd
			FilterRadioTooltip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_FILTERTOOLTIP_ALL") ) -- "모든 아이템이 활성화되어 있는 기본 필터링"
		elseif 1 == target then
			control = self.radioButtonTransport
			FilterRadioTooltip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_FILTERTOOLTIP_TRADE") ) -- "무역 아이템을 제외하고, 회색으로 필터링"
		elseif 2 == target then
			control = self.radioButtonHousing
			FilterRadioTooltip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_FILTERTOOLTIP_HOUSING") ) -- "하우징 관련 아이템을 제외하고, 회색으로 필터링"
		end

		FilterRadioTooltip:SetPosX( control:GetPosX() - FilterRadioTooltip:GetSizeX() )
		FilterRadioTooltip:SetPosY( control:GetPosY() - FilterRadioTooltip:GetTextSizeY() )
		FilterRadioTooltip:SetShow( true )
	else
		FilterRadioTooltip:SetShow( false )
	end
end

-- 모드 변경에 따른 위치 변경 사항을 저장한다.
local panel_tmpPosX = 0
local panel_tmpPosY = 0
function Inventory_PosSaveMemory()
	panel_tmpPosX = Panel_Window_Inventory:GetPosX()
	panel_tmpPosY = Panel_Window_Inventory:GetPosY()
end
function Inventory_PosLoadMemory()
	Panel_Window_Inventory:SetPosX(panel_tmpPosX)
	Panel_Window_Inventory:SetPosY(panel_tmpPosY)
end

Inventory_RePosition()
------------------------------------------------------------
-- 					실버 버튼 막는 함수
------------------------------------------------------------
function Inventory_SetIgnoreMoneyButton( setIgnore )
	local	self	= inven
	
	if ( setIgnore == true ) and (not Panel_Window_Warehouse:GetShow())then
		self.buttonMoney:SetIgnore( true )
		--self.buttonMoney:SetColor( UI_color.C_FFD20000 )
		--self.buttonMoney:SetFontColor( UI_color.C_FFF26A6A )
			-- _PA_LOG("LUA", "여기가 버튼 막는 곳")
	else
		self.buttonMoney:SetIgnore( false )
		--self.buttonMoney:SetColor( UI_color.C_FFFFFFFF )
		--self.buttonMoney:SetFontColor( UI_color.C_FFDCD489 )
			-- _PA_LOG("LUA", "버튼 다시 풀어주기")
	end
end

function Inventory_ManufactureBTN()
	if ( MiniGame_Manual_Value_FishingStart == true ) then
		return
	else
		if not IsSelfPlayerWaitAction() then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_MANUFACTURE") )
			return
		end
		
		if Panel_Manufacture ~= nil and Panel_Window_Inventory ~= nil and Panel_Equipment ~= nil then
			-- UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
			-- 인벤의 필터가 상호작용하는 UI에 따라 동작하려면 인벤토리를 먼저 열어주어야합니다.
			local isInvenOpen = Panel_Window_Inventory:GetShow()
			local isManufactureOpen = Panel_Manufacture:GetShow()
			if isManufactureOpen == false or isInvenOpen == false then
				-- ♬ 창 켤 때 소리난다요
				audioPostEvent_SystemUi(01,26)
				Manufacture_Show( nil, CppEnums.ItemWhereType.eInventory, true, true )
				if Panel_Manufacture:GetShow() then
					Panel_Equipment:SetShow( false )
				end
			-- else
			-- 	-- ♬ 창 끌 때 소리난다요
			-- 	audioPostEvent_SystemUi(01,25)
			-- 	Manufacture_Close( true )
			-- 	-- if false == check_ShowWindow() then
			-- 	-- 	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
			-- 	-- end
			end
		end
		return
	end
end

-- function FGlobal_RecentCookItemCheck( itemKey, itemCount )
-- 	local self = inven
-- 	local saveInfo = {}
-- 	local	useStartSlot	= inventorySlotNoUserStart()
-- 	local returnSlotNo = nil
-- 	for i=0, self.config.slotCount -1 do
-- 		local slotNo = i + useStartSlot
-- 		local itemWrapper		= getInventoryItemByType( CppEnums.ItemWhereType.eInventory, slotNo )
-- 		if nil ~= itemWrapper then
-- 			local itemSSW = itemWrapper:getStaticStatus()
-- 			local invenItemKey = itemSSW:get()._key:getItemKey()
-- 			-- _PA_LOG("정태곤", "itemKey : " .. tostring(itemKey) .. " / invenItemKey : " .. tostring(invenItemKey))
-- 			if itemKey == invenItemKey then
-- 				saveInfo.slotNo = slotNo
-- 				returnSlotNo = slotNo
-- 			end
-- 		end
-- 	end
-- 	return returnSlotNo
-- end

function inventory_FlushRestoreFunc()
	btn_Manufacture			:SetEnable( true )
	btn_Manufacture			:SetMonoTone( false )
	btn_AlchemyStone		:SetEnable( true )
	btn_AlchemyStone		:SetMonoTone( false )
	btn_AlchemyFigureHead	:SetEnable( true )
	btn_AlchemyFigureHead	:SetMonoTone( false )
	btn_DyePalette			:SetEnable( true )
	btn_DyePalette			:SetMonoTone( false )
end
UI.addRunPostRestorFunction(inventory_FlushRestoreFunc)

-- Inventory_SetFunctor( nil, nil, nil, nil )

-- function Mapae_SetEffect( effect )
-- 	local self = inven
-- 	self.effect = effect 		--  이펙트 이름 세팅
-- end
