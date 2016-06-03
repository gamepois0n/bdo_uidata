UIAni = {}

local UI_ANI_ADV	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_AV			= CppEnums.PA_UI_ALIGNVERTICAL
local UI_TT			= CppEnums.PAUI_TEXTURE_TYPE
local UI_color 		= Defines.Color

function UIAni.closeAni( panel )
	panel:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)

	local closeAni = panel:addColorAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	closeAni:SetStartColor( UI_color.C_FFFFFFFF )
	closeAni:SetEndColor( UI_color.C_00FFFFFF ) 
	closeAni:SetStartIntensity( 3.0 )
	closeAni:SetEndIntensity( 1.0 )
	closeAni.IsChangeChild = true
	closeAni:SetHideAtEnd(true)
	closeAni:SetDisableWhileAni(true)
end

function UIAni.TestFunc(panel, uvStX, uvStY, uvEndX, uvEndY )
	local getGuildMarkTexture = guildMark:getBaseTexture()
	getGuildMarkTexture:setUV( uvStX, uvStY, uvEndX, uvEndY ) -- 65 2
	guildMark:SetTexturePreload(false)	
end

function UIAni.fadeInSCR_MidOut( panel )
	panel:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_MidHorizon.dds")

	local FadeMaskAni = panel:addTextureUVAnimation (0.0, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI )
	FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)

	FadeMaskAni:SetStartUV ( uvStartX, uvStartY, 0 )
	FadeMaskAni:SetEndUV ( 0.6, 0.0, 0 )

	FadeMaskAni:SetStartUV ( 1.0, 0.0, 1 )
	FadeMaskAni:SetEndUV ( 0.4, 0.0, 1 )

	FadeMaskAni:SetStartUV ( 0.0, 1.0, 2 )
	FadeMaskAni:SetEndUV ( 0.6, 1.0, 2 )

	FadeMaskAni:SetStartUV ( 1.0, 1.0, 3 )
	FadeMaskAni:SetEndUV ( 0.4, 1.0, 3 )
	
	FadeMaskAni.IsChangeChild = true
end

