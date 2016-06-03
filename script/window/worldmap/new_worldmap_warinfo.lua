-----------------------------------------------------------
-- Local 변수 설정
-----------------------------------------------------------
local UI_PUCT 		= CppEnums.PA_UI_CONTROL_TYPE
local UI_color 		= Defines.Color

Panel_Win_Worldmap_WarInfo:SetShow( false )

local WarInfoUIPool = {
}

local toolTip			= UI.getChildControl(Panel_Win_Worldmap_WarInfo, "StaticText_Help")
local findTentIcon		= UI.getChildControl(Panel_Win_Worldmap_WarInfo, "Static_Territory_FindCount_Icon")
local allTentIcon		= UI.getChildControl(Panel_Win_Worldmap_WarInfo, "Static_Territory_AllCount_Icon")
local closeBTN			= UI.getChildControl(Panel_Win_Worldmap_WarInfo, "Button_Win_Close")

toolTip:SetShow( false )
toolTip:SetAutoResize( true )
toolTip:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )


findTentIcon:addInputEvent("Mouse_On", "territoryWarScoreIconToolTip( true, \"find\")")
findTentIcon:addInputEvent("Mouse_Out", "territoryWarScoreIconToolTip( false )")
allTentIcon:addInputEvent("Mouse_On", "territoryWarScoreIconToolTip( true, \"all\" )")
allTentIcon:addInputEvent("Mouse_Out", "territoryWarScoreIconToolTip( false )")
closeBTN:addInputEvent("Mouse_LUp", "FGlobal_WarInfo_Close()")

local _buttonQuestion	= UI.getChildControl( Panel_Win_Worldmap_WarInfo, "Button_Question" )					--물음표 버튼
_buttonQuestion			: addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"WarInfo\" )" )			--물음표 좌클릭
_buttonQuestion			: addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"WarInfo\", \"true\")" )		--물음표 마우스오버
_buttonQuestion			: addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"WarInfo\", \"false\")" )	--물음표 마우스아웃

function territoryWarScoreIconToolTip( show, value )
	if true == show then
		if "find" == value then
			toolTip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_WARINFO_TEXT_TOOLTIP1") ) -- "플레이어가 속한 길드가 해당 영지에서 <PAColor0xffed6363>찾은 지휘소/성채 수<PAOldColor>"
			toolTip:SetPosX( findTentIcon:GetPosX() - toolTip:GetTextSizeX() )
			toolTip:SetPosY( findTentIcon:GetPosY() - toolTip:GetSizeY() )
			toolTip:SetShow( true )
		else
			toolTip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_WARINFO_TEXT_TOOLTIP2") ) -- "해당 영지에 건설이 <PAColor0xffed6363>완료된 지휘소/성채의 수<PAOldColor>"
			toolTip:SetPosX( allTentIcon:GetPosX() - toolTip:GetTextSizeX() )
			toolTip:SetPosY( allTentIcon:GetPosY() - toolTip:GetSizeY() )
			toolTip:SetShow( true )
		end
	else
		toolTip:SetShow( false )
	end
end

local Templete	= {
	territory_Name			= UI.getChildControl(Panel_Win_Worldmap_WarInfo, "StaticText_Territory_Name"),
	territory_FindCount		= UI.getChildControl(Panel_Win_Worldmap_WarInfo, "StaticText_Territory_FindCount"),
	territory_DestroyCount	= UI.getChildControl(Panel_Win_Worldmap_WarInfo, "StaticText_Territory_DestroyCount"),
	territory_AllCount		= UI.getChildControl(Panel_Win_Worldmap_WarInfo, "StaticText_Territory_AllCount"),
}

local territory_NamePosY	= Templete.territory_Name:GetPosY()
local territory_CountPosY	= Templete.territory_AllCount:GetPosY()

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

local territoryInfo_Init = function()
	local line_gap = 5
	local territoryCount = getTerritoryListByAll()				-- 발렌시아 지역이 없으므로 일단 카운트 -1
	if nil == territoryCount then
		return
	end

	for territory_idx = 0, territoryCount -1 do
		local territoryKey			= getTerritoryByIndex( territory_idx )
		local territoryName			= getTerritoryNameByKey( territoryKey )	-- 영지 이름

		if ( nil ~= territoryKey ) then
			local territoryDATA = {}
			-- 이름 생성
			territoryDATA.Name = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_Win_Worldmap_WarInfo, "StaticText_Territory_Name_" .. territory_idx)
			CopyBaseProperty(Templete.territory_Name, territoryDATA.Name)
			territoryDATA.Name:SetShow( true )
			territoryDATA.Name:SetPosY( territory_NamePosY )
			territoryDATA.Name:SetText( territoryName )
			chanege_SiegeIcon( territoryDATA.Name, 0 )

			-- 찾은 수 생성
			territoryDATA.FindCount = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_Win_Worldmap_WarInfo, "StaticText_Territory_FindCount_" .. territory_idx)
			CopyBaseProperty(Templete.territory_FindCount, territoryDATA.FindCount)
			territoryDATA.FindCount:SetShow( true )
			territoryDATA.FindCount:SetPosY( territory_CountPosY )

			-- 파괴한 수 생성
			-- territoryDATA.DestroyCount = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_Win_Worldmap_WarInfo, "StaticText_Territory_DestroyCount_" .. territory_idx)
			-- CopyBaseProperty(Templete.territory_DestroyCount, territoryDATA.DestroyCount)
			-- territoryDATA.DestroyCount:SetShow( true )
			-- territoryDATA.DestroyCount:SetPosY( territory_CountPosY )

			-- 모든 수 생성
			territoryDATA.AllCount = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_Win_Worldmap_WarInfo, "StaticText_Territory_AllCount_" .. territory_idx)
			CopyBaseProperty(Templete.territory_AllCount, territoryDATA.AllCount)
			territoryDATA.AllCount:SetShow( true )
			territoryDATA.AllCount:SetPosY( territory_CountPosY )

			territory_NamePosY	= territory_NamePosY + territoryDATA.Name:GetSizeY() + 5 + line_gap
			territory_CountPosY	= territory_CountPosY + territoryDATA.FindCount:GetSizeY() + line_gap

			-- Pool에 저장
			WarInfoUIPool[territory_idx] = territoryDATA
		end
	end
