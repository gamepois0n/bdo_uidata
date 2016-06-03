local IM 			= CppEnums.EProcessorInputMode
local UI_TM 		= CppEnums.TextMode
local UI_ANI_ADV	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color

Panel_Housing_FarmInfo_New:SetShow( false )
Panel_Housing_FarmInfo_New:RegisterShowEventFunc( true, 'Panel_Housing_FarmInfo_ShowAni()' )
Panel_Housing_FarmInfo_New:RegisterShowEventFunc( false, 'Panel_Housing_FarmInfo_HideAni()' )
Panel_Housing_FarmInfo_New:setGlassBackground( true )
Panel_Housing_FarmInfo_New:ActiveMouseEventEffect( true )

function Panel_Housing_FarmInfo_ShowAni()
	local aniInfo1 = Panel_Housing_FarmInfo_New:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.2)
	aniInfo1.AxisX = Panel_Housing_FarmInfo_New:GetSizeX() / 2
	aniInfo1.AxisY = Panel_Housing_FarmInfo_New:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_Housing_FarmInfo_New:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.2)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_Housing_FarmInfo_New:GetSizeX() / 2
	aniInfo2.AxisY = Panel_Housing_FarmInfo_New:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function Panel_Housing_FarmInfo_HideAni()
	Panel_Housing_FarmInfo_New:SetAlpha( 1 )
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_Housing_FarmInfo_New, 0.0, 0.1 )
	aniInfo:SetHideAtEnd(true)
end

