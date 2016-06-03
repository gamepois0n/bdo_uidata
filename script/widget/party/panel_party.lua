Panel_Party:ActiveMouseEventEffect(true)
Panel_Party:SetShow( false, false )
Panel_PartyOption:SetShow( false, false )

Panel_Party:RegisterShowEventFunc( true, 'PartyShowAni()' )
Panel_Party:RegisterShowEventFunc( false, 'PartyHideAni()' )
Panel_PartyOption:RegisterShowEventFunc( true, 'PartyOptionShowAni()' )
Panel_PartyOption:RegisterShowEventFunc( false, 'PartyOptionHideAni()' )

local isContentsEnable = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 38 )

local CT2S 			= CppEnums.ClassType2String
local PLT 			= CppEnums.PartyLootType
local PLT2S 		= CppEnums.PartyLootType2String
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE
local PP 			= CppEnums.PAUIMB_PRIORITY
local UI_color 		= Defines.Color
local UI_Class		= CppEnums.ClassType
local registMarket	= true --ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 64 )		-- 파티분배옵션 ( 지이사님의 요청으로 컨텐츠 옵션화 하지 않는다.)

local _last_Index 	= nil
local _partyData 	= {}
local withdrawMember

local requestPlayerList = {}
local refuseName = ""
local isMainChannel	= nil
local isDevServer	= nil

local controlTemplate =
{
	_styleLeaderIcon 		= UI.getChildControl( Panel_Party, 	"Static_Icon_Leader"  ),
	_styleBackGround		= UI.getChildControl( Panel_Party, 	"Static_ClassSlot"  ),
	_styleClassIcon 		= UI.getChildControl( Panel_Party, 	"Static_Icon_Class"  ),
	_styleUserName 			= UI.getChildControl( Panel_Party, 	"StaticText_UserName"  ),
	_styleHpBG				= UI.getChildControl( Panel_Party, 	"Static_HpBG"  ),
	_styleHp 				= UI.getChildControl( Panel_Party, 	"Progress2_Hp"  ),
	_styleMp			 	= UI.getChildControl( Panel_Party, 	"Progress2_Mp"  ),
	_styleUserLevel			= UI.getChildControl( Panel_Party, 	"StaticText_UserLevel"  ),
	-- _styleMpHead			 	= nil,
	-- _stylePortraitCharacter	= UI.getChildControl( Panel_Party, 	"Static_Portrait_Character"  ),
	-- _stylePortraitDeco		= UI.getChildControl( Panel_Party, 	"Static_Portrait_Deco"  ),
	_styleConditionBG 		= UI.getChildControl( Panel_Party, 	"Static_DeadConditionBG"  ),
	_styleConditionTxt 		= UI.getChildControl( Panel_Party, 	"StaticText_NowCondition"  ),
	_stylePartyOptionBtn	= UI.getChildControl( Panel_Party,	"Button_Option" ),
	_styleFollowBtn			= UI.getChildControl( Panel_Party,	"Button_Follow" ),
	_distance				= UI.getChildControl( Panel_Party,	"Static_Distance" ),
}

local partyMarketOption		= UI.getChildControl( Panel_Party, "Static_MarketOption" )
partyMarketOption:addInputEvent( "Mouse_On", "Show_Tooltips_SpecialGoods( " .. 1 .. ", true )" )
partyMarketOption:addInputEvent( "Mouse_Out", "Show_Tooltips_SpecialGoods( " .. 1 .. ", false )" )
partyMarketOption:SetShow( registMarket )

local btnSpecialGoods		= UI.getChildControl( Panel_Party, "Static_RegistSpecialGoods")
btnSpecialGoods:addInputEvent( "Mouse_On", "Show_Tooltips_SpecialGoods( " .. 2 .. ", true )" )
btnSpecialGoods:addInputEvent( "Mouse_Out", "Show_Tooltips_SpecialGoods( " .. 2 .. ", false )" )
btnSpecialGoods:SetShow( registMarket )

local partyPenalty			= UI.getChildControl( Panel_Party, "Static_Penalty")
partyPenalty:addInputEvent( "Mouse_On", "PartyPop_SimpleTooltip_Show( true, 2)" )
partyPenalty:addInputEvent( "Mouse_Out", "PartyPop_SimpleTooltip_Show( false, 2 )" )
partyPenalty:setTooltipEventRegistFunc("PartyPop_SimpleTooltip_Show( true, 2)")
partyPenalty:SetShow( false )

-- local partyMemberDistance	= UI.getChildControl( Panel_Party, "Static_Distance")

local _tooltipBg	= UI.getChildControl( Panel_Party, "Static_TooltipBG" )
local _tooltipText	= UI.getChildControl( Panel_Party, "Tooltip_Name" )

local registItem =
{
	_bg				= UI.getChildControl( Panel_Party, "Static_MarketOptionBg" ),
	_checkMoney		= UI.getChildControl( Panel_Party, "CheckButton_Money" ),
	_checkGrade		= UI.getChildControl( Panel_Party, "CheckButton_Grade" ),
	_moneyValue		= UI.getChildControl( Panel_Party, "StaticText_MoneyValue" ),
	_comboBox		= UI.getChildControl( Panel_Party, "Combobox_MarketGrade" ),
	_option			= UI.getChildControl( Panel_Party, "Static_Option" ),
	_btnAdmin		= UI.getChildControl( Panel_Party, "Button_Admin" ),
	_btnCancel		= UI.getChildControl( Panel_Party, "Button_Cancel" ),
}

registItem._option:addInputEvent( "Mouse_LUp",		"Party_RegistItem_ChangeMoney()" )
registItem._comboBox:addInputEvent( "Mouse_LUp",	"Party_RegistItem_ShowComboBox()" )
registItem._comboBox:GetListControl():addInputEvent( "Mouse_LUp", "Party_RegistItem_SetGrade()"  )
registItem._btnAdmin:addInputEvent( "Mouse_LUp",	"Party_RegistItem_Set()" )
registItem._btnCancel:addInputEvent( "Mouse_LUp",	"Party_RegistItem_Show( false )" )

registItem._bg:AddChild( registItem._checkMoney )
registItem._bg:AddChild( registItem._checkGrade )
registItem._bg:AddChild( registItem._moneyValue )
registItem._bg:AddChild( registItem._comboBox )
registItem._bg:AddChild( registItem._option )
registItem._bg:AddChild( registItem._btnAdmin )
registItem._bg:AddChild( registItem._btnCancel )

Panel_Party:RemoveControl( registItem._checkMoney )
Panel_Party:RemoveControl( registItem._checkGrade )
Panel_Party:RemoveControl( registItem._moneyValue )
Panel_Party:RemoveControl( registItem._comboBox )
Panel_Party:RemoveControl( registItem._option )
Panel_Party:RemoveControl( registItem._btnAdmin )
Panel_Party:RemoveControl( registItem._btnCancel )

registItem._bg:SetChildIndex( registItem._comboBox, 9999 )

local bgSizeX = registItem._bg:GetSizeX()
local optionPosX = registItem._option:GetPosX()
local moneyValuePosX = registItem._moneyValue:GetPosX()
local comboBoxPosX = registItem._comboBox:GetPosX()
local btnAdminPosX = registItem._btnAdmin:GetPosX()
local btnCancelPosX = registItem._btnCancel:GetPosX()
local registItem_Resize = function()
	local plusSizeX = 0
	if isGameTypeRussia() then
		plusSizeX = 50
	elseif isGameTypeEnglish() then
		plusSizeX = 50
	end
	registItem._bg:SetSize( bgSizeX + plusSizeX, registItem._bg:GetSizeY() )
	registItem._option:SetPosX( optionPosX + plusSizeX )
	registItem._moneyValue:SetPosX( moneyValuePosX + plusSizeX )
	registItem._comboBox:SetPosX( comboBoxPosX + plusSizeX )
	registItem._btnAdmin:SetPosX( btnAdminPosX + plusSizeX/2 )
	registItem._btnCancel:SetPosX( btnCancelPosX + plusSizeX/2 )
