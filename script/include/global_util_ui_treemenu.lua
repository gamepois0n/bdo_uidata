if nil == UI then
	UI = {}
end

local UCT = CppEnums.PA_UI_CONTROL_TYPE
local TreeMenuGroupState =
{
	Closed = 1,
	Opened = 2,
}

TreeMenuItem = {}
TreeMenuItem.__index = TreeMenuItem

function TreeMenuItem.new( control, tree, parentItem )
	local menuItem = {}
	setmetatable( menuItem, TreeMenuItem )

	menuItem.control = control
	menuItem.tree = tree
	menuItem.parent = parentItem

	tree.items:push_back( menuItem )
	menuItem.index = tree.items:length()
	menuItem.startAni		= false

	return menuItem
end

function TreeMenuItem:isRootItem()
	return (nil == self.parent)
end

function TreeMenuItem:isLeafItem()
	return (nil == self.groupInfo)
end

function TreeMenuItem:SetAsParentNode( _radius, _lineTemplate, _linePosFactor, _startRadian, _maxRadian )
	-- Line Template 세로로 긴 것이라고 가정했다!
	local lineLength = _lineTemplate:GetSizeY()

	self.groupInfo =
	{
		childs = Array.new(),
		radius = _radius,
		startRadian = _startRadian,
		maxRadian = _maxRadian,
		state = TreeMenuGroupState.Closed,
		lineTemplate = _lineTemplate,
		calculatedLinePosFactor = 1 - ((_radius - lineLength) * _linePosFactor + (lineLength / 2)) / _radius,
	}
end

function TreeMenuItem:addItem( buttonTemplate, id, imageControl )
	if self:isLeafItem() then
		return nil
	end

	local isChildShow = self.groupInfo.state ~= TreeMenuGroupState.Closed

	local controlID = id or ( self.tree.id .. '_' .. self.tree.items:length() )

	local control = UI.createControl( buttonTemplate:GetType(), self.control, controlID )
	CopyBaseProperty( buttonTemplate, control )
	control:SetShow( isChildShow )

	local childMenuItem = TreeMenuItem.new( control, self.tree, self )
	self.groupInfo.childs:push_back( childMenuItem )

	local line = UI.createControl( self.groupInfo.lineTemplate:GetType(), control, controlID .. '_line' )
	CopyBaseProperty( self.groupInfo.lineTemplate, line )
	line:SetIgnore( true )
	line:SetShow( isChildShow )
	childMenuItem.line = line

	if imageControl ~= nil then
		local imageStatic = UI.createControl( imageControl:GetType(), self.control, controlID .. '_Image' )
		CopyBaseProperty( imageControl, imageStatic )
		imageStatic:SetIgnore( true )
		imageStatic:SetShow( isChildShow )
		childMenuItem.imageStatic = imageStatic
	end

	return childMenuItem
end

function TreeMenuItem:addEvent( event )
	self.control:SetIgnore( false )
	self.control:addInputEvent( "Mouse_LUp", event )
end

function TreeMenuItem:expand()
	if self:isLeafItem() then
		return;
	end

	for _,child in ipairs( self.groupInfo.childs ) do
		child.startAni = false
		child.control:EraseAllEffect()
		child.control:SetShow( true )
		child.control:SetAlpha( 0 )
		UIAni.AlphaAnimation( 1, child.control, 0.0, 0.2 )
		
		child.line:SetShow( true )
		child.line:SetAlpha( 0 )
		UIAni.AlphaAnimation( 1, child.line, 0.0, 0.2 )
			
		if child.imageStatic ~= nil then
			child.imageStatic:SetShow( true )
			child.imageStatic:SetAlpha( 0 )
			UIAni.AlphaAnimation( 1, child.imageStatic, 0.0, 0.2 )
		end
	end
	self.groupInfo.state = TreeMenuGroupState.Opened
end

function TreeMenuItem:collapse()
	if self:isLeafItem() then
		return;
	end

	for _,child in ipairs( self.groupInfo.childs ) do
			local aniInfo = UIAni.AlphaAnimation( 0, child.control, 0.0, 0.2 )
			aniInfo:SetHideAtEnd(true)		
		if child.imageStatic ~= nil then
			aniInfo = UIAni.AlphaAnimation( 0, child.imageStatic, 0.0, 0.2 )
			aniInfo:SetHideAtEnd(true)		
		end
		child.line:SetShow( false )
	end
	self.groupInfo.state = TreeMenuGroupState.Closed
