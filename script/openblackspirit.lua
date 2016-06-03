-- 흑정령 퀘가 있고, 안전지역이다! 너는 이미 흑정령을 부르고 있다.
local UIMode = Defines.UIMode
local IM = CppEnums.EProcessorInputMode

function OpenBlackSpirit( regionData )
	-- if nil == regionData then
		-- return
		-- -- _PA_LOG("효", "리턴1")
	-- end
	
	-- local isSafetyZone = regionData:get():isSafeZone()								-- 안전지역 여부 출력
	-- if ( isSafetyZone ) and ( questList_updateNewQuest() ) then
		-- -- getSelfPlayer():setActionChart("WAIT")
		-- -- _PA_LOG("효", "강제로 WAIT 해야쥐")
		
		-- local preUIMode = GetUIMode()
		-- local callSummon = RequestBeginTalkToClientNpc()
		
		-- SetUIMode( UIMode.eUIMode_NpcDialog_Dummy )
		-- if callSummon then
			-- UI.flushAndClearUI()				-- 일단 모든 창을 숨긴다
				-- -- _PA_LOG("효", "여기선 숨겨준다")
			-- UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
				-- -- _PA_LOG("효", "여기선 숨겨준다")
		-- else
			-- SetUIMode( preUIMode )
		-- end
		-- return
		-- -- _PA_LOG("효", "리턴3")
	-- end
end


registerEvent("selfPlayer_regionChanged", "OpenBlackSpirit")