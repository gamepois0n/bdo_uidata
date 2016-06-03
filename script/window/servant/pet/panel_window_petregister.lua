Panel_Window_PetRegister:SetShow(false, false)
Panel_Window_PetRegister:setMaskingChild(true)
Panel_Window_PetRegister:ActiveMouseEventEffect(true)
--Panel_Window_PetRegister:setGlassBackground(true)
Panel_Window_PetRegister:RegisterShowEventFunc( true, '' )
Panel_Window_PetRegister:RegisterShowEventFunc( false, '' )

local	UI_ANI_ADV	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local	UI_color	= Defines.Color

local	PetRegister	= {
	_const	=
	{
		createType_Inventory	= 0,	-- 아이템
		createType_ChangeName	= 1,	-- 이름변경
	},
		
	_staticIcon					= UI.getChildControl( Panel_Window_PetRegister, 	"Static_Icon" ),
	_staticHp					= UI.getChildControl( Panel_Window_PetRegister, 	"Static_Hp" ),
	_staticHpValue				= UI.getChildControl( Panel_Window_PetRegister, 	"Static_HpValue" ),
	_staticMp					= UI.getChildControl( Panel_Window_PetRegister, 	"Static_Stamina" ),
	_staticMpValue				= UI.getChildControl( Panel_Window_PetRegister, 	"Static_StaminaValue" ),
	_staticWeight				= UI.getChildControl( Panel_Window_PetRegister, 	"Static_Weight" ),
	_staticWeightValue			= UI.getChildControl( Panel_Window_PetRegister, 	"Static_WeightValue" ),
	_staticLife					= UI.getChildControl( Panel_Window_PetRegister, 	"Static_Life" ),
	_staticLifeValue			= UI.getChildControl( Panel_Window_PetRegister, 	"Static_LifeValue" ),
	_staticMaxMoveSpeed			= UI.getChildControl( Panel_Window_PetRegister, 	"Static_MaxMoveSpeed" ),
	_staticMaxMoveSpeedValue	= UI.getChildControl( Panel_Window_PetRegister, 	"Static_MaxMoveSpeedValue" ),
	_staticAcceleration			= UI.getChildControl( Panel_Window_PetRegister, 	"Static_Acceleration" ),
	_staticAccelerationValue	= UI.getChildControl( Panel_Window_PetRegister, 	"Static_AccelerationValue" ),
	_staticCorneringSpeed		= UI.getChildControl( Panel_Window_PetRegister, 	"Static_CorneringSpeed" ),
	_staticCorneringSpeedValue	= UI.getChildControl( Panel_Window_PetRegister, 	"Static_CorneringSpeedValue" ),
	_staticBrakeSpeed			= UI.getChildControl( Panel_Window_PetRegister, 	"Static_BrakeSpeed" ),
	_staticBrakeSpeedValue		= UI.getChildControl( Panel_Window_PetRegister, 	"Static_BrakeSpeedValue" ),
	_editEditName				= UI.getChildControl( Panel_Window_PetRegister,	"Edit_Naming"),
	_buttonOk					= UI.getChildControl( Panel_Window_PetRegister,	"Button_Yes"),
	_buttonClose				= UI.getChildControl( Panel_Window_PetRegister,	"Button_No"),
	
	_buttonQuestion				= UI.getChildControl( Panel_Window_PetRegister,	"Button_Question" ),			-- 물음표 버튼
	
	_inventoryType				= nil,
	_inventorySlotNo			= nil,
	_servantSlotNo				= nil,
	_type						= nil,
}