end

function TreeMenuItem:isExpand()
	return self.groupInfo.state == TreeMenuGroupState.Opened;
end

local computeRadPos = function( radian, radius )
	-- Y 축은 Screen 좌표계와 직교 좌표계가 다르므로, 뒤집어줘야 한다!
	return radius * math.cos( radian ), -radius * math.sin( radian )
end

function TreeMenuItem:computePos( parentBasePos, radian, radius, linePosFactor )
	local control = self.control
	local line = self.line
	local imageStatic = self.imageStatic

	local basePosX = control:GetSizeX() / 2
	local basePosY = control:GetSizeY() / 2

	local dx, dy = computeRadPos( radian, radius )

	if( self.startAni == false ) then
		local aniInfo = control:addMoveAnimation( 0.0, 0.2, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR )
		aniInfo:SetStartPosition( parentBasePos.x - basePosX, parentBasePos.y - basePosY )
		aniInfo:SetEndPosition( parentBasePos.x + dx - basePosX ,  parentBasePos.y + dy - basePosY )
		control:CalcUIAniPos(aniInfo)
	
		if imageStatic ~= nil then
			aniInfo = imageStatic:addMoveAnimation( 0.0, 0.2, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR )
			aniInfo:SetStartPosition( parentBasePos.x - basePosX, parentBasePos.y - basePosY )
			aniInfo:SetEndPosition( parentBasePos.x + dx - basePosX ,  parentBasePos.y + dy - basePosY )
			imageStatic:CalcUIAniPos(aniInfo)
		end
	
		self.startAni = true
	end
	
	line:SetPosX( basePosX - dx * linePosFactor - line:GetSizeX() / 2 )
	line:SetPosY( basePosY - dy * linePosFactor - line:GetSizeY() / 2 )
	
	line:SetRotate( math.atan2( -dx, dy ) )
end

TreeMenu = {}
TreeMenu.__index = TreeMenu

function TreeMenu.new( id, parent )
	local treeData = {}
	setmetatable( treeData, TreeMenu )
	-- Single Group Template = { baseControl = nil, baseGroup = nil, radius = 0, startRadian = 0, maxRadian = 0 }
	treeData.items = Array.new()
	treeData.id = id
	treeData.lastExpandItemIndex = 0

	-- Root Item Create!!!
	local control = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, parent, id .. '_1' )
	control:SetIgnore( true )
	control:SetSize(1, 1)
	TreeMenuItem.new( control, treeData, nil )
	return treeData
end

function TreeMenu.new_Button( id, parent )
	local treeData = {}
	setmetatable( treeData, TreeMenu )
	-- Single Group Template = { baseControl = nil, baseGroup = nil, radius = 0, startRadian = 0, maxRadian = 0 }
	treeData.items = Array.new()
	treeData.id = id
	treeData.lastExpandItemIndex = 0

	-- Root Item Create!!!
	local control = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, parent, id .. '_1' )
	control:SetIgnore( false )
	control:SetSize(1, 1)
	TreeMenuItem.new( control, treeData, nil )
	return treeData
end

function TreeMenu:getRootItem()
	return self.items[1]
end

function TreeMenu:getItemByIndex( index )
	return self.items[index]
end

function TreeMenu:expandAll()
	for _,menuItem in ipairs(self.items) do
		menuItem:expand()
	end
end

function TreeMenu:collapseAll()
	for _,menuItem in ipairs(self.items) do
		menuItem:collapse()
	end
end

function TreeMenu:SetShow( bShow )
	self:getRootItem().control:SetShow( bShow )
end

