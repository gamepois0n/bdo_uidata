Panel_AlchemyStone:SetShow( false )

local AlchemyStone = {
	control = {
		tab_Charge		= UI.getChildControl( Panel_AlchemyStone, "RadioButton_Tab_Charge" ),
		tab_Exp			= UI.getChildControl( Panel_AlchemyStone, "RadioButton_Tab_Exp" ),
		tab_Upgrade		= UI.getChildControl( Panel_AlchemyStone, "RadioButton_Tab_Upgrade" ),

		contentBG		= UI.getChildControl( Panel_AlchemyStone, "Static_ContentTypeBG" ),
		contentEffect	= UI.getChildControl( Panel_AlchemyStone, "Static_ContentTypeEffect" ),
		guideString		= UI.getChildControl( Panel_AlchemyStone, "Static_GuideText" ),

		btn_Close		= UI.getChildControl( Panel_AlchemyStone, "Button_Win_Close" ),
		btn_Doit		= UI.getChildControl( Panel_AlchemyStone, "Button_Doit" ),

		Slot_1			= UI.getChildControl( Panel_AlchemyStone, "Static_Slot_1" ),
		Slot_2			= UI.getChildControl( Panel_AlchemyStone, "Static_Slot_2" ),

		needCount		= UI.getChildControl( Panel_AlchemyStone, "Static_NeedCount" ),
		btn_Plus		= UI.getChildControl( Panel_AlchemyStone, "Button_CountPlus" ),
		btn_Minus		= UI.getChildControl( Panel_AlchemyStone, "Button_CountMinus" ),
		
		descBg			= UI.getChildControl( Panel_AlchemyStone, "Static_DescBg" ),
		desc			= UI.getChildControl( Panel_AlchemyStone, "StaticText_Desc" ),
	},

	slotConfig = {
		createIcon		= true,
		createBorder	= true,
		createCount		= true,
		createCash		= true
	},

	Stuff_slot			= {},
	Stone_slot			= {},

	selectedTabIdx		= 0,
	selectedStoneType	= 0,
	selectedStoneItemKey= nil,

	fromWhereType		= -1,
	fromSlotNo			= -1,
	fromCount			= toInt64(0,-1),
	fromMaxCount		= toInt64(0,-1),
	toWhereType			= -1,
	toSlotNo			= -1,

	toLostEndurance		= 0,
	recoverCount		= 0,
	maxRecoverCount		= 0,
	chargePoint			= 0,

	isPushDoit			= false,
	doItType			= -1,
	startEffectPlay		= false,
	contentEffectPlay	= false,
	slotEffectPlay		= false,
	effectEnd			= false,
	resultMsg			= {},
}

local 	_buttonQuestion	= UI.getChildControl( Panel_AlchemyStone, "Button_Question" )							-- 물음표 버튼
	_buttonQuestion:	addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"AlchemyStone\" )" )			-- 물음표 좌클릭
	_buttonQuestion:	addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"AlchemyStone\", \"true\")" )	-- 물음표 마우스오버
	_buttonQuestion:	addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"AlchemyStone\", \"false\")" )	-- 물음표 마우스아웃

local AlchemyStoneTab = {
	Charge	= 0,
	Exp		= 1,
	Upgrade	= 2,
}

local AlchemyStoneTabTexture = {
	[AlchemyStoneTab.Charge]	= { 
		bg		= "New_UI_Common_forLua/Window/AlchemyStone/AlchemyStone_Charge_BG.dds", 
		effect	= "New_UI_Common_forLua/Window/ChangeItem/ChangeItem_Effect1.dds"
	},
	[AlchemyStoneTab.Exp]		= { 
		bg		= "New_UI_Common_forLua/Window/AlchemyStone/AlchemyStone_Exp_BG.dds", 
		effect	= "New_UI_Common_forLua/Window/AlchemyStone/AlchemyStone_Exp_Effect.dds"
	},
	[AlchemyStoneTab.Upgrade]	= { 
		bg		= "New_UI_Common_forLua/Window/AlchemyStone/AlchemyStone_Upgrade_BG.dds", 
		effect	= "New_UI_Common_forLua/Window/AlchemyStone/AlchemyStone_Upgrade_Effect.dds"
	},
}

local alchemyStoneDesc =
{
	[AlchemyStoneTab.Charge] = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_DESC_1"),	-- "※ 재료 아이템으로 연금석의 소모 횟수를 충전합니다.\n※ 충전 재료 : 오일류, 혈액류, 시약류",
	[AlchemyStoneTab.Exp] = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_DESC_2"),	-- "※ 재료 아이템으로 연금석의 경험치를 올립니다.\n※ 연금석에 따라 필요 재료가 달라집니다.",
	[AlchemyStoneTab.Upgrade] = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_DESC_3"),	-- "※ 경험치 80%부터 성장 시도가 가능하며, 경험치가 많을수록 성장 확률이 오릅니다.\n※ 성장 실패 시 연금석 등급에 따라 경험치 감소, 등급 하락, 연금석 파괴 등의 페널티가 적용됩니다."
}
local panelSizeY	= Panel_AlchemyStone:GetSizeY()
local bgSizeY		= AlchemyStone.control.descBg:GetSizeY()
local textSizeY		= AlchemyStone.control.desc:GetTextSizeY()
AlchemyStone.control.desc:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )

