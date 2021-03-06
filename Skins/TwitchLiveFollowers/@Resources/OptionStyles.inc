[sBG]
ImageName=#@#Images\Options\OptionsBG1.png
W=450
H=500

[sTabText]
Y=33
W=55
H=20
FontColor=DDDDDD
FontFace=Verdana
FontSize=7
StringStyle=Bold
StringAlign=CenterCenter
AntiAlias=1

[sTitleText]
X=235
Y=15
H=50
FontSize=9
FontColor=FFFFFF
FontFace=Verdana
StringStyle=Bold
StringEffect=Shadow
AntiAlias=1
Text=Live Following for Twitch#CRLF#Skin Options

[sCCIMG]
ImageName=#@#Images\Twitch\CC.png
X=315
Y=460
W=13
H=13
ToolTipTitle=Creative Commons License
ToolTipText=The Live Following for Twitch Rainmeter Skin is released under the Creative Commons BY-NC-SA 4.0 License. Click for more details.
ToolTipWidth=300
LeftMouseUpAction=["http://creativecommons.org/licenses/by-nc-sa/4.0/"]

[sCCText]
MeasureName=MeasureCurrentYear
X=5R
Y=r
FontFace=Segoe UI
FontColor=DDDDDD
FontSize=7
StringStyle=Bold
AntiAlias=1
Text=2014-%1 Wallboy
ToolTipTitle=Creative Commons License
ToolTipText=The Live Following for Twitch Rainmeter Skin is released under the Creative Commons BY-NC-SA 4.0 License. Click for more details.
ToolTipWidth=300
LeftMouseUpAction=["http://creativecommons.org/licenses/by-nc-sa/4.0/"]

[sCloseButton]
X=422
Y=22
ButtonImage=#@#Images\Twitch\Close.png
ButtonCommand=[!DeactivateConfig #CURRENTCONFIG#]
ToolTipTitle=Close Options
ToolTipText=Closes the Skin Options

[sHelpIMG]
ImageName=#@#Images\Twitch\HelpIcon.png
X=29
Y=365

[sHelpText]
FontFace=Verdana
FontSize=10
FontColor=DDDDDD
StringStyle=Bold
X=10R
Y=0r
H=40
W=375
ClipString=2
AntiAlias=1
Text=Hover over this icon above for more info about a particular option.

[sHelpTitle]
X=55
Y=365
FontSize=10
Hidden=1
Group=Help | HelpText

[sHelpDesc]
X=35
Y=23r
W=375
H=100
ClipString=2
Hidden=1
Group=Help | HelpText

[sTabTitle]
X=45
Y=50
FontSize=13

[sHelpHoverIMG]
ImageName=#@#Images\Twitch\HelpIcon.png
ImageAlpha=128
LeftMouseUpAction=[!SetOption #CURRENTSECTION# MouseActionCursor 1]
MouseLeaveAction=[!HideMeterGroup Help][!ShowMeter MeterHelpText][!SetOption #CURRENTSECTION# ImageAlpha ""][!UpdateMeter *][!Redraw]

[sMainText]
X=10R
Y=1r
FontFace=Verdana
FontColor=FFFFFF
FontSize=8
StringStyle=Bold
AntiAlias=1

[sLivestreamer]
Hidden=(#Livestreamer# = 1 ? 0 : 1)
Group=Livestreamer

[sColorOutline]
ImageName=#@#Images\Options\ColorOutline.png
X=10R
Y=-1r

[sColorBarPos]
W=33
H=13
X=1r
Y=1r


