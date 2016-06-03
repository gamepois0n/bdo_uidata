local UI_color			= Defines.Color
local UI_TM 			= CppEnums.TextMode


Panel_LordMenu:SetShow( false )

Panel_LordMenu:RegisterShowEventFunc( true, 'Panel_LordMenu_ShowAni()' )
Panel_LordMenu:RegisterShowEventFunc( false, 'Panel_LordMenu_HideAni()' )

function Panel_LordMenu_ShowAni()
	Panel_LordMenu:SetAlpha(0)
	UIAni.fadeInSCR_Down( Panel_LordMenu )
	Panel_LordMenu:SetShow(true)
end

function Panel_LordMenu_HideAni()
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_LordMenu, 0.0, 0.2 )
	aniInfo:SetHideAtEnd(true)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local moveChildElements = function ( destControl, srcControl, uiList )
	for _, value in pairs( uiList ) do
		destControl:AddChild( value )
		srcControl:RemoveControl( value )
	end
end

local showToggleElements = function ( isShow, uiList )
	for _, value in pairs( uiList ) do
		value:SetShow(isShow)
	end
end



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local ui_Main = 
{
	_btn_WinClose 		= UI.getChildControl ( Panel_LordMenu, "Button_Close" ),
	_buttonQuestion 	= UI.getChildControl ( Panel_LordMenu, "Button_Question" ),		--물음표 버튼
	_btn_TerInfo		= UI.getChildControl ( Panel_LordMenu, "RadioButton_TerInfo" ),
	_btn_PayInfo 		= UI.getChildControl ( Panel_LordMenu, "RadioButton_PayInfo" ),
	_btn_TaxInfo 		= UI.getChildControl ( Panel_LordMenu, "RadioButton_TaxInfo" ),
	_FrameBG 			= UI.getChildControl ( Panel_LordMenu, "Static_Background" ),
}


------------------------------------------------------------------------------------------------------------
--												영지 정보
local ui_Ter = 
{
	_title_0 		= UI.getChildControl ( Panel_LordMenu_Territory, "StaticText_Terr_Title_0" ),
	
	_M_GuildName 	= UI.getChildControl ( Panel_LordMenu_Territory, "StaticText_M_GuildName" ),
	_M_LordName 	= UI.getChildControl ( Panel_LordMenu_Territory, "StaticText_M_LordName" ),
	_M_Occupation 	= UI.getChildControl ( Panel_LordMenu_Territory, "StaticText_M_Occupation" ),
	_M_Residence 	= UI.getChildControl ( Panel_LordMenu_Territory, "StaticText_M_Residence" ),
	
	_R_GuildName	= UI.getChildControl ( Panel_LordMenu_Territory, "StaticText_R_GuildName" ),
	_R_LordName 	= UI.getChildControl ( Panel_LordMenu_Territory, "StaticText_R_LordName" ),
	_R_Occupation	= UI.getChildControl ( Panel_LordMenu_Territory, "StaticText_R_Occupation" ),
	_R_Residence 	= UI.getChildControl ( Panel_LordMenu_Territory, "StaticText_R_Residence" ),
	
	_guildIconBG	= UI.getChildControl ( Panel_LordMenu_Territory, "Static_GuildIcon_BG" ),
	_guildIcon 		= UI.getChildControl ( Panel_LordMenu_Territory, "Static_GuildIcon" ),
	
	_txt_TerrHelp	= UI.getChildControl ( Panel_LordMenu_Territory, "StaticText_TerrInfo_Help" ),
	
	_title_1 		= UI.getChildControl ( Panel_LordMenu_Territory, "StaticText_Terr_Title_1" ),
	
	_happyBG 		= UI.getChildControl ( Panel_LordMenu_Territory, "Static_HappyGaugeBG" ),
	_happyGauge		= UI.getChildControl ( Panel_LordMenu_Territory, "Progress2_HappyGauge" ),
	
	_happyComment 	= UI.getChildControl ( Panel_LordMenu_Territory, "StaticText_HappyComment" ),
	_happy_Help 	= UI.getChildControl ( Panel_LordMenu_Territory, "StaticText_HappyRate_Help" ),
}


------------------------------------------------------------------------------------------------------------
--												징수 현황
local ui_Pay = 
{
	_title_0 				= UI.getChildControl ( Panel_LordMenu_PayInfo, "StaticText_Pay_Title_0" ),
	
	-- _consTax_Now_BG 		= UI.getChildControl ( Panel_LordMenu_PayInfo, "Static_ConsTax_Now_BG" ),
	-- _consTax_Bef_BG 		= UI.getChildControl ( Panel_LordMenu_PayInfo, "Static_ConsTax_Bef_BG" ),
	-- _incomeTax_Now_BG 		= UI.getChildControl ( Panel_LordMenu_PayInfo, "Static_IncomeTax_Now_BG" ),
	-- _incomeTax_Bef_BG 		= UI.getChildControl ( Panel_LordMenu_PayInfo, "Static_IncomeTax_Bef_BG" ),
	-- _duty_Now_BG 			= UI.getChildControl ( Panel_LordMenu_PayInfo, "Static_Duty_Now_BG" ),
	-- _duty_Bef_BG 			= UI.getChildControl ( Panel_LordMenu_PayInfo, "Static_Duty_Bef_BG" ),
	_transferTax_Now_BG 	= UI.getChildControl ( Panel_LordMenu_PayInfo, "Static_TransferTax_Now_BG" ),
	_transferTax_Bef_BG 	= UI.getChildControl ( Panel_LordMenu_PayInfo, "Static_TransferTax_Bef_BG" ),
	
	-- _consTax_Now_Gauge 		= UI.getChildControl ( Panel_LordMenu_PayInfo, "Progress2_ConsTax_Now" ),
	-- _consTax_Bef_Gauge 		= UI.getChildControl ( Panel_LordMenu_PayInfo, "Progress2_ConsTax_Bef" ),
	-- _incomeTax_Now_Gauge 	= UI.getChildControl ( Panel_LordMenu_PayInfo, "Progress2_IncomeTax_Now" ),
	-- _incomeTax_Bef_Gauge 	= UI.getChildControl ( Panel_LordMenu_PayInfo, "Progress2_IncomeTax_Bef" ),
	-- _duty_Now_Gauge 		= UI.getChildControl ( Panel_LordMenu_PayInfo, "Progress2_Duty_Now" ),
	-- _duty_Bef_Gauge 		= UI.getChildControl ( Panel_LordMenu_PayInfo, "Progress2_DutyTax_Bef" ),
	_transferTax_Now_Gauge 	= UI.getChildControl ( Panel_LordMenu_PayInfo, "Progress2_TransferTax_Now" ),
	_transferTax_Bef_Gauge 	= UI.getChildControl ( Panel_LordMenu_PayInfo, "Progress2_TransferTax_Bef" ),
	
	-- _txt_ConsTax 			= UI.getChildControl ( Panel_LordMenu_PayInfo, "StaticText_ConsTax" ),
	-- _txt_IncomeTax 			= UI.getChildControl ( Panel_LordMenu_PayInfo, "StaticText_IncomeTax" ),
	-- _txt_Duty 				= UI.getChildControl ( Panel_LordMenu_PayInfo, "StaticText_Duty" ),
	_txt_TransferTax 		= UI.getChildControl ( Panel_LordMenu_PayInfo, "StaticText_TransferTax" ),
	
	-- _txt_ConsTax_Gold 		= UI.getChildControl ( Panel_LordMenu_PayInfo, "StaticText_ConsTax_Gold" ),
	-- _txt_IncomeTax_Gold 	= UI.getChildControl ( Panel_LordMenu_PayInfo, "StaticText_IncomeTax_Gold" ),
	-- _txt_Duty_Gold 			= UI.getChildControl ( Panel_LordMenu_PayInfo, "StaticText_Duty_Gold" ),
	_txt_TransferTax_Gold 	= UI.getChildControl ( Panel_LordMenu_PayInfo, "StaticText_TransferTax_Gold" ),
	
	_txt_TaxNow_Help 		= UI.getChildControl ( Panel_LordMenu_PayInfo, "StaticText_TaxNow_Help" ),
	_txt_TaxBef_Help 		= UI.getChildControl ( Panel_LordMenu_PayInfo, "StaticText_TaxBef_Help" ),
	
	_tax_Help 				= UI.getChildControl ( Panel_LordMenu_PayInfo, "StaticText_Tax_Help" ),
	
	_title_1 				= UI.getChildControl ( Panel_LordMenu_PayInfo, "StaticText_Pay_Title_1" ),
	
	_txt_Balance 			= UI.getChildControl ( Panel_LordMenu_PayInfo, "StaticText_Balance" ),
	_txt_LocalTax 			= UI.getChildControl ( Panel_LordMenu_PayInfo, "StaticText_LocalTax" ),
	_txt_Balance_Gold 		= UI.getChildControl ( Panel_LordMenu_PayInfo, "StaticText_Balance_Gold" ),
	_txt_LocalTax_Gold 		= UI.getChildControl ( Panel_LordMenu_PayInfo, "StaticText_LocalTax_Gold" ),
	
	_btn_GetMoney 			= UI.getChildControl ( Panel_LordMenu_PayInfo, "Button_GetMoney" ),
	
	_txt_Balance_Help		= UI.getChildControl ( Panel_LordMenu_PayInfo, "StaticText_Balance_Help" ),
}


