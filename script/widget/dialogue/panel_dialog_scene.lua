--------------------------------------------------------------------------------------------
-- getActorByIndex(int32) 											-> index의 actorProxy 클래스를 가져온다.
-- getCharacterActorByIndex(int32)  								-> index의 CharacterProxy를 가져 온다.
-- getSceneCharacterPosition(int32)									-> index의 위치값을 가져온다.
-- setVisibleSceneCharacter( int32, bool )							-> index의 캐릭터를 true/false 하기
-- changeCameraScene("", time)										-> sceneCamera\
-- npcShop_getCommerceType(슬롯 번호)								-> 해당 슬롯의 commerceType을 준다. ( -1 은 사용 안함 )
						
-- showSceneCharacter( index, bool )								-> 해당 캐릭터를 보이게 안보이게 한다.
-- callAIHandlerByIndex( index, targetIndex, aiExecuteName )		-> index 인 캐릭터가 targetIndex 설정이 되어 있다면 target에게 없을수있다.(0) aiExecuteList를 수행해라

Panel_Dialog_Scene:SetShow( false )
Panel_Dialog_Scene:setFlushAble(false)

-- 전역
global_SelectCommerceType = -1

--
local VCK = CppEnums.VirtualKeyCode

local scene_WorldPosition
local pickingIndex = -1

enCommerceType = 
{
	enCommerceType_Luxury_Miscellaneous = 1,
	enCommerceType_Luxury 				= 2,
	enCommerceType_Grocery 				= 3,
	enCommerceType_Medicine 			= 4,
	--enCommerceType_Seed 				= 5,
	enCommerceType_MilitarySupplies		= 5,
	enCommerceType_ObjectSaint 			= 6,
	enCommerceType_Cloth 				= 7,
	enCommerceType_SeaFood	 			= 8,
	enCommerceType_RawMaterial 			= 9,

	enCommerceType_Max					= 10 		-- 항상 마지막에 오도록 세팅해주자
}

-- 조사 버튼
--local lua_DialogSearchButton = nil

-- 인덱스(dialogScen 에서 사용하는 npcIndex)는 고정으로 쓰자... 저 번호들은 무역품 종류가 된다.
-- 종류가 추가 되면 여기에도 추가 시켜 주어야 한다.
-- TradeMarket_Graph의  _dialogSceneIndex 여기 값에도 추가 수정을 동일하게 해 주어야 한다.
local beginIndex = 5
local endIndex = 14
commerceCategory =
{
	[beginIndex] = { name = PAGetString( Defines.StringSheet_GAME, "DIALOGSCENE_COMMERCETYPE_GROCERY" ) , 	Type = enCommerceType.enCommerceType_Grocery },
	[6] = { name = PAGetString( Defines.StringSheet_GAME, "DIALOGSCENE_COMMERCETYPE_MEDICINE" ), 			Type = enCommerceType.enCommerceType_Medicine },
	[7] = { name = PAGetString( Defines.StringSheet_GAME, "DIALOGSCENE_COMMERCETYPE_LUXURY" ), 		Type = enCommerceType.enCommerceType_Luxury },
	[8] = { name = PAGetString( Defines.StringSheet_GAME, "DIALOGSCENE_COMMERCETYPE_MISCELLANEOUS" ), 		Type = enCommerceType.enCommerceType_Luxury_Miscellaneous },
	[9] = { name = PAGetString( Defines.StringSheet_GAME, "DIALOGSCENE_COMMERCETYPE_SEED" ), 		Type = enCommerceType.enCommerceType_Seed },
	[10] = { name = PAGetString( Defines.StringSheet_GAME, "DIALOGSCENE_COMMERCETYPE_CLOTH" ), 		Type = enCommerceType.enCommerceType_Cloth },
	[11] = { name = PAGetString( Defines.StringSheet_GAME, "DIALOGSCENE_COMMERCETYPE_SAINTOBJECT" ), 	Type = enCommerceType.enCommerceType_ObjectSaint },
	[12] = { name = PAGetString( Defines.StringSheet_GAME, "DIALOGSCENE_COMMERCETYPE_SAINTOBJECT" ), 	Type = enCommerceType.enCommerceType_MilitarySupplies },
	[13] = { name = PAGetString( Defines.StringSheet_GAME, "DIALOGSCENE_COMMERCETYPE_SAINTOBJECT" ), 	Type = enCommerceType.enCommerceType_RawMaterial },
	[endIndex] = { name = PAGetString( Defines.StringSheet_GAME, "DIALOGSCENE_COMMERCETYPE_SEEFOOD" ),  	Type = enCommerceType.enCommerceType_SeaFood }
}

