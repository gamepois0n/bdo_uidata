CppEnums.SiegeNotifyType =
{
	Insert		= 0,	-- 참전
	Unbuild		= 1,	-- 회수
	Destroy		= 2,	-- 파괴
	DestroyGate	= 3,	-- 문 파괴
}

local UI_ANI_ADV 		= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_TM				= CppEnums.TextMode
local UI_color			= Defines.Color

Panel_WarInfoMessage:SetShow( false, false )
Panel_WarInfoMessage:RegisterShowEventFunc( true, 'WarInfoMessageShowAni()' )
Panel_WarInfoMessage:RegisterShowEventFunc( false, 'WarInfoMessageHideAni()' )

local panel_BG			= UI.getChildControl(Panel_WarInfoMessage, "Static_BGTexture")
local panel_MainMessage	= UI.getChildControl(Panel_WarInfoMessage, "StaticText_MainMessage")
local panel_SubMessage	= UI.getChildControl(Panel_WarInfoMessage, "StaticText_SubMessage")
local panel_Effect		= UI.getChildControl(Panel_WarInfoMessage, "Static_Effect")
local onTime = 0

local chanege_BG = function( control, type )
	if 0 == type then		-- 어떤 성채 파괴
		control:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/WarInfoMessage/destroyGuildTent.dds" )
	elseif 1 == type then	-- 어떤 성채 추가
		control:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/WarInfoMessage/addGuildTent.dds" )
	elseif 2 == type then	-- 해방
		control:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/WarInfoMessage/newTerritoryOwner.dds" )
	elseif 3 == type then	-- 피격
		control:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/WarInfoMessage/attackGuildTent.dds" )
	elseif 4 == type then	-- 종료
		control:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/WarInfoMessage/newTerritoryOwner.dds" )
	elseif 5 == type then	-- 점령전 시작
		control:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/WarInfoMessage/startWars.dds" )
	elseif 6 == type then	-- 길드전 시작
		control:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/WarInfoMessage/guildWarStart.dds" )
	elseif 7 == type then	-- 길드전 종료
		control:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/WarInfoMessage/guildWarEnd.dds" )
	end
	local x1, y1, x2, y2 = setTextureUV_Func( control, 0, 0, 562, 128 )
	control:getBaseTexture():setUV(  x1, y1, x2, y2  )
	control:setRenderTexture(control:getBaseTexture())
	return control
end

local warMsgCheckPanel = UI.createPanel("warMsgCheckPanel", Defines.UIGroup.PAGameUIGroup_ModalDialog)
warMsgCheckPanel:SetSize(1,1)
warMsgCheckPanel:SetIgnore( true )
warMsgCheckPanel:SetHorizonCenter()
warMsgCheckPanel:SetVerticalTop()

local send_WarMsgPool = Array.new()

function send_WarMsgHandle( deltaTime )
	if not Panel_WarInfoMessage:GetShow() then
		local msg = send_WarMsgPool:pop_front()
		if nil == msg then
			warMsgCheckPanel:SetShow( false )
			return
		else
			panel_Effect:EraseAllEffect()
			if 0 == msg[0] then		-- 이탈
				panel_Effect:AddEffect ( "UI_CastleMinusLight", false, 0, 0 )
				-- ♬ 이탈 할 때
				audioPostEvent_SystemUi(15,02)
			elseif 1 == msg[0] then	-- 참전
				panel_Effect:AddEffect ( "UI_CastlePlusLight", false, 0, 0 )
				-- ♬ 난입 할 때
				audioPostEvent_SystemUi(15,01)
			elseif 2 == msg[0] then	-- 해방
				panel_Effect:AddEffect ( "UI_SiegeWarfare_Win", false, -19, 0 )
				panel_Effect:AddEffect ( "fUI_SkillAwakenBoom", false, -19, 0 )
				-- ♬ 해방될 때
				audioPostEvent_SystemUi(15,04)
			elseif 3 == msg[0] then	-- 피격
				panel_Effect:AddEffect ( "UI_SiegeWarfare_Alarm", true, -16, -22 )
				-- ♬ 내 성채가 맞을 때
				audioPostEvent_SystemUi(15,03)
			elseif 4 == msg[0] then	-- 종료
				panel_Effect:AddEffect ( "UI_SiegeWarfare_Win", false, -19, 0 )
				panel_Effect:AddEffect ( "fUI_SkillAwakenBoom", false, -19, 0 )
				-- ♬ 점령전이 종료 될 때
				audioPostEvent_SystemUi(15,04)
			elseif 5 == msg[0] then	-- 점령전 시작
				panel_Effect:AddEffect ( "UI_SiegeWarfare_Win_Green", false, -19, 0 )
				panel_Effect:AddEffect ( "fui_skillawakenboom_green", false, -19, 0 )
				-- ♬ 점령전이 시작 될 때
				audioPostEvent_SystemUi(15,00)
			elseif 6 == msg[0] then	-- 길드 전쟁 시작
				panel_Effect:AddEffect ( "UI_SiegeWarfare_Win_Red", false, -19, 0 )
				panel_Effect:AddEffect ( "fui_skillawakenboom_red", false, -19, 0 )
				-- ♬ 길드전이 시작 될 때
				audioPostEvent_SystemUi(15,04)
			elseif 7 == msg[0] then	-- 길드 전쟁 종료
				panel_Effect:AddEffect ( "UI_SiegeWarfare_Win_Red", false, -19, 0 )
				panel_Effect:AddEffect ( "fui_skillawakenboom_red", false, -19, 0 )
				-- ♬ 길드전이 종료 될 때
				audioPostEvent_SystemUi(15,04)
			end

			chanege_BG( panel_BG, msg[0] )
			panel_MainMessage:SetText( msg[1] )
			panel_SubMessage:SetText( msg[2] )
			Panel_WarInfoMessage:SetShow( true, true )
		end
	end
