Panel_Worker_Tooltip:setMaskingChild(true)
Panel_Worker_Tooltip:setGlassBackground(true)
Panel_Worker_Tooltip:SetShow( false, false )
Panel_Worker_Tooltip:SetIgnoreChild( true )

local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_TM = CppEnums.TextMode
local UI_color 		= Defines.Color
local UI_QuestType	= CppEnums.QuestType
local UI_TM 		= CppEnums.TextMode

workerInfoTooltip = nil

local controlWorkerTooltip =
{
	_icon 				= UI.getChildControl ( Panel_Worker_Tooltip, "Static_workerIcon" ),
	_name 				= UI.getChildControl ( Panel_Worker_Tooltip, "StaticText_workerName" ),
	_actionPointValue 	= UI.getChildControl ( Panel_Worker_Tooltip, "StaticText_workerActionPoint_value" ),
	_luckValue 			= UI.getChildControl ( Panel_Worker_Tooltip, "StaticText_workerLuck_value" ),
	_efficiency2_Value 	= UI.getChildControl ( Panel_Worker_Tooltip, "StaticText_WorkerWork2Speed_Value" ),
	-- _efficiency5_Value 	= UI.getChildControl ( Panel_Worker_Tooltip, "StaticText_WorkerWork5Speed_Value" ),
	-- _efficiency6_Value 	= UI.getChildControl ( Panel_Worker_Tooltip, "StaticText_WorkerWork6Speed_Value" ),
	-- _efficiency8_Value 	= UI.getChildControl ( Panel_Worker_Tooltip, "StaticText_WorkerWork8Speed_Value" ),
	_moveSpeedValue 	= UI.getChildControl ( Panel_Worker_Tooltip, "StaticText_workerMoveSpeed_value" ),
	_levelValue		 	= UI.getChildControl ( Panel_Worker_Tooltip, "StaticText_Level" ),
	_expProgress	 	= UI.getChildControl ( Panel_Worker_Tooltip, "Progress2_ExpPoint" ),

	_workerBg			= UI.getChildControl ( Panel_Worker_Tooltip, "Static_BG_2" ),

	_skilBox			= UI.getChildControl ( Panel_Worker_Tooltip, "Static_SkillBox" ),
	_skillTitle			= UI.getChildControl ( Panel_Worker_Tooltip, "StaticText_SkillTitle" ),
	_skill				= {},

	_defaultSkillBox	= UI.getChildControl ( Panel_Worker_Tooltip, "Static_SkillBox_Default" ),
	_defaultSkillTitle	= UI.getChildControl ( Panel_Worker_Tooltip, "StaticText_SkillTitle_Default" ),
	_defaultSkillBg		= UI.getChildControl ( Panel_Worker_Tooltip, "Static_SkillSlotBG_00" ),
	_defaultSkillIcon	= UI.getChildControl ( Panel_Worker_Tooltip, "Static_SkillSlot_00" ),
	_defaultSkillName	= UI.getChildControl ( Panel_Worker_Tooltip, "StaticText_SkillName_00" ),
	_defaultSkillDesc	= UI.getChildControl ( Panel_Worker_Tooltip, "StaticText_SkillDesc_00" ),

	_workingNameTitle 	= UI.getChildControl ( Panel_Worker_Tooltip, "StaticText_WorkerStateValue" ),
	_workingNameValue 	= UI.getChildControl ( Panel_Worker_Tooltip, "StaticText_WorkerWorkingName_Value" ),
	_workingNameBG	 	= UI.getChildControl ( Panel_Worker_Tooltip, "StaticText_EmploymentBG" ),
	_panelBG			= UI.getChildControl ( Panel_Worker_Tooltip, "Static_PanelBG" ),
	_panel_Size			= Panel_Worker_Tooltip:GetSizeY(),

	_maxSkillCount		= 7,
}

