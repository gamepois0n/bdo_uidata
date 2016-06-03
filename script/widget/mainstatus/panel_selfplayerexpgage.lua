local UI_TM 		= CppEnums.TextMode
local UI_PUCT 		= CppEnums.PA_UI_CONTROL_TYPE
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color 		= Defines.Color
local UI_BUFFTYPE	= CppEnums.UserChargeType

-- 사운드 추가 필요
Panel_SelfPlayerExpGage:SetShow( true, false )
Panel_SelfPlayerExpGage:SetIgnore(true)
Panel_SelfPlayerExpGage:ActiveMouseEventEffect(false)
Panel_SelfPlayerExpGage:RegisterShowEventFunc( true, 'SelfPlayerExpGageShowAni()' )
Panel_SelfPlayerExpGage:RegisterShowEventFunc( false, 'SelfPlayerExpGageHideAni()' )

local _levelBG 					= UI.getChildControl( Panel_SelfPlayerExpGage, "Static_LevelBG" )

local expGageBG 				= UI.getChildControl( Panel_SelfPlayerExpGage, "Static_SelfPlayerExpBG" )
local expGage 					= UI.getChildControl( Panel_SelfPlayerExpGage, "Progress2_ExpGage" )
local _expHead 					= UI.getChildControl( expGage, 					"Progress2_ExpGage_Head" )
local staticLevelBg				= UI.getChildControl( Panel_SelfPlayerExpGage, "Static_LevelBG" )
local _staticLevel 				= UI.getChildControl( Panel_SelfPlayerExpGage, "StaticText_Level" )
local _staticLevelSub 			= UI.getChildControl( Panel_SelfPlayerExpGage, "StaticText_Level_Sub" )
local _staticLvText				= UI.getChildControl( Panel_SelfPlayerExpGage, "StaticText_LVTXT" )
local expText 					= UI.getChildControl( Panel_SelfPlayerExpGage, "StaticText_EXPText" )

local _skillGaugeBG 			= UI.getChildControl( Panel_SelfPlayerExpGage, "Static_SkillGauge_BG" )
local _staticSkillExp 			= UI.getChildControl( Panel_SelfPlayerExpGage, "CircularProgress_SkillExp" )
local _staticSkillExp_Head		= UI.getChildControl( _staticSkillExp,			"Progress2_1_Bar_Head" )
local _staticSkillPoint 		= UI.getChildControl( Panel_SelfPlayerExpGage, "StaticText_Sp" )
local _staticSkillPointMain		= UI.getChildControl( Panel_SelfPlayerExpGage, "StaticText_Sp_Main" )
local _staticSkillPointSub 		= UI.getChildControl( Panel_SelfPlayerExpGage, "StaticText_Sp_Sub" )

local _wpGaugeBG 				= UI.getChildControl( Panel_SelfPlayerExpGage, "Static_WP_BG" )
local _Wp 						= UI.getChildControl( Panel_SelfPlayerExpGage, "StaticText_WP" )
local _Wp_Main					= UI.getChildControl( Panel_SelfPlayerExpGage, "StaticText_WP_Main" )
local _wpGauge 					= UI.getChildControl( Panel_SelfPlayerExpGage, "Progress2_WP" )
local _wpGauge_Head				= UI.getChildControl( _wpGauge, 				"Progress2_1_Bar_Head" )
local _WpHelpMSG 				= UI.getChildControl( Panel_SelfPlayerExpGage, "StaticText_WPHelp" )

local _contribute_BG 			= UI.getChildControl( Panel_SelfPlayerExpGage, "Static_Contribute_BG" )
local _contribute_progress		= UI.getChildControl( Panel_SelfPlayerExpGage, "Progress_Contribute" )
local _contribute_progress_Head	= UI.getChildControl( _contribute_progress, 	"Progress2_1_Bar_Head" )
local _contribute_txt 			= UI.getChildControl( Panel_SelfPlayerExpGage, "StaticText_ContributeP" )
local _contribute_Main 			= UI.getChildControl( Panel_SelfPlayerExpGage, "StaticText_Contribute_Main" )
local _contribute_helpMsg		= UI.getChildControl( Panel_SelfPlayerExpGage, "StaticText_ContributeHelpMsg" )

local _close_ExpGauge 			= UI.getChildControl( Panel_SelfPlayerExpGage, "Button_Win_Close" )

local _btn_NewSkill				= UI.getChildControl( Panel_SelfPlayerExpGage, "Button_NewSkill" )
local _txt_NewSkill				= UI.getChildControl( Panel_SelfPlayerExpGage, "StaticText_Number" )
local _txt_NewSkillDesc			= UI.getChildControl( Panel_SelfPlayerExpGage, "StaticText_NewSkillHelp" )
--{	버프 아이콘(좌측 상단)
	local _pcRoomIcon				= UI.getChildControl( Panel_SelfPlayerExpGage, "Static_PCRoom" )
	local _fixedChargeIcon			= UI.getChildControl( Panel_SelfPlayerExpGage, "Static_FixedCharge" )
	local _starterPackage			= UI.getChildControl( Panel_SelfPlayerExpGage, "Static_StarterPackageIcon")
	local _premiumPackage			= UI.getChildControl( Panel_SelfPlayerExpGage, "Static_PremiumPackageIcon")
	local _premiumAlert				= UI.getChildControl( Panel_SelfPlayerExpGage, "StaticText_BubbleAlert" )
	local _premiumText				= UI.getChildControl( Panel_SelfPlayerExpGage, "StaticText_NoticePremium" )
	local _btnCashShop				= UI.getChildControl( Panel_SelfPlayerExpGage, "Button_IngameCashShop" )
	local _btnAlertClose			= UI.getChildControl( Panel_SelfPlayerExpGage, "Button_TextClose" )
	local _NodeLvBuffIcon			= UI.getChildControl( Panel_SelfPlayerExpGage, "Static_NodeLvBuffIcon")
	local _pearlPackage				= UI.getChildControl( Panel_SelfPlayerExpGage, "Static_PearlPackageIcon")
	local _expEvent					= UI.getChildControl( Panel_SelfPlayerExpGage, "Static_ExpEvent")
	local _dropEvent				= UI.getChildControl( Panel_SelfPlayerExpGage, "Static_DropEvent")
	local _customize				= UI.getChildControl( Panel_SelfPlayerExpGage, "Static_CustomizeBuff")
	local _pearlPallete				= UI.getChildControl( Panel_SelfPlayerExpGage, "Static_PearlPallete")
	local _russiaKamasilv			= UI.getChildControl( Panel_SelfPlayerExpGage, "Static_RussiaKamasilv")	-- 러시아 전용 카마실브 버프.
--}

-- { 러시아만 PC방 아이콘을 정액 서버 아이콘으로 쓴다.
	-- if isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_RUS ) then
	-- 	_pcRoomIcon:ChangeTextureInfoName("New_UI_Common_ForLua/Window/Lobby/primium_Server.dds" )
	-- 	local x1, y1, x2, y2 = setTextureUV_Func( _pcRoomIcon, 0, 0, 35, 35 )
	-- 	_pcRoomIcon:getBaseTexture():setUV( x1, y1, x2, y2 )
	-- 	_pcRoomIcon:setRenderTexture(_pcRoomIcon:getBaseTexture())
	-- end
-- }


local _ExpFix					= UI.getChildControl( Panel_SelfPlayerExpGage, "CheckButton_ExpFix")

_btnCashShop:addInputEvent( "Mouse_LUp", "PearlShop_Open()" )
_btnAlertClose:addInputEvent( "Mouse_LUp", "PremiumNotice_Close()" )

local localNodeName				= nil
local localNodeInvestment		= false

if false == isGameTypeKorea() then	-- 한국서비스 아니면 레이아웃 늘려줌 ( 대부분 외국어 폰트가 더 길어서 )
	_levelBG:SetSize(100, _levelBG:GetSizeY())
	local expGagePosX = _levelBG:GetPosX()+_levelBG:GetSizeX()
	-- 밀어줄 게이지가 추가되면 gaugeBundle 배열에 콘트롤명 추가해줘야함.
	local gaugeBundle = {	_wpGaugeBG, _Wp, _Wp_Main, _wpGauge, _wpGauge_Head, _WpHelpMSG,
							_contribute_BG, _contribute_progress, _contribute_progress_Head, _contribute_txt, _contribute_Main, _contribute_helpMsg,
							_skillGaugeBG, _staticSkillExp, _staticSkillExp_Head, _staticSkillPoint, _staticSkillPointMain, _staticSkillPointSub,
						}
	for _, control in pairs( gaugeBundle ) do	-- 늘어난 만큼 우측 게이지들도 밀어줌
		control:SetPosX ( expGagePosX )
	end
end

local initPosX = Panel_SelfPlayerExpGage:GetPosX()
local initPosY = Panel_SelfPlayerExpGage:GetPosY()

_close_ExpGauge:SetShow( false )
_Wp:SetIgnore ( false )
_WpHelpMSG:SetAlpha(0)
_WpHelpMSG:SetFontAlpha(0)
_ExpFix:SetCheck( false )
_ExpFix:SetShow( false )	-- 임시로 닫아둡니다.

local _reservedLearningSkillSlot = 
{
	iconBG 			= UI.getChildControl( Panel_SelfPlayerExpGage, "Static_IconBG" ),
	icon 			= UI.getChildControl( Panel_SelfPlayerExpGage, "Static_SkillIcon" ),
	circularBorder 	= UI.getChildControl( Panel_SelfPlayerExpGage, "CircularProgress_Active" ),
	point			= UI.getChildControl( Panel_SelfPlayerExpGage, "Static_ProgressHead" ),
}

_btn_NewSkill:ActiveMouseEventEffect( true )

_reservedLearningSkillSlot.iconBG:SetShow(false)
_reservedLearningSkillSlot.icon:SetShow(false)
_reservedLearningSkillSlot.circularBorder:SetShow(false)
_reservedLearningSkillSlot.point:SetShow(false)


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function SelfPlayerExpGageShowAni()
	-- Panel_SelfPlayerExpGage:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_IN)
		
	-- local PlayerEXPOpen_Alpha = Panel_SelfPlayerExpGage:addColorAnimation( 0.0, 0.35, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	-- PlayerEXPOpen_Alpha:SetStartColor( UI_color.C_00FFFFFF )
	-- PlayerEXPOpen_Alpha:SetEndColor( UI_color.C_FFFFFFFF )
	-- PlayerEXPOpen_Alpha.IsChangeChild = true
	UIAni.AlphaAnimation( 1, Panel_SelfPlayerExpGage, 0.0, 0.2 )
end

function SelfPlayerExpGageHideAni()
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_SelfPlayerExpGage, 0.0, 0.2 )
	aniInfo:SetHideAtEnd(true)
