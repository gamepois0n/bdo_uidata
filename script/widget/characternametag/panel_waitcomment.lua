Panel_Copy_WaitComment:SetPosX(-1000)
Panel_Copy_WaitComment:SetPosY(-1000)

function FromClient_WaitCommentCreated( actorKeyRaw, targetPanel, selfPlayerActorWrapper )
	copyPanelChild( Panel_Copy_WaitComment, targetPanel )
end


registerEvent("FromClient_WaitCommentCreated", "FromClient_WaitCommentCreated")