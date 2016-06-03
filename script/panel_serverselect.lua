-------------------------------
-- Panel Init
-------------------------------
Panel_ServerSelect:SetShow(true, false)
Panel_ServerSelect:SetSize( getScreenSizeX(), getScreenSizeY() )

--------------------------------
--	"getCurrentWolrdName",	
--  "getCurrentChannelIndex"
--------------------------------

-------------------------------
-- Control Regist & Init
-------------------------------
local	FRAME_SERVERLIST				= UI.getChildControl(Panel_ServerSelect,	"FrameServerList")
local	FRAMEContents_SERVERLIST		= UI.getChildControl(FRAME_SERVERLIST,		"Frame_1_Content")
local	FRAME_Scroll					= UI.getChildControl(FRAME_SERVERLIST,		"Frame_1_VerticalScroll")

local 	SELECT_SERVER_BG_TEXT			= UI.getChildControl(Panel_ServerSelect,	"StaticText_ServerSelect")

local 	WORLD_BG_BTN					= UI.getChildControl(Panel_ServerSelect,	"Button_Server")
local 	WORLD_NAME_TEXT 				= UI.getChildControl(Panel_ServerSelect,	"StaticText_ServerName")
local 	WORLD_Event_TEXT 				= UI.getChildControl(Panel_ServerSelect,	"StaticText_ServerEvent")
local	WORLD_UNABLE_CREATE_CHARACTER	= UI.getChildControl(Panel_ServerSelect,	"Static_UnableCreate")
local 	WORLD_CHARACTERCOUNT_TEXT 		= UI.getChildControl(Panel_ServerSelect,	"StaticText_CharacterCount")
local 	WORLD_STATUS_TEXT				= UI.getChildControl(Panel_ServerSelect,	"Static_ServerStatus")
local	WORLD_PRIMIUMSERVER_ICON		= UI.getChildControl(Panel_ServerSelect,	"Static_PrimiumIcon")

local 	CHANNEL_BG_STATIC				= UI.getChildControl(Panel_ServerSelect,	"Static_ChannelBG")
local 	CHANNEL_NAME_TEXT 				= UI.getChildControl(Panel_ServerSelect,	"StaticText_ChannelName")
local 	CHANNEL_MAINICON_STATIC			= UI.getChildControl(Panel_ServerSelect,	"Static_MainChannelIcon")
local 	CHANNEL_STATUS_TEXT 			= UI.getChildControl(Panel_ServerSelect,	"Static_ChannelStatus")
local 	CHANNEL_ENTER_BTN				= UI.getChildControl(Panel_ServerSelect,	"Button_Channel")

local	CHANNEL_CHANGE_TEXT				= UI.getChildControl(Panel_ServerSelect,	"MultilineText_ChangeChannel")

-- 점령전/거점전 정보
	
local warInfo = {	
	_uiWarInfo			= UI.getChildControl( Panel_ServerSelect,	"Static_WarInfo" ),
	_warInfoTitle		= UI.getChildControl( Panel_ServerSelect,	"StaticText_WarInfo_Title" ),
	_uiBG				= UI.getChildControl( Panel_ServerSelect,	"Static_WarInfo_BG" ),
	_warGuide			= UI.getChildControl( Panel_ServerSelect,	"StaticText_WarGuide" ),
		
	_siegeBG			= UI.getChildControl( Panel_ServerSelect,	"Static_SiegeBG" ),
	_staticChannel		= UI.getChildControl( Panel_ServerSelect,	"StaticText_Channel" ),
	_siegeBalenos		= UI.getChildControl( Panel_ServerSelect,	"StaticText_Siege_Balenos" ),
	_siegeSerendia		= UI.getChildControl( Panel_ServerSelect,	"StaticText_Siege_Serendia" ),
	_siegeCalpheon		= UI.getChildControl( Panel_ServerSelect,	"StaticText_Siege_Calpheon" ),
	_siegeMedia			= UI.getChildControl( Panel_ServerSelect,	"StaticText_Siege_Media" ),
	_siegeValencia		= UI.getChildControl( Panel_ServerSelect,	"StaticText_Siege_Valencia" ),
	_nodeWarBG			= UI.getChildControl( Panel_ServerSelect,	"Static_NodeWarBG" ),
	_staticSchedule		= UI.getChildControl( Panel_ServerSelect,	"StaticText_Schedule" ),
	_scheduleSiege		= UI.getChildControl( Panel_ServerSelect,	"StaticText_Schedule_Siege" ),
	_scheduleNodeWar	= UI.getChildControl( Panel_ServerSelect,	"StaticText_Schedule_Nodewar" ),
	
	_slotMaxCount	= 5,
	_startPosY		= 5,
	_isSieging		= false,
	_isNodeWar		= false,
	
	_slots			={},
}

local channelSelectInfo = {
	_channelSelectTitle	= UI.getChildControl( Panel_ServerSelect, "StaticText_ChannelSelectTitle"),
	_mainBG				= UI.getChildControl( Panel_ServerSelect, "Static_ChannelSelectMainBG"),
	_subBG				= UI.getChildControl( Panel_ServerSelect, "Static_ChannelSelectSubBG"),
	_channelSelectDesc	= UI.getChildControl( Panel_ServerSelect, "StaticText_ChannelSelectDesc"),
}

function channelSelectInfo_Init()
	local self = channelSelectInfo

	self._mainBG		:AddChild(self._channelSelectTitle)
	self._mainBG		:AddChild(self._subBG)
	self._mainBG		:AddChild(self._channelSelectDesc)

	Panel_ServerSelect	:RemoveControl(self._channelSelectTitle)
	Panel_ServerSelect	:RemoveControl(self._subBG)
	Panel_ServerSelect	:RemoveControl(self._channelSelectDesc)

	self._channelSelectTitle	:SetPosX( 10 )
	self._channelSelectTitle	:SetPosY( 30 )
	self._subBG					:SetPosX( 10 )
	self._subBG					:SetPosY( 40 )
	self._channelSelectDesc		:SetPosX( 18 )
	self._channelSelectDesc		:SetPosY( 50 )
end