enStableType = 
{
	enStableType_Dye			= 1,
	enStableType_ArmorStands	= 2,
	enStableType_Hybridization	= 3,

	enStableType_Max			= 4
}

local	stableCategory	=
{
	[1] = { name = PAGetString( Defines.StringSheet_GAME, "DIALOGSCENE_STABLECATEGORY_DYE" ), 	Type = enStableType.enStableType_Dye			},
	[2] = { name = PAGetString( Defines.StringSheet_GAME, "DIALOGSCENE_STABLECATEGORY_ARMOR" ), 	Type = enStableType.enStableType_ArmorStands	},
	[3] = { name = PAGetString( Defines.StringSheet_GAME, "DIALOGSCENE_STABLECATEGORY_HYBRIDIZATION" ), 		Type = enStableType.enStableType_Hybridization	}
}

----------------------------------------------------------------
-- global function

local _prevPickingIndex = 0

function	updateSceneObjectPicking( fDeltaTime )	
	local	subIndex = getCurrentSubIndex()
		
	if -1 ~= subIndex then
		pickingIndex = getObjectPickingIndex()
		dialog_Scene_Click_Func[ subIndex ]()
		--UI.debugMessage( "pickingIndex : " .. pickingIndex )
	end
end

function show_DialogPanel()
	Panel_Dialog_Scene:SetShow( true )
	--setCharacterEdgeSize( 2.0 )
end

function hide_DialogSceneUIPanel()
	Panel_Dialog_Scene:SetShow( false )	
	--setCharacterEdgeSize( 1.0 )
end

Panel_Dialog_Scene:RegisterUpdateFunc("updateSceneObjectPicking")

local	dialogNpcSceneInfo = {}

----------------------------------------------------------------------------------------------------------------------------
-- scene 추가시 해야할 것들
-- subIndex 등록	------------------------------------------------------------------------------------------------------------
local dialogScene_Category_Trade = 0
local dialogScene_Category_Stable = 1
local dialogScene_Category_Search = 2
local dialogScene_Category_Wharf = 3

----------------------------------------------------------------------------------------------------------------------------
--	이하 버튼 클릭에 대한 구현부
function dialogNpcSceneInfo.click_Trade()
	if false == global_IsTrading then
		return
	end

	if true == isKeyDown_Once( VCK.KeyCode_LBUTTON ) then
		-- 해당 장면마다 클릭시 처리
		if -1 ~= pickingIndex then
			_prevPickingIndex = pickingIndex

			if nil ~= commerceCategory[pickingIndex] then
				global_SelectCommerceType = commerceCategory[pickingIndex].Type
				global_buyListOpen( global_SelectCommerceType )
			end

			global_updateCommerceInfoByType( global_SelectCommerceType, 1 )
		end
	end
end

function	dialogNpcSceneInfo.click_Stable()
	if	true == isKeyDown_Once( VCK.KeyCode_LBUTTON )	then
		if -1 == pickingIndex then
			return
		end
		
		-- UI위를 눌렀다면 클릭되지 않게 한다.
		if nil ~= getEventControl() then
			return
		end
		
		if		enStableType.enStableType_Dye			== pickingIndex	then
			-- UI.debugMessage( '염색 하기' )
		elseif	enStableType.enStableType_ArmorStands	== pickingIndex	then
			if	npcShop_isShopContents()	then
				npcShop_requestList( 9 )
				StableShop_OpenPanel()
			end
		elseif	enStableType.enStableType_Hybridization	== pickingIndex	then
			-- UI.debugMessage( '교배 하기' )
			StableFunction_Button_ListMating()
		end
	end
end

function dialogNpcSceneInfo.click_Search()

end

function dialogNpcSceneInfo.click_wharf()
end

----------------------------------------------------------------------------------------------------------------------------
--	버튼 클릭시 함수 바인드
-- Dialog Scene 에서 subIndex 단위로 함수를 만들어 주도록하자
dialog_Scene_Click_Func =
{
	[dialogScene_Category_Trade]	= dialogNpcSceneInfo.click_Trade,
	[dialogScene_Category_Stable]	= dialogNpcSceneInfo.click_Stable,
	[dialogScene_Category_Search]	= dialogNpcSceneInfo.click_Search,
	[dialogScene_Category_Wharf]	= dialogNpcSceneInfo.click_wharf,
}


----------------------------------------------------------------------------------------------------------------------------

function global_TradeShopScene()
--UI.debugMessage( "이동 " .. _prevPickingIndex )
	callAIHandlerByIndex( 1, _prevPickingIndex, "SceneTradeBuy" )
end

function global_TradeShopReset()
	callAIHandlerByIndex( 3, 0, "ResetTradeshop" )
end
