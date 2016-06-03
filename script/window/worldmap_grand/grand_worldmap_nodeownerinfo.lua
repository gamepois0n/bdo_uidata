local UI_Color			= Defines.Color
local positionTarget	= UI.getChildControl( Panel_NodeMenu, "MainMenu_Bg");

Panel_NodeOwnerInfo:SetShow( false )
local nodeOwnerInfo = {
	ui = {
		_static_GuildMarkBG		= UI.getChildControl( Panel_NodeOwnerInfo, "NodeInfo_Static_GuildMarkBG"),
		_static_GuildMark		= UI.getChildControl( Panel_NodeOwnerInfo, "NodeInfo_Static_GuildMark"),
		_txt_GuildName_Title	= UI.getChildControl( Panel_NodeOwnerInfo, "NodeInfo_StaticText_GuildName"),
		_txt_GuildName_Value	= UI.getChildControl( Panel_NodeOwnerInfo, "NodeInfo_StaticText_GuildName_Value"),
		_txt_GuildMaster_Title	= UI.getChildControl( Panel_NodeOwnerInfo, "NodeInfo_StaticText_GuildMaster"),
		_txt_GuildMaster_Value	= UI.getChildControl( Panel_NodeOwnerInfo, "NodeInfo_StaticText_GuildMaster_Value"),
		_txt_HasDate_Title		= UI.getChildControl( Panel_NodeOwnerInfo, "NodeInfo_StaticText_HasDate"),
		_txt_HasDate_Value		= UI.getChildControl( Panel_NodeOwnerInfo, "NodeInfo_StaticText_HasDate_Value"),
		_txt_NodeBonus_Title	= UI.getChildControl( Panel_NodeOwnerInfo, "NodeInfo_NodeBonus"),
		_txt_NodeBonus_Value	= UI.getChildControl( Panel_NodeOwnerInfo, "NodeInfo_NodeBonus_Value"),
		_txt_NowWar				= UI.getChildControl( Panel_NodeOwnerInfo, "NodeInfo_StaticText_NowWar"),
	},

	config = {
	},
}

nodeOwnerInfo.ui._txt_NodeBonus_Title:SetFontColor( UI_Color.C_FFFFD46D )
nodeOwnerInfo.ui._txt_NodeBonus_Value:SetFontColor( UI_Color.C_FFEDE699 )


function nodeOwnerInfo:SetFontColor( isSiegeBeing, hasOccupant )
	if true == isSiegeBeing then
		self.ui._txt_GuildName_Title	:SetFontColor( UI_Color.C_FFD20000 )
		self.ui._txt_GuildMaster_Title	:SetFontColor( UI_Color.C_FFD20000 )
		self.ui._txt_HasDate_Title		:SetFontColor( UI_Color.C_FFD20000 )
	else
		if true == hasOccupant then
			self.ui._txt_GuildName_Title	:SetFontColor( UI_Color.C_FF00C0D7 )
			self.ui._txt_GuildMaster_Title	:SetFontColor( UI_Color.C_FF00C0D7 )
			self.ui._txt_HasDate_Title		:SetFontColor( UI_Color.C_FF00C0D7 )
		else
			self.ui._txt_GuildName_Title	:SetFontColor( UI_Color.C_FFEFEFEF )
			self.ui._txt_GuildMaster_Title	:SetFontColor( UI_Color.C_FFEFEFEF )
			self.ui._txt_HasDate_Title		:SetFontColor( UI_Color.C_FFEFEFEF )
		end
	end
end

function nodeOwnerInfo:SetShowText( isSiegeBeing )
	self.ui._txt_GuildMaster_Title	:SetShow( not isSiegeBeing )
	self.ui._txt_GuildMaster_Value	:SetShow( not isSiegeBeing )
	self.ui._txt_HasDate_Title		:SetShow( not isSiegeBeing )
	self.ui._txt_HasDate_Value		:SetShow( not isSiegeBeing )
	self.ui._txt_NowWar				:SetShow( isSiegeBeing )
end

