-------------------------------
-- Panel Init
-------------------------------
Panel_Login:SetShow(true, false)
Panel_Login:SetSize( getScreenSizeX(), getScreenSizeY() )
-------------------------------
-- Control Regist & Init
-------------------------------
local _loginBG 				= UI.getChildControl( Panel_Login, "Static_LoginBG" )
local _buttonBG 			= UI.getChildControl( Panel_Login, "Static_ButtonBG" )
local _txt_Guide			= UI.getChildControl( Panel_Login, "StaticText_InputTxt" )
local Button_Login 			= UI.getChildControl( Panel_Login, "Button_Login" )
local Button_Exit 			= UI.getChildControl( Panel_Login, "Button_Exit" )
local Button_GameOption		= UI.getChildControl( Panel_Login, "Button_GameOption_Login" )
local Edit_ID 				= UI.getChildControl( Panel_Login, "Edit_ID" )
local _blackStone			= UI.getChildControl( Panel_Login, "Static_BlackStone" )

local StaticEventBG			= UI.getChildControl( Panel_Login, "Static_EventBG" )
local Static_BI 			= UI.getChildControl( Panel_Login, "Static_BI" )
local Static_Blackline_up 	= UI.getChildControl( Panel_Login, "Static_Blackline_up" )
local Static_Blackline_down = UI.getChildControl( Panel_Login, "Static_Blackline_down" )
local Static_CI 			= UI.getChildControl( Panel_Login, "Static_CI" )
local Static_DaumCI 		= UI.getChildControl( Panel_Login, "Static_DaumCI" )

Button_Login:ActiveMouseEventEffect( true )
Button_Exit:ActiveMouseEventEffect( true )
Button_GameOption:ActiveMouseEventEffect( true )

Button_Login:SetEnable( true )
Button_Exit:SetEnable( true )
Button_GameOption:SetEnable( true )

local screenX = getScreenSizeX()
local screenY = getScreenSizeY()

local bgCount	= 17 -- 이미지 총 장수가 바뀌면 이 곳을 수량만큼 수정한다.
local totalBG	= 18
local bgResizeCount = 17
if isGameTypeKorea() then
	if ToClient_isEventOn('x-mas') then
		bgCount = 18
		bgResizeCount = 18
	else
		bgCount = 17
		bgResizeCount = 17
	end
elseif isGameTypeRussia() then
	bgCount = 10
	bgResizeCount = 16
elseif isGameTypeEnglish() then
	bgCount = 10
	bgResizeCount = 16
elseif isGameTypeJapan() then			-- 일본은 발렌시아까지 오픈했따!
	if ToClient_isEventOn('x-mas') then
		bgCount = 17
		bgResizeCount = 17
	else
		bgCount = 16
		bgResizeCount = 16
	end
	totalBG = 17
else
	bgCount = 10
	bgResizeCount = 16
end

Static_Back	= Array.new()

for ii = 1, totalBG do
	targetControl = UI.getChildControl( Panel_Login, "Static_Back_"..ii )
	targetControl:SetSize(screenX, screenY)
	targetControl:SetPosX(0.0)
	targetControl:SetPosY(0.0)
	targetControl:SetAlpha(0.0)
	Static_Back[ii] = targetControl
end

--if isGameServiceTypeKor() or isGameServiceTypeJp() then
if false == isLoginIDShow() then
	Edit_ID:SetShow(false)
	_loginBG:SetShow(false)
	_txt_Guide:SetShow(false)
else
	-- _blackStone:SetShow( true )
	-- _loginBG:AddEffect( "CO_Empty", true, 0, 0 )
	Edit_ID:SetEditText(getLoginID())
end


-------------------------------
-- 구현부
-------------------------------
function Panel_Login_Enter()
	connectToGame(Edit_ID:GetEditText(), '검은전사비번' )
end

function FGlobal_Panel_Login_Enter()
	Panel_Login_Enter()
end


