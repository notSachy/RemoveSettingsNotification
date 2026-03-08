local addon = CreateFrame("Frame")

function addon:RemoveNewSettingsNotification()
	-- Mark all settings as seen across all versions
	for version, settings in pairs(NewSettings) do
		for _, newSetting in ipairs(settings) do
			if not NewSettingsSeen[newSetting] then
				TableUtil.TrySet(NewSettingsSeen, newSetting)
			end
		end
	end

	-- Wipe the NewSettings table so IsNewSettingInCurrentVersion()
	-- returns false for everything. This kills NEW tags at all levels:
	-- category sidebar badges, section headers, and individual controls.
	wipe(NewSettings)
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
