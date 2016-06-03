------------------------------------------------------
-- 		HP 양에 따라서 반짝거림이 나타난다.
-- 08-08 경고 40퍼
-- 08-09 경고 20퍼
-- 08-10 경고 10퍼

local enumRate = {
	rate_40over = 0,
	rate_20over = 1,
	rate_else	= 2,
}

local rateType = enumRate.rate_40over

function SelfPlayer_HpCheck_SoundFunction( actorKeyRaw, hp, maxHp )
	local actorProxyWrapper = getActor( actorKeyRaw )
	if ( nil == actorProxyWrapper ) then
		-- _PA_LOG("LUA", "리턴 위에 1")
		return
	end
	
	if ( false == actorProxyWrapper:get():isSelfPlayer() ) then
		-- _PA_LOG("LUA", "리턴 위에 2")
		return
	end
	local rate = hp / maxHp * 100
	local currRateType
	if ( 40 <= rate ) then
		currRateType = enumRate.rate_40over
	elseif ( 20 <= rate ) then
		currRateType = enumRate.rate_20over
	else
		currRateType = enumRate.rate_else
	end
	
	if ( currRateType == rateType ) then
		-- _PA_LOG("LUA", "리턴 위에 3")
		return
	end
	if ( currRateType < rateType ) then
		rateType = currRateType
		return
	end
	rateType = currRateType
	
	
	if ( enumRate.rate_20over == rateType ) then
		-- _PA_LOG("LUA", "사십")
		-- ♬ 경고음 40%
		audioPostEvent_SystemUi(08,08)
	elseif ( enumRate.rate_else == rateType ) then
		-- _PA_LOG("LUA", "이십")
		-- ♬ 경고음 20%
		-- audioPostEvent_SystemUi(08,09) -- 20% 긴급회피 메시지 및 사운드 들어가며 이건 삭제 2015.03.05
	end
end

registerEvent("hpChanged", "SelfPlayer_HpCheck_SoundFunction")