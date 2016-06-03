------------------------------------------------------------------------------------------------------
-- 로컬 변수 선언
local UI_color 			= Defines.Color
local UI_ST				= CppEnums.SpawnType
local UI_TM				= CppEnums.TextMode
local UI_ANI_ADV		= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_AV				= CppEnums.PA_UI_ALIGNVERTICAL
local UI_TT				= CppEnums.PAUI_TEXTURE_TYPE
local currentTownMode	= false
local eWorldmapState = CppEnums.WorldMapState;
local worldMapState = {
	[eWorldmapState.eWMS_EXPLORE_PLANT] 			= UI.getChildControl( Panel_WorldMap, "Static_3DMap_UIMode_Change_default" ),
	[eWorldmapState.eWMS_REGION] 					= UI.getChildControl( Panel_WorldMap, "Static_3DMap_UIMode_Change_NoUI" ),
	[eWorldmapState.eWMS_LOCATION_INFO_WATER] 		= UI.getChildControl( Panel_WorldMap, "Static_3DMap_UIMode_Change_Water" ),
	[eWorldmapState.eWMS_LOCATION_INFO_CELCIUS] 	= UI.getChildControl( Panel_WorldMap, "Static_3DMap_UIMode_Change_Celcius" ),
	[eWorldmapState.eWMS_LOCATION_INFO_HUMIDITY] 	= UI.getChildControl( Panel_WorldMap, "Static_3DMap_UIMode_Change_Humility" ),
	[eWorldmapState.eWMS_GUILD_WAR]					= UI.getChildControl( Panel_WorldMap, "Static_3DMap_UIMode_Change_GuildWar" )
}

local checkBoxBG					= UI.getChildControl( Panel_WorldMap, "Static_GuideBG");

local eCheckState = CppEnums.WorldMapCheckState; 
local worldMapCheckList = {
	[eCheckState.eCheck_Quest] 		= UI.getChildControl( Panel_WorldMap, "CheckButton_Quest" ),
	[eCheckState.eCheck_Knowledge] 	= UI.getChildControl( Panel_WorldMap, "CheckButton_Knowledge" ),
	[eCheckState.eCheck_FishnChip] 	= UI.getChildControl( Panel_WorldMap, "CheckButton_Fishnchip" ),
	[eCheckState.eCheck_Node] 		= UI.getChildControl( Panel_WorldMap, "CheckButton_Node" ),
	[eCheckState.eCheck_Trade] 		= UI.getChildControl( Panel_WorldMap, "CheckButton_Trade" ),
	[eCheckState.eCheck_Way] 		= UI.getChildControl( Panel_WorldMap, "CheckButton_WayGuide" ),
	[eCheckState.eCheck_Postions] 	= UI.getChildControl( Panel_WorldMap, "CheckButton_Positions" ),
	[eCheckState.eCheck_Wagon] 		= UI.getChildControl( Panel_WorldMap, "CheckButton_Carriage" )
}

local worldMapMovieList = {
	_playButton		= UI.getChildControl( Panel_WorldMap, "Button_MovieTooltip" ),
	
	_panel 			= UI.getChildControl( Panel_WorldMap, "Static_MovieToolTipPanel" ),
	_title 			= UI.getChildControl( Panel_WorldMap, "StaticText_MovieTitle" ),
	_panelBG 		= UI.getChildControl( Panel_WorldMap, "Static_MovieToolTipPanel_BG" ),
	_btn_Close	 	= UI.getChildControl( Panel_WorldMap, "Button_Close" ),
		
	_btn_Movie_1 	= UI.getChildControl( Panel_WorldMap, "Button_Movie_0" ),
	_btn_Movie_2 	= UI.getChildControl( Panel_WorldMap, "Button_Movie_1" ),
	_btn_Movie_3 	= UI.getChildControl( Panel_WorldMap, "Button_Movie_2" ),
	_btn_Movie_4 	= UI.getChildControl( Panel_WorldMap, "Button_Movie_3" ),
}

-- 길드모드에서 필요한 임시 렌더 상태 저장
local _checkState = 
{
	[eCheckState.eCheck_Quest] 		= true,
	[eCheckState.eCheck_Knowledge] 	= true,
	[eCheckState.eCheck_FishnChip] 	= true,
	[eCheckState.eCheck_Node] 		= true,
	[eCheckState.eCheck_Trade] 		= true,
	[eCheckState.eCheck_Way] 		= true,
	[eCheckState.eCheck_Postions] 	= true,
	[eCheckState.eCheck_Wagon] 		= true,
}

local nowExplorePoint = nil
local maxExplorePoint = nil

--{ CBT 일 때는 동영상 무비 가이드 버튼을 노출시키지 않는다!
local countryType = true
if ( getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_CBT ) then
	countryType = false
else
	countryType = true
end
--}

if getEnableSimpleUI() then
	worldMapMovieList._playButton:SetShow(false);
	worldMapMovieList._panel:SetShow(false);
end

worldMapMovieList._playButton:addInputEvent( "Mouse_LUp", "Panel_Worldmap_MovieGuide_Func()" )
worldMapMovieList._btn_Close:addInputEvent( "Mouse_LUp", "Panel_Worldmap_MovieGuide_Close()" )
	
