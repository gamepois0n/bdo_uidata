local workerNoUndefined = 0
local appliedStat = NpcWorkerSkillAppliedStat()
local checkData = PlantWorkerPassiveSkillCheckData(appliedStat)


local workerWrapper = {}
workerWrapper.__index = workerWrapper

--초기화 ( 내부용 )
function workerWrapper:init( workerNoRaw, callReflesh )
	self:initOnly( workerNoRaw, callReflesh )
	self:setClientValue()
end

--초기화 ( 내부용 )
function workerWrapper:initOnly( workerNoRaw, callReflesh )
	self._workerNoRaw = workerNoRaw
	if ( nil == callReflesh ) then
		self._callReflesh = true
	else
		self._callReflesh = callReflesh
	end
end
--wrapper다시 셋팅 및 상태 변환시
--ex: 일하지않던 일꾼이 일하는 상태로 바뀐경우
function workerWrapper:reflesh()
	if ( false == self._callReflesh ) then
		return
	end

	self:setClientValue()
end

--해당 일꾼이 일하고있는지여부
function workerWrapper:isWorking()
	return nil ~= self._workingWrapper
end

--데이터가 정상적인지 ( 내부용 )
function workerWrapper:isValid()
	return nil ~= self._workerWrapper and nil ~= self._workerWrapper:get()
end

--wrapper다시 셋팅 ( 내부용 )
function workerWrapper:setClientValue()
	-- 안의 값이 workerNo와 맞는지 체크후 스킵할것
	self._workerWrapper = ToClient_getNpcWorkerByWorkerNo(self._workerNoRaw)
	self._workingWrapper = ToClient_getNpcWorkingByWorkerNo(self._workerNoRaw)
end

-- 일꾼 래퍼 반환(툴팁용)
function workerWrapper:getWorkerWrapper()
	return self._workerWrapper
end

--현재 일꾼의 일할 횟수 가져오는 함수
function workerWrapper:getWorkingCount()
	self:reflesh()
	return self:getWorkingCountXXX()
end

--현재 일꾼의 일할 횟수 가져오는 함수 ( 내부용 )
function workerWrapper:getWorkingCountXXX()
	return ToClient_getNpcWorkerWorkingCount(self._workerNoRaw)
end

--현재 일꾼의 남은 일할 시간
--일안하면 0반환
function workerWrapper:getLeftWorkingTime()
	self:reflesh()
	return self:getLeftWorkingTimeXXX(getServerUtc64())
end

--현재 일꾼의 남은 일할 시간 ( 내부용 )
--일안하면 0반환
function workerWrapper:getLeftWorkingTimeXXX(serverUtc64)
	if ( false == self:isWorking() ) then
		return 0
	end
	return Int64toInt32(self._workingWrapper:getLeftWorkTime( serverUtc64 ))
end

--현재하고 있는 일의 제한시간이 무제한인경우 true , 아니면 false
function workerWrapper:isWorkTimeUnlimitXXX()
	if ( false == self:isWorking() ) then
		return true
	end
	return self._workingWrapper:isWorkTimeUnlimit()
end

--현재 일꾼의 전체 일할 시간
--일안하면 0반환
function workerWrapper:getTotalWorkTime()
	self:reflesh()
	return self:getTotalWorkTimeXXX(getServerUtc64())
end

--현재 일꾼의 전체 일할 시간 ( 내부용 )
--일안하면 0반환
function workerWrapper:getTotalWorkTimeXXX( serverUtc64 )
	if ( false == self:isWorking() ) then
		return 0
	end
	return Int64toInt32(self._workingWrapper:getTotalWorkTime( serverUtc64 ))
end

--현재 일하고있는 일꾼의 WorkingState
--일안하거나 state를 안쓰는 타입이면 CppEnums.NpcWorkingState.eNpcWorkingState_Undefined 반환
function workerWrapper:getWorkingState()
	self:reflesh()
	return self:getWorkingStateXXX()
end

--현재 일하고있는 일꾼의 WorkingState
--일안하거나 state를 안쓰는 타입이면 CppEnums.NpcWorkingState.eNpcWorkingState_Undefined 반환
function workerWrapper:getWorkingStateXXX()
	if ( false == self:isWorking() ) then
		return CppEnums.NpcWorkingState.eNpcWorkingState_Undefined
	end
	return self._workingWrapper:getWorkingState()
