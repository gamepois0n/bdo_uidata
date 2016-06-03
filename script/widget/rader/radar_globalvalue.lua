local raderText						= UI.getChildControl( Panel_Radar,		"StaticText_raderText" )
local radar_Background				= UI.getChildControl( Panel_Radar, 		"rader_background" )
local radar_SizeSlider				= UI.getChildControl( Panel_Radar, 		"Slider_MapSize" )
local radar_SizeBtn					= UI.getChildControl( radar_SizeSlider, "Slider_MapSize_Btn" )
local radar_AlphaScrl				= UI.getChildControl( Panel_Radar, 		"Slider_RadarAlpha" )
local radar_AlphaBtn				= UI.getChildControl( radar_AlphaScrl,	"RadarAlpha_CtrlBtn" )
local radar_OverName				= UI.getChildControl( Panel_Radar, 		"Static_OverName" )
local radar_MiniMapScl				= UI.getChildControl( Panel_Radar, 		"Button_SizeControl") 

radar_Background:SetShowAALineList(true);
radar_Background:SetColorShowAALineList( float4( 1.0, 1.0, 1.0, 1.0 ) );

radarMap =
{
	config =
	{
		constMapRadius = 60,		-- 변경하지 말것
		mapRadius = 60,				-- RadarMap 에 표시할 World 영역의 반지름을 뜻한다. 단위는 M. 반지름이 50M 이므로, 지름은 100M 이다.
		mapRadiusByPixel = 80		-- RadarMap 의 rader_background 컨트롤에 있는 원 부분의 반지름 크기를 의미한다.
	},
	controls =
	{
		rader_Background				= UI.getChildControl(Panel_Radar, "rader_background"),
		icon_SelfPlayer					= UI.getChildControl(Panel_Radar, "icon_selfPlayer"),
		timeNum							= UI.getChildControl(Panel_TimeBarNumber, "timeNum"),
		
		rader_Plus						= UI.getChildControl(radar_SizeSlider, "Button_RaderViewModePlus"),
		rader_Minus						= UI.getChildControl(radar_SizeSlider, "Button_RaderViewModeMinus"),
		
		rader_AlphaPlus					= UI.getChildControl(radar_AlphaScrl, "Button_AlphaPlus"),
		rader_AlphaMinus				= UI.getChildControl(radar_AlphaScrl, "Button_AlphaMinus"),
		
		rader_Reset						= UI.getChildControl(Panel_Radar, "Button_RaderViewModeReset"),
		rader_NpcFind_Toggle			= UI.getChildControl(Panel_Radar, "Button_NpcFind_Toggle"),
		rader_Close 					= UI.getChildControl(Panel_Radar, "Button_Win_Close" ),
	},
	template =
	{
		icon_Player						= UI.getChildControl(Panel_Radar, "icon_player"),
		icon_Party						= UI.getChildControl(Panel_Radar, "icon_partyMember"),
		icon_Guild						= UI.getChildControl(Panel_Radar, "icon_guildMember"),

		icon_Horse						= UI.getChildControl(Panel_Radar, "icon_horse"),
		icon_DeadBody					= UI.getChildControl(Panel_Radar, "icon_deadbody"),

		icon_Monster_general_normal		= UI.getChildControl(Panel_Radar, "icon_monsterGeneral_normal"),
		icon_Monster_general_quest		= UI.getChildControl(Panel_Radar, "icon_monsterGeneral_quest"),
		icon_Monster_named_normal		= UI.getChildControl(Panel_Radar, "icon_monsterNamed_normal"),
		icon_Monster_named_quest		= UI.getChildControl(Panel_Radar, "icon_monsterNamed_quest"),
		icon_Monster_boss_normal		= UI.getChildControl(Panel_Radar, "icon_monsterBoss_normal"),
		icon_Monster_boss_quest			= UI.getChildControl(Panel_Radar, "icon_monsterBoss_quest"),

		icon_Quest_acceptable			= UI.getChildControl( Panel_Radar, "icon_quest_accept"),
		icon_Quest_cleared				= UI.getChildControl( Panel_Radar, "icon_quest_clear"),

		icon_NPC_lordManager			= UI.getChildControl( Panel_Radar, "icon_npc_lordManager"),	
		icon_NPC_trainner				= UI.getChildControl( Panel_Radar, "icon_npc_skillTrainner"),		
		radorType_tradeMerchantNpc		= UI.getChildControl( Panel_Radar, "icon_npc_trader"),     	-- 사용하나?
		radorType_nodeManager			= UI.getChildControl( Panel_Radar, "icon_npc_nodeManager"), -- 사용하나?
		icon_NPC_talkable				= UI.getChildControl( Panel_Radar, "icon_npc_general"),		 		
		icon_NPC_garage					= UI.getChildControl( Panel_Radar, "icon_npc_warehouse"),			
		icon_NPC_liquidStore			= UI.getChildControl( Panel_Radar, "icon_npc_potion"),		 		
		icon_NPC_weaponStore			= UI.getChildControl( Panel_Radar, "icon_npc_storeArmor"),
		icon_NPC_armorStore				= UI.getChildControl( Panel_Radar, "icon_npc_storeArmor"),
		icon_NPC_horseStable			= UI.getChildControl( Panel_Radar, "icon_npc_horse"),		 		
		radorType_workerNpc				= UI.getChildControl( Panel_Radar, "icon_npc_worker"),		-- 사용하나? 		
		radorType_jewelNpc				= UI.getChildControl( Panel_Radar, "icon_npc_jewel"),		-- 사용하나? 		
		radorType_furnitureNpc			= UI.getChildControl( Panel_Radar, "icon_npc_furniture"),	-- 사용하나?
		icon_NPC_product				= UI.getChildControl( Panel_Radar, "icon_npc_collect"),		 		
		radorType_shipNpc				= UI.getChildControl( Panel_Radar, "icon_npc_ship"),		-- 사용하나?	
		radorType_alchemyNpc			= UI.getChildControl( Panel_Radar, "icon_npc_alchemy"),		-- 사용하나?
		radorType_fishNpc				= UI.getChildControl( Panel_Radar, "icon_npc_fish"),		-- 사용하나?
		
		icon_NPC_itemRepairer			= UI.getChildControl(Panel_Radar, "icon_npc_repairer"),

		icon_NPC_unknown				= UI.getChildControl(Panel_Radar, "icon_npc_unknown"),
		
		icon_PIN_Party					= UI.getChildControl(Panel_Radar, "icon_pin_Party"),
		icon_PIN_PartyMine				= UI.getChildControl(Panel_Radar, "icon_pin_PartyMine"),		
		
		icon_PIN_Guild					= UI.getChildControl(Panel_Radar, "icon_pin_Guild"),
		icon_PIN_GuildMine				= UI.getChildControl(Panel_Radar, "icon_pin_GuildMine"),
		icon_PIN_GuildMaster			= UI.getChildControl(Panel_Radar, "icon_pin_GuildMaster"),
		
		pin_guideArrow					= UI.getChildControl(Panel_Radar, "pin_area_guided"),

		area_quest						= UI.getChildControl(Panel_Radar, "quest_area"),
		area_quest_guideArrow			= UI.getChildControl(Panel_Radar, "quest_area_guided"),	
		
	},	
	pcInfo =
	{
		position =
		{						-- 매 프레임 갱신 된다. PC 의 World Position
			x = 0,
			y = 0,
			z = 0
		},
		s64_teamNo = Defines.s64_const.s64_m1
	},
	worldDistanceToPixelRate = 1,	-- 월드 좌표 -> Pixel 배율. 초기화시에 계산된다.
	pcPosBaseControl =
	{						-- PC 아이콘의 중점에 대한 Panel 기준 위치이다. 초기화 시에 계산된다.
		x = 0,
		y = 0
	},
	actorIcons = {},
	monsterIcons = {},
	iconPool = Array.new(),
	iconCreateCount = 0,
	areaQuests = {},
	questIconPool = Array.new(),
	questCreateCount = 0,
	regionTypeValue = CppEnums.RegionType.eRegionType_MinorTown,
	scaleRateWidth = 1.0,
	scaleRateHeight = 1.0,
	isRotateMode = false
}

