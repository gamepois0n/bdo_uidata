local UIMode 	= Defines.UIMode
local IM 		= CppEnums.EProcessorInputMode

function appear_blackSpirit(questNo, isFlush )
	--_PA_LOG("최대호", "appear_blackSpirit : "..tostring( isFlush ) )
	ToClient_SaveUiInfo( true )
	close_WindowPanelList();
	local preUIMode = GetUIMode()
	SetUIMode( UIMode.eUIMode_NpcDialog_Dummy )
	local callSummon = RequestAppearBlackSpirit(questNo)
	if callSummon then
		if( isFlush ) then
			UI.flushAndClearUI()				-- 일단 모든 창을 숨긴다
		end

		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
		-- 아무 키 입력도 받지 않는 State 로 전환
		-- 그 이후에 클라에서 메시지가 와서 NpcDialog 가 뜨면, 키 입력이 재개 될것이다!
		-- UIMain_QuestUpdateRemove()
	else
		SetUIMode( preUIMode )
		ToClient_PopBlackSpiritFlush();
	end
end

registerEvent("appear_blackSpirit", "appear_blackSpirit")
