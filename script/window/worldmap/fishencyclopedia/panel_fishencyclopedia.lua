local UI_color = Defines.Color

local _staticFishBack		= UI.getChildControl ( Panel_FishEncyclopedia, "Static_FishBG" )
local _staticFishImage		= UI.getChildControl ( Panel_FishEncyclopedia, "Static_FishImage" )
local _staticFishRating1	= UI.getChildControl ( Panel_FishEncyclopedia, "Static_FishRating1" )
local _staticFishRating2	= UI.getChildControl ( Panel_FishEncyclopedia, "Static_FishRating2" )
local _staticFishRating3	= UI.getChildControl ( Panel_FishEncyclopedia, "Static_FishRating3" )
local _staticFishRating4	= UI.getChildControl ( Panel_FishEncyclopedia, "Static_FishRating4" )
local _staticFishRating5	= UI.getChildControl ( Panel_FishEncyclopedia, "Static_FishRating5" )
-- local _staticFishRating6	= UI.getChildControl ( Panel_FishEncyclopedia, "Static_FishRating6" ) -- 어류 등급 추가분
-- local _staticFishRating7	= UI.getChildControl ( Panel_FishEncyclopedia, "Static_FishRating7" )
-- local _staticFishRating8	= UI.getChildControl ( Panel_FishEncyclopedia, "Static_FishRating8" )

local _textFishName			= UI.getChildControl ( Panel_FishEncyclopedia, "StaticText_FishName" )
local _textFishRarity		= UI.getChildControl ( Panel_FishEncyclopedia, "StaticText_Rarity" )
local _staticTopLine		= UI.getChildControl ( Panel_FishEncyclopedia, "Static_TopLine" )
local _staticDescBack		= UI.getChildControl ( Panel_FishEncyclopedia, "Static_ExplanationBG" )
local _textDesc				= UI.getChildControl ( Panel_FishEncyclopedia, "StaticText_FishExplanation" )
local _staticBottomLine		= UI.getChildControl ( Panel_FishEncyclopedia, "Static_BottomLine" )
local _staticInforBack		= UI.getChildControl ( Panel_FishEncyclopedia, "Static_InfoBG" )
local _textFishArea			= UI.getChildControl ( Panel_FishEncyclopedia, "StaticText_FishArea" )
local _buttonFishPosition	= UI.getChildControl ( Panel_FishEncyclopedia, "Button_FishLocation" )
local _textFishCount		= UI.getChildControl ( Panel_FishEncyclopedia, "StaticText_FishCount" )
local _textFishCountNum		= UI.getChildControl ( Panel_FishEncyclopedia, "StaticText_FishCountNumber" )
local _textFishSize			= UI.getChildControl ( Panel_FishEncyclopedia, "StaticText_FishMaxSize" )
local _textFishSizeNum		= UI.getChildControl ( Panel_FishEncyclopedia, "StaticText_FishMaxSizeNumber" )
local _radioFishType		= UI.getChildControl ( Panel_FishEncyclopedia, "RadioButton_FishType" )

local _textSizeRankTitle	= UI.getChildControl ( Panel_FishEncyclopedia, "StaticText_SizeRankTitle" )
local _staticSizeRankLine	= UI.getChildControl ( Panel_FishEncyclopedia, "Static_SizeRankLine" )
local _staticSizeRankBG		= UI.getChildControl ( Panel_FishEncyclopedia, "Static_SizeRankBG" )

local _textSizeRanker		= UI.getChildControl ( Panel_FishEncyclopedia, "StaticText_SizeRanker" )
local _textSizeRankerName	= UI.getChildControl ( Panel_FishEncyclopedia, "StaticText_SizeRankerName" )
local _textSizeRankerSize	= UI.getChildControl ( Panel_FishEncyclopedia, "StaticText_SizeRankerSize" )
local _textSizeNoAcquire	= UI.getChildControl ( Panel_FishEncyclopedia, "StaticText_SizeNoAcquire" )
local _textSizeRankLoading	= UI.getChildControl ( Panel_FishEncyclopedia, "StaticText_SizeRankLoading" )

local _static_ScrollEnableArea	= _staticFishBack:getParent()

local _textSizeRankTitleString	= PAGetString(Defines.StringSheet_GAME, "LUA_FISHENCYCLOPEDIA_SIZERANK_TITLE")		-- "포획 크기 순위"
local _textSizeNoAcquireString	= PAGetString(Defines.StringSheet_GAME, "LUA_FISHENCYCLOPEDIA_SIZERANK_NOACQUIRE")	-- "포획한 어류만 순위가 공개됩니다."
local _textSizeRankLoadingString	= PAGetString(Defines.StringSheet_GAME, "LUA_FISHENCYCLOPEDIA_SIZERANK_LOADING")	-- "순위를 불러오는 중입니다."
local _textSizeRankingString		= PAGetString(Defines.StringSheet_GAME, "LUA_FISHENCYCLOPEDIA_SIZERANK_RANKING")	-- "위"