function warInfo_Init()
	local self	= warInfo	
	-- for ii = 0, self._slotMaxCount -1 do
		-- local slot = {}
		-- slot.slotNo	= ii
		
		-- slot._warListBG		= UI.createAndCopyBasePropertyControl( Panel_ServerSelect, "Static_WarListBG",			self._uiWarInfo,	"warListBG"		.. ii )
		-- slot._nodeName		= UI.createAndCopyBasePropertyControl( Panel_ServerSelect, "StaticText_NodeWar_Name", 	slot._warListBG,	"nodeName"		.. ii )
		-- slot._warStatus		= UI.createAndCopyBasePropertyControl( Panel_ServerSelect, "StaticText_WarStatus",		slot._warListBG,	"warStatus"		.. ii )
		
		-- slot._warListBG		:SetPosX( 5 )
		-- slot._warListBG		:SetPosY( self._startPosY + ( ( slot._warListBG:GetSizeY() + 3 ) * ii ) )
		-- slot._nodeName		:SetPosX( 15 )
		-- slot._nodeName		:SetPosY( 10 )
		-- slot._warStatus		:SetPosX( slot._nodeName:GetSizeX() + 10 )
		-- slot._warStatus		:SetPosY( 10 )
		
		-- self._slots[ii]		= slot
	-- end	
	-- warInfo_Update()	
	self._uiWarInfo	:AddChild(self._warInfoTitle)
	self._uiWarInfo	:AddChild(self._uiBG)
	self._uiWarInfo	:AddChild(self._siegeBG)
	self._uiWarInfo	:AddChild(self._staticChannel)
	self._uiWarInfo	:AddChild(self._siegeBalenos)
	self._uiWarInfo	:AddChild(self._siegeSerendia)
	self._uiWarInfo	:AddChild(self._siegeCalpheon)
	self._uiWarInfo	:AddChild(self._siegeMedia)
	self._uiWarInfo	:AddChild(self._siegeValencia)
	self._uiWarInfo	:AddChild(self._nodeWarBG)
	self._uiWarInfo	:AddChild(self._staticSchedule)
	self._uiWarInfo	:AddChild(self._scheduleSiege)
	self._uiWarInfo	:AddChild(self._scheduleNodeWar)
	
	Panel_ServerSelect :RemoveControl( self._warInfoTitle )
	Panel_ServerSelect :RemoveControl( self._uiBG )
	Panel_ServerSelect :RemoveControl( self._siegeBG )
	Panel_ServerSelect :RemoveControl( self._staticChannel )
	Panel_ServerSelect :RemoveControl( self._siegeBalenos )
	Panel_ServerSelect :RemoveControl( self._siegeSerendia )
	Panel_ServerSelect :RemoveControl( self._siegeCalpheon )
	Panel_ServerSelect :RemoveControl( self._siegeMedia )
	Panel_ServerSelect :RemoveControl( self._siegeValencia )
	Panel_ServerSelect :RemoveControl( self._nodeWarBG )
	Panel_ServerSelect :RemoveControl( self._staticSchedule )
	Panel_ServerSelect :RemoveControl( self._scheduleSiege )
	Panel_ServerSelect :RemoveControl( self._scheduleNodeWar )
	
	self._warInfoTitle:SetPosX( 10 )
	self._warInfoTitle:SetPosY( 38 )
	self._uiBG:SetPosX( 10 )
	self._uiBG:SetPosY( 45 )
	self._siegeBG:SetPosX( 15 )
	self._siegeBG:SetPosY( 50 )
	self._staticChannel:SetPosX( 25 )
	self._staticChannel:SetPosY( 60 )
	self._siegeBalenos:SetPosX( 30 )
	self._siegeBalenos:SetPosY( 80 )
	self._siegeSerendia:SetPosX( 30 )
	self._siegeSerendia:SetPosY( 100 )
	self._siegeCalpheon:SetPosX( 30 )
	self._siegeCalpheon:SetPosY( 120 )
	self._siegeMedia:SetPosX( 30 )
	self._siegeMedia:SetPosY( 140 )
	self._siegeValencia:SetPosX( 30 )
	self._siegeValencia:SetPosY( 160 )
	self._nodeWarBG:SetPosX( 15 )
	self._nodeWarBG:SetPosY( 190 )
	self._staticSchedule:SetPosX( 25 )
	self._staticSchedule:SetPosY( 200 )
	self._scheduleSiege:SetPosX( 30 )
	self._scheduleSiege:SetPosY( 220 )
	self._scheduleNodeWar:SetPosX( 30 )
	self._scheduleNodeWar:SetPosY( 240 )
	if isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_KOR ) then
		warInfo_Show()
		ChannelSelectInfo_Show()
	else
		warInfo_Hide()
		ChannelSelectInfo_Hide()
	end
end

WORLD_BG_BTN					:SetShow(false)
WORLD_NAME_TEXT					:SetShow(false)
WORLD_UNABLE_CREATE_CHARACTER	:SetShow( false )
WORLD_CHARACTERCOUNT_TEXT		:SetShow(false)
WORLD_STATUS_TEXT				:SetShow(false)
WORLD_PRIMIUMSERVER_ICON		:SetShow(false)

CHANNEL_BG_STATIC				:SetShow(false)
CHANNEL_NAME_TEXT				:SetShow(false)
CHANNEL_STATUS_TEXT				:SetShow(false)
CHANNEL_ENTER_BTN				:SetShow(false)
CHANNEL_CHANGE_TEXT				:SetShow(false)

FRAME_SERVERLIST				:SetShow(true)

local screenX = getScreenSizeX()
local screenY = getScreenSizeY()
Static_Back	= Array.new()

local bgCount = 17
local totalBG = 18
if isGameTypeKorea() then
	if ToClient_isEventOn('x-mas') then
		bgCount = 18
	else
		bgCount = 17
	end
elseif isGameTypeRussia() then
	bgCount = 10
elseif isGameTypeEnglish() then
	bgCount = 10
elseif isGameTypeJapan() then			-- 일본은 발렌시아까지 오픈했따!
	if ToClient_isEventOn('x-mas') then
		bgCount = 17
	else
		bgCount = 16
	end
	totalBG = 17
else
	bgCount = 10
end

