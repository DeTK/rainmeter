[measureRainRGB]
Measure=Plugin
Plugin=RunCommand
Program="#@#Addons\RainRGB4.exe"

[MeterTab2Title]
Meter=String
MeterStyle=sMainText | sTabTitle
Text=Skin Colors

;====================
;==== COLOR HELP ====
;====================

[MeterColorHelp]
Meter=Image
MeterStyle=sHelpHoverIMG
X=135
Y=25r
MouseOverAction=[!SetOption #CURRENTSECTION# ImageAlpha 255][!CommandMeasure MeasureOptionsLUA "helpHover('ColorHelp')"]

[MeterColor1Text]
Meter=String
MeterStyle=sMainText
Text=Color 1

[MeterColor2Text]
Meter=String
MeterStyle=sMainText
Text=Color 2
X=10R
Y=r

;===================
;==== TOP BAR ====
;===================

[MeterTitleBarHelp]
Meter=Image
MeterStyle=sHelpHoverIMG
X=81
Y=20r
MouseOverAction=[!SetOption #CURRENTSECTION# ImageAlpha 255][!CommandMeasure MeasureOptionsLUA "helpHover('TopBar')"]

[MeterTitleBarText]
Meter=String
MeterStyle=sMainText
Text=Top Bar

[MeterTitleBarColorOutline]
Meter=Image
MeterStyle=sColorOutline

[MeterTitleBarColor]
Meter=Image
MeterStyle=sColorBarPos
SolidColor=#colorTitleBar#
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "setColor('#CURRENTSECTION#', 'colorTitleBar')"]

[MeterTitleBarColorOutline2]
Meter=Image
MeterStyle=sColorOutline
X=17R

[MeterTitleBarColor2]
Meter=Image
MeterStyle=sColorBarPos
SolidColor=#colorTitleBar2#
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "setColor('#CURRENTSECTION#', 'colorTitleBar2')"]

;===================
;== SUBTITLE BAR ===
;===================

[MeterSubtitleBarHelp]
Meter=Image
MeterStyle=sHelpHoverIMG
X=57
Y=20r
MouseOverAction=[!SetOption #CURRENTSECTION# ImageAlpha 255][!CommandMeasure MeasureOptionsLUA "helpHover('SubtitleBar')"]

[MeterSubtitleBarText]
Meter=String
MeterStyle=sMainText
Text=Subtitle Bar

[MeterSubtitleBarColorOutline]
Meter=Image
MeterStyle=sColorOutline

[MeterSubtitleBarColor]
Meter=Image
MeterStyle=sColorBarPos
SolidColor=#colorSubtitleBar#
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "setColor('#CURRENTSECTION#', 'colorSubtitleBar')"]

[MeterSubtitleBarColorOutline2]
Meter=Image
MeterStyle=sColorOutline
X=17R

[MeterSubtitleBarColor2]
Meter=Image
MeterStyle=sColorBarPos
SolidColor=#colorSubtitleBar2#
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "setColor('#CURRENTSECTION#', 'colorSubtitleBar2')"]

;===================
;=== CHANNEL BAR ===
;===================

[MeterChannelBarHelp]
Meter=Image
MeterStyle=sHelpHoverIMG
X=69
Y=20r
MouseOverAction=[!SetOption #CURRENTSECTION# ImageAlpha 255][!CommandMeasure MeasureOptionsLUA "helpHover('ChannelBar')"]

[MeterChannelBarText]
Meter=String
MeterStyle=sMainText
Text=Chan. Bar

[MeterChannelColorOutline]
Meter=Image
MeterStyle=sColorOutline

[MeterChannelBarColor]
Meter=Image
MeterStyle=sColorBarPos
SolidColor=#colorChannelBar#
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "setColor('#CURRENTSECTION#', 'colorChannelBar')"]

[MeterChannelBarColorOutline2]
Meter=Image
MeterStyle=sColorOutline
X=17R

[MeterChannelBarColor2]
Meter=Image
MeterStyle=sColorBarPos
SolidColor=#colorChannelBar2#
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "setColor('#CURRENTSECTION#', 'colorChannelBar2')"]

