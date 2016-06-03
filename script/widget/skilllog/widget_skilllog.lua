Panel_Widget_SkillLog:setGlassBackground( true )
Panel_Widget_SkillLog:setMaskingChild( true )
Panel_Widget_SkillLog:SetShow( false, false )

Panel_Widget_SkillLog:RegisterShowEventFunc( true, 'Panel_Widget_SkillLog_ShowAni()' )
Panel_Widget_SkillLog:RegisterShowEventFunc( false, 'Panel_Widget_SkillLog_HideAni()' )

local 	UCT 			= CppEnums.PA_UI_CONTROL_TYPE
local 	UI_ANI_ADV		= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local 	UI_DS			= CppEnums.DialogState
local 	UI_color		= Defines.Color
local 	UI_TM 			= CppEnums.TextMode
local	UI_PSFT			= CppEnums.PAUI_SHOW_FADE_TYPE
local	UI_TT			= CppEnums.PAUI_TEXTURE_TYPE

local	skillLog_Icon	= UI.getChildControl( Panel_Widget_SkillLog, "Static_C_SkillIcon" )
local	skillLog		= UI.getChildControl( Panel_Widget_SkillLog, "StaticText_UsedSkill" )

local notifySkillMsg = {}

notifySkillMsg[0] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Widget_SkillLog, "StaticText_SkillMsg_1" )
CopyBaseProperty ( skillLog, notifySkillMsg[0] )
notifySkillMsg[1] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Widget_SkillLog, "StaticText_SkillMsg_2" )
CopyBaseProperty ( skillLog, notifySkillMsg[1] )
notifySkillMsg[2] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Widget_SkillLog, "StaticText_SkillMsg_3" )
CopyBaseProperty ( skillLog, notifySkillMsg[2] )

local displayTime = 2.0
local _displayRunningTime = 0