_textSizeNoAcquire		:SetText( _textSizeNoAcquireString )
_textSizeRankLoading	:SetText( _textSizeRankLoadingString )
_textSizeRankTitle		:SetText( _textSizeRankTitleString )
_textSizeNoAcquire		:SetFontColor( UI_color.C_FF84FFF5 )
_textSizeRankLoading	:SetFontColor( UI_color.C_FF84FFF5 )



local FishEncyclopedia = 
{
	_FISH_COUNT_FOR_PAGE		= 2,
	
	_fishList					= {},
	_radioButton				= {},
	
	_closeButton				= UI.getChildControl ( Panel_FishEncyclopedia, "Button_Win_Close" ),
	_pageLeftButton				= UI.getChildControl ( Panel_FishEncyclopedia, "Button_List_Left" ),
	_pageRightButton			= UI.getChildControl ( Panel_FishEncyclopedia, "Button_List_Right" ),
	_pageStaticText				= UI.getChildControl ( Panel_FishEncyclopedia, "StaticText_ListCount" ),
	_acquireRatePrograss		= UI.getChildControl ( Panel_FishEncyclopedia, "Progress2_FishProgress" ),
	_acquireRateStaticText		= UI.getChildControl ( Panel_FishEncyclopedia, "StaticText_PercentCount" ),
	
	_currentCategoryParamIndex	= CppEnums.FishEncyclopediaCategory.eFishEncyclopediaCategory_FreshWaterFish,
	_currentPage				= 0,
	_currentTotalPage			= 0,

	maxRankSlotCount			= 10,
}