end
registItem_Resize()

local itemGrade =
{
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_NOT_SETTING"), --"설정 안됨",
	PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_ITEMGRADE_GREEN"), --"<PAColor0xFF5DFF70>녹색<PAOldColor>",
	PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_ITEMGRADE_BLUE"), --"<PAColor0xFF4B97FF>파랑<PAOldColor>",
	PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_ITEMGRADE_YELLOW"), --"<PAColor0xFFFFC832>노랑<PAOldColor>",
	PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_ITEMGRADE_ORANGE"), --"<PAColor0xFFFF6C00>주황<PAOldColor>"
}

local _grade = 0
local _baseMoney, _money = toInt64(0, 1000000)

function Party_RegistItem_ChangeMoney()
	Panel_NumberPad_Show( true, toInt64(0, 100000000), param0, setMoney )
end

function setMoney( inputNum )
	local _inputNum
	if 100000000 < Int64toInt32(inputNum) then
		_inputNum = toInt64(0, 100000000)
	elseif Int64toInt32(inputNum) < 1000000 then
		_inputNum = _baseMoney
	else
		_inputNum = inputNum
	end
	
	_money = _inputNum
	registItem._moneyValue:SetText( "<PAColor0xffe7d583>" .. makeDotMoney(_inputNum) .. "<PAOldColor>" )
end

function Party_RegistItem_ShowComboBox()
	Party_RegistItem_PopOption()
end

function Party_RegistItem_PopOption()
	local self = registItem
	self._comboBox:DeleteAllItem()
		
	for ii = 0, #itemGrade do
		self._comboBox:AddItem( itemGrade[ii], ii )
	end
	self._comboBox:ToggleListbox()
	self._comboBox:SetShow(true)
end

function Party_RegistItem_SetGrade()
	local self = registItem
	self._comboBox:SetSelectItemIndex(self._comboBox:GetSelectIndex())
	self._comboBox:ToggleListbox()
end

function Party_RegistItem_Show( isShow )
	local self = registItem
	if nil == isShow then
		self._bg:SetShow( not self._bg:GetShow() )
	else
		self._bg:SetShow( isShow )
	end
	
	local isPartyLeader = RequestParty_isLeader()
	self._checkGrade	:SetEnable( isPartyLeader )
	self._checkMoney	:SetEnable( isPartyLeader )
	self._option		:SetEnable( isPartyLeader )
	self._comboBox		:SetEnable( isPartyLeader )
	
	if isPartyLeader then
		self._btnAdmin:SetShow( true )
		self._btnCancel:SetShow( true )
		self._bg:SetSize( self._bg:GetSizeX(), 75 )
	else
		self._btnAdmin:SetShow( false )
		self._btnCancel:SetShow( false )
		self._bg:SetSize( self._bg:GetSizeX(), 45 )
	end
	
	_money = RequestParty_getDistributionPrice()
	if toInt64(0,0) ~= _money then
		self._moneyValue:SetText( "<PAColor0xffe7d583>" .. makeDotMoney( _money ) .. "<PAOldColor>" )
		self._checkMoney:SetCheck( true )
	else
		self._moneyValue:SetText( "<PAColor0xffe7d583>" .. makeDotMoney( _baseMoney ) .. "<PAOldColor>" )
		self._checkMoney:SetCheck( false )
	end
	
	-- 콤보박스 초기화
	self._comboBox:DeleteAllItem()
	for ii = 0, #itemGrade do
		self._comboBox:AddItem( itemGrade[ii], ii )
	end
	if 0 < RequestParty_getDistributionGrade() and RequestParty_getDistributionGrade() < 5 then
		self._comboBox:SetSelectItemIndex( RequestParty_getDistributionGrade() )
		self._comboBox:SetText( itemGrade[RequestParty_getDistributionGrade()])
		self._checkGrade:SetCheck( true )
	else
		self._comboBox:SetSelectItemIndex( 0 )
		self._checkGrade:SetCheck( false )
	end
end
Party_RegistItem_Show( false )

function Party_RegistItem_Option_Init()
	local self = registItem
	self._checkMoney:SetCheck( false )
	self._checkGrade:SetCheck( false )
	
	self._moneyValue:SetText( "<PAColor0xffe7d583>" .. makeDotMoney(_money) .. "<PAOldColor>" )
	self._comboBox:SetSelectItemIndex( 0 )
end

function Party_RegistItem_Set()
	local self = registItem
	local price, grade
	
	if self._checkMoney:IsCheck() then
		price = toInt64(0, math.max(Int64toInt32(_money), Int64toInt32(_baseMoney)))
	else
		price = toInt64(0,0)
	end
	
	if self._checkGrade:IsCheck() then
		grade = self._comboBox:GetSelectIndex()
	else
		grade = 5
		self._comboBox:SetSelectItemIndex( 0 )
	end
	
	if 0 < self._comboBox:GetSelectIndex() and self._comboBox:GetSelectIndex() < 5 then
		self._comboBox:SetSelectItemIndex( self._comboBox:GetSelectIndex() )
	else
		grade = 5
		self._comboBox:SetSelectItemIndex( 0 )
	end
	
	RequestParty_changeDistributionOption(price, grade)
	Party_RegistItem_Show( false )
end

Party_RegistItem_Option_Init()

function Show_Tooltips_SpecialGoods( btnType, isShow )
	-- ToClient_requestListMySellInfo()
	local itemCount = ToClient_requestGetMySellInfoCount()
	
	-- local msg = "현재 " .. itemCount .. "개의 특가상품이 등록되어 있습니다."
	
	local self = registItem
	local msg
	if 1 == btnType then
		if 0 < Int64toInt32(RequestParty_getDistributionPrice()) then
			if 0 < RequestParty_getDistributionGrade() and RequestParty_getDistributionGrade() < 5 then
				msg = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_HIGHSILVER", "getDistributionPrice", makeDotMoney(RequestParty_getDistributionPrice()) ) .. ", " .. PAGetStringParam1( Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_HIGHGRADE", "getDistributionGrade", itemGrade[RequestParty_getDistributionGrade()] )
			else
				msg = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_HIGHSILVER", "getDistributionPrice", makeDotMoney(RequestParty_getDistributionPrice()) )
			end
		else
			if 0 < RequestParty_getDistributionGrade() and RequestParty_getDistributionGrade() < 5 then
				msg = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_HIGHGRADE2", "getDistributionGrade", itemGrade[RequestParty_getDistributionGrade()] ) -- "파티 분배 옵션 : " .. itemGrade[RequestParty_getDistributionGrade()] .. " 등급 이상"
			else
				msg = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_NOT_OPTION_SETTING") -- "파티 분배 옵션이 설정되지 않았습니다."
			end
		end
	elseif 2 == btnType then
		-- if 0 < itemCount then
			-- msg = "현재 " .. itemCount .. "개의 특가상품이 등록되어 있습니다."
		-- else
			-- msg = "등록된 특가상품이 없습니다."
		-- end
		msg = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_REGISTITEM_VIEW") -- 내 파티로 등록된 특가상품 보기
	end
	
	_tooltipBg:SetShow( isShow )
	_tooltipText:SetShow( isShow )
	_tooltipText:SetText( msg )
	_tooltipBg:SetSize( _tooltipText:GetTextSizeX() + 10, _tooltipBg:GetSizeY() )
end

function Party_ShowMessageAlert()
	Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_ONLY_MASTER") ) -- 파티장만 변경할 수 있습니다.
end

-- controlTemplate._styleMpHead = UI.getChildControl(controlTemplate._styleMp, 	"Progress2_2_Mp_Head"  )