local farmInfo = {
	_currentActorKeyRaw = nil,
	_tempPercent = 0,
	_humidityPercent = 0,
	_isShowOnlyGround = false,
	_ui = {
		staticText_Title						= UI.getChildControl ( Panel_Housing_FarmInfo_New, "StaticText_Title" ),
		button_Question							= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Button_Question" ),
		button_Close							= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Button_Win_Close" ),
		static_FarmInfoBG						= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Static_FarmInfoBG" ),
		staticText_FarmTitle					= UI.getChildControl ( Panel_Housing_FarmInfo_New, "StaticText_FarmTitle" ),
		staticText_Temperature_Title			= UI.getChildControl ( Panel_Housing_FarmInfo_New, "StaticText_Temperature_Title" ),
		static_TemperatureBG					= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Static_TemperatureBG" ),
		static_TemperatureHighlight				= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Static_TemperatureHighlight" ),
		slider_Temperature						= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Slider_Temperature" ),
		static_Temperature_Arrow				= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Static_Temperature_Arrow" ),
		staticText_Temperature_Value			= UI.getChildControl ( Panel_Housing_FarmInfo_New, "StaticText_Temperature_Value" ),
		staticText_Temperature_Desc				= UI.getChildControl ( Panel_Housing_FarmInfo_New, "StaticText_TemperatureDesc" ),
		
		staticText_Humidity_Title				= UI.getChildControl ( Panel_Housing_FarmInfo_New, "StaticText_Humidity_Title" ),
		static_HumidityBG						= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Static_HumidityBG" ),
		static_HumidityHighlight				= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Static_HumidityHighlight" ),
		slider_Humidity							= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Slider_Humidity" ),
		static_Humidity_Arrow					= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Static_Humidity_Arrow" ),
		staticText_Humidity_Value				= UI.getChildControl ( Panel_Housing_FarmInfo_New, "StaticText_Humidity_Value" ),
		staticText_Humidity_Desc				= UI.getChildControl ( Panel_Housing_FarmInfo_New, "StaticText_HumidityDesc" ),
		
		staticText_RemainTime					= UI.getChildControl ( Panel_Housing_FarmInfo_New, "StaticText_RemainTime" ),
		staticText_RemainTime_Value				= UI.getChildControl ( Panel_Housing_FarmInfo_New, "StaticText_RemainTime_Value" ),
		button_NowStatus						= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Button_NowStatus" ),
		static_FarmIconBG						= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Static_FarmIconBG" ),
		static_FarmIcon_Scarecrow				= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Static_FarmIcon_Scarecrow" ),			--
		staticText_FarmIcon_ScarecrowDesc		= UI.getChildControl ( Panel_Housing_FarmInfo_New, "StaticText_FarmIcon_ScarecrowDesc" ),
		static_FarmIcon_Waterway				= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Static_FarmIcon_Waterway" ),			--
		staticText_FarmIcon_WaterWayDesc		= UI.getChildControl ( Panel_Housing_FarmInfo_New, "StaticText_FarmIcon_WaterWayDesc" ),
		static_CropsInfoBG						= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Static_CropsInfoBG" ),
		staticText_CropsTitle					= UI.getChildControl ( Panel_Housing_FarmInfo_New, "StaticText_CropsTitle" ),
		staticText_Growing						= UI.getChildControl ( Panel_Housing_FarmInfo_New, "StaticText_Growing" ),
		progressBack_Growing					= UI.getChildControl ( Panel_Housing_FarmInfo_New, "ProgressBack_Growing" ),
		progress_Growing						= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Progress_Growing" ),
		staticText_Growing_Value				= UI.getChildControl ( Panel_Housing_FarmInfo_New, "StaticText_Growing_Value" ),
		staticText_Helth						= UI.getChildControl ( Panel_Housing_FarmInfo_New, "StaticText_Helth" ),
		progressBack_Helth						= UI.getChildControl ( Panel_Housing_FarmInfo_New, "ProgressBack_Helth" ),
		progress_Helth							= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Progress_Helth" ),
		staticText_Helth_Value					= UI.getChildControl ( Panel_Housing_FarmInfo_New, "StaticText_Helth_Value" ),
		staticText_NeedWater					= UI.getChildControl ( Panel_Housing_FarmInfo_New, "StaticText_NeedWater" ),
		progressBack_NeedWater					= UI.getChildControl ( Panel_Housing_FarmInfo_New, "ProgressBack_NeedWater" ),
		progress_NeedWater						= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Progress_NeedWater" ),
		staticText_NeedWater_Value				= UI.getChildControl ( Panel_Housing_FarmInfo_New, "StaticText_NeedWater_Value" ),
		static_CropsIconBG						= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Static_CropsIconBG" ),
		static_CropsIcon_Pruning				= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Static_CropsIcon_Pruning" ),			--
		staticText_CropsIcon_PruningDesc		= UI.getChildControl ( Panel_Housing_FarmInfo_New, "StaticText_CropsIcon_PruningDesc" ),
		static_CropsIcon_InsectDamege			= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Static_CropsIcon_InsectDamege" ),		--
		staticText_CropsIcon_InsectDamegeDesc	= UI.getChildControl ( Panel_Housing_FarmInfo_New, "StaticText_CropsIcon_InsectDamegeDesc" ),
		
		static_FarmIcon_Scarecrow_Eff			= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Static_ScareCrow_Eff" ),		--
		static_FarmIcon_Waterway_Eff			= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Static_Water_Eff" ),			--
		static_CropsIcon_Pruning_Eff			= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Static_Cutting_Eff" ),			--
		static_CropsIcon_InsectDamege_Eff		= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Static_Insect_Eff" ),			--

		staticText_UndergroundWater				= UI.getChildControl ( Panel_Housing_FarmInfo_New, "StaticText_UndergroundWater" ),	--
		staticText_Compost						= UI.getChildControl ( Panel_Housing_FarmInfo_New, "StaticText_Compost" ),			--
		progress2_UndergroundWater1				= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Progress2_UndergroundWater1" ),	--
		progress2_UndergroundWater2				= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Progress2_UndergroundWater2" ),	--
		staticText_UndergroundWater_Value		= UI.getChildControl ( Panel_Housing_FarmInfo_New, "StaticText_UndergroundWater_Value" ),	--
		static_CompostBG						= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Static_CompostBG" ),			--
		progress2_Compost						= UI.getChildControl ( Panel_Housing_FarmInfo_New, "Progress2_Compost" ),			--
	},
	_uiIconUV = {
		static_FarmIcon_Scarecrow				= { [true] = { x0 = 106,	x1 = 148,	y0 = 76,	y1 = 118	},	[false] = { x0 = 106,	x1 = 148,	y0 = 123,	y1 = 165	},	},
		static_FarmIcon_Waterway				= { [true] = { x0 = 153,	x1 = 195,	y0 = 76,	y1 = 118	},	[false] = { x0 = 153,	x1 = 195,	y0 = 123,	y1 = 165	},	},
		static_CropsIcon_Pruning				= { [true] = { x0 = 12,		x1 = 54,	y0 = 76,	y1 = 118	},	[false] = { x0 = 12,	x1 = 54,	y0 = 123,	y1 = 165	},	},
		static_CropsIcon_InsectDamege			= { [true] = { x0 = 59,		x1 = 101,	y0 = 76,	y1 = 118	},	[false] = { x0 = 59,	x1 = 101,	y0 = 123,	y1 = 165	},	},
	},
	_isChange = false,
}