function AlchemyStone:Init()
	-- 슬롯 세팅
	SlotItem.new( self.Stuff_slot, 'AlchemyStone_Stuff', 0, self.control.Slot_1, self.slotConfig )
	self.Stuff_slot:createChild()
	self.Stuff_slot.Empty = true
	self.Stuff_slot.icon:addInputEvent( "Mouse_RUp", "HandleClicked_AlchemyStone_UnSetSlot(" .. 1 .. ")" )

	SlotItem.new( self.Stone_slot, 'AlchemyStone_Stone', 0, self.control.Slot_2, self.slotConfig )
	self.Stone_slot:createChild()
	self.Stone_slot.Empty = true
	self.Stone_slot.icon:addInputEvent( "Mouse_RUp", "HandleClicked_AlchemyStone_UnSetSlot(" .. 0 .. ")" )

	-- 기본 선택 탭
	self.control.tab_Charge		:SetCheck( true )
	self.control.tab_Exp		:SetCheck( false )
	self.control.tab_Upgrade	:SetCheck( false )

	local btnChargeSizeX			= self.control.tab_Charge:GetSizeX()+23
	local btnChargeTextPosX			= (btnChargeSizeX - (btnChargeSizeX/2) - ( self.control.tab_Charge:GetTextSizeX() / 2 ))
	local btnExpSizeX				= self.control.tab_Exp:GetSizeX()+23
	local btnExpTextPosX			= (btnExpSizeX - (btnExpSizeX/2) - ( self.control.tab_Exp:GetTextSizeX() / 2 ))
	local btnUpgradeSizeX			= self.control.tab_Upgrade:GetSizeX()+23
	local btnUpgradeTextPosX		= (btnUpgradeSizeX - (btnUpgradeSizeX/2) - ( self.control.tab_Upgrade:GetTextSizeX() / 2 ))

	self.control.tab_Charge		:SetTextSpan( btnChargeTextPosX, 5 )
	self.control.tab_Exp		:SetTextSpan( btnExpTextPosX, 5 )
	self.control.tab_Upgrade	:SetTextSpan( btnUpgradeTextPosX, 5 )

	-- 컨텐츠 BG 텍스처 지정
	self.control.contentBG		:ChangeTextureInfoName( AlchemyStoneTabTexture[0].bg )	-- 텍스쳐 변경

	self.control.contentEffect	:SetShow( false )

	-- 기본 가이드 텍스트
end

function AlchemyStone:registEventHandler()
	self.control.tab_Charge		:addInputEvent( "Mouse_LUp", "HandleClicked_AlchemyStoneTab( " .. AlchemyStoneTab.Charge .. " )" )
	self.control.tab_Exp		:addInputEvent( "Mouse_LUp", "HandleClicked_AlchemyStoneTab( " .. AlchemyStoneTab.Exp .. " )" )
	self.control.tab_Upgrade	:addInputEvent( "Mouse_LUp", "HandleClicked_AlchemyStoneTab( " .. AlchemyStoneTab.Upgrade .. " )" )

	self.control.tab_Charge		:addInputEvent( "Mouse_On", "HandleClicked_AlchemyStoneTab_Tooltip( true, " .. AlchemyStoneTab.Charge .. " )" )
	self.control.tab_Charge		:addInputEvent( "Mouse_Out", "HandleClicked_AlchemyStoneTab_Tooltip( false, " .. AlchemyStoneTab.Charge .. " )" )
	self.control.tab_Charge		:setTooltipEventRegistFunc( "HandleClicked_AlchemyStoneTab_Tooltip( true, " .. AlchemyStoneTab.Charge .. " )" )
	self.control.tab_Exp		:addInputEvent( "Mouse_On", "HandleClicked_AlchemyStoneTab_Tooltip( true, " .. AlchemyStoneTab.Exp .. " )" )
	self.control.tab_Exp		:addInputEvent( "Mouse_Out", "HandleClicked_AlchemyStoneTab_Tooltip( false, " .. AlchemyStoneTab.Exp .. " )" )
	self.control.tab_Exp		:setTooltipEventRegistFunc( "HandleClicked_AlchemyStoneTab_Tooltip( true, " .. AlchemyStoneTab.Exp .. " )" )
	self.control.tab_Upgrade	:addInputEvent( "Mouse_On", "HandleClicked_AlchemyStoneTab_Tooltip( true, " .. AlchemyStoneTab.Upgrade .. " )" )
	self.control.tab_Upgrade	:addInputEvent( "Mouse_Out", "HandleClicked_AlchemyStoneTab_Tooltip( false, " .. AlchemyStoneTab.Upgrade .. " )" )
	self.control.tab_Upgrade	:setTooltipEventRegistFunc( "HandleClicked_AlchemyStoneTab_Tooltip( true, " .. AlchemyStoneTab.Upgrade .. " )" )

	self.control.btn_Plus		:addInputEvent( "Mouse_LUp", "HandleClicked_AlchemyStone_ChangeStuffCount( true )" )
	self.control.btn_Minus		:addInputEvent( "Mouse_LUp", "HandleClicked_AlchemyStone_ChangeStuffCount( false )" )

	self.control.btn_Doit		:addInputEvent( "Mouse_LUp", "HandleClicked_AlchemyStone_Doit()" )
	self.control.btn_Close		:addInputEvent( "Mouse_LUp", "HandleClicked_AlchemyStone_Close()" )
end

function AlchemyStone:registMessageHandler()
	registerEvent( "onScreenResize",						"AlchemyStone_onScreenResize" )
	registerEvent( "FromClient_ItemUpgrade", 				"FromClient_ItemUpgrade" )					-- 
	registerEvent( "FromClient_StoneChange", 				"FromClient_StoneChange" )					-- 성장 성공
	registerEvent( "FromClient_StoneChangeFailedByDown", 	"FromClient_StoneChangeFailedByDown" )		-- 성장 실패
	registerEvent( "FromClient_AlchemyEvolve", 				"FromClient_AlchemyEvolve" )				-- 성장 결과 전달용
	registerEvent( "FromClient_AlchemyRepair", 				"FromClient_AlchemyRepair" )				-- 충전 결과 전달용
	
	Panel_AlchemyStone:RegisterUpdateFunc("Panel_AlchemyStone_updateTime")