controlTemplate._styleBackGround:SetShow(false)
controlTemplate._styleUserName:SetShow(false)
controlTemplate._styleHpBG:SetShow(false)
-- controlTemplate._styleMpBG:SetShow(false)
controlTemplate._styleHp:SetShow(false)
controlTemplate._styleUserLevel:SetShow(false)
-- controlTemplate._styleMpHead:SetShow(false)
controlTemplate._styleClassIcon:SetShow(false)
-- controlTemplate._stylePortraitCharacter:SetShow(false)
-- controlTemplate._stylePortraitDeco:SetShow(false)
controlTemplate._styleLeaderIcon:SetShow(false)
controlTemplate._styleConditionBG:SetShow(false)
controlTemplate._styleConditionTxt:SetShow(false)
controlTemplate._stylePartyOptionBtn:SetShow(false)
controlTemplate._styleFollowBtn:SetShow(false)
controlTemplate._distance:SetShow(false)

local Match_Button_Info			= UI.getChildControl( Panel_Party, "Match_Button_MatchInfo" )	-- 결투정보 버튼

local _styleLootType 			= UI.getChildControl( Panel_Party, "StaticText_LootType"  )
local _uiComboLootingOption		= UI.getChildControl( Panel_Party, "Combobox_Looting_Option" )
local _comboBoxList				= UI.getChildControl( _uiComboLootingOption, "Combobox_List" )
_styleLootType:SetShow(false)
_uiComboLootingOption:SetShow( true )
Panel_Party:SetChildIndex( _uiComboLootingOption, 9999 )

local _uiPartyMemberList 		= {}
_maxPartyMemberCount 			= 5
local _preLootType

local _uiButtonChangeLeader		= UI.getChildControl( Panel_PartyOption, "Button_Change_Leader" )
local _uiButtonWithdrawMember	= UI.getChildControl( Panel_PartyOption, "Button_Withdraw_Member" )
-- local _uiButtonWinClose 		= UI.getChildControl( Panel_PartyOption, "Button_Win_Close" )
-- local _uiButtonQuestion	 		= UI.getChildControl( Panel_PartyOption, "Button_Question" )				-- 물음표 버튼


----- 현재 채널 정보를 얻어옴 (3:3 PvP가 메인채널인 1채널 및 개발서버에서만 가능하도록) ----------------
if isContentsEnable then
	isMainChannel		= getCurrentChannelServerData()._isMain
	isDevServer			= ToClient_IsDevelopment()
end
--------------------------------------------------------------------------------------------------------


local closePartyOption = function()
	-- 꺼준다
	Panel_PartyOption:SetShow(false)
end


function PartyShowAni()
end

function PartyHideAni()
end


function PartyOptionShowAni()
	UIAni.fadeInSCR_Down(Panel_PartyOption)
end


function PartyOptionHideAni()
	Panel_PartyOption:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo1 = Panel_PartyOption:addColorAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)

	local aniInfo2 = Panel_PartyOption:addScaleAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo2:SetStartScale(1.0)
	aniInfo2:SetEndScale(0.97)
	aniInfo2.AxisX = 200
	aniInfo2.AxisY = 295
	aniInfo2.IsChangeChild = true
end


function Looting_ComboBox()
	if false == RequestParty_isLeader() then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_ONLYLEADERCHANGE") ) -- "파티장만 변경할 수 있습니다."
		return
	end
	
	PartyPop_onLootingOptionUI()

	local lootingList = _uiComboLootingOption:GetListControl()
	
	lootingList:addInputEvent( "Mouse_LUp", "changeLooting()" )
	_uiComboLootingOption:ToggleListbox()
end


function changeLooting()
	local selectKey = _uiComboLootingOption:GetSelectKey()
	_uiComboLootingOption:SetSelectItemIndex( selectKey )
	
	RequestParty_changeLooting(selectKey)
	-- _uiComboLootingOption:SetShow(false)
end

local createPartyControls = function()
	for index = 0 , _maxPartyMemberCount-1, 1 do
		local partyMember = {}
		partyMember._base 					= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, 		Panel_Party,		'PartyMember_Back' .. index)
		partyMember._leader					= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, 		partyMember._base,	'PartyMember_Leader' .. index)
		partyMember._name 					= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, 	partyMember._base,	'PartyMember_UserName' .. index)
		partyMember._class					= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, 		partyMember._base,	'PartyMember_Class' .. index)
		partyMember._hpBG					= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, 		partyMember._base,	'PartyMember_HpBG' .. index)
		partyMember._hp						= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_PROGRESS2, 	partyMember._base,	'PartyMember_Hp' .. index)
		partyMember._mp						= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_PROGRESS2, 	partyMember._base,	'PartyMember_Mp' .. index)
		partyMember._level					= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, 	partyMember._base,	'PartyMember_UserLevel' .. index)
		partyMember._conditionBG			= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, 		partyMember._base,	'PartyMember_ConditionBG' .. index)
		partyMember._conditionTxt			= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT,	partyMember._base,	'PartyMember_ConditionTxt' .. index)
		partyMember._stylePartyOptionBtn	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON,		partyMember._base,	'PartyMember_OptionBtn' .. index)
		partyMember._styleFollowBtn			= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON,		partyMember._base,	'PartyMember_FollowBtn' .. index)
		partyMember._distance				= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC,		partyMember._base,	'PartyMember_Distance' .. index)

		CopyBaseProperty( controlTemplate._styleLeaderIcon, 		partyMember._leader )
		CopyBaseProperty( controlTemplate._styleUserName, 			partyMember._name )
		CopyBaseProperty( controlTemplate._styleBackGround,			partyMember._base )
		CopyBaseProperty( controlTemplate._styleClassIcon, 			partyMember._class )
		CopyBaseProperty( controlTemplate._styleHpBG, 				partyMember._hpBG )
		CopyBaseProperty( controlTemplate._styleHp, 				partyMember._hp )
		CopyBaseProperty( controlTemplate._styleMp, 				partyMember._mp )
		CopyBaseProperty( controlTemplate._styleUserLevel, 			partyMember._level )
		CopyBaseProperty( controlTemplate._styleConditionBG, 		partyMember._conditionBG )
		CopyBaseProperty( controlTemplate._styleConditionTxt, 		partyMember._conditionTxt )
		CopyBaseProperty( controlTemplate._stylePartyOptionBtn, 	partyMember._stylePartyOptionBtn )
		CopyBaseProperty( controlTemplate._styleFollowBtn, 			partyMember._styleFollowBtn )
		CopyBaseProperty( controlTemplate._distance, 				partyMember._distance )

		partyMember._leader:SetShow(false)
		partyMember._name:SetShow(true)
		partyMember._base:SetShow(true)
		partyMember._class:SetShow(true)
		partyMember._hpBG:SetShow(true)
		partyMember._hp:SetShow(true)
		partyMember._mp:SetShow(true)
		partyMember._level:SetShow(true)
		partyMember._conditionBG:SetShow(true)
		partyMember._conditionTxt:SetShow(true)

		partyMember._base:SetAlpha( 0.7 )
		partyMember._base:SetShow(true)
		partyMember._base:SetPosY(index*partyMember._base:GetSizeY()*1.08)

		partyMember._name:SetIgnore(true)
		partyMember._class:SetIgnore(true)
		partyMember._hpBG:SetIgnore(true)
		partyMember._hp:SetIgnore(true)
		partyMember._mp:SetIgnore(true)
		partyMember._level:SetIgnore(true)
		partyMember._leader:SetIgnore(true)
		partyMember._conditionBG:SetIgnore(true)
		partyMember._conditionTxt:SetIgnore(true)

		partyMember._stylePartyOptionBtn:addInputEvent( "Mouse_LUp", "PartyPop_clickPartyOption("..index..")")
		partyMember._styleFollowBtn:addInputEvent( "Mouse_LUp", "PartyPop_clickPartyFollow("..index..")")
		partyMember._styleFollowBtn:addInputEvent( "Mouse_On", "PartyPop_SimpleTooltip_Show(true, 0, "..index..")")
		partyMember._styleFollowBtn:addInputEvent( "Mouse_Out", "PartyPop_SimpleTooltip_Show(false, 0, "..index..")")
		partyMember._styleFollowBtn:setTooltipEventRegistFunc("PartyPop_SimpleTooltip_Show(true, 0, "..index..")")
		
		_uiPartyMemberList[index] = partyMember
	end

	Panel_Party:SetChildIndex( _styleLootType, Panel_Party:GetChildSize() )
