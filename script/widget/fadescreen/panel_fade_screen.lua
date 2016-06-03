---------------------------
-- Panel Init
---------------------------
Panel_Fade_Screen:SetPosX( 0 )
Panel_Fade_Screen:SetPosY( 0 )
Panel_Fade_Screen:SetShow(false, false)
Panel_Fade_Screen:SetSize( getScreenSizeX(), getScreenSizeY() )
Panel_Fade_Screen:SetIgnore(true)
--Panel_Fade_Screen:SetSize( 100, 100 )

---------------------------
-- Local Variables
---------------------------
local lua_StaticText_FieldName = UI.getChildControl(Panel_Fade_Screen, "StaticText_FieldName")

local FieldNamePostionY = 0
local FieldNamePositionHalf = getScreenSizeY()

FieldNamePositionHalf = FieldNamePositionHalf / 4
lua_StaticText_FieldName:SetHorizonCenter()
lua_StaticText_FieldName:SetShow(false)
lua_StaticText_FieldName:SetSpanSize( 0, FieldNamePositionHalf )

local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color

---------------------------
-- Functions
---------------------------
function startFadeIn(strFieldName)
		-- 사운드 추가 필요
		Panel_Fade_Screen:SetShow(true, false)
		Panel_Fade_Screen:SetColor(UI_color.C_FFFFFFFF)

		if strFieldName ~= nil then
		
			lua_StaticText_FieldName:SetShow(true)		-- 여긴 위에 필요없는 부분을 지우면 넣어 줘야 한다.
			lua_StaticText_FieldName:SetText(strFieldName)
			lua_StaticText_FieldName:SetFontColor(UI_color.C_00FFFFFF)
			local aniText = lua_StaticText_FieldName:addColorAnimation( 1, 2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
			aniText:SetStartColor( UI_color.C_00FFFFFF )
			aniText:SetEndColor( UI_color.C_FFFFFFFF )

			local aniText2 = lua_StaticText_FieldName:addColorAnimation( 5, 6, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
			aniText2:SetStartColor( UI_color.C_FFFFFFFF )
			aniText2:SetEndColor( UI_color.C_00FFFFFF )

			local aniInfoFadeOut = Panel_Fade_Screen:addColorAnimation( 6, 8, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
			aniInfoFadeOut:SetStartColor( UI_color.C_FFFFFFFF )
			aniInfoFadeOut:SetEndColor( 0 )
		else
			lua_StaticText_FieldName:SetShow(false)
			local aniInfoFadeOut = Panel_Fade_Screen:addColorAnimation( 1, 4, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
			aniInfoFadeOut:SetStartColor( UI_color.C_FFFFFFFF )
			aniInfoFadeOut:SetEndColor( 0 )
		end
end

function EventFadeInResize()
	Panel_Fade_Screen:SetSize( getScreenSizeX(), getScreenSizeY() )
	local FieldNamePositionHalf = getScreenSizeY()

	FieldNamePositionHalf = FieldNamePositionHalf / 4
	lua_StaticText_FieldName:SetHorizonCenter()
	lua_StaticText_FieldName:SetShow(false)
	lua_StaticText_FieldName:SetSpanSize( 0, FieldNamePositionHalf )
end

registerEvent( "onScreenResize", "EventFadeInResize" )
registerEvent("EventStartFadeIn", "startFadeIn()")
