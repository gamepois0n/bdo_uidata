---------------------------
-- Panel Init
---------------------------
Panel_Radar			:SetShow(true, false)
Panel_Radar			:SetIgnore(true)
Panel_Radar			:setGlassBackground(true)

Panel_TimeBar		:SetShow(true, false)
Panel_TimeBar		:RegisterShowEventFunc(true, " ")
Panel_TimeBar		:RegisterShowEventFunc(false, " ")
Panel_TimeBarNumber	:SetIgnore(true)

Panel_Radar			:RegisterShowEventFunc( true, 'RaderShowAni()' )
Panel_Radar			:RegisterShowEventFunc( false, 'RaderHideAni()' )

ToClient_setRadorUIPanel(Panel_Radar)
ToClient_setRadorUIViewDistanceRate( 85 * 85 )
ToCleint_InitializeRadarActorPool(1000)

---------------------------
-- Local Variablesicon_quest_accept
---------------------------
local CGT 							= CppEnums.CharacterGradeType
local UI_ANI_ADV 					= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 						= Defines.Color
local UI_TM							= CppEnums.TextMode
local UI_RT		 					= CppEnums.RegionType

local isDrag						= false
local alphaValue					= 1.0	-- 배경 알파값이 30%가 기본이다
local simpleUIAlpha 				= 0.0;

local raderText						= UI.getChildControl( Panel_Radar,		"StaticText_raderText" )
local radar_Background				= UI.getChildControl( Panel_Radar, 		"rader_background" )
local radar_SizeSlider				= UI.getChildControl( Panel_Radar, 		"Slider_MapSize" )
local radar_SizeBtn					= UI.getChildControl( radar_SizeSlider, "Slider_MapSize_Btn" )
local radar_AlphaScrl				= UI.getChildControl( Panel_Radar, 		"Slider_RadarAlpha" )
local radar_AlphaBtn				= UI.getChildControl( radar_AlphaScrl,	"RadarAlpha_CtrlBtn" )
local radar_OverName				= UI.getChildControl( Panel_Radar, 		"Static_OverName" )
local radar_MiniMapScl				= UI.getChildControl( Panel_Radar, 		"Button_SizeControl" )
local radar_regionName				= UI.getChildControl( Panel_Radar, 		"StaticText_RegionName" )
local radar_regionNodeName			= UI.getChildControl( Panel_Radar, 		"StaticText_RegionNodeName" )
local radar_regionWarName			= UI.getChildControl( Panel_Radar, 		"StaticText_RegionWarName" )
local radar_DangerIcon				= UI.getChildControl( Panel_Radar, 		"Static_DangerArea" )
local redar_DangerAletText			= UI.getChildControl( Panel_Radar,		"StaticText_MonsterAlert" )
local radar_DangetAlertBg			= UI.getChildControl( Panel_Radar,		"Static_Alert")
radar_regionName:SetAutoResize( true )
radar_regionName:SetNotAbleMasking( true )
radar_regionNodeName:SetAutoResize( true )
radar_regionNodeName:SetNotAbleMasking( true )
radar_regionWarName:SetAutoResize( true )
radar_regionWarName:SetNotAbleMasking( true )

-- 경고 문구 메시지
redar_DangerAletText:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
redar_DangerAletText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RADER_NEARMONSTERALERT" ) ) -- "<주의> 주변에 강한 몬스터가 있습니다!")
redar_DangerAletText:SetShow( false )
redar_DangerAletText:SetDepth( -9999 )
radar_DangetAlertBg:SetShow( false )
radar_DangetAlertBg:SetDepth( -9998 )

local raderAlert_Resize = function()
	if redar_DangerAletText:GetSizeY() < redar_DangerAletText:GetTextSizeY() then
		redar_DangerAletText:SetSize( Panel_Radar:GetSizeX()-25, redar_DangerAletText:GetSizeY() + 20 )
	else
		redar_DangerAletText:SetSize( Panel_Radar:GetSizeX()-25, redar_DangerAletText:GetSizeY() )
	end
	redar_DangerAletText:ComputePos()
	
	radar_DangetAlertBg:SetSize( Panel_Radar:GetSizeX()-25, Panel_Radar:GetSizeY()-25 )
	radar_DangetAlertBg:ComputePos()
end
raderAlert_Resize()

local Panel_OrigSizeX				= 320 --Panel_Radar:GetSizeXOrigin()
local Panel_OrigSizeY				= 280 --Panel_Radar:GetSizeYOrigin()
local wheelCount					= 0.5		-- 0.95
local cacheSimpleUI_ShowButton 		= true;
local isMouseOn 					= false
local scaleMinValue					= 50
local scaleMaxValue 				= 150
local useLanternAlertTime			= 0

local beforSafeZone					= false		-- 이전 지역이 안전 지역이었나?
local beforeCombatZone				= false		-- 이전 지역이 전투 지역이었나?
local beforeArenaZone				= false		-- 이전 지역이 결투 지역이었나?
local beforeDesertZone				= false		-- 이전 지역이 사막 지역이었나?

local nodeWarRegionName				= nil
local balenciaPart2					= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 65 )

radar_Background:SetAlpha( 0.0 )

-- 함수 전방 선언
local RadarMap_UpdatePixelRate 		-- PixelRate가 변경 될때, 호출 된다.
-- 함수 전방 선언 끝
local radarTime =
{
	controls =
	{
		-- timeLine				= UI.getChildControl(Panel_TimeBar, "timeLine"),
		-- timeElement			= UI.getChildControl(Panel_TimeBar, "timeElement"),
		-- timeElement_right	= UI.getChildControl(Panel_TimeBar, "timeElement2"),
		iconNotice				= UI.getChildControl(Panel_TimeBar, "StaticText_Icon_Notice"),	-- 아이콘 도움말 풍선
		commandCenter			= UI.getChildControl(Panel_TimeBar, "Static_CommandCenter"),	-- 지휘소
		citadel					= UI.getChildControl(Panel_TimeBar, "Static_Citadel"),			-- 성채
		raining					= UI.getChildControl(Panel_TimeBar, "Static_Raining"),			-- 비
		siegeArea				= UI.getChildControl(Panel_TimeBar, "Static_SiegeArea" ),		-- 점령전 건물 건설 가능 여부
		VillageWar				= UI.getChildControl(Panel_TimeBar, "Static_VillageWarArea" ),	-- 세력전 아이콘
		regionType				= UI.getChildControl(Panel_TimeBar, "regionType"),				-- 안전 지역
		regionName				= UI.getChildControl(Panel_TimeBar, "regionName"),				-- 지역 이름
		terrainInfo				= UI.getChildControl(Panel_TimeBar, "StaticText_Terrain"),		-- 도로 위
		serverName				= UI.getChildControl(Panel_TimeBar, "StaticText_ServerName"),	-- 서버이름
		channelName				= UI.getChildControl(Panel_TimeBar, "StaticText_ChannelName"),	-- 채널이름
		gameTime				= UI.getChildControl(Panel_TimeBar, "StaticText_Time"),			-- 시간
	}
}
radarTime.controls.regionType:SetShow( false )
radarTime.controls.regionName:SetShow( false )

local UCT_STATICTEXT			= CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT
local terrainNotice 			= UI.getChildControl ( Panel_Radar, "Static_Notice")
local terrainNoticeStyle		= UI.getChildControl ( Panel_Radar, "StaticText_Notice")
local terrainNoticeText			= UI.createControl( UCT_STATICTEXT, terrainNotice, "terrainNoticeText")
local textInfo					= ""
Panel_Radar:SetChildIndex( terrainNotice,						9999 )
CopyBaseProperty( terrainNoticeStyle, terrainNoticeText )
UI.deleteControl(terrainNoticeStyle)
terrainNoticeStyle = nil
terrainNoticeText:SetSpanSize(10,0)

-- 사용할 전역 함수들!
local floor = math.floor
local sqrt = math.sqrt

local RegionData_IngameTime = 0
local RegionData_RealIngameTime = 0
-- local RegionData_ElementWidth = radarTime.controls.timeElement:GetSizeX()
local dayCycle = 24 * 60 * 60
local QuestArrowHalfSize = 0
---------------------------
-- Functions
---------------------------
local checkLoad = function()
	local radarControl = radarMap.controls

	local SPI = radarControl.icon_SelfPlayer			-- Self Player Icon
	-- 코드에, icon_SelfPlayer 가 가로 세로가 동일한 정사각형이라고 가정하고 작성한 코드가 있다!
	UI.ASSERT(SPI:GetSizeX() == SPI:GetSizeY()			, "[Radar.lua] icon_SelfPlayer MEST BE 'square'")
end

local updateWorldMapDistance = function( mapRadius )
	local config = radarMap.config
	config.mapRadius = math.min(math.max(mapRadius, scaleMinValue), scaleMaxValue)
	radarMap.worldDistanceToPixelRate = config.mapRadiusByPixel / config.mapRadius
	ToClient_setRadorUIDistanceToPixelRate(radarMap.worldDistanceToPixelRate / 100 * 2)

	RadarMap_UpdatePixelRate()
end

function Rader_updateWorldMapDistance_Reset( )
--[[	updateWorldMapDistance(30)
	
	wheelCount = 0.7;
	radar_SizeSlider:SetControlPos( 30 )
	audioPostEvent_SystemUi(00,00)
]]--
	radarMap.config.mapRadius = radarMap.config.constMapRadius;
	FGlobal_Rader_updateWorldMapDistance_Relative( 1.3 )
end

function FGlobal_Rader_updateWorldMapDistance_Relative( value )
	updateWorldMapDistance(radarMap.config.mapRadius + ( radarMap.config.constMapRadius * value ) )	
	local percents = (radarMap.config.mapRadius - scaleMinValue)
	percents = math.max(math.min(percents, 100), 0)
	radar_SizeSlider:SetControlPos( 100 - percents )
		
	ToClient_SetRaderScale(radar_SizeSlider:GetControlPos())
	ToClient_SaveUiInfo( false )
end

function FGlobal_Rader_UpdateWorldMapDistance( value )
	
end

--버튼들 정렬
local controlAlign = function()
	local scl_minus = radarMap.controls.rader_Minus
	local scl_plus = radarMap.controls.rader_Plus

	radar_SizeSlider:SetScale( radarMap.scaleRateWidth, 1.0 )	
	scl_plus:SetPosX( scl_minus:GetPosX() + scl_minus:GetSizeX() + radar_SizeSlider:GetSizeX() + 15 )

	local alpha_plus = radarMap.controls.rader_AlphaPlus
	local alpha_minus = radarMap.controls.rader_AlphaMinus	
	
	radar_AlphaScrl:SetScale( 1.0, radarMap.scaleRateHeight )	
	
	alpha_minus:SetPosY( alpha_plus:GetPosY() + radar_AlphaScrl:GetSizeY() + alpha_minus:GetSizeY() + 5 )
	
	local resetIcon = radarMap.controls.rader_Reset
	
	resetIcon:SetVerticalBottom()
	resetIcon:SetHorizonRight()
	radar_MiniMapScl:SetVerticalBottom()

	radar_DangerIcon	:ComputePos()
	radar_regionWarName	:ComputePos()
end

local MAX_WIDTH = 512
local MAX_HEIGHT = 512

--미니맵 스케일링
function FromClient_MapSizeScale()
	local origEndX = Panel_Radar:GetPosX() + Panel_Radar:GetSizeX()
	
	if( MAX_WIDTH >= origEndX - getMousePosX() and origEndX - getMousePosX() >= Panel_OrigSizeX  ) then
		Panel_Radar:SetPosX( getMousePosX() )
		Panel_Radar:SetSize( origEndX - getMousePosX(), Panel_Radar:GetSizeY() )
		
		radarMap.controls.rader_Background:SetPosX( 0 )
		radarMap.controls.rader_Background:SetSize( origEndX - getMousePosX(), Panel_Radar:GetSizeY() )
	end
	
	if(  MAX_HEIGHT >= getMousePosY() - Panel_Radar:GetPosY() and getMousePosY() - Panel_Radar:GetPosY() >= Panel_OrigSizeY ) then
		Panel_Radar:SetSize( Panel_Radar:GetSizeX(), getMousePosY() - Panel_Radar:GetPosY() )
		
		radarMap.controls.rader_Background:SetSize( Panel_Radar:GetSizeX(), getMousePosY() - Panel_Radar:GetPosY() )
	end
		
	
	radarMap.scaleRateWidth = Panel_Radar:GetSizeX() / Panel_OrigSizeX
	radarMap.scaleRateHeight = Panel_Radar:GetSizeY() / Panel_OrigSizeY	
	
	local SPI = radarMap.controls.icon_SelfPlayer
	
	local halfSelfSizeX = SPI:GetSizeX() / 2
	local halfSelfSizeY = SPI:GetSizeY() / 2
	
	local halfSizeX = Panel_Radar:GetSizeX() / 2
	local halfSizeY = Panel_Radar:GetSizeY() / 2	
	
	SPI:SetPosX( (halfSizeX - halfSelfSizeX) )
	SPI:SetPosY( (halfSizeY - halfSelfSizeY) )
	
	radarMap.pcPosBaseControl.x = SPI:GetPosX() + halfSelfSizeX
	radarMap.pcPosBaseControl.y = SPI:GetPosY() + halfSelfSizeY	
	
	ToClient_setRadorUICenterPosition( int2(radarMap.pcPosBaseControl.x, radarMap.pcPosBaseControl.y) )

	controlAlign()
	
	NpcNavi_Reset_Posistion()		-- NPC 찾기창 위치 초기화
	Panel_Endurance_Resize()
	Panel_HorseEndurance_Resize()
	TownNpcIcon_Resize()
	FGlobal_MovieGuideButton_Position()
	
	ToClient_SaveUiInfo(false)
	raderAlert_Resize()
end

------------------------------------------------------------------------------
--					레이다 배경 알파 조정하는 함수
------------------------------------------------------------------------------

function Rader_IconsSetAlpha( alpha )
	local actorAlpha = math.max( math.min( alpha + 0.2, 1 ), 0.7 );
	for _,areaQuest in pairs(radarMap.areaQuests) do
		areaQuest.icon_QuestArea:SetAlpha( actorAlpha );
		areaQuest.icon_QuestArrow:SetAlpha( actorAlpha );
	end

	radarMap.controls.icon_SelfPlayer:SetAlpha(actorAlpha )

	RaderMapBG_SetAlphaValue( alphaValue );
	FGlobal_PositionGuideSetAlpha( actorAlpha);
end
function Radar_CalcAlaphValue( alpha )
	alphaValue = math.max(math.min( alpha , 1.0 ), 0.0)
	radar_AlphaScrl:SetControlPos( 100 * (1 - alphaValue) )

	alphaValue = alphaValue + ( (1 - alphaValue) * 0.5)
	return alphaValue;
end


function Rader_updateWorldMap_AlphaControl( alpha )
	alphaValue = Radar_CalcAlaphValue( 1 -radar_AlphaScrl:GetControlPos() + alpha );
	Rader_IconsSetAlpha( alphaValue )	
	
	ToClient_SetRaderAlpha(radar_AlphaScrl:GetControlPos())
	ToClient_SaveUiInfo( false )
end

function FGlobal_ReloadRaderAlphaValue()
	alphaValue = Radar_CalcAlaphValue( alphaValue );
	Rader_IconsSetAlpha( alphaValue );
end



------------------------------------------------------------------------------
--				레이다 배경 알파 조정하는 함수 - 스크롤
------------------------------------------------------------------------------
function Rader_updateWorldMap_AlphaControl_Init()
	local alphaSlideValue = 1.0 - radar_AlphaScrl:GetControlPos()
	alphaSlideValue = Radar_CalcAlaphValue( alphaSlideValue )
	Rader_IconsSetAlpha( alphaSlideValue )
	alphaValue = alphaSlideValue
end

function Rader_updateWorldMap_AlphaControl_Scrl()
	Rader_updateWorldMap_AlphaControl_Init()
	
	ToClient_SetRaderAlpha(radar_AlphaScrl:GetControlPos())
	ToClient_SaveUiInfo( false )
end


------------------------------------------------------------------------------
--				레이다 스케일링 함수 - 스크롤
------------------------------------------------------------------------------
function Rader_updateWorldMap_ScaleControl_Scrl()

	local scaleSlideValue = 1.0 - radar_SizeSlider:GetControlPos()
	updateWorldMapDistance(scaleMinValue + scaleSlideValue * 100)
	--updateWorldMapDistance(radarMap.config.mapRadius + scaleSlideValue * 100)
	NpcNavi_Reset_Posistion()
	
	ToClient_SetRaderScale(radar_SizeSlider:GetControlPos())
	ToClient_SaveUiInfo( false )
end

-- 레이다 스케일링이 휠 스크롤로도 가능하게
function Rader_updateWorldMap_ScaleControl_Wheel( isUp )
	if true == isUp then
		if wheelCount > 0 then
			wheelCount = wheelCount - 0.05
--			updateWorldMapDistance(scaleMinValue + wheelCount * 100)
			updateWorldMapDistance(radarMap.config.mapRadius + wheelCount * 100)
		end
	else
		if wheelCount < 1 then
			wheelCount = wheelCount + 0.05
--			updateWorldMapDistance(scaleMinValue + wheelCount * 100)
			updateWorldMapDistance(radarMap.config.mapRadius + wheelCount * 100)
		end
	end

	--local percents = (radarMap.config.mapRadius * wheelCount) / 60 * 100
	--percents = math.max(math.min(percents, 100), 0)
	local percents = wheelCount * 100
	radar_SizeSlider:SetControlPos( 100 - percents )

	NpcNavi_Reset_Posistion()
end