-- 레이더 관련 인터페이스
-- 튜토리얼로 미니맵 오픈될 때 이펙트 부여
function FGlobal_Panel_Radar_Show_AddEffect()
	Panel_Radar:SetShow( true )
	radar_Background:AddEffect("UI_Tuto_MiniMap_1", false, 0, 0)
	radar_Background:AddEffect("fUI_Tuto_MiniMap_01A", false, 0, 0)
end

function FGlobal_Panel_Radar_Show( isShow )
	Panel_Radar:SetShow( isShow )
end

function FGlobal_Panel_Radar_GetShow()
	return Panel_Radar:GetShow()
end

function FGlobal_Panel_Radar_GetSizeX()
	return Panel_Radar:GetSizeX()
end

function FGlobal_Panel_Radar_GetSizeY()
	return Panel_Radar:GetSizeY()
end

function FGlobal_Panel_Radar_GetSpanSizeX()
	return Panel_Radar:GetSpanSize().x
end

function FGlobal_Panel_Radar_GetSpanSizeY()
	return Panel_Radar:GetSpanSize().y
end

function FGlobal_Panel_Radar_GetPosX()
	return Panel_Radar:GetPosX()
end

function FGlobal_Panel_Radar_GetPosY()
	return Panel_Radar:GetPosY()
end

function FGlobal_Panel_Radar_Movable_UI()
	
	local raderText = UI.getChildControl ( Panel_Radar,					"StaticText_raderText" )

	raderText:SetShow( false )
	Panel_Radar:SetIgnore( false )
	Panel_Radar:SetDragEnable( true )
	Panel_Radar:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_isWidget.dds" )
	-- local x1, y1, x2, y2 = setTextureUV_Func( Panel_Radar, 202, 0, 402, 256 )
	-- Panel_Radar:getBaseTexture():setUV(  x1, y1, x2, y2  )
	-- Panel_Radar:setRenderTexture(Panel_Radar:getBaseTexture())

	RadarMap_SetDragMode(true)
	
end
	
	
function FGlobal_Panel_Radar_Movable_UI_Cancel()
	
	local raderText = UI.getChildControl ( Panel_Radar,					"StaticText_raderText" )
	
	raderText:SetShow( false )
	Panel_Radar:SetIgnore( true )
	Panel_Radar:SetDragEnable( false )
	Panel_Radar:ChangeTextureInfoName( "New_UI_Common_forLua/Default/Default_Etc_00.dds" )
	local x1, y1, x2, y2 = setTextureUV_Func( Panel_Radar, 102, 60, 110, 68 )
	Panel_Radar:getBaseTexture():setUV(  x1, y1, x2, y2  )
	Panel_Radar:setRenderTexture(Panel_Radar:getBaseTexture())
	
	RadarMap_SetDragMode(false)
end	
