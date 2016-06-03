function FGlobal_MiniGame_HerbMachine() -- 약탕기 점프뛰기
	if(questList_hasProgressMiniGame(CppEnums.MiniGame.eMiniGameHerbMachine, CppEnums.MiniGameParam.eMiniGameParamDefault)) then
		request_clearMiniGame(CppEnums.MiniGame.eMiniGameHerbMachine, CppEnums.MiniGameParam.eMiniGameParamDefault)
	end
end

function FGlobal_MiniGame_Buoy() --추출장 부표 흔들어 추출하기
	if(questList_hasProgressMiniGame(CppEnums.MiniGame.eMiniGameBuoy, CppEnums.MiniGameParam.eMiniGameParamDefault)) then
		request_clearMiniGame(CppEnums.MiniGame.eMiniGameBuoy, CppEnums.MiniGameParam.eMiniGameParamDefault)
	end
end

function FGlobal_MiniGame_PowerControl() --소 젖 짜기
	if(questList_hasProgressMiniGame(CppEnums.MiniGame.eMiniGamePowerControl, CppEnums.MiniGameParam.eMiniGameParamDefault)) then
		request_clearMiniGame(CppEnums.MiniGame.eMiniGamePowerControl, CppEnums.MiniGameParam.eMiniGameParamDefault)	
	end
end

function FGlobal_MiniGame_Tutorial() -- 기본기의 이해
	if(questList_hasProgressMiniGame(CppEnums.MiniGame.eMiniGameTutorial, CppEnums.MiniGameParam.eMiniGameParamDefault)) then
		request_clearMiniGame(CppEnums.MiniGame.eMiniGameTutorial, CppEnums.MiniGameParam.eMiniGameParamDefault)
	end
end

function FGlobal_MiniGame_HouseControl_Empty() --주거지 구매하기
	if(questList_hasProgressMiniGame(CppEnums.MiniGame.eMiniGameBuyHouse, CppEnums.eHouseUseType.Empty)) then
		request_clearMiniGame( CppEnums.MiniGame.eMiniGameBuyHouse, CppEnums.eHouseUseType.Empty )
	end
end

function FGlobal_MiniGame_HouseControl_Depot() --창고 구매하기
	if(questList_hasProgressMiniGame(CppEnums.MiniGame.eMiniGameBuyHouse, CppEnums.eHouseUseType.Depot)) then
		request_clearMiniGame( CppEnums.MiniGame.eMiniGameBuyHouse, CppEnums.eHouseUseType.Depot )
	end
end

function FGlobal_MiniGame_HouseControl_Refinery() --정제소 구매
	if(questList_hasProgressMiniGame(CppEnums.MiniGame.eMiniGameBuyHouse, CppEnums.eHouseUseType.Refinery)) then
		request_clearMiniGame( CppEnums.MiniGame.eMiniGameBuyHouse, CppEnums.eHouseUseType.Refinery )
	end
end

function FGlobal_MiniGame_HouseControl_LocalSpecailtiesWorkshop() -- 작물 가공소 구매
	if(questList_hasProgressMiniGame(CppEnums.MiniGame.eMiniGameBuyHouse, CppEnums.eHouseUseType.LocalSpecailtiesWorkshop)) then
		request_clearMiniGame( CppEnums.MiniGame.eMiniGameBuyHouse, CppEnums.eHouseUseType.LocalSpecailtiesWorkshop )
	end
end

function FGlobal_MiniGame_HouseControl_Shipyard() -- 조선소
	if(questList_hasProgressMiniGame(CppEnums.MiniGame.eMiniGameBuyHouse, CppEnums.eHouseUseType.Shipyard)) then
		request_clearMiniGame( CppEnums.MiniGame.eMiniGameBuyHouse, CppEnums.eHouseUseType.Shipyard )
	end
end

function FGlobal_MiniGame_RequestPlantInvest(param) -- 퀘스트 : 거점 투자 (로기아 농장 - 옥수수 재배)
	if(questList_hasProgressMiniGame(CppEnums.MiniGame.eMiniGameInvestPlant, param)) then
		request_clearMiniGame( CppEnums.MiniGame.eMiniGameInvestPlant, param )
	end
end

function FGlobal_Tutorial_RequestSitDown() -- 퀘스트 : 앉아라
	if(questList_hasProgressQuest(2001, 189)) then
		request_clearMiniGame( CppEnums.MiniGame.eTutorialSitDown, CppEnums.MiniGameParam.eMiniGameParamDefault )
	end
end

function FGlobal_Tutorial_RequestLean() -- 퀘스트 : 기대라
	if(questList_hasProgressQuest(2001, 190)) then
		request_clearMiniGame( CppEnums.MiniGame.eTutorialLean, CppEnums.MiniGameParam.eMiniGameParamDefault )
	end
end

function FGlobal_MiniGame_RequestPlantWorking() -- 퀘스트 : 거점 생산 일 시키기 (로기아 농장 - 옥수수 재배)
	-- if(questList_hasProgressQuest(1698, 3)) then
		-- request_clearMiniGame(1006)	
	-- end
end

function FGlobal_MiniGame_RequestExtraction() -- 강화석 추출
	if(questList_hasProgressMiniGame(CppEnums.MiniGame.eMiniGameExtraction, CppEnums.MiniGameParam.eMiniGameParamDefault))then
		request_clearMiniGame(CppEnums.MiniGame.eMiniGameExtraction, CppEnums.MiniGameParam.eMiniGameParamDefault)
	end
end

function FGlobal_MiniGame_RequestEditingHouse(param) -- 집 꾸미기
	if(questList_hasProgressMiniGame(CppEnums.MiniGame.eMiniGameEditingHouse, param))then
		request_clearMiniGame(CppEnums.MiniGame.eMiniGameEditingHouse, param)
	end
end