end

function AlchemyStone:ClearData( isOpenStep )
	if true == isOpenStep then
		self.resultMsg			= {}
	end

	self.toWhereType			= -1
	self.toSlotNo				= -1
	self.fromWhereType			= -1
	self.fromSlotNo				= -1
	self.fromCount				= toInt64(0,-1)
	self.fromMaxCount			= toInt64(0,-1)
	self.selectedStoneType		= -1
	self.selectedStoneItemKey	= nil
	self.toLostEndurance		= 0
	self.recoverCount			= 0
	self.maxRecoverCount		= 0
	self.chargePoint			= 0

	self.isPushDoit			= false
	self.startEffectPlay	= false
	self.contentEffectPlay	= false
	self.slotEffectPlay		= false
	self.effectEnd			= false

	self.Stuff_slot.icon		:EraseAllEffect()
	self.control.contentEffect	:EraseAllEffect()
	self.Stone_slot.icon		:EraseAllEffect()

	self.control.btn_Doit		:SetMonoTone( not self.isPushDoit )
	self.control.btn_Doit		:SetEnable( self.isPushDoit )

	self.Stuff_slot				:clearItem()	-- 슬롯을 초기화 한다.
	self.Stone_slot				:clearItem()	-- 슬롯을 초기화 한다.
	self.Stuff_slot.Empty 		= true
	self.Stone_slot.Empty 		= true

	self.control.contentEffect	:SetShow( false )

	local guideKeyword = ""
	local guideText = ""
	if AlchemyStoneTab.Charge == self.selectedTabIdx then
		guideKeyword = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_CHARGE")	-- 충전
		guideText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_SELECT", "guideKeyword", guideKeyword)	-- 가방에서 {guideKeyword}시킬 연금석을 선택해주세요.
	elseif AlchemyStoneTab.Exp == self.selectedTabIdx then
		guideKeyword = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_EXP")	-- 연마
		guideText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_SELECT", "guideKeyword", guideKeyword)	-- 가방에서 {guideKeyword}시킬 연금석을 선택해주세요.
	elseif AlchemyStoneTab.Upgrade == self.selectedTabIdx then
		guideKeyword = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_UPGRADE")	-- 성장
		guideText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_SELECT", "guideKeyword", guideKeyword)	-- 가방에서 {guideKeyword}시킬 연금석을 선택해주세요.
	end

	self.control.guideString	:SetText( guideText )
	self.control.btn_Doit		:SetText( guideKeyword )

	local btnDoitSizeX			= self.control.btn_Doit:GetSizeX()+23
	local btnDoitTextPosX		= (btnDoitSizeX - (btnDoitSizeX/2) - ( self.control.btn_Doit:GetTextSizeX() / 2 ))
	self.control.btn_Doit		:SetTextSpan( btnDoitTextPosX, 5 )

	self.control.needCount	:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_NEEDMAXCHARGECOUNT", "count", 0) )
end

--------------------------------------------------------------------------------
-- click Event
--------------------------------------------------------------------------------
function HandleClicked_AlchemyStoneTab( tabIdx )
	AlchemyStone.toWhereType			= -1
	AlchemyStone.toSlotNo				= -1
	AlchemyStone.fromWhereType			= -1
	AlchemyStone.fromSlotNo				= -1
	AlchemyStone.fromCount				= toInt64(0,-1)
	AlchemyStone.fromMaxCount			= toInt64(0,-1)
	AlchemyStone.selectedStoneType		= -1
	AlchemyStone.selectedStoneItemKey	= nil
	AlchemyStone.toLostEndurance		= 0
	AlchemyStone.recoverCount			= 0
	AlchemyStone.maxRecoverCount		= 0
	AlchemyStone.chargePoint			= 0

	AlchemyStone.Stone_slot		:clearItem()	-- 슬롯을 초기화 한다.
	AlchemyStone.Stuff_slot		:clearItem()	-- 슬롯을 초기화 한다.
	AlchemyStone.Stone_slot.Empty = true
	AlchemyStone.Stuff_slot.Empty = true

	AlchemyStone.Stone_slot.icon:addInputEvent( "Mouse_On",		"" )
	AlchemyStone.Stone_slot.icon:addInputEvent( "Mouse_Out",	"" )
	AlchemyStone.Stuff_slot.icon:addInputEvent( "Mouse_On",		"" )
	AlchemyStone.Stuff_slot.icon:addInputEvent( "Mouse_Out",	"" )

	AlchemyStone.control.contentBG		:ChangeTextureInfoName( AlchemyStoneTabTexture[tabIdx].bg )		-- 텍스쳐 변경

	AlchemyStone.selectedTabIdx	= tabIdx

	doItType							= -1	-- 탭 버튼 누르면 저장된 시작 값 초기화
	AlchemyStone.isPushDoit				= false	-- 탭 버튼 누르면, 진행 중인 작업이 취소.
	AlchemyStone.Stuff_slot.icon		:EraseAllEffect()
	AlchemyStone.control.contentEffect	:EraseAllEffect()
	AlchemyStone.Stone_slot.icon		:EraseAllEffect()

	Inventory_SetFunctor( AlchemyStone_StoneFilter, AlchemyStone_StoneRfunction, nil, nil )

	AlchemyStone.control.needCount	:SetShow( false )
	AlchemyStone.control.btn_Plus	:SetShow( false )
	AlchemyStone.control.btn_Minus	:SetShow( false )

	local guideKeyword = ""
	local guideText = ""
	if AlchemyStoneTab.Charge == tabIdx then
		guideKeyword = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_CHARGE")	-- 충전
		guideText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_SELECT", "guideKeyword", guideKeyword)	-- 가방에서 {guideKeyword}시킬 연금석을 선택해주세요.
		AlchemyStone.control.needCount	:SetShow( true )
		AlchemyStone.control.btn_Plus	:SetShow( true )
		AlchemyStone.control.btn_Minus	:SetShow( true )

		AlchemyStone.control.needCount	:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_NEEDMAXCHARGECOUNT", "count", 0) )

	elseif AlchemyStoneTab.Exp == tabIdx then
		guideKeyword = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_EXP")	-- 연마
		guideText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_SELECT", "guideKeyword", guideKeyword)	-- 가방에서 {guideKeyword}시킬 연금석을 선택해주세요.

	elseif AlchemyStoneTab.Upgrade == tabIdx then
		guideKeyword = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_UPGRADE")	-- 성장
		guideText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_SELECT", "guideKeyword", guideKeyword)	-- 가방에서 {guideKeyword}시킬 연금석을 선택해주세요.

	end

	AlchemyStone.control.guideString:SetText( guideText )
	AlchemyStone.control.btn_Doit:SetText( guideKeyword )

	local btnDoitSizeX			= AlchemyStone.control.btn_Doit:GetSizeX()+23
	local btnDoitTextPosX		= (btnDoitSizeX - (btnDoitSizeX/2) - ( AlchemyStone.control.btn_Doit:GetTextSizeX() / 2 ))
	AlchemyStone.control.btn_Doit		:SetTextSpan( btnDoitTextPosX, 5 )
	
	-- 설명글 사이즈 계산
	AlchemyStone.control.desc:SetText( alchemyStoneDesc[tabIdx] )
	local _descTextSizeY = AlchemyStone.control.desc:GetTextSizeY()
	if 35 < _descTextSizeY then
		Panel_AlchemyStone:SetSize( Panel_AlchemyStone:GetSizeX(), panelSizeY + _descTextSizeY - 34 )
		AlchemyStone.control.descBg:SetSize( AlchemyStone.control.descBg:GetSizeX(), bgSizeY + _descTextSizeY - 34 )
	else
		Panel_AlchemyStone:SetSize( Panel_AlchemyStone:GetSizeX(), panelSizeY )
		AlchemyStone.control.descBg:SetSize( AlchemyStone.control.descBg:GetSizeX(), bgSizeY )
	end
	AlchemyStone.control.btn_Doit:ComputePos()
