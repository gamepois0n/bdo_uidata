local UI_TM			= CppEnums.TextMode
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE
local UI_color		= Defines.Color
local UI_CIT		= CppEnums.InstallationType
local IM 			= CppEnums.EProcessorInputMode

Panel_House_InstallationMode_ObjectControl:SetShow( false )

local HouseInstallationControl	= {
	btn_Confirm				= UI.getChildControl( Panel_House_InstallationMode_ObjectControl, "Button_Confirm"),
	btn_Rotate_Right		= UI.getChildControl( Panel_House_InstallationMode_ObjectControl, "Button_Rotate_Right"),
	btn_Rotate_Left			= UI.getChildControl( Panel_House_InstallationMode_ObjectControl, "Button_Rotate_Left"),
	btn_Delete				= UI.getChildControl( Panel_House_InstallationMode_ObjectControl, "Button_Delete"),
	btn_Move				= UI.getChildControl( Panel_House_InstallationMode_ObjectControl, "Button_Move"),
	btn_Cancel				= UI.getChildControl( Panel_House_InstallationMode_ObjectControl, "Button_Cancel"),
	btn_Resize				= UI.getChildControl( Panel_House_InstallationMode_ObjectControl, "Button_Resize"),
	staticText_DetailGuide	= UI.getChildControl( Panel_House_InstallationMode_ObjectControl, "StaticText_DetailGuide"),
}

local _txt_btnDesc			= UI.getChildControl( Panel_House_InstallationMode_ObjectControl, "StaticText_Desc")

function HouseInstallationControl:Initialize()
	self.btn_Confirm			:SetShow( false )
	self.btn_Rotate_Right		:SetShow( false )
	self.btn_Rotate_Left		:SetShow( false )
	self.btn_Delete				:SetShow( false )
	self.btn_Move				:SetShow( false )
	self.btn_Cancel				:SetShow( false )
	self.btn_Resize				:SetShow( false )
	self.staticText_DetailGuide	:SetShow( false )
end

local HouseInstallationControl_Is_Open = false;
local isConfirmStep = false

local typeIsHavest = false

function HouseInstallationControl:Close()
	Panel_House_InstallationMode_ObjectControl:SetShow( false )
	HouseInstallationControl_Is_Open = false;
end

function Is_Show_HouseInstallationControl()
	return HouseInstallationControl_Is_Open;
end

function Panel_House_ObjectControlDescFunc( isOn, btnType )
	if ( isOn == true ) then
		_txt_btnDesc:SetAlpha( 0 )
		_txt_btnDesc:SetFontAlpha( 0 )
		_txt_btnDesc:ResetVertexAni()
		local AniInfo = UIAni.AlphaAnimation( 1, _txt_btnDesc, 0.0, 0.2 )
		_txt_btnDesc:SetShow( true )
		
		if ( btnType == 1 ) then		
			if false == FGlobal_HouseInstallationControl_IsConfirmStep() then
				_txt_btnDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_OBJECTCONTROL_CONFIRM") ) -- "확 인")
			else
				_txt_btnDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_OBJECTCONTROL_CONFIRM") .. "(SpaceBar)" ) -- "확 인(Space Bar)")			
			end
		elseif ( btnType == 2 ) then
			_txt_btnDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_OBJECTCONTROL_RIGHTROTATION") ) -- "우측으로 회전")
		elseif ( btnType == 3 ) then
			_txt_btnDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_OBJECTCONTROL_LEFTROTATION") ) -- "좌측으로 회전")
		elseif ( btnType == 4 ) then
			if typeIsHavest then
				_txt_btnDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_OBJECTCONTROL_DELETE") ) -- 제 거
			else
				_txt_btnDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_OBJECTCONTROL_RETURN") ) -- "회 수")
			end
		elseif ( btnType == 5 ) then
			_txt_btnDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_OBJECTCONTROL_MOVE") ) -- "이 동")
		elseif ( btnType == 6 ) then
			_txt_btnDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_OBJECTCONTROL_CANCEL") ) -- "취 소")
		elseif ( btnType == 7 ) then
			_txt_btnDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_OBJECTCONTROL_ZOOMIN") ) -- "확대/축소")
		end
		_txt_btnDesc:SetSize( ( _txt_btnDesc:GetTextSizeX() + 50 ) + _txt_btnDesc:GetSpanSize().x, _txt_btnDesc:GetSizeY() )
	else
		_txt_btnDesc:ResetVertexAni()
		local AniInfo = UIAni.AlphaAnimation( 0, _txt_btnDesc, 0.0, 0.2 )
		AniInfo:SetHideAtEnd( true )
	end
	_txt_btnDesc:ComputePos()
