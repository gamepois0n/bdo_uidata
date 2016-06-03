--[[
\\ 인벤토리와 창고에서 사용되는 아이템 정렬 기능을 지원하기 위한 코드입니다.
\\ 정렬 순서를 변경하고자 할 때에는 [성경]과 상의후에 변경하세요!
\\ 
]]

local  itemTypePriorityMap =
{
	[0] = 0,	-- gc::ItemType::Normal
	3,			-- gc::ItemType::Equip
	2,			-- gc::ItemType::Skill
	1,			-- gc::ItemType::Tent
	1,			-- gc::ItemType::Installation
	1,			-- gc::ItemType::Jewel
	1,			-- gc::ItemType::CannonBall
	1,			-- gc::ItemType::Mapae
	1,			-- gc::ItemType::Material
	1,			-- gc::ItemType::Interaction
	1			-- gc::ItemType::ContentsEvent
}

local equipTypePriorityMap =
{
	[0] = 0,9900,	9800,	9700,	9600,
	9500,	9400,	9300,	8700,
	8200,	8100,	8000,	7900,	7800,	7700,
	7600,	7500,	7400,	7300,	7200,
	9200,	8600,
	7100,	7000,	6900,	6800,	6700,	6600,
	9100,	9000,	8900,	8800,	8500,	8400,	8300,
	9200,	9100,	8800
}

-- global.itemType.Equip 은 global_define_cpp_enum 에 정의되어 있음
local itemType_Equip		= CppEnums.ItemType.Equip

function Global_ItemComparer( ii, jj, getFunction, inventoryType )
	local self = inven

	-- 빈 슬롯은 뒤쪽으로.
	local invenItemII = nil
	if nil ~= inventoryType then
		invenItemII = getFunction(inventoryType, ii)
	else
		invenItemII = getFunction(ii)
	end
	
	local emptyII = (nil == invenItemII)
	local itemStaticWrapperII, itemTypeII, equipTypeII, minLevelII, gradeTypeII, itemKeyII
	if not emptyII then
		itemStaticWrapperII	= invenItemII:getStaticStatus()
		itemTypeII			= itemStaticWrapperII:getItemType()
		equipTypeII			= itemStaticWrapperII:getEquipType()
		minLevelII			= itemStaticWrapperII:get()._minLevel
		gradeTypeII			= itemStaticWrapperII:getGradeType()
		itemKeyII			= invenItemII:get():getKey():getItemKey()
	end

	-- 빈 슬롯은 뒤쪽으로.
	local invenItemJJ = nil
	if nil ~= inventoryType then
		invenItemJJ = getFunction(inventoryType, jj)
	else
		invenItemJJ = getFunction(jj)
	end
	
	local emptyJJ		= (nil == invenItemJJ)
	local itemStaticWrapperJJ, itemTypeJJ, equipTypeJJ, minLevelJJ, gradeTypeJJ, itemKeyJJ
	if not emptyJJ then
		itemStaticWrapperJJ	= invenItemJJ:getStaticStatus()
		itemTypeJJ			= itemStaticWrapperJJ:getItemType()
		equipTypeJJ			= itemStaticWrapperJJ:getEquipType()
		minLevelJJ			= itemStaticWrapperJJ:get()._minLevel
		gradeTypeJJ			= itemStaticWrapperJJ:getGradeType()
		itemKeyJJ			= invenItemJJ:get():getKey():getItemKey()
	end

	if emptyII and emptyJJ then
		return 0				-- 둘다 empty 이면, 순서를 바꾸지 않는다!
	elseif emptyII then
		return -1				-- ii 가 empty 이면, 뒤로 보낸다.
	elseif emptyJJ then
		return 1				-- jj 가 empty 이면, 뒤로 보낸다.
	end

	-- 아이템 우선순위가 높은것이 낮은 슬롯 번호로
	local itemPriorityII = itemTypePriorityMap[itemTypeII] or 0	-- 존재하지 않는 itemType 이 들어오면 오류 방지를 위해
	local itemPriorityJJ = itemTypePriorityMap[itemTypeJJ] or 0	-- 기본 우선도를 0 으로 설정한다
	if itemPriorityII ~= itemPriorityJJ then
		-- UI.debugMessage('ItemComparer - ItemType(' .. itemPriorityII .. ',' .. itemPriorityJJ .. ')')
		return(itemPriorityII - itemPriorityJJ)
	end

	-- 같은 우선순위를 가지는 아이템이다!
	if (itemType_Equip == itemTypeII) and (itemType_Equip == itemTypeJJ) then
		-- 둘다 장비일 경우는 다른 조건이 적용된다.
		local equipPriorityII = equipTypePriorityMap[equipTypeII] or 0	-- 존재하지 않는 itemType 이 들어오면 오류 방지를 위해
		local equipPriorityJJ = equipTypePriorityMap[equipTypeJJ] or 0	-- 기본 우선도를 0 으로 설정한다

		-- 높은 우선순위를 가지는 장비가 낮은 슬롯 번호로
		if equipPriorityII ~= equipPriorityJJ then
			return(equipPriorityII - equipPriorityJJ)
		end
		
		-- 아이템 등급이 높은 장비가 낮은 슬롯 번호로
		if gradeTypeII ~= gradeTypeJJ then
			return( gradeTypeII - gradeTypeJJ )
		end

		-- 최소 레벨이 높은 장비가 낮은 슬롯 번호로
		if minLevelII ~= minLevelJJ then
			return( minLevelII - minLevelJJ )
		end
		
		-- 동일 아이템 키로 정렬
		return( itemKeyII - itemKeyJJ )
	else
		-- 모든 아이템에 적용되는 정렬 조건임!
		-- 아이템 등급이 높은 장비가 낮은 슬롯 번호로
		if gradeTypeII ~= gradeTypeJJ then
			return( gradeTypeII - gradeTypeJJ )
		end

		-- 동일 아이템 키로 정렬
		return( itemKeyII - itemKeyJJ )
	end
end