function nodeOwnerInfo:Update( nodeStaticStatus )
	local regionInfo	= nodeStaticStatus:getMinorSiegeRegion() -- regionInfo를 가져온다
	if nil ~= regionInfo then
		local regionKey			= regionInfo._regionKey -- 리전 키
		local regionWrapper 	= getRegionInfoWrapper( regionKey:get() )
		local minorSiegeWrapper	= regionWrapper:getMinorSiegeWrapper()
		local siegeWrapper		= ToClient_GetSiegeWrapperByRegionKey( regionKey:get() )	-- SiegeWrapper
		local paDate			= siegeWrapper:getOccupyingDate()							-- 점령 시간
		local siegeTentCount	= ToClient_GetCompleteSiegeTentCount( regionKey:get() )
		--{ 거점전 혜택( 세금혜택, 생산 혜택 둘 중 하나만 혜택을 볼 수 있다. 즉, 둘중 하나의 값은 0이다.)
			local dropType				= regionInfo:getDropGroupRerollCountOfSieger()	-- 생산노드 혜택
			local nodeTaxType			= regionInfo:getVillageTaxLevel()				-- 세금 혜택
		--}
		local year				= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_YEAR", "year", tostring(paDate:GetYear()) )
		local month				= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_MONTH", "month", tostring(paDate:GetMonth()) )
		local day				= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_DAY", "day", tostring(paDate:GetDay()) )
		local hour				= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_HOUR", "hour", tostring(paDate:GetHour()) )
		local dropTypeValue		= ""
		local isSiegeBeing		= minorSiegeWrapper:isSiegeBeing()
		local hasOccupantExist	= siegeWrapper:doOccupantExist()

		self:SetShowText( isSiegeBeing )					-- 길드대장 제목, 길드대장 값, 점령일 제목, 점령일 값, 점령중인 길드 없음. 켜고 끄기.
		self:SetFontColor( isSiegeBeing, hasOccupantExist )	-- 길드명 제목, 길드대장 제목, 혜택 제목 색 지정.

		if true == isSiegeBeing then		-- 거점전이 진행중이라면
			local isSiegeChannel	= ToClient_doMinorSiegeInTerritory( regionWrapper:getTerritoryKeyRaw() )
			if true == isSiegeChannel then	-- 이 채널이 거점전 가능한 채널이라면
				self.ui._txt_NowWar:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_COUNT", "siegeTentCount", siegeTentCount ) )	-- siegeTentCount .. "개 길드가 참여중입니다.
			else
				self.ui._txt_NowWar:SetText( "<PAColor0xfff26a6a>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODEOWNERINFO_NOT_NODEWAR") .. "<PAOldColor>" )
			end

			self.ui._txt_GuildName_Value	:SetText( "<PAColor0xfff26a6a>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODEOWNERINFO_WAR") .. "<PAOldColor>" )


			if 0 == dropType and 1 <= nodeTaxType then	-- 세금 혜택
				dropTypeValue = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_TAX", "nodeTaxType", nodeTaxType ) -- "세금 혜택(" .. nodeTaxType .. " 단계)"
			elseif 1 <= dropType and 0 == nodeTaxType then
				dropTypeValue = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_LIFE", "dropType", dropType+1 ) -- "생산량 혜택(" .. dropType .. " 단계)"
			elseif 1 <= dropType and 1 <= nodeTaxType then
				dropTypeValue = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_BOTH", "nodeTaxType", tostring(nodeTaxType), "dropType", tostring(dropType+1) ) -- "세금 혜택 : " .. tostring(nodeTaxType) .. "단계 / 생산량 혜택 : " .. tostring(dropType) .. "배수"
			else
				dropTypeValue = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_NOT") -- 혜택이 없습니다.
			end
			
			self.ui._txt_NodeBonus_Value:SetText( dropTypeValue )

		else
			if true == hasOccupantExist then		-- ture면 점령자가 있다.
				local isSet = setGuildTextureByGuildNo( siegeWrapper:getGuildNo(), self.ui._static_GuildMark )
				if (not isSet) then
					self.ui._static_GuildMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
					local x1, y1, x2, y2 = setTextureUV_Func( self.ui._static_GuildMark, 183, 1, 188, 6 )
					self.ui._static_GuildMark:getBaseTexture():setUV(  x1, y1, x2, y2  )
					self.ui._static_GuildMark:setRenderTexture(self.ui._static_GuildMark:getBaseTexture())
				end

				self.ui._txt_GuildName_Value	:SetText( "<PAColor0xff00c0d7>" .. siegeWrapper:getGuildName() .. "<PAOldColor>" )
				self.ui._txt_GuildMaster_Value	:SetText( "<PAColor0xff96d4fc>" .. siegeWrapper:getGuildMasterName() .. "<PAOldColor>" )
				self.ui._txt_HasDate_Value		:SetText( "<PAColor0xff96d4fc>" .. year .. " " .. month .. " " .. day .. " " .. hour .. "<PAOldColor>" )

				if 0 == dropType and 1 <= nodeTaxType then	-- 세금 혜택
					dropTypeValue = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_TAX", "nodeTaxType", nodeTaxType ) -- "세금 혜택(" .. nodeTaxType .. " 단계)"
				elseif 1 <= dropType and 0 == nodeTaxType then
					dropTypeValue = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_LIFE", "dropType", dropType+1 ) -- "생산량 혜택(" .. dropType .. " 단계)"
				elseif 1 <= dropType and 1 <= nodeTaxType then
					dropTypeValue = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_BOTH", "nodeTaxType", tostring(nodeTaxType), "dropType", tostring(dropType+1) ) -- "세금 혜택 : " .. tostring(nodeTaxType) .. "단계 / 생산량 혜택 : " .. tostring(dropType) .. "배수"
				else
					dropTypeValue = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_NOT") -- 혜택이 없습니다.
				end

				self.ui._txt_NodeBonus_Value:SetText( dropTypeValue )
			else
				self.ui._static_GuildMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
				local x1, y1, x2, y2 = setTextureUV_Func( self.ui._static_GuildMark, 0, 0, 0, 0 )
				self.ui._static_GuildMark:getBaseTexture():setUV(  x1, y1, x2, y2  )
				self.ui._static_GuildMark:setRenderTexture(self.ui._static_GuildMark:getBaseTexture())
				
				self.ui._txt_GuildName_Value	:SetText( "<PAColor0xfff26a6a>" .. PAGetString(Defines.StringSheet_GAME, "LUA_GRAND_WORLDMAP_NODEOWNERINFO_NOWAR") .. "<PAOldColor>" )
				self.ui._txt_GuildMaster_Value	:SetText( "<PAColor0xff515151>-<PAOldColor>" )
				self.ui._txt_HasDate_Value		:SetText( "<PAColor0xff515151>-<PAOldColor>" )
				
				if 0 == dropType and 1 <= nodeTaxType then	-- 세금 혜택
					dropTypeValue = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_TAX", "nodeTaxType", nodeTaxType ) -- "세금 혜택(" .. nodeTaxType .. " 단계)"
				elseif 1 <= dropType and 0 == nodeTaxType then
					dropTypeValue = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_LIFE", "dropType", dropType+1 ) -- "생산량 혜택(" .. dropType .. " 단계)"
				elseif 1 <= dropType and 1 <= nodeTaxType then
					dropTypeValue = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_BOTH", "nodeTaxType", tostring(nodeTaxType), "dropType", tostring(dropType+1) ) -- "세금 혜택 : " .. tostring(nodeTaxType) .. "단계 / 생산량 혜택 : " .. tostring(dropType) .. "배수"
				else
					dropTypeValue = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_NOT") -- 혜택이 없습니다.
				end
				self.ui._txt_NodeBonus_Value:SetText( dropTypeValue )
			end
		end
	end
end


function FGlobal_nodeOwnerInfo_SetInfo( nodeStaticStatus )
	nodeOwnerInfo:Update( nodeStaticStatus )
end

function nodeOwnerInfo:Close()
	Panel_NodeOwnerInfo:SetShow( false )
end

function FGlobal_nodeOwnerInfo_SetPosition()
	Panel_NodeOwnerInfo:SetPosX( positionTarget:GetSpanSize().x + positionTarget:GetSizeX() + 10 )
	Panel_NodeOwnerInfo:SetPosY( positionTarget:GetSpanSize().y + 5 )
end

function FGlobal_nodeOwnerInfo_Close()
	nodeOwnerInfo:Close()
end