end

function Panel_House_ObjectControl_Confirm()
	if( housing_isInstallMode() ) then
		local doit = function()
			-- 장바구니 업데이트
			housing_InstallObject()
			FGlobal_House_InstallationModeCart_Update()
			HouseInstallationControl:Close()
		end

		local doCancel = function()
			-- 끄기
			FGlobal_HouseInstallationControl_Close()
			return
		end			

		local installationType			= UI_CIT.TypeCount
		local characterStaticWrapper	= housing_getCreatedCharacterStaticWrapper();
		if( nil ~= characterStaticWrapper ) then
			installationType = characterStaticWrapper:getObjectStaticStatus():getInstallationType()
			if(( installationType == UI_CIT.eType_WallPaper ) or ( installationType == UI_CIT.eType_FloorMaterial ) ) then
				local titleString	= PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_TITLE_WALLPAPERDONTCANCLE")
				local contentString	= PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_MEMO_WALLPAPERDONTCANCLE")
				local messageboxData= { title = titleString
									, content = contentString, functionYes = doit, functionCancel = doCancel, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
				MessageBox.showMessageBox(messageboxData)
				return;
			end
		end

		doit()	-- 업데이트 한다.
		
	elseif housing_isBuildMode() then
		housing_InstallObject()
		FGlobal_HouseInstallationControl_Close()
		-- 설치 모드를 끝낸다.
		FGlobal_House_InstallationMode_Close()
	else
		-- 설치 모드를 끝낸다.
		FGlobal_House_InstallationMode_Close()
	end
	-- _PA_LOG( "luadebug", "HandleClicked_HouseInstallationControl_Confirm( shoppingCount " ..  tostring(housing_getShoppingBasketItemCount()) )
end

--------------------------------------------------------------------------------
-- 클릭 이벤트
--------------------------------------------------------------------------------
function HandleClicked_HouseInstallationControl_Confirm()
	Panel_House_ObjectControl_Confirm()
end
function HandleClicked_HouseInstallationControl_Rotate( isRight )
	if true == isRight then
		housing_rotateObject( 2 )
	else
		housing_rotateObject( 1 )
	end
end
function HandleClicked_HouseInstallationControl_Delete()
	housing_deleteObject()
	HouseInstallationControl:Close()
end
function HandleClicked_HouseInstallationControl_Move()
	housing_moveObject()
	HouseInstallationControl:Close()
end
function HandleClicked_HouseInstallationControl_Cancel()
	housing_CancelInstallObject()
	HouseInstallationControl:Close()
	PAHousing_FarmInfo_Close();
end

--------------------------------------------------------------------------------
-- 클라이언트 이벤트
--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
-- 외부 이벤트
--------------------------------------------------------------------------------
function FGlobal_HouseInstallationControl_Open( installMode, posX, posY, isShow , isShowMove, isShowFix, isShowDelete, isShowCancel )	
	if Panel_Win_System:GetShow() then
		-- 확인창이 떠 있으면, 배치를 할 수 없다.
		return
	end

	local self						= HouseInstallationControl
	local characterStaticWrapper	= housing_getCreatedCharacterStaticWrapper()
	local installationType			= nil
	local isCurtain					= false
	if nil ~= characterStaticWrapper then
		installationType = characterStaticWrapper:getObjectStaticStatus():getInstallationType()
	end
	
	_txt_btnDesc				:SetShow( false )	-- 버튼 툴팁을 끈다.


	-- 인벤 아이템 설치 모드 일 때,
	local houseBuildMode	= housing_isBuildMode()
	-- characterStaticWrapper:getObjectStaticStatus():isPersonalTent()

	-- 가구, 씨앗 설치 모드 일 때,
	local houseWrapper		= housing_getHouseholdActor_CurrentPosition()
	local isFixed	= nil
	if nil ~= houseWrapper then
		isFixed	= ( houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isFixedHouse() or houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isInnRoom() )	-- 하우징이면 true, 텃밭이면 false
	end

	local tempShow = isShow
	if( 2 == installMode and false == houseBuildMode ) then	
		tempShow = false;
	end

	local tempisShowDelete = isShowDelete --and getSelfPlayer():get():isMyHouseVisiting()

	self.btn_Resize			:SetShow( false )	-- 사용안한다!

	self.btn_Confirm		:SetShow( tempShow )
	self.btn_Rotate_Right	:SetShow( tempShow )
	self.btn_Rotate_Left	:SetShow( tempShow )
	self.btn_Delete			:SetShow( tempisShowDelete )
	self.btn_Move			:SetShow( isShowMove )
	self.btn_Cancel			:SetShow( isShowCancel )
	if false == tempisShowDelete and 3 == installMode then
		isConfirmStep = true
	else
		isConfirmStep = false
	end

	Panel_House_InstallationMode_ObjectControl:SetIgnore( false )
	if UI_CIT.eType_Chandelier == installationType and 2 == installMode then
		Panel_House_InstallationMode_ObjectControl:SetIgnore( true )
		self.staticText_DetailGuide	:SetShow( true )
		self.staticText_DetailGuide	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_OBJECTCONTROL_DETAILGUIDE1") ) -- "휠스크롤을 이용해 높낮이를 조절 할 수 있습니다." )
		typeIsHavest = false
	elseif UI_CIT.eType_Curtain == installationType and 2 == installMode then
		Panel_House_InstallationMode_ObjectControl:SetIgnore( true )
		self.staticText_DetailGuide	:SetShow( true )
		self.staticText_DetailGuide	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_OBJECTCONTROL_DETAILGUIDE2") ) -- "마우스 이동과 휠스크롤로 폭과 높이를 조절 할 수 있습니다.\n컨트롤 키와 휠스크롤로 커튼 길이를 조절할 수 있습니다." )
typeIsHavest = false
	elseif UI_CIT.eType_WallPaper == installationType and 3 == installMode then
		self.btn_Rotate_Right	:SetShow( false )
		self.btn_Rotate_Left	:SetShow( false )
		typeIsHavest = false
	elseif UI_CIT.eType_FloorMaterial == installationType and 3 == installMode then
		self.btn_Rotate_Right	:SetShow( false )
		self.btn_Rotate_Left	:SetShow( false )
		typeIsHavest = false
	elseif UI_CIT.eType_Havest == installationType and false == isFixed then
		typeIsHavest = true
		self.btn_Rotate_Right	:SetShow( false )
		self.btn_Rotate_Left	:SetShow( false )
	else
		self.staticText_DetailGuide	:SetShow( false )
		typeIsHavest = false
	end

	-- if false == isFixed then
	-- 	-- houseWrapper:getInstallationActorKeyRaw(  )
	-- 	-- FromClient_InterActionHarvestInformation(  )
	-- end

	-- installationType 따라서 한다.
	-- getInstallModeSequence()
	-- installMode
	-- InstallMode_None = 0,
	-- InstallMode_Translation = 1,
	-- InstallMode_Detail = 2 ,
	-- InstallMode_WatingConfirm = 3,
	-- InstallMode_Count = 4,

	if houseBuildMode then
		self.btn_Cancel			:SetShow( false )
	end
	
	Panel_House_InstallationMode_ObjectControl:SetPosX( posX )
	Panel_House_InstallationMode_ObjectControl:SetPosY( posY )
	Panel_House_InstallationMode_ObjectControl:SetShow( isShow )
	
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
	
	HouseInstallationControl_Is_Open = true;
end
function FGlobal_HouseInstallationControl_Close()
	housing_CancelInstallObject()
	Panel_House_InstallationMode_ObjectControl:SetShow( false )
	HouseInstallationControl_Is_Open = false;
end

function FGlobal_HouseInstallationControl_Move()
	housing_moveObject()
	HouseInstallationControl:Close()
end

function FGlobal_HouseInstallationControl_CloseOuter()
	HouseInstallationControl:Close()
end

function FGlobal_HouseInstallationControl_Confirm()
	Panel_House_ObjectControl_Confirm()
end

function FGlobal_HouseInstallationControl_IsConfirmStep()
	return isConfirmStep
end

function HouseInstallationControl:registEventHandler()
	self.btn_Confirm		:addInputEvent("Mouse_LUp",	"HandleClicked_HouseInstallationControl_Confirm()")
	self.btn_Rotate_Right	:addInputEvent("Mouse_LUp",	"HandleClicked_HouseInstallationControl_Rotate( true )")
	self.btn_Rotate_Left	:addInputEvent("Mouse_LUp",	"HandleClicked_HouseInstallationControl_Rotate( false )")
	self.btn_Delete			:addInputEvent("Mouse_LUp",	"HandleClicked_HouseInstallationControl_Delete()")
	self.btn_Move			:addInputEvent("Mouse_LUp",	"HandleClicked_HouseInstallationControl_Move()")
	self.btn_Cancel			:addInputEvent("Mouse_LUp",	"HandleClicked_HouseInstallationControl_Cancel()")
	
	self.btn_Confirm		:ActiveMouseEventEffect( true )
	self.btn_Rotate_Right	:ActiveMouseEventEffect( true )
	self.btn_Rotate_Left	:ActiveMouseEventEffect( true )
	self.btn_Delete			:ActiveMouseEventEffect( true )
	self.btn_Move			:ActiveMouseEventEffect( true )
	self.btn_Cancel			:ActiveMouseEventEffect( true )
	
	self.btn_Confirm			:addInputEvent( "Mouse_On", "Panel_House_ObjectControlDescFunc( true, " .. 1 .. ")" )
	self.btn_Rotate_Right		:addInputEvent( "Mouse_On", "Panel_House_ObjectControlDescFunc( true, " .. 2 .. ")" )
	self.btn_Rotate_Left		:addInputEvent( "Mouse_On", "Panel_House_ObjectControlDescFunc( true, " .. 3 .. ")" )
	self.btn_Delete				:addInputEvent( "Mouse_On", "Panel_House_ObjectControlDescFunc( true, " .. 4 .. ")" )
	self.btn_Move				:addInputEvent( "Mouse_On", "Panel_House_ObjectControlDescFunc( true, " .. 5 .. ")" )
	self.btn_Cancel				:addInputEvent( "Mouse_On", "Panel_House_ObjectControlDescFunc( true, " .. 6 .. ")" )
	self.btn_Resize				:addInputEvent( "Mouse_On", "Panel_House_ObjectControlDescFunc( true, " .. 7 .. ")" )
	
	self.btn_Confirm			:addInputEvent( "Mouse_Out", "Panel_House_ObjectControlDescFunc( false," .. 1 .. ")" )
	self.btn_Rotate_Right		:addInputEvent( "Mouse_Out", "Panel_House_ObjectControlDescFunc( false," .. 2 .. ")" )
	self.btn_Rotate_Left		:addInputEvent( "Mouse_Out", "Panel_House_ObjectControlDescFunc( false," .. 3 .. ")" )
	self.btn_Delete				:addInputEvent( "Mouse_Out", "Panel_House_ObjectControlDescFunc( false," .. 4 .. ")" )
	self.btn_Move				:addInputEvent( "Mouse_Out", "Panel_House_ObjectControlDescFunc( false," .. 5 .. ")" )
	self.btn_Cancel				:addInputEvent( "Mouse_Out", "Panel_House_ObjectControlDescFunc( false," .. 6 .. ")" )
	self.btn_Resize				:addInputEvent( "Mouse_Out", "Panel_House_ObjectControlDescFunc( false," .. 7 .. ")" )
end
function HouseInstallationControl:registMessageHandler()
end

HouseInstallationControl:Initialize()
HouseInstallationControl:registEventHandler()
HouseInstallationControl:registMessageHandler()