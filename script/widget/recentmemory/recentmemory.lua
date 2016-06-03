Panel_RecentMemory:SetPosX( -10 )
Panel_RecentMemory:SetPosY( 265 )
Panel_RecentMemory:ActiveMouseEventEffect(true)
Panel_RecentMemory:setGlassBackground(true)

local RecentMemory = {
	_close			= UI.getChildControl( Panel_RecentMemory, "Button_Close" ),
	_questString0_1	= UI.getChildControl( Panel_RecentMemory, "StaticText_Quest1_1" ), -- 25 68
	_questString0_2	= UI.getChildControl( Panel_RecentMemory, "StaticText_Quest1_2" ), -- 25 88
	_questString1	= UI.getChildControl( Panel_RecentMemory, "StaticText_Quest2" ),
	_memo			= UI.getChildControl( Panel_RecentMemory, "StaticText_Memo" ),
	_time			= UI.getChildControl( Panel_RecentMemory, "StaticText_Time" ),
	_closeNotify	= UI.getChildControl( Panel_RecentMemory, "StaticText_CloseNotify" ),
}
RecentMemory._close:addInputEvent("Mouse_LUp", "RecentMemory_Close()")

function RecentMemory:filldata( memo, recentTime, questNo0, questNo1, questNoCurrent )
	questWrapper = ToClient_getQuestWrapper( questNo0 )
	if ( nil ~= questWrapper ) then
		self._questString0_1	:SetText("- " .. questWrapper:getTitle())
	else
		self._questString0_1	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RECENTMEMORY_NOCOMPLETEQUEST") ) -- "- 완료한 의뢰가 없습니다."
	end

	questWrapper = ToClient_getQuestWrapper( questNo1 )
	if ( nil ~= questWrapper ) then
		self._questString0_2	:SetText("- " .. questWrapper:getTitle())
	else
		self._questString0_2	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RECENTMEMORY_NOCOMPLETEQUEST") ) -- "- 완료한 의뢰가 없습니다."
	end

	local paTime = PATime(recentTime)
	self._memo				:SetText(memo)
	self._time:SetShow( false )
	
	
	questWrapper = ToClient_getQuestWrapper( questNoCurrent )
	if ( nil ~= questWrapper ) then
		self._questString1	:SetText("- " .. questWrapper:getTitle())
	else
		self._questString1	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RECENTMEMORY_NOPROGRESSQUEST") ) -- "- 진행중이던 의뢰가 없습니다."
	end
end

function RecentMemory:show()
	if isFlushedUI() then
		return
	end

	if ToClient_SelfPlayerIsGM() then
		return
	end

	Panel_RecentMemory:SetShow(true, false)
end

function RecentMemory_Close()
	Panel_RecentMemory:SetShow(false, false)
end

function FromClient_PreviousCharacterDataUpdate( memo, recentTime, questNo0, questNo1, questNoCurrent )
	RecentMemory:filldata( memo, recentTime, questNo0, questNo1, questNoCurrent )
	RecentMemory:show()
end

local openTime	= 0
local beforTime	= 0
function recentMemory_OpenTimeCheck( deltaTime )
	openTime = openTime + deltaTime
	local sumTime = 30 - math.ceil( openTime )
	RecentMemory._closeNotify:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_RECENTMEMORY_CLOSETIME", "sumTime", convertStringFromDatetime(toInt64(0,sumTime)) ) ) -- convertStringFromDatetime(toInt64(0,sumTime)) .. " 후에 닫힙니다.

	if 31 < openTime then
		RecentMemory_Close()
		openTime = 0
	end
end

Panel_RecentMemory:RegisterUpdateFunc( "recentMemory_OpenTimeCheck" )
registerEvent("FromClient_PreviousCharacterDataUpdate", "FromClient_PreviousCharacterDataUpdate")