Panel_Window_PetControl:SetShow( false, false )

local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color		= Defines.Color
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE

local PetControl = {
	Btn_PetInfo		= UI.getChildControl( Panel_Window_PetControl, "Button_PetInfo" ),
	Btn_Follow		= UI.getChildControl( Panel_Window_PetControl, "Button_Follow" ),
	Btn_Wait		= UI.getChildControl( Panel_Window_PetControl, "Button_Wait" ),
	Btn_Find		= UI.getChildControl( Panel_Window_PetControl, "Button_Find" ),
	Btn_GetItem		= UI.getChildControl( Panel_Window_PetControl, "Button_GetItem" ),
	Btn_Seal		= UI.getChildControl( Panel_Window_PetControl, "Button_Seal" ),

	Dot_RedIcon		= UI.getChildControl( Panel_Window_PetControl, "Static_RedDotIcon"),
	Dot_GreenIcon	= UI.getChildControl( Panel_Window_PetControl, "Static_GreenDotIcon"),
	Dot_YellowIcon	= UI.getChildControl( Panel_Window_PetControl, "Static_YellowDotIcon"),
	Dot_PurpleIcon	= UI.getChildControl( Panel_Window_PetControl, "Static_PurpleDotIcon"),
	Dot_GrayIcon1	= UI.getChildControl( Panel_Window_PetControl, "Static_GrayDotIcon1"),
	Dot_GrayIcon2	= UI.getChildControl( Panel_Window_PetControl, "Static_GrayDotIcon2"),
	Btn_IconPet		= UI.getChildControl( Panel_Window_PetControl, "Button_IconPet"),
	Stc_IconPetBg	= UI.getChildControl( Panel_Window_PetControl, "Static_IconPetBG" ),

	Stc_HungryBG	= UI.getChildControl( Panel_Window_PetControl, "Static_HungryBG"),
	Progrss_Hungry	= UI.getChildControl( Panel_Window_PetControl, "Progress2_Hungry"),

	Txt_HungryAlert	= UI.getChildControl( Panel_Window_PetIcon, "StaticText_HungryAlert"),

	Btn_AllSeal		= UI.getChildControl( Panel_Window_PetControl, "Button_Allseal"),
}

local btnPetIcon	= UI.getChildControl( Panel_Window_PetIcon, "Button_PetIcon" )

for v, control in pairs ( PetControl ) do
	control:SetShow( false )
end