for ii = 1, totalBG do
	targetControl = UI.getChildControl( Panel_ServerSelect, "Static_Back_"..ii )
	targetControl:SetSize(screenX, screenY)
	targetControl:SetPosX(0.0)
	targetControl:SetPosY(0.0)
	targetControl:SetAlpha(0.0)
	Static_Back[ii] = targetControl
end

-------------------------------
-- 변수
-------------------------------
local _selectWorldIndex = -1;
local _worldServerCount = 0;

local _channelCtrl =
{
	_bgStatic,
	_nameText,
	_statusText,
	_enterBtn,
	_changeChannel,
}

local _worldServerCtrl =
{
	_bgButton,
	_nameText,
	_countText,
	_statusText,
	_channelCount,
	_channelCtrls,
}
local _worldServerCtrls = {}


-------------------------------
-- 구현부
-------------------------------


------------------------------------------------------------------------------------
-- 		 			서버/채널 상태에 따른 텍스처 변경.
------------------------------------------------------------------------------------

local serverStatusTexture = {
	[0] = { 133, 27, 149, 43 },	-- 점 검
	{ 150, 27, 166, 43 },	-- 원 활
	{ 167, 27, 183, 43 },	-- 혼 잡
	{ 184, 27, 200, 43 },	-- 매우혼잡
	{ 184, 44, 200, 60 },	-- 만 원
}

function changeTexture_ByServerStatus( control, status )
	control:ChangeTextureInfoName( "new_ui_common_forlua/Default/Default_Etc_01.dds" )
	local x1, y1, x2, y2 = setTextureUV_Func( control, serverStatusTexture[status][1], serverStatusTexture[status][2], serverStatusTexture[status][3], serverStatusTexture[status][4] )
	control:getBaseTexture():setUV( x1, y1, x2, y2 )
	control:setRenderTexture(control:getBaseTexture())
end

local createStatusTexture = {
	[0] = { 139, 44, 166, 71 },		-- 가능
	{ 111, 44, 138, 71 },			-- 불가능
}
function changeTexture_ByCreateStatus( control, status )
	control:ChangeTextureInfoName( "new_ui_common_forlua/Default/Default_Etc_01.dds" )
	local x1, y1, x2, y2 = setTextureUV_Func( control, createStatusTexture[status][1], createStatusTexture[status][2], createStatusTexture[status][3], createStatusTexture[status][4] )
	control:getBaseTexture():setUV( x1, y1, x2, y2 )
	control:setRenderTexture(control:getBaseTexture())
end




------------------------------------------------------------------------------------
-- 									서버 리스트
------------------------------------------------------------------------------------
function StartUp_Panel_SelectServer()
	if isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_KOR ) then
		SELECT_SERVER_BG_TEXT:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_CHANNEL") )
	else
		SELECT_SERVER_BG_TEXT:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_SERVER") )
	end


	Panel_ServerSelect:SetSize(getScreenSizeX(), getScreenSizeY());
	
	_worldServerCount =  getGameWorldServerDataCount()

	-- _PA_LOG("Lua" , "StartUp_Panel_SelectServer: worldCount " ..tostring(_worldServerCount) );
	
	for idx = 0 , _worldServerCount-1 do
		local serverData = getGameWorldServerDataByIndex(idx)
		if ( nil == serverData ) then
			break
		end
		
		local isExpBonusEvent = IsWorldServerEventTypeByWorldIndex( idx, 0 )
		local isDropRateEvent = IsWorldServerEventTypeByWorldIndex( idx, 1 )
		-- _PA_LOG("Lua" , "StartUp_Panel_SelectServer: idx " ..tostring(idx) );
		
		local worldCtrl = {}
		
		-- 버튼
		local tempBtn = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, FRAME_SERVERLIST:GetFrameContent(), "WorldButton_" .. tostring(idx) )
		CopyBaseProperty( WORLD_BG_BTN, tempBtn )	
		tempBtn:SetShow(true)
		tempBtn:ActiveMouseEventEffect( true )
		tempBtn:addInputEvent("Mouse_LUp", "Panel_Lobby_function_SelectWorldServer(" .. idx .. ")")
		tempBtn:SetPosX( 0 )
		tempBtn:SetPosY( idx * ( tempBtn:GetSizeY() + 25 ) )
		
		-- 이름
		local tempName = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempBtn, "WorldName_" .. tostring(idx) )
		CopyBaseProperty( WORLD_NAME_TEXT, tempName )	
		tempName:SetShow(true)
		tempName:ActiveMouseEventEffect( true )

		local tempWorldName = getWorldNameByWorldNo(serverData._worldNo)
		tempName:SetText( tempWorldName )
		tempName:SetPosX( 20 )
		tempName:SetPosY( 14 )

		-- 정액 서버 아이콘
		local tempPrimiumIcon = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempBtn, "WorldPrimiumIcon_" .. tostring(idx) )
		CopyBaseProperty( WORLD_PRIMIUMSERVER_ICON, tempPrimiumIcon )	
		tempPrimiumIcon:SetPosX( 20 )

		-- 이벤트 여부
		local tempEvent = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempBtn, "WorldEventName_" .. tostring(idx) )
		CopyBaseProperty( WORLD_Event_TEXT, tempEvent )	
		tempEvent:ActiveMouseEventEffect( true )

		local tempEventName = ""
		if isExpBonusEvent then
			tempEventName = tempEventName .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_EXPEVENT")
		end
		if isDropRateEvent then
			tempEventName = tempEventName .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_DROPEVENT")
		end

		if "" == tempEventName then
			tempName:SetPosY( 20 )
			tempEvent:SetShow( false )

			tempPrimiumIcon:SetPosY( 20 )
		else
			tempName:SetPosY( 14 )
			tempEvent:SetShow( true )

			tempPrimiumIcon:SetPosY( 14 )
		end

		-- 러시아 정액 서버 처리.
		local temporaryWrapper	= getTemporaryInformationWrapper()
		local isFixedCharge		= temporaryWrapper:isFixedCharge()
		if serverData._fixedCharge	then
			tempPrimiumIcon:SetShow( true )
			tempName:SetPosX( tempPrimiumIcon:GetPosX() + tempPrimiumIcon:GetSizeX() + 2 )
		else
			tempPrimiumIcon:SetShow( false )
			tempName:SetPosX( 20 )
		end

		tempEvent:SetText( tempEventName )
		tempEvent:SetPosX( 20 )
		tempEvent:SetPosY( 37 )

		-- 캐릭터 수
		local tempCount = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempBtn, "WorldCount_" .. tostring(idx) )
		CopyBaseProperty( WORLD_CHARACTERCOUNT_TEXT, tempCount )	
		tempCount:SetShow(true)
		tempCount:ActiveMouseEventEffect( true )
		
		local tempStr = ""
		tempStr = '(' .. tostring( serverData._characterCount ) ..'/' ..tostring(serverData._deleteCount) ..')'
		
		tempCount:SetText( tempStr );
		tempCount:SetPosX( 180 )
		tempCount:SetPosY( 20 )

		-- if(serverData._doRestrictCharacterCreation) then
		-- 	tempUnableCreate:SetShow( true )
		-- end		
		
		-- 상태
		local tempStatus = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempBtn, "WorldStatus_" .. tostring(idx) )
		CopyBaseProperty( WORLD_STATUS_TEXT, tempStatus )	
		tempStatus:SetShow(true)
		tempStatus:ActiveMouseEventEffect( true )
		tempStatus:SetAutoResize( true )
		tempStatus:SetVerticalMiddle()
		tempStatus:SetHorizonRight()
		
		local busyState = getGameWorldServerBusyByIndex(idx)
		-- changeTexture_ByServerStatus( tempStatus, busyState )

		if( busyState == 0 ) then
			tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_0") -- "<PAColor0xff868686>점 검<PAOldColor>"
		elseif( busyState == 1 ) then
			tempStr = ""
		elseif( busyState == 2 ) then
			tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_2") -- "<PAColor0xffeabf4c>혼 잡<PAOldColor>"
		elseif( busyState == 3 ) then
			tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_3") -- "<PAColor0xffed6363>매우혼잡<PAOldColor>"
		elseif( busyState == 4 ) then
			tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_4") -- "<PAColor0xffed6363>만 원<PAOldColor>"
		end

		-- 생성 제한.
		local tempUnableCreate = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempBtn, "WorldUnableCreate_" .. tostring(idx) )
		CopyBaseProperty( WORLD_UNABLE_CREATE_CHARACTER, tempUnableCreate )	
		tempUnableCreate:SetShow( true )
		tempUnableCreate:SetPosX( tempBtn:GetSizeX() - (tempUnableCreate:GetSizeX() * 1.5) )
		tempUnableCreate:SetPosY( 18 )

		if ToClient_IsCreatableWorldServer( idx ) then
			changeTexture_ByCreateStatus( tempUnableCreate, 0 )
		else
			changeTexture_ByCreateStatus( tempUnableCreate, 1 )
		end
		
		tempStatus:SetText( tempStr )
		tempStatus:SetSpanSize( (tempUnableCreate:GetSizeX()*2) + 10,-3 )
		
		worldCtrl._bgButton 	= tempBtn;
		worldCtrl._nameText 	= tempName;
		worldCtrl._unableCreate = tempUnableCreate;
		worldCtrl._countText	= tempCount;
		worldCtrl._statusText	= tempStatus;
		
		_worldServerCtrls[idx] = worldCtrl
	end
		
	for idx = 0 , _worldServerCount-1 do
		Panel_SelectServer_ReCreateChannelCtrl(idx);	
	end

	_selectWorldIndex = -1;
	
	Panel_Lobby_function_SelectWorldServer(0)
	Panel_SelectServer_RePositioningCtrls();
