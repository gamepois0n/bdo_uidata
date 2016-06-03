local UI_Class = CppEnums.ClassType
local UI_ANI_ADV	= CppEnums.PAUI_ANIM_ADVANCE_TYPE

Panel_TransferLifeExperience:SetShow( false )
Panel_TransferLifeExperience:RegisterShowEventFunc( true, 'TransferLife_ShowAni()' )
Panel_TransferLifeExperience:RegisterShowEventFunc( false, 'TransferLife_HideAni()' )
Panel_TransferLifeExperience:ActiveMouseEventEffect(true)
Panel_TransferLifeExperience:setGlassBackground(true)

local TransferLife	= {
	itemWhereType			= nil,
	itemSlotNo				= nil,
	itemLifeType			= nil,
	characterIndex			= nil,
	characterNo_64			= nil,

	panelBG					= UI.getChildControl(Panel_TransferLifeExperience, "Static_PanelBG"),
	btn_Confirm				= UI.getChildControl(Panel_TransferLifeExperience, "Button_Confirm"),
	btn_Cancel				= UI.getChildControl(Panel_TransferLifeExperience, "Button_Cancel"),
	btn_Close				= UI.getChildControl(Panel_TransferLifeExperience, "Button_Win_Close"),
	_scroll					= UI.getChildControl(Panel_TransferLifeExperience, "Scroll_TransferLife"),
	notify					= UI.getChildControl(Panel_TransferLifeExperience, "Static_Notify"),

	maxSlotCount 			= 4,
	listCount				= 0,
	startPos_characterBtn	= 5,
	startCharacterIdx		= 0,
	Slot					= {},
}
TransferLife._scrollBtn	= UI.getChildControl( TransferLife._scroll, "Scroll_CtrlButton" )
TransferLife.btn_Cancel	:addInputEvent("Mouse_LUp", "TransferLife_Close()")
TransferLife.btn_Close	:addInputEvent("Mouse_LUp", "TransferLife_Close()")

