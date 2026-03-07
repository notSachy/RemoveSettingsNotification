local addon = CreateFrame("Frame")

function addon:RemoveNewSettingsNotification()
	-- Clear new settings from all versions, not just the current build,
	-- so badges are removed even for prior patch entries
	for version, settings in pairs(NewSettings) do
		for _, newSetting in ipairs(settings) do
			if not NewSettingsSeen[newSetting] then
				TableUtil.TrySet(NewSettingsSeen, newSetting)
			end
		end
	end
end

function addon:OnEvent(e, ...)
  self:RemoveNewSettingsNotification()
end

function addon:OnLoad()
  self:SetScript("OnEvent", self.OnEvent)
  self:RegisterEvent("PLAYER_LOGIN")
end

addon:OnLoad()
