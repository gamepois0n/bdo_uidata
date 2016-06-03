runLua("UI_Data/Script/Widget/Buff/AppliedBuff_View.lua")
runLua("UI_Data/Script/Widget/Buff/AppliedBuff_Control.lua")

-- -- Panel_AppliedBuffList:ActiveMouseEventEffect(true)
-- Panel_AppliedBuffList:SetShow(false, false)

-- local _styleBuffIcon 		= UI.getChildControl( Panel_AppliedBuffList, "StaticText_Buff"  )
-- local _styleDeBuffIcon 		= UI.getChildControl( Panel_AppliedBuffList, "StaticText_deBuff"  )
-- --local _close_BuffList 		= UI.getChildControl( Panel_AppliedBuffList, "Button_Win_Close" )
-- local _buffList_BG 			= UI.getChildControl( Panel_AppliedBuffList, "Static_Buff_BG" )
-- local _deBuffList_BG		= UI.getChildControl( Panel_AppliedBuffList, "Static_DeBuff_BG" )
-- local buffText				= UI.getChildControl( Panel_AppliedBuffList, "StaticText_buffText" )

-- local _maxBuffCount = 14
-- local _uiBuffList = {}
-- local _uiDeBuffList = {}
-- local uiToBuffIndex = {}

-- local buffIconIndex = -1
-- local tooltipDebuff = false
-- local iconSpan = _styleBuffIcon:GetSizeX() + 5
-- local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
-- local UI_classType = CppEnums.ClassType
-- local UI_TIMETOP =  Util.Time.inGameTimeFormattingTop

-- local _buffDataList = {}
-- local _cumulateTime = 0

-- local u64_Zero = Defines.u64_const.u64_0
-- local u64_1000 = Defines.u64_const.u64_1000

-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- local uiToInnerIndex = function( isDebuff, uiIndex )
	-- local index = uiIndex
	-- if ( isDebuff ) then
		-- index = index + _maxBuffCount
	-- end
	-- return index
-- end

-- local AddIndexSet = function( isDebuff, uiIndex, dataIndex )
	-- local index = uiToInnerIndex(isDebuff, uiIndex)
	-- uiToBuffIndex[index] = dataIndex
-- end

-- local getDataIndex = function( isDebuff, uiIndex )
	-- return uiToBuffIndex[uiToInnerIndex( isDebuff, uiIndex )]
-- end

-- local getDataGroup = function( isDebuff, uiIndex )
	-- local dataIndex = getDataIndex( isDebuff, uiIndex )
	-- if ( nil ~= dataIndex ) then
		-- return _buffDataList[dataIndex]
	-- end
	-- return nil
-- end



-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- local init = function()
	-- _styleBuffIcon:SetShow( false )
	-- _styleDeBuffIcon:SetShow( false )
	-- --_close_BuffList:SetShow( false )
	-- _buffList_BG:SetShow( false )
	-- _deBuffList_BG:SetShow( false )

	-- -- index 를 1부터 시작하도록 했다!
	-- for index = 1, _maxBuffCount, 1 do
		-- local buffIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_AppliedBuffList, 'AppliedBuff_' .. index)
		-- CopyBaseProperty( _styleBuffIcon, buffIcon )
		-- buffIcon:SetPosX( _buffList_BG:GetPosX() + iconSpan * (index -1) + 2 )
		-- buffIcon:SetPosY( _buffList_BG:GetPosY() + 2 )
		-- buffIcon:SetShow(false)
		-- buffIcon:SetIgnore(false)
	
		-- local deBuffIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_AppliedBuffList, 'AppliedDeBuff_' .. index)
		-- CopyBaseProperty( _styleDeBuffIcon, deBuffIcon )
		-- deBuffIcon:SetPosX( _deBuffList_BG:GetPosX() + iconSpan * (index-1) + 2 )
		-- deBuffIcon:SetPosY( _deBuffList_BG:GetPosY() + 2 )
		-- deBuffIcon:SetShow(false)
		-- deBuffIcon:SetIgnore(false)

		-- buffIcon:addInputEvent( "Mouse_On", "ShowBuffTooltip(".. index ..",false)" )
		-- buffIcon:addInputEvent( "Mouse_Out", "HideBuffTooltip(".. index ..",false)" )
		-- deBuffIcon:addInputEvent( "Mouse_On", "ShowBuffTooltip(".. index ..",true)" )
		-- deBuffIcon:addInputEvent( "Mouse_Out", "HideBuffTooltip(".. index ..",true)" )
	
		-- _uiBuffList[index] = buffIcon
		-- _uiDeBuffList[index] = deBuffIcon
	-- end
	-- _buffList_BG:SetIgnore(true)
	-- _deBuffList_BG:SetIgnore(true)
-- end

