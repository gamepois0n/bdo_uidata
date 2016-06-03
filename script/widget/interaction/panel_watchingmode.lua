Panel_WatchingMode:SetDragAll(true)
Panel_WatchingMode:SetIgnore( true )

local watchingMode = {
	skillCommandBg	= UI.getChildControl(Panel_WatchingMode, "Static_CommandBG"),

	key_W			= UI.getChildControl(Panel_WatchingMode, "StaticText_Key_W"),
	key_A			= UI.getChildControl(Panel_WatchingMode, "StaticText_Key_A"),
	key_S			= UI.getChildControl(Panel_WatchingMode, "StaticText_Key_S"),
	key_D			= UI.getChildControl(Panel_WatchingMode, "StaticText_Key_D"),
	key_Q			= UI.getChildControl(Panel_WatchingMode, "StaticText_Key_Q"),
	key_E			= UI.getChildControl(Panel_WatchingMode, "StaticText_Key_E"),
	key_R			= UI.getChildControl(Panel_WatchingMode, "StaticText_Key_R"),
	key_Shift		= UI.getChildControl(Panel_WatchingMode, "StaticText_Key_Shift"),

	forward			= UI.getChildControl(Panel_WatchingMode, "StaticText_Forward"),
	left			= UI.getChildControl(Panel_WatchingMode, "StaticText_Left"),
	back			= UI.getChildControl(Panel_WatchingMode, "StaticText_Back"),
	right			= UI.getChildControl(Panel_WatchingMode, "StaticText_Right"),
	small			= UI.getChildControl(Panel_WatchingMode, "StaticText_Small"),
	big				= UI.getChildControl(Panel_WatchingMode, "StaticText_Big"),
	exit			= UI.getChildControl(Panel_WatchingMode, "StaticText_Exit"),
	speed			= UI.getChildControl(Panel_WatchingMode, "StaticText_Speed"),
}


local showToogleBGBtn	= UI.getChildControl(Panel_WatchingMode, "Static_CommandBG")
local showToogleBtn		= UI.getChildControl(Panel_WatchingMode, "Button_ShowCommand")

function WatchingModeInt()
	local self = watchingMode
	-- Panel_WatchingMode:SetEnableArea(100, 0, 200, 25)
	-- Panel_WatchingMode:SetDragEnable(true)
	-- showToogleBtn:SetEnableArea(0, 25, 200, 50)
	
	self.skillCommandBg:SetIgnore(false)
	self.skillCommandBg:AddChild( self.key_W )
	self.skillCommandBg:AddChild( self.key_A )
	self.skillCommandBg:AddChild( self.key_S )
	self.skillCommandBg:AddChild( self.key_D )
	self.skillCommandBg:AddChild( self.key_Q )
	self.skillCommandBg:AddChild( self.key_E )
	self.skillCommandBg:AddChild( self.key_R )
	self.skillCommandBg:AddChild( self.key_Shift )
	self.skillCommandBg:AddChild( self.forward )
	self.skillCommandBg:AddChild( self.left )
	self.skillCommandBg:AddChild( self.back )
	self.skillCommandBg:AddChild( self.right )
	self.skillCommandBg:AddChild( self.small )
	self.skillCommandBg:AddChild( self.big )
	self.skillCommandBg:AddChild( self.exit )
	self.skillCommandBg:AddChild( self.speed )

	Panel_WatchingMode:RemoveControl( self.key_W )
	Panel_WatchingMode:RemoveControl( self.key_A )
	Panel_WatchingMode:RemoveControl( self.key_S )
	Panel_WatchingMode:RemoveControl( self.key_D )
	Panel_WatchingMode:RemoveControl( self.key_Q )
	Panel_WatchingMode:RemoveControl( self.key_E )
	Panel_WatchingMode:RemoveControl( self.key_R )
	Panel_WatchingMode:RemoveControl( self.key_Shift )
	Panel_WatchingMode:RemoveControl( self.forward )
	Panel_WatchingMode:RemoveControl( self.left )
	Panel_WatchingMode:RemoveControl( self.back )
	Panel_WatchingMode:RemoveControl( self.right )
	Panel_WatchingMode:RemoveControl( self.small )
	Panel_WatchingMode:RemoveControl( self.big  )
	Panel_WatchingMode:RemoveControl( self.exit )
	Panel_WatchingMode:RemoveControl( self.speed )

	showToogleBtn:addInputEvent("Mouse_LUp", "ShowCommandFunc()")
end

function ShowCommandFunc()
	local self				= watchingMode
	local checkToggleBtn	= showToogleBtn:IsCheck()
	Panel_WatchingMode:SetShow( true )
	if checkToggleBtn then
		self.skillCommandBg:SetShow( false )
	else
		self.skillCommandBg:SetShow( true )
	end
	-- Panel_WatchingMode:SetPosX( (getScreenSizeX() / 2) + 200 ) -- - (Panel_WatchingMode:GetSizeX() / 2) - 240 )
	-- Panel_WatchingMode:SetPosY( (getScreenSizeY() / 2) - (Panel_WatchingMode:GetSizeY()/2) ) -- - 150 )

	self.key_W:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_MoveFront ) )
	self.key_S:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_MoveBack ) )
	self.key_A:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_MoveLeft ) )
	self.key_D:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_MoveRight ) )
	self.key_Q:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_CrouchOrSkill ) )
	self.key_E:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_GrabOrGuard ) )
	self.key_R:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_Interaction ) )
	self.key_Shift:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_Dash ) )
end

-- function showCommandToggle()

-- end

WatchingModeInt()