end

--현재 일꾼이 일하고있다면 진행정도
--일하고있지않다면 0 반환 ( isWorking() 체크이후에 사용하는것으로.. )
function workerWrapper:currentProgressPercents()
	self:reflesh()
	if ( false == self:isWorking() ) then
		return 0
	end

	if ( self:isWorkTimeUnlimitXXX() ) then
		return 0
	end

	local serverUtc64 = getServerUtc64()
	local working_LeftTime	= self:getLeftWorkingTimeXXX(serverUtc64)
	local working_TotalTime	= self:getTotalWorkTimeXXX(serverUtc64)

	if ( 0 == working_TotalTime ) then
		return 0
	end

	return 100 - ((working_LeftTime / working_TotalTime) * 100)	
end

--현재 일꾼이 일하고있는 상태 string
function workerWrapper:getWorkStringOnlyTarget()
	self:reflesh()

	local workString = ""
	if self:isWorking() then
		local working_LeftTime	= 0
		local isWorkTimeUnlimit = self:isWorkTimeUnlimitXXX()
		if ( false == isWorkTimeUnlimit ) then
			working_LeftTime = self:getLeftWorkingTimeXXX( getServerUtc64() )
		end
		if ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantZone) )
			or ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouse) )
			or ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouseLargeCraft) ) then
			
			local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(self._workerNoRaw)
			if nil ~= esSSW then
				workString 	= "(" .. self._workingWrapper:getWorkingNodeName() .. ")"
			end
					
		elseif ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantBuliding) ) then
			local name = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_BULDINGTYPE_FORTRESS") -- 성채
			local characterSSW = self._workingWrapper:getBuildingCharacterInfo()
			if ( nil ~= characterSSW ) then
				name = characterSSW:getName()
			end
			workString 	= Util.Time.timeFormatting(math.ceil(working_LeftTime/1000)) .. " <PAColor0xffd0ee68>[" .. name .. "]<PAOldColor>"
		elseif ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_Upgrade) ) then
			workString 	= Util.Time.timeFormatting(math.ceil(working_LeftTime/1000)) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_WORKER_UPGRADE")
		elseif ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_GuildHouseLargeCraft) ) then
			local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(self._workerNoRaw)
			if nil ~= esSSW then
				local _leftWorkCount	= self:getWorkingCountXXX()
				if 0 < _leftWorkCount then
					workString 	= Util.Time.timeFormatting(math.ceil(working_LeftTime/1000)) .. " [" .. esSSW:getDescription() .. PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_LEFTWORKCOUNT", "leftWorkCount", _leftWorkCount+1 ) .. "]"
				else
					workString 	= Util.Time.timeFormatting(math.ceil(working_LeftTime/1000)) .. " [" .. esSSW:getDescription() .. "]"
				end
			end
		elseif ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_HarvestWorking) ) then
			if ( false == isWorkTimeUnlimit ) then
				workString 	= Util.Time.timeFormatting(math.ceil(working_LeftTime/1000))
			end

			local workingState = self:getWorkingStateXXX()
			if ( CppEnums.NpcWorkingState.eNpcWorkingState_HarvestWorking_MoveTo == workingState ) then
				workString = workString .. PAGetString(Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_WORKER_GOHARVEST") -- "[텃밭 이동중]"
			elseif ( CppEnums.NpcWorkingState.eNpcWorkingState_HarvestWorking_Working == workingState ) then
				workString = workString .. PAGetString(Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_WORKER_HARVESTMANAGING") -- "[텃밭 관리중]"
			elseif ( CppEnums.NpcWorkingState.eNpcWorkingState_HarvestWorking_Return == workingState ) then
				workString = workString .. PAGetString(Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_WORKER_GOHOME") -- "[귀가중]"
			end
		end
	elseif self:getIsAuctionInsert() then
		workString = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_WORKER_MARKETREGIST") -- "<PAColor0xffde8585>[거래소 등록]<PAOldColor>"
	else
		workString = ""
	end
	return workString
end


--현재 일꾼이 일하고있는 상태 string
function workerWrapper:getWorkString()
	self:reflesh()

	local workString = ""
	if self:isWorking() then
		local working_LeftTime	= 0
		local isWorkTimeUnlimit = self:isWorkTimeUnlimitXXX()
		if ( false == isWorkTimeUnlimit ) then
			working_LeftTime = self:getLeftWorkingTimeXXX( getServerUtc64() )
		end
		if ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantZone) )
			or ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouse) )
			or ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouseLargeCraft) ) then
			
			local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(self._workerNoRaw)
			if nil ~= esSSW then
				local _leftWorkCount	= self:getWorkingCountXXX()
				if 0 < _leftWorkCount then
					workString 	= Util.Time.timeFormatting(math.ceil(working_LeftTime/1000)) .. " [" .. esSSW:getDescription() .. PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_LEFTWORKCOUNT", "leftWorkCount", _leftWorkCount+1 ) .. "]"
				else
					workString 	= Util.Time.timeFormatting(math.ceil(working_LeftTime/1000)) .. " [" .. esSSW:getDescription() .. "]"
				end
			end
					
		elseif ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantBuliding) ) then
			local name = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_BULDINGTYPE_FORTRESS") -- 성채
			--local characterSSW = self._workingWrapper:getBuildingCharacterInfo()
			--if ( nil ~= characterSSW ) then
			--	name = characterSSW:getName()
			--end
			workString 	= Util.Time.timeFormatting(math.ceil(working_LeftTime/1000)) .. " <PAColor0xffd0ee68>[" .. name .. "]<PAOldColor>"
		elseif ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_Upgrade) ) then
			workString 	= Util.Time.timeFormatting(math.ceil(working_LeftTime/1000)) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_WORKER_UPGRADE")
		elseif ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_GuildHouseLargeCraft) ) then
			local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(self._workerNoRaw)
			if nil ~= esSSW then
				local _leftWorkCount	= self:getWorkingCountXXX()
				if 0 < _leftWorkCount then
					workString 	= Util.Time.timeFormatting(math.ceil(working_LeftTime/1000)) .. " [" .. esSSW:getDescription() .. PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_LEFTWORKCOUNT", "leftWorkCount", _leftWorkCount+1 ) .. "]"
				else
					workString 	= Util.Time.timeFormatting(math.ceil(working_LeftTime/1000)) .. " [" .. esSSW:getDescription() .. "]"
				end
			end
		elseif ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_HarvestWorking) ) then
			if ( false == isWorkTimeUnlimit ) then
				workString 	= Util.Time.timeFormatting(math.ceil(working_LeftTime/1000))
			end

			local workingState = self:getWorkingStateXXX()
			if ( CppEnums.NpcWorkingState.eNpcWorkingState_HarvestWorking_MoveTo == workingState ) then
				workString = workString .. PAGetString(Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_WORKER_GOHARVEST") -- "[텃밭 이동중]"
			elseif ( CppEnums.NpcWorkingState.eNpcWorkingState_HarvestWorking_Working == workingState ) then
				workString = workString .. PAGetString(Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_WORKER_HARVESTMANAGING") -- "[텃밭 관리중]"
			elseif ( CppEnums.NpcWorkingState.eNpcWorkingState_HarvestWorking_Return == workingState ) then
				workString = workString .. PAGetString(Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_WORKER_GOHOME") -- "[귀가중]"
			end
		end
	elseif self:getIsAuctionInsert() then
		workString = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_WORKER_MARKETREGIST") -- "<PAColor0xffde8585>[거래소 등록]<PAOldColor>"
	else
		local workerRegionWrapper	= ToClient_getRegionInfoWrapper( self._workerWrapper:get() )
		workString = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORKERLUAWRAPPER_WORKER_WAITING", "getAreaName", workerRegionWrapper:getAreaName() ) -- <PAColor0xff797979>[대기중 : " .. workerRegionWrapper:getAreaName() .. "]<PAOldColor>
	end

	return workString
end


function workerWrapper:getWorkingType()
	self:reflesh()

	local workingType = nil
	if self:isWorking() then
		if ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantZone) ) then						-- 농장
			workingType = CppEnums.NpcWorkingType.eNpcWorkingType_PlantZone
		elseif ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_Upgrade) ) then					-- 승급
			workingType = CppEnums.NpcWorkingType.eNpcWorkingType_Upgrade
		elseif ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouse) ) then				-- rentHouse 제작
			workingType = CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouse
		elseif ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_ChangeTown) ) then					-- 생략
			workingType = CppEnums.NpcWorkingType.eNpcWorkingType_ChangeTown
		elseif ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantBuliding) ) then				-- 건설
			workingType = CppEnums.NpcWorkingType.eNpcWorkingType_PlantBuliding
		elseif ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_RegionManaging) ) then				-- 영지 관리
			workingType = CppEnums.NpcWorkingType.eNpcWorkingType_RegionManaging
		elseif ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouseLargeCraft) ) then	-- 대량 제작
			workingType = CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouseLargeCraft
		elseif ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_HouseParty) ) then					-- 파티
			workingType = CppEnums.NpcWorkingType.eNpcWorkingType_HouseParty
		elseif ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_GuildHouseLargeCraft) ) then		-- 길드 제작
			workingType = CppEnums.NpcWorkingType.eNpcWorkingType_GuildHouseLargeCraft
		elseif ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_HarvestWorking) ) then				-- 텃밭
			workingType = CppEnums.NpcWorkingType.eNpcWorkingType_HarvestWorking
		end
	else	-- 휴식중.
		workingType = CppEnums.NpcWorkingType.eNpcWorkingType_Count
	end

	return workingType
