function Initialize()
	local activeTab = tonumber( SKIN:GetVariable('Tab') )
	SKIN:Bang('[!SetOption MeterBG ImageName "#@#Images\\Options\\OptionsBG'..activeTab..'.png"][!SetOption MeterTab'..activeTab..' FontColor FFFFFF]')
	getState()

	JSON = JSONDecode()
	function JSON:assert(message, text, location, etc)
		return
	end

	-- Populate tables
	helpTable()
	colorTable()
end

function getState()
	local activeTab = tonumber( SKIN:GetVariable('Tab') )
	if (activeTab == 1) then
		-- viewersDisplay
		local viewersDisplay = SKIN:GetVariable('ViewersDisplay')
		if (viewersDisplay == "Full") then
			SKIN:Bang('[!SetOption MeterFullButton ImageName "#@#Images\\Options\\PressedButton.png"][!SetOption MeterCompactButton ImageName "#@#Images\\Options\\DepressedButton.png"]')
		else
			SKIN:Bang('[!SetOption MeterFullButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterCompactButton ImageName "#@#Images\\Options\\PressedButton.png"]')
		end
		-- Thumbnails
		local thumbnails = SKIN:GetVariable('Thumbnails')
		if (thumbnails == "On") then
			SKIN:Bang('[!SetOption MeterOnButton ImageName "#@#Images\\Options\\PressedButton.png"][!SetOption MeterOffButton ImageName "#@#Images\\Options\\DepressedButton.png"]')
		else
			SKIN:Bang('[!SetOption MeterOffButton ImageName "#@#Images\\Options\\PressedButton.png"][!SetOption MeterOnButton ImageName "#@#Images\\Options\\DepressedButton.png"]')
		end
		-- Online Notifs
		local notifs = SKIN:GetVariable('Notifications')
		if (notifs == "On") then
			SKIN:Bang('[!SetOption MeterNotifOnButton ImageName "#@#Images\\Options\\PressedButton.png"][!SetOption MeterNotifOffButton ImageName "#@#Images\\Options\\DepressedButton.png"]')
		else
			SKIN:Bang('[!SetOption MeterNotifOffButton ImageName "#@#Images\\Options\\PressedButton.png"][!SetOption MeterNotifOnButton ImageName "#@#Images\\Options\\DepressedButton.png"]')
		end
		-- Livestreamer Quality
		local quality = SKIN:GetVariable('Quality')
		if (quality == "Source") then
			SKIN:Bang('[!SetOption MeterSourceButton ImageName "#@#Images\\Options\\PressedButton.png"][!SetOption MeterHighButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterMediumButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterLowButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterMobileButton ImageName "#@#Images\\Options\\DepressedButton.png"]')
		elseif (quality == "High") then
			SKIN:Bang('[!SetOption MeterHighButton ImageName "#@#Images\\Options\\PressedButton.png"][!SetOption MeterSourceButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterMediumButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterLowButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterMobileButton ImageName "#@#Images\\Options\\DepressedButton.png"]')
		elseif (quality == "Medium") then
			SKIN:Bang('[!SetOption MeterMediumButton ImageName "#@#Images\\Options\\PressedButton.png"][!SetOption MeterSourceButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterHighButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterLowButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterMobileButton ImageName "#@#Images\\Options\\DepressedButton.png"]')
		elseif (quality == "Low") then
			SKIN:Bang('[!SetOption MeterLowButton ImageName "#@#Images\\Options\\PressedButton.png"][!SetOption MeterSourceButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterHighButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterMediumButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterMobileButton ImageName "#@#Images\\Options\\DepressedButton.png"]')
		elseif (quality == "Mobile") then
			SKIN:Bang('[!SetOption MeterMobileButton ImageName "#@#Images\\Options\\PressedButton.png"][!SetOption MeterSourceButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterHighButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterMediumButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterLowButton ImageName "#@#Images\\Options\\DepressedButton.png"]')
		end
	end
	SKIN:Bang('[!UpdateMeter *][!Redraw]')
end

function tabHandler(i)
	local tab = SKIN:GetVariable('Tab')
	if (i == tonumber(tab)) then -- do nothing if already on the same tab
		return
	end

	SKIN:Bang('[!WriteKeyValue "Variables" "Tab" "'..i..'" "#@#OptionVars.inc"]')

	SKIN:Bang('[!Refresh]')
end

function setColor(meter, colorVar)
	SKIN:Bang('!SetOption', 'measureRainRGB', 'Parameter', '"""VarName='..colorVar..'" "FileName=#@#colorVars.inc" "RefreshConfig=IgnoreThisError"""')
	SKIN:Bang('!SetOption', 'measureRainRGB', 'FinishAction', '[!CommandMeasure MeasureOptionsLUA "readColor(\''..meter..'\', \''..colorVar..'\')"]')

	SKIN:Bang('[!UpdateMeasure measureRainRGB]')
	SKIN:Bang('[!CommandMeasure measureRainRGB Run]')
end

function readColor(meter, colorVar)
	local resourcePath = SKIN:GetVariable('@')
	local f = assert(io.open(resourcePath..'colorVars.inc', 'r'), 'Unable to open colorVars.inc')
	for line in f:lines() do
		if not line:match('^%s-;') then
			local key, color = line:match('^([^=]+)=(.+)')
			if (key == colorVar) then
				SKIN:Bang('!SetVariable', key, color)
				SKIN:Bang('!SetVariable', key, color, 'TwitchLiveFollowers\\Twitch')
				SKIN:Bang('!SetOption', meter, 'DynamicVariables', '0')
				for k, v in pairs(tColors[meter]) do	-- Sets the correponding meter/s in the main ini to Dynamic for one update. pairs might be able to be ipairs?
					SKIN:Bang('!SetOption', v, 'DynamicVariables', '0', 'TwitchLiveFollowers\\Twitch')
				end

				SKIN:Bang('[!UpdateMeter *][!Redraw]')
				SKIN:Bang('[!UpdateMeter * "TwitchLiveFollowers\\Twitch"][!Redraw "TwitchLiveFollowers\\Twitch"]')
				break
			end
		end
	end
	f:close()
end

function readColorProfile(inputfile)
	local resourcePath = SKIN:GetVariable('@')
	local defaultVars = assert(io.open(resourcePath..inputfile, 'r'), 'Unable to open ' .. inputfile)
	for line in defaultVars:lines() do
		if not line:match('^%s-;') then
			local key, color = line:match('^([^=]+)=(.+)')
			if key then
				SKIN:Bang('!SetVariable', key, color, 'TwitchLiveFollowers\\Twitch')
				SKIN:Bang('!WriteKeyValue', 'Variables', key, color, '#@#colorVars.inc')
			end
		end
	end

	defaultVars:close()

	SKIN:Bang('[!Refresh "TwitchLiveFollowers\\Twitch"]')
	SKIN:Bang('[!Refresh]')
end

