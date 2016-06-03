local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color

------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------

Panel_ClassResource:RegisterShowEventFunc( true, 'ClassResource_ShowAni()' )
Panel_ClassResource:RegisterShowEventFunc( false, 'ClassResource_HideAni()' )
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------

local resourceText = UI.getChildControl ( Panel_ClassResource, "StaticText_ResourceText" )
local resourceValue = UI.getChildControl ( Panel_ClassResource, "StaticText_Count" )

local phantomPopMSG = UI.getChildControl (Panel_ClassResource, "StaticText_PhantomPopHelp" )

Panel_ClassResource:SetShow(false)

Panel_ClassResource:addInputEvent( "Mouse_On", "ClassResource_ChangeTexture_On()" )
Panel_ClassResource:addInputEvent( "Mouse_Out", "ClassResource_ChangeTexture_Off()" )

-- 팬텀 카운트 관련 정의
local _phantomCount_Icon = UI.getChildControl ( Panel_ClassResource, "Static_BlackStone" )
local _phantomCount_HelpText_Box = UI.getChildControl ( Panel_ClassResource, "StaticText_PhantomHelp")
local _phantom_Effect_1stChk = false	-- 팬텀 아이콘 이팩트 1 활성 여부를 위한 변수
local _phantom_Effect_2ndChk = false	-- 팬텀 아이콘 이팩트 2 활성 여부를 위한 변수
local _phantom_Effect_3rdChk = false	-- 팬텀 아이콘 이팩트 3 활성 여부를 위한 변수
_phantomCount_Icon:addInputEvent( "Mouse_On", "PhantomCount_HelpComment( true )" )
_phantomCount_Icon:addInputEvent( "Mouse_Out", "PhantomCount_HelpComment( false )" )
-- 팬텀 카운트 관련 정의 end

local init = function()
	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		Panel_ClassResource:SetShow(false)
		return
	end

	local classType = selfPlayer:getClassType()
	if CppEnums.ClassType.ClassType_Sorcerer == classType then
		local phantomCount = selfPlayer:get():getSubResourcePoint()
		Panel_ClassResource:SetShow(true)
		resourceValue:SetText("X "..phantomCount)
		-- Panel_Adrenallin:SetPosX( Panel_ClassResource:GetPosX() + 55 )  -- 소서러이기 때문에 아드레날린 패널을 팬텀 아이콘 우측으로 밀었음.
	else
		Panel_ClassResource:SetShow(false)
	end
end

function PhantomCount_HelpComment( _isShowPhantomHelp )		-- 팬텀 카운트 도움말
	if ( _isShowPhantomHelp == true ) then
		_phantomCount_Message = PAGetString(Defines.StringSheet_GAME, "LUA_PHANTOMCOUNT_MESSAGE")	-- StringTable\StringTable_KR.xlsm에 GAME 탭 LUA_PHANTOMCOUNT_MESSAGE 값을 불러온다.
		Panel_ClassResource:SetChildIndex(_phantomCount_HelpText_Box, 9999)
		_phantomCount_HelpText_Box:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
		_phantomCount_HelpText_Box:SetAutoResize( true )
		_phantomCount_HelpText_Box:SetText(_phantomCount_Message)
		_phantomCount_HelpText_Box:SetPosX(getMousePosX() - Panel_ClassResource:GetPosX() - 70)		-- 툴팁 위치 보정
		_phantomCount_HelpText_Box:SetPosY(getMousePosY() - Panel_ClassResource:GetPosY() - 90)
		_phantomCount_HelpText_Box:ComputePos()
		_phantomCount_HelpText_Box:SetSize( _phantomCount_HelpText_Box:GetSizeX(), _phantomCount_HelpText_Box:GetSizeY() )
		_phantomCount_HelpText_Box:SetAlpha(0)
		_phantomCount_HelpText_Box:SetFontAlpha(0)
		UIAni.AlphaAnimation( 1, _phantomCount_HelpText_Box, 0.0, 0.2 )						-- 등장 애니메이션.
		_phantomCount_HelpText_Box:SetShow(true)
	else
		local aniInfo = UIAni.AlphaAnimation( 0, _phantomCount_HelpText_Box, 0.0, 0.2 )				-- 사라지는 애니메이션
		aniInfo:SetHideAtEnd(true)
	end