end

------------------------------------------------------------------------------------
-- 									채널 리스트
------------------------------------------------------------------------------------
function Panel_SelectServer_ReCreateChannelCtrl(worldIndex)
	
	local worldServerData	    = getGameWorldServerDataByIndex(worldIndex)
	local restrictedServerNo	= worldServerData._restrictedServerNo;

	local changeChannelTime		= getChannelMoveableRemainTime( worldServerData._worldNo )
	local changeMoveChannel		= getChannelMoveableTime( worldServerData._worldNo )
	local changeRealChannelTime	= convertStringFromDatetime( changeChannelTime )
	local changeMoveChannelTime	= convertStringFromDatetime( changeMoveChannel )
	_worldServerCtrls[worldIndex]._channelCount = getGameChannelServerDataCount(worldServerData._worldNo);
	_worldServerCtrls[worldIndex]._channelCtrls = {}
		
	for idx = 0 , _worldServerCtrls[worldIndex]._channelCount -1  do
		local serverData = getGameChannelServerDataByIndex(worldIndex, idx)
		if ( nil == serverData ) then
			break
		end		
		
		local isAdmission = true;
		if( restrictedServerNo ~= 0 ) then
			if( restrictedServerNo == serverData._serverNo ) then
				isAdmission = true;
			else
				if( toInt64(0,0) < changeChannelTime ) then
					isAdmission = false;
				else
					isAdmission = true;
				end
			end		
		end
			
		local strTemp = "ChannelBG_" ..tostring(worldIndex).."_"..tostring(idx);
		
		-- _PA_LOG( "Lua", "  strTemp " .. strTemp )
	
		-- 채널 배경 	
		local tempBG = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, FRAME_SERVERLIST:GetFrameContent(), "ChannelBG_" ..tostring(worldIndex).."_"..tostring(idx) )
		CopyBaseProperty( CHANNEL_BG_STATIC, tempBG )	
		tempBG:SetShow(false)
		tempBG:ActiveMouseEventEffect( true )
		tempBG:SetIgnore(false)
		-- tempBG:SetSize( tempBG:GetSizeX(), tempBG:GetSizeY( )
		
		-- 이름
		local tempName = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempBG, "ChannelName_" ..tostring(worldIndex).."_"..tostring(idx) )
		CopyBaseProperty( CHANNEL_NAME_TEXT, tempName )	
		tempName:SetShow(true)
		tempName:ActiveMouseEventEffect( true )
		
		-- 채널 아이콘
		local tempMainIcon = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempBG, "ChannelMainIcon_" ..tostring(worldIndex).."_"..tostring(idx) )
		CopyBaseProperty( CHANNEL_MAINICON_STATIC, tempMainIcon )	
		tempMainIcon:SetShow(false)
		tempMainIcon:ActiveMouseEventEffect( true )

		local admissionDesc = ""
		if( false == isAdmission ) then
			admissionDesc = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SERVERSELECT_ISADMISSION_LIMIT", "admissionDesc", admissionDesc ) -- admissionDesc.."(제한됨)"
		else
			admissionDesc = admissionDesc -- .."(입장가능)"
		end
		
		local channelName = getChannelName(worldServerData._worldNo, serverData._serverNo )
		_PA_ASSERT( nil ~= channelName, '서버 이름은 존재해야합니다.')
		
		if true == isGameServiceTypeDev() then
			channelName = channelName .." " .. getDotIp(serverData) .. admissionDesc 
		else
			channelName = channelName.." "..admissionDesc 
		end
		
		tempName:SetText( channelName )

		tempName:SetPosX( 15 ) 
		tempName:SetPosY( 13 )

		if serverData._isMain == true then
			tempMainIcon:SetShow( false ) -- 지희환 이사님의 요청으로 메인채널을 따로 표기해주지 않는다!(모든 국가 통일)
			tempMainIcon:SetPosX( 15 )
			tempMainIcon:SetPosY( 17 )
		end
					
		-- 상태
		local tempStatus = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempBG, "ChannelStatus_" ..tostring(worldIndex).."_"..tostring(idx) )
		CopyBaseProperty( CHANNEL_STATUS_TEXT, tempStatus )	
		tempStatus:SetShow(true)
		tempStatus:ActiveMouseEventEffect( true )
		
		local busyState = serverData._busyState
		if( busyState == 0 ) then
			tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_0") -- "<PAColor0xff868686>점 검<PAOldColor>"
		elseif( busyState == 1 ) then -- 재희형의 요청으로 2016-02-19에 원활은 표기 안하기로 작업함.
			tempStr = "" -- PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_1") -- "<PAColor0xffd0ee68>원 활<PAOldColor>"
		elseif( busyState == 2 ) then
			tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_2") -- "<PAColor0xffeabf4c>혼 잡<PAOldColor>"
		elseif( busyState == 3 ) then
			tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_3") -- "<PAColor0xffed6363>매우혼잡<PAOldColor>"
		elseif( busyState == 4 ) then
			tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_4") -- "<PAColor0xffed6363>만 원<PAOldColor>"
		end

		tempStatus:SetText( tempStr )
		-- changeTexture_ByServerStatus( tempStatus, busyState )

		tempStatus:SetPosX( 160 )
		tempStatus:SetPosY( 14 )

		local tempUnableCreate = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempBG, "ChannelCreateStatus_" .. tostring(idx) )
		CopyBaseProperty( WORLD_UNABLE_CREATE_CHARACTER, tempUnableCreate )	
		tempUnableCreate:SetShow( true )
		tempUnableCreate:SetPosX( 235 )
		tempUnableCreate:SetPosY( 11 )

		if serverData._isCreatable then
			changeTexture_ByCreateStatus( tempUnableCreate, 0 )
		else
			changeTexture_ByCreateStatus( tempUnableCreate, 1 )
		end

		-- 버튼
		local tempBtn = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, tempBG, "ChannelButton_" ..tostring(worldIndex).."_"..tostring(idx) )
		CopyBaseProperty( CHANNEL_ENTER_BTN, tempBtn )	
		tempBtn:SetIgnore(false)
		tempBtn:ActiveMouseEventEffect( true )
		tempBtn:SetPosX( 270 ) 
		tempBtn:SetPosY( 7 )
		tempBtn:addInputEvent("Mouse_LUp", "Panel_Lobby_function_EnterChannel(" .. idx .. ")")

		-- 채널 변경 제한 텍스트
		local tempChgChannel = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_MULTILINETEXT, tempBG, "ChannelChangeText_" .. tostring(worldIndex).."_"..tostring(idx))
		CopyBaseProperty( CHANNEL_CHANGE_TEXT, tempChgChannel )
		tempChgChannel:SetIgnore(true)
		tempChgChannel:SetPosX( 265 )
		tempChgChannel:SetPosY( 7 )
		-- 개발에서는 제한됐을때만 입장버튼을 보여주고
		if true == isLoginIDShow() then
			tempBtn:SetShow( isAdmission );
			if toInt64(0,0) < changeChannelTime then
				tempChgChannel:SetShow( not isAdmission )
				tempChgChannel:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SERVERSELECT_CHANGECHANNEL", "changeRealChannelTime", changeRealChannelTime ) )
			end
		else -- 서비스 버젼에서는 점검상태도 체크한 후 보여준다.
			tempBtn:SetShow( isAdmission and (busyState ~= 0)  );
			
			local isTextShow = (not isAdmission) and (busyState ~= 0)
			tempChgChannel:SetShow( isTextShow )

			if isTextShow then
				if toInt64(0,0) < changeChannelTime then
					tempChgChannel:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SERVERSELECT_CHANGECHANNEL", "changeRealChannelTime", changeRealChannelTime ) )
				else
					tempChgChannel:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SERVERSELECT_CHANGECHANNEL", "changeRealChannelTime", 0 ) )
				end
			end
			
		end

		-- 러시아 정액 서버 처리.
		if isGameTypeRussia() or CppEnums.CountryType.DEV == getGameServiceType() then
			local temporaryWrapper	= getTemporaryInformationWrapper()
			local isFixedCharge		= temporaryWrapper:isFixedCharge()
			if serverData._fixedCharge	then
				if isFixedCharge then	-- 과금을 했다.
					tempBtn:SetIgnore( false )
					tempBtn:SetMonoTone( false )
				else
					tempBtn:SetIgnore( true )
					tempBtn:SetMonoTone( true )
				end
			else
				tempBtn:SetIgnore( false )
				tempBtn:SetMonoTone( false )
			end
		end
		
		_worldServerCtrls[worldIndex]._channelCtrls[idx] = {}
		_worldServerCtrls[worldIndex]._channelCtrls[idx]._bgStatic 		= tempBG
		_worldServerCtrls[worldIndex]._channelCtrls[idx]._nameText 		= tempName
		_worldServerCtrls[worldIndex]._channelCtrls[idx]._statusText 	= tempStatus
		_worldServerCtrls[worldIndex]._channelCtrls[idx]._enterBtn		= tempBtn
		_worldServerCtrls[worldIndex]._channelCtrls[idx]._changeChannel	= tempChgChannel

	end