-- function AppliedBuffList_Update( fDeltaTime )
	-- if isFlushedUI() then
		-- return
	-- end

	-- -- 버프가 없으면 숨긴다!
	-- if ( 0 == #_buffDataList ) then
		-- if Panel_UIControl:IsShow() then
			-- Panel_AppliedBuffList:SetShow( true, false )
			-- _buffList_BG:SetShow( true )
			-- _deBuffList_BG:SetShow( true )
		-- else
			-- Panel_AppliedBuffList:SetShow( false, false )
			-- _buffList_BG:SetShow( false )
			-- _deBuffList_BG:SetShow( false )
			-- _cumulateTime = 0
			-- -- 만에 하나 툴팁이 남는 경우를 차단한다.
			-- local TooltipCommon_idx = TooltipCommon_getCurrentIndex()
			-- if -1 ~= TooltipCommon_idx then
				-- TooltipCommon_Hide( TooltipCommon_idx )
			-- end
			-- return
		-- end
	-- end

	-- _cumulateTime = _cumulateTime + fDeltaTime
	
	-- local cumulateTimeInSecond = math.floor(_cumulateTime)
	-- local u64_cumulateTime = toUint64(0, cumulateTimeInSecond)
	-- local icon = nil
	-- local deBuffIcon = nil

	-- if ( 1 < _cumulateTime ) then
		-- local buffIconSizeX = 0
		-- local debuffIconSizeX = 0
		-- local showIndexDebuff = 1
		-- local showIndexBuff = 1

		-- for dataIndex, buffInfo in ipairs( _buffDataList ) do
			-- if buffInfo._u64_remainedTime <= u64_cumulateTime then
				-- buffInfo._u64_remainedTime = u64_Zero
			-- else
				-- buffInfo._u64_remainedTime = buffInfo._u64_remainedTime - u64_cumulateTime
			-- end
			
			-- -- 0초일 때 아이콘을 강제로 꺼버린다
			-- if ( buffInfo.isDebuff ) then
				-- icon = _uiDeBuffList[showIndexDebuff]
				-- showIndexDebuff = showIndexDebuff +1
			-- else
				-- icon = _uiBuffList[showIndexBuff]
				-- showIndexBuff = showIndexBuff +1
			-- end
			
			-- -- 0초일 때 아이콘을 강제로 꺼버린다
			-- local isShow = u64_Zero < buffInfo._u64_remainedTime
			-- if ( isShow ) then
				-- icon:SetText(UI_TIMETOP(buffInfo._u64_remainedTime))

				-- if ( buffInfo.isDebuff ) then
					-- icon:SetPosX( debuffIconSizeX + 2)
					-- debuffIconSizeX = debuffIconSizeX + 37
					-- _deBuffList_BG:SetSize( debuffIconSizeX, 52 )
					
				-- else
					-- icon:SetPosX( buffIconSizeX + 2)
					-- buffIconSizeX = buffIconSizeX + 37
					-- _buffList_BG:SetSize( buffIconSizeX, 52 )
				-- end
			-- end
			
			-- icon:SetShow( isShow )
		-- end
		
		-- if ( buffIconSizeX > 0  ) then
			-- -- _buffList_BG:SetSize( buffIconSizeX, 52 )
			-- _buffList_BG:SetShow( true )
		-- else
			-- _buffList_BG:SetShow( false )
		-- end
		-- if ( debuffIconSizeX > 0 ) then
			-- -- _deBuffList_BG:SetSize( debuffIconSizeX, 52 )
			-- _deBuffList_BG:SetShow( true )
		-- else
			-- _deBuffList_BG:SetShow( false )
		-- end
		-- _cumulateTime = 0
	-- end
	-- --_cumulateTime = _cumulateTime - cumulateTimeInSecond
-- end

-- function ResponseBuff_changeBuffList()
	-- if isFlushedUI() then
		-- return
	-- end

	-- _buffDataList = {}

	-- local buffIndex = 1
	-- local debuffIndex = 1
	-- local index = 1
	-- local appliedBuff = getSelfPlayer():getAppliedBuffBegin()
	-- if nil == appliedBuff then
		-- return
	-- end
	-- local buffIconSizeX = 0
	-- local debuffIconSizeX = 0
		
	-- while (appliedBuff ~= nil) do
		-- local u64_calc_time1 = appliedBuff:getRemainedTime_u64() / u64_1000		
		-- if u64_Zero < u64_calc_time1 then
			-- local icon
			-- if ( appliedBuff:isDebuff() ) then
				-- icon = _uiDeBuffList[debuffIndex]
				-- AddIndexSet( true, debuffIndex, index )
				-- debuffIndex = debuffIndex + 1
				-- debuffIconSizeX = debuffIconSizeX + 37
			-- else
				-- icon = _uiBuffList[buffIndex]
				-- AddIndexSet( false, buffIndex, index )
				-- buffIndex = buffIndex + 1
				-- buffIconSizeX = buffIconSizeX + 37
			-- end
			-- icon:ChangeTextureInfoName("icon/" .. appliedBuff:getIconName())
			-- icon:SetShow(true)
			-- icon:SetText(UI_TIMETOP(u64_calc_time1))

			-- _buffDataList[index]  = { _buff = appliedBuff, _u64_remainedTime = u64_calc_time1, isDebuff = appliedBuff:isDebuff() }
			
			-- index = index + 1
		-- end
		
		-- if(_maxBuffCount <= index) then
			-- break;
		-- end
		
		-- appliedBuff = getSelfPlayer():getAppliedBuffNext()
	-- end

	-- -- 버프가 하나라도 있으면 패널을 보여준다!
	-- -- 버프 index는 다음것을 가르키기때문에 -1 한다.
	-- if 1 <= buffIndex -1 or 1 <= debuffIndex -1 then
		-- Panel_AppliedBuffList:SetShow(true)
		-- if( 0 < debuffIconSizeX ) then
			-- _deBuffList_BG:SetShow(true)
			-- _deBuffList_BG:SetSize( debuffIconSizeX, 52 )
		-- end
		
		-- if( 0 < buffIconSizeX ) then
			-- _buffList_BG:SetShow(true)		
			-- _buffList_BG:SetSize( buffIconSizeX, 52 )
		-- end
	-- end

	-- local buffIndexTmp = buffIconIndex
	-- local isDebuff = tooltipDebuff
	-- HideBuffTooltip( buffIconIndex, isDebuff )
	-- if ( -1 < buffIndexTmp ) and ( buffIndexTmp < buffIndex ) then
		-- ShowBuffTooltip( buffIndexTmp, isDebuff )
	-- end

	-- -- 버프 아이콘을 없애준다
	-- for index = buffIndex, _maxBuffCount, 1 do
		-- _uiBuffList[index]:SetShow(false)
	-- end
	-- for index = debuffIndex, _maxBuffCount, 1 do
		-- _uiDeBuffList[index]:SetShow(false)
	-- end
-- end

-- function buff_RunPostRestoreFunction()
	-- ResponseBuff_changeBuffList()
	-- AppliedBuffList_Update( 0 )
-- end
-- UI.addRunPostRestorFunction( buff_RunPostRestoreFunction )

-- function ShowBuffTooltip( buffIndex, isDebuff )
	-- -- _PA_LOG("LUA", tostring(buffIndex) .. "   " .. tostring(isDebuff) )
	-- local buffInfo = getDataGroup( isDebuff, buffIndex )
	-- local dataIndex = getDataIndex( isDebuff, buffIndex )

	-- local icon
	-- if ( isDebuff ) then
		-- icon = _uiDeBuffList[buffIndex]
	-- else
		-- icon = _uiBuffList[buffIndex]
	-- end

	-- if( buffInfo ~= nil ) or ( deBuffInfo ~= nil ) then
		-- buffIconIndex = buffIndex
		-- tooltipDebuff = isDebuff
		-- TooltipCommon_Show( dataIndex, icon, buffInfo._buff:getIconName() , buffInfo._buff:getBuffDesc(), '' )
	-- end
-- end

-- function HideBuffTooltip( buffIndex, isDebuff )
	-- TooltipCommon_Hide( getDataIndex( isDebuff, buffIndex ) )
	-- buffIconIndex = -1
	-- tooltipDebuff = false
-- end

-- function AppliedBuffList_ChangeTexture_On()	
	-- if Panel_UIControl:IsShow() then
		-- --_close_BuffList:SetShow(true)
		-- Panel_AppliedBuffList:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_drag.dds")
		-- buffText:SetText( PAGetString(Defines.StringSheet_GAME, "BUFF_LIST_MOVE") )
	-- end
-- end

-- function AppliedBuffList_ChangeTexture_Off()
	-- --_close_BuffList:SetShow(false)
	-- if Panel_UIControl:IsShow() then		
		-- Panel_AppliedBuffList:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_isWidget.dds")
		-- buffText:SetText( PAGetString(Defines.StringSheet_GAME, "BUFF_LIST") )
	-- else		
		-- Panel_AppliedBuffList:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_empty.dds")
	-- end
-- end



-- Panel_AppliedBuffList:addInputEvent( "Mouse_On", "AppliedBuffList_ChangeTexture_On()" )
-- Panel_AppliedBuffList:addInputEvent( "Mouse_Out", "AppliedBuffList_ChangeTexture_Off()" )
-- Panel_AppliedBuffList:addInputEvent( "Mouse_Lup", "ResetPos_WidgetButton()")
-- registerEvent("ResponseBuff_changeBuffList",	"ResponseBuff_changeBuffList")
-- Panel_AppliedBuffList:RegisterUpdateFunc( "AppliedBuffList_Update" )


-- init()
-- AppliedBuffList_Show()