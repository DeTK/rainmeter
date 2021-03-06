function Initialize()
	tCurrentStreams = {}
	isFirstLoad = true
	skipNotif = false
	isNotifying = false
	gTotalOnline = 0
	TokenErrorCnt = 0
	DataErrorCnt = 0
	path = SKIN:GetVariable('CURRENTPATH')
	resourcePath = SKIN:GetVariable('@')
	getState()

	JSON = JSONDecode()
	-- Handle my own errors with the JSON module, so just return
	function JSON:assert(message, text, location, etc)
		return
	end
end

function getState()
	-- SortArrow
	local sortType = SKIN:GetVariable('sortType', 'ViewersDESC')
	if (sortType == "ViewersDESC") then
		SKIN:Bang('!SetOption', 'MeterSortArrow', 'X', '(#skinWidth# - 82)')
		SKIN:Bang('!SetOption', 'MeterSortArrow', 'ImageFlip', 'None')
	elseif (sortType == "ViewersASC") then
		SKIN:Bang('!SetOption', 'MeterSortArrow', 'ImageFlip', 'Vertical')
		SKIN:Bang('!SetOption', 'MeterSortArrow', 'X', '(#skinWidth# - 82)')
	elseif (sortType == "NameDESC") then
		SKIN:Bang('!SetOption', 'MeterSortArrow', 'X', '5R')
		SKIN:Bang('!SetOption', 'MeterSortArrow', 'ImageFlip', 'None')
	elseif (sortType == "NameASC") then
		SKIN:Bang('!SetOption', 'MeterSortArrow', 'X', '5R')
		SKIN:Bang('!SetOption', 'MeterSortArrow', 'ImageFlip', 'Vertical')
	end

	-- Collapsed/Expanded

	local Collapsed = tonumber( SKIN:GetVariable('Collapsed') )
	if (Collapsed == 0) then
		SKIN:Bang('!SetOption', 'MeterExpCol', 'ButtonImage', '#@#Images\\Twitch\\Collapse.png')
		SKIN:Bang('!SetOption', 'MeterExpCol', 'ToolTipTitle', 'Hide Live Channels')
		SKIN:Bang('!SetOption', 'MeterExpCol', 'ToolTipText', 'Collapse skin to hide all live channels (Online notifications will still appear)')
	else
		SKIN:Bang('!SetOption', 'MeterExpCol', 'ButtonImage', '#@#Images\\Twitch\\Expand.png')
		SKIN:Bang('!SetOption', 'MeterExpCol', 'ToolTipTitle', 'Show Live Channels')
		SKIN:Bang('!SetOption', 'MeterExpCol', 'ToolTipText', 'Expand skin to show all live channels')
	end

	-- VLC ToolTip Quality
	local quality = SKIN:GetVariable('Quality')
	if (quality == "Source") then
		SKIN:Bang('[!SetOption MeterVLCIcon ToolTipTitle "Watch Using Livestreamer (Current Quality: Source)"]')
	elseif (quality == "High") then
		SKIN:Bang('[!SetOption MeterVLCIcon ToolTipTitle "Watch Using Livestreamer (Current Quality: High)"]')
	elseif (quality == "Medium") then
		SKIN:Bang('[!SetOption MeterVLCIcon ToolTipTitle "Watch Using Livestreamer (Current Quality: Medium)"]')
	elseif (quality == "Low") then
		SKIN:Bang('[!SetOption MeterVLCIcon ToolTipTitle "Watch Using Livestreamer (Current Quality: Low)"]')
	elseif (quality == "Mobile") then
		SKIN:Bang('[!SetOption MeterVLCIcon ToolTipTitle "Watch Using Livestreamer (Current Quality: Mobile)"]')
	end

	SKIN:Bang('!UpdateMeter', '*')
	SKIN:Bang('!Redraw')
end

function detectLivestreamer()
	local MeasureOBJ = SKIN:GetMeasure('MeasureDetectLivestreamer')
	local PATH = ( MeasureOBJ:GetStringValue() )

	if ( string.find(PATH, "Livestreamer") or string.find(PATH, "livestreamer") ) then
		SKIN:Bang('!SetVariable', 'Livestreamer', '1')
	else
		SKIN:Bang('!SetVariable', 'Livestreamer', '0')
	end
	SKIN:Bang('[!DisableMeasure MeasureCheckForLivestreamer]')
end