function FishEncyclopedia:createSlot(index)
	
	local FishInfo = {}
	
	FishInfo._staticFishBack	= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_FishEncyclopedia, "Static_FishBG_"..index )
	CopyBaseProperty( _staticFishBack, FishInfo._staticFishBack )

	FishInfo._textFishName		= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, FishInfo._staticFishBack, "StaticText_FishName_"..index )
	CopyBaseProperty( _textFishName, FishInfo._textFishName )
	FishInfo._textFishName:SetPosX(20)
	FishInfo._textFishName:SetPosY(11)

	FishInfo._textFishRarity	= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, FishInfo._staticFishBack, "StaticText_Rarity_"..index )
	CopyBaseProperty( _textFishRarity, FishInfo._textFishRarity )	
	FishInfo._textFishRarity:SetPosX(25)
	FishInfo._textFishRarity:SetPosY(44)
	
	FishInfo._staticFishImage	= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, FishInfo._staticFishBack, "Static_FishImage_"..index )
	CopyBaseProperty( _staticFishImage, FishInfo._staticFishImage )
	FishInfo._staticFishImage:SetPosX(274)
	FishInfo._staticFishImage:SetPosY(42)
	
	FishInfo._staticFishRating = {}
	FishInfo._staticFishRating[0]	= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, FishInfo._staticFishBack, "Static_FishRating1_"..index )
	CopyBaseProperty( _staticFishRating1, FishInfo._staticFishRating[0] )
	FishInfo._staticFishRating[0]:SetPosX(140)
	FishInfo._staticFishRating[0]:SetPosY(48)
	
	FishInfo._staticFishRating[1]	= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, FishInfo._staticFishBack, "Static_FishRating2_"..index )
	CopyBaseProperty( _staticFishRating2, FishInfo._staticFishRating[1] )
	FishInfo._staticFishRating[1]:SetPosX(160)
	FishInfo._staticFishRating[1]:SetPosY(48)
	
	FishInfo._staticFishRating[2]	= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, FishInfo._staticFishBack, "Static_FishRating3_"..index )
	CopyBaseProperty( _staticFishRating3, FishInfo._staticFishRating[2] )
	FishInfo._staticFishRating[2]:SetPosX(180)
	FishInfo._staticFishRating[2]:SetPosY(48)
		
	FishInfo._staticFishRating[3]	= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, FishInfo._staticFishBack, "Static_FishRating4_"..index )
	CopyBaseProperty( _staticFishRating4, FishInfo._staticFishRating[3] )
	FishInfo._staticFishRating[3]:SetPosX(200)
	FishInfo._staticFishRating[3]:SetPosY(48)
	
	FishInfo._staticFishRating[4]	= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, FishInfo._staticFishBack, "Static_FishRating5_"..index )
	CopyBaseProperty( _staticFishRating5, FishInfo._staticFishRating[4] )
	FishInfo._staticFishRating[4]:SetPosX(220)
	FishInfo._staticFishRating[4]:SetPosY(48)
	
	---- 어류 등급 추가분
	-- FishInfo._staticFishRating[5]	= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, FishInfo._staticFishBack, "Static_FishRating6_"..index )
	-- CopyBaseProperty( _staticFishRating6, FishInfo._staticFishRating[5] )
	-- FishInfo._staticFishRating[5]:SetPosX(140)
	-- FishInfo._staticFishRating[5]:SetPosY(25)
	
	-- FishInfo._staticFishRating[6]	= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, FishInfo._staticFishBack, "Static_FishRating7_"..index )
	-- CopyBaseProperty( _staticFishRating7, FishInfo._staticFishRating[6] )
	-- FishInfo._staticFishRating[6]:SetPosX(160)
	-- FishInfo._staticFishRating[6]:SetPosY(25)
	
	-- FishInfo._staticFishRating[7]	= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, FishInfo._staticFishBack, "Static_FishRating8_"..index )
	-- CopyBaseProperty( _staticFishRating8, FishInfo._staticFishRating[7] )
	-- FishInfo._staticFishRating[7]:SetPosX(180)
	-- FishInfo._staticFishRating[7]:SetPosY(25)


	FishInfo._staticTopLine		= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, FishInfo._staticFishBack, "Static_TopLine_"..index )
	CopyBaseProperty( _staticTopLine, FishInfo._staticTopLine )		
	FishInfo._staticTopLine:SetPosX(16)
	FishInfo._staticTopLine:SetPosY(67)
	
	FishInfo._staticDescBack	= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, FishInfo._staticFishBack, "Static_ExplanationBG_"..index )
	CopyBaseProperty( _staticDescBack, FishInfo._staticDescBack )	
	FishInfo._staticDescBack:SetPosX(18)
	FishInfo._staticDescBack:SetPosY(79)
	
	FishInfo._textDesc			= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, FishInfo._staticFishBack, "StaticText_FishExplanation_"..index )
	CopyBaseProperty( _textDesc, FishInfo._textDesc )				
	FishInfo._textDesc:SetPosX(25)
	FishInfo._textDesc:SetPosY(86)
	FishInfo._textDesc:SetSize(FishInfo._staticDescBack:GetSizeX() - 14, FishInfo._staticDescBack:GetSizeY() - 14)
	FishInfo._textDesc:SetTextMode ( CppEnums.TextMode.eTextMode_Limit_AutoWrap )
	FishInfo._textDesc:SetAutoResize ( true )
	FishInfo._textDesc:SetLineCount(4)
	
	FishInfo._staticBottomLine	= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, FishInfo._staticFishBack, "Static_BottomLine_"..index )
	CopyBaseProperty( _staticBottomLine, FishInfo._staticBottomLine )		
	FishInfo._staticBottomLine:SetPosX(15)
	FishInfo._staticBottomLine:SetPosY(164)
	
	FishInfo._staticInforBack	= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, FishInfo._staticFishBack, "Static_InfoBG_"..index )
	CopyBaseProperty( _staticInforBack, FishInfo._staticInforBack )			
	FishInfo._staticInforBack:SetPosX(19)
	FishInfo._staticInforBack:SetPosY(176)
	
	FishInfo._textFishArea		= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, FishInfo._staticFishBack, "StaticText_FishArea_"..index )
	CopyBaseProperty( _textFishArea, FishInfo._textFishArea )		
	FishInfo._textFishArea:SetPosX(25)
	FishInfo._textFishArea:SetPosY(182)
	
	FishInfo._buttonFishPosition= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, FishInfo._staticFishBack, "Button_FishLocation_"..index )
	CopyBaseProperty( _buttonFishPosition, FishInfo._buttonFishPosition )		
	FishInfo._buttonFishPosition:SetPosX(175)
	FishInfo._buttonFishPosition:SetPosY(178)
	
	FishInfo._textFishPosition	= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, FishInfo._staticFishBack, "StaticText_FishPosition_"..index )
	CopyBaseProperty( _textFishCountNum, FishInfo._textFishPosition )
	FishInfo._textFishPosition:SetPosX(187)
	FishInfo._textFishPosition:SetPosY(178)
	
	FishInfo._textFishCount		= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, FishInfo._staticFishBack, "StaticText_FishCount_"..index )
	CopyBaseProperty( _textFishCount, FishInfo._textFishCount )			
	FishInfo._textFishCount:SetPosX(25)
	FishInfo._textFishCount:SetPosY(205)
	
	FishInfo._textFishCountNum	= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, FishInfo._staticFishBack, "StaticText_FishCountNumber_"..index )
	CopyBaseProperty( _textFishCountNum, FishInfo._textFishCountNum )		
	FishInfo._textFishCountNum:SetPosX(187)
	FishInfo._textFishCountNum:SetPosY(201)

	FishInfo._textFishSize		= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, FishInfo._staticFishBack, "StaticText_FishMaxSize_"..index )
	CopyBaseProperty( _textFishSize, FishInfo._textFishSize )				
	FishInfo._textFishSize:SetPosX(25)
	FishInfo._textFishSize:SetPosY(229)
	
	FishInfo._textFishSizeNum	= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, FishInfo._staticFishBack, "StaticText_FishMaxSizeNumber_"..index )
	CopyBaseProperty( _textFishSizeNum, FishInfo._textFishSizeNum )
	FishInfo._textFishSizeNum:SetPosX(187)
	FishInfo._textFishSizeNum:SetPosY(224)


		FishInfo._textSizeRankTitle		= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, FishInfo._staticFishBack, "StaticText_textSizeRankTitle_"..index )
		CopyBaseProperty( _textSizeRankTitle, FishInfo._textSizeRankTitle )
		FishInfo._textSizeRankTitle:SetPosX(25)
		FishInfo._textSizeRankTitle:SetPosY(270)
		
		FishInfo._staticSizeRankLine	= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, FishInfo._staticFishBack, "Static_staticSizeRankLine_"..index )
		CopyBaseProperty( _staticSizeRankLine, FishInfo._staticSizeRankLine )
		FishInfo._staticSizeRankLine:SetPosX(15)
		FishInfo._staticSizeRankLine:SetPosY(293)
		
		FishInfo._staticSizeRankBG		= UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, FishInfo._staticFishBack, "Static_staticSizeRankBG_"..index )
		CopyBaseProperty( _staticSizeRankBG, FishInfo._staticSizeRankBG )
		FishInfo._staticSizeRankBG:SetPosX(12)
		FishInfo._staticSizeRankBG:SetPosY(308)
		
		FishInfo._textSizeNoAcquire =	UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, FishInfo._staticSizeRankBG, "StaticText_SizeNoAcquire_"..index )
		CopyBaseProperty( _textSizeNoAcquire, FishInfo._textSizeNoAcquire )
		FishInfo._textSizeNoAcquire:SetPosX(25)
		FishInfo._textSizeNoAcquire:SetPosY(13)
		
		FishInfo._textSizeRankLoading =	UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, FishInfo._staticSizeRankBG, "StaticText_SizeRankLoading_"..index )
		CopyBaseProperty( _textSizeRankLoading, FishInfo._textSizeRankLoading )
		FishInfo._textSizeRankLoading:SetPosX(25)
		FishInfo._textSizeRankLoading:SetPosY(13)
		
		FishInfo.rankList = {}
			for rankIdx = 0, 9 do
				local posConfig =
				{
					_startPosY 	= 6,
					_PosYGap 	= 16,
				}
				FishInfo.rankList[rankIdx] = {}
				
				FishInfo.rankList[rankIdx]._textSizeRanker =		UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, FishInfo._staticSizeRankBG, "StaticText_SizeRanker_"..index .. "_" .. rankIdx )
				CopyBaseProperty( _textSizeRanker, FishInfo.rankList[rankIdx]._textSizeRanker )
				FishInfo.rankList[rankIdx]._textSizeRanker:SetPosX(-10)
				FishInfo.rankList[rankIdx]._textSizeRanker:SetPosY( posConfig._startPosY + ( posConfig._PosYGap * (rankIdx) ) )
				
				FishInfo.rankList[rankIdx]._textSizeRankerName =	UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, FishInfo._staticSizeRankBG, "StaticText_SizeRankerName_"..index .. "_" .. rankIdx )
				CopyBaseProperty( _textSizeRankerName, FishInfo.rankList[rankIdx]._textSizeRankerName )
				FishInfo.rankList[rankIdx]._textSizeRankerName:SetPosX(95)
				FishInfo.rankList[rankIdx]._textSizeRankerName:SetPosY( posConfig._startPosY + ( posConfig._PosYGap * (rankIdx) ) )
				
				FishInfo.rankList[rankIdx]._textSizeRankerSize =	UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, FishInfo._staticSizeRankBG, "StaticText_SizeRankerSize_"..index .. "_" .. rankIdx )
				CopyBaseProperty( _textSizeRankerSize, FishInfo.rankList[rankIdx]._textSizeRankerSize )
				FishInfo.rankList[rankIdx]._textSizeRankerSize:SetPosX(353)
				FishInfo.rankList[rankIdx]._textSizeRankerSize:SetPosY( posConfig._startPosY + ( posConfig._PosYGap * (rankIdx) ) )
			end

	function FishInfo:setPosition(x, y)
		FishInfo._staticFishBack:SetPosX(43 + x)
		FishInfo._staticFishBack:SetPosY(115 + y)
	end
	
	return	FishInfo