end
createPartyControls()

local _partyMemberCount = RequestParty_getPartyMemberCount()
function ResponseParty_createPartyList()
	local partyMemberCount = RequestParty_getPartyMemberCount()
	if (0<partyMemberCount) then
		if not isFlushedUI() then
			Panel_Party:SetShow(true, false)
		end

		table.remove( requestPlayerList )
		ResponseParty_updatePartyList()
		-- Panel_WidgetControl_Toggle("Panel_Party", true)
		_partyMemberCount = partyMemberCount
		Party_RegistItem_Show( false )
		ToClient_requestListMySellInfo()		-- 파티 멤버가 1이상 일 때 한 번 돌려준다.
	end
end

local savedPrice = toInt64(0,0)
local savedGrade = 0
local firstCheck = 0
function ResponseParty_updatePartyList() 	-- 내가 리더인지 필요할듯(팀원중에 리더가 없으면으로 판단할까?)
	local isSelfMaster = false
		
	if (Panel_Party:IsShow()) then
		local partyMemberCount = RequestParty_getPartyMemberCount()
		local classTypeTexture
		local distanceTexture
		local lootType = RequestParty_getPartyLootType()
		local classMP = ""

		local _idx = 0

		_partyData = {}
		for index = 0, (partyMemberCount - 1) do
			local idx = 0
			local memberData = RequestParty_getPartyMemberAt(index)
			if true == RequestParty_isSelfPlayer(index) then
				idx = 0
			else
				idx = _idx + 1
				_idx = idx
			end

			_partyData[idx] = 
			{
				_index		= index,
				_isMaster 	= memberData._isMaster,
				_isSelf		= RequestParty_isSelfPlayer(index),
				_name 		= memberData:name(),
				_class 		= memberData:classType(),
				_level 		= memberData._level,
				_nowHp 		= memberData._hp * 100,
				_maxHp 		= memberData._maxHp,
				_nowMp 		= memberData._mp * 100,
				_maxMp 		= memberData._maxMp,
				_distance	= memberData:getExperienceGrade(),
			}	

			if true == _partyData[idx]._isSelf and true == _partyData[idx]._isMaster then
				isSelfMaster = true			
			end
		end

		for index = 0, _maxPartyMemberCount-1, 1 do
			_uiPartyMemberList[index]._hpBG:SetShow(true)

			if( index <= partyMemberCount-1 ) and nil ~= _partyData[index] then
				_uiPartyMemberList[index]._name:SetText( _partyData[index]._name )
				_uiPartyMemberList[index]._level:SetText( _partyData[index]._level )
				_uiPartyMemberList[index]._hp:SetProgressRate( _partyData[index]._nowHp / _partyData[index]._maxHp )
				_uiPartyMemberList[index]._mp:SetProgressRate( _partyData[index]._nowMp / _partyData[index]._maxMp )
				if true == isSelfMaster or true == _partyData[index]._isSelf then
					local spanSizeX = _uiPartyMemberList[index]._name:GetTextSizeX() + _uiPartyMemberList[index]._name:GetPosX()
					_uiPartyMemberList[index]._stylePartyOptionBtn:SetSpanSize( -185, _uiPartyMemberList[index]._stylePartyOptionBtn:GetSpanSize().y )
					---- PvP 신청 상태일 경우 파티 옵션 버튼 꺼줌 -----------------------------------------
					if isContentsEnable then
						_uiPartyMemberList[index]._stylePartyOptionBtn:SetShow( true )
					else
						_uiPartyMemberList[index]._stylePartyOptionBtn:SetShow( true )
					end
					---------------------------------------------------------------------------------------
				else
					_uiPartyMemberList[index]._stylePartyOptionBtn:SetShow(false)
				end

				classTypeTexture = "new_ui_common_forlua/widget/party/portrait_" .. CT2S[_partyData[index]._class].. ".dds"
				if(_partyData[index]._class == 4) then
					classMP = "new_ui_common_forlua/default/Default_Gauges.dds"				-- EP
					_uiPartyMemberList[index]._mp:ChangeTextureInfoName(classMP)

						local x1, y1, x2, y2 = setTextureUV_Func( _uiPartyMemberList[index]._mp, 1, 70, 233, 76 )
						_uiPartyMemberList[index]._mp:getBaseTexture():setUV(  x1, y1, x2, y2  )
						_uiPartyMemberList[index]._mp:setRenderTexture(_uiPartyMemberList[index]._mp:getBaseTexture())

				elseif(_partyData[index]._class == 8 or _partyData[index]._class == 16) then
					classMP = "new_ui_common_forlua/default/Default_Gauges.dds"				-- MP
					_uiPartyMemberList[index]._mp:ChangeTextureInfoName(classMP)

						local x1, y1, x2, y2 = setTextureUV_Func( _uiPartyMemberList[index]._mp, 1, 63, 233, 69 )
						_uiPartyMemberList[index]._mp:getBaseTexture():setUV(  x1, y1, x2, y2  )
						_uiPartyMemberList[index]._mp:setRenderTexture(_uiPartyMemberList[index]._mp:getBaseTexture())

				elseif(_partyData[index]._class == 24) then									-- 발키리
					classMP = "new_ui_common_forlua/default/Default_Gauges.dds"				-- BP
					_uiPartyMemberList[index]._mp:ChangeTextureInfoName(classMP)

						local x1, y1, x2, y2 = setTextureUV_Func( _uiPartyMemberList[index]._mp, 2, 250, 232, 255 )
						_uiPartyMemberList[index]._mp:getBaseTexture():setUV(  x1, y1, x2, y2  )
						_uiPartyMemberList[index]._mp:setRenderTexture(_uiPartyMemberList[index]._mp:getBaseTexture())

				elseif( (_partyData[index]._class == 0) or (_partyData[index]._class == 12) 
					or (_partyData[index]._class == 20) or (_partyData[index]._class == 21)
					or (_partyData[index]._class == 25) ) then
					classMP = "new_ui_common_forlua/default/Default_Gauges.dds"				-- FP
					_uiPartyMemberList[index]._mp:ChangeTextureInfoName(classMP)

						local x1, y1, x2, y2 = setTextureUV_Func( _uiPartyMemberList[index]._mp, 1, 56, 233, 62 )
						_uiPartyMemberList[index]._mp:getBaseTexture():setUV(  x1, y1, x2, y2  )
						_uiPartyMemberList[index]._mp:setRenderTexture(_uiPartyMemberList[index]._mp:getBaseTexture())
				end

				---------------------------------------------------------
				--			클래스 별로 클래스 아이콘을 바꿔준다
				if ( _partyData[index]._class == UI_Class.ClassType_Warrior ) then	-- 워리어
				classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
				_uiPartyMemberList[index]._class:ChangeTextureInfoName(classTypeTexture)
					local x1, y1, x2, y2 = setTextureUV_Func( _uiPartyMemberList[index]._class, 77, 25, 107, 55 )
					_uiPartyMemberList[index]._class:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())

				elseif ( _partyData[index]._class == UI_Class.ClassType_Ranger ) then	-- 레인저
				classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
				_uiPartyMemberList[index]._class:ChangeTextureInfoName(classTypeTexture)
					local x1, y1, x2, y2 = setTextureUV_Func( _uiPartyMemberList[index]._class, 108, 25, 138, 55 )
					_uiPartyMemberList[index]._class:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())
					
				elseif ( _partyData[index]._class == UI_Class.ClassType_Sorcerer ) then	-- 소서러
				classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
				_uiPartyMemberList[index]._class:ChangeTextureInfoName(classTypeTexture)
					local x1, y1, x2, y2 = setTextureUV_Func( _uiPartyMemberList[index]._class, 139, 25, 169, 55 )
					_uiPartyMemberList[index]._class:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())
					
				elseif ( _partyData[index]._class == UI_Class.ClassType_Giant ) then	-- 자이언트
				classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
				_uiPartyMemberList[index]._class:ChangeTextureInfoName(classTypeTexture)
					local x1, y1, x2, y2 = setTextureUV_Func( _uiPartyMemberList[index]._class, 170, 25, 200, 55 )
					_uiPartyMemberList[index]._class:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())

				elseif ( _partyData[index]._class == UI_Class.ClassType_Tamer ) then	-- 금수랑
				classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
				_uiPartyMemberList[index]._class:ChangeTextureInfoName(classTypeTexture)
					local x1, y1, x2, y2 = setTextureUV_Func( _uiPartyMemberList[index]._class, 167, 56, 197, 86 )
					_uiPartyMemberList[index]._class:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())

				elseif ( _partyData[index]._class == UI_Class.ClassType_BladeMaster ) then	-- 무사
				classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
				_uiPartyMemberList[index]._class:ChangeTextureInfoName(classTypeTexture)
					local x1, y1, x2, y2 = setTextureUV_Func( _uiPartyMemberList[index]._class, 198, 56, 228, 86 )
					_uiPartyMemberList[index]._class:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())

				elseif ( _partyData[index]._class == UI_Class.ClassType_BladeMasterWomen ) then	-- 매화(여자 무사)
				classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
				_uiPartyMemberList[index]._class:ChangeTextureInfoName(classTypeTexture)
					local x1, y1, x2, y2 = setTextureUV_Func( _uiPartyMemberList[index]._class, 198, 87, 228, 117 )
					_uiPartyMemberList[index]._class:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())

				elseif ( _partyData[index]._class == UI_Class.ClassType_Valkyrie ) then	-- 발키리
				classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
				_uiPartyMemberList[index]._class:ChangeTextureInfoName(classTypeTexture)
					local x1, y1, x2, y2 = setTextureUV_Func( _uiPartyMemberList[index]._class, 167, 87, 197, 117 )
					_uiPartyMemberList[index]._class:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())

				elseif ( _partyData[index]._class == UI_Class.ClassType_Wizard ) then	-- 위자드
				classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
				_uiPartyMemberList[index]._class:ChangeTextureInfoName(classTypeTexture)
					local x1, y1, x2, y2 = setTextureUV_Func( _uiPartyMemberList[index]._class, 198, 118, 228, 148 )
					_uiPartyMemberList[index]._class:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())

				elseif ( _partyData[index]._class == UI_Class.ClassType_WizardWomen ) then	-- 위치(여자 위자드)
				classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
				_uiPartyMemberList[index]._class:ChangeTextureInfoName(classTypeTexture)
					local x1, y1, x2, y2 = setTextureUV_Func( _uiPartyMemberList[index]._class, 198, 149, 228, 179 )
					_uiPartyMemberList[index]._class:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())

				elseif ( _partyData[index]._class == UI_Class.ClassType_NinjaWomen ) then	-- 쿠노이치
				classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
				_uiPartyMemberList[index]._class:ChangeTextureInfoName(classTypeTexture)
					local x1, y1, x2, y2 = setTextureUV_Func( _uiPartyMemberList[index]._class, 201, 25, 231, 55 )
					_uiPartyMemberList[index]._class:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())

				elseif ( _partyData[index]._class == UI_Class.ClassType_NinjaMan ) then	-- 닌자
				classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
				_uiPartyMemberList[index]._class:ChangeTextureInfoName(classTypeTexture)
					local x1, y1, x2, y2 = setTextureUV_Func( _uiPartyMemberList[index]._class, 198, 180, 228, 210 )
					_uiPartyMemberList[index]._class:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiPartyMemberList[index]._class:setRenderTexture(_uiPartyMemberList[index]._class:getBaseTexture())

				end
				------------------------------------------------------
				--				파티원 거리 표시
				------------------------------------------------------
				_uiPartyMemberList[index]._distance:SetShow(true)
				_uiPartyMemberList[index]._distance:ChangeTextureInfoName("new_ui_common_forlua/widget/party/party_00.dds")
				if 0 == _partyData[index]._distance then
					local x1, y1, x2, y2 = setTextureUV_Func( _uiPartyMemberList[index]._distance, 152, 1, 174, 23 )
					_uiPartyMemberList[index]._distance:getBaseTexture():setUV(  x1, y1, x2, y2  )

				elseif 1 == _partyData[index]._distance then
					local x1, y1, x2, y2 = setTextureUV_Func( _uiPartyMemberList[index]._distance, 176, 1, 198, 23 )
					_uiPartyMemberList[index]._distance:getBaseTexture():setUV(  x1, y1, x2, y2  )
				elseif 2 == _partyData[index]._distance then
					local x1, y1, x2, y2 = setTextureUV_Func( _uiPartyMemberList[index]._distance, 200, 1, 222, 23 )
					_uiPartyMemberList[index]._distance:getBaseTexture():setUV(  x1, y1, x2, y2  )
				elseif 3 == _partyData[index]._distance then
					local x1, y1, x2, y2 = setTextureUV_Func( _uiPartyMemberList[index]._distance, 224, 1, 246, 23 )
					_uiPartyMemberList[index]._distance:getBaseTexture():setUV(  x1, y1, x2, y2  )
				end
				_uiPartyMemberList[index]._distance:setRenderTexture(_uiPartyMemberList[index]._distance:getBaseTexture())
				_uiPartyMemberList[index]._distance:addInputEvent("Mouse_On", "PartyPop_SimpleTooltip_Show( true, 1," .. index .. "," .. _partyData[index]._distance .." )")
				_uiPartyMemberList[index]._distance:addInputEvent("Mouse_Out", "PartyPop_SimpleTooltip_Show( false, 1," .. index .. "," .. _partyData[index]._distance .." )")
				_uiPartyMemberList[index]._distance:setTooltipEventRegistFunc("PartyPop_SimpleTooltip_Show( true, 1," .. index .. "," .. _partyData[index]._distance .." )")

				------------------------------------------------------
				--					캐릭터가 사망했다!!
				if ( 0 >= _partyData[index]._nowHp ) then
					_uiPartyMemberList[index]._conditionBG:SetShow( true )
					_uiPartyMemberList[index]._conditionTxt:SetShow( true )
					_uiPartyMemberList[index]._conditionTxt:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_PARTY_DEATH" ) )
				elseif ( _partyData[index]._nowHp >= 1 ) then
					_uiPartyMemberList[index]._conditionBG:SetShow( false )
					_uiPartyMemberList[index]._conditionTxt:SetShow( false )
					_uiPartyMemberList[index]._conditionTxt:SetText( "" )
				end
				-- 리더이면!
				if true == _partyData[index]._isMaster then
					_uiPartyMemberList[index]._leader:SetShow( true )
				else
					_uiPartyMemberList[index]._leader:SetShow( false )
				end

				if _partyData[index]._isSelf then
					_uiPartyMemberList[index]._styleFollowBtn:SetShow(false)
					_uiPartyMemberList[index]._distance:SetShow( false )
					_uiPartyMemberList[index]._distance:SetSpanSize( -125, _uiPartyMemberList[index]._distance:GetSpanSize().y )
				else
					_uiPartyMemberList[index]._styleFollowBtn:SetShow(true)
					if _uiPartyMemberList[index]._stylePartyOptionBtn:GetShow() then
						_uiPartyMemberList[index]._styleFollowBtn:SetSpanSize( -165, _uiPartyMemberList[index]._styleFollowBtn:GetSpanSize().y )
					else
						_uiPartyMemberList[index]._styleFollowBtn:SetSpanSize( -185, _uiPartyMemberList[index]._styleFollowBtn:GetSpanSize().y )
					end
					_uiPartyMemberList[index]._distance:SetSpanSize( _uiPartyMemberList[index]._styleFollowBtn:GetSpanSize().x+23, _uiPartyMemberList[index]._distance:GetSpanSize().y )
				end
				
				_uiPartyMemberList[index]._base:SetShow(true)
			else
				_uiPartyMemberList[index]._base:SetShow(false)
			end
		end

		if(_preLootType ~= nil ) and (_preLootType ~= PLT2S[lootType]) then
			local rottingMsg = PAGetString( Defines.StringSheet_GAME, "PANEL_PARTY_CHANGE_LOOTING_RULE1" ) .. " " .. PLT2S[lootType] .. PAGetString( Defines.StringSheet_GAME, "PANEL_PARTY_CHANGE_LOOTING_RULE2" )
			-- 획득 방식을 변경하였습니다.
			_uiComboLootingOption:SetText(PLT2S[lootType])
			Proc_ShowMessage_Ack(rottingMsg)
		elseif nil == _preLootType then
			_uiComboLootingOption:SetText(PLT2S[lootType])
		end

		-- _styleLootType:SetText(PAGetString( Defines.StringSheet_GAME, "PANEL_PARTY_LOOTING_RULE" ) .. " : " )		-- 획득 방식
		_preLootType = PLT2S[lootType]
		if 4 ~= lootType then
			FGlobal_PartyInventoryClose()
		else
			-- _uiButtonPartyInven:SetEnable( true )
			-- _uiButtonPartyInven:SetMonoTone( false )
			FGlobal_PartyInventoryOpen()
			-- Panel_Window_PartyInventory:SetPosY( partyMemberCount*Panel_Party:GetPosY() -30 )
			for i=1, partyMemberCount do
				Panel_Window_PartyInventory:SetPosY( (i*Panel_Party:GetSizeY())+Panel_Party:GetPosY() +40 )
			end
		end

		if(0 == partyMemberCount) then
			_styleLootType:SetShow(false)
			-- _uiComboLootingOption:SetShow(false)
			Panel_Party:SetShow(false, false)
			requestPlayerList = {}
			Panel_PartyOption:SetShow(false, false)
			-- Panel_WidgetControl_Toggle("Panel_Party", false)
		else
			-- _uiButtonPartyInven:SetPosY( partyMemberCount*Panel_Party:GetSizeY() +10 )
			-- _uiButtonPartyInven:SetPosX( _styleLootType:GetPosX() )
			-- _styleLootType:SetPosY(partyMemberCount*Panel_Party:GetSizeY()+20)
			-- _styleLootType:SetShow(true)
			-- _uiComboLootingOption:SetPosY(partyMemberCount*Panel_Party:GetSizeY()+10)
			_uiComboLootingOption:SetSpanSize( 3, partyMemberCount*Panel_Party:GetSizeY()+10 )
			-- _uiComboLootingOption:SetPosX( _uiComboLootingOption:GetSizeX() - _uiComboLootingOption:GetPosX() )
		end
		_partyMemberCount = partyMemberCount
		
		
		---- 매치정보 버튼 ---------------------------------------------------------------------------------
		if isContentsEnable then
			if 0 < _partyMemberCount then	-- 파티원이 1명 이상일때
				Match_Button_Info		:SetShow( true )
				Match_Button_Info		:SetSpanSize( _uiComboLootingOption:GetSpanSize().x + 115, _uiComboLootingOption:GetSpanSize().y -1 )	-- 매치정보 버튼 위치잡기
				Match_Button_Info		:ComputePos()
				
				if (isMainChannel) or (isDevServer) then	-- 1채널이거나 개발자 서버일때만 호출
					FGlobal_UpdatePartyState( _partyMemberCount, RequestParty_isLeader() )
				end
			end
			partyPenalty:SetPosX( Match_Button_Info:GetSpanSize().x+60 )
			partyPenalty:SetPosY( Match_Button_Info:GetSpanSize().y-1 )
		else
			partyPenalty:SetPosX( _uiComboLootingOption:GetSizeX() + _uiComboLootingOption:GetSpanSize().x+10 )
			partyPenalty:SetPosY( _uiComboLootingOption:GetSpanSize().y-1 )
			Match_Button_Info		:SetShow( false )
		end
		----------------------------------------------------------------------------------------------------
		
		
		if RequestParty_isLeader() then
			partyMarketOption:addInputEvent( "Mouse_LUp", "Party_RegistItem_Show()" )
		else
			partyMarketOption:addInputEvent( "Mouse_LUp", "Party_ShowMessageAlert()" )
		end
		
		btnSpecialGoods:addInputEvent( "Mouse_LUp", "Panel_Party_ItemList_Open()" )
		
		if firstCheck < partyMemberCount then
			firstCheck = firstCheck + 1
			
		else
			local currentPrice = RequestParty_getDistributionPrice()
			local currentGrade = RequestParty_getDistributionGrade()
			if (currentPrice ~= savedPrice or currentGrade ~= savedGrade) and (registMarket) then
				Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_CHANGE_OPTION") ) -- 거래소 특가상품 등록을 위한 파티 분배 옵션이 설정되었습니다.
				savedPrice = currentPrice
				savedGrade = currentGrade
			end
			
			local sizeY = isShow_PartyMatchBg()
			registItem._bg:SetPosY((partyMemberCount*Panel_Party:GetSizeY()) + 40 + sizeY )
		end
	end
