-- Charactor Customization // Custom Data Save/Load
-- FileExplorer_Customization.lua

-- 커스터마이징 저장
function OpenExplorerSaveCustomizing()
	InitExplorerOption( PAGetString( Defines.StringSheet_RESOURCE, "FILEEXPLORER_TITLE" ) )
	
	-- 확인 버튼 동작 함수 연동
	FileExplorer_CustomConfirmFunction( SaveCustomData )

	-- FileList 재정렬
	refreshFileList()
end

-- 커스터마이징 읽기
function OpenExplorerLoadCustomizing()
	InitExplorerOption( PAGetString( Defines.StringSheet_RESOURCE, "FILEEXPLORER_TITLE" ) )
	
	-- 확인 버튼 동작 함수 연동
	FileExplorer_CustomConfirmFunction( LoadCustomData )
		
	-- FileList 재정렬
	refreshFileList()
end

function InitExplorerOption( titleName )
	-- FileExplorer.lua Func
	local FilterType = { "None" }	-- 모든 확장자를 보이도록 할때 "None" Type에 등록.
	
	-- Explorer(탐색기) 생성
	FileExplorer_Open(titleName, 0, FilterType)

	FileExplorerSetFilterBoxAtIndex(0)
	
	-- 탐색기에서 사용할 대상 폴더를 지정 ( 현재 기본 폴더 경로는 내문서/유저/BlackDesert/ 입니다. )
	FileExplorerAddPathToCurrentPath("Customization")
	
	-- Prev, Next 버튼을 비활성화
	--FileExplorer_NotUsePrevNextBtn(false)
	
	-- FilterComboBox 를 비활성화
	FileExplorer_NotUseFilterComboBox(false)
	
	-- 기본 Text 지정.
	FileExplorer_SetEditText( "CustomizationData" )
	
	-- 폴더는 탐색기에 노출하지 않는다.
	--FileExplorer_SetDirectorySerch(true)
	
	-- MaxInput size ( 입력받을 사이즈 조절 )
	FileExplorer_setEditTextMaxInput(100)	-- PAUILuaBindFunc.cpp
end

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-- 	Load Custom

function LoadCustomData(text)
	if( text == "" ) then
		-- 파일명이 없습니다.
		local	messageBoxMemo = PAGetString ( Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MESSAGEBOX_NONAME")
		local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"), content = messageBoxMemo,  functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
		return;
	end
	
	local loadPath = FileExplorer_getCurrentPath()
	
	if not isExistCustomizationFile(text, loadPath) then
		local	messageBoxMemo = PAGetString ( Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MESSAGEBOX_LOAD_FAILED")
		local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	else
		local	messageBoxMemo = PAGetString ( Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MESSAGEBOX_APPLY")
		local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = LoadCustomYesBtn, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	end
	
	closeExplorer()
end

function LoadCustomYesBtn()
	local text = FileExplorer_GetEditText()
	
	local loadPath = FileExplorer_getCurrentPath()
	
	loadCustomizationData(text, loadPath)
end


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-- 	Save Custom

function SaveCustomData( text )
	if( text == "" ) then
		-- 파일명이 없습니다.
		local	messageBoxMemo = PAGetString ( Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MESSAGEBOX_NONAME")
		local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"), content = messageBoxMemo,  functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
		return;
	end
	
	local savePath = FileExplorer_getCurrentPath()

	if isExistCustomizationFile(text, savePath) then
		local	messageBoxMemo = PAGetString ( Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MESSAGEBOX_SAVE")
		local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = SaveCustomYesBtn, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	else
		SaveCustomizationFile(text, savePath)
	end
	
	closeExplorer()
end

function SaveCustomYesBtn()
	local text = FileExplorer_GetEditText()
	local savePath = FileExplorer_getCurrentPath()
	SaveCustomizationFile(text, savePath)
end

function SaveCustomizationFile( strFileName, savePath )
	if not saveCustomizationData( strFileName, savePath ) then
		local errorString = "" .. strFileName .. " - " .. PAGetString ( Defines.StringSheet_SymbolNo, "eErrNoInvalidFileNameToSave")
		
		Event_MessageBox_NotifyMessage(errorString)
	end
end