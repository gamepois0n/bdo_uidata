local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PP 		= CppEnums.PAUIMB_PRIORITY
local UI_PUCT 		= CppEnums.PA_UI_CONTROL_TYPE
local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color 		= Defines.Color
local UI_TM 		= CppEnums.TextMode


Panel_Inn:SetShow(false,true)
Panel_Inn:setMaskingChild(true)
Panel_Inn:ActiveMouseEventEffect(true)
Panel_Inn:setGlassBackground(true)

Panel_Inn:RegisterShowEventFunc( true, 'Inn_ShowAni()' )
Panel_Inn:RegisterShowEventFunc( false, 'Inn_HideAni()' )

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local _uiBackGround				= UI.getChildControl( Panel_Inn, "Static_BackGround" )
local _styleBG					= UI.getChildControl( Panel_Inn, "Style_BG" )
local _styleButton				= UI.getChildControl( Panel_Inn, "Style_Button" )
local _styleName				= UI.getChildControl( Panel_Inn, "StaticText_Name" )
local _stylePrice				= UI.getChildControl( Panel_Inn, "StaticText_Price" )
local _styleRentable			= UI.getChildControl( Panel_Inn, "StaticText_Rentable" )
local _styleImage				= UI.getChildControl( Panel_Inn, "Static_Image" )
local _styleTime				= UI.getChildControl( Panel_Inn, "StaticText_Time" )
local _styleArea				= UI.getChildControl( Panel_Inn, "StaticText_Area" )
local _styleBasicService		= UI.getChildControl( Panel_Inn, "StaticText_BasicService" )
local _styleSpecialService		= UI.getChildControl( Panel_Inn, "StaticText_SpecialService" )
local _closeButton				= UI.getChildControl( Panel_Inn, "Button_Win_Close" )
local _buttonQuestion			= UI.getChildControl( Panel_Inn, "Button_Question" )		-- 물음표 버튼
local _noticeText				= UI.getChildControl( Panel_Inn, "StaticText_Notice" )
local _currentInn				= UI.getChildControl( Panel_Inn, "StaticText_CurrentInn" )
local _cancelRentedRoomButton 	= UI.getChildControl( Panel_Inn, "Button_CancelRent" )
local _inn_ListPage 			= UI.getChildControl( Panel_Inn, "StaticText_List" ); _inn_ListPage:SetShow(true);
local _inn_BtnLeft				= UI.getChildControl( Panel_Inn, "Button_List_Left" ); _inn_BtnLeft:SetShow(true);
local _inn_BtnRight			 	= UI.getChildControl( Panel_Inn, "Button_List_Right" ); _inn_BtnRight:SetShow(true);

_noticeText:SetTextMode ( UI_TM.eTextMode_AutoWrap )
_styleButton:SetShow(false)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------
-- 변수들 정리
local _uiButtonInnList 	= {}
local roomNumber 		= -1
local _selectedIndex 	= 0
local _maxXCount 		= 1
local _maxYCount 		= 3
local _currentPage		= 0;
local _maxPage			= 0;
local INNLIST_COUNT_PER_PAGE = _maxXCount * _maxYCount;	-- 한페이지당 3개

local InnManager = 
{
	_innList = {}
}