end

local delayTime = 1
local serverSelectDeltaTime = 0
function Panel_SelectServer_Delta( deltaTime )
	serverSelectDeltaTime = serverSelectDeltaTime + deltaTime
	if ( delayTime <= serverSelectDeltaTime  )then
		local serverCount = getGameWorldServerDataCount()
		for index = 0 , serverCount-1 do
			local worldServerData	    = getGameWorldServerDataByIndex(index)
			local restrictedServerNo	= worldServerData._restrictedServerNo;

			local changeChannelTime		= getChannelMoveableRemainTime( worldServerData._worldNo )
			changeChannelTime		= changeChannelTime - toInt64(0,20)	-- 서버 클라 간 시간 차이 때문에 더함.
			local changeMoveChannel		= getChannelMoveableTime( worldServerData._worldNo )
			local changeRealChannelTime	= convertStringFromDatetime( changeChannelTime )
			local changeMoveChannelTime	= convertStringFromDatetime( changeMoveChannel )

			for idx = 0 , _worldServerCtrls[index]._channelCount -1  do

				local serverData = getGameChannelServerDataByIndex(index, idx)
				if ( nil == serverData ) then
					break
				end

				local isAdmission = true;
				if( restrictedServerNo ~= 0 ) then
					if( restrictedServerNo == serverData._serverNo ) then
						isAdmission = true;
					else
						if( toInt64(0,0) < changeChannelTime ) then
							isAdmission = false;
						else
							isAdmission = true;
						end
					end
				end

				local busyState = serverData._busyState
				if( busyState == 0 ) then
					tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_0") -- "<PAColor0xff868686>점 검<PAOldColor>"
				elseif( busyState == 1 ) then
					tempStr = ""
				elseif( busyState == 2 ) then
					tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_2") -- "<PAColor0xffeabf4c>혼 잡<PAOldColor>"
				elseif( busyState == 3 ) then
					tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_3") -- "<PAColor0xffed6363>매우혼잡<PAOldColor>"
				elseif( busyState == 4 ) then
					tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_4") -- "<PAColor0xffed6363>만 원<PAOldColor>"
				end
				_worldServerCtrls[index]._channelCtrls[idx]._statusText:SetText( tempStr )

				local isTempShow = isAdmission and (busyState ~= 0)

				local admissionDesc = ""
				if( false == isAdmission ) then
					admissionDesc = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SERVERSELECT_ISADMISSION_LIMIT", "admissionDesc", admissionDesc ) -- admissionDesc.."(제한됨)"
				else
					admissionDesc = admissionDesc -- .."(입장가능)"
				end

				local channelName = getChannelName(worldServerData._worldNo, serverData._serverNo )
				_PA_ASSERT( nil ~= channelName, '서버 이름은 존재해야합니다.')
				
				if true == isGameServiceTypeDev() then
					channelName = channelName .." " .. getDotIp(serverData) .. admissionDesc 
				else
					channelName = channelName.." "..admissionDesc 
				end
				
				_worldServerCtrls[index]._channelCtrls[idx]._nameText:SetText( channelName )

				if true == isLoginIDShow() then -- 개발 버전에서는 서버 상태 체크 안한다.
					_worldServerCtrls[index]._channelCtrls[idx]._enterBtn:SetShow( isAdmission )
				else
					_worldServerCtrls[index]._channelCtrls[idx]._enterBtn:SetShow( true )
				end

				_worldServerCtrls[index]._channelCtrls[idx]._changeChannel:SetShow( not isTempShow )
				if( 0 == busyState ) then
					_worldServerCtrls[index]._channelCtrls[idx]._changeChannel:SetShow( false )
				end
				
				_worldServerCtrls[index]._channelCtrls[idx]._changeChannel:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SERVERSELECT_CHANGECHANNEL", "changeRealChannelTime", changeRealChannelTime ) )
			end
		end

		-- Panel_Lobby_function_SelectWorldServer(0)
		-- Panel_SelectServer_RePositioningCtrls();
		serverSelectDeltaTime = 0
	end
