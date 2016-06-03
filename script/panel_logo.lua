-------------------------------
-- Panel Init
-------------------------------
Panel_Logo:SetShow(true, false)

Panel_Logo:SetSize(getScreenSizeX(), getScreenSizeY())

-------------------------------
-- Control Regist & Init
-------------------------------
local static_PearlAbyss		= UI.getChildControl ( Panel_Logo, "Static_Pearl" )
local static_Daum			= UI.getChildControl ( Panel_Logo, "Static_Daum" )
local static_Grade			= UI.getChildControl ( Panel_Logo, "Static_Grade" )
local staticText_Warning	= UI.getChildControl ( Panel_Logo, "MultilineText_Warning" )
local static_Movie			= nil

function Panel_Logo_Init()
	if isGameTypeKorea() then
		static_Grade:SetSize( 311, 121 )
		static_Grade:ChangeTextureInfoName( "GameGradeIcon18.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( static_Grade, 0, 0, 311, 121 )
		static_Grade:getBaseTexture():setUV( x1, y1, x2, y2 )
		static_Grade:setRenderTexture(static_Grade:getBaseTexture())
	elseif isGameTypeEnglish() then
		static_Grade:SetSize( 317, 122 )
		static_Grade:ChangeTextureInfoName( "GameGradeIcon18.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( static_Grade, 0, 0, 317, 122 )
		static_Grade:getBaseTexture():setUV( x1, y1, x2, y2 )
		static_Grade:setRenderTexture(static_Grade:getBaseTexture())
	else
		static_Grade:SetSize( 311, 121 )
		static_Grade:ChangeTextureInfoName( "GameGradeIcon18.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( static_Grade, 0, 0, 311, 121 )
		static_Grade:getBaseTexture():setUV( x1, y1, x2, y2 )
		static_Grade:setRenderTexture(static_Grade:getBaseTexture())
	end
end
Panel_Logo_Init()

Panel_Logo:ComputePos()
static_PearlAbyss:ComputePos()
static_Daum:ComputePos()
static_Grade:ComputePos()
staticText_Warning:ComputePos()
staticText_Warning:SetFontAlpha(0.0)


local startAniTime = 2.0
-- local aniInfo1 = static_Daum:addColorAnimation( startAniTime, startAniTime + 2.0, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
-- aniInfo1:SetStartColor( Defines.Color.C_FFFFFFFF )		-- 0x00FFFFFF
-- aniInfo1:SetEndColor( Defines.Color.C_00FFFFFF )		-- 0x00FFFFFF

-- local aniInfo2 = static_PearlAbyss:addColorAnimation( startAniTime + 2.0, startAniTime + 4.0, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
-- aniInfo2:SetStartColor( Defines.Color.C_00FFFFFF )		-- 0x00FFFFFF
-- aniInfo2:SetEndColor( Defines.Color.C_FFFFFFFF )		-- 0x00FFFFFF
if getGameServiceType() == 1 or getGameServiceType() == 2 or getGameServiceType() == 3 or getGameServiceType() == 4 then
	local aniInfo1 = static_PearlAbyss:addColorAnimation( startAniTime + 4.0, startAniTime + 8.0, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartColor( Defines.Color.C_FFFFFFFF )		-- 0x00FFFFFF
	aniInfo1:SetEndColor( Defines.Color.C_00FFFFFF )		-- 0x00FFFFFF

---------------------------------------------------------------------------------

	local aniInfo2 = static_Grade:addColorAnimation( startAniTime + 8.0, startAniTime + 10.0, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartColor( Defines.Color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo2:SetEndColor( Defines.Color.C_FFFFFFFF )		-- 0x00FFFFFF

	local aniInfo3 = staticText_Warning:addColorAnimation( startAniTime + 8.0, startAniTime + 10.0, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo3:SetStartColor( Defines.Color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo3:SetEndColor( Defines.Color.C_FFFFFFFF )		-- 0x00FFFFFF
	aniInfo3.IsChangeChild = true

	local aniInfo4 = static_Grade:addColorAnimation( startAniTime + 13.0, startAniTime + 15.0, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo4:SetStartColor( Defines.Color.C_FFFFFFFF )		-- 0x00FFFFFF
	aniInfo4:SetEndColor( Defines.Color.C_00FFFFFF )		-- 0x00FFFFFF

	local aniInfo5 = staticText_Warning:addColorAnimation( startAniTime + 13.0, startAniTime + 15.0, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo5:SetStartColor( Defines.Color.C_FFFFFFFF )		-- 0x00FFFFFF
	aniInfo5:SetEndColor( Defines.Color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo5.IsChangeChild = true
elseif isGameTypeEnglish() then
	local aniInfo1 = static_PearlAbyss:addColorAnimation( startAniTime + 4.0, startAniTime + 15.0, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartColor( Defines.Color.C_FFFFFFFF )		-- 0x00FFFFFF
	aniInfo1:SetEndColor( Defines.Color.C_00FFFFFF )		-- 0x00FFFFFF

	local aniInfo2 = static_Grade:addColorAnimation( startAniTime + 4.0, startAniTime + 15.0, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartColor( Defines.Color.C_FFFFFFFF )		-- 0x00FFFFFF
	aniInfo2:SetEndColor( Defines.Color.C_00FFFFFF )		-- 0x00FFFFFF	
else
	local aniInfo1 = static_PearlAbyss:addColorAnimation( startAniTime + 4.0, startAniTime + 15.0, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartColor( Defines.Color.C_FFFFFFFF )		-- 0x00FFFFFF
	aniInfo1:SetEndColor( Defines.Color.C_00FFFFFF )		-- 0x00FFFFFF
end

--테스트 코드
local updateTime = 0.0
local isPlaying = false;

function Panel_Logo_Update(deltaTime)
	updateTime = updateTime + deltaTime
	if 2 < updateTime then
		if static_Movie == nil then
			static_Movie			= UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_Logo, 'WebControl_Movie')
			local sizeX = getScreenSizeX()
			local sizeY = getScreenSizeY()
			static_Movie:SetIgnore(true)
			static_Movie:SetPosX(-8.0)
			static_Movie:SetPosY(-8.0)
			static_Movie:SetSize(sizeX + 34, sizeY + 19)
			--static_Movie:SetUrl(1280, 720, "http://google.co.kr")
			static_Movie:SetUrl(1280, 720, "coui://UI_Movie/Introl_Movie.html")
			isPlaying = true
		end
	end
	
	if 3 < updateTime then
		if static_Movie ~= nil then
			static_Movie:ResetUrl()
			static_Movie:SetShow(false)
		end
	end
end

--Panel_Logo:RegisterUpdateFunc("Panel_Logo_Update")