;=======================
;=== CHANNEL BAR ALT ===
;=======================

[MeterChannelBarAltHelp]
Meter=Image
MeterStyle=sHelpHoverIMG
X=45
Y=20r
MouseOverAction=[!SetOption #CURRENTSECTION# ImageAlpha 255][!CommandMeasure MeasureOptionsLUA "helpHover('ChannelBarAlt')"]

[MeterChannelBarAltText]
Meter=String
MeterStyle=sMainText
Text=Chan. Bar Alt.

[MeterChannelAltColorOutline]
Meter=Image
MeterStyle=sColorOutline

[MeterChannelAltBarColor]
Meter=Image
MeterStyle=sColorBarPos
SolidColor=#colorChannelBarAlt#
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "setColor('#CURRENTSECTION#', 'colorChannelBarAlt')"]

[MeterChannelAltBarColorOutline2]
Meter=Image
MeterStyle=sColorOutline
X=17R

[MeterChannelAltBarColor2]
Meter=Image
MeterStyle=sColorBarPos
SolidColor=#colorChannelBarAlt2#
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "setColor('#CURRENTSECTION#', 'colorChannelBarAlt2')"]

;=======================
;=== CHANNEL HOVER  ====
;=======================

[MeterChannelHoverHelp]
Meter=Image
MeterStyle=sHelpHoverIMG
X=30
Y=20r
MouseOverAction=[!SetOption #CURRENTSECTION# ImageAlpha 255][!CommandMeasure MeasureOptionsLUA "helpHover('ChannelBarHover')"]

[MeterChannelHoverText]
Meter=String
MeterStyle=sMainText
Text=Chan. Bar Hover

[MeterChannelHoverColorOutline]
Meter=Image
MeterStyle=sColorOutline

[MeterChannelHoverBarColor]
Meter=Image
MeterStyle=sColorBarPos
SolidColor=#colorChannelBarHover#
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "setColor('#CURRENTSECTION#', 'colorChannelBarHover')"]

[MeterChannelHoverBarColorOutline2]
Meter=Image
MeterStyle=sColorOutline
X=17R

[MeterChannelHoverBarColor2]
Meter=Image
MeterStyle=sColorBarPos
SolidColor=#colorChannelBarHover2#
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "setColor('#CURRENTSECTION#', 'colorChannelBarHover2')"]

;===================
;=== SKIN BORDER ===
;===================

[MeterBorderHelp]
Meter=Image
MeterStyle=sHelpHoverIMG
X=57
Y=20r
MouseOverAction=[!SetOption #CURRENTSECTION# ImageAlpha 255][!CommandMeasure MeasureOptionsLUA "helpHover('Border')"]

[MeterBorderText]
Meter=String
MeterStyle=sMainText
Text=Skin Border

[MeterBorderColorOutline]
Meter=Image
MeterStyle=sColorOutline

[MeterBorderColor]
Meter=Image
MeterStyle=sColorBarPos
SolidColor=#colorBorder#
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "setColor('#CURRENTSECTION#', 'colorBorder')"]

;======================
;=== PROFILE BORDER ===
;======================

[MeterProfileBorderHelp]
Meter=Image
MeterStyle=sHelpHoverIMG
X=54
Y=20r
MouseOverAction=[!SetOption #CURRENTSECTION# ImageAlpha 255][!CommandMeasure MeasureOptionsLUA "helpHover('ProfileBorder')"]

[MeterProfileBorderText]
Meter=String
MeterStyle=sMainText
Text=Logo Border

[MeterProfileBorderColorOutline]
Meter=Image
MeterStyle=sColorOutline

[MeterProfileBorderColor]
Meter=Image
MeterStyle=sColorBarPos
SolidColor=#colorProfileBorder#
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "setColor('#CURRENTSECTION#', 'colorProfileBorder')"]

;======================
;=== ONLINE BORDER ====
;======================