end

-- 화면 사이즈에 따라 리사이징 해준다!
function Panel_SelfPlayerExpGage_onScreenResize()
	local sizeX = getScreenSizeX()
	expGageBG:SetSize (sizeX, 4)
	expGage:SetSize (sizeX, 4)
	-- _levelBG:SetSize (sizeX, _levelBG:GetSizeY())
	expGage:SetProgressRate( 0 )
	FGlobal_PackageIconUpdate()
	ExpGauge_CharacterInfoUpdate_Reload()
end

local _selfExpSimpleUI_MouseOver = false;
function SelfExp_MouseOver( isOver )
	if not getEnableSimpleUI() then
		return;
	end
	SelfExp_MouseOver_Force( isOver );
end
function SelfExp_MouseOver_Force( isOver )
	_selfExpSimpleUI_MouseOver = isOver;
end
function SelfExp_MouseOver_Force_Over()
	SelfExp_MouseOver_Force( false );
end
function SelfExp_MouseOver_Force_Out()
	_levelBG:SetShow(true);
	_levelBG:SetAlpha(1.0);
	
	_skillGaugeBG:SetShow(true);
	_skillGaugeBG:SetAlpha(1.0);
	_staticSkillExp:SetShow(true);
	_staticSkillExp:SetAlpha(1.0);
	_staticSkillExp_Head:SetShow(true);
	_staticSkillExp_Head:SetAlpha(1.0);
	_staticSkillPoint:SetShow(true);
	_staticSkillPoint:SetFontAlpha(1.0);
	_staticSkillPointMain:SetShow(true);
	_staticSkillPointMain:SetFontAlpha(1.0);
	_staticSkillPointSub:SetShow(true);
	_staticSkillPointSub:SetFontAlpha(1.0);
	
	_wpGaugeBG:SetShow(true);
	_wpGaugeBG:SetAlpha(1.0);
	_wpGauge:SetShow(true);
	_wpGauge:SetAlpha(1.0);
	_wpGauge_Head:SetShow(true);
	_wpGauge_Head:SetAlpha(1.0);
	_Wp:SetShow(true);
	_Wp:SetFontAlpha(1.0);
	_Wp_Main:SetShow(true);
	_Wp_Main:SetFontAlpha(1.0);
	
	_contribute_BG:SetShow(true);
	_contribute_BG:SetAlpha(1.0);
	_contribute_progress:SetShow(true);
	_contribute_progress:SetAlpha(1.0);
	_contribute_progress_Head:SetShow(true);
	_contribute_progress_Head:SetAlpha(1.0);
	_contribute_txt:SetShow(true);
	_contribute_txt:SetFontAlpha(1.0);
	_contribute_Main:SetShow(true);
	_contribute_Main:SetFontAlpha(1.0);
end

if getEnableSimpleUI() then
	SelfExp_MouseOver_Force(false);
end

_levelBG:addInputEvent( "Mouse_On", 	"SelfExp_MouseOver( true )" )
_levelBG:addInputEvent( "Mouse_Out", 	"SelfExp_MouseOver( false )" )
registerEvent( "EventSimpleUIEnable",			"SelfExp_MouseOver_Force_Over")
registerEvent( "EventSimpleUIDisable",			"SelfExp_MouseOver_Force_Out")

function SelfExp_SimpleUIUpdatePerFrame( deltaTime )
	local tmpRaderAlphaValue = 0.65;
	local tmpRaderLessAlphaValue = 0.85;
	local tmpRaderMoreAlphaValue = 0.55;
	if _selfExpSimpleUI_MouseOver then
		tmpRaderAlphaValue = 1.0;
		tmpRaderLessAlphaValue = 1.0;
		tmpRaderMoreAlphaValue = 1.0;
	end

	UIAni.perFrameAlphaAnimation(tmpRaderAlphaValue, 	 _levelBG,						2.8 * deltaTime);
	
	UIAni.perFrameAlphaAnimation(tmpRaderMoreAlphaValue, _skillGaugeBG,					3.8 * deltaTime);
	UIAni.perFrameAlphaAnimation(tmpRaderMoreAlphaValue, _staticSkillExp,				3.8 * deltaTime);
	UIAni.perFrameAlphaAnimation(tmpRaderMoreAlphaValue, _staticSkillExp_Head,			3.8 * deltaTime);
	UIAni.perFrameFontAlphaAnimation(tmpRaderLessAlphaValue, _staticSkillPoint,			3.8 * deltaTime);
	UIAni.perFrameFontAlphaAnimation(tmpRaderLessAlphaValue, _staticSkillPointMain,		3.8 * deltaTime);
	UIAni.perFrameFontAlphaAnimation(tmpRaderLessAlphaValue, _staticSkillPointSub,		3.8 * deltaTime);
	UIAni.perFrameAlphaAnimation(tmpRaderMoreAlphaValue, _wpGaugeBG,					3.8 * deltaTime);
	UIAni.perFrameAlphaAnimation(tmpRaderMoreAlphaValue, _wpGauge,						3.8 * deltaTime);
	UIAni.perFrameAlphaAnimation(tmpRaderMoreAlphaValue, _wpGauge_Head,					3.8 * deltaTime);
	UIAni.perFrameFontAlphaAnimation(tmpRaderLessAlphaValue, _Wp,						3.8 * deltaTime);
	UIAni.perFrameFontAlphaAnimation(tmpRaderLessAlphaValue, _Wp_Main,					3.8 * deltaTime);
	UIAni.perFrameAlphaAnimation(tmpRaderMoreAlphaValue, _contribute_BG,				3.8 * deltaTime);
	UIAni.perFrameAlphaAnimation(tmpRaderMoreAlphaValue, _contribute_progress,			3.8 * deltaTime);
	UIAni.perFrameAlphaAnimation(tmpRaderMoreAlphaValue, _contribute_progress_Head,		3.8 * deltaTime);
	UIAni.perFrameFontAlphaAnimation(tmpRaderLessAlphaValue, _contribute_txt,			3.8 * deltaTime);
	UIAni.perFrameFontAlphaAnimation(tmpRaderLessAlphaValue, _contribute_Main,			3.8 * deltaTime);
end

