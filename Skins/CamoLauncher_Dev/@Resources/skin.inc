[Rainmeter]
Update=100
DynamicWindowSize=1
LeftMouseDoubleClickAction=[!SetVariable "bg" "#@#Images\0.png"][!Update][!CommandMeasure "MeasureName" "FollowPath"][!UpdateMeasure *][!UpdateMeter *][!Redraw]
MouseScrollUpAction=[!CommandMeasure "MeasurePath" "IndexUp"][!UpdateMeasure MeasurePath][!UpdateMeasure *][!UpdateMeter *][!Redraw]
MouseScrollDownAction=[!CommandMeasure "MeasurePath" "IndexDown"][!UpdateMeasure MeasurePath][!UpdateMeasure *][!UpdateMeter *][!Redraw]
LeftMouseDownAction=[!SetVariable "bg" "#@#Images\2.png"][!Update]
OnUnfocusAction=[!SetVariable "bg" "#@#Images\0.png"][!Update]
MouseOverAction=[!SetVariable "bg" "#@#Images\1.png"][!Update]
MouseLeaveAction=[!SetVariable "bg" "#@#Images\0.png"][!Update]
MouseActionCursor=0
ContextTitle=AddApps
ContextAction=["#Path#"]
ContextTitle2=ChangeVariables
ContextAction2=["#@#Variables.inc"]
ContextTitle3=ChangeSourceCode
ContextAction3=["#@#skin.inc"]
ContextTitle4=OpenFolder
ContextAction4=["#ROOTCONFIGPATH#"]

[Metadata]
Name=CamoLauncher
Author=Aryan Tyagi
Information=False windows-like icon that is actually your app launcher. No one will ever doubt that this is not a regular desktop icon.
Version=2
License=Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)

[Include]
@include=#@#Variables.inc

[TextStyle]
FontFace=#fontface#
FontSize=#fontsize#
FontColor=255,255,255,255
StringAlign=CenterCenter
StringCase=Proper
StringStyle=#stringstyle#
StringEffect=Shadow
ClipString=1
AntiAlias=0

[MeasurePath]
Measure=Plugin
Plugin=FileView
Path="#Path#"
Count=1
HideExtensions=1
ShowDotDot=0
ShowFolder=0
ShowHidden=0
ShowSystem=0

[MeasureName]
Measure=Plugin
Plugin=FileView
Path=[MeasurePath]
Type=FileName
Index=1
HideExtensions=1

[MeasureIcon]
Measure=Plugin
Plugin=FileView
Path=[MeasurePath]
Type=Icon
Index=1

[MeterBase]
Meter=Image
SolidColor=0,0,0,1
W=#Width#
H=#Height#

[MeterBox]
Meter=Image
ImageName=#bg#
Tile=0
PreserveAspectRatio=0
ScaleMargins=3,3,3,3
W=#Width#
H=#Height#
dynamicvariables=1

[MeterName]
Meter=String
MeasureName=MeasureName
MeterStyle=TextStyle
Text=%1
W=(#Width#-3)
H=(#fontsize#+3)
X=(#Width#/2)
Y=(#Height#*(4/5))

[MeterIcon]
Meter=Image
MeasureName=MeasureIcon
ImageName=%1
W=#IconSize#
H=#IconSize#
X=((#Width#/2)-(#IconSize#/2))
Y=(#Height#*(1/20))