function getError(errorType)
	if (errorType == 401) then
		SKIN:Bang('!SetOption', 'MeterErrorHelp', 'ToolTipTitle', 'Access Token Error')
		SKIN:Bang('!SetOption', 'MeterErrorHelp', 'LeftMouseUpAction', 'http://wallboy.ca/rainmeter/faq/#accesstoken')
		SKIN:Bang('!SetOption', 'MeterErrorDesc', 'Text', 'Access Token Error')
		SKIN:Bang('!SetOption', 'MeterErrorDesc', 'LeftMouseUpAction', 'http://wallboy.ca/rainmeter/faq/#accesstoken')
	elseif (errorType == 500) then
		SKIN:Bang('!SetOption', 'MeterErrorHelp', 'ToolTipTitle', 'Error Fetching Data')
		SKIN:Bang('!SetOption', 'MeterErrorHelp', 'LeftMouseUpAction', 'http://wallboy.ca/rainmeter/faq/#dataerror')
		SKIN:Bang('!SetOption', 'MeterErrorDesc', 'Text', 'Error Fetching Data')
		SKIN:Bang('!SetOption', 'MeterErrorDesc', 'LeftMouseUpAction', 'http://wallboy.ca/rainmeter/faq/#dataerror')
	end

	SKIN:Bang('!ShowMeterGroup', 'ErrorBar')
	SKIN:Bang('[!UpdateMeter *][!Redraw]')
end

function validateData(tJSON)
	-- Checks for access token and data errors when the skin is first refreshed/loaded
	if isFirstLoad then
		if not tJSON then
			getError(500)
			return false
		else
			if (tJSON.status == 401) then
				getError(401)
				return false
			else
				SKIN:Bang('!HideMeterGroup', 'ErrorBar')
			end
		end
	else
		-- If tJSON returns HTML such as a 503 or 502 error, we skip the error for up to 5 updates. If the error persists, we notify the user.
		if not tJSON then
			DataErrorCnt = DataErrorCnt + 1
			if (DataErrorCnt == 5) then
				gTotalOnline = 0
				isFirstLoad = true
				printTable()
				getError(500)
				return false
			end
			return false
		end
		-- Same as above, except this checks for "false positive" access token errors. Only after 5 failed updates do we notify the user.
		if (tJSON.status == 401) then
			TokenErrorCnt = TokenErrorCnt + 1
			if (TokenErrorCnt == 5) then
				gTotalOnline = 0
				isFirstLoad = true
				printTable()
				getError(401)
				return false
			end
			return false
		end
	end

	-- Quick "hack". Twitch API can drop to 0 online for a single update, creating a possible long list of online notif's next update, so we skip an update when this happens.
	if ( (tJSON._total == 0) and (gTotalOnline >= 1) ) then
		gTotalOnline = 0
		return false
	end

	-- If we made it to here, no errors
	TokenErrorCnt = 0
	DataErrorCnt = 0
	return true
end

function getProfileThumbs()
	while ( NotifIndex <= LogosToProcess ) do
		local profileThumbKey

		if (tNewStream[NotifIndex].LogoURL ~= nil) then
			profileThumbKey = string.match(tNewStream[NotifIndex].LogoURL, 'image%-(.+)-')
		else
			profileThumbKey = "NoProfileImage"
		end

		if ( profileThumbKeys(tNewStream[NotifIndex].name, profileThumbKey) ) then
			return
		end
	end
	fadeNotif(1)
end

function downloadLogo()

	if not tNewStream[NotifIndex].LogoURL then
		SKIN:Bang('!SetOption', 'MeasureProfThumb', 'URL', 'http://static-cdn.jtvnw.net/jtv_user_pictures/xarth/404_user_150x150.png')
	else
		SKIN:Bang('!SetOption', 'MeasureProfThumb', 'URL', tNewStream[NotifIndex].LogoURL)
	end
	SKIN:Bang('!Setoption', 'MeasureProfThumb', 'DownloadFile', 'ProfileThumbs\\'..tNewStream[NotifIndex].name..'.png')

	if (NotifIndex == LogosToProcess) then
		SKIN:Bang('!SetOption', 'MeasureResize', 'FinishAction', '[!CommandMeasure MeasureLUA "fadeNotif(1)"]')
	end

	SKIN:Bang('!SetOption', 'MeasureResize', 'Parameter', '-overwrite -quiet -out png -resize 40 40 "'..path..'DownloadFile\\ProfileThumbs\\'..tNewStream[NotifIndex].name..'.png"')

	NotifIndex = NotifIndex + 1

	SKIN:Bang('[!UpdateMeasure MeasureResize]')

	SKIN:Bang('[!EnableMeasure MeasureProfThumb]')
	SKIN:Bang('[!CommandMeasure MeasureProfThumb Update]')
	SKIN:Bang('[!UpdateMeasure MeasureProfThumb]')
end