registerEvent( "SimpleUI_UpdatePerFrame",		"SelfExp_SimpleUIUpdatePerFrame")
	

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local registEventHandler = function()
	_reservedLearningSkillSlot.icon:addInputEvent( "Mouse_LUp", "ExpGauge_Skill_IconClick()" )
	_reservedLearningSkillSlot.icon:addInputEvent( "Mouse_On",  "ExpGauge_Skill_OverEvent(\"SkillBoxBottom\")" )
	_reservedLearningSkillSlot.icon:addInputEvent( "Mouse_Out", "ExpGauge_Skill_OverEventHide(\"SkillBoxBottom\")" )

	_btn_NewSkill:addInputEvent( "Mouse_LUp", "HandleMLUp_SkillWindow_OpenForLearn()" )
	_btn_NewSkill:addInputEvent( "Mouse_On", "BuffIcon_ShowSimpleToolTip( true, 0 )" )
	_btn_NewSkill:addInputEvent( "Mouse_Out", "BuffIcon_ShowSimpleToolTip( false )" )

	--기술 포인트 이벤트
	_staticSkillPoint		:addInputEvent( "Mouse_On",		"SelfPlayer_ExpTooltip(true, " .. 0 .. ")" )
	_staticSkillPoint		:addInputEvent( "Mouse_Out",	"SelfPlayer_ExpTooltip(false, " .. 0 .. ")" )
	_staticSkillPointMain	:addInputEvent( "Mouse_On",		"SelfPlayer_ExpTooltip(true, " .. 0 .. ")" )
	_staticSkillPointMain	:addInputEvent( "Mouse_Out",	"SelfPlayer_ExpTooltip(false, " .. 0 .. ")" )
	_staticSkillPointSub	:addInputEvent( "Mouse_On",		"SelfPlayer_ExpTooltip(true, " .. 0 .. ")" )
	_staticSkillPointSub	:addInputEvent( "Mouse_Out",	"SelfPlayer_ExpTooltip(false, " .. 0 .. ")" )
	_staticSkillPoint		:setTooltipEventRegistFunc( "SelfPlayer_ExpTooltip(true, " .. 0 .. ")" )
	_staticSkillPointMain	:setTooltipEventRegistFunc( "SelfPlayer_ExpTooltip(true, " .. 0 .. ")" )
	_staticSkillPointSub	:setTooltipEventRegistFunc( "SelfPlayer_ExpTooltip(true, " .. 0 .. ")" )

	-- 기운 이벤트
	_Wp					:addInputEvent( "Mouse_On",		"SelfPlayer_ExpTooltip(true, " .. 1 .. ")" )
	_Wp					:addInputEvent( "Mouse_Out",	"SelfPlayer_ExpTooltip(false, " .. 1 .. ")" )
	_Wp_Main			:addInputEvent( "Mouse_On",		"SelfPlayer_ExpTooltip(true, " .. 1 .. ")" )
	_Wp_Main			:addInputEvent( "Mouse_Out",	"SelfPlayer_ExpTooltip(false, " .. 1 .. ")" )
	_Wp					:setTooltipEventRegistFunc( "SelfPlayer_ExpTooltip(true, " .. 1 .. ")" )
	_Wp_Main			:setTooltipEventRegistFunc( "SelfPlayer_ExpTooltip(true, " .. 1 .. ")" )

	-- 공헌도 마우스 이벤트 ( 공헌도에 대한 설명을 적어넣는다! )
	_contribute_txt		:addInputEvent("Mouse_On",		"SelfPlayer_ExpTooltip( true, " .. 2 .. " )" )
	_contribute_txt		:addInputEvent("Mouse_Out",		"SelfPlayer_ExpTooltip( false, " .. 2 .. " )" )
	_contribute_Main	:addInputEvent("Mouse_On",		"SelfPlayer_ExpTooltip( true, " .. 2 .. " )" )
	_contribute_Main	:addInputEvent("Mouse_Out",		"SelfPlayer_ExpTooltip( false, " .. 2 .. " )" )
	_contribute_txt		:setTooltipEventRegistFunc( "SelfPlayer_ExpTooltip(true, " .. 2 .. ")" )
	_contribute_Main	:setTooltipEventRegistFunc( "SelfPlayer_ExpTooltip(true, " .. 2 .. ")" )

	-- 켜고 끄기 이벤트 함수~!
	_close_ExpGauge:addInputEvent( "Mouse_LUp", "SelfPlayerExpGauge_ShowToggle()" )
	Panel_SelfPlayerExpGage:addInputEvent( "Mouse_On", "ExpGauge_ChangeTexture_On()" )
	Panel_SelfPlayerExpGage:addInputEvent( "Mouse_Out", "ExpGauge_ChangeTexture_Off()" )
	Panel_SelfPlayerExpGage:addInputEvent( "Mouse_LUp", "ResetPos_WidgetButton()" )			--메인UI위젯 위치 초기화
	-- 버프 툴팁
	_pcRoomIcon			:addInputEvent( "Mouse_On",		"BuffIcon_ShowSimpleToolTip( true, 1 )" )
	_pcRoomIcon			:addInputEvent( "Mouse_Out",	"BuffIcon_ShowSimpleToolTip( false )" )
	_fixedChargeIcon	:addInputEvent( "Mouse_On",		"BuffIcon_ShowSimpleToolTip( true, 11 )" )
	_fixedChargeIcon	:addInputEvent( "Mouse_Out",	"BuffIcon_ShowSimpleToolTip( false )" )
	_starterPackage		:addInputEvent( "Mouse_On",		"BuffIcon_ShowSimpleToolTip( true, 2)" )
	_starterPackage		:addInputEvent( "Mouse_Out",	"BuffIcon_ShowSimpleToolTip( false )" )
	_premiumPackage		:addInputEvent( "Mouse_On",		"BuffIcon_ShowSimpleToolTip( true, 3)" )
	_premiumPackage		:addInputEvent( "Mouse_Out",	"BuffIcon_ShowSimpleToolTip( false )" )
	
	_NodeLvBuffIcon		:addInputEvent( "Mouse_On",		"BuffIcon_ShowSimpleToolTip( true, 5)" )
	_NodeLvBuffIcon		:addInputEvent( "Mouse_Out",	"BuffIcon_ShowSimpleToolTip( false )" )
	
	_pearlPackage		:addInputEvent( "Mouse_On",		"BuffIcon_ShowSimpleToolTip( true, 4)" )
	_pearlPackage		:addInputEvent( "Mouse_Out",	"BuffIcon_ShowSimpleToolTip( false )" )

	_expEvent			:addInputEvent( "Mouse_On",		"BuffIcon_ShowSimpleToolTip( true, 6 )")
	_expEvent			:addInputEvent( "Mouse_Out",	"BuffIcon_ShowSimpleToolTip( false )")
	_dropEvent			:addInputEvent( "Mouse_On",		"BuffIcon_ShowSimpleToolTip( true, 7 )")
	_dropEvent			:addInputEvent( "Mouse_Out",	"BuffIcon_ShowSimpleToolTip( false )")
	_customize			:addInputEvent( "Mouse_On",		"BuffIcon_ShowSimpleToolTip( true, 8 )")
	_customize			:addInputEvent( "Mouse_Out",	"BuffIcon_ShowSimpleToolTip( false )")

	_pearlPallete		:addInputEvent( "Mouse_On",		"BuffIcon_ShowSimpleToolTip( true, 9 )")
	_pearlPallete		:addInputEvent( "Mouse_Out",	"BuffIcon_ShowSimpleToolTip( false )")

	_russiaKamasilv		:addInputEvent( "Mouse_On",		"BuffIcon_ShowSimpleToolTip( true, 10 )")
	_russiaKamasilv		:addInputEvent( "Mouse_Out",	"BuffIcon_ShowSimpleToolTip( false, 10 )")

	_pcRoomIcon			:setTooltipEventRegistFunc("BuffIcon_ShowSimpleToolTip( true, 1 )")
	_starterPackage		:setTooltipEventRegistFunc("BuffIcon_ShowSimpleToolTip( true, 2 )")
	_premiumPackage		:setTooltipEventRegistFunc("BuffIcon_ShowSimpleToolTip( true, 3 )")
	_pearlPackage		:setTooltipEventRegistFunc("BuffIcon_ShowSimpleToolTip( true, 4 )")
	_NodeLvBuffIcon		:setTooltipEventRegistFunc("BuffIcon_ShowSimpleToolTip( true, 5 )")
	_expEvent			:setTooltipEventRegistFunc("BuffIcon_ShowSimpleToolTip( true, 6 )")
	_dropEvent			:setTooltipEventRegistFunc("BuffIcon_ShowSimpleToolTip( true, 7 )")
	_customize			:setTooltipEventRegistFunc("BuffIcon_ShowSimpleToolTip( true, 8 )")
	_pearlPallete		:setTooltipEventRegistFunc("BuffIcon_ShowSimpleToolTip( true, 9 )")
	_russiaKamasilv		:setTooltipEventRegistFunc("BuffIcon_ShowSimpleToolTip( true, 10 )")
	_fixedChargeIcon	:setTooltipEventRegistFunc("BuffIcon_ShowSimpleToolTip( true, 11 )")

	-- _ExpFix				:addInputEvent( "Mouse_LUp",	"CharacterExpFix()")
	-- _ExpFix				:addInputEvent( "Mouse_On",		"BuffIcon_ShowSimpleToolTip( true, 90 )")
	-- _ExpFix				:addInputEvent( "Mouse_Out",	"BuffIcon_ShowSimpleToolTip( false )")
	-- _ExpFix				:setTooltipEventRegistFunc("BuffIcon_ShowSimpleToolTip( true, 90 )")
end
local registMessageHandler = function()
	registerEvent( "onScreenResize", 				"Panel_SelfPlayerExpGage_onScreenResize")
	registerEvent( "EventCharacterInfoUpdate", 		"ExpGauge_CharacterInfoUpdate_Reload")
	
	--registerEvent( "EventCharacterInfoUpdate", 		"Panel_SelfPlayer_EnableSkillCheck_Func")	-- 스킬 포인트가 오를 때,
	registerEvent( "FromClient_SelfPlayerCombatSkillPointChanged", 		"UserSkillPoint_Update") -- 스킬 포인트 혹은 경험치 변경 시 포인트 수치 및 경험치 게이지 표시
	registerEvent( "FromClient_SelfPlayerCombatSkillPointChanged", 		"Panel_SelfPlayer_EnableSkillCheck_Func")	-- 스킬 포인트가 오를 때, 배울 수 있는 스킬 아이콘 표시
	registerEvent( "FromClient_EnableSkillCheck", 	"Panel_SelfPlayer_EnableSkillCheck_Func")	-- 처음 실행될 때
	
	registerEvent("FromClient_SelfPlayerExpChanged", "Panel_SelfPlayerExpGage_CharacterInfoWindowUpdate")
	registerEvent("EventSelfPlayerLevelUp", "UserLevel_Update")
	registerEvent("FromClient_WpChanged", "wpPoint_UpdateFunc")
	registerEvent("FromClient_UpdateExplorePoint", "contributePoint_UpdateFunc")
	registerEvent("FromClient_UpdateCharge", "FromClient_PackageIconUpdate")		-- 주기적으로 온다.
	registerEvent("FromClient_LoadCompleteMsg", "FromClient_PackageIconUpdate")		-- 로딩이 발생했을 경우 한번 호출해 주자
	registerEvent("FromClient_ResponseChangeExpAndDropPercent", "FromClient_ResponseChangeExpAndDropPercent") 
	-- 차후 새로운 스킬이 있을 경우만 체크해야함
	-- Panel_SelfPlayerExpGage:RegisterUpdateFunc("Panel_SelfPlayer_EnableSkillCheck_Func")
	-- registerEvent("EventCharacterInfoUpdate", "Panel_User_ProductSkillPoint_Update")
end

local _lastSkillPoint = -1
local _lastWP = -1
local _lastEXP = -1
local _lastSkillExp = 0
local saved_maxWp = 0
local expHead_EffectKey = 0
local prevLevel = 0

