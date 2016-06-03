local functor = {}


function FromClient_ActionChartEvent( actorKeyRaw, eventNo, isSelfPlayer )
	local aFunction = functor[eventNo]
	if ( nil ~= aFunction ) then
		aFunction( actorKeyRaw, isSelfPlayer )
	end
end


function ActionChartEventBindFunction( eventNo, insertFunctor )
	if ( nil ~= functor[eventNo] ) then
		_PA_ASSERT(false, "잘못된 ActionChart이벤트를 삽입하였습니다. ActionChartEventBindFunction 함수의 첫번째 인자를 확인해 주세요.")
	else
		functor[eventNo] = insertFunctor
	end
end


registerEvent("FromClient_ActionChartEvent", "FromClient_ActionChartEvent")