end

function FGlobal_PartyMemberCount()
	return _partyMemberCount
end


local messageBox_party_accept = function()
	requestPlayerList = {}
	RequestParty_acceptInvite()
end


local messageBox_party_refuse = function()
	RequestParty_refuseInvite()
	
	for ii = 0, #requestPlayerList do
		if requestPlayerList[ii] == refuseName then
			requestPlayerList[ii] = ""
			return
		end
	end
end


function ResponseParty_withdraw( withdrawType, actorKey, isMe )

	-- withdrawType
	local message = ""
	if 0 == withdrawType then -- 스스로 탈퇴
		if( isMe ) then
			message = PAGetString( Defines.StringSheet_GAME, "PANEL_PARTY_LEAVE_PARTY_SELF" )
		else
			local actorProxyWrapper = getActor(actorKey)
			if ( nil ~= actorProxyWrapper ) then
				local textName = actorProxyWrapper:getName()
				message = tostring(textName) .. PAGetString( Defines.StringSheet_GAME, "PANEL_PARTY_LEAVE_PARTY_MEMBER" )
			end
		end
	elseif 1 == withdrawType then -- 추방

		if( isMe ) then
			message = PAGetString( Defines.StringSheet_GAME, "PANEL_PARTY_FORCEOUT_SELF" )
		else
			local actorProxyWrapper = getActor(actorKey)
			if ( nil ~= actorProxyWrapper ) then
				local textName = actorProxyWrapper:getName()
				message = tostring(textName) .. PAGetString( Defines.StringSheet_GAME, "PANEL_PARTY_FORCEOUT_MEMBER" )
			end
		end

	elseif 2 == withdrawType then -- 파티 해산

		message = PAGetString( Defines.StringSheet_GAME, "PANEL_PARTY_DISPERSE" )

	end

	Proc_ShowMessage_Ack( message )
	partyPenalty:SetPosX( Match_Button_Info:GetSpanSize().x+60 )
	partyPenalty:SetPosY( Match_Button_Info:GetSpanSize().y-1 )
	--chatting_sendMessage( "", message, CppEnums.ChatType.System )
