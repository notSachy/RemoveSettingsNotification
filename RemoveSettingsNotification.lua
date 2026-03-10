local addon = CreateFrame("Frame")

function addon:RemoveNewSettingsNotification()
	-- Override the check function to always return false.
	-- We intentionally avoid modifying NewSettings/NewSettingsSeen tables
	-- because that taints the secure GameMenuFrame execution path.
	IsNewSettingInCurrentVersion = function() return false end
end

function addon:HookCategoryNewBadges()
	if not SettingsCategoryListButtonMixin then return end

	-- Force-hide category sidebar NEW badges
	hooksecurefunc(SettingsCategoryListButtonMixin, "RefreshNewFeature", function(button)
		button.NewFeature:SetShown(false)
	end)

	self.hookedCategoryBadges = true
end

function addon:OnEvent(e, arg1)
	if e == "PLAYER_LOGIN" then
		self:RemoveNewSettingsNotification()
		self:HookCategoryNewBadges()
	elseif e == "ADDON_LOADED" and not self.hookedCategoryBadges then
		-- Settings addon may load on demand after PLAYER_LOGIN
		self:HookCategoryNewBadges()
	end
end

function addon:OnLoad()
	self:SetScript("OnEvent", self.OnEvent)
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("ADDON_LOADED")
end

addon:OnLoad()