function Panel_SelfPlayerExpGage_CharacterInfoWindowUpdate()
	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		return
	end
	local player = selfPlayer:get()
	local s64_needExp = player:getNeedExp_s64()
	local s64_exp = player:getExp_s64()

	-- int64 의 나누기 연산은 정수 나누기 이기 때문에, 이렇게 작업했다.
	local _const = Defines.s64_const
	local rate = 0
	local rateDisplay = 0
	
	if _const.s64_10000 < s64_needExp then
		rate = Int64toInt32((s64_exp*Defines.s64_const.s64_1000*Defines.s64_const.s64_100) / s64_needExp)
	elseif _const.s64_0 ~= s64_needExp then
		rate = Int64toInt32((s64_exp*Defines.s64_const.s64_1000*Defines.s64_const.s64_100) / s64_needExp)
	end
	
	if _lastEXP < Int64toInt32( s64_exp) and -1 ~= _lastEXP then
		if ( 0 ~= expHead_EffectKey ) then
			_expHead:EraseEffect(expHead_EffectKey)
		end
		expHead_EffectKey = _expHead:AddEffect("fUI_Gauge_Experience", false, 0.0, 0.0)
	end
	
	local real_rate = rate / 1000
	if 100 == real_rate then
		rateDisplay = "100.000%"
	elseif 0 == real_rate then
		rateDisplay = "0.000%"
	else
		if real_rate == (real_rate - real_rate%1) then
			rateDisplay = real_rate .. ".000%"
		elseif real_rate == (real_rate - real_rate%0.1) then
			rateDisplay = real_rate .. "00%"
		elseif real_rate == (real_rate - real_rate%0.01) then
			rateDisplay = real_rate .. "0%"
		else
			rateDisplay = real_rate .. ("%")
		end
	end
	
	
	-- if 10 > rate then
		-- rateDisplay = ("00.00").. rate ..("%")
	-- elseif 100 > rate then
		-- rateDisplay = ("00.0").. rate ..("%")
	-- elseif 1000 > rate then
		-- rateDisplay = ("00.").. rate ..("%")
	-- elseif 10000 > rate then
		-- rateDisplay = ("0").. rate/1000 .. (".").. rate-rate%1000 ..("%")
	-- else
		-- rateDisplay = rate
	-- end
	
	--local refreshExp = false
	--if prevLevel ~= player:getLevel()  then
	--	prevLevel = player:getLevel()
	--	refreshExp = true
	--end
	
	--if _lastEXP < Int64toInt32( s64_exp ) or refreshExp then
		expGage:SetProgressRate( real_rate )
		_lastEXP = Int64toInt32( s64_exp )
	--end

	_staticLevelSub:ComputePos()
	_staticLevelSub:SetText( string.format( "%.3f", real_rate ) .."%" )

	local MaxLevQuestInfo = questList_isClearQuest( 151, 1 )

	if (49 == player:getLevel() ) and (99 <= rate) and not MaxLevQuestInfo then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_50UP") ) -- "'[협동] 쇠약해진 벨모른 처치' 의뢰를 완료해야 레벨업 할 수 있습니다.")
	end
	
	-- if 10 > player:getLevel() then
		-- _staticLevelSub:SetPosX(_staticLevel:GetPosX() + _staticLevel:GetTextSizeX() + 3)
	-- else
		-- _staticLevelSub:SetPosX(_staticLevel:GetPosX() + _staticLevel:GetTextSizeX() - 5)
	-- end
	
	_staticLevelSub:SetFontColor( 4294899677 )
	_staticLevelSub:useGlowFont( true, "BaseFont_Glow", 4289951243 )	-- GLOW:의뢰제목
	_staticLvText:SetFontColor( 4294899677 )
	_staticLvText:useGlowFont( true, "BaseFont_8_Glow", 4289951243 )	-- GLOW:의뢰제목
	
end

----------------------------------------------------------------------------------------------------------
-- 												스킬 포인트
----------------------------------------------------------------------------------------------------------
function UserSkillPoint_Update()
	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		return
	end
	
	local player = selfPlayer:get()
	local skillExpRate, skillPointNeedExp
	skillPointNeedExp = player:getSkillPointNeedExperience()
	if 0 ~= skillPointNeedExp then
		skillExpRate = player:getSkillPointExperience() / skillPointNeedExp
	else
		skillExpRate = 0
	end
	if _lastSkillPoint < player:getRemainSkillPoint() and -1 ~= _lastSkillPoint then
		-- ♬ 스킬 포인트가 올랐을 때 사운드 추가
		audioPostEvent_SystemUi(03,07)
		
		_staticSkillPointMain:EraseAllEffect()
		_staticSkillPointMain:AddEffect("UI_LevelUP_Skill", false, -28, 1.0)
		_staticSkillPointMain:AddEffect("fUI_LevelUP_Skill02", false, -28, 1.0)
		-- UIMain_SkillPointUpdate(player:getRemainSkillPoint() - _lastSkillPoint)
	end
	-- _staticSkillPoint:SetText( PAGetString( Defines.StringSheet_GAME,  "LUA_EXPGAUGE_SKILLPOINT") )
	_staticSkillPointMain:SetPosX ( _staticSkillPoint:GetSizeX() + _staticSkillPoint:GetPosX() + 5 )
	_staticSkillPointMain:SetText ( tostring( player:getRemainSkillPoint() ) )

	if CppEnums.CountryType.DEV == getGameServiceType() then
		local skillPointInfo = getSkillPointInfo( 0 )--생산스킬포인트(2번이니까)
		local skillPointLev	= tostring( skillPointInfo._pointLevel )
		_staticSkillPointMain:SetText ( "(" .. skillPointLev .. ")" .. tostring( player:getRemainSkillPoint() ) )
	end

	_staticSkillPointMain:SetSize ( _staticSkillPointMain:GetTextSizeX() + 5, _staticSkillPointMain:GetSizeY() )
	_staticSkillPointSub:SetPosX ( _staticSkillPointMain:GetSizeX() + _staticSkillPointMain:GetPosX() - 5 )
	_staticSkillExp:SetProgressRate( skillExpRate * 100 )	
	
	if ( _lastSkillExp ~= skillExpRate ) then
		_staticSkillExp:EraseAllEffect()
		_staticSkillExp_Head:EraseAllEffect()
		_staticSkillExp:AddEffect("UI_Gauge_Experience02", false, 0.0, 0.0)
		_staticSkillExp_Head:AddEffect("fUI_Repair01", false, 0.0, 0.0)
	end
	
	local _tempSkillPoint = skillExpRate * 100
	if 10 > _tempSkillPoint then
		_staticSkillPointSub:SetText(".0".. string.format("%.0f", _tempSkillPoint))
	else
		_staticSkillPointSub:SetText("." .. string.format("%.0f", _tempSkillPoint))
	end
	_lastSkillPoint = player:getRemainSkillPoint()
	_lastSkillExp = skillExpRate		-- 마지막 스킬포인트 경험치 저장
	
	if ( selfPlayer:get():getReservedLearningSkillKey():isDefined() ) then
		
		-- 안 보여지고 있었다면, 보여주게한다.
		if( false == _reservedLearningSkillSlot.iconBG:GetShow() ) then
			ExpGauge_SetReservedLearningSkill()
		end	
		-- 배우기 예약 스킬 원형 프로그래스 업데이트
		ExpGauge_UpdateReservedSkillCircularProgress()
	
	end
	
	_staticSkillPointMain:SetFontColor( 4294899677 )
	_staticSkillPointMain:useGlowFont( true, "BaseFont_Glow", 4289951243 )	-- GLOW:의뢰제목
	_staticSkillPointSub:SetFontColor( 4294899677 )
	_staticSkillPointSub:useGlowFont( true, "BaseFont_10_Glow", 4289951243 )	-- GLOW:의뢰제목
	enableSkill_UpdateData()
	
end


----------------------------------------------------------------------------------------------------------
--?
----------------------------------------------------------------------------------------------------------
local tooltipExpPanel = UI.createPanel( "tooltipExp", Defines.UIGroup.PAGameUIGroup_Windows )
tooltipExpPanel:SetShow( false, false )
local tooltipExpPanel_Static = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, tooltipExpPanel, "tooltipExpStatic" )

tooltipExpPanel_Static:SetPosX( 10 )
tooltipExpPanel_Static:SetPosY( 10 )
tooltipExpPanel_Static:SetSize( 290, 90 )
tooltipExpPanel_Static:SetShow( true )

function Panel_SelfPlayerExpGage_OnMouse()
	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		return
	end
	local player = selfPlayer:get()
	
	tooltipExpPanel:SetSize( 300, 100 )
	tooltipExpPanel:SetPosX( getMousePosX() )
	positionY = getMousePosY()
	positionY = positionY - 100
	
	tooltipExpPanel:SetPosY( positionY )
	tooltipExpPanel:SetShow( true, false )
	tooltipExpPanel_Static:SetText( PAGetString( Defines.StringSheet_GAME,  "MAINSTATUS_EXP" )..tostring(player:getExp_s64()).."/"..tostring(player:getNeedExp_s64()) )
end

function Panel_SelfPlayerExpGage_OutMouse()
	tooltipExpPanel:SetShow( false, false )
end

local _lastLevel = 0
function UserLevel_Update()
	local player = getSelfPlayer()
	if nil == player then
		return
	end
	staticLevelBg:SetShow( true )
	staticLevelBg:SetAlpha( 0.6 )
	_staticLevel:SetText( tostring(player:get():getLevel()) )
	_staticLevel:SetFontColor( 4294899677 )
	_staticLevel:useGlowFont( true, "BaseFont_26_Glow", 4289951243 )	-- GLOW:의뢰제목
	if _lastLevel < player:get():getLevel() and 0 ~= _lastLevel then
		-- ♬ 레벨업 할 때 사운드 추가
		_staticLevel:EraseAllEffect()
		_staticLevel:AddEffect("fUI_NewSkill01", false, 0.0, 0.0)
		_staticLevel:AddEffect("UI_NewSkill01", false, 0.0, 0.0)
		_staticLevel:AddEffect("UI_LevelUP_Main", false, -33.0, -43.0)
		_staticLevel:AddEffect("fUI_Gauge_LevelUp01", false, 80.0, -40.0)
	end
	_lastLevel = player:get():getLevel()
	
	--테스트용[who1310]	
	--_staticLifeExperienceLevel:SetText( tostring( player:get():getLifeExperienceLevel(0) ) )
	--_staticLifeExperienceCurrPoint:SetText( tostring( player:get():getCurrLifeExperiencePoint(0) ) )
	--_staticLifeExperienceMaxPoint:SetText( tostring( player:get():getDemandLifeExperiencePoint(0) ) )
	-- 0 채집 1 낚시 2 가공 3 요리 4 연금
end


----------------------------------------------------------------------------------------------------------
--												기운
----------------------------------------------------------------------------------------------------------
function wpPoint_UpdateFunc()
	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		return
	end	
	local Wp = selfPlayer:getWp()
	local maxWp = selfPlayer:getMaxWp()
	
	-- 저장해줬던 wp와 새로오는 wp가 다를경우 표시해준다!
	-- if ( Wp ~= _lastWP ) then
		local wpSetProgress = ( Wp / maxWp ) * 100
		
		if _lastWP < Wp and -1 ~= _lastWP then
			-- ♬ 기운 포인트가 올랐을 때 사운드 추가
			audioPostEvent_SystemUi(03,13)
			_Wp_Main:EraseAllEffect()

			_Wp_Main:AddEffect("UI_LevelUP_Skill", false, -43.0, 1.0)
			_Wp_Main:AddEffect("fUI_LevelUP_Skill02", false, -43.0, 1.0)

			_wpGauge:EraseAllEffect()
			_wpGauge_Head:EraseAllEffect()
			_wpGauge:AddEffect("UI_Gauge_Experience02", false, 0.0, 0.0)
			_wpGauge_Head:AddEffect("fUI_Repair01", false, 0.0, 0.0)
		end
		
		-- _Wp:SetText( PAGetString( Defines.StringSheet_GAME,  "MAINSTATUS_WP") )
		-- _Wp:SetSize ( _Wp:GetTextSizeX(), _Wp:GetSizeY() )
		_Wp_Main:SetPosX( _Wp:GetSizeX() + _Wp:GetPosX() + 5 )
		_Wp_Main:SetText( tostring(Wp).." / "..maxWp )
		_wpGauge:SetProgressRate( wpSetProgress )
		_Wp_Main:SetSize( _Wp_Main:GetTextSizeX() + 10, _Wp_Main:GetSizeY() )
		_Wp_Main:SetEnableArea( 0, 0, _Wp_Main:GetTextSizeX(), _Wp_Main:GetSizeY() )
		_Wp_Main:SetFontColor( 4294899677 )
		_Wp_Main:useGlowFont( true, "BaseFont_Glow", 4289951243 )	-- GLOW:의뢰제목

		_lastWP = Wp
	-- end