local posX				= PetControl.Btn_IconPet:GetSizeX()
-- 펫 최대 소환수는 ContentsOption에서 가져와서 사용한다
local maxUnsealCount = ToClient_getPetUseMaxCount()
local petIcon			= {}
local haveUnsealPetNo	= {}
local petIconPosX =
{
	[0] = {},
	[1] = {},
	[2] = {},
	[3] = {},
	[4] = {}
}
function PetControl:Init()
	for index = 0, maxUnsealCount -1 do
		local temp = {}
		local _petInfo = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, Panel_Window_PetControl, 'Button_PetInfo_' .. index )
		CopyBaseProperty( self.Btn_PetInfo, _petInfo )
		_petInfo:addInputEvent( "Mouse_LUp",	"PetInfoNew_Open(" .. index .. ")" )
		_petInfo:addInputEvent( "Mouse_On",		"petControl_Button_Tooltip( true," ..  4 .. ", " .. index .. ")" )
		_petInfo:addInputEvent( "Mouse_Out",	"petControl_Button_Tooltip( false )" )
		_petInfo:setTooltipEventRegistFunc(		"petControl_Button_Tooltip( true, " .. 4 .. " )" )
		temp._petInfo = _petInfo
		
		local _follow = UI.createControl( UI_PUCT.PA_UI_CONTROL_RADIOBUTTON, Panel_Window_PetControl, 'Button_Follow_' .. index )
		CopyBaseProperty( self.Btn_Follow, _follow )
		_follow:addInputEvent( "Mouse_LUp",		"PetControl_Follow(" .. index .. ")" )
		_follow:addInputEvent( "Mouse_On",		"petControl_Button_Tooltip( true," ..  0 .. ", " .. index .. ")" )
		_follow:addInputEvent( "Mouse_Out",		"petControl_Button_Tooltip( false )" )
		_follow:setTooltipEventRegistFunc(		"petControl_Button_Tooltip( true, " .. 0 .. " )" )
		_follow:SetCheck( false )
		temp._follow = _follow
		
		local _wait = UI.createControl( UI_PUCT.PA_UI_CONTROL_RADIOBUTTON, Panel_Window_PetControl, 'Button_Wait_' .. index )
		CopyBaseProperty( self.Btn_Wait, _wait )
		_wait:addInputEvent( "Mouse_LUp",		"PetControl_Wait(" .. index .. ")" )
		_wait:addInputEvent( "Mouse_On",		"petControl_Button_Tooltip( true," ..  1 .. ", " .. index .. ")" )
		_wait:addInputEvent( "Mouse_Out",		"petControl_Button_Tooltip( false )" )
		_wait:setTooltipEventRegistFunc(		"petControl_Button_Tooltip( true, " .. 1 .. " )" )
		temp._wait = _wait
		
		local _find = UI.createControl( UI_PUCT.PA_UI_CONTROL_CHECKBUTTON, Panel_Window_PetControl, 'Button_Find_' .. index )
		CopyBaseProperty( self.Btn_Find, _find )
		_find:addInputEvent( "Mouse_LUp",		"PetControl_Find(" .. index .. ")" )
		_find:addInputEvent( "Mouse_On",		"petControl_Button_Tooltip( true," ..  3 .. ", " .. index .. ")" )
		_find:addInputEvent( "Mouse_Out",		"petControl_Button_Tooltip( false )" )
		_find:setTooltipEventRegistFunc(		"petControl_Button_Tooltip( true, " .. 3 .. " )" )
		_find:SetCheck( true )
		temp._find = _find
		
		local _getItem = UI.createControl( UI_PUCT.PA_UI_CONTROL_CHECKBUTTON, Panel_Window_PetControl, 'Button_GetItem_' .. index )
		CopyBaseProperty( self.Btn_GetItem, _getItem )
		_getItem:addInputEvent( "Mouse_LUp",	"PetControl_GetItem(" .. index .. ")" )
		_getItem:addInputEvent( "Mouse_On",		"petControl_Button_Tooltip( true," ..  2 .. ", " .. index .. ")" )
		_getItem:addInputEvent( "Mouse_Out",	"petControl_Button_Tooltip( false )" )
		_getItem:setTooltipEventRegistFunc(		"petControl_Button_Tooltip( true, " .. 2 .. " )" )
		_getItem:SetCheck( false )
		temp._getItem = _getItem
		
		local _seal = UI.createControl( UI_PUCT.PA_UI_CONTROL_CHECKBUTTON, Panel_Window_PetControl, 'Button_Seal_' .. index )
		CopyBaseProperty( self.Btn_Seal, _seal )
		_seal:addInputEvent( "Mouse_LUp",		"HandleClicked_petControl_Seal(" .. index .. ")" )
		_seal:addInputEvent( "Mouse_On",		"petControl_Button_Tooltip( true," ..  97 .. ", " .. index .. ")" )
		_seal:addInputEvent( "Mouse_Out",		"petControl_Button_Tooltip( false )" )
		_seal:setTooltipEventRegistFunc(		"petControl_Button_Tooltip( true, " .. 97 .. " )" )
		temp._seal = _seal
		
		local _redDotIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Window_PetControl, 'Static_RedDotIcon_' .. index )
		CopyBaseProperty( self.Dot_RedIcon, _redDotIcon )
		temp._redDotIcon = _redDotIcon
		
		local _greenDotIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Window_PetControl, 'Static_GreenDotIcon_' .. index )
		CopyBaseProperty( self.Dot_GreenIcon, _greenDotIcon )
		temp._greenDotIcon = _greenDotIcon
		
		local _yellowDotIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Window_PetControl, 'Static_YellowDotIcon_' .. index )
		CopyBaseProperty( self.Dot_YellowIcon, _yellowDotIcon )
		temp._yellowDotIcon = _yellowDotIcon
		
		local _purpleDotIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Window_PetControl, 'Static_PurpleDotIcon_' .. index )
		CopyBaseProperty( self.Dot_PurpleIcon, _purpleDotIcon )
		temp._purpleDotIcon = _purpleDotIcon
		
		local _grayDotIcon1 = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Window_PetControl, 'Static_GrayDotIcon1_' .. index )
		CopyBaseProperty( self.Dot_GrayIcon1, _grayDotIcon1 )
		temp._grayDotIcon1 = _grayDotIcon1
		
		local _grayDotIcon2 = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Window_PetControl, 'Static_GrayDotIcon2_' .. index )
		CopyBaseProperty( self.Dot_GrayIcon2, _grayDotIcon2 )
		temp._grayDotIcon2 = _grayDotIcon2
		
		local _iconPet = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, Panel_Window_PetControl, 'Button_IconPet_' .. index )
		CopyBaseProperty( self.Btn_IconPet, _iconPet )
		_iconPet:addInputEvent( "Mouse_LUp",	"HandleClicked_petControl_IconShow(" .. index .. ")" )
		_iconPet:addInputEvent( "Mouse_On",		"petControl_Button_Tooltip( true," ..  98 .. ", " .. index .. ")" )
		_iconPet:addInputEvent( "Mouse_Out",	"petControl_Button_Tooltip( false )" )
		_iconPet:setTooltipEventRegistFunc(		"petControl_Button_Tooltip( true, " .. 98 .. " )" )
		temp._iconPet = _iconPet
		
		local _iconPetBg = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Window_PetControl, 'Static_IconPetBG_' .. index )
		CopyBaseProperty( self.Stc_IconPetBg, _iconPetBg )
		temp._iconPetBg = _iconPetBg

		local _hungryBg = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Window_PetControl, 'Static_HungryBG_' .. index )
		CopyBaseProperty( self.Stc_HungryBG, _hungryBg )
		temp._hungryBg = _hungryBg
		
		local _progress = UI.createControl( UI_PUCT.PA_UI_CONTROL_PROGRESS2, Panel_Window_PetControl, 'Progress2_Hungry_' .. index )
		CopyBaseProperty( self.Progrss_Hungry, _progress )
		temp._progress = _progress

		for v, control in pairs( temp ) do
			control:SetPosX( control:GetPosX() + (posX+13) * index )
			control:SetShow( false )
		end

		petIcon[index] = temp
		petIconPosX[index]._petInfo = petIcon[index]._petInfo:GetPosX()
		petIconPosX[index]._seal = petIcon[index]._seal:GetPosX()
		petIconPosX[index]._follow = petIcon[index]._follow:GetPosX()
		petIconPosX[index]._find = petIcon[index]._find:GetPosX()
		petIconPosX[index]._getItem = petIcon[index]._getItem:GetPosX()
	end

	local isAsia = (CppEnums.ContryCode.eContryCode_KOR == getContryTypeLua()) or (CppEnums.ContryCode.eContryCode_JAP == getContryTypeLua())
	if false == isAsia then
		for index = 0, maxUnsealCount -1 do
			petIcon[index]._petInfo:SetText( "" )
			petIcon[index]._follow:SetText( "" )
			petIcon[index]._wait:SetText( "" )
			petIcon[index]._find:SetText( "" )
			petIcon[index]._getItem:SetText( "" )
			petIcon[index]._seal:SetText( "" )
		end
	end
	
	self.Btn_AllSeal:addInputEvent("Mouse_LUp", "HandleClicked_petControl_AllUnSeal()")
	btnPetIcon:addInputEvent( "Mouse_LUp",	"FGlobal_PetListNew_Toggle()" )
	btnPetIcon:addInputEvent( "Mouse_RUp",	"Panel_Window_PetControl_ShowToggle()" )
	btnPetIcon:addInputEvent( "Mouse_On",	"petControl_Button_Tooltip( true, 99 )" )
	btnPetIcon:addInputEvent( "Mouse_Out",	"petControl_Button_Tooltip( false )" )
	btnPetIcon:setTooltipEventRegistFunc(	"petControl_Button_Tooltip( true, " .. 99 .. " )" )
	btnPetIcon:ActiveMouseEventEffect( true )
	self.Btn_AllSeal:SetShow( false )
