local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UCT			= CppEnums.PA_UI_CONTROL_TYPE
local UI_TM			= CppEnums.TextMode
local UI_color 		= Defines.Color

Panel_Widget_CraftLevInfo:SetShow( false )
Panel_Widget_CraftLevInfo:SetPosX( 15 )
Panel_Widget_CraftLevInfo:SetPosY( getScreenSizeY() - Panel_Widget_CraftLevInfo:GetSizeY() )
Panel_Widget_CraftLevInfo:SetDragAll( true )
Panel_Widget_CraftLevInfo:setMaskingChild(true)

-- Panel_Widget_CraftLevInfo:addInputEvent("Mouse_On", "CraftLevInfo_RollOver( true )")
-- Panel_Widget_CraftLevInfo:addInputEvent("Mouse_Out", "CraftLevInfo_RollOver( false )")

Panel_Widget_CraftLevInfo:RegisterShowEventFunc( true, 'CraftLevInfo_ShowAni()' )
Panel_Widget_CraftLevInfo:RegisterShowEventFunc( false, 'CraftLevInfo_HideAni()' )

--------------------------------------------------------------------------------
-- 기본 선언
--------------------------------------------------------------------------------
local CraftLevInfo = {
	gathering_Icon			= UI.getChildControl(Panel_Widget_CraftLevInfo, "Static_Icon_Gathering"),
	manufacture_Icon		= UI.getChildControl(Panel_Widget_CraftLevInfo, "Static_Icon_Manufacture"),
	cook_Icon				= UI.getChildControl(Panel_Widget_CraftLevInfo, "Static_Icon_Cook"),
	training_Icon			= UI.getChildControl(Panel_Widget_CraftLevInfo, "Static_Icon_Training"),
	alchemy_Icon			= UI.getChildControl(Panel_Widget_CraftLevInfo, "Static_Icon_Alchemy"),
	fishing_Icon			= UI.getChildControl(Panel_Widget_CraftLevInfo, "Static_Icon_Fishing"),
	hunting_Icon			= UI.getChildControl(Panel_Widget_CraftLevInfo, "Static_Icon_Hunting"),
	trade_Icon				= UI.getChildControl(Panel_Widget_CraftLevInfo, "Static_Icon_Trade"),

	gathering_Progress    	= UI.getChildControl(Panel_Widget_CraftLevInfo, "Progress2_GatheringLevel_Gauge"),
	manufacture_Progress  	= UI.getChildControl(Panel_Widget_CraftLevInfo, "Progress2_ManufactureLevel_Gauge"),
	cook_Progress         	= UI.getChildControl(Panel_Widget_CraftLevInfo, "Progress2_CookLevel_Gauge"),
	training_Progress     	= UI.getChildControl(Panel_Widget_CraftLevInfo, "Progress2_TrainingLevel_Gauge"),
	alchemy_Progress      	= UI.getChildControl(Panel_Widget_CraftLevInfo, "Progress2_AlchemyLevel_Gauge"),
	fishing_Progress      	= UI.getChildControl(Panel_Widget_CraftLevInfo, "Progress2_FishingLevel_Gauge"),
	hunting_Progress      	= UI.getChildControl(Panel_Widget_CraftLevInfo, "Progress2_HuntingLevel_Gauge"),
	trade_Progress        	= UI.getChildControl(Panel_Widget_CraftLevInfo, "Progress2_TradeLevel_Gauge"),

	gathering_LevText    	= UI.getChildControl(Panel_Widget_CraftLevInfo, "StaticText_GatheringLevel_Value"),
	manufacture_LevText  	= UI.getChildControl(Panel_Widget_CraftLevInfo, "StaticText_ManufactureLevel_Value"),
	cook_LevText         	= UI.getChildControl(Panel_Widget_CraftLevInfo, "StaticText_CookLevel_Value"),
	training_LevText     	= UI.getChildControl(Panel_Widget_CraftLevInfo, "StaticText_TrainingLevel_Value"),
	alchemy_LevText      	= UI.getChildControl(Panel_Widget_CraftLevInfo, "StaticText_AlchemyLevel_Value"),
	fishing_LevText      	= UI.getChildControl(Panel_Widget_CraftLevInfo, "StaticText_FishingLevel_Value"),
	hunting_LevText      	= UI.getChildControl(Panel_Widget_CraftLevInfo, "StaticText_HuntingLevel_Value"),
	trade_LevText        	= UI.getChildControl(Panel_Widget_CraftLevInfo, "StaticText_TradeLevel_Value"),
}


