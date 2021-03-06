[sTopBotCurve]
ImageName=#@#Images\Twitch\Curve.png
W=#skinWidth# 

[sTopBar]
X=0r
Y=0R
W=#skinWidth#
H=#topBarHeight#
SolidColor=#colorTitleBar#
SolidColor2=#colorTitleBar2#
GradientAngle=90

[sNumOnline]
X=6
Y=3
FontColor=#colorNumOnline#
FontFace=#fontName#
FontSize=9
StringStyle=Bold
AntiAlias=1
Text=0

[sOnlineStr]
X=7R
Y=0r
FontFace=#fontName#
FontColor=#colorOnline#
FontSize=9
StringStyle=Bold
Text=Online
AntiAlias=1

[sSettingsIcon]
X=8R
Y=4
ImageName=#@#Images\Twitch\SettingsCog.png
LeftMouseUpAction=[!ToggleConfig "TwitchLiveFollowers\Options" "Options.ini"]
ToolTipTitle=Settings
ToolTipText=Contains settings specific to this skin.
ToolTipWidth=350
Hidden=1
Group=Buttons

[sExpCol]
X=5R
Y=4
ButtonImage=#@#Images\Twitch\Collapse.png
LeftMouseUpAction=[!CommandMeasure MeasureLUA "collapseExpand()"]
ToolTipTitle=Hide Live Channels
ToolTipText=Collapse skin to hide all live channels (Online notifications will still appear)
ToolTipWidth=350
MouseActionCursor=0
Hidden=1
Group=Buttons

