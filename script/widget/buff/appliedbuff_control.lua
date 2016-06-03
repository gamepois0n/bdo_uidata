
-- 툴팁 처리

function ShowBuffTooltip( buffIndex, isDebuff )
	local appliedBuff = getSelfPlayer():getAppliedBuffByIndex(buffIndex-1, isDebuff)
	if nil == appliedBuff then
		return
	end	

	local icon
	if ( isDebuff ) then
		icon = PaGlobalAppliedBuffList._uiDeBuffList[buffIndex]
	else
		icon = PaGlobalAppliedBuffList._uiBuffList[buffIndex]
	end

	local tooltipIndex = buffIndex;
	if( isDebuff ) then
		tooltipIndex = tooltipIndex + PaGlobalAppliedBuffList._maxBuffCount
	end
	
	if( appliedBuff ~= nil ) then
		TooltipCommon_Show( tooltipIndex, icon, appliedBuff:getIconName() , appliedBuff:getBuffDesc(), '' )
	end
end

function HideBuffTooltip( buffIndex, isDebuff )
	local tooltipIndex = buffIndex;
	if( isDebuff ) then
		tooltipIndex = tooltipIndex + PaGlobalAppliedBuffList._maxBuffCount
	end
	
	TooltipCommon_Hide( tooltipIndex )
end

-----

local default_uiBackBuffPosX = PaGlobalAppliedBuffList._uiBackBuff:GetPosX()
function PaGlobalAppliedBuffList:updateBuff( isDebuff )
	local uiBuffList	= self._uiDeBuffList
	local uiBackBuff	= self._uiBackDeBuff
	if( false == isDebuff ) then
		uiBuffList	= self._uiBuffList
		uiBackBuff	= self._uiBackBuff
	end
	
	local buffIndex = 0
	local appliedBuff = getSelfPlayer():getAppliedBuffBegin( isDebuff )
	while (appliedBuff ~= nil) do	
		buffIndex = buffIndex + 1
		if(self._maxBuffCount < buffIndex) then
			buffIndex = buffIndex - 1
			break;
		end
		
		local u64_calc_time1 = appliedBuff:getRemainedTime_u64() / Defines.u64_const.u64_1000
		uiBuffList[buffIndex]:ChangeTextureInfoName("icon/" .. appliedBuff:getIconName())
		uiBuffList[buffIndex]:SetShow(true)
		uiBuffList[buffIndex]:SetText(Util.Time.inGameTimeFormattingTop(u64_calc_time1))		
		
		appliedBuff = getSelfPlayer():getAppliedBuffNext( isDebuff )
	end
	if 0 < buffIndex then	
		uiBackBuff:SetSize( buffIndex*33 + 4, 52 )
		uiBackBuff:SetShow(true)
	else
		uiBackBuff:SetShow(false)
	end
	
	while( buffIndex < self._maxBuffCount ) do
		buffIndex = buffIndex + 1
		uiBuffList[buffIndex]:SetShow(false)
	end	
	
	if (17 < buffIndex) then
		uiBackBuff:SetPosX( default_uiBackBuffPosX - (buffIndex-17)/2 * 33)
	else
		uiBackBuff:SetPosX( default_uiBackBuffPosX )
	end
	for index = 1, buffIndex do
		uiBuffList[index]:SetPosX( uiBackBuff:GetPosX() + 33 * (index -1) + 2 )
	end
end

function PaGlobalAppliedBuffList:updateBuffList()
	PaGlobalAppliedBuffList:updateBuff(true)	-- 디버프
	PaGlobalAppliedBuffList:updateBuff(false)	-- 버프
end



local _cumulateTime = 0
function AppliedBuffList_Update( fDeltaTime )
	if isFlushedUI() then
		return
	end
	_cumulateTime = _cumulateTime + fDeltaTime
	
	PaGlobalAppliedBuffList:updateBuffList()
	
	local cumulateTimeInSecond = math.floor(_cumulateTime)
	local u64_cumulateTime = toUint64(0, cumulateTimeInSecond)
	if ( 1 < _cumulateTime ) then
		
		_cumulateTime = 0
	end
end

function ResponseBuff_changeBuffList()
	if isFlushedUI() then
		return
	end
	
	PaGlobalAppliedBuffList:updateBuffList()
end




function buff_RunPostRestoreFunction()
	ResponseBuff_changeBuffList()
	--AppliedBuffList_Update( 0 )
end
UI.addRunPostRestorFunction( buff_RunPostRestoreFunction )

function	reloadAppliedBuffPanel()
	PaGlobalAppliedBuffList:show()
	ResponseBuff_changeBuffList()
end

reloadAppliedBuffPanel()

registerEvent("ResponseBuff_changeBuffList",	"ResponseBuff_changeBuffList")
Panel_AppliedBuffList:RegisterUpdateFunc( "AppliedBuffList_Update" )