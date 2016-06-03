-----------------------------------------------------------
-- Local 변수 설정
-----------------------------------------------------------
local UI_PUCT 		= CppEnums.PA_UI_CONTROL_TYPE
local UI_color 		= Defines.Color

Panel_Win_Worldmap_NodeWarInfo:SetShow( false )

local nodeWarInfoUIPool = {
}

local toolTip			= UI.getChildControl(Panel_Win_Worldmap_NodeWarInfo, "StaticText_Help")
local ingTentIcon		= UI.getChildControl(Panel_Win_Worldmap_NodeWarInfo, "Static_NodeWar_Ing_Icon")
local endTentIcon		= UI.getChildControl(Panel_Win_Worldmap_NodeWarInfo, "Static_NodeWar_EndCount_Icon")
local closeBTN			= UI.getChildControl(Panel_Win_Worldmap_NodeWarInfo, "Button_Win_Close")

toolTip:SetShow( false )
toolTip:SetAutoResize( true )
toolTip:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )


ingTentIcon:addInputEvent("Mouse_On", "NodeWarScoreIconToolTip( true, \"find\")")
ingTentIcon:addInputEvent("Mouse_Out", "NodeWarScoreIconToolTip( false )")
endTentIcon:addInputEvent("Mouse_On", "NodeWarScoreIconToolTip( true, \"all\" )")
endTentIcon:addInputEvent("Mouse_Out", "NodeWarScoreIconToolTip( false )")
-- closeBTN:addInputEvent("Mouse_LUp", "FGlobal_WarInfo_Close()")

local _buttonQuestion	= UI.getChildControl( Panel_Win_Worldmap_NodeWarInfo, "Button_Question" )					--물음표 버튼
_buttonQuestion			: addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"WarInfo\" )" )			--물음표 좌클릭
_buttonQuestion			: addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"WarInfo\", \"true\")" )		--물음표 마우스오버
_buttonQuestion			: addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"WarInfo\", \"false\")" )	--물음표 마우스아웃

function NodeWarScoreIconToolTip( show, value )
	if true == show then
		if "find" == value then
			toolTip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_NODEWARINFO_TOOLTIP_ING") ) -- 해당 영지에서 <PAColor0xffed6363>진행중인 거점전 수<PAOldColor>
			toolTip:SetPosX( ingTentIcon:GetPosX() - toolTip:GetTextSizeX() )
			toolTip:SetPosY( ingTentIcon:GetPosY() - toolTip:GetSizeY() )
			toolTip:SetShow( true )
		else
			toolTip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_NODEWARINFO_TOOLTIP_END") ) -- 해당 영지에서 <PAColor0xffed6363>종료된 거점전 수<PAOldColor>
			toolTip:SetPosX( endTentIcon:GetPosX() - toolTip:GetTextSizeX() )
			toolTip:SetPosY( endTentIcon:GetPosY() - toolTip:GetSizeY() )
			toolTip:SetShow( true )
		end
	else
		toolTip:SetShow( false )
	end
end

local Templete	= {
	nodeWar_Name			= UI.getChildControl(Panel_Win_Worldmap_NodeWarInfo, "StaticText_NodeWar_Name"),
	nodeWar_IngCount		= UI.getChildControl(Panel_Win_Worldmap_NodeWarInfo, "StaticText_NodeWar_IngCount"),
	nodeWar_EndCount		= UI.getChildControl(Panel_Win_Worldmap_NodeWarInfo, "StaticText_NodeWar_EndCount"),
}

local nodeWar_NamePosY	= Templete.nodeWar_Name:GetPosY()
local nodeWar_CountPosY	= Templete.nodeWar_EndCount:GetPosY()

local siegeIcon = {
	[0] = {19, 170, 51, 202},	-- 점령전 안함(어두움)
	[1] = {154, 219, 185, 250}	-- 점령전 중
}
local chanege_SiegeIcon = function( control, isBattle )
	if 0 == isBattle then
		control:ChangeTextureInfoName ( "new_ui_common_forlua/default/default_etc_01.dds" )
	else
		control:ChangeTextureInfoName ( "new_ui_common_forlua/default/default_etc_00.dds" )
	end
	
	local x1, y1, x2, y2 = setTextureUV_Func( control, siegeIcon[isBattle][1], siegeIcon[isBattle][2], siegeIcon[isBattle][3], siegeIcon[isBattle][4] )
	control:getBaseTexture():setUV(  x1, y1, x2, y2  )
	control:setRenderTexture(control:getBaseTexture())
end

