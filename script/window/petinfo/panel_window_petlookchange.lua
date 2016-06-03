local UI_TM			= CppEnums.TextMode
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE
local UI_color		= Defines.Color
local UI_ANI_ADV	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM			= CppEnums.EProcessorInputMode

Panel_Window_PetLookChange:SetShow( false )
Panel_Window_PetLookChange:setGlassBackground( true )
Panel_Window_PetLookChange:ActiveMouseEventEffect( true )

Panel_Window_PetLookChange:RegisterShowEventFunc( true, 'PetLookChangeShowAni()' )
Panel_Window_PetLookChange:RegisterShowEventFunc( false, 'PetLookChangeHideAni()' )

function PetLookChangeShowAni()
end
function PetLookChangeHideAni()
end

local petGeneral =
{
	_btnClose		= UI.getChildControl( Panel_Window_PetLookChange, "Button_Win_Close" ),
	_btnQuestion	= UI.getChildControl( Panel_Window_PetLookChange, "Button_Question" ),
	_selectBg		= UI.getChildControl( Panel_Window_PetLookChange, "Template_Static_ListContentSelectBG" ),
	_scroll			= UI.getChildControl( Panel_Window_PetLookChange, "Scroll_PetListNew" ),
	_buttonClose	= UI.getChildControl( Panel_Window_PetLookChange, "Button_Close" ),
	
	_startIndex		= 0,
	_selectedIndex	= 0,
	_petCount		= 0,
}

petGeneral._scrollCtrBTN	= UI.getChildControl( petGeneral._scroll, "Scroll_CtrlButton" )
petGeneral._scrollCtrBTN	:addInputEvent("Mouse_LPress",		"HandleClicked_PetLookChange_ScrollBtn()")
petGeneral._scrollCtrBTN	:addInputEvent( "Mouse_DownScroll", "PetLookChange_ScrollEvent( false )")
petGeneral._scrollCtrBTN	:addInputEvent( "Mouse_UpScroll", "PetLookChange_ScrollEvent( true )")
petGeneral._scroll			:addInputEvent( "Mouse_DownScroll", "PetLookChange_ScrollEvent( false )")
petGeneral._scroll			:addInputEvent( "Mouse_UpScroll", "PetLookChange_ScrollEvent( true )")
petGeneral._scroll			:addInputEvent("Mouse_LUp",			"HandleClicked_PetLookChange_ScrollBtn()")
-- UIScroll.InputEvent( petGeneral._scroll, "PetLookChange_ScrollEvent" )

petGeneral._btnQuestion:addInputEvent( "Mouse_LUp",	"Panel_WebHelper_ShowToggle( \"Pet\" )" )					-- 물음표 좌클릭
petGeneral._btnQuestion:addInputEvent( "Mouse_On",	"HelpMessageQuestion_Show( \"Pet\", \"true\")" )				-- 물음표 마우스오버
petGeneral._btnQuestion:addInputEvent( "Mouse_Out",	"HelpMessageQuestion_Show( \"Pet\", \"false\")" )			-- 물음표 마우스아웃

function petGeneral:registerEvent()
	self._btnClose:addInputEvent( "Mouse_LUp", "Panel_Window_PetLookChange_Close()" )
	self._buttonClose:addInputEvent( "Mouse_LUp", "Panel_Window_PetLookChange_Close()" )
end
petGeneral:registerEvent()

local lookChange = 
{
	_petIcon	= UI.getChildControl( Panel_Window_PetLookChange, "Static_IconPet" ),
	_btnLeft	= UI.getChildControl( Panel_Window_PetLookChange, "Button_Left" ),
	_btnRight	= UI.getChildControl( Panel_Window_PetLookChange, "Button_Right" ),
	_btnChange	= UI.getChildControl( Panel_Window_PetLookChange, "Button_Change" ),
	_lookIndex	= UI.getChildControl( Panel_Window_PetLookChange, "StaticText_LookIndex" ),
	
	_currentIndex = 0,
}

local template =
{
	_bg			= UI.getChildControl( Panel_Window_PetLookChange, "Template_Static_ListContentBG" ),
	_iconBg		= UI.getChildControl( Panel_Window_PetLookChange, "Template_Static_IconPetBG" ),
	_icon		= UI.getChildControl( Panel_Window_PetLookChange, "Template_Static_IconPet" ),
	_level		= UI.getChildControl( Panel_Window_PetLookChange, "Template_StaticText_Level" ),
	_name		= UI.getChildControl( Panel_Window_PetLookChange, "Template_StaticText_PetName" ),
}
for _, control in pairs (template) do
	control:SetShow( false )
end

local petList = {}
local maxSlot = 4