[sClose]
X=5R
Y=4
ButtonImage=#@#Images\Twitch\Close.png
LeftMouseUpAction=[!DeactivateConfig #CURRENTCONFIG#]
ToolTipTitle=Close Skin
ToolTipText=Unloads the skin
ToolTipWidth=400
MouseActionCursor=0
Hidden=1
Group=Buttons

[sGlitch]
ImageName=#@#Images\Twitch\Glitch.png
ImageAlpha=150
H=40
W=40
X=(#skinWidth# - 44)
Y=5

[sNotif]
Group=Notif
Hidden=1

[sNotifBorder]
ImageName=#@#Images\Twitch\BorderHover.png
ImageTint=#colorProfileBorder#
X=(#skinWidth# - 50)

[sNotifThumb]
H=40
W=40
X=(#skinWidth# - 45)
Y=5

[sNotifName]
X=(#skinWidth# - 50)
Y=18
H=15
StringAlign=Right
FontColor=#colorPlayingText#
FontFace=#fontName#
FontSize=9
StringStyle=Bold
ClipString=2
ClipStringW=148
ClipStringH=10
AntiAlias=1

[sNotifSubtitle]
X=(#skinWidth# - 50)
Y=33
H=15
FontFace=#fontName#
FontColor=#colorGameName#
FontSize=8
StringStyle=Bold
ClipString=2
ClipStringW=148
AntiAlias=1
StringAlign=Right

[sTopBarSpacer]
X=0R
Y=3
H=#topBarHeight#

[sSubtitleBar]
Y=R
W=#skinWidth#
H=#subtitleBarHeight#
SolidColor=#colorSubtitleBar#
SolidColor2=#colorSubtitleBar2#
GradientAngle=90
Group=DropDown | Subtitle
Hidden=(#numOnline# = 0 ? 1 : 0)

[sSortArrow]
ImageName=#@#Images\Twitch\SortArrow.png
X=118
Y=-4r
ImageFlip=None
Group=Subtitle | DropDown
Hidden=(#numOnline# = 0 ? 1 : 0)

[sSubtitleTextL]
X=7r
Y=(#subtitleBarHeight# / 2)r
FontColor=#colorSubtitleText#
FontFace=#fontName#
FontSize=9
StringStyle=Bold
StringAlign=LeftCenter
Text=Channel
LeftMouseUpAction=[!CommandMeasure MeasureLUA "changeSort('L')"]
Group=DropDown | Subtitle
Hidden=(#numOnline# = 0 ? 1 : 0)
AntiAlias=1

[sSubtitleTextR]
X=(#skinWidth# - 7)
Y=4r
FontColor=#colorSubtitleText#
FontFace=#fontName#
FontSize=9
StringStyle=Bold
StringAlign=RightCenter
Text=Viewers
LeftMouseUpAction=[!CommandMeasure MeasureLUA "changeSort('R')"]
Group=DropDown | Subtitle
Hidden=(#numOnline# = 0 ? 1 : 0)
AntiAlias=1

[sSubtitleSpacer]
X=0r
Y=(-(#subtitleBarHeight# / 2))r
H=#subtitleBarHeight#
Hidden=(#numOnline# = 0 ? 1 : 0)
Group=DropDown | Subtitle

[sChanBar]
Y=0R
W=#skinWidth#
H=#meterHeight#
SolidColor=#colorChannelBar#
SolidColor2=#colorChannelBar2#
GradientAngle=90

[sChanBarAlt]
Y=0R
W=#skinWidth#
H=#meterHeight#
SolidColor=#colorChannelBarAlt#
SolidColor2=#colorChannelBarAlt2#
GradientAngle=90

[sChanName]
X=7r
Y=(#meterHeight# / 2)r
H=(#meterHeight# - 2)
FontColor=#colorStreamName#
FontFace=#fontName#
FontSize=#fontSize#
StringStyle=Bold
StringAlign=LeftCenter
ClipString=2
ClipStringW=((#skinWidth# / 2) + 10)
AntiAlias=1

[sViewCount]
X=(#skinWidth#-7)
Y=0r
H=(#meterHeight# - 2)
W=((#skinWidth# / 2) - 45)
FontColor=#colorViewers#
FontFace=#fontName#
FontSize=#fontSize#
StringStyle=Bold
StringAlign=RightCenter
AntiAlias=1

[sStream1]
Group=DropDown | Chan1
Hidden=( (#numOnline# >= 1) && (#Collapsed# = 0) ? 0 : 1)

[sStream2]
Group=DropDown | Chan2
Hidden=( (#numOnline# >= 2) && (#Collapsed# = 0) ? 0 : 1)

[sStream3]
Group=DropDown | Chan3
Hidden=( (#numOnline# >= 3) && (#Collapsed# = 0) ? 0 : 1)

[sStream4]
Group=DropDown | Chan4
Hidden=( (#numOnline# >= 4) && (#Collapsed# = 0) ? 0 : 1)

[sStream5]
Group=DropDown | Chan5
Hidden=( (#numOnline# >= 5) && (#Collapsed# = 0) ? 0 : 1)

[sStream6]
Group=DropDown | Chan6
Hidden=( (#numOnline# >= 6) && (#Collapsed# = 0) ? 0 : 1)

[sStream7]
Group=DropDown | Chan7
Hidden=( (#numOnline# >= 7) && (#Collapsed# = 0) ? 0 : 1)

[sStream8]
Group=DropDown | Chan8
Hidden=( (#numOnline# >= 8) && (#Collapsed# = 0) ? 0 : 1)

[sStream9]
Group=DropDown | Chan9
Hidden=( (#numOnline# >= 9) && (#Collapsed# = 0) ? 0 : 1)

[sStream10]
Group=DropDown | Chan10
Hidden=( (#numOnline# >= 10) && (#Collapsed# = 0) ? 0 : 1)

[sStream11]
Group=DropDown | Chan11
Hidden=( (#numOnline# >= 11) && (#Collapsed# = 0) ? 0 : 1)

[sStream12]
Group=DropDown | Chan12
Hidden=( (#numOnline# >= 12) && (#Collapsed# = 0) ? 0 : 1)

[sStream13]
Group=DropDown | Chan13
Hidden=( (#numOnline# >= 13) && (#Collapsed# = 0) ? 0 : 1)

[sStream14]
Group=DropDown | Chan14
Hidden=( (#numOnline# >= 14) && (#Collapsed# = 0) ? 0 : 1)

[sStream15]
Group=DropDown | Chan15
Hidden=( (#numOnline# >= 15) && (#Collapsed# = 0) ? 0 : 1)

[sStream16]
Group=DropDown | Chan16
Hidden=( (#numOnline# >= 16) && (#Collapsed# = 0) ? 0 : 1)

[sStream17]
Group=DropDown | Chan17
Hidden=( (#numOnline# >= 17) && (#Collapsed# = 0) ? 0 : 1)

[sStream18]
Group=DropDown | Chan18
Hidden=( (#numOnline# >= 18) && (#Collapsed# = 0) ? 0 : 1)

[sStream19]
Group=DropDown | Chan19
Hidden=( (#numOnline# >= 19) && (#Collapsed# = 0) ? 0 : 1)

[sStream20]
Group=DropDown | Chan20
Hidden=( (#numOnline# >= 20) && (#Collapsed# = 0) ? 0 : 1)

[sStream21]
Group=DropDown | Chan21
Hidden=( (#numOnline# >= 21) && (#Collapsed# = 0) ? 0 : 1)

[sStream22]
Group=DropDown | Chan22
Hidden=( (#numOnline# >= 22) && (#Collapsed# = 0) ? 0 : 1)

[sStream23]
Group=DropDown | Chan23
Hidden=( (#numOnline# >= 23) && (#Collapsed# = 0) ? 0 : 1)

[sStream24]
Group=DropDown | Chan24
Hidden=( (#numOnline# >= 24) && (#Collapsed# = 0) ? 0 : 1)

[sStream25]
Group=DropDown | Chan25
Hidden=( (#numOnline# >= 25) && (#Collapsed# = 0) ? 0 : 1)

[sStream26]
Group=DropDown | Chan26
Hidden=( (#numOnline# >= 26) && (#Collapsed# = 0) ? 0 : 1)

[sStream27]
Group=DropDown | Chan27
Hidden=( (#numOnline# >= 27) && (#Collapsed# = 0) ? 0 : 1)

[sStream28]
Group=DropDown | Chan28
Hidden=( (#numOnline# >= 28) && (#Collapsed# = 0) ? 0 : 1)

[sStream29]
Group=DropDown | Chan29
Hidden=( (#numOnline# >= 29) && (#Collapsed# = 0) ? 0 : 1)

[sStream30]
Group=DropDown | Chan30
Hidden=( (#numOnline# >= 30) && (#Collapsed# = 0) ? 0 : 1)

[sChanSpacer]
X=0r
Y=(-(#meterHeight# / 2))r
H=#meterHeight#

[sBorder]
ImageName=#@#Images\Twitch\Border.png
ImageTint=#colorBorder#
W=#skinWidth#
ScaleMargins=2,2,2,2

[sSideBorder]
ImageName=#@#Images\Twitch\SideBorder.png
H=(#numOnline# = 0 ? #topBarHeight# : (#Collapsed# = 0 ? ( (#topBarHeight# + #subtitleBarHeight#) + (#meterHeight# * #numOnline#) ) : #topBarHeight#))
Y=3

[sVLCIcon]
ImageName=#@#Images\Twitch\VLC.png
W=14
H=14
ToolTipTitle=Watch Using Livestreamer (Current Quality: Source)
ToolTipText=Watch the stream in an external player using Livestreamer. Quality can be changed in Settings > General Tab > Livestreamer Quality.
ToolTipWidth=350
Hidden=1

[sErrorHelp]
ImageName=#@#Images\Twitch\HelpIcon.png
X=5
Y=23
MouseActionCursor=1
ToolTipText=Click here to learn why you're seeing this error
ToolTipWidth=200
Hidden=1
Group=ErrorBar

[sErrorDesc]
X=5R
Y=8r
W=160
H=30
FontSize=8
FontColor=E6E225
Hidden=1
Group=ErrorBar