-----------------------------------------------------------------------------------------------
-- 									영상 가이드 전용 함수
-----------------------------------------------------------------------------------------------
function Panel_Worldmap_MovieGuide_Close()
	if ( worldMapMovieList._panel:GetShow() == true ) then
		worldMapMovieList._panel:SetShow( false )
		Panel_MovieTheater640_Initialize()
		Panel_MovieTheater_640:SetShow( false )
		-- FGlobal_Panel_MovieTheater640_WindowClose()
	else
		worldMapMovieList._panel:SetShow( true )
		-- Panel_MovieTheater640_Initialize()
		Panel_MovieTheater_640:SetPosX( getScreenSizeX()/2 - Panel_MovieTheater_640:GetSizeX()/2 )
		Panel_MovieTheater_640:SetPosY( getScreenSizeY()/2 - Panel_MovieTheater_640:GetSizeY()/2 )
		if isGameTypeKorea() or isGameTypeJapan() then
			Panel_MovieTheater640_GameGuide_Func(18)								---------------------- 클래스가 추가되면 숫자 하나씩 증가시켜준다.
		elseif isGameTypeRussia() then
			Panel_MovieTheater640_GameGuide_Func(12)
		elseif isGameTypeEnglish() then
			Panel_MovieTheater640_GameGuide_Func(11)
		end
		worldMapMovieList._panel:SetPosX( Panel_MovieTheater_640:GetPosX() - worldMapMovieList._panel:GetSizeX() - 5 )
		worldMapMovieList._panel:SetPosY( Panel_MovieTheater_640:GetPosY() + Panel_MovieTheater_640:GetSizeY() - worldMapMovieList._panel:GetSizeY())
	end
end

function Panel_Worldmap_MovieGuide_Func()
	worldMapMovieList._panel:SetPosX( 425 )
	worldMapMovieList._panel:SetPosY( 70 )
	if isGameTypeKorea() or isGameTypeJapan() then
		worldMapMovieList._btn_Movie_1:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 18 .. ")" )
		worldMapMovieList._btn_Movie_2:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 19 .. ")" )
		worldMapMovieList._btn_Movie_3:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 22 .. ")" )
		worldMapMovieList._btn_Movie_4:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 27 .. ")" )
	elseif isGameTypeRussia() then
		worldMapMovieList._btn_Movie_1:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 12 .. ")" )
		worldMapMovieList._btn_Movie_2:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 13 .. ")" )
		worldMapMovieList._btn_Movie_3:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 16 .. ")" )
		worldMapMovieList._btn_Movie_4:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 21 .. ")" )
	elseif isGameTypeEnglish() then
		worldMapMovieList._btn_Movie_1:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 11 .. ")" )
		worldMapMovieList._btn_Movie_2:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 12 .. ")" )
		worldMapMovieList._btn_Movie_3:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 15 .. ")" )
		worldMapMovieList._btn_Movie_4:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 20 .. ")" )
	end
	Panel_Worldmap_MovieGuide_Close()
end

function Panel_Worldmap_MovieGuide_Init()
	worldMapMovieList._panel:AddChild ( worldMapMovieList._title 	   )
	worldMapMovieList._panel:AddChild ( worldMapMovieList._btn_Close   )
	worldMapMovieList._panel:AddChild ( worldMapMovieList._panelBG     )
	worldMapMovieList._panel:AddChild ( worldMapMovieList._btn_Movie_1 )
	worldMapMovieList._panel:AddChild ( worldMapMovieList._btn_Movie_2 )
	worldMapMovieList._panel:AddChild ( worldMapMovieList._btn_Movie_3 )
	worldMapMovieList._panel:AddChild ( worldMapMovieList._btn_Movie_4 )
	
	Panel_WorldMap:RemoveControl ( worldMapMovieList._title 	  )
	Panel_WorldMap:RemoveControl ( worldMapMovieList._btn_Close   )
	Panel_WorldMap:RemoveControl ( worldMapMovieList._panelBG     )
	Panel_WorldMap:RemoveControl ( worldMapMovieList._btn_Movie_1 )
	Panel_WorldMap:RemoveControl ( worldMapMovieList._btn_Movie_2 )
	Panel_WorldMap:RemoveControl ( worldMapMovieList._btn_Movie_3 )
	Panel_WorldMap:RemoveControl ( worldMapMovieList._btn_Movie_4 )
	
	if isGameTypeKorea() or isGameTypeJapan() then
		worldMapMovieList._btn_Movie_1:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 18 .. ")" )
		worldMapMovieList._btn_Movie_2:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 19 .. ")" )
		worldMapMovieList._btn_Movie_3:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 22 .. ")" )
		worldMapMovieList._btn_Movie_4:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 27 .. ")" )
	elseif isGameTypeRussia() then
		worldMapMovieList._btn_Movie_1:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 12 .. ")" )
		worldMapMovieList._btn_Movie_2:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 13 .. ")" )
		worldMapMovieList._btn_Movie_3:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 16 .. ")" )
		worldMapMovieList._btn_Movie_4:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 21 .. ")" )
	elseif isGameTypeEnglish() then
		worldMapMovieList._btn_Movie_1:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 11 .. ")" )
		worldMapMovieList._btn_Movie_2:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 12 .. ")" )
		worldMapMovieList._btn_Movie_3:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 15 .. ")" )
		worldMapMovieList._btn_Movie_4:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 20 .. ")" )
	end
	worldMapMovieList._panel:SetPosX( 425 )
	worldMapMovieList._panel:SetPosY( 70 )
	
	--Panel_MovieTheater640_Initialize()

	worldMapMovieList._panel:SetShow( countryType )
	worldMapMovieList._playButton:SetShow( countryType )
	if getEnableSimpleUI() then
		worldMapMovieList._panel:SetShow( false )
		FGlobal_Panel_MovieTheater640_WindowClose()
	end
end

function WorldmapMovieGuide_EnableSimpleUI()
	worldMapMovieList._panel:SetShow( false )
	worldMapMovieList._playButton:SetShow( false );
	FGlobal_Panel_MovieTheater640_WindowClose()
end
function WorldmapMovieGuide_DisableSimpleUI()
	worldMapMovieList._panel:SetShow( countryType )
	worldMapMovieList._playButton:SetShow( countryType );
	--Panel_MovieTheater640_Initialize()
end
registerEvent( "EventSimpleUIEnable",			"WorldmapMovieGuide_EnableSimpleUI")
registerEvent( "EventSimpleUIDisable",			"WorldmapMovieGuide_DisableSimpleUI")


Panel_Worldmap_MovieGuide_Init()
	
