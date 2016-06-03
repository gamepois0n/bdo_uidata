local dialogQuestButtonIcon = {
	  [0] = {380, 31, 398, 50},		--흑정령 의뢰 (Icon이미지 없음)
			{475, 1,  493, 20},		--스토리 의뢰(주요 의뢰)
			{380, 11, 398, 30},		--마을 의뢰	(일반 의뢰)
			{418, 1,  436, 20},		--탐험 의뢰
			{437, 1,  455, 20},		--무역 의뢰
			{456, 1,  474, 20},		--생산 의뢰
			{399, 1,  417, 20},		--반복 의뢰
			{399, 21, 417, 40}		--완료
}

local dialogButtonIcon = {
	  [0] = {0, 0, 0, 0},			--일반 대화 
			{494, 41, 512, 59},		--지식 주는 대화
			{475, 41, 493, 60},		--기능 있는 대화
			{418, 21, 436, 40},		--컷씬 있는 대화
			{494, 21, 512, 40},		--아이템 교환 있는 대화
			{494, 21, 512, 40},		--아이템 교환 있는 대화
}

function FGlobal_ChangeOnTextureForDialogQuestIcon(control, iconType)
	control:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Etc_00.dds" )
	local x1, y1, x2, y2 = setTextureUV_Func( control, dialogQuestButtonIcon[iconType][1], dialogQuestButtonIcon[iconType][2], dialogQuestButtonIcon[iconType][3], dialogQuestButtonIcon[iconType][4] )
	control:getBaseTexture():setUV(  x1, y1, x2, y2  )
	control:setRenderTexture(control:getBaseTexture())
end

function FGlobal_ChangeOnTextureForDialogIcon(control, iconType)
	control:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Etc_00.dds" )
	local x1, y1, x2, y2 = setTextureUV_Func( control, dialogButtonIcon[iconType][1], dialogButtonIcon[iconType][2], dialogButtonIcon[iconType][3], dialogButtonIcon[iconType][4] )
	control:getBaseTexture():setUV(  x1, y1, x2, y2  )
	control:setRenderTexture(control:getBaseTexture())
end