function LogInPanel_Resize()
	Panel_Login:SetSize( getScreenSizeX(), getScreenSizeY() )

	_loginBG:ComputePos()
	_buttonBG:ComputePos()
	_txt_Guide:ComputePos()
	Button_Login:ComputePos()
	Button_Login:AddEffect( "fUI_PvPButtonLoop", true, 0, 0 )
	Button_Exit:ComputePos()
	Button_GameOption:ComputePos()
	Edit_ID:ComputePos()
	
	for ii = 1, totalBG do
		Static_Back[ii]:SetSize( getScreenSizeX(), getScreenSizeY() )
	end
	
	Static_Blackline_up:SetSize(getScreenSizeX(), getScreenSizeY() * 0.07 )
	Static_Blackline_down:SetSize(getScreenSizeX(), getScreenSizeY() * 0.07)
	Static_CI:SetSpanSize(Static_DaumCI:GetSizeX() + 30, (Static_Blackline_down:GetSizeY() - Static_CI:GetSizeY()) / 2 )
	if isGameTypeRussia() then		-- 아... 정리가... ... 으....
		Static_DaumCI:SetSize(111, 29)
		Static_DaumCI:ChangeTextureInfoName( "new_ui_common_forlua/window/lobby/login_CI_Daum.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( Static_DaumCI, 0, 0, 168, 36 )
		Static_DaumCI:getBaseTexture():setUV(  x1, y1, x2, y2  )
		Static_DaumCI:setRenderTexture(Static_DaumCI:getBaseTexture())
	elseif isGameTypeJapan() then
		Static_DaumCI:SetSize(111, 26)
		Static_DaumCI:ChangeTextureInfoName( "new_ui_common_forlua/window/lobby/login_CI_Daum.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( Static_DaumCI, 0, 0, 111, 26 )
		Static_DaumCI:getBaseTexture():setUV(  x1, y1, x2, y2  )
		Static_DaumCI:setRenderTexture(Static_DaumCI:getBaseTexture())
	elseif isGameTypeEnglish() then
		Static_DaumCI:SetSize(72, 36)
		Static_DaumCI:ChangeTextureInfoName( "new_ui_common_forlua/window/lobby/login_CI_Daum.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( Static_DaumCI, 0, 0, 72, 36 )
		Static_DaumCI:getBaseTexture():setUV(  x1, y1, x2, y2  )
		Static_DaumCI:setRenderTexture(Static_DaumCI:getBaseTexture())
	else
		Static_DaumCI:SetSize(72, 36)
		Static_DaumCI:ChangeTextureInfoName( "new_ui_common_forlua/window/lobby/login_CI_Daum.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( Static_DaumCI, 0, 0, 72, 36 )
		Static_DaumCI:getBaseTexture():setUV(  x1, y1, x2, y2  )
		Static_DaumCI:setRenderTexture(Static_DaumCI:getBaseTexture())
	end
	Static_DaumCI:SetSpanSize(20, (Static_Blackline_down:GetSizeY() - Static_DaumCI:GetSizeY()) / 2 )

	StaticEventBG:SetShow( false )
	local isXmas = ToClient_isEventOn('x-mas')
	if isXmas then
		StaticEventBG:SetShow( true )
	end

	StaticEventBG:ComputePos()
	Static_BI:ComputePos()
	Static_Blackline_up:ComputePos()
	Static_Blackline_down:ComputePos()
	Static_CI:ComputePos()
	Static_DaumCI:ComputePos()

	Static_BI:SetPosY( getScreenSizeY() * 0.14 )
end

local bgImgIndex = 1	-- 시작 배경 이미지 숫자.
if isGameTypeKorea() then
	if ToClient_isEventOn('x-mas') then
		bgImgIndex = 18
	else
		bgImgIndex = 17
	end
elseif isGameTypeRussia() then
	bgImgIndex = 1
elseif isGameTypeJapan() then
	if ToClient_isEventOn('x-mas') then
		bgImgIndex = 17
	else
		bgImgIndex = 16
	end
else
	bgImgIndex = 1
end

local currentBackIndex = bgImgIndex -- getRandomValue(1, bgCount)
local nextBackIndex = currentBackIndex + 1
Static_Back[currentBackIndex]:SetShow( true, true )
Static_Back[currentBackIndex]:SetAlpha(1.0)

local updateTime = 0.0
local isScope = true
local startUV = 0.1
local endUV = startUV + 0.04
local startUV2 = 0.9
local endUV2 = startUV2 + 0.04

function Panel_Login_Update(deltaTime)
	updateTime = updateTime - deltaTime
	if updateTime <= 0.0 then
		updateTime = 15.0
		if isScope then
			isScope = false
			local FadeMaskAni = Static_Back[currentBackIndex]:addTextureUVAnimation (0.0, 15.0, 0 )
		
			FadeMaskAni:SetStartUV ( startUV, startUV, 0 )
			FadeMaskAni:SetEndUV ( endUV, startUV, 0 )

			FadeMaskAni:SetStartUV ( startUV2, startUV, 1 )
			FadeMaskAni:SetEndUV ( endUV2, startUV, 1 )

			FadeMaskAni:SetStartUV ( startUV, startUV2, 2 )
			FadeMaskAni:SetEndUV ( endUV, startUV2, 2 )

			FadeMaskAni:SetStartUV ( startUV2, startUV2, 3 )
			FadeMaskAni:SetEndUV ( endUV2, startUV2, 3 )
		else
			isScope = true
			local FadeMaskAni = Static_Back[currentBackIndex]:addTextureUVAnimation (0.0, 15.0, 0 )
		
			FadeMaskAni:SetEndUV ( startUV, startUV, 0 )
			FadeMaskAni:SetStartUV ( endUV, startUV, 0 )

			FadeMaskAni:SetEndUV ( startUV2, startUV, 1 )
			FadeMaskAni:SetStartUV ( endUV2, startUV, 1 )

			FadeMaskAni:SetEndUV ( startUV, startUV2, 2 )
			FadeMaskAni:SetStartUV ( endUV, startUV2, 2 )

			FadeMaskAni:SetEndUV ( startUV2, startUV2, 3 )
			FadeMaskAni:SetStartUV ( endUV2, startUV2, 3 )
			
			local fadeColor = Static_Back[currentBackIndex]:addColorAnimation( 15.0, 17.0, 0)
			fadeColor:SetStartColor( Defines.Color.C_FFFFFFFF )
			fadeColor:SetEndColor( Defines.Color.C_00FFFFFF )
			
			if bgCount < nextBackIndex then
				nextBackIndex = getRandomValue(1, bgCount)
			end

			local baseTexture = Static_Back[nextBackIndex]:getBaseTexture()
			baseTexture:setUV(startUV, startUV, startUV2, startUV2)
			Static_Back[nextBackIndex]:setRenderTexture(baseTexture)
			local fadeColor2 = Static_Back[nextBackIndex]:addColorAnimation( 12.0, 15.0, 0)
			fadeColor2:SetStartColor( Defines.Color.C_00FFFFFF )
			fadeColor2:SetEndColor( Defines.Color.C_FFFFFFFF )
			
			currentBackIndex = nextBackIndex
			if bgCount <= nextBackIndex then
				nextBackIndex = bgImgIndex
			else
				nextBackIndex = getRandomValue(1, bgCount) -- 앞 인자는 무조건 1부터 시작해야한다.
			end
		end
	end
end

function Panel_Login_ButtonDisable( bool )
	if true == bool then
		Button_Login:SetEnable( false )
		Button_Login:SetMonoTone( true )
		Button_Login:SetIgnore( true )
		Button_Exit:SetEnable( false )
		Button_Exit:SetMonoTone( true )
		Button_Exit:SetIgnore( true )
		Button_GameOption:SetEnable( false )
		Button_GameOption:SetMonoTone( true )
		Button_GameOption:SetIgnore( true )
		
	else
		Button_Login:SetEnable( true )
		Button_Login:SetMonoTone( false )
		Button_Login:SetIgnore( false )
		Button_Exit:SetEnable( true )
		Button_Exit:SetMonoTone( false )
		Button_Exit:SetIgnore( false )
		Button_GameOption:SetEnable( true )
		Button_GameOption:SetMonoTone( false )
		Button_GameOption:SetIgnore( false )
	end
end

function Panel_Login_BeforOpen()
	local serviceType = getGameServiceType()
	if isGameTypeKorea() and 1 ~= serviceType then	-- 한국이고 개발이 아닐경우
		FGlobal_TermsofGameUse_Open()
	else
		Panel_Login_Enter()
	end
end

Panel_Login:RegisterUpdateFunc("Panel_Login_Update")

Button_Login:addInputEvent("Mouse_LUp", "Panel_Login_BeforOpen()")
Button_Exit:addInputEvent("Mouse_LUp", "GlobalExitGameClient()")
Button_GameOption:addInputEvent("Mouse_LUp", "showGameOption()")

registerEvent( "onScreenResize", "LogInPanel_Resize" )
LogInPanel_Resize()