function viewersDisplay(currentOption)
	if ( SKIN:GetVariable('ViewersDisplay') ~= currentOption ) then
		SKIN:Bang('[!SetVariable ViewersDisplay '..currentOption..'][!WriteKeyValue Variables ViewersDisplay '..currentOption..' "#@#OptionVars.inc"]')
		if (currentOption == "Full") then
			SKIN:Bang('[!SetOption MeterFullButton ImageName "#@#Images\\Options\\PressedButton.png"][!SetOption MeterCompactButton ImageName "#@#Images\\Options\\DepressedButton.png"]')
			SKIN:Bang('[!SetVariable numFormat 0 "TwitchLiveFollowers\\Twitch"][!WriteKeyValue Variables numFormat 0 "#@#Variables.inc"]')
			SKIN:Bang('[!CommandMeasure MeasureLUA "printTable()" "TwitchLiveFollowers\\Twitch"]')
		else
			SKIN:Bang('[!SetOption MeterFullButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterCompactButton ImageName "#@#Images\\Options\\PressedButton.png"]')
			SKIN:Bang('[!SetVariable numFormat 1 "TwitchLiveFollowers\\Twitch"][!WriteKeyValue Variables numFormat 1 "#@#Variables.inc"]')
			SKIN:Bang('[!CommandMeasure MeasureLUA "printTable()" "TwitchLiveFollowers\\Twitch"]')
		end
		SKIN:Bang('[!UpdateMeter *][!Redraw]')
	end
end

function thumbnails(currentOption)
	if ( SKIN:GetVariable('Thumbnails') ~= currentOption ) then
		SKIN:Bang('[!SetVariable Thumbnails '..currentOption..'][!WriteKeyValue Variables Thumbnails '..currentOption..' "#@#OptionVars.inc"]')
		if (currentOption == "On") then
			SKIN:Bang('[!SetOption MeterOnButton ImageName "#@#Images\\Options\\PressedButton.png"][!SetOption MeterOffButton ImageName "#@#Images\\Options\\DepressedButton.png"]')
			SKIN:Bang('[!SetVariable Thumbnails 1 "TwitchLiveFollowers\\Twitch"][!WriteKeyValue Variables Thumbnails 1 "#@#Variables.inc"]')
			SKIN:Bang('[!SetVariable LastConfigX -9999 "TwitchLiveFollowers\\Twitch"][!WriteKeyValue Variables LastConfigX -9999 "#@#Variables.inc"]') -- Forces recalculation in showThumbnails()

			SKIN:Bang('[!WriteKeyValue Variables ThumbsDisabled 0 "#@#Variables.inc"]')
			SKIN:Bang('[!Refresh TwitchLiveFollowers\\Twitch]')
		elseif (currentOption == "Off") then
			SKIN:Bang('[!SetOption MeterOffButton ImageName "#@#Images\\Options\\PressedButton.png"][!SetOption MeterOnButton ImageName "#@#Images\\Options\\DepressedButton.png"]')
			SKIN:Bang('[!SetVariable Thumbnails 2 "TwitchLiveFollowers\\Twitch"][!WriteKeyValue Variables Thumbnails 2 "#@#Variables.inc"]')
			SKIN:Bang('[!SetVariable ThumbsDisabled 1 "TwitchLiveFollowers\\Twitch"][!WriteKeyValue Variables ThumbsDisabled 1 "#@#Variables.inc"]')
			SKIN:Bang('[!UpdateMeter * "TwitchLiveFollowers\\Twitch"]')
		end
		SKIN:Bang('[!UpdateMeter *][!Redraw]')
	end
end

function onlineNotifications(currentOption)
	if ( SKIN:GetVariable('Notifications') ~= currentOption ) then
		SKIN:Bang('[!SetVariable Notifications '..currentOption..'][!WriteKeyValue Variables Notifications '..currentOption..' "#@#OptionVars.inc"]')
		if (currentOption == "On") then
			SKIN:Bang('[!SetOption MeterNotifOnButton ImageName "#@#Images\\Options\\PressedButton.png"][!SetOption MeterNotifOffButton ImageName "#@#Images\\Options\\DepressedButton.png"]')
			SKIN:Bang('[!SetVariable Notifications 1 "TwitchLiveFollowers\\Twitch"][!WriteKeyValue Variables Notifications 1 "#@#Variables.inc"]')
		elseif (currentOption == "Off") then
			SKIN:Bang('[!SetOption MeterNotifOffButton ImageName "#@#Images\\Options\\PressedButton.png"][!SetOption MeterNotifOnButton ImageName "#@#Images\\Options\\DepressedButton.png"]')
			SKIN:Bang('[!SetVariable Notifications 0 "TwitchLiveFollowers\\Twitch"][!WriteKeyValue Variables Notifications 0 "#@#Variables.inc"]')
		end
		SKIN:Bang('[!UpdateMeter *][!Redraw]')
	end
end

function livestreamerQuality(currentOption)
	local quality = SKIN:GetVariable('Quality')
	if (quality ~= currentOption) then
		SKIN:Bang('[!SetVariable Quality '..currentOption..'][!WriteKeyValue Variables Quality '..currentOption..' "#@#OptionVars.inc"]')
		if (currentOption == 'Source') then
			SKIN:Bang('[!SetOption MeterSourceButton ImageName "#@#Images\\Options\\PressedButton.png"][!SetOption MeterHighButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterMediumButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterLowButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterMobileButton ImageName "#@#Images\\Options\\DepressedButton.png"]')
			SKIN:Bang('[!SetVariable Quality "Source" "TwitchLiveFollowers\\Twitch"][!WriteKeyValue Variables Quality "Source" "#@#Variables.inc"]')
			SKIN:Bang('[!SetOption MeterVLCIcon ToolTipTitle "Watch Using Livestreamer (Current Quality: Source)" "TwitchLiveFollowers\\Twitch"]')
		elseif (currentOption == 'High') then
			SKIN:Bang('[!SetOption MeterHighButton ImageName "#@#Images\\Options\\PressedButton.png"][!SetOption MeterSourceButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterMediumButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterLowButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterMobileButton ImageName "#@#Images\\Options\\DepressedButton.png"]')
			SKIN:Bang('[!SetVariable Quality "High" "TwitchLiveFollowers\\Twitch"][!WriteKeyValue Variables Quality "High" "#@#Variables.inc"]')
			SKIN:Bang('[!SetOption MeterVLCIcon ToolTipTitle "Watch Using Livestreamer (Current Quality: High)" "TwitchLiveFollowers\\Twitch"]')
		elseif (currentOption == 'Medium') then
			SKIN:Bang('[!SetOption MeterMediumButton ImageName "#@#Images\\Options\\PressedButton.png"][!SetOption MeterSourceButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterHighButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterLowButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterMobileButton ImageName "#@#Images\\Options\\DepressedButton.png"]')
			SKIN:Bang('[!SetVariable Quality "Medium" "TwitchLiveFollowers\\Twitch"][!WriteKeyValue Variables Quality "Medium" "#@#Variables.inc"]')
			SKIN:Bang('[!SetOption MeterVLCIcon ToolTipTitle "Watch Using Livestreamer (Current Quality: Medium)" "TwitchLiveFollowers\\Twitch"]')
		elseif (currentOption == 'Low') then
			SKIN:Bang('[!SetOption MeterLowButton ImageName "#@#Images\\Options\\PressedButton.png"][!SetOption MeterSourceButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterHighButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterMediumButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterMobileButton ImageName "#@#Images\\Options\\DepressedButton.png"]')
			SKIN:Bang('[!SetVariable Quality "Low" "TwitchLiveFollowers\\Twitch"][!WriteKeyValue Variables Quality "Low" "#@#Variables.inc"]')
			SKIN:Bang('[!SetOption MeterVLCIcon ToolTipTitle "Watch Using Livestreamer (Current Quality: Low)" "TwitchLiveFollowers\\Twitch"]')
		elseif (currentOption == 'Mobile') then
			SKIN:Bang('[!SetOption MeterMobileButton ImageName "#@#Images\\Options\\PressedButton.png"][!SetOption MeterSourceButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterHighButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterMediumButton ImageName "#@#Images\\Options\\DepressedButton.png"][!SetOption MeterLowButton ImageName "#@#Images\\Options\\DepressedButton.png"]')
			SKIN:Bang('[!SetVariable Quality "Mobile" "TwitchLiveFollowers\\Twitch"][!WriteKeyValue Variables Quality "Mobile" "#@#Variables.inc"]')
			SKIN:Bang('[!SetOption MeterVLCIcon ToolTipTitle "Watch Using Livestreamer (Current Quality: Mobile)" "TwitchLiveFollowers\\Twitch"]')
		end
	SKIN:Bang('[!UpdateMeter * "TwitchLiveFollowers\\Twitch"]')
	SKIN:Bang('[!UpdateMeter *][!Redraw]')
	end