function Inn.createInnSlot(index)
	local innslot = {}
	innslot._staticBack		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, 		Panel_Inn, "Style_BG"..index )
	innslot._name			= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, 	innslot._staticBack, "StaticText_Name"..index )
	innslot._buttonRent		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, 		innslot._staticBack, "Button_Rent"..index )
	innslot._time			= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, 	innslot._staticBack, "StaticText_Time"..index )
	innslot._price			= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, 	innslot._staticBack, "StaticText_Price"..index )
	innslot._rentable		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, 	innslot._staticBack, "StaticText_Rentable"..index )
	innslot._image			= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC,		innslot._staticBack, "Static_Image"..index )
	innslot._area			= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, 	innslot._staticBack, "StaticText_Area"..index )
	innslot._basicService	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, 	innslot._staticBack, "StaticText_BasicService"..index )
	innslot._specialService	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, 	innslot._staticBack, "StaticText_SpecialService"..index )
	
	CopyBaseProperty( _styleBG, 			innslot._staticBack )		;innslot._staticBack:SetShow(true)
	CopyBaseProperty( _styleName, 			innslot._name )				;innslot._name:SetShow(true)
	CopyBaseProperty( _styleButton, 		innslot._buttonRent )		;innslot._buttonRent:SetShow(true)
	CopyBaseProperty( _styleTime, 			innslot._time )				;innslot._time:SetShow(true)
	CopyBaseProperty( _stylePrice, 			innslot._price )			;innslot._price:SetShow(true)
	CopyBaseProperty( _styleRentable, 		innslot._rentable )			;innslot._rentable:SetShow(true)
	CopyBaseProperty( _styleImage, 			innslot._image )			;innslot._image:SetShow(true)
	CopyBaseProperty( _styleArea, 			innslot._area )				;innslot._area:SetShow(true)
	CopyBaseProperty( _styleBasicService, 	innslot._basicService )		;innslot._basicService:SetShow(true)
	CopyBaseProperty( _styleSpecialService, innslot._specialService )	;innslot._specialService:SetShow(true)
	
	innslot._buttonRent:addInputEvent( "Mouse_LUp", "handleInn_Rent(".. index ..")" )
	
	---------------------------------------------
	--		컨트롤들의 위치값을 셋팅해준다
	function innslot:SetPos( x, y )
		innslot._staticBack:SetPosX( x )
		innslot._staticBack:SetPosY( y )
	end
	
	function innslot:SetShow( isShow )
		innslot._staticBack:SetShow(isShow)
	end
	
	function innslot:SetData( innData, myInnCharacterKey )
		
		local roomName = innData:getName()
		local roomPrice = innData:getPrice_s64()
		innslot._name:SetTextMode( UI_TM.eTextMode_AutoWrap )
		innslot._name:SetText(roomName)
		innslot._price:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INN_PRICE", "roomPrice", tostring(roomPrice) ) ) -- - 가격 : "..tostring(roomPrice).." 실버
	
		local innCharacterKey = innData:getInnCharacterKey()
		
		--------------------------------------------------------------------------------------------------------
		-- 										실제 데이터 바인딩
		local screenShotPath 	= innData:get():getObjectStaticStatus():getHouseScreenShotPath(0)	-- 스크린샷 ( 0 ~ 3번까지 가져올 수 있다 )
		local descArea 			= innData:get():getObjectStaticStatus():getDescArea()				-- 면적
		local descFeature1		= innData:get():getObjectStaticStatus():getDescFeature1()			-- 기본 제공
		local descFeature2		= innData:get():getObjectStaticStatus():getDescFeature2()			-- 특징
		--------------------------------------------------------------------------------------------------------

		if( myInnCharacterKey == innCharacterKey ) then
			innslot._buttonRent:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_INN_BTN_RENT_CANCEL") ) -- "<PAColor0xFFFC9D7C>" .. "임대 취소" .."<PAOldColor>"
			innslot._rentable:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_INN_RENTAL") ) -- "<PAColor0xFFFC9D7C>".."임대 중" .."<PAOldColor>"
			innslot._time:SetShow(true)
			innslot._time:SetPosX( innslot._staticBack:GetSizeX() - innslot._rentable:GetTextSizeX()  - innslot._time:GetSizeX() )
		else
			innslot._buttonRent:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_INN_BTN_RENT") ) -- "<PAColor0xFFEFEFEF>" .. "임대하기" .."<PAOldColor>"
			innslot._rentable:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_INN_RENT_POSSIBEL") ) -- "<PAColor0xFF6DC6FF>" .. "임대 가능" .. "<PAOldColor>"
			innslot._time:SetShow(false)
		end

		innslot._area:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_INN_AREA", "descArea", descArea ) ) -- "- 면적 : " .. descArea .."㎡"
		innslot._basicService:SetTextMode( UI_TM.eTextMode_AutoWrap )
		innslot._basicService:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_INN_BASICSERVICES", "descFeature1", descFeature1 ) ) -- "- 기본 제공 : " .. descFeature1
		innslot._specialService:SetTextMode( UI_TM.eTextMode_AutoWrap )
		innslot._specialService:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_INN_SPECIALSERVICE", "descFeature2", descFeature2 ) ) -- "- 특징 : " .. descFeature2
		innslot._image:ChangeTextureInfoName(screenShotPath)
	
	end
	
	return innslot