function farmInfo:init()
	Panel_Housing_FarmInfo_New:RegisterUpdateFunc("PAHousingFarmInfo_UpdatePerFrame")
	self._ui.button_NowStatus			:addInputEvent("Mouse_LDown",	"PAHousing_FarmInfo_NowState()")
	self._ui.button_Close				:addInputEvent("Mouse_LUp",		"PAHousing_FarmInfo_Close()")
	--self._ui.static_Temperature_Arrow	:addInputEvent("Mouse_LUp",		"PAHousing_FarmInfo_UpdateCursor()")
	--self._ui.static_Humidity_Arrow		:addInputEvent("Mouse_LUp",		"PAHousing_FarmInfo_UpdateCursor()")
	self._ui.button_Question			:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelWindowTent\" )" )
	
	-- self._ui.staticText_Temperature_Title	:addInputEvent( "Mouse_On", "Panel_FarmInfo_ValueDescFunc( true, " .. 1 .. " )" )
	-- self._ui.staticText_Humidity_Title		:addInputEvent( "Mouse_On", "Panel_FarmInfo_ValueDescFunc( true, " .. 2 .. " )" )
	-- self._ui.staticText_Temperature_Title	:addInputEvent( "Mouse_Out", "Panel_FarmInfo_ValueDescFunc( false, " .. 1 .. " )" )
	-- self._ui.staticText_Humidity_Title		:addInputEvent( "Mouse_Out", "Panel_FarmInfo_ValueDescFunc( false, " .. 2 .. " )" )
	
	-- self._ui.staticText_Temperature_Value	:addInputEvent( "Mouse_On", "Panel_FarmInfo_ValueDescFunc( true, " .. 1 .. " )" )
	-- self._ui.staticText_Humidity_Value		:addInputEvent( "Mouse_On", "Panel_FarmInfo_ValueDescFunc( true, " .. 2 .. " )" )
	-- self._ui.staticText_Temperature_Value	:addInputEvent( "Mouse_Out", "Panel_FarmInfo_ValueDescFunc( false, " .. 1 .. " )" )
	-- self._ui.staticText_Humidity_Value		:addInputEvent( "Mouse_Out", "Panel_FarmInfo_ValueDescFunc( false, " .. 2 .. " )" )

	self._ui.staticText_Temperature_Title		:addInputEvent( "Mouse_On", "farmInfo_SimpleToolTips( true, 0 )")		-- 온도
	self._ui.staticText_Temperature_Title		:addInputEvent( "Mouse_Out", "TooltipSimple_Hide()")	-- 온도
	self._ui.staticText_Humidity_Title			:addInputEvent( "Mouse_On", "farmInfo_SimpleToolTips( true, 1 )")		-- 습도
	self._ui.staticText_Humidity_Title			:addInputEvent( "Mouse_Out", "TooltipSimple_Hide()")	-- 습도
	self._ui.staticText_UndergroundWater		:addInputEvent( "Mouse_On", "farmInfo_SimpleToolTips( true, 2 )")		-- 지하수
	self._ui.staticText_UndergroundWater		:addInputEvent( "Mouse_Out", "TooltipSimple_Hide()")	-- 지하수
	self._ui.staticText_Compost					:addInputEvent( "Mouse_On", "farmInfo_SimpleToolTips( true, 3 )")		-- 비료
	self._ui.staticText_Compost					:addInputEvent( "Mouse_Out", "TooltipSimple_Hide()")	-- 비료
	self._ui.staticText_Growing					:addInputEvent( "Mouse_On", "farmInfo_SimpleToolTips( true, 4 )")	-- 성장
	self._ui.staticText_Growing					:addInputEvent( "Mouse_Out", "TooltipSimple_Hide()")	-- 성장
	self._ui.staticText_Helth					:addInputEvent( "Mouse_On", "farmInfo_SimpleToolTips( true, 5 )")	-- 건강
	self._ui.staticText_Helth					:addInputEvent( "Mouse_Out", "TooltipSimple_Hide()")	-- 건강
	self._ui.staticText_NeedWater				:addInputEvent( "Mouse_On", "farmInfo_SimpleToolTips( true, 6 )")	-- 수분
	self._ui.staticText_NeedWater				:addInputEvent( "Mouse_Out", "TooltipSimple_Hide()")	-- 수분
	self._ui.staticText_Temperature_Title		:setTooltipEventRegistFunc("farmInfo_SimpleToolTips( true, 0 )")
	self._ui.staticText_Humidity_Title			:setTooltipEventRegistFunc("farmInfo_SimpleToolTips( true, 1 )")
	self._ui.staticText_UndergroundWater		:setTooltipEventRegistFunc("farmInfo_SimpleToolTips( true, 2 )")
	self._ui.staticText_Compost					:setTooltipEventRegistFunc("farmInfo_SimpleToolTips( true, 3 )")
	self._ui.staticText_Growing					:setTooltipEventRegistFunc("farmInfo_SimpleToolTips( true, 4 )")
	self._ui.staticText_Helth					:setTooltipEventRegistFunc("farmInfo_SimpleToolTips( true, 5 )")
	self._ui.staticText_NeedWater				:setTooltipEventRegistFunc("farmInfo_SimpleToolTips( true, 6 )")
end

