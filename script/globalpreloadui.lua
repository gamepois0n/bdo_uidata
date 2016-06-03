-- Processor Mode 변화 알림 --
local _voidCursor = UI.getChildControl( Panel_SelfPlayerExpGage, "Static_Cursor" )

function ProcessorInputModeChange()
	_voidCursor:SetPosX(getMousePosX())
	_voidCursor:SetPosY(getMousePosY())
	if 0 == getInputMode() then
		_voidCursor:AddEffect("UI_Mouse_Appear", false, 0, 0)
		_voidCursor:AddEffect("fUI_SkillButton03", false, 0, 0)
	else
		_voidCursor:AddEffect("UI_Mouse_Hide", false, 0, 0)
		_voidCursor:AddEffect("fUI_SkillButton01", false, 0, 0)
	end
end

registerEvent("EventProcessorInputModeChange",	"ProcessorInputModeChange");