end


--일꾼의 이름 가져오기
function workerWrapper:getName()
	self:reflesh()
    return self._workerWrapper:getName()
end

--일꾼의 레벨 가져오기
function workerWrapper:getLevel()
	self:reflesh()
    return self._workerWrapper:get():getLevel()
end

-- 일꾼의 현재 경험치 가져오기( int64 )
function workerWrapper:getExperience()
	self:reflesh()
	return self._workerWrapper:get():getExperience()
end

-- 일꾼의 최대 경험치 가져오기( int64 )
function workerWrapper:getMaxExperience()
	self:reflesh()
	return self._workerWrapper:get():getMaxExperience()
end

--일꾼의 HomeWaypoint 가져오기
function workerWrapper:getHomeWaypoint()
	self:reflesh()
    return self._workerWrapper:get():getHomeWaypoint()
end

--일꾼의 현재 액션포인트 가져오기
function workerWrapper:getActionPoint()
	self:reflesh()
    return self:getActionPointXXX()
end

--일꾼의 현재 액션포인트 가져오기 ( 내부용 )
function workerWrapper:getActionPointXXX()
    return self._workerWrapper:get():getActionPoint()
end

--일꾼의 최대 액션포인트 가져오기
function workerWrapper:getMaxActionPoint()
	self:reflesh()
    return self:getMaxActionPointXXX()
