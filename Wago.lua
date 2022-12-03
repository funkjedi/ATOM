local addonName, ATOM = ...
local Module = ATOM:NewModule('Wago')

local CopyIntoTable, CompressData, DecompressData, GetField
local GetAddon, SelectAddon, SelectAddonProfile, SelectImportBtn, SelectExportBtn, UpdateDisabledStates

function Module:ShowWindow()
    Module.minwidth = 720
    Module.minheight = 460

    local AceGUI = LibStub('AceGUI-3.0')

    local window = AceGUI:Create('Frame')
    window.frame:SetClampedToScreen(true)
    window.frame:SetFrameStrata('MEDIUM')
    window.frame:Raise()
    window.content:SetFrameStrata('MEDIUM')
    window.content:Raise()
    window:SetTitle('ATOM Import/Export')
    window:SetStatusText('')
    window:SetLayout('Fill')
    window:SetWidth(Module.minwidth)
    window:SetHeight(Module.minheight)
    window:SetAutoAdjustHeight(true)
    window:SetCallback('OnClose', function(widget)
        AceGUI:Release(widget)
    end)
    Module.window = window

    _G['ATOM_WagoWindow'] = window.frame
    tinsert(UISpecialFrames, 'ATOM_WagoWindow')

    local group1 = AceGUI:Create('SimpleGroup')
    group1:SetLayout('List')
    group1:SetFullWidth(true)
    group1:SetFullHeight(true)
    window:AddChild(group1)

    local group2 = AceGUI:Create('SimpleGroup')
    group2:SetLayout('Flow')
    group2:SetFullWidth(true)
    group1:AddChild(group2)

    local supportedAddons = {}

    if GetAddon('Dominos') then
        supportedAddons['Dominos.db'] = 'Dominos'
    end

    local addonDropdown = AceGUI:Create('Dropdown')
    addonDropdown:SetMultiselect(false)
    addonDropdown:SetLabel('Select addon:')
    addonDropdown:SetWidth(200)
    addonDropdown:SetList(supportedAddons)
    addonDropdown:SetCallback('OnValueChanged', SelectAddon)
    window.addonDropdown = addonDropdown
    group2:AddChild(addonDropdown)

    local profileDropdown = AceGUI:Create('Dropdown')
    profileDropdown:SetMultiselect(false)
    profileDropdown:SetLabel('Select profile:')
    profileDropdown:SetWidth(200)
    profileDropdown:SetDisabled(true)
    profileDropdown:SetCallback('OnValueChanged', SelectAddonProfile)
    window.profileDropdown = profileDropdown
    group2:AddChild(profileDropdown)

    local textBox = AceGUI:Create('MultiLineEditBox')
    textBox:SetLabel('')
    textBox:SetMaxLetters(0)
    textBox:SetNumLines(20)
    textBox:SetHeight(290)
    textBox:DisableButton(true)
    textBox:SetFullWidth(true)
    textBox:SetText('')
    textBox:SetCallback('OnTextChanged', SelectAddonProfile)
    window.textBox = textBox
    group1:AddChild(textBox)

    local group3 = AceGUI:Create('SimpleGroup')
    group3:SetLayout('Flow')
    group3:SetFullWidth(true)
    group1:AddChild(group3)

    local importBtn = AceGUI:Create('Button')
    importBtn:SetText('Import')
    importBtn:SetWidth(110)
    importBtn:SetDisabled(true)
    importBtn:SetCallback('OnClick', SelectImportBtn)
    window.importBtn = importBtn
    group3:AddChild(importBtn)

    local exportBtn = AceGUI:Create('Button')
    exportBtn:SetText('Export')
    exportBtn:SetWidth(110)
    exportBtn:SetDisabled(true)
    exportBtn:SetCallback('OnClick', SelectExportBtn)
    window.exportBtn = exportBtn
    group3:AddChild(exportBtn)

    hooksecurefunc(window, 'OnWidthSet', function(widget, width)
        if widget == window and width < Module.minwidth then
            window:SetWidth(Module.minwidth)
        end
    end)

    hooksecurefunc(window, 'OnHeightSet', function(widget, height)
        if widget == window then
            if height < Module.minheight then
                window:SetHeight(Module.minheight)
            else
                textBox:SetHeight(height - Module.minheight + 298)
            end
        end
    end)

    addonDropdown:SetValue('Dominos.db')
    SelectAddon(addonDropdown, 'OnValueChanged', 'Dominos.db')
end