function Panel_FarmInfo_ValueDescFunc( isOn, descType )
	farmInfo._ui.staticText_Temperature_Desc:	SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_TEMPERATURE_DESC_DEFAULT") ) -- "온도는 성장 속도에 영향을 미칩니다." )
	farmInfo._ui.staticText_Humidity_Desc:		SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_HUMIDITY_DESC_DEFAULT") ) -- "습도는 병충해에 걸릴 확률에 영향을 미칩니다." )
	
	if ( isOn == true ) then
		if ( descType == 1 ) then
			farmInfo._ui.staticText_Temperature_Desc:SetShow( true )
			farmInfo._ui.staticText_Humidity_Desc:SetShow( false )
		elseif ( descType == 2 ) then
			farmInfo._ui.staticText_Temperature_Desc:SetShow( false )
			farmInfo._ui.staticText_Humidity_Desc:SetShow( true )
		end
	else
		farmInfo._ui.staticText_Temperature_Desc:SetShow( false )
		farmInfo._ui.staticText_Humidity_Desc:SetShow( false )
	end
	farmInfo._ui.staticText_Temperature_Desc:SetSize( farmInfo._ui.staticText_Temperature_Desc:GetTextSizeX() + 20, farmInfo._ui.staticText_Temperature_Desc:GetSizeY() )
	farmInfo._ui.staticText_Humidity_Desc:SetSize( farmInfo._ui.staticText_Humidity_Desc:GetTextSizeX() + 20, farmInfo._ui.staticText_Humidity_Desc:GetSizeY() )
end

