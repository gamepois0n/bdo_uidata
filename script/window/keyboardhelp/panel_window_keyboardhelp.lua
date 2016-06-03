Panel_KeyboardHelp:SetShow( false, false )

local keyboardHelp = {
	btn_XClose	= UI.getChildControl( Panel_KeyboardHelp, "Button_Close" ),
	btn_Close	= UI.getChildControl( Panel_KeyboardHelp, "Button_CloseWindow" ),
	btn_Help	= UI.getChildControl( Panel_KeyboardHelp, "Button_Help" ),
}

function KeyboardHelpShow()
	if Panel_KeyboardHelp:GetShow() then
		return
	end
	audioPostEvent_SystemUi(01,00)
	Panel_KeyboardHelp:SetShow( true )
end

function FGlobal_KeyboardHelpShow()
	if Panel_KeyboardHelp:IsShow() then
		Panel_KeyboardHelp:SetShow( false )
		return false
	else
		audioPostEvent_SystemUi(01,00)
		Panel_KeyboardHelp:SetShow( true )
		return true
	end
end

function KeyboardHelpHide()
	Panel_KeyboardHelp:SetShow( false )
end

function keyboardHelp:registEventHandler()
	self.btn_Close	:addInputEvent( "Mouse_LUp", "KeyboardHelpHide()" )
	self.btn_XClose	:addInputEvent( "Mouse_LUp", "KeyboardHelpHide()" )
	self.btn_Help	:addInputEvent( "Mouse_LUp", "FGlobal_Panel_WebHelper_ShowToggle()" )
end

keyboardHelp:registEventHandler()