end

----------------------------------------------------------------------------------------------------------
-- 												공헌도
----------------------------------------------------------------------------------------------------------
local lastContRate = 0
local lastRemainExplorePoint = 0
local lastExplorePoint = 0
local isFirstExplore = false
Panel_Expgauge_MyContributeValue = 0

function contributePoint_UpdateFunc()
	local territoryKeyRaw 			= getDefaultTerritoryKey()
	local explorePoint				= getExplorePointByTerritoryRaw( territoryKeyRaw )
	if (nil == explorePoint) then
		_contribute_Main:SetText("")
		_contribute_progress:SetProgressRate(0)
		return
	end
	
	local s64_exploreRequireExp	= getRequireExperienceToExplorePointByTerritory_s64( territoryKeyRaw )
	local cont_expRate 			= Int64toInt32(explorePoint:getExperience_s64()) / Int64toInt32(getRequireExplorationExperience_s64()) 				-- 현재 공헌도 % 계산

	local nowRemainExpPoint 	= tostring(explorePoint:getRemainedPoint())
	local nowExpPoint				= tostring(explorePoint:getAquiredPoint())
		
	-- _contribute_txt:SetText( PAGetString( Defines.StringSheet_GAME,  "MAINSTATUS_CONTRIBUTE" ) )
	-- _contribute_txt:SetSize ( _contribute_txt:GetTextSizeX(), _contribute_txt:GetSizeY() )
	_contribute_Main:SetPosX ( _contribute_txt:GetSizeX() + _contribute_txt:GetPosX() + 5 )
	_contribute_Main:SetText ( tostring(explorePoint:getRemainedPoint()) .." / " .. tostring(explorePoint:getAquiredPoint()) )
	
	-- 개발 버전에만 공헌도 경험치를 표시해준다(재희 요청)
	if isGameServiceTypeDev() then
		_contribute_Main:SetText ( tostring(explorePoint:getRemainedPoint()) .." / " .. tostring(explorePoint:getAquiredPoint()) .. "      (".. Int64toInt32(explorePoint:getExperience_s64()) .. " / " ..  Int64toInt32(getRequireExplorationExperience_s64()) .. ")" )
	end
	
	_contribute_progress:SetProgressRate( cont_expRate * 100 )
	_contribute_Main:SetSize( _contribute_Main:GetTextSizeX() + 10, _contribute_Main:GetSizeY() )
	_contribute_Main:SetEnableArea( 0, 0, _contribute_Main:GetTextSizeX(), _contribute_Main:GetSizeY() )
	
	Panel_Expgauge_MyContributeValue = tostring(explorePoint:getRemainedPoint())	-- 현재 나의 공헌도를 저장한다.( Panel_Interaction, 집 구매버튼에서 사용 )

	-- 최초 값 세팅
	if ( isFirstExplore == false ) then
		lastRemainExplorePoint = 0
		lastExplorePoint = 0
		nowRemainExpPoint = 0
		nowExpPoint = 0
		isFirstExplore = true
	end
		
		-- 게이바에 이펙트!
	if ( lastContRate ~= cont_expRate ) then
		_contribute_progress:SetNotAbleMasking(true)
		_contribute_progress_Head:SetNotAbleMasking(true)
		_contribute_progress:EraseAllEffect()
		_contribute_progress_Head:EraseAllEffect()
		_contribute_progress:AddEffect("UI_Gauge_Experience02", false, 0.0, 0.0)
		_contribute_progress_Head:AddEffect("fUI_Repair01", false, 0.0, 0.0)
	end
		
	-- 현재 남은 공헌도에 이펙트!
	if ( lastRemainExplorePoint ~= nowRemainExpPoint ) and ( isFirstExplore == true ) then
		-- ♬ 공헌도 포인트에 변경점이 생겼을 때 사운드 추가
		audioPostEvent_SystemUi(03,07)
		
		_contribute_Main:EraseAllEffect()
		_contribute_Main:AddEffect("UI_LevelUP_Skill", false, 0, 1.0)
	end
		
	-- 현재 남은 공헌도에 이펙트!
	if ( lastExplorePoint ~= nowExpPoint ) and ( isFirstExplore == true ) then
		-- ♬ 공헌도 포인트에 변경점이 생겼을 때 사운드 추가
		audioPostEvent_SystemUi(03,07)
		
		_contribute_Main:EraseAllEffect()
		_contribute_Main:AddEffect("UI_LevelUP_Skill", false, -38, 1.0)
	end
	
	_contribute_Main:SetFontColor( 4294899677 )
	_contribute_Main:useGlowFont( true, "BaseFont_Glow", 4289951243 )	-- GLOW:의뢰제목

		
	lastContRate = cont_expRate
	lastRemainExplorePoint = tostring(explorePoint:getRemainedPoint())
	lastExplorePoint = tostring(explorePoint:getAquiredPoint())
end

local _contributeUsePoint =
{
	[0] = PAGetString( Defines.StringSheet_GAME, "LUA_EXPGUAGE_CONTRIBUTE_VALUE_1" ),	--"집 구입",
	[1] = PAGetString( Defines.StringSheet_GAME, "LUA_EXPGUAGE_CONTRIBUTE_VALUE_2" ),	--"거점 투자",
	[2] = PAGetString( Defines.StringSheet_GAME, "LUA_EXPGUAGE_CONTRIBUTE_VALUE_3" )	--"아이템 대여"
}


function ExpGauge_ChangeTexture_On()
	_close_ExpGauge:SetShow(true)
	Panel_SelfPlayerExpGage:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_drag.dds")
	expText:SetText( PAGetString( Defines.StringSheet_GAME,  "MAINSTATUS_DRAG_SKILLEXP") )
end
function ExpGauge_ChangeTexture_Off()
	_close_ExpGauge:SetShow(false)
	Panel_SelfPlayerExpGage:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_isWidget.dds")
	expText:SetText( PAGetString( Defines.StringSheet_GAME,  "MAINSTATUS_SKILLEXP") )
end

function SelfPlayerExpGauge_ShowToggle()
	local isShow = Panel_SelfPlayerExpGage:IsShow()
	
	if isShow == true then
		
		ExpGague_ClearReservedLearningSkill()
		Panel_SelfPlayerExpGage:SetShow ( false, false )
		
	else
		Panel_SelfPlayerExpGage:SetPosX(initPosX)
		Panel_SelfPlayerExpGage:SetPosY(initPosY)
		Panel_SelfPlayerExpGage:SetShow ( true, true )
		ExpGauge_SetReservedLearningSkill()
	end
	
	-- widgetControlButtonFunction(1)
end


-- 생산 스킬 포인트
local _staticSkillExp_p = UI.getChildControl( Panel_SelfPlayerExpGage, "CircularProgress_SkillExp_p" )
local _staticSkillPoint_p = UI.getChildControl( Panel_SelfPlayerExpGage, "StaticText_SkillPoint_p" )
function Panel_User_ProductSkillPoint_Update()	
	local skillPointInfo = getSkillPointInfo( 2 )--생산스킬포인트(2번이니까)
	_staticSkillPoint_p:SetText( tostring(skillPointInfo._remainPoint ) )
	local skillExpRate_p = skillPointInfo._currentExp / skillPointInfo._nextLevelExp
	_staticSkillExp_p:SetProgressRate( skillExpRate_p * 100 )	
end

-- 배우기 예약 스킬 관련
function ExpGauge_Skill_IconClick()
	skillWindow_ClearReservedLearningSkill()
end


------------------------------------------------------------
--			스킬 아이콘에 마우스 올렸을 때 이벤트
------------------------------------------------------------
function ExpGauge_Skill_OverEvent( SlotType )
	local skillNo = 0
	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		return
	end
	if ( selfPlayer:get():getReservedLearningSkillKey():isDefined() ) then
		skillNo = selfPlayer:get():getReservedLearningSkillKey():getSkillNo()
	else
		return
	end
	
	Panel_SkillTooltip_SetPosition( skillNo, _reservedLearningSkillSlot.icon, "SkillBoxBottom" )
	Panel_SkillTooltip_Show(skillNo,false, SlotType, true)
end

function	ExpGauge_Skill_OverEventHide(SlotType)
	Panel_SkillTooltip_Hide()
end

function ExpGague_ClearReservedLearningSkill( )
	
	_reservedLearningSkillSlot.icon:ReleaseTexture()
	_reservedLearningSkillSlot.icon:ChangeTextureInfoName("")
	_reservedLearningSkillSlot.icon:SetAlpha(0)

	_reservedLearningSkillSlot.iconBG:SetShow(false)
	_reservedLearningSkillSlot.icon:SetShow(false)
	_reservedLearningSkillSlot.circularBorder:SetShow(false)
	_reservedLearningSkillSlot.point:SetShow(false)
	
	Panel_SkillTooltip_Hide()
end

function ExpGauge_SetReservedLearningSkill( )
	
	local skillNo = 0 
	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		return
	end
	if ( selfPlayer:get():getReservedLearningSkillKey():isDefined() ) then
		skillNo = selfPlayer:get():getReservedLearningSkillKey():getSkillNo()
	else
		return
	end
	
	local skillTypeStaticWrapper = getSkillTypeStaticStatus( skillNo )
	local skillTypeStatic = skillTypeStaticWrapper:get()
	
	-- 아이콘
	_reservedLearningSkillSlot.icon:ChangeTextureInfoName( "Icon/" .. skillTypeStaticWrapper:getIconPath() )
	_reservedLearningSkillSlot.icon:SetAlpha(1)

	-- 원형 프로그래스
	_reservedLearningSkillNo = skillNo
	ExpGauge_UpdateReservedSkillCircularProgress()
	
	-- 포인트 위치 설정
	
	-- 보여주기
	_reservedLearningSkillSlot.iconBG:SetShow(true)
	_reservedLearningSkillSlot.icon:SetShow(true)
	_reservedLearningSkillSlot.circularBorder:SetShow(true)
	_reservedLearningSkillSlot.point:SetShow(false)