end

function detectLivestreamer()
	local MeasureOBJ = SKIN:GetMeasure('MeasureDetectLivestreamer')
	local PATH = ( MeasureOBJ:GetStringValue() )

	if ( string.find(PATH, "Livestreamer") or string.find(PATH, "livestreamer") ) then
		SKIN:Bang('!SetVariable', 'Livestreamer', '1')
	else
		SKIN:Bang('!SetVariable', 'Livestreamer', '0')
	end

	-- If Livestreamer is found, we display the Livestreamer group of options, else we hide them.
	SKIN:Bang('!SetOptionGroup', 'Livestreamer', 'DynamicVariables', '0')
	SKIN:Bang('[!UpdateMeterGroup Livestreamer][!Redraw]')
end

function validateKey(retry, change)
	local mainFeedOBJ = SKIN:GetMeasure("MeasureValidateToken")
	local rawJSON = mainFeedOBJ:GetStringValue()
	local tJSON = JSON:decode(rawJSON)

	if not tJSON then
		SKIN:Bang('!SetOption', 'MeterAccount', 'FontColor', 'E6E225')
		SKIN:Bang('!SetOption', 'MeterAccount', 'StringStyle', 'BoldItalic')
		SKIN:Bang('!SetOption', 'MeterAccount', 'Text', '(ERROR: Twitch API is currently down)')
	else

		if not tJSON.token.valid then

			if not change then
				SKIN:Bang('!SetOption', 'MeterAccount', 'FontColor', 'E6E225')
				SKIN:Bang('!SetOption', 'MeterAccount', 'StringStyle', 'BoldItalic')
				SKIN:Bang('!SetOption', 'MeterAccount', 'Text', '(ERROR: Invalid Access Token)')
				SKIN:Bang('!ShowMeterGroup', 'NewToken')
				SKIN:Bang('!HideMeter', 'MeterCopyKey')
			end

			if retry then
				SKIN:Bang('!SetOption', 'MeterInputLabel', 'Text', 'Invalid Key. Please try again')
				SKIN:Bang('!SetOption', 'MeterInputLabel', 'FontColor', '128,0,0')
			end
			SKIN:Bang('[!UpdateMeter *][!Redraw]')
		else
			local AccessToken = SKIN:GetVariable('OAuth_Token')

			if retry then
				SKIN:Bang('!WriteKeyValue', 'Variables', 'OAuth_Token', AccessToken, '#@#SharedVars.inc')

				SKIN:Bang('[!Refresh TwitchLiveFollowers\\Twitch]')
				SKIN:Bang('[!Refresh]')
				return
			end

			SKIN:Bang('!ShowMeter', 'MeterAccountChange')

			SKIN:Bang('!SetOption', 'MeterAccount', 'Text', tJSON.token.user_name)
			SKIN:Bang('[!UpdateMeter *][!Redraw]')
		end
	end
	SKIN:Bang('[!DisableMeasure MeasureValidateToken]')
	SKIN:Bang('[!UpdateMeter MeterAccount][!Redraw]')
end

function changeAccount()
	SKIN:Bang('[!ShowMeterGroup ChangeAccount]')
	SKIN:Bang('!SetOption', 'MeterInputLabel', 'LeftMouseUpAction', '[!CommandMeasure "MeasureInputAccessToken" "ExecuteBatch 4-6"]')

	SKIN:Bang('[!UpdateMeter *][!Redraw]')
end

function checkVersion()
	local mainFeedOBJ = SKIN:GetMeasure("MeasureCheckVersion")
	local rawJSON = mainFeedOBJ:GetStringValue()
	local tJSON = JSON:decode(rawJSON)
	local currentVersion = tonumber(SKIN:GetVariable('currentVersion'))

	if (currentVersion < tJSON.latestVersion) then
		SKIN:Bang('!SetOption', 'MeterVersionCheck', 'FontColor', '0,0,255')
		SKIN:Bang('!SetOption', 'MeterVersionCheck', 'StringStyle', 'Bold')
		SKIN:Bang('!SetOption', 'MeterVersionCheck', 'LeftMouseUpAction', '["http://wallboy.ca/rainmeter/installation/"]')
		SKIN:Bang('!SetOption', 'MeterVersionCheck', 'Text', '(Update Available!)')
	else
		SKIN:Bang('!SetOption', 'MeterVersionCheck', 'FontColor', '255,255,255')
		SKIN:Bang('!SetOption', 'MeterVersionCheck', 'LeftMouseUpAction', '')
		SKIN:Bang('!SetOption', 'MeterVersionCheck', 'Text', '(No Updates Found)')
	end
	SKIN:Bang('[!DisableMeasure MeasureCheckVersion]')
	SKIN:Bang('[!UpdateMeter MeterVersionCheck][!Redraw]')
end

function checkSupport()
	local mainFeedOBJ = SKIN:GetMeasure("MeasureCheckSupport")
	local rawJSON = mainFeedOBJ:GetStringValue()
	local tJSON = JSON:decode(rawJSON)

	if tJSON.isOnline then
		SKIN:Bang('!SetOption', 'MeterOnlineSupport', 'Hidden', '0')
	end
	SKIN:Bang('[!DisableMeasure MeasureCheckSupport]')
	SKIN:Bang('[!UpdateMeter MeterOnlineSupport][!Redraw]')
end

function helpHover(index)
	SKIN:Bang('[!SetOption MeterHelpText Hidden 1]')
	SKIN:Bang('[!SetOption MeterHelpSectionTitle Text """'..tHelpTable[index].Title..'"""]')
	SKIN:Bang('[!SetOption MeterHelpSectionDesc Text """'..tHelpTable[index].Desc..'"""]')
	if ( tHelpTable[index].Img1 ~= nil ) then
		SKIN:Bang('[!SetOption MeterHelpSectionImg1 ImageName "'..tHelpTable[index].Img1.ImageName..'"][!SetOption MeterHelpSectionImg1 X '..tHelpTable[index].Img1.X..'][!SetOption MeterHelpSectionImg1 Y '..tHelpTable[index].Img1.Y..']')
		SKIN:Bang('[!SetOption MeterHelpSectionImg1 Hidden 0]')
		if ( tHelpTable[index].Img2 ~= nil ) then
			SKIN:Bang('[!SetOption MeterHelpSectionImg2 ImageName "'..tHelpTable[index].Img2.ImageName..'"][!SetOption MeterHelpSectionImg2 X '..tHelpTable[index].Img2.X..'][!SetOption MeterHelpSectionImg2 Y '..tHelpTable[index].Img2.Y..']')
			SKIN:Bang('[!SetOption MeterHelpSectionImg2 Hidden 0]')
		end
	end

	SKIN:Bang('[!ShowMeterGroup HelpText]')
	SKIN:Bang('[!UpdateMeter *][!Redraw]')