end


function	territory_Info_Update()
	local territoryCount = getTerritoryListByAll()
	if nil == territoryCount then
		return
	end

	local isSiegeBeing_World = false
	for territory_idx = 0, territoryCount -1 do
		local territoryDATA			= WarInfoUIPool[territory_idx]
		local count_FindBuildingTent= getCurrentBuildingKingOrLordTentCount( territory_idx )
		if nil == count_FindBuildingTent then
			count_FindBuildingTent = 0
		end
		local count_FindCompleteTent= getCurrentCompleteKingOrLordTentCount( territory_idx )
		if nil == count_FindCompleteTent then
			count_FindCompleteTent = 0
		end

		local count_BuildingTent	= getBuildingKingOrLordTentCount( territory_idx )
		-- local count_CompleteTent	= getCompleteKingOrLordTentCount( territory_idx )
		local count_CompleteTent	= ToClient_GetLeftSiegeGuildCount( territory_idx )

		local isSiegeBeing_Value	= isSiegeBeing( territory_idx )	-- isSiegeBeing( territoryKeyRaw )	-- 점령전 중인가?
		isSiegeBeing_World = isSiegeBeing_World or isSiegeBeing_Value
		-- 카운트 갱신
		if true == isSiegeBeing_Value then
			chanege_SiegeIcon( territoryDATA.Name, 1 )
			territoryDATA.Name:SetFontColor( UI_color.C_FFE7E7E7 )
			territoryDATA.FindCount:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_WARINFO_TEXT_FINDCOUNT1", "count", count_FindCompleteTent ) ) -- "발견 " .. count_FindCompleteTent
			territoryDATA.FindCount:SetFontColor( UI_color.C_FF40D7FD )
			territoryDATA.AllCount:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_WARINFO_TEXT_ALLCOUNT1", "count", count_CompleteTent ) ) -- "전체 " .. count_CompleteTent
			territoryDATA.AllCount:SetFontColor( UI_color.C_FFFF4B4B )
		else
			chanege_SiegeIcon( territoryDATA.Name, 0 )
			territoryDATA.Name:SetFontColor( UI_color.C_FF626262 )
			territoryDATA.FindCount:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_WARINFO_TEXT_FINDCOUNT2") ) -- 발견  - 
			territoryDATA.FindCount:SetFontColor( UI_color.C_FF626262 )
			territoryDATA.AllCount:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_WARINFO_TEXT_ALLCOUNT2") ) -- 전체  - 
			territoryDATA.AllCount:SetFontColor( UI_color.C_FF626262 )
		end
	end
	
	if not isSiegeBeing_World then
		FGlobal_WarInfo_Close()
	end
end

--------------------------------------------------------------------------------
-- 성채수 변화생김
--------------------------------------------------------------------------------
function	FromClient_NotifyKingOrLoadTentCountUpdate()
	territory_Info_Update()
end
registerEvent("FromClient_KingOrLordTentCountUpdate",		"FromClient_NotifyKingOrLoadTentCountUpdate")	-- 성채/지휘소 추가, 파괴, 제거


function FGlobal_WarInfo_Open()
	if Panel_Win_Worldmap_WarInfo:GetShow() then
		return
	end

	local territoryCount = getTerritoryListByAll()
	if nil == territoryCount then
		return
	end

	local isSiegeBeing_chk = false
	for territory_idx = 0, territoryCount -1 do
		local territoryKey			= getTerritoryByIndex( territory_idx )
		local isSiegeBeing_Value	= isSiegeBeing( territory_idx )	-- isSiegeBeing( territoryKeyRaw )	-- 점령전 중인가?
		if isSiegeBeing_Value then
			isSiegeBeing_chk = true
		end
	end

	if isSiegeBeing_chk then
		Panel_Win_Worldmap_WarInfo:SetShow( true )
		Panel_Win_Worldmap_NodeWarInfo:SetShow( false )
		territory_Info_Update()
	else
		FGlobal_WarInfo_Close()
	end
end

function FGlobal_WarInfo_Close()
	if not Panel_Win_Worldmap_WarInfo:GetShow() then
		return
	end
	territoryWarScoreIconToolTip(false)
	Panel_Win_Worldmap_WarInfo:SetShow( false )
end




territoryInfo_Init()
