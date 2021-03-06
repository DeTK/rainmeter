[MeasureValidateToken]
Measure=Plugin
Plugin=WebParser
URL=https://api.twitch.tv/kraken?oauth_token=#OAuth_Token#
RegExp=(?siU)^(.*)$
UpdateRate=2000
FinishAction=[!CommandMeasure MeasureOptionsLUA "validateKey()"]

[MeasureCheckVersion]
Measure=Plugin
Plugin=WebParser
URL=http://www.wallboy.ca/rainmeter/versioncheck.json
RegExp=(?siU)^(.*)$
UpdateRate=2000
FinishAction=[!CommandMeasure MeasureOptionsLUA "checkVersion()"]

[MeasureCheckSupport]
Measure=Plugin
Plugin=WebParser
URL=http://www.wallboy.ca/rainmeter/onlinesupport.php
RegExp=(?siU)^(.*)$
UpdateRate=2000
FinishAction=[!CommandMeasure MeasureOptionsLUA "checkSupport()"]

[MeterTab3Title]
Meter=String
MeterStyle=sMainText | sTabTitle
Text=About

;================
;=== TOP INFO ===
;================

[MeterAuthorText]
Meter=String
MeterStyle=sMainText
StringAlign=Right
StringStyle=Normal
X=110
Y=85
Text=Author:

[MeterAuthor]
Meter=String
MeterStyle=sMainText
FontSize=9
X=15r
Text=Wallboy

[MeterVersionText]
Meter=String
MeterStyle=sMainText
StringAlign=Right
StringStyle=Normal
X=110
Y=2R
Text=Version:

[MeterVersion]
Meter=String
MeterStyle=sMainText
FontSize=9
X=15r
Text=0.92 Beta

[MeterVersionCheck]
Meter=String
MeterStyle=sMainText
StringStyle=Italic
X=5R
Y=0r
Text=(Checking for Update...)

[MeterVersionDateText]
Meter=String
MeterStyle=sMainText
StringAlign=Right
StringStyle=Normal
X=110
Y=2R
Text=Version Date:

[MeterVersionDate]
Meter=String
MeterStyle=sMainText
FontSize=9
X=15r
Text=August 20th, 2015

[MeterLicenseText]
Meter=String
MeterStyle=sMainText
StringStyle=Normal
StringAlign=Right
X=110
Y=2R
Text=License:

[MeterLicense]
Meter=String
MeterStyle=sMainText
FontSize=9
FontColor=0,0,255
StringStyle=Normal
X=15r
Text=Creative Commons BY-NC-SA 4.0
ToolTipText=Click to view more information about the license
LeftMouseUpAction=["http://creativecommons.org/licenses/by-nc-sa/4.0/"]

[MeterWebsiteText]
Meter=String
MeterStyle=sMainText
StringStyle=Normal
StringAlign=Right
X=110
Y=2R
Text=Website:

[MeterWebsite]
Meter=String
MeterStyle=sMainText
FontSize=9
StringStyle=Normal
FontColor=0,0,255
X=15r
Text=wallboy.ca/rainmeter/
ToolTipText=Visit the website for the skin for support, FAQ, and other information
LeftMouseUpAction=["http://www.wallboy.ca/rainmeter/"]

[MeterChangeLogText]
Meter=String
MeterStyle=sMainText
StringStyle=Normal
StringAlign=Right
X=110
Y=2R
Text=ChangeLog:

[MeterChangeLog]
Meter=String
MeterStyle=sMainText
FontSize=9
FontColor=0,0,255
StringStyle=Normal
X=15r
Text=View ChangeLog/About
ToolTipText=View the change log and about information
LeftMouseUpAction=["#ROOTCONFIGPATH#About-ChangeLog.txt"]

[MeterContactText]
Meter=String
MeterStyle=sMainText
StringStyle=Normal
StringAlign=Right
X=110
Y=2R
Text=Contact:

[MeterContact]
Meter=String
MeterStyle=sMainText
FontSize=9
StringStyle=Normal
FontColor=0,0,255
X=15r
Text=Contact the author
ToolTipText=Contact the author for support/suggestions/bugs/etc
LeftMouseUpAction=["http://www.wallboy.ca/rainmeter/contact/"]

[MeterOnlineSupport]
Meter=String
MeterStyle=sMainText
FontSize=8
StringStyle=Italic
FontColor=0,255,0
X=10R
Text=(Live Chat Support Online)
ToolTipText=Live chat support is currently online. Click to visit the website if you need any live support
Hidden=1

;====================
;=== ACCOUNT INFO ===
;====================

