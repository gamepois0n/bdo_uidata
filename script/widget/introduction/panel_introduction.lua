local UI_Color		= Defines.Color
local UI_PP 		= CppEnums.PAUIMB_PRIORITY
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_TM 		= CppEnums.TextMode

local tooltip =
{
	_bg		= UI.getChildControl( Panel_Introduction,	"Static_TooltipBG" ),
	_name	= UI.getChildControl( Panel_Introduction,	"Tooltip_Name" ),
	_desc	= UI.getChildControl( Panel_Introduction,	"Tooltip_Description" ),
	_close	= UI.getChildControl( Panel_Introduction,	"Button_Close" )
}
tooltip._desc:SetTextMode( UI_TM.eTextMode_AutoWrap )
tooltip._close:addInputEvent( "Mouse_LUp", "FGlobal_Introcution_TooltipHide()" )

function FGlobal_Introcution_TooltipHide()
	Panel_Introduction:SetShow( false )
end

function FGlobal_Introduction_TooltipShow( uiControl, name, desc, isClose )
	FGlobal_Introcution_TooltipHide()
	
	Panel_Introduction:SetShow( true )
	local self = tooltip
	self._bg	:SetShow( true )
	self._name	:SetShow( true )
	self._desc	:SetShow( true )
	self._close	:SetShow( isClose )
	
	self._name:SetText( name )
	
	local nameLength = math.max( 135, self._name:GetTextSizeX() + 15 ) + 15
	self._desc:SetSize( nameLength, self._desc:GetSizeY() )
	self._desc:SetText( desc )
	self._bg:SetSize( nameLength + 10, self._name:GetSizeY() + self._desc:GetTextSizeY() + 15 )
	Panel_Introduction:SetSize( self._bg:GetSizeX(), self._bg:GetSizeY() )
	
	local posX, posY
	if nil ~= uiControl then
		posX = uiControl:GetPosX() + 130
		posY = uiControl:GetPosY() + 25
		
	else
		posX = getScreenSizeX()/3
		posY = getScreenSizeY()/3
	end
	
	Panel_Introduction:SetPosX( posX )
	Panel_Introduction:SetPosY( posY )
	self._close:ComputePos()
end

function FromClient_InterActionUserIntroduction( actorKey )
	local name, desc, uiControl
	
	local playerActorProxyWrapper	= getPlayerActor( actorKey )
	local name = playerActorProxyWrapper:getUserNickname() .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENT_PLAYERINTRO")
	local desc = playerActorProxyWrapper:getUserIntroduction()
	
	FGlobal_Introduction_TooltipShow( uiControl, name, desc, true )
end

registerEvent( "FromClient_InterActionUserIntroduction", "FromClient_InterActionUserIntroduction" )