[MeterOnlineBorderHelp]
Meter=Image
MeterStyle=sHelpHoverIMG
X=45
Y=20r
MouseOverAction=[!SetOption #CURRENTSECTION# ImageAlpha 255][!CommandMeasure MeasureOptionsLUA "helpHover('OnlineBorder')"]

[MeterOnlineBorderText]
Meter=String
MeterStyle=sMainText
Text=Online Border

[MeterOnlineBorderColorOutline]
Meter=Image
MeterStyle=sColorOutline

[MeterOnlineBorderColor]
Meter=Image
MeterStyle=sColorBarPos
SolidColor=#colorOnlineBorder#
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "setColor('#CURRENTSECTION#', 'colorOnlineBorder')"]

;=====================
;=== NUMBER ONLINE ===
;=====================

[MeterNumOnlineHelp]
Meter=Image
MeterStyle=sHelpHoverIMG
X=27
Y=20r
MouseOverAction=[!SetOption #CURRENTSECTION# ImageAlpha 255][!CommandMeasure MeasureOptionsLUA "helpHover('NumOnline')"]

[MeterNumOnlineText]
Meter=String
MeterStyle=sMainText
Text=Following Online

[MeterNumOnlineColorOutline]
Meter=Image
MeterStyle=sColorOutline

[MeterNumOnlineColor]
Meter=Image
MeterStyle=sColorBarPos
SolidColor=#colorNumOnline#
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "setColor('#CURRENTSECTION#', 'colorNumOnline')"]

;===================
;=== ONLINE TEXT ===
;===================

[MeterOnlineHelp]
Meter=Image
MeterStyle=sHelpHoverIMG
X=59
Y=20r
MouseOverAction=[!SetOption #CURRENTSECTION# ImageAlpha 255][!CommandMeasure MeasureOptionsLUA "helpHover('Online')"]

[MeterOnlineText]
Meter=String
MeterStyle=sMainText
Text=Online Text

[MeterOnlineColorOutline]
Meter=Image
MeterStyle=sColorOutline

[MeterOnlineColor]
Meter=Image
MeterStyle=sColorBarPos
SolidColor=#colorOnline#
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "setColor('#CURRENTSECTION#', 'colorOnline')"]

;=====================
;=== SUBTITLE TEXT ===
;=====================

[MeterSubtitleTextHelp]
Meter=Image
MeterStyle=sHelpHoverIMG
X=51
Y=20r
MouseOverAction=[!SetOption #CURRENTSECTION# ImageAlpha 255][!CommandMeasure MeasureOptionsLUA "helpHover('SubtitleText')"]

[MeterSubtitleText]
Meter=String
MeterStyle=sMainText
Text=Subtitle Text

[MeterSubtitleTextColorOutline]
Meter=Image
MeterStyle=sColorOutline

[MeterSubtitleTextColor]
Meter=Image
MeterStyle=sColorBarPos
SolidColor=#colorSubtitleText#
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "setColor('#CURRENTSECTION#', 'colorSubtitleText')"]

;=====================
;=== STREAMS TEXT ====
;=====================

[MeterStreamNameHelp]
Meter=Image
MeterStyle=sHelpHoverIMG
X=265
Y=96
MouseOverAction=[!SetOption #CURRENTSECTION# ImageAlpha 255][!CommandMeasure MeasureOptionsLUA "helpHover('StreamName')"]

[MeterStreamNameText]
Meter=String
MeterStyle=sMainText
Text=Stream Name

[MeterStreamNameColorOutline]
Meter=Image
MeterStyle=sColorOutline

[MeterStreamNameColor]
Meter=Image
MeterStyle=sColorBarPos
SolidColor=#colorStreamName#
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "setColor('#CURRENTSECTION#', 'colorStreamName')"]

;=====================
;=== VIEWERS TEXT ====
;=====================

[MeterViewersTextHelp]
Meter=Image
MeterStyle=sHelpHoverIMG
X=298
Y=20r
MouseOverAction=[!SetOption #CURRENTSECTION# ImageAlpha 255][!CommandMeasure MeasureOptionsLUA "helpHover('ViewersText')"]

[MeterViewersText]
Meter=String
MeterStyle=sMainText
Text=Viewers

[MeterViewersTextColorOutline]
Meter=Image
MeterStyle=sColorOutline

[MeterViewersTextColor]
Meter=Image
MeterStyle=sColorBarPos
SolidColor=#colorViewers#
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "setColor('#CURRENTSECTION#', 'colorViewers')"]

