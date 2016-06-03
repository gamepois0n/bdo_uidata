loadUI("UI_Data/Widget/Buff/UI_BuffPanel.xml",			"Panel_AppliedBuffList", Defines.UIGroup.PAGameUIGroup_MainUI)

Panel_AppliedBuffList:SetShow(false, false)

PaGlobalAppliedBuffList = {	
	_uiBackBuff			= UI.getChildControl( Panel_AppliedBuffList, "Static_Buff_BG" ),
	_uiBackDeBuff		= UI.getChildControl( Panel_AppliedBuffList, "Static_DeBuff_BG" ),
	_buffText			= UI.getChildControl( Panel_AppliedBuffList, "StaticText_buffText" ),
	
	_maxBuffCount 		= 20,
	_uiBuffList			= {},
	_uiDeBuffList		= {},
	_isShow				= false,
}

local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_classType = CppEnums.ClassType
local UI_TIMETOP =  Util.Time.inGameTimeFormattingTop

function PaGlobalAppliedBuffList:initialize()
	local	styleBuffIcon 		= UI.getChildControl( Panel_AppliedBuffList, "StaticText_Buff"  )
	local	styleDeBuffIcon 	= UI.getChildControl( Panel_AppliedBuffList, "StaticText_deBuff"  )
	styleBuffIcon:SetShow( false )
	styleDeBuffIcon:SetShow( false )
	self._uiBackBuff:SetShow( false )
	self._uiBackDeBuff:SetShow( false )	
	
	local iconSpan = styleBuffIcon:GetSizeX() + 1	
	-- index 를 1부터 시작하도록 했다!
	for index = 1, self._maxBuffCount, 1 do
		local buffIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_AppliedBuffList, 'AppliedBuff_' .. index)
		CopyBaseProperty( styleBuffIcon, buffIcon )
		buffIcon:SetPosX( self._uiBackBuff:GetPosX() + iconSpan * (index -1) + 2 )
		buffIcon:SetPosY( self._uiBackBuff:GetPosY() + 2 )
		buffIcon:SetShow(false)
		buffIcon:SetIgnore(false)
	
		local deBuffIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_AppliedBuffList, 'AppliedDeBuff_' .. index)
		CopyBaseProperty( styleDeBuffIcon, deBuffIcon )
		deBuffIcon:SetPosX( self._uiBackDeBuff:GetPosX() + iconSpan * (index-1) + 2 )
		deBuffIcon:SetPosY( self._uiBackDeBuff:GetPosY() + 2 )
		deBuffIcon:SetShow(false)
		deBuffIcon:SetIgnore(false)

		buffIcon:addInputEvent( "Mouse_On", "HandleMOnAppliedBuff(".. index ..",false)" )
		buffIcon:addInputEvent( "Mouse_Out", "HandleMOffAppliedBuff(".. index ..",false)" )
		deBuffIcon:addInputEvent( "Mouse_On", "HandleMOnAppliedBuff(".. index ..",true)" )
		deBuffIcon:addInputEvent( "Mouse_Out", "HandleMOffAppliedBuff(".. index ..",true)" )
	
		self._uiBuffList[index] = buffIcon
		self._uiDeBuffList[index] = deBuffIcon
	end
	self._uiBackBuff:SetIgnore(true)
	self._uiBackDeBuff:SetIgnore(true)
	
	Panel_AppliedBuffList:addInputEvent( "Mouse_On", "HandleMOnAppliedBuffPenel()" )
	Panel_AppliedBuffList:addInputEvent( "Mouse_Out", "HandleMOutAppliedBuffPenel()" )
	Panel_AppliedBuffList:addInputEvent( "Mouse_Lup", "ResetPos_WidgetButton()")
end

function PaGlobalAppliedBuffList:setMovableUIForControlMode()
	self._buffText:SetShow( false )
	Panel_AppliedBuffList:SetIgnore( false )
	Panel_AppliedBuffList:SetDragEnable( true )
	Panel_AppliedBuffList:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_isWidget.dds" )
end
function PaGlobalAppliedBuffList:cancelMovableUIForControlMode()
	self._buffText:SetShow( false )
	Panel_AppliedBuffList:SetDragEnable( false )
	Panel_AppliedBuffList:ChangeTextureInfoName( "New_UI_Common_forLua/Default/window_sample_empty.dds" )
end

function PaGlobalAppliedBuffList:changeOnOffTexture( isOn )
	if( true == isOn ) then
		if Panel_UIControl:IsShow() then
			Panel_AppliedBuffList:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_drag.dds")
			self._buffText:SetText( PAGetString(Defines.StringSheet_GAME, "BUFF_LIST_MOVE") )
		end
	else
		if Panel_UIControl:IsShow() then		
			Panel_AppliedBuffList:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_isWidget.dds")
			self._buffText:SetText( PAGetString(Defines.StringSheet_GAME, "BUFF_LIST") )
		else		
			Panel_AppliedBuffList:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_empty.dds")
		end
	end	
end

function PaGlobalAppliedBuffList:show()
	Panel_AppliedBuffList:SetShow( true, false )
end

function PaGlobalAppliedBuffList:hide()
	Panel_AppliedBuffList:SetShow( false, false )
end

function PaGlobalAppliedBuffList:showToggle()
	if Panel_AppliedBuffList:IsShow() then
		Panel_AppliedBuffList:SetShow ( false )
	else
		Panel_AppliedBuffList:SetShow ( true )
	end
end


-- 핸들러 추가
function HandleMOnAppliedBuffPenel()	
	AppliedBuffList:changeOnOffTexture(true)
end
function HandleMOutAppliedBuffPenel()
	AppliedBuffList:changeOnOffTexture(false)
end

function HandleMOnAppliedBuff( buffIndex, isDebuff )
	ShowBuffTooltip(buffIndex, isDebuff)
end
function HandleMOffAppliedBuff( buffIndex, isDebuff )
	HideBuffTooltip(buffIndex, isDebuff)
end

PaGlobalAppliedBuffList:initialize()