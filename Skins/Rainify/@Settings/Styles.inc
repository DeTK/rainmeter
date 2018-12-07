[sOutline]
X=0
Y=0
UpdateDivider=10000

[sGradient]
X=5
Y=4
ImageName=#ROOTCONFIGPATH#\@Settings\Gradient.png
UpdateDivider=10000

[sTextArea]
X=5
Y=4
W=200
SolidColor=#color.Skin#

[sButton]
X=16r
Y=8
MouseActionCursor=1
UpdateDivider=10000
Hidden=1

[sTitle]
X=10
Y=10
W=183
H=19
FontColor=#color.Title#
FontEffectColor=00000040
FontFace=#font.Name#
FontSize=11
StringAlign=LEFT
StringCase=NONE
StringStyle=BOLD
StringEffect=SHADOW
ClipString=1
AntiAlias=1

[sLeft]
X=10
Y=-12r
H=14
W=190
ClipString=1
FontColor=#color.Text#
FontEffectColor=00000020
FontFace=#font.Name#
FontSize=#text.Size#
StringAlign=LEFT
StringCase=NONE
StringStyle=BOLD
StringEffect=SHADOW
ToolTipWidth=250
AntiAlias=1

[sRight]
X=200
Y=0r
H=14
W=190
ClipString=1
FontColor=#color.Text#
FontEffectColor=00000020
FontFace=#font.Name#
FontSize=#text.Size#
StringAlign=RIGHT
StringCase=NONE
StringStyle=BOLD
StringEffect=SHADOW
AntiAlias=1

[sBar]
X=5
Y=28r
W=200
H=1
BarColor=#color.Highlight#
SolidColor=00000000
BarOrientation=HORIZONTAL

[sWrench]
ButtonImage=#ROOTCONFIGPATH#\@Settings\Wrench.png
X=195
Y=17
ToolTipText="Change skin settings"
LeftMouseUpAction=!Execute ["#ROOTCONFIGPATH#\@Settings\ConfigTool.exe" /a=page /v=#PAGE# /cc=#CURRENTCONFIG# /pp=#PROGRAMPATH#]
MouseActionCursor=1
UpdateDivider=10000
Hidden=1

[sClose]
ButtonImage=#ROOTCONFIGPATH#\@Settings\Close.png
X=195
Y=7
ToolTipText="Close skin"
LeftMouseUpAction=!Execute [!RainmeterDeactivateConfig]
MouseActionCursor=1
UpdateDivider=10000
Hidden=1