local btnCtrl_Exit 			= UI.getChildControl( Panel_WorldMap, "Button_Exit" )
local static_ExOutLine		= UI.getChildControl( Panel_WorldMap, "Static_ExplorePoint_OutLine")
local static_ExBG			= UI.getChildControl( Panel_WorldMap, "Static_ExplorePoint_BG")
local txtCtrl_ExPoint 		= UI.getChildControl( Panel_WorldMap, "StaticText_info_ExplorePoint" )
local progress_ExPoint 		= UI.getChildControl( Panel_WorldMap, "Progress_ExplorePoint" )
local btn_FishEncyclopedia	= UI.getChildControl( Panel_WorldMap, "Button_FishEncyclopedia" )
local btn_DelyveryInfo		= UI.getChildControl( Panel_WorldMap, "Button_DelyveryInfo" )
local btn_ItemMarket		= UI.getChildControl( Panel_WorldMap, "Button_ItemMarket" )
local btn_TradeInfo			= UI.getChildControl( Panel_WorldMap, "Button_TradeEventInfo" )
if (5 == getGameServiceType() or 6 == getGameServiceType()) then
	btn_ItemMarket:SetTextSpan( 30, 8 )
end

local isTradeSupply = 22		-- 황실 납품 컨텐츠 그룹키
if ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, isTradeSupply ) then		-- 황실납품이 열려 있는 곳만 버튼 오픈
	btn_TradeInfo:SetShow( true )
else
	btn_TradeInfo:SetShow( false )
end


btn_FishEncyclopedia:SetShow(false)
local static_ContributeBG	= UI.getChildControl( Panel_WorldMap, "Static_ContributeBG" )

-- 로컬 변수 설정 끝
-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------
-- 컨트롤 이벤트 등록
-----------------------------------------------------------------------------------------------------
-- 렌더 모드 변경
worldMapState[eWorldmapState.eWMS_EXPLORE_PLANT]			:addInputEvent( "Mouse_LUp", "WorldMapStateChange("..eWorldmapState.eWMS_EXPLORE_PLANT..")" )
worldMapState[eWorldmapState.eWMS_REGION]					:addInputEvent( "Mouse_LUp", "WorldMapStateChange("..eWorldmapState.eWMS_REGION..")" )
worldMapState[eWorldmapState.eWMS_LOCATION_INFO_WATER]		:addInputEvent( "Mouse_LUp", "WorldMapStateChange("..eWorldmapState.eWMS_LOCATION_INFO_WATER..")")
worldMapState[eWorldmapState.eWMS_LOCATION_INFO_CELCIUS]	:addInputEvent( "Mouse_LUp", "WorldMapStateChange("..eWorldmapState.eWMS_LOCATION_INFO_CELCIUS..")")
worldMapState[eWorldmapState.eWMS_LOCATION_INFO_HUMIDITY]	:addInputEvent( "Mouse_LUp", "WorldMapStateChange("..eWorldmapState.eWMS_LOCATION_INFO_HUMIDITY..")")
worldMapState[eWorldmapState.eWMS_GUILD_WAR]				:addInputEvent( "Mouse_LUp", "WorldMapStateChange("..eWorldmapState.eWMS_GUILD_WAR..")")

worldMapState[eWorldmapState.eWMS_EXPLORE_PLANT]			:addInputEvent( "Mouse_On",		"WorldMapStateChange_SimpleTooltips(true, 0)")
worldMapState[eWorldmapState.eWMS_EXPLORE_PLANT]			:addInputEvent( "Mouse_Out",	"WorldMapStateChange_SimpleTooltips( false )")
worldMapState[eWorldmapState.eWMS_REGION]					:addInputEvent( "Mouse_On",		"WorldMapStateChange_SimpleTooltips(true, 1)")
worldMapState[eWorldmapState.eWMS_REGION]					:addInputEvent( "Mouse_Out",	"WorldMapStateChange_SimpleTooltips( false )")
worldMapState[eWorldmapState.eWMS_LOCATION_INFO_WATER]		:addInputEvent( "Mouse_On",		"WorldMapStateChange_SimpleTooltips(true, 2)")
worldMapState[eWorldmapState.eWMS_LOCATION_INFO_WATER]		:addInputEvent( "Mouse_Out",	"WorldMapStateChange_SimpleTooltips( false )")
worldMapState[eWorldmapState.eWMS_LOCATION_INFO_CELCIUS]	:addInputEvent( "Mouse_On",		"WorldMapStateChange_SimpleTooltips(true, 3)")
worldMapState[eWorldmapState.eWMS_LOCATION_INFO_CELCIUS]	:addInputEvent( "Mouse_Out",	"WorldMapStateChange_SimpleTooltips( false )")
worldMapState[eWorldmapState.eWMS_LOCATION_INFO_HUMIDITY]	:addInputEvent( "Mouse_On",		"WorldMapStateChange_SimpleTooltips(true, 4)")
worldMapState[eWorldmapState.eWMS_LOCATION_INFO_HUMIDITY]	:addInputEvent( "Mouse_Out",	"WorldMapStateChange_SimpleTooltips( false )")
worldMapState[eWorldmapState.eWMS_GUILD_WAR]				:addInputEvent( "Mouse_On",		"WorldMapStateChange_SimpleTooltips(true, 5)")
worldMapState[eWorldmapState.eWMS_GUILD_WAR]				:addInputEvent( "Mouse_Out",	"WorldMapStateChange_SimpleTooltips( false )")

worldMapState[eWorldmapState.eWMS_EXPLORE_PLANT]			:setTooltipEventRegistFunc( "WorldMapStateChange_SimpleTooltips(true, 0)" )
worldMapState[eWorldmapState.eWMS_REGION]					:setTooltipEventRegistFunc( "WorldMapStateChange_SimpleTooltips(true, 1)" )
worldMapState[eWorldmapState.eWMS_LOCATION_INFO_WATER]		:setTooltipEventRegistFunc( "WorldMapStateChange_SimpleTooltips(true, 2)" )
worldMapState[eWorldmapState.eWMS_LOCATION_INFO_CELCIUS]	:setTooltipEventRegistFunc( "WorldMapStateChange_SimpleTooltips(true, 3)" )
worldMapState[eWorldmapState.eWMS_LOCATION_INFO_HUMIDITY]	:setTooltipEventRegistFunc( "WorldMapStateChange_SimpleTooltips(true, 4)" )
worldMapState[eWorldmapState.eWMS_GUILD_WAR]				:setTooltipEventRegistFunc( "WorldMapStateChange_SimpleTooltips(true, 5)" )