[MeterAccountHelp]
Meter=Image
MeterStyle=sHelpHoverIMG
X=30
Y=230
MouseOverAction=[!SetOption #CURRENTSECTION# ImageAlpha 255][!CommandMeasure MeasureOptionsLUA "helpHover('Account')"]

[MeterAccountText]
Meter=String
MeterStyle=sMainText
StringStyle=Normal
StringAlign=Right
X=88R
Y=0r
Text=Your Account:

[MeterAccount]
Meter=String
MeterStyle=sMainText
FontFace=Segoe UI
FontSize=9
H=15
ClipString=2
ClipStringW=215
X=15r
Y=-2r

[MeterAccountChange]
Meter=String
MeterStyle=sMainText
FontColor=0,0,255
StringStyle=Italic
X=5R
Y=2r
Text=(Change)
ToolTipTitle=Change Linked Account
ToolTipText=Click here to view instructions on changing which Twitch account this skin is bound to
ToolTipWidth=300
LeftMouseUpAction=["http://www.wallboy.ca/rainmeter/faq/#changeaccount"][!CommandMeasure MeasureOptionsLUA "changeAccount()"]
Hidden=1

[MeterAccessTokenHelp]
Meter=Image
MeterStyle=sHelpHoverIMG
X=30
Y=250
MouseOverAction=[!SetOption #CURRENTSECTION# ImageAlpha 255][!CommandMeasure MeasureOptionsLUA "helpHover('AccessToken')"]

[MeterAccessTokenText]
Meter=String
MeterStyle=sMainText
StringStyle=Normal
StringAlign=Right
X=88R
Y=0r
Text=Access Token:

[MeterAccessToken]
Meter=String
MeterStyle=sMainText
FontFace=Segoe UI
FontSize=9
X=15r
Y=-2r
H=15
ClipString=2
ClipStringW=270
Text=#OAuth_Token#

[MeterCopyKey]
Meter=String
MeterStyle=sMainText
StringStyle=Italic
FontColor=0,0,255
X=0r
Y=5R
Text=(Copy to Clipboard)
LeftMouseUpAction=[!SetClip #OAuth_Token#]
ToolTipTitle=Copy to Windows Clipboard
ToolTipText=Copies the Access Token. If you're installing the skin on another computer and want to use the same Twitch Account. Use this token instead of generating a new one.
ToolTipWidth=300

[MeterGenerateKey]
Meter=String
MeterStyle=sMainText
FontSize=9
StringStyle=Normal
FontColor=0,0,255
X=125
Y=267
Text=Click here to generate a new Token
Hidden=1
Group=NewToken
LeftMouseUpAction=["https://api.twitch.tv/kraken/oauth2/authorize?response_type=token&client_id=sb0uh7t94m15xyfcri8lyxhlsvx83ts&redirect_uri=http://www.wallboy.ca/rainmeter/access-token&scope=user_read"]

[MeterInputLabelBG]
Meter=Image
W=350
X=50
Y=285
H=26
SolidColor=75,75,75
Hidden=1
Group=NewToken | ChangeAccount

[MeterInputLabel]
Meter=String
W=342
X=([MeterInputLabelBG:W] / 2)r
Y=([MeterInputLabelBG:H] / 2)r
H=20
FontSize=10
FontFace=Verdana
StringStyle=BoldItalic
StringAlign=CenterCenter
SolidColor=255,255,255
AntiAlias=1
MouseActionCursorName=Text
Text=Paste New Access Token and hit Enter
LeftMouseUpAction=[!CommandMeasure "MeasureInputAccessToken" "ExecuteBatch 1-3"]
Hidden=1
Group=NewToken | ChangeAccount
DynamicVariables=1

[MeasureInputAccessToken]
Measure=Plugin
Plugin=InputText
SolidColor=255,255,255
FontColor=0,0,0
FontFace=Segoe UI
FontSize=10
StringStyle=Bold
X=55
Y=289
W=340
H=([MeterInputLabel:H] - 1)
DefaultValue="Paste token and hit Enter"
Command1=[!SetVariable OAuth_Token "$UserInput$"][!SetOption MeasureValidateToken DynamicVariables 0]
Command2=[!SetOption MeterInputLabel Text "Validating Access Token..."][!SetOption MeterInputLabel FontColor 0,0,0][!SetOption MeasureValidateToken FinishAction """[!CommandMeasure MeasureOptionsLUA "validateKey(1)"]"""][!UpdateMeter *][!Redraw]
Command3=[!EnableMeasure MeasureValidateToken][!CommandMeasure MeasureValidateToken Update][!UpdateMeasure MeasureValidateToken]
Command4=[!SetVariable OAuth_Token "$UserInput$"][!SetOption MeasureValidateToken DynamicVariables 0]
Command5=[!SetOption MeterInputLabel Text "Validating Access Token..."][!SetOption MeterInputLabel FontColor 0,0,0][!SetOption MeasureValidateToken FinishAction """[!CommandMeasure MeasureOptionsLUA "validateKey(1,1)"]"""][!UpdateMeter *][!Redraw]
Command6=[!EnableMeasure MeasureValidateToken][!CommandMeasure MeasureValidateToken Update][!UpdateMeasure MeasureValidateToken]