function petList:Init()
	for index = 0, maxSlot - 1 do
		local temp = {}
		temp._bg = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC,	Panel_Window_PetLookChange, "Static_PetListBg_" .. index )
		CopyBaseProperty( template._bg, temp._bg )
		temp._bg:SetPosY( 50 + (temp._bg:GetSizeY() + 5) * index )
		temp._bg:SetShow( false )
		
		temp._iconBg = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC,	temp._bg, "Static_PetListIconBg_" .. index )
		CopyBaseProperty( template._iconBg, temp._iconBg )
		temp._iconBg:SetPosX( 5 )
		temp._iconBg:SetPosY( 5 )
		temp._iconBg:SetShow( true )
		
		temp._icon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC,	temp._bg, "Static_PetListIcon_" .. index )
		CopyBaseProperty( template._icon, temp._icon )
		temp._icon:SetPosX( 5 )
		temp._icon:SetPosY( 5 )
		temp._icon:SetShow( true )
		
		temp._level = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT,	temp._bg, "StaticText_PetListLevel_" .. index )
		CopyBaseProperty( template._level, temp._level )
		temp._level:SetPosX( 65 )
		temp._level:SetPosY( 20 )
		temp._level:SetShow( true )
		
		temp._name = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT,	temp._bg, "StaticText_PetListName_" .. index )
		CopyBaseProperty( template._name, temp._name )
		temp._name:SetPosX( 105 )
		temp._name:SetPosY( 20 )
		temp._name:SetShow( true )
		
		petList[index] = temp
	end
end

function petLookChange_Update()
	if not Panel_Window_PetLookChange:GetShow() then
		return
	end
	
	local sealPetCount = petGeneral._petCount
	for index = 0, maxSlot - 1 do
		local petData = ToClient_getPetSealedDataByIndex( index + petGeneral._startIndex )
		if nil ~= petData then
			local iconPath = petData:getIconPath()
			local petLevel = petData._level
			local petName = petData:getName()
			
			petList[index]._icon:ChangeTextureInfoName( iconPath )
			petList[index]._level:SetText( "Lv." .. petLevel )
			petList[index]._name:SetText( petName )
			petList[index]._bg:SetShow( true )
			petList[index]._bg:addInputEvent( "Mouse_LUp", "PetLookChange_SelectSlot(" .. index + petGeneral._startIndex .. ")" )
			petList[index]._bg:addInputEvent( "Mouse_DownScroll", "PetLookChange_ScrollEvent( false )")
			petList[index]._bg:addInputEvent( "Mouse_UpScroll", "PetLookChange_ScrollEvent( true )")
		else
			petList[index]._bg:SetShow( false )
			petList[index]._bg:addInputEvent( "Mouse_LUp", "" )
		end
		
		if petGeneral._startIndex <= petGeneral._selectedIndex and petGeneral._selectedIndex < (petGeneral._startIndex + maxSlot) then
			petGeneral._selectBg:SetShow( true )
			local posY = petList[petGeneral._selectedIndex - petGeneral._startIndex]._bg:GetPosY()
			petGeneral._selectBg:SetPosY(posY)
		else
			petGeneral._selectBg:SetShow( false )
		end
		
	end
end

function PetLookChange_SelectSlot( petIndex )
	local petData = ToClient_getPetSealedDataByIndex( petIndex )
	if nil == petData then
		return
	end
	
	petGeneral._selectedIndex = petIndex
	lookChange._currentIndex = 0
	PetLook_IconChange( petIndex, lookChange._currentIndex )
	
	petGeneral._selectBg:SetShow( true )
	local posY = petList[petIndex - petGeneral._startIndex]._bg:GetPosY()
	petGeneral._selectBg:SetPosY(posY)
end

function PetLook_IconChange( petIndex, lookIndex )
	local petData = ToClient_getPetSealedDataByIndex( petIndex )
	if nil == petData then
		return
	end
	
	local petStaticStatus = petData:getPetStaticStatus()
	local count = ToClient_getPetChangeLookCount( petStaticStatus )
	
	if lookIndex < 0 or count <= lookIndex then
		return
	end
	
	lookChange._currentIndex = lookIndex
	local iconPath = ToClient_getPetChangeLook_IconPath( petStaticStatus, lookIndex )
	lookChange._petIcon:ChangeTextureInfoName( iconPath )
	lookChange._lookIndex:SetText( lookChange._currentIndex + 1 .. " / " .. count )
	
	local actionIndex = ToClient_getPetChangeLook_ActionIndex( petStaticStatus, lookChange._currentIndex )
	
	lookChange._btnRight:addInputEvent( "Mouse_LUp", "PetLook_IconChange(" .. petIndex .. "," .. lookChange._currentIndex + 1 .. ")" )
	lookChange._btnLeft:addInputEvent( "Mouse_LUp", "PetLook_IconChange(" .. petIndex .. "," .. lookChange._currentIndex - 1 .. ")" )
	lookChange._btnChange:addInputEvent( "Mouse_LUp", "PetLookChange_Request(" .. petIndex .. "," .. actionIndex .. ")" )