end

function helpTable()
	tHelpTable = {}

	tHelpTable.ViewersDisplay = 	{
									Title  	= "Viewers Display Format",
									Desc   	= "Display the full viewer count or a compact thousands version.",
									Img1   	= {ImageName = "#@#Images\\Options\\ViewersFull.png", X = "150", Y = "15r"},
									Img2   	= {ImageName = "#@#Images\\Options\\ViewersCompact.png", X = "10R", Y = "0r"}
									}

	tHelpTable.Thumbnails = 		{
									Title	= "Thumbnails",
									Desc	= "Enables or disables the downloading and displaying of thumbnails beside the channel name."
									}

	tHelpTable.OnlineNotifications ={
									Title	= "Online Notifications",
									Desc 	= "Enables or disables the notification in the top bar when a new channel comes online."
									}

	tHelpTable.ColorHelp = 			{
									Title 	= "Color 1 and Color 2",
									Desc	= "Some of the color options allow a color gradient between Color 1 and Color 2. If you would like a single solid color for the entire bar, choose the same color for both.",
									Img1	= {ImageName = "#@#Images\\Options\\ColorHelp.png", X = "105", Y = "40r"}
									}

	tHelpTable.TopBar = 			{
									Title	= "Top Bar",
									Desc	= "Change the colors for the Top Bar of the skin.",
									Img1   	= {ImageName = "#@#Images\\Options\\TopBar.png", X = "120", Y = "22r"}
									}

	tHelpTable.SubtitleBar = 		{
									Title	= "Subtitle Bar",
									Desc	= "Change the color for the Subtitle Bar of the skin.",
									Img1   	= {ImageName = "#@#Images\\Options\\SubtitleBar.png", X = "120", Y = "27r"}
									}

	tHelpTable.ChannelBar = 		{
									Title	= "Channel Bar",
									Desc	= "Channel Bar is the first bar of the two channel bars that alternate between each other.",
									Img1   	= {ImageName = "#@#Images\\Options\\ChanBar.png", X = "140", Y = "27r"}
									}

	tHelpTable.ChannelBarAlt = 		{
									Title	= "Channel Bar Alternate",
									Desc	= "Channel Bar Alt is the second bar of the two channel bars that alternate between each other.",
									Img1   	= {ImageName = "#@#Images\\Options\\ChanBar.png", X = "140", Y = "27r"}
									}

	tHelpTable.ChannelBarHover = 	{
									Title	= "Channel Bar Hover",
									Desc 	= "Channel Bar Hover is the color of the channel bar when hovering your mouse cursor over it.",
									Img1   	= {ImageName = "#@#Images\\Options\\ChanBarHover.png", X = "105", Y = "30r"}
									}

	tHelpTable.Border	= 			{
									Title	= "Border",
									Desc	= "Border is the color of the outside border around the entire skin.",
									Img1	= {ImageName = "#@#Images\\Options\\SkinBorder.png", X = "90", Y = "10r"}
									}

	tHelpTable.ProfileBorder = 		{
									Title	= "Profile Logo Border",
									Desc	= "Sets the color tint of the semi-transparent border around the profile logo of the stream in the top bar when hovering over a channel.",
									Img1	= {ImageName = "#@#Images\\Options\\LogoBorder.png", X = "105", Y = "27r"}
									}

	tHelpTable.OnlineBorder = 		{
									Title	= "Online Notification Border",
									Desc	= "Sets the color tint of the semi-transparent border around the profile logo of the stream when a channel comes online.",
									Img1	= {ImageName = "#@#Images\\Options\\OnlineBorder.png", X = "105", Y = "27r"}
									}

	tHelpTable.NumOnline = 			{
									Title	= "Following Online",
									Desc	= "Sets the color of the number of live channels you are following in the top left of the skin.",
									Img1	= {ImageName = "#@#Images\\Options\\FollowersOnline.png", X = "105", Y = "27r"}
									}

	tHelpTable.Online = 			{
									Title	= "Online Text",
									Desc 	= "Sets the color of the \"Online\" text at the top of the skin.",
									Img1	= {ImageName = "#@#Images\\Options\\OnlineText.png", X = "105", Y = "27r"}
									}

	tHelpTable.Reset = 				{
									Title	= "Reset All Colors",
									Desc	= "Resets the color theme to the default.#CRLF##CRLF#IMPORTANT: You will lose any current custom color settings you have!"
									}

	tHelpTable.SubtitleText = 		{
									Title	= "Subtitle Text",
									Desc	= "Sets the color of the \"Channel\" and \"Viewers\" text on the Subtitle Bar.",
									Img1	= {ImageName = "#@#Images\\Options\\SubtitleText.png", X = "120", Y = "27r"}
									}

	tHelpTable.StreamName = 		{
									Title	= "Stream Name Text",
									Desc	= "Sets the color for the stream name text.",
									Img1	= {ImageName = "#@#Images\\Options\\StreamName.png", X = "120", Y = "27r"}
									}

	tHelpTable.ViewersText = 		{
									Title	= "Viewers Text",
									Desc	= "Sets the color for the viewers text.",
									Img1	= {ImageName = "#@#Images\\Options\\Viewers.png", X = "120", Y = "27r"}
									}

	tHelpTable.PlayingText = 		{
									Title	= "\"Playing\" Text",
									Desc	= "Sets the color of the \"Playing\" text in the top bar when hovering over a channel.",
									Img1	= {ImageName = "#@#Images\\Options\\PlayingText.png", X = "105", Y = "27r"}
									}

	tHelpTable.NotifName = 			{
									Title	= "Notification Stream Name",
									Desc	= "Sets the color of the stream name in the online notification area when a new channel comes online.",
									Img1	= {ImageName = "#@#Images\\Options\\NotifName.png", X = "105", Y = "27r"}
									}

	tHelpTable.GameName = 			{
									Title	= "Game Name",
									Desc	= "Sets the color of the game name in the notification area when hovering your mouse over a channel.",
									Img1	= {ImageName = "#@#Images\\Options\\GameName.png", X = "105", Y = "27r"}
									}

	tHelpTable.ComeOnline = 		{
									Title	= "\"has come online\" Text",
									Desc	= "Sets the color of the \"has come online\" text that appears when a new channel comes online.",
									Img1	= {ImageName = "#@#Images\\Options\\ComeOnlineText.png", X = "105", Y = "27r"}
									}

	tHelpTable.Quality = 			{
									Title	= "Livestreamer Quality",
									Desc	= "Sets the quality livestreamer opens the stream at in your external player.#CRLF##CRLF#NOTE: Some channels don't have all transcoding options. You may need to choose Source if a channel does not open in your player."
									}

	tHelpTable.Account = 			{
									Title 	= "Your Account",
									Desc	= "This is your Twitch account that the skin currently is bound to. If you would like to use a different Twitch account, click (Change) for instructions on how to do so."
									}

	tHelpTable.AccessToken = 		{
									Title	= "Access Token",
									Desc	= "Displays your current Access Token. Use this same token for any other computer you wish to install this skin on for the same Twitch account name."
									}
end