end

function ExpGauge_UpdateReservedSkillCircularProgress()
	
	local skillNo = 0 
	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		return
	end
	if ( selfPlayer:get():getReservedLearningSkillKey():isDefined() ) then
		skillNo = selfPlayer:get():getReservedLearningSkillKey():getSkillNo()
	else
		return
	end
	
	local skillStaticWrapper = getSkillStaticStatus( skillNo, 1 ) -- 현재 스킬들의 레벨은 무조건 1이다.
	local needPoint = skillStaticWrapper:get()._needSkillPointForLearning
	
	if( 0 == needPoint ) then
		UI.ASSERT( false	,"제수가 0 이면 안된다.")
		return
	end
			
	local curSkillPoint = _lastSkillPoint + _lastSkillExp
	local progressRate = curSkillPoint / needPoint
	
	_reservedLearningSkillSlot.circularBorder:SetProgressRate( progressRate * 100)	
	
end

function ExpGauge_CharacterInfoUpdate_Reload()
	Panel_SelfPlayerExpGage_CharacterInfoWindowUpdate()
	UserSkillPoint_Update()
	UserLevel_Update()
	wpPoint_UpdateFunc()
	contributePoint_UpdateFunc()
end


----------------------------------------------------------------------------------------------------------
-- 									배울 수 있는 스킬이 있다!
----------------------------------------------------------------------------------------------------------
local isChecked_EnableSkill = false
function Panel_SelfPlayer_EnableSkillCheck_Func()
	local isLearnable = PaGlobal_Skill:SkillWindow_PlayerLearnableSkill()
	local skillCount = FGlobal_EnableSkillReturn()

	if ( isLearnable ) then
		-- ♬ 배울 수 있는 스킬이 있네? 사운드!
		-- audioPostEvent_SystemUi(03,13)

		-- 배울 수 있는 스킬이 있다.
		-- FGlobal_MessageHistory_InputMSG( 0, "배울 수 있는 스킬이 있습니다.", HandleMLUp_SkillWindow_OpenForLearn )
		
		-- _btn_NewSkill:AddEffect("UI_ButtonLineRight_Blue", true, 0, 0)
		_btn_NewSkill:SetShow( true )
		-- _btn_NewSkill:SetEnableArea ( -_btn_NewSkill:GetTextSizeX()-10, 0, _btn_NewSkill:GetSizeX(), _btn_NewSkill:GetSizeY() )
		_txt_NewSkill:SetShow( true )
		_txt_NewSkill:SetText( skillCount )
		_txt_NewSkill:SetPosX ( ( _btn_NewSkill:GetPosX() + _btn_NewSkill:GetSizeX() - _txt_NewSkill:GetSizeX() ) + 2 )
		_txt_NewSkill:SetPosY ( ( _btn_NewSkill:GetPosY() + _btn_NewSkill:GetSizeY() - _txt_NewSkill:GetSizeY() ) + 2 )
	else
		_btn_NewSkill:SetShow( false )
		_txt_NewSkill:SetShow( false )
	end
	FromClient_PackageIconUpdate()
	FromClient_ResponseChangeExpAndDropPercent()
end

function FGlobal_PackageIconUpdate()
	FromClient_PackageIconUpdate()
	FromClient_ResponseChangeExpAndDropPercent()
end

local valuePackCheck = false				-- 밸류 패키지 사라짐 체크용
function FromClient_PackageIconUpdate()
	local temporaryPCRoomWrapper	= getTemporaryInformationWrapper()
	local isPremiumPcRoom			= temporaryPCRoomWrapper:isPremiumPcRoom()

	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		return
	end

	local starter				= selfPlayer:get():getUserChargeTime( UI_BUFFTYPE.eUserChargeType_StarterPackage )
	local premium				= selfPlayer:get():getUserChargeTime( UI_BUFFTYPE.eUserChargeType_PremiumPackage )
	local pearl					= selfPlayer:get():getUserChargeTime( UI_BUFFTYPE.eUserChargeType_PearlPackage )
	local customize				= selfPlayer:get():getUserChargeTime( UI_BUFFTYPE.eUserChargeType_CustomizationPackage )
	local dyeingPackage			= selfPlayer:get():getUserChargeTime( UI_BUFFTYPE.eUserChargeType_DyeingPackage )
	local russiaKamasilv		= selfPlayer:get():getUserChargeTime( UI_BUFFTYPE.eUserChargeType_Kamasilve )				-- 러시아 전용 카마실브 버프

	local applyStarter			= selfPlayer:get():isApplyChargeSkill( UI_BUFFTYPE.eUserChargeType_StarterPackage )
	local applyPremium			= selfPlayer:get():isApplyChargeSkill( UI_BUFFTYPE.eUserChargeType_PremiumPackage )
	local applyPearl			= selfPlayer:get():isApplyChargeSkill( UI_BUFFTYPE.eUserChargeType_PearlPackage )
	local applyCustomize		= selfPlayer:get():isApplyChargeSkill( UI_BUFFTYPE.eUserChargeType_CustomizationPackage )
	local applyDyeingPackage	= selfPlayer:get():isApplyChargeSkill( UI_BUFFTYPE.eUserChargeType_DyeingPackage )
	local applyRussiaKamasilv	= selfPlayer:get():isApplyChargeSkill( UI_BUFFTYPE.eUserChargeType_Kamasilve )				-- 러시아 전용 카마실브 버프
	-- local starter			= player:getStarterPackageTime()
	-- local premium			= player:getPremiumPackageTime()
	-- local pearl				= player:getPearlPackageTime()
	-- local customize			= player:getCustomizationPackageTime()
	-- local dyeingPackage		= ToClient_getDyeingPackageTime()
	-- local russiaKamasilv	= player:getKamasilvePackageTime()	-- 러시아 전용 카마실브 버프
	-- { 초기화
		_pcRoomIcon		:SetShow( false )
		_fixedChargeIcon:SetShow( false )
		_starterPackage	:SetShow( false )
		_premiumPackage	:SetShow( false )
		_pearlPackage	:SetShow( false )
		_customize		:SetShow( false )
		_pearlPallete	:SetShow( false )
		_russiaKamasilv	:SetShow( false )
		if valuePackCheck then
			valuePackCheck = false
			PremiumPackageBuyNotice()
			_premiumText:SetShow( false )
			_btnCashShop:SetShow( false )
			_btnAlertClose:SetShow( false )
		end
	-- }
-- 북미에서는 PC방 버프 아이콘이 노출되지 않도록 한다!!!
	if ( true == isPremiumPcRoom ) then
		if (not isGameTypeRussia()) and (not isGameTypeEnglish()) then
			_pcRoomIcon:SetShow( true )
		end
	end

	if ( isServerFixedCharge() ) then
		_fixedChargeIcon:SetShow( true )
	end

	if applyStarter then
		_starterPackage:SetShow( true )
	end

	if applyPremium then
		_premiumPackage:SetShow( true )
		_premiumAlert:SetShow( false )
		local leftTime = math.ceil(premium/60/60)			-- 시간 단위(초 단위를 시간으로 변경)
		if leftTime <= 24 then								-- 6시간보다 적다면
			local msg = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_BUFFTIME_MSG", "leftTime", leftTime )
			_premiumAlert:SetText( msg )
			_premiumAlert:SetSize( _premiumAlert:GetTextSizeX() + 10, _premiumAlert:GetSizeY() )
			_premiumAlert_ShowAni( _premiumAlert, 10.0 )	-- 밸류 패키지 남은시간 알럿
		end
		valuePackCheck = true
	end
	
	if applyPearl then
		_pearlPackage:SetShow( true )
	end

	if applyCustomize then
		_customize:SetShow( true )
	end

	if applyDyeingPackage then
		_pearlPallete:SetShow( true )
	else
		_pearlPallete:SetShow( false )
	end
--{	러시아 전용 카마실브 버프.
	if applyRussiaKamasilv then
		_russiaKamasilv:SetShow( true )
	end
--}
	PackageIconPosition()
end

function FromClient_ResponseChangeExpAndDropPercent()
	local curChannelData		= getCurrentChannelServerData()
	local expEventShow			= IsWorldServerEventTypeByWorldNo( curChannelData._worldNo, 0 )
	local dropEventShow			= IsWorldServerEventTypeByWorldNo( curChannelData._worldNo, 1 )

	if expEventShow then
		_expEvent:SetShow( true )
	else
		_expEvent:SetShow( false )
	end

	if dropEventShow then
		_dropEvent:SetShow( true )
	else
		_dropEvent:SetShow( false )
	end
	PackageIconPosition()
end

