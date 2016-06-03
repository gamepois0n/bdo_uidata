-------------------------------
-- Panel Init
-------------------------------
Panel_Loading:SetShow(true, false)

-------------------------------
-- local Vars
-------------------------------
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_TM = CppEnums.TextMode

local _currentTime = 10000		-- Update Time 인 5.7 보다 큰 값이면, 아무 값이나 상관 없다.
local _isStartLoading = false

local screenX = nil
local screenY = nil

-------------------------------
-- Control Regist & Init
-------------------------------

local _bg1			= UI.getChildControl( Panel_Loading, "Static_BG_1" )
local _bg2			= UI.getChildControl( Panel_Loading, "Static_BG_2" )

local _regionName	= UI.getChildControl( Panel_Loading, "StaticText_RegionName" );

local _knowledge_Image 	= UI.getChildControl ( Panel_Loading, "Static_knowImage" )
local _knowledge_title 	= UI.getChildControl ( Panel_Loading, "StaticText_knowTitle" )
local _knowledge_desc	= UI.getChildControl ( Panel_Loading, "StaticText_knowDesc" )

local progressRate		= UI.getChildControl( Panel_Loading, "Progress2_Loading" )
local progressHead		= UI.getChildControl( progressRate, "Progress2_Bar_Head" )
local staticBack			= UI.getChildControl( Panel_Loading, "Static_Progress_Back" )
local goblinRun			= UI.getChildControl( Panel_Loading, "Static_GoblinRun" )


local UI_color = Defines.Color
progressRate:SetCurrentProgressRate(0)		-- 프로그레스 바 0%로 만들기

_knowLedge_TitleSizeX = 0
-- ToClient_isEventOn('x-mas')

-------------------------------
-- 구현부
-------------------------------
function LoadingPanel_Resize()
	screenX = getScreenSizeX()
	screenY = getScreenSizeY()
	
	Panel_Loading:SetSize(screenX, screenY)
	
	_bg1:SetSize( screenX, screenY)
	_bg1:ComputePos()
	-- _bg1:SetShow(true)
	
	_bg2:SetSize( screenX, screenY)
	_bg2:SetSize( 1, 1)
	_bg2:ComputePos()
	-- _bg2:SetShow(true)
	
	progressRate:SetSize( screenX * 0.8, progressRate:GetSizeY() )
	progressRate:ComputePos()

	staticBack:SetSize( screenX * 0.8, staticBack:GetSizeY() )
	staticBack:ComputePos()
end

function LoadingPanel_Init()

	progressRate:SetCurrentProgressRate(0)		-- 프로그레스 바 0%로 만들기
	local progressRateX = progressRate:GetPosX()
	local progressRateY = progressRate:GetPosY()
	local progressHeadX = progressHead:GetPosX()
	local progressHeadY = progressHead:GetPosY()
	
	goblinRun:SetPosX( progressRateX + progressHeadX + progressHead:GetSizeX() )
	goblinRun:SetPosY( progressRateY + progressHeadY + 25 )

	local isXmas	= ToClient_isEventOn('x-mas')
	local isEaster	= ToClient_isEventOn('Easter')
	if isXmas then
		goblinRun:ChangeTextureInfoName("New_UI_Common_ForLua/Default/goblrun2.dds" )
	elseif isEaster then
		goblinRun:ChangeTextureInfoName("New_UI_Common_ForLua/Default/EN_easter.dds" )
	else
		goblinRun:ChangeTextureInfoName("new_ui_common_forlua/default/goblrun.dds" )
	end
end
function LoadingPanel_SetProgress(rate)
	progressRate:SetProgressRate(rate)
	local progressRateX = progressRate:GetPosX()
	local progressRateY = progressRate:GetPosY()
	local progressHeadX = progressHead:GetPosX()
	local progressHeadY = progressHead:GetPosY()
	
	--UI.debugMessage("X" .. progressHeadX .." / Y" .. progressHeadY )
	goblinRun:SetPosX( progressRateX + progressHeadX + progressHead:GetSizeX() )
	goblinRun:SetPosY( progressRateY + progressHeadY + 25 )
end

function LoadingPanel_SetRegionName()
	local cameraPosition = getWorldMapCameraLookAt();
	_regionName:SetText(getRegionNameByPosition(cameraPosition));
end