end


function FishEncyclopedia:createRadioButton(index, paramIndex, strLabel)
	local radioButton = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, Panel_FishEncyclopedia, "RadioButton_FishType_" .. index )
	CopyBaseProperty( _radioFishType, radioButton )
	radioButton:addInputEvent( "Mouse_LUp", "HandleClicked_FishEncyclopedia_SelectedCategory(" .. paramIndex .. ")" )
	radioButton:SetText(strLabel)
	radioButton:SetPosX(34 + (index * 96))
	radioButton:SetPosY(68)
	
	return radioButton
end


function FishEncyclopedia:deleteStyleUI()
	UI.deleteControl( _staticFishBack )
	UI.deleteControl( _staticFishImage )
	UI.deleteControl( _staticFishRating1 )
	UI.deleteControl( _staticFishRating2 )
	UI.deleteControl( _staticFishRating3 )
	UI.deleteControl( _staticFishRating4 )
	UI.deleteControl( _staticFishRating5 )
	-- UI.deleteControl( _staticFishRating6 ) -- 어류 등급 추가시 주석 해제
	-- UI.deleteControl( _staticFishRating7 )
	-- UI.deleteControl( _staticFishRating8 )
	UI.deleteControl( _textFishName )
	UI.deleteControl( _textFishRarity )
	UI.deleteControl( _staticTopLine )
	UI.deleteControl( _staticDescBack )
	UI.deleteControl( _textDesc )
	UI.deleteControl( _staticBottomLine )
	UI.deleteControl( _staticInforBack )
	UI.deleteControl( _textFishArea )
	UI.deleteControl( _buttonFishPosition )
	UI.deleteControl( _textFishCount )
	UI.deleteControl( _textFishCountNum )
	UI.deleteControl( _textFishSize )
	UI.deleteControl( _textFishSizeNum )
	UI.deleteControl( _radioFishType )
	UI.deleteControl( _textSizeRankTitle ) -- 포획 크기 순위
	UI.deleteControl( _staticSizeRankLine )
	UI.deleteControl( _staticSizeRankBG )
	UI.deleteControl( _textSizeRanker )
	UI.deleteControl( _textSizeRankerName )
	UI.deleteControl( _textSizeRankerSize )
	UI.deleteControl( _textSizeNoAcquire )
	UI.deleteControl( _textSizeRankLoading )