end

function Panel_SelectServer_ShowChannelCtrls(worldIndex)

	local count = _worldServerCount
	for idx=0, count-1 do
			
		local isShow = false;
		if( idx == worldIndex ) then
			isShow = true;
		end
		
		for channelIdx = 0, _worldServerCtrls[idx]._channelCount-1 do	
		
			_worldServerCtrls[idx]._channelCtrls[channelIdx]._bgStatic:SetShow(isShow)
			
			-- _PA_LOG( "Lua", "Panel_SelectServer_ShowChannelCtrls world idx show "..tostring(idx).." "..tostring(channelIdx).." ".. tostring(isShow) )
		end		
	end

end

function 	Panel_SelectServer_RePositioningCtrls()
	local bgPosY 			= SELECT_SERVER_BG_TEXT:GetPosY() + 20
	local worldSizeY		= WORLD_BG_BTN:GetSizeY()

	local posX = SELECT_SERVER_BG_TEXT:GetPosX() + 20
	local posY = bgPosY + 30
	
	FRAME_SERVERLIST:SetPosX( posX )
	FRAME_SERVERLIST:SetPosY( posY )
		
	posX = 0
	posY = 0
	local count = _worldServerCount
	for idx = 0, count-1 do 
		_worldServerCtrls[idx]._bgButton:SetPosX( posX )
		_worldServerCtrls[idx]._bgButton:SetPosY( posY + 5 )
	
		local varyY = Panel_SelectServer_GetVariableSizeY( posX + 5, posY, idx )
		posY = posY + varyY
		
		SELECT_SERVER_BG_TEXT:SetSize( SELECT_SERVER_BG_TEXT:GetSizeX(), getScreenSizeY() - 20 )
	end
	FRAME_SERVERLIST:SetSize( SELECT_SERVER_BG_TEXT:GetSizeX() - 40 , SELECT_SERVER_BG_TEXT:GetSizeY() - 60 )
	FRAMEContents_SERVERLIST:SetSize(SELECT_SERVER_BG_TEXT:GetSizeX() - 40 , posY)
	FRAME_Scroll	:SetSize( FRAME_Scroll:GetSizeX() , SELECT_SERVER_BG_TEXT:GetSizeY() - 60 )
	FRAME_SERVERLIST:UpdateContentPos()
	if FRAME_SERVERLIST:GetSizeY() < FRAMEContents_SERVERLIST:GetSizeY() then
		FRAME_Scroll:SetShow( true )
	else
		FRAME_Scroll:SetShow( false )
	end