function Panel_Widget_SkillLog_ShowAni()
	Panel_Widget_SkillLog:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_Gradient_toTop.dds")
	local FadeMaskAni = Panel_Widget_SkillLog:addTextureUVAnimation (0.0, 0.75, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI )
	FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)

	FadeMaskAni:SetStartUV ( 0.0, 0.1, 0 )
	FadeMaskAni:SetEndUV ( 0.0, 0.6, 0 )

	FadeMaskAni:SetStartUV ( 1.0, 0.1, 1 )
	FadeMaskAni:SetEndUV ( 1.0, 0.6, 1 )

	FadeMaskAni:SetStartUV ( 0.0, 0.4, 2 )
	FadeMaskAni:SetEndUV ( 0.0, 1.0, 2 )

	FadeMaskAni:SetStartUV ( 1.0, 0.4, 3 )
	FadeMaskAni:SetEndUV ( 1.0, 1.0, 3 )

	Panel_Widget_SkillLog:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)

	local aniInfo3 = Panel_Widget_SkillLog:addColorAnimation( 0.0, 0.20, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo3:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo3.IsChangeChild = true

	local aniInfo8 = Panel_Widget_SkillLog:addColorAnimation( 0.12, 0.23, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo8:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo8:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo8:SetStartIntensity( 3.0 )
	aniInfo8:SetEndIntensity( 1.0 )
end
function Panel_Widget_SkillLog_HideAni()
	Panel_Widget_SkillLog:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
	local SkillLog_Alpha = Panel_Widget_SkillLog:addColorAnimation( 0.0, 0.6, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	SkillLog_Alpha:SetStartColor( UI_color.C_FFFFFFFF )
	SkillLog_Alpha:SetEndColor( UI_color.C_00FFFFFF )
	SkillLog_Alpha.IsChangeChild = true
	SkillLog_Alpha:SetHideAtEnd(true)
	SkillLog_Alpha:SetDisableWhileAni(true)
end

local index = 0
local prevIndex1 = nil
local prevIndex2 = nil

function SkillLog_Init()
	_displayRunningTime = 0
	notifySkillMsg[0]:SetText("")
	notifySkillMsg[1]:SetText("")
	notifySkillMsg[2]:SetText("")
	index = 0
	prevIndex1 = nil
	prevIndex2 = nil
end

function FromClient_EventSelfPlayerUsedSkill()
	if false == FGlobal_IsChecked_SkillCommand() then
		Panel_Widget_SkillLog:SetShow( false )
		local skillWrapper = selfPlayerUsedSkillFront()
		Tutorial_CheckUsedSkill( skillWrapper )
		selfPlayerUsedSkillPopFront()
		return
	end

	Panel_Widget_SkillLog:SetShow( true, true )
	
	if nil ~= prevIndex1 then
		if "" ~= notifySkillMsg[prevIndex1]:GetText() then
			-- 위로 올라가는 애니메이션
			SkillName_MovAni( notifySkillMsg[prevIndex1], 58, 30 )
			if 0 == prevIndex1 then
				prevIndex2 = 2
			else
				prevIndex2 = prevIndex1 - 1
			end
			if "" ~= notifySkillMsg[prevIndex2]:GetText() then
				-- 위로 올라가는 애니메이션
				SkillName_MovAni( notifySkillMsg[prevIndex2], 30, 2 )
			end
		end
	end
	
	local skillWrapper = selfPlayerUsedSkillFront()
	if nil ~= skillWrapper then
		Tutorial_CheckUsedSkill( skillWrapper )
		local iconPath = skillWrapper:getSkillTypeStaticStatusWrapper():getIconPath()
		skillLog_Icon:ChangeTextureInfoName("Icon/" .. iconPath)
		
		local skillName = skillWrapper:getName()

		notifySkillMsg[index]:SetText( skillName )
		notifySkillMsg[index]:SetShow( true )
		notifySkillMsg[index]:SetPosY( 58 )
		-- 등장 애니메이션 추가
		-- SkillName_ScaleAni( notifySkillMsg[index] )
		selfPlayerUsedSkillPopFront()
		prevIndex1 = index
		index = (index + 1) % 3
		_displayRunningTime = 0
	end
end

function SkillName_MovAni( control, startPosY, endPosY )
	local MoveAni1 = control:addMoveAnimation( 0.0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI )
	MoveAni1:SetStartPosition( control:GetPosX(), startPosY )
	MoveAni1:SetEndPosition( control:GetPosX(), endPosY )
end

-- 스케일 애니메이션이 끝나기 전에 무브 애니메이션이 실행될 경우, 포지션 버그가 발생해서 잠시 막아둠
function SkillName_ScaleAni( control )
	local aniInfo1 = control:addScaleAnimation( 0.0, 0.05, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.0)
	aniInfo1:SetEndScale(1.0)
	aniInfo1.AxisX = 0
	aniInfo1.AxisY = 0
	aniInfo1.ScaleType = 4
end

function SkillLog_TimeCheck( deltaTime )
	_displayRunningTime = _displayRunningTime + deltaTime
	
	if displayTime < _displayRunningTime then
		Panel_Widget_SkillLog:SetShow( false, true )
		SkillLog_Init()
	end
end

function Panel_Widget_SkillLog_SetPos()
	Panel_Widget_SkillLog:SetPosX( getScreenSizeX()/2 - Panel_Widget_SkillLog:GetSizeX()*1.3)
	Panel_Widget_SkillLog:SetPosY( getScreenSizeY()/2 + Panel_Widget_SkillLog:GetSizeY()/2)
end

SkillLog_Init()
Panel_Widget_SkillLog:RegisterUpdateFunc("SkillLog_TimeCheck")
registerEvent( "EventSelfPlayerUsedSkill", "FromClient_EventSelfPlayerUsedSkill" )
registerEvent( "onScreenResize", "Panel_Widget_SkillLog_SetPos")