function colorTable()
	tColors = {}

	tColors.MeterTitleBarColor 			= {"MeterTopBar", "MeterTopCurve"}
	tColors.MeterTitleBarColor2 		= {"MeterTopBar"}
	tColors.MeterSubtitleBarColor		= {"MeterSubtitleBar"}
	tColors.MeterSubtitleBarColor2  	= {"MeterSubtitleBar"}
	tColors.MeterChannelBarColor		= {"MeterChanBar1", "MeterChanBar3", "MeterChanBar5", "MeterChanBar7", "MeterChanBar9", "MeterChanBar11", "MeterChanBar13", "MeterChanBar15", "MeterChanBar17", "MeterChanBar19", "MeterChanBar21", "MeterChanBar23", "MeterChanBar25", "MeterChanBar27", "MeterChanBar29"}
	tColors.MeterChannelBarColor2		= {"MeterChanBar1", "MeterChanBar3", "MeterChanBar5", "MeterChanBar7", "MeterChanBar9", "MeterChanBar11", "MeterChanBar13", "MeterChanBar15", "MeterChanBar17", "MeterChanBar19", "MeterChanBar21", "MeterChanBar23", "MeterChanBar25", "MeterChanBar27", "MeterChanBar29", "MeterBottomCurve"}
	tColors.MeterChannelAltBarColor		= {"MeterChanBar2", "MeterChanBar4", "MeterChanBar6", "MeterChanBar8", "MeterChanBar10", "MeterChanBar12", "MeterChanBar14", "MeterChanBar16", "MeterChanBar18", "MeterChanBar20", "MeterChanBar22", "MeterChanBar24", "MeterChanBar26", "MeterChanBar28", "MeterChanBar30"}
	tColors.MeterChannelAltBarColor2	= {"MeterChanBar2", "MeterChanBar4", "MeterChanBar6", "MeterChanBar8", "MeterChanBar10", "MeterChanBar12", "MeterChanBar14", "MeterChanBar16", "MeterChanBar18", "MeterChanBar20", "MeterChanBar22", "MeterChanBar24", "MeterChanBar26", "MeterChanBar28", "MeterChanBar30", "MeterBottomCurve"}
	tColors.MeterChannelHoverBarColor	= {}
	tColors.MeterChannelHoverBarColor2	= {}
	tColors.MeterBorderColor			= {"MeterTopCurveBorder", "MeterSideBorder", "MeterBottomCurveBorder"}
	tColors.MeterProfileBorderColor		= {"MeterNotifBorder"}
	tColors.MeterOnlineBorderColor		= {"MeterNotifBorder"}
	tColors.MeterNumOnlineColor			= {"MeterNumOnline"}
	tColors.MeterOnlineColor			= {"MeterOnlineStr"}
	tColors.MeterSubtitleTextColor		= {"MeterChannelStr", "MeterViewersStr"}
	tColors.MeterStreamNameColor		= {"MeterStreamName1", "MeterStreamName2", "MeterStreamName3", "MeterStreamName4", "MeterStreamName5", "MeterStreamName6", "MeterStreamName7", "MeterStreamName8", "MeterStreamName9", "MeterStreamName10", "MeterStreamName11", "MeterStreamName12", "MeterStreamName13", "MeterStreamName14", "MeterStreamName15", "MeterStreamName16", "MeterStreamName17", "MeterStreamName18", "MeterStreamName19", "MeterStreamName20", "MeterStreamName21", "MeterStreamName22", "MeterStreamName23", "MeterStreamName24", "MeterStreamName25", "MeterStreamName26", "MeterStreamName27", "MeterStreamName28", "MeterStreamName29", "MeterStreamName30"}
	tColors.MeterViewersTextColor		= {"MeterViewers1", "MeterViewers2", "MeterViewers3", "MeterViewers4", "MeterViewers5", "MeterViewers6", "MeterViewers7", "MeterViewers8", "MeterViewers9", "MeterViewers10", "MeterViewers11", "MeterViewers12", "MeterViewers13", "MeterViewers14", "MeterViewers15", "MeterViewers16", "MeterViewers17", "MeterViewers18", "MeterViewers19", "MeterViewers20", "MeterViewers21", "MeterViewers22", "MeterViewers23", "MeterViewers24", "MeterViewers25", "MeterViewers26", "MeterViewers27", "MeterViewers28", "MeterViewers29", "MeterViewers30"}
	tColors.MeterPlayingTextColor		= {"MeterNotifName"}
	tColors.MeterNotifNameColor			= {"MeterNotifName"}
	tColors.MeterGameNameColor			= {"MeterNotifSubtitle"}
	tColors.MeterComeOnlineColor		= {"MeterNotifSubtitle"}

end

function JSONDecode()
---------------------------------------------------------------------------------------------------------------------------------------------
-- START OF JSON SCRIPT ---------------------
---------------------------------------------------------------------------------------------------------------------------------------------



-- -*- coding: utf-8 -*-
--
-- Simple JSON encoding and decoding in pure Lua.
--
-- Copyright 2010-2013 Jeffrey Friedl
-- http://regex.info/blog/
--
-- Latest version: http://regex.info/blog/lua/json
--
-- This code is released under a Creative Commons CC-BY "Attribution" License:
-- http://creativecommons.org/licenses/by/3.0/deed.en_US
--
-- It can be used for any purpose so long as the copyright notice and
-- web-page links above are maintained. Enjoy.
--
local VERSION = 20140418.11  -- version history at end of file
local OBJDEF = { VERSION = VERSION }


--
-- Simple JSON encoding and decoding in pure Lua.
-- http://www.json.org/
--
--
--   JSON = (loadfile "JSON.lua")() -- one-time load of the routines
--
--   local lua_value = JSON:decode(raw_json_text)
--
--   local raw_json_text    = JSON:encode(lua_table_or_value)
--   local pretty_json_text = JSON:encode_pretty(lua_table_or_value) -- "pretty printed" version for human readability
--
--
-- DECODING
--
--   JSON = (loadfile "JSON.lua")() -- one-time load of the routines
--
--   local lua_value = JSON:decode(raw_json_text)
--
--   If the JSON text is for an object or an array, e.g.
--     { "what": "books", "count": 3 }
--   or
--     [ "Larry", "Curly", "Moe" ]
--
--   the result is a Lua table, e.g.
--     { what = "books", count = 3 }
--   or
--     { "Larry", "Curly", "Moe" }
--
--
--   The encode and decode routines accept an optional second argument, "etc", which is not used
--   during encoding or decoding, but upon error is passed along to error handlers. It can be of any
--   type (including nil).
--
--   With most errors during decoding, this code calls
--
--      JSON:onDecodeError(message, text, location, etc)
--
--   with a message about the error, and if known, the JSON text being parsed and the byte count
--   where the problem was discovered. You can replace the default JSON:onDecodeError() with your
--   own function.
--
--   The default onDecodeError() merely augments the message with data about the text and the
--   location if known (and if a second 'etc' argument had been provided to decode(), its value is
--   tacked onto the message as well), and then calls JSON.assert(), which itself defaults to Lua's
--   built-in assert(), and can also be overridden.
--
--   For example, in an Adobe Lightroom plugin, you might use something like
--
--          function JSON:onDecodeError(message, text, location, etc)
--             LrErrors.throwUserError("Internal Error: invalid JSON data")
--          end
--
--   or even just
--
--          function JSON.assert(message)
--             LrErrors.throwUserError("Internal Error: " .. message)
--          end
--
--   If JSON:decode() is passed a nil, this is called instead:
--
--      JSON:onDecodeOfNilError(message, nil, nil, etc)
--
--   and if JSON:decode() is passed HTML instead of JSON, this is called:
--
--      JSON:onDecodeOfHTMLError(message, text, nil, etc)
--
--   The use of the fourth 'etc' argument allows stronger coordination between decoding and error
--   reporting, especially when you provide your own error-handling routines. Continuing with the
--   the Adobe Lightroom plugin example:
--
--          function JSON:onDecodeError(message, text, location, etc)
--             local note = "Internal Error: invalid JSON data"
--             if type(etc) = 'table' and etc.photo then
--                note = note .. " while processing for " .. etc.photo:getFormattedMetadata('fileName')
--             end
--             LrErrors.throwUserError(note)
--          end
--
--            :
--            :
--
--          for i, photo in ipairs(photosToProcess) do
--               :
--               :
--               local data = JSON:decode(someJsonText, { photo = photo })
--               :
--               :
--          end
--
--
--
--