end


function HandleClicked_FishEncyclopedia_SelectedCategory( categoryParamIndex )
	FishEncyclopedia._currentCategoryParamIndex = categoryParamIndex
	FishEncyclopedia._currentPage				= 0
	
	local fishCount = ToClient_GetFishCountByCategory( categoryParamIndex )
	local totalPage = math.floor(fishCount / FishEncyclopedia._FISH_COUNT_FOR_PAGE) + 1
	if 0 == fishCount % FishEncyclopedia._FISH_COUNT_FOR_PAGE then
		totalPage = totalPage - 1
	end
	FishEncyclopedia._currentTotalPage			= totalPage
	
	local pageStr = tostring(FishEncyclopedia._currentPage + 1) .. "/" .. tostring(totalPage)
	FishEncyclopedia._pageStaticText:SetText(pageStr)
	
	changePageButtonEnable()
	updateFishList()
end


function updateFishList()
	local startIndex 	= FishEncyclopedia._currentPage * FishEncyclopedia._FISH_COUNT_FOR_PAGE
	local endIndex		= startIndex + FishEncyclopedia._FISH_COUNT_FOR_PAGE - 1
	local maxIndex		= ToClient_GetFishCountByCategory( FishEncyclopedia._currentCategoryParamIndex )
	local index = 0
		
	local FishInfo = FishEncyclopedia._fishList[index]

	clearFishList()
	
	for ii = startIndex, endIndex, 1 do
		local FishInfo = FishEncyclopedia._fishList[index]
		if nil ~= FishInfo then

			if maxIndex - 1 < ii then
				FishInfo._staticFishBack:SetShow( false )
			else
				setFishSlot(ii, index)
			end
		end
		index = index + 1
	end
	
end