local craftType = 
{
	gather		= 0, -- 채집
	fishing		= 1, -- 낚시
	hunting		= 2, -- 수렵
	cooking		= 3, -- 요리
	alchemy		= 4, -- 연금
	manufacture	= 5, -- 가공
	training	= 6, -- 조련
	trade		= 7, -- 무역
	levelText	= PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_CRAFTLEVEL"),
}


function CraftLevInfo:registEventHandler()
end 
function CraftLevInfo:registMessageHandler()
	registerEvent("FromClient_UpdateSelfPlayerLifeExp",		"FromClient_CraftLevInfoUpdate")
	registerEvent("onScreenResize",							"FromClient_CraftLevInfo_OnScreenResize")
end

--------------------------------------------------------------------------------
-- 툴팁 설정
--------------------------------------------------------------------------------
local tooltipBase 	= UI.getChildControl ( Panel_CheckedQuest, "StaticText_Notice_1")
local helpWidget	= UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT, Panel_Widget_CraftLevInfo, "HelpWindow_For_CraftLevInfo" )
CopyBaseProperty( tooltipBase, helpWidget )
helpWidget:SetColor( ffffffff )
helpWidget:SetAlpha( 1.0 )
helpWidget:SetFontColor( UI_color.C_FFC4BEBE )
helpWidget:SetAutoResize( true )
helpWidget:SetTextMode( UI_TM.eTextMode_AutoWrap )
helpWidget:SetShow( false )
--helpWidget:SetTextHorizonCenter()
Panel_Widget_CraftLevInfo:SetChildIndex( helpWidget, 9999 )

--------------------------------------------------------------------------------
-- 초기 설정
--------------------------------------------------------------------------------
local CraftLevInfo_Initialize = function()
	local self = CraftLevInfo
	-- Panel_Widget_CraftLevInfo:SetShow( true, true )
	self.gathering_Icon			:SetIgnore( false )
	self.manufacture_Icon		:SetIgnore( false )
	self.cook_Icon				:SetIgnore( false )
	self.training_Icon			:SetIgnore( false )
	self.alchemy_Icon			:SetIgnore( false )
	self.fishing_Icon			:SetIgnore( false )
	self.hunting_Icon			:SetIgnore( false )
	self.trade_Icon				:SetIgnore( false )
	self.gathering_Progress    	:SetIgnore( true )
	self.manufacture_Progress  	:SetIgnore( true )
	self.cook_Progress         	:SetIgnore( true )
	self.training_Progress     	:SetIgnore( true )
	self.alchemy_Progress      	:SetIgnore( true )
	self.fishing_Progress      	:SetIgnore( true )
	self.hunting_Progress      	:SetIgnore( true )
	self.trade_Progress        	:SetIgnore( true )
end


