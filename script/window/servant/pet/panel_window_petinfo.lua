Panel_Window_PetInfo:SetShow(false, false)
Panel_Window_PetInfo:setMaskingChild( true )
Panel_Window_PetInfo:ActiveMouseEventEffect( true )
Panel_Window_PetInfo:SetDragEnable( true )

Panel_Window_PetInfo:RegisterShowEventFunc( true,		'PetInfoShowAni()' )
Panel_Window_PetInfo:RegisterShowEventFunc( false,		'PetInfoHideAni()' )

local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color

function	PetInfoShowAni()
	Panel_Window_PetInfo:SetShow(true, false)

	UIAni.fadeInSCR_Right(Panel_Window_PetInfo)
	local aniInfo3 = Panel_Window_PetInfo:addColorAnimation( 0.0, 0.20, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo3:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo3.IsChangeChild = false
end

function	PetInfoHideAni()
	Panel_Window_PetInfo:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo1 = Panel_Window_PetInfo:addColorAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd( true )
	aniInfo1:SetDisableWhileAni( true )

	-- local aniInfo2 = Panel_Window_PetInfo:addScaleAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	-- aniInfo2:SetStartScale(1.0)
	-- aniInfo2:SetEndScale(0.97)
	-- aniInfo2.AxisX = 200
	-- aniInfo2.AxisY = 295
	-- aniInfo2.IsChangeChild = true
end

local PetInfo	=
{
	----------------------------------------------------------------------
	-- 기본 정보
	_staticWindowTitle			= UI.getChildControl(Panel_Window_PetInfo,	"Static_PetInfo_Title"),
	_staticName					= UI.getChildControl(Panel_Window_PetInfo,	"StaticText_Name"),
	_staticLevel				= UI.getChildControl(Panel_Window_PetInfo,	"Static_Text_Level"),

	_staticText_Hp				= UI.getChildControl( Panel_Window_PetInfo,	"HP_CountData" ),
	_staticText_Mp				= UI.getChildControl( Panel_Window_PetInfo,	"MP_CountData" ),
	_staticText_Exp				= UI.getChildControl( Panel_Window_PetInfo,	"EXP_CountData" ),
	_staticText_Weight			= UI.getChildControl( Panel_Window_PetInfo,	"WHT_CountData" ),

	_staticText_GaugeBar_Hp		= UI.getChildControl( Panel_Window_PetInfo,	"HP_GaugeBar"),
	_staticText_GaugeBar_Mp		= UI.getChildControl( Panel_Window_PetInfo,	"MP_GaugeBar"),
	_staticText_GaugeBar_Exp	= UI.getChildControl( Panel_Window_PetInfo,	"EXP_GaugeBar"),
	_staticText_GaugeBar_Weight	= UI.getChildControl( Panel_Window_PetInfo,	"Weight_GaugeBar"),

	_femaleIcon					= UI.getChildControl( Panel_Window_PetInfo,	"Static_FemaleIcon"),
	_maleIcon					= UI.getChildControl( Panel_Window_PetInfo,	"Static_MaleIcon"),

	_static_matingCountValue	= UI.getChildControl( Panel_Window_PetInfo,	"Static_MatingCountValue"),
	_static_matingCount			= UI.getChildControl( Panel_Window_PetInfo,	"Static_MatingCount"),
	_staticText_LifeCountValue	= UI.getChildControl( Panel_Window_PetInfo,	"Static_LifeCountValue"),
	_staticText_LifeCount		= UI.getChildControl( Panel_Window_PetInfo,	"Static_LifeCount"),

	_staticMatingtime			= UI.getChildControl( Panel_Window_PetInfo,	"Static_MatingTime"		),
	_staticMatingtimeValue		= UI.getChildControl( Panel_Window_PetInfo,	"Static_MatingTimeValue"),

	_servantSlotNo				= nil
}

----------------------------------------------------------------------------------------------------
-- Init init
function	PetInfo:init()
end

function	PetInfo:update()
	local	servantInfo		= stable_getServant( self._servantSlotNo )
	if	nil == servantInfo	then
		return
	end

	local	characterKeyRaw = servantInfo:getCharacterKeyRaw()
	local	sceneIndex		= getIndexByCharacterKey( characterKeyRaw )
	local 	diffIndexPrev	= true

	Servant_SceneView( self._prevShowHorseIndex, sceneIndex )

	stable_previewEquipItem( slotNo )

	self._prevShowHorseIndex = sceneIndex
	
	-- ★ 기본 정보
	-- self._staticLevel:SetText( "Lv."..tostring( servantInfo:getLevel() ) )
	self._staticLevel:SetText( "Lv.-" )
	self._staticName:SetText( servantInfo:getName() )

	-- self._staticText_Hp:SetText( tostring( servantInfo:getHp() ) .. " / " .. tostring(servantInfo:getMaxHp() ) )
	-- self._staticText_Mp:SetText( tostring( servantInfo:getMp() ) .. " / " .. tostring(servantInfo:getMaxMp() ) )
	-- self._staticText_Exp:SetText( tostring( servantInfo:getExp_s64() ) .. " / " .. tostring(servantInfo:getNeedExp_s64() ) )
	-- self._staticText_Weight:SetText( tostring( servantInfo:getMaxWeight_s64() / Defines.s64_const.s64_10000 ) )
	self._staticText_Hp:SetText( "" )
	self._staticText_Mp:SetText( "" )
	self._staticText_Exp:SetText( "" )
	self._staticText_Weight:SetText( "" )

	-- self._staticText_GaugeBar_Hp:SetSize( 250 / 100 * ( ( servantInfo:getHp() / servantInfo:getMaxHp() ) * 100 ) ,6 )	
	-- self._staticText_GaugeBar_Mp:SetSize( 250 / 100 * ( ( servantInfo:getMp() / servantInfo:getMaxMp() ) * 100 ) ,6 )
	self._staticText_GaugeBar_Hp:SetSize( 0 )	
	self._staticText_GaugeBar_Mp:SetSize( 0 )

	-- 경험치 게이지 표시
	local	s64_exp			= servantInfo:getExp_s64()
	local	s64_needexp		= servantInfo:getNeedExp_s64()
	local	s64_exp_percent	= Defines.s64_const.s64_0
	if	Defines.s64_const.s64_0 < s64_exp	then
		s64_exp_percent	= toUint64( 0, 250 ) / Defines.s64_const.s64_100 * ( ( s64_exp / s64_needexp ) * Defines.s64_const.s64_100 )
	end
	-- self._staticText_GaugeBar_Exp:SetSize( Int64toInt32( s64_exp_percent ), 6 )
	self._staticText_GaugeBar_Exp:SetSize( 0 )

	self._maleIcon:SetShow( false )
	self._femaleIcon:SetShow( false )
	if servantInfo:isMale()	then
		self._maleIcon:SetShow( true )
	else
		self._femaleIcon:SetShow( true )
	end

	-- 남은 교배 수
	self._static_matingCountValue:SetText( servantInfo:getMatingCount() )	-- 죽은 휫수는 getDeadCount()
	self._static_matingCount:SetShow( true )
	self._static_matingCountValue:SetShow( true )

	self._staticMatingtime:SetShow( false )
	self._staticMatingtimeValue:SetShow( false )
	if	( CppEnums.ServantStateType.Type_Mating == servantInfo:getStateType() )	then
		if	( not servantInfo:isMatingComplete() )	then
			self._staticMatingtimeValue:SetText( convertStringFromDatetime( servantInfo:getMatingTime() ) )
			self._staticMatingtime:SetShow( true )
			self._staticMatingtimeValue:SetShow( true )
		end
	end

	-- 남은 수명
	local ExpiredTime = servantInfo:getExpiredTime()
	if "" == convertStringFromDatetime( ExpiredTime ) then
		self._staticText_LifeCountValue:SetText(PAGetString(Defines.StringSheet_RESOURCE, "STABLE_INFO_TEXT_LIFEVALUE"))	
	else
		self._staticText_LifeCountValue:SetText( convertStringFromDatetime( ExpiredTime ) )
	end
	self._staticText_LifeCount:SetShow( true )
	self._staticText_LifeCountValue:SetShow( true )

end

function	PetInfo:registEventHandler()
end

function	PetInfo:registMessageHandler()
	registerEvent( "onScreenResize",				"PetInfo_Resize" )
end

function	PetInfo_Resize()
	-- screenX = getScreenSizeX()
	-- screenY = getScreenSizeY()

	Panel_Window_PetInfo:SetSpanSize( 20, 30 )
	Panel_Window_PetInfo:ComputePos()
end

----------------------------------------------------------------------------------------------------
-- Function
function	PetInfo_Update( slotNo )
	local	self	= PetInfo
	self._servantSlotNo	= slotNo
	self:update()
	
	PetInfo_Open()
end

----------------------------------------------------------------------------------------------------
-- Common Function
function	PetInfo_ScrollEvent( isScrollUp )
	local	self		= PetInfo

	self._startSlotIndex	= UIScroll.ScrollEvent( self._baseSkillScroll, isScrollUp, self.config.skillSlotCount, self._temporayLearnSkillCount, self._startSlotIndex, 1 )
	self:SlotUpdate( self.currentSlotNo )
end
----------------------------------------------------------------------------------------------------
-- Window Open/Close

function	PetInfo_Open()
	if	( Panel_Window_PetInfo:GetShow() )	then
		return
	end

	Panel_Window_PetInfo:SetShow(true, false)	
end

function	PetInfo_Close()
	if	( not Panel_Window_PetInfo:GetShow() )	then
		return
	end
	
	Panel_Window_PetInfo:SetShow(false, false)
end

----------------------------------------------------------------------------------------------------
-- 아가 수령.

function	PetInfo_ReceiveChildServant()
	stable_getServantMatingChildInfo( PetList_SelectSlotNo() )
	PetList_ClosePopup()
end


-- Init
PetInfo:init()
PetInfo:registEventHandler()
PetInfo:registMessageHandler()

PetInfo_Resize()