-- GUI Translator Script with Google Translate API
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local LocalizationService = game:GetService("LocalizationService")

-- Create main GUI in CoreGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TranslatorGUI"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Create main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.3, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BackgroundTransparency = 0.5
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TitleBar.BackgroundTransparency = 0.3
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -70, 1, 0)
TitleText.Position = UDim2.new(0, 20, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Translator"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 20
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Dragging system
local dragging = false
local dragOffset = Vector2.new(0, 0)

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        local mouseLocation = UserInputService:GetMouseLocation()
        dragOffset = Vector2.new(mouseLocation.X - MainFrame.AbsolutePosition.X, mouseLocation.Y - MainFrame.AbsolutePosition.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mouseLocation = UserInputService:GetMouseLocation()
        local newX = mouseLocation.X - dragOffset.X
        local newY = mouseLocation.Y - dragOffset.Y
        
        local screenSize = workspace.CurrentCamera.ViewportSize
        newX = math.clamp(newX, 0, screenSize.X - MainFrame.AbsoluteSize.X)
        newY = math.clamp(newY, 0, screenSize.Y - MainFrame.AbsoluteSize.Y)
        
        MainFrame.Position = UDim2.new(0, newX, 0, newY)
    end
end)

-- Close button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Position = UDim2.new(1, -40, 0, 2.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
CloseButton.BackgroundTransparency = 0.2
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton

-- Circle button
local CircleButton = Instance.new("TextButton")
CircleButton.Name = "CircleButton"
CircleButton.Size = UDim2.new(0, 50, 0, 50)
CircleButton.AnchorPoint = Vector2.new(0.5, 0)
CircleButton.Position = UDim2.new(0.5, 0, 0, 5)
CircleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CircleButton.BackgroundTransparency = 0.3
CircleButton.BorderSizePixel = 0
CircleButton.Text = "🌐"
CircleButton.TextSize = 24
CircleButton.Visible = false
CircleButton.ZIndex = 10
CircleButton.Parent = ScreenGui

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = CircleButton

-- Input area with ScrollingFrame (HAS SLIDER)
local InputScrollingFrame = Instance.new("ScrollingFrame")
InputScrollingFrame.Name = "InputScrollingFrame"
InputScrollingFrame.Size = UDim2.new(1, -30, 0, 50)
InputScrollingFrame.Position = UDim2.new(0, 15, 0, 50)
InputScrollingFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
InputScrollingFrame.BackgroundTransparency = 0.3
InputScrollingFrame.BorderSizePixel = 0
InputScrollingFrame.ScrollBarThickness = 5
InputScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.XY
InputScrollingFrame.CanvasSize = UDim2.new(0, 470, 0, 50)
InputScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
InputScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
InputScrollingFrame.ScrollBarImageTransparency = 0.3
InputScrollingFrame.Parent = MainFrame

local InputScrollCorner = Instance.new("UICorner")
InputScrollCorner.CornerRadius = UDim.new(0, 8)
InputScrollCorner.Parent = InputScrollingFrame

-- Input TextBox inside ScrollingFrame
local InputBox = Instance.new("TextBox")
InputBox.Name = "InputBox"
InputBox.Size = UDim2.new(1, -10, 0, 50)
InputBox.Position = UDim2.new(0, 5, 0, 0)
InputBox.BackgroundTransparency = 1
InputBox.BorderSizePixel = 0
InputBox.Text = ""
InputBox.PlaceholderText = ""
InputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.Font = Enum.Font.Gotham
InputBox.TextSize = 16
InputBox.TextXAlignment = Enum.TextXAlignment.Left
InputBox.TextYAlignment = Enum.TextYAlignment.Center
InputBox.ClearTextOnFocus = false
InputBox.TextWrapped = false
InputBox.TextTruncate = Enum.TextTruncate.None
InputBox.Parent = InputScrollingFrame

local InputPadding = Instance.new("UIPadding")
InputPadding.PaddingLeft = UDim.new(0, 10)
InputPadding.PaddingRight = UDim.new(0, 30)
InputPadding.PaddingTop = UDim.new(0, 15)
InputPadding.PaddingBottom = UDim.new(0, 15)
InputPadding.Parent = InputBox

-- Update canvas size when text changes (for slider)
InputBox:GetPropertyChangedSignal("Text"):Connect(function()
    local textLength = #InputBox.Text
    local estimatedWidth = math.max(470, textLength * 8)
    InputScrollingFrame.CanvasSize = UDim2.new(0, estimatedWidth, 0, 50)
    InputScrollingFrame.CanvasPosition = Vector2.new(estimatedWidth, 0)
end)

-- Clear button
local ClearInputButton = Instance.new("TextButton")
ClearInputButton.Name = "ClearInputButton"
ClearInputButton.Size = UDim2.new(0, 20, 0, 20)
ClearInputButton.Position = UDim2.new(1, -25, 0.5, -10)
ClearInputButton.BackgroundTransparency = 1
ClearInputButton.BorderSizePixel = 0
ClearInputButton.Text = "X"
ClearInputButton.TextColor3 = Color3.fromRGB(150, 150, 150)
ClearInputButton.Font = Enum.Font.GothamBold
ClearInputButton.TextSize = 14
ClearInputButton.Visible = false
ClearInputButton.ZIndex = 5
ClearInputButton.Parent = InputScrollingFrame

InputBox:GetPropertyChangedSignal("Text"):Connect(function()
    ClearInputButton.Visible = #InputBox.Text > 0
end)

ClearInputButton.MouseButton1Click:Connect(function()
    InputBox.Text = ""
    ClearInputButton.Visible = false
    translateText()
end)

-- Result Label
local ResultLabel = Instance.new("TextLabel")
ResultLabel.Name = "ResultLabel"
ResultLabel.Size = UDim2.new(1, -110, 0, 100)
ResultLabel.Position = UDim2.new(0, 15, 0, 110)
ResultLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ResultLabel.BackgroundTransparency = 0.3
ResultLabel.BorderSizePixel = 0
ResultLabel.Text = "Translation will appear here"
ResultLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ResultLabel.Font = Enum.Font.Gotham
ResultLabel.TextSize = 16
ResultLabel.TextWrapped = true
ResultLabel.TextXAlignment = Enum.TextXAlignment.Left
ResultLabel.TextYAlignment = Enum.TextYAlignment.Top
ResultLabel.Parent = MainFrame

local ResultCorner = Instance.new("UICorner")
ResultCorner.CornerRadius = UDim.new(0, 8)
ResultCorner.Parent = ResultLabel

local ResultPadding = Instance.new("UIPadding")
ResultPadding.PaddingLeft = UDim.new(0, 10)
ResultPadding.PaddingRight = UDim.new(0, 10)
ResultPadding.PaddingTop = UDim.new(0, 10)
ResultPadding.PaddingBottom = UDim.new(0, 10)
ResultPadding.Parent = ResultLabel

-- Copy button
local CopyButton = Instance.new("TextButton")
CopyButton.Name = "CopyButton"
CopyButton.Size = UDim2.new(0, 90, 0, 100)
CopyButton.Position = UDim2.new(1, -105, 0, 110)
CopyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
CopyButton.BackgroundTransparency = 0.3
CopyButton.BorderSizePixel = 0
CopyButton.Text = "Copy"
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Font = Enum.Font.GothamBold
CopyButton.TextSize = 16
CopyButton.Parent = MainFrame

local CopyCorner = Instance.new("UICorner")
CopyCorner.CornerRadius = UDim.new(0, 8)
CopyCorner.Parent = CopyButton

-- Language Dropdown
local LanguageDropdown = Instance.new("TextButton")
LanguageDropdown.Name = "LanguageDropdown"
LanguageDropdown.Size = UDim2.new(1, -30, 0, 40)
LanguageDropdown.Position = UDim2.new(0, 15, 0, 220)
LanguageDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
LanguageDropdown.BackgroundTransparency = 0.3
LanguageDropdown.BorderSizePixel = 0
LanguageDropdown.Text = "Target Language: Auto (Detected)"
LanguageDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
LanguageDropdown.Font = Enum.Font.Gotham
LanguageDropdown.TextSize = 16
LanguageDropdown.Parent = MainFrame

local DropdownCorner = Instance.new("UICorner")
DropdownCorner.CornerRadius = UDim.new(0, 8)
DropdownCorner.Parent = LanguageDropdown

-- Dropdown container
local DropdownContainer = Instance.new("Frame")
DropdownContainer.Name = "DropdownContainer"
DropdownContainer.Size = UDim2.new(1, -30, 0, 150)
DropdownContainer.Position = UDim2.new(0, 15, 0, 265)
DropdownContainer.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
DropdownContainer.BackgroundTransparency = 0.2
DropdownContainer.BorderSizePixel = 0
DropdownContainer.Visible = false
DropdownContainer.ZIndex = 20
DropdownContainer.Parent = MainFrame

local DropdownContainerCorner = Instance.new("UICorner")
DropdownContainerCorner.CornerRadius = UDim.new(0, 8)
DropdownContainerCorner.Parent = DropdownContainer

-- Search box
local SearchBox = Instance.new("TextBox")
SearchBox.Name = "SearchBox"
SearchBox.Size = UDim2.new(1, -10, 0, 30)
SearchBox.Position = UDim2.new(0, 5, 0, 5)
SearchBox.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
SearchBox.BackgroundTransparency = 0.2
SearchBox.BorderSizePixel = 0
SearchBox.Text = ""
SearchBox.PlaceholderText = ""
SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 14
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = DropdownContainer

local SearchBoxCorner = Instance.new("UICorner")
SearchBoxCorner.CornerRadius = UDim.new(0, 5)
SearchBoxCorner.Parent = SearchBox

-- Dropdown list with UIListLayout
local DropdownList = Instance.new("ScrollingFrame")
DropdownList.Name = "DropdownList"
DropdownList.Size = UDim2.new(1, -10, 0, 110)
DropdownList.Position = UDim2.new(0, 5, 0, 40)
DropdownList.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
DropdownList.BackgroundTransparency = 0.2
DropdownList.BorderSizePixel = 0
DropdownList.ScrollBarThickness = 5
DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
DropdownList.Parent = DropdownContainer

local DropdownLayout = Instance.new("UIListLayout")
DropdownLayout.Padding = UDim.new(0, 2)
DropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
DropdownLayout.Parent = DropdownList

-- COMPLETE LANGUAGES LIST (100+ languages)
local languages = {
    {name = "Auto (Detected)", code = "auto", autoDetect = true},
    {name = "Afrikaans", code = "af"},
    {name = "Albanian", code = "sq"},
    {name = "Amharic", code = "am"},
    {name = "Arabic", code = "ar"},
    {name = "Armenian", code = "hy"},
    {name = "Azerbaijani", code = "az"},
    {name = "Basque", code = "eu"},
    {name = "Belarusian", code = "be"},
    {name = "Bengali", code = "bn"},
    {name = "Bosnian", code = "bs"},
    {name = "Bulgarian", code = "bg"},
    {name = "Catalan", code = "ca"},
    {name = "Cebuano", code = "ceb"},
    {name = "Chinese (Simplified)", code = "zh-CN"},
    {name = "Chinese (Traditional)", code = "zh-TW"},
    {name = "Corsican", code = "co"},
    {name = "Croatian", code = "hr"},
    {name = "Czech", code = "cs"},
    {name = "Danish", code = "da"},
    {name = "Dutch", code = "nl"},
    {name = "English", code = "en"},
    {name = "Esperanto", code = "eo"},
    {name = "Estonian", code = "et"},
    {name = "Finnish", code = "fi"},
    {name = "French", code = "fr"},
    {name = "Frisian", code = "fy"},
    {name = "Galician", code = "gl"},
    {name = "Georgian", code = "ka"},
    {name = "German", code = "de"},
    {name = "Greek", code = "el"},
    {name = "Gujarati", code = "gu"},
    {name = "Haitian Creole", code = "ht"},
    {name = "Hausa", code = "ha"},
    {name = "Hawaiian", code = "haw"},
    {name = "Hebrew", code = "iw"},
    {name = "Hindi", code = "hi"},
    {name = "Hmong", code = "hmn"},
    {name = "Hungarian", code = "hu"},
    {name = "Icelandic", code = "is"},
    {name = "Igbo", code = "ig"},
    {name = "Indonesian", code = "id"},
    {name = "Irish", code = "ga"},
    {name = "Italian", code = "it"},
    {name = "Japanese", code = "ja"},
    {name = "Javanese", code = "jw"},
    {name = "Kannada", code = "kn"},
    {name = "Kazakh", code = "kk"},
    {name = "Khmer", code = "km"},
    {name = "Korean", code = "ko"},
    {name = "Kurdish (Kurmanji)", code = "ku"},
    {name = "Kyrgyz", code = "ky"},
    {name = "Lao", code = "lo"},
    {name = "Latin", code = "la"},
    {name = "Latvian", code = "lv"},
    {name = "Lithuanian", code = "lt"},
    {name = "Luxembourgish", code = "lb"},
    {name = "Macedonian", code = "mk"},
    {name = "Malagasy", code = "mg"},
    {name = "Malay", code = "ms"},
    {name = "Malayalam", code = "ml"},
    {name = "Maltese", code = "mt"},
    {name = "Maori", code = "mi"},
    {name = "Marathi", code = "mr"},
    {name = "Mongolian", code = "mn"},
    {name = "Myanmar (Burmese)", code = "my"},
    {name = "Nepali", code = "ne"},
    {name = "Norwegian", code = "no"},
    {name = "Nyanja (Chichewa)", code = "ny"},
    {name = "Pashto", code = "ps"},
    {name = "Persian", code = "fa"},
    {name = "Polish", code = "pl"},
    {name = "Portuguese", code = "pt"},
    {name = "Punjabi", code = "pa"},
    {name = "Romanian", code = "ro"},
    {name = "Russian", code = "ru"},
    {name = "Samoan", code = "sm"},
    {name = "Scots Gaelic", code = "gd"},
    {name = "Serbian", code = "sr"},
    {name = "Sesotho", code = "st"},
    {name = "Shona", code = "sn"},
    {name = "Sindhi", code = "sd"},
    {name = "Sinhala", code = "si"},
    {name = "Slovak", code = "sk"},
    {name = "Slovenian", code = "sl"},
    {name = "Somali", code = "so"},
    {name = "Spanish", code = "es"},
    {name = "Sundanese", code = "su"},
    {name = "Swahili", code = "sw"},
    {name = "Swedish", code = "sv"},
    {name = "Tagalog (Filipino)", code = "tl"},
    {name = "Tajik", code = "tg"},
    {name = "Tamil", code = "ta"},
    {name = "Telugu", code = "te"},
    {name = "Thai", code = "th"},
    {name = "Turkish", code = "tr"},
    {name = "Ukrainian", code = "uk"},
    {name = "Urdu", code = "ur"},
    {name = "Uzbek", code = "uz"},
    {name = "Vietnamese", code = "vi"},
    {name = "Welsh", code = "cy"},
    {name = "Xhosa", code = "xh"},
    {name = "Yiddish", code = "yi"},
    {name = "Yoruba", code = "yo"},
    {name = "Zulu", code = "zu"},
}

local function getRobloxLanguageCode()
    local robloxLocale = LocalizationService.RobloxLocaleId
    local localeMap = {
        ["en-us"] = "en", ["es-es"] = "es", ["pt-br"] = "pt", ["de-de"] = "de",
        ["fr-fr"] = "fr", ["it-it"] = "it", ["ja-jp"] = "ja", ["ko-kr"] = "ko",
        ["zh-cn"] = "zh-CN", ["zh-tw"] = "zh-TW", ["ru-ru"] = "ru", ["pl-pl"] = "pl",
        ["nl-nl"] = "nl", ["tr-tr"] = "tr", ["vi-vn"] = "vi", ["th-th"] = "th",
        ["id-id"] = "id", ["ar-sa"] = "ar", ["hi-in"] = "hi", ["sv-se"] = "sv",
        ["no-no"] = "no", ["da-dk"] = "da", ["fi-fi"] = "fi",
    }
    return localeMap[robloxLocale:lower()] or "en"
end

local userLanguageCode = getRobloxLanguageCode()
local selectedLanguage = languages[1]

for _, lang in ipairs(languages) do
    if lang.code == userLanguageCode then
        selectedLanguage = lang
        break
    end
end

if selectedLanguage.autoDetect then
    LanguageDropdown.Text = "Target Language: Auto (Detected)"
else
    LanguageDropdown.Text = "Target Language: " .. selectedLanguage.name .. " (Your Roblox Language)"
end

local languageButtons = {}

local function filterLanguages(searchText)
    for _, button in ipairs(languageButtons) do
        button:Destroy()
    end
    languageButtons = {}
    
    local filteredLanguages = {}
    if searchText == "" then
        filteredLanguages = languages
    else
        for _, lang in ipairs(languages) do
            if lang.name:lower():sub(1, #searchText) == searchText:lower() then
                table.insert(filteredLanguages, lang)
            end
        end
    end
    
    for i, lang in ipairs(filteredLanguages) do
        local langButton = Instance.new("TextButton")
        langButton.Size = UDim2.new(1, 0, 0, 35)
        langButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        langButton.BackgroundTransparency = 0.3
        langButton.BorderSizePixel = 0
        langButton.Text = lang.name
        langButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        langButton.Font = Enum.Font.Gotham
        langButton.TextSize = 15
        langButton.LayoutOrder = i
        langButton.Parent = DropdownList
        
        if lang.code == userLanguageCode and not lang.autoDetect then
            langButton.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
            langButton.Text = lang.name .. " (Your Language)"
        end
        
        langButton.MouseButton1Click:Connect(function()
            selectedLanguage = lang
            if lang.autoDetect then
                LanguageDropdown.Text = "Target Language: Auto (Detected)"
            elseif lang.code == userLanguageCode then
                LanguageDropdown.Text = "Target Language: " .. lang.name .. " (Your Roblox Language)"
            else
                LanguageDropdown.Text = "Target Language: " .. lang.name
            end
            DropdownContainer.Visible = false
            SearchBox.Text = ""
            filterLanguages("")
            translateText()
        end)
        
        table.insert(languageButtons, langButton)
    end
    
    DropdownList.CanvasSize = UDim2.new(0, 0, 0, #filteredLanguages * 37)
end

filterLanguages("")

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    filterLanguages(SearchBox.Text)
end)

-- INPUT PLACEHOLDER ANIMATION (Types text, then refreshes _ 3 times)
local inputPlaceholderText = "Enter text to translate..."
local inputAnimActive = false

local function startInputPlaceholderAnimation()
    if inputAnimActive then return end
    inputAnimActive = true
    
    spawn(function()
        while inputAnimActive and InputBox.Text == "" and not InputBox:IsFocused() do
            -- Type out text
            for i = 1, #inputPlaceholderText do
                if not inputAnimActive or InputBox.Text ~= "" or InputBox:IsFocused() then break end
                InputBox.PlaceholderText = inputPlaceholderText:sub(1, i)
                wait(0.1)
            end
            
            -- Refresh: _ (0.5s) → empty (0.3s), 3 times
            for blink = 1, 3 do
                if not inputAnimActive or InputBox.Text ~= "" or InputBox:IsFocused() then break end
                InputBox.PlaceholderText = inputPlaceholderText .. "_"
                wait(0.5)
                
                if not inputAnimActive or InputBox.Text ~= "" or InputBox:IsFocused() then break end
                InputBox.PlaceholderText = inputPlaceholderText
                wait(0.3)
            end
            
            if inputAnimActive and InputBox.Text == "" and not InputBox:IsFocused() then
                InputBox.PlaceholderText = ""
                wait(0.3)
            end
        end
    end)
end

InputBox.Focused:Connect(function()
    inputAnimActive = false
    InputBox.PlaceholderText = ""
end)

InputBox.FocusLost:Connect(function()
    inputAnimActive = false
    if InputBox.Text == "" then
        startInputPlaceholderAnimation()
    end
end)

-- SEARCH PLACEHOLDER ANIMATION
local searchPlaceholderText = "Search language..."
local searchAnimActive = false

local function startSearchPlaceholderAnimation()
    if searchAnimActive then return end
    searchAnimActive = true
    
    spawn(function()
        while searchAnimActive and SearchBox.Text == "" and not SearchBox:IsFocused() do
            for i = 1, #searchPlaceholderText do
                if not searchAnimActive or SearchBox.Text ~= "" or SearchBox:IsFocused() then break end
                SearchBox.PlaceholderText = searchPlaceholderText:sub(1, i)
                wait(0.08)
            end
            
            for blink = 1, 3 do
                if not searchAnimActive or SearchBox.Text ~= "" or SearchBox:IsFocused() then break end
                SearchBox.PlaceholderText = searchPlaceholderText .. "_"
                wait(0.5)
                
                if not searchAnimActive or SearchBox.Text ~= "" or SearchBox:IsFocused() then break end
                SearchBox.PlaceholderText = searchPlaceholderText
                wait(0.3)
            end
            
            if searchAnimActive and SearchBox.Text == "" and not SearchBox:IsFocused() then
                SearchBox.PlaceholderText = ""
                wait(0.3)
            end
        end
    end)
end

SearchBox.Focused:Connect(function()
    searchAnimActive = false
    SearchBox.PlaceholderText = ""
end)

SearchBox.FocusLost:Connect(function()
    searchAnimActive = false
    if SearchBox.Text == "" then
        startSearchPlaceholderAnimation()
    end
end)

-- Start animations
startInputPlaceholderAnimation()
startSearchPlaceholderAnimation()

-- Translation function
local isTranslating = false
local function translateText()
    local text = InputBox.Text
    if text ~= "" and selectedLanguage and not isTranslating then
        isTranslating = true
        ResultLabel.Text = "Translating..."
        
        local targetLang = selectedLanguage.code
        if selectedLanguage.autoDetect then
            targetLang = userLanguageCode
        end
        
        local url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=" .. 
                    targetLang .. "&dt=t&q=" .. HttpService:UrlEncode(text)
        
        local success, response = pcall(function()
            return HttpService:GetAsync(url)
        end)
        
        if success then
            local success2, decoded = pcall(function()
                return HttpService:JSONDecode(response)
            end)
            
            if success2 and decoded and decoded[1] then
                local translatedText = ""
                for i, segment in ipairs(decoded[1]) do
                    if segment[1] then
                        translatedText = translatedText .. segment[1]
                    end
                end
                
                if translatedText ~= "" then
                    ResultLabel.Text = translatedText
                else
                    ResultLabel.Text = "Translation failed"
                end
            else
                ResultLabel.Text = "Error parsing response"
            end
        else
            ResultLabel.Text = "Translation failed. Check your internet connection."
        end
        
        isTranslating = false
    elseif text == "" then
        ResultLabel.Text = "Translation will appear here"
    end
end

-- Debounced translation
local debounce = false
local function debouncedTranslate()
    if not debounce then
        debounce = true
        translateText()
        wait(0.5)
        debounce = false
    end
end

InputBox:GetPropertyChangedSignal("Text"):Connect(debouncedTranslate)

InputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        translateText()
    end
end)

-- Copy button functionality
CopyButton.MouseButton1Click:Connect(function()
    if ResultLabel.Text ~= "Translation will appear here" and 
       ResultLabel.Text ~= "Translating..." and
       ResultLabel.Text ~= "Translation failed" and
       ResultLabel.Text ~= "Error parsing response" and
       ResultLabel.Text ~= "Translation failed. Check your internet connection." then
        setclipboard(ResultLabel.Text)
        CopyButton.Text = "Copied!"
        wait(1)
        CopyButton.Text = "Copy"
    end
end)

-- Dropdown toggle
LanguageDropdown.MouseButton1Click:Connect(function()
    DropdownContainer.Visible = not DropdownContainer.Visible
    if DropdownContainer.Visible then
        SearchBox.Text = ""
        filterLanguages("")
        SearchBox:CaptureFocus()
    end
end)

-- Close dropdown when clicking elsewhere
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and DropdownContainer.Visible then
        local mousePos = UserInputService:GetMouseLocation()
        local dropdownBounds = DropdownContainer.AbsolutePosition
        local dropdownSize = DropdownContainer.AbsoluteSize
        
        if mousePos.X < dropdownBounds.X or mousePos.X > dropdownBounds.X + dropdownSize.X or
           mousePos.Y < dropdownBounds.Y or mousePos.Y > dropdownBounds.Y + dropdownSize.Y then
            DropdownContainer.Visible = false
            SearchBox.Text = ""
            filterLanguages("")
        end
    end
end)

-- Close button functionality
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    CircleButton.Visible = true
end)