end

function HandleClicked_AlchemyStone_ChangeStuffCount( isUp )
	if AlchemyStone.fromCount < toInt64(0,1) then
		Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_NOTSETSTUFF" ) )	-- "충전 재료가 정의되지 않았습니다."
		return
	end

	if true == isUp then
		if (toInt64(0,AlchemyStone.maxRecoverCount) <= AlchemyStone.fromCount) then
			Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_MAXCHARGECOUNT" ) )	-- "내구도 복구에 필요한 최대 갯수입니다."
			return
		elseif AlchemyStone.fromMaxCount <= AlchemyStone.fromCount then
			return
		end

		AlchemyStone.fromCount = AlchemyStone.fromCount + toInt64(0,1)
	else
		if AlchemyStone.fromCount <= toInt64(0,1) then
			Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_MUSTMOREONE" ) )	-- "충전 재료의 갯수는 1보다 작을 수 없습니다."
			return
		end

		AlchemyStone.fromCount = AlchemyStone.fromCount - toInt64(0,1)
	end

	AlchemyStone.Stuff_slot.count:SetText( tostring(AlchemyStone.fromCount) )
end

function HandleClicked_AlchemyStoneTab_Tooltip( isOn, buttonType )
	if true == isOn then
		local control = nil
		local name = ""
		local desc = ""
		if AlchemyStoneTab.Charge == buttonType then
			control = AlchemyStone.control.tab_Charge
			name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ALCHEMYSTONE_BTN_CHARGE")	-- "충전"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_RADIO_0_TOOLTIP_DESC")-- "연금석의 내구도를 복구해, 계속 사용할 수 있게 만듭니다."
		elseif AlchemyStoneTab.Exp == buttonType then
			control = AlchemyStone.control.tab_Exp
			name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ALCHEMYSTONE_BTN_EXP")-- "연마"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_RADIO_1_TOOLTIP_DESC")-- "연금석의 경험치를 올려, 다음 등급 혹은 단계로 성장 시킬 수 있는 기회를 만듭니다."
		elseif AlchemyStoneTab.Upgrade == buttonType then
			control = AlchemyStone.control.tab_Upgrade
			name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ALCHEMYSTONE_BTN_UPGRADE")-- "성장"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_RADIO_2_TOOLTIP_DESC")-- "연금석의 다음 단계 혹은 등급 성장을 시도합니다. 성장은 연금석의 경험치가 80% 이상이어야 합니다."
		end
		registTooltipControl(control, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end
function HandleClicked_AlchemyStone_Doit()
	local doUpgrade = function()
		AlchemyStone.isPushDoit	= true											-- 시작 여부 변수 적용
	end

	local itemWrapper			= getInventoryItemByType(AlchemyStone.toWhereType, AlchemyStone.toSlotNo)
	local itemSSW				= itemWrapper:getStaticStatus()
	local itemGrade				= itemSSW:getGradeType()
	local itemContentsParam2	= itemSSW:get()._contentsEventParam2
	local msgTitle				= PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_MSGBOX_TITLE")	-- 알 림
	local msgContent			= ""
	
	if AlchemyStone.selectedTabIdx == AlchemyStoneTab.Upgrade then
		if (3 == itemContentsParam2) or (4 == itemContentsParam2) then
			msgContent = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_MSGBOX_CONTENT1")	-- 실패시 연금석의 등급이 하락할 수 있습니다.\n이대로 진행하시겠습니까?
		elseif (5 == itemContentsParam2) or (6 == itemContentsParam2) then
			msgContent = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_MSGBOX_CONTENT2")	-- 실패시 연금석이 증발될 수 있습니다.\n이대로 진행하시겠습니까?
		elseif (7 == itemContentsParam2) then
			if itemGrade < 3 then
				msgContent = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_MSGBOX_CONTENT2")	-- 실패시 연금석이 증발될 수 있습니다.\n이대로 진행하시겠습니까?
			end
		else
			AlchemyStone.isPushDoit	= true
		end
		
		if "" ~= msgContent then
			local messageBoxData = { title = msgTitle, content = msgContent, functionYes = doUpgrade, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
			MessageBox.showMessageBox(messageBoxData, "middle")	
		end
	else
		AlchemyStone.isPushDoit	= true
	end

	doItType = AlchemyStone.selectedTabIdx									-- 시작 버튼 누를 때, 선택된 탭 기억.
	
	AlchemyStone.control.contentEffect	:SetShow( true )
	
	AlchemyStone.control.btn_Doit		:SetMonoTone( AlchemyStone.isPushDoit )
	AlchemyStone.control.btn_Doit		:SetEnable( not AlchemyStone.isPushDoit )

	audioPostEvent_SystemUi(01,43)
end
function HandleClicked_AlchemyStone_Close()
	Panel_AlchemyStone:SetShow( false )

	AlchemyStone.toWhereType			= -1
	AlchemyStone.toSlotNo				= -1
	AlchemyStone.fromWhereType			= -1
	AlchemyStone.fromSlotNo				= -1
	AlchemyStone.fromCount				= toInt64(0,-1)
	AlchemyStone.fromMaxCount			= toInt64(0,-1)
	AlchemyStone.selectedStoneType		= -1
	AlchemyStone.selectedStoneItemKey	= nil
	AlchemyStone.isPushDoit				= false
	AlchemyStone.toLostEndurance		= 0
	AlchemyStone.recoverCount			= 0
	AlchemyStone.maxRecoverCount		= 0
	AlchemyStone.chargePoint			= 0

	doItType							= -1

	if Panel_Window_Inventory:GetShow() then
		Inventory_SetFunctor( nil, nil, nil, nil )
		Equipment_SetShow(true)
	end
end

function HandleClicked_AlchemyStone_UnSetSlot( slotType )
	if 0 == slotType then
		if false == AlchemyStone.Stone_slot.Empty then
			AlchemyStone.Stone_slot:clearItem()
			AlchemyStone.Stone_slot.Empty = true

			AlchemyStone.Stuff_slot:clearItem()
			AlchemyStone.Stuff_slot.Empty = true
			
			---- 언슬롯 이후 툴팁 안나오게 및 실행버튼 누르지 못하도록
			AlchemyStone.Stone_slot.icon:addInputEvent( "Mouse_On",		"" )
			AlchemyStone.Stone_slot.icon:addInputEvent( "Mouse_Out",	"" )
			AlchemyStone.Stuff_slot.icon:addInputEvent( "Mouse_On",		"" )
			AlchemyStone.Stuff_slot.icon:addInputEvent( "Mouse_Out",	"" )
			AlchemyStone.control.btn_Doit:SetMonoTone( true )
			AlchemyStone.control.btn_Doit:SetEnable( false )
			----------------------------------------------------------
			Inventory_SetFunctor( AlchemyStone_StoneFilter, AlchemyStone_StoneRfunction, nil, nil )

			if Panel_Window_Exchange_Number:GetShow() then
				Panel_NumberPad_ButtonCancel_Mouse_Click()
			end
		end
	else
		if false == AlchemyStone.Stuff_slot.Empty then
			AlchemyStone.Stuff_slot:clearItem()
			AlchemyStone.Stuff_slot.Empty = true
			
			---- 언슬롯 이후 툴팁 안나오게 및 실행버튼 누르지 못하도록
			AlchemyStone.Stuff_slot.icon:addInputEvent( "Mouse_On",		"" )
			AlchemyStone.Stuff_slot.icon:addInputEvent( "Mouse_Out",	"" )
			AlchemyStone.control.btn_Doit:SetMonoTone( true )
			AlchemyStone.control.btn_Doit:SetEnable( false )
			----------------------------------------------------------
			Inventory_SetFunctor( AlchemyStone_StuffFilter, AlchemyStone_StuffRfunction, nil, nil )
		end
	end
	AlchemyStone.control.needCount	:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_NEEDMAXCHARGECOUNT", "count", 0) )
end

function AlchemyStone_ItemToolTip( isShow, slotType )
	if true == isShow then
		local control = nil
		local itemWrapper = nil
		if 0 == slotType then
			control = AlchemyStone.Stone_slot.icon
			if -1 ~= AlchemyStone.toWhereType then
				itemWrapper = getInventoryItemByType( AlchemyStone.toWhereType, AlchemyStone.toSlotNo )
				Panel_Tooltip_Item_Show( itemWrapper, control, false, true, nil, nil, nil )
			else
				return
			end
		else
			control = AlchemyStone.Stuff_slot.icon
			if -1 ~= AlchemyStone.fromWhereType then
				itemWrapper = getInventoryItemByType( AlchemyStone.fromWhereType, AlchemyStone.fromSlotNo )
				Panel_Tooltip_Item_Show( itemWrapper, control, false, true, nil, nil, nil )
			else
				return
			end
		end
	else
		Panel_Tooltip_Item_hideTooltip()
	end
end

--------------------------------------------------------------------------------
-- inventory function
--------------------------------------------------------------------------------
function AlchemyStone_StoneFilter( slotNo, itemWrapper, count, inventoryType )
	local returnValue = true

	if ( nil == itemWrapper:getStaticStatus() ) then
		return returnValue
	end

	if 32 == itemWrapper:getStaticStatus():get():getContentsEventType() then
		returnValue = false
	end

	return returnValue
end
function AlchemyStone_StoneRfunction( slotNo, itemWrapper, count, inventoryType )
	AlchemyStone.toWhereType			= inventoryType
	AlchemyStone.toSlotNo				= slotNo
	AlchemyStone.selectedStoneType		= itemWrapper:getStaticStatus():get()._contentsEventParam1
	AlchemyStone.selectedStoneItemKey	= itemWrapper:get():getKey()
	AlchemyStone.recoverCount			= itemWrapper:getStaticStatus():get():getAlchemyStoneGrade()		-- 충전일 때만, 최대 충전 필요 갯수를 구한다.

	AlchemyStone.Stone_slot:setItem( itemWrapper )
	AlchemyStone.Stone_slot.Empty = false

	local currentEndurance 		= itemWrapper:get():getEndurance()
	local maxEndurance 			= itemWrapper:get():getMaxEndurance()

	AlchemyStone.toLostEndurance	= maxEndurance - currentEndurance	-- 연금석의 소모된 내구도를 구함.

	AlchemyStone.Stone_slot.icon:addInputEvent( "Mouse_On",		"AlchemyStone_ItemToolTip( true, " .. 0 .. " )" )
	AlchemyStone.Stone_slot.icon:addInputEvent( "Mouse_Out",	"AlchemyStone_ItemToolTip( false )" )

	Inventory_SetFunctor( AlchemyStone_StuffFilter, AlchemyStone_StuffRfunction, nil, nil )

	local guideText = ""
	if AlchemyStoneTab.Charge == AlchemyStone.selectedTabIdx then
		guideText = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_SELECT_CHARGE")	-- 가방에서 충전시킬 재료를 선택해주세요.
	elseif AlchemyStoneTab.Exp == AlchemyStone.selectedTabIdx then
		guideText = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_SELECT_EXP")	-- 가방에서 연마시킬 재료를 선택해주세요.
	elseif AlchemyStoneTab.Upgrade == AlchemyStone.selectedTabIdx then
		guideText = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_SELECT_UPGRADE")	-- 블랙스톤(무기)를 선택해주세요.
	end

	AlchemyStone.control.guideString:SetText( guideText )
end

function AlchemyStone_StuffFilter( slotNo, itemWrapper, count, inventoryType )
	local returnValue = true
	local staticStatus = itemWrapper:getStaticStatus()
	
	if nil == staticStatus or -1 == AlchemyStone.selectedStoneType then
		return returnValue
	end

	if AlchemyStoneTab.Charge == AlchemyStone.selectedTabIdx then
		if staticStatus:isAlchemyRepair( AlchemyStone.selectedStoneType ) then
			returnValue = false
		end
	elseif AlchemyStoneTab.Exp == AlchemyStone.selectedTabIdx then
		if staticStatus:isAlchemyUpgradeItem( AlchemyStone.selectedStoneType ) then
			returnValue = false
		end
	elseif AlchemyStoneTab.Upgrade == AlchemyStone.selectedTabIdx then
		local itemKey = itemWrapper:get():getKey()
		if staticStatus:isAlchemyUpgradeMaterial( AlchemyStone.selectedStoneItemKey ) then
			returnValue = false
		end
	end

	return returnValue
end
function AlchemyStone_StuffRfunction( slotNo, itemWrapper, count, inventoryType )
	AlchemyStone.fromWhereType	= inventoryType
	AlchemyStone.fromSlotNo		= slotNo
	AlchemyStone.fromCount		= count
	AlchemyStone.fromMaxCount	= count

	local itemSSW		= itemWrapper:getStaticStatus()
	local itemKey		= itemSSW:get()._key	-- :getItemKey()

	local setStuffFunc = function( itemCount )
		AlchemyStone.fromCount		= itemCount

		local itemSSW		= getItemEnchantStaticStatus( itemKey )
		AlchemyStone.Stuff_slot:setItemByStaticStatus( itemSSW, AlchemyStone.fromCount, nil, nil, nil )
		AlchemyStone.Stuff_slot.Empty = false

		AlchemyStone.Stuff_slot.icon:addInputEvent( "Mouse_On",		"AlchemyStone_ItemToolTip( true, " .. 1 .. " )" )
		AlchemyStone.Stuff_slot.icon:addInputEvent( "Mouse_Out",	"AlchemyStone_ItemToolTip( false )" )

		AlchemyStone.control.btn_Doit:SetMonoTone( AlchemyStone.isPushDoit )
		AlchemyStone.control.btn_Doit:SetEnable( not AlchemyStone.isPushDoit )

		AlchemyStone.control.guideString:SetText( guideText )
	end

	local guideText = ""
	if AlchemyStoneTab.Charge == AlchemyStone.selectedTabIdx then				-- 충전일 때
		guideText		= PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_DOIT_CHARGE")	-- 충전 버튼을 누르면 충전이 시작됩니다.
		AlchemyStone.chargePoint		= ToClient_GetAlchmeyStoneChargePoint( AlchemyStone.toWhereType, AlchemyStone.toSlotNo, AlchemyStone.fromWhereType, AlchemyStone.fromSlotNo )
		AlchemyStone.maxRecoverCount	= math.ceil(AlchemyStone.toLostEndurance/AlchemyStone.chargePoint) * AlchemyStone.recoverCount
		local string = PAGetStringParam3( Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_NEEDMAXCHARGECOUNT", "count1", AlchemyStone.maxRecoverCount, "count2", AlchemyStone.recoverCount, "count3", AlchemyStone.chargePoint )
		AlchemyStone.control.needCount	:SetText( string ) 

	elseif AlchemyStoneTab.Exp == AlchemyStone.selectedTabIdx then				-- 연마일 때
		guideText = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_DOIT_EXP")	-- 연마 버튼을 누르면 연마가 시작됩니다.

	elseif AlchemyStoneTab.Upgrade == AlchemyStone.selectedTabIdx then			-- 성장일 때
		guideText = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_DOIT_UPGRADE")	-- 성장 버튼을 누르면 성장이 시작됩니다.

	end

	if toInt64(0,1) < count then											-- 재료 갯수를 지정할 수 있다.
		Panel_NumberPad_Show( true, count, nil, setStuffFunc, false, nil, nil )
	else
		setStuffFunc( toInt64(0,1) )
	end
end


--------------------------------------------------------------------------------
-- function Event
--------------------------------------------------------------------------------
function FGlobal_AlchemyStone_Open()
	local isAlchemyStoneEnble = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 35 )	-- 35 =성장형 장비 컨텐츠(연금석 등) 
	if not isAlchemyStoneEnble then	-- 컨텐츠 옵션에서 열지 않으면 리턴!
		return
	end

	if Panel_AlchemyFigureHead:GetShow() then
		FGlobal_AlchemyFigureHead_Close()
	end
	
	if Panel_Manufacture:GetShow() then
		Manufacture_Close()
	end
	
	if Panel_DyePalette:GetShow() then
		FGlobal_DyePalette_Close()
	end
	
	FGlobal_SetInventoryDragNoUse(Panel_AlchemyStone)
	
	Panel_AlchemyStone			:SetShow( true )
	
	-- 기본 선택 탭
	AlchemyStone.control.tab_Charge		:SetCheck( true )
	AlchemyStone.control.tab_Exp		:SetCheck( false )
	AlchemyStone.control.tab_Upgrade	:SetCheck( false )

	AlchemyStone:ClearData( true )		-- 초기화
	HandleClicked_AlchemyStoneTab( 0 )	-- 탭 0 선택
	doItType							= 0

	if Panel_Equipment:GetShow() then
		EquipmentWindow_Close()
	end

	InventoryWindow_Show()
	Inventory_SetFunctor( AlchemyStone_StoneFilter, AlchemyStone_StoneRfunction, nil, nil )
end
function FGlobal_AlchemyStone_Close()
	HandleClicked_AlchemyStone_Close()
end

function FGlobal_AlchemyStone_Use()
	local itemWrapper = getEquipmentItem( CppEnums.EquipSlotNo.alchemyStone )
	if nil ~= itemWrapper then
		useAlchemyStone()
	end
end

local elapsTime = 0
function Panel_AlchemyStone_updateTime( deltaTime )
	if AlchemyStone.isPushDoit then
		elapsTime = elapsTime + deltaTime

		if 0 < elapsTime and false == AlchemyStone.startEffectPlay then
			AlchemyStone.Stuff_slot.icon:EraseAllEffect()
			AlchemyStone.Stuff_slot.icon:AddEffect( "fUI_Alchemy_UpgradeStart01", false )
			AlchemyStone.startEffectPlay	= true

			if AlchemyStoneTab.Charge == doItType then
				-- ♬ 충전 사운드!
				audioPostEvent_SystemUi(13,16)
			elseif AlchemyStoneTab.Exp == doItType then
				-- ♬ 연마 사운드!
				audioPostEvent_SystemUi(13,16)
			elseif AlchemyStoneTab.Upgrade == doItType then
				-- ♬ 성장 사운드!
				audioPostEvent_SystemUi(13,17)
			end
		end

		if 1 < elapsTime and false == AlchemyStone.contentEffectPlay then
			-- 재료를 사라지게 한다.
			AlchemyStone.Stuff_slot:clearItem()
			AlchemyStone.Stuff_slot.Empty = true

			AlchemyStone.control.contentEffect:EraseAllEffect()
			if AlchemyStoneTab.Charge == doItType then
				-- ♬ 충전 사운드!
				AlchemyStone.control.contentEffect:AddEffect( "fUI_Alchemy_Stone01", false )
			elseif AlchemyStoneTab.Exp == doItType then
				-- ♬ 연마 사운드!
				AlchemyStone.control.contentEffect:AddEffect( "fUI_Alchemy_Stone01", false )
			elseif AlchemyStoneTab.Upgrade == doItType then
				-- ♬ 성장 사운드!
				AlchemyStone.control.contentEffect:AddEffect( "fUI_Alchemy_Stone_Upgrade01", false )
			end
			AlchemyStone.contentEffectPlay = true
		end

		if 2.5 < elapsTime and false == AlchemyStone.slotEffectPlay then
			AlchemyStone.Stone_slot.icon:EraseAllEffect()
			if AlchemyStoneTab.Charge == doItType then
				AlchemyStone.Stone_slot.icon:AddEffect( "fUI_Alchemy_Stone02", false )
			elseif AlchemyStoneTab.Exp == doItType then
				AlchemyStone.Stone_slot.icon:AddEffect( "fUI_Alchemy_Stone02", false )
			elseif AlchemyStoneTab.Upgrade == doItType then
				AlchemyStone.Stone_slot.icon:AddEffect( "fUI_Alchemy_Stone_Upgrade02", false )
			end
			AlchemyStone.slotEffectPlay = true
		end

		if 3 < elapsTime and false == AlchemyStone.effectEnd then
				if AlchemyStoneTab.Charge == doItType then
					alchemyRepair( AlchemyStone.toWhereType, AlchemyStone.toSlotNo, AlchemyStone.fromWhereType, AlchemyStone.fromSlotNo, AlchemyStone.fromCount )
				elseif AlchemyStoneTab.Exp == doItType then
					alchemyUpgrade( AlchemyStone.fromWhereType, AlchemyStone.fromSlotNo, AlchemyStone.fromCount, AlchemyStone.toWhereType, AlchemyStone.toSlotNo )
				elseif AlchemyStoneTab.Upgrade == doItType then
					alchemyEvolve( AlchemyStone.fromWhereType, AlchemyStone.fromSlotNo, AlchemyStone.toWhereType, AlchemyStone.toSlotNo )
				end

			-- { 초기화
				AlchemyStone.effectEnd = true
				elapsTime = 0													-- 시간 초기화
				AlchemyStone:ClearData()	-- 초기화
				Inventory_SetFunctor( AlchemyStone_StoneFilter, AlchemyStone_StoneRfunction, nil, nil )
			-- }
		end
	else
		elapsTime = 0	-- 시간 초기화
	end
end



--------------------------------------------------------------------------------
-- client Event
--------------------------------------------------------------------------------
function AlchemyStone_onScreenResize()
	Panel_AlchemyStone:ComputePos()
end

function FromClient_ItemUpgrade( itemwhereType, slotNo, exp )
	if not Panel_AlchemyStone:GetShow() then
		return
	end

	if -1 == doItType  then
		return
	end

	local itemWrapper	= getInventoryItemByType( itemwhereType, slotNo )
	if	( nil == itemWrapper )	then
		return
	end
	local itemName		= itemWrapper:getStaticStatus():getName()
	local mainMsg		= ""
	if -1 == doItType  then
		return
	end

	if AlchemyStoneTab.Charge == doItType then
		mainMsg	= itemName .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_DONE_CHARGE")	--  충전 완료!
	elseif AlchemyStoneTab.Exp == doItType then
		mainMsg	= itemName .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_DONE_EXP")	--  연마 완료!
	elseif AlchemyStoneTab.Upgrade == doItType then
		mainMsg	= itemName .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_DONE_UPGRADE")	--  성장 실패.
	end

	AlchemyStone.resultMsg	= {
		main	= mainMsg,
		sub		= PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_MSG_EXP") .. string.format( "%.2f", (itemWrapper:getExperience()/10000) ) .. "%",	-- 현재 경험치 : 
		addMsg	= "Icon/" .. itemWrapper:getStaticStatus():getIconPath()
	}

	Proc_ShowMessage_Ack_For_RewardSelect( AlchemyStone.resultMsg, 2.5, 33 )

	AlchemyStone.resultMsg	= {}
	AlchemyStone:ClearData()	-- 초기화
	Inventory_SetFunctor( AlchemyStone_StoneFilter, AlchemyStone_StoneRfunction, nil, nil )
end

function FromClient_StoneChange( whereType, slotNo )
	if not Panel_AlchemyStone:GetShow() then
		return
	end

	if -1 == doItType  then
		return
	end

	local itemWrapper	= getInventoryItemByType( whereType, slotNo )
	if	( nil == itemWrapper )	then
		return
	end

	local itemName		= itemWrapper:getStaticStatus():getName()

	msg	= {
		main	= PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_MSG_DONE"),	-- 연금석 성장 성공
		sub		= PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_MSG_DONE2", "itemName", itemName),	-- {itemName}으로 성장에 성공했습니다.
		addMsg	= "Icon/" .. itemWrapper:getStaticStatus():getIconPath()
	}

	Proc_ShowMessage_Ack_For_RewardSelect( msg, 2.5, 33 )
	AlchemyStone:ClearData()	-- 초기화
	Inventory_SetFunctor( AlchemyStone_StoneFilter, AlchemyStone_StoneRfunction, nil, nil )
end

function FromClient_StoneChangeFailedByDown( whereType, slotNo )
	if not Panel_AlchemyStone:GetShow() then
		return
	end

	if -1 == doItType  then
		return
	end

	local itemWrapper	= getInventoryItemByType( whereType, slotNo )
	if	( nil == itemWrapper )	then
		return
	end
	
	local itemName		= itemWrapper:getStaticStatus():getName()

	msg	= {
		main	= PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_MSG_FAIL"),	-- 연금석 성장 실패
		sub		= PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_MSG_FAIL2", "itemName", itemName),	-- 성장 실패로 {itemName}이 됐습니다.
		addMsg	= "Icon/" .. itemWrapper:getStaticStatus():getIconPath()
	}

	Proc_ShowMessage_Ack_For_RewardSelect( msg, 2.5, 33 )
	AlchemyStone:ClearData()	-- 초기화
	Inventory_SetFunctor( AlchemyStone_StoneFilter, AlchemyStone_StoneRfunction, nil, nil )
end

function FromClient_AlchemyEvolve( evolveType )
	if not Panel_AlchemyStone:GetShow() then
		return
	end
	
	if -1 == doItType  then
		return
	end

	-- 0 실패(경험치차감)
	-- 1 실패(깨짐)
	-- 2 실패(단계하락)
	-- 3 성공

	if 1 == evolveType then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_MSG_LOST"))	-- 성장에 실패하여, 연금석이 증발됩니다.
	end

	AlchemyStone:ClearData()	-- 초기화
	Inventory_SetFunctor( AlchemyStone_StoneFilter, AlchemyStone_StoneRfunction, nil, nil )
end

function FromClient_AlchemyRepair( whereType, slotNo )
	local itemWrapper	= getInventoryItemByType( whereType, Int64toInt32(slotNo) )
	if nil ~= itemWrapper then
		local itemSSW		= itemWrapper:getStaticStatus()
		local itemName		= itemSSW:getName()
		Proc_ShowMessage_Ack( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_CHARGE_COMPLETE_ACK", "itemName", itemName ) ) -- itemName .. "이 충전됐습니다." )
	end
end


AlchemyStone:Init()
AlchemyStone:registEventHandler()
AlchemyStone:registMessageHandler()