end

local _havePetCount = 0
local _unSealPetCount = 0
local petCond = {}
function PetInfoInit_ByPetNo()
	local unSealPetCount = ToClient_getPetUnsealedList()
	local sealPetCount = ToClient_getPetSealedList()
	local havePetCount = unSealPetCount + sealPetCount
	if 0 >= havePetCount then
		return
	end
	
	if _havePetCount ~= havePetCount or _unSealPetCount ~= unSealPetCount then				-- 보유 펫의 변화가 생기면 seal 상태의 펫을 초기화 해준다.
		for index = 0, havePetCount - 1 do
			local petConditionByPetNo = {}
			if unSealPetCount <= index then
				local sealPetIndex = index - unSealPetCount
				local petData = ToClient_getPetSealedDataByIndex( sealPetIndex )
				petConditionByPetNo._petNo		= petData._petNo
				petConditionByPetNo._follow		= false
				petConditionByPetNo._find		= true
				petConditionByPetNo._getItem	= false
			else
				local petData = ToClient_getPetUnsealedDataByIndex( index )
				petConditionByPetNo._petNo		= petData:getPcPetNo()
				petConditionByPetNo._follow		= petIcon[index]._follow:IsCheck()
				petConditionByPetNo._find		= petIcon[index]._find:IsCheck()
				petConditionByPetNo._getItem	= petIcon[index]._getItem:IsCheck()
			end
			petCond[index] = petConditionByPetNo
		end
		_havePetCount = havePetCount
		_unSealPetCount = unSealPetCount
	end
	
	-- 일본 버전에선 펫 아이콘을 켜준다
	if 5 == getGameServiceType() or 6 == getGameServiceType() then
		Panel_Window_PetControl_ShowToggle()
	end
end

function FGlobal_PetInfoInit()
	if 5 ~= getGameServiceType() and 6 ~= getGameServiceType() then
		PetInfoInit_ByPetNo()
	end
end

local screenX		= getScreenSizeX()
local screenY		= getScreenSizeY()
local panelSizeX	= PetControl.Btn_GetItem:GetSizeX()
local panelSizeY	= PetControl.Btn_GetItem:GetSizeY()
local unSealPetNo	= { [0] = nil, nil, nil }
local PetControl_CurrentButtonTooltipType = -1

PetControl.Btn_Follow:ActiveMouseEventEffect( true )
PetControl.Btn_Wait:ActiveMouseEventEffect( true )

function PetControl:ButtonShow( isShow, index )
	petIcon[index]._petInfo	:SetShow( isShow )
	petIcon[index]._follow	:SetShow( isShow )
	petIcon[index]._wait	:SetShow( isShow )
	petIcon[index]._find	:SetShow( isShow )
	petIcon[index]._getItem	:SetShow( isShow )
	petIcon[index]._seal	:SetShow( isShow )
	
	-- if self.Txt_HungryAlert:GetShow() then
		-- petIcon[index]._petInfo	:SetPosY( self.Txt_HungryAlert:GetSizeY() + (self.Txt_HungryAlert:GetPosY()+15) )
		-- petIcon[index]._follow	:SetPosY( self.Txt_HungryAlert:GetSizeY() + (self.Txt_HungryAlert:GetPosY()+15) )
		-- petIcon[index]._wait	:SetPosY( self.Txt_HungryAlert:GetSizeY() + (self.Txt_HungryAlert:GetPosY()+15) )
		-- petIcon[index]._find	:SetPosY( self.Txt_HungryAlert:GetSizeY() + (self.Txt_HungryAlert:GetPosY()+15) )
		-- petIcon[index]._getItem	:SetPosY( self.Txt_HungryAlert:GetSizeY() + (self.Txt_HungryAlert:GetPosY()+15) )
		-- petIcon[index]._seal	:SetPosY( self.Txt_HungryAlert:GetSizeY() + (self.Txt_HungryAlert:GetPosY()+15) )
	-- else
		-- petIcon[index]._petInfo	:SetPosY( petIcon[index]._iconPet:GetSizeY() + (petIcon[index]._iconPet:GetPosY()+15) )
		-- petIcon[index]._follow	:SetPosY( petIcon[index]._iconPet:GetSizeY() + (petIcon[index]._iconPet:GetPosY()+15) )
		-- petIcon[index]._wait	:SetPosY( petIcon[index]._iconPet:GetSizeY() + (petIcon[index]._iconPet:GetPosY()+15) )
		-- petIcon[index]._find	:SetPosY( petIcon[index]._iconPet:GetSizeY() + (petIcon[index]._iconPet:GetPosY()+15) )
		-- petIcon[index]._getItem	:SetPosY( petIcon[index]._iconPet:GetSizeY() + (petIcon[index]._iconPet:GetPosY()+15) )
		-- petIcon[index]._seal	:SetPosY( petIcon[index]._iconPet:GetSizeY() + (petIcon[index]._iconPet:GetPosY()+15) )
	-- end
