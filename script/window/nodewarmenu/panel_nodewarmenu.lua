local UI_color			= Defines.Color
local UI_TM 			= CppEnums.TextMode

Panel_NodeWarMenu:SetShow( false )

Panel_NodeWarMenu:RegisterShowEventFunc( true, 'Panel_NodeWarMenu_ShowAni()' )
Panel_NodeWarMenu:RegisterShowEventFunc( false, 'Panel_NodeWarMenu_HideAni()' )

function Panel_NodeWarMenu_ShowAni()
	Panel_NodeWarMenu:SetAlpha(0)
	UIAni.fadeInSCR_Down( Panel_NodeWarMenu )
	Panel_NodeWarMenu:SetShow(true)
end

function Panel_NodeWarMenu_HideAni()
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_NodeWarMenu, 0.0, 0.2 )
	aniInfo:SetHideAtEnd(true)
end
-------------------------------------------------------------------------------------------------------



local nodeWarMenu = {

	_txt_Name				= UI.getChildControl( Panel_NodeWarMenu, "StaticText_GuildName"),
	_txt_MasterName			= UI.getChildControl( Panel_NodeWarMenu, "StaticText_NodeMasterName"),
	_txt_Period				= UI.getChildControl( Panel_NodeWarMenu, "StaticText_Occupation"),
	_stc_GuildMarkBG		= UI.getChildControl( Panel_NodeWarMenu, "Static_GuildIcon_BG"),

	_txt_GuildName			= UI.getChildControl( Panel_NodeWarMenu, "StaticText_GuildNameValue"),
	_txt_NodeMasterName		= UI.getChildControl( Panel_NodeWarMenu, "StaticText_NodeMasterNameValue"),
	_txt_NodeOccupation		= UI.getChildControl( Panel_NodeWarMenu, "StaticText_OccupationValue"),
	_txt_GuildMark			= UI.getChildControl( Panel_NodeWarMenu, "Static_GuildIcon"),

	_txt_NodeWarBenefits	= UI.getChildControl( Panel_NodeWarMenu, "StaticText_NodeBenefitsValue"),

	_txt_NoOccupation		= UI.getChildControl( Panel_NodeWarMenu, "StaticText_NoOccupation"),

	_txt_NodeWarProcessing	= UI.getChildControl( Panel_NodeWarMenu, "StaticText_NodeWarProcessing"),

	_btn_GetTax				= UI.getChildControl( Panel_NodeWarMenu, "Button_GetTax"),

	_txt_tax				= UI.getChildControl( Panel_NodeWarMenu, "StaticText_Tax"),
	_txt_taxValue			= UI.getChildControl( Panel_NodeWarMenu, "StaticText_TaxValue"),
}

function NodeWarMenuInit()
	local scrX = getScreenSizeX()
	local scrY = getScreenSizeY()

	Panel_NodeWarMenu:SetPosX( scrX/2 - (Panel_NodeWarMenu:GetSizeX() /2 ) )
	Panel_NodeWarMenu:SetPosY( scrY/2 - Panel_NodeWarMenu:GetSizeY()/2 - 30 )
	Panel_NodeWarMenu:ComputePos()
end