function Radar_SetRotateMode( isRotate )
	radarMap.isRotateMode = isRotate;
	local rot = 0;
	if( isRotate ) then
		rot = math.pi;
	end

	local radarControl = radarMap.controls
	radarControl.rader_Background:SetParentRotCalc(isRotate)
	radarControl.rader_Background:SetParentRotCalc(isRotate)
	radarControl.icon_SelfPlayer:SetRotate(rot);

	FGlobal_PinRotateMode( isRotate )
	RadarBackground_SetRotateMode( isRotate )
	Radar_UpdateQuestList()
end
--------------------------------------------------------------------------------------------
-- PIN
--------------------------------------------------------------------------------------------
local pinX, pinZ
function Radar_PinUpdate( isAlways )	
	SendPingInfo_ToClient( isAlways )
end

function Radar_MouseOn()
	isMouseOn = true;	
end

function Radar_MouseOut()
	isMouseOn = false;
end

function RadarMap_Background_MouseRUp()
	local mousePosX = getMousePosX();
	local mousePosY = getMousePosY();

	local posX = mousePosX - Panel_Radar:GetPosX();
	local posZ = mousePosY - Panel_Radar:GetPosY() - Panel_Radar:GetSizeY();

	if isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_KOR ) then
		if getSelfPlayer():get():getLevel() < 11 then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TUTORIAL_PROGRSS_ACK") ) -- "튜토리얼 진행 중에는 네비게이션을 임의로 바꾸거나 설정할 수 없습니다." )
			updateQuestWidgetList( FGlobal_QuestWidgetGetStartPosition() )	-- 의뢰 업데이트!
			updateQuestWindowList( FGlobal_QuestWindowGetStartPosition() )	-- 의뢰 업데이트!
			return
		end
	end

	if ToClient_IsShowNaviGuideGroup(0) then
		radar_MiniMapScl:AddEffect( "fUI_Button_Hide", false, posX, posZ)
		ToClient_DeleteNaviGuideByGroup(0);
	else
		radar_MiniMapScl:AddEffect( "fUI_Button_Hide", false, posX, posZ)

		local posX = getMousePosX() - Panel_Radar:GetPosX()		-- 레이더 기준의로 좌표 변환
		local posY = getMousePosY() - Panel_Radar:GetPosY()		-- 레이더 기준으로 좌표 변환
	
		local intervalX = posX - ( radarMap.controls.icon_SelfPlayer:GetPosX() + (radarMap.controls.icon_SelfPlayer:GetSizeX() / 2))	-- 레이더 내의 포지션을 기준으로 좌표 변환
		local intervalZ = ( radarMap.controls.icon_SelfPlayer:GetPosY() + (radarMap.controls.icon_SelfPlayer:GetSizeY() / 2)) - posY
	
		intervalX = intervalX * ( 100 / ( radarMap.worldDistanceToPixelRate * 2 ) )
		intervalZ = intervalZ * ( 100 / ( radarMap.worldDistanceToPixelRate * 2 )  )
	
		local selfPosition = getSelfPlayer():get3DPos();
	-- * 100의 이유는 Radar의 축적이  1 : 100이다.(미터)
		local float3Pos = float3(selfPosition.x + intervalX,		-- X 좌표를 월드로 변환
							0,													-- Y는 쓰지 않는다
							selfPosition.z + intervalZ	)
		
--		posX =  (mousePosX - (Panel_Radar:GetPosX() + Panel_Radar:GetSizeX() / 2.0)) * 12800.0 / 255;
--		posZ = -(mousePosY - (Panel_Radar:GetPosY() + Panel_Radar:GetSizeY() / 2.0)) * 12800.0 / 255;
		
--		selfPosition.x = selfPosition.x + posX;
--		selfPosition.z = selfPosition.z + posZ;
		float3Pos.y = selfPosition.y
		ToClient_WorldMapNaviStart( float3Pos, NavigationGuideParam(), false, true );
		audioPostEvent_SystemUi(00,14)
	end
end

local controlInit = function()
	-- Radar
	-- Panel_Radar:SetIgnore(true)	
	local radarControl = radarMap.controls
	radarControl.timeNum:SetShow(false)		-- 시간 숫자는 최초에 꺼진 상태
	radarControl.timeNum:SetIgnore(true)

	local SPI = radarControl.icon_SelfPlayer	-- Self Player Icon
	
	radarMap.pcPosBaseControl.x = SPI:GetPosX() + SPI:GetSizeX() / 2
	radarMap.pcPosBaseControl.y = SPI:GetPosY() + SPI:GetSizeY() / 2	
	ToClient_setRadorUICenterPosition( int2(radarMap.pcPosBaseControl.x, radarMap.pcPosBaseControl.y) )

	--FGlobal_Rader_updateWorldMapDistance_Relative( 1.3 )
--	updateWorldMapDistance(radarMap.config.mapRadius)

	radarTime.controls.terrainInfo:addInputEvent("Mouse_On", "TerrainInfo_ShowBubble(true)")
	radarTime.controls.terrainInfo:addInputEvent("Mouse_Out", "TerrainInfo_ShowBubble(false)")
	
	radarTime.controls.raining		:addInputEvent("Mouse_On", 		"Rader_Icon_Help_BubbleShowFunc(".. 0 .. ", true )")
	radarTime.controls.raining		:addInputEvent("Mouse_Out", 	"Rader_Icon_Help_BubbleShowFunc(".. 0 .. ", false )")
	radarTime.controls.citadel		:addInputEvent("Mouse_On", 		"Rader_Icon_Help_BubbleShowFunc(".. 1 .. ", true )")
	radarTime.controls.citadel		:addInputEvent("Mouse_Out", 	"Rader_Icon_Help_BubbleShowFunc(".. 1 .. ", false )")
	radarTime.controls.siegeArea	:addInputEvent("Mouse_On", 		"Rader_Icon_Help_BubbleShowFunc(".. 2 .. ", true )")
	radarTime.controls.siegeArea	:addInputEvent("Mouse_Out", 	"Rader_Icon_Help_BubbleShowFunc(".. 2 .. ", false )")
	radarTime.controls.VillageWar	:addInputEvent("Mouse_On", 		"Rader_Icon_Help_BubbleShowFunc(".. 3 .. ", true )")
	radarTime.controls.VillageWar	:addInputEvent("Mouse_Out", 	"Rader_Icon_Help_BubbleShowFunc(".. 3 .. ", false )")

	radar_DangerIcon				:addInputEvent("Mouse_On", 		"Rader_Icon_Help_BubbleShowFunc(".. 4 .. ", true )")
	radar_DangerIcon				:addInputEvent("Mouse_Out", 	"Rader_Icon_Help_BubbleShowFunc(".. 4 .. ", false )")

	-- radarTime.controls.commandCenter:addInputEvent("Mouse_On", 	"Rader_Icon_Help_BubbleShowFunc(".. 2 .. ", true )")
	-- radarTime.controls.commandCenter:addInputEvent("Mouse_Out", "Rader_Icon_Help_BubbleShowFunc(".. 2 .. ", false )")
	
	-- 매 프레임 업데이트 함수
	Panel_Radar:RegisterUpdateFunc( "RadarMap_UpdatePerFrame" )

	radarControl.rader_Plus			:addInputEvent("Mouse_LUp",		"FGlobal_Rader_updateWorldMapDistance_Relative(-0.1)")
	radarControl.rader_Minus		:addInputEvent("Mouse_LUp",		"FGlobal_Rader_updateWorldMapDistance_Relative(0.1)")
	radar_SizeBtn					:addInputEvent("Mouse_LPress",	"Rader_updateWorldMap_ScaleControl_Scrl()")
	radar_SizeSlider				:addInputEvent("Mouse_LPress",	"Rader_updateWorldMap_ScaleControl_Scrl()")
	
	radarControl.rader_AlphaPlus	:addInputEvent("Mouse_LUp",		"Rader_updateWorldMap_AlphaControl(0.05)")
	radarControl.rader_AlphaMinus	:addInputEvent("Mouse_LUp",		"Rader_updateWorldMap_AlphaControl(-0.05)")
	radar_AlphaBtn					:addInputEvent("Mouse_LPress",	"Rader_updateWorldMap_AlphaControl_Scrl()")
	radar_AlphaScrl					:addInputEvent("Mouse_LPress",	"Rader_updateWorldMap_AlphaControl_Scrl()")
	radar_AlphaScrl					:SetControlPos( 100 - (alphaValue * 100) )
	
	radarControl.rader_Reset:addInputEvent("Mouse_LUp", "Rader_updateWorldMapDistance_Reset()")
	radarControl.rader_Close:addInputEvent("Mouse_LDown", "Panel_Radar_ShowToggle()")
	-- radarControl.rader_NpcFind_Toggle:addInputEvent("Mouse_LDown", "NpcNavi_ShowToggle()")	--NPC 찾기
	-- radarControl.rader_NpcFind_Toggle:SetShow( true )
	radarControl.rader_Background:SetSize(  Panel_Radar:GetSizeX(), Panel_Radar:GetSizeY() )
	radarControl.rader_Background:addInputEvent("Mouse_LDown", 		"Radar_PinUpdate(false)")
	radarControl.rader_Background:addInputEvent("Mouse_LDClick", 	"Radar_PinUpdate(true)")
	radarControl.rader_Background:addInputEvent("Mouse_UpScroll",	"FGlobal_Rader_updateWorldMapDistance_Relative(-0.1)"	)
	radarControl.rader_Background:addInputEvent("Mouse_RUp",		"RadarMap_Background_MouseRUp()"	)	
	radarControl.rader_Background:addInputEvent("Mouse_DownScroll",	"FGlobal_Rader_updateWorldMapDistance_Relative(0.1)"	)
	radar_MiniMapScl:addInputEvent( "Mouse_LPress", "FromClient_MapSizeScale()" )
	radar_MiniMapScl:addInputEvent( "Mouse_On", "RadarScale_SimpleTooltips( true )" )
	radar_MiniMapScl:addInputEvent( "Mouse_Out", "RadarScale_SimpleTooltips( false )" )
	radar_MiniMapScl:addInputEvent( "Mouse_LUp", "HandleClicked_RadarResize()" )
	radar_MiniMapScl:setTooltipEventRegistFunc("RadarScale_SimpleTooltips( true )")

	radarTime.controls.channelName:addInputEvent("Mouse_LUp", "FGlobal_ChannelSelect_Show()")
	
	controlAlign()

	RadarMap_Init()
	Panel_Radar:ChangeSpecialTextureInfoName( "New_UI_Common_forLua/Widget/Rader/Minimap_Mask.dds" )
	Panel_Radar:setMaskingChild(true)
	
	radarControl.rader_Plus:SetNotAbleMasking( true )
	radarControl.rader_Minus:SetNotAbleMasking( true )
	radar_SizeBtn:SetNotAbleMasking(true)
	radar_SizeSlider:SetNotAbleMasking(true)
	radarControl.rader_AlphaPlus:SetNotAbleMasking( true )
	radarControl.rader_AlphaMinus:SetNotAbleMasking( true )
	radar_AlphaBtn:SetNotAbleMasking( true )
	radar_AlphaScrl:SetNotAbleMasking( true )
	radarControl.rader_Reset:SetNotAbleMasking( true )
	radarControl.rader_Close:SetNotAbleMasking( true )
	-- radarControl.rader_NpcFind_Toggle:SetNotAbleMasking( true )
	radar_MiniMapScl:SetNotAbleMasking(true)

	radarControl.rader_Plus:SetAlpha( 0.0 )
	radarControl.rader_Minus:SetAlpha( 0.0 )
	radar_SizeBtn:SetAlpha( 0.0 )
	radar_SizeSlider:SetAlpha( 0.0 )
	radarControl.rader_AlphaPlus:SetAlpha( 0.0 )
	radarControl.rader_AlphaMinus:SetAlpha( 0.0 )
	radar_AlphaBtn:SetAlpha( 0.0 )
	radar_AlphaScrl:SetAlpha( 0.0 )
	radarControl.rader_Reset:SetAlpha( 0.0 )
	radarControl.rader_Close:SetAlpha( 0.0 )
	-- radarControl.rader_NpcFind_Toggle:SetAlpha( 0.0 )
	radar_MiniMapScl:SetAlpha( 0.0 )
	radarControl.icon_SelfPlayer:SetRotate(math.pi);


	--Rader_updateWorldMap_AlphaControl( 0 )
	
	radar_AlphaScrl					:SetControlPos( ToClient_GetRaderAlpha() * 100 )
	Rader_updateWorldMap_AlphaControl_Init()
	
	radar_SizeSlider				:SetControlPos( ToClient_GetRaderScale() * 100 )
	local scaleSlideValue = 1.0 - radar_SizeSlider:GetControlPos()
	updateWorldMapDistance(scaleMinValue + scaleSlideValue * 100)
end



