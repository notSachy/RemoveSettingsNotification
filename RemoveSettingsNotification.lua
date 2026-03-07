local addon = CreateFrame("Frame")

function addon:RemoveNewSettingsNotification()
	local currentNewSettings = NewSettings[GetBuildInfo()]
	if not currentNewSettings then
		return
	end

	for _, newSetting in ipairs(currentNewSettings) do
		if not NewSettingsSeen[newSetting] then
			-- Set variable securely via this util, other functions exist to do the same
			-- insecurely it will taint action bars and more so don't do that
			TableUtil.TrySet(NewSettingsSeen, newSetting)
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