--------------------------------------------------------------------------------
--					SHOW 애니메이션, HIDE 애니메이션
--------------------------------------------------------------------------------
function CraftLevInfo_ShowAni()
	Panel_Widget_CraftLevInfo:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_IN)
	local aniInfo = Panel_Widget_CraftLevInfo:addColorAnimation( 0.0, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo.IsChangeChild = true

	local aniInfo1 = Panel_Widget_CraftLevInfo:addScaleAnimation( 0.0, 0.12, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.0)
	aniInfo1:SetEndScale(1.3)
	aniInfo1.AxisX = Panel_Widget_CraftLevInfo:GetSizeX() / 2
	aniInfo1.AxisY = Panel_Widget_CraftLevInfo:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_Widget_CraftLevInfo:addScaleAnimation( 0.12, 0.18, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.3)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_Widget_CraftLevInfo:GetSizeX() / 2
	aniInfo2.AxisY = Panel_Widget_CraftLevInfo:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end
function CraftLevInfo_HideAni()
	Panel_Widget_CraftLevInfo:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo3 = Panel_Widget_CraftLevInfo:addColorAnimation( 0.0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo3:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo3.IsChangeChild = true
	aniInfo3:SetHideAtEnd(true)
	aniInfo3:SetDisableWhileAni(true)		
end

--------------------------------------------------------------------------------
-- 업데이트
--------------------------------------------------------------------------------
function CraftLevInfo:Update()
	local player = getSelfPlayer()
	local playerGet = player:get()

	-- 2. 생산 등급 : (1) 채집
	local gatherLevel 			= playerGet:getLifeExperienceLevel(craftType.gather)
	local gatherCurrentExp 		= playerGet:getCurrLifeExperiencePoint(craftType.gather)
	local gatherMaxExp 			= playerGet:getDemandLifeExperiencePoint(craftType.gather)
	local gatherExpRate			= Int64toInt32(gatherCurrentExp * toInt64(0,100) / gatherMaxExp)
	self.gathering_LevText			:SetText( FGlobal_CraftLevel_Replace( gatherLevel, craftType.gather ) )
	self.gathering_Progress			:SetProgressRate(gatherExpRate)
	self.gathering_Icon				:addInputEvent("Mouse_On",	"CraftLevInfo_RollOver( true, " .. craftType.gather .. " )")
	self.gathering_Icon				:addInputEvent("Mouse_Out",	"CraftLevInfo_RollOver( false )")
	self.gathering_Progress			:addInputEvent("Mouse_On",	"CraftLevInfo_RollOver( true, " .. craftType.gather .. " )")
	self.gathering_Progress			:addInputEvent("Mouse_Out",	"CraftLevInfo_RollOver( false )")
	self.gathering_Icon				:SetEnableArea( 0, 0, self.gathering_Icon:GetSizeX() + self.gathering_Progress:GetSizeX() + 2, self.gathering_Icon:GetSizeY() + 3 )
	
	-- 2. 생산 등급 : (2) 가공
	local manufatureLevel 		= playerGet:getLifeExperienceLevel(craftType.manufacture)
	local manufatureCurrentExp 	= playerGet:getCurrLifeExperiencePoint(craftType.manufacture)
	local manufatureMaxExp 		= playerGet:getDemandLifeExperiencePoint(craftType.manufacture)
	local manufatureExpRate		= Int64toInt32(manufatureCurrentExp * toInt64(0,100) / manufatureMaxExp)
	self.manufacture_LevText	:SetText( FGlobal_CraftLevel_Replace( manufatureLevel, craftType.manufacture ) )
	self.manufacture_Progress	:SetProgressRate(manufatureExpRate)
	self.manufacture_Icon		:addInputEvent("Mouse_On",	"CraftLevInfo_RollOver( true, " .. craftType.manufacture .. " )")
	self.manufacture_Icon		:addInputEvent("Mouse_Out",	"CraftLevInfo_RollOver( false )")
	self.manufacture_Progress	:addInputEvent("Mouse_On",	"CraftLevInfo_RollOver( true, " .. craftType.manufacture .. " )")
	self.manufacture_Progress	:addInputEvent("Mouse_Out",	"CraftLevInfo_RollOver( false )")
	self.manufacture_Icon		:SetEnableArea( 0, 0, self.manufacture_Icon:GetSizeX() + self.manufacture_Progress:GetSizeX() + 2, self.manufacture_Icon:GetSizeY() + 3 )

	-- 2. 생산 등급 : (3) 요리
	local cookingLevel 			= playerGet:getLifeExperienceLevel(craftType.cooking)
	local cookingCurrentExp 	= playerGet:getCurrLifeExperiencePoint(craftType.cooking)
	local cookingMaxExp 		= playerGet:getDemandLifeExperiencePoint(craftType.cooking)
	local cookingExpRate		= Int64toInt32(cookingCurrentExp * toInt64(0,100) / cookingMaxExp)
	self.cook_LevText			:SetText( FGlobal_CraftLevel_Replace(cookingLevel, craftType.cooking) )
	self.cook_Progress			:SetProgressRate(cookingExpRate)
	self.cook_Icon				:addInputEvent("Mouse_On",	"CraftLevInfo_RollOver( true, " .. craftType.cooking .. " )")
	self.cook_Icon				:addInputEvent("Mouse_Out",	"CraftLevInfo_RollOver( false )")
	self.cook_Progress			:addInputEvent("Mouse_On",	"CraftLevInfo_RollOver( true, " .. craftType.cooking .. " )")
	self.cook_Progress			:addInputEvent("Mouse_Out",	"CraftLevInfo_RollOver( false )")
	self.cook_Icon				:SetEnableArea( 0, 0, self.cook_Icon:GetSizeX() + self.cook_Progress:GetSizeX() + 2, self.cook_Icon:GetSizeY() + 3 )

	-- 2. 생산 등급 : (4) 연금
	local alchemyLevel 			= playerGet:getLifeExperienceLevel(craftType.alchemy)
	local alchemyCurrentExp 	= playerGet:getCurrLifeExperiencePoint(craftType.alchemy)
	local alchemyMaxExp 		= playerGet:getDemandLifeExperiencePoint(craftType.alchemy)
	local alchemyExpRate		= Int64toInt32(alchemyCurrentExp * toInt64(0,100) / alchemyMaxExp)
	self.alchemy_LevText		:SetText( FGlobal_CraftLevel_Replace(alchemyLevel, craftType.alchemy) )
	self.alchemy_Progress		:SetProgressRate(alchemyExpRate)
	self.alchemy_Icon			:addInputEvent("Mouse_On",	"CraftLevInfo_RollOver( true, " .. craftType.alchemy .. " )")
	self.alchemy_Icon			:addInputEvent("Mouse_Out",	"CraftLevInfo_RollOver( false )")
	self.alchemy_Progress		:addInputEvent("Mouse_On",	"CraftLevInfo_RollOver( true, " .. craftType.alchemy .. " )")
	self.alchemy_Progress		:addInputEvent("Mouse_Out",	"CraftLevInfo_RollOver( false )")
	self.alchemy_Icon			:SetEnableArea( 0, 0, self.alchemy_Icon:GetSizeX() + self.alchemy_Progress:GetSizeX() + 2, self.alchemy_Icon:GetSizeY() + 3 )

	-- 2. 생산 등급 : (5)낚시
	local fishingLevel 			= playerGet:getLifeExperienceLevel(craftType.fishing)
	local fishingCurrentExp 	= playerGet:getCurrLifeExperiencePoint(craftType.fishing)
	local fishingMaxExp 		= playerGet:getDemandLifeExperiencePoint(craftType.fishing)
	local fishingExpRate		= Int64toInt32(fishingCurrentExp * toInt64(0,100) / fishingMaxExp)
	self.fishing_LevText		:SetText( FGlobal_CraftLevel_Replace(fishingLevel, craftType.fishing) )
	self.fishing_Progress		:SetProgressRate(fishingExpRate)
	self.fishing_Icon			:addInputEvent("Mouse_On",	"CraftLevInfo_RollOver( true, " .. craftType.fishing .. " )")
	self.fishing_Icon			:addInputEvent("Mouse_Out",	"CraftLevInfo_RollOver( false )")
	self.fishing_Progress		:addInputEvent("Mouse_On",	"CraftLevInfo_RollOver( true, " .. craftType.fishing .. " )")
	self.fishing_Progress		:addInputEvent("Mouse_Out",	"CraftLevInfo_RollOver( false )")
	self.fishing_Icon			:SetEnableArea( 0, 0, self.fishing_Icon:GetSizeX() + self.fishing_Progress:GetSizeX() + 2, self.fishing_Icon:GetSizeY() + 3 )

	-- 2. 생산 등급 : (6)수렵
	local huntingLevel 			= playerGet:getLifeExperienceLevel(craftType.hunting)
	local huntingCurrentExp 	= playerGet:getCurrLifeExperiencePoint(craftType.hunting)
	local huntingMaxExp 		= playerGet:getDemandLifeExperiencePoint(craftType.hunting)
	local huntingExpRate		= Int64toInt32(huntingCurrentExp * toInt64(0,100) / huntingMaxExp)
	self.hunting_LevText		:SetText( FGlobal_CraftLevel_Replace(huntingLevel, craftType.hunting) )
	self.hunting_Progress		:SetProgressRate(huntingExpRate)
	self.hunting_Icon			:addInputEvent("Mouse_On",	"CraftLevInfo_RollOver( true, " .. craftType.hunting .. " )")
	self.hunting_Icon			:addInputEvent("Mouse_Out",	"CraftLevInfo_RollOver( false )")
	self.hunting_Progress		:addInputEvent("Mouse_On",	"CraftLevInfo_RollOver( true, " .. craftType.hunting .. " )")
	self.hunting_Progress		:addInputEvent("Mouse_Out",	"CraftLevInfo_RollOver( false )")
	self.hunting_Icon			:SetEnableArea( 0, 0, self.hunting_Icon:GetSizeX() + self.hunting_Progress:GetSizeX() + 2, self.hunting_Icon:GetSizeY() + 3 )

	-- 2. 생산 등급 : (7)조련
	local trainingLevel 		= playerGet:getLifeExperienceLevel(craftType.training)
	local trainingCurrentExp 	= playerGet:getCurrLifeExperiencePoint(craftType.training)
	local trainingMaxExp 		= playerGet:getDemandLifeExperiencePoint(craftType.training)
	local trainingExpRate		= Int64toInt32(trainingCurrentExp * toInt64(0,100) / trainingMaxExp)
	self.training_LevText		:SetText( FGlobal_CraftLevel_Replace(trainingLevel, craftType.training) )
	self.training_Progress		:SetProgressRate(trainingExpRate)
	self.training_Icon			:addInputEvent("Mouse_On",	"CraftLevInfo_RollOver( true, " .. craftType.training .. " )")
	self.training_Icon			:addInputEvent("Mouse_Out",	"CraftLevInfo_RollOver( false )")
	self.training_Progress		:addInputEvent("Mouse_On",	"CraftLevInfo_RollOver( true, " .. craftType.training .. " )")
	self.training_Progress		:addInputEvent("Mouse_Out",	"CraftLevInfo_RollOver( false )")
	self.training_Icon			:SetEnableArea( 0, 0, self.training_Icon:GetSizeX() + self.training_Progress:GetSizeX() + 2, self.training_Icon:GetSizeY() + 3 )

	-- 2. 생산 등급 : (8)무역
	local tradeLevel 			= playerGet:getLifeExperienceLevel(craftType.trade)
	local tradeCurrentExp 		= playerGet:getCurrLifeExperiencePoint(craftType.trade)
	local tradeMaxExp 			= playerGet:getDemandLifeExperiencePoint(craftType.trade)
	local tradeExpRate			= Int64toInt32(tradeCurrentExp * toInt64(0,100) / tradeMaxExp)
	self.trade_LevText	 		:SetText( FGlobal_CraftLevel_Replace(tradeLevel, craftType.trade) )
	self.trade_Progress			:SetProgressRate(tradeExpRate)
	self.trade_Icon				:addInputEvent("Mouse_On",	"CraftLevInfo_RollOver( true, " .. craftType.trade .. " )")
	self.trade_Icon				:addInputEvent("Mouse_Out",	"CraftLevInfo_RollOver( false )")
	self.trade_Progress			:addInputEvent("Mouse_On",	"CraftLevInfo_RollOver( true, " .. craftType.trade .. " )")
	self.trade_Progress			:addInputEvent("Mouse_Out",	"CraftLevInfo_RollOver( false )")
	self.trade_Icon				:SetEnableArea( 0, 0, self.trade_Icon:GetSizeX() + self.trade_Progress:GetSizeX() + 2, self.trade_Icon:GetSizeY() + 3 )
end
function FromClient_CraftLevInfoUpdate()
	local self = CraftLevInfo
	self:Update()
end

--------------------------------------------------------------------------------
-- 마우스 오버
--------------------------------------------------------------------------------
function CraftLevInfo_RollOver( show, type )
	local self = CraftLevInfo
	local text = nil
	local posX = nil
	local posY = nil
	if true == show then
		if craftType.gather == type then
			text = PAGetString(Defines.StringSheet_GAME, "LUA_CRAFTLEVELINFO_DESC_1") .. self.gathering_LevText:GetText()		-- 채집
			posX = self.gathering_Icon:GetPosX()
			posY = self.gathering_Icon:GetPosY()
		elseif craftType.manufacture == type then
			text = PAGetString(Defines.StringSheet_GAME, "LUA_CRAFTLEVELINFO_DESC_2") .. self.manufacture_LevText:GetText()		-- 가공
			posX = self.manufacture_Icon:GetPosX()
			posY = self.manufacture_Icon:GetPosY()
		elseif craftType.cooking == type then
			text = PAGetString(Defines.StringSheet_GAME, "LUA_CRAFTLEVELINFO_DESC_3") .. self.cook_LevText:GetText()			-- 요리
			posX = self.cook_Icon:GetPosX()
			posY = self.cook_Icon:GetPosY()
		elseif craftType.alchemy == type then
			text = PAGetString(Defines.StringSheet_GAME, "LUA_CRAFTLEVELINFO_DESC_4") .. self.alchemy_LevText:GetText()			-- 연금
			posX = self.alchemy_Icon:GetPosX()
			posY = self.alchemy_Icon:GetPosY()
		elseif craftType.fishing == type then
			text = PAGetString(Defines.StringSheet_GAME, "LUA_CRAFTLEVELINFO_DESC_5") .. self.fishing_LevText:GetText()			-- 낚시
			posX = self.fishing_Icon:GetPosX()
			posY = self.fishing_Icon:GetPosY()
		elseif craftType.hunting == type then
			text = PAGetString(Defines.StringSheet_GAME, "LUA_CRAFTLEVELINFO_DESC_6") .. self.hunting_LevText:GetText()			-- 수렵
			posX = self.hunting_Icon:GetPosX()
			posY = self.hunting_Icon:GetPosY()
		elseif craftType.training == type then
			text = PAGetString(Defines.StringSheet_GAME, "LUA_CRAFTLEVELINFO_DESC_7") .. self.training_LevText:GetText()		-- 조련
			posX = self.training_Icon:GetPosX()
			posY = self.training_Icon:GetPosY()			
		elseif craftType.trade == type then
			text = PAGetString(Defines.StringSheet_GAME, "LUA_CRAFTLEVELINFO_DESC_8") .. self.trade_LevText:GetText()			-- 무역
			posX = self.trade_Icon:GetPosX()
			posY = self.trade_Icon:GetPosY()
		end
		helpWidget:SetText( text )
		helpWidget:SetSize( helpWidget:GetTextSizeX() + 20, helpWidget:GetSizeY() )
		helpWidget:SetPosX( self.gathering_LevText:GetPosX() )
		helpWidget:SetPosY( self.gathering_LevText:GetPosY() - 5 )
		helpWidget:SetShow( true )
	else
		helpWidget:SetShow( false )
	end
end

function FromClient_CraftLevInfo_OnScreenResize()
	Panel_Widget_CraftLevInfo:SetPosX( 15 )
	Panel_Widget_CraftLevInfo:SetPosY( getScreenSizeY() - Panel_Widget_CraftLevInfo:GetSizeY() )
end
--------------------------------------------------------------------------------
-- 온오프
--------------------------------------------------------------------------------
function CraftLevInfo_Show()
	if Panel_Widget_CraftLevInfo:GetShow() then
		return
	end
	-- Panel_Widget_CraftLevInfo:SetShow( true, true )
end
function CraftLevInfo_Hide()
	if not Panel_Widget_CraftLevInfo:GetShow() then
		return
	end
	-- Panel_Widget_CraftLevInfo:SetShow( false, false )
end

function Panel_Widget_CraftLevInfo_ShowToggle()
	-- if Panel_Widget_CraftLevInfo:IsShow() then
	-- 	Panel_Widget_CraftLevInfo:SetShow( false, false )
	-- else
	-- 	Panel_Widget_CraftLevInfo:SetShow( true, true )
	-- end
end

Panel_Widget_CraftLevInfo:addInputEvent( "Mouse_LUp", "ResetPos_WidgetButton()" )

CraftLevInfo_Initialize()
CraftLevInfo:registEventHandler()
CraftLevInfo:registMessageHandler()
CraftLevInfo:Update()