------------------------------------------------------------------------------------------------------------
--												세율 조정
local ui_Tax =
{
	_title_0						= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_Tax_Title_0" ),
			
	-- _txt_Consum						= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_Tax_Consum" ),
	-- _slide_Consum					= UI.getChildControl ( Panel_LordMenu_TaxControl, "Slider_Consum" ),
	-- _slideBtn_Consum				= nil,	
	-- _txt_Consum_Help				= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_Consum_Help" ),
	-- _txt_Cons_Ref_Min				= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_Cons_Ref_Min" ),
	-- _txt_Cons_Ref_Max				= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_Cons_Ref_Max" ),
			
	-- _txt_IncomeTax					= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_Tax_IncomeTax" ),
	-- _slide_IncomeTax				= UI.getChildControl ( Panel_LordMenu_TaxControl, "Slider_IncomeTax" ),
	-- _slideBtn_IncomeTax				= nil,	
	-- _txt_IncomeTax_Help				= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_IncomeTax_Help" ),
	-- _txt_Tax_Ref_Min				= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_Tax_Ref_Min" ),
	-- _txt_Tax_Ref_Max				= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_Tax_Ref_Max" ),
			
	-- _txt_Duty						= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_Tax_Duty" ),
	-- _slide_Duty						= UI.getChildControl ( Panel_LordMenu_TaxControl, "Slider_Duty" ),
	-- _slideBtn_Duty					= nil,
	-- _txt_Duty_Help					= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_Duty_Help" ),
	-- _txt_Duty_Ref_Min				= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_Duty_Ref_Min" ),
	-- _txt_Duty_Ref_Max				= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_Duty_Ref_Max" ),
	
	_txt_TransferTax				= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_Tax_TransferTax" ),
	_slide_TransferTax				= UI.getChildControl ( Panel_LordMenu_TaxControl, "Slider_TransferTax" ),
	_slideBtn_TransferTax			= nil,
	_txt_TransferTax_Help			= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_TransferTax_Help" ),
	_txt_TransferTax_Ref_Min		= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_TransferTax_Ref_Min" ),
	_txt_TransferTax_Ref_Max		= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_TransferTax_Ref_Max" ),
	
	_title_1				= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_Tax_Title_1" ),
	
	_txt_Territory_1		= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_Territory_1" ),
	_txt_Territory_2		= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_Territory_2" ),
	_txt_Territory_3		= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_Territory_3" ),
	_txt_Territory_4		= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_Territory_4" ),
	_txt_Territory_5		= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_Territory_5" ),
	_txt_Territory_6		= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_Territory_6" ),
	
	_slide_Territory_1		= UI.getChildControl ( Panel_LordMenu_TaxControl, "Slider_Territory_1" ),
	_slideBtn_Territory_1	= nil,
	_slide_Territory_2		= UI.getChildControl ( Panel_LordMenu_TaxControl, "Slider_Territory_2" ),
	_slideBtn_Territory_2	= nil,
	_slide_Territory_3		= UI.getChildControl ( Panel_LordMenu_TaxControl, "Slider_Territory_3" ),
	_slideBtn_Territory_3	= nil,
	_slide_Territory_4		= UI.getChildControl ( Panel_LordMenu_TaxControl, "Slider_Territory_4" ),
	_slideBtn_Territory_4	= nil,
	_slide_Territory_5		= UI.getChildControl ( Panel_LordMenu_TaxControl, "Slider_Territory_5" ),
	_slideBtn_Territory_5	= nil,
	_slide_Territory_6		= UI.getChildControl ( Panel_LordMenu_TaxControl, "Slider_Territory_6" ),
	_slideBtn_Territory_6	= nil,

	_txt_min_1				= UI.getChildControl( Panel_LordMenu_TaxControl, "StaticText_Min_1"),
	_txt_min_2				= UI.getChildControl( Panel_LordMenu_TaxControl, "StaticText_Min_2"),
	_txt_min_3				= UI.getChildControl( Panel_LordMenu_TaxControl, "StaticText_Min_3"),
	_txt_min_4				= UI.getChildControl( Panel_LordMenu_TaxControl, "StaticText_Min_4"),
	_txt_min_5				= UI.getChildControl( Panel_LordMenu_TaxControl, "StaticText_Min_5"),
	_txt_min_6				= UI.getChildControl( Panel_LordMenu_TaxControl, "StaticText_Min_6"),

	_txt_max_1				= UI.getChildControl( Panel_LordMenu_TaxControl, "StaticText_Max_1"),
	_txt_max_2				= UI.getChildControl( Panel_LordMenu_TaxControl, "StaticText_Max_2"),
	_txt_max_3				= UI.getChildControl( Panel_LordMenu_TaxControl, "StaticText_Max_3"),
	_txt_max_4				= UI.getChildControl( Panel_LordMenu_TaxControl, "StaticText_Max_4"),
	_txt_max_5				= UI.getChildControl( Panel_LordMenu_TaxControl, "StaticText_Max_5"),
	_txt_max_6				= UI.getChildControl( Panel_LordMenu_TaxControl, "StaticText_Max_6"),

	_txt_DutyTax_Help		= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_DutyTax_Help" ),

	_btn_Tax_Reset			= UI.getChildControl ( Panel_LordMenu_TaxControl, "Button_Title_0_Reset" ),
	_btn_Tax_Accpet			= UI.getChildControl ( Panel_LordMenu_TaxControl, "Button_Title_0_Accept" ),	
	_btn_Duty_Reset			= UI.getChildControl ( Panel_LordMenu_TaxControl, "Button_Title_1_Reset" ),
	_btn_Duty_Accpet		= UI.getChildControl ( Panel_LordMenu_TaxControl, "Button_Title_1_Accept" ),

	_noTax					= UI.getChildControl ( Panel_LordMenu_TaxControl, "StaticText_NoTax" ),
}

local tapIndex = 0
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------
--						초기화 함수
----------------------------------------------------------------
local Panel_LordMenu_Initialize = function()
	moveChildElements( ui_Main._FrameBG, Panel_LordMenu_Territory, 		ui_Ter )
	moveChildElements( ui_Main._FrameBG, Panel_LordMenu_PayInfo, 		ui_Pay )
	moveChildElements( ui_Main._FrameBG, Panel_LordMenu_TaxControl, 	ui_Tax )
	
	ui_Pay._btn_GetMoney:addInputEvent( "Mouse_LDown", "LordMenu_Withdraw_Money()" )
	
	-- ui_Tax._slideBtn_Consum			= UI.getChildControl ( ui_Tax._slide_Consum, 			"Slider_ConsumButton" )
	-- ui_Tax._slideBtn_Consum:addInputEvent( "Mouse_LPress", "LordMenu_SlideControl_Consum()" )
	-- ui_Tax._slideBtn_IncomeTax		= UI.getChildControl ( ui_Tax._slide_IncomeTax, 		"Slider_IncomeTaxButton" )
	-- ui_Tax._slideBtn_IncomeTax:addInputEvent( "Mouse_LPress", "LordMenu_SlideControl_Income()" )
	-- ui_Tax._slideBtn_Duty			= UI.getChildControl ( ui_Tax._slide_Duty, 				"Slider_Duty_Button" )
	-- ui_Tax._slideBtn_Duty:addInputEvent( "Mouse_LPress", "LordMenu_SlideControl_Duty()" )
	ui_Tax._slideBtn_TransferTax	= UI.getChildControl ( ui_Tax._slide_TransferTax, 		"Slider_TransferTax_Button" )
	ui_Tax._slideBtn_TransferTax:addInputEvent( "Mouse_LPress", "LordMenu_SlideControl_TransferTax()" )
	
	
	
	ui_Tax._slideBtn_Territory_1= UI.getChildControl ( ui_Tax._slide_Territory_1, 		"Slider_TerritoryButton_1" )
	ui_Tax._slideBtn_Territory_1:addInputEvent( "Mouse_LPress", "LordMenu_SlideControl_TaxForSiegeTerritory_1()" )
	ui_Tax._slideBtn_Territory_2= UI.getChildControl ( ui_Tax._slide_Territory_2, 		"Slider_TerritoryButton_2" )
	ui_Tax._slideBtn_Territory_2:addInputEvent( "Mouse_LPress", "LordMenu_SlideControl_TaxForSiegeTerritory_2()" )
	ui_Tax._slideBtn_Territory_3= UI.getChildControl ( ui_Tax._slide_Territory_3, 		"Slider_TerritoryButton_3" )
	ui_Tax._slideBtn_Territory_3:addInputEvent( "Mouse_LPress", "LordMenu_SlideControl_TaxForSiegeTerritory_3()" )
	ui_Tax._slideBtn_Territory_4= UI.getChildControl ( ui_Tax._slide_Territory_4, 		"Slider_TerritoryButton_4" )
	ui_Tax._slideBtn_Territory_4:addInputEvent( "Mouse_LPress", "LordMenu_SlideControl_TaxForSiegeTerritory_4()" )
	ui_Tax._slideBtn_Territory_5= UI.getChildControl ( ui_Tax._slide_Territory_5, 		"Slider_TerritoryButton_5" )
	ui_Tax._slideBtn_Territory_5:addInputEvent( "Mouse_LPress", "LordMenu_SlideControl_TaxForSiegeTerritory_5()" )
	ui_Tax._slideBtn_Territory_6= UI.getChildControl ( ui_Tax._slide_Territory_6, 		"Slider_TerritoryButton_6" )
	ui_Tax._slideBtn_Territory_6:addInputEvent( "Mouse_LPress", "LordMenu_SlideControl_TaxForSiegeTerritory_6()" )
	
	----------------------------------------
	--		영지 정보 버튼을 우선 체크
	ui_Main._btn_TerInfo:SetCheck( true )

	----------------------------------------
	--		각자 라디오 버튼에 이벤트
	ui_Main._btn_TerInfo:addInputEvent( "Mouse_LUp", "LordMenu_MouseEvent_TerInfoShow()")
	ui_Main._btn_PayInfo:addInputEvent( "Mouse_LUp", "LordMenu_MouseEvent_PayInfoShow()")
	ui_Main._btn_TaxInfo:addInputEvent( "Mouse_LUp", "LordMenu_MouseEvent_TaxInfoShow()")

	----------------------------------------
	--	영지 정보를 우선 업데이트 한다
	showToggleElements(true, ui_Ter)
	showToggleElements(false, ui_Pay)
	showToggleElements(false, ui_Tax)

	------------------------------------------------------------
	--	!! 문제가 있어 게이지의 Index를 강제로 설정해줘야한다
	-- ui_Main._FrameBG:SetChildIndex( ui_Pay._consTax_Now_Gauge:GetKey(), 9999 )
	-- ui_Main._FrameBG:SetChildIndex( ui_Pay._consTax_Bef_Gauge:GetKey(), 9999 )
	-- ui_Main._FrameBG:SetChildIndex( ui_Pay._incomeTax_Now_Gauge:GetKey(), 9999 )
	-- ui_Main._FrameBG:SetChildIndex( ui_Pay._incomeTax_Bef_Gauge:GetKey(), 9999 )
	-- ui_Main._FrameBG:SetChildIndex( ui_Pay._duty_Now_Gauge:GetKey(), 9999 )
	-- ui_Main._FrameBG:SetChildIndex( ui_Pay._duty_Bef_Gauge:GetKey(), 9999 )
	ui_Main._FrameBG:SetChildIndex( ui_Pay._transferTax_Now_Gauge, 9999 )
	ui_Main._FrameBG:SetChildIndex( ui_Pay._transferTax_Bef_Gauge, 9999 )
	
	-------------------------------------------------------------
	-- 세율을 적용한다.
	ui_Tax._btn_Tax_Reset:addInputEvent( "Mouse_LUp", "LordMenu_MouseEvent_ResetTaxForFortress()")
	ui_Tax._btn_Tax_Accpet:addInputEvent( "Mouse_LUp", "LordMenu_MouseEvent_ChangeTaxForFortress()")
	ui_Tax._btn_Duty_Reset:addInputEvent( "Mouse_LUp", "LordMenu_MouseEvent_ResetTaxForSiege()")
	ui_Tax._btn_Duty_Accpet:addInputEvent( "Mouse_LUp", "LordMenu_MouseEvent_ChangeTaxForSiege()")
	
	-------------------------------------------------------------
	-- 창을 닫는다.
	ui_Main._btn_WinClose:addInputEvent( "Mouse_LUp", "LordMenu_Hide()")
	
	ui_Main._buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelLordMenu\" )")		--물음표 좌클릭
	ui_Main._buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"PanelLordMenu\", \"true\")")		--물음표 마우스오버
	ui_Main._buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"PanelLordMenu\", \"false\")")		--물음표 마우스오버
	
	