local weatherTooltip	= 0
local buildingTooltip	= 0
local siegeTooltip		= 0
local VillageWarTooltip	= 0
function Rader_Icon_Help_BubbleShowFunc( iconNo, isOn )
	if iconNo == 0 then
		if 0 == weatherTooltip then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TOOLTIP_WEATHER_RAIN_NAME") -- "날씨 : 비"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_REDUCED_DAMAGE_REASON_RAIN")
			uiControl = radarTime.controls.raining
		elseif 2 == weatherTooltip then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TOOLTIP_WEATHER_SNOW_NAME") -- "날씨 : 눈"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_REDUCED_DAMAGE_REASON_SNOW")
			uiControl = radarTime.controls.raining
		else
			name = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TOOLTIP_WEATHER_CLEAR_NAME") -- "날씨 : 맑음"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TOOLTIP_WEATHER_CLEAR_DESC") -- "날씨가 맑아 전투에 영향을 끼치는 요소가 없습니다."
			uiControl = radarTime.controls.raining
		end
	elseif iconNo == 1 then
		if 1 == buildingTooltip or 2 == buildingTooltip then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TOOLTIP_COMBATPOSSIBLE_NAME") -- "점령전 가능 지역"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TOOLTIP_COMBATPOSSIBLE_DESC") -- "점령전 시 PvP가 가능해지는 지역입니다."
			-- desc = PAGetString(Defines.StringSheet_GAME, "LUA_Rader_CAN_BUILD_ACROPOLIS")
			uiControl = radarTime.controls.citadel
		else
			name = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TOOLTIP_COMBATIMPOSSIBLE_NAME") -- "점령전 불가 지역"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TOOLTIP_COMBATIMPOSSIBLE_DESC") -- "점령전이 진행되지 않는 지역입니다."
			uiControl = radarTime.controls.citadel
		end
	elseif iconNo == 2 then
		if 0 == siegeTooltip then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TOOLTIP_SIEGEPOSSIBLE1_NAME") -- "성채 건설 가능 지역"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TOOLTIP_SIEGEPOSSIBLE1_DESC") -- "성채를 지을 수 있는 지역입니다."
			uiControl = radarTime.controls.siegeArea
		elseif 1 == siegeTooltip then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TOOLTIP_SIEGEPOSSIBLE2_NAME") -- "지휘소 건설 가능 지역"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TOOLTIP_SIEGEPOSSIBLE2_DESC") -- "지휘소를 지을 수 있는 지역입니다."
			uiControl = radarTime.controls.siegeArea
		else
			name = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TOOLTIP_SIEGEIMPOSSIBLE_NAME") -- "건설 불가 지역"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TOOLTIP_SIEGEIMPOSSIBLE_DESC") -- "점령전용 건물을 지을 수 없는 지역입니다."
			uiControl = radarTime.controls.siegeArea
		end
	elseif iconNo == 3 then
		if 0 == VillageWarTooltip then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TOOLTIP_VILLAGEWARABLE_NAME") -- "거점전 지역"
			if "" ~= nodeWarRegionName then
				desc = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_RADER_TOOLTIP_VILLAGEWARABLE_DESC", "nodeWarRegionName", nodeWarRegionName )
			else
				desc = ""
			end
			uiControl = radarTime.controls.VillageWar
		else
			name = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TOOLTIP_VILLAGEWARDISABLE_NAME") -- "거점전 불가 지역"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TOOLTIP_VILLAGEWARDISABLE_DESC") -- "거점전이 진행되지 않는 지역입니다."
			uiControl = radarTime.controls.VillageWar
		end
	elseif 4 == iconNo then
		local player = getSelfPlayer()
		if( nil == player ) then
			return;
		end

		local playerGet = player:get()
		local ChaTendency = playerGet:getTendency()
		
		name		= PAGetString(Defines.StringSheet_GAME, "LUA_RADER_INTO_DESERT_TITLE")
		desc		= ""

		if ChaTendency < 0 then
			desc		= PAGetString(Defines.StringSheet_GAME, "LUA_RADER_INTO_COMBATZONE_FOR_CAOTIC_DESC")
		else
			desc		= PAGetString(Defines.StringSheet_GAME, "LUA_RADER_INTO_DESERT_DESC")
		end
		uiControl	= radar_DangerIcon
	end

	if isOn == true then
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function TerrainInfo_ShowBubble(isShow)

	local terraintype = selfPlayerNaviMaterial()
	local radarControl = radarTime.controls

	if terraintype == 0 then
		textInfo = PAGetString( Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_NORMAL" )
		roadInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_NORMAL" )
	elseif terraintype == 1 then
		textInfo = PAGetString( Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_ROAD")
		roadInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_ROAD" )
	elseif terraintype == 2 then
		textInfo = PAGetString( Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_SNOW")
		roadInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_SNOW" )
	elseif terraintype == 3 then
		textInfo = PAGetString( Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_DESERT")
		roadInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_DESERT" )
	elseif terraintype == 4 then
		textInfo = PAGetString( Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_SWAMP")
		roadInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_SWAMP" )
	elseif terraintype == 5 then
		textInfo = PAGetString( Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_OBJECT")
		roadInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_OBJECT" )
	elseif terraintype == 6 then
		textInfo = PAGetString( Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_WATER")
		roadInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_WATER" )
	elseif terraintype == 7 then
		textInfo = PAGetString( Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_GRASS")
		roadInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_GRASS" )
	elseif terraintype == 8 then
		textInfo = PAGetString( Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_DEEPWATER")
		roadInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_DEEPWATER" )
	elseif terraintype == 9 then
		textInfo = PAGetString( Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_AIR")
		roadInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_AIR" )
	else
		textInfo = PAGetString( Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_NORMAL")
		roadInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_NORMAL" )
	end


	name = roadInfo
	desc = textInfo
	uiControl = radarTime.controls.terrainInfo

	if true == isShow then
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end	
end

function RadarScale_SimpleTooltips( isShow )
	local name, desc, uiControl = nil, nil, nil

	name = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TOOLTIP_RADER_MINIMAP_NAME") -- "미니맵 크기 조절"
	desc = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TOOLTIP_RADER_MINIMAP_DESC") -- "미니맵 크기를 조절할 수 있습니다. 미니맵 크기를 조절하면 해당 크기가 서버에 저장되기까지 일정시간이 소요됩니다."
	uiControl = radar_MiniMapScl

	registTooltipControl(uiControl, Panel_Tooltip_SimpleText)

	if true == isShow then
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end	
end

function RaderShowAni()
	Panel_Radar:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)

	local MainStatusOpen_Alpha = Panel_Radar:addColorAnimation( 0.0, 0.35, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	MainStatusOpen_Alpha:SetStartColor( UI_color.C_00FFFFFF )
	MainStatusOpen_Alpha:SetEndColor( UI_color.C_FFFFFFFF )
	MainStatusOpen_Alpha.IsChangeChild = true
end


function RaderHideAni()
	Panel_Radar:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	local MainStatusOpen_Alpha = Panel_Radar:addColorAnimation( 0.0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	MainStatusOpen_Alpha:SetStartColor( UI_color.C_FFFFFFFF )
	MainStatusOpen_Alpha:SetEndColor( UI_color.C_00FFFFFF )
	MainStatusOpen_Alpha.IsChangeChild = true
	MainStatusOpen_Alpha:SetHideAtEnd(true)
	MainStatusOpen_Alpha:SetDisableWhileAni(true)
end

function SortRador_IconIndex()
	-- 버튼을 퀘스트 영역보다 위로 한다.
	local mapButton = radarMap.controls
	Panel_Radar:SetChildIndex( radar_SizeSlider,						9999 )
	Panel_Radar:SetChildIndex( radar_AlphaScrl,						9999 )
	Panel_Radar:SetChildIndex( mapButton.rader_Reset,					9999 )
	Panel_Radar:SetChildIndex( radar_MiniMapScl,						9999 )
end

-- Static 을 Pool 로 관리한다. Pool 에서 꺼내오거나, Pool 이 비었으면 새로 생성한다.
function radarMap:getIdleIcon()
	local iconPool = self.iconPool
	if 0 < iconPool:length() then
		return iconPool:pop_back()
	else
		self.iconCreateCount = self.iconCreateCount + 1
		local make_Icon = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Radar, "Static_Icon_" .. self.iconCreateCount )
		return make_Icon
	end
end


-- Static 을 Pool 에 넣는다.
function radarMap:returnIconToPool( icon )
	-- UI.ASSERT( (nil ~= icon) and (icon.__name == 'PAUIPureStatic'),			'[Radar.lua] PAUIPureStatic 이 아닌데, 풀에 반납 되었다!!')		-- 서비스 버전에서는 제거해야 하는 코드입니다.!
	self.iconPool:push_back( icon )
end


function radarMap:getIdleQuest()
	local questPool = self.questIconPool
	if 0 < questPool:length() then
		return questPool:pop_back()
	else
		self.questCreateCount = self.questCreateCount + 1

		local iconQuestArea = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Radar, "Static_QuestArea_" .. self.questCreateCount )
		local iconQuestArrow = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Radar, "Static_QuestArrow_" .. self.questCreateCount )

		CopyBaseProperty( self.template.area_quest,				iconQuestArea	)
		CopyBaseProperty( self.template.area_quest_guideArrow,	iconQuestArrow	)

		iconQuestArea:SetShow( false )
		iconQuestArrow:SetShow( false )

		iconQuestArea:SetSize( self.template.area_quest:GetSizeX(), self.template.area_quest:GetSizeY() )

		iconQuestArrow:SetPosX( self.pcPosBaseControl.x - iconQuestArrow:GetSizeX() / 2 )
		iconQuestArrow:SetPosY( self.pcPosBaseControl.y - iconQuestArrow:GetSizeY() / 2 )
		iconQuestArrow:SetSize( self.template.area_quest_guideArrow:GetSizeX(), self.template.area_quest_guideArrow:GetSizeY() )
		QuestArrowHalfSize = iconQuestArrow:GetSizeY() / 2
		
		local questIcon =
		{
			icon_QuestArea = iconQuestArea,
			icon_QuestArrow = iconQuestArrow,
		}
		return questIcon
	end
end

-- Static 을 Pool 에 넣는다.
function radarMap:returnQuestToPool( questIcon )
	-- UI.ASSERT( (nil ~= quest) and (quest.__name == 'PAUIPureStatic'),			'[Radar.lua] PAUIPureStatic 이 아닌데, 풀에 반납 되었다!!')		-- 서비스 버전에서는 제거해야 하는 코드입니다.!
	self.questIconPool:push_back( questIcon )
end

---------------------------------------------------------------------------------------------------------------------
--- 패널의 드래그 설정 -------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

	-- Panel_Radar:SetDragEnable( true )

---------------------------------------------------------------------------------------------------------------------
-- 패널 및 지역명, 지역 타입, 서버시간 및 타임바 표시 관련 -------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
-- \brief 서버시간 표시/타임바 Toggle
-- function RadarTimeBar_ShowToggle( isShow )
	-- local radarTimeControl = radarTime.controls

	-- radarTimeControl.timeLine:SetShow(not isShow)
	-- radarTimeControl.timeElement:SetShow(not isShow)
	-- radarTimeControl.timeElement_right:SetShow(not isShow)
	
	
	-- if ( isShow ) then
		-- Panel_TimeBar:SetAlpha(0.0)
		-- Panel_TimeBarNumber:SetAlpha(0.0)
	-- else
		-- Panel_TimeBar:SetAlpha(1.0)
		-- Panel_TimeBarNumber:SetAlpha(1.0)
	-- end

	-- Panel_TimeBarNumber:SetPosX(Panel_TimeBar:GetPosX())
	-- Panel_TimeBarNumber:SetPosY(Panel_TimeBar:GetPosY())
	-- radarMap.controls.timeNum:SetShow(isShow)
-- end
function Panel_TimeBar_ShowToggle()
	local isShow = Panel_TimeBar:IsShow()
	if isShow then
		Panel_TimeBarNumber:SetShow( false )
		Panel_TimeBar:SetShow( false )
	else
		-- Panel_TimeBarNumber:SetShow( true )
		Panel_TimeBar:SetShow( true )
	end
end

-- \brief 지역명 갱신
function RadarMap_updateRegion(regionData)
	if nil == regionData then
		return
	end

	local radarControl = radarTime.controls

	local isArenaZone	= regionData:get():isArenaZone() 						-- 결투장
	local isSafetyZone	= regionData:get():isSafeZone()							-- 안전지역 여부 출력
	local isDesertZone	= regionData:isDesert()									-- 사막 지역

	local checkVillageWarArea = function( control, isRight )					-- 거점전 가능 여부에 따라 아이콘 변경.
		control:ChangeTextureInfoName( "New_UI_Common_forLua/Window/Guild/Guild_00.dds" )
		local x1, y1, x2, y2 = 0, 0, 0, 0
		if isRight then
			x1, y1, x2, y2 = setTextureUV_Func( control, 333, 31, 353, 51 )
			VillageWarTooltip = 0
		else
			x1, y1, x2, y2 = setTextureUV_Func( control, 354, 31, 374, 51 )
			VillageWarTooltip = 1
		end
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())
	end

	local linkedSiegeRegionInfoWrapper = ToClient_getVillageSiegeRegionInfoWrapperByPosition( getSelfPlayer():get():getPosition() );
	checkVillageWarArea( radarTime.controls.VillageWar, linkedSiegeRegionInfoWrapper:get():isVillageWarZone() )

	radar_regionName:SetFontColor( UI_color.C_FFEFEFEF )
	radar_regionName:useGlowFont( false )	-- GLOW:의뢰제목
	
	radar_regionNodeName:SetFontColor( UI_color.C_FFEFEFEF )
	radar_regionNodeName:useGlowFont( false )

	radar_regionWarName:SetFontColor( UI_color.C_FFEFEFEF )
	radar_regionWarName:useGlowFont( false )

	radar_DangerIcon:SetShow( false )

	local player = getSelfPlayer()
	if( nil == player ) then
		return;
	end

	local playerGet = player:get()
	local ChaTendency = playerGet:getTendency()

	if isSafetyZone then
		radar_regionName		:SetFontColor(4292276981)
		radar_regionName		:useGlowFont( true, "BaseFont_12_Glow", 4281961144 )	-- GLOW:의뢰제목
		radar_regionNodeName	:SetFontColor(4292276981)
		radar_regionNodeName	:useGlowFont( true, "BaseFont_8_Glow", 4281961144 )	-- GLOW:의뢰제목
		radar_regionWarName		:SetFontColor(4292276981)
		radar_regionWarName		:useGlowFont( true, "BaseFont_8_Glow", 4281961144 )	-- GLOW:의뢰제목

		if true == beforeCombatZone then	-- 이전 지역이 안전/결투 지역이었는데, 전투 지역으로 이동했으면;
			local msg = { main = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_ISSAFETYZONE_ACK_MAIN"), sub = "" } -- "안전 지역에 진입했습니다."
			Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect( msg, 6, 0)
		end
		beforSafeZone		= true
		beforeCombatZone	= false
		beforeArenaZone		= false
		beforeDesertZone	= false

	elseif isArenaZone then
		radar_regionName		:SetFontColor(4294495693)
		radar_regionName		:useGlowFont( true, "BaseFont_12_Glow", 4286580487 )	-- GLOW:의뢰제목
		radar_regionNodeName	:SetFontColor(4294495693)
		radar_regionNodeName	:useGlowFont( true, "BaseFont_8_Glow", 4286580487 )	-- GLOW:의뢰제목
		radar_regionWarName		:SetFontColor(4294495693)
		radar_regionWarName		:useGlowFont( true, "BaseFont_8_Glow", 4286580487 )	-- GLOW:의뢰제목

		beforSafeZone		= false
		beforeCombatZone	= false
		beforeArenaZone		= true
		beforeDesertZone	= false

	else
		radar_regionName		:SetFontColor(4294495693)
		radar_regionName		:useGlowFont( true, "BaseFont_12_Glow", 4286580487 )	-- GLOW:의뢰제목
		radar_regionNodeName	:SetFontColor(4294495693)
		radar_regionNodeName	:useGlowFont( true, "BaseFont_8_Glow", 4286580487 )	-- GLOW:의뢰제목
		radar_regionWarName		:SetFontColor(4294495693)
		radar_regionWarName		:useGlowFont( true, "BaseFont_8_Glow", 4286580487 )	-- GLOW:의뢰제목
		local msg = ""
		if 0 <= ChaTendency then
			if balenciaPart2 then
				if isDesertZone then
					msg = { main = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_INTO_DESERT_TITLE"), sub = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_INTO_DESERT_DESC") }
					-- "위험 지역 진입", "적대 성향 모험가에게 쉽게 공격받을 수 있으니 주의해야 합니다."
					Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect( msg, 6, 50)
					radar_DangerIcon:SetShow( true )
					Panel_Radar:SetChildIndex( radar_DangerIcon, 9999 )
				else
					msg = { main = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_ISCOMBATZONE_ACK_MAIN"), sub = "" }
					-- "전투 지역에 진입했습니다."
					Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect( msg, 6, 1)
					radar_DangerIcon:SetShow( false )
					Panel_Radar:SetChildIndex( radar_DangerIcon, 9999 )
				end
			else
				msg = { main = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_ISCOMBATZONE_ACK_MAIN"), sub = "" }
				-- "전투 지역에 진입했습니다."
				Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect( msg, 6, 1)
				radar_DangerIcon:SetShow( false )
				Panel_Radar:SetChildIndex( radar_DangerIcon, 9999 )
			end
		else
			if balenciaPart2 then
				if isDesertZone then
					msg = { main = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_ISCOMBATZONE_ACK_MAIN"), sub = "" }
					-- "전투 지역에 진입했습니다."	-- 
					Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect( msg, 6, 1)
					radar_DangerIcon:SetShow( false )
					Panel_Radar:SetChildIndex( radar_DangerIcon, 9999 )
				else
					msg = { main = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_INTO_DESERT_TITLE"), sub = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_INTO_COMBATZONE_FOR_CAOTIC_DESC") }
					-- "위험 지역 진입" , "적대 성향 모험가는 불이익이 있습니다."
					Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect( msg, 6, 1)
					radar_DangerIcon:SetShow( true )
					Panel_Radar:SetChildIndex( radar_DangerIcon, 9999 )
				end
			else
				msg = { main = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_ISCOMBATZONE_ACK_MAIN"), sub = "" }
				-- "전투 지역에 진입했습니다."
				Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect( msg, 6, 1)
				radar_DangerIcon:SetShow( false )
				Panel_Radar:SetChildIndex( radar_DangerIcon, 9999 )
			end
		end

		beforSafeZone		= not isDesertZone
		beforeCombatZone	= not isDesertZone
		beforeArenaZone		= not isDesertZone
		beforeDesertZone	= isDesertZone

		FGlobal_CheckUnderwear()
	end

	-- 미니맵에 지역 표시해주는 부분(태곤)
	local selfPlayerWrapper = getSelfPlayer()
	local selfPlayerPos = selfPlayerWrapper:get3DPos();
	local linkSiegeWrapper	= ToClient_getVillageSiegeRegionInfoWrapperByPosition( selfPlayerPos )
	nodeWarRegionName = ""
	if nil ~= linkSiegeWrapper then
		local explorationWrapper	= linkSiegeWrapper:getExplorationStaticStatusWrapper()
		local villageWarZone		= linkSiegeWrapper:get():isVillageWarZone()
		if nil ~= explorationWrapper and true == villageWarZone then
			nodeWarRegionName = explorationWrapper:getName()
	 		radar_regionName:SetText( regionData:getAreaName() )	-- 지역명 출력
	 	else
			radar_regionName:SetText( regionData:getAreaName() )	-- 지역명 출력
		end
	end

	radar_regionName:SetSize( radar_regionName:GetTextSizeX() + 40, radar_regionName:GetSizeY() + 3 )
	-- radar_regionNodeName:SetSize( radar_regionNodeName:GetTextSizeX() + 40, radar_regionNodeName:GetSizeY() + 3 )
	radar_regionName:ComputePos()
	-- radar_regionNodeName:ComputePos()
	radarMap.regionTypeValue = regionData:get():getRegionType()
end

function NodeLevelRegionNameShow( wayPointKey )
	local nodeName	= ToClient_GetNodeNameByWaypointKey ( wayPointKey )
	if "" == nodeName or nil == nodeName then
		radar_regionNodeName:SetShow( false )
	else
		radar_regionNodeName:SetShow( true )
		radar_regionNodeName:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_RADER_REGIONNODENAME", "getName", nodeName ) )
		radar_regionNodeName:SetSize( radar_regionNodeName:GetTextSizeX() + 40, radar_regionNodeName:GetSizeY() + 3 )
		radar_regionNodeName:ComputePos()
	end

	if "" == nodeWarRegionName or nil == nodeWarRegionName then
		radar_regionWarName:SetShow( false )
	else
		radar_regionWarName:SetShow( true )
		radar_regionWarName:SetText( nodeWarRegionName .. " " .. PAGetString( Defines.StringSheet_GAME, "LUA_RADER_TOOLTIP_VILLAGEWARABLE_NAME" ) )
		radar_regionWarName:SetSize( radar_regionWarName:GetTextSizeX() + 40, radar_regionWarName:GetSizeY() + 3 )
		radar_regionWarName:ComputePos()
	end
end

registerEvent( "FromClint_EventChangedExplorationNode", "NodeLevelRegionNameShow")

-- \brief 시간 갱신(매 프레임 호출된다)
local _nightCheck = 0
local _nightAlertCheck = 0
function RadarMap_UpdateTimePerFrame()
	local ingameTime = getIngameTime_variableSecondforLua()
	
	if ingameTime < 0 then
		return
	end
	
	if ( dayCycle < ingameTime ) then
		ingameTime = ingameTime % dayCycle
	end

	if ( ingameTime ~= RegionData_IngameTime ) then
		RegionData_IngameTime = ingameTime

		local minute = ( floor(ingameTime/60) % 60 )
		local hour = floor( ingameTime / 3600 )

		local calcMinute = "00"
		if minute < 10 then
			calcMinute = "0" .. minute
		else
			calcMinute = tostring(minute)
		end

		local radarControl = radarTime.controls
		if hour == 12 then
			radarControl.gameTime:SetText( 'PM ' .. tostring(hour) .. ' : ' .. calcMinute )
		elseif hour == 0 then
			local calcHour = hour + 12
			radarControl.gameTime:SetText( 'AM ' .. tostring(calcHour) .. ' : ' .. calcMinute )
		elseif hour == 24 then
			local calcHour = hour
			radarControl.gameTime:SetText( 'AM ' .. "0" .. ' : ' .. calcMinute )
		elseif hour > 11 then
			local calcHour = hour - 12
			radarControl.gameTime:SetText( 'PM ' .. tostring(calcHour) .. ' : ' .. calcMinute )
		else
			radarControl.gameTime:SetText( 'AM ' .. tostring(hour) .. ' : ' .. calcMinute )
		end
	end



	------------------------------------------------------------
	local radarTimeControl = radarTime.controls
	local realInGameTime = getIngameTime_minute()

	if ( RegionData_RealIngameTime ~= realInGameTime ) then
		if ( 24 * 60 < realInGameTime ) then
			realInGameTime = realInGameTime % (24 * 60)
		end
		local minute = floor( realInGameTime % 60 )
		local hour = floor( realInGameTime / 60 )

		if ( 22 == hour ) and ( 0 == minute / 60 ) then				-- 밤 10시가 되면
			_nightCheck = 22
			if ( _nightCheck ~= _nightAlertCheck ) then
				Night_Alert( _nightCheck )
				_nightAlertCheck = _nightCheck
			end
		end
		
		if ( 2 == hour ) and ( 0 == minute / 60 ) then				-- 새벽 2시가 되면
			_nightCheck = 2
			if ( _nightCheck ~= _nightAlertCheck ) then
				Night_Alert( _nightCheck )
				_nightAlertCheck = _nightCheck
			end
		end
		
		if hour > 21 or hour < 2 then								-- 밤 10시 ~ 7시까지(2시) 랜턴 안내
			showUseLanternToolTip( true )
		else
			showUseLanternToolTip( false )
			useLanternAlertTime = 0									-- 꺼질 시간때에 누적 타임 초기화
		end
	end
end

function showUseLanternToolTip( param )
	local itemWrapper = getEquipmentItem( 13 )
	if nil == itemWrapper and true ==  param and 100 > useLanternAlertTime then		-- 100 TimePerFrame (3~4초) 간만 보여주기
		FGlobal_ShowUseLantern(true)
		useLanternAlertTime = useLanternAlertTime+1
	else
		FGlobal_ShowUseLantern(false)
	end
end
-------------------------------------------------------------------
-- 밤 10시, 새벽 7시 메시지 세팅
-------------------------------------------------------------------
Panel_Rader_NightAlert:SetShow(false, false)
Panel_Rader_NightAlert:setMaskingChild(true)

Panel_Rader_NightAlert:RegisterShowEventFunc( true, 'Rader_NightAlert_ShowAni()' )
Panel_Rader_NightAlert:RegisterShowEventFunc( false, 'Rader_NightAlert_HideAni()' )

local Night_AlertPanel = UI.getChildControl( Panel_Rader_NightAlert, "Static_AlertPanel" )
local Night_AlertText = UI.getChildControl( Panel_Rader_NightAlert, "StaticText_Alert_NoticeText" )

function Night_Alert( _nightCheck )
	local message = ""
	local isColorBlindMode = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(CppEnums.GlobalUIOptionType.ColorBlindMode)
	--{ 색맹 모드 색상을 지정해준다.
	if (0 == isColorBlindMode) then
		Night_AlertText:SetFontColor( UI_color.C_FFFF0000 )
	elseif (1 == isColorBlindMode) then
		Night_AlertText:SetFontColor( UI_color.C_FF0096FF )
	elseif (2 == isColorBlindMode) then
		Night_AlertText:SetFontColor( UI_color.C_FF0096FF )
	end
	--}
	if ( 22 == _nightCheck ) then
		Night_AlertText:SetText( PAGetString(Defines.StringSheet_GAME, "PANEL_RADER_NIGHT_ALERT_TEXT1") ) -- 밤 10시가 되자 몬스터가 흉포해집니다. 몬스터의 공격력이 증가하지만, 획득 경험치도 늘어납니다.
	elseif ( 2 == _nightCheck ) then
		Night_AlertText:SetText( PAGetString(Defines.StringSheet_GAME, "PANEL_RADER_NIGHT_ALERT_TEXT2") ) -- 오전 7시가 되니 몬스터가 힘을 잃고 원래의 상태로 돌아갑니다.
	else
		return
	end
	Panel_Rader_NightAlert:SetShow( true, true )
	Night_AlertPanel:SetShow( true )
end

local _cumulateTime = 0
function Rader_NightAlert_Close ( fDeltaTime )
	_cumulateTime = _cumulateTime + fDeltaTime
	if _cumulateTime >= 9.0 then
		Panel_Rader_NightAlert:SetShow( false, true )
		_cumulateTime = 0
	end
end
Panel_Rader_NightAlert:RegisterUpdateFunc("Rader_NightAlert_Close")

function Rader_NightAlert_ShowAni()
	audioPostEvent_SystemUi(01,09)
	UIAni.fadeInSCR_MidOut( Panel_Rader_NightAlert )
end

function Rader_NightAlert_HideAni()
	-- 꺼준다
	Panel_Rader_NightAlert:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo6 = Panel_Rader_NightAlert:addColorAnimation( 0.0, 1.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo6:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo6:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo6.IsChangeChild = true
	aniInfo6:SetHideAtEnd(true)
	aniInfo6:SetDisableWhileAni(true)
end

---------------------------------------------------------------------------------------------------------------------
-- 레이더 및 각종 아이콘 표시 관련 ---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
-- \brief PC 정보 갱신. Ratation 변경. (매 프레임 호출된다)
local RadarMap_UpdateSelfPlayerPerFrame = function()
	local selfPlayerWrapper = getSelfPlayer()
	if nil == selfPlayerWrapper then
		return
	end
	local selfPlayer = selfPlayerWrapper:get()

	if nil == selfPlayer then
			return;
	end

	local selfPlayerIcon = radarMap.controls.icon_SelfPlayer

	if( false == radarMap.isRotateMode ) then
		selfPlayerIcon:SetRotate( getCameraRotation() )	
	else
		Panel_Radar:SetRotate( -getCameraRotation() + math.pi )
	end

--Panel_Radar:SetRotate( getCameraRotation() - 3.14159265358979323846264338327950288419716939937510 )
	-- 매 프레임 현재 위치를 갱신해준다!
	local pcInfo = radarMap.pcInfo
	local selfPlayerPos = pcInfo.position
	selfPlayerPos.x = selfPlayer:getPositionX()
	selfPlayerPos.y = selfPlayer:getPositionY()
	selfPlayerPos.z = selfPlayer:getPositionZ()

	pcInfo.s64_teamNo = selfPlayerWrapper:getTeamNo_s64()
end
-- Actor 위치를 컨트롤 위치로 변경해준다. PC 와의 Distance 를 체크해서 일정 거리 이상은 뿌리지 않도록 처리한다.
-- Panel_worldMap.lua : WorldMap_UpdateOtherActor에서 사용 ( 리소스 공유 )
local getPosBaseControl = function( actorPosition )	-- pa::float3
	local selfPlayerPos = radarMap.pcInfo.position
	local selfPlayerControlPos = radarMap.pcPosBaseControl

	local dx = (actorPosition.x - selfPlayerPos.x) / 100
	local dz = (selfPlayerPos.z - actorPosition.z) / 100		-- Z 축은 World 좌표와 Screen 좌표가 방향이 반대이다.

	local distance = sqrt( dx * dx + dz * dz )

	local dxPerPixel = dx * radarMap.worldDistanceToPixelRate + selfPlayerControlPos.x
	local dyPerPixel = dz * radarMap.worldDistanceToPixelRate + selfPlayerControlPos.y

	return (distance < radarMap.config.mapRadius), dxPerPixel, dyPerPixel
end


local getPosQuestControl = function( areaQuest )
	local selfPlayerPos = radarMap.pcInfo.position
	local selfPlayerControlPos = radarMap.pcPosBaseControl

	-- position 은 CM 단위. M 로 변환을 위해 100 을 나눈다
	local dx = (areaQuest.x - selfPlayerPos.x) / 100
	local dz = (selfPlayerPos.z - areaQuest.z) / 100		-- Z 축은 World 좌표와 Screen 좌표가 방향이 반대이다.

	local distance = sqrt( dx * dx + dz * dz )

	local dxPerPixel = dx * radarMap.worldDistanceToPixelRate * 2 + selfPlayerControlPos.x
	local dyPerPixel = dz * radarMap.worldDistanceToPixelRate * 2 + selfPlayerControlPos.y

	-- TRadius 는 cm 단위. M 로 변환을 위해, 100 으로 나눠준다.
	return (distance <= (radarMap.config.mapRadius + areaQuest.radius / 100)), dxPerPixel, dyPerPixel
end

-- 사용하지 않을 Static 을 반납하고, Actor 정보를 지운다.
local RadarMap_DestoryQuestIcons = function()
	for idx, areaQuest in pairs(radarMap.areaQuests) do
		if nil ~= areaQuest then
			-- Show 를 끄고, Pool 에 반납한다!
			areaQuest.icon_QuestArea:SetShow( false )
			areaQuest.icon_QuestArrow:SetShow( false )
			radarMap:returnQuestToPool( areaQuest )
		end
	end
	radarMap.areaQuests = {}
end

function regeistTooltipInfo( index, isArrow )
	if isArrow then
		registTooltipControl(radarMap.areaQuests[index].icon_QuestArrow, Panel_QuestInfo)
	else
		registTooltipControl(radarMap.areaQuests[index].icon_QuestArea, Panel_QuestInfo)
	end
end

function QuestTooltipForHandle( index, controlIdx, IsArrow )
	regeistTooltipInfo( controlIdx, IsArrow )
	QuestInfoData.questDescShowWindowForLeft( index )
end

function Radar_UpdateQuestList()
	RadarMap_DestoryQuestIcons()

	local questCount = questList_getCheckedProgressQuestCount()
	local controlCount = 1
	local pixelRate = radarMap.worldDistanceToPixelRate / 100 * 2;

	for index = 1, questCount do
		local progressQuest = questList_getCheckedProgressQuestAt(index-1)
		if ( nil ~= progressQuest ) then
			local questGroupId 		= progressQuest:getQuestNo()._group
			local questId 			= progressQuest:getQuestNo()._quest
			local questCondition	= 0
			if true == progressQuest:isSatisfied() then
				questCondition = 0
			else
				questCondition = 1
			end

			local positionCount 	= progressQuest:getQuestPositionCount()
			if 0 ~= positionCount and not progressQuest:isSatisfied() then
				for posIndex = 1, positionCount do
					local questPosition = progressQuest:getQuestPositionAt(posIndex-1)
					
					local areaQuest = radarMap:getIdleQuest()

					-- local isShow, posX, posY = getPosQuestControl( questPosition )
					areaQuest.index = index - 1

					areaQuest.icon_QuestArea:addInputEvent("Mouse_On",	"QuestTooltipForHandle(" ..(index-1)..", "..controlCount..", false)")
					areaQuest.icon_QuestArea:addInputEvent("Mouse_Out",	"QuestInfoData.questDescHideWindow()")
					areaQuest.icon_QuestArea:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_FindTarget(" ..questGroupId..", "..questId..", " .. questCondition .. ", false)" )
					areaQuest.icon_QuestArea:setTooltipEventRegistFunc("QuestTooltipForHandle(" ..(index-1)..", "..controlCount..", false)")
					
					areaQuest.icon_QuestArrow:addInputEvent("Mouse_On",	"QuestTooltipForHandle(" ..(index-1)..", "..controlCount..", true)")					
					areaQuest.icon_QuestArrow:addInputEvent("Mouse_Out","QuestInfoData.questDescHideWindow()")
					areaQuest.icon_QuestArrow:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_FindTarget(" ..questGroupId..", "..questId..", " .. questCondition .. ", false)" )
					areaQuest.icon_QuestArrow:setTooltipEventRegistFunc("QuestTooltipForHandle(" ..(index-1)..", "..controlCount..", false)")
					
					areaQuest.x = questPosition._position.x
					areaQuest.y = questPosition._position.y
					areaQuest.z = questPosition._position.z		-- WorldPos 에서 Z 임.
					areaQuest.radius = questPosition._radius
					-- 반지름이라 * 2	
					local size = floor(pixelRate * areaQuest.radius) * 2
					areaQuest.icon_QuestArea:SetSize( size, size )
					areaQuest.icon_QuestArea:SetParentRotCalc(radarMap.isRotateMode)
--					areaQuest.icon_QuestArea:SetEnableArea( questPosition._position.x, questPosition._position.y,
--					questPosition._position.x + size, questPosition._position.y + size )

					radarMap.areaQuests[controlCount] = areaQuest
					controlCount = controlCount + 1
				end
			end
		end
	end
	
	for idx, areaQuest in pairs(radarMap.areaQuests) do
		if nil ~= areaQuest then			
			Panel_Radar:SetChildIndex( areaQuest.icon_QuestArrow,	9998 )
		end
	end	
	
	for actorKeyRaw,_ in pairs(radarMap.actorIcons) do
		RadarMap_DestoryOtherActor( actorKeyRaw )
	end
end

RadarMap_UpdatePixelRate = function()
	for _,areaQuest in pairs(radarMap.areaQuests) do

		local size = floor(radarMap.worldDistanceToPixelRate * areaQuest.radius / 100 * 2)
		areaQuest.icon_QuestArea:SetSize( size, size )
	end
end

local RadarMap_UpdateQuestAreaPositionPerFrame = function()
	local self = radarMap
	local enableHalfSize = 12
	local sizeX = Panel_Radar:GetSizeX()
	local sizeY = Panel_Radar:GetSizeY() * 0.9
	local camRot = getCameraRotation();
	local halfSizeX = Panel_Radar:GetSizeX() * 0.5
	local halfSizeY = Panel_Radar:GetSizeY() * 0.5
	local radarPosX = Panel_Radar:GetPosX();
	local radarPosY = Panel_Radar:GetPosY();
	local selfPlayerControlPos = radarMap.pcPosBaseControl

	local selfPlayerControlPos = radarMap.pcPosBaseControl
	for _,areaQuest in pairs(self.areaQuests) do
		local questAreaIcon = areaQuest.icon_QuestArea
		local questArrowIcon = areaQuest.icon_QuestArrow

		local isShow, posX, posY = getPosQuestControl( areaQuest )
		if isShow then
			-- AreaIcon	
			
			local areaSize = questAreaIcon:GetSizeX()
			local areaHalfSize = areaSize * 0.5 
			local dist =  posX - selfPlayerControlPos.x;
			local disty = posY - selfPlayerControlPos.y;
			local tempPos = float2( dist, disty );
			tempPos:rotate( camRot + math.pi );

			posX = posX - floor(areaHalfSize)
			posY = posY - floor(areaHalfSize)

			questAreaIcon:SetPosX( posX )
			questAreaIcon:SetPosY( posY )
			
			questAreaIcon:SetEnableArea(tempPos.x-dist, tempPos.y-disty,
										tempPos.x-dist+areaSize, tempPos.y-disty+areaSize);
--			questAreaIcon:SetScale( radarMap.worldDistanceToPixelRate * 2,
--									radarMap.worldDistanceToPixelRate * 2)
			--클리핑 영역 설정[최대호]
			
			questAreaIcon:SetRectClip( float2( -posX, -posY ),
									float2( Panel_Radar:GetPosX() + sizeX - questAreaIcon:GetParentPosX(),
									Panel_Radar:GetPosY() + sizeY - questAreaIcon:GetPosY() ) )
		else
			-- ArrowIcon			
			questArrowIcon:SetPosX((Panel_Radar:GetSizeX() - questArrowIcon:GetSizeX()) / 2)
			questArrowIcon:SetPosY((Panel_Radar:GetSizeY() - questArrowIcon:GetSizeY()) / 2)
			local dx = self.pcInfo.position.x - areaQuest.x
			local dy = self.pcInfo.position.z - areaQuest.z
			local radian = math.atan2( dx, dy )

			local arrowIconRotate = radian;
			local arrowCalcRotate = -radian;
		
			if( radarMap.isRotateMode ) then
				arrowIconRotate = radian - camRot + math.pi;
				arrowCalcRotate = -radian - camRot + math.pi;
			end
			questArrowIcon:SetRotate( arrowIconRotate )
			--questArrowIcon:SetParentRotCalc(true)
			questAreaIcon:SetParentRotCalc(radarMap.isRotateMode)


			local tempPos = float2(0.0, QuestArrowHalfSize)
			tempPos:rotate(arrowCalcRotate)	
			
			questArrowIcon:SetEnableArea(QuestArrowHalfSize+tempPos.x-enableHalfSize, QuestArrowHalfSize+tempPos.y-enableHalfSize, QuestArrowHalfSize+tempPos.x+enableHalfSize, QuestArrowHalfSize+tempPos.y+enableHalfSize );
			
		end
		
		local sizeX = Panel_Radar:GetSizeX()/2
		local sizeY = Panel_Radar:GetSizeY()/2
		local centerPosX = Panel_Radar:GetPosX() + sizeX - 5
		local centerPosY = Panel_Radar:GetPosY() + sizeY + 15
		local dx = getMousePosX() - centerPosX
		local dy = getMousePosY() - centerPosY	

		local distance = sqrt( dx * dx + dy * dy )
		
		if distance < sizeX then
			questAreaIcon:SetIgnore( false )
			if isQuestDescShow then
				Panel_QuestInfo:SetShow( true, true )
			end
		else 
			questAreaIcon:SetIgnore( true )
			--Panel_QuestInfo:SetShow( false, true )
		end

		-- UI.debugMessage( tostring(isShow) .. posX .. '/' .. posY .. '/' .. questAreaIcon:GetSizeX() .. '/' .. questAreaIcon:GetSizeX() )
		questAreaIcon:SetShow( isShow )

		questArrowIcon:SetShow( false )
		if( not isShow ) then
			local pos = float3( self.pcInfo.position.x, self.pcInfo.position.y, self.pcInfo.position.z );
			if( true == ToClient_IsViewSelfPlayer( pos ) ) then
				questArrowIcon:SetShow( not isShow )
			end
		end
	end
end

-- 사용하지 않을 Static 을 반납하고, Actor 정보를 지운다.
function RadarMap_DestoryOtherActor( actorKeyRaw )
	local actorIcon = radarMap.actorIcons[actorKeyRaw]
	if nil ~= actorIcon then
		-- Show 를 끄고, Pool 에 반납한다!
		actorIcon:SetShow( false )
		radarMap:returnIconToPool( actorIcon )
		radarMap.actorIcons[actorKeyRaw] = nil
	end
end

function Rader_ChangeTexture_On()
	-- _close_Rader:SetShow(true)
	-- 드래그 상태로 바꾼다 (마우스가 올라가 있을 때)
	raderText:SetText(PAGetString( Defines.StringSheet_GAME, "PANEL_RADER_RADER" ) .. "-" ..PAGetString( Defines.StringSheet_GAME, "PANEL_RADER_MOVE_DRAG" ))		--"레이더 - 드래그해서 옮기세요."
end

function Rader_ChangeTexture_Off()
	-- _close_Rader:SetShow(false)
	-- 드래그 상태지만 마우스가 올라가지 않았을 때 - isWidget 상태
		
	raderText:SetText(PAGetString( Defines.StringSheet_GAME, "PANEL_RADER_RADER" ))	--"레이더"
	-- Panel_TimeBarNumber:SetPosX(Panel_TimeBar:GetPosX())
	-- Panel_TimeBarNumber:SetPosY(Panel_TimeBar:GetPosY())
end

function Panel_Radar_ShowToggle()
	local isShow = Panel_Radar:IsShow()
	if isShow then
		Panel_Radar:SetShow( false )
		RaderBackground_Hide()
	else
		Panel_Radar:SetShow( true )
		RaderBackground_Show()
	end
	
	-- widgetControlButtonFunction(8)
end

function RadarMap_UpdateTerrainInfo()
	local terraintype = selfPlayerNaviMaterial()
	local radarControl = radarTime.controls.terrainInfo
	radarControl:ChangeTextureInfoName( "new_ui_common_forlua/default/default_etc_01.dds" )
	local x1, y1, x2, y2 = 0, 0, 0, 0

	if terraintype == 0 then
		x1, y1, x2, y2 = setTextureUV_Func( radarControl, 73, 170, 93, 190 )
		textInfo = PAGetString( Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_NORMAL" )
		-- radarControl.terrainInfo:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_NORMAL" ))
	elseif terraintype == 1 then
		x1, y1, x2, y2 = setTextureUV_Func( radarControl, 52, 170, 72, 190 )
		textInfo = PAGetString( Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_ROAD")
		-- radarControl.terrainInfo:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_ROAD" ))
	elseif terraintype == 2 then
		x1, y1, x2, y2 = setTextureUV_Func( radarControl, 108, 177, 128, 197 )
		textInfo = PAGetString( Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_SNOW")
		-- radarControl.terrainInfo:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_SNOW" ))
	elseif terraintype == 3 then
		x1, y1, x2, y2 = setTextureUV_Func( radarControl, 129, 177, 149, 197 )
		textInfo = PAGetString( Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_DESERT")
		-- radarControl.terrainInfo:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_DESERT" ))
	elseif terraintype == 4 then
		x1, y1, x2, y2 = setTextureUV_Func( radarControl, 150, 177, 170, 197 )
		textInfo = PAGetString( Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_SWAMP")
		-- radarControl.terrainInfo:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_SWAMP" ))
	elseif terraintype == 5 then
		x1, y1, x2, y2 = setTextureUV_Func( radarControl, 73, 170, 93, 190 )
		textInfo = PAGetString( Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_OBJECT")
		-- radarControl.terrainInfo:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_OBJECT" ))
	elseif terraintype == 6 then
		x1, y1, x2, y2 = setTextureUV_Func( radarControl, 171, 177, 191, 197 )
		textInfo = PAGetString( Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_WATER")
		-- radarControl.terrainInfo:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_WATER" ))
	elseif terraintype == 7 then
		x1, y1, x2, y2 = setTextureUV_Func( radarControl, 73, 170, 93, 190 )
		textInfo = PAGetString( Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_GRASS")
		-- radarControl.terrainInfo:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_GRASS" ))
	elseif terraintype == 8 then
		x1, y1, x2, y2 = setTextureUV_Func( radarControl, 171, 156, 191, 176 )
		textInfo = PAGetString( Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_DEEPWATER")
		-- radarControl.terrainInfo:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_DEEPWATER" ))
	elseif terraintype == 9 then
		x1, y1, x2, y2 = setTextureUV_Func( radarControl, 171, 135, 191, 155 )
		textInfo = PAGetString( Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_AIR")
		-- radarControl.terrainInfo:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_AIR" ))
	else
		x1, y1, x2, y2 = setTextureUV_Func( radarControl, 73, 170, 93, 190 )
		textInfo = PAGetString( Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_NORMAL")
		-- radarControl.terrainInfo:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_NORMAL" ))
	end

	radarControl:getBaseTexture():setUV(  x1, y1, x2, y2  )
	radarControl:setRenderTexture(radarControl:getBaseTexture())
end

local _isSiegeArea = false
local buildingType = ""
function RadarMap_UpdatePosition()
	if( false == Panel_TimeBar:GetShow() ) then
		return;
	end

	local radarTimeControl = radarTime.controls
	-- local posX = radarTimeControl.gameTime:GetPosX() - radarTimeControl.gameTime:GetTextSizeX() - gapX - radarTimeControl.regionName:GetTextSizeX()
	local gapX = 15
	local regionNameSpanY = 0

	local posX = radarTimeControl.gameTime:GetTextSizeX() + gapX	-- 시간 표시
	radarTimeControl.channelName:SetSpanSize(posX - 3, regionNameSpanY )	-- 채널이름 표시

	posX = posX + radarTimeControl.channelName:GetTextSizeX()
	radarTimeControl.serverName:SetSpanSize(posX, regionNameSpanY )	-- 서버 이름 표시

	-- posX = posX + gapX + radarTimeControl.serverName:GetTextSizeX()
	-- radarTimeControl.regionName:SetSpanSize(posX, regionNameSpanY)	-- 지역 이름 표시

	-- posX = posX + gapX + radarTimeControl.regionName:GetTextSizeX()
	-- radarTimeControl.regionType:SetSpanSize(posX, regionNameSpanY)	-- 안전 지역 표시
	
	-- posX = posX + gapX + radarTimeControl.serverName:GetTextSizeX()
	-- radarTimeControl.terrainInfo:SetSpanSize(posX, regionNameSpanY + 1)	-- 거친 노면 표시
	radarTimeControl.terrainInfo:ComputePos()
	
	posX = radarTimeControl.terrainInfo:GetSizeX() + 5
	local iconSize = 20
	------------------------------------
	--		비를 맞고 있는 경우 비 아이콘 아니면 해 아이콘
	radarTimeControl.raining:ChangeTextureInfoName( "new_ui_common_forlua/widget/rader/minimap_00.dds" )
	local x1, y1, x2, y2 = 0, 0, 0, 0
	-- _PA_LOG("김창욱", "강수량:" ..tostring(getWeatherInfoBySelfPos(CppEnums.WEATHER_SYSTEM_FACTOR_TYPE.eWSFT_RAIN_AMOUNT)))
	-- _PA_LOG("김창욱", "기온:" .. tostring(getWeatherInfoBySelfPos(CppEnums.WEATHER_SYSTEM_FACTOR_TYPE.eWSFT_CELSIUS)))
	if ( 0 < getWeatherInfoBySelfPos(CppEnums.WEATHER_SYSTEM_FACTOR_TYPE.eWSFT_RAIN_AMOUNT) ) then
		if ( getWeatherInfoBySelfPos(CppEnums.WEATHER_SYSTEM_FACTOR_TYPE.eWSFT_CELSIUS) < 0 ) then
			weatherTooltip = 2
			x1, y1, x2, y2 = setTextureUV_Func( radarTimeControl.raining, 78, 223, 98, 243 )
		else
			weatherTooltip = 0
			x1, y1, x2, y2 = setTextureUV_Func( radarTimeControl.raining, 43, 133, 62, 152 )
		end
	else
		weatherTooltip = 1
		x1, y1, x2, y2 = setTextureUV_Func( radarTimeControl.raining, 171, 187, 188, 205 )
	end
	radarTimeControl.raining:getBaseTexture():setUV(  x1, y1, x2, y2  )
	radarTimeControl.raining:setRenderTexture(radarTimeControl.raining:getBaseTexture())


	radarTimeControl.raining:SetShow(true)
	radarTimeControl.raining:SetSpanSize(posX, regionNameSpanY + 1)
	posX = posX + iconSize
	
	radarTimeControl.VillageWar:SetShow( true )	-- 세력전 아이콘
	radarTimeControl.VillageWar:SetSpanSize(posX, regionNameSpanY + 1)
	posX = posX + iconSize


	---------------------------------------------
	--		성채가 설치 가능한 지역일 경우
	radarTimeControl.citadel:ChangeTextureInfoName( "new_ui_common_forlua/window/guild/guild_00.dds" )
	local x1, y1, x2, y2 = 0, 0, 0, 0
	if (UI_RT.eRegionType_Fortress == radarMap.regionTypeValue) then	-- 성채
		buildingTooltip = 1
		x1, y1, x2, y2 = setTextureUV_Func( radarTimeControl.siegeArea, 291, 31, 311, 51 )
	elseif (UI_RT.eRegionType_Siege == radarMap.regionTypeValue) then	-- 지휘소
		buildingTooltip = 2
		x1, y1, x2, y2 = setTextureUV_Func( radarTimeControl.siegeArea, 291, 31, 311, 51 )
	else	-- 건설 불가
		buildingTooltip = 0
		x1, y1, x2, y2 = setTextureUV_Func( radarTimeControl.siegeArea, 312, 31, 332, 51 )
	end
	radarTimeControl.citadel:getBaseTexture():setUV(  x1, y1, x2, y2  )
	radarTimeControl.citadel:setRenderTexture(radarTimeControl.citadel:getBaseTexture())
	
	radarTimeControl.citadel:SetShow(true)
	radarTimeControl.citadel:SetSpanSize(posX, regionNameSpanY + 1)
	posX = posX + iconSize
	
	-- 성채/지휘소 건설 가능 지역인지 체크해서 빅나크 띄움 / 아이콘 체인지
	local CheckSiegeArea = function( installType )
		local x1, y1, x2, y2 = 0, 0, 0, 0
		local radarTimeControl = radarTime.controls
		radarTimeControl.siegeArea:ChangeTextureInfoName( "new_ui_common_forlua/window/guild/guild_00.dds" )

		-- 길마 또는 부길마만 메시지 표시
		local isGuildMaster		= getSelfPlayer():get():isGuildMaster()
		local isGuildSubMaster	= getSelfPlayer():get():isGuildSubMaster()
		
		if ( UI_RT.eRegionType_Fortress == installType ) and ( true == selfPlayerCurrentSiegeCanInstall()) then
			buildingType = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_BULDINGTYPE_FORTRESS") -- "성채"
			if false == _isSiegeArea then
				_isSiegeArea = true
				local msg = { main = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_RADER_BULDIN_POSSIBLE", "buildingType", buildingType ), sub = "" }
				if true == isGuildMaster or true == isGuildSubMaster then
					Proc_ShowMessage_Ack_For_RewardSelect( msg, 2.3, 20 )				-- 성채/지휘소 건설 가능 지역
				end
			end
			x1, y1, x2, y2 = setTextureUV_Func( radarTimeControl.citadel, 166, 1, 186, 21 )
			siegeTooltip = 0
		elseif ( UI_RT.eRegionType_Siege == installType ) and ( true == selfPlayerCurrentSiegeCanInstall()) then
			buildingType = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_BULDINGTYPE_SIEGE") -- "지휘소"
			if false == _isSiegeArea then
				_isSiegeArea = true
				local msg = { main = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_RADER_BULDIN_POSSIBLE", "buildingType", buildingType ), sub = "" } -- buildingType .. " 건설 가능 지역에 진입했습니다."
				if true == isGuildMaster or true == isGuildSubMaster then
					Proc_ShowMessage_Ack_For_RewardSelect( msg, 2.3, 20 )				-- 성채/지휘소 건설 가능 지역
				end
			end
			x1, y1, x2, y2 = setTextureUV_Func( radarTimeControl.citadel, 187, 1, 207, 21 )
			siegeTooltip = 1
		else
			if true == _isSiegeArea then
				_isSiegeArea = false
				local msg = { main = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_RADER_BULDIN_IMPOSSIBLE", "buildingType", buildingType ), sub = "" } -- buildingType .. " 건설 가능 지역에서 벗어났습니다."
				if true == isGuildMaster or true == isGuildSubMaster then
					Proc_ShowMessage_Ack_For_RewardSelect( msg, 2.3, 21 )				-- 성채/지휘소 건설 가능 지역 이탈
				end
			end
			x1, y1, x2, y2 = setTextureUV_Func( radarTimeControl.citadel, 249, 31, 269, 51 )
			siegeTooltip = 2
		end
		
		radarTimeControl.siegeArea:getBaseTexture():setUV(  x1, y1, x2, y2  )
		radarTimeControl.siegeArea:setRenderTexture(radarTimeControl.siegeArea:getBaseTexture())

		radarTimeControl.siegeArea:SetShow(true)
		radarTimeControl.siegeArea:SetSpanSize(posX, regionNameSpanY + 1)
	end
	
	radarTimeControl.commandCenter:SetShow(false)	-- 사용하지 않음!
	
	CheckSiegeArea( radarMap.regionTypeValue )

	Panel_TimeBar:SetSize( 295, 22 )
	Panel_TimeBar:ComputePos()

	radarTimeControl.gameTime:ComputePos()
	radarTimeControl.channelName:ComputePos()
	radarTimeControl.serverName:ComputePos()
	radarTimeControl.terrainInfo:ComputePos()
	radarTimeControl.raining:ComputePos()
	radarTimeControl.citadel:ComputePos()
	radarTimeControl.citadel:SetShow( false )		-- 의미가 없어져 꺼준다!!
	-- radarTimeControl.siegeArea:ComputePos()
	radarTimeControl.siegeArea:SetPosX( radarTimeControl.citadel:GetPosX() )
	radarTimeControl.VillageWar:ComputePos()
	radarTimeControl.commandCenter:ComputePos()

	radar_regionName:ComputePos()
	radar_regionNodeName:ComputePos()
	-- radarTimeControl.regionType:ComputePos()

	---------------------------------------------------
	-- radarTimeControl.regionName:SetSpanSize( 120, 35 )	-- 지역 이름 표시
	-- radarTimeControl.regionName:ComputePos()
end
RadarMap_UpdatePosition()		-- 미니맵이 꺼진 상태면 포지션 업데이트가 불가능하므로, 로딩 시 한 번 돌려준다!

function RadarMap_MouseOnOffAnimation(deltaTime)	
	local isUiMode = (CppEnums.EProcessorInputMode.eProcessorInputMode_UiMode == getInputMode() or CppEnums.EProcessorInputMode.eProcessorInputMode_ChattingInputMode == getInputMode());

	local IsMouseOver = 	Panel_Radar:GetPosX() - 20 < getMousePosX() and getMousePosX() < Panel_Radar:GetPosX() + Panel_Radar:GetSizeX() + 20 and
							Panel_Radar:GetPosY() - 20 < getMousePosY() and getMousePosY() < Panel_Radar:GetPosY() + Panel_Radar:GetSizeY() + 20;

	if IsMouseOver and isUiMode then
		simpleUIAlpha = 1.0;
	else
		simpleUIAlpha = 0.0;
	end
	
	UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.timeNum, 						5 * deltaTime);
	UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.rader_Plus, 					5 * deltaTime);
	UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.rader_Minus, 					5 * deltaTime);
	UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.rader_AlphaPlus, 				5 * deltaTime);
	UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.rader_AlphaMinus, 			5 * deltaTime);
	UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.rader_Reset, 					5 * deltaTime);
	-- UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.rader_NpcFind_Toggle, 		5 * deltaTime);

	UIAni.perFrameAlphaAnimation(simpleUIAlpha, radar_SizeSlider,								5 * deltaTime);
	UIAni.perFrameAlphaAnimation(simpleUIAlpha, radar_SizeBtn, 									5 * deltaTime);
	UIAni.perFrameAlphaAnimation(simpleUIAlpha, radar_AlphaScrl,								5 * deltaTime);
	UIAni.perFrameAlphaAnimation(simpleUIAlpha, radar_AlphaBtn, 								5 * deltaTime);
	UIAni.perFrameAlphaAnimation(simpleUIAlpha, radar_MiniMapScl, 								5 * deltaTime);
end

-- 파티멤버 애로우 표시용
local iconPartyMemberArrow = {}
local partyMemberArrowIcon = function( index, isShow )
	if nil == iconPartyMemberArrow[index] then
		iconPartyMemberArrow[index] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Radar, "Static_PartyMemberArrow_" .. index )
		CopyBaseProperty( radarMap.template.area_quest_guideArrow,	iconPartyMemberArrow[index] )
		iconPartyMemberArrow[index]:SetColor(Defines.Color.C_FF00C0D7)
		iconPartyMemberArrow[index]:SetEnable( true )
		Panel_Radar:SetChildIndex( iconPartyMemberArrow[index],	9999 )
	end
	
	iconPartyMemberArrow[index]:SetShow( isShow )
	if true == isShow then
		iconPartyMemberArrow[index]:SetPosX( radarMap.pcPosBaseControl.x - iconPartyMemberArrow[index]:GetSizeX() / 2 )
		iconPartyMemberArrow[index]:SetPosY( radarMap.pcPosBaseControl.y - iconPartyMemberArrow[index]:GetSizeY() / 2 )
		iconPartyMemberArrow[index]:SetSize( radarMap.template.area_quest_guideArrow:GetSizeX(), radarMap.template.area_quest_guideArrow:GetSizeY() )

		local memberData = RequestParty_getPartyMemberAt( index )
		local dx = radarMap.pcInfo.position.x - memberData:getPositionX()
		local dy = radarMap.pcInfo.position.z - memberData:getPositionZ()
		local radian = math.atan2( dx, dy )
		iconPartyMemberArrow[index]:SetRotate( radian )	
	end
	Panel_Radar:SetChildIndex(iconPartyMemberArrow[index], 9999 )
end

local partyMemberIconPerFrame = function()
	local partyMemberCount = FGlobal_PartyMemberCount()
	if 0 >= partyMemberCount or false == Panel_Party:GetShow() then
		for i = 0, 4 do
			partyMemberArrowIcon( i, false )
		end
		return
	end
	for index = 0, partyMemberCount - 1 do
		local memberData = RequestParty_getPartyMemberAt( index )
		if nil ~= memberData then
			local isNearPartyMember = getPlayerActor( memberData:getActorKey() )
			if ( nil == isNearPartyMember ) then
				partyMemberArrowIcon( index, true )
			else
				partyMemberArrowIcon( index, false )
			end
		end
	end
end

local getPosBaseControl2 = function( actorPosition )	-- pa::float3
	local selfPlayerPos = radarMap.pcInfo.position
	local selfPlayerControlPos = radarMap.pcPosBaseControl

	local dx = (actorPosition.x - selfPlayerPos.x) / 100
	local dz = (selfPlayerPos.z - actorPosition.z) / 100		-- Z 축은 World 좌표와 Screen 좌표가 방향이 반대이다.

	local distance = sqrt( dx * dx + dz * dz ) * 2

	local dxPerPixel = dx * radarMap.worldDistanceToPixelRate * 2 + selfPlayerControlPos.x
	local dyPerPixel = dz * radarMap.worldDistanceToPixelRate * 2 + selfPlayerControlPos.y

	return (distance < radarMap.config.mapRadius), dxPerPixel, dyPerPixel
end

function RadarMap_UpdateSelfPlayerNavigationGuide()
	
	local color			= float4(1.0, 0.8, 0.6, 1.0);
	local colorBG		= float4(0.6, 0.2, 0.2, 0.3);
	
	--local lerpFactor	= math.sin( getTickCount32() / 1000.0 * math.pi * 2.0 ) * 0.5 + 0.5;
	--color.x = Util.Math.Lerp(color.x, 1.0, lerpFactor);
	--color.y = Util.Math.Lerp(color.y, 1.0, lerpFactor);
	--color.z = Util.Math.Lerp(color.z, 1.0, lerpFactor);
	--
	--colorBG.x = Util.Math.Lerp(colorBG.x, 1.0, lerpFactor);
	--colorBG.y = Util.Math.Lerp(colorBG.y, 1.0, lerpFactor);
	--colorBG.z = Util.Math.Lerp(colorBG.z, 1.0, lerpFactor);


	radarMap.controls.rader_Background:ClearShowAALineList();
	local pathSize = ToClient_getRenderPathSize();
	
	--local prePosX, prePosY;
	for ii = 0, pathSize-1, 1 do
		local pathPosition = ToClient_getRenderPathByIndex(ii);
		
		local isShow, posX, posY = getPosBaseControl2(pathPosition);
		--if (isShow) then
		--	prePosX = posX;
		--	prePosY = posY;
			radarMap.controls.rader_Background:AddShowAALineList( float3(posX, posY, 0.0) );
		--else
		--	break;
		--end
	end
	radarMap.controls.rader_Background:SetColorShowAALineList( color );
	radarMap.controls.rader_Background:SetBGColorShowAALineList( colorBG );
end

-- 매 프레임 호출되는 함수 PAUIPanel:Update
local whaleTimeCheck = 0
local alchemyStoneTimeCheck = 0
local chattingAlertTimeCheck = 60
local strongMonsterCheckDistance = 3500
function RadarMap_UpdatePerFrame(deltaTime)
	--local profile1 = startProfileLog("RadarMap_UpdateTimePerFrame()");
	RadarMap_UpdateTimePerFrame()	
	--endProfileLog( profile1 );
	-------------------------------------------------------------------
	--local profile2 = startProfileLog("RadarMap_UpdateSelfPlayerPerFrame()");
	RadarMap_UpdateSelfPlayerPerFrame()
	--endProfileLog( profile2 );
	
	-------------------------------------------------------------------
	--local profile3 = startProfileLog("RadarMap_UpdateSelfPlayerNavigationGuide()");
	RadarMap_UpdateSelfPlayerNavigationGuide();
	--endProfileLog( profile3 );

	-------------------------------------------------------------------
	--local profile4 = startProfileLog("RadarMap_UpdateQuestAreaPositionPerFrame()");
	RadarMap_UpdateQuestAreaPositionPerFrame()
	--endProfileLog( profile4 );
	-------------------------------------------------------------------
	--local profile5 = startProfileLog("RadarMap_UpdateTerrainInfo()");
	RadarMap_UpdateTerrainInfo()	
	--endProfileLog( profile5 );
	-------------------------------------------------------------------
	--local profile6 = startProfileLog("RadarMap_UpdatePosition()");
	RadarMap_UpdatePosition()
	--endProfileLog( profile6 );
	-------------------------------------------------------------------
	--local profile7 = startProfileLog("RadarMap_MouseOnOffAnimation()");
	RadarMap_MouseOnOffAnimation(deltaTime)
	--endProfileLog( profile7 );
	-------------------------------------------------------------------
	--local profile8 = startProfileLog("RadarMap_UpdatePerFrame()");	
	
	local SPI = radarMap.controls.icon_SelfPlayer
	
	local halfSelfSizeX = SPI:GetSizeX() / 2
	local halfSelfSizeY = SPI:GetSizeY() / 2
	
	local halfSizeX = Panel_Radar:GetSizeX() / 2
	local halfSizeY = Panel_Radar:GetSizeY() / 2	
	
	SPI:SetPosX( (halfSizeX - halfSelfSizeX) )
	SPI:SetPosY( (halfSizeY - halfSelfSizeY) )
	
	radarMap.pcPosBaseControl.x = SPI:GetPosX() + halfSelfSizeX
	radarMap.pcPosBaseControl.y = SPI:GetPosY() + halfSelfSizeY	
	
	ToClient_setRadorUICenterPosition( int2(radarMap.pcPosBaseControl.x, radarMap.pcPosBaseControl.y) )
	ToClient_SetRadarCenterPos(float2( radarMap.pcPosBaseControl.x,	radarMap.pcPosBaseControl.y))
	--[[test
	local selfPlayerWrapper = getSelfPlayer()
	local selfPlayer = selfPlayerWrapper:get()
	
	local icoposX = radarMap.controls.icon_SelfPlayer:GetPosX() + radarMap.controls.icon_SelfPlayer:GetSizeX() /2
	local icoposY = radarMap.controls.icon_SelfPlayer:GetPosY() + radarMap.controls.icon_SelfPlayer:GetSizeY() / 2
	
	local posX = (pinX - selfPlayer:getPositionX()) / 100
	local posZ = (selfPlayer:getPositionZ() - pinZ) / 100

	_PA_LOG("최대호", tostring(pinZ/100) )
	_PA_LOG("최대호", tostring(selfPlayer:getPositionZ()/100) )
	_PA_LOG("최대호", tostring(posZ) )
	
	radarMap.template.icon_PIN_PartyMine:SetPosX( icoposX + posX )
	radarMap.template.icon_PIN_PartyMine:SetPosY( icoposY + posZ )]]--
	--endProfileLog( profile8 );	
	-------------------------------------------------------------------
	--local profile9 = startProfileLog("FGlobal_UpdateRadarPin()");
	FGlobal_UpdateRadarPin()
	--endProfileLog( profile9 );
	-------------------------------------------------------------------
	--local profile10 = startProfileLog("RaderBackground_updatePerFrame()");
	RaderBackground_updatePerFrame(deltaTime)
	--endProfileLog( profile10 );

	GameTips_MessageUpdate( deltaTime )
	
	-- 파티원 애로우 아이콘 위치 갱신용
	partyMemberIconPerFrame()
	
	-- 고래 체크용(10초에 한 번만 체크) / 점령전 메시지도 체크
	whaleTimeCheck = whaleTimeCheck + deltaTime
	if 10 < whaleTimeCheck then
		whaleTimeCheck = 0
		FGlobal_WhaleConditionCheck()
		FGlobal_TerritoryWar_Caution()
	end
	
	-- 연금석 자동 사용 체크용(185초마다 체크)
	local cooltime = FGlobal_AlchemyStonCheck()
	if 0 < cooltime then
		if 0 == alchemyStoneTimeCheck then
			FGlobal_AlchemyStone_Use()
		end
		alchemyStoneTimeCheck = alchemyStoneTimeCheck + deltaTime
		if cooltime < alchemyStoneTimeCheck then
			alchemyStoneTimeCheck = 0
		end
	else
		alchemyStoneTimeCheck = 0
	end
	
	-- 주변에 강한 몬스터가 있는지 체크!
	if not isNearMonsterAlert() then
		StrongMonsterByNear(deltaTime)
		if FromClient_DetectsOfStrongMonster( strongMonsterCheckDistance ) then
			chattingAlertTimeCheck = chattingAlertTimeCheck + deltaTime
			if 60 < chattingAlertTimeCheck then
				chattingAlertTimeCheck = 0
				chatting_sendMessage( "", PAGetString(Defines.StringSheet_GAME, "LUA_RADER_NEARMONSTER_CHATALERT"), CppEnums.ChatType.System )		-- "몬스터와의 레벨 차이가 커 제대로 싸울 수 없습니다. 좀 더 강해진 다음에 도전하세요."
			end
		end
	else
		redar_DangerAletText:SetShow( false )
		radar_DangetAlertBg:SetShow( false )
	end
end

function FGlobal_ChattingAlert_Call()
	
end

local textAniTime = 0
local isAnimation = false
function StrongMonsterByNear(deltaTime)
	textAniTime = textAniTime + deltaTime
	
	if FromClient_DetectsOfStrongMonster( strongMonsterCheckDistance ) then
		if textAniTime < 2 and false == isAnimation then
			redar_DangerAletText:SetShow( true )
			local aniInfo = UIAni.AlphaAnimation( 1.0, redar_DangerAletText, 0.0, 0.4 )
			isAnimation = true
		elseif 2 < textAniTime and textAniTime < 5 and isAnimation then
			local aniInfo = UIAni.AlphaAnimation( 0.0, redar_DangerAletText, 0.0, 0.4 )
			aniInfo:SetHideAtEnd(true)
			isAnimation = false
		elseif 5 < textAniTime then
			textAniTime = 0
		end
		if not radar_DangetAlertBg:GetShow() then
			radar_DangetAlertBg:SetShow( true )
		end
	else
		redar_DangerAletText:SetShow( false )
		radar_DangetAlertBg:SetShow( false )
	end
end

function RadarMap_SimpleUIUpdatePerFrame( deltaTime )
	local isUiMode = (CppEnums.EProcessorInputMode.eProcessorInputMode_UiMode == getInputMode() or CppEnums.EProcessorInputMode.eProcessorInputMode_ChattingInputMode == getInputMode());

	local IsMouseOver = 	Panel_Radar:GetPosX() - 20 < getMousePosX() and getMousePosX() < Panel_Radar:GetPosX() + Panel_Radar:GetSizeX() + 20 and
							Panel_Radar:GetPosY() - 20 < getMousePosY() and getMousePosY() < Panel_Radar:GetPosY() + Panel_Radar:GetSizeY() + 20;	
	
	if isUiMode then
		isUiMode = IsMouseOver;
	end
	
	if IsMouseOver then
		simpleUIAlpha = 1.0;
	--else
	--	simpleUIAlpha = 0.0;
	end
	
	UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.timeNum, 						5 * deltaTime);
	UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.rader_Plus, 					5 * deltaTime);
	UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.rader_Minus, 					5 * deltaTime);
	UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.rader_AlphaPlus, 				5 * deltaTime);
	UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.rader_AlphaMinus, 			5 * deltaTime);
	UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.rader_Reset, 					5 * deltaTime);
	-- UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.rader_NpcFind_Toggle, 		5 * deltaTime);

	UIAni.perFrameAlphaAnimation(simpleUIAlpha, radar_SizeSlider,								5 * deltaTime);
	UIAni.perFrameAlphaAnimation(simpleUIAlpha, radar_SizeBtn, 									5 * deltaTime);
	UIAni.perFrameAlphaAnimation(simpleUIAlpha, radar_AlphaScrl,								5 * deltaTime);
	UIAni.perFrameAlphaAnimation(simpleUIAlpha, radar_AlphaBtn, 								5 * deltaTime);
	UIAni.perFrameAlphaAnimation(simpleUIAlpha, radar_MiniMapScl, 								5 * deltaTime);
	
	--if isUiMode then
	--	simpleUIAlpha = 1.0;
	--else
	--	simpleUIAlpha = 0.0;
	--end
	
	-- local tmpRaderAlphaValue = 0.7;
	-- local tmpRaderMoreAlphaValue = 0.5;
	-- if isUiMode then
		-- tmpRaderAlphaValue = 1.0;
		-- tmpRaderMoreAlphaValue = 1.0;
	-- end
	
	-- if( Panel_Radar:GetShow() ) then
		-- UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.rader_Plus, 					2.8 * deltaTime);
		-- UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.rader_Minus, 					2.8 * deltaTime);
		-- UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.rader_AlphaPlus, 				2.8 * deltaTime);
		-- UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.rader_AlphaMinus, 			2.8 * deltaTime);
		-- UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.rader_Reset, 					2.8 * deltaTime);
		-- -- UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.rader_NpcFind_Toggle, 		2.8 * deltaTime);
		-- UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.rader_Close, 					2.8 * deltaTime);
		-- UIAni.perFrameAlphaAnimation(simpleUIAlpha, radar_SizeSlider,								2.8 * deltaTime);
		-- UIAni.perFrameAlphaAnimation(simpleUIAlpha, radar_SizeBtn, 									2.8 * deltaTime);
		-- UIAni.perFrameAlphaAnimation(simpleUIAlpha, radar_AlphaScrl,								2.8 * deltaTime);
		-- UIAni.perFrameAlphaAnimation(simpleUIAlpha, radar_AlphaBtn, 								2.8 * deltaTime);
		-- UIAni.perFrameAlphaAnimation(simpleUIAlpha, radar_MiniMapScl, 								2.8 * deltaTime);
		-- UIAni.perFrameAlphaAnimation(tmpRaderAlphaValue,		radarMap.controls.icon_SelfPlayer, 	2.8 * deltaTime);
	-- end
	
	-- -- _PA_LOG("Test", "Test:"..tostring(Panel_TimeBar:GetShow()));
	-- --if( Panel_TimeBar:GetShow() ) then
		-- UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.timeNum, 						2.8 * deltaTime);
		-- UIAni.perFrameAlphaAnimation(tmpRaderMoreAlphaValue,	Panel_TimeBar, 						2.8 * deltaTime);
	-- --end
end

registerEvent( "SimpleUI_UpdatePerFrame",		"RadarMap_SimpleUIUpdatePerFrame")

function RaderMap_GetDistanceToPixelRate()
	return radarMap.worldDistanceToPixelRate
end

function RaderMap_GetSelfPosInRader()
	return radarMap.pcPosBaseControl
end

-- 최대호 스케일 비율
function RadarMap_GetScaleRateWidth()
	return radarMap.scaleRateWidth
end

function RadarMap_GetScaleRateHeight()
	return radarMap.scaleRateHeight
end

function HandleClicked_RadarResize()
	ToClient_SaveUiInfo( true )	-- 위치를 잡고 저장해야 한다.
end


checkLoad()			-- 서비스 버전에서는 없어도 되는 함수이다.
controlInit()		-- 초기화 함수
Radar_UpdateQuestList()  -- 퀘스트 표시 함수
-- RadarTimeBar_ShowToggle( true )

registerEvent("selfPlayer_regionChanged", "RadarMap_updateRegion")
registerEvent("EventActorDelete",			"RadarMap_DestoryOtherActor")
registerEvent("EventQuestListChanged",		"Radar_UpdateQuestList")
registerEvent("FromClient_UpdateQuestList", 	"Radar_UpdateQuestList")

-- 켜고 끄기 이벤트 함수~!
Panel_Radar:addInputEvent( "Mouse_On",	"Rader_ChangeTexture_On()" )
Panel_Radar:addInputEvent( "Mouse_Out", "Rader_ChangeTexture_Off()" )
Panel_Radar:addInputEvent( "Mouse_LUp", "ResetPos_WidgetButton()" )			--메인UI위젯 위치 초기화



function RadarMap_EnableSimpleUI_Force_Over()
	RadarMap_EnableSimpleUI( true );
end
function RadarMap_EnableSimpleUI_Force_Out()
	RadarMap_EnableSimpleUI( false );
end
registerEvent( "EventSimpleUIEnable",			"RadarMap_EnableSimpleUI_Force_Over")
registerEvent( "EventSimpleUIDisable",			"RadarMap_EnableSimpleUI_Force_Out")

function RadarMap_EnableSimpleUI(isEnable)
	--if isEnable then
	--	Rader_updateWorldMap_AlphaControl(-1.0);
	--end
	
	cacheSimpleUI_ShowButton = true;
end

if getEnableSimpleUI() then
--	RadarMap_EnableSimpleUI(true);
--	RadarMapBG_EnableSimpleUI(true)
end

--------------------------------drag 타임 설정용

function RadarMap_SetDragMode( isSet )
	isDrag = isSet
end




-----------------------------------------------------------------
-- Rador New
-----------------------------------------------------------------


local radorType =
{
	radorType_none						= 0,	--보여주지 않을 actor -- 삭제용
	radorType_hide						= 1,	--보여주지만 않을 actor

	radorType_allymonster				= 2,	--플레이어의 소환수 or 같은팀인 몬스터
	radorType_normalMonster				= 3,	--일반적인 몹들
	radorType_namedMonster				= 4,	--이름있는 몹들
	radorType_bossMonster				= 5,	--보스 몹들
	radorType_normalMonsterQuestTarget	= 6,	--퀘스트 목표인 일반적인 몹들
	radorType_namedMonsterQuestTarget	= 7,	--퀘스트 목표인 이름있는 몹들
	radorType_bossMonsterQuestTarget	= 8,	--퀘스트 목표인 보스 몹들

	radorType_lordManager				= 9, 	--영지 정보 관리인 Npc
	radorType_skillTrainner				= 10,	--스킬 교관 Npc
	radorType_tradeMerchantNpc			= 11,	--무역관리인 Npc(무역)
	radorType_nodeManager				= 12,	--탐험 노드관리인 Npc
	radorType_normalNpc					= 13,	--일반적인 npc
	radorType_warehouseNpc				= 14,	--창고관리인 Npc
	radorType_potionNpc					= 15,	--물약상인 Npc
	radorType_weaponNpc					= 16,	--무기상인 Npc
	radorType_horseNpc					= 17,	--마구간지기 Npc
	radorType_workerNpc					= 18,	--작업감독관 Npc
	radorType_jewelNpc					= 19,	--보석상인 Npc
	radorType_furnitureNpc				= 20,	--가구상인 Npc
	radorType_collectNpc				= 21,	--재료상인 Npc
	radorType_shipNpc					= 22,	--나루터지기 Npc
	radorType_alchemyNpc				= 23,	--연금술사 Npc
	radorType_fishNpc					= 24,	--물고기상인 Npc
	
	radorType_guild	    				= 25,   --길드 Npc
	radorType_guildShop 				= 26,   --길드하우스 경매 Npc
	radorType_itemTrader    			= 27,   --아이템 거래소 Npc
	radorType_TerritorySupply			= 28,   --황실납품 Npc
	radorType_TerritoryTrade			= 29,   --황실무역 Npc
	radorType_Cook						= 30,   --요리 Npc
	radorType_Wharf                     = 31,   --나루터지기 Npc
	
	radorType_itemRepairer				= 32,	--수리 Npc
	radorType_shopMerchantNpc			= 33,	--상인 Npc(일반) 
	radorType_ImportantNpc				= 34,	--그외 중요 Npc
	radorType_QuestAcceptable			= 35,	-- 퀘스트를 완료 할 수 있는 경우
	radorType_QuestProgress				= 36,	-- 퀘스트를 수행 중인 경우
	radorType_QuestComplete				= 37,	-- 퀘스트를 완료할 수 있는 경우
	radorType_unknownNpc				= 38,	--현재 발견되지 않은 Npc
		
	radorType_partyMember				= 39,	-- 파티원 플레이어
	radorType_guildMember				= 40,	-- 길드원 플레이어
	radorType_normalPlayer				= 41,	-- 그외 플레이어

	radorType_isHorse					= 42,	--플레이어의 말
	radorType_isDonkey					= 43,	--플레이어의 당나귀
	radorType_isCamel					= 44,	--플레이어의 낙타
	radorType_isElephant				= 45,	--플레이어의 코끼리(길드소유)
	radorType_isShip					= 46,	--플레이어의 배
	radorType_isCarriage				= 47,	--플레이어의 마차


	radorType_installation				= 48,	--설치물
	radorType_kingGuildTent				= 49,	--공성 길드텐트
	radorType_lordGuildTent				= 50,	--영지 길드텐트
	radorType_villageGuildTent			= 51,	--영지 길드텐트

	radorType_selfDeadBody				= 52,	--셀프플레이어의 시체 계통
	radorType_advancedBase				= 53,	-- 전진기지
		
	radorType_Count						= 54,
}



local template = {
	[radorType.radorType_none]						= nil,
	[radorType.radorType_hide]						= UI.getChildControl( Panel_Radar, "icon_hide"),

	[radorType.radorType_allymonster]				= UI.getChildControl( Panel_Radar, "icon_horse"),
	[radorType.radorType_normalMonster]				= UI.getChildControl( Panel_Radar, "icon_monsterGeneral_normal"),
	[radorType.radorType_namedMonster]				= UI.getChildControl( Panel_Radar, "icon_monsterNamed_normal"),		-- <난폭한>
	[radorType.radorType_bossMonster]				= UI.getChildControl( Panel_Radar, "icon_monsterBoss_normal"),		-- <우두머리>
	[radorType.radorType_normalMonsterQuestTarget]	= UI.getChildControl( Panel_Radar, "icon_monsterGeneral_quest"),
	[radorType.radorType_namedMonsterQuestTarget]	= UI.getChildControl( Panel_Radar, "icon_monsterNamed_quest"),
	[radorType.radorType_bossMonsterQuestTarget]	= UI.getChildControl( Panel_Radar, "icon_monsterBoss_quest"),

	[radorType.radorType_lordManager]				= UI.getChildControl( Panel_Radar, "icon_npc_lordManager"),		-- 영지 정보 관리인 Npc
	[radorType.radorType_skillTrainner]				= UI.getChildControl( Panel_Radar, "icon_npc_skillTrainner"),   -- 스킬 교관 Npc
	[radorType.radorType_tradeMerchantNpc]			= UI.getChildControl( Panel_Radar, "icon_npc_trader"),     		-- 무역관리인 Npc(무역)
	[radorType.radorType_nodeManager]				= UI.getChildControl( Panel_Radar, "icon_npc_nodeManager"),     -- 탐험 노드관리인 Npc
	--[radorType.radorType_normalNpc]					= UI.getChildControl( Panel_Radar, "icon_npc_general"),		    -- 일반적인 npc
	[radorType.radorType_normalNpc]					= nil,		    -- 일반적인 npc
	[radorType.radorType_warehouseNpc]				= UI.getChildControl( Panel_Radar, "icon_npc_warehouse"),		-- 창고관리인 Npc
	[radorType.radorType_potionNpc]					= UI.getChildControl( Panel_Radar, "icon_npc_potion"),		    -- 물약상인 Npc
	[radorType.radorType_weaponNpc]					= UI.getChildControl( Panel_Radar, "icon_npc_storeArmor"),		-- 무기상인 Npc
	[radorType.radorType_horseNpc]					= UI.getChildControl( Panel_Radar, "icon_npc_horse"),		    -- 마구간지기 Npc
	[radorType.radorType_workerNpc]					= UI.getChildControl( Panel_Radar, "icon_npc_worker"),		    -- 작업감독관 Npc
	[radorType.radorType_jewelNpc]					= UI.getChildControl( Panel_Radar, "icon_npc_jewel"),		    -- 보석상인 Npc
	[radorType.radorType_furnitureNpc]				= UI.getChildControl( Panel_Radar, "icon_npc_furniture"),		-- 가구상인 Npc
	[radorType.radorType_collectNpc]				= UI.getChildControl( Panel_Radar, "icon_npc_collect"),		    -- 재료상인 Npc
	[radorType.radorType_shipNpc]					= UI.getChildControl( Panel_Radar, "icon_npc_ship"),		     	-- 나루터지기 Npc
	[radorType.radorType_alchemyNpc]				= UI.getChildControl( Panel_Radar, "icon_npc_alchemy"),		    -- 연금술사 Npc
	[radorType.radorType_fishNpc]					= UI.getChildControl( Panel_Radar, "icon_npc_fish"),		     	-- 물고기상인 Npc

	[radorType.radorType_guild]	    	        	= UI.getChildControl( Panel_Radar, "icon_npc_guild"),          --길드 Npc
	[radorType.radorType_guildShop] 	            = UI.getChildControl( Panel_Radar, "icon_npc_guildShop"),      --길드하우스 경매 Npc
	[radorType.radorType_itemTrader]    	        = UI.getChildControl( Panel_Radar, "icon_npc_itemTrader"),     --아이템 거래소 Npc
	[radorType.radorType_TerritorySupply]			= UI.getChildControl( Panel_Radar, "icon_npc_territorySupply"),--황실납품 Npc
	[radorType.radorType_TerritoryTrade]  			= UI.getChildControl( Panel_Radar, "icon_npc_territoryTrade"), --황실무역 Npc
	[radorType.radorType_Cook]			    	    = UI.getChildControl( Panel_Radar, "icon_npc_cook"),           --요리 Npc
    [radorType.radorType_Wharf]                     = UI.getChildControl( Panel_Radar, "icon_npc_wharf"),          --나루터지기 Npc
	
	                                                                                                            
	[radorType.radorType_itemRepairer]				= UI.getChildControl( Panel_Radar, "icon_npc_repairer"),		-- 수리공
	[radorType.radorType_shopMerchantNpc]			= UI.getChildControl( Panel_Radar, "icon_npc_shop"),			-- 상점
	[radorType.radorType_ImportantNpc]				= UI.getChildControl( Panel_Radar, "icon_npc_important"),		-- 중요 NPC
	
	[radorType.radorType_QuestAcceptable]			= UI.getChildControl( Panel_Radar, "icon_quest_accept"),		-- 퀘스트 수락 가능
	[radorType.radorType_QuestProgress]				= UI.getChildControl( Panel_Radar, "icon_quest_doing"),			-- 퀘스트 수행중
	[radorType.radorType_QuestComplete]				= UI.getChildControl( Panel_Radar, "icon_quest_clear"),			-- 퀘스트 완료 가능
	
	[radorType.radorType_unknownNpc]				= UI.getChildControl( Panel_Radar, "icon_npc_unknown"),			-- ?
	
	[radorType.radorType_partyMember]				= UI.getChildControl( Panel_Radar, "icon_partyMember"),
	[radorType.radorType_guildMember]				= UI.getChildControl( Panel_Radar, "icon_guildMember"),
	[radorType.radorType_normalPlayer]				= UI.getChildControl( Panel_Radar, "icon_player"),
	
	[radorType.radorType_isHorse]					= UI.getChildControl( Panel_Radar, "icon_horse"),
	[radorType.radorType_isDonkey]					= UI.getChildControl( Panel_Radar, "icon_donkey"),
	[radorType.radorType_isShip]					= UI.getChildControl( Panel_Radar, "icon_ship"),
	[radorType.radorType_isCarriage]				= UI.getChildControl( Panel_Radar, "icon_carriage"),
	[radorType.radorType_isCamel]					= UI.getChildControl( Panel_Radar, "icon_camel"),
		
	[radorType.radorType_installation]				= UI.getChildControl( Panel_Radar, "icon_tent"),
	[radorType.radorType_kingGuildTent]				= UI.getChildControl( Panel_Radar, "icon_tent"),
	[radorType.radorType_lordGuildTent]				= UI.getChildControl( Panel_Radar, "icon_tent"),
	[radorType.radorType_villageGuildTent]			= UI.getChildControl( Panel_Radar, "icon_tent"),
	
	[radorType.radorType_selfDeadBody]				= UI.getChildControl( Panel_Radar, "icon_deadbody"),
	[radorType.radorType_advancedBase]				= UI.getChildControl( Panel_Radar, "icon_Outpost"),
}

local typeDepth = {
	[radorType.radorType_none]						= 0,
	[radorType.radorType_hide]						= 0,

	[radorType.radorType_allymonster]				= -2,
	[radorType.radorType_normalMonster]				= -2,
	[radorType.radorType_namedMonster]				= -10,	-- <난폭한>
	[radorType.radorType_bossMonster]				= -10,	-- <우두머리>
	[radorType.radorType_normalMonsterQuestTarget]	= -2,
	[radorType.radorType_namedMonsterQuestTarget]	= -2,
	[radorType.radorType_bossMonsterQuestTarget]	= -2,

	[radorType.radorType_lordManager]				= -2,	-- 영지 정보 관리인 Npc
	[radorType.radorType_skillTrainner]				= -2,	-- 스킬 교관 Npc
	[radorType.radorType_tradeMerchantNpc]			= -2,	-- 무역관리인 Npc(무역)
	[radorType.radorType_nodeManager]				= -2,	-- 탐험 노드관리인 Npc

	[radorType.radorType_normalNpc]					= -2,  -- 일반적인 npc
	[radorType.radorType_warehouseNpc]				= -2,  -- 창고관리인 Npc
	[radorType.radorType_potionNpc]					= -2,  -- 물약상인 Npc
	[radorType.radorType_weaponNpc]					= -2,  -- 무기상인 Npc
	[radorType.radorType_horseNpc]					= -2,  -- 마구간지기 Npc
	[radorType.radorType_workerNpc]					= -2,  -- 작업감독관 Npc
	[radorType.radorType_jewelNpc]					= -2,  -- 보석상인 Npc
	[radorType.radorType_furnitureNpc]				= -2,  -- 가구상인 Npc
	[radorType.radorType_collectNpc]				= -2,  -- 재료상인 Npc
	[radorType.radorType_shipNpc]					= -2,  -- 나루터지기 Npc
	[radorType.radorType_alchemyNpc]				= -2,  -- 연금술사 Npc
	[radorType.radorType_fishNpc]					= -2,  -- 물고기상인 Npc

	[radorType.radorType_guild]	    	        	= -2,  --길드 Npc           
	[radorType.radorType_guildShop] 	            = -2,  --길드하우스 경매 Npc
	[radorType.radorType_itemTrader]    	        = -2,  --아이템 거래소 Npc  
	[radorType.radorType_TerritorySupply]			= -2,  --황실납품 Npc       
	[radorType.radorType_TerritoryTrade]  			= -2,  --황실무역 Npc       
	[radorType.radorType_Cook]			    	    = -2,  --요리 Npc           
    [radorType.radorType_Wharf]                     = -2,  --나루터지기 Npc

	[radorType.radorType_itemRepairer]				= -2,	-- 수리공
	[radorType.radorType_shopMerchantNpc]			= -2,	-- 상점
	[radorType.radorType_ImportantNpc]				= -2,	-- 중요 NPC

	[radorType.radorType_QuestAcceptable]			= -2,	-- 퀘스트 수락 가능
	[radorType.radorType_QuestProgress]				= -2,	-- 퀘스트 수행중
	[radorType.radorType_QuestComplete]				= -2,	-- 퀘스트 완료 가능

	[radorType.radorType_unknownNpc]				= -2,	-- ?

	[radorType.radorType_partyMember]				= -90,	-- 파티원
	[radorType.radorType_guildMember]				= -80,	-- 길드원들
	[radorType.radorType_normalPlayer]				= -1,	-- 일반플레이어들

	[radorType.radorType_isHorse]					= -100,	-- 내 탈것들(말)
	[radorType.radorType_isDonkey]					= -100,	-- 내 탈것들(당나귀)
	[radorType.radorType_isShip]					= -100,	-- 내 탈것들(배)
	[radorType.radorType_isCarriage]				= -100,	-- 내 탈것들(마차)
	[radorType.radorType_isCamel]					= -100,	-- 내 탈것들(낙타)

	[radorType.radorType_installation]				= -10,	-- 설치물
	[radorType.radorType_kingGuildTent]				= -10,	-- 
	[radorType.radorType_lordGuildTent]				= -10,	-- 

	[radorType.radorType_selfDeadBody]				= -10,
	[radorType.radorType_advancedBase]				= -10,
}

local colorBlindNone = {
	[radorType.radorType_allymonster]				= UI_color.C_FFB22300,
	[radorType.radorType_normalMonster]				= UI_color.C_FFB22300,
	[radorType.radorType_namedMonster]				= UI_color.C_FFB22300,
	[radorType.radorType_bossMonster]				= UI_color.C_FFB22300,
	[radorType.radorType_normalMonsterQuestTarget]	= UI_color.C_FFEE9900,
	[radorType.radorType_namedMonsterQuestTarget]	= UI_color.C_FFEE9900,
	[radorType.radorType_bossMonsterQuestTarget]	= UI_color.C_FFEE9900,
}

local colorBlindRed = {
	[radorType.radorType_allymonster]				= UI_color.C_FFD85300,
	[radorType.radorType_normalMonster]				= UI_color.C_FFD85300,
	[radorType.radorType_namedMonster]				= UI_color.C_FFD85300,
	[radorType.radorType_bossMonster]				= UI_color.C_FFD85300,
	[radorType.radorType_normalMonsterQuestTarget]	= UI_color.C_FFFFE866,
	[radorType.radorType_namedMonsterQuestTarget]	= UI_color.C_FFFFE866,
	[radorType.radorType_bossMonsterQuestTarget]	= UI_color.C_FFFFE866,
}

local colorBlindGreen = {
	[radorType.radorType_allymonster]				= UI_color.C_FFD82800,
	[radorType.radorType_normalMonster]				= UI_color.C_FFD82800,
	[radorType.radorType_namedMonster]				= UI_color.C_FFD82800,
	[radorType.radorType_bossMonster]				= UI_color.C_FFD82800,
	[radorType.radorType_normalMonsterQuestTarget]	= UI_color.C_FFFFE866,
	[radorType.radorType_namedMonsterQuestTarget]	= UI_color.C_FFFFE866,
	[radorType.radorType_bossMonsterQuestTarget]	= UI_color.C_FFFFE866,
}

function FGlobal_Rador_SetColorBlindMode()
	-- local ActorIconList		= FromClient_getRadarIconList(  )
	local ActorIconList = nil
	local isColorBlindMode	= ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(CppEnums.GlobalUIOptionType.ColorBlindMode)

	if (0 == isColorBlindMode) then	-- 비 색맹 모드
		for key, value in pairs( colorBlindNone ) do
			ActorIconList = FromClient_getRadarIconList( key )
			for key, control in pairs( ActorIconList ) do
				control:SetColor( value )
			end
		end
	elseif (1 == isColorBlindMode) then	-- 적색맹 모드
		for key, value in pairs( colorBlindRed ) do
			ActorIconList = FromClient_getRadarIconList( key )
			for key, control in pairs( ActorIconList ) do
				control:SetColor( value )
			end
		end
	elseif (2 == isColorBlindMode) then	-- 녹색맹 모드
		for key, value in pairs( colorBlindGreen ) do
			ActorIconList = FromClient_getRadarIconList( key )
			for key, control in pairs( ActorIconList ) do
				control:SetColor( value )
			end
		end
	end	
	

	-- for key, value in pairs(ActorIconList) do
	-- 	if (0 == isColorBlindMode) then	-- 비 색맹 모드
	-- 		if key == radorType.radorType_allymonster then
	-- 			value:SetColor( UI_color.C_FFB22300 )
	-- 		elseif key == radorType.radorType_normalMonster then
	-- 			value:SetColor( UI_color.C_FFB22300 )
	-- 		elseif key == radorType.radorType_namedMonster then
	-- 			value:SetColor( UI_color.C_FFB22300 )
	-- 		elseif key == radorType.radorType_bossMonster then
	-- 			value:SetColor( UI_color.C_FFB22300 )
	-- 		elseif key == radorType.radorType_normalMonsterQuestTarget then
	-- 			value:SetColor( UI_color.C_FFEE9900 )
	-- 		elseif key == radorType.radorType_namedMonsterQuestTarget then
	-- 			value:SetColor( UI_color.C_FFEE9900 )
	-- 		elseif key == radorType.radorType_bossMonsterQuestTarget then
	-- 			value:SetColor( UI_color.C_FFEE9900 )
	-- 		end
	-- 	elseif (1 == isColorBlindMode) then	-- 적색맹 모드
	-- 		if key == radorType.radorType_allymonster then
	-- 			value:SetColor( UI_color.C_FFD85300 )
	-- 		elseif key == radorType.radorType_normalMonster then
	-- 			value:SetColor( UI_color.C_FFD85300 )
	-- 		elseif key == radorType.radorType_namedMonster then
	-- 			value:SetColor( UI_color.C_FFD85300 )
	-- 		elseif key == radorType.radorType_bossMonster then
	-- 			value:SetColor( UI_color.C_FFD85300 )
	-- 		elseif key == radorType.radorType_normalMonsterQuestTarget then
	-- 			value:SetColor( UI_color.C_FFFFE866 )
	-- 		elseif key == radorType.radorType_namedMonsterQuestTarget then
	-- 			value:SetColor( UI_color.C_FFFFE866 )
	-- 		elseif key == radorType.radorType_bossMonsterQuestTarget then
	-- 			value:SetColor( UI_color.C_FFFFE866 )
	-- 		end
	-- 	elseif (2 == isColorBlindMode) then	-- 녹색맹 모드
	-- 		if key == radorType.radorType_allymonster then
	-- 			value:SetColor( UI_color.C_FFD82800 )
	-- 		elseif key == radorType.radorType_normalMonster then
	-- 			value:SetColor( UI_color.C_FFD82800 )
	-- 		elseif key == radorType.radorType_namedMonster then
	-- 			value:SetColor( UI_color.C_FFD82800 )
	-- 		elseif key == radorType.radorType_bossMonster then
	-- 			value:SetColor( UI_color.C_FFD82800 )
	-- 		elseif key == radorType.radorType_normalMonsterQuestTarget then
	-- 			value:SetColor( UI_color.C_FFFFE866 )
	-- 		elseif key == radorType.radorType_namedMonsterQuestTarget then
	-- 			value:SetColor( UI_color.C_FFFFE866 )
	-- 		elseif key == radorType.radorType_bossMonsterQuestTarget then
	-- 			value:SetColor( UI_color.C_FFFFE866 )
	-- 		end
	-- 	end
	-- end
end
-- FGlobal_Rador_SetColorBlindMode()

function FromClient_RadorUICreated( actorKeyRaw, control, actorProxyWrapper, radorTypeValue )
	control:SetSize(10, 10)

	--if ( actorProxyWrapper:get():isHiddenName() ) then		
	--	control:SetShow(false)
	--	return
	--end
	local base = template[radorTypeValue] -- radorTypeValue대로 안넣는경우가 있으면 병화에게 알려주세요.
	local isColorBlindType = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(CppEnums.GlobalUIOptionType.ColorBlindMode)


	if ( nil ~= base ) then		
		CopyBaseProperty( base, control)
		control:SetShow(true)
		if (0 == isColorBlindType) then	-- 색약 모드 사용 안함.
			if (radorType.radorType_allymonster						== radorTypeValue) then	-- 플레이어 소환수?
				control:SetColor( UI_color.C_FFB22300 )
			elseif (radorType.radorType_normalMonster				== radorTypeValue) then	-- 일반 몬스터
				control:SetColor( UI_color.C_FFB22300 )
			elseif (radorType.radorType_namedMonster				== radorTypeValue) then	-- 별사탕 몬스터
				control:SetColor( UI_color.C_FFB22300 )
			elseif (radorType.radorType_bossMonster					== radorTypeValue) then	-- 보스 몬스터
				control:SetColor( UI_color.C_FFB22300 )
			elseif (radorType.radorType_normalMonsterQuestTarget	== radorTypeValue) then	-- 일반 퀘스트 몬스터
				control:SetColor( UI_color.C_FFEE9900 )
			elseif (radorType.radorType_namedMonsterQuestTarget		== radorTypeValue) then	-- 별사탕 퀘스트 몬스터
				control:SetColor( UI_color.C_FFEE9900 )
			elseif (radorType.radorType_bossMonsterQuestTarget		== radorTypeValue) then	-- 보스 퀘스트 몬스터
				control:SetColor( UI_color.C_FFEE9900 )
			end
		elseif (1 == isColorBlindType) then	-- 색약 모드(적색맹)
			if (radorType.radorType_allymonster						== radorTypeValue) then	-- 플레이어 소환수?
				control:SetColor( UI_color.C_FFD85300 )
			elseif (radorType.radorType_normalMonster				== radorTypeValue) then	-- 일반 몬스터
				control:SetColor( UI_color.C_FFD85300 )
			elseif (radorType.radorType_namedMonster				== radorTypeValue) then	-- 별사탕 몬스터
				control:SetColor( UI_color.C_FFD85300 )
			elseif (radorType.radorType_bossMonster					== radorTypeValue) then	-- 보스 몬스터
				control:SetColor( UI_color.C_FFD85300 )
			elseif (radorType.radorType_normalMonsterQuestTarget	== radorTypeValue) then	-- 일반 퀘스트 몬스터
				control:SetColor( UI_color.C_FFFFE866 )
			elseif (radorType.radorType_namedMonsterQuestTarget		== radorTypeValue) then	-- 별사탕 퀘스트 몬스터
				control:SetColor( UI_color.C_FFFFE866 )
			elseif (radorType.radorType_bossMonsterQuestTarget		== radorTypeValue) then	-- 보스 퀘스트 몬스터
				control:SetColor( UI_color.C_FFFFE866 )
			end
		elseif ( 2 == isColorBlindType ) then	-- 색약 모드(녹색맹)
			if (radorType.radorType_allymonster						== radorTypeValue) then	-- 플레이어 소환수?
				control:SetColor( UI_color.C_FFD82800 )
			elseif (radorType.radorType_normalMonster				== radorTypeValue) then	-- 일반 몬스터
				control:SetColor( UI_color.C_FFD82800 )
			elseif (radorType.radorType_namedMonster				== radorTypeValue) then	-- 별사탕 몬스터
				control:SetColor( UI_color.C_FFD82800 )
			elseif (radorType.radorType_bossMonster					== radorTypeValue) then	-- 보스 몬스터
				control:SetColor( UI_color.C_FFD82800 )
			elseif (radorType.radorType_normalMonsterQuestTarget	== radorTypeValue) then	-- 일반 퀘스트 몬스터
				control:SetColor( UI_color.C_FFFFE866 )
			elseif (radorType.radorType_namedMonsterQuestTarget		== radorTypeValue) then	-- 별사탕 퀘스트 몬스터
				control:SetColor( UI_color.C_FFFFE866 )
			elseif (radorType.radorType_bossMonsterQuestTarget		== radorTypeValue) then	-- 보스 퀘스트 몬스터
				control:SetColor( UI_color.C_FFFFE866 )
			end
		end
	else
	    control:SetShow(false)
	end		
	
	monsterTitle = nil
	SortRador_IconIndex()
	ToClient_setRadorUICenterPosition( int2(radarMap.pcPosBaseControl.x, radarMap.pcPosBaseControl.y) )
	control:SetDepth( typeDepth[radorTypeValue] )
end

function FromClient_RadorTypeChanged( actorKeyRaw, targetUI, radorTypeValue )
	local templateUI = template[radorTypeValue]
	if ( nil == templateUI ) then
		targetUI:SetShow(false)
		return
	end

	CopyBaseProperty( templateUI, targetUI )
	local isColorBlindType = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(CppEnums.GlobalUIOptionType.ColorBlindMode)
	if (0 == isColorBlindType) then	-- 색약 모드 사용 안함.
		if (radorType.radorType_allymonster						== radorTypeValue) then	-- 플레이어 소환수?
			targetUI:SetColor( UI_color.C_FFB22300 )
		elseif (radorType.radorType_normalMonster				== radorTypeValue) then	-- 일반 몬스터
			targetUI:SetColor( UI_color.C_FFB22300 )
		elseif (radorType.radorType_namedMonster				== radorTypeValue) then	-- 별사탕 몬스터
			targetUI:SetColor( UI_color.C_FFB22300 )
		elseif (radorType.radorType_bossMonster					== radorTypeValue) then	-- 보스 몬스터
			targetUI:SetColor( UI_color.C_FFB22300 )
		elseif (radorType.radorType_normalMonsterQuestTarget	== radorTypeValue) then	-- 일반 퀘스트 몬스터
			targetUI:SetColor( UI_color.C_FFEE9900 )
		elseif (radorType.radorType_namedMonsterQuestTarget		== radorTypeValue) then	-- 별사탕 퀘스트 몬스터
			targetUI:SetColor( UI_color.C_FFEE9900 )
		elseif (radorType.radorType_bossMonsterQuestTarget		== radorTypeValue) then	-- 보스 퀘스트 몬스터
			targetUI:SetColor( UI_color.C_FFEE9900 )
		end
	elseif (1 == isColorBlindType) then	-- 색약 모드(적색맹)
		if (radorType.radorType_allymonster						== radorTypeValue) then	-- 플레이어 소환수?
			targetUI:SetColor( UI_color.C_FFD85300 )
		elseif (radorType.radorType_normalMonster				== radorTypeValue) then	-- 일반 몬스터
			targetUI:SetColor( UI_color.C_FFD85300 )
		elseif (radorType.radorType_namedMonster				== radorTypeValue) then	-- 별사탕 몬스터
			targetUI:SetColor( UI_color.C_FFD85300 )
		elseif (radorType.radorType_bossMonster					== radorTypeValue) then	-- 보스 몬스터
			targetUI:SetColor( UI_color.C_FFD85300 )
		elseif (radorType.radorType_normalMonsterQuestTarget	== radorTypeValue) then	-- 일반 퀘스트 몬스터
			targetUI:SetColor( UI_color.C_FFFFE866 )
		elseif (radorType.radorType_namedMonsterQuestTarget		== radorTypeValue) then	-- 별사탕 퀘스트 몬스터
			targetUI:SetColor( UI_color.C_FFFFE866 )
		elseif (radorType.radorType_bossMonsterQuestTarget		== radorTypeValue) then	-- 보스 퀘스트 몬스터
			targetUI:SetColor( UI_color.C_FFFFE866 )
		end
	elseif ( 2 == isColorBlindType ) then	-- 색약 모드(녹색맹)
		if (radorType.radorType_allymonster						== radorTypeValue) then	-- 플레이어 소환수?
			targetUI:SetColor( UI_color.C_FFD82800 )
		elseif (radorType.radorType_normalMonster				== radorTypeValue) then	-- 일반 몬스터
			targetUI:SetColor( UI_color.C_FFD82800 )
		elseif (radorType.radorType_namedMonster				== radorTypeValue) then	-- 별사탕 몬스터
			targetUI:SetColor( UI_color.C_FFD82800 )
		elseif (radorType.radorType_bossMonster					== radorTypeValue) then	-- 보스 몬스터
			targetUI:SetColor( UI_color.C_FFD82800 )
		elseif (radorType.radorType_normalMonsterQuestTarget	== radorTypeValue) then	-- 일반 퀘스트 몬스터
			targetUI:SetColor( UI_color.C_FFFFE866 )
		elseif (radorType.radorType_namedMonsterQuestTarget		== radorTypeValue) then	-- 별사탕 퀘스트 몬스터
			targetUI:SetColor( UI_color.C_FFFFE866 )
		elseif (radorType.radorType_bossMonsterQuestTarget		== radorTypeValue) then	-- 보스 퀘스트 몬스터
			targetUI:SetColor( UI_color.C_FFFFE866 )
		end
	end

	targetUI:SetDepth( typeDepth[radorTypeValue] )
	--Panel_Radar:SetChildIndex( targetUI:GetKey(), 9000 )
end
registerEvent("FromClient_RadorTypeChanged", "FromClient_RadorTypeChanged")
registerEvent("FromClient_RadorUICreated", "FromClient_RadorUICreated" )

local check_ServerChannel = function()
	local radarTimeControl = radarTime.controls
	radarTimeControl.serverName:SetText( getCurrentWolrdName() )
	-- if mainChannel then radarTimeControl.channelName:SetText( "(" .. getCurrentChannelIndex()+1 .. "채널)" ) + 아이콘 켠다. else
	local curChannelData	= getCurrentChannelServerData()
	if isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_KOR ) then
		radarTimeControl.serverName:SetShow( false )
	else
		radarTimeControl.serverName:SetShow( true )
	end
		
	local channelName		= getChannelName(curChannelData._worldNo, curChannelData._serverNo )
	radarTimeControl.channelName:SetText( "<PAColor0xFFb0cd61>" .. channelName .. "<PAOldColor>" )
	-- end
end
check_ServerChannel()


function CalcPositionUseToTextUI( targetUI, textUI )
	if( Panel_Radar:GetSizeX() < targetUI:GetPosX() + textUI:GetTextSizeX() ) then
		textUI:SetPosX( Panel_Radar:GetSizeX() - textUI:GetTextSizeX() )
	else
		textUI:SetPosX( targetUI:GetPosX() )
	end
	
	if( Panel_Radar:GetPosY() > targetUI:GetPosY() - textUI:GetTextSizeY() ) then
		textUI:SetPosY( Panel_Radar:GetPosY() )
	else
		textUI:SetPosY( targetUI:GetPosY() - textUI:GetTextSizeY() )
	end
end

function FromClient_setNameOfMouseOverIcon( actorProxyWrapper, targetUI )
	local actorName = ""
	if actorProxyWrapper:get():isNpc() then
		if "" ~= actorProxyWrapper:getCharacterTitle() then
			actorName = actorProxyWrapper:getName() .. " " .. actorProxyWrapper:getCharacterTitle()
		else
			actorName = actorProxyWrapper:getName()
		end
	elseif ( actorProxyWrapper:get():isHouseHold() ) then
		actorName = getHouseHoldName( actorProxyWrapper:get() )
	else
		actorName = actorProxyWrapper:getName()
	end

	radar_OverName:SetShow(true)
	radar_OverName:SetText( actorName )
	radar_OverName:SetSize( radar_OverName:GetTextSizeX() + 15, radar_OverName:GetTextSizeY() + radar_OverName:GetSpanSize().y )
	Panel_Radar:SetChildIndex(radar_OverName, 9999 )
	CalcPositionUseToTextUI( targetUI, radar_OverName )
	radar_OverName:SetDepth( - 1000 )
	
	--[[
	if( Panel_Radar:GetSizeX() < targetUI:GetPosX() + radar_OverName:GetTextSizeX() ) then
		radar_OverName:SetPosX( Panel_Radar:GetSizeX() - radar_OverName:GetTextSizeX() )
	else
		radar_OverName:SetPosX( targetUI:GetPosX() )
	end
	
	if( Panel_Radar:GetPosY() > targetUI:GetPosY() - radar_OverName:GetTextSizeY() ) then
		radar_OverName:SetPosY( Panel_Radar:GetPosY() )
	else
		radar_OverName:SetPosY( targetUI:GetPosY() - radar_OverName:GetTextSizeY() )
	end
	]]--
	
end

function FromClient_NameOff()
	if(radar_OverName:GetShow() ) then		
		radar_OverName:SetShow(false)
	end
end

function FGlobal_ResetRadarUI()
	radar_AlphaScrl					:SetControlPos( ToClient_GetRaderAlpha() * 100 )
	Rader_updateWorldMap_AlphaControl_Init()
	
	radar_SizeSlider				:SetControlPos( ToClient_GetRaderScale() * 100 )
	local scaleSlideValue = 1.0 - radar_SizeSlider:GetControlPos()
	updateWorldMapDistance(scaleMinValue + scaleSlideValue * 100)
end

registerEvent("FromClient_setNameOfMouseOverIcon", "FromClient_setNameOfMouseOverIcon" )
registerEvent("FromClient_NameOff", "FromClient_NameOff" )
registerEvent("FromClient_ChangeRadarRotateMode", "Radar_SetRotateMode")

changePositionBySever(Panel_Radar, CppEnums.PAGameUIType.PAGameUIPanel_RadarMap, true, false, false)
changePositionBySever(Panel_TimeBar, CppEnums.PAGameUIType.PAGameUIPanel_TimeBar, true, false, false)