function farmInfo:updateIcon( key, effectUIKey, isOn )
	local uvGroup = self._uiIconUV[key][isOn]
	local targetUI = self._ui[key]
	local effectUI = self._ui[effectUIKey]

	if ( nil == uvGroup ) then
		return
	end
	if ( nil == targetUI ) then
		return
	end
	if ( nil == effectUI ) then
		return
	end

	if (farmInfo._isChange) then
		if "static_CropsIcon_Pruning" == key or "static_CropsIcon_InsectDamege" == key then
			targetUI:ChangeTextureInfoName( "new_ui_common_forlua/widget/housing/housing_tentobjectinfo_01.dds" )
		end
		
		if "static_CropsIcon_Pruning_Eff" == effectUIKey then
			effectUI:ChangeTextureInfoName( "new_ui_common_forlua/widget/housing/housing_tentobjectinfo_00.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( effectUI, 12, 209, 54, 251 )
			effectUI:getBaseTexture():setUV( x1, y1, x2, y2 )
			effectUI:setRenderTexture(effectUI:getBaseTexture())
		end
		
		if "static_CropsIcon_InsectDamege_Eff" == effectUIKey then
			effectUI:ChangeTextureInfoName( "new_ui_common_forlua/widget/housing/housing_tentobjectinfo_00.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( effectUI, 59, 209, 101, 251 )
			effectUI:getBaseTexture():setUV( x1, y1, x2, y2 )
			effectUI:setRenderTexture(effectUI:getBaseTexture())
		end
	else
		if "static_CropsIcon_Pruning" == key or "static_CropsIcon_InsectDamege" == key then
			targetUI:ChangeTextureInfoName( "new_ui_common_forlua/widget/housing/housing_tentobjectinfo_00.dds" )
		end
		
		if "static_CropsIcon_Pruning_Eff" == effectUIKey then
			effectUI:ChangeTextureInfoName( "new_ui_common_forlua/widget/housing/housing_tentobjectinfo_00.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( effectUI, 12, 76, 54, 118 )
			effectUI:getBaseTexture():setUV( x1, y1, x2, y2 )
			effectUI:setRenderTexture(effectUI:getBaseTexture())
		end
		if "static_CropsIcon_InsectDamege_Eff" == effectUIKey then
			effectUI:ChangeTextureInfoName( "new_ui_common_forlua/widget/housing/housing_tentobjectinfo_00.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( effectUI, 59, 166, 101, 208 )
			effectUI:getBaseTexture():setUV( x1, y1, x2, y2 )
			effectUI:setRenderTexture(effectUI:getBaseTexture())
		end
	end
	targetUI:SetShow(true)
	local x1, y1, x2, y2 = setTextureUV_Func( targetUI, uvGroup.x0, uvGroup.y0, uvGroup.x1, uvGroup.y1 )
	targetUI:getBaseTexture():setUV( x1, y1, x2, y2 )
	targetUI:setRenderTexture(targetUI:getBaseTexture())

	if ( effectUI:GetShow() ~= isOn ) then
		effectUI:SetShow(isOn)
	end
end

function farmInfo:setProgressBar( progressBarKey, textKey, value )
	local progressBarUI = self._ui[progressBarKey]
	local textUI = self._ui[textKey]
	if ( nil == progressBarUI ) then
		return
	end
	if ( nil == textUI ) then
		return
	end

	progressBarUI:SetProgressRate( value )
	textUI:SetText( string.format( "%.0f%%", value ) )
end

function farmInfo:setSliderAndStatic( sliderKey, staticKey, textKey, value, textRate, viewDetail )
	local sliderUI	= self._ui[sliderKey]
	local staticUI	= self._ui[staticKey]
	local textUI	= self._ui[textKey]

	
	if ( nil == sliderUI ) then
		return
	end
	if ( nil == staticUI ) then
		return
	end
	if ( nil == textUI ) then
		return
	end


	if ( nil ~= value ) then
		sliderUI:SetControlPos( value )
		staticUI:SetPosX(sliderUI:GetControlButton():GetParentPosX() - Panel_Housing_FarmInfo_New:GetPosX())
	end
	if ( viewDetail ) then
		textUI:SetText( string.format( "%.2f%%", textRate ) )
	else
		textUI:SetText( string.format( "%.0f%%", textRate ) )
	end
end

function farmInfo:setProgressBarOnly( sliderKey, value )
	local sliderUI	= self._ui[sliderKey]
	
	if ( nil == sliderUI ) then
		return
	end

	if ( nil ~= value ) then
		sliderUI:SetProgressRate( value )
	end
end

function farmInfo:setSliderHighlight( maxStaticKey, staticKey, valuePair )
	local staticUI	= self._ui[staticKey]
	local maxSizeStaticUI	= self._ui[maxStaticKey]
	local rate = 0

	if ( nil == staticUI ) then
		return
	end
	if ( nil == maxSizeStaticUI ) then
		return
	end

	if ( nil ~= valuePair ) then
		rate = (valuePair.y - valuePair.x) / 100
	end
	if ( 0 == rate ) then
		staticUI:SetShow(false)
		return
	end
	staticUI:SetShow(true)
	staticUI:SetSize( rate * maxSizeStaticUI:GetSizeX(), staticUI:GetSizeY() )
	staticUI:SetPosX( valuePair.x / 100 * maxSizeStaticUI:GetSizeX() + maxSizeStaticUI:GetPosX() )
end

function farmInfo:update( isRePosition )
	if ( self._isShowOnlyGround ) then
		local actorKeyRaw = toClient_GetHousingSelectInstallationActorKey()
		if ( toClient_GetHousingSelectInstallationActorKeyIsSet() )  then
			farmInfo._currentActorKeyRaw = actorKeyRaw
			self._isShowOnlyGround = false
		end
	end

	if ( self._isShowOnlyGround ) then
		local ownerHouseHoldNo = housing_getInstallmodeHouseHoldNo()
		local itemEnchantSSW = housing_getItemEnchantStaticStatus()
		local cultivationWeatherSSW = itemEnchantSSW:getCharacterStaticStatus():getObjectStaticStatus():getCultivationWeatherStaticStatusWrapper()

		
		self._ui.staticText_Title:SetText( itemEnchantSSW:getCharacterStaticStatus():getName() )

		local growingRate = housing_getGrowingRate(itemEnchantSSW:get())
		local remainingTime = 1000000 / growingRate * 5 * 60
		self._ui.staticText_RemainTime_Value:SetText(convertStringFromDatetime( toInt64(0,remainingTime) ))
		self._ui.staticText_RemainTime_Value:SetFontColor( UI_color.C_FFEFEFEF )
		
		self:updateData( isRePosition, ownerHouseHoldNo, cultivationWeatherSSW, nil )
	else
		if ( nil == farmInfo._currentActorKeyRaw ) then
			return
		end
		local installationActorProxyWrapper = getInstallationActor( farmInfo._currentActorKeyRaw )
		if ( nil == installationActorProxyWrapper ) then
			PAHousing_FarmInfo_Close()
			return
		end

		local ownerHouseHoldNo = installationActorProxyWrapper:get():getOwnerHouseholdNo_s64()
		local progressingInfo = installationActorProxyWrapper:get():getInstallationProgressingInfo()
		if ( nil == ownerHouseHoldNo ) or ( nil == progressingInfo ) then
			PAHousing_FarmInfo_Close()
			return
		end

		local serverUtc64Time = getServerUtc64()

		self._currentActorKeyRaw = installationActorProxyWrapper:get():getActorKeyRaw()
		
		self._ui.staticText_Title:SetText( installationActorProxyWrapper:getStaticStatusWrapper():getName() )
		
		if ( progressingInfo:isGrowingStop() ) then
			self._ui.staticText_RemainTime_Value:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_STOP") ) -- "정지됨")
			self._ui.staticText_RemainTime_Value:SetFontColor( UI_color.C_FFF26A6A )
		else
			self._ui.staticText_RemainTime_Value:SetText(convertStringFromDatetime(progressingInfo:getCompleteTime(serverUtc64Time)))
			self._ui.staticText_RemainTime_Value:SetFontColor( UI_color.C_FFEFEFEF )
		end
		local cultivationWeatherSSW = installationActorProxyWrapper:getStaticStatusWrapper():getObjectStaticStatus():getCultivationWeatherStaticStatusWrapper()

		self:updateData( isRePosition, ownerHouseHoldNo, cultivationWeatherSSW, progressingInfo, serverUtc64Time )
		
	end

	Panel_Housing_FarmInfo_New:SetShow( true, false )
end

function farmInfo:updateData(isRePosition, ownerHouseHoldNo, cultivationWeatherSSW, progressingInfo, serverUtc64Time)
	if ( isRePosition ) then
		self._tempPercent		= housing_getInstallationMenuHarvestTempRate(ownerHouseHoldNo)
		self._humidityPercent	= housing_getInstallationMenuHarvestHumidity(ownerHouseHoldNo)
		self:setSliderAndStatic( "slider_Temperature",		"static_Temperature_Arrow",		"staticText_Temperature_Value", self._tempPercent,		cultivationWeatherSSW:getRateByWeather( CppEnums.WeatherKind.WeatherKind_Temperature,	self._tempPercent		) / 10000, true )
		self:setSliderAndStatic( "slider_Humidity",			"static_Humidity_Arrow",		"staticText_Humidity_Value",	self._humidityPercent,	cultivationWeatherSSW:getRateByWeather( CppEnums.WeatherKind.WeatherKind_Humidity,		self._humidityPercent	) / 10000, false )
	else
		self:setSliderAndStatic( "slider_Temperature",		"static_Temperature_Arrow",		"staticText_Temperature_Value", nil,					cultivationWeatherSSW:getRateByWeather( CppEnums.WeatherKind.WeatherKind_Temperature,	self._tempPercent		) / 10000, true )
		self:setSliderAndStatic( "slider_Humidity",			"static_Humidity_Arrow",		"staticText_Humidity_Value",	nil,					cultivationWeatherSSW:getRateByWeather( CppEnums.WeatherKind.WeatherKind_Humidity,		self._humidityPercent	) / 10000, false )
	end

	-- temp working --------
	local groundWaterRate = housing_getInstallationMenuHarvestWaterRate(ownerHouseHoldNo)
	local farmWaterRate = housing_getGrowingRateValue(ownerHouseHoldNo, CppEnums.HarvestGrowRateKind.HarvestGrowRateKind_Water ) / 10000
	local totalWaterRate = math.max(math.min(groundWaterRate + farmWaterRate, 100), 0)
	self:setProgressBarOnly("progress2_UndergroundWater1", totalWaterRate )
	self:setProgressBarOnly("progress2_UndergroundWater2", groundWaterRate )
	self:setProgressBarOnly("progress2_Compost", housing_getGrowingRateValue(ownerHouseHoldNo, CppEnums.HarvestGrowRateKind.HarvestGrowRateKind_Nutrient ) / 10000 )
	local plusValue = cultivationWeatherSSW:getRateByWeather( CppEnums.WeatherKind.WeatherKind_Water, totalWaterRate ) / 10000
	if ( 0 ~= plusValue ) then
		plusValue = - plusValue
	end
	self._ui.staticText_UndergroundWater_Value:SetText( string.format( "%.2f%%", plusValue ) )

	------------------------

	self:setSliderHighlight( "static_TemperatureBG",	"static_TemperatureHighlight",	cultivationWeatherSSW:getTopValue( CppEnums.WeatherKind.WeatherKind_Temperature ) )
	self:setSliderHighlight( "static_HumidityBG",		"static_HumidityHighlight",		cultivationWeatherSSW:getBottomValue( CppEnums.WeatherKind.WeatherKind_Humidity ) )

	self:updateIcon( "static_FarmIcon_Scarecrow",	"static_FarmIcon_Scarecrow_Eff",	housing_hasInstallationByType(ownerHouseHoldNo, CppEnums.InstallationType.eType_Scarecrow)	)
	self:updateIcon( "static_FarmIcon_Waterway",	"static_FarmIcon_Waterway_Eff",		housing_hasInstallationByType(ownerHouseHoldNo, CppEnums.InstallationType.eType_Waterway)	)
	
	if ( nil ~= progressingInfo ) then
		self:setProgressBar( "progress_Growing",	"staticText_Growing_Value",		math.floor( progressingInfo:getCurrentProgress( serverUtc64Time ) / 10000 ) )
		self:setProgressBar( "progress_Helth",		"staticText_Helth_Value",		100 - (progressingInfo:getDecreaseYieldsRate()  / 10000) )
		self:setProgressBar( "progress_NeedWater",	"staticText_NeedWater_Value",	100 - (progressingInfo:getNeedWater() / 10000) )
	
		self:updateIcon( "static_CropsIcon_Pruning",		"static_CropsIcon_Pruning_Eff",			progressingInfo:getNeedLop() )
		self:updateIcon( "static_CropsIcon_InsectDamege",	"static_CropsIcon_InsectDamege_Eff",	progressingInfo:getNeedPestControl() )
	else
		self:setProgressBar( "progress_Growing",	"staticText_Growing_Value",		0 )
		self:setProgressBar( "progress_Helth",		"staticText_Helth_Value",		100 )
		self:setProgressBar( "progress_NeedWater",	"staticText_NeedWater_Value",	100 )
	
		self:updateIcon( "static_CropsIcon_Pruning",		"static_CropsIcon_Pruning_Eff",			false )
		self:updateIcon( "static_CropsIcon_InsectDamege",	"static_CropsIcon_InsectDamege_Eff",	false )
	end
end

function farmInfo:SetPosition()
	local scrSizeX		= getScreenSizeX()
	local scrSizeY		= getScreenSizeY()
	local panelSizeX 	= Panel_Housing_FarmInfo_New:GetSizeX()
	local panelSizeY 	= Panel_Housing_FarmInfo_New:GetSizeY()

	Panel_Housing_FarmInfo_New:SetPosX( (scrSizeX / 2) + (panelSizeX / 2) )
	Panel_Housing_FarmInfo_New:SetPosY( (scrSizeY / 4) - (panelSizeY / 4) )
end


function PAHousing_FarmInfo_Open()
	--하우스에서 땅바닥에 꼽을때 보여줌
	farmInfo._currentActorKeyRaw = toClient_GetHousingSelectInstallationActorKey()
	farmInfo._isShowOnlyGround = true
	farmInfo:SetPosition()
	UI.Set_ProcessorInputMode( IM.eProcessorInputMode_UiMode )
	farmInfo:update(true)
end

function PAHousing_FarmInfo_UpdateCursor()
	local self = farmInfo
	local tempPercent		= self._ui.slider_Temperature	:GetControlPos()
	local humidityPercent	= self._ui.slider_Humidity		:GetControlPos()
	if ( self._tempPercent == tempPercent ) and ( self._humidityPercent == humidityPercent ) then
		return
	end

	self._tempPercent = tempPercent * 100
	self._humidityPercent = humidityPercent * 100
	farmInfo:update(false)
end
function PAHousing_FarmInfo_NowState()
	farmInfo:update(true)
end
function PAHousing_FarmInfo_Close()
	Panel_Housing_FarmInfo_New:SetShow( false, false )
	if not housing_isBuildMode() and not housing_isInstallMode() then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
	end
	
	farmInfo._currentActorKeyRaw = nil
	farmInfo._isShowOnlyGround = false
end

function PAHousingFarmInfo_UpdatePerFrame()
	if ( false == Panel_Housing_FarmInfo_New:IsShow() ) then
		return
	end
	PAHousing_FarmInfo_UpdateCursor()
end

function FromClient_InterActionHarvestInformation( actorKeyRaw )
	farmInfo:SetPosition()

	farmInfo._currentActorKeyRaw = actorKeyRaw
	farmInfo._isShowOnlyGround = false
	UI.Set_ProcessorInputMode( IM.eProcessorInputMode_UiMode )
	
	-- 가축정보인지 작물정보인지 체크해 텍스처 및 텍스트를 바꿔준다.
	local installationActorProxyWrapper = getInstallationActor( farmInfo._currentActorKeyRaw )
	local installationType = installationActorProxyWrapper:getStaticStatusWrapper():getObjectStaticStatus():getInstallationType()
	if (CppEnums.InstallationType.eType_LivestockHarvest == installationType) then
		FarmInfo_Change_Texture( true )
		farmInfo._isChange = true
	else
		FarmInfo_Change_Texture( false )
		farmInfo._isChange = false
	end
	
	farmInfo:update(true)
end

function FarmInfo_Change_Texture( isChange )
	local self = farmInfo._ui
	self.staticText_CropsIcon_PruningDesc		:SetTextMode(UI_TM.eTextMode_LimitText)
	self.staticText_CropsIcon_InsectDamegeDesc	:SetTextMode(UI_TM.eTextMode_LimitText)

	if (isChange) then
		self.staticText_Compost		:SetShow( false )
		self.static_CompostBG		:SetShow( false )
		self.progress2_Compost		:SetShow( false )
		self.staticText_CropsTitle					:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_FARMINFO_DOMESTICANIMAL_TITLE") ) -- "- 가축 정보" )
		self.staticText_CropsIcon_PruningDesc		:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_FARMINFO_NEEDFEEDING") ) -- "먹이관리가\n필요합니다." )
		self.staticText_CropsIcon_InsectDamegeDesc	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_FARMINFO_NEEDKILLBUG") ) -- "기생충 박멸이\n필요합니다." )
		farmInfo._uiIconUV.static_CropsIcon_Pruning			= { [true] = { x0 = 193,	x1 = 235,	y0 = 97,	y1 = 139	},	[false] = { x0 = 193,	x1 = 235,	y0 = 5,		y1 = 47		},	}
		farmInfo._uiIconUV.static_CropsIcon_InsectDamege	= { [true] = { x0 = 240,	x1 = 282,	y0 = 97,	y1 = 139	},	[false] = { x0 = 240,	x1 = 282,	y0 = 5,		y1 = 47		},	}
	else
		self.staticText_Compost		:SetShow( true )
		self.static_CompostBG		:SetShow( true )
		self.progress2_Compost		:SetShow( true )
		self.staticText_CropsTitle					:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_HOUSEING_FARMINFO_NEW_SCROPTITLE") )
		self.staticText_CropsIcon_PruningDesc		:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_HOUSEING_FARMINFO_NEW_PRUNINGDESC") )
		self.staticText_CropsIcon_InsectDamegeDesc	:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_HOUSEING_FARMINFO_NEW_INSECTDAMEGEDESC") )
		farmInfo._uiIconUV.static_CropsIcon_Pruning			= { [true] = { x0 = 12,		x1 = 54,	y0 = 76,	y1 = 118	},	[false] = { x0 = 12,	x1 = 54,	y0 = 123,	y1 = 165	},	}
		farmInfo._uiIconUV.static_CropsIcon_InsectDamege	= { [true] = { x0 = 59,		x1 = 101,	y0 = 76,	y1 = 118	},	[false] = { x0 = 59,	x1 = 101,	y0 = 123,	y1 = 165	},	}
	end
end

function farmInfo_SimpleToolTips( isShow, farmInfoType )
	local name, desc, uiControl = nil, nil, nil
	local self = farmInfo._ui

	if (farmInfo._isChange) then
		if farmInfoType == 0 then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_TEMPERATURE_TITLE") -- "온도"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_TEMPERATURE_DESC")
			uiControl = self.staticText_Temperature_Title
		elseif farmInfoType == 1 then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_HUMIDITY_TITLE") -- "습도"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_HUMIDITY_DESC")
			uiControl = self.staticText_Humidity_Title
		elseif farmInfoType == 2 then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_UNDERGROUNDWATER_TITLE") -- "지하수"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_UNDERGROUNDWATER_DESC")
			uiControl = self.staticText_UndergroundWater
		elseif farmInfoType == 3 then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_COMPOST_TITLE") -- "비료"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_COMPOST_DESC")
			uiControl = self.staticText_Compost
		elseif farmInfoType == 4 then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_GROWING_TITLE") -- "성장"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_GROWING_DESC_2") -- "가축의 현재 성장 정도를 나타냅니다. 가축의 성장률이 120%를 넘으면 수확량이 줄어듭니다."
			uiControl = self.staticText_Growing
		elseif farmInfoType == 5 then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_HEALTH_TITLE") -- "건강"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_HEALTH_DESC_2") -- "새서리를 당할 때마다 여물이 줄어들어 가축의 성장 속도가 느려집니다."
			uiControl = self.staticText_Helth
		elseif farmInfoType == 6 then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_NEEDWATER_TITLE") -- "수분"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_NEEDWATER_DESC_2") -- "수분량이 0이 되면 가축이 물을 먹지 못해 수확량이 줄어듭니다. 텃밭에 물을 뿌려 지하수량을 보정할 수 있으며, 지하수량이 높으면 수분량이 회복됩니다."
			uiControl = self.staticText_NeedWater
		end
	else
		if farmInfoType == 0 then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_TEMPERATURE_TITLE") -- "온도"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_TEMPERATURE_DESC")
			uiControl = self.staticText_Temperature_Title
		elseif farmInfoType == 1 then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_HUMIDITY_TITLE") -- "습도"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_HUMIDITY_DESC")
			uiControl = self.staticText_Humidity_Title
		elseif farmInfoType == 2 then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_UNDERGROUNDWATER_TITLE") -- "지하수"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_UNDERGROUNDWATER_DESC")
			uiControl = self.staticText_UndergroundWater
		elseif farmInfoType == 3 then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_COMPOST_TITLE") -- "비료"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_COMPOST_DESC")
			uiControl = self.staticText_Compost
		elseif farmInfoType == 4 then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_GROWING_TITLE") -- "성장"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_GROWING_DESC")
			uiControl = self.staticText_Growing
		elseif farmInfoType == 5 then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_HEALTH_TITLE") -- "건강"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_HEALTH_DESC")
			uiControl = self.staticText_Helth
		elseif farmInfoType == 6 then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_NEEDWATER_TITLE") -- "수분"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_FARMINFO_NEEDWATER_DESC")
			uiControl = self.staticText_NeedWater
		end
	end

	if isShow == true then
		registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end
end

farmInfo:init();

registerEvent("FromClient_InterActionHarvestInformation",	"FromClient_InterActionHarvestInformation")