end

----------------------------------------------------------------
--					영지 정보 업데이트 함수
----------------------------------------------------------------
function Panel_LordMenu_TerInfoUpdate()
	local selfPlayer = getSelfPlayer();
	local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
	if (nil == regionInfoWrapper) then
		Panel_LordMenu:SetShow( false )
		return
	end	
	local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(getSelfPlayer():getRegionKeyRaw())
	if (nil == siegeWrapper) then
		Panel_LordMenu:SetShow( false )
		return
	end	
	
	local doOccupantExist = siegeWrapper:doOccupantExist()

	local guildName 				= ""
	local lordName 					= ""
	
	if (doOccupantExist) then
		guildName 					= siegeWrapper:getGuildName()
		lordName 					= siegeWrapper:getGuildMasterName()
	end	
	local occupyingDate 			= siegeWrapper:getOccupyingDate()
	local year 						= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_YEAR", "year", tostring(occupyingDate:GetYear()) )
	local month 					= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_MONTH", "month", tostring(occupyingDate:GetMonth()) )
	local day 						= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_DAY", "day", tostring(occupyingDate:GetDay()) )
	local hour 						= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_HOUR", "hour", tostring(occupyingDate:GetHour()) )
	occupyingDate 					= year .. " " .. month .. " " .. day .. " " .. hour
	local affiliatedUserRate 		= siegeWrapper:getAffiliatedUserRate() 
	local affiliatedUserRateStr 	= "" 
	local affiliatedUserRateColor 	= "" 
	local loyalty 					= siegeWrapper:getLoyalty()
	local loyaltyStr				= ""	
	local loyaltyColor 				= "" 
	
	ui_Ter._R_GuildName:SetText(guildName)
	ui_Ter._R_LordName:SetText(lordName)
	ui_Ter._R_Occupation:SetText(occupyingDate)
	
	if (0 <= affiliatedUserRate and affiliatedUserRate <= 20) then
		affiliatedUserRateStr 	= PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_POPULATIONDENSITY_LACK").."("..string.format( "%d", affiliatedUserRate).."%)"
		affiliatedUserRateColor = UI_color.C_FFFF4C4C
	elseif (20 < affiliatedUserRate and affiliatedUserRate <= 40) then
		affiliatedUserRateStr 	= PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_POPULATIONDENSITY_LOW").."("..string.format( "%d", affiliatedUserRate).."%)"
		affiliatedUserRateColor = UI_color.C_FFFF874C
	elseif (40 < affiliatedUserRate and affiliatedUserRate <= 60) then
		affiliatedUserRateStr 	= PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_POPULATIONDENSITY_NORMAL").."("..string.format( "%d", affiliatedUserRate).."%)"
		affiliatedUserRateColor = UI_color.C_FFAEFF9B
	elseif (60 < affiliatedUserRate and affiliatedUserRate <= 80) then
		affiliatedUserRateStr 	= PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_POPULATIONDENSITY_HIGH").."("..string.format( "%d", affiliatedUserRate).."%)"
		affiliatedUserRateColor = UI_color.C_FF9B9BFF
	elseif (80 < affiliatedUserRate ) then
		affiliatedUserRateStr 	= PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_POPULATIONDENSITY_EXPLOSION").."("..string.format( "%d", affiliatedUserRate).."%)"
		affiliatedUserRateColor = UI_color.C_FF8737FF
	end
	
	ui_Ter._R_Residence:SetText(affiliatedUserRateStr)
	ui_Ter._R_Residence:SetFontColor(affiliatedUserRateColor)
	
	local selfActorKeyRaw = selfPlayer:getActorKey()
	local isSet = setGuildTextureByGuildNo( siegeWrapper:getGuildNo(), ui_Ter._guildIcon )
	if (not isSet) then
		ui_Ter._guildIcon:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( ui_Ter._guildIcon, 183, 1, 188, 6 )
		ui_Ter._guildIcon:getBaseTexture():setUV(  x1, y1, x2, y2  )
		ui_Ter._guildIcon:setRenderTexture(ui_Ter._guildIcon:getBaseTexture())
	end
	
	
	if (0 <= loyalty and loyalty <= 15) then
		loyaltyStr		= PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_LOYALTY_UPRISING")
		loyaltyColor 	= UI_color.C_FFFF4C4C
	elseif (15 < loyalty and loyalty <= 50) then
		loyaltyStr		= PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_LOYALTY_COMPLAINT")
		loyaltyColor 	= UI_color.C_FFFF874C
	elseif (50 < loyalty and loyalty <= 70) then
		loyaltyStr		= PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_LOYALTY_NORMAL")
		loyaltyColor 	= UI_color.C_FFAEFF9B
	elseif (70 < loyalty and loyalty <= 94) then
		loyaltyStr		= PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_LOYALTY_SATISFACTION")
		loyaltyColor 	= UI_color.C_FF9B9BFF
	elseif (94 < loyalty and loyalty <= 100) then
		loyaltyStr		= PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_LOYALTY_GREATSATISFACTION")
		loyaltyColor 	= UI_color.C_FF8737FF
	end
	
	ui_Ter._happyGauge:SetProgressRate(loyalty)
	ui_Ter._happyComment:SetText(loyaltyStr)
	ui_Ter._happyComment:SetFontColor(loyaltyColor)

	ui_Ter._txt_TerrHelp:SetTextMode( UI_TM.eTextMode_AutoWrap )
	ui_Ter._happy_Help:SetTextMode( UI_TM.eTextMode_AutoWrap )
	
	-- ui_Pay._consTax_Now_Gauge:SetProgressRate(0)
	-- ui_Pay._consTax_Bef_Gauge:SetProgressRate(0)
	-- ui_Pay._incomeTax_Now_Gauge:SetProgressRate(0)
	-- ui_Pay._incomeTax_Bef_Gauge:SetProgressRate(0)
	-- ui_Pay._duty_Now_Gauge:SetProgressRate(0)
	-- ui_Pay._duty_Bef_Gauge:SetProgressRate(0)
	ui_Pay._transferTax_Now_Gauge:SetProgressRate(0)
	ui_Pay._transferTax_Bef_Gauge:SetProgressRate(0)
	
	
	
	ui_Ter._txt_TerrHelp:SetText( PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_TXT_TERRHELP") )	-- - 모든 플레이어는 매주 전출기간에 거주지를 결정합니다.\n- 많은 주민들을 거주시키면 보다 많은 세수를 확보할 수 있습니다.
	ui_Ter._happy_Help:SetText( PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_HAPPY_HELP") )	-- - 행복 지수가 떨어질 수록 주민들이 시위를 시작하며, 행복 지수가 낮은 상태로 유지되면 징수된 세금이 조금씩 약탈 당하게되니 주의가 필요합니다.\n- 각 지역들의 상황에 맞춰 명령을 내려 행복 지수를 관리할 수 있습니다.\n- 과도한 세율 설정은 행복 지수를 떨어뜨리는 요인이 될 수 있습니다.

		
	local isLord = siegeWrapper:isLord()
	if (not isLord) then
		ui_Main._btn_PayInfo:SetShow(false) 
		ui_Main._btn_TaxInfo:SetShow(false)
	else
		ui_Main._btn_PayInfo:SetShow(true) 
		ui_Main._btn_TaxInfo:SetShow(true)
	end
	
	if Panel_Window_Exchange_Number:IsShow() then
		Panel_NumberPad_Show( false, Defines.s64_const.s64_0, 0, nil);
	end
end


----------------------------------------------------------------
--					징수 현황 업데이트 함수
----------------------------------------------------------------
function Panel_LordMenu_PayInfoUpdate()
	local selfPlayer = getSelfPlayer();
	local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
	if (nil == regionInfoWrapper) then
		return
	end	
	local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(getSelfPlayer():getRegionKeyRaw())
	if (nil == siegeWrapper) then
		return
	end	
	
	local doOccupantExist = siegeWrapper:doOccupantExist()
	if (not doOccupantExist) then
		return;
	end
	
	local isLord = siegeWrapper:isLord()
	
	if (not isLord) then
		return
	end
	
	local maxAmount = toInt64(0, 1)
	-- local consumptionTaxProducedAmount = siegeWrapper:getTaxProducedAmount(CppEnums.TaxType.eTaxType_BuyItemFromSystem)
	-- local consumptionTaxAffiliatedAmount = siegeWrapper:getTaxAffiliatedAmount(CppEnums.TaxType.eTaxType_BuyItemFromSystem)
	-- local consumptionTaxAmount = consumptionTaxProducedAmount + consumptionTaxAffiliatedAmount
	
	-- local consignmentProducedAmount = siegeWrapper:getTaxProducedAmount(CppEnums.TaxType.eTaxType_BuyItemFromConsignment)
	-- local servantMarketProducedAmount = siegeWrapper:getTaxProducedAmount(CppEnums.TaxType.eTaxType_BuyHorseFromServantMarket)
	-- local servantMatingProducedAmount = siegeWrapper:getTaxProducedAmount(CppEnums.TaxType.eTaxType_BuyHorseFromServantMating)
	-- local incomeTaxProducedAmount = consignmentProducedAmount + servantMarketProducedAmount + servantMatingProducedAmount
	-- local consignmentAffiliatedAmount = siegeWrapper:getTaxAffiliatedAmount(CppEnums.TaxType.eTaxType_BuyItemFromConsignment)
	-- local servantMarketAffiliatedAmount = siegeWrapper:getTaxAffiliatedAmount(CppEnums.TaxType.eTaxType_BuyHorseFromServantMarket)
	-- local servantMatingAffiliatedAmount = siegeWrapper:getTaxAffiliatedAmount(CppEnums.TaxType.eTaxType_BuyHorseFromServantMating)
	-- local incomeTaxAffiliatedAmount = consignmentAffiliatedAmount + servantMarketAffiliatedAmount + servantMatingAffiliatedAmount
	-- local incomeTaxAmount = incomeTaxProducedAmount + incomeTaxAffiliatedAmount
	
	-- local dutyProducedAmount = siegeWrapper:getTaxProducedAmount(CppEnums.TaxType.eTaxType_DeliverItemByPublicWagon)
	-- local dutyAffiliatedAmount = siegeWrapper:getTaxAffiliatedAmount(CppEnums.TaxType.eTaxType_DeliverItemByPublicWagon)
	-- local dutyAmount = dutyProducedAmount + dutyAffiliatedAmount
	
	local transferTaxProducedAmount = siegeWrapper:getTaxProducedAmount(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
	local transferTaxAffiliatedAmount = siegeWrapper:getTaxAffiliatedAmount(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
	local transferTaxAmount = transferTaxProducedAmount + transferTaxAffiliatedAmount
	
	
	-- if (maxAmount < consumptionTaxAmount) then
		-- maxAmount = consumptionTaxAmount
	-- end
	
	-- if (maxAmount < incomeTaxAmount) then
		-- maxAmount = incomeTaxAmount
	-- end
	
	-- if (maxAmount < dutyAmount) then
		-- maxAmount = dutyAmount
	-- end
	
	if (maxAmount < transferTaxAmount) then
		maxAmount = transferTaxAmount
	end
	
	-- ui_Pay._consTax_Now_Gauge:SetProgressRate( math.floor(Int64toInt32(consumptionTaxProducedAmount/maxAmount*toInt64(0, 100))) )
	-- ui_Pay._consTax_Bef_Gauge:SetProgressRate( math.floor(Int64toInt32(consumptionTaxAffiliatedAmount/maxAmount*toInt64(0, 100))) )
	-- ui_Pay._incomeTax_Now_Gauge:SetProgressRate( math.floor(Int64toInt32(incomeTaxProducedAmount/maxAmount*toInt64(0, 100))) )
	-- ui_Pay._incomeTax_Bef_Gauge:SetProgressRate( math.floor(Int64toInt32(incomeTaxAffiliatedAmount/maxAmount*toInt64(0, 100))) )
	-- ui_Pay._duty_Now_Gauge:SetProgressRate( math.floor(Int64toInt32(dutyProducedAmount/maxAmount*toInt64(0, 100))) )
	-- ui_Pay._duty_Bef_Gauge:SetProgressRate( math.floor(Int64toInt32(dutyAffiliatedAmount/maxAmount*toInt64(0, 100))) )
	ui_Pay._transferTax_Now_Gauge:SetProgressRate( math.floor(Int64toInt32(transferTaxProducedAmount/maxAmount*toInt64(0, 100))) )
	ui_Pay._transferTax_Bef_Gauge:SetProgressRate( math.floor(Int64toInt32(transferTaxAffiliatedAmount/maxAmount*toInt64(0, 100))) )
	
	-- ui_Pay._txt_ConsTax_Gold:SetText(tostring(consumptionTaxAmount))
	-- ui_Pay._txt_IncomeTax_Gold:SetText(tostring(incomeTaxAmount))
	-- ui_Pay._txt_Duty_Gold:SetText(tostring(dutyAmount))
	ui_Pay._txt_TransferTax_Gold:SetText(makeDotMoney(transferTaxAmount))
	
	
	
	local taxRemainedAmountForFortress = siegeWrapper:getTaxRemainedAmountForFortress()
	local taxRemainedAmountForSiege = siegeWrapper:getTaxRemainedAmountForSiege()
	
	ui_Pay._txt_Balance_Gold:SetText(makeDotMoney(taxRemainedAmountForFortress))
	ui_Pay._txt_LocalTax_Gold:SetText(makeDotMoney(taxRemainedAmountForSiege))
	-- 메디아, 발렌시아 영주정보(징수현황)에서는 지방세를 보여주지 않는다.
	local territorysInNationalCount = siegeWrapper:getTerritorysCountInNational()
	local territoryKeyInNational = 10
	for ii = 0, territorysInNationalCount - 1 do
		territoryKeyInNational = siegeWrapper:getTerritoryKeyInNationalByIndex(ii)
		if 3 == territoryKeyInNational or 4 == territoryKeyInNational then
			ui_Pay._txt_LocalTax_Gold:SetShow( false )
			ui_Pay._txt_LocalTax:SetShow( false )
			ui_Pay._txt_Balance:SetSpanSize( 15, 351 )
			ui_Pay._txt_Balance_Gold:SetSpanSize( 230, 353 )
			ui_Pay._txt_Balance_Help:SetText( PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_TXT_BALANCE_HELP2") )
		else
			ui_Pay._txt_LocalTax_Gold:SetShow( true )
			ui_Pay._txt_LocalTax:SetShow( true )
			ui_Pay._txt_Balance:SetSpanSize( 15, 335 )
			ui_Pay._txt_Balance_Gold:SetSpanSize( 230, 335 )
			ui_Pay._txt_Balance_Help:SetTextMode( UI_TM.eTextMode_AutoWrap )
			ui_Pay._txt_Balance_Help:SetText( PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_TXT_BALANCE_HELP") )
		end
	end
	ui_Pay._txt_TaxNow_Help:SetTextMode( UI_TM.eTextMode_AutoWrap )
	ui_Pay._txt_TaxBef_Help:SetTextMode( UI_TM.eTextMode_AutoWrap )
	ui_Pay._tax_Help:SetTextMode( UI_TM.eTextMode_AutoWrap )
	
	
	
	
	ui_Pay._txt_TaxNow_Help:SetText( PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_TXT_TAXNOW_HELP") )			-- 현재의 영지에서 징수된 세금
	ui_Pay._txt_TaxBef_Help:SetText( PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_TXT_TAXBEF_HELP") )	-- 타지에서 소속 주민들로부터 징수된 세금
	ui_Pay._tax_Help:SetText( PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_TAX_HELP") )	-- - 공성전/ 성채전이 시작하는 시점부터 누적된 금액을 의미하며, 인출하더라도 위의 표시에 반영되지 않습니다.\n- 위의 표는 매주 공성전/성채전 시점에 초기화 됩니다.

	if Panel_Window_Exchange_Number:IsShow() then
		Panel_NumberPad_Show( false, Defines.s64_const.s64_0, 0, nil);
	end
end


----------------------------------------------------------------
--                  돈 인출
----------------------------------------------------------------
function LordMenu_Withdraw_Money()
	local selfPlayer = getSelfPlayer();
	local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
	if (nil == regionInfoWrapper) then
		return
	end	
	local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(getSelfPlayer():getRegionKeyRaw())
	if (nil == siegeWrapper) then
		return
	end	
	
	local doOccupantExist = siegeWrapper:doOccupantExist()
	if (not doOccupantExist) then
		return;
	end
	
	local isLord = siegeWrapper:isLord()
	
	if (not isLord) then
		return
	end
	
	local taxRemainedAmountForFortress = siegeWrapper:getTaxRemainedAmountForFortress()
	
	Panel_NumberPad_Show(true, taxRemainedAmountForFortress, 0, LordMenu_Withdraw_Money_Message)
end

local withdrawMoney = 0
function LordMenu_Withdraw_Money_Message(inputNumber, param)
	withdrawMoney = inputNumber
	
	
	
	
	local	messageBoxMemo	= tostring(withdrawMoney)..PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_WITHDRAW_CONTENT")
	local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_WITHDRAW_TITLE"), content = messageBoxMemo, functionYes = LordMenu_Withdraw_Money_Confirm, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData)
end

function LordMenu_Withdraw_Money_Confirm()
	local selfPlayer = getSelfPlayer();
	local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
	if (nil == regionInfoWrapper) then
		return
	end	
	local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(getSelfPlayer():getRegionKeyRaw())
	if (nil == siegeWrapper) then
		return
	end	
	
	if (0 == inputNumber) then
		return
	end	
	
	siegeWrapper:moveTownTaxToWarehouse(withdrawMoney, false)
end

function LordMenu_PayInfo_Update()
	Panel_LordMenu_PayInfoUpdate()
end

----------------------------------------------------------------
--					세율 조정 업데이트 함수
----------------------------------------------------------------
-- local consumptionTaxRate 	= 0 
-- local incomeTaxRate 		= 0
-- local dutyRate 				= 0
local transferTaxRate		= 0
local taxForSiegeList 		= {}

function Panel_LordMenu_TaxInfoUpdate()
	local selfPlayer = getSelfPlayer();
	local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
	if (nil == regionInfoWrapper) then
		return
	end	
	local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(getSelfPlayer():getRegionKeyRaw())
	if (nil == siegeWrapper) then
		return
	end	
	
	local doOccupantExist = siegeWrapper:doOccupantExist()
	if (not doOccupantExist) then
		return;
	end
	
	local isLord = siegeWrapper:isLord()
	
	if (not isLord) then
		return
	end
	
	local minRate = 0
	local maxRate = 10
	
	-- minRate = siegeWrapper:getMinTaxRateForFortress(CppEnums.TaxType.eTaxType_BuyItemFromSystem)
	-- maxRate = siegeWrapper:getMaxTaxRateForFortress(CppEnums.TaxType.eTaxType_BuyItemFromSystem)
	-- consumptionTaxRate = siegeWrapper:getTaxRateForFortress(CppEnums.TaxType.eTaxType_BuyItemFromSystem) -- 소비세
	-- ui_Tax._slideBtn_Consum:SetText(tostring(consumptionTaxRate).."%")
	-- ui_Tax._slide_Consum:SetControlPos((consumptionTaxRate-minRate)/(maxRate-minRate)*100)
	-- ui_Tax._txt_Cons_Ref_Min:SetText(tostring(minRate).."%")	
	-- ui_Tax._txt_Cons_Ref_Max:SetText(tostring(maxRate).."%")	
	
	-- minRate = siegeWrapper:getMinTaxRateForFortress(CppEnums.TaxType.eTaxType_BuyItemFromConsignment)
	-- maxRate = siegeWrapper:getMaxTaxRateForFortress(CppEnums.TaxType.eTaxType_BuyItemFromConsignment)
	-- incomeTaxRate = siegeWrapper:getTaxRateForFortress(CppEnums.TaxType.eTaxType_BuyItemFromConsignment) -- 소득세
	-- ui_Tax._slideBtn_IncomeTax:SetText(tostring(incomeTaxRate).."%")
	-- ui_Tax._slide_IncomeTax:SetControlPos((incomeTaxRate-minRate)/(maxRate-minRate)*100)
	-- ui_Tax._txt_Tax_Ref_Min:SetText(tostring(minRate).."%")	
	-- ui_Tax._txt_Tax_Ref_Max:SetText(tostring(maxRate).."%")	
	
	-- minRate = siegeWrapper:getMinTaxRateForFortress(CppEnums.TaxType.eTaxType_DeliverItemByPublicWagon)
	-- maxRate = siegeWrapper:getMaxTaxRateForFortress(CppEnums.TaxType.eTaxType_DeliverItemByPublicWagon)
	-- dutyRate = siegeWrapper:getTaxRateForFortress(CppEnums.TaxType.eTaxType_DeliverItemByPublicWagon) -- 소득세
	-- ui_Tax._slideBtn_Duty:SetText(tostring(dutyRate).."S")	
	-- ui_Tax._slide_Duty:SetControlPos((dutyRate-minRate)/(maxRate-minRate)*100)
	-- ui_Tax._txt_Duty_Ref_Min:SetText(tostring(minRate).."S")	
	-- ui_Tax._txt_Duty_Ref_Max:SetText(tostring(maxRate).."S")	
	
	minRate 		= siegeWrapper:getMinTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
	maxRate 		= siegeWrapper:getMaxTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
	transferTaxRate = siegeWrapper:getTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket) -- 거래세
	ui_Tax._slideBtn_TransferTax:SetText(tostring(transferTaxRate).."%")	
	ui_Tax._slide_TransferTax:SetControlPos((transferTaxRate-minRate)/(maxRate-minRate)*100)
	ui_Tax._txt_TransferTax_Ref_Min:SetText(tostring(minRate).."%")	
	ui_Tax._txt_TransferTax_Ref_Max:SetText(tostring(maxRate).."%")	
	
	-- 거래세 임시 사용불가 처리.(15.01.14)
	ui_Tax._slideBtn_TransferTax:SetMonoTone( true )
	ui_Tax._slideBtn_TransferTax:SetEnable( false )
	
	local isKing = siegeWrapper:isKing()
	local isKingTerritoryOnly = siegeWrapper:isKingTerritoryOnly()

	local isDutyShow = isKing and isKingTerritoryOnly
	-- false된 부분은 사용하지 않는 것이기 때문에 강제 false 처리하였음. 추후 사용하게되면 isDutyShow로 맞출 것.
	ui_Tax._title_1:SetShow(isDutyShow)
	ui_Tax._txt_Territory_1:SetShow(isDutyShow)
	ui_Tax._txt_Territory_2:SetShow(isDutyShow)
	ui_Tax._txt_Territory_3:SetShow( false )
	ui_Tax._txt_Territory_4:SetShow( false )
	ui_Tax._txt_Territory_5:SetShow( false )
	ui_Tax._txt_Territory_6:SetShow( false )
	ui_Tax._slide_Territory_1:SetShow(isDutyShow)
	ui_Tax._slide_Territory_2:SetShow(isDutyShow)
	ui_Tax._slide_Territory_3:SetShow( false )
	ui_Tax._slide_Territory_4:SetShow( false )
	ui_Tax._slide_Territory_5:SetShow( false )
	ui_Tax._slide_Territory_6:SetShow( false )
	ui_Tax._slideBtn_Territory_1:SetShow(isDutyShow)
	ui_Tax._slideBtn_Territory_2:SetShow(isDutyShow)
	ui_Tax._slideBtn_Territory_3:SetShow( false )
	ui_Tax._slideBtn_Territory_4:SetShow( false )
	ui_Tax._slideBtn_Territory_5:SetShow( false )
	ui_Tax._slideBtn_Territory_6:SetShow( false )
	-- ui_Tax._txt_DutyValue_1:SetShow(isDutyShow)
	-- ui_Tax._txt_DutyValue_2:SetShow(isDutyShow)
	-- ui_Tax._txt_DutyValue_3:SetShow( false )
	-- ui_Tax._txt_DutyValue_4:SetShow( false )
	-- ui_Tax._txt_DutyValue_5:SetShow( false )
	-- ui_Tax._txt_DutyValue_6:SetShow( false )
	ui_Tax._txt_min_1:SetShow( isDutyShow )
	ui_Tax._txt_min_2:SetShow( isDutyShow )
	ui_Tax._txt_min_3:SetShow( false )
	ui_Tax._txt_min_4:SetShow( false )
	ui_Tax._txt_min_5:SetShow( false )
	ui_Tax._txt_min_6:SetShow( false )
	ui_Tax._txt_max_1:SetShow( isDutyShow )
	ui_Tax._txt_max_2:SetShow( isDutyShow )
	ui_Tax._txt_max_3:SetShow( false )
	ui_Tax._txt_max_4:SetShow( false )
	ui_Tax._txt_max_5:SetShow( false )
	ui_Tax._txt_max_6:SetShow( false )
	ui_Tax._txt_DutyTax_Help:SetShow(isDutyShow)
	ui_Tax._btn_Duty_Reset:SetShow(isDutyShow)
	ui_Tax._btn_Duty_Accpet:SetShow(isDutyShow)
	ui_Tax._btn_Duty_Reset:SetEnable( true )
	ui_Tax._btn_Duty_Reset:SetMonoTone( false )
	ui_Tax._noTax:SetShow( false )

	local territorysInNationalCount = siegeWrapper:getTerritorysCountInNational()
	local territoryKeyInNational  = 10
	local territorySiege = nil
	local siegeName = nil
	local territoryTaxRateForSiege = 10
	local indexCount = 1

	for ii = 0, territorysInNationalCount - 1 do
		territoryKeyInNational = siegeWrapper:getTerritoryKeyInNationalByIndex(ii)
		if (3 == territoryKeyInNational) or (4 == territoryKeyInNational) then -- 메디아, 발렌시아 지역이면 지방세를 부과할 지역이 없다.(보여주지않는다)
			ui_Tax._txt_Territory_1:SetShow( false )
			ui_Tax._txt_Territory_2:SetShow( false )
			ui_Tax._slide_Territory_1:SetShow( false )
			ui_Tax._slide_Territory_2:SetShow( false )
			ui_Tax._slideBtn_Territory_1:SetShow( false )
			ui_Tax._slideBtn_Territory_2:SetShow( false )
			-- ui_Tax._txt_DutyValue_1:SetShow( false )
			-- ui_Tax._txt_DutyValue_2:SetShow( false )
			ui_Tax._txt_min_1:SetShow( false )
			ui_Tax._txt_min_2:SetShow( false )
			ui_Tax._txt_max_1:SetShow( false )
			ui_Tax._txt_max_2:SetShow( false )
			ui_Tax._btn_Duty_Reset:SetEnable( false )
			ui_Tax._btn_Duty_Reset:SetMonoTone( true )
			ui_Tax._btn_Duty_Accpet:SetEnable( false )
			ui_Tax._btn_Duty_Accpet:SetMonoTone( true )
			ui_Tax._noTax:SetShow( true )
			ui_Tax._txt_DutyTax_Help:SetShow( false )
		end
		if (regionInfoWrapper:getTerritoryKeyRaw() ~= territoryKeyInNational) then
			territorySiege = ToClient_GetSiegeWrapper(territoryKeyInNational)
			territorySiege:updateTaxRateForSiege()
			territoryName = territorySiege:getTerritoryName()
			territoryTaxRateForSiege = territorySiege:getTaxRateForSiege()
			if (nil == taxForSiegeList[indexCount]) then
				taxForSiegeList[indexCount] = {}
			end
			taxForSiegeList[indexCount].territoryKey = territoryKeyInNational	
			taxForSiegeList[indexCount].taxRateForSiege = territoryTaxRateForSiege
			if (nil ~= territorySiege) then
				if (1 == indexCount) then
					ui_Tax._txt_Territory_1:SetText(territoryName)
					ui_Tax._slideBtn_Territory_1:SetText(tostring(territoryTaxRateForSiege).."%")
					ui_Tax._slide_Territory_1:SetControlPos(territoryTaxRateForSiege*2)
					if territoryTaxRateForSiege == 10 then
						ui_Tax._slide_Territory_1:SetControlPos(0)
					end
				elseif (2 == indexCount) then
					ui_Tax._txt_Territory_2:SetText(territoryName)
					ui_Tax._slideBtn_Territory_2:SetText(tostring(territoryTaxRateForSiege).."%")
					ui_Tax._slide_Territory_2:SetControlPos(territoryTaxRateForSiege*2)
					if territoryTaxRateForSiege == 10 then
						ui_Tax._slide_Territory_2:SetControlPos(0)
					end
				elseif (3 == indexCount) then
					ui_Tax._txt_Territory_3:SetText(territoryName)
					ui_Tax._slideBtn_Territory_3:SetText(tostring(territoryTaxRateForSiege).."%")
					ui_Tax._slide_Territory_3:SetControlPos(territoryTaxRateForSiege*2)
				elseif (4 == indexCount) then
					ui_Tax._txt_Territory_4:SetText(territoryName)
					ui_Tax._slideBtn_Territory_4:SetText(tostring(territoryTaxRateForSiege).."%")
					ui_Tax._slide_Territory_4:SetControlPos(territoryTaxRateForSiege*2)	
				elseif (5 == indexCount) then
					ui_Tax._txt_Territory_5:SetText(territoryName)
					ui_Tax._slideBtn_Territory_5:SetText(tostring(territoryTaxRateForSiege).."%")
					ui_Tax._slide_Territory_5:SetControlPos(territoryTaxRateForSiege*2)
				elseif (6 == indexCount) then
					ui_Tax._txt_Territory_6:SetText(territoryName)	
					ui_Tax._slideBtn_Territory_6:SetText(tostring(territoryTaxRateForSiege).."%")
					ui_Tax._slide_Territory_6:SetControlPos(territoryTaxRateForSiege*2)	
				end
				indexCount = indexCount + 1
			end
		end
	end
	
	-- ui_Tax._txt_Consum_Help:SetTextMode( UI_TM.eTextMode_AutoWrap )
	-- ui_Tax._txt_IncomeTax_Help:SetTextMode( UI_TM.eTextMode_AutoWrap )
	-- ui_Tax._txt_Duty_Help:SetTextMode( UI_TM.eTextMode_AutoWrap )
	ui_Tax._txt_TransferTax_Help:SetTextMode( UI_TM.eTextMode_AutoWrap )
	ui_Tax._txt_DutyTax_Help:SetTextMode( UI_TM.eTextMode_AutoWrap )
	
	-- ui_Tax._txt_Consum_Help:SetText( PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_TXT_CONSUM_HELP") )	-- - 상점과 무역품을 구입할 때 매겨지는 세금입니다.
	-- ui_Tax._txt_IncomeTax_Help:SetText( PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_TXT_INCOMETAX_HELP") )	-- - 하우스의 위탁 판매기와 마 시장, 교배 시장에서 발생한 판매 소득에 매겨지는 세금입니다.
	-- ui_Tax._txt_Duty_Help:SetText( PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_TXT_DUTY_HELP") )	-- - 마구간을 통해 아이템을 타지로 운송 시 수수료에 부과되는 세금입니다.
	ui_Tax._txt_TransferTax_Help:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_ITEMMARKETTAX") ) -- "- 거래소에서 매겨지는 세금입니다." )	-- - - 상점과 무역품을 구입할 때 매겨지는 세금입니다.
	ui_Tax._txt_DutyTax_Help:SetText( PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_TXT_DUTYTAX_HELP") ) -- 	- 각 영지에 지방세를 부과하면 매주 특정한 시간에 공물 마차에 실려 성으로 보내지게 됩니다.
	
	local isSiegeBeing = siegeWrapper:isSiegeBeing()
	if (isSiegeBeing) then
		-- ui_Tax._slideBtn_Consum:SetIgnore(isSiegeBeing)
		-- ui_Tax._slideBtn_IncomeTax:SetIgnore(isSiegeBeing)	
		-- ui_Tax._slideBtn_Duty:SetIgnore(isSiegeBeing)	
		ui_Tax._slideBtn_TransferTax:SetIgnore(isSiegeBeing)
		ui_Tax._slideBtn_Territory_1:SetIgnore(isSiegeBeing)
		ui_Tax._slideBtn_Territory_2:SetIgnore(isSiegeBeing)
		ui_Tax._slideBtn_Territory_3:SetIgnore(isSiegeBeing)
		ui_Tax._slideBtn_Territory_4:SetIgnore(isSiegeBeing)
		ui_Tax._slideBtn_Territory_5:SetIgnore(isSiegeBeing)
		ui_Tax._slideBtn_Territory_6:SetIgnore(isSiegeBeing)

		ui_Tax._btn_Tax_Reset:SetEnable(not isSiegeBeing)
		ui_Tax._btn_Tax_Reset:SetEnable(not isSiegeBeing)
		ui_Tax._btn_Tax_Reset:SetMonoTone(isSiegeBeing)
		ui_Tax._btn_Tax_Accpet:SetEnable(not isSiegeBeing)
		ui_Tax._btn_Tax_Reset:SetMonoTone(isSiegeBeing)
		ui_Tax._btn_Duty_Reset:SetEnable(not isSiegeBeing)
		ui_Tax._btn_Tax_Reset:SetMonoTone(isSiegeBeing)
		ui_Tax._btn_Duty_Accpet:SetEnable(not isSiegeBeing)
		ui_Tax._btn_Tax_Reset:SetMonoTone(isSiegeBeing)
	end
	-------- 거래세 사용 불가 상태에 따른 임시 처방.
	ui_Tax._btn_Tax_Reset:SetEnable( false )
	ui_Tax._btn_Tax_Accpet:SetEnable( false )
	ui_Tax._btn_Tax_Reset:SetMonoTone( true )
	ui_Tax._btn_Tax_Accpet:SetMonoTone( true )
	------------------------------------------------------------
	--	!! 문제가 있어 버튼의 Index를 강제로 설정해줘야한다
	ui_Main._FrameBG:SetChildIndex( ui_Tax._btn_Tax_Reset, 9999 )
	ui_Main._FrameBG:SetChildIndex( ui_Tax._btn_Tax_Accpet, 9999 )
	ui_Main._FrameBG:SetChildIndex( ui_Tax._btn_Duty_Reset, 9999 )
	ui_Main._FrameBG:SetChildIndex( ui_Tax._btn_Duty_Accpet, 9999 )
	
	if Panel_Window_Exchange_Number:IsShow() then
		Panel_NumberPad_Show( false, Defines.s64_const.s64_0, 0, nil);
	end
end

----------------------------------------------------------------
--				세율 조정 Slide 버튼 Control
----------------------------------------------------------------
-- function LordMenu_SlideControl_Consum()
	-- local selfPlayer = getSelfPlayer();
	-- local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
	-- if (nil == regionInfoWrapper) then
		-- return
	-- end	
	-- local siegeWrapper = ToClient_GetSiegeWrapper(regionInfoWrapper:getTerritoryKeyRaw())
	-- if (nil == siegeWrapper) then
		-- return
	-- end	
	-- local minRate = siegeWrapper:getMinTaxRateForFortress(CppEnums.TaxType.eTaxType_BuyItemFromSystem)
	-- local maxRate = siegeWrapper:getMaxTaxRateForFortress(CppEnums.TaxType.eTaxType_BuyItemFromSystem)
	-- consumptionTaxRate = math.floor(ui_Tax._slide_Consum:GetControlPos() * (maxRate-minRate) + minRate)
	-- ui_Tax._slideBtn_Consum:SetText(tostring(consumptionTaxRate).."%")	
-- end

-- function LordMenu_SlideControl_Income()
	-- local selfPlayer = getSelfPlayer();
	-- local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
	-- if (nil == regionInfoWrapper) then
		-- return
	-- end	
	-- local siegeWrapper = ToClient_GetSiegeWrapper(regionInfoWrapper:getTerritoryKeyRaw())
	-- if (nil == siegeWrapper) then
		-- return
	-- end	
	-- local minRate = siegeWrapper:getMinTaxRateForFortress(CppEnums.TaxType.eTaxType_BuyItemFromConsignment)
	-- local maxRate = siegeWrapper:getMaxTaxRateForFortress(CppEnums.TaxType.eTaxType_BuyItemFromConsignment)
	-- incomeTaxRate = math.floor(ui_Tax._slide_IncomeTax:GetControlPos() * (maxRate-minRate) + minRate)
	-- ui_Tax._slideBtn_IncomeTax:SetText(tostring(incomeTaxRate).."%")	
-- end

-- function LordMenu_SlideControl_Duty()
	-- local selfPlayer = getSelfPlayer();
	-- local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
	-- if (nil == regionInfoWrapper) then
		-- return
	-- end	
	-- local siegeWrapper = ToClient_GetSiegeWrapper(regionInfoWrapper:getTerritoryKeyRaw())
	-- if (nil == siegeWrapper) then
		-- return
	-- end	
	-- local minRate = siegeWrapper:getMinTaxRateForFortress(CppEnums.TaxType.eTaxType_DeliverItemByPublicWagon)
	-- local maxRate = siegeWrapper:getMaxTaxRateForFortress(CppEnums.TaxType.eTaxType_DeliverItemByPublicWagon)
	-- dutyRate = math.floor(ui_Tax._slide_Duty:GetControlPos() * (maxRate-minRate) + minRate)
	-- ui_Tax._slideBtn_Duty:SetText(tostring(dutyRate).."S")	
-- end

function LordMenu_SlideControl_TransferTax()
	local selfPlayer = getSelfPlayer();
	local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
	if (nil == regionInfoWrapper) then
		return
	end	
	local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(selfPlayer:getRegionKeyRaw())
	if (nil == siegeWrapper) then
		return
	end	
	local minRate = siegeWrapper:getMinTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
	local maxRate = siegeWrapper:getMaxTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
	transferTaxRate = math.floor(ui_Tax._slide_TransferTax:GetControlPos() * (maxRate-minRate) + minRate)
	ui_Tax._slideBtn_TransferTax:SetText(tostring(transferTaxRate).."%")	
end

function LordMenu_SlideControl_TaxForSiegeTerritory_1()
	local taxForSiege = math.floor((0.2 + ui_Tax._slide_Territory_1:GetControlPos() * 4 / 5) * 50)
	-- local taxForSiege = math.floor(ui_Tax._slide_Territory_1:GetControlPos() * 50)
	-- ui_Tax._txt_DutyValue_1:SetText(tostring(taxForSiege).."%")
	ui_Tax._slideBtn_Territory_1:SetText(tostring(taxForSiege).."%")
	taxForSiegeList[1].taxRateForSiege = taxForSiege
end

function LordMenu_SlideControl_TaxForSiegeTerritory_2()
	-- local taxForSiege = math.floor(ui_Tax._slide_Territory_2:GetControlPos() * 50)
	local taxForSiege = math.floor((0.2 + ui_Tax._slide_Territory_2:GetControlPos() * 4 / 5) * 50)
	-- ui_Tax._txt_DutyValue_2			:SetText(tostring(taxForSiege).."%")
	ui_Tax._slideBtn_Territory_2	:SetText(tostring(taxForSiege).."%")
	taxForSiegeList[2].taxRateForSiege = taxForSiege
end

function LordMenu_SlideControl_TaxForSiegeTerritory_3()
	local taxForSiege = math.floor(ui_Tax._slide_Territory_3:GetControlPos() * 50)
	-- ui_Tax._txt_DutyValue_3			:SetText(tostring(taxForSiege).."%")
	ui_Tax._slideBtn_Territory_3	:SetText(tostring(taxForSiege).."%")
	taxForSiegeList[3].taxRateForSiege = taxForSiege
end

function LordMenu_SlideControl_TaxForSiegeTerritory_4()
	local taxForSiege = math.floor(ui_Tax._slide_Territory_4:GetControlPos() * 50)
	-- ui_Tax._txt_DutyValue_4			:SetText(tostring(taxForSiege).."%")
	ui_Tax._slideBtn_Territory_4	:SetText(tostring(taxForSiege).."%")
	taxForSiegeList[4].taxRateForSiege = taxForSiege
end

function LordMenu_SlideControl_TaxForSiegeTerritory_5()
	local taxForSiege = math.floor(ui_Tax._slide_Territory_5:GetControlPos() * 50)
	-- ui_Tax._txt_DutyValue_5			:SetText(tostring(taxForSiege).."%")
	ui_Tax._slideBtn_Territory_5	:SetText(tostring(taxForSiege).."%")
	taxForSiegeList[5].taxRateForSiege = taxForSiege
end

function LordMenu_SlideControl_TaxForSiegeTerritory_6()
	local taxForSiege = math.floor(ui_Tax._slide_Territory_6:GetControlPos() * 50)
	-- ui_Tax._txt_DutyValue_6			:SetText(tostring(taxForSiege).."%")
	ui_Tax._slideBtn_Territory_6	:SetText(tostring(taxForSiege).."%")
	taxForSiegeList[6].taxRateForSiege = taxForSiege
end

function LordMenu_MouseEvent_ResetTaxForFortress()
	local selfPlayer = getSelfPlayer();
	local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
	if (nil == regionInfoWrapper) then
		return
	end	
	local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(selfPlayer:getRegionKeyRaw())
	if (nil == siegeWrapper) then
		return
	end	
	
	local isLord = siegeWrapper:isLord()
	
	if (not isLord) then
		return
	end
	
	local minRate = 0
	local maxRate = 10
	
	-- minRate = siegeWrapper:getMinTaxRateForFortress(CppEnums.TaxType.eTaxType_BuyItemFromSystem)
	-- maxRate = siegeWrapper:getMaxTaxRateForFortress(CppEnums.TaxType.eTaxType_BuyItemFromSystem)
	-- consumptionTaxRate = siegeWrapper:getTaxRateForFortress(CppEnums.TaxType.eTaxType_BuyItemFromSystem) -- 소비세
	-- ui_Tax._slideBtn_Consum:SetText(tostring(consumptionTaxRate).."%")
	-- ui_Tax._slide_Consum:SetControlPos((consumptionTaxRate-minRate)/(maxRate-minRate)*100)
	-- ui_Tax._txt_Cons_Ref_Min:SetText(tostring(minRate).."%")	
	-- ui_Tax._txt_Cons_Ref_Max:SetText(tostring(maxRate).."%")	
	
	-- minRate = siegeWrapper:getMinTaxRateForFortress(CppEnums.TaxType.eTaxType_BuyItemFromConsignment)
	-- maxRate = siegeWrapper:getMaxTaxRateForFortress(CppEnums.TaxType.eTaxType_BuyItemFromConsignment)
	-- incomeTaxRate = siegeWrapper:getTaxRateForFortress(CppEnums.TaxType.eTaxType_BuyItemFromConsignment) -- 소득세
	-- ui_Tax._slideBtn_IncomeTax:SetText(tostring(incomeTaxRate).."%")
	-- ui_Tax._slide_IncomeTax:SetControlPos((incomeTaxRate-minRate)/(maxRate-minRate)*100)
	-- ui_Tax._txt_Tax_Ref_Min:SetText(tostring(minRate).."%")	
	-- ui_Tax._txt_Tax_Ref_Max:SetText(tostring(maxRate).."%")	
	
	-- minRate = siegeWrapper:getMinTaxRateForFortress(CppEnums.TaxType.eTaxType_DeliverItemByPublicWagon)
	-- maxRate = siegeWrapper:getMaxTaxRateForFortress(CppEnums.TaxType.eTaxType_DeliverItemByPublicWagon)
	-- dutyRate = siegeWrapper:getTaxRateForFortress(CppEnums.TaxType.eTaxType_DeliverItemByPublicWagon) -- 소득세
	-- ui_Tax._slideBtn_Duty:SetText(tostring(dutyRate).."S")	
	-- ui_Tax._slide_Duty:SetControlPos((dutyRate-minRate)/(maxRate-minRate)*100)
	-- ui_Tax._txt_Duty_Ref_Min:SetText(tostring(minRate).."S")	
	-- ui_Tax._txt_Duty_Ref_Max:SetText(tostring(maxRate).."S")
	
	minRate 		= siegeWrapper:getMinTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
	maxRate 		= siegeWrapper:getMaxTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
	transferTaxRate = siegeWrapper:getTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket) -- 거래세
	ui_Tax._slideBtn_TransferTax:SetText(tostring(transferTaxRate).."%")	
	ui_Tax._slide_TransferTax:SetControlPos((transferTaxRate-minRate)/(maxRate-minRate)*100)
	ui_Tax._txt_TransferTax_Ref_Min:SetText(tostring(minRate).."%")	
	ui_Tax._txt_TransferTax_Ref_Max:SetText(tostring(maxRate).."%")
end

function LordMenu_MouseEvent_ChangeTaxForFortress()
	local selfPlayer = getSelfPlayer();
	local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
	if (nil == regionInfoWrapper) then
		return
	end	
	local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(selfPlayer:getRegionKeyRaw())
	if (nil == siegeWrapper) then
		return
	end	
	
	local isLord = siegeWrapper:isLord()

	if (not isLord) then
		return
	end
	
	--siegeWrapper:changeTaxRateForFortress(consumptionTaxRate, incomeTaxRate, dutyRate, transferTaxRate)
	siegeWrapper:changeTaxRateForFortress(0, 0, 0, transferTaxRate)
end

function LordMenu_MouseEvent_ResetTaxForSiege()
	local selfPlayer = getSelfPlayer();
	local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
	if (nil == regionInfoWrapper) then
		return
	end	
	local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(selfPlayer:getRegionKeyRaw())
	if (nil == siegeWrapper) then
		return
	end	
	local isKing = siegeWrapper:isKing()
	if (not isKing) then
		return
	end
	
	local territorysInNationalCount = siegeWrapper:getTerritorysCountInNational()
	local territoryKeyInNational  = 10
	local territorySiege = nil
	local siegeName = nil
	local territoryTaxRateForSiege = 10
	local indexCount = 1
	for ii = 0, territorysInNationalCount - 1 do
		territoryKeyInNational = siegeWrapper:getTerritoryKeyInNationalByIndex(ii)
		if (regionInfoWrapper:getTerritoryKeyRaw() ~= territoryKeyInNational) then
			territorySiege = ToClient_GetSiegeWrapper(territoryKeyInNational)
			territoryName = territorySiege:getTerritoryName()
			territoryTaxRateForSiege = territorySiege:getTaxRateForSiege()
			if (nil == taxForSiegeList[indexCount]) then
				taxForSiegeList[indexCount] = {}
			end
			taxForSiegeList[indexCount].territoryKey = territoryKeyInNational	
			taxForSiegeList[indexCount].taxRateForSiege = territoryTaxRateForSiege
			if (nil ~= territorySiege) then
				if (1 == indexCount) then
					ui_Tax._txt_Territory_1:SetText(territoryName)
					ui_Tax._slideBtn_Territory_1:SetText(tostring(territoryTaxRateForSiege).."%")	
					ui_Tax._slide_Territory_1:SetControlPos(territoryTaxRateForSiege*2)
					if territoryTaxRateForSiege == 10 then
						ui_Tax._slide_Territory_1:SetControlPos( 0 )
					end
				elseif (2 == indexCount) then
					ui_Tax._txt_Territory_2:SetText(territoryName)
					ui_Tax._slideBtn_Territory_2:SetText(tostring(territoryTaxRateForSiege).."%")	
					ui_Tax._slide_Territory_2:SetControlPos(territoryTaxRateForSiege*2)
					if territoryTaxRateForSiege == 10 then
						ui_Tax._slide_Territory_2:SetControlPos( 0 )
					end
				elseif (3 == indexCount) then
					ui_Tax._txt_Territory_3:SetText(territoryName)
					ui_Tax._slideBtn_Territory_3:SetText(tostring(territoryTaxRateForSiege).."%")	
					ui_Tax._slide_Territory_3:SetControlPos(territoryTaxRateForSiege*2)
				elseif (4 == indexCount) then
					ui_Tax._txt_Territory_4:SetText(territoryName)
					ui_Tax._slideBtn_Territory_4:SetText(tostring(territoryTaxRateForSiege).."%")
					ui_Tax._slide_Territory_4:SetControlPos(territoryTaxRateForSiege*2)	
				elseif (5 == indexCount) then
					ui_Tax._txt_Territory_5:SetText(territoryName)
					ui_Tax._slideBtn_Territory_5:SetText(tostring(territoryTaxRateForSiege).."%")	
					ui_Tax._slide_Territory_5:SetControlPos(territoryTaxRateForSiege*2)
				elseif (6 == indexCount) then
					ui_Tax._txt_Territory_6:SetText(territoryName)	
					ui_Tax._slideBtn_Territory_6:SetText(tostring(territoryTaxRateForSiege).."%")
					ui_Tax._slide_Territory_6:SetControlPos(territoryTaxRateForSiege*2)	
				end
				indexCount = indexCount + 1
			end	
		end
	end
	
end

function LordMenu_MouseEvent_ChangeTaxForSiege()
	local siegeWrapper = nil
	for idx, val in pairs (taxForSiegeList) do
		if (nil ~= val) then
			siegeWrapper = ToClient_GetSiegeWrapper(val.territoryKey)
			if (nil ~= siegeWrapper ) then
				siegeWrapper:changeTaxRateForSiege(val.taxRateForSiege)
			end
		end	
	end
end

----------------------------------------------------------------
--				각 메뉴들 켜고 끄기 토글 함수
----------------------------------------------------------------
function LordMenu_MouseEvent_TerInfoShow()
	tapIndex = 0
	showToggleElements(true, ui_Ter)
	showToggleElements(false, ui_Pay)
	showToggleElements(false, ui_Tax)
	
	Panel_LordMenu_TerInfoUpdate()
end

function LordMenu_MouseEvent_PayInfoShow()
	tapIndex = 1
	showToggleElements(false, ui_Ter)
	showToggleElements(true, ui_Pay)
	showToggleElements(false, ui_Tax)
	
	Panel_LordMenu_PayInfoUpdate()
end

function LordMenu_MouseEvent_TaxInfoShow()
	tapIndex = 2
	showToggleElements(false, ui_Ter)
	showToggleElements(false, ui_Pay)
	showToggleElements(true, ui_Tax)
	
	Panel_LordMenu_TaxInfoUpdate()
end

function LordMenu_Show()
	
	local selfPlayer = getSelfPlayer();
	local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
	if (nil == regionInfoWrapper) then
		return
	end	
	local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(selfPlayer:getRegionKeyRaw())
	if (nil == siegeWrapper) then
		return
	end	
	
	local isLord = siegeWrapper:isLord()
	if (isLord) then
		siegeWrapper:updateTaxAmount( false )
	end
	
	Panel_LordMenu:SetShow( true )
	ui_Main._btn_TerInfo:SetCheck( true )
	LordMenu_MouseEvent_TerInfoShow()
	
	ui_Main._btn_TerInfo:SetCheck( true )
	ui_Main._btn_PayInfo:SetCheck( false )
	ui_Main._btn_TaxInfo:SetCheck( false )
	
end

function LordMenu_Hide()
	if Panel_LordMenu:IsShow() then
		Panel_LordMenu:SetShow( false )
		ui_Main._btn_TerInfo:SetCheck( true )
		ui_Main._btn_PayInfo:SetCheck( false )
		ui_Main._btn_TaxInfo:SetCheck( false )
	end
end


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Panel_LordMenu_Initialize()

registerEvent("EventLordMenuPayInfoUpdate", "LordMenu_PayInfo_Update")

-- 영주 메뉴에서 세율 조정할 때 실행되는 함수
local texFirstNotifyCheck	= true
-- local _consumptionTaxRate	= nil
-- local _incomeTaxRate		= nil
-- local _dutyRate				= nil
local _transferTaxRate		= nil
function FromClient_NotifyUpdateTownTax(regionKeyRow)
	local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(regionKeyRow)
	if (nil == siegeWrapper) then
		return
	end	

	local territoryName			= siegeWrapper:getTerritoryName()
	-- local consumptionTaxRate	= siegeWrapper:getTaxRateForFortress(CppEnums.TaxType.eTaxType_BuyItemFromSystem)			-- 소비세
	-- local incomeTaxRate			= siegeWrapper:getTaxRateForFortress(CppEnums.TaxType.eTaxType_BuyItemFromConsignment)		-- 소득세
	-- local dutyRate				= siegeWrapper:getTaxRateForFortress(CppEnums.TaxType.eTaxType_DeliverItemByPublicWagon)	-- 관세
	local transferTaxRate		= siegeWrapper:getTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)	-- 거래세
	local _texMessage			= ""

	if ( texFirstNotifyCheck == true ) then
		-- _consumptionTaxRate	= consumptionTaxRate
		-- _incomeTaxRate		= incomeTaxRate
		-- _dutyRate			= dutyRate
		_transferTaxRate	= transferTaxRate
		texFirstNotifyCheck = false
		--_texMessage			= territoryName .. "의 세율이 적용되었습니다.\n( 소비세 : " .. tostring(_consumptionTaxRate) .. "% | 소득세 : " .. tostring(_incomeTaxRate) .. "% | 관세 : " .. tostring(_dutyRate) .. "실버 )"
		_texMessage			= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_LORDMENU_NOTIFYUPDATETOWNTAX_APPLY", "territoryName", territoryName, "transferTaxRate", tostring(_transferTaxRate) ) -- territoryName .. "의 세율이 적용되었습니다.( 거래세 : " .. tostring(_transferTaxRate) .. "% )"
	else
		--if ( _consumptionTaxRate == consumptionTaxRate ) and ( _incomeTaxRate == incomeTaxRate ) and ( _dutyRate == dutyRate ) then		-- 변경된 세율이 없으면
		if ( _transferTaxRate == transferTaxRate ) then			-- 변경된 세율이 없으면
			return
		else
			--_consumptionTaxRate	= consumptionTaxRate
			--_incomeTaxRate		= incomeTaxRate
			--_dutyRate			= dutyRate
			_transferTaxRate	= transferTaxRate
			--_texMessage			= territoryName .. "의 세율이 변경되었습니다.\n( 소비세 : " .. tostring(_consumptionTaxRate) .. "% | 소득세 : " .. tostring(_incomeTaxRate) .. "% | 관세 : " .. tostring(_dutyRate) .. "실버 )"	
			_texMessage			= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_LORDMENU_NOTIFYUPDATETOWNTAX_CHANGE", "territoryName", territoryName, "transferTaxRate", tostring(_transferTaxRate) ) -- territoryName .. "의 세율이 변경되었습니다.( 거래세 : " .. tostring(_transferTaxRate) .. "% )"	
		end
	end

	TerritoryTex_ShowMessage_Ack( _texMessage )

end

registerEvent("FromClient_NotifyUpdateTownTax", "FromClient_NotifyUpdateTownTax")
registerEvent("FromClient_NotifyUpdateSiegeTax", "Panel_LordMenu_TaxInfoUpdate")