-- Circle button functionality
CircleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    CircleButton.Visible = false
end)

-- Circle button dragging
local circleDragging = false
local circleDragOffset = Vector2.new(0, 0)

CircleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        circleDragging = true
        local mouseLocation = UserInputService:GetMouseLocation()
        circleDragOffset = Vector2.new(mouseLocation.X - CircleButton.AbsolutePosition.X, mouseLocation.Y - CircleButton.AbsolutePosition.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        circleDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if circleDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mouseLocation = UserInputService:GetMouseLocation()
        local newX = mouseLocation.X - circleDragOffset.X
        local newY = mouseLocation.Y - circleDragOffset.Y
        
        local screenSize = workspace.CurrentCamera.ViewportSize
        newX = math.clamp(newX, 0, screenSize.X - CircleButton.AbsoluteSize.X)
        newY = math.clamp(newY, 0, screenSize.Y - CircleButton.AbsoluteSize.Y)
        
        CircleButton.Position = UDim2.new(0, newX, 0, newY)
    end
end)

CircleButton.MouseButton2Click:Connect(function()
    CircleButton.Position = UDim2.new(0.5, 0, 0, 5)
end)

print("Translator GUI loaded successfully!")
print("Total languages: " .. #languages)
print("Placeholder: Types text, then refreshes _ 3 times!")
print("Input textbox has visible slider for long text!")