end

function ClassResource_ChangeTexture_On()
	-- ♬ 마우스 올렸을 때 사운드 추가
	audioPostEvent_SystemUi(00,10)
	Panel_ClassResource:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_drag.dds")
	resourceText:SetText ( PAGetString(Defines.StringSheet_GAME, "LUA_PVPMODE_UI_MOVE") )	--"PVP 활성화\n드래그해서 옮기세요.")
end
function ClassResource_ChangeTexture_Off()
	-- ♬ 마우스 뺐을 때 사운드 추가
	if Panel_UIControl:IsShow() then
		Panel_ClassResource:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_isWidget.dds")
		resourceText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_PVPMODE_UI") )	-- "PVP 활성화"
	else
		Panel_ClassResource:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_empty.dds")
	end
end

-- 켜주는 애니
function ClassResource_ShowAni()
	Panel_ClassResource:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_IN)
	local ClassResourceOpen_Alpha = Panel_ClassResource:addColorAnimation( 0.0, 0.6, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	ClassResourceOpen_Alpha:SetStartColor( UI_color.C_00FFFFFF )
	ClassResourceOpen_Alpha:SetEndColor( UI_color.C_FFFFFFFF )
	ClassResourceOpen_Alpha.IsChangeChild = true
end

-- 꺼주는 애니
function ClassResource_HideAni()
	Panel_ClassResource:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
	local ClassResourceClose_Alpha = Panel_ClassResource:addColorAnimation( 0.0, 0.6, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	ClassResourceClose_Alpha:SetStartColor( UI_color.C_FFFFFFFF )
	ClassResourceClose_Alpha:SetEndColor( UI_color.C_00FFFFFF )
	ClassResourceClose_Alpha.IsChangeChild = true
	ClassResourceClose_Alpha:SetHideAtEnd(true)
	ClassResourceClose_Alpha:SetDisableWhileAni(true)
end


function ClassResource_Update()
	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		return
	end

	local playerMp = selfPlayer:get():getMp()
	local playerMaxMp = selfPlayer:get():getMaxMp()

	local playerMpRate = (playerMp / playerMaxMp) * 100

 	local phantomCount = selfPlayer:get():getSubResourcePoint()
	resourceValue:SetText("X "..phantomCount)					-- 카운트 적용

	if (phantomCount >= 10 and phantomCount <= 19) and _phantom_Effect_1stChk == false then
		_phantomCount_Icon:EraseAllEffect()
		_phantomCount_Icon:AddEffect( "UI_Button_Hide", false, 0, 0 )
		_phantom_Effect_1stChk = true
		_phantom_Effect_2ndChk = false
		_phantom_Effect_3rdChk = false
	
	elseif (phantomCount >= 20 and phantomCount <= 29) and _phantom_Effect_2ndChk == false then
		_phantomCount_Icon:EraseAllEffect()
		_phantomCount_Icon:AddEffect( "UI_Button_Hide", false, 0, 0 )
		_phantom_Effect_1stChk = false
		_phantom_Effect_2ndChk = true
		_phantom_Effect_3rdChk = false
	
	elseif (phantomCount == 30) and _phantom_Effect_3rdChk == false then
		_phantomCount_Icon:EraseAllEffect()
		_phantomCount_Icon:AddEffect( "UI_Button_Hide", false, 0, 0 )
		_phantom_Effect_1stChk = false
		_phantom_Effect_2ndChk = false
		_phantom_Effect_3rdChk = true
	
	elseif phantomCount == 0 then
		_phantomCount_Icon:EraseAllEffect()
		_phantom_Effect_1stChk = false
		_phantom_Effect_2ndChk = false
		_phantom_Effect_3rdChk = false
	end

	if 10 <= phantomCount and playerMpRate < 20 then
		phantomPopMSG:SetShow( true )
		phantomPopMSG:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_CLASSRESOURCE_PHANTOMPOPMSG") ) -- "어둠의 조각을 흡수하여\n정신력을 회복하세요.(Q)" )
	else
		phantomPopMSG:SetShow( false )
	end
end

-- Panel_ClassResource:SetPosX( Panel_MainStatus_User_Bar:GetPosX() )
-- Panel_ClassResource:SetPosY( Panel_MainStatus_User_Bar:GetPosY() - _phantomCount_Icon:GetSizeY() )

function Panel_ClassResource_EnableSimpleUI()
	Panel_ClassResource_SetAlphaAllChild( Panel_MainStatus_User_Bar:GetAlpha() );
end
function Panel_ClassResource_DisableSimpleUI()
	Panel_ClassResource_SetAlphaAllChild( 1.0 );
end
function Panel_ClassResource_UpdateSimpleUI( fDeltaTime )
	Panel_ClassResource_SetAlphaAllChild( Panel_MainStatus_User_Bar:GetAlpha() );
end
function Panel_ClassResource_SetAlphaAllChild( alphaValue )
	resourceText				:SetFontAlpha( alphaValue );
	resourceValue				:SetFontAlpha( alphaValue );
	_phantomCount_Icon			:SetAlpha( alphaValue );
	_phantomCount_HelpText_Box	:SetAlpha( alphaValue );
end
registerEvent( "SimpleUI_UpdatePerFrame",		"Panel_ClassResource_UpdateSimpleUI")
registerEvent( "EventSimpleUIEnable",			"Panel_ClassResource_EnableSimpleUI")
registerEvent( "EventSimpleUIDisable",			"Panel_ClassResource_DisableSimpleUI")
registerEvent("FromClient_SelfPlayerMpChanged",	"ClassResource_Update")

function Phantom_Locate()
	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		return
	end

	if isFlushedUI() then
		return
	end
	
	Panel_ClassResource:SetPosX( Panel_MainStatus_User_Bar:GetPosX() + (_phantomCount_Icon:GetSizeX()) -5 )
	Panel_ClassResource:SetPosY( Panel_MainStatus_User_Bar:GetPosY() - (_phantomCount_Icon:GetSizeY()) +5 )
	
	changePositionBySever(Panel_ClassResource, CppEnums.PAGameUIType.PAGameUIPanel_ClassResource, true, true, false)
	init() -- changePositionBySever에서 위치를 저장시키기 때문에 그 후에 별도로 켜줄지 말지 체크해야한다.
end

function Phantom_Resize()
	Panel_ClassResource:SetPosX( Panel_MainStatus_User_Bar:GetPosX() + (_phantomCount_Icon:GetSizeX()) -5 )
	Panel_ClassResource:SetPosY( Panel_MainStatus_User_Bar:GetPosY() - (_phantomCount_Icon:GetSizeY()) +5 )
	
	changePositionBySever(Panel_ClassResource, CppEnums.PAGameUIType.PAGameUIPanel_ClassResource, true, true, false)
	init()
end

function Panel_ClassResource_ShowToggle()
	if Panel_ClassResource:IsShow() then
		Panel_ClassResource:SetShow( false )
	else
		Panel_ClassResource:SetShow( true )
	end
end

UI.addRunPostRestorFunction( Phantom_Locate )

init()
Phantom_Locate()

registerEvent(	"subResourceChanged",			"ClassResource_Update")
registerEvent(	"EventPlayerPvPAbleChanged",	"Phantom_Locate")
registerEvent(	"onScreenResize",				"Phantom_Resize" )

Panel_ClassResource:addInputEvent( "Mouse_LUp", "ResetPos_WidgetButton()" )