-- 버블 알럿 사라지는 애니메이션
function _premiumAlert_ShowAni( control, showTime )
	control:SetShow( true )

	local closeAni = control:addColorAnimation( showTime, showTime+0.55, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	closeAni:SetStartColor( UI_color.C_FFFFFFFF )
	closeAni:SetEndColor( UI_color.C_00FFFFFF ) 
	closeAni:SetStartIntensity( 3.0 )
	closeAni:SetEndIntensity( 1.0 )
	closeAni.IsChangeChild = true
	closeAni:SetHideAtEnd(true)
	closeAni:SetDisableWhileAni(true)
end

-- 
function PremiumPackageBuyNotice()
	-- local cPSSW	= ToClient_GetCashProductStaticStatusWrapperByKeyRaw( productKey )
	if _premiumText:GetShow() then
		return
	end
	
	local msg = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_BUFFTIME_BUYINCASH_MSG")
	_premiumText:SetText( msg )
	_premiumText:SetShow( true )
	_btnCashShop:SetShow( true )
	_btnAlertClose:SetShow( true )
end

function PearlShop_Open()
	PremiumNotice_Close()
	InGameShop_Open()
	-- InGameShop_TabEvent(2)
end

function PremiumNotice_Close()
	_premiumText:SetShow( false )
	_btnCashShop:SetShow( false )
	_btnAlertClose:SetShow( false )
end

-- function HandleClicked_Buy_CashRevivalItem( respawnType )
	-- local cPSSW		= ToClient_GetCashProductStaticStatusWrapperByKeyRaw( getRevivalItem() )
	-- msgContent	= "[" .. tostring(cPSSW:getName()) .. "( 가격 : ".. tostring(cPSSW:getPearlPrice()) .."펄 )]\n이 아이템을 구매하시겠습니까?" .. "\n(로그아웃 후 접속한 상태면 경험치가 복구되지 않습니다.)"

	-- local messageboxData = { title = msgTitle, content = msgContent, functionYes = ToClient_Buy_CashRevivalBuy_Do, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	-- MessageBox.showMessageBox(messageboxData)
-- end
-- function ToClient_Buy_CashRevivalBuy_Do()
	-- local cPSSW		= ToClient_GetCashProductStaticStatusWrapperByKeyRaw( getRevivalItem() )
	-- getIngameCashMall():requestBuyItem(cPSSW:getNoRaw(), 1, cPSSW:getPearlPrice(), CppEnums.BuyItemReqTrType.eBuyItemReqTrType_ImmediatelyUse)
-- end


-- 버프 아이콘 show이벤트 되는 부분에 모두 선언해주어야함.
local _buffIconPosX
function PackageIconPosition()
	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		return
	end
	local iconPosX = Panel_SelfPlayerExpGage:GetPosX() + Panel_SelfPlayerExpGage:GetSizeX()
	local iconPosY = 15
	local iconBackPosX = nil

	local starter			= selfPlayer:get():isApplyChargeSkill( UI_BUFFTYPE.eUserChargeType_StarterPackage )
	local premium			= selfPlayer:get():isApplyChargeSkill( UI_BUFFTYPE.eUserChargeType_PremiumPackage )
	local pearl				= selfPlayer:get():isApplyChargeSkill( UI_BUFFTYPE.eUserChargeType_PearlPackage )
	local customize			= selfPlayer:get():isApplyChargeSkill( UI_BUFFTYPE.eUserChargeType_CustomizationPackage )
	local dyeingPackage		= selfPlayer:get():isApplyChargeSkill( UI_BUFFTYPE.eUserChargeType_DyeingPackage )
	local russiaKamasilv	= selfPlayer:get():isApplyChargeSkill( UI_BUFFTYPE.eUserChargeType_Kamasilve )				-- 러시아 전용 카마실브 버프

	if _pcRoomIcon:GetShow() then
		_pcRoomIcon:SetPosX( iconPosX )
		iconPosX = iconPosX + _pcRoomIcon:GetSizeX() + 5
	end

	if _fixedChargeIcon:GetShow() then
		_fixedChargeIcon:SetPosX( iconPosX )
		iconPosX = iconPosX + _fixedChargeIcon:GetSizeX() + 5
	end

	if starter then
		_starterPackage:SetPosX( iconPosX )
		_starterPackage:SetPosY( iconPosY )
		iconPosX = iconPosX + _starterPackage:GetSizeX() + 5
	end
	if premium then
		_premiumPackage:SetPosX( iconPosX )
		_premiumPackage:SetPosY( iconPosY )
		iconPosX = iconPosX + _premiumPackage:GetSizeX() + 5
		_premiumAlert:SetPosX( _premiumPackage:GetPosX() )
		_premiumAlert:SetPosY( _premiumPackage:GetPosY() + _premiumPackage:GetSizeY() + 10 )
		_premiumText:SetPosX( _premiumPackage:GetPosX() )
		_premiumText:SetPosY( _premiumPackage:GetPosY() + _premiumPackage:GetSizeY() )
		_btnCashShop:SetPosX( _premiumText:GetPosX() + _premiumText:GetTextSizeX() + 30 )
		_btnCashShop:SetPosY( _premiumText:GetPosY() + 30 )
		_btnAlertClose:SetPosX( _btnCashShop:GetPosX() + _btnCashShop:GetSizeX() )
		_btnAlertClose:SetPosY( _btnCashShop:GetPosY() )
	end
	if pearl then
		_pearlPackage:SetPosX( iconPosX )
		_pearlPackage:SetPosY( iconPosY )
		iconPosX = iconPosX + _pearlPackage:GetSizeX() + 5
	end
	if _btn_NewSkill:GetShow() then
		_btn_NewSkill:SetPosX( iconPosX )
		iconPosX = iconPosX + _btn_NewSkill:GetSizeX() + 5
	end
	if _txt_NewSkill:GetShow() then
		_txt_NewSkill:SetPosX ( ( _btn_NewSkill:GetPosX() + _btn_NewSkill:GetSizeX() - _txt_NewSkill:GetSizeX() ) + 2 )
	end
	if Panel_NormalKnowledge:GetShow() then
		Panel_NormalKnowledge:SetPosX( iconPosX )
		iconPosX = iconPosX + Panel_NormalKnowledge:GetSizeX() + 5
	end
	if Panel_ImportantKnowledge:GetShow() then
		Panel_ImportantKnowledge:SetPosX( iconPosX )
		iconPosX = iconPosX + Panel_ImportantKnowledge:GetSizeX() + 5
	end

	if _NodeLvBuffIcon:GetShow() then
		_NodeLvBuffIcon:SetPosX( iconPosX )
		_NodeLvBuffIcon:SetPosY( iconPosY )
		iconPosX = iconPosX + _NodeLvBuffIcon:GetSizeX() + 5
	end

	if _expEvent:GetShow() then
		_expEvent:SetPosX( iconPosX )
		_expEvent:SetPosY( iconPosY )
		iconPosX = iconPosX + _expEvent:GetSizeX() + 5
	end

	if _dropEvent:GetShow() then
		_dropEvent:SetPosX( iconPosX )
		_dropEvent:SetPosY( iconPosY )
		iconPosX = iconPosX + _dropEvent:GetSizeX() + 5
	end

	if customize then
		_customize:SetPosX( iconPosX )
		_customize:SetPosY( iconPosY )
		iconPosX = iconPosX + _customize:GetSizeX() + 5
	end

	if dyeingPackage then
		_pearlPallete:SetPosX( iconPosX )
		_pearlPallete:SetPosY( iconPosY )
		iconPosX = iconPosX + _pearlPallete:GetSizeX() + 5
	end

	if russiaKamasilv then
		_russiaKamasilv:SetPosX( iconPosX )
		_russiaKamasilv:SetPosY( iconPosY )
		iconPosX = iconPosX + _russiaKamasilv:GetSizeX() + 5
	end

	-- iconPosX 지식 위치도 잡혀있음.
	_buffIconPosX = iconPosX
end

function SelfExp_BuffIcon_PosX()
	return _buffIconPosX
end

function CharacterExpFix()
	if getSelfPlayer():get():getLevel() < 11 then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_NOTYETUSE") ) -- "아직 사용할 수 없습니다." )
		_ExpFix:SetCheck(false)
		return
	end

	ToClient_SetAddedExperience( not _ExpFix:IsCheck() )
end

function BuffIcon_ShowSimpleToolTip( isShow, iconType )
	local name, desc, uiControl	= nil, nil, nil
	local leftTime				= 0
	local selfPlayer				= getSelfPlayer()
	if nil == selfPlayer then
		return
	end
	local player				= selfPlayer:get()
	local starter				= player:getUserChargeTime( UI_BUFFTYPE.eUserChargeType_StarterPackage )
	local premium				= player:getUserChargeTime( UI_BUFFTYPE.eUserChargeType_PremiumPackage )
	local pearl					= player:getUserChargeTime( UI_BUFFTYPE.eUserChargeType_PearlPackage )
	local customize				= player:getUserChargeTime( UI_BUFFTYPE.eUserChargeType_CustomizationPackage )
	local dyeingPackage			= player:getUserChargeTime( UI_BUFFTYPE.eUserChargeType_DyeingPackage )
	local russiaKamasilv		= player:getUserChargeTime( UI_BUFFTYPE.eUserChargeType_Kamasilve )
	
	if iconType == 0 then	-- "배울수 있는 기술이 있습니다.", "툴팁이 사라지지 않는 현상으로 인해 이곳으로 이동"
		name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_NewSkillDesc") -- "배울 수 있는 기술이 있습니다."
		desc = nil
		uiControl = _btn_NewSkill
	elseif iconType == 1 then		-- PC방 버프(국가별로 틀리게 사용한다.)
		if isGameTypeEnglish() then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_PCROOM_TITLE_NA")
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_PCROOM_DESC_NA")
		else
			name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_PCROOM_TITLE") -- "PC방 혜택"
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_PCROOM_DESC") -- "채집 잠재력 +1\n낚시 잠재력 +1\n친밀도 획득 +20%\n말 경험치 획득 +20%\n가방 16칸 확장\n창고 16칸 확장\nPC방 상자 지급(30분 마다)\nPC방 NPC 상점 이용 가능\n거래소 수령액+20%"
		end
		uiControl = _pcRoomIcon
	elseif iconType == 2 then -- 카마실브의 축복(국가별 설명이 틀림.)
		leftTime = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_YAZBUFF_TIME", "getStarterPackageTime", convertStringFromDatetime( toInt64(0, starter) ) ) -- "남은시간 : " .. convertStringFromDatetime( toInt64(0, getSelfPlayer():get():getStarterPackageTime()) )
		if isGameTypeRussia() then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_YAZBUFF_TITLE_RUS") -- 프리미엄 I
			desc = leftTime .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_YAZBUFF_DESC_RUS")
		else
			name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_YAZBUFF_TITLE") -- "야즈의 축복"
			desc = leftTime .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_YAZBUFF_DESC") -- "HP 회복속도 +1 (1주)\n가방 확장 16칸 (1주)\n창고 확장 16칸 (1주)"
		end
		uiControl = _starterPackage
	elseif iconType == 3 then -- 밸류 패키지
		leftTime = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_AILINBUFF_TIME", "getPremiumPackageTime", convertStringFromDatetime( toInt64(0, premium) ) ) -- "남은시간 : " .. convertStringFromDatetime( toInt64(0, getSelfPlayer():get():getPremiumPackageTime()) )
		if isGameTypeJapan() then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_TITLE") -- 밸류 패키지
			desc = leftTime .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_DESC_JP")
		elseif isGameTypeRussia() then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_TITLE_RUS") -- 프리미엄 II
			desc = leftTime .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_DESC_RUS")
		else
			name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_TITLE") -- 밸류 패키지
			desc = leftTime .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_DESC")
		end
		uiControl = _premiumPackage
	elseif iconType == 4 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_PEARLBUFF_TITLE") -- "빛나는 진주의 축복"
		leftTime = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_LIGHTPEARLBUFF_TIME", "getPearlPackageTime", convertStringFromDatetime( toInt64(0, pearl) ) ) -- "남은시간 : " .. convertStringFromDatetime( toInt64(0, getSelfPlayer():get():getPearlPackageTime()) )
		desc = leftTime .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_PEARLBUFF_DESC") -- "기운 회복 속도 +1\n아이템 획득 확률 +2.5%"
		uiControl = _pearlPackage
	elseif iconType == 5 and true == localNodeInvestment then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_NODELVBUFF_TITLE") -- "거점 투자 혜택"
		desc = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_NODELVBUFF_DESC", "nodeName", localNodeName  ) -- "{nodeName} 거점\n아이템 드롭률 증가"
		uiControl = _NodeLvBuffIcon
	elseif iconType == 5 and false == localNodeInvestment then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_NODELVBUFF_TITLE") -- "거점 투자 혜택"
		desc = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_NOTNODELVBUFF_DESC", "localNodeName", localNodeName )
		uiControl = _NodeLvBuffIcon
	elseif iconType == 6 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EXPBUFF") -- 경험치 획득 증가 이벤트 진행중
		uiControl = _expEvent
	elseif iconType == 7 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_DROPBUFF") -- 드랍률 증가 이벤트 진행중
		uiControl = _dropEvent
	elseif iconType == 8 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTER_BUFF_TOOLTIP_NAME")
		desc = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CASH_CUSTOMIZATION_BUFFTOOLTIP_DESC", "customizationPackageTime", convertStringFromDatetime(toInt64(0, customize)) )
		uiControl = _customize

	elseif iconType == 9 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAUGE_DYEINGPACKEAGE_TITLE")	-- "마르지 않는 팔레트"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAUGE_DYEINGPACKEAGE_DESC") .. convertStringFromDatetime( toInt64(0, dyeingPackage) )	-- "지속시간동안 마르지 않는 팔레트를 이용해 제한 없이 염색을 할 수 있습니다.\n남은 이용 시간 : "
		uiControl = _pearlPallete

	elseif iconType == 10 then	-- 러시아 전용 카마실브 버프.
		name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_YAZBUFF_TITLE")
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_YAZBUFF_DESC") .. "\n" .. convertStringFromDatetime( toInt64(0,russiaKamasilvTime) )
		uiControl = _russiaKamasilv

	elseif iconType == 11 then	-- 러시아 전용 P2P 서버 남은 시간.
		local temporaryPCRoomWrapper	= getTemporaryInformationWrapper()
		name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_PRIMIUMSERVER_TITLE") -- 정액 결제
		desc = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_PRIMIUMSERVER_DESC", "leftTime", convertStringFromDatetime( toInt64(0, temporaryPCRoomWrapper:getFixedChargeTime()) ) ) -- "정액 서버 이용 남은시간 : " .. convertStringFromDatetime( toInt64(0, getSelfPlayer():get():getStarterPackageTime()) )
		uiControl = _fixedChargeIcon

	elseif iconType == 90 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_TOOLTIP_FIXEXP_TITLE") -- "경험치 고정하기"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_TOOLTIP_FIXEXP_DESC") -- "선택하게 되면 경험치를 더 이상 습득하지 않습니다."
		uiControl = _ExpFix
	end

	if true == isShow then
		registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end
