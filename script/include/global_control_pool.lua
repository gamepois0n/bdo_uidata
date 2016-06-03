-- 전제 1. 다른 타입의 컨트롤을 사용할 수는 없다. PAUIButton <-> PAUIStatic
-- 전제 2. 같은 PAUIButton 이라 하더라도, CopyBaseProperties 는 비용이 소모된다.
--         그러나, 컨트롤을 새로 생성하는 것보다는 CopyBaseProperties 만 호출하여 사용하는 편이 효율적이다!

-- 1. Best case 는, 이미 생성되어 있는 컨트롤을, CopyBaseProperties 없이 그대로 사용하는 것이다.!
-- 2. 위의 경우가 불가능 하다면, 타입이 같은 컨트롤에 CopyBaseProperties 를 하여 사용하는 것이다.!
-- 3. 1, 2 가 모두 불가능 한 경우에만, 컨트롤을 새로 생성한다!

---------------------------------------------------
-- ControlPool Class
---------------------------------------------------
ControlPool = {}
ControlPool.__index = ControlPool

function ControlPool.createPool( parent )
	if nil == parent then
		return nil
	end

	local newPool = {}
	setmetatable( newPool, ControlPool )

	newPool._parent = parent
	-- map<controlType, map<id, Array>> : WeakReference 임. controlPool 과 동일한 Array 객체를 가리키고 있다.
	newPool.poolMapByControlType	= {}
	-- map<id, Array>
	newPool.poolMap					= {}

	return newPool
end

function ControlPool:addCategory( id, controlType, template, controlID )
	local pool = self.poolMap[id]
	if nil ~= pool then
		return false
	end

	local poolInfo = 
	{
		_template = template,
		_type = controlType,
		_count = 0,
		_controlID = controlID,
		_pool = Array.new()
	}
	self.poolMap[id] = poolInfo

	local managePool = self.poolMapByControlType[controlType]
	if nil == managePool then
		managePool = {}
		self.poolMapByControlType[controlType] = managePool
	end
	managePool[id] = poolInfo._pool
end

function ControlPool:hasCategory( id )
	return (nil ~= self.poolMap[id]);
end

-- 같은 타입의 컨트롤이 Pool 에 존재하면 리턴, 없으면 nil
-- private
function ControlPool:getControlTypePool( controlType )
	local weakRefPool = self.poolMapByControlType[controlType]
	-- _PA_ASSERT( nil ~= weakRefPool, 'Nil 이면 안되는데!!!' )
	for _,pool in pairs(weakRefPool) do
		if 0 < pool:length() then
			return pool:pop_back()
		end
	end
	return nil
end

-- Pool 에 있었거나, 새로 생성된 컨트롤!
function ControlPool:getOrCreateControl( id )
	local poolInfo = self.poolMap[id]
	if nil == poolInfo then
		return nil								-- Pool 이 존재하지 않는다! 컨트롤을 가져올 수 없다!
	end

	if 0 < poolInfo._pool:length() then		-- 풀에 여분 컨트롤이 존재할 경우!
		return poolInfo._pool:pop_back()
	else										-- 풀에 여분 컨트롤이 존재하지 않을 경우!
		local sameTypeControl = self:getControlTypePool( poolInfo._type )
		if nil ~= sameTypeControl then			-- 같은 타입의 컨트롤이 있다면, Copy 후에 리턴한다!
			if nil ~= poolInfo._template then
				CopyBaseProperty( poolInfo._template, sameTypeControl )
			end
			return sameTypeControl
		else									-- 같은 타입의 컨트롤도 없다면, 새로 생성한 후에, Copy 하고 리턴한다!
			poolInfo._count = poolInfo._count + 1
			local newControl = UI.createControl( poolInfo._type, self._parent, poolInfo._controlID .. poolInfo._count )
			if nil ~= newControl then
				if nil ~= poolInfo._template then
					CopyBaseProperty( poolInfo._template, newControl )
				end
				newControl:SetShow( false )
				return newControl
			end

			return nil							-- 생성에도 실패한 경우!!
		end
	end
end

function ControlPool:returnToPool( id, control )
	local poolInfo = self.poolMap[id]
	if nil == poolInfo then
		return false							-- Pool 이 존재하지 않는다! 반환 실패!
	end

	control:SetShow( false )
	poolInfo._pool:push_back( control )
	return true
end