end

local firstPetLoad = false			-- UI가 리로드 되는 상황(죽음 등)에 펫 명령을 초기화 해주기 위한 변수
local showIndex = -1
function FGlobal_PetControl_CheckUnSealPet( petNo_s64 )
	if isFlushedUI() then
		return
	end
	
	local isUnSealPet = ToClient_getPetUnsealedList()
	if 0 < isUnSealPet  then
		PetControl_SetPositon()
		-- Panel_Window_PetControl:SetShow( true )
		-- 펫 아이콘!
		
		for index = 0, maxUnsealCount -1 do
			local PetUnSealData	= ToClient_getPetUnsealedDataByIndex( index )
			if nil ~= PetUnSealData then
				local self = petIcon[index]
				local unsealPetStaticStatus	= PetUnSealData:getPetStaticStatus()
				local unsealIconPath		= PetUnSealData:getIconPath()
				local petNo					= PetUnSealData:getPcPetNo()
				petIcon[index]._iconPet		: ChangeTextureInfoName( unsealIconPath )

				for v, control in pairs( petIcon[index] ) do
					control:SetShow( true )
				end
				
				if isShowIndex() ~= index then
					PetControl:ButtonShow( false, index )
				else
					self._wait:SetShow( false )
				end
				
				for i = 0, _havePetCount -1 do
					if petNo == petCond[i]._petNo then
						self._follow:	SetCheck( petCond[i]._follow )
						self._find:		SetCheck( petCond[i]._find )
						self._getItem:	SetCheck( petCond[i]._getItem )
						FGlobal_PetContorl_HungryGaugeUpdate( petNo )
						if false == firstPetLoad then
							PetControl_GetItem( index )
							PetControl_Find( index )
							PetControl_BTNCheckedUpdate( index )
						end
					end
				end
				
				if true == self._follow:IsCheck() then
					self._redDotIcon	:SetShow( true )
					self._greenDotIcon	:SetShow( false )
				else
					self._greenDotIcon	:SetShow( true )
					self._redDotIcon	:SetShow( false )
				end
				
				if false == self._getItem:IsCheck() then
					self._purpleDotIcon	:SetShow( true )
					self._grayDotIcon2	:SetShow( false )
				else
					self._purpleDotIcon	:SetShow( false )
					self._grayDotIcon2	:SetShow( true )
				end
				
				if false == self._find:IsCheck() then
					self._yellowDotIcon	:SetShow( true )
					self._grayDotIcon1	:SetShow( false )
				else
					self._yellowDotIcon	:SetShow( false )
					self._grayDotIcon1	:SetShow( true )
				end
				
				if ( Panel_Window_PetIcon:GetShow() ) then
					petIcon[index]._progress:SetShow( true )
					petIcon[index]._hungryBg:SetShow( true )
				else
					petIcon[index]._progress:SetShow( false )
					petIcon[index]._hungryBg:SetShow( false )
				end
				
				-- 일본에서는 펫 찾을 때마다 명령 버튼을 나오게 한다!
				if 5 == getGameServiceType() or 6 == getGameServiceType() then
					if nil ~= petNo_s64 then
						PetControl_Show( petNo_s64 )
					end
				end
				
				-- local isCheckTalent = PetUnSealData:getSkillParam(1):isPassiveSkill()
				-- self._find:SetCheck( not isCheckTalent )
				-- self._yellowDotIcon	:SetShow( isCheckTalent )
				-- self._grayDotIcon1	:SetShow( not isCheckTalent )
				
				local petRace = unsealPetStaticStatus:getPetRace()
				if 4 == petRace or 5 == petRace or 7 == petRace or 8 == petRace then		-- 4, 5, 7은 특기가 항상 켜져 있게 한다
					self._find:SetCheck( false )
					self._yellowDotIcon	:SetShow( true )
					self._grayDotIcon1	:SetShow( false )
				end
			else
				for v, control in pairs( petIcon[index] ) do
					control:SetShow( false )
				end
			end
		end
		firstPetLoad = true
		-- FGlobal_PetControl_SealPet()
		-- Panel_MovieGuideButton_SetPosition( isUnSealPet )
	else
		if Panel_Window_PetControl:GetShow() then
			Panel_Window_PetControl_ShowToggle()
		end
		-- Panel_Window_PetControl:SetShow( false )
		-- Panel_MovieGuideButton:SetPosX( 20 )
		haveUnsealPetNo = {}				-- 찾은 펫이 없으면 초기화
	end
end