function profileThumbKeys(streamName, profileKey)
	local hFile = io.open(resourcePath..'profileKeys.txt', 'r')
	if (hFile == nil) then
		hFile = io.open(resourcePath..'profileKeys.txt', 'w')
		hFile:close()
		hFile = assert(io.open(resourcePath..'profileKeys.txt', 'r'), 'Unable to open profileKeys.txt')
	end

	local lines = {}
	local restOfFile = ""
	local foundLine = false
	local needDownload = false
	local needWrite = false

	local f = io.open(path..'DownloadFile\\ProfileThumbs\\'..tNewStream[NotifIndex].name..'.png', "r")
	if (f == nil) then
		needDownload = true
	else
		io.close(f)
	end

	for line in hFile:lines() do
		local lineStreamName, lineProfileKey = line:match('^([^=]+)=(.+)')
		if(streamName == lineStreamName) then
			foundLine = true
			if (profileKey ~= lineProfileKey) then
				lines[#lines + 1] = streamName.."="..profileKey
				restOfFile = hFile:read("*a")
				needDownload = true
				needWrite = true
				break
			else
				lines[#lines + 1] = line
			end
		else
			lines[#lines + 1] = line
		end
	end

	hFile:close()

	if (foundLine == false) then
		lines[#lines + 1] = streamName.."="..profileKey
		needDownload = true
		needWrite = true
	end

	if needWrite then
		hFile = assert(io.open(resourcePath..'profileKeys.txt', 'w'), 'Unable to open profileKeys.txt')
		for i, line in ipairs(lines) do
		  hFile:write(line, "\n")
		end
		hFile:write(restOfFile)
		hFile:close()
	end

	if needDownload then
		downloadLogo()
		return true
	else
		NotifIndex = NotifIndex + 1
	end
end

function fadeNotif(setup)
	if ( tonumber(SKIN:GetVariable('Notifications')) == 0 or isFirstLoad ) then -- Don't show them on first skin load/refresh
		isFirstLoad = false
		return
	end

	if setup then
		SKIN:Bang('!SetOption', 'MeterNotifName', 'FontColor', '#*colorNotifName*#')
		SKIN:Bang('!SetOption', 'MeterNotifBorder', 'ImageTint', '#*colorOnlineBorder*#')
		SKIN:Bang('!SetOption', 'MeterNotifSubtitle', 'FontColor', '#*colorComeOnline*#')
		SKIN:Bang('!SetOption', 'MeterNotifSubtitle', 'Text', 'has come online')
		SKIN:Bang('!SetOptionGroup', 'Notif', 'Hidden', '0')

		SKIN:Bang('!HideMeter', 'MeterGlitch')

		NotifIndex = 1
		isNotifying = true 	-- lock notif area in use

		SKIN:Bang('[!EnableMeasure MeasureNotifTimer]')
	end

	if (NotifIndex <= LogosToProcess) then
		SKIN:Bang('!SetOption', 'MeterNotifName', 'Text', tNewStream[NotifIndex].display_name)
		SKIN:Bang('!SetOption', 'MeterNotifName', 'LeftMouseUpAction', tNewStream[NotifIndex].URL)
		SKIN:Bang('!SetOption', 'MeterNotifThumb', 'ImageName', path..'DownloadFile\\ProfileThumbs\\'..tNewStream[NotifIndex].name..'.png')
		SKIN:Bang('!SetOption', 'MeterNotifThumb', 'LeftMouseUpAction', tNewStream[NotifIndex].URL)
		SKIN:Bang('[!UpdateMeter *][!Redraw]')

		NotifIndex = NotifIndex + 1
		return

	else
		SKIN:Bang('!DisableMeasure', 'MeasureNotifTimer')
		SKIN:Bang('!SetOption', 'MeterNotifName', 'LeftMouseUpAction', '')
		SKIN:Bang('!SetOption', 'MeterNotifThumb', 'LeftMouseUpAction', '')
		SKIN:Bang('!SetOptionGroup', 'Notif', 'Hidden', '1')
		SKIN:Bang('!ShowMeter', 'MeterGlitch')

		SKIN:Bang('[!UpdateMeter *][!Redraw]')
		isNotifying = false	 -- unlock notif area
	end
end

function changeSort(Side)
	local sortType = SKIN:GetVariable('sortType', 'ViewersDESC')
	-- Sort by ViewersASC from ViewersDESC
	if (sortType == "ViewersDESC") and (Side == "R") then
			SKIN:Bang('!SetOption', 'MeterSortArrow', 'ImageFlip', 'Vertical')
			SKIN:Bang('!SetVariable', 'sortType', 'ViewersASC')
			SKIN:Bang('[!WriteKeyValue "Variables" "sortType" "ViewersASC" "#@#Variables.inc"]')
	-- Sort by NameDESC from ViewersDESC
	elseif (sortType == "ViewersDESC") and (Side == "L") then
			SKIN:Bang('!SetOption', 'MeterSortArrow', 'X', '5R')
			SKIN:Bang('!SetVariable', 'sortType', 'NameDESC')
			SKIN:Bang('[!WriteKeyValue "Variables" "sortType" "NameDESC" "#@#Variables.inc"]')
	-- Sort by ViewersDESC from ViewersASC
	elseif (sortType == "ViewersASC") and (Side == "R") then
			SKIN:Bang('!SetOption', 'MeterSortArrow', 'ImageFlip', 'None')
			SKIN:Bang('!SetVariable', 'sortType', 'ViewersDESC')
			SKIN:Bang('[!WriteKeyValue "Variables" "sortType" "ViewersDESC" "#@#Variables.inc"]')
	-- Sort by NameASC from ViewersASC
	elseif (sortType == "ViewersASC") and (Side == "L") then
			SKIN:Bang('!SetOption', 'MeterSortArrow', 'X', '5R')
			SKIN:Bang('!SetVariable', 'sortType', 'NameASC')
			SKIN:Bang('[!WriteKeyValue "Variables" "sortType" "NameASC" "#@#Variables.inc"]')
	-- Sort by ViewersDESC from NameDESC
	elseif (sortType == "NameDESC") and (Side == "R") then
			SKIN:Bang('!SetOption', 'MeterSortArrow', 'X', '(#skinWidth# - 82)')
			SKIN:Bang('!SetVariable', 'sortType', 'ViewersDESC')
			SKIN:Bang('[!WriteKeyValue "Variables" "sortType" "ViewersDESC" "#@#Variables.inc"]')
	-- Sort by NameASC from NameDESC
	elseif (sortType == "NameDESC") and (Side == "L") then
			SKIN:Bang('!SetOption', 'MeterSortArrow', 'ImageFlip', 'Vertical')
			SKIN:Bang('!SetVariable', 'sortType', 'NameASC')
			SKIN:Bang('[!WriteKeyValue "Variables" "sortType" "NameASC" "#@#Variables.inc"]')
	-- Sort by ViewersASC from NameASC
	elseif (sortType == "NameASC") and (Side == "R") then
			SKIN:Bang('!SetOption', 'MeterSortArrow', 'X', '(#skinWidth# - 82)')
			SKIN:Bang('!SetVariable', 'sortType',  'ViewersASC')
			SKIN:Bang('[!WriteKeyValue "Variables" "sortType" "ViewersASC" "#@#Variables.inc"]')
	-- Sort by NameDESC from NameASC
	elseif (sortType == "NameASC") and (Side == "L") then
			SKIN:Bang('!SetOption', 'MeterSortArrow', 'ImageFlip', 'None')
			SKIN:Bang('!SetVariable', 'sortType',  'NameDESC')
			SKIN:Bang('[!WriteKeyValue "Variables" "sortType" "NameDESC" "#@#Variables.inc"]')
	end

		sortTable()
		printTable()
		SKIN:Bang('!UpdateMeter', '*')
		SKIN:Bang('!Redraw')
end

function collapseExpand()
	local Collapsed = tonumber( SKIN:GetVariable('Collapsed') )

	-- Collapse Skin
	if (Collapsed == 0) then
		SKIN:Bang('!SetVariable', 'Collapsed', '1')
		SKIN:Bang('!WriteKeyValue', 'Variables', 'Collapsed', '1', '#@#Variables.inc')

		SKIN:Bang('!SetOption', 'MeterExpCol', 'ButtonImage', '#@#Images\\Twitch\\Expand.png')

		SKIN:Bang('!SetOption', 'MeterExpCol', 'ToolTipTitle', 'Show Live Channels')
		SKIN:Bang('!SetOption', 'MeterExpCol', 'ToolTipText', 'Expand skin to show all live channels')

		SKIN:Bang('!SetOptionGroup', 'DropDown', 'Hidden', '1')

		SKIN:Bang('!SetOption', 'MeterBottomCurve', 'ImageTint', '#colorTitleBar2#')

	-- Expand Skin
	else
		SKIN:Bang('!SetVariable', 'Collapsed', '0')
		SKIN:Bang('!WriteKeyValue', 'Variables', 'Collapsed', '0', '#@#Variables.inc')

		SKIN:Bang('!SetOption', 'MeterExpCol', 'ButtonImage', '#@#Images\\Twitch\\Collapse.png')

		SKIN:Bang('!SetOption', 'MeterExpCol', 'ToolTipTitle', 'Hide Live Channels')
		SKIN:Bang('!SetOption', 'MeterExpCol', 'ToolTipText', 'Collapse skin to hide all live channels (Online notifications will still appear)')

		SKIN:Bang('!SetOptionGroup', 'DropDown', 'Hidden', '')
		SKIN:Bang('!SetOptionGroup', 'DropDown', 'DynamicVariables', '0')

		if ( (gTotalOnline % 2) == 0 )  then
			SKIN:Bang('!SetOption', 'MeterBottomCurve', 'ImageTint', '#colorChannelBarAlt2#')
		else
			SKIN:Bang('!SetOption', 'MeterBottomCurve', 'ImageTint', '#colorChannelBar2#')
		end
	end

	SKIN:Bang('!SetOption', 'MeterSideBorder', 'DynamicVariables', '0')

	SKIN:Bang('[!UpdateMeter *][!Redraw]')
end

function updateValues()
	local mainFeedOBJ = SKIN:GetMeasure("MeasureJSONFeed")
	local rawJSON = mainFeedOBJ:GetStringValue()
	local tJSON = JSON:decode(rawJSON)

	-- Validates access token, and checks for any errors in the JSON decode
	if not validateData(tJSON) then
		return
	end

	gTotalOnline = tJSON._total

	-- Cap to maximum supported meters
	if (gTotalOnline > 30) then
		gTotalOnline = 30
	end

	tNewStream = {}
	local tTemp = {}
	local ThumbsDisabled = tonumber( SKIN:GetVariable('ThumbsDisabled') )
	if (ThumbsDisabled ~= 1) then
		gThumbUpdTime = 5
	else
		gThumbUpdTime = 0
	end

	for stream, field in ipairs(tJSON.streams) do
		local found = false
		for k, v in ipairs(tCurrentStreams) do
			if (v.name == field.channel.name) then
				tTemp[#tTemp + 1] = v

				tTemp[#tTemp].game 			= field.game
				tTemp[#tTemp].viewers 		= field.viewers
				if (ThumbsDisabled ~= 1) then
					tTemp[#tTemp].ThumbUpdTime 	= v.ThumbUpdTime + 1
				else
					tTemp[#tTemp].ThumbUpdTime 	= 0
				end
				found = true
				break
			end
		end

		if not found then
			tNewStream[#tNewStream + 1] = {
										   ["name"]				= field.channel.name,
										   ["display_name"] 	= field.channel.display_name,
										   ["game"]				= field.game,
										   ["URL"] 				= "http://www.twitch.tv/"..field.channel.name, -- field.channel.URL is sometimes blank. So we concatenate instead.
										   ["viewers"] 			= field.viewers,
										   ["ThumbURL"] 		= field.preview.template,
										   ["LogoURL"]			= field.channel.logo,
										   ["ThumbUpdTime"]		= gThumbUpdTime
									      }
			tTemp[#tTemp + 1] = tNewStream[#tNewStream]
		end
	end

	tCurrentStreams = {}
	tCurrentStreams = tTemp

	---- SORT/PRINT------

	sortTable()
	printTable()

	--- ONLINE NOTIFS ---

	if ( next(tNewStream) ~= nil ) then
		LogosToProcess = #tNewStream
		NotifIndex = 1

		SKIN:Bang('!SetOption', 'MeasureResize', 'FinishAction', '[!CommandMeasure MeasureLUA "getProfileThumbs()"]')

		getProfileThumbs()
	end

	if (isFirstLoad and gTotalOnline == 0) then -- Quick hack. isFirstLoad = false gets skipped if the skin is initially loaded with 0 channels online.
		isFirstLoad = false
	end
end

function showThumbnail(meter)
	-- MouseLeaveAction:
	if not meter then
		local ThumbsDisabled = tonumber( SKIN:GetVariable('ThumbsDisabled') )
		if (ThumbsDisabled ~= 1) then
			SKIN:Bang('[!DeactivateConfig "TwitchLiveFollowers\\Thumbnail"]')
		end
		return
	end

	local Thumbnails = tonumber( SKIN:GetVariable('Thumbnails') )

	-- Display Thumbnail on left or right depending on screen position
	if ( Thumbnails < 2 ) then -- 0 = Right, 1 = Left, >=2 = Off
		local LastConfigX = tonumber( SKIN:GetVariable('LastConfigX') )
		local CURRENTCONFIGX = tonumber( SKIN:GetVariable('CURRENTCONFIGX') )

		-- Only calculate if the skin was moved
		if ( CURRENTCONFIGX ~= LastConfigX ) then
			local CURRENTCONFIGY = tonumber(SKIN:GetVariable('CURRENTCONFIGY'))

			local WORKAREAX = tonumber(SKIN:GetVariable('WORKAREAX'))
			local WORKAREAY = tonumber(SKIN:GetVariable('WORKAREAY'))

			local WORKAREAWIDTH = tonumber(SKIN:GetVariable('WORKAREAWIDTH'))
			local WORKAREAHEIGHT = tonumber(SKIN:GetVariable('WORKAREAHEIGHT'))

			local CURRENTCONFIGWIDTH = tonumber(SKIN:GetVariable('skinWidth'))
			local CURRENTCONFIGHEIGHT = tonumber(SKIN:GetVariable('CURRENTCONFIGHEIGHT'))

			if ( (CURRENTCONFIGX < 200 + WORKAREAX) and (CURRENTCONFIGX > WORKAREAX - 200) ) then
				SKIN:Bang('!SetVariable', 'Thumbnails', '0')
				SKIN:Bang('!WriteKeyValue', 'Variables', 'Thumbnails', '0', '#@#Variables.inc')

			elseif ( (CURRENTCONFIGX < 200 + ((WORKAREAWIDTH + WORKAREAX) - CURRENTCONFIGWIDTH)) and (CURRENTCONFIGX > -200 + ((WORKAREAWIDTH + WORKAREAX) - CURRENTCONFIGWIDTH)) ) then
				SKIN:Bang('!SetVariable', 'Thumbnails', '1')
				SKIN:Bang('!WriteKeyValue', 'Variables', 'Thumbnails', '1', '#@#Variables.inc')

			else
				SKIN:Bang('!SetVariable', 'Thumbnails', '1')
				SKIN:Bang('!WriteKeyValue', 'Variables', 'Thumbnails', '1', '#@#Variables.inc')
			end
			SKIN:Bang('!SetVariable', 'LastConfigX', CURRENTCONFIGX)
			SKIN:Bang('!WriteKeyValue', 'Variables', 'LastCOnfigX', CURRENTCONFIGX, '#@#Variables.inc')
		end

		if ( tonumber(SKIN:GetVariable('Thumbnails')) == 1 ) then
			SKIN:Bang('!WriteKeyValue', 'TwitchLiveFollowers\\Thumbnail', 'WindowX', '(#CURRENTCONFIGX# - #skinWidth#)', '#SETTINGSPATH#Rainmeter.ini')
		else
			SKIN:Bang('!WriteKeyValue', 'TwitchLiveFollowers\\Thumbnail', 'WindowX', '(#CURRENTCONFIGX# + #skinWidth#)', '#SETTINGSPATH#Rainmeter.ini')
		end
		SKIN:Bang('!WriteKeyValue', 'TwitchLiveFollowers\\Thumbnail', 'WindowY', '(#CURRENTCONFIGY# -46 + #subtitleBarHeight# + #topBarHeight# + #meterHeight# *'..(meter - 1)..')', '#SETTINGSPATH#Rainmeter.ini')
	-- Thumbnail Off
	else
		return -- Do nothing, thumbsnails are off
	end
	SKIN:Bang('!WriteKeyValue', 'MeterThumbnail', 'ImageName', '#*ROOTCONFIGPATH*#Twitch\\DownloadFile\\StreamThumbs\\'..tCurrentStreams[meter].name..'.png', '#ROOTCONFIGPATH#Thumbnail\\thumb.ini')

	SKIN:Bang('[!ActivateConfig TwitchLiveFollowers\\Thumbnail]')
end

function streamHover(i, leave)
	-- MouseLeaveAction
	local meterOnline = SKIN:GetMeter('MeterNumOnline')

	if leave then
		if (isNotifying == false) then			-- Only hide it if no online notifications are currently running.
			SKIN:Bang('[!SetOptionGroup Notif Hidden 1]')
			SKIN:Bang('!ShowMeter', 'MeterGlitch')
		end
		SKIN:Bang('[!HideMeter MeterVLCIcon]')

		SKIN:Bang('!SetOption', 'MeterChanBar'..i, 'SolidColor', '')
		SKIN:Bang('!SetOption', 'MeterChanBar'..i, 'SolidColor2', '')

		if (i == gTotalOnline) then
			if ( (i % 2) ~= 0) then
				SKIN:Bang('!SetOption', 'MeterBottomCurve', 'ImageTint', '#*colorChannelBar2*#')
			else
				SKIN:Bang('!SetOption', 'MeterBottomCurve', 'ImageTint', '#*colorChannelBarAlt2*#')
			end
		end

		SKIN:Bang('!UpdateMeter', '*')
		SKIN:Bang('!Redraw')
		return
	end

	if ( tonumber(SKIN:GetVariable('Livestreamer')) == 1) then
		local quality = SKIN:GetVariable('Quality')
		SKIN:Bang('!SetOption', 'MeterVLCIcon', 'LeftMouseUpAction', '["livestreamer.exe" '..tCurrentStreams[i].URL..' '..quality..']')
		SKIN:Bang('!SetOption', 'MeterVLCIcon', 'X', '(([MeterStreamName'..i..':X] + [MeterStreamName'..i..':W]) + 5)')
		SKIN:Bang('!SetOption', 'MeterVLCIcon', 'Y', '([MeterStreamName'..i..':Y] + 1)')

		SKIN:Bang('!ShowMeter', 'MeterVLCIcon')
	end

	if ( isNotifying == false ) then -- Only show if no online notifications are running
		SKIN:Bang('!SetOption', 'MeterNotifThumb', 'ImageName', path..'DownloadFile\\ProfileThumbs\\'..tCurrentStreams[i].name..'.png')
		SKIN:Bang('!SetOption', 'MeterNotifThumb', 'ImageAlpha', '255')
		SKIN:Bang('!SetOption', 'MeterNotifBorder', 'ImageAlpha', '255')
		SKIN:Bang('!SetOption', 'MeterNotifBorder', 'ImageTint', '')
		SKIN:Bang('!SetOption', 'MeterNotifName', 'Text', 'Playing')
		SKIN:Bang('!SetOption', 'MeterNotifName', 'FontColor', '#*colorPlayingText*#')
		SKIN:Bang('!SetOption', 'MeterNotifSubtitle', 'Text', tCurrentStreams[i].game)
		SKIN:Bang('!SetOption', 'MeterNotifSubtitle', 'FontColor', '#*colorGameName*#')

		SKIN:Bang('!SetOptionGroup', 'Notif', 'Hidden', '0')
		SKIN:Bang('!HideMeter', 'MeterGlitch')
	end

	SKIN:Bang('!SetOption', 'MeterChanBar'..i, 'SolidColor', '#colorChannelBarHover#')
	SKIN:Bang('!SetOption', 'MeterChanBar'..i, 'SolidColor2', '#colorChannelBarHover2#')

	if (i == gTotalOnline) then
		SKIN:Bang('!SetOption', 'MeterBottomCurve', 'ImageTint', '#colorChannelBarHover2#')
	end

	SKIN:Bang('!UpdateMeter', '*')
	SKIN:Bang('!Redraw')
end

function sortTable()
	local sortType = SKIN:GetVariable('sortType', 'ViewersDESC')

	if (sortType == "ViewersDESC") then
		table.sort(tCurrentStreams, function (a,b) return a.viewers > b.viewers end)
	elseif (sortType == "ViewersASC") then
		table.sort(tCurrentStreams, function (a,b) return a.viewers < b.viewers end)
	elseif (sortType == "NameDESC") then
		table.sort(tCurrentStreams, function (a,b) return a.name > b.name end)
	elseif (sortType == "NameASC") then
		table.sort(tCurrentStreams, function (a,b) return a.name < b.name end)
	end

end

function printTable()
	for k, v in ipairs(tCurrentStreams) do
		if (v.ThumbUpdTime == 5) then		-- Thumbnail older than 5 minutes? Update.
			SKIN:Bang('!SetOption', 'MeasureIMG'..k, 'URL', customThumbnailSize( v.ThumbURL ))
			SKIN:Bang('!SetOption', 'MeasureIMG'..k, 'DownloadFile', 'StreamThumbs\\'..v.name..'.png')
			SKIN:Bang('!EnableMeasure', 'MeasureIMG'..k)
			SKIN:Bang('!CommandMeasure', 'MeasureIMG'..k, 'Update')
			SKIN:Bang('!UpdateMeasure', 'MeasureIMG'..k)
			v.ThumbUpdTime = 0
		end

		SKIN:Bang('!SetOption', 'MeterStreamName'..k, 'Text', v.display_name)
		SKIN:Bang('!SetOption', 'MeterChanBar'..k, 'LeftMouseUpAction', '["'..v.URL..'"]')
		SKIN:Bang('!SetOption', 'MeterViewers'..k, 'Text', formatViewers(v.viewers))
	end

	if (gTotalOnline <= 29) then
		SKIN:Bang('!SetOption', 'MeterNumOnline', 'Text', gTotalOnline)
	else
		SKIN:Bang('!SetOption', 'MeterNumOnline', 'Text', '30+')
	end

	if ( (tonumber( SKIN:GetVariable('Collapsed') )) == 0)  then
		if ( (gTotalOnline % 2) == 0 )  then
			SKIN:Bang('!SetOption', 'MeterBottomCurve', 'ImageTint', '#*colorChannelBarAlt2*#')
		else
			SKIN:Bang('!SetOption', 'MeterBottomCurve', 'ImageTint', '#*colorChannelBar2*#')
		end
	end

	SKIN:Bang('!SetVariable', 'numOnline', gTotalOnline)
	SKIN:Bang('!SetOption', 'MeterSideBorder', 'DynamicVariables', '0')

	if ( tonumber(SKIN:GetVariable('Collapsed')) == 0 ) then
		SKIN:Bang('!SetOptionGroup', 'DropDown', 'DynamicVariables', '0')
	end

	SKIN:Bang('[!UpdateMeter *][!Redraw]')
end

function formatViewers(numVar)
	-- Modified function from: http://docs.rainmeter.net/snippets/add-commas
	if ( tonumber(SKIN:GetVariable('numFormat')) ) == 0 then -- Full version with commas
		assert(tonumber(numVar), 'Function formatViewers() expects a number.')
		local prefix, number, postfix = string.match(numVar, '^([^%d]*%d)(%d*)(.-)$')

		return prefix..(number:reverse():gsub('(%d%d%d)', '%1,'):reverse())..postfix
	else -- Short version with rounding
		if numVar >= 10^6 then
			return string.format("%.2f", numVar / 10^6) .. "m"
		elseif numVar >= 10^3 then
			return string.format("%.1f", numVar / 10^3) .. "k"
		else
			return numVar
		end
	end
end

function customThumbnailSize(urlStr)
	local s = string.gsub(urlStr, "{width}", "184")
	return (string.gsub(s, "{height}", "104"))
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

--
-- Version history:
--
--   20140418.11   JSON nulls embedded within an array were being ignored, such that
--                     ["1",null,null,null,null,null,"seven"],
--                 would return
--                     {1,"seven"}
--                 It's now fixed to properly return
--                     {1, nil, nil, nil, nil, nil, "seven"}
--                 Thanks to "haddock" for catching the error.
--
--   20140116.10   The user's JSON.assert() wasn't always being used. Thanks to "blue" for the heads up.
--
--   20131118.9    Update for Lua 5.3... it seems that tostring(2/1) produces "2.0" instead of "2",
--                 and this caused some problems.
--
--   20131031.8    Unified the code for encode() and encode_pretty(); they had been stupidly separate,
--                 and had of course diverged (encode_pretty didn't get the fixes that encode got, so
--                 sometimes produced incorrect results; thanks to Mattie for the heads up).
--
--                 Handle encoding tables with non-positive numeric keys (unlikely, but possible).
--
--                 If a table has both numeric and string keys, or its numeric keys are inappropriate
--                 (such as being non-positive or infinite), the numeric keys are turned into
--                 string keys appropriate for a JSON object. So, as before,
--                         JSON:encode({ "one", "two", "three" })
--                 produces the array
--                         ["one","two","three"]
--                 but now something with mixed key types like
--                         JSON:encode({ "one", "two", "three", SOMESTRING = "some string" }))
--                 instead of throwing an error produces an object:
--                         {"1":"one","2":"two","3":"three","SOMESTRING":"some string"}
--
--                 To maintain the prior throw-an-error semantics, set
--                      JSON.noKeyConversion = true
--
--   20131004.7    Release under a Creative Commons CC-BY license, which I should have done from day one, sorry.
--
--   20130120.6    Comment update: added a link to the specific page on my blog where this code can
--                 be found, so that folks who come across the code outside of my blog can find updates
--                 more easily.
--
--   20111207.5    Added support for the 'etc' arguments, for better error reporting.
--
--   20110731.4    More feedback from David Kolf on how to make the tests for Nan/Infinity system independent.
--
--   20110730.3    Incorporated feedback from David Kolf at http://lua-users.org/wiki/JsonModules:
--
--                   * When encoding lua for JSON, Sparse numeric arrays are now handled by
--                     spitting out full arrays, such that
--                        JSON:encode({"one", "two", [10] = "ten"})
--                     returns
--                        ["one","two",null,null,null,null,null,null,null,"ten"]
--
--                     In 20100810.2 and earlier, only up to the first non-null value would have been retained.
--
--                   * When encoding lua for JSON, numeric value NaN gets spit out as null, and infinity as "1+e9999".
--                     Version 20100810.2 and earlier created invalid JSON in both cases.
--
--                   * Unicode surrogate pairs are now detected when decoding JSON.
--
--   20100810.2    added some checking to ensure that an invalid Unicode character couldn't leak in to the UTF-8 encoding
--
--   20100731.1    initial public release
--


end

