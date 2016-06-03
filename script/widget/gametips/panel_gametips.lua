Panel_GameTips:ActiveMouseEventEffect( true )
Panel_GameTips:setGlassBackground( true )
Panel_GameTips:SetShow( true )

Panel_GameTipMask:setMaskingChild( true )
Panel_GameTipMask:SetShow( true )
Panel_GameTips:SetDragEnable(false)

local msgCount = 319	-- 엑셀 관련 컬럼 마지막 번호를 넣습니다.
local MessageData = {}

function gameTip_setMessageData()
	for idx = 1, msgCount do
		MessageData[idx] = PAGetString(Defines.StringSheet_GAME, "LUA_GAMETIPS_MESSAGE" .. idx)
	end
end
gameTip_setMessageData()


local gameTips_Message = {
		UI.getChildControl( Panel_GameTipMask, "StaticText_GameTips_Content1" ),
		UI.getChildControl( Panel_GameTipMask, "StaticText_GameTips_Content2" ),
		UI.getChildControl( Panel_GameTipMask, "StaticText_GameTips_Content3" ),
	}
	gameTips_Message[1]:SetText( MessageData[1] )
	gameTips_Message[2]:SetText( MessageData[1] )
	gameTips_Message[3]:SetText( MessageData[1] )
local gameTipsBG		= UI.getChildControl( Panel_GameTips, "Static_GameTipsBG" )

local elapsedTime		= 0
local nowPlayingIndex	= 1
local textIndex			= 1

local const = {
	textChangeTime = 60,
	controlCount = #gameTips_Message,
	textOffset = 100,
	fixStartPosX = 100,
}

function gameTip_init()
	for i=1, #gameTips_Message do
		gameTips_Message[i]:SetIgnore(true)
	end
	Panel_GameTipMask:addInputEvent( "Mouse_LUp", "FGlobal_GameTipsShow()" )
end

function gameTip_aniPlay( deltaTime )
	local firstControl = gameTips_Message[ nowPlayingIndex ]
	local posX = firstControl:GetPosX()
	posX = posX - (const.fixStartPosX / 3) * deltaTime

	for index = 0, const.controlCount -1 do
		local targetControl = gameTips_Message[ ( nowPlayingIndex + index -1 ) % const.controlCount + 1]
		targetControl:SetPosX( posX )
		posX = posX + targetControl:GetTextSizeX() + const.textOffset
	end

	if ( firstControl:GetPosX() + firstControl:GetTextSizeX() < 0 ) then
		firstControl:SetText(MessageData[textIndex])
		nowPlayingIndex = (nowPlayingIndex % const.controlCount) + 1
	end
end

function GameTips_MessageUpdate( deltaTime )
	if not Panel_GameTips:GetShow() then
		return
	end

	elapsedTime = elapsedTime + deltaTime;					-- 애니메이션 타임과 메모리용 타이머를 비교하기 위한 변수
	if ( const.textChangeTime < elapsedTime )	then
		elapsedTime = elapsedTime - const.textChangeTime
		textIndex =( textIndex % #MessageData ) + 1
	end
	gameTip_aniPlay( deltaTime )
end

function GameTips_Reposition()
	Panel_GameTips:SetPosX( 4 )
	Panel_GameTips:SetPosY( getScreenSizeY() - Panel_GameTips:GetSizeY() + 12 )
	Panel_GameTipMask:SetPosX( 30 )
	Panel_GameTipMask:SetPosY( getScreenSizeY() - Panel_GameTipMask:GetSizeY() - 8 )
end

function GameTips_Show()
	Panel_GameTips:SetShow( true )
	Panel_GameTipMask:SetShow( true )
end
function GameTips_Hide()
	Panel_GameTips:SetShow( false )
	Panel_GameTipMask:SetShow( false )
end

gameTip_init()
GameTips_Reposition()
-- FGlobal_GameTip_ShowToggle( isCheck_GameTip() )
registerEvent( "onScreenResize", "GameTips_Reposition" )


changePositionBySever(Panel_GameTips, CppEnums.PAGameUIType.PAGameUIPanel_GameTips, true, false, false)
changePositionBySever(Panel_GameTipMask, CppEnums.PAGameUIType.PAGameUIPanel_GameTips, true, false, false)