function PetControl_Show( petNo )
	if 5 ~= getGameServiceType() and 6 ~= getGameServiceType() then
		return
	end
	haveUnsealPetNo = {}
	
	ToClient_getPetUnsealedList();
	
	if nil == petNo then
		for index = 0, maxUnsealCount - 1 do
			local unsealPetInfo = ToClient_getPetUnsealedDataByIndex( index )
			if nil ~= unsealPetInfo then
				table.insert( haveUnsealPetNo, tostring(unsealPetInfo:getPcPetNo()) )		-- 꺼낸 펫의 넘버를 스트링으로 테이블에 push
			end
		end
	else
		if not Panel_Window_PetControl:GetShow() then
			Panel_Window_PetControl_ShowToggle()
		end
		
		for pIndex = 0, maxUnsealCount -1 do
			local unsealPetInfo = ToClient_getPetUnsealedDataByIndex( pIndex )
			if nil ~= unsealPetInfo then
				local myPetNo = unsealPetInfo:getPcPetNo()
				if petNo == myPetNo then
					for i = 0, maxUnsealCount - 1 do
						if petIcon[i]._petInfo:GetShow() then
							PetControl:ButtonShow( false, i )
						end
					end
					
					PetControl_ButtonShow( pIndex )
					table.insert( haveUnsealPetNo, tostring(petNo) )		-- 새로 꺼낸 펫의 넘버를 스트링으로 테이블에 push
					showIndex = pIndex
					return
				end
			end
		end
	end
end
PetControl_Show()

function isShowIndex()
	return showIndex
end

function PetControl_SetPositon()
	Panel_Window_PetControl:SetPosX( 10 )
	Panel_Window_PetControl:SetPosY( Panel_SelfPlayerExpGage:GetSizeY() * 2.2 )
end

function PetInfoNew_Open( index )
	local petCount = ToClient_getPetUnsealedList()
	if petCount == 0 then
		return
	end
	
	local petNo = ToClient_getPetUnsealedDataByIndex( index ):getPcPetNo()
	FGlobal_PetInfoNew_Open( petNo, true )
end

function PetControl_Follow( index )
	PetControl_BTNCheckedUpdate( index )
end

function PetControl_Wait( index )
	PetControl_BTNCheckedUpdate( index )
end

function PetControl_GetItem( index ) -- 주워와를 눌렀을 때
	local petCount = ToClient_getPetUnsealedList()
	if petCount == 0 then
		return
	end
	
	local petNo = ToClient_getPetUnsealedDataByIndex( index ):getPcPetNo()
	if false == petIcon[index]._getItem	:IsCheck() then
		-- petIcon[index]._getItem			:SetCheck( false )
		petIcon[index]._purpleDotIcon	:SetShow( true )
		petIcon[index]._grayDotIcon2	:SetShow( false )
		ToClient_callHandlerToPetNo( "handlePetGetItemOn", petNo )
	else
		-- petIcon[index]._getItem			:SetCheck( true )
		petIcon[index]._purpleDotIcon	:SetShow( false )
		petIcon[index]._grayDotIcon2	:SetShow( true )
		ToClient_callHandlerToPetNo( "handlePetGetItemOff", petNo )
	end
	
	local toLoop = ToClient_getPetUnsealedList() - 1;
	for i = 0, toLoop do
		if petNo == petCond[i]._petNo then
			petCond[i]._getItem	= petIcon[index]._getItem:IsCheck()
		end
	end
end
function PetControl_Find( index ) -- 찾아와 버튼을 눌렀을 때
	if PetTalentCheck( index ) then
		petIcon[index]._find:SetCheck( false )
		petIcon[index]._yellowDotIcon	:SetShow( true )
		petIcon[index]._grayDotIcon1	:SetShow( false )
		return
	end
	
	local petCount = ToClient_getPetUnsealedList()
	if petCount == 0 then
		return
	end
	
	local petNo = ToClient_getPetUnsealedDataByIndex( index ):getPcPetNo()
	if false == petIcon[index]._find:IsCheck() then
		-- petIcon[index]._find			:SetCheck( false )
		petIcon[index]._yellowDotIcon	:SetShow( true )
		petIcon[index]._grayDotIcon1	:SetShow( false )
		ToClient_callHandlerToPetNo( "handlePetFindThatOn", petNo )
	else
		-- petIcon[index]._find			:SetCheck( true )
		petIcon[index]._yellowDotIcon	:SetShow( false )
		petIcon[index]._grayDotIcon1	:SetShow( true )
		ToClient_callHandlerToPetNo( "handlePetFindThatOff", petNo )
	end

	local toLoop = ToClient_getPetUnsealedList() - 1;
	for i = 0, toLoop do
		if petNo == petCond[i]._petNo then
			petCond[i]._find	= petIcon[index]._find:IsCheck()
		end
	end
end

-- 버프 유지형 펫 체크(펭귄, 사막여우)
function PetTalentCheck( index )
	local petCount = ToClient_getPetUnsealedList()
	if petCount == 0 then
		return false
	end
	
	local petData = ToClient_getPetUnsealedDataByIndex( index )
	local petRace = petData:getPetStaticStatus():getPetRace()
	-- _PA_LOG("이문종", "petData = " .. tostring(petData) .. " / " .. tostring(petData:getPetStaticStatus():getPetRace()))
	
	
	-- return petData:getSkillParam(1):isPassiveSkill()
	
	if 4 == petRace or 5 == petRace or 7 == petRace or 8 == petRace then
		return true
	end
	return false
end