local makeSkillUi = function()
	local self = controlWorkerTooltip
	-- {고유 스킬
		self._defaultSkillBox	:AddChild		( self._defaultSkillTitle )
		self._defaultSkillBox	:AddChild		( self._defaultSkillBg )
		Panel_Worker_Tooltip	:RemoveControl	( self._defaultSkillTitle )
		Panel_Worker_Tooltip	:RemoveControl	( self._defaultSkillBg )
		self._defaultSkillBg	:AddChild		( self._defaultSkillIcon )
		self._defaultSkillBg	:AddChild		( self._defaultSkillName )
		self._defaultSkillBg	:AddChild		( self._defaultSkillDesc )
		Panel_Worker_Tooltip	:RemoveControl	( self._defaultSkillIcon )
		Panel_Worker_Tooltip	:RemoveControl	( self._defaultSkillName )
		Panel_Worker_Tooltip	:RemoveControl	( self._defaultSkillDesc )

		self._defaultSkillBox	:ComputePos()
		self._defaultSkillTitle	:SetSpanSize( 0, 0 )
		self._defaultSkillTitle	:ComputePos()
		self._defaultSkillBg	:SetPosX( 10 )
		self._defaultSkillBg	:SetPosY( 24 )
		self._defaultSkillIcon	:SetPosX( 0 )
		self._defaultSkillIcon	:SetPosY( 0 )
		self._defaultSkillName	:SetPosX( self._defaultSkillIcon:GetSizeX() + 5 )
		self._defaultSkillName	:SetPosY( 2 )
		self._defaultSkillDesc	:SetPosX( self._defaultSkillIcon:GetSizeX() + 5 )
		self._defaultSkillDesc	:SetPosY( 20 )
	--}
	-- {스킬
		self._skilBox			:AddChild		( self._skillTitle )
		Panel_Worker_Tooltip	:RemoveControl	( self._skillTitle )
		self._skilBox			:ComputePos()
		self._skillTitle		:ComputePos()
	-- 
	--{ 작업 상태
		self._workingNameBG		:AddChild		( self._workingNameTitle )
		self._workingNameBG		:AddChild		( self._workingNameValue )
		Panel_Worker_Tooltip	:RemoveControl	( self._workingNameTitle )
		Panel_Worker_Tooltip	:RemoveControl	( self._workingNameValue )
		self._workingNameTitle	:SetPosX( 10 )
		self._workingNameTitle	:SetPosY( 0 )
		self._workingNameValue	:SetPosX( 10 )
		self._workingNameValue	:SetPosY( 28 )
	--

	local slotGapY = 50
	for idx = 0, 6 do
		self._skill[idx] = {}
		self._skill[idx].iconBg	= UI.createAndCopyBasePropertyControl( Panel_Worker_Tooltip, "Static_SkillSlotBG_01",	self._skilBox,	"WorkerSkill_SlotBG_"					.. idx )
		self._skill[idx].icon	= UI.createAndCopyBasePropertyControl( Panel_Worker_Tooltip, "Static_SkillSlot_01",		self._skill[idx].iconBg,	"WorkerSkill_SlotIcon_"					.. idx )
		self._skill[idx].name	= UI.createAndCopyBasePropertyControl( Panel_Worker_Tooltip, "StaticText_SkillName_01",	self._skill[idx].iconBg,	"WorkerSkill_SlotName_"					.. idx )
		self._skill[idx].desc	= UI.createAndCopyBasePropertyControl( Panel_Worker_Tooltip, "StaticText_SkillDesc_01",	self._skill[idx].iconBg,	"WorkerSkill_SlotDesc_"					.. idx )

		self._skill[idx].iconBg		:SetPosX( 10 )
		self._skill[idx].iconBg		:SetPosY( (slotGapY * idx) + 26 )
		self._skill[idx].icon		:SetPosX( 0 )
		self._skill[idx].icon		:SetPosY( 0 )
		self._skill[idx].name		:SetPosX( self._skill[idx].icon:GetSizeX() + 5 )
		self._skill[idx].name		:SetPosY( 0 )
		self._skill[idx].desc		:SetPosX( self._skill[idx].icon:GetSizeX() + 5 )
		self._skill[idx].desc		:SetPosY( 20 )

	end

	self._skillTitle:SetPosY( 0 )
end
makeSkillUi()


function HandleOnWorkerTooltip( workerData, uiBase )
	workerInfoTooltip = uiBase
	local waitWorkerCount = 0;	
	
	if ( nil == workerData ) then
		FGlobal_InitWorkerTooltip();
		return
	end
		
	local workerStaticStatus = workerData:getWorkerStaticStatus()
	FGlobal_ShowWorkerTooltip( workerData, uiBase );
end


function HandleOutWorkerTooltip( uiBase )
	if ( uiBase == workerInfoTooltip ) then
		workerInfoTooltip = nil	
	end
	
	FGlobal_HideWorkerTooltip()
end

function FGlobal_ShowWorkerTooltip( workerData, uiBase, isRight, isPlant )
	-- ♬ 툴팁이 열릴 때 사운드 추가
	audioPostEvent_SystemUi(01,13)
	local workerStaticStatus	= workerData:getWorkerStaticStatus()
	local defaultSkill			= workerData:getWorkerDefaultSkillStaticStatus()
	if nil ~= defaultSkill then
		controlWorkerTooltip._defaultSkillBox	:SetShow( true )
		controlWorkerTooltip._defaultSkillBox	:ComputePos()
		controlWorkerTooltip._skilBox			:SetSpanSize( 0, 260 )
		controlWorkerTooltip._skilBox			:ComputePos()

		controlWorkerTooltip._defaultSkillIcon	:ChangeTextureInfoName( defaultSkill:getIconPath() )
		controlWorkerTooltip._defaultSkillName	:SetText( defaultSkill:getName() )
		controlWorkerTooltip._defaultSkillDesc	:SetText( defaultSkill:getDescription() )

		controlWorkerTooltip._workerBg			:SetSize( controlWorkerTooltip._workerBg:GetSizeX(), 580 )

		tempPenelSizeY = controlWorkerTooltip._panel_Size + 120
	else
		controlWorkerTooltip._defaultSkillBox	:SetShow( false )
		controlWorkerTooltip._defaultSkillBox	:ComputePos()
		controlWorkerTooltip._skilBox			:SetSpanSize( 0, 185 )
		controlWorkerTooltip._skilBox			:ComputePos()

		controlWorkerTooltip._workerBg			:SetSize( controlWorkerTooltip._workerBg:GetSizeX(), 510 )

		tempPenelSizeY = controlWorkerTooltip._panel_Size + 50
	end

	if false == isWaitWorker(workerData) then
		local _WorkerNo				= workerData:getWorkerNo():get_s64()
		local workerWrapper			= getWorkerWrapper(_WorkerNo, false)
		local workName				= workerWrapper:getWorkString()
		local workNodeName			= workerWrapper:getWorkStringOnlyTarget()
		local workParentsNodeName	= workerWrapper:getWorkingNodeDesc()

		controlWorkerTooltip._workingNameBG		:SetPosY( controlWorkerTooltip._workerBg:GetPosY() + controlWorkerTooltip._workerBg:GetSizeY() + 5 )
		-- controlWorkerTooltip._workingNameValue:SetTextMode( UI_TM.eTextMode_LimitText )
		controlWorkerTooltip._workingNameValue	:SetText(workName .. "\n  " .. workParentsNodeName)
		controlWorkerTooltip._workingNameTitle	:SetShow(true)
		controlWorkerTooltip._workingNameValue	:SetShow(true)
		controlWorkerTooltip._workingNameBG		:SetShow(true)

		controlWorkerTooltip._panelBG:SetSize(controlWorkerTooltip._panelBG:GetSizeX(), tempPenelSizeY )
		Panel_Worker_Tooltip:SetSize(Panel_Worker_Tooltip:GetSizeX(), tempPenelSizeY )
	else
		controlWorkerTooltip._workingNameTitle	:SetShow(false)
		controlWorkerTooltip._workingNameValue	:SetShow(false)
		controlWorkerTooltip._workingNameBG		:SetShow(false)

		controlWorkerTooltip._panelBG:SetSize(controlWorkerTooltip._panelBG:GetSizeX(), tempPenelSizeY - 40 )
		Panel_Worker_Tooltip:SetSize(Panel_Worker_Tooltip:GetSizeX(), tempPenelSizeY - 40 )
	end
	
	controlWorkerTooltip._icon:ChangeTextureInfoName( getWorkerIcon(workerStaticStatus) ) 									-- 아이콘

	local workerGrade = workerData:getWorkerStaticStatus():getCharacterStaticStatus()._gradeType:get()						-- 일꾼 등급
	controlWorkerTooltip._name:SetFontColor( ConvertFromGradeToColor(workerGrade) )

	local _tempWorkerExp = 0
	if toInt64(0,0) == workerData:getExperience() then
		_tempWorkerExp = 0
	else
		local maxExp = Int64toInt32(workerData:getMaxExperience())
		if ( toInt64(0,0) == maxExp ) then
			_tempWorkerExp = 0
		else
			_tempWorkerExp = math.ceil((Int64toInt32(workerData:getExperience())/maxExp )*100)
		end
	end
	
	controlWorkerTooltip._levelValue	:SetText( "Lv "..workerData:getLevel() )
	controlWorkerTooltip._expProgress	:SetCurrentProgressRate( _tempWorkerExp )
	controlWorkerTooltip._expProgress	:SetProgressRate( _tempWorkerExp )
	controlWorkerTooltip._name			:SetText( getWorkerName(workerStaticStatus) ) 			-- 이름

	local _tempActionPoint = tostring(workerData:getActionPoint()) .. "/" .. tostring(workerStaticStatus._actionPoint)
	controlWorkerTooltip._actionPointValue:SetText( _tempActionPoint )	 -- 액션포인트

	local _tempWorkEfficiency = 0
	if _tempWorkEfficiency < workerData:getWorkEfficiency(2) then	-- 거점생산
		_tempWorkEfficiency = workerData:getWorkEfficiency(2)
	end
	if _tempWorkEfficiency < workerData:getWorkEfficiency(5) then	-- 집제작
		_tempWorkEfficiency = workerData:getWorkEfficiency(5)
	end
	if _tempWorkEfficiency < workerData:getWorkEfficiency(6) then	-- 성채건설
		_tempWorkEfficiency = workerData:getWorkEfficiency(6)
	end
	if _tempWorkEfficiency < workerData:getWorkEfficiency(8) then	-- 대량생산
		_tempWorkEfficiency = workerData:getWorkEfficiency(8)
	end

	controlWorkerTooltip._efficiency2_Value:SetText( string.format("%.2f", tostring(_tempWorkEfficiency/1000000)) )		-- 작업 속도(가장 큰 값)		 
	controlWorkerTooltip._moveSpeedValue:SetText( string.format("%.2f", (workerData:getMoveSpeed()/100)))		-- 이동속도  .. " (+" .. string.format("%.2f", Int64toInt32(workerData:getMoveSpeedAdditionl())) .. ")"

	controlWorkerTooltip._luckValue:SetText( string.format( "%.2f", (workerData:getLuck())/10000 ) )		-- 행운  .. " (+" .. string.format("%.2f", Int64toInt32(workerData:getLuckAdditionl())/10000) .. ")"


	for skill_Index = 0, controlWorkerTooltip._maxSkillCount -1 do	--스킬 초기화
		controlWorkerTooltip._skill[skill_Index].iconBg:SetShow( true )
		local skillLev = 0
		if 0 == skill_Index then
			skillLev = 1
		else
			skillLev = skill_Index * 5
		end
		controlWorkerTooltip._skill[skill_Index].icon:SetShow( false )
		controlWorkerTooltip._skill[skill_Index].name:SetFontColor( UI_color.C_FF888888 )
		controlWorkerTooltip._skill[skill_Index].name:SetText( "Lv." .. skillLev )
		controlWorkerTooltip._skill[skill_Index].desc:SetFontColor( UI_color.C_FF888888 )
		controlWorkerTooltip._skill[skill_Index].desc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_WORKER_TOOLTIP_HAVENT_THISSKILL") )
	end

	local skillCount = workerData:getSkillCount()
	if 0 ~= skillCount then
		for skill_Index = 0, skillCount - 1 do
			local skillSSW = workerData:getWorkerSkillStaticStatusByIndex( skill_Index )
			if nil ~= skillSSW then
				controlWorkerTooltip._skill[skill_Index].iconBg:SetShow( true )
				controlWorkerTooltip._skill[skill_Index].icon:SetShow( true )
				controlWorkerTooltip._skill[skill_Index].icon:ChangeTextureInfoName( skillSSW:getIconPath() )

				controlWorkerTooltip._skill[skill_Index].name:SetFontColor( UI_color.C_FFEFEFEF )
				controlWorkerTooltip._skill[skill_Index].name:SetText( skillSSW:getName() )

				controlWorkerTooltip._skill[skill_Index].desc:SetFontColor( UI_color.C_FFFAE696 )
				controlWorkerTooltip._skill[skill_Index].desc:SetText( skillSSW:getDescription() )
			end
		end
	end

	-- { 위치 잡기}
		local posX = uiBase:GetParentPosX()
		local posY = uiBase:GetParentPosY()
		local parentSizeX =  uiBase:GetSizeX()
		local parentSizeY =  uiBase:GetSizeY()
		local tooltipSizeX = Panel_Worker_Tooltip:GetSizeX()
		local tooltipSizeY = Panel_Worker_Tooltip:GetSizeY()
		local scrnSizeX = getScreenSizeX()
		local scrnSizeY = getScreenSizeY()
		
		if ( ( scrnSizeX - posX - parentSizeX ) <  posX ) then
			posX = posX - tooltipSizeX - 5
		else
			posX = posX + parentSizeX + 5
		end
		
		if ( (scrnSizeY - posY - parentSizeY ) < posY ) then
			posY = posY - tooltipSizeY + parentSizeY + 5
		else
			posY = posY - 5
		end

		if true == isRight then
			posX = posX + parentSizeX + tooltipSizeX + 10
		elseif false == isRight then
			posX = posX - parentSizeX - tooltipSizeX - 5
		else
			-- 대처 안함.
		end
		
		if scrnSizeY < posY + tooltipSizeY then	-- 뚫고 나가는 것을 막자.
			posY = scrnSizeY - tooltipSizeY - 5
		elseif posY < 0 then
			posY = 5
		end

		Panel_Worker_Tooltip:SetPosX( posX )
		Panel_Worker_Tooltip:SetPosY( posY )
		
		Panel_Worker_Tooltip:SetShow( true, false )
		Panel_Worker_Tooltip:setFlushAble( false )

	-- }
end

function FGlobal_ShowWorkerTooltipByWorkerNoRaw( workerNoRaw, uiBase, isRight, isPlant )
	-- ♬ 툴팁이 열릴 때 사운드 추가
	audioPostEvent_SystemUi(01,13)

	local workerWrapperLua = getWorkerWrapper( workerNoRaw, true )

	local workerIcon	= workerWrapperLua:getWorkerIcon()
	local defaultSkill	= workerWrapperLua:getWorkerDefaultSkillStaticStatus()
	if nil ~= defaultSkill then
		controlWorkerTooltip._defaultSkillBox	:SetShow( true )
		controlWorkerTooltip._defaultSkillBox	:ComputePos()
		controlWorkerTooltip._skilBox			:SetSpanSize( 0, 270 )
		controlWorkerTooltip._skilBox			:ComputePos()

		controlWorkerTooltip._defaultSkillIcon	:ChangeTextureInfoName( defaultSkill:getIconPath() )
		controlWorkerTooltip._defaultSkillName	:SetText( defaultSkill:getName() )
		controlWorkerTooltip._defaultSkillDesc	:SetTextMode( UI_TM.eTextMode_AutoWrap )
		controlWorkerTooltip._defaultSkillDesc	:SetText( defaultSkill:getDescription() )

		controlWorkerTooltip._workerBg			:SetSize( controlWorkerTooltip._workerBg:GetSizeX(), 590 )

		tempPenelSizeY = controlWorkerTooltip._panel_Size + 150
	else
		controlWorkerTooltip._defaultSkillBox	:SetShow( false )
		controlWorkerTooltip._defaultSkillBox	:ComputePos()
		controlWorkerTooltip._skilBox			:SetSpanSize( 0, 185 )
		controlWorkerTooltip._skilBox			:ComputePos()

		controlWorkerTooltip._workerBg			:SetSize( controlWorkerTooltip._workerBg:GetSizeX(), 510 )

		tempPenelSizeY = controlWorkerTooltip._panel_Size + 65
	end

	if true == workerWrapperLua:isWorking() then
		local workName				= workerWrapperLua:getWorkString()
		local workNodeName			= workerWrapperLua:getWorkStringOnlyTarget()
		local workParentsNodeName	= workerWrapperLua:getWorkingNodeDesc()

		controlWorkerTooltip._workingNameBG		:SetPosY( controlWorkerTooltip._workerBg:GetPosY() + controlWorkerTooltip._workerBg:GetSizeY() + 5 )
		-- controlWorkerTooltip._workingNameValue:SetTextMode( UI_TM.eTextMode_LimitText )
		controlWorkerTooltip._workingNameValue	:SetText(workName .. "\n  " .. workParentsNodeName)
		controlWorkerTooltip._workingNameTitle	:SetShow(true)
		controlWorkerTooltip._workingNameValue	:SetShow(true)
		controlWorkerTooltip._workingNameBG		:SetShow(true)

		controlWorkerTooltip._panelBG:SetSize(controlWorkerTooltip._panelBG:GetSizeX(), tempPenelSizeY )
		Panel_Worker_Tooltip:SetSize(Panel_Worker_Tooltip:GetSizeX(), tempPenelSizeY )
	else
		controlWorkerTooltip._workingNameTitle	:SetShow(false)
		controlWorkerTooltip._workingNameValue	:SetShow(false)
		controlWorkerTooltip._workingNameBG		:SetShow(false)

		controlWorkerTooltip._panelBG:SetSize(controlWorkerTooltip._panelBG:GetSizeX(), tempPenelSizeY - 40 )
		Panel_Worker_Tooltip:SetSize(Panel_Worker_Tooltip:GetSizeX(), tempPenelSizeY - 40 )
	end
	
	controlWorkerTooltip._icon:ChangeTextureInfoName( workerIcon ) 									-- 아이콘

	local workerGrade =  workerWrapperLua:getGrade()	-- 일꾼 등급
	controlWorkerTooltip._name:SetFontColor( ConvertFromGradeToColor(workerGrade) )

	local workerLev			= workerWrapperLua:getLevel()
	local workerName		= workerWrapperLua:getName()

	local _tempWorkerExp	= 0
	local workerEXP			= workerWrapperLua:getExperience()
	local workerMaxEXP		= workerWrapperLua:getMaxExperience()
	if (toInt64(0,0) == workerEXP or toInt64(0,0) == workerMaxEXP ) then
		_tempWorkerExp = 0
	else
		_tempWorkerExp = math.ceil((Int64toInt32(workerEXP)/Int64toInt32(workerMaxEXP))*100)
	end


	controlWorkerTooltip._levelValue	:SetText( "Lv "..workerLev )
	controlWorkerTooltip._expProgress	:SetCurrentProgressRate( _tempWorkerExp )
	controlWorkerTooltip._expProgress	:SetProgressRate( _tempWorkerExp )
	controlWorkerTooltip._name			:SetText( workerName ) 			-- 이름

	local workerActionPoint		= workerWrapperLua:getActionPoint()
	local workerMaxActionPoint	= workerWrapperLua:getMaxActionPoint()

	local _tempActionPoint = tostring( workerActionPoint ) .. "/" .. tostring( workerMaxActionPoint )
	controlWorkerTooltip._actionPointValue:SetText( _tempActionPoint )	 -- 액션포인트

	local _tempWorkEfficiency = 0
	if _tempWorkEfficiency < workerWrapperLua:getWorkEfficiency(2) then	-- 거점생산
		_tempWorkEfficiency = workerWrapperLua:getWorkEfficiency(2)
	end
	if _tempWorkEfficiency < workerWrapperLua:getWorkEfficiency(5) then	-- 집제작
		_tempWorkEfficiency = workerWrapperLua:getWorkEfficiency(5)
	end
	if _tempWorkEfficiency < workerWrapperLua:getWorkEfficiency(6) then	-- 성채건설
		_tempWorkEfficiency = workerWrapperLua:getWorkEfficiency(6)
	end
	if _tempWorkEfficiency < workerWrapperLua:getWorkEfficiency(8) then	-- 대량생산
		_tempWorkEfficiency = workerWrapperLua:getWorkEfficiency(8)
	end

	controlWorkerTooltip._efficiency2_Value:SetText( string.format("%.2f", tostring(_tempWorkEfficiency/1000000)) )		-- 작업 속도(가장 큰 값)		 
	controlWorkerTooltip._moveSpeedValue:SetText( string.format("%.2f", (workerWrapperLua:getMoveSpeed()/100)))		-- 이동속도  .. " (+" .. string.format("%.2f", Int64toInt32(workerData:getMoveSpeedAdditionl())) .. ")"

	controlWorkerTooltip._luckValue:SetText( string.format( "%.2f", (workerWrapperLua:getLuck())/10000 ) )		-- 행운  .. " (+" .. string.format("%.2f", Int64toInt32(workerData:getLuckAdditionl())/10000) .. ")"


	for skill_Index = 0, controlWorkerTooltip._maxSkillCount -1 do	--스킬 초기화
		controlWorkerTooltip._skill[skill_Index].iconBg:SetShow( true )
		local skillLev = 0
		if 0 == skill_Index then
			skillLev = 1
		else
			skillLev = skill_Index * 5
		end
		controlWorkerTooltip._skill[skill_Index].icon:SetShow( false )
		controlWorkerTooltip._skill[skill_Index].name:SetFontColor( UI_color.C_FF888888 )
		controlWorkerTooltip._skill[skill_Index].name:SetText( "Lv." .. skillLev )
		controlWorkerTooltip._skill[skill_Index].desc:SetFontColor( UI_color.C_FF888888 )
		controlWorkerTooltip._skill[skill_Index].desc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_WORKER_TOOLTIP_HAVENT_THISSKILL") )
	end

	local skillCount = workerWrapperLua:getSkillCount()
	if 0 ~= skillCount then
		workerWrapperLua:foreachSkillList( function(index, skillStaticStatusWrapper)
			if ( nil == controlWorkerTooltip._skill[index] ) then
				return true
			end
			controlWorkerTooltip._skill[index].iconBg	:SetShow(true)
			controlWorkerTooltip._skill[index].icon		:SetShow(true)
			controlWorkerTooltip._skill[index].icon		:ChangeTextureInfoName( skillStaticStatusWrapper:getIconPath() )

			controlWorkerTooltip._skill[index].name		:SetFontColor( UI_color.C_FFEFEFEF )
			controlWorkerTooltip._skill[index].name		:SetText( skillStaticStatusWrapper:getName() )

			controlWorkerTooltip._skill[index].desc		:SetFontColor( UI_color.C_FFFAE696 )
			controlWorkerTooltip._skill[index].desc		:SetTextMode( UI_TM.eTextMode_AutoWrap )
			controlWorkerTooltip._skill[index].desc		:SetText( skillStaticStatusWrapper:getDescription() )

			return false
		end)
	end

	-- { 위치 잡기}
		local posX = uiBase:GetParentPosX()
		local posY = uiBase:GetParentPosY()
		local parentSizeX =  uiBase:GetSizeX()
		local parentSizeY =  uiBase:GetSizeY()
		local tooltipSizeX = Panel_Worker_Tooltip:GetSizeX()
		local tooltipSizeY = Panel_Worker_Tooltip:GetSizeY()
		local scrnSizeX = getScreenSizeX()
		local scrnSizeY = getScreenSizeY()
		
		if ( posX <  tooltipSizeX ) then
			posX = posX + parentSizeX + 5
		else
			posX = posX - tooltipSizeX - 5
		end
		
		if ( (scrnSizeY - posY - parentSizeY ) < posY ) then
			posY = posY - tooltipSizeY + parentSizeY + 5
		else
			posY = posY - 5
		end

		-- if true == isRight then
		-- 	posX = posX + parentSizeX + tooltipSizeX + 10
		-- elseif false == isRight then
		-- 	posX = posX - parentSizeX - tooltipSizeX - 5
		-- else
			-- 대처 안함.
		-- end
		
		if scrnSizeY < posY + tooltipSizeY then	-- 뚫고 나가는 것을 막자.
			posY = scrnSizeY - tooltipSizeY - 5
		elseif posY < 0 then
			posY = 5
		end

		Panel_Worker_Tooltip:SetPosX( posX )
		Panel_Worker_Tooltip:SetPosY( posY )
		
		Panel_Worker_Tooltip:SetShow( true, false )
		Panel_Worker_Tooltip:setFlushAble( false )

	-- }
end


function FGlobal_HideWorkerTooltip()
	if ( Panel_Worker_Tooltip:GetShow() and workerInfoTooltip == nil ) then	
		Panel_Worker_Tooltip:SetShow( false, false )
	end
end

function FGlobal_InitWorkerTooltip()
	workerInfoTooltip = nil
	FGlobal_HideWorkerTooltip()
end

function FromClient_WorkerInfoChanged( workerNoRaw, worker, isLevelup )
	-- 일꾼 정보가 갱신됐습니다.
	if true == isLevelup then
		local name = getWorkerName(worker:getWorkerStaticStatus())
		local lev = worker:getLevel()
		Proc_ShowMessage_Ack( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_WORKER_TOOLTIP_LVUP", "workName", name, "level", lev ) )
		-- {name}이 {level} 레벨이 됐습니다.
	end
end

registerEvent("FromClient_WorkerInfoChanged", 			"FromClient_WorkerInfoChanged")