end

--일꾼의 최대 액션포인트 가져오기 ( 내부용 )
function workerWrapper:getMaxActionPointXXX()
    return self._workerWrapper:get():getWorkerStaticStatus()._actionPoint
end

--일꾼의 현재 액션포인트 퍼센트 가져오기
function workerWrapper:getActionPointPercents()
	self:reflesh()
    return self:getActionPointXXX() / self:getMaxActionPointXXX() * 100
end

--일꾼의 등급 가져오기
function workerWrapper:getGrade()
	self:reflesh()
    return self:getGradeXXX()
end

--일꾼의 등급 가져오기 ( 내부용 )
function workerWrapper:getGradeXXX()
    return self._workerWrapper:get():getWorkerStaticStatus():getCharacterStaticStatus()._gradeType:get()
end

--일꾼 승급 가능 횟수를 가져온다.
function workerWrapper:getUpgradePoint()
	self:reflesh()
    return self._workerWrapper:get():getUpgradePoint()	
end

-- 일꾼의 등급색 가져오기
function workerWrapper:getGradeToColor()
    local grade = self:getGradeXXX()
	if ( CppEnums.CharacterGradeType.CharacterGradeType_Normal == grade ) then
		return Defines.Color.C_FFC4BEBE
	elseif ( CppEnums.CharacterGradeType.CharacterGradeType_Elite == grade ) then
		return Defines.Color.C_FF5DFF70
	elseif ( CppEnums.CharacterGradeType.CharacterGradeType_Hero == grade ) then
		return Defines.Color.C_FF4B97FF
	elseif ( CppEnums.CharacterGradeType.CharacterGradeType_Legend == grade ) then
		return Defines.Color.C_FFFFC832
	elseif ( CppEnums.CharacterGradeType.CharacterGradeType_Boss == grade ) then
		return Defines.Color.C_FFFF6C00
	elseif ( CppEnums.CharacterGradeType.CharacterGradeType_Assistant == grade ) then
		return Defines.Color.C_FFC4BEBE
	end
	
	-- error상태
	return Defines.Color.C_FFC4BEBE