local NodeWarInfo_Init = function()
	local line_gap = 5
	local territoryCount = getTerritoryListByAll()
	if nil == territoryCount then
		return
	end

	for territory_idx = 0, territoryCount -1 do
		local territoryKey			= getTerritoryByIndex( territory_idx )
		local territoryName			= getTerritoryNameByKey( territoryKey )	-- 영지 이름

		if ( nil ~= territoryKey ) then
			local territoryDATA = {}
			-- 이름 생성
			territoryDATA.Name = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_Win_Worldmap_NodeWarInfo, "StaticText_NodeWar_Name_" .. territory_idx)
			CopyBaseProperty(Templete.nodeWar_Name, territoryDATA.Name)
			territoryDATA.Name:SetShow( true )
			territoryDATA.Name:SetPosY( nodeWar_NamePosY )
			territoryDATA.Name:SetText( territoryName )
			chanege_SiegeIcon( territoryDATA.Name, 0 )

			-- 거점전 진행 중
			territoryDATA.IngCount = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_Win_Worldmap_NodeWarInfo, "StaticText_NodeWar_IngCount_" .. territory_idx)
			CopyBaseProperty(Templete.nodeWar_IngCount, territoryDATA.IngCount)
			territoryDATA.IngCount:SetShow( true )
			territoryDATA.IngCount:SetPosY( nodeWar_CountPosY )

			-- 거점전 종료 됨
			territoryDATA.EndCount = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_Win_Worldmap_NodeWarInfo, "StaticText_NodeWar_EndCount_" .. territory_idx)
			CopyBaseProperty(Templete.nodeWar_EndCount, territoryDATA.EndCount)
			territoryDATA.EndCount:SetShow( true )
			territoryDATA.EndCount:SetPosY( nodeWar_CountPosY )

			nodeWar_NamePosY	= nodeWar_NamePosY + territoryDATA.Name:GetSizeY() + 5 + line_gap
			nodeWar_CountPosY	= nodeWar_CountPosY + territoryDATA.IngCount:GetSizeY() + line_gap

			-- Pool에 저장
			nodeWarInfoUIPool[territory_idx] = territoryDATA
		end
	end
end

--------------------------------------------------------------------------------
-- 거점전에 변화가 생겼다! 정보를 업데이트 해랏!
--------------------------------------------------------------------------------
function	FromClient_NodeWarInfoTentCountUpdate()
	NodeWar_Info_Update()
end
registerEvent("FromClient_KingOrLordTentCountUpdate",		"FromClient_NodeWarInfoTentCountUpdate")	-- 성채/지휘소에 변화가 생겼다!


--------------------------------------------------------------------------------
-- 거점전 현황판 정보 업뎃.
--------------------------------------------------------------------------------
function	NodeWar_Info_Update()
	local territoryCount = getTerritoryListByAll()
	if nil == territoryCount then
		return
	end

	for territory_idx = 0, territoryCount -1 do
		local territoryDATA			= nodeWarInfoUIPool[territory_idx]
		local territoryKey			= getTerritoryByIndex( territory_idx ):get()
		local nowBeingMinor			= ToClient_GetVillageSiegeCountByTerritory(territoryKey, true)
		local nowFinishMinor		= ToClient_GetVillageSiegeCountByTerritory(territoryKey, false)

		-- 카운트 갱신
		if 0 < nowBeingMinor then
			chanege_SiegeIcon( territoryDATA.Name, 1 )
			territoryDATA.Name:SetFontColor( UI_color.C_FFE7E7E7 )
			territoryDATA.IngCount:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_NODEWARINFO_NOWBEINGMINOR", "nowBeingMinor", tostring(nowBeingMinor) ) ) -- 진행  .. tostring(nowBeingMinor)
			territoryDATA.IngCount:SetFontColor( UI_color.C_FF40D7FD )
			territoryDATA.EndCount:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_NODEWARINFO_NOWENDMINOR", "nowFinishMinor", tostring(nowFinishMinor) ) ) -- 종료 " .. tostring(nowFinishMinor)
			territoryDATA.EndCount:SetFontColor( UI_color.C_FFFF4B4B )
		else
			chanege_SiegeIcon( territoryDATA.Name, 0 )
			territoryDATA.Name:SetFontColor( UI_color.C_FF626262 )
			territoryDATA.IngCount:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_NODEWARINFO_ING") ) -- 진행  - 
			territoryDATA.IngCount:SetFontColor( UI_color.C_FF626262 )
			territoryDATA.EndCount:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_NODEWARINFO_END") ) -- 종료  - 
			territoryDATA.EndCount:SetFontColor( UI_color.C_FF626262 )
		end
	end
end

--------------------------------------------------------------------------------
-- 거점전 현황판 열고 닫음!
--------------------------------------------------------------------------------
function FGlobal_NodeWarInfo_Open()
	if Panel_Win_Worldmap_NodeWarInfo:GetShow() then
		return
	end

	if isWorldMapGrandOpen() then
		Panel_Win_Worldmap_NodeWarInfo:SetSpanSize( 5, 75 )
	else
		Panel_Win_Worldmap_NodeWarInfo:SetSpanSize( 5, 5 )
	end
	
	local territoryCount = getTerritoryListByAll()
	if nil == territoryCount then
		return
	end

	local isSiegeBeing_chk = false
	for territory_idx = 0, territoryCount -1 do
		local territoryKey	= getTerritoryByIndex( territory_idx ):get()
		local nowBeingMinor = ToClient_GetVillageSiegeCountByTerritory(territoryKey, true)
		if 0 < nowBeingMinor then	-- 거점전이 진행중인가? 아닌가를 체크한다.
			isSiegeBeing_chk = true
		end
	end

	if isSiegeBeing_chk then
		Panel_Win_Worldmap_NodeWarInfo:SetShow( true )
		Panel_Win_Worldmap_WarInfo:SetShow( false )
		NodeWar_Info_Update()
	end
end

function FGlobal_NodeWarInfo_Close()
	if not Panel_Win_Worldmap_NodeWarInfo:GetShow() then
		return
	end
	NodeWarScoreIconToolTip(false)
	Panel_Win_Worldmap_NodeWarInfo:SetShow( false )
end

NodeWarInfo_Init()