function UIAni.fadeInSCR_Up( panel )
	panel:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_Gradient_toTop.dds")
	local FadeMaskAni = panel:addTextureUVAnimation (0.0, 0.75, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI )
	FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)

	FadeMaskAni:SetStartUV ( 0.0, 0.1, 0 )
	FadeMaskAni:SetEndUV ( 0.0, 0.6, 0 )

	FadeMaskAni:SetStartUV ( 1.0, 0.1, 1 )
	FadeMaskAni:SetEndUV ( 1.0, 0.6, 1 )

	FadeMaskAni:SetStartUV ( 0.0, 0.4, 2 )
	FadeMaskAni:SetEndUV ( 0.0, 1.0, 2 )

	FadeMaskAni:SetStartUV ( 1.0, 0.4, 3 )
	FadeMaskAni:SetEndUV ( 1.0, 1.0, 3 )

	panel:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)

	local aniInfo3 = panel:addColorAnimation( 0.0, 0.20, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo3:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo3.IsChangeChild = true

	-- local aniInfo4 = panel:addScaleAnimation( 0.0, 0.12, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	-- aniInfo4:SetStartScale(0.97)
	-- aniInfo4:SetEndScale(1.0)
	-- aniInfo4.AxisX = 200
	-- aniInfo4.AxisY = 295
	-- aniInfo4.IsChangeChild = true

	local aniInfo8 = panel:addColorAnimation( 0.12, 0.23, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo8:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo8:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo8:SetStartIntensity( 3.0 )
	aniInfo8:SetEndIntensity( 1.0 )
end

function UIAni.fadeInSCR_Right( panel )
	panel:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_Gradient_toRight.dds")
	local FadeMaskAni = panel:addTextureUVAnimation (0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI )
	FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)

	FadeMaskAni:SetStartUV ( 0.6, 0.1, 0 )
	FadeMaskAni:SetEndUV ( 0.1, 0.1, 0 )

	FadeMaskAni:SetStartUV ( 1.0, 1.0, 1 )
	FadeMaskAni:SetEndUV ( 0.4, 1.0, 1 )

	FadeMaskAni:SetStartUV ( 0.6, 1.0, 2 )
	FadeMaskAni:SetEndUV ( 0.1, 1.0, 2 )

	FadeMaskAni:SetStartUV ( 1.0, 1.0, 3 )
	FadeMaskAni:SetEndUV ( 0.4, 1.0, 3 )

	panel:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)

	local aniInfo3 = panel:addColorAnimation( 0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo3:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo3.IsChangeChild = true

	-- local aniInfo4 = panel:addScaleAnimation( 0.0, 0.12, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	-- aniInfo4:SetStartScale(0.97)
	-- aniInfo4:SetEndScale(1.0)
	-- aniInfo4.AxisX = 200
	-- aniInfo4.AxisY = 295
	-- aniInfo4.IsChangeChild = true

	local aniInfo8 = panel:addColorAnimation( 0.12, 0.23, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo8:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo8:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo8:SetStartIntensity( 3.0 )
	aniInfo8:SetEndIntensity( 1.0 )
end

function UIAni.fadeInSCR_Down( panel )
	panel:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_Gradient_toBottom.dds")
	local FadeMaskAni = panel:addTextureUVAnimation (0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI )
	FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)

	FadeMaskAni:SetStartUV ( 0.0, 0.6, 0 )
	FadeMaskAni:SetEndUV ( 0.0, 0.1, 0 )

	FadeMaskAni:SetStartUV ( 1.0, 0.6, 1 )
	FadeMaskAni:SetEndUV ( 1.0, 0.1, 1 )

	FadeMaskAni:SetStartUV ( 0.0, 1.0, 2 )
	FadeMaskAni:SetEndUV ( 0.0, 0.4, 2 )

	FadeMaskAni:SetStartUV ( 1.0, 1.0, 3 )
	FadeMaskAni:SetEndUV ( 0.0, 0.4, 3 )

	panel:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)

	local aniInfo3 = panel:addColorAnimation( 0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo3:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo3.IsChangeChild = true

	local aniInfo8 = panel:addColorAnimation( 0.15, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo8:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo8:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo8:SetStartIntensity( 3.0 )
	aniInfo8:SetEndIntensity( 1.0 )
end

function UIAni.fadeInSCR_Left( panel )
	panel:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_Gradient_toLeft.dds")
	local FadeMaskAni = panel:addTextureUVAnimation (0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI )
	FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)

	FadeMaskAni:SetStartUV ( 0.0, 0.0, 0 )
	FadeMaskAni:SetEndUV ( 0.6, 0.0, 0 )

	FadeMaskAni:SetStartUV ( 0.4, 0.0, 1 )
	FadeMaskAni:SetEndUV ( 1.0, 0.0, 1 )

	FadeMaskAni:SetStartUV ( 0.0, 1.0, 2 )
	FadeMaskAni:SetEndUV ( 0.6, 1.0, 2 )

	FadeMaskAni:SetStartUV ( 0.4, 1.0, 3 )
	FadeMaskAni:SetEndUV ( 1.0, 1.0, 3 )

	panel:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)

	-- local aniInfo3 = panel:addColorAnimation( 0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	-- aniInfo3:SetStartColor( UI_color.C_00FFFFFF )
	-- aniInfo3:SetEndColor( UI_color.C_FFFFFFFF )
	-- aniInfo3.IsChangeChild = false

	local aniInfo8 = panel:addColorAnimation( 0.0, 0.12, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo8:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo8:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo8:SetStartIntensity( 3.0 )
	aniInfo8:SetEndIntensity( 1.0 )
	aniInfo3.IsChangeChild = true
end

function UIAni.fadeInSCR_Left_Clear( panel )
	panel:ChangeSpecialTextureInfoName("")
	--panel:SetAlphaChild(1.0)
end


-- 월드맵 전용
function UIAni.fadeInSCRWorldMap_Down(panel)
	local FadeMaskAni = panel:addTextureUVAnimation (0.0, 0.28, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI )
	FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)

	FadeMaskAni:SetStartUV ( 0.0, 0.6, 0 )
	FadeMaskAni:SetEndUV ( 0.0, 0.1, 0 )

	FadeMaskAni:SetStartUV ( 1.0, 0.6, 1 )
	FadeMaskAni:SetEndUV ( 1.0, 0.1, 1 )

	FadeMaskAni:SetStartUV ( 0.0, 1.0, 2 )
	FadeMaskAni:SetEndUV ( 0.0, 0.4, 2 )

	FadeMaskAni:SetStartUV ( 1.0, 1.0, 3 )
	FadeMaskAni:SetEndUV ( 0.0, 0.4, 3 )

	panel:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)

	local aniInfo3 = panel:addColorAnimation( 0.0, 0.20, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo3:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo3.IsChangeChild = true

	local aniInfo8 = panel:addColorAnimation( 0.12, 0.23, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo8:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo8:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo8:SetStartIntensity( 3.0 )
	aniInfo8:SetEndIntensity( 1.0 )
end



-- 다이얼로그 전용
function UIAni.fadeInSCRDialog_MidOut( panel )
	panel:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_MidHorizon.dds")
	local FadeMaskAni = panel:addTextureUVAnimation (0.0, 2.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI )
	FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)

	FadeMaskAni:SetStartUV ( 0.0, 0.0, 0 )
	FadeMaskAni:SetEndUV ( 0.6, 0.0, 0 )

	FadeMaskAni:SetStartUV ( 1.0, 0.0, 1 )
	FadeMaskAni:SetEndUV ( 0.4, 0.0, 1 )

	FadeMaskAni:SetStartUV ( 0.0, 1.0, 2 )
	FadeMaskAni:SetEndUV ( 0.6, 1.0, 2 )

	FadeMaskAni:SetStartUV ( 1.0, 1.0, 3 )
	FadeMaskAni:SetEndUV ( 0.4, 1.0, 3 )
end

function UIAni.fadeInSCRDialog_Up( panel )
	panel:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_Gradient_toTop.dds")
	local FadeMaskAni = panel:addTextureUVAnimation (0.0, 0.85, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI )
	FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)

	FadeMaskAni:SetStartUV ( 0.0, 0.1, 0 )
	FadeMaskAni:SetEndUV ( 0.0, 0.6, 0 )

	FadeMaskAni:SetStartUV ( 1.0, 0.1, 1 )
	FadeMaskAni:SetEndUV ( 1.0, 0.6, 1 )

	FadeMaskAni:SetStartUV ( 0.0, 0.4, 2 )
	FadeMaskAni:SetEndUV ( 0.0, 1.0, 2 )

	FadeMaskAni:SetStartUV ( 1.0, 0.4, 3 )
	FadeMaskAni:SetEndUV ( 1.0, 1.0, 3 )

	panel:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)

	local aniInfo3 = panel:addColorAnimation( 0.0, 0.20, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo3:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo3.IsChangeChild = true

	local aniInfo8 = panel:addColorAnimation( 0.12, 0.23, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo8:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo8:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo8:SetStartIntensity( 3.0 )
	aniInfo8:SetEndIntensity( 1.0 )
end

function UIAni.fadeInSCRDialog_Right( panel )
	panel:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_Gradient_toRight.dds")
	local FadeMaskAni = panel:addTextureUVAnimation (0.0, 0.36, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI )
	FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)

	FadeMaskAni:SetStartUV ( 0.6, 0.1, 0 )
	FadeMaskAni:SetEndUV ( 0.1, 0.1, 0 )

	FadeMaskAni:SetStartUV ( 1.0, 1.0, 1 )
	FadeMaskAni:SetEndUV ( 0.4, 1.0, 1 )

	FadeMaskAni:SetStartUV ( 0.6, 1.0, 2 )
	FadeMaskAni:SetEndUV ( 0.1, 1.0, 2 )

	FadeMaskAni:SetStartUV ( 1.0, 1.0, 3 )
	FadeMaskAni:SetEndUV ( 0.4, 1.0, 3 )

	panel:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)

	local aniInfo3 = panel:addColorAnimation( 0.0, 0.20, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo3:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo3.IsChangeChild = true

	local aniInfo8 = panel:addColorAnimation( 0.12, 0.23, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo8:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo8:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo8:SetStartIntensity( 3.0 )
	aniInfo8:SetEndIntensity( 1.0 )
end

function UIAni.fadeInSCRDialog_Down( panel )
	panel:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_Gradient_toBottom.dds")
	local FadeMaskAni = panel:addTextureUVAnimation (0.0, 0.20, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI )
	FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)

	FadeMaskAni:SetStartUV ( 0.0, 0.6, 0 )
	FadeMaskAni:SetEndUV ( 0.0, 0.1, 0 )

	FadeMaskAni:SetStartUV ( 1.0, 0.6, 1 )
	FadeMaskAni:SetEndUV ( 1.0, 0.1, 1 )

	FadeMaskAni:SetStartUV ( 0.0, 1.0, 2 )
	FadeMaskAni:SetEndUV ( 0.0, 0.4, 2 )

	FadeMaskAni:SetStartUV ( 1.0, 1.0, 3 )
	FadeMaskAni:SetEndUV ( 0.0, 0.4, 3 )

	panel:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)

	local aniInfo3 = panel:addColorAnimation( 0.0, 0.20, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo3:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo3.IsChangeChild = true

	-- local aniInfo8 = panel:addColorAnimation( 0.12, 0.23, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	-- aniInfo8:SetStartColor( UI_color.C_FFFFFFFF )
	-- aniInfo8:SetEndColor( UI_color.C_FFFFFFFF )
	-- aniInfo8:SetStartIntensity( 3.0 )
	-- aniInfo8:SetEndIntensity( 1.0 )
end

function UIAni.fadeInSCRDialog_Left( panel )
	panel:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_Gradient_toLeft.dds")
	local FadeMaskAni = panel:addTextureUVAnimation (0.0, 0.36, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI )
	FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)

	FadeMaskAni:SetStartUV ( 0.0, 0.0, 0 )
	FadeMaskAni:SetEndUV ( 0.6, 0.0, 0 )

	FadeMaskAni:SetStartUV ( 0.4, 0.0, 1 )
	FadeMaskAni:SetEndUV ( 1.0, 0.0, 1 )

	FadeMaskAni:SetStartUV ( 0.0, 1.0, 2 )
	FadeMaskAni:SetEndUV ( 0.6, 1.0, 2 )

	FadeMaskAni:SetStartUV ( 0.4, 1.0, 3 )
	FadeMaskAni:SetEndUV ( 1.0, 1.0, 3 )

	panel:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)

	local aniInfo3 = panel:addColorAnimation( 0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo3:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo3.IsChangeChild = true

	local aniInfo8 = panel:addColorAnimation( 0.12, 0.23, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo8:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo8:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo8:SetStartIntensity( 3.0 )
	aniInfo8:SetEndIntensity( 1.0 )
end


-- 알파 애니메이션
function UIAni.AlphaAnimation( toAlpha, control, startTime, EndTime )
	control:ResetVertexAni()
	
	local alphaAni = control:addColorAnimation( startTime, EndTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	alphaAni:SetStartColorBySafe( PAUIColorType(control:GetAlpha() * 255, 255, 255, 255) )
	alphaAni:SetEndColorBySafe( PAUIColorType(toAlpha * 255, 255, 255, 255) )
	alphaAni.IsChangeChild = true
	
	return alphaAni
end


function UIAni.perFrameAlphaAnimation( toAlpha, control, rate )
	local newAlpha = control:GetAlpha();
	if newAlpha == toAlpha then
		return;
	end
	
	if (math.abs(toAlpha - newAlpha) < 0.01) then
		control				:SetAlpha(toAlpha);
	else
		newAlpha = newAlpha + (toAlpha - newAlpha) * rate;
		control				:SetAlpha(newAlpha);
	end
	if newAlpha > 0.0 then
		control				:SetShow(true);
	else
		control				:SetShow(false);
	end
end

function UIAni.perFrameFontAlphaAnimation( toAlpha, control, rate )
	local newAlpha = control:GetFontAlpha();
	if newAlpha == toAlpha then
		return;
	end
	
	if (math.abs(toAlpha - newAlpha) < 0.01) then
		control				:SetFontAlpha(toAlpha);
	else
		newAlpha = newAlpha + (toAlpha - newAlpha) * rate;
		control				:SetFontAlpha(newAlpha);
	end
	if newAlpha > 0.0 then
		control				:SetShow(true);
	else
		control				:SetShow(false);
	end
end



-- 다이얼로그 같이 애니메이션을 끄고 동작시킬 필요가있는 경우 로직에 추가시킨다.
function IsAniUse()
    return not Panel_Npc_Dialog:GetShow()
end