function setFishSlot(dataIndex, slotIndex) -- dataindex = 어종 인덱스값, slotIndex = 슬롯인덱스
	local fishInfo	= ToClient_GetFishAt( FishEncyclopedia._currentCategoryParamIndex, dataIndex )
	local FishSlot	= FishEncyclopedia._fishList[slotIndex]
		
	if nil == FishSlot then
		return
	end
	
	if nil == fishInfo then
		return
	end
	
	local isAcquire = fishInfo:isAcquire()
	
	if isAcquire then
		local KeyForFishSizeRank	= fishInfo:getKey()
		ToClient_RequestFishTopRankingBody(KeyForFishSizeRank)

		local fishName = fishInfo:getName()
		FishSlot._textFishName:SetText(fishName)
		
		local fishDesc = fishInfo:getDesc()
		FishSlot._textDesc:SetText(fishDesc)
		
		local fishRareness = fishInfo:getRareness()
		for ii = 0, fishRareness-1, 1 do
			local fishRarenessUI = FishSlot._staticFishRating[4-ii] -- 어류 등급 추가시 변경
			if nil ~= fishRarenessUI then
				fishRarenessUI:SetShow( true )
			end
		end
		
		local fishCount = fishInfo:getCount()
		FishSlot._textFishCountNum:SetText(fishCount)
	
		local fishValue = fishInfo:getMaxValue()
		FishSlot._textFishSizeNum:SetText(fishValue)
		
		local fishImage = fishInfo:getImagePath()
		FishSlot._staticFishImage:ChangeTextureInfoName( fishImage )
		
		-- FishSlot._buttonFishPosition:SetShow( true ) -- 포획장소 (미구현)
		FishSlot._textFishPosition:SetShow( true )
		
		FishSlot._textSizeNoAcquire		:SetShow( false )
		FishSlot._textSizeRankLoading	:SetShow( true )
		
		FishSizeRankSet( KeyForFishSizeRank, slotIndex )
	else
		FishSlot._textSizeNoAcquire		:SetShow( true )
		FishSlot._textSizeRankLoading	:SetShow( false )
	end
end


function FromClient_ResponseFishTopRankingBody(sizeRankKey)

	for rankIdx = 0, FishEncyclopedia.maxRankSlotCount - 1 do
		local rankValue	= ToClient_GetFishTopRankingValueInClient(sizeRankKey, rankIdx)
	end

	FishSizeRankSet(sizeRankKey, nil)
end


function FishSizeRankSet( sizeRankKey, slotIndex ) -- 포획 크기 순위
	if nil == slotIndex then
		return
	end
	
	local FishSlot				= FishEncyclopedia._fishList[slotIndex]
	local rankSlot				= FishEncyclopedia._fishList[slotIndex].rankList
	local selfPlayerNIckName	= getSelfPlayer():getUserNickname()
	
	for rankIdx = 0, FishEncyclopedia.maxRankSlotCount - 1 do -- 초기화
		rankSlot[rankIdx]._textSizeRanker		:SetShow( false )
		rankSlot[rankIdx]._textSizeRankerName	:SetShow( false )
		rankSlot[rankIdx]._textSizeRankerSize	:SetShow( false )
	end
	
	for rankIdx = 0, FishEncyclopedia.maxRankSlotCount - 1 do
		
		local rankValue	= ToClient_GetFishTopRankingValueInClient(sizeRankKey, rankIdx)
		
		if nil ~= rankValue then
			--local rankEnable		= rankValue:empty()
			local rankNickName		= rankValue:getUserNickName()
			local rankName			= rankValue:getCharacterName()
			local rankLength		= rankValue.length
			
			if 0 ~= rankLength then
			
				FishSlot._textSizeNoAcquire		:SetShow( false )
				FishSlot._textSizeRankLoading	:SetShow( false )
			
				if (0 == rankIdx) and (selfPlayerNIckName ~= rankNickName) then
					rankSlot[rankIdx]._textSizeRanker		:SetFontColor( UI_color.C_FF84FFF5 )
					rankSlot[rankIdx]._textSizeRankerName	:SetFontColor( UI_color.C_FF84FFF5 )
					rankSlot[rankIdx]._textSizeRankerSize	:SetFontColor( UI_color.C_FF84FFF5 )
				elseif selfPlayerNIckName == rankNickName then
					rankSlot[rankIdx]._textSizeRanker		:SetFontColor(UI_color.C_FFEF9C7F)
					rankSlot[rankIdx]._textSizeRankerName	:SetFontColor(UI_color.C_FFEF9C7F)
					rankSlot[rankIdx]._textSizeRankerSize	:SetFontColor(UI_color.C_FFEF9C7F)
				else
					rankSlot[rankIdx]._textSizeRanker		:SetFontColor(UI_color.C_FFC4BEBE)
					rankSlot[rankIdx]._textSizeRankerName	:SetFontColor(UI_color.C_FFC4BEBE)
					rankSlot[rankIdx]._textSizeRankerSize	:SetFontColor(UI_color.C_FFC4BEBE)
				end	
				rankSlot[rankIdx]._textSizeRanker			:SetText( tostring(rankIdx + 1) .. _textSizeRankingString ) -- "위"
				rankSlot[rankIdx]._textSizeRankerName		:SetText( tostring(rankName .. " (" .. rankNickName .. ")") )
				rankSlot[rankIdx]._textSizeRankerSize		:SetText( tostring(rankLength) )
			
				rankSlot[rankIdx]._textSizeRanker			:SetShow( true )
				rankSlot[rankIdx]._textSizeRankerName		:SetShow( true )
				rankSlot[rankIdx]._textSizeRankerSize		:SetShow( true )
			end
		end
	end