end


function ResponseParty_changeLeader( actorKey )
	local actorProxyWrapper = getActor(actorKey)
	if ( nil == actorProxyWrapper ) then
		return
	end
	local textName = actorProxyWrapper:getName()
	Proc_ShowMessage_Ack( tostring(textName) .. PAGetString( Defines.StringSheet_GAME, "PANEL_PARTY_CHANGE_PARTY_LEADER" ) )
	ResponseParty_updatePartyList()
	Party_RegistItem_Show( false )	-- 파티장 위임 시 파티분배 옵션창 닫기
end


function ResponseParty_refuse(reason)
	local contentString = reason
	local messageboxData = { title = PAGetString( Defines.StringSheet_GAME, "PARTY_INVITE_MESSAGEBOX_TITLE" ), content = contentString, functionYes = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
end


function ResponseParty_invite( hostName )
	for ii = 0, #requestPlayerList do
		if requestPlayerList[ii] == hostName then
			--_PA_LOG( "TESTAAAAa", "중복 : " .. ii .. " " .. requestPlayerList[ii] .. " : " .. #requestPlayerList )
			return
		end
	end
	
	refuseName = hostName
	
	requestPlayerList[#requestPlayerList] = hostName
	
	local messageboxMemo	= hostName .. PAGetString( Defines.StringSheet_GAME, "PANEL_PARTY_INVITE_ACCEPT" )	--"님이 파티에 초대하셨습니다. 수락하시겠습니까?"
	local messageboxData	= { title = PAGetString( Defines.StringSheet_GAME, "PARTY_INVITE_MESSAGEBOX_TITLE"), content = messageboxMemo, functionYes = messageBox_party_accept, functionNo = messageBox_party_refuse, priority = PP.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
end


function PartyPop_clickChangeLeader( index )
	RequestParty_changeLeader( index )
	local memberData = RequestParty_getPartyMemberAt(index)
	--Proc_ShowMessage_Ack(memberData:name()..PAGetString( Defines.StringSheet_GAME, "PANEL_PARTY_CHANGE_PARTY_LEADER" ) ) -- "님으로 파티장으로 변경되었습니다."
	closePartyOption()
end


function PartyPop_clickWithdrawMember( index )
	local partyOut = function()
		RequestParty_withdrawMember( index )
		FGlobal_PartyInventoryClose()
		Proc_ShowMessage_Ack(PAGetString( Defines.StringSheet_GAME, "PANEL_PARTY_LEAVE_PARTY_SELF" ))
		closePartyOption()
	end

	-- local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_WITHDRAW_MSGBOX")
	local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_GETOUTPARTY") -- "파티를 탈퇴하시겠습니까?"
	local messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"), content = messageBoxMemo, functionYes = partyOut, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData)
end


function messageBox_party_withdrawMember()
	local memberData = RequestParty_getPartyMemberAt(withdrawMember)
	RequestParty_withdrawMember( withdrawMember )
	Proc_ShowMessage_Ack( memberData:name() .. PAGetString(Defines.StringSheet_GAME, "PANEL_PARTY_FORCEOUT_MEMBER") )	--"님이 파티에서 추방되었습니다."
end


function PartyPop_clickBanishMember( index )
	withdrawMember = index
	local memberData = RequestParty_getPartyMemberAt(index)
	local contentString = memberData:name().. PAGetString( Defines.StringSheet_GAME, "PANEL_PARTY_FORCEOUT_QUESTION" )--"님을 파티에서 추방하시겠습니까?"
	local titleForceOut = PAGetString( Defines.StringSheet_GAME, "PANEL_PARTY_FORCEOUT" )
	local messageboxData = { title = titleForceOut, content = contentString, functionYes = messageBox_party_withdrawMember, functionCancel = MessageBox_Empty_function, priority = PP.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
	closePartyOption()
end


local ResponseParty_showList = function( idx )
	
	local index = _partyData[idx]._index
	local isShow = Panel_PartyOption:IsShow()
	if isShow == true and _last_Index == idx then
		closePartyOption()
	else
		-- local posY = 250 + controlTemplate._styleBackGround:GetSizeY()*(0.75*idx)
		local posY = _uiPartyMemberList[idx]._stylePartyOptionBtn:GetParentPosY() - 2
		local posX = _uiPartyMemberList[idx]._stylePartyOptionBtn:GetParentPosX() + _uiPartyMemberList[idx]._stylePartyOptionBtn:GetSizeX()
		--local posX = controlTemplate._styleBackGround:GetSizeX()
		
		---- PvP 신청 상태일 경우 파티 옵션 버튼 꺼줌 -----------------------------------------
		if isContentsEnable then
			if _partyData[idx]._isSelf == true then
				_uiButtonWithdrawMember:SetText(PAGetString( Defines.StringSheet_GAME, "PANEL_PARTY_SELF_OUT" ))		--파티 탈퇴
				_uiButtonWithdrawMember:addInputEvent( "Mouse_LUp", "PartyPop_clickWithdrawMember("..index..")")
				_uiButtonWithdrawMember:SetShow(true)
				_uiButtonChangeLeader:SetShow(false)
			
				-- 켜준다
				Panel_PartyOption:SetPosX(posX)
				Panel_PartyOption:SetPosY(posY)
				Panel_PartyOption:SetShow(true,true)
			
			else
				if _partyData[0]._isMaster == true then
					_uiButtonWithdrawMember:SetText(PAGetString( Defines.StringSheet_GAME, "PANEL_PARTY_MEMBER_FORCEOUT" ))		-- 파티원 추방
					_uiButtonWithdrawMember:addInputEvent( "Mouse_LUp", "PartyPop_clickBanishMember("..index..")")
					_uiButtonChangeLeader:addInputEvent( "Mouse_LUp", "PartyPop_clickChangeLeader("..index..")")
					_uiButtonChangeLeader:SetShow(true)
			
					-- 켜준다
					Panel_PartyOption:SetPosX(posX)
					Panel_PartyOption:SetPosY(posY)
					Panel_PartyOption:SetShow(true,true)
				else
					_uiButtonWithdrawMember:SetShow(false)
					_uiButtonChangeLeader:SetShow(false)
			
				end
			end
		else
			if _partyData[idx]._isSelf == true then
				_uiButtonWithdrawMember:SetText(PAGetString( Defines.StringSheet_GAME, "PANEL_PARTY_SELF_OUT" ))		--파티 탈퇴
				_uiButtonWithdrawMember:addInputEvent( "Mouse_LUp", "PartyPop_clickWithdrawMember("..index..")")
				_uiButtonWithdrawMember:SetShow(true)
				_uiButtonChangeLeader:SetShow(false)
			
				-- 켜준다
				Panel_PartyOption:SetPosX(posX)
				Panel_PartyOption:SetPosY(posY)
				Panel_PartyOption:SetShow(true,true)
			
			else
				if _partyData[0]._isMaster == true then
					_uiButtonWithdrawMember:SetText(PAGetString( Defines.StringSheet_GAME, "PANEL_PARTY_MEMBER_FORCEOUT" ))		-- 파티원 추방
					_uiButtonWithdrawMember:addInputEvent( "Mouse_LUp", "PartyPop_clickBanishMember("..index..")")
					_uiButtonChangeLeader:addInputEvent( "Mouse_LUp", "PartyPop_clickChangeLeader("..index..")")
					_uiButtonChangeLeader:SetShow(true)
			
					-- 켜준다
					Panel_PartyOption:SetPosX(posX)
					Panel_PartyOption:SetPosY(posY)
					Panel_PartyOption:SetShow(true,true)
				else
					_uiButtonWithdrawMember:SetShow(false)
					_uiButtonChangeLeader:SetShow(false)
			
				end
			end
		end
		---------------------------------------------------------------------------------------
	end
	_last_Index = idx
end


function PartyPop_clickPartyOption( index )
	ResponseParty_showList( index )
end

function PartyPop_clickPartyFollow( index )
	local selfPlayer = getSelfPlayer()
	local memberData = RequestParty_getPartyMemberAt(index)
	if nil ~= memberData then
		local actorKey = memberData:getActorKey()
		selfPlayer:setFollowActor( actorKey )
	end
end

function PartyPop_SimpleTooltip_Show( isShow, tipType, index, isDistance )
	local name, desc, control = nil, nil, nil
	if 0 == tipType then
		name	= PAGetString(Defines.StringSheet_RESOURCE, "INTERACTION_BTN_FOLLOW_ACTOR" )		-- "따라가기"
		control	= _uiPartyMemberList[index]._styleFollowBtn
	elseif 1 == tipType then
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_SIMPLETOOLTIP_DISTANCE_NAME") --"파티 거리 보너스"
		desc	= PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_SIMPLETOOLTIP_DISTANCE_DESC") --"파티원과 가까이 있어야 더 많은 파티 경험치를 얻을 수 있습니다."
		control	= _uiPartyMemberList[index]._distance
	elseif 2 == tipType then
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_SIMPLETOOLTIP_PENALTY_NAME") --"파티 경험치 무효"
		desc	= PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_SIMPLETOOLTIP_PENALTY_DESC") --"상대와 6 레벨 이상 차이로 인해 파티 경험치를 얻지 못합니다."
		control	= partyPenalty
	end
	registTooltipControl( control, Panel_Tooltip_SimpleText )
	if true == isShow then
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function PartyOption_Hide()
	Panel_PartyOption:SetShow(false)
end


function PartyPop_onLootingOptionUI()
	if RequestParty_isLeader() == true then
		local lootType = RequestParty_getPartyLootType()
		_uiComboLootingOption:DeleteAllItem()
		
		for ii = 0, PLT.LootType_Bound-2 do
			_uiComboLootingOption:AddItem( PLT2S[ii], ii )
		end
		-- _comboBoxList:SetSize( _comboBoxList:GetSizeX(), 80 )
		_uiComboLootingOption:SetSelectItemIndex(lootType)
		--Panel_Party:SetChildOrder(_styleLootType:GetKey(), _uiComboLootingOption:GetKey())
		_uiComboLootingOption:SetShow(true, false)
	end
end


function PartyPop_offLootingOptionUI()
	local list = _uiComboLootingOption:GetListControl();

	if( list:GetShow() ) then
		return
	end
	-- _uiComboLootingOption:SetShow(false, false)
end


function Panel_Party_ShowToggle()
	local isShow = Panel_Party:GetShow()
	if RequestParty_getPartyMemberCount() == 0 then
		return
	end
	-- UI.debugMessage(RequestParty_getPartyMemberCount())
	if isShow == true then
		Panel_Party:SetShow ( false )
		requestPlayerList = {}
	else
		Panel_Party:SetShow ( true )
	end
end


function partWidget_OnscreenEvent()
	-- Panel_Party:ComputePos()
	if ( 0 == RequestParty_getPartyMemberCount() ) then
		Panel_Party:SetShow( false )
		requestPlayerList = {}
	else
		if not isFlushedUI() then
			Panel_Party:SetShow( true )
		end

		ResponseParty_updatePartyList()
	end
	
	changePositionBySever(Panel_Party, CppEnums.PAGameUIType.PAGameUIPanel_Party, false, true, false)
	_uiComboLootingOption:ComputePos()
end

-- 파티원이 아이템을 획득 했을 경우(파티 인벤토리로 획득 했을 경우가 아니다!)
function FromClient_NotifyPartyMemberPickupItem( userName, itemName )
	local message = ""
	message = PAGetStringParam2(Defines.StringSheet_GAME, "GAME_MESSAGE_NOTIFY_PARTYMEMBER_PICKUP_ITEM", "userName", userName, "itemName", itemName)
	Proc_ShowMessage_Ack(message)
end
-- 파티원 가방 획득 방식으로 파티원이 파티인벤토리로 들어가는 아이템을 획득 했을 경우 뿌린다!
function FromClient_NotifyPartyMemberPickupItemFromPartyInventory( userName, itemName, itemCount )
	local message = ""

	message = PAGetStringParam3( Defines.StringSheet_GAME, "GAME_MESSAGE_NOTIFY_PARTYMEMBER_PICKUP_ITEM_FOR_PARTYINVENTORY", "userName", userName, "itemName", itemName, "itemCount", tostring(itemCount) )
	Proc_ShowMessage_Ack(message)
end

function PartyPanel_Repos()
	if not Panel_Window_PetControl:GetShow() then
		-- Panel_LocalWar:SetSpanSize( 10, 200 )
		-- if Panel_LocalWar:GetShow() then
			-- Panel_Party:SetSpanSize( 10, 250 )			-- 파티 위치를 잡아줘야한다.
		-- else
			Panel_Party:SetSpanSize( 10, 200 )
		-- end
	else
		-- Panel_LocalWar:SetSpanSize( 10, 310 )
		-- if Panel_LocalWar:GetShow() then
			-- Panel_Party:SetSpanSize( 10, 360 )			-- 파티 위치를 잡아줘야한다.
		-- else
			Panel_Party:SetSpanSize( 10, 310 )
		-- end
	end
end

function FGlobal_PartyListUpdate()
	ResponseParty_updatePartyList()
end

function FromClient_UpdatePartyExperiencePenalty( isPenalty )
	if nil == isPenalty then
		return
	end
	if isPenalty then
		partyPenalty:SetShow( true )
		partyPenalty:SetPosX( Match_Button_Info:GetSpanSize().x+60 )
		partyPenalty:SetPosY( Match_Button_Info:GetSpanSize().y-1 )
	else
		partyPenalty:SetShow( false )
	end
end

-- _styleLootType			:addInputEvent("Mouse_On",	"PartyPop_onLootingOptionUI()")
_uiComboLootingOption	:addInputEvent("Mouse_LUp",	"Looting_ComboBox()" )
Panel_Party				:addInputEvent("Mouse_LUp",	"ResetPos_WidgetButton()" )			--메인UI위젯 위치 초기화

registerEvent("ResponseParty_createPartyList",								"ResponseParty_createPartyList")
registerEvent("ResponseParty_updatePartyList",								"ResponseParty_updatePartyList")
registerEvent("ResponseParty_invite",										"ResponseParty_invite")
registerEvent("ResponseParty_refuse",										"ResponseParty_refuse")
registerEvent("ResponseParty_changeLeader",									"ResponseParty_changeLeader")
registerEvent("ResponseParty_withdraw",										"ResponseParty_withdraw")
registerEvent("FromClient_GroundMouseClick",								"PartyOption_Hide")
registerEvent("onScreenResize", 											"partWidget_OnscreenEvent" )
registerEvent("FromClient_UpdatePartyExperiencePenalty", 					"FromClient_UpdatePartyExperiencePenalty" )

registerEvent("FromClient_NotifyPartyMemberPickupItem",						"FromClient_NotifyPartyMemberPickupItem")
registerEvent("FromClient_NotifyPartyMemberPickupItemFromPartyInventory",	"FromClient_NotifyPartyMemberPickupItemFromPartyInventory")


ResponseParty_createPartyList()
ResponseParty_updatePartyList()

local postFlushFunction = function()
	--파티원 체크
	if ( 0 == RequestParty_getPartyMemberCount() ) then
		Panel_Party:SetShow( false )
		requestPlayerList = {}
	else
		Panel_Party:SetShow( true )
		ResponseParty_updatePartyList()
	end
end

UI.addRunPostRestorFunction( postFlushFunction )					-- Flush 모드가 true에서 false가 될 때 다시 체크해줌

changePositionBySever(Panel_Party, CppEnums.PAGameUIType.PAGameUIPanel_Party, false, true, false)