end

-- 일꾼의 등급색글씨 가져오기
function workerWrapper:getGradeToColorString()
    local grade = self:getGradeXXX()
	if ( CppEnums.CharacterGradeType.CharacterGradeType_Normal == grade ) then
		return "<PAColor0xffc4bebe>"
	elseif ( CppEnums.CharacterGradeType.CharacterGradeType_Elite == grade ) then
		return "<PAColor0xFF5DFF70>"
	elseif ( CppEnums.CharacterGradeType.CharacterGradeType_Hero == grade ) then
		return "<PAColor0xFF4B97FF>"
	elseif ( CppEnums.CharacterGradeType.CharacterGradeType_Legend == grade ) then
		return "<PAColor0xFFFFC832>"
	elseif ( CppEnums.CharacterGradeType.CharacterGradeType_Boss == grade ) then
		return "<PAColor0xFFFF6C00>"
	elseif ( CppEnums.CharacterGradeType.CharacterGradeType_Assistant == grade ) then
		return "<PAColor0xffc4bebe>"
	end
	
	-- error상태
	return "<PAColor0xffc4bebe>"
end

-- 일꾼 승급요청 함수
-- 반환값은 요청 성공/실패 ( 실패시 얼럿뜸 )
function workerWrapper:requestUpgrade()
	return ToClient_requestStartUpgrade(self._workerNoRaw)
end

-- 일꾼 승급가능 여부
-- 반환값이 true면 승급가능
function workerWrapper:isUpgradable()
	self:reflesh()
    return self._workerWrapper:get():isUpgradable()	
end

-- 일꾼의 거래소 등록여부
-- 반환값이 true면 거래소에 등록됨. false 면 등록되지않음.
function workerWrapper:getIsAuctionInsert()
	self:reflesh()
	return self._workerWrapper:get():getIsAuctionInsert()
end

-- 일꾼의 거래소 판매 가능여부
function workerWrapper:isSellable()
	self:reflesh()
	return self._workerWrapper:get():isSellable()
end

-- 일꾼의 거래소 판매가격의 적합성여부 ( min max 값 사이인지 검사 )
function workerWrapper:checkValidWorkerPrice( price )
	self:reflesh()
	return ( 0 == self._workerWrapper:get():checkValidWorkerPrice( toInt64(0, price) ) )
end

-- 일꾼의 거래소 최소 판매 가격
function workerWrapper:getWorkerMinPrice()
	self:reflesh()
	return Int64toInt32( self._workerWrapper:getWorkerMinPrice() )
end

-- 일꾼의 거래소 최대 판매 가격
function workerWrapper:getWorkerMaxPrice()
	self:reflesh()
	return Int64toInt32( self._workerWrapper:getWorkerMaxPrice() )
end

-- 일꾼의 이동속도 ( 스킬에 의한것들도 총합 )
-- workingType : CppEnums.NpcWorkingType가 들어감.
-- houseUseType : CppEnums.eHouseUseType가 들어감. (workingType이 eNpcWorkingType_PlantRentHouse일때만 의미 있음. 의미없을때는 count넣으면 됨.)
-- waypointKey : waypointKey(nodeKey)가 들어감.  (workingType이 eNpcWorkingType_PlantZone일때만 의미 있음. 의미없을때는 0넣으면 됨.)
function workerWrapper:getMoveSpeedWithSkill( workingType, houseUseType, waypointKey )
	self:reflesh()
	if ( nil == self._workerWrapper ) or ( nil == self._workerWrapper:get() ) then
		return 0
	end
	local checkData = self._workerWrapper:get():getStaticSkillCheckData()
	checkData:set(workingType, houseUseType, waypointKey)
	checkData._diceCheckForceSuccess = true

	return self._workerWrapper:getMoveSpeedWithSkill(checkData)
end

-- 일꾼의 이동속도 ( 기본이속만 해당 - 일반적으로 일하지 않은상태로 보여줄때 쓰임. )
function workerWrapper:getMoveSpeed()
	self:reflesh()
	return self._workerWrapper:get():getMoveSpeed()