-- DECODING AND STRICT TYPES
--
--   Because both JSON objects and JSON arrays are converted to Lua tables, it's not normally
--   possible to tell which a JSON type a particular Lua table was derived from, or guarantee
--   decode-encode round-trip equivalency.
--
--   However, if you enable strictTypes, e.g.
--
--      JSON = (loadfile "JSON.lua")() --load the routines
--      JSON.strictTypes = true
--
--   then the Lua table resulting from the decoding of a JSON object or JSON array is marked via Lua
--   metatable, so that when re-encoded with JSON:encode() it ends up as the appropriate JSON type.
--
--   (This is not the default because other routines may not work well with tables that have a
--   metatable set, for example, Lightroom API calls.)
--
--
-- ENCODING
--
--   JSON = (loadfile "JSON.lua")() -- one-time load of the routines
--
--   local raw_json_text    = JSON:encode(lua_table_or_value)
--   local pretty_json_text = JSON:encode_pretty(lua_table_or_value) -- "pretty printed" version for human readability

--   On error during encoding, this code calls:
--
--    JSON:onEncodeError(message, etc)
--
--   which you can override in your local JSON object.
--
--   If the Lua table contains both string and numeric keys, it fits neither JSON's
--   idea of an object, nor its idea of an array. To get around this, when any string
--   key exists (or when non-positive numeric keys exist), numeric keys are converted
--   to strings.
--
--   For example,
--     JSON:encode({ "one", "two", "three", SOMESTRING = "some string" }))
--   produces the JSON object
--     {"1":"one","2":"two","3":"three","SOMESTRING":"some string"}
--
--   To prohibit this conversion and instead make it an error condition, set
--      JSON.noKeyConversion = true


--
-- SUMMARY OF METHODS YOU CAN OVERRIDE IN YOUR LOCAL LUA JSON OBJECT
--
--    assert
--    onDecodeError
--    onDecodeOfNilError
--    onDecodeOfHTMLError
--    onEncodeError
--
--  If you want to create a separate Lua JSON object with its own error handlers,
--  you can reload JSON.lua or use the :new() method.
--
---------------------------------------------------------------------------


local author = "-[ JSON.lua package by Jeffrey Friedl (http://regex.info/blog/lua/json), version " .. tostring(VERSION) .. " ]-"
local isArray  = { __tostring = function() return "JSON array"  end }    isArray.__index  = isArray
local isObject = { __tostring = function() return "JSON object" end }    isObject.__index = isObject


function OBJDEF:newArray(tbl)
   return setmetatable(tbl or {}, isArray)
end

function OBJDEF:newObject(tbl)
   return setmetatable(tbl or {}, isObject)
end

local function unicode_codepoint_as_utf8(codepoint)
   --
   -- codepoint is a number
   --
   if codepoint <= 127 then
      return string.char(codepoint)

   elseif codepoint <= 2047 then
      --
      -- 110yyyxx 10xxxxxx         <-- useful notation from http://en.wikipedia.org/wiki/Utf8
      --
      local highpart = math.floor(codepoint / 0x40)
      local lowpart  = codepoint - (0x40 * highpart)
      return string.char(0xC0 + highpart,
                         0x80 + lowpart)

   elseif codepoint <= 65535 then
      --
      -- 1110yyyy 10yyyyxx 10xxxxxx
      --
      local highpart  = math.floor(codepoint / 0x1000)
      local remainder = codepoint - 0x1000 * highpart
      local midpart   = math.floor(remainder / 0x40)
      local lowpart   = remainder - 0x40 * midpart

      highpart = 0xE0 + highpart
      midpart  = 0x80 + midpart
      lowpart  = 0x80 + lowpart

      --
      -- Check for an invalid character (thanks Andy R. at Adobe).
      -- See table 3.7, page 93, in http://www.unicode.org/versions/Unicode5.2.0/ch03.pdf#G28070
      --
      if ( highpart == 0xE0 and midpart < 0xA0 ) or
         ( highpart == 0xED and midpart > 0x9F ) or
         ( highpart == 0xF0 and midpart < 0x90 ) or
         ( highpart == 0xF4 and midpart > 0x8F )
      then
         return "?"
      else
         return string.char(highpart,
                            midpart,
                            lowpart)
      end

   else
      --
      -- 11110zzz 10zzyyyy 10yyyyxx 10xxxxxx
      --
      local highpart  = math.floor(codepoint / 0x40000)
      local remainder = codepoint - 0x40000 * highpart
      local midA      = math.floor(remainder / 0x1000)
      remainder       = remainder - 0x1000 * midA
      local midB      = math.floor(remainder / 0x40)
      local lowpart   = remainder - 0x40 * midB

      return string.char(0xF0 + highpart,
                         0x80 + midA,
                         0x80 + midB,
                         0x80 + lowpart)
   end
end

function OBJDEF:onDecodeError(message, text, location, etc)
   if text then
      if location then
         message = string.format("%s at char %d of: %s", message, location, text)
      else
         message = string.format("%s: %s", message, text)
      end
   end

   if etc ~= nil then
      message = message .. " (" .. OBJDEF:encode(etc) .. ")"
   end

   if self.assert then
      self.assert(false, message)
   else
      assert(false, message)
   end
end

OBJDEF.onDecodeOfNilError  = OBJDEF.onDecodeError
OBJDEF.onDecodeOfHTMLError = OBJDEF.onDecodeError

function OBJDEF:onEncodeError(message, etc)
   if etc ~= nil then
      message = message .. " (" .. OBJDEF:encode(etc) .. ")"
   end

   if self.assert then
      self.assert(false, message)
   else
      assert(false, message)
   end
end

local function grok_number(self, text, start, etc)
   --
   -- Grab the integer part
   --
   local integer_part = text:match('^-?[1-9]%d*', start)
                     or text:match("^-?0",        start)

   if not integer_part then
      self:onDecodeError("expected number", text, start, etc)
   end

   local i = start + integer_part:len()

   --
   -- Grab an optional decimal part
   --
   local decimal_part = text:match('^%.%d+', i) or ""

   i = i + decimal_part:len()

   --
   -- Grab an optional exponential part
   --
   local exponent_part = text:match('^[eE][-+]?%d+', i) or ""

   i = i + exponent_part:len()

   local full_number_text = integer_part .. decimal_part .. exponent_part
   local as_number = tonumber(full_number_text)

   if not as_number then
      self:onDecodeError("bad number", text, start, etc)
   end

   return as_number, i
end