function FGlobal_PetControl_SealPet( index )	-- 펫을 맡길 때.
	local self = petIcon[index]

	local unsealedPetList = ToClient_getPetUnsealedList();
	if 0 < unsealedPetList then
		local petData 	= ToClient_getPetUnsealedDataByIndex( index )
		local petNo 	= petData:getPcPetNo()

		for i = 0, unsealedPetList - 1 do
			if petNo == petCond[i]._petNo then
				petCond[i]._follow	= false
				petCond[i]._find	= true
				petCond[i]._getItem	= false
			end
		end
		
		ToClient_callHandlerToPetNo( "handlePetFollowMaster", petNo )
		ToClient_callHandlerToPetNo( "handlePetGetItemOn", petNo )
		ToClient_callHandlerToPetNo( "handlePetFindThatOff", petNo )
		
		for petIconIndex = 0, maxUnsealCount -1 do
			local petData = ToClient_getPetUnsealedDataByIndex( petIconIndex ) 
			if nil ~= petData then
				FGlobal_PetContorl_HungryGaugeUpdate( petData:getPcPetNo() )
				PetControl		:ButtonShow( false, petIconIndex )
			end
		end
	end

	self._follow	:SetCheck( false )
	self._wait		:SetCheck( true )
	self._getItem	:SetCheck( false )
	self._find		:SetCheck( true )

	if ( Panel_Window_PetIcon:GetShow() ) then
		self._progress:SetShow( true )
		self._hungryBg:SetShow( true )
	else
		self._progress:SetShow( false )
		self._hungryBg:SetShow( false )
	end
	
	-- 펫을 맡기면, 명령 버튼을 닫아주자
	-- haveUnsealPetNo = {}		-- 테이블을 초기화하고
	-- PetControl_Show()			-- 꺼낸 펫 넘버를 다시 테이블에 push
	
	FGlobal_PetControl_RestoreUI()
	-- Panel_MovieGuideButton_SetPosition( ToClient_getPetUnsealedList() )
end

function FGlobal_PetControl_RestoreUI()
	local self = PetControl
	TooltipSimple_Hide()
	
	local unsealedCount = ToClient_getPetUnsealedList();
	if(unsealedCount <= 0) then
		return
	end
	if Panel_Window_PetControl:GetShow() or Panel_Window_PetIcon:GetShow() then
		local isUnSealPetIndex = unsealedCount - 1
	end
end

function HandleClicked_petControl_IconShow( index ) -- 펫 아이콘을 클릭 했을 때
	for i = 0, maxUnsealCount - 1 do
		if true == petIcon[i]._petInfo:GetShow() then
			PetControl_ButtonHide( i )
			return
		end
	end
	PetControl_ButtonShow( index )
end

-- 펫을 맡길 때
function HandleClicked_petControl_Seal( index )
	local self = petIcon[index]
	local unSealPetInfo			= ToClient_getPetUnsealedList() -- 찾은 펫 갯수 리턴
	local PetUnSealData			= ToClient_getPetUnsealedDataByIndex( index )
	if nil ~= PetUnSealData then
		local unsealPetNo_s64	= PetUnSealData:getPcPetNo()
		FGlobal_petListNew_Seal( tostring(unsealPetNo_s64), index );
	end
	FGlobal_AllSealButtonPosition( unSealPetInfo, false)
end

function HandleClicked_petControl_AllUnSeal()
	for index=0, maxUnsealCount - 1 do
		local self = petIcon[index]
		local unSealPetInfo			= ToClient_getPetUnsealedList()
		local PetUnSealData			= ToClient_getPetUnsealedDataByIndex( index )

		if nil ~= PetUnSealData then
			local unsealPetNo_s64	= PetUnSealData:getPcPetNo()
			FGlobal_petListNew_Seal( tostring(unsealPetNo_s64), index );
		end
	end
end

function FGlobal_HandleClicked_petControl_AllUnSeal()
	HandleClicked_petControl_AllUnSeal()
end

local unSealPetCounting = 0
function FGlobal_AllSealButtonPosition( sealCount, sealType )
	local self = PetControl

	if nil == sealCount then
		unSealPetCounting		= ToClient_getPetUnsealedList() -- 찾은 펫 갯수 리턴
	else
		if true == sealType then
			unSealPetCounting		= sealCount+1
		else
			unSealPetCounting		= sealCount-1
		end
	end

	self.Btn_AllSeal:SetPosX( 20 + 57 * unSealPetCounting )
	
	-- if 1 == unSealPetCounting then
		-- self.Btn_AllSeal:SetPosX( posX + 20 )
	-- elseif 2 == unSealPetCounting then
		-- self.Btn_AllSeal:SetPosX( posX + 70 )
	-- elseif 3 == unSealPetCounting then
		-- self.Btn_AllSeal:SetPosX( posX + 130 )
	-- end
end

function PetControl_ButtonShow( index )
	-- for i = 0, maxUnsealCount - 1 do
		-- if true == petIcon[i]._petInfo:GetShow() then
			-- PetControl_ButtonHide( i )
			-- return
		-- end
	-- end
	
	local self = petIcon[index]
	local endTime = 0.08
	-- PetControl:ButtonShow( true )
	-- Panel_MovieGuideButton:SetShow( false )
	-- 펫정보
	local MoveAni1 = self._petInfo:addMoveAnimation( 0.0, endTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI )
	MoveAni1:SetStartPosition( petIconPosX[index]._petInfo, self._petInfo:GetPosY() )
	MoveAni1:SetEndPosition( petIconPosX[index]._petInfo, self._petInfo:GetPosY() )
	self._petInfo:SetShow( true )
	-- 펫 맡기기
	local MoveAni2 = self._seal:addMoveAnimation( 0.0, endTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI )
	MoveAni2:SetStartPosition( petIconPosX[index]._petInfo, self._seal:GetPosY() )
	MoveAni2:SetEndPosition( petIconPosX[index]._seal, self._seal:GetPosY() )
	self._seal:SetShow( true )
	-- 따라와
	local MoveAni3 = self._follow:addMoveAnimation( 0.0, endTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI )
	MoveAni3:SetStartPosition( petIconPosX[index]._petInfo, self._follow:GetPosY() )
	MoveAni3:SetEndPosition( petIconPosX[index]._follow, self._follow:GetPosY() )
	if self._greenDotIcon:GetShow() then
		self._follow:SetShow( true )
		self._wait:SetShow( false )
	else
		self._wait:SetShow( true )
		self._follow:SetShow( false )
	end
	
	-- 기다려
	local MoveAni4 = self._wait:addMoveAnimation( 0.0, endTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI )
	MoveAni4:SetStartPosition( petIconPosX[index]._petInfo, self._follow:GetPosY() )
	MoveAni4:SetEndPosition( petIconPosX[index]._follow, self._follow:GetPosY() )
	-- 찾아
	local MoveAni5 = self._find:addMoveAnimation( 0.0, endTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI )
	MoveAni5:SetStartPosition( petIconPosX[index]._petInfo, self._find:GetPosY() )
	MoveAni5:SetEndPosition( petIconPosX[index]._find, self._find:GetPosY() )
	self._find:SetShow( true )
	-- 주워와
	local MoveAni6 = self._getItem:addMoveAnimation( 0.0, endTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI )
	MoveAni6:SetStartPosition( petIconPosX[index]._petInfo, self._getItem:GetPosY() )
	MoveAni6:SetEndPosition( petIconPosX[index]._getItem, self._getItem:GetPosY() )
	self._getItem:SetShow( true )
