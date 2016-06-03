--------------------------------------------------
-- 커스터마이징 공통 global 변수 및 함수 정의
--------------------------------------------------
function setSliderValue( SliderControl, value, valueMin, valueMax)
	local range = valueMax - valueMin
	if value < valueMin then
		value = valueMin
	end
	if value > valueMax then
		value = valueMax
	end
	if range <= 0  then
		SliderControl:SetControlPos( 50 )
	else
		SliderControl:SetControlPos( (value-valueMin)/range * 100 )
	end 
end

function getSliderValue( SliderControl, valueMin, valueMax )
	local ratio = SliderControl:GetControlPos()
	local range 	= valueMax - valueMin
	if range < 0 then
		range = 0 
	end
	return math.floor( ratio * range  + valueMin )
end

local clearGroupCustomizedBonInfoPostProcessList = Array.new()

function pushClearGroupCustomizedBonInfoPostFunction(functor)
	clearGroupCustomizedBonInfoPostProcessList:push_back(functor)
end

function clearGroupCustomizedBonInfoLua()
	clearGroupCustomizedBoneInfo()
	for key, value in pairs(clearGroupCustomizedBonInfoPostProcessList) do
		value()
	end
end