;=====================
;=== PLAYING TEXT ====
;=====================

[MeterPlayingTextHelp]
Meter=Image
MeterStyle=sHelpHoverIMG
X=265
Y=20r
MouseOverAction=[!SetOption #CURRENTSECTION# ImageAlpha 255][!CommandMeasure MeasureOptionsLUA "helpHover('PlayingText')"]

[MeterPlayingText]
Meter=String
MeterStyle=sMainText
Text='Playing' Text

[MeterPlayingTextColorOutline]
Meter=Image
MeterStyle=sColorOutline

[MeterPlayingTextColor]
Meter=Image
MeterStyle=sColorBarPos
SolidColor=#colorPlayingText#
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "setColor('#CURRENTSECTION#', 'colorPlayingText')"]

;==================
;=== NOTIF NAME ===
;==================

[MeterNotifNameHelp]
Meter=Image
MeterStyle=sHelpHoverIMG
X=275
Y=20r
MouseOverAction=[!SetOption #CURRENTSECTION# ImageAlpha 255][!CommandMeasure MeasureOptionsLUA "helpHover('NotifName')"]

[MeterNotifNameText]
Meter=String
MeterStyle=sMainText
Text=Notif. Name

[MeterNotifNameColorOutline]
Meter=Image
MeterStyle=sColorOutline

[MeterNotifNameColor]
Meter=Image
MeterStyle=sColorBarPos
SolidColor=#colorNotifName#
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "setColor('#CURRENTSECTION#', 'colorNotifName')"]

;=================
;=== GAME NAME ===
;=================

[MeterGameNameHelp]
Meter=Image
MeterStyle=sHelpHoverIMG
X=274
Y=20r
MouseOverAction=[!SetOption #CURRENTSECTION# ImageAlpha 255][!CommandMeasure MeasureOptionsLUA "helpHover('GameName')"]

[MeterGameNameText]
Meter=String
MeterStyle=sMainText
Text=Game Name

[MeterGameNameColorOutline]
Meter=Image
MeterStyle=sColorOutline

[MeterGameNameColor]
Meter=Image
MeterStyle=sColorBarPos
SolidColor=#colorGameName#
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "setColor('#CURRENTSECTION#', 'colorGameName')"]

;=========================
;=== NOTIF COME ONLINE ===
;=========================

[MeterComeOnlineHelp]
Meter=Image
MeterStyle=sHelpHoverIMG
X=212
Y=20r
MouseOverAction=[!SetOption #CURRENTSECTION# ImageAlpha 255][!CommandMeasure MeasureOptionsLUA "helpHover('ComeOnline')"]

[MeterComeOnlineText]
Meter=String
MeterStyle=sMainText
Text='has come online' Text

[MeterComeOnlineColorOutline]
Meter=Image
MeterStyle=sColorOutline

[MeterComeOnlineColor]
Meter=Image
MeterStyle=sColorBarPos
SolidColor=#colorComeOnline#
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "setColor('#CURRENTSECTION#', 'colorComeOnline')"]

;====================
;=== RESET COLORS ===
;====================

[MeterDefaultHelp]
Meter=Image
MeterStyle=sHelpHoverIMG
X=340
Y=320
MouseOverAction=[!SetOption #CURRENTSECTION# ImageAlpha 255][!CommandMeasure MeasureOptionsLUA "helpHover('Reset')"]

[MeterDefaultButton]
Meter=Button
ButtonImage=#@#Images\Options\OptionsButton.png
ButtonCommand=[!CommandMeasure MeasureOptionsLUA "readColorProfile('defaultColorVars.inc')"]
X=10R
Y=-5r

[MeterDefaultButtonName]
Meter=String
MeterStyle=sMainText
X=([MeterDefaultButton:W] / 2)r
Y=([MeterDefaultButton:H] / 2)r
W=[MeterDefaultButton:W]
StringAlign=CenterCenter
Text=Reset