local function grok_string(self, text, start, etc)

   if text:sub(start,start) ~= '"' then
      self:onDecodeError("expected string's opening quote", text, start, etc)
   end

   local i = start + 1 -- +1 to bypass the initial quote
   local text_len = text:len()
   local VALUE = ""
   while i <= text_len do
      local c = text:sub(i,i)
      if c == '"' then
         return VALUE, i + 1
      end
      if c ~= '\\' then
         VALUE = VALUE .. c
         i = i + 1
      elseif text:match('^\\b', i) then
         VALUE = VALUE .. "\b"
         i = i + 2
      elseif text:match('^\\f', i) then
         VALUE = VALUE .. "\f"
         i = i + 2
      elseif text:match('^\\n', i) then
         VALUE = VALUE .. "\n"
         i = i + 2
      elseif text:match('^\\r', i) then
         VALUE = VALUE .. "\r"
         i = i + 2
      elseif text:match('^\\t', i) then
         VALUE = VALUE .. "\t"
         i = i + 2
      else
         local hex = text:match('^\\u([0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF])', i)
         if hex then
            i = i + 6 -- bypass what we just read

            -- We have a Unicode codepoint. It could be standalone, or if in the proper range and
            -- followed by another in a specific range, it'll be a two-code surrogate pair.
            local codepoint = tonumber(hex, 16)
            if codepoint >= 0xD800 and codepoint <= 0xDBFF then
               -- it's a hi surrogate... see whether we have a following low
               local lo_surrogate = text:match('^\\u([dD][cdefCDEF][0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF])', i)
               if lo_surrogate then
                  i = i + 6 -- bypass the low surrogate we just read
                  codepoint = 0x2400 + (codepoint - 0xD800) * 0x400 + tonumber(lo_surrogate, 16)
               else
                  -- not a proper low, so we'll just leave the first codepoint as is and spit it out.
               end
            end
            VALUE = VALUE .. unicode_codepoint_as_utf8(codepoint)

         else

            -- just pass through what's escaped
            VALUE = VALUE .. text:match('^\\(.)', i)
            i = i + 2
         end
      end
   end

   self:onDecodeError("unclosed string", text, start, etc)
end