end


-- function Panel_SelfPlayer_EnableSkill_HelpDesc( isOn )	-- "배울 수 있는 기술이 있습니다."	--	"툴팁이 사라지지 않는 현상으로 인해 심플 툴팁으로 변경"
	-- _txt_NewSkillDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_NewSkillDesc") )
	
	-- _txt_NewSkillDesc:SetPosX( _btn_NewSkill:GetPosX() + _btn_NewSkill:GetSizeX() - 30 )
	-- _txt_NewSkillDesc:SetPosY( _btn_NewSkill:GetPosY() + _btn_NewSkill:GetSizeY() +10 )
	-- _txt_NewSkillDesc:SetSize( 150, 25 )
	
	-- if ( isOn == true ) then
		-- _txt_NewSkillDesc:SetShow( true )
		-- _txt_NewSkillDesc:SetSize( _txt_NewSkillDesc:GetSizeX() + _txt_NewSkillDesc:GetSpanSize().x + 13, _txt_NewSkillDesc:GetSizeY() + _txt_NewSkillDesc:GetSpanSize().y + 5 )
	-- else
		-- _txt_NewSkillDesc:SetShow( false )
	-- end
-- end

UI.addRunPostRestorFunction( FGlobal_PackageIconUpdate )	-- 플러시를 나올 때, Show체크를 다시 해야 한다. 펄상점/뷰티샵에서 스케일 조정을 하기 때문.


--------------------------------------------------------------------------------
-- 아이콘 툴팁
--------------------------------------------------------------------------------
function SelfPlayer_ExpTooltip( isShow, iconType )
	local uiControl, name, desc = nil
	if 0 == iconType then		-- 기술 포인트
		name = PAGetString( Defines.StringSheet_GAME,  "LUA_MAINSTATUS_SKILLPOINTICON_TITLE" )
		desc = PAGetString( Defines.StringSheet_GAME,  "LUA_MAINSTATUS_SKILLPOINTICON_DESC" )
		uiControl = _staticSkillPointSub

	elseif 1 == iconType then	-- 기운 포인트
		name = PAGetString( Defines.StringSheet_RESOURCE,  "CHARACTERINFO_TEXT_MENTAL" )
		desc = PAGetString( Defines.StringSheet_GAME,  "MAINSTATUS_DESC_WP" )
		uiControl = _Wp_Main

	elseif 2 == iconType then	-- 공헌도
		local _contributeBubbleText = ""
		for i = 0, 2 do
			if 0 < ToClient_UsedExplorePoint(i) then
				if ( "" == _contributeBubbleText ) then
					_contributeBubbleText = _contributeUsePoint[i] .. " " .. ToClient_UsedExplorePoint(i)
				else
					_contributeBubbleText = _contributeBubbleText .. " | " .. _contributeUsePoint[i] .. " " .. ToClient_UsedExplorePoint(i)
				end
			end
		end
		
		if ( "" == _contributeBubbleText ) then
			_contributeBubbleText = PAGetString( Defines.StringSheet_GAME, "LUA_EXPGUAGE_CONTRIBUTE_VALUE_4" )
		else
			_contributeBubbleText = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_EXPGUAGE_CONTRIBUTE_VALUE_5", "_contributeBubbleText", _contributeBubbleText )
		end
		name = PAGetString( Defines.StringSheet_GAME,  "LUA_WORLD_MAP_GUIDE_CONTRIBUTIVENESS" )
		desc = PAGetString( Defines.StringSheet_GAME,  "MAINSTATUS_DESC_EXPLORE" ) .. "\n" .. _contributeBubbleText
		uiControl = _contribute_Main
	end

	if isShow then
		-- ♬ 도움말 뜰 때 사운드 추가
		audioPostEvent_SystemUi(00,13)

		registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end
end
local saveWayPoint = nil
function eventChangedExplorationNode( wayPointKey )
	local nodeLv	= ToClient_GetNodeLevel( wayPointKey )
	local nodeName	= ToClient_GetNodeNameByWaypointKey ( wayPointKey )
	local nodeExp	= ToClient_GetNodeExperience_s64( wayPointKey )
	localNodeName = nodeName
	saveWayPoint = wayPointKey
	if 0 < nodeLv and toInt64(0,0) <= nodeExp then	-- 거점 레벨이 0보다 크고 경험치가 0보다 같거나 크면 버프 아이콘 활성화
		_NodeLvBuffIcon:SetShow( true )
		_NodeLvBuffIcon:ChangeTextureInfoName("Icon/New_Icon/04_PC_Skill/03_Buff/Node_ItemDropRateUP.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( _NodeLvBuffIcon, 1, 1, 32, 32 )
		_NodeLvBuffIcon:getBaseTexture():setUV(  x1, y1, x2, y2  )
		_NodeLvBuffIcon:setRenderTexture(_NodeLvBuffIcon:getBaseTexture())
		PackageIconPosition()
		localNodeInvestment = true
	else
		_NodeLvBuffIcon:SetShow( true )
		_NodeLvBuffIcon:ChangeTextureInfoName("Icon/New_Icon/04_PC_Skill/03_Buff/Non_ItemDropRateUP.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( _NodeLvBuffIcon, 1, 1, 32, 32 )
		_NodeLvBuffIcon:getBaseTexture():setUV(  x1, y1, x2, y2  )
		_NodeLvBuffIcon:setRenderTexture(_NodeLvBuffIcon:getBaseTexture())
		PackageIconPosition()
		localNodeInvestment = false
	end
	
end

function eventChangedExplorationNodeCheck(wayPointKey)
	eventChangedExplorationNode(wayPointKey)
end

function eventChangeExplorationNode(wayPointKey)
	if saveWayPoint == wayPointKey then
		eventChangedExplorationNode(wayPointKey)
	end
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
contributePoint_UpdateFunc()
Panel_SelfPlayerExpGage_CharacterInfoWindowUpdate()
UserSkillPoint_Update()
CharacterExpFix()
registEventHandler()
registMessageHandler()

changePositionBySever(Panel_SelfPlayerExpGage, CppEnums.PAGameUIType.PAGameUIPanel_SelfPlayer_ExpGage, true, false, false)
registerEvent( "FromClint_EventChangedExplorationNode", "eventChangedExplorationNodeCheck")
registerEvent( "FromClint_EventUpdateExplorationNode", "eventChangeExplorationNode")
--registerEvent( "FromClint_EventChangedExplorationNode", "eventChangedExplorationNode")
--registerEvent( "FromClint_EventUpdateExplorationNode", "eventChangeExplorationNodeName")
