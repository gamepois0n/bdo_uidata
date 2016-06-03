local UI_color 		= Defines.Color

Panel_GuardGauge:SetShow(false, false)

local guardGauge 			= UI.getChildControl( Panel_GuardGauge, "Progress2_1" )
local bar_FullGauge 		= UI.getChildControl( Panel_GuardGauge, "GuardGauge_ProgresssBG" )
local txt_GuardGaugeMax 	= UI.getChildControl( Panel_GuardGauge, "StaticText_GuardGaugeCount" )
-- local staticBar 		= UI.getChildControl( Panel_Stamina, "StaminaBar" )
-- local _txt_StaminaMax 	= UI.getChildControl( Panel_GuardGauge, "StaticText_GuardGaugeCount" )
-- local _cannonDesc 		= UI.getChildControl( Panel_GuardGauge, "StaticText_CannonDesc" )

-- local maxBarSize = guardGauge:GetSizeX()

Panel_GuardGauge:RegisterShowEventFunc( false, 'Panel_GuardGauge_HideAni()' )

Panel_GuardGauge:SetPosX(100)
Panel_GuardGauge:SetPosY(200)


function Panel_GuardGauge_HideAni()
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_GuardGauge, 0.0, 0.3 )
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

function GuardGauge_Update()
	local selfPlayerWrapper = getSelfPlayer()
	if nil ~= selfPlayerWrapper then
		local sp = selfPlayerWrapper:get():getCurrentGuard()
		local maxSp = selfPlayerWrapper:get():getMaxGuard()
			
		-- UI.debugMessage( "sp: " .. sp .. " / maxSp: " .. maxSp .. "/ useType: " .. tostring(useType) .. "/ recover: " .. tostring(SpUseType.Recover) )
		if ( sp == maxSp ) then
			-- ♬ 스태미너가 다 찼을 때 효과음 추가
			-- audioPostEvent_SystemUi(02,00)
			bar_FullGauge:SetShow( true )
			bar_FullGauge:EraseAllEffect()
		
			Panel_GuardGauge:SetShow( false, false )
			return
		end
			
				-- UI.flushAndClearUI()가 호출되도 밑에서 setshow(true,false)를 직접호출하기에
				-- 원하지 않게 보여지게 된다. 그래서 flushed 상태를 체크하고 setshow(false,false)를 직접해준다.
				-- UI.isFlushedUI()가 필요하지 않는 방법이 있다면 수정한다.[20131005:흥신]
		if( true == UI.isFlushedUI() ) then
			Panel_GuardGauge:SetShow( false, false )
			return
		end
			
		local spRate = sp / maxSp
		local alpha = ( 1 - spRate ) * 15		-- 숫자가 늘어날 수록 알파가 뒤늦게 들어온다
		local fullGauge = ( spRate ) * 100
		-- UI.debugMessage( spRate .. " / " .. alpha .. " / " .. fullGauge )
		if 1 < alpha then
			alpha = 1
		end
		-- UI.debugMessage( fullGauge )
		Panel_GuardGauge:SetAlphaChild( alpha )
		guardGauge:SetProgressRate( fullGauge )
		txt_GuardGaugeMax:SetFontAlpha( alpha )
		txt_GuardGaugeMax:SetText( tostring( math.floor(spRate * 100) ) )
		-- _bar_FullGauge:EraseAllEffect()
		Panel_GuardGauge:SetShow( true, false )
	end
end

registerEvent("FromClientGuardUpdate", "GuardGauge_Update()")
Panel_GuardGauge:RegisterUpdateFunc("GuardGauge_Update")