function TransferLife_ShowAni()
	Panel_TransferLifeExperience:SetAlpha( 0 )
	UIAni.AlphaAnimation( 1, Panel_TransferLifeExperience, 0.0, 0.15 )

	local aniInfo1 = Panel_TransferLifeExperience:addScaleAnimation( 0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(1.5)
	aniInfo1:SetEndScale(0.8)
	aniInfo1.AxisX = Panel_TransferLifeExperience:GetSizeX() / 2
	aniInfo1.AxisY = Panel_TransferLifeExperience:GetSizeY() / 2
	aniInfo1.ScaleType = 0
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_TransferLifeExperience:addScaleAnimation( 0.15, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(0.8)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_TransferLifeExperience:GetSizeX() / 2
	aniInfo2.AxisY = Panel_TransferLifeExperience:GetSizeY() / 2
	aniInfo2.ScaleType = 0
	aniInfo2.IsChangeChild = true
end
function TransferLife_HideAni()
	Panel_TransferLifeExperience:SetAlpha( 1 )
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_TransferLifeExperience, 0.0, 0.1 )
	aniInfo:SetHideAtEnd(true)
end

local TransferLife_Initialize = function()
	local self = TransferLife

	self.notify:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
	self.notify:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TRANSFERLIFEEXPERIENCE_NOTIFY") ) -- - 접속한 캐릭터의 해당 생활 경험치를 선택한 캐릭터로 이전할 수 있습니다.

	for slotIdx = 0, self.maxSlotCount -1 do
		local slotBtn = UI.createAndCopyBasePropertyControl( Panel_TransferLifeExperience, "Button_Character0",	self.panelBG,	"TransferLife_CharacterBTN_"	.. slotIdx )
		slotBtn:SetPosY( self.startPos_characterBtn + ( (slotBtn:GetSizeY() + 5) * slotIdx )  )
		slotBtn:addInputEvent(	"Mouse_UpScroll",	"TransferLife_ScrollEvent( true )"	)
		slotBtn:addInputEvent(	"Mouse_DownScroll",	"TransferLife_ScrollEvent( false )"	)
		self.Slot[slotIdx] = slotBtn
	end

	self.panelBG:addInputEvent(	"Mouse_UpScroll",	"TransferLife_ScrollEvent( true )"	)
	self.panelBG:addInputEvent(	"Mouse_DownScroll",	"TransferLife_ScrollEvent( false )"	)

	UIScroll.InputEvent( self._scroll, "TransferLife_ScrollEvent" )

	self.characterNo_64 = getSelfPlayer():getCharacterNo_64()
end
TransferLife_Initialize()

local ChangeTexture_Class = function( control, classType )
	if ( classType == UI_Class.ClassType_Warrior ) then
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_00.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 1, 458, 61 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())
		
		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 62, 458, 122 )
		control:getOnTexture():setUV(  x1, y1, x2, y2  )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 123, 458, 183 )
		control:getClickTexture():setUV(  x1, y1, x2, y2  )

	elseif ( classType == UI_Class.ClassType_Ranger ) then
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_00.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 184, 458, 244 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())

		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 245, 458, 305 )
		control:getOnTexture():setUV(  x1, y1, x2, y2  )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 306, 458, 366 )
		control:getClickTexture():setUV(  x1, y1, x2, y2  )

	elseif ( classType == UI_Class.ClassType_Sorcerer ) then
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_00.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 367, 458, 427 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())

		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 428, 458, 488 )
		control:getOnTexture():setUV(  x1, y1, x2, y2  )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_01.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 1, 458, 61 )
		control:getClickTexture():setUV(  x1, y1, x2, y2  )

	elseif ( classType == UI_Class.ClassType_Giant ) then
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_01.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 62, 458, 122 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())

		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_01.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 123, 458, 183 )
		control:getOnTexture():setUV(  x1, y1, x2, y2  )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_01.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 184, 458, 244 )
		control:getClickTexture():setUV(  x1, y1, x2, y2  )

	elseif ( classType == UI_Class.ClassType_Tamer ) then
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_02.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 1, 458, 61 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())

		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_02.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 62, 458, 122 )
		control:getOnTexture():setUV( x1, y1, x2, y2 )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_02.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 123, 458, 183 )
		control:getClickTexture():setUV( x1, y1, x2, y2 )

	elseif ( classType == UI_Class.ClassType_BladeMaster ) then
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_02.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 184, 458, 244 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())

		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_02.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 245, 458, 305 )
		control:getOnTexture():setUV( x1, y1, x2, y2 )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_02.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 306, 458, 366 )
		control:getClickTexture():setUV( x1, y1, x2, y2 )

	elseif ( classType == UI_Class.ClassType_BladeMasterWomen ) then
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_04.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 184, 458, 244 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())

		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_04.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 245, 458, 305 )
		control:getOnTexture():setUV( x1, y1, x2, y2 )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_04.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 306, 458, 366 )
		control:getClickTexture():setUV( x1, y1, x2, y2 )

	elseif ( classType == UI_Class.ClassType_Valkyrie ) then
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_04.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 1, 458, 61 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())

		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_04.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 62, 458, 122 )
		control:getOnTexture():setUV( x1, y1, x2, y2 )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_04.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 123, 458, 183 )
		control:getClickTexture():setUV( x1, y1, x2, y2 )

	elseif ( classType == UI_Class.ClassType_Wizard ) then
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_05.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 1, 458, 61 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())

		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_05.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 62, 458, 122 )
		control:getOnTexture():setUV( x1, y1, x2, y2 )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_05.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 123, 458, 183 )
		control:getClickTexture():setUV( x1, y1, x2, y2 )

	elseif ( classType == UI_Class.ClassType_WizardWomen ) then
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_05.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 184, 458, 244 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())

		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_05.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 245, 458, 305 )
		control:getOnTexture():setUV( x1, y1, x2, y2 )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_05.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 306, 458, 366 )
		control:getClickTexture():setUV( x1, y1, x2, y2 )

	elseif ( classType == UI_Class.ClassType_NinjaWomen ) then
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_06.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 184, 458, 244 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())

		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_06.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 245, 458, 305 )
		control:getOnTexture():setUV( x1, y1, x2, y2 )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_06.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 306, 458, 366 )
		control:getClickTexture():setUV( x1, y1, x2, y2 )

	elseif ( classType == UI_Class.ClassType_NinjaMan ) then
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_07.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 1, 458, 61 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())

		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_07.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 62, 458, 122 )
		control:getOnTexture():setUV( x1, y1, x2, y2 )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_07.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 123, 458, 183 )
		control:getClickTexture():setUV( x1, y1, x2, y2 )

	else
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_01.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 245, 458, 305 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())
		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_01.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 306, 458, 366 )
		control:getOnTexture():setUV(  x1, y1, x2, y2  )
		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_01.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 367, 458, 427 )
		control:getClickTexture():setUV(  x1, y1, x2, y2  )
	end