-- 체크 리스트
worldMapCheckList[eCheckState.eCheck_Quest]		:addInputEvent( "Mouse_LUp", "WorldMapCheckListChange("..eCheckState.eCheck_Quest..")")
worldMapCheckList[eCheckState.eCheck_Knowledge]	:addInputEvent( "Mouse_LUp", "WorldMapCheckListChange("..eCheckState.eCheck_Knowledge..")")
worldMapCheckList[eCheckState.eCheck_FishnChip]	:addInputEvent( "Mouse_LUp", "WorldMapCheckListChange("..eCheckState.eCheck_FishnChip..")")
worldMapCheckList[eCheckState.eCheck_Node]		:addInputEvent( "Mouse_LUp", "WorldMapCheckListChange("..eCheckState.eCheck_Node..")")
worldMapCheckList[eCheckState.eCheck_Trade]		:addInputEvent( "Mouse_LUp", "WorldMapCheckListChange("..eCheckState.eCheck_Trade..")")
worldMapCheckList[eCheckState.eCheck_Way]		:addInputEvent( "Mouse_LUp", "WorldMapCheckListChange("..eCheckState.eCheck_Way..")")
worldMapCheckList[eCheckState.eCheck_Postions]	:addInputEvent( "Mouse_LUp", "WorldMapCheckListChange("..eCheckState.eCheck_Postions..")")
worldMapCheckList[eCheckState.eCheck_Wagon]		:addInputEvent( "Mouse_LUp", "WorldMapCheckListChange("..eCheckState.eCheck_Wagon..")")

-- 체크 리스트 툴팁
worldMapCheckList[eCheckState.eCheck_Quest]		:addInputEvent( "Mouse_On", "WorldMapCheckListToolTips( true, 0 )"	)
worldMapCheckList[eCheckState.eCheck_Quest]		:addInputEvent( "Mouse_Out","WorldMapCheckListToolTips( false )"	)
worldMapCheckList[eCheckState.eCheck_Knowledge]	:addInputEvent( "Mouse_On", "WorldMapCheckListToolTips( true, 1 )"	)
worldMapCheckList[eCheckState.eCheck_Knowledge]	:addInputEvent( "Mouse_Out","WorldMapCheckListToolTips( false )"	)
worldMapCheckList[eCheckState.eCheck_FishnChip]	:addInputEvent( "Mouse_On", "WorldMapCheckListToolTips( true, 2 )"	)
worldMapCheckList[eCheckState.eCheck_FishnChip]	:addInputEvent( "Mouse_Out","WorldMapCheckListToolTips( false )"	)
worldMapCheckList[eCheckState.eCheck_Node]		:addInputEvent( "Mouse_On", "WorldMapCheckListToolTips( true, 3 )"	)
worldMapCheckList[eCheckState.eCheck_Node]		:addInputEvent( "Mouse_Out","WorldMapCheckListToolTips( false )"	)
worldMapCheckList[eCheckState.eCheck_Trade]		:addInputEvent( "Mouse_On", "WorldMapCheckListToolTips( true, 4 )"	)
worldMapCheckList[eCheckState.eCheck_Trade]		:addInputEvent( "Mouse_Out","WorldMapCheckListToolTips( false )"	)
worldMapCheckList[eCheckState.eCheck_Way]		:addInputEvent( "Mouse_On", "WorldMapCheckListToolTips( true, 5 )"	)
worldMapCheckList[eCheckState.eCheck_Way]		:addInputEvent( "Mouse_Out","WorldMapCheckListToolTips( false )"	)
worldMapCheckList[eCheckState.eCheck_Postions]	:addInputEvent( "Mouse_On", "WorldMapCheckListToolTips( true, 6 )"	)
worldMapCheckList[eCheckState.eCheck_Postions]	:addInputEvent( "Mouse_Out","WorldMapCheckListToolTips( false )"	)

static_ContributeBG								:addInputEvent( "Mouse_On", "WorldMapCheckListToolTips( true, 7 )"	)
static_ContributeBG								:addInputEvent( "Mouse_Out","WorldMapCheckListToolTips( false )"	)

worldMapCheckList[eCheckState.eCheck_Quest]		:SetDisableColor( true )
worldMapCheckList[eCheckState.eCheck_Knowledge]	:SetDisableColor( true )
worldMapCheckList[eCheckState.eCheck_FishnChip]	:SetDisableColor( true )
worldMapCheckList[eCheckState.eCheck_Node]		:SetDisableColor( true )
worldMapCheckList[eCheckState.eCheck_Trade]		:SetDisableColor( true )
worldMapCheckList[eCheckState.eCheck_Way]		:SetDisableColor( true )
worldMapCheckList[eCheckState.eCheck_Postions]	:SetDisableColor( true )
worldMapCheckList[eCheckState.eCheck_Wagon]		:SetDisableColor( true )

-- 버튼
btnCtrl_Exit			:addInputEvent( "Mouse_LUp", "FromClient_WorldMapPanelClose()" )
-- btn_FishEncyclopedia	:addInputEvent( "Mouse_LUp", "FGlobal_FishEncyclopedia_Open()" )
btn_DelyveryInfo		:addInputEvent( "Mouse_LUp", "DeliveryInformationView_Open()" )
btn_ItemMarket			:addInputEvent( "Mouse_LUp", "FGlobal_handleOpenItemMarket(1)" )	--  지역정보를 쓰나?
btn_TradeInfo			:addInputEvent( "Mouse_LUp", "HandleClicked_TradeEventInfo()" )

-----------------------------------------------------------------------------------------------
-- 월드맵 패널 애니메이션
-----------------------------------------------------------------------------------------------