end

function handleInn_Rent(index)
	
	local roomIndex = index + ( _currentPage * INNLIST_COUNT_PER_PAGE  );
	
	local myInnInfoWrapper = nil --housing_getMyInnInfo()
	local myInnCharacterKey = 0
	local innData = RequestMentalGame_getInnListAt(roomIndex)
	if( nil ~= myInnInfoWrapper ) then
		myInnCharacterKey = myInnInfoWrapper:getHouseCharacterKey()
	end
	
	local innCharacterKey = innData:getInnCharacterKey()
	if( myInnCharacterKey == innCharacterKey ) then
		-- local contentString = "이미 대여중인 여관입니다."
		-- local messageboxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"), content = contentString, functionYes = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		-- MessageBox.showMessageBox(messageboxData)
		-- return
		local name = myInnInfoWrapper:getHouseName()
		local contentString = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_INN_CANCELCONFIRM_MSGBOX", "name", name ) -- "현재 임대중인".. name .."의 임대를 취소합니다. 괜찮습니까?"
		local messageboxData	= { title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"), content = contentString, functionYes = CancelRentedRoomConfirm, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData)
		return
	end
	
	roomNumber = roomIndex
	local currentName = innData:getName()
	if nil ~= myInnInfoWrapper then
		local name = myInnInfoWrapper:getHouseName()
		local contentString = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_INN_CHANGECONFIRM_MSGBOX", "name", name ) -- "현재 임대중인".. name .."의 임대를 취소하고"..currentName.."을 임대하게 됩니다. 임대하시겠습니까?"
		local messageboxData	= { title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"), content = contentString, functionYes = Request_RentInn, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData)
	else
		local contentString = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_INN_RENTCONFIRM_MSGBOX", "currentName", currentName ) -- currentName.."을 임대하시겠습니까?"
		local messageboxData	= { title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"), content = contentString, functionYes = Request_RentInn, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData)
	end
end

----------------------------------------------------------------------------
local startX = 12
local startY = 40
local gapX = 10
local gapY = 10
local sizeX = 120
local sizeY = 190


----------------------------------------------------------------
--					임대 창 애니메이션 처리
----------------------------------------------------------------
function Inn_ShowAni()
	UIAni.fadeInSCR_Down(Panel_Inn)
	audioPostEvent_SystemUi(01,00)
end

function Inn_HideAni()
	Panel_Inn:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo1 = Panel_Inn:addColorAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
	audioPostEvent_SystemUi(01,01)
end


----------------------------------------------------------------
--					초기화 해주는 함수
----------------------------------------------------------------
function InnManager:initialize()
	for indexY = 0, _maxYCount-1, 1 do
		for indexX = 0, _maxXCount-1, 1 do
			local index = (indexY*_maxXCount + indexX)
			self._innList[index] = Inn.createInnSlot( index)
			self._innList[index]:SetPos((indexX * sizeX) + startX , (indexY * sizeY) + startY + (indexY * gapY))
			-- self._innList[index]:SetPos((indexX * sizeX) + startX + (indexX *gapX) , (indexY * sizeY) + startY + (indexY * gapY))
			self._innList[index]:SetShow(true)
		end
	end
end


----------------------------------------------------------------
--				방의 정보를 업데이트 해준다
----------------------------------------------------------------
function InnManager:update()
	
	local myInnInfoWrapper = nil -- housing_getMyInnInfo()
	local myInnCharacterKey = 0
	if( nil ~= myInnInfoWrapper ) then
		myInnCharacterKey = myInnInfoWrapper:getHouseCharacterKey()
	end
	
	local innCount = RequestMentalGame_getInnListCount()
	local startInnIndex = _currentPage * INNLIST_COUNT_PER_PAGE
	for index = 0,  INNLIST_COUNT_PER_PAGE-1 , 1  do
	
		if(startInnIndex <= innCount-1) then
			
			-- _PA_LOG( "lua_debug", "InnManager:update : startInnIndex - " ..startInnIndex );
			local innData = RequestMentalGame_getInnListAt( startInnIndex )
			self._innList[index]:SetData(innData, myInnCharacterKey)
			self._innList[index]:SetShow(true)

			startInnIndex = startInnIndex + 1;
		else
			self._innList[index]:SetShow(false)
		end
		
	end
	
	local householdInfoWrapper = nil --housing_getMyInnInfo()
	if( nil ~= householdInfoWrapper ) then
		local name = householdInfoWrapper:getStaticStatusWrapper():getName()
		_currentInn:SetText("<PAColor0xFF92BA5A>"..PAGetString( Defines.StringSheet_GAME, "LUA_INN_TEXT_INN_NOWRENT") .. " " .. name )		-- 현재 임대하고 있는 집
	else
		_currentInn:SetText("<PAColor0xFFC4BEBE>"..PAGetString( Defines.StringSheet_GAME, "LUA_INN_TEXT_INN_NOWRENT_NONE"))					-- 현재 임대한 집이 없다
	end
end


----------------------------------------------------------------
--					데이터를 입력하는 함수
----------------------------------------------------------------
function ResponseInn_showList()
	local isShow = Panel_Inn:GetShow()
	if isShow == true then
		-- 꺼준다
		Panel_Inn:SetShow(false, true)
	else
		-- 켜준다
		UIAni.fadeInSCR_Down(Panel_Inn)
		Panel_Inn:SetShow(true,true)
		
		local innCount = RequestMentalGame_getInnListCount()
		_maxPage = math.floor(innCount / INNLIST_COUNT_PER_PAGE)
		local _isSecondPage = innCount / INNLIST_COUNT_PER_PAGE
		-- _currentPage = 0
		local isPageBtnShow = (1 < _isSecondPage)
		_inn_BtnLeft:SetShow( isPageBtnShow );
		_inn_BtnRight:SetShow( isPageBtnShow );
		_inn_ListPage:SetShow( isPageBtnShow );
		if( isPageBtnShow ) then
			_inn_ListPage:SetText( tostring(_currentPage + 1) );
		end
					
		InnManager:update()
	end	
end


----------------------------------------------------------------
--					임대 취소를 눌렀다!
----------------------------------------------------------------
function clickCancelRentedRoomButton(index)
	local luaCancelRentedRoomMsg = PAGetString( Defines.StringSheet_GAME, "LUA_INN_TEXT_CANCEL_RENTEDROOM_MSG" )
	local luaCancelRentedRoom = PAGetString( Defines.StringSheet_GAME, "LUA_INN_TEXT_CANCEL_RENTEDROOM" )
	local contentString = luaCancelRentedRoomMsg
	----------------------------------
	-- 		메시지 박스를 띄운다
	local messageboxData = { title = luaCancelRentedRoom, content = contentString, functionYes = CancelRentedRoomConfirm, functionCancel = MessageBox_Empty_function, priority = UI_PP.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
	
end

----------------------------------------------------------------
--					임대 리스트 페이지 버튼
----------------------------------------------------------------
function clickLeftBtn_InnList()

	_currentPage = _currentPage - 1;
	if( _currentPage < 0 ) then
		_currentPage = 0
	end
	
	_inn_ListPage:SetText( tostring(_currentPage + 1) );
	
	InnManager:update()
end

function clickRightBtn_InnList()

	_currentPage = _currentPage + 1
	if( _maxPage < _currentPage ) then
		_currentPage = _maxPage
	end
	
	_inn_ListPage:SetText( tostring(_currentPage + 1) );
	
	InnManager:update();
end

----------------------------------------------------------------
--					실제 임대 취소가 되는 부분
----------------------------------------------------------------
function CancelRentedRoomConfirm()
	inn_CancelRentedInn()
end


----------------------------------------------------------------
--					임대를 요청하는 함수
----------------------------------------------------------------
function Request_RentInn()
	if -1 == roomNumber then
		return
	else
		RequestInn_RentInn(roomNumber)
	end
	ResponseInn_showList()
end

function InnWindow_Close()
	if	Panel_Inn:IsShow()	then
		Panel_Inn:SetShow(false, IsAniUse())
	end
end


---------------------------------------------------------------------------
--	임대 기간이 되었거나 취소했을 때 정상적으로 서버 체크를 했을 경우 ( 여관 )
---------------------------------------------------------------------------
function EventUnoccupyInnRoom( userName, houseName)	
	--[[ 주거지 반남
	local luaUnoccupyInnRoomMsg = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_INN_TEXT_UNOCCUPY_INNROOM_MSG", "userName", userName, "houseName", houseName )
	local luaUnoccupyInnRoom = PAGetString( Defines.StringSheet_GAME, "LUA_INN_TEXT_UNOCCUPY_INNROOM")
	
	local contentString = luaUnoccupyInnRoomMsg
	local messageboxData = { title = luaUnoccupyInnRoom, content = contentString, functionApply = ResponseInn_showList, priority = UI_PP.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData);
	--]]
end

function	EventOccupyInnRoom( useName, houseName )

	--주거지 변경
	local luaOccupyInnRoom = PAGetString( Defines.StringSheet_GAME, "LUA_HOUSECONTROL_CHANGESTATE_TITLE_1")
	
	local contentString = PAGetStringParam1( Defines.StringSheet_GAME, "HOUSING_RENT_HOUSE", "housename", houseName ) -- {housename}가 주거지가 되었습니다.
	Proc_ShowMessage_Ack( contentString )
	--local messageboxData = { title = luaOccupyInnRoom, content = contentString, functionApply = MessageBox_Empty_function, priority = UI_PP.PAUIMB_PRIORITY_LOW}
	--MessageBox.showMessageBox(messageboxData);
	
end

---------------------------------------------------------------------------
--	임대 기간이 되었거나 취소했을 때 정상적으로 서버 체크를 했을 경우 ( 일반 집 )
---------------------------------------------------------------------------
function EventUnoccupyFixedHouse( userName, houseName )
	local luaUnoccupyFixedHouseMsg = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_INN_TEXT_UNOCCUPY_FIXEDHOUSE_MSG", "userName", userName, "houseName", houseName )
	local luaUnoccupyFixedHouse = PAGetString( Defines.StringSheet_GAME, "LUA_INN_TEXT_UNOCCUPY_FIXEDHOUSE")
	
	local contentString = luaUnoccupyFixedHouseMsg
	local messageboxData = { title = luaUnoccupyFixedHouse, content = contentString, functionApply = MessageBox_Empty_function, priority = UI_PP.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData);
end


--------------------------------------------------------------------------------------
InnManager:initialize()

registerEvent("ResponseInn_showList", 		"ResponseInn_showList")
registerEvent("EventUnoccupyInnRoom", 		"EventUnoccupyInnRoom")
registerEvent("EventOccupyInnRoom", 		"EventOccupyInnRoom")
registerEvent("EventUnoccupyFixedHouse", 	"EventUnoccupyFixedHouse")

_closeButton:addInputEvent( "Mouse_LUp", 	"ResponseInn_showList()" )	
_buttonQuestion:addInputEvent( "Mouse_LUp", 	"Panel_WebHelper_ShowToggle( \"PanelInn\" )" )			--물음표 좌클릭
_buttonQuestion:addInputEvent( "Mouse_On", 	"HelpMessageQuestion_Show( \"PanelInn\", \"true\")" )				--물음표 마우스오버
_buttonQuestion:addInputEvent( "Mouse_Out", 	"HelpMessageQuestion_Show( \"PanelInn\", \"false\")" )				--물음표 마우스아웃
_cancelRentedRoomButton:addInputEvent( "Mouse_LUp", "clickCancelRentedRoomButton()" )	
_inn_BtnLeft:addInputEvent( "Mouse_LUp", "clickLeftBtn_InnList()" )
_inn_BtnRight:addInputEvent( "Mouse_LUp", "clickRightBtn_InnList()" )