end

function	Panel_SelectServer_GetVariableSizeY( posX, posY, worldIndex )
	local default = WORLD_BG_BTN:GetSizeY() + 10
		
	if ( _selectWorldIndex ~= worldIndex ) then
		return default;
	end
	
	local channelSizeY = CHANNEL_BG_STATIC:GetSizeY() + 5
	local count = _worldServerCtrls[worldIndex]._channelCount
	local tempPosY
	for idx=0, count-1 do 
		local isShow = _worldServerCtrls[worldIndex]._channelCtrls[idx]._bgStatic:GetShow();
		tempPosY = posY + default + ( channelSizeY * idx )
		local tempPosYGap = 5

		_worldServerCtrls[worldIndex]._channelCtrls[idx]._bgStatic:SetPosX( posX )
		_worldServerCtrls[worldIndex]._channelCtrls[idx]._bgStatic:SetPosY( tempPosY )
	end
	FRAMEContents_SERVERLIST:SetSize( posX , tempPosY+default )
	
	return ( default + (channelSizeY * count) )
end

function Panel_Lobby_function_SelectWorldServer(index)
	_selectWorldIndex = index
	
	Panel_SelectServer_ShowChannelCtrls(index)
	Panel_SelectServer_RePositioningCtrls()
	
end

function Panel_Lobby_function_EnterChannel(index)

	selectServerGroup( _selectWorldIndex, index)

end

function EventUpdateServerInformation_SelectServer()
	local isShow = Panel_ServerSelect:IsShow()	-- 서버 데이터를 업데이트했다.
	if( false == isShow ) then
		return;
	end

	local selectIndex = _selectWorldIndex;
	
	-- 데이터 설정
	StartUp_Panel_SelectServer()

	-- 선택한 서버가 있으면 세부 채널을 보여준다.
	if( -1  ~= selectIndex ) then
		Panel_Lobby_function_SelectWorldServer(selectIndex);
	end
	
end

function SelectServer_RequestInfo_ForTest()
	
	requestServerInformationForTest()
	
end

function PanelServerSelect_Resize()

	local count = getGameWorldServerDataCount() + 1
	Panel_ServerSelect:SetSize( getScreenSizeX(), getScreenSizeY() )

	SELECT_SERVER_BG_TEXT:SetSize( SELECT_SERVER_BG_TEXT:GetSizeX() + 21, ( count * 48 ) + 50 )
	SELECT_SERVER_BG_TEXT:SetHorizonRight()
	
	FRAME_SERVERLIST:SetSize( SELECT_SERVER_BG_TEXT:GetSizeX() - 40 , SELECT_SERVER_BG_TEXT:GetSizeY() - 60 )
	FRAME_Scroll	:SetSize( FRAME_Scroll:GetSizeX() , SELECT_SERVER_BG_TEXT:GetSizeY() - 60 )
	FRAME_SERVERLIST:SetHorizonRight()
	-- SELECT_SERVER_BG_TEXT:SetSize( SELECT_SERVER_BG_TEXT:GetSizeX(), (count * 48) + 50)
	-- SELECT_SERVER_BG_TEXT:SetSize( SELECT_SERVER_BG_TEXT:GetSizeX(), getScreenSizeY() - 30 )
	FRAME_SERVERLIST:UpdateContentPos()
	
	if FRAME_SERVERLIST:GetSizeY() < FRAME_SERVERLIST:GetSizeY() then
		FRAME_Scroll:SetShow( true )
	else
		FRAME_Scroll:SetShow( false )
	end

	for ii = 1, totalBG do
		Static_Back[ii]:SetSize( getScreenSizeX(), getScreenSizeY() )
	end
end

local BgImgIndex = 1	-- 시작 배경 이미지 숫자.
if isGameTypeKorea() then
	if ToClient_isEventOn('x-mas') then
		BgImgIndex = 18
	else
		BgImgIndex = 17
	end
elseif isGameTypeRussia() then
	BgImgIndex = 1
elseif isGameTypeJapan() then
	if ToClient_isEventOn('x-mas') then
		BgImgIndex = 17
	else
		BgImgIndex = 16
	end
else
	BgImgIndex = 1
end

local currentBackIndex = BgImgIndex -- getRandomValue(1, 11)
local nextBackIndex = currentBackIndex + 1
Static_Back[currentBackIndex]:SetShow(true)
Static_Back[currentBackIndex]:SetAlpha(1.0)

local updateTime = 0.0
local isScope = true
local startUV = 0.1
local endUV = startUV + 0.04
local startUV2 = 0.9
local endUV2 = startUV2 + 0.04

function warInfo_onScreenResize()
	local self = warInfo
	local scrX = getScreenSizeX()	
	self._uiWarInfo:SetPosX( scrX - ( FRAME_SERVERLIST:GetSizeX() + self._uiWarInfo:GetSizeX() + 55 ))
	self._uiWarInfo:SetPosY( 155 )
end

function ChannelSelectInfo_onScreenResize()
	local self = channelSelectInfo
	local scrX = getScreenSizeX()
	self._mainBG:SetPosX( scrX - ( FRAME_SERVERLIST:GetSizeX() + self._mainBG:GetSizeX() + 55 ) )
	self._mainBG:SetPosY( 10 )
end

function warInfo_Show()
	local self = warInfo
	warInfo_onScreenResize()
	self._uiWarInfo:SetShow( true )
end

function warInfo_Hide()
	local self	= warInfo
	if	(not self._uiWarInfo:GetShow() )	then
		return
	end
	self._uiWarInfo:SetShow( false )