end
warMsgCheckPanel:RegisterUpdateFunc("send_WarMsgHandle")


function WarInfoMessageShowAni()
	local aniInfo1 = Panel_WarInfoMessage:addScaleAnimation( 0.0, 0.05, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.8)
	aniInfo1:SetEndScale(1.3)
	aniInfo1.AxisX = Panel_WarInfoMessage:GetSizeX() / 2
	aniInfo1.AxisY = Panel_WarInfoMessage:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_WarInfoMessage:addScaleAnimation( 0.05, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.3)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_WarInfoMessage:GetSizeX() / 2
	aniInfo2.AxisY = Panel_WarInfoMessage:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end
function WarInfoMessageHideAni()
	local aniInfo1 = Panel_WarInfoMessage:addColorAnimation( 0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
end

--------------------------------------------------------------------------------
-- 점령함
--------------------------------------------------------------------------------
function FromClient_NotifyOccupySiege( regionKeyRaw, guildName )
	-- 마이너공성이 추가되면서 영지키를 지역키로 변경함 (crazy4idea:20150408)
	local regionInfoWrapper = getRegionInfoWrapper(regionKeyRaw)
	if (nil == regionInfoWrapper) then
		return
	end	

	local 	msg_type	= 4
	local 	msg_Main 	= nil;
	local	areaName 	= nil;

	-- 메인타운인 경우 영지전이고 메인타운이 아닌경우는 세력전이다
	if(regionInfoWrapper:get():isMainTown()) then
		areaName = regionInfoWrapper:getTerritoryName()
		msg_Main	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYOCCUPYSIEGE_END_MAIN", "territoryName", areaName ) -- "<PAColor0xffcab120>" .. areaName .. " 점령전이 종료됐습니다.<PAOldColor>"
	else
		local explorationWrapper	= regionInfoWrapper:getExplorationStaticStatusWrapper()
		if nil ~= explorationWrapper then
			areaName = explorationWrapper:getName()
			msg_Main	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYOCCUPY_VILLAGESIEGE_END_MAIN", "territoryName", areaName ) -- "<PAColor0xffcab120>" .. areaName .. " 거점전이 종료됐습니다.<PAOldColor>"
		end
	end

	local msg_Sub	= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYOCCUPYSIEGE_END_SUB", "territoryName", areaName, "guildName", guildName ) -- "<PAColor0xfffff179>이제 <PAColor0xffffffff>" .. areaName .. "<PAOldColor><PAColor0xfffff179>은 <PAOldColor><PAColor0xffffffff>" .. guildName .. "<PAOldColor><PAColor0xfffff179> 길드의 관리를 받습니다.<PAOldColor>"

	local message = { main = msg_Main, sub = msg_Sub, addMsg = "" }
	Proc_ShowMessage_Ack_For_RewardSelect( message, 4, 11 )

	-- send_WarMsgPool:push_back( { [0] = msg_type, [1] = msg_Main, [2] = msg_Sub } )

	-- if not warMsgCheckPanel:GetShow() then
	-- 	warMsgCheckPanel:SetShow( true )
	-- end
end

--------------------------------------------------------------------------------
-- 해방됨
--------------------------------------------------------------------------------
function FromClient_NotifyReleaseSiege( territoryKeyRaw )
	-- 마이너공성이 추가되면서 영지키를 지역키로 변경함 (crazy4idea:20150408)
	local regionInfoWrapper = getRegionInfoWrapper(regionKeyRaw)
	if (nil == regionInfoWrapper) then
		return
	end	
	
	local	areaName = nil;
	
	-- 메인타운인 경우 영지전이고 메인타운이 아닌경우는 세력전이다
	if(regionInfoWrapper:get():isMainTown()) then
		areaName = regionInfoWrapper:getTerritoryName()
	else
		local explorationWrapper	= regionInfoWrapper:getExplorationStaticStatusWrapper()
		if nil ~= explorationWrapper then
			areaName = explorationWrapper:getName()
		end
	end

	local msg_type	= 2
	local msg_Main	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYOCCUPYSIEGE_RELEASE_MAIN", "territoryName", areaName ) -- "<PAColor0xffc29d0a>" .. areaName .. "이 해방됐습니다.<PAOldColor>"
	local msg_Sub	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYOCCUPYSIEGE_RELEASE_SUB", "territoryName", areaName ) -- "<PAColor0xffcab120>" .. areaName .. " 점령 길드가 패배했습니다.<PAOldColor>"

	local message = { main = msg_Main, sub = msg_Sub, addMsg = "" }
	Proc_ShowMessage_Ack_For_RewardSelect( message, 4, 11 )

	-- send_WarMsgPool:push_back( { [0] = msg_type, [1] = msg_Main, [2] = msg_Sub } )

	-- if not warMsgCheckPanel:GetShow() then
	-- 	warMsgCheckPanel:SetShow( true )
	-- end
end


--------------------------------------------------------------------------------
-- 성채 추가, 파괴, 삭제
--------------------------------------------------------------------------------
function	FromClient_NotifyKingOrLordTentChange( notifyType, regionKeyRaw, guildName, guildNamePeer )
	-- CppEnums.SiegeNotifyType 참조.
	
	local regionInfoWrapper = getRegionInfoWrapper(regionKeyRaw)
	if (nil == regionInfoWrapper) then
		return
	end	
	
	local	areaName = nil;
	local	warInfoName = nil;
	-- 메인타운인 경우 영지전이고 메인타운이 아닌경우는 세력전이다
	if(regionInfoWrapper:get():isMainTown()) then
		areaName = regionInfoWrapper:getTerritoryName()
		warInfoName = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_TERRITORYWAR") -- 점령전
	else
		local explorationWrapper	= regionInfoWrapper:getExplorationStaticStatusWrapper()
		if nil ~= explorationWrapper then
			areaName = explorationWrapper:getName()
			warInfoName = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_NODEWAR") -- 거점전
		end
	end
	
	local	count_CompleteTent	= ToClient_GetCompleteSiegeTentCount( regionKeyRaw )
	local	msg_type			= nil
	local	msg_Main			= nil
	local	msg_Sub				= nil

	if	( CppEnums.SiegeNotifyType.Insert == notifyType )	then
		msg_type	= 1
		msg_Main	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYKINGORLORDTENTCHANGE_INSERT_MAIN", "guildName", guildName ) -- "<PAColor0xff00d8ff>" .. guildName .. " 길드 참전<PAOldColor>" 
		msg_Sub		= PAGetStringParam3( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYKINGORLORDTENTCHANGE_INSERT_SUB", "territoryName", areaName, "warInfoName", warInfoName, "count_CompleteTent", count_CompleteTent ) -- "<PAColor0xff9cf7ff>" .. areaName .. " 점령전은 " .. count_CompleteTent .. "개 길드가 참전중입니다.<PAOldColor>"

		local message = { main = msg_Main, sub = msg_Sub, addMsg = "" }
		Proc_ShowMessage_Ack_For_RewardSelect( message, 4, 12 )

	elseif	( CppEnums.SiegeNotifyType.Unbuild == notifyType )	then
		msg_type	= 0
		msg_Main	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYKINGORLORDTENTCHANGE_UNBUILD_MAIN", "guildName", guildName ) -- "<PAColor0xffff0000>" .. guildName .. "길드 점령전 철수<PAOldColor>" 
		msg_Sub		= PAGetStringParam3( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYKINGORLORDTENTCHANGE_UNBUILD_SUB", "territoryName", areaName, "warInfoName", warInfoName, "count_CompleteTent", count_CompleteTent ) -- "<PAColor0xffff6363>" .. areaName .. " 점령전은 " .. count_CompleteTent .. "개 길드가 참전중입니다.<PAOldColor>"

		local message = { main = msg_Main, sub = msg_Sub, addMsg = "" }
		Proc_ShowMessage_Ack_For_RewardSelect( message, 4, 13 )

	elseif	( CppEnums.SiegeNotifyType.Destroy == notifyType )	then
		msg_type	= 0
		msg_Main	= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYKINGORLORDTENTCHANGE_DESTORY_MAIN", "guildNamePeer", guildNamePeer, "guildName", guildName ) -- "<PAColor0xffff0000>" .. guildNamePeer .. "길드가 " .. guildName .. "길드 지휘소/성채 파괴<PAOldColor>" 
		if 1 == count_CompleteTent then
			msg_Sub		= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYKINGORLORDTENTCHANGE_DESTORY_ONLYONE_SUB", "territoryName", areaName, "warInfoName", warInfoName )
		else
			msg_Sub		= PAGetStringParam3( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYKINGORLORDTENTCHANGE_DESTORY_SUB", "territoryName", areaName, "warInfoName", warInfoName, "count_CompleteTent", count_CompleteTent ) -- "<PAColor0xffff6363>" .. areaName .. " 점령전은 " .. count_CompleteTent .. "개 길드가 참전중입니다.<PAOldColor>"
		end

		local message = { main = msg_Main, sub = msg_Sub, addMsg = "" }
		Proc_ShowMessage_Ack_For_RewardSelect( message, 4, 13 )

	elseif	( CppEnums.SiegeNotifyType.DestroyGate == notifyType )	then
		msg_type	= 0
		msg_Main	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYKINGORLORDTENTCHANGE_DESTORYGATE_MAIN", "territoryName", areaName ) -- "<PAColor0xffff0000>" .. areaName .. " 성문 파괴<PAOldColor>" 
		msg_Sub		= PAGetStringParam3( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYKINGORLORDTENTCHANGE_DESTORYGATE_SUB", "territoryName", areaName, "warInfoName", warInfoName, "count_CompleteTent", count_CompleteTent ) -- "<PAColor0xffff6363>" .. areaName .. " 점령전은 " .. count_CompleteTent .. "개 길드가 참전중입니다.<PAOldColor>"

		local message = { main = msg_Main, sub = msg_Sub, addMsg = "" }
		Proc_ShowMessage_Ack_For_RewardSelect( message, 4, 13 )

	else
		return
	end
	
	-- send_WarMsgPool:push_back( { [0] = msg_type, [1] = msg_Main, [2] = msg_Sub } )
	
	-- if not warMsgCheckPanel:GetShow() then
	-- 	warMsgCheckPanel:SetShow( true )
	-- end
end


Panel_WarInfoMessage:RegisterUpdateFunc('warInfoMessage_check')
function warInfoMessage_check( deltaTime )
	onTime = onTime + deltaTime
	if 4 < onTime and Panel_WarInfoMessage:GetShow() then
		Panel_WarInfoMessage:SetShow( false, false )
		onTime = 0
	end
	if 6 < onTime then
		onTime = 0
	end
end

--------------------------------------------------------------------------------
-- 내 성채 피격
--------------------------------------------------------------------------------
function	FromClient_NotifyAttackedKingOrLoadTent( percent, areaName )
	if percent < 0 then
		return
	end

	local msg_type	= 3
	local msg_Main	= nil
	if percent <= 600000 and 300001 <= percent then
		msg_Main = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_KINGORLORDTENTNOTIFY", "areaName", areaName ) .. " " .. PAGetStringParam2( Defines.StringSheet_GAME, "LUA_GUILD_ATTACKEDKINGORLOADTENT_UNDER", "Percent", 60, "left_HP", string.format( "%.1f", percent/10000 ) )
		-- 내구도가 {Percent}% 미만입니다. (내구도 {left_HP}%)
	elseif percent <= 300000 then
		msg_Main = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_KINGORLORDTENTNOTIFY", "areaName", areaName ) .. " " .. PAGetStringParam2( Defines.StringSheet_GAME, "LUA_GUILD_ATTACKEDKINGORLOADTENT_DANGER", "Percent", 30, "left_HP", string.format( "%.1f", percent/10000 ) )
		-- 위험합니다. 내구도가 {Percent}% 미만입니다. (내구도 {left_HP}%)
	else
		msg_Main = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_KINGORLORDTENTNOTIFY", "areaName", areaName ) .. " " .. PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_ATTACKEDKINGORLOADTENT_NOTY", "Percent", string.format( "%.1f", percent/10000 ) )
		-- 내구도가 {Percent}% 남았습니다.
	end
	msg_Main = "<PAColor0xffaf1426>" .. msg_Main .. "<PAOldColor>"
	local msg_Sub	= "<PAColor0xfff14152>" .. PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_KINGORLORDTENTNOTIFY2", "areaName", areaName ) .. " " .. PAGetString(Defines.StringSheet_GAME, "Lua_Guild_AttackedKingOrLoadTent") .. "<PAOldColor>"	-- 지휘소 혹은 성채가 공격 받고 있습니다.
	
	local message = { main = msg_Main, sub = msg_Sub, addMsg = "" }
	Proc_ShowMessage_Ack_For_RewardSelect( message, 4, 14 )

	-- send_WarMsgPool:push_back( { [0] = msg_type, [1] = msg_Main, [2] = msg_Sub } )

	-- if not warMsgCheckPanel:GetShow() then
	-- 	warMsgCheckPanel:SetShow( true )
	-- end
end

--------------------------------------------------------------------------------
-- 내 성채 파괴
--------------------------------------------------------------------------------
function FromClient_KingOrLordTentDestroy( notifyType, regionKeyRaw )
	-- 어느 영지의 내 성채가 파괴 됐다.
	-- CppEnums.SiegeNotifyType 참조.

	local regionInfoWrapper = getRegionInfoWrapper(regionKeyRaw)
	if (nil == regionInfoWrapper) then
		return
	end	
	
	local	areaName = nil;
	
	-- 메인타운인 경우 영지전이고 메인타운이 아닌경우는 세력전이다
	local	msg_Main = nil
	if(regionInfoWrapper:get():isMainTown()) then
		areaName = regionInfoWrapper:getTerritoryName()
		msg_Main = PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_KINGORLORDTENTDESTORY_MAIN") -- "<PAColor0xffaf1426>점령전에서 패배했습니다.<PAOldColor>"
	else
		local explorationWrapper	= regionInfoWrapper:getExplorationStaticStatusWrapper()
		if nil ~= explorationWrapper then
			areaName = explorationWrapper:getName()
			msg_Main = ""
		end
	end
	
	local msg_type	= 3
	
	local msg_Sub = ""
	if( 1 == notifyType ) then --해체
		msg_Sub	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_KINGORLORDTENTDESTORY_SUB1", "territoryName", areaName ) -- "<PAColor0xfff14152>" .. areaName .. "의 지휘소/성채가 해체됐습니다.<PAOldColor>"
	else
		msg_Sub	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_KINGORLORDTENTDESTORY_SUB2", "territoryName", areaName ) -- "<PAColor0xfff14152>" .. areaName .. "의 지휘소/성채가 파괴됐습니다.<PAOldColor>"
	end
	
	local message = { main = msg_Main, sub = msg_Sub, addMsg = "" }
	Proc_ShowMessage_Ack_For_RewardSelect( message, 4, 14 )

	-- send_WarMsgPool:push_back( { [0] = msg_type, [1] = msg_Main, [2] = msg_Sub } )

	-- if not warMsgCheckPanel:GetShow() then
	-- 	warMsgCheckPanel:SetShow( true )
	-- end
end

--------------------------------------------------------------------------------
-- 길드 vs 길드
--------------------------------------------------------------------------------
function FromClient_NotifyGuildWar( msgType, guildName, targetGuildName )
	local msg_type	= nil
	local msg_Main	= nil
	local msg_Sub	= nil

	-- 해산된 길드의 전쟁취소를 하면 길드명이 안나오기때문에 뿌려주지않기 위해서 return한다.
	if 1 == msgType and "" == targetGuildName then
		return
	end

	if( 0 == msgType ) then
		msg_type	= 6
		msg_Main	= PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_WARSTART_NACK_MAIN") -- "<PAColor0xffaf1426>길드 전쟁이 시작됩니다.<PAOldColor>"
		msg_Sub		= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_WAIT_WARSTART_NACK_SUB", "guildName", guildName, "targetGuildName", targetGuildName ) 
		-- [<PAColor0xFFE49800>{guildName}<PAOldColor>] 길드와 [<PAColor0xFFE49800>{targetGuildName}<PAOldColor>] 간에 전쟁이 시작되었습니다.

		local message = { main = msg_Main, sub = msg_Sub, addMsg = "" }

		Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect( message, 4, 15 )
		chatting_sendMessage( "", message.sub , CppEnums.ChatType.System )
	elseif( 1 == msgType ) then
		msg_type	= 7
		msg_Main	= PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_WARSTOP_NACK_MAIN") -- "<PAColor0xff9a9a9a>길드 전쟁이 종료됩니다.<PAOldColor>"
		msg_Sub		= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_WARSTOP_NACK_SUB", "guildName", guildName, "targetGuildName", targetGuildName ) -- "<PAColor0xffd3d3d3>" .. guildName .. " 길드가 " .. targetGuildName .. " 길드와의 전쟁을 철회했습니다.<PAOldColor>"

		local message = { main = msg_Main, sub = msg_Sub, addMsg = "" }

		Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect( message, 4, 16 )
		chatting_sendMessage( "", message.sub , CppEnums.ChatType.System )
	elseif( 2 == msgType ) then
		msg_type	= 7
		msg_Main	= PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_WARBRAKEUP_NACK_MAIN") -- "<PAColor0xff9a9a9a>길드가 해산되었습니다.<PAOldColor>"
		msg_Sub		= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_WARBRAKEUP_NACK_SUB", "targetGuildName", targetGuildName ) -- "<PAColor0xffd3d3d3>전쟁 중인 " .. targetGuildName .. " 길드가 해산되었습니다.<PAOldColor>"

		local message = { main = msg_Main, sub = msg_Sub, addMsg = "" }

		Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect( message, 4, 16 )
		chatting_sendMessage( "", message.sub , CppEnums.ChatType.System )
	elseif( 3 == msgType ) then
		msg_type	= 6
		msg_Main	= PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_WARSTART_NACK_MAIN") -- "<PAColor0xffaf1426>길드 전쟁이 시작됩니다.<PAOldColor>"
		msg_Sub		= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_WAIT_DECLAREWAR_NACK_SUB", "targetGuildName", targetGuildName )
		-- [<PAColor0xFFE49800>{targetGuildName}<PAOldColor>] 길드에 전쟁을 선포하였습니다. 잠시 후 안내와 함께 전쟁이 시작됩니다.

		local message = { main = msg_Main, sub = msg_Sub, addMsg = "" }

		Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect( message, 4, 15 )
		chatting_sendMessage( "", message.sub , CppEnums.ChatType.System )	
	elseif( 4 == msgType ) then
		msg_type	= 6
		msg_Main	= PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_WARSTART_NACK_MAIN") -- "<PAColor0xffaf1426>길드 전쟁이 시작됩니다.<PAOldColor>"
		msg_Sub		= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_WAIT_DECLAREWAR_TARGET_NACK_SUB", "guildName", guildName )
		-- [<PAColor0xFFE49800>{guildName}<PAOldColor>] 길드에서 전쟁을 선포하였습니다. 잠시 후 안내와 함께 전쟁이 시작됩니다.

		local message = { main = msg_Main, sub = msg_Sub, addMsg = "" }

		Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect( message, 4, 15 )
		chatting_sendMessage( "", message.sub , CppEnums.ChatType.System )		
	elseif( 5 == msgType ) then
		msg_type	= 6
		msg_Main	= PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_WARSTART_NACK_MAIN") -- "<PAColor0xffaf1426>길드 전쟁이 시작됩니다.<PAOldColor>"
		msg_Sub		= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_RESPONSE_WARSTART_NACK_SUB", "guildName", guildName, "targetGuildName", targetGuildName )
		-- [<PAColor0xFFE49800>{guildName}<PAOldColor>] 길드에서 전쟁을 선포하였습니다. 잠시 후 안내와 함께 전쟁이 시작됩니다.

		local message = { main = msg_Main, sub = msg_Sub, addMsg = "" }

		Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect( message, 4, 15 )
		chatting_sendMessage( "", message.sub , CppEnums.ChatType.System )			
	end

	-- send_WarMsgPool:push_back( { [0] = msg_type, [1] = msg_Main, [2] = msg_Sub } )

	-- if not warMsgCheckPanel:GetShow() then
	-- 	warMsgCheckPanel:SetShow( true )
	-- end
end

--------------------------------------------------------------------------------
-- 점령전 시작!!!!!!!!!
--------------------------------------------------------------------------------
function FromClient_NotifyStartSiege( msgtype,  regionKeyRaw )
	-- msgtype = int : 0 시작, 1 진행중, 2 거점전 시작, 3 거점전 진행중

	-- 마이너공성이 추가되면서 영지키를 지역키로 변경함 (crazy4idea:20150408)
	-- local regionInfoWrapper = getRegionInfoWrapper(regionKeyRaw)
	-- if (nil == regionInfoWrapper) then
	-- 	return
	-- end	
	
	-- local	areaName = nil;
	
	-- -- 메인타운인 경우 영지전이고 메인타운이 아닌경우는 세력전이다
	-- if(regionInfoWrapper:get():isMainTown()) then
	-- 	areaName = regionInfoWrapper:getTerritoryName()
	-- else
	-- 	areaName = regionInfoWrapper:getAreaName()
	-- end
		
	if 0 == msgtype then
		local msg_type	= 5
		local msg_Main	= PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYSTARTSIEGE_SIEGESTART_MAIN")
		-- "<PAColor0xff3a811b>점령전이 시작됩니다.<PAOldColor>"
		local msg_Sub	= PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYSTARTSIEGE_SIEGESTART_SUB")
		-- "<PAColor0xff81ac2d>준비하신 여러분의 승전을 기원합니다.<PAOldColor>"

		local message = { main = msg_Main, sub = msg_Sub, addMsg = "" }
		Proc_ShowMessage_Ack_For_RewardSelect( message, 4, 10 )
		
		-- send_WarMsgPool:push_back( { [0] = msg_type, [1] = msg_Main, [2] = msg_Sub } )

		-- if not warMsgCheckPanel:GetShow() then
		-- 	warMsgCheckPanel:SetShow( true )
		-- end
	elseif 1 == msgtype then 
		local msg_type	= 5
		local msg_Main	= PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYSTARTSIEGE_SIEGEPROGRESS_MAIN")
		-- "<PAColor0xff3a811b>점령전이 진행되고 있습니다.<PAOldColor>"
		local msg_Sub	= PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYSTARTSIEGE_SIEGEPROGRESS_SUB")
		-- "<PAColor0xff81ac2d>준비하신 여러분의 승전을 기원합니다.<PAOldColor>"

		local message = { main = msg_Main, sub = msg_Sub, addMsg = "" }
		Proc_ShowMessage_Ack_For_RewardSelect( message, 4, 10 )
		
		-- send_WarMsgPool:push_back( { [0] = msg_type, [1] = msg_Main, [2] = msg_Sub } )

		-- if not warMsgCheckPanel:GetShow() then
		-- 	warMsgCheckPanel:SetShow( true )
		-- end
	elseif 2 == msgtype then
		local msg_type	= 5
		local msg_Main	= PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYSTARTNODESIEGE_SIEGESTART_MAIN")
		 -- "<PAColor0xff3a811b>거점전이 시작됩니다.<PAOldColor>"
		local msg_Sub	= PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYSTARTSIEGE_SIEGESTART_SUB")
		 -- "<PAColor0xff81ac2d>준비하신 여러분의 승전을 기원합니다.<PAOldColor>"

		local message = { main = msg_Main, sub = msg_Sub, addMsg = "" }
		Proc_ShowMessage_Ack_For_RewardSelect( message, 4, 10 )
		
		-- send_WarMsgPool:push_back( { [0] = msg_type, [1] = msg_Main, [2] = msg_Sub } )

		-- if not warMsgCheckPanel:GetShow() then
		-- 	warMsgCheckPanel:SetShow( true )
		-- end
	elseif 3 == msgtype then 
		local msg_type	= 5
		local msg_Main	= PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYSTARTNODESIEGE_SIEGEPROGRESS_MAIN")
		-- "<PAColor0xff3a811b>거점전이 진행되고 있습니다.<PAOldColor>"
		local msg_Sub	= PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYSTARTSIEGE_SIEGEPROGRESS_SUB")
		-- "<PAColor0xff81ac2d>준비하신 여러분의 승전을 기원합니다.<PAOldColor>"

		local message = { main = msg_Main, sub = msg_Sub, addMsg = "" }
		Proc_ShowMessage_Ack_For_RewardSelect( message, 4, 10 )
		
		-- send_WarMsgPool:push_back( { [0] = msg_type, [1] = msg_Main, [2] = msg_Sub } )

		-- if not warMsgCheckPanel:GetShow() then
		-- 	warMsgCheckPanel:SetShow( true )
		-- end
	end

	-- 점령전이 시작될 때, 위젯을 켠다.
	-- FGlobal_Panel_WarRecord_Open()
end

--------------------------------------------------------------------------------
-- 점령전 종료!!!!!!!!!
--------------------------------------------------------------------------------
function FromClient_FinishVillageSiege()
	local msg_Main	= PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYSTOPNODESIEGE_SIEGESTOP_MAIN")

	local message = { main = msg_Main, sub = "", addMsg = "" }
	Proc_ShowMessage_Ack_For_RewardSelect( message, 4, 11 )
end

--------------------------------------------------------------------------------
-- 플레이어 Kill or Death
--------------------------------------------------------------------------------
local killDeathScore ={
	content		= UI.getChildControl(Panel_TerritoryWarKillingScore, "Static_Content"),
}
local TWKScore_PosIndex		= 0
local TWKScore_PanelCount	= 3
local TWKScore_PanelUIPool	= {}
local TWKScore_AlertList	= {}
local create_TWKScore_Panel	= function()
	for panel_idx = 1, TWKScore_PanelCount do
		local panel = UI.createPanel("territoryWar_KillDeathScore_Panel_" .. panel_idx, Defines.UIGroup.PAGameUIGroup_ModalDialog)
		-- CopyBaseProperty( Panel_TerritoryWarKillingScore, panel )
		panel:SetSize( 370, 35 )
		panel:SetIgnore( true )
		panel:SetHorizonCenter()
		panel:SetShow(false, false)

		local panel_StaticText	= UI.createAndCopyBasePropertyControl( Panel_TerritoryWarKillingScore, "Static_Content", panel, "territoryWar_KillDeathScore_Panel_" .. panel_idx .."_StaticText" )
		CopyBaseProperty(killDeathScore.content, panel_StaticText)
		panel_StaticText:SetIgnore( true )
		panel_StaticText:SetShow(true)
		panel_StaticText:SetSize( 370, 35 )


		TWKScore_PanelUIPool[panel_idx] = panel
		TWKScore_AlertList[panel_idx]	= panel_StaticText

	end
end
create_TWKScore_Panel()

local TWKScore_Open = function(panel)
	-- ♬ 시스템 메시지가 나올 때 사운드 추가
	audioPostEvent_SystemUi(04,04)
	
	panel:SetShow(true, false)	
	panel:ResetVertexAni()
	panel:SetScaleChild( 1, 1 )

	-- 켜기
	local aniInfo = panel:addColorAnimation( 0.0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo.IsChangeChild = true

	-- 꺼준다
	local aniInfo3 = panel:addColorAnimation( 0.26, 8.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo3:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo3.IsChangeChild = true
	
	local aniInfo4 = panel:addScaleAnimation( 8.0, 8.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo4:SetStartScale(1.0)
	aniInfo4:SetEndScale(0)
	aniInfo4.IsChangeChild = true
end

local TWKScore_updatePosition = function()
	-- local centerPos = ( getScreenSizeX() / 2) - (Panel_TerritoryWarKillingScore:GetSizeX() / 2)
	--한칸씩 위로 올림.
	for index = 1, TWKScore_PanelCount, 1 do
		local realIndex = ( index - TWKScore_PosIndex + 5 ) % TWKScore_PanelCount + 1
		local panel = TWKScore_PanelUIPool[index]
		if (panel:IsShow()) then
			-- panel:SetPosX( centerPos )	
			panel:SetPosY( Panel_WarInfoMessage:GetPosY() + (Panel_TerritoryWarKillingScore:GetSizeY() * realIndex) + 5 )	
		end
	end
end

function	FromClient_NotifyKillOrDeathPlayer( notifyType, isKill, characterName, characterNamePeer, guildNamePeer, isInSiege, isWarGuild, doPopup )
	local killOrDeathMsg = nil
	local colorValue = 0
	local textureDDS = ""

	local isSigeBeing 			= deadMessage_isSiegeBeingMyChannel()					-- 현재 지역이 공성 진행중인지
	local guildNameLength = string.len(guildNamePeer)

	if isKill then
		if 0 ~= guildNameLength then
			if isSigeBeing and isInSiege then
				killOrDeathMsg = PAGetStringParam3( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_SiegeAttacker", "characterName", characterName, "guildNamePeer", guildNamePeer, "characterNamePeer", characterNamePeer )
				textureDDS = "New_UI_Common_forLua/Widget/WarInfoMessage/score_KillingEnemy.dds"
				colorValue = 4282165742
			elseif isWarGuild then
				killOrDeathMsg = PAGetStringParam3( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_GuildAttacker", "characterName", characterName, "guildNamePeer", guildNamePeer, "characterNamePeer", characterNamePeer )
				textureDDS = "New_UI_Common_forLua/Widget/WarInfoMessage/score_KillingEnemy.dds"
				colorValue = 4282165742
			else
				killOrDeathMsg = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NoGuildAttacker", "characterName", characterName, "characterNamePeer", characterNamePeer )
				textureDDS = "New_UI_Common_forLua/Widget/WarInfoMessage/score_KillingEnemy.dds"
				colorValue = 4282165742
			end
		else
			if isSigeBeing and isInSiege then
				killOrDeathMsg = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_SiegeAttackerToNoSiegeAttackee", "characterName", characterNamePeer )
				textureDDS = "New_UI_Common_forLua/Widget/WarInfoMessage/score_KillingEnemy.dds"
				colorValue = 4282165742
			else
				killOrDeathMsg = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NoGuildAttacker", "characterName", characterName, "characterNamePeer", characterNamePeer )
				textureDDS = "New_UI_Common_forLua/Widget/WarInfoMessage/score_KillingEnemy.dds"
				colorValue = 4282165742
			end
		end
	else
		if 0 ~= guildNameLength then
			if isSigeBeing and isInSiege then
				killOrDeathMsg = PAGetStringParam3( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_SiegeAttackee", "characterName", characterName, "guildNamePeer", guildNamePeer, "characterNamePeer", characterNamePeer )
				textureDDS = "New_UI_Common_forLua/Widget/WarInfoMessage/score_DeathAlly.dds"
				colorValue = 4294057271			
			elseif isWarGuild then
				killOrDeathMsg = PAGetStringParam3( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_GuildAttackee", "characterName", characterName, "guildNamePeer", guildNamePeer, "characterNamePeer", characterNamePeer )
				textureDDS = "New_UI_Common_forLua/Widget/WarInfoMessage/score_DeathAlly.dds"
				colorValue = 4294057271
			else
				killOrDeathMsg = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NoGuildAttackee", "characterName", characterName, "characterNamePeer", characterNamePeer )
				textureDDS = "New_UI_Common_forLua/Widget/WarInfoMessage/score_DeathAlly.dds"
				colorValue = 4294057271
			end
		else
			if( 5 == notifyType ) then -- 몬스터, 낙사 등등에 의한 죽음
				killOrDeathMsg =  PAGetStringParam2( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_KILL", "characterNamePeer", characterNamePeer, "characterName", characterName ) -- " ["..characterNamePeer.."]에 의해 [" ..characterName.. "]가 죽임을 당했습니다."
				textureDDS = "New_UI_Common_forLua/Widget/WarInfoMessage/score_DeathAlly.dds"
				colorValue = 4294057271
			else
				killOrDeathMsg = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NoGuildAttackee", "characterName", characterName, "characterNamePeer", characterNamePeer )
				textureDDS = "New_UI_Common_forLua/Widget/WarInfoMessage/score_DeathAlly.dds"
				colorValue = 4294057271
			end
				
		end
	end
	
	if doPopup then
		TWKScore_PosIndex = (TWKScore_PosIndex % TWKScore_PanelCount ) + 1

		local targetControl = TWKScore_AlertList[TWKScore_PosIndex]
		targetControl:SetText( killOrDeathMsg )  -- characterName .. " : " .. guildNamePeer .. " 길드 - " .. characterNamePeer .. " 사살"
		targetControl:ChangeTextureInfoName ( textureDDS )
		targetControl:SetFontColor( colorValue )

		local x1, y1, x2, y2 = setTextureUV_Func( targetControl, 0, 0, 370, 35 )
		targetControl:getBaseTexture():setUV(  x1, y1, x2, y2  )
		targetControl:setRenderTexture(targetControl:getBaseTexture())

		TWKScore_Open(TWKScore_PanelUIPool[TWKScore_PosIndex])
		TWKScore_updatePosition()	
	end
	
	chatting_sendMessage( "", killOrDeathMsg, CppEnums.ChatType.Battle )	-- 전쟁 중 사살 이력 채팅창에 뿌리기.
end

-- 거점전, 공성전 판단하여 진행중 메시지 뿌림
function WarInfoMessage_IsBeingSiegeOrNodeWarNotify()
	local isVillageSiege = ToClient_IsVillageSiegeBeing()
	if (true == isVillageSiege) then
		local isFinishMinorSiege = ToClient_IsFinishMinorSiege();
		if (false == isFinishMinorSiege) then
			FromClient_NotifyStartSiege(3,0)
		end
	else
		local isFinishMajorSiege = ToClient_IsFinishMajorSiege();
		if (false == isFinishMajorSiege) then
			FromClient_NotifyStartSiege(1,0)
		end
	end
end



--------------------------------------------------------------------------------
-- 길드 결전
--------------------------------------------------------------------------------
function FromClient_NotifyGuildDuel( msgType, guildName, targetGuildName )
	local msg_type	= nil
	local msg_Main	= nil
	local msg_Sub	= nil

	if( 0 == msgType ) then
		msg_Main	= PAGetString(Defines.StringSheet_GAME, "LUA_DUELINFOMESSAGE_GUILDUELSTART_NACK_MAIN") -- "<PAColor0xffaf1426>길드결전이 시작됩니다.<PAOldColor>"
		msg_Sub		= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_DUELINFOMESSAGE_GUILDUELSTART_NACK_SUB", "guildName", guildName, "targetGuildName", targetGuildName ) 
		-- [<PAColor0xFFE49800>{guildName}<PAOldColor>] 길드와 [<PAColor0xFFE49800>{targetGuildName}<PAOldColor>] 길드의 결전이 시작됩니다.

		local message = { main = msg_Main, sub = msg_Sub, addMsg = "" }

		Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect( message, 4, 15 )
		chatting_sendMessage( "", message.sub , CppEnums.ChatType.System )
	elseif( 1 == msgType ) then
		msg_Main	= PAGetString(Defines.StringSheet_GAME, "LUA_DUELINFOMESSAGE_GUILDUELSTOP_NACK_MAIN") -- "<PAColor0xffaf1426>길드 전쟁이 종료됩니다.<PAOldColor>"
		msg_Sub		= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_DUELINFOMESSAGE_GUILDUELSTOP_NACK_WIN", "guildName", guildName, "targetGuildName", targetGuildName ) 
		-- [<PAColor0xFFE49800>{guildName}<PAOldColor>] 길드가 [<PAColor0xFFE49800>{targetGuildName}<PAOldColor>] 길드와의 결전에서 승리하였습니다.

		local message = { main = msg_Main, sub = msg_Sub, addMsg = "" }

		Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect( message, 4, 15 )
		chatting_sendMessage( "", message.sub , CppEnums.ChatType.System )
	elseif( 2 == msgType ) then
		msg_Main	= PAGetString(Defines.StringSheet_GAME, "LUA_DUELINFOMESSAGE_GUILDUELSTOP_NACK_MAIN") -- "<PAColor0xffaf1426>길드 전쟁이 종료됩니다.<PAOldColor>"
		msg_Sub		= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_DUELINFOMESSAGE_GUILDUELSTOP_NACK_DRAW", "targetGuildName", targetGuildName ) 
		-- [<PAColor0xFFE49800>{targetGuildName}<PAOldColor>] 길드와의 결전이 무승부로 종료되었습니다.

		local message = { main = msg_Main, sub = msg_Sub, addMsg = "" }

		Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect( message, 4, 15 )
		chatting_sendMessage( "", message.sub , CppEnums.ChatType.System )
	elseif( 3 == msgType ) then
		msg_Main	= PAGetString(Defines.StringSheet_GAME, "LUA_DUELINFOMESSAGE_GUILDUELSTOP_NACK_MAIN") -- "<PAColor0xffaf1426>길드 전쟁이 종료됩니다.<PAOldColor>"
		msg_Sub		= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_DUELINFOMESSAGE_GUILDUELSTOP_NACK_TIMEOVER", "targetGuildName", targetGuildName ) 
		-- [<PAColor0xFFE49800>{targetGuildName}<PAOldColor>] 길드와의 결전이 시간 초과로 종료되었습니다.

		local message = { main = msg_Main, sub = msg_Sub, addMsg = "" }

		Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect( message, 4, 15 )
		chatting_sendMessage( "", message.sub , CppEnums.ChatType.System )		
	end

end

WarInfoMessage_IsBeingSiegeOrNodeWarNotify()

registerEvent("FromClient_KillOrDeathPlayer",				"FromClient_NotifyKillOrDeathPlayer")			-- Player 킬 변화
registerEvent("FromClient_KingOrLordTentChange",			"FromClient_NotifyKingOrLordTentChange")		-- 성채/지휘소 변화 : 인자 notifyType, regionKeyRaw, guildName, guildNamePeer
registerEvent("FromClient_OccupySiege",						"FromClient_NotifyOccupySiege")					-- 점령 : 인자 regionKeyRaw, guildName
registerEvent("FromClient_ReleaseSiege",					"FromClient_NotifyReleaseSiege")				-- 해방 : 인자 regionKeyRaw
registerEvent("FromClient_NotifyAttackedKingOrLordTent",	"FromClient_NotifyAttackedKingOrLoadTent")		-- 내성채 피격 : 인자 : percent, areaName
registerEvent("FromClient_KingOrLordTentDestroy", 			"FromClient_KingOrLordTentDestroy")				-- 내 성채 파괴 : 인자 : territoryKeyRaw
registerEvent("FromClient_NotifyGuildWar",					"FromClient_NotifyGuildWar")					-- 전쟁 선포 : 인자 : msgType(int), guildName, targetGuildName
registerEvent("FromClient_NotifyStartSiege",				"FromClient_NotifyStartSiege")					-- 점령전 시작 : 인자 msgtype(int), territoryKey(int)
registerEvent("FromClient_FinishVillageSiege",				"FromClient_FinishVillageSiege")				-- 거점전 종료
registerEvent("FromClient_NotifyGuildDuel",					"FromClient_NotifyGuildDuel")					-- 전쟁 선포 : 인자 : msgType(int), guildName, 