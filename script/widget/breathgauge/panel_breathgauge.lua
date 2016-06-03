local staticBar = UI.getChildControl( Panel_BreathGauge, "HorseMpBar" )

function EventUpdateBreathGauge( breathGauge )
    local breathGaugeDefaultValue = ToClient_getMaxBreathGauge()
	if ( breathGauge == 0 ) or ( breathGauge == breathGaugeDefaultValue ) then
		Panel_BreathGauge:SetShow(false, false)
	else
		Panel_BreathGauge:SetShow(true, false)
	end
	staticBar:SetProgressRate( breathGauge * 100 / breathGaugeDefaultValue  )
end


registerEvent("EventUpdateBreathGauge", "EventUpdateBreathGauge")