local LoadingPanel_PlayKnowledgeAni = function()
 _bg1:SetShow(true)
 _bg2:SetShow(true)

	-- 이동 애니메이션
	local ImageMoveAni = _knowledge_Image:addMoveAnimation( 0.0, 1.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	ImageMoveAni:SetStartPosition( (screenX / 2) - 200, (screenY / 2) - 350 )
	ImageMoveAni:SetEndPosition( (screenX / 2) - 200, (screenY / 2) - 400 )
	ImageMoveAni.IsChangeChild = true
	_knowledge_Image:CalcUIAniPos(ImageMoveAni)

	local knowTitleMoveAni = _knowledge_title:addMoveAnimation( 0.0, 1.65, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	knowTitleMoveAni:SetStartPosition( (screenX / 2) - ( _knowLedge_TitleSizeX / 2 ), (screenY / 2) - 50 )
	knowTitleMoveAni:SetEndPosition( (screenX / 2) - ( _knowLedge_TitleSizeX / 2 ), (screenY / 2) + 20 )
	knowTitleMoveAni.IsChangeChild = true
	_knowledge_title:CalcUIAniPos(knowTitleMoveAni)

	local knowDescMoveAni = _knowledge_desc:addMoveAnimation( 0.0, 1.75, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	knowDescMoveAni:SetStartPosition( (screenX / 2) - 300, (screenY / 2) - 25 )
	knowDescMoveAni:SetEndPosition( (screenX / 2) - 300, (screenY / 2) + 50 )
	knowDescMoveAni.IsChangeChild = true
	_knowledge_desc:CalcUIAniPos(knowDescMoveAni)


	-- 알파 애니메이션1
	local ImageAni = _knowledge_Image:addColorAnimation( 0.0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	ImageAni:SetStartColor( UI_color.C_00FFFFFF )
	ImageAni:SetEndColor( UI_color.C_00FFFFFF )
	ImageAni.IsChangeChild = true

	local knowTitleAni = _knowledge_title:addColorAnimation( 0.0, 0.35, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	knowTitleAni:SetStartColor( UI_color.C_00FFFFFF )
	knowTitleAni:SetEndColor( UI_color.C_00FFFFFF )
	knowTitleAni.IsChangeChild = true

	local knowDescAni = _knowledge_desc:addColorAnimation( 0.0, 0.45, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	knowDescAni:SetStartColor( UI_color.C_00FFFFFF )
	knowDescAni:SetEndColor( UI_color.C_00FFFFFF )
	knowDescAni.IsChangeChild = true

	-- 알파 애니메이션2
	local ImageAni = _knowledge_Image:addColorAnimation( 0.25, 0.85, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	ImageAni:SetStartColor( UI_color.C_00FFFFFF )
	ImageAni:SetEndColor( UI_color.C_FFFFFFFF )
	ImageAni.IsChangeChild = true

	local knowTitleAni = _knowledge_title:addColorAnimation( 0.35, 0.95, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	knowTitleAni:SetStartColor( UI_color.C_00FFFFFF )
	knowTitleAni:SetEndColor( UI_color.C_FFFFFFFF )
	knowTitleAni.IsChangeChild = true

	local knowDescAni = _knowledge_desc:addColorAnimation( 0.45, 1.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	knowDescAni:SetStartColor( UI_color.C_00FFFFFF )
	knowDescAni:SetEndColor( UI_color.C_FFFFFFFF )
	knowDescAni.IsChangeChild = true

	-- 알파 애니메이션3
	local ImageAni = _knowledge_Image:addColorAnimation( 7.0, 7.65, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	ImageAni:SetStartColor( UI_color.C_FFFFFFFF )
	ImageAni:SetEndColor( UI_color.C_00FFFFFF )
	ImageAni.IsChangeChild = true

	local knowTitleAni = _knowledge_title:addColorAnimation( 7.0, 7.75, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	knowTitleAni:SetStartColor( UI_color.C_FFFFFFFF )
	knowTitleAni:SetEndColor( UI_color.C_00FFFFFF )
	knowTitleAni.IsChangeChild = true

	local knowDescAni = _knowledge_desc:addColorAnimation( 7.0, 7.85, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	knowDescAni:SetStartColor( UI_color.C_FFFFFFFF )
	knowDescAni:SetEndColor( UI_color.C_00FFFFFF )
	knowDescAni.IsChangeChild = true
end

local LoadingPanel_GetRandomKnowledge = function()
	local mentalCardData = RequestIntimacy_getRandomKnowledge()

	if(nil ~= mentalCardData) then
		_knowledge_Image:SetShow(true, false)
		_knowledge_title:SetShow(true, false)
		_knowledge_desc:SetShow(true, false)
		
		local screenX = getScreenSizeX()

		_knowledge_Image:ChangeTextureInfoName( mentalCardData:getPicture() )
		_knowledge_title:SetText( mentalCardData:getName() )
		_knowLedge_TitleSizeX = _knowledge_title:GetTextSizeX()

		_knowledge_desc:SetTextMode( UI_TM.eTextMode_AutoWrap )
		_knowledge_desc:SetText( mentalCardData:getDesc() )

		LoadingPanel_PlayKnowledgeAni()
	end
end

function LoadingPanel_UpdatePerFrame( deltaTime )
	_currentTime = _currentTime + deltaTime
	if ( 8.0 < _currentTime ) then
		_currentTime = 0
		LoadingPanel_GetRandomKnowledge()
	end
end

registerEvent( "EventMapLoadProgress", "LoadingPanel_SetProgress" )
registerEvent( "onScreenResize", "LoadingPanel_Resize" )
Panel_Loading:RegisterUpdateFunc( "LoadingPanel_UpdatePerFrame" )
LoadingPanel_Resize()