----------------------------------------------------------------------------------------------------
-- Init Function
function PetRegister:init()
	self._editEditName:SetMaxInput( getNameSize() )
	
	self._staticIcon:SetShow(true)
	self._staticHp:SetShow(true)
	self._staticHpValue:SetShow(true)
	self._staticMp:SetShow(true)
	self._staticMpValue:SetShow(true)
	self._staticWeight:SetShow(true)
	self._staticWeightValue:SetShow(true)	
	self._staticLife:SetShow(true)
	self._staticLifeValue:SetShow(true)
	self._staticMaxMoveSpeed:SetShow(true)
	self._staticMaxMoveSpeedValue:SetShow(true)
	self._staticAcceleration:SetShow(true)
	self._staticAccelerationValue:SetShow(true)
	self._staticCorneringSpeed:SetShow(true)
	self._staticCorneringSpeedValue:SetShow(true)
	self._staticBrakeSpeed:SetShow(true)
	self._staticBrakeSpeedValue:SetShow(true)	
	
	self._editEditName:SetShow(true)
	self._buttonOk:SetShow(true)
	self._buttonClose:SetShow(true)
end

function PetRegister:update()

	local	servantInfo	= stable_getServantByCharacterKey( self._characterKey, self._level )
	if	( nil == servantInfo )	then
		return
	end
	
	self._editEditName:SetEditText( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_EDITBOX_COMMENT"), true )

	self._staticIcon:ChangeTextureInfoName( servantInfo:getIconPath1() )
	-- self._staticHpValue:SetText( servantInfo:getMaxHp() )
	-- self._staticMpValue:SetText( PAGetString(Defines.StringSheet_GAME, "MENTALGAME_BUFF_EMPTY") )
	-- self._staticWeightValue:SetText( tostring(servantInfo:getMaxWeight_s64() / Defines.s64_const.s64_10000) )

	self._staticHpValue:SetText( "-" )
	self._staticMpValue:SetText( "-" )
	self._staticWeightValue:SetText( "-" )
	
	-- if	( servantInfo:isPeriodLimit() )	then
	-- 	self._staticLifeValue:SetText( servantInfo:getStaticExpiredTime() .. PAGetString(Defines.StringSheet_RESOURCE, "STABLE_INFO_TEXT_LIFETIME") )
	-- else
	-- 	self._staticLifeValue:SetText( PAGetString(Defines.StringSheet_RESOURCE, "STABLE_INFO_TEXT_LIFEVALUE"))
	-- end

	self._staticLifeValue:SetText( "-" )

	self._staticMaxMoveSpeedValue:SetText( "-" )
	self._staticAccelerationValue:SetText( "-" )
	self._staticCorneringSpeedValue:SetText( "-" )
	self._staticBrakeSpeedValue:SetText( "-" )
end

function	PetRegister:registEventHandler()
	self._buttonOk:addInputEvent(		"Mouse_LUp",	"PetRegister_Register()"	)
	self._buttonClose:addInputEvent(	"Mouse_LUp",	"PetRegister_Close()"		)
	self._editEditName:addInputEvent(	"Mouse_LUp",	"PetRegister_EditClear()"	)
	
	self._buttonQuestion:addInputEvent(	"Mouse_LUp",	"Panel_WebHelper_ShowToggle( \"PanelWindowStableRegister\" )"			)	--물음표 좌클릭
	self._buttonQuestion:addInputEvent(	"Mouse_On",		"HelpMessageQuestion_Show( \"PanelWindowStableRegister\", \"true\")"	)   --물음표 마우스오버
	self._buttonQuestion:addInputEvent(	"Mouse_Out",	"HelpMessageQuestion_Show( \"PanelWindowStableRegister\", \"false\")"	)   --물음표 마우스아웃
end

function	PetRegister:registMessageHandler()
	registerEvent(	"onScreenResize",				"PetRegister_Resize"		)
	registerEvent(	"FromClient_ServantChildInfo",	"PetRegister_OpenByMating"	)	
end

function	PetRegister_Resize()
	local	self	= PetRegister
	
	screenX	= getScreenSizeX()
	screenY	= getScreenSizeY()

	--Panel_Window_StableRegister:SetSize(screenX, screenY )
	Panel_Window_PetRegister:ComputePos()

	self._staticIcon:ComputePos()
	self._staticHp:ComputePos()
	self._staticHpValue:ComputePos()
	self._staticMp:ComputePos()
	self._staticMpValue:ComputePos()
	self._staticWeight:ComputePos()
	self._staticWeightValue:ComputePos()	
	self._staticLife:ComputePos()
	self._staticLifeValue:ComputePos()
	self._staticMaxMoveSpeed:ComputePos()
	self._staticMaxMoveSpeedValue:ComputePos()
	self._staticAcceleration:ComputePos()
	self._staticAccelerationValue:ComputePos()
	self._staticCorneringSpeed:ComputePos()
	self._staticCorneringSpeedValue:ComputePos()
	self._staticBrakeSpeed:ComputePos()
	self._staticBrakeSpeedValue:ComputePos()
end

----------------------------------------------------------------------------------------------------
-- Button Function
function	PetRegister_Register()
	-- ♬ 애완동물을 등록한다.
	audioPostEvent_SystemUi(00,00)
	
	local	self	= PetRegister
	local	name	= self._editEditName:GetEditText()
		
	if	self._const.createType_Inventory == self._type	then
		stable_registerByItem( self._inventoryType, self._inventorySlotNo, name )
	elseif	self._const.createType_ChangeName == self._type	then
		stable_changeName( self._servantSlotNo, name )
	elseif	self._const.createType_Mating == self._type	then
		stable_receiveServantMatingChild( PetList_SelectSlotNo(), name )
	else
		UI.ASSERT( false, "에러!" )
	end
	
	self._editEditName:SetEditText("", true)
end

function	PetRegister_EditClear()
	local	self	= PetRegister
	
	self._editEditName:SetEditText("", true)
	SetFocusEdit(self._editEditName)
end

----------------------------------------------------------------------------------------------------
-- Window Open Function
function	PetRegister_OpenByInventory( inventoryType, inventorySlotNo )
	local	self		= PetRegister
	local	itemWrapper = getInventoryItemByType( inventoryType, inventorySlotNo )
	if	nil == itemWrapper	then
		return
	end
	
	self._type				= self._const.createType_Inventory
	self._inventoryType		= inventoryType
	self._inventorySlotNo	= inventorySlotNo
	self._characterKey		= itemWrapper:getStaticStatus():getObjectKey()
	self._level				= 1
	PetRegister_Open()
end

function	PetRegister_OpenByChangeName( slotNo )
	local	self		= PetRegister
	local	servantInfo	= stable_getServant( slotNo )
	if	nil == servantInfo	then
		return
	end
	
	self._type			= self._const.createType_ChangeName
	self._servantSlotNo	= slotNo
	self._characterKey	= servantInfo:getCharacterKey()
	self._level			= servantInfo:getLevel()
	PetRegister_Open()
end

function	PetRegister_OpenByMating( characterKey )
	if	( CppEnums.ServantType.Type_Pet ~= stable_getServantType() )	then
		return
	end
	
	local	self		= PetRegister
	
	self._type			= self._const.createType_Mating
	self._characterKey	= characterKey
	self._level			= 1
	PetRegister_Open()
end
----------------------------------------------------------------------------------------------------
-- Window Open/Close
function	PetRegister_Open()
	if	( Panel_Window_PetRegister:IsShow() )	then
		return
	end
	
	local	self	= PetRegister	
	PetRegister:update()
	
	Panel_Window_PetRegister:SetShow( true )
end

function	PetRegister_Close()
	audioPostEvent_SystemUi(00,00)
	
	if	not Panel_Window_PetRegister:IsShow()	then
		return
	end
	
	Panel_Window_PetRegister:SetShow( false )
	audioPostEvent_SystemUi(01,01)
end
----------------------------------------------------------------------------------------------------
-- Init
PetRegister:init()
PetRegister:registEventHandler()
PetRegister:registMessageHandler()

PetRegister_Resize()