end

local _whereType, _slotNo
function PetLookChange_Request( petIndex, actionIndex )
	local petData = ToClient_getPetSealedDataByIndex( petIndex )
	if nil == petData then
		return
	end
	
	local currentActionIndex = petData._actionIndex
	if currentActionIndex == actionIndex then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_PETLOOKCHANGE_SAMETHING") ) -- "현재 외형과 같은 외형입니다." )
		return
	end
	
	local petNo = petData._petNo
	ToClient_requestPetChangeLook( petNo, actionIndex, _whereType, _slotNo )
end

function PetLookChange_ScrollEvent( isUp )
	local sealPetCount = petGeneral._petCount
	if isUp then
		if 0 < petGeneral._startIndex then
			petGeneral._startIndex = petGeneral._startIndex - 1
			petLookChange_Update()
		end
	else
		if (petGeneral._startIndex + maxSlot) < sealPetCount then
			petGeneral._startIndex = petGeneral._startIndex + 1
			petLookChange_Update()
		end
	end
	
	local interval = sealPetCount - maxSlot
	petGeneral._scroll:SetControlPos( petGeneral._startIndex / interval )
	
end

function HandleClicked_PetLookChange_ScrollBtn()
	local self			= petGeneral
	local listCount		= self._petCount
	local posByIndex	= 1 / ( listCount - maxSlot )
	local currentIndex	= math.floor( self._scroll:GetControlPos() / posByIndex )
	self._startIndex	= currentIndex
	petLookChange_Update()
end


function Panel_Window_PetLookChange_Open()
	if not Panel_Window_PetLookChange:GetShow() then
		Panel_Window_PetLookChange:SetShow( true )
		Panel_Window_PetLookChange:SetPosX( getScreenSizeX()/2 - Panel_Window_PetLookChange:GetSizeX() - 100 )
		Panel_Window_PetLookChange:SetPosY( getScreenSizeY()/2 - Panel_Window_PetLookChange:GetSizeY()/2 - 50 )
	end
	petGeneral._startIndex = 0
	petGeneral._selectedIndex = 0
	lookChange._currentIndex = 0
	petLookChange_Update()
	petGeneral._scroll:SetControlPos( lookChange._currentIndex )
	PetLookChange_SelectSlot( petGeneral._selectedIndex )
	
	petGeneral._petCount = ToClient_getPetSealedList()
	if maxSlot < petGeneral._petCount then
		petGeneral._scroll:SetShow( true )
		UIScroll.SetButtonSize( petGeneral._scroll, maxSlot, petGeneral._petCount)
	else
		petGeneral._scroll:SetShow( false )
	end
end

function Panel_Window_PetLookChange_Close()
	Panel_Window_PetLookChange:SetShow( false )
end

function FromClient_SealPetCountChange()
	if not Panel_Window_PetLookChange:GetShow() then
		return
	end
	petGeneral._startIndex = 0
	petGeneral._selectedIndex = 0
	lookChange._currentIndex = 0
	petGeneral._petCount = ToClient_getPetSealedList()
	petLookChange_Update()
	petGeneral._scroll:SetControlPos( lookChange._currentIndex )
	PetLookChange_SelectSlot( petGeneral._selectedIndex )
end

function FromClient_PetChangeLook( whereType, slotNo )
	petGeneral._petCount = ToClient_getPetSealedList()
	if 0 < petGeneral._petCount then
		_whereType = whereType
		_slotNo = slotNo
		Panel_Window_PetLookChange_Open()
	else
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_PETLOOKCHANGE_NOPET") ) -- "외형 변경할 애완동물이 없습니다." )
	end
end

function FromClient_PetLookChanged(petNo, actionIndex)
	Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_PETLOOKCHANGE_CHANGEPET") ) -- "애완동물의 외형이 변경되었습니다." )
	Panel_Window_PetLookChange_Close()
end

petList:Init()
registerEvent( "FromClient_PetChangeLook",		"FromClient_PetChangeLook" )
registerEvent( "FromClient_PetLookChanged",		"FromClient_PetLookChanged" )
registerEvent( "FromClient_PetAddSealedList",	"FromClient_SealPetCountChange" )	-- 인자 petNo
registerEvent( "FromClient_PetDelSealedList",	"FromClient_SealPetCountChange" )	-- 인자 petNo