local updatePos = function( menuItem, recursiveFunc )
	local childList = menuItem.groupInfo.childs
	local childCount = childList:length()

	if 0 == childCount then
		return;
	end

	local basePos = float2( menuItem.control:GetSizeX() / 2, menuItem.control:GetSizeY() / 2 )

	if 1 == childCount then
		local radian = (menuItem.groupInfo.startRadian + menuItem.groupInfo.maxRadian) / 2
		local child = childList[1]
		child:computePos( basePos, radian, menuItem.groupInfo.radius, menuItem.groupInfo.calculatedLinePosFactor )

		if not child:isLeafItem() then
			recursiveFunc( child, recursiveFunc )
		end
		return;
	end

	local radianPerChild = (menuItem.groupInfo.maxRadian - menuItem.groupInfo.startRadian) / (childCount - 1)
	-- UI.debugMessage( 'Start : ' .. menuItem.groupInfo.startRadian .. ' / End : ' .. menuItem.groupInfo.maxRadian )
	-- UI.debugMessage( 'Per Child : ' .. radianPerChild .. ' / (' .. childCount .. ')' )
	local radian = menuItem.groupInfo.startRadian
	for idx,child in ipairs(childList) do
		-- UI.debugMessage( tostring(idx) .. '/' .. radian )
		child:computePos( basePos, radian, menuItem.groupInfo.radius, menuItem.groupInfo.calculatedLinePosFactor )
		radian = radian + radianPerChild

		if not child:isLeafItem() then
			recursiveFunc( child, recursiveFunc )
		end
	end
end

function TreeMenu:update()
	local rootItem = self:getRootItem()
	if not rootItem:isLeafItem() then
		updatePos( rootItem, updatePos )
	end
end


-- A
----- A1
----- A2
----- A3
-- B
----- B1
----- B2
-- [[

--[[
local quter_Pi = math.pi / 4
local lineTemplate1 = skill.template_guideLine.v[13]
local lineTemplate2 = skill.template_guideLine.v[14]

local myTree = TreeMenu.new( 'TreeMenuTest', Panel_Window_Skill )
-- 부모가 없는 최상위 Group. 반경은 100px, pi/4 => -pi/4 )

local rootMenuItem = myTree:getRootItem()
rootMenuItem:SetAsParentNode( 100, lineTemplate1, 0.5, quter_Pi, -quter_Pi )

-- A Group
local childItemA = rootMenuItem:addItem( skill.slotConfig.template.learnButton, 'PAButton_TreeMenu_A' )
childItemA.control:SetText('A Button')
childItemA:SetAsParentNode( 100, lineTemplate1, 0.5, quter_Pi, -quter_Pi )
-- 하위 메뉴 Show / Hide Toggle 이벤트 핸들러!
childItemA:addEvent( "TreeMenuItem_ClickTest("..childItemA.index..")" )


local childItemA1 = childItemA:addItem( skill.slotConfig.template.learnButton )
childItemA1.control:SetText('A-1 Button')

local childItemA2 = childItemA:addItem( skill.slotConfig.template.learnButton )
childItemA2.control:SetText('A-2 Button')

local childItemA3 = childItemA:addItem( skill.slotConfig.template.learnButton )
childItemA3.control:SetText('A-3 Button')


local childItemB = rootMenuItem:addItem( skill.slotConfig.template.learnButton, 'PAButton_TreeMenu_B' )
childItemB.control:SetText('B Button')
childItemB:SetAsParentNode( 100, lineTemplate1, 0.5, quter_Pi * 2 / 3, -quter_Pi * 2 / 3 )
childItemB:addEvent( "TreeMenuItem_ClickTest("..childItemB.index..")" )		-- Expand / Collapse

local childItemB1 = childItemB:addItem( skill.slotConfig.template.learnButton )
childItemB1.control:SetText('B-1 Button')

local childItemB2 = childItemB:addItem( skill.slotConfig.template.learnButton )
childItemB2.control:SetText('B-2 Button')
childItemB2.control:addInputEvent('Mouse_LUp', 'SomeFuunction')

rootMenuItem.control:SetPosX( -500 )
myTree:update()
myTree:expandAll()
myTree:SetShow( true )

function TreeMenuItem_ClickTest( index )
	local menuItem = myTree:getItemByIndex( index )
	if nil ~= menuItem then
		if menuItem:isExpand() then
			menuItem:collapse()
		else
			menuItem:expand()
		end
	end
end
]]
