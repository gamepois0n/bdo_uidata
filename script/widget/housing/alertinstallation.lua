local eWarningType = 
{
	eHarvestWarningType_BirdAttack  = 0,
	eHarvestWarningType_BugDetect   = 1,
	eHarvestWarningType_BugAttack   = 2,
	eHarvestWarningType_NeedLop     = 3,
	eHarvestWarningType_NeedWaterUp = 4,
}

local warningString = 
{
    [eWarningType.eHarvestWarningType_BirdAttack]    = PAGetString(Defines.StringSheet_GAME, "LUA_ALERTINSTALLATION_BIRDATTACK"), -- "새들의 공격을 받아 작물이 피해를 입었습니다.",
    [eWarningType.eHarvestWarningType_BugDetect]     = PAGetString(Defines.StringSheet_GAME, "LUA_ALERTINSTALLATION_BUGDETECT"), -- "작물에서 벌레가 생겨나기 시작했습니다.",
    [eWarningType.eHarvestWarningType_BugAttack]     = PAGetString(Defines.StringSheet_GAME, "LUA_ALERTINSTALLATION_BUGATTACK"), -- "벌레가 작물을 먹어치우고 있습니다!",
    [eWarningType.eHarvestWarningType_NeedLop]       = PAGetString(Defines.StringSheet_GAME, "LUA_ALERTINSTALLATION_NEEDLOP"), -- "작물이 엉켰습니다. 가지치기를 해야 합니다.",
    [eWarningType.eHarvestWarningType_NeedWaterUp]   = PAGetString(Defines.StringSheet_GAME, "LUA_ALERTINSTALLATION_NEEDWATERUP"), -- "지하수량이 부족해 작물의 수분량이 감소하고 있습니다.",
}

local warningString1 = 
{
    [eWarningType.eHarvestWarningType_BirdAttack]    = "새들이 모여들어 건초 더미를 헤집어 놓고 있습니다.",
    [eWarningType.eHarvestWarningType_BugDetect]     = "가축에 기생충이 생겨나기 시작했습니다.",
    [eWarningType.eHarvestWarningType_BugAttack]     = "벌레가 건초 더미를 먹어치우고 있습니다.",
    [eWarningType.eHarvestWarningType_NeedLop]       = "건초 더미의 상태가 나빠져 가축이 제대로 성장하지 못하고 있습니다.",
    [eWarningType.eHarvestWarningType_NeedWaterUp]   = "지하수량이 부족해 가축이 물을 제대로 먹지 못하고 있습니다.",
}

local warningMessage =
{
    [eWarningType.eHarvestWarningType_BirdAttack]    = function(tentPosition, characterSSW, progressingInfo, addtionalValue1)
		Proc_ShowMessage_Ack( characterSSW:getName() .. " : " .. warningString[eWarningType.eHarvestWarningType_BirdAttack] )
	end,
    [eWarningType.eHarvestWarningType_BugDetect]     = function(tentPosition, characterSSW, progressingInfo, addtionalValue1)
		Proc_ShowMessage_Ack( characterSSW:getName() .. " : " .. warningString[eWarningType.eHarvestWarningType_BugDetect] )
	end,
    [eWarningType.eHarvestWarningType_BugAttack]     = function(tentPosition, characterSSW, progressingInfo, addtionalValue1)
		--Proc_ShowMessage_Ack( characterSSW:getName() .. " : " .. warningString[eWarningType.eHarvestWarningType_BugAttack] )
	end,
    [eWarningType.eHarvestWarningType_NeedLop]       = function(tentPosition, characterSSW, progressingInfo, addtionalValue1)
		Proc_ShowMessage_Ack( characterSSW:getName() .. " : " .. warningString[eWarningType.eHarvestWarningType_NeedLop] )
	end,
    [eWarningType.eHarvestWarningType_NeedWaterUp]   = function(tentPosition, characterSSW, progressingInfo, addtionalValue1)
		if ( math.floor(progressingInfo:getNeedWater() / 200000) == math.floor(addtionalValue1 / 200000) ) then
			return
		end
		if ( 500000 <= progressingInfo:getNeedWater() ) then
			Proc_ShowMessage_Ack( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ALERTINSTALLATION_GETNEEDWATER", "getName", characterSSW:getName() ) ) -- characterSSW:getName() .. " : 작물의 수분량이 절반 이하로 감소하였습니다. 작물의 수분량이 0이 되면 작물수확량이 감소합니다." )	
		else
			Proc_ShowMessage_Ack( characterSSW:getName() .. " : " .. warningString[eWarningType.eHarvestWarningType_NeedWaterUp] )
		end
	end,
}

local warningMessage1 =
{
    [eWarningType.eHarvestWarningType_BirdAttack]    = function(tentPosition, characterSSW, progressingInfo, addtionalValue1)
		Proc_ShowMessage_Ack( characterSSW:getName() .. " : " .. warningString1[eWarningType.eHarvestWarningType_BirdAttack] )
	end,
    [eWarningType.eHarvestWarningType_BugDetect]     = function(tentPosition, characterSSW, progressingInfo, addtionalValue1)
		Proc_ShowMessage_Ack( characterSSW:getName() .. " : " .. warningString1[eWarningType.eHarvestWarningType_BugDetect] )
	end,
    [eWarningType.eHarvestWarningType_BugAttack]     = function(tentPosition, characterSSW, progressingInfo, addtionalValue1)
		--Proc_ShowMessage_Ack( characterSSW:getName() .. " : " .. warningString1[eWarningType.eHarvestWarningType_BugAttack] )
	end,
    [eWarningType.eHarvestWarningType_NeedLop]       = function(tentPosition, characterSSW, progressingInfo, addtionalValue1)
		Proc_ShowMessage_Ack( characterSSW:getName() .. " : " .. warningString1[eWarningType.eHarvestWarningType_NeedLop] )
	end,
    [eWarningType.eHarvestWarningType_NeedWaterUp]   = function(tentPosition, characterSSW, progressingInfo, addtionalValue1)
		if ( math.floor(progressingInfo:getNeedWater() / 200000) == math.floor(addtionalValue1 / 200000) ) then
			return
		end
		if ( 500000 <= progressingInfo:getNeedWater() ) then
			Proc_ShowMessage_Ack( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ALERTINSTALLATION_GETNEEDWATER", "getName", characterSSW:getName() ) ) -- characterSSW:getName() .. " : 작물의 수분량이 절반 이하로 감소하였습니다. 작물의 수분량이 0이 되면 작물수확량이 감소합니다." )	
		else
			Proc_ShowMessage_Ack( characterSSW:getName() .. " : " .. warningString1[eWarningType.eHarvestWarningType_NeedWaterUp] )
		end
	end,
}

function FromClient_InstallationInfoWarning( warningType, tentPosition, characterSSW, progressingInfo, actorWrapper, addtionalValue1 )
	if ( nil == progressingInfo ) then
		return
	end

	if nil == actorWrapper then
		return
	end
	local installationType = actorWrapper:getStaticStatusWrapper():getObjectStaticStatus():getInstallationType()
	if (CppEnums.InstallationType.eType_LivestockHarvest == installationType) then
		warningMessage1[warningType]( tentPosition, characterSSW, progressingInfo, addtionalValue1 )
	else
		warningMessage[warningType]( tentPosition, characterSSW, progressingInfo, addtionalValue1 )
	end
end

registerEvent("FromClient_InstallationInfoWarning", "FromClient_InstallationInfoWarning");