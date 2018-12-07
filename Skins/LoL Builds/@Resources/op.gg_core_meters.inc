[MeterChampion]
Meter=String
X=(#XChampion#-3)
Y=#YChampion#
H=25
W=122
FontSize=14
FontColor=205,190,145,255
FontFace=Segoe UI
AntiAlias=1
DynamicVariables=1
StringCase=Proper
Text=#Champion#
LeftMouseUpAction=[!CommandMeasure "MeasureChampion" "ExecuteBatch ALL"][!SetVariable AutoDetection -1]

[MeterSelectedLane]
Meter=Image
DynamicVariables=1
X=(#XLane#+[MeasureSelectedLane]-1)
Y=(#YLane#-1)
SolidColor=12C4D4
W=(#LaneSize#+2)
H=(#LaneSize#+2)

[MeterTop]
Meter=Image
ImageName=#@#top.png
X=#XLane#
Y=#YLane#
H=#LaneSize#
W=#LaneSize#
LeftMouseUpAction=[!SetVariable Lane "TOP"][!SetVariable AutoDetection -1]

[MeterJungle]
Meter=Image
ImageName=#@#jungle.png
X=(#XLane#+25)
Y=#YLane#
H=#LaneSize#
W=#LaneSize#
LeftMouseUpAction=[!SetVariable Lane "JUNGLE"][!SetVariable AutoDetection -1]

[MeterMid]
Meter=Image
ImageName=#@#mid.png
X=(#XLane#+50)
Y=#YLane#
H=#LaneSize#
W=#LaneSize#
LeftMouseUpAction=[!SetVariable Lane "MID"][!SetVariable AutoDetection -1]

[MeterBot]
Meter=Image
ImageName=#@#bot.png
X=(#XLane#+75)
Y=#YLane#
H=#LaneSize#
W=#LaneSize#
LeftMouseUpAction=[!SetVariable Lane "BOT"][!SetVariable AutoDetection -1]

[MeterSupport]
Meter=Image
ImageName=#@#support.png
X=(#XLane#+100)
Y=#YLane#
H=#LaneSize#
W=#LaneSize#
LeftMouseUpAction=[!SetVariable Lane "SUPPORT"][!SetVariable AutoDetection -1]

[MeterChampionIcon]
Meter=Image
MeasureName=MeasureChampionIcon
X=5
Y=5
H=#ChampionIconSize#
W=#ChampionIconSize#

[MeterSkillOrder]
Meter=String
MeasureName=MeasureSkill1
MeasureName2=MeasureSkill2
MeasureName3=MeasureSkill3
X=5
Y=65
FontSize=12
FontFace=Segoe UI
FontColor=205,190,145,255
AntiAlias=1
Text=Skill Order:#CRLF#%1 > %2 > %3

[MeterItem]
Meter=String
X=197
Y=0
FontSize=10
FontFace=Segoe UI
FontColor=205,190,145,255
AntiAlias=1
Text=Items:

[MeterItem1]
Meter=Image
MeasureName=MeasureItem1
X=200
Y=#YItem#
H=#ItemSize#
W=#ItemSize#

[MeterItem2]
Meter=Image
MeasureName=MeasureItem2
X=245
Y=#YItem#
H=#ItemSize#
W=#ItemSize#

[MeterItem3]
Meter=Image
MeasureName=MeasureItem3
X=290
Y=#YItem#
H=#ItemSize#
W=#ItemSize#

[MeterBootsText]
Meter=String
X=347
Y=0
FontSize=10
FontFace=Segoe UI
FontColor=205,190,145,255
AntiAlias=1
Text=Boots:

[MeterBoots]
Meter=Image
MeasureName=MeasureBoots
X=350
Y=#YItem#
H=#ItemSize#
W=#ItemSize#

[MeterRunes]
Meter=String
X=197
Y=60
FontSize=10
FontFace=Segoe UI
FontColor=205,190,145,255
AntiAlias=1
Text=Runes:

[MeterKeystoneBackground]
Meter=Roundline
X=200
Y=#YRune#
W=#RuneSize#
H=#RuneSize#
StartAngle=(Rad(270))
RotationAngle=(Rad(360))
LineLength=(#RuneSize#/2)
LineColor=92,91,87,255
Solid=1
AntiAlias=1

[MeterKeystone]
Meter=Image
MeasureName=MeasureKeystone
X=200
Y=#YRune#
H=#RuneSize#
W=#RuneSize#

[MeterRune1]
Meter=Image
MeasureName=MeasureRune1
X=260
Y=#YRune#
H=#RuneSize#
W=#RuneSize#

[MeterRune2]
Meter=Image
MeasureName=MeasureRune2
X=305
Y=#YRune#
H=#RuneSize#
W=#RuneSize#

[MeterRune3]
Meter=Image
MeasureName=MeasureRune3
X=350
Y=#YRune#
H=#RuneSize#
W=#RuneSize#

[MeterLoading]
Meter=BitMap
MeasureName=MeasureLoadingFrame
BitMapImage=#@#loading.png
BitmapFrames=5
BitmapExtend=1
Hidden=0
X=158
Y=66
DynamicVariables=1