function NodeWarMenuUpdate()
	local self = nodeWarMenu
	local minorSiegeWrapper			= ToClient_GetCurrentMinorSiegeWrapper()
	if nil == minorSiegeWrapper then
		return
	end

	if false == minorSiegeWrapper:doOccupantExist() then
		self._txt_NoOccupation		:SetShow( true )		-- 점령 길드가 없습니다.
		self._txt_Name				:SetShow( false )
		self._txt_MasterName		:SetShow( false )
		self._txt_Period			:SetShow( false )
		self._stc_GuildMarkBG		:SetShow( false )

		self._txt_GuildName			:SetShow( false )
		self._txt_NodeMasterName	:SetShow( false )
		self._txt_NodeOccupation	:SetShow( false )
		self._txt_GuildMark			:SetShow( false )

		self._txt_NodeWarBenefits	:SetText( "없음" )
	end
	local regionInfo			= ToClient_GetCurrentMinorSiegeRegion()
	local regionKey				= regionInfo._regionKey -- 리전 키
	local regionWrapper			= getRegionInfoWrapper( regionKey:get() )
	local isSiegeChannel		= ToClient_doMinorSiegeInTerritory(regionWrapper:getTerritoryKeyRaw())
	local nodeGuildName			= minorSiegeWrapper:getGuildName()			-- 길드이름
	local nodeGuildMasterName	= minorSiegeWrapper:getGuildMasterName()		-- 거점장 이름
	local paDate				= minorSiegeWrapper:getOccupyingDate()		-- 점령 시간

	local isLord				= minorSiegeWrapper:isLord()
	local nodeTax_s64			= minorSiegeWrapper:getTaxRemainedAmountForFortress() -- 세금
	local dropType				= regionInfo:getDropGroupRerollCountOfSieger()
	local nodeTaxType			= regionInfo:getVillageTaxLevel()
	local year = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_YEAR", "year", tostring(paDate:GetYear()) )
	local month = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_MONTH", "month", tostring(paDate:GetMonth()) )
	local day = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_DAY", "day", tostring(paDate:GetDay()) )
	local hour = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_HOUR", "hour", tostring(paDate:GetHour()) )

	if true == minorSiegeWrapper:isSiegeBeing() then
		self._txt_NodeWarProcessing	:SetShow( true )
		self._txt_Name				:SetShow( false )
		self._txt_MasterName		:SetShow( false )
		self._txt_Period			:SetShow( false )
		self._stc_GuildMarkBG		:SetShow( false )
		self._txt_GuildName			:SetShow( false )
		self._txt_NodeMasterName	:SetShow( false )
		self._txt_NodeOccupation	:SetShow( false )
		self._txt_GuildMark			:SetShow( false )
		self._txt_taxValue			:SetShow( false )

		if 0 == dropType and 1 <= nodeTaxType then	-- 세금 혜택
			dropTypeValue = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_TAX", "nodeTaxType", nodeTaxType ) -- "세금 혜택(" .. nodeTaxType .. " 단계)"
		elseif 1 <= dropType and 0 == nodeTaxType then
			dropTypeValue = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_LIFE", "dropType", dropType+1 ) -- "생산량 혜택(" .. dropType .. " 단계)"
		elseif 1 <= dropType and 1 <= nodeTaxType then
			dropTypeValue = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_BOTH_NPC", "nodeTaxType", tostring(nodeTaxType), "dropType", tostring(dropType+1) ) -- "세금 혜택 : " .. tostring(nodeTaxType) .. "단계 / 생산량 혜택 : " .. tostring(dropType) .. "배수"
		else
			dropTypeValue = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_NOT") -- 혜택이 없습니다.
		end

		self._btn_GetTax:SetShow( false )
		self._txt_NodeWarBenefits	:SetShow( true )
		self._txt_NodeWarBenefits	:SetText( dropTypeValue )
	else
		self._txt_NodeWarProcessing	:SetShow( false )
		local isSet = setGuildTextureByGuildNo( minorSiegeWrapper:getGuildNo(), self._txt_GuildMark )
		if (not isSet) then
			self._txt_GuildMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( self._txt_GuildMark, 183, 1, 188, 6 )
			self._txt_GuildMark:getBaseTexture():setUV(  x1, y1, x2, y2  )
			self._txt_GuildMark:setRenderTexture(self._txt_GuildMark:getBaseTexture())
		end

		if 0 == dropType and 1 <= nodeTaxType then	-- 세금 혜택
			dropTypeValue = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_TAX", "nodeTaxType", nodeTaxType ) -- "세금 혜택(" .. nodeTaxType .. " 단계)"
		elseif 1 <= dropType and 0 == nodeTaxType then
			dropTypeValue = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_LIFE", "dropType", dropType+1 ) -- "생산량 혜택(" .. dropType .. " 단계)"
		elseif 1 <= dropType and 1 <= nodeTaxType then
			dropTypeValue = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_BOTH_NPC", "nodeTaxType", tostring(nodeTaxType), "dropType", tostring(dropType+1) ) -- "세금 혜택 : " .. tostring(nodeTaxType) .. "단계 / 생산량 혜택 : " .. tostring(dropType) .. "배수"
		else
			dropTypeValue = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_NOT") -- 혜택이 없습니다.
		end
		if 1 <= nodeTaxType and isLord and isSiegeChannel then
			if toInt64(0,0) == nodeTax_s64 then
				self._btn_GetTax	:SetShow( false )
			else
				self._btn_GetTax	:SetShow( true )
			end
			self._txt_tax		:SetShow( true )
			self._txt_taxValue	:SetShow( true )
			self._txt_taxValue	:SetText( makeDotMoney(nodeTax_s64) )
		else
			self._txt_tax		:SetShow( false )
			self._btn_GetTax	:SetShow( false )
			self._txt_taxValue	:SetShow( false )
		end

		self._txt_GuildName			:SetText( nodeGuildName )
		self._txt_NodeMasterName	:SetText( nodeGuildMasterName )
		self._txt_NodeOccupation	:SetText( year .. " " .. month .. " " .. day .. " " .. hour )

		self._txt_NodeWarBenefits	:SetText( dropTypeValue )
	end