-- 월드맵 켤 때 애니메이션
Panel_WorldMap:RegisterShowEventFunc( true, 'FGlobal_WorldmapPanelShowAni()' )
Panel_WorldMap:RegisterShowEventFunc( false, 'FGlobal_WorldmapPanelHideAni()' )

function FGlobal_WorldmapPanelShowAni()
	Panel_WorldMap:SetAlpha(0)
	Panel_WorldMap:ResetVertexAni();
	Panel_WorldMap:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)
	local aniInfo = Panel_WorldMap:addColorAnimation( 0.0, 1.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
	aniInfo:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo.IsChangeChild = false
end


--	월드맵 끌 때 애니메이션
function FGlobal_WorldmapPanelHideAni()
	Panel_WorldMap:ResetVertexAni();
	Panel_WorldMap:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)

	local aniInfo = Panel_WorldMap:addColorAnimation( 0.0, 1.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
	aniInfo:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo.IsChangeChild = false
	aniInfo:SetHideAtEnd(true)
	aniInfo:SetDisableWhileAni(true)
	Panel_WorldMap:SetAlpha(0)
end

-- 컨트롤 이벤트 등록 끝
------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------
-- 클라이언트 이벤트 등록

registerEvent("FromClient_WorldMapOpen",	"FromClient_WorldMapPanelOpen" )
registerEvent("FromClient_ExitWorldMap",	"FromClient_WorldMapPanelClose")
registerEvent("FromClient_SetTownMode",		"FromClient_SetTownModeToPanel")
registerEvent("FromClient_resetTownMode",	"FromClient_resetTownModeToPanel")
registerEvent("FromClient_UpdateExplorePointParam",		"FromClient_updateExplorePointParam")

 -- 클라이언트 이벤트 등록 끝
 -----------------------------------------------------------------------------------------------------
 
 -----------------------------------------------------------------------------------------------------
 -- 지역 함수 등록
 
 local setWorldmapCHeckUseAble = function()
	worldMapCheckList[eCheckState.eCheck_Quest]		:SetEnable( true )
	worldMapCheckList[eCheckState.eCheck_Knowledge]	:SetEnable( true )
	worldMapCheckList[eCheckState.eCheck_FishnChip]	:SetEnable( true )
	worldMapCheckList[eCheckState.eCheck_Node]		:SetEnable( true )
	worldMapCheckList[eCheckState.eCheck_Trade]		:SetEnable( true )
	worldMapCheckList[eCheckState.eCheck_Way]		:SetEnable( true )
	worldMapCheckList[eCheckState.eCheck_Postions]	:SetEnable( true )
	worldMapCheckList[eCheckState.eCheck_Wagon]		:SetEnable( true )

	worldMapCheckList[eCheckState.eCheck_Quest]		:SetCheck( ToClient_isWorldmapCheckState(eCheckState.eCheck_Quest		) )
	worldMapCheckList[eCheckState.eCheck_Knowledge]	:SetCheck( ToClient_isWorldmapCheckState(eCheckState.eCheck_Knowledge	) )
	worldMapCheckList[eCheckState.eCheck_FishnChip]	:SetCheck( ToClient_isWorldmapCheckState(eCheckState.eCheck_FishnChip	) )
	worldMapCheckList[eCheckState.eCheck_Node]		:SetCheck( ToClient_isWorldmapCheckState(eCheckState.eCheck_Node		) )
	worldMapCheckList[eCheckState.eCheck_Trade]		:SetCheck( ToClient_isWorldmapCheckState(eCheckState.eCheck_Trade		) )
	worldMapCheckList[eCheckState.eCheck_Way]		:SetCheck( ToClient_isWorldmapCheckState(eCheckState.eCheck_Way			) )
	worldMapCheckList[eCheckState.eCheck_Postions]	:SetCheck( ToClient_isWorldmapCheckState(eCheckState.eCheck_Postions	) )	
	worldMapCheckList[eCheckState.eCheck_Wagon]		:SetCheck( ToClient_isWorldmapCheckState(eCheckState.eCheck_Wagon		) )	
 end

 local setWorldmapCheckDisable = function()
 	worldMapCheckList[eCheckState.eCheck_Quest]		:SetEnable( false )
	worldMapCheckList[eCheckState.eCheck_Knowledge]	:SetEnable( false )
	worldMapCheckList[eCheckState.eCheck_FishnChip]	:SetEnable( false )
	worldMapCheckList[eCheckState.eCheck_Node]		:SetEnable( false )
	worldMapCheckList[eCheckState.eCheck_Trade]		:SetEnable( false )
	worldMapCheckList[eCheckState.eCheck_Way]		:SetEnable( false )
	worldMapCheckList[eCheckState.eCheck_Postions]	:SetEnable( false )
	worldMapCheckList[eCheckState.eCheck_Wagon]		:SetEnable( false )
 end
 
 -----------------------------------------------------------------------------------------------------
 -- 전역 함수 등록
 
--[[
	 @Date 		2014/11/2014
	 @Author 	who1310
	 @Breif 	월드맵의 렌더 상태가 변경 됨
]]--
local WORLDMAP_RENDERTYPE  = CppEnums.WorldMapState
local _currentRenderMode = WORLDMAP_RENDERTYPE.eWMS_EXPLORE_PLANT
local _isGuildWarMode = false;

function FGlobal_resetGuildWarMode()
	_isGuildWarMode = false;
end

function FGlobal_isGuildWarMode()
	return _isGuildWarMode;
end

function WorldMapStateChange( state )
	
	if( WORLDMAP_RENDERTYPE.eWMS_EXPLORE_PLANT == state ) then
		setWorldmapCHeckUseAble();
		_isGuildWarMode = false;
		if( _currentRenderMode == state ) then
			ToClient_SetGuildMode( _isGuildWarMode )
			handleGuildModeChange( _isGuildWarMode )
		end
	elseif( WORLDMAP_RENDERTYPE.eWMS_GUILD_WAR == state ) then
		setWorldmapCHeckUseAble();
		_isGuildWarMode = true;
		state = WORLDMAP_RENDERTYPE.eWMS_EXPLORE_PLANT;

		if( _currentRenderMode == state ) then
			ToClient_SetGuildMode( _isGuildWarMode )
			handleGuildModeChange( _isGuildWarMode )
		end
	else
		setWorldmapCheckDisable()
--	elseif( WORLDMAP_RENDERTYPE.eWMS_REGION == state ) then
--	elseif( WORLDMAP_RENDERTYPE.eWMS_LOCATION_INFO_WATER == state ) then
--	elseif( WORLDMAP_RENDERTYPE.eWMS_LOCATION_INFO_CELCIUS == state ) then
--	elseif( WORLDMAP_RENDERTYPE.eWMS_LOCATION_INFO_HUMIDITY == state ) then
	end
	_currentRenderMode = state;
	ToClient_WorldmapStateChange( state )
end

--[[
	@Date		2015/04/24
	@Author		who1310
	@Breif		길드 모드 변경 될 시에, 렌더 상태 변경
]]--
function handleGuildModeChange( isGuildMode )
	ToClient_reloadNodeLine(isGuildMode, WaypointKeyUndefined)
	if( isGuildMode ) then
		ToClient_worldmapNodeMangerSetShow(true)
		ToClient_worldmapBuildingManagerSetShow(false)
		ToClient_worldmapQuestManagerSetShow(false)
		ToClient_worldmapGuideLineSetShow(false)
		ToClient_worldmapDeliverySetShow(false)
		--ToClient_worldmapTerritoryManagerSetShow(false)
		ToClient_worldmapActorManagerSetShow(false)
		ToClient_worldmapPinSetShow(true)
		ToClient_worldmapExceptionLifeKnowledgeSetShow(false, WaypointKeyUndefined)
		ToClient_worldmapLifeKnowledgeSetShow(false, WaypointKeyUndefined)		
		ToClient_worldmapTradeNpcSetShow(false, WaypointKeyUndefined)
	else
		ToClient_worldmapNodeMangerSetShow(_checkState[eCheckState.eCheck_Node])
		ToClient_worldmapBuildingManagerSetShow(true)
		ToClient_worldmapQuestManagerSetShow(_checkState[eCheckState.eCheck_Quest])
		ToClient_worldmapGuideLineSetShow(_checkState[eCheckState.eCheck_Way])
		ToClient_worldmapDeliverySetShow(_checkState[eCheckState.eCheck_Wagon])
		--ToClient_worldmapTerritoryManagerSetShow(true)
		ToClient_worldmapActorManagerSetShow(_checkState[eCheckState.eCheck_Postions])
		ToClient_worldmapPinSetShow(_checkState[eCheckState.eCheck_Postions])
		ToClient_worldmapExceptionLifeKnowledgeSetShow(_checkState[eCheckState.eCheck_Knowledge], WaypointKeyUndefined)
		ToClient_worldmapLifeKnowledgeSetShow(_checkState[eCheckState.eCheck_FishnChip], WaypointKeyUndefined)		
		ToClient_worldmapTradeNpcSetShow(_checkState[eCheckState.eCheck_Trade], WaypointKeyUndefined)
	end

end

--[[
	@Date		2015/04/16
	@Author		goni
	@Breif		월드맵의 상태 변경 버튼 툴팁
]]--

function WorldMapStateChange_SimpleTooltips( isShow, tipType )
	local name, desc, control = nil, nil, nil

	if 0 == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_PLANT_NAME") -- "일반 정보"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_PLANT_DESC") -- "탐험한 지역과 거점 및 의뢰 그리고 지식 정보가 표시됩니다."
		control = worldMapState[eWorldmapState.eWMS_EXPLORE_PLANT]
	elseif 1 == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_REGION_NAME") -- "영지 자원 정보"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_REGION_DESC") -- "영지 지역별 자원 및 민심의 정보가 막대로 표시됩니다."
		control = worldMapState[eWorldmapState.eWMS_REGION]
	elseif 2 == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_WATER_NAME") -- "지하수 정보"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_WATER_DESC") -- "땅 밑에 매장되어 있는 지하수량의 범위를 표시합니다."
		control = worldMapState[eWorldmapState.eWMS_LOCATION_INFO_WATER]
	elseif 3 == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_CELCIUS_NAME") -- 온도 정보"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_CELCIUS_DESC") -- 각 지역의 온도차를 범위화하여 표시합니다."
		control = worldMapState[eWorldmapState.eWMS_LOCATION_INFO_CELCIUS]
	elseif 4 == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_HUMIDITY_NAME") -- "습도 정보"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_HUMIDITY_DESC") -- "각 지역의 습도량을 범위화하여 표시합니다."
		control = worldMapState[eWorldmapState.eWMS_LOCATION_INFO_HUMIDITY]
	elseif 5 == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_GUILDWAR_NAME") -- "거점전 정보"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_GUILDWAR_DESC") -- "거점전 가능한 지역의 거점 점령 현황을 표시합니다."
		control = worldMapState[eWorldmapState.eWMS_GUILD_WAR]
	end

	if isShow == true then
		registTooltipControl(control, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end

end

--[[
	 @Date 		2014/11/2014
	 @Author 	who1310
	 @Breif 		월드맵의 Check 상태 변경
]]--
function WorldMapCheckListChange( checkState )
	-- _PA_LOG("최대호", tostring( checkState ) )
	ToClient_WorldmapCheckState(checkState, worldMapCheckList[checkState]:IsCheck() )
	_checkState[checkState]	= worldMapCheckList[checkState]:IsCheck();
end

function FromClient_SetTownModeToPanel()
	setWorldmapCheckDisable()
	FGlobal_SetShowCheckBox( false );
	FromClient_WorldMap_HouseNaviShow(true)
	FGlobal_AlignExplorePointInfo()
	currentTownMode = true
end

function FromClient_resetTownModeToPanel()
	setWorldmapCHeckUseAble()
	FGlobal_SetShowCheckBox( true );
	FromClient_WorldMap_HouseNaviShow(false)
	FGlobal_AlignExplorePointInfo()
end

function FGlobal_handleOpenItemMarket( territoryKey )
	WorldMapPopupManager:push( Panel_Window_ItemMarket, true );
	FGlobal_ItemMarket_Open_ForWorldMap(1)	
end

function HandleClicked_TradeEventInfo()
	WorldMapPopupManager:increaseLayer(true)
	WorldMapPopupManager:push( Panel_TradeMarket_EventInfo, true )
	TradeEventInfo_Set()
end

-- 전역 함수 끝
-------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------
-- 클라이언트 호출 함수 등록
--
function FromClient_updateExplorePointParam( explorePoint )
	if( nil == explorePoint ) then
		txtCtrl_ExPoint:SetText("");
		progress_ExPoint:SetProgressRate(0);
	end
	
	nowExplorePoint = explorePoint:getRemainedPoint()
	maxExplorePoint = explorePoint:getAquiredPoint()
	local explorePointPercent = nowExplorePoint / maxExplorePoint * 100
	txtCtrl_ExPoint:SetText( PAGetString( Defines.StringSheet_GAME, "MAINSTATUS_CONTRIBUTE" ) .. " " .. nowExplorePoint .. " / " .. maxExplorePoint)
	progress_ExPoint:SetProgressRate( explorePointPercent );
end

--[[
	 @Date 		2014/11/2014
	 @Author 	who1310
	 @Breif		클라이언트에서 월드맵이 열렸을때 호출된다
]]--
function FromClient_WorldMapPanelOpen()
	Panel_WorldMap:SetShow( true );
	setWorldmapCHeckUseAble();
	worldMapState[eWorldmapState.eWMS_EXPLORE_PLANT]:SetCheck(true)
	worldMapState[eWorldmapState.eWMS_REGION]:SetCheck(false)
	worldMapState[eWorldmapState.eWMS_LOCATION_INFO_WATER]:SetCheck(false)
	worldMapState[eWorldmapState.eWMS_LOCATION_INFO_CELCIUS]:SetCheck(false)
	worldMapState[eWorldmapState.eWMS_LOCATION_INFO_HUMIDITY]:SetCheck(false)
	worldMapState[eWorldmapState.eWMS_GUILD_WAR]:SetCheck(false)

	worldMapCheckList[eCheckState.eCheck_Quest]		:SetCheck( ToClient_isWorldmapCheckState(eCheckState.eCheck_Quest		) )
	worldMapCheckList[eCheckState.eCheck_Knowledge]	:SetCheck( ToClient_isWorldmapCheckState(eCheckState.eCheck_Knowledge	) )
	worldMapCheckList[eCheckState.eCheck_FishnChip]	:SetCheck( ToClient_isWorldmapCheckState(eCheckState.eCheck_FishnChip	) )
	worldMapCheckList[eCheckState.eCheck_Node]		:SetCheck( ToClient_isWorldmapCheckState(eCheckState.eCheck_Node		) )
	worldMapCheckList[eCheckState.eCheck_Trade]		:SetCheck( ToClient_isWorldmapCheckState(eCheckState.eCheck_Trade		) )
	worldMapCheckList[eCheckState.eCheck_Way]		:SetCheck( ToClient_isWorldmapCheckState(eCheckState.eCheck_Way			) )
	worldMapCheckList[eCheckState.eCheck_Postions]	:SetCheck( ToClient_isWorldmapCheckState(eCheckState.eCheck_Postions	) )
	worldMapCheckList[eCheckState.eCheck_Wagon]		:SetCheck( ToClient_isWorldmapCheckState(eCheckState.eCheck_Wagon		) )

	_checkState[eCheckState.eCheck_Quest]			=	ToClient_isWorldmapCheckState(eCheckState.eCheck_Quest		)
	_checkState[eCheckState.eCheck_Knowledge]		=	ToClient_isWorldmapCheckState(eCheckState.eCheck_Knowledge	)
	_checkState[eCheckState.eCheck_FishnChip]		=	ToClient_isWorldmapCheckState(eCheckState.eCheck_FishnChip	)
	_checkState[eCheckState.eCheck_Node]			=	ToClient_isWorldmapCheckState(eCheckState.eCheck_Node		)
	_checkState[eCheckState.eCheck_Trade]			=	ToClient_isWorldmapCheckState(eCheckState.eCheck_Trade		)
	_checkState[eCheckState.eCheck_Way]				=	ToClient_isWorldmapCheckState(eCheckState.eCheck_Way		)
	_checkState[eCheckState.eCheck_Postions]		=	ToClient_isWorldmapCheckState(eCheckState.eCheck_Postions	)
	_checkState[eCheckState.eCheck_Wagon]			=	ToClient_isWorldmapCheckState(eCheckState.eCheck_Wagon		)
	
	btnCtrl_Exit:SetSpanSize( Panel_WorldMap:GetSizeX() - getScreenSizeX() + 6, Panel_WorldMap:GetSizeY() - getScreenSizeY() + 6 )
	FGlobal_SetShowCheckBox(true)
	FGlobal_AlignExplorePointInfo()
	worldMapMovieList._panel:SetShow( false )
	worldMapMovieList._playButton:SetSpanSize( getScreenSizeX() - 110, 10 )
end

--[[
	 @Date 		2014/11/2014
	 @Author 	who1310
	 @Breif		클라이언트에서 월드맵이 닫혔을때 호출된다
]]--

function FromClient_WorldMapPanelClose()
	if true == currentTownMode then		-- 타운모드일때는 타운모드만 닫기
		FGlobal_CloseNodeMenu()
		currentTownMode = false
	else
		-- if true == Panel_Window_ItemMarket:GetShow() then	-- 아이템 거래소 켜있다면 끄기
		-- 	FGolbal_ItemMarket_Close()
		-- end
		--Panel_WorldMap:SetShow(false)
		FromClient_ExitWorldMap()
	end
end


--[[
	@Dat3		2014/12/32
	@Author		who1310
	@Brief		체크 박스를 켜고 끈다
]]--
function FGlobal_SetShowCheckBox( isShow )
	checkBoxBG:SetShow( isShow )
	for i, checkBox in pairs( worldMapCheckList ) do
		checkBox:SetShow( isShow )	
	end
end

function FGlobal_AlignExplorePointInfo()
	local baseCtrl = nil
	if( checkBoxBG:GetShow() ) then
		baseCtrl = checkBoxBG
	else
		baseCtrl = Panel_NodeHouseFilter
	end
	

	static_ContributeBG:SetPosX( baseCtrl:GetSizeX() + 10 )
	local basePosX = static_ContributeBG:GetPosX();

	txtCtrl_ExPoint:SetPosX( basePosX + 20 )
	basePos = txtCtrl_ExPoint:GetTextSizeX() + basePosX + 20
	static_ExOutLine:SetPosX( basePos + 10 )
	static_ExBG:SetPosX( basePos + 11 )
	progress_ExPoint:SetPosX( basePos + 12 )
	
	local size = progress_ExPoint:GetPosX() - static_ContributeBG:GetPosX() + progress_ExPoint:GetSizeX() + 12 + 20;
	static_ContributeBG:SetSize( size, static_ContributeBG:GetSizeY() )
end


function WorldMapCheckListToolTips( isShow, checkType )
	local _contributeBubbleText = ""
	local _contributeUsePoint =
	{
		[0] = PAGetString( Defines.StringSheet_GAME, "LUA_EXPGUAGE_CONTRIBUTE_VALUE_1" ),	--"집 구입",
		[1] = PAGetString( Defines.StringSheet_GAME, "LUA_EXPGUAGE_CONTRIBUTE_VALUE_2" ),	--"거점 투자",
		[2] = PAGetString( Defines.StringSheet_GAME, "LUA_EXPGUAGE_CONTRIBUTE_VALUE_3" )	--"아이템 대여"
	}

	for i = 0, 2 do
		if 0 < ToClient_UsedExplorePoint(i) then
			if ( "" == _contributeBubbleText ) then
				_contributeBubbleText = _contributeUsePoint[i] .. " " .. ToClient_UsedExplorePoint(i)
			else
				_contributeBubbleText = _contributeBubbleText .. " | " .. _contributeUsePoint[i] .. " " .. ToClient_UsedExplorePoint(i)
			end
		end
	end
	
	if ( "" == _contributeBubbleText ) then
		if (7 == getGameServiceType() or 8 == getGameServiceType()) then
			country_RU = "\n<PAColor0xFFFAECB6>" .. PAGetString( Defines.StringSheet_GAME, "MAINSTATUS_CONTRIBUTE" ) .. " " .. nowExplorePoint .. " / " .. maxExplorePoint .. "<PAOldColor>\n"
			_contributeBubbleText = country_RU .. PAGetString( Defines.StringSheet_GAME, "LUA_EXPGUAGE_CONTRIBUTE_VALUE_4" )
		else
			_contributeBubbleText = PAGetString( Defines.StringSheet_GAME, "LUA_EXPGUAGE_CONTRIBUTE_VALUE_4" )
		end
	else
		if (7 == getGameServiceType() or 8 == getGameServiceType()) then
			country_RU = "\n<PAColor0xFFFAECB6>" .. PAGetString( Defines.StringSheet_GAME, "MAINSTATUS_CONTRIBUTE" ) .. " " .. nowExplorePoint .. " / " .. maxExplorePoint .. "<PAOldColor>\n"
			_contributeBubbleText = country_RU .. PAGetStringParam1( Defines.StringSheet_GAME, "LUA_EXPGUAGE_CONTRIBUTE_VALUE_5", "_contributeBubbleText", _contributeBubbleText )
		else
			_contributeBubbleText = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_EXPGUAGE_CONTRIBUTE_VALUE_5", "_contributeBubbleText", _contributeBubbleText )
		end
	end

	if checkType == 0 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_QUEST_NAME") -- "의뢰"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_QUEST_DESC") -- "월드맵에서의 의뢰 지역 정보를 켜고 끌 수 있습니다."
		uiControl = worldMapCheckList[eCheckState.eCheck_Quest]
	elseif checkType == 1 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_KNOWLEDGE_NAME") -- "지식"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_KNOWLEDGE_DESC") -- "월드맵에서의 지식, NPC 위치를 켜고 끌 수 있습니다."
		uiControl = worldMapCheckList[eCheckState.eCheck_Knowledge]
	elseif checkType == 2 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_FISH_NAME") -- "낚시/채집 지식"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_FISH_DESC") -- "월드맵에서의 낚시/채집 지식 위치를 켜고 끌 수 있습니다."
		uiControl = worldMapCheckList[eCheckState.eCheck_FishnChip]
	elseif checkType == 3 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_NODE_NAME") -- "거점"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_NODE_DESC") -- "월드맵에서의 거점 연결 지역 위치를 켜고 끌 수 있습니다."
		uiControl = worldMapCheckList[eCheckState.eCheck_Node]
	elseif checkType == 4 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_TRADE_NAME") -- "무역"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_TRADE_DESC") -- "월드맵에서의 무역 정보를 켜고 끌 수 있습니다."
		uiControl = worldMapCheckList[eCheckState.eCheck_Trade]
	elseif checkType == 5 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_DIRECTION_NAME") -- "방향 정보"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_DIRECTION_DESC") -- "월드맵에서의 방향 정보를 켜고 끌 수 있습니다."
		uiControl = worldMapCheckList[eCheckState.eCheck_Way]
	elseif checkType == 6 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_WHERE_NAME") -- "위치 아이콘"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_WHERE_DESC") -- "월드맵에서의 도적, 탑승물 등의 위치 정보를 켜고 끌 수 있습니다."
		uiControl = worldMapCheckList[eCheckState.eCheck_Postions]
	elseif checkType == 7 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_CONTRIBUT_NAME") -- "공헌도"
		desc = PAGetString( Defines.StringSheet_GAME,  "MAINSTATUS_DESC_EXPLORE" ) .. "\n" .. _contributeBubbleText
		uiControl = static_ContributeBG
	end

	if true == isShow then
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end
end