local function skip_whitespace(text, start)

   local match_start, match_end = text:find("^[ \n\r\t]+", start) -- [http://www.ietf.org/rfc/rfc4627.txt] Section 2
   if match_end then
      return match_end + 1
   else
      return start
   end
end

local grok_one -- assigned later

local function grok_object(self, text, start, etc)
   if not text:sub(start,start) == '{' then
      self:onDecodeError("expected '{'", text, start, etc)
   end

   local i = skip_whitespace(text, start + 1) -- +1 to skip the '{'

   local VALUE = self.strictTypes and self:newObject { } or { }

   if text:sub(i,i) == '}' then
      return VALUE, i + 1
   end
   local text_len = text:len()
   while i <= text_len do
      local key, new_i = grok_string(self, text, i, etc)

      i = skip_whitespace(text, new_i)

      if text:sub(i, i) ~= ':' then
         self:onDecodeError("expected colon", text, i, etc)
      end

      i = skip_whitespace(text, i + 1)

      local val, new_i = grok_one(self, text, i)

      VALUE[key] = val

      --
      -- Expect now either '}' to end things, or a ',' to allow us to continue.
      --
      i = skip_whitespace(text, new_i)

      local c = text:sub(i,i)

      if c == '}' then
         return VALUE, i + 1
      end

      if text:sub(i, i) ~= ',' then
         self:onDecodeError("expected comma or '}'", text, i, etc)
      end

      i = skip_whitespace(text, i + 1)
   end

   self:onDecodeError("unclosed '{'", text, start, etc)
end

local function grok_array(self, text, start, etc)
   if not text:sub(start,start) == '[' then
      self:onDecodeError("expected '['", text, start, etc)
   end

   local i = skip_whitespace(text, start + 1) -- +1 to skip the '['
   local VALUE = self.strictTypes and self:newArray { } or { }
   if text:sub(i,i) == ']' then
      return VALUE, i + 1
   end

   local VALUE_INDEX = 1

   local text_len = text:len()
   while i <= text_len do
      local val, new_i = grok_one(self, text, i)

      -- can't table.insert(VALUE, val) here because it's a no-op if val is nil
      VALUE[VALUE_INDEX] = val
      VALUE_INDEX = VALUE_INDEX + 1

      i = skip_whitespace(text, new_i)

      --
      -- Expect now either ']' to end things, or a ',' to allow us to continue.
      --
      local c = text:sub(i,i)
      if c == ']' then
         return VALUE, i + 1
      end
      if text:sub(i, i) ~= ',' then
         self:onDecodeError("expected comma or '['", text, i, etc)
      end
      i = skip_whitespace(text, i + 1)
   end
   self:onDecodeError("unclosed '['", text, start, etc)
end


grok_one = function(self, text, start, etc)
   -- Skip any whitespace
   start = skip_whitespace(text, start)

   if start > text:len() then
      self:onDecodeError("unexpected end of string", text, nil, etc)
   end

   if text:find('^"', start) then
      return grok_string(self, text, start, etc)

   elseif text:find('^[-0123456789 ]', start) then
      return grok_number(self, text, start, etc)

   elseif text:find('^%{', start) then
      return grok_object(self, text, start, etc)

   elseif text:find('^%[', start) then
      return grok_array(self, text, start, etc)

   elseif text:find('^true', start) then
      return true, start + 4

   elseif text:find('^false', start) then
      return false, start + 5

   elseif text:find('^null', start) then
      return nil, start + 4

   else
      self:onDecodeError("can't parse JSON", text, start, etc)
   end
end

function OBJDEF:decode(text, etc)
   if type(self) ~= 'table' or self.__index ~= OBJDEF then
      OBJDEF:onDecodeError("JSON:decode must be called in method format", nil, nil, etc)
   end

   if text == nil then
      self:onDecodeOfNilError(string.format("nil passed to JSON:decode()"), nil, nil, etc)
   elseif type(text) ~= 'string' then
      self:onDecodeError(string.format("expected string argument to JSON:decode(), got %s", type(text)), nil, nil, etc)
   end

   if text:match('^%s*$') then
      return nil
   end

   if text:match('^%s*<') then
      -- Can't be JSON... we'll assume it's HTML
      self:onDecodeOfHTMLError(string.format("html passed to JSON:decode()"), text, nil, etc)
   end

   --
   -- Ensure that it's not UTF-32 or UTF-16.
   -- Those are perfectly valid encodings for JSON (as per RFC 4627 section 3),
   -- but this package can't handle them.
   --
   if text:sub(1,1):byte() == 0 or (text:len() >= 2 and text:sub(2,2):byte() == 0) then
      self:onDecodeError("JSON package groks only UTF-8, sorry", text, nil, etc)
   end

   local success, value = pcall(grok_one, self, text, 1, etc)

   if success then
      return value
   else
      -- if JSON:onDecodeError() didn't abort out of the pcall, we'll have received the error message here as "value", so pass it along as an assert.
      if self.assert then
         self.assert(false, value)
      else
         assert(false, value)
      end
      -- and if we're still here, return a nil and throw the error message on as a second arg
      return nil, value
   end
end

local function backslash_replacement_function(c)
   if c == "\n" then
      return "\\n"
   elseif c == "\r" then
      return "\\r"
   elseif c == "\t" then
      return "\\t"
   elseif c == "\b" then
      return "\\b"
   elseif c == "\f" then
      return "\\f"
   elseif c == '"' then
      return '\\"'
   elseif c == '\\' then
      return '\\\\'
   else
      return string.format("\\u%04x", c:byte())
   end
end

local chars_to_be_escaped_in_JSON_string
   = '['
   ..    '"'    -- class sub-pattern to match a double quote
   ..    '%\\'  -- class sub-pattern to match a backslash
   ..    '%z'   -- class sub-pattern to match a null
   ..    '\001' .. '-' .. '\031' -- class sub-pattern to match control characters
   .. ']'

local function json_string_literal(value)
   local newval = value:gsub(chars_to_be_escaped_in_JSON_string, backslash_replacement_function)
   return '"' .. newval .. '"'
end

local function object_or_array(self, T, etc)
   --
   -- We need to inspect all the keys... if there are any strings, we'll convert to a JSON
   -- object. If there are only numbers, it's a JSON array.
   --
   -- If we'll be converting to a JSON object, we'll want to sort the keys so that the
   -- end result is deterministic.
   --
   local string_keys = { }
   local number_keys = { }
   local number_keys_must_be_strings = false
   local maximum_number_key

   for key in pairs(T) do
      if type(key) == 'string' then
         table.insert(string_keys, key)
      elseif type(key) == 'number' then
         table.insert(number_keys, key)
         if key <= 0 or key >= math.huge then
            number_keys_must_be_strings = true
         elseif not maximum_number_key or key > maximum_number_key then
            maximum_number_key = key
         end
      else
         self:onEncodeError("can't encode table with a key of type " .. type(key), etc)
      end
   end

   if #string_keys == 0 and not number_keys_must_be_strings then
      --
      -- An empty table, or a numeric-only array
      --
      if #number_keys > 0 then
         return nil, maximum_number_key -- an array
      elseif tostring(T) == "JSON array" then
         return nil
      elseif tostring(T) == "JSON object" then
         return { }
      else
         -- have to guess, so we'll pick array, since empty arrays are likely more common than empty objects
         return nil
      end
   end

   table.sort(string_keys)

   local map
   if #number_keys > 0 then
      --
      -- If we're here then we have either mixed string/number keys, or numbers inappropriate for a JSON array
      -- It's not ideal, but we'll turn the numbers into strings so that we can at least create a JSON object.
      --

      if JSON.noKeyConversion then
         self:onEncodeError("a table with both numeric and string keys could be an object or array; aborting", etc)
      end

      --
      -- Have to make a shallow copy of the source table so we can remap the numeric keys to be strings
      --
      map = { }
      for key, val in pairs(T) do
         map[key] = val
      end

      table.sort(number_keys)

      --
      -- Throw numeric keys in there as strings
      --
      for _, number_key in ipairs(number_keys) do
         local string_key = tostring(number_key)
         if map[string_key] == nil then
            table.insert(string_keys , string_key)
            map[string_key] = T[number_key]
         else
            self:onEncodeError("conflict converting table with mixed-type keys into a JSON object: key " .. number_key .. " exists both as a string and a number.", etc)
         end
      end
   end

   return string_keys, nil, map
end

--
-- Encode
--
local encode_value -- must predeclare because it calls itself
function encode_value(self, value, parents, etc, indent) -- non-nil indent means pretty-printing

   if value == nil then
      return 'null'

   elseif type(value) == 'string' then
      return json_string_literal(value)

   elseif type(value) == 'number' then
      if value ~= value then
         --
         -- NaN (Not a Number).
         -- JSON has no NaN, so we have to fudge the best we can. This should really be a package option.
         --
         return "null"
      elseif value >= math.huge then
         --
         -- Positive infinity. JSON has no INF, so we have to fudge the best we can. This should
         -- really be a package option. Note: at least with some implementations, positive infinity
         -- is both ">= math.huge" and "<= -math.huge", which makes no sense but that's how it is.
         -- Negative infinity is properly "<= -math.huge". So, we must be sure to check the ">="
         -- case first.
         --
         return "1e+9999"
      elseif value <= -math.huge then
         --
         -- Negative infinity.
         -- JSON has no INF, so we have to fudge the best we can. This should really be a package option.
         --
         return "-1e+9999"
      else
         return tostring(value)
      end

   elseif type(value) == 'boolean' then
      return tostring(value)

   elseif type(value) ~= 'table' then
      self:onEncodeError("can't convert " .. type(value) .. " to JSON", etc)

   else
      --
      -- A table to be converted to either a JSON object or array.
      --
      local T = value

      if parents[T] then
         self:onEncodeError("table " .. tostring(T) .. " is a child of itself", etc)
      else
         parents[T] = true
      end

      local result_value

      local object_keys, maximum_number_key, map = object_or_array(self, T, etc)
      if maximum_number_key then
         --
         -- An array...
         --
         local ITEMS = { }
         for i = 1, maximum_number_key do
            table.insert(ITEMS, encode_value(self, T[i], parents, etc, indent))
         end

         if indent then
            result_value = "[ " .. table.concat(ITEMS, ", ") .. " ]"
         else
            result_value = "[" .. table.concat(ITEMS, ",") .. "]"
         end

      elseif object_keys then
         --
         -- An object
         --
         local TT = map or T

         if indent then

            local KEYS = { }
            local max_key_length = 0
            for _, key in ipairs(object_keys) do
               local encoded = encode_value(self, tostring(key), parents, etc, "")
               max_key_length = math.max(max_key_length, #encoded)
               table.insert(KEYS, encoded)
            end
            local key_indent = indent .. "    "
            local subtable_indent = indent .. string.rep(" ", max_key_length + 2 + 4)
            local FORMAT = "%s%" .. string.format("%d", max_key_length) .. "s: %s"

            local COMBINED_PARTS = { }
            for i, key in ipairs(object_keys) do
               local encoded_val = encode_value(self, TT[key], parents, etc, subtable_indent)
               table.insert(COMBINED_PARTS, string.format(FORMAT, key_indent, KEYS[i], encoded_val))
            end
            result_value = "{\n" .. table.concat(COMBINED_PARTS, ",\n") .. "\n" .. indent .. "}"

         else

            local PARTS = { }
            for _, key in ipairs(object_keys) do
               local encoded_val = encode_value(self, TT[key],       parents, etc, indent)
               local encoded_key = encode_value(self, tostring(key), parents, etc, indent)
               table.insert(PARTS, string.format("%s:%s", encoded_key, encoded_val))
            end
            result_value = "{" .. table.concat(PARTS, ",") .. "}"

         end
      else
         --
         -- An empty array/object... we'll treat it as an array, though it should really be an option
         --
         result_value = "[]"
      end

      parents[T] = false
      return result_value
   end
end


function OBJDEF:encode(value, etc)
   if type(self) ~= 'table' or self.__index ~= OBJDEF then
      OBJDEF:onEncodeError("JSON:encode must be called in method format", etc)
   end
   return encode_value(self, value, {}, etc, nil)
end

function OBJDEF:encode_pretty(value, etc)
   if type(self) ~= 'table' or self.__index ~= OBJDEF then
      OBJDEF:onEncodeError("JSON:encode_pretty must be called in method format", etc)
   end
   return encode_value(self, value, {}, etc, "")
end

function OBJDEF.__tostring()
   return "JSON encode/decode package"
end

OBJDEF.__index = OBJDEF

function OBJDEF:new(args)
   local new = { }

   if args then
      for key, val in pairs(args) do
         new[key] = val
      end
   end

   return setmetatable(new, OBJDEF)
end

return OBJDEF:new()
end
