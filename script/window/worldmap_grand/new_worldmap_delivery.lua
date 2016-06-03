local _Util_Math	= Util.Math
local UI_TYPE		= CppEnums.PA_UI_CONTROL_TYPE

-- CppEnums.DelivererType = {
--     NotDeliverer    = 0, --개인마차
--     Wagon           = 1, -- 공용 아이템 운송 마차
--     TransportShip   = 2, -- 공용 아이템 운송 수송선(작은 배)
--     TradingShip     = 3, -- 공용 아이템 운송 교역선(큰 배)
--     WagonForPerson  = 4, -- 공용 사람 운송 마차
--     OfferingCarrier = 5, -- 공물 마차
--     TypeCount       = 6 
-- }

-- CppEnums.eDeliveryProduct = {
--     eDeliveryProduct_Empty          = 0,
--     eDeliveryProduct_Item           = 1,
--     eDeliveryProduct_Person         = 2,
--     eDeliveryProduct_Both           = 3,
-- }
local DelivererType = CppEnums.DelivererType;
local ProductType 	= CppEnums.eDeliveryProduct
local transportKindTexture = {

		[DelivererType.Wagon] = {
			[ProductType.eDeliveryProduct_Empty] 	= { x =  4, y =   3, width = 111, height = 147 },
			[ProductType.eDeliveryProduct_Item] 	= { x =115, y =   3, width = 222, height = 147 },
			[ProductType.eDeliveryProduct_Person] 	= { x =226, y =   3, width = 333, height = 147 },
			[ProductType.eDeliveryProduct_Both] 	= { x =337, y =   3, width = 444, height = 147 },
		},

		[DelivererType.TransportShip] = {
			[ProductType.eDeliveryProduct_Empty] 	= {	x =  4, y = 151, width = 111, height = 295 },
			[ProductType.eDeliveryProduct_Item] 	= {	x =115, y = 151, width = 222, height = 295 },
			[ProductType.eDeliveryProduct_Person] 	= {	x =226, y = 151, width = 333, height = 295 },
			[ProductType.eDeliveryProduct_Both] 	= {	x =337, y = 151, width = 444, height = 295 },
		},

		[DelivererType.TradingShip] = {
			[ProductType.eDeliveryProduct_Empty] 	= { x =  4, y = 299, width = 111, height = 443 },
			[ProductType.eDeliveryProduct_Item] 	= { x =115, y = 299, width = 222, height = 443 },
			[ProductType.eDeliveryProduct_Person] 	= { x =226, y = 299, width = 333, height = 443 },
			[ProductType.eDeliveryProduct_Both] 	= { x =337, y = 299, width = 444, height = 443 },
		},

		[DelivererType.WagonForPerson] = { -- 공용 사람 운송 마차
			[ProductType.eDeliveryProduct_Empty] 	= { x =  4, y =   3, width = 111, height = 147 },
			[ProductType.eDeliveryProduct_Item] 	= { x =115, y =   3, width = 222, height = 147 },
			[ProductType.eDeliveryProduct_Person] 	= { x =226, y =   3, width = 333, height = 147 },
			[ProductType.eDeliveryProduct_Both] 	= { x =337, y =   3, width = 444, height = 147 },
		},

		[DelivererType.OfferingCarrier] = { -- 공물마차
			[ProductType.eDeliveryProduct_Empty] 	= { x =  4, y =   3, width = 111, height = 147 },
			[ProductType.eDeliveryProduct_Item] 	= { x =115, y =   3, width = 222, height = 147 },
			[ProductType.eDeliveryProduct_Person] 	= { x =226, y =   3, width = 333, height = 147 },
			[ProductType.eDeliveryProduct_Both] 	= { x =337, y =   3, width = 444, height = 147 },
		},
}

function FromClient_DelivererStateChange( control, isDelivery )
	local delivererType = control:FromClient_getDelivererType()		-- 마차 타입
	local delivererWrapper = ToClient_worldmapGetDelivererWrapper( control:FromClient_getActorKey() );
	if nil == delivererWrapper then
		return
	end
	local productType = delivererWrapper:getDeliveryProductType();	-- 배송 물품 타입

	control:ChangeTextureInfoName( "New_UI_Common_forLua/Widget/WorldMap/WorldMap_TransporIcon.dds" )

	local uvStartX, uvStartY, uvEndX, uvEndY = setTextureUV_Func( control, transportKindTexture[delivererType][productType].x, transportKindTexture[delivererType][productType].y,
														transportKindTexture[delivererType][productType].width, transportKindTexture[delivererType][productType].height )
	control:getBaseTexture():setUV(  uvStartX, uvStartY, uvEndX, uvEndY )
	control:setRenderTexture( control:getBaseTexture() )

end
--registerEvent("FromClient_ChangeDeliveryIcon", "changeDeliveryIcon");
registerEvent("FromClient_DelivererStateChange", "FromClient_DelivererStateChange")
