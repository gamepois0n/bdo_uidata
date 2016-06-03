
--[[
	@Date				2014/12/31
	@Author				who1310
	@Desc				집 필터 패널에 붙어 있는 콘트롤 들을 정의한다
]]--
local _myHosueCombo	= UI.getChildControl( Panel_NodeHouseFilter, "Combobox_MyHouse")
local _typeCombo	= UI.getChildControl( Panel_NodeHouseFilter, "Combobox_Type")
local _levelCombo	= UI.getChildControl( Panel_NodeHouseFilter, "Combobox_Level")
local _resetBtn		= UI.getChildControl( Panel_NodeHouseFilter, "Button_FilterReset")
local _myhouseList = _myHosueCombo:GetListControl();
local _typeList = _typeCombo:GetListControl();
local _levelList = _levelCombo:GetListControl();
local _typeListScroll = _typeList:GetScroll()
local _beforeReceipeIndex = 0;
local _houseMaxLevel = 5
local _itemSize = 0;
-- 월드맵 켤 때 애니메이션
Panel_NodeHouseFilter:RegisterShowEventFunc( true, 'FGlobal_HouseFilter_ShowAni()' )
Panel_NodeHouseFilter:RegisterShowEventFunc( false, 'FGlobal_HouseFilter_HideAni()' )

-- UI 이벤트 등록
_myHosueCombo:addInputEvent("Mouse_LUp", 	"ToggleCombo(" .. 0 .. ")")
_typeCombo:addInputEvent(	"Mouse_LUp", 	"ToggleCombo(" .. 1 .. ")")
_levelCombo:addInputEvent(	"Mouse_LUp", 	"ToggleCombo(" .. 2 .. ")")
_resetBtn:addInputEvent(	"Mouse_LUp",	"FGlobal_FilterReset()")

-- 클라이언트 이벤트 등록

Panel_NodeHouseFilter:SetShow( false, false )

function FGlobal_HouseFilter_ShowAni()
end

function FGlobal_HouseFilter_HideAni()
end

local Worldmap_HouseNavi_Init = function()
	-- 소유 여부 필터
	_myHosueCombo:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_OWNERFIILTER" ) );
	_myhouseList:SetItemQuantity(3)
	_myHosueCombo:AddItem( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_OWNERRFILTER_ALL" ) );
	_myHosueCombo:AddItem( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_OWNERFIILTER_MINE" ) );
	_myHosueCombo:AddItem( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_OWNERFILTER_OTHER" ) );
	_itemSize = _myhouseList:GetItemHeight();
	_myhouseList:SetSize( _myhouseList:GetSizeX(), 3 * _itemSize )
	
	-- 용도
	_typeCombo:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_USETYPEFILTER" ) );

	-- 제작 / 업그레이드 가능 필터
	_levelCombo:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_LEVELFILTER" ) );

	_levelList:SetItemQuantity(_houseMaxLevel)
	for i = 1, _houseMaxLevel do
		_levelCombo:AddItem( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_LEVELFILTER") .. " " .. i )
	end

	--_levelList:SetSize( _myhouseList:GetSizeX(), ( _houseMaxLevel )* _itemSize )

	-- Event 등록

	_myhouseList:addInputEvent("Mouse_LUp", "FGlobal_SelectedFilter()");
	_typeList:addInputEvent("Mouse_LUp", "FGlobal_SelectedFilter()");
	_levelList:addInputEvent("Mouse_LUp", "FGlobal_SelectedFilter()")
end

function ToggleCombo( index )
	if( 0 == index ) then
		_myHosueCombo:ToggleListbox();
	elseif( 1 == index ) then
		_typeCombo:ToggleListbox();
	elseif( 2 == index ) then
		_levelCombo:ToggleListbox();
	end
end

function FGlobal_FilterReset()
	ToCleint_findHouseByFilter( CppEnums.HouseOwnerFilter.HOUSE_OWNER_ALL, -1, 1 );
	_myHosueCombo:SetSelectItemIndex(0)
	_typeCombo:SetSelectItemIndex(0)
	_levelCombo:SetSelectItemIndex(0)
end


function FGlobal_SelectedFilter()
	local ownerIndex = _myHosueCombo:GetSelectIndex();
	local receipeIndex = _typeCombo:GetSelectIndex();
	local receipeKey = ToClient_getReceipeTypeByIndex( receipeIndex - 1 );

--	if( _beforeReceipeIndex ~= receipeIndex ) then
--		FGlobal_FilterLevelOn()
--		_levelCombo:SetSelectItemIndex(0)
--		_beforeReceipeIndex = receipeIndex
--	end

	local levelIndex = _levelCombo:GetSelectIndex();

	_myHosueCombo:SetSelectItemIndex( ownerIndex )
	_typeCombo:SetSelectItemIndex( receipeIndex )
	_levelCombo:SetSelectItemIndex( levelIndex )	

	-- 버튼에 걸린 이팩트를 지운다.
	FGlobal_FilterEffectClear()
	
	ToCleint_findHouseByFilter( ownerIndex, receipeKey, levelIndex + 1 );
end

--[[
	@Date				2014/12/31
	@Author				who1310
	@Desc				보여주기 및 위치
]]--
function FromClient_WorldMap_HouseNaviShow( isShow )
	Panel_NodeHouseFilter:SetPosX(10)
	Panel_NodeHouseFilter:SetPosY(10)
	Panel_NodeHouseFilter:SetShow( isShow, false );
	if( isShow ) then
		FGlobal_FilterReset()
		FGlobal_FilterReceiPeOn();
		--FGlobal_FilterLevelOn()
	end
end

--[[
	@Data				2014/12/31
	@Author				who1310
	@Desc				필터 내용을 만든다.
]]--
function FGlobal_FilterReceiPeOn()
	local count = ToClient_getTownReceipeList()
	_typeCombo:DeleteAllItem()

	local quantity = 0
	if 10 < count then
		quantity = 10
	else
		quantity = count
	end

	_typeList:SetSize( _typeList:GetSizeX(), (quantity)* _itemSize )
	_typeList:SetItemQuantity( quantity )
	_typeCombo:AddItem( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_OWNERRFILTER_ALL" ) );
	for idx = 0, count - 1 do
		_typeCombo:AddItem( ToClient_getReceipeName( ToClient_getReceipeTypeByIndex( idx ) ) );
	end

	_typeCombo:SetSelectItemIndex(0)
	_typeListScroll:SetControlPos(0)

end

function FGlobal_FilterLevelOn()
	local receipeIndex = _typeCombo:GetSelectIndex();
	if( 0 >= receipeIndex ) then
		return
	end

	local maxLevel = ToClient_getReceipeMaxLevelByIndex( receipeIndex )

	_levelCombo:DeleteAllItem()
	for i = 1, maxLevel do
		_levelCombo:AddItem( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_LEVELFILTER") .. " " .. i )
	end
end

Worldmap_HouseNavi_Init()