end

function PetControl_ButtonHide( index )
	local self = petIcon[index]

	PetControl:ButtonShow( false, index )
end

function PetControl_BTNCheckedUpdate( index )
	local petCount = ToClient_getPetUnsealedList()
	if petCount == 0 then
		return
	end
	
	local petNo = ToClient_getPetUnsealedDataByIndex( index ):getPcPetNo()
	if true == petIcon[index]._follow:IsCheck() then
		petIcon[index]._follow		:SetShow( false )
		petIcon[index]._wait		:SetShow( true )
		petIcon[index]._redDotIcon	:SetShow( true )
		petIcon[index]._greenDotIcon:SetShow( false )
		ToClient_callHandlerToPetNo( "handlePetWaitMaster", petNo )
	else
		petIcon[index]._follow		:SetShow( true )
		petIcon[index]._wait		:SetShow( false )
		petIcon[index]._greenDotIcon:SetShow( true )
		petIcon[index]._redDotIcon	:SetShow( false )
		ToClient_callHandlerToPetNo( "handlePetFollowMaster", petNo )
	end
end

function Panel_Window_PetControl_ShowToggle()
	if Panel_Window_PetControl:GetShow() then
		Panel_Window_PetControl:SetShow( false )
	else
		Panel_Window_PetControl:SetShow( true )
		FGlobal_PetControl_CheckUnSealPet()		-- 꺼내진 펫이 있는지 없는지 체크한다. 없으면 꺼내진 펫이 없어도 마지막 꺼냈던 펫 아이콘이 노출된다.
	end
	-- petControl_Button_Tooltip( true, 99 )
	PetControl.Btn_AllSeal:SetShow( true )
	FGlobal_AllSealButtonPosition()
	
	-- 파티창과 펫컨트롤창이 모두 열려 있는 상태에서, 포지션이 겹친다면 포지션을 조정해준다!
	if Panel_Party:GetShow() and Panel_Window_PetControl:GetShow() then
		local petCount = ToClient_getPetUnsealedList()
		local isOverlap = false
		for overlapY = Panel_Party:GetPosY(), (Panel_Party:GetPosY()+Panel_Party:GetSizeY()), Panel_Party:GetSizeY() do
			if Panel_Window_PetControl:GetPosY() <= overlapY and overlapY <= Panel_Window_PetControl:GetPosY() + Panel_Window_PetControl:GetSizeY() then
				isOverlap = true
			end
		end
		if isOverlap then
			for overlapX = Panel_Party:GetPosX(), (Panel_Party:GetPosX()+Panel_Party:GetSizeX()), Panel_Party:GetSizeX() do
				if Panel_Window_PetControl:GetPosX() <= overlapX and overlapX <= (Panel_Window_PetControl:GetPosX() + (Panel_Window_PetControl:GetSizeX()+10)*petCount + 60) then
					PartyPanel_Repos()
					return
				end
			end
		end
	end
end