end

-- 일꾼의 일효율 ( 스킬에 의한것들도 총합 )
-- workingType : CppEnums.NpcWorkingType가 들어감.
-- houseUseType : CppEnums.eHouseUseType가 들어감. (workingType이 eNpcWorkingType_PlantRentHouse일때만 의미 있음. 의미없을때는 count넣으면 됨.)
-- waypointKey : waypointKey(nodeKey)가 들어감.  (workingType이 eNpcWorkingType_PlantZone일때만 의미 있음. 의미없을때는 0넣으면 됨.)
-- productCategory : CppEnums.ProductCategory가 들어감
function workerWrapper:getWorkEfficienceWithSkill( workingType, houseUseType, waypointKey, productCategory )
	self:reflesh()
	if ( nil == self._workerWrapper ) or ( nil == self._workerWrapper:get() ) then
		return 0
	end
	local checkData = self._workerWrapper:get():getStaticSkillCheckData()
	checkData:set(workingType, houseUseType, waypointKey)
	checkData._diceCheckForceSuccess = true

	return self._workerWrapper:getWorkEfficienceWithSkill(checkData, productCategory)
end

-- 일꾼의 일효율 ( 기본이속만 해당 - 일반적으로 일하지 않은상태로 보여줄때 쓰임. )
-- productCategory : CppEnums.ProductCategory가 들어감
function workerWrapper:getWorkEfficiency(productCategory)
	self:reflesh()
	return self._workerWrapper:get():getWorkEfficiency(productCategory)
end

-- 일꾼의 운 ( 스킬에 의한것들도 총합 )
-- workingType : CppEnums.NpcWorkingType가 들어감.
-- houseUseType : CppEnums.eHouseUseType가 들어감. (workingType이 eNpcWorkingType_PlantRentHouse일때만 의미 있음. 의미없을때는 count넣으면 됨.)
-- waypointKey : waypointKey(nodeKey)가 들어감.  (workingType이 eNpcWorkingType_PlantZone일때만 의미 있음. 의미없을때는 0넣으면 됨.)
function workerWrapper:getLuckWithSkill( workingType, houseUseType, waypointKey )
	self:reflesh()
	if ( nil == self._workerWrapper ) or ( nil == self._workerWrapper:get() ) then
		return 0
	end
	local checkData = self._workerWrapper:get():getStaticSkillCheckData()
	checkData:set(workingType, houseUseType, waypointKey)
	checkData._diceCheckForceSuccess = true
	
	return self._workerWrapper:getLuckWithSkill(checkData)
end

-- 일꾼의 1번 나갔을 때 작업횟수를 반환한다.
function workerWrapper:getAdditionalRepeatCount( workingType, houseUseType, waypointKey, itemExchangeKeyRaw )
	self:reflesh()
	if ( nil == self._workerWrapper ) or ( nil == self._workerWrapper:get() ) then
		return 0
	end
	local checkData = self._workerWrapper:get():getStaticSkillCheckData()
	checkData:set(workingType, houseUseType, waypointKey)
	checkData:setItemExchangeStaticStatus(ItemExchangeKey(itemExchangeKeyRaw))
	checkData._diceCheckForceSuccess = true
	
	return self._workerWrapper:getAdditionalRepeatCount(checkData)
end

-- 일꾼의 운 ( 기본이속만 해당 - 일반적으로 일하지 않은상태로 보여줄때 쓰임. )
function workerWrapper:getLuck()
	self:reflesh()
	return self._workerWrapper:get():getLuck()
end

-- 일꾼의 아이콘
function workerWrapper:getWorkerIcon()
	self:reflesh()
	return getWorkerIcon(self._workerWrapper:get():getWorkerStaticStatus())
end

-- 일꾼의 기본 스킬
function workerWrapper:getWorkerDefaultSkillStaticStatus()
	self:reflesh()
	return self._workerWrapper:get():getWorkerDefaultSkillStaticStatus()
end


-- 일꾼의 스킬 갯수
function workerWrapper:getSkillCount()
	self:reflesh()
	return self._workerWrapper:get():getSkillCount()
end


