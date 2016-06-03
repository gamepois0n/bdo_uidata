local UI_color 		= Defines.Color

Panel_Stamina:SetShow(false, false)

local staticBar 		= UI.getChildControl( Panel_Stamina, "StaminaBar" )
local _bar_FullGauge 	= UI.getChildControl( Panel_Stamina, "Static_FullGauge" )
local _txt_StaminaMax 	= UI.getChildControl( Panel_Stamina, "StaticText_StaminaMax" )
local _cannonDesc 		= UI.getChildControl( Panel_Stamina, "StaticText_CannonDesc" )

local maxBarSize = staticBar:GetSizeX()

Panel_Stamina:RegisterShowEventFunc( false, 'Panel_Stamina_HideAni()' )


function Panel_Stamina_HideAni()
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_Stamina, 0.0, 0.2 )
	aniInfo:SetHideAtEnd(true)
end

local SpUseType =
{
	Once = 0,
	Continue = 1,
	Recover = 2,
	Stop = 3,
	Reset = 4,
	None = 5
}

-- local x1, y1, x2, y2
function Stamina_Update()
	local selfPlayerWrapper = getSelfPlayer()
	if nil ~= selfPlayerWrapper then
		local stamina = selfPlayerWrapper:get():getStamina()
		if nil ~= stamina then
			local sp = stamina:getSp()
			local maxSp = stamina:getMaxSp()
			local useType = stamina:getUseType()

			if ( Panel_Cannon_Value_IsCannon == true ) then
				_cannonDesc:SetShow( true )
			else
				_cannonDesc:SetShow( false )
			end
			
			if ( sp == maxSp ) and ( useType == SpUseType.Recover ) then
				-- ♬ 스태미너가 다 찼을 때 효과음 추가
				-- audioPostEvent_SystemUi(02,00)
				
				_bar_FullGauge:SetShow( true )
				_bar_FullGauge:EraseAllEffect()
			
				Panel_Stamina:SetShow( false, false )
				return
			end
			
				-- UI.flushAndClearUI()가 호출되도 밑에서 setshow(true,false)를 직접호출하기에
				-- 원하지 않게 보여지게 된다. 그래서 flushed 상태를 체크하고 setshow(false,false)를 직접해준다.
				-- UI.isFlushedUI()가 필요하지 않는 방법이 있다면 수정한다.[20131005:흥신]
			if( true == UI.isFlushedUI() ) then
				Panel_Stamina:SetShow( false, false )
				return
			end
			
			local spRate = sp / maxSp
			local alpha = ( 1 - spRate ) * 15		-- 숫자가 늘어날 수록 알파가 뒤늦게 들어온다
			local fullGauge = ( spRate ) * 100
			
			if 1 < alpha then
				alpha = 1
			end
			
			Panel_Stamina:SetAlphaChild( alpha )
			staticBar:SetProgressRate( fullGauge )
			_txt_StaminaMax:SetFontAlpha( alpha )
			_txt_StaminaMax:SetText( tostring( math.floor(spRate * 100) ) )
			-- _bar_FullGauge:EraseAllEffect()
			Panel_Stamina:SetShow( true, false )
			
			local totalStamina = math.floor(spRate * 100)
			-- _PA_LOG("LUA", "spRate : " .. spRate )
			-- staticBar:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Gauges_02.dds")
			
			-- if ( totalStamina > 80 ) then
				-- x1, y1, x2, y2 = setTextureUV_Func( staticBar, 66, 1, 130, 65 )
			-- elseif ( totalStamina > 60 ) then
				-- x1, y1, x2, y2 = setTextureUV_Func( staticBar, 131, 1, 195, 65 )
			-- elseif ( totalStamina > 40 ) then
				-- x1, y1, x2, y2 = setTextureUV_Func( staticBar, 196, 1, 260, 65 )
			-- elseif ( totalStamina > 35 ) then
				-- x1, y1, x2, y2 = setTextureUV_Func( staticBar, 261, 1, 325, 65 )
			-- elseif ( totalStamina > 30 ) then
				-- x1, y1, x2, y2 = setTextureUV_Func( staticBar, 326, 1, 390, 65 )
			-- elseif ( totalStamina > 25 ) then
				-- x1, y1, x2, y2 = setTextureUV_Func( staticBar, 66, 66, 130, 130 )
			-- elseif ( totalStamina > 20 ) then
				-- x1, y1, x2, y2 = setTextureUV_Func( staticBar, 131, 66, 195, 130 )
			-- elseif ( totalStamina > 15 ) then
				-- x1, y1, x2, y2 = setTextureUV_Func( staticBar, 196, 66, 260, 130 )
			-- elseif ( totalStamina > 10 ) then
				-- x1, y1, x2, y2 = setTextureUV_Func( staticBar, 261, 66, 325, 130 )
			-- elseif ( totalStamina > 5 ) then
				-- x1, y1, x2, y2 = setTextureUV_Func( staticBar, 326, 66, 390, 130 )
			-- else
				-- x1, y1, x2, y2 = setTextureUV_Func( staticBar, 326, 66, 390, 130 )
			-- end
			-- staticBar:getBaseTexture():setUV( x1, y1, x2, y2 )
			-- staticBar:setRenderTexture(staticBar:getBaseTexture())
		end
	end
end

registerEvent("EventStaminaUpdate", "Stamina_Update()")
Panel_Stamina:RegisterUpdateFunc("Stamina_Update")