end



function clearFishList()
	for ii = 0, FishEncyclopedia._FISH_COUNT_FOR_PAGE -1, 1 do
		clearFishSlot(ii)
	end
end


function clearFishSlot(index)
	local FishInfo = FishEncyclopedia._fishList[index]
	if nil == FishInfo then
		return
	end
	
	FishInfo._staticFishBack:SetShow( true )
	
	FishInfo._textFishName:SetText("???")
	
	FishInfo._staticFishImage:ChangeTextureInfoName("UI_Artwork/Encyclopedia/Fish_undiscover.dds") -- 발견 안된 어류 이미지
	
	for ii = 0, 4, 1 do -- 어류 등급
		FishInfo._staticFishRating[ii]:SetShow( false )
	end
	
	FishInfo._textDesc:SetText("???")	
	
	FishInfo._buttonFishPosition:SetShow( false ) -- 잡은 위치 (미구현)
	FishInfo._textFishPosition:SetShow( true )
	FishInfo._textFishPosition:SetText("...")
	
	FishInfo._textFishCountNum:SetText("...")
	FishInfo._textFishSizeNum:SetText("...")

	local slot	= FishEncyclopedia._fishList[index].rankList
		
	for idx = 0, FishEncyclopedia.maxRankSlotCount - 1 do
		slot[idx]._textSizeRanker		:SetShow( false )
		slot[idx]._textSizeRankerName	:SetShow( false )
		slot[idx]._textSizeRankerSize	:SetShow( false )
	end	
	
	FishInfo._textSizeNoAcquire		:SetShow( true )
	FishInfo._textSizeRankLoading	:SetShow( false )
end


function FishEncyclopedia:initialize()

	self._fishList[0] = self:createSlot(0)
	self._fishList[0]:setPosition(0,0)
	self._fishList[1] = self:createSlot(1)
	self._fishList[1]:setPosition(462,0)
	
	self._radioButton[0] = self:createRadioButton(0, CppEnums.FishEncyclopediaCategory.eFishEncyclopediaCategory_FreshWaterFish, 	PAGetString(Defines.StringSheet_GAME, "LUA_FISHENCYCLOPEDIA_FRESHWATERFISH"))
	self._radioButton[1] = self:createRadioButton(1, CppEnums.FishEncyclopediaCategory.eFishEncyclopediaCategory_SeaFish, 			PAGetString(Defines.StringSheet_GAME, "LUA_FISHENCYCLOPEDIA_SEAFISH"))
	self._radioButton[2] = self:createRadioButton(2, CppEnums.FishEncyclopediaCategory.eFishEncyclopediaCategory_Crustacea, 		PAGetString(Defines.StringSheet_GAME, "LUA_FISHENCYCLOPEDIA_CRUSTACEA"))
	self._radioButton[3] = self:createRadioButton(3, CppEnums.FishEncyclopediaCategory.eFishEncyclopediaCategory_Etc, 				PAGetString(Defines.StringSheet_GAME, "LUA_FISHENCYCLOPEDIA_ETC"))
	
	self._radioButton[0]:SetCheck(true)
	HandleClicked_FishEncyclopedia_SelectedCategory(CppEnums.FishEncyclopediaCategory.eFishEncyclopediaCategory_FreshWaterFish)
	
	self._pageLeftButton:addInputEvent("Mouse_LUp",		"HandleClicked_FishEncyclopedia_PageMoveButton(true)")
	self._pageRightButton:addInputEvent("Mouse_LUp",	"HandleClicked_FishEncyclopedia_PageMoveButton(false)")

	self._pageLeftButton	:SetAutoDisableTime(0.1)
	self._pageRightButton	:SetAutoDisableTime(0.1)
	
	_static_ScrollEnableArea	:addInputEvent("Mouse_UpScroll",	"ScrollEvent_FishEncyclopedia(true)")
	_static_ScrollEnableArea	:addInputEvent("Mouse_DownScroll",	"ScrollEvent_FishEncyclopedia(false)")
	
	self._pageLeftButton		:addInputEvent("Mouse_UpScroll",	"ScrollEvent_FishEncyclopedia(true)")
	self._pageLeftButton		:addInputEvent("Mouse_DownScroll",	"ScrollEvent_FishEncyclopedia(false)")
	
	self._pageRightButton		:addInputEvent("Mouse_UpScroll",	"ScrollEvent_FishEncyclopedia(true)")
	self._pageRightButton		:addInputEvent("Mouse_DownScroll",	"ScrollEvent_FishEncyclopedia(false)")
	
	self._radioButton[0]		:addInputEvent("Mouse_UpScroll",	"ScrollEvent_FishEncyclopedia(true)")
	self._radioButton[0]		:addInputEvent("Mouse_DownScroll",	"ScrollEvent_FishEncyclopedia(false)")
	self._radioButton[1]		:addInputEvent("Mouse_UpScroll",	"ScrollEvent_FishEncyclopedia(true)")
	self._radioButton[1]		:addInputEvent("Mouse_DownScroll",	"ScrollEvent_FishEncyclopedia(false)")
	self._radioButton[2]		:addInputEvent("Mouse_UpScroll",	"ScrollEvent_FishEncyclopedia(true)")
	self._radioButton[2]		:addInputEvent("Mouse_DownScroll",	"ScrollEvent_FishEncyclopedia(false)")
	self._radioButton[3]		:addInputEvent("Mouse_UpScroll",	"ScrollEvent_FishEncyclopedia(true)")
	self._radioButton[3]		:addInputEvent("Mouse_DownScroll",	"ScrollEvent_FishEncyclopedia(false)")
	
	self._closeButton:addInputEvent("Mouse_LUp",		"HandleClicked_FishEncyclopedia_CloseButton()")
	
	self:deleteStyleUI()