-- 일꾼의 스킬을 함수로 돌림.
-- functor : boolean functor( skillStaticStatusWrapper, index )의 형을 취함.
function workerWrapper:foreachSkillList( functor )
	if ( nil == functor ) then
		return
	end

	self:reflesh()
	local skillCount = self._workerWrapper:get():getSkillCount()
	for index = 0, skillCount - 1 do
		local skillSSW = self._workerWrapper:get():getWorkerSkillStaticStatusByIndex( index )
		local isStop = functor(index, skillSSW)
		if ( isStop ) then
			return
		end
	end
end

function workerWrapper:getSkillSSW( idx )
	self:reflesh()

	local skillSSW = self._workerWrapper:get():getWorkerSkillStaticStatusByIndex( idx )
	return skillSSW
end


-- 일꾼이 자기자신의 일꾼인지 확인하는 함수
function workerWrapper:isMine()
	return nil ~= ToClient_getNpcWorkerByWorkerNo(self._workerNoRaw)
end

-- 일꾼이 판매가능한 일꾼인지 확인하는 함수
function workerWrapper:getIsSellable()
	self:reflesh()
	return self._workerWrapper:getIsSellable()
end

-- 일꾼이 반복작업을 할수 있는지 여부
function workerWrapper:isWorkerRepeatable()
	self:reflesh()
	return self._workerWrapper:isWorkerRepeatable()
end

-- 일꾼의 반복작업관련정보를 가져옴.
-- 반환값 WorkerWorkingPrimitiveWrapper. 없으면 nil
function workerWrapper:getWorkerRepeatableWorkingWrapper()
	self:reflesh()
	return self._workerWrapper:getWorkerRepeatableWorkingWrapper()
end

-- 일꾼이 해당노드까지 일하러 갈수있게 연결되어있는지 여부
function workerWrapper:isWorkingable(toWaypointKey)
	self:reflesh()
	if ( nil == self._workerWrapper ) then
		return false
	end
	return self._workerWrapper:isWorkingable(toWaypointKey)
end

-- 일꾼이 스킬을 변경할수 있는상황인지 검사 true면 변경가능 ( 레벨, 경험치 검사함 )
function workerWrapper:checkPossibleChangesSkillKey()
	self:reflesh()
	if ( nil == self._workerWrapper ) then
		return false
	end
	return self._workerWrapper:checkPossibleChangesSkillKey()
end

-- 일꾼의 스킬을 변경가능한 경험치를 반환 s64임.
function workerWrapper:getNeedExperienceByChangeSkill()
	self:reflesh()
	if ( nil == self._workerWrapper ) then
		return 0
	end
	return self._workerWrapper:getNeedExperienceByChangeSkill()
end

--일꾼의 일하고있는 노드 설명 ( 내부용 )
function workerWrapper:getWorkingNodeDescXXX()
	local workString = ""
	if self:isWorking() then
		local working_LeftTime	= 0
		local isWorkTimeUnlimit = self:isWorkTimeUnlimitXXX()
		if ( false == isWorkTimeUnlimit ) then
			working_LeftTime = self:getLeftWorkingTimeXXX( getServerUtc64() )
		end
		if ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantZone) ) then
			local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(self._workerNoRaw)
			if nil ~= esSSW then
				workString 	= self._workingWrapper:getWorkingNodeDesc()
			end

		elseif ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouse) )
			or ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouseLargeCraft) )
			or ( self._workingWrapper:isType(CppEnums.NpcWorkingType.eNpcWorkingType_GuildHouseLargeCraft) ) then
			local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(self._workerNoRaw)
			if nil ~= esSSW then
				workString 	= self._workingWrapper:getWorkingNodeName()
			end
		end
	else
		workString = ""
	end
	return workString
end

--일꾼의 일하고있는 노드 설명
function workerWrapper:getWorkingNodeDesc()
	self:reflesh()
    return self:getWorkingNodeDescXXX()
end

-----------------------------------------------
-- global function Helper ( local Only )
-----------------------------------------------
local getWorkerWrapperOnlyInit = function( workerNoRaw, callReflesh )
	if ( nil == workerNoRaw or workerNoUndefined == workerNoRaw ) then
		return nil
	end

	local copyValue = {}
	setmetatable( copyValue, workerWrapper )
	copyValue:initOnly(workerNoRaw, callReflesh)
	return copyValue
end

-----------------------------------------------
-- global function
-----------------------------------------------