function petControl_Button_Tooltip( isShow, buttonType, index )
	if false == isShow then
		TooltipSimple_Hide()
		PetControl.Txt_HungryAlert:SetShow( false )
		return
	end
	
	local self = nil
	local uiControl, name, desc = nil, nil, nil
	if nil ~= index then
		self = petIcon[index]
	else
		if 99 == buttonType then
			uiControl	= Panel_Window_PetIcon
			name		= PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_BUTTONTOOLTIP_PETLIST_NAME") -- "애완동물 목록"
			
			if 0 == ToClient_getPetUnsealedList() then
				desc	= PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_BUTTONTOOLTIP_WAITPET_DESC") -- "주인이 불러주길 기다리는 애완동물이 있습니다.\n애완동물을 찾아 명령을 내려보세요.\n- 좌클릭 : 애완동물 목록"
			else
				if Panel_Window_PetControl:GetShow() then
					desc	= PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_BUTTONTOOLTIP_ICONHIDE_DESC") -- "주인이 불러주길 기다리는 애완동물이 있습니다.\n애완동물을 찾아 명령을 내려보세요.\n- 좌클릭 : 애완동물 목록"
				else
					desc	= PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_BUTTONTOOLTIP_ICONSHOW_DESC") -- "주인이 불러주길 기다리는 애완동물이 있습니다.\n애완동물을 찾아 명령을 내려보세요.\n- 좌클릭 : 애완동물 목록"
				end
				if PetHungryConditionCheck() then
					desc	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_PETCONTROL_BUTTONTOOLTIP_PETHUNGRY_DESC", "desc", desc ) -- desc .. "\n<배고픈 애완동물이 있으니 사료를 먹이세요.>"
					PetControl.Txt_HungryAlert:SetShow( true )
				else
					PetControl.Txt_HungryAlert:SetShow( false )
				end
			end
		else
			return
		end
		registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( uiControl, name, desc )
		return
	end
	if true == isShow then
		if 0 == buttonType then
			uiControl	= self._follow
			name		= PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_FOLLOW_NAME") -- "애완동물 명령:따라와"
			desc		= PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_FOLLOW_DESC") -- "애완동물이 플레이어를 따라 다니도록 설정합니다. 기다려와 따라와 중 하나만 선택할 수 있습니다."
		elseif 1 == buttonType then
			uiControl	= self._wait
			name		= PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_WAIT_NAME") -- "애완동물 명령:기다려"
			desc		= PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_WAIT_DESC") -- "애완동물이 플레이어를 제자리에서 기다리도록 설정합니다. 거리가 너무 멀어지는 경우 플레이어 옆으로 이동합니다. 기다려와 따라와 중 하나만 선택할 수 있습니다."
		elseif 2 == buttonType then
			uiControl	= self._getItem
			name		= PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_GETITEM_NAME") -- "애완동물 명령:주워와"
			desc		= PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_GETITEM_DESC") -- "애완동물이 플레이어 대신 아이템을 주워 옵니다."
		elseif 3 == buttonType then
			uiControl	= self._find
			name		= PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_FIND_NAME") -- "애완동물 명령:찾아"
			desc		= PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_FIND_DESC") -- "애완동물이 주변에서 가치 있는 장소, 물건 등을 찾습니다."
		elseif 4 == buttonType then
			uiControl	= self._petInfo
			name		= PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_PETINFO_NAME") -- "애완동물 정보"
			desc		= PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_PETINFO_DESC") -- "애완동물 정보를 확인할 수 있습니다."
		elseif 97 == buttonType then
			uiControl	= self._seal
			name		= PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_PETSEAL_NAME") -- "애완동물 맡기기"
			desc		= PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_PETSEAL_DESC") -- "애완동물을 맡길 수 있습니다."
		elseif 98 == buttonType then
			uiControl	= self._iconPet
			name		= PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_PETCONTROL_NAME") -- "애완동물 명령하기"
			desc		= PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_PETCONTROL_DESC") -- "애완동물에게 명령을 내릴 수 있습니다.\n- 좌클릭 : 애완동물 명령"
		-- elseif 99 == buttonType then
			-- uiControl	= Panel_Window_PetIcon
			-- name		= PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_PetICON_NAME") -- "애완동물 목록"
			-- desc		= PAGetString(Defines.StringSheet_GAME, "LUA_PETCONTROL_TOOLTIP_PetICON_DESC") -- "주인이 불러주길 기다리는 애완동물이 있습니다.\n애완동물을 찾아 명령을 내려보세요.\n- 좌클릭 : 애완동물 목록"
		end

		registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( uiControl, name, desc )
	end
end

--애완동물 아이콘 밑에 배고픔 게이지
function FGlobal_PetContorl_HungryGaugeUpdate( petNo_s64 )
	if isFlushedUI() then
		return
	end
	local petCount = ToClient_getPetUnsealedList()
	if petCount == 0 then
		return
	end
	
	for index = 0, _havePetCount - 1 do
		local pcPetData = ToClient_getPetUnsealedDataByIndex( index )
		if nil ~= pcPetData then
			if petNo_s64 == pcPetData:getPcPetNo() then

				local petStaticStatus	= pcPetData:getPetStaticStatus()
				local petHungry			= pcPetData:getHungry()
				local petMaxHungry		= petStaticStatus._maxHungry
				local petHungryPercent	= ( petHungry / petMaxHungry ) * 100

				petIcon[index]._progress:SetProgressRate( petHungryPercent )
				petIcon[index]._progress:SetShow( true )
			end
		end
	end
end
--위치 변경으로 인한 사용안함.
-- function Panel_MovieGuideButton_SetPosition( unSealPetCount )
-- 	if Panel_Window_PetControl:GetShow() then
-- 		Panel_MovieGuideButton:SetPosX( petIcon[unSealPetCount-1]._iconPet:GetPosX() + petIcon[unSealPetCount-1]._iconPet:GetSizeX() + 20 )
-- 	else
-- 		Panel_MovieGuideButton:SetPosX( 20 )
-- 	end
-- end

local hungryCheck = false
function FGlobal_PetHungryAlert( petHungryCheck )
	if isFlushedUI() then
		return
	end
	btnPetIcon:EraseAllEffect()
	if petHungryCheck and 0 < ToClient_getPetUnsealedList() then
		btnPetIcon:AddEffect("fUI_Pet_01A", true, -1, -0.5)
	end
	hungryCheck = petHungryCheck
end

function PetHungryConditionCheck()
	return hungryCheck
end

function PetControl_registMessageHandler()
	registerEvent("FromClient_PetAddList",		"FGlobal_PetContorl_HungryGaugeUpdate")
	registerEvent("FromClient_PetInfoChanged",	"FGlobal_PetContorl_HungryGaugeUpdate")
end

PetControl:Init()
PetInfoInit_ByPetNo()

-- FGlobal_PetControl_SealPet()
FGlobal_PetControl_CheckUnSealPet()
PetControl_registMessageHandler()
UI.addRunPostRestorFunction( FGlobal_PetControl_RestoreUI )