end


function ScrollEvent_FishEncyclopedia( isUp )
	
	if isUp then
		if (FishEncyclopedia._currentPage <= 0) then
		else
			FishEncyclopedia._currentPage = FishEncyclopedia._currentPage - 1
		end
	else
		if (FishEncyclopedia._currentTotalPage <= (FishEncyclopedia._currentPage + 1)) then
		else
			FishEncyclopedia._currentPage = FishEncyclopedia._currentPage + 1
		end
	end
	
	local pageStr = tostring(FishEncyclopedia._currentPage + 1) .. "/" .. tostring(FishEncyclopedia._currentTotalPage)
	FishEncyclopedia._pageStaticText:SetText(pageStr)
	
	changePageButtonEnable()
	updateFishList()
end


function changePageButtonEnable()
	if (FishEncyclopedia._currentPage <= 0) then
		FishEncyclopedia._pageLeftButton:SetIgnore( true )
	else
		FishEncyclopedia._pageLeftButton:SetIgnore( false )
	end
	
	if (FishEncyclopedia._currentTotalPage <= (FishEncyclopedia._currentPage + 1)) then
		FishEncyclopedia._pageRightButton:SetIgnore( true )
	else
		FishEncyclopedia._pageRightButton:SetIgnore( false )
	end
end


function HandleClicked_FishEncyclopedia_PageMoveButton(isLeft)
	if isLeft then
		FishEncyclopedia._currentPage = FishEncyclopedia._currentPage - 1
	else
		FishEncyclopedia._currentPage = FishEncyclopedia._currentPage + 1
	end
	
	local pageStr = tostring(FishEncyclopedia._currentPage + 1) .. "/" .. tostring(FishEncyclopedia._currentTotalPage)
	FishEncyclopedia._pageStaticText:SetText(pageStr)
	
	changePageButtonEnable()
	updateFishList()
end


function updateFishAcquireRate()
	local totalFishCount 	= ToClient_GetTotalFishCount()
	local acquireFishCount 	= ToClient_GetAcquireFishCount()
	local rate				= acquireFishCount / totalFishCount * 100
	FishEncyclopedia._acquireRatePrograss:SetProgressRate( rate )
	local rateText			= math.floor(rate)
	
	FishEncyclopedia._acquireRateStaticText:SetText(rateText .. "%")
end


function HandleClicked_FishEncyclopedia_CloseButton()
	FGlobal_FishEncyclopedia_Close()
end


function FGlobal_FishEncyclopedia_Open()
	audioPostEvent_SystemUi(01,42)
	Panel_FishEncyclopedia:SetShow( true )
end


function FGlobal_FishEncyclopedia_Close()
	Panel_FishEncyclopedia:SetShow( false )
end


local returnTime = 0
function FishSizeRankSetTimeCount( deltaTime )	----- 5초마다 페이지 갱신
	returnTime = returnTime + deltaTime
	if 5 < returnTime then
		returnTime = 0
		updateFishList()
	end
end


FishEncyclopedia:initialize()
updateFishAcquireRate()

registerEvent("FromClient_ResponseFishTopRankingBody", "FromClient_ResponseFishTopRankingBody")
Panel_FishEncyclopedia:RegisterUpdateFunc("FishSizeRankSetTimeCount")
