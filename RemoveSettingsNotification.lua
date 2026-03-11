local addon = CreateFrame("Frame")

function addon:RemoveNewSettingsNotification()
	for version, settings in pairs(NewSettings) do
		for _, newSetting in ipairs(settings) do
			if not NewSettingsSeen[newSetting] then
				TableUtil.TrySet(NewSettingsSeen, newSetting)
			end
		end
	end
	-- Override the check function to always return false. Safe in 12.0.1, not a secured frame, no taint issues.
	IsNewSettingInCurrentVersion = function() return false end
end

function addon:HookCategoryNewBadges() -- for the stupid fucking new 'new' badges they added INSIDE subcategories...
	if not SettingsCategoryListButtonMixin then return end
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
		self:HookCategoryNewBadges()
	end
end

function addon:OnLoad()
	self:SetScript("OnEvent", self.OnEvent)
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("ADDON_LOADED")
end

addon:OnLoad()

