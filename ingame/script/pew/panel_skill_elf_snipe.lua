------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local _radial = UI.getChildControl ( Panel_Skill_Elf_Snipe, "Static_Radial" )

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Panel_Skill_Elf_Snipe_ScreenResize()
	local scrX = getScreenSizeX()
	local scrY = getScreenSizeY()
	
	Panel_Skill_Elf_Snipe:SetSize ( scrX, scrY )
	Panel_Skill_Elf_Snipe:SetPosX ( 0 )
	Panel_Skill_Elf_Snipe:SetPosY ( 0 )
	_radial:SetSize ( scrX, scrY )
end


function Panel_Skill_Elf_Snipe_Start()
	Panel_Skill_Elf_Snipe:SetShow( true, false )
end

function Panel_Skill_Elf_Snipe_End()
	if Panel_Skill_Elf_Snipe:IsShow() then
		Panel_Skill_Elf_Snipe:SetShow( false, false )
	end
end



registerEvent("onScreenResize", "Panel_Skill_Elf_Snipe_ScreenResize")