end

function ChannelSelectInfo_Show()
	local self = channelSelectInfo
	ChannelSelectInfo_onScreenResize()
	self._mainBG:SetShow( true )
end

function ChannelSelectInfo_Hide()
	local self = channelSelectInfo
	if ( not self._mainBG:GetShow() ) then
		return
	end
	self._mainBG:SetShow( false )
end

-- function warInfo_Update()
	-- local self = warInfo	
	-- local territoryCount = getTerritoryListByAll()	
	
	-- -- 초기화
	-- self._uiWarInfo:SetShow( false )
	-- for territory_idx = 0, territoryCount -1 do
		-- self._slots[territory_idx]._warListBG:SetShow( false )
	-- end	
	
	-- local uiIdx = 0
	-- for territory_idx = 0, territoryCount -1 do
		-- local territoryKey			= getTerritoryByIndex( territory_idx )		
		-- local territoryName			= getTerritoryNameByKey( territoryKey )		
		-- local isSiegeBeing_Value	= isSiegeBeing( territory_idx ) -- 점령전이 진행 중인가?		
		-- local nowBeingMinor = ToClient_GetVillageSiegeCountByTerritory(territoryKey, true)		
		
		-- if isSiegeBeing_Value then
			-- self._slots[uiIdx]._warListBG:SetShow( true )
			-- self._slots[uiIdx]._nodeName:SetShow( true )
			-- self._slots[uiIdx]._nodeName:SetText( territoryName )
			-- self._slots[uiIdx]._warStatus:SetShow( true )
			-- self._slots[uiIdx]._warStatus:SetText("(점령전 진행중)")
			-- self._isSieging	= true
			
			-- uiIdx = uiIdx + 1
		-- elseif 0 < nowBeingMinor then		
			-- self._slots[uiIdx]._warListBG:SetShow( true )
			-- self._slots[uiIdx]._nodeName:SetShow( true )
			-- self._slots[uiIdx]._nodeName:SetText( territoryName )
			-- self._slots[uiIdx]._warStatus:SetShow( true )
			-- self._slots[uiIdx]._warStatus:SetText("(거점전 진행중)")
			-- self._isNodeWar	= true
			-- uiIdx = uiIdx + 1
		-- end		
	-- end
	-- if self._isSieging or self._isNodeWar then
		-- warInfo_Show()
	-- end
	
-- end


function Panel_ServerSelect_Update(deltaTime)
	Panel_SelectServer_Delta( deltaTime )
	updateTime = updateTime - deltaTime
	if updateTime <= 0.0 then
		updateTime = 15.0
		if isScope then
			Static_Back[currentBackIndex]:SetShow(true)
			isScope = false
			local FadeMaskAni = Static_Back[currentBackIndex]:addTextureUVAnimation (0.0, 15.0, 0 )
		
			FadeMaskAni:SetStartUV ( startUV, startUV, 0 )
			FadeMaskAni:SetEndUV ( endUV, startUV, 0 )

			FadeMaskAni:SetStartUV ( startUV2, startUV, 1 )
			FadeMaskAni:SetEndUV ( endUV2, startUV, 1 )

			FadeMaskAni:SetStartUV ( startUV, startUV2, 2 )
			FadeMaskAni:SetEndUV ( endUV, startUV2, 2 )

			FadeMaskAni:SetStartUV ( startUV2, startUV2, 3 )
			FadeMaskAni:SetEndUV ( endUV2, startUV2, 3 )
		else
			isScope = true
			local FadeMaskAni = Static_Back[currentBackIndex]:addTextureUVAnimation (0.0, 15.0, 0 )
		
			FadeMaskAni:SetEndUV ( startUV, startUV, 0 )
			FadeMaskAni:SetStartUV ( endUV, startUV, 0 )

			FadeMaskAni:SetEndUV ( startUV2, startUV, 1 )
			FadeMaskAni:SetStartUV ( endUV2, startUV, 1 )

			FadeMaskAni:SetEndUV ( startUV, startUV2, 2 )
			FadeMaskAni:SetStartUV ( endUV, startUV2, 2 )

			FadeMaskAni:SetEndUV ( startUV2, startUV2, 3 )
			FadeMaskAni:SetStartUV ( endUV2, startUV2, 3 )
			
			local fadeColor = Static_Back[currentBackIndex]:addColorAnimation( 15.0, 17.0, 0)
			fadeColor:SetStartColor( Defines.Color.C_FFFFFFFF )
			fadeColor:SetEndColor( Defines.Color.C_00FFFFFF )

			if bgCount < nextBackIndex then
				nextBackIndex = getRandomValue(1, bgCount)
			end

			local baseTexture = Static_Back[nextBackIndex]:getBaseTexture()
			baseTexture:setUV(startUV, startUV, startUV2, startUV2)
			Static_Back[nextBackIndex]:setRenderTexture(baseTexture)
			local fadeColor2 = Static_Back[nextBackIndex]:addColorAnimation( 12.0, 15.0, 0)
			fadeColor2:SetStartColor( Defines.Color.C_00FFFFFF )
			fadeColor2:SetEndColor( Defines.Color.C_FFFFFFFF )
			
			currentBackIndex = nextBackIndex
			if bgCount <= nextBackIndex then
				nextBackIndex = BgImgIndex
			else
				nextBackIndex = getRandomValue(BgImgIndex, bgCount) + 1
			end
		end
	end
	
	--[[
	if isKeyDown_Once( 0x74 ) then --CppEnums.VirtualKeyCode.KeyCode_F5 ) then
		if Panel_ServerSelect:GetShow() then
			SelectServer_RequestInfo_ForTest()
	 	end
	 end
	--]]
	
end

registerEvent("EventChangeLobbyStageToServerSelect",				"StartUp_Panel_SelectServer")
registerEvent("EventUpdateServerInformationForServerSelect",		"EventUpdateServerInformation_SelectServer")
	
Panel_ServerSelect:RegisterUpdateFunc("Panel_ServerSelect_Update")
registerEvent( "onScreenResize", "PanelServerSelect_Resize" )
PanelServerSelect_Resize()
warInfo_Init()
channelSelectInfo_Init()