end

function FGlobal_NodeWarMenuOpen()
	local minorSiegeWrapper			= ToClient_GetCurrentMinorSiegeWrapper()
	if nil == minorSiegeWrapper then
		return
	end
	local isLord				= minorSiegeWrapper:isLord()
	local regionInfo			= ToClient_GetCurrentMinorSiegeRegion()
	local regionKey				= regionInfo._regionKey -- 리전 키
	local regionWrapper			= getRegionInfoWrapper( regionKey:get() )
	local minorSiegeWrapper		= regionWrapper:getMinorSiegeWrapper()
	local isSiegeChannel		= ToClient_doMinorSiegeInTerritory(regionWrapper:getTerritoryKeyRaw())
_PA_LOG("정태곤", "isSiegeChannel : " .. tostring(isSiegeChannel))
	if (isLord) and isSiegeChannel then
		minorSiegeWrapper:updateTaxAmount( true )
	else
		NodeWarMenuUpdate()
	end
	Panel_NodeWarMenu:SetShow( true, true )
end

function FGlobal_NodeWarMenuClose()
	Panel_NodeWarMenu:SetShow( false, false )
end

function NodeWarMenuOnScreenReSize()
	local scrX = getScreenSizeX()
	local scrY = getScreenSizeY()

	Panel_NodeWarMenu:SetPosX( scrX/2 - (Panel_NodeWarMenu:GetSizeX() /2 ) )
	Panel_NodeWarMenu:SetPosY( scrY/2 - Panel_NodeWarMenu:GetSizeY()/2 - 30 )
	Panel_NodeWarMenu:ComputePos()
end

--{ 세금 인출
function NodeWarMenu_Withdraw_Money()
	local regionInfo			= ToClient_GetCurrentMinorSiegeRegion()
	if (nil == regionInfo) then
		return
	end	
	local minorSiegeWrapper		= ToClient_GetCurrentMinorSiegeWrapper()
	if (nil == minorSiegeWrapper) then
		return
	end	
	
	local doOccupantExist = minorSiegeWrapper:doOccupantExist()
	if (not doOccupantExist) then
		return;
	end
	
	local isLord = minorSiegeWrapper:isLord()
	
	if (not isLord) then
		return
	end
	
	local taxRemainedAmountForFortress = minorSiegeWrapper:getTaxRemainedAmountForFortress()
	
	Panel_NumberPad_Show(true, taxRemainedAmountForFortress, 0, NodeWarMenu_Withdraw_Money_Message)
end

local withdrawMoney = 0
function NodeWarMenu_Withdraw_Money_Message(inputNumber, param)
	withdrawMoney = inputNumber
	
	local	messageBoxMemo	= makeDotMoney(withdrawMoney)..PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_WITHDRAW_CONTENT")
	local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_WITHDRAW_TITLE"), content = messageBoxMemo, functionYes = NodeWarMenu_Withdraw_Money_Confirm, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData)
end

function NodeWarMenu_Withdraw_Money_Confirm()
	local regionInfo			= ToClient_GetCurrentMinorSiegeRegion()
	if (nil == regionInfo) then
		return
	end	
	local minorSiegeWrapper		= ToClient_GetCurrentMinorSiegeWrapper()
	if (nil == minorSiegeWrapper) then
		return
	end	
	
	if (0 == inputNumber) then
		return
	end	
	
	minorSiegeWrapper:moveTownTaxToWarehouse(withdrawMoney, true)
end
--}
function NodeWarMenu_registEventHandler()
	nodeWarMenu._btn_GetTax:addInputEvent("Mouse_LUp", "NodeWarMenu_Withdraw_Money()")
end

function NodeWarMenu_registMessageHandler()
	registerEvent("EventLordMenuPayInfoUpdate", "NodeWarMenuUpdate()")
	registerEvent("onScreenResize",				"NodeWarMenuOnScreenReSize()")
end

NodeWarMenuInit()
NodeWarMenu_registEventHandler()
NodeWarMenu_registMessageHandler()