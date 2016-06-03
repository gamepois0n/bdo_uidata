-------------------------- Panel 설정 -------------------------
Panel_Dialogue_Itemtake:setGlassBackground(true)
---------------------------------------------------------------

-------------------------- Local 변수 설정 --------------------
local 	UI_color					= Defines.Color
local 	UI_TM 						= CppEnums.TextMode

local slotConfig =
{	-- 일단 아이콘, 테두리, 카운트(숫자) 만 적용한다!
	createIcon		= true,
	createBorder	= true,
	createCount		= true,
	createCash		= true
}
---------------------------------------------------------------

-------------------------- Control 획득 -----------------------
local TalkPopup =
{
	 _itemSlot				= {}
	,_itemSlotBg			= UI.getChildControl(Panel_Dialogue_Itemtake, "Static_Itemicon")
	,_buttonAccept			= UI.getChildControl(Panel_Dialogue_Itemtake, "Button_Yes")
	,_buttonCancel			= UI.getChildControl(Panel_Dialogue_Itemtake, "Button_No")
	,_textItemName			= UI.getChildControl(Panel_Dialogue_Itemtake, "StaticText_Itemname")
	,_textComment			= UI.getChildControl(Panel_Dialogue_Itemtake, "StaticText_Comment")
	,_textNeedContribution	= UI.getChildControl(Panel_Dialogue_Itemtake, "StaticText_NeedContribution")
	,_textMyContribution	= UI.getChildControl(Panel_Dialogue_Itemtake, "StaticText_MyContribution")
	,_territoryMark			= UI.getChildControl(Panel_Dialogue_Itemtake, "Static_territorymark")
	,_helpMsg				= UI.getChildControl(Panel_Dialogue_Itemtake, "StaticText_helpMsg")
	,_selectedIndex			= 0
	,_currentDisplayData	= nil
}
---------------------------------------------------------------


-------------------------- 아이템 대여 ---------------------------
------------------------------- 초기화 ---------------------------
function TalkPopup:init()
	SlotItem.new( self._itemSlot, 'ItemIconSlot' , 0, self._itemSlotBg, slotConfig )
	self._itemSlot:createChild();

	self._itemSlot.icon:SetPosX( self._itemSlot.icon:GetPosX() + 6 )
	self._itemSlot.icon:SetPosY( self._itemSlot.icon:GetPosY() + 6 )
	self._buttonAccept:addInputEvent( "Mouse_LUp", "click_yesDialogButton()" )
	self._buttonCancel:addInputEvent( "Mouse_LUp", "click_noDialogButton()" )
	self._itemSlot.icon:addInputEvent( "Mouse_On", "showTooltip()" )
	self._itemSlot.icon:addInputEvent( "Mouse_Out","hideTooltip()" )
	Panel_Tooltip_Item_SetPosition( 0, self._itemSlot.icon, "talkPopup" )
end

TalkPopup:init()

------------------------------------------------------------------
function showTooltip()
	local itemStaticWrapper = getItemEnchantStaticStatus( TalkPopup._currentDisplayData:getItemKey() )
	Panel_Tooltip_Item_Show( itemStaticWrapper, TalkPopup._itemSlot.icon, true, false )
end

function hideTooltip()
	Panel_Tooltip_Item_hideTooltip()
end

function TalkPopup_Show(displayData)
	local self = TalkPopup
	TalkPopup._currentDisplayData = displayData
	Panel_Dialogue_Itemtake:SetShow(true)
	Panel_Dialogue_Itemtake:SetPosX( getScreenSizeX() - Panel_Dialogue_Itemtake:GetSizeX()*1.5 )
	Panel_Dialogue_Itemtake:SetPosY( getScreenSizeY()/2 - Panel_Dialogue_Itemtake:GetSizeY()/2 - 60 )
	local itemStaticWrapper 	= getItemEnchantStaticStatus( displayData:getItemKey() )
	local explorePoint			= getExplorePointByTerritory(TalkPopup._currentDisplayData._territoryKey)
	self._itemSlot:setItemByStaticStatus( itemStaticWrapper, displayData._itemCounts64 );

	local	strNeedPoint	= string.format( "%d", displayData._needPoint )
	local	strHavePoint	= string.format( "%d", explorePoint:getRemainedPoint() )
	self._textItemName:SetText(itemStaticWrapper:getName())
	self._textNeedContribution:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "DIALOG_NEED_POINT", "point", strNeedPoint ) )
	self._textMyContribution:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "DIALOG_HAVE_POINT", "point", strHavePoint ) )

	if selfPlayerCurrentTerritory() == PAGetString(Defines.StringSheet_GAME, "DIALOG_SERENDIA") then
		self._territoryMark:ChangeTextureInfoName('New_UI_Common_forLua/Widget/Dialogue/Dialogue_Etc_00.dds')
		local x1, y1, x2, y2 = setTextureUV_Func( self._territoryMark, 329, 1, 379, 60 )
		self._territoryMark:getBaseTexture():setUV(  x1, y1, x2, y2  )
		self._territoryMark:setRenderTexture(self._territoryMark:getBaseTexture())
	elseif selfPlayerCurrentTerritory() == PAGetString(Defines.StringSheet_GAME, "DIALOG_BALENOS") then
		self._territoryMark:ChangeTextureInfoName('New_UI_Common_forLua/Widget/Dialogue/Dialogue_Etc_00.dds')
		local x1, y1, x2, y2 = setTextureUV_Func( self._territoryMark, 278, 1, 328, 60 )
		self._territoryMark:getBaseTexture():setUV(  x1, y1, x2, y2  )
		self._territoryMark:setRenderTexture(self._territoryMark:getBaseTexture())
	end

	if	(displayData._needPoint > explorePoint:getRemainedPoint()) then
		self._textComment:SetText(PAGetString(Defines.StringSheet_GAME, "DIALOG_ERROR_SHORTAGE_POINT"))
		self._buttonAccept:SetEnable(false)
		self._buttonAccept:SetMonoTone(true)
		self._buttonAccept:SetFontColor(UI_color.C_FF515151)
	else
		self._textComment:SetText(PAGetString(Defines.StringSheet_GAME, "DIALOG_ITEMTAKE_TXT_COMMENT"))
		self._buttonAccept:SetEnable(true)
		self._buttonAccept:SetMonoTone(false)
		self._buttonAccept:SetFontColor(UI_color.C_FFC4BEBE)
	end

	self._helpMsg:SetShow( true )
	self._helpMsg:SetTextMode( UI_TM.eTextMode_AutoWrap )
	self._helpMsg:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_DIALOGUE_TXT_CONTRIHELP") )
end


function TalkPopup:hide()
	Panel_Dialogue_Itemtake:SetShow(false)
end

function click_yesDialogButton()
	local explorePoint			= getExplorePointByTerritory(TalkPopup._currentDisplayData._territoryKey)
	if ( explorePoint:getRemainedPoint() < TalkPopup._currentDisplayData._needPoint ) then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "DIALOG_ERROR_SHORTAGE_POINT") )
		return;
	end

	Dialog_clickDialogButtonReq(TalkPopup._selectedIndex)
	TalkPopup:hide()
end

function click_noDialogButton()
	TalkPopup:hide()
end

function TalkPopup_SelectedIndex(index)
	TalkPopup._selectedIndex = index
end