end

local TransferLife_Update = function()
	local self = TransferLife
	for slotIdx = 0, self.maxSlotCount - 1 do	-- 초기화
		local slotBtn = self.Slot[slotIdx]
		slotBtn:SetShow( false )
	end

	self.listCount = getCharacterDataCount()

	if self.maxSlotCount < self.listCount then
		self._scroll:SetShow( true )
	else
		self._scroll:SetShow( false )
	end

	local uiIdx = 0
	for slotIdx = self.startCharacterIdx, self.listCount - 1 do
		if self.maxSlotCount <= uiIdx then
			return
		end

		local slotBtn = self.Slot[uiIdx]
		slotBtn:SetMonoTone( false )
		slotBtn:SetEnable( true )

		local characterData		= getCharacterDataByIndex( slotIdx )
		local characterName		= getCharacterName( characterData )
		local classType			= getCharacterClassType( characterData )
		local characterLevel	= string.format( "Lv.%d", characterData._level )

		if self.characterNo_64 == characterData._characterNo_s64 then
			characterName = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_TRANSFERLIFEEXPERIENCE_CHARACTERNAME", "characterName", characterName ) -- characterName .. "(접속중)"
			slotBtn:SetMonoTone(true)
			slotBtn:SetEnable(false)
		end

		slotBtn:SetText( characterLevel .. " " .. characterName )
		slotBtn:addInputEvent("Mouse_LUp", "TransferLife_SelectedCharacter(" .. slotIdx .. ")")
		ChangeTexture_Class( slotBtn, classType )
		
		slotBtn:SetShow( true )

		uiIdx = uiIdx + 1
	end
end

function TransferLife_Open()
	Panel_TransferLifeExperience:SetShow( true, true )
	
	TransferLife._scroll:SetControlPos(0)
end
function TransferLife_Close()
	Panel_TransferLifeExperience:SetShow( false, false )
end
function FGlobal_TransferLife_Close()
	TransferLife_Close()
end

function TransferLife_ScrollEvent( isUp )
	local	self		= TransferLife
	self.startCharacterIdx	= UIScroll.ScrollEvent( self._scroll, isUp, self.maxSlotCount, self.listCount, self.startCharacterIdx, 1 )
	
	TransferLife_Update()
end

function TransferLife_SelectedCharacter( slotIdx )
	local self = TransferLife
	self.characterIndex = slotIdx
end

function TransferLife_Confirm()
	local self = TransferLife
	if nil == self.itemWhereType or nil == self.itemSlotNo or nil == self.itemLifeType or nil == self.characterIndex then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_TRANSFERLIFEEXPERIENCE_WRONGVALUE") ) -- 값이 올바르지 않습니다.
		return
	end
	ToClient_requestTransferLifeExperience( self.itemWhereType, self.itemSlotNo, self.itemLifeType, self.characterIndex )
end

registerEvent( "FromClient_RequestUseTransferLifeExperience",   "FromClient_RequestUseTransferLifeExperience" )
registerEvent( "FromClient_TransferLifeExperience",   			"FromClient_TransferLifeExperience" )

function FromClient_RequestUseTransferLifeExperience( fromWhereType, fromSlotNo, lifeType )
	local self = TransferLife
	self.itemWhereType		= fromWhereType
	self.itemSlotNo			= fromSlotNo
	self.itemLifeType		= lifeType
	self.startCharacterIdx	= 0
	TransferLife_Update()
	TransferLife_Open()
end

function FromClient_TransferLifeExperience( lifeType )
	Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_TRANSFERLIFEEXPERIENCE_SUCCESS_TRANSFER") ) -- 경험치가 안전하게 이전됐습니다.
	TransferLife_Close()
end


TransferLife.btn_Confirm:addInputEvent("Mouse_LUp", "TransferLife_Confirm()")