--일꾼 wrapper가져오기
function getWorkerWrapper( workerNoRaw, callReflesh )
	if ( nil == workerNoRaw or workerNoUndefined == workerNoRaw ) then
		return nil
	end
	local copyValue = {}
	setmetatable( copyValue, workerWrapper )
	copyValue:init(workerNoRaw, callReflesh)
	if ( false == copyValue:isValid() ) then
		return nil
	end
	return copyValue
end


--경매소에서 일꾼wrapper가져오기
function getWorkerWrapperByAuction( workerNoRaw, callReflesh )
	if ( nil == workerNoRaw or workerNoUndefined == workerNoRaw ) then
		return nil
	end
	local copyValue = {}

	-- meta Function setting and override
	setmetatable( copyValue, workerWrapper )
	function copyValue:setClientValue()
		-- 안의 값이 workerNo와 맞는지 체크후 스킵할것
		self._workerWrapper = RequestGetAuctionInfo():getWorkerWrapper(self._workerNoRaw)
		self._workingWrapper = nil
	end

	--initialize
	copyValue:init(workerNoRaw, callReflesh)
	if ( false == copyValue:isValid() ) then
		return nil
	end

	return copyValue
end


--길드하우스 대기일꾼 목록화하여 가져오기
function getGuildHouseWaitWorkerWrapperList( receipeKeyRaw )
	local wrapperList = Array.new()
	local count = ToClient_getGuildHouseLargeCraftWaitWorkerListCount(receipeKeyRaw) - 1
	for index = 0, count do
		local workerNoRaw = ToClient_getGuildHouseLargeCraftWorkerIndex(index)
		local workerLuaWrapper = getWorkerWrapperOnlyInit(workerNoRaw, true)
		if ( nil ~= workerLuaWrapper ) then
			wrapperList:push_back( {wrapper = workerLuaWrapper, NoRaw = workerNoRaw} )
		end
	end

	return wrapperList
end

--길드하우스 작업일꾼 목록화하여 가져오기
function getGuildHouseWorkingWorkerWrapperList( receipeKeyRaw, exchangeKeyRaw )
	local wrapperList = Array.new()
	local count = ToClient_getGuildHouseLargeCraftWorkingWorkerListCount( receipeKeyRaw, exchangeKeyRaw ) - 1
	for index = 0, count do
		local workerNoRaw = ToClient_getGuildHouseLargeCraftWorkerIndex(index)
		local workerLuaWrapper = getWorkerWrapperOnlyInit(workerNoRaw, true)
		if ( nil ~= workerLuaWrapper ) then
			wrapperList:push_back( {wrapper = workerLuaWrapper, NoRaw = workerNoRaw} )
		end
	end

	return wrapperList
end

--모든 대기일꾼목록을 가져오기 ( plantKey가 nil이 아니면 해당 plantKey에 해당하는 마을 일꾼만 로드함.)
function getWaitWorkerFullList(plantKey)
	local plantArray	= Array.new()
	local workerArray	= Array.new()
	if nil ~= plantKey then
		plantArray:push_back( plantKey )
	else
		-- 일꾼을 등록할 수 있는 거점키를 구한다.
		local plantConut = ToCleint_getHomePlantKeyListCount()
		for plantIdx = 0, plantConut -1 do
			local plantKeyRaw = ToCleint_getHomePlantKeyListByIndex( plantIdx )
			local plantKey = PlantKey()
			plantKey:setRaw( plantKeyRaw )
			plantArray:push_back( plantKey )
		end
	end

	-- 마을 정렬
	local plantSort_do = function( a, b )
		return a:get() < b:get()
	end
	table.sort( plantArray, plantSort_do )
	
	for plantRawIdx = 1, #plantArray do
		local plantKey = plantArray[plantRawIdx]

		local plantWorkerCount	= ToClient_getPlantWaitWorkerListCount( plantKey, 0 )
		local workerHouseCount	= ToClient_getTownWorkerMaxCapacity( plantKey )
		if workerHouseCount < plantWorkerCount then
			plantWorkerCount = workerHouseCount
		end

		for workerIdx = 0, plantWorkerCount -1 do
			local workerNoRaw	= ToClient_getPlantWaitWorkerNoRawByIndex( plantKey, workerIdx )
			workerArray:push_back( workerNoRaw )
		end
	end
	return workerArray
end