function GetAddon(addon)
    if _G[addon] then
        return _G[addon]
    end

    return LibStub('AceAddon-3.0'):GetAddon(addon, true)
end

function GetField(field)
    local var = _G

    for name in string.gmatch(field, '[%w_]+') do
        if var == _G then
            var = GetAddon(name)
        elseif type(var) == 'table' then
            var = var[name]
        else
            var = nil
        end
    end

    return var
end

function SelectAddon(widget, event, key)
    local database = GetField(key)
    local profiles = {}
    local currentProfile

    if database then
        currentProfile = database:GetCurrentProfile()
        for i, name in pairs(database:GetProfiles()) do
            if name == currentProfile then
                profiles[name] = name .. ' (current)'
            else
                profiles[name] = name
            end
        end
    end

    Module.window.profileDropdown:SetList(profiles)

    if #profiles then
        Module.window.profileDropdown:SetDisabled(false)
    else
        Module.window.profileDropdown:SetDisabled(true)
    end

    if currentProfile then
        Module.window.profileDropdown:SetValue(currentProfile)
        SelectAddonProfile(Module.window.profileDropdown, 'OnValueChanged', currentProfile)
    end
end

function SelectAddonProfile()
    local payload = Module.window.textBox:GetText()
    local profile = Module.window.addonDropdown:GetValue()

    if profile and payload ~= '' then
        Module.window.importBtn:SetDisabled(false)
        Module.window.exportBtn:SetDisabled(true)
    elseif profile then
        Module.window.importBtn:SetDisabled(true)
        Module.window.exportBtn:SetDisabled(false)
    else
        Module.window.importBtn:SetDisabled(true)
        Module.window.exportBtn:SetDisabled(true)
    end
end

function SelectImportBtn()
    local database = GetField(Module.window.addonDropdown:GetValue())
    local profileName = Module.window.profileDropdown:GetValue()
    local profile = DecompressData(Module.window.textBox:GetText())

    if database and profile then
        database:SetProfile(profileName)
        database:ResetProfile(false, true)
        CopyIntoTable(database.profile, profile)
        Module.window.textBox:GetText('')
        Module.window:SetStatusText('Profile imported')
        UpdateDisabledStates()
        ReloadUI()
    else
        Module.window:SetStatusText('Failed to import profile')
    end

end

function SelectExportBtn()
    local database = GetField(Module.window.addonDropdown:GetValue())
    local profileName = Module.window.profileDropdown:GetValue()
    local content

    if database and database.profiles[profileName] then
        content = CompressData(database.profiles[profileName])
    end

    if content then
        Module.window.textBox:SetFocus()
        Module.window.textBox:SetText(content)
        Module.window.textBox:HighlightText()
        Module.window:SetStatusText('Profile exported')
        UpdateDisabledStates()
    else
        Module.window:SetStatusText('Failed to export profile')
    end
end

function UpdateDisabledStates()
    Module.window.addonDropdown:SetDisabled(true)
    Module.window.profileDropdown:SetDisabled(true)
    Module.window.importBtn:SetDisabled(true)
    Module.window.exportBtn:SetDisabled(true)
end

function CopyIntoTable(dst, src)
    for key, value in pairs(src) do
        if (key ~= '__index') then
            if (type(value) == 'table') then
                dst[key] = dst[key] or {}
                CopyIntoTable(dst[key], src[key])
            else
                dst[key] = value
            end
        end
    end
    return dst
end

function CompressData(data)
    local LibDeflate = LibStub:GetLibrary('LibDeflate')
    local LibAceSerializer = LibStub:GetLibrary('AceSerializer-3.0')

    if LibDeflate and LibAceSerializer then
        local serializedData = LibAceSerializer:Serialize(data)

        if not serializedData then
            return nil
        end

        local compressedData = LibDeflate:CompressDeflate(serializedData, { level = 9 })

        if not compressedData then
            return nil
        end

        return LibDeflate:EncodeForPrint(compressedData)
    end
end

function DecompressData(encodedData)
    local LibDeflate = LibStub:GetLibrary('LibDeflate')
    local LibAceSerializer = LibStub:GetLibrary('AceSerializer-3.0')

    if LibDeflate and LibAceSerializer then
        local compressedData = LibDeflate:DecodeForPrint(encodedData)

        if not compressedData then
            return nil
        end

        local serializedData = LibDeflate:DecompressDeflate(compressedData)

        if not serializedData then
            return nil
        end

        local deserialized, data = LibAceSerializer:Deserialize(serializedData)

        if not deserialized then
            return nil
        end

        return data
    end
end
