[MeasureGo]
Measure=Calc
Formula=(#AutoDetection# < 0) && (#CurrentlyLoading# < 0) ? 1 : -1
IfAboveValue=0
IfAboveAction=[!ShowMeter MeterGo]
IfBelowValue=0
IfBelowAction=[!HideMeter MeterGo]
DynamicVariables=1

[MeasureCurrentlyLoading]
Measure=String
String=#CurrentlyLoading#
IfAboveValue=0
IfAboveAction=[!EnableMeasure MeasureLoadingFrame][!ShowMeter MeterLoading][!HideMeter MeterRegExpError]
IfBelowValue=0
IfBelowAction=[!DisableMeasure MeasureLoadingFrame][!HideMeter MeterLoading]
DynamicVariables=1

[MeasureChampion]
Measure=Plugin
Plugin=InputText
SolidColor=0D3D5E
FontColor=205,190,145,255
FontFace=Segoe UI
StringStyle=Italic
FontSize=14
X=(#XChampion#-1)
Y=#YChampion#
H=25
W=122
Command1=!SetVariable Champion "$UserInput$" Y=#YChampion# DefaultValue="Champion"

[MeasureSelectedLane]
Measure=String
String=#Lane#
Substitute="TOP":"0", "JUNGLE":"25", "MID":"50", "ADC":"75", "SUPPORT":"100", "BOT":"75"
DynamicVariables=1

[MeasureBuild]
Measure=WebParser
UpdateRate=-1
DynamicVariables=1
URL=http://euw.op.gg/champion/#Champion#/statistics/#Lane#
RegExp=(?siU)<li class="champion-stats-header__position.*data-position="(.*)">.*<div class="champion-stats-header-info__image">.*<img src="//(.*)".*>.*Recommended Skill Builds.*<li class="champion-stats__list__item tip".*<span>(.*)</span>.*<li class="champion-stats__list__item tip".*<span>(.*)</span>.*<li class="champion-stats__list__item tip".*<span>(.*)</span>.*Recommended Builds.*<li class="champion-stats__list__item tip".*<img src="//(.*)".*>.*<li class="champion-stats__list__item tip".*<img src="//(.*)".*>.*<li class="champion-stats__list__item tip".*<img src="//(.*)".*>.*<strong>(.*)</strong>.*<span>(.*)</span>.*Boots.*<li class="champion-stats__list__item tip".*<img src="//(.*)".*>.*<div class="perk-page__item perk-page__item--keystone perk-page__item--active">.*<img src="//(.*)".*>.*<div class="perk-page__item  perk-page__item--active">.*<img src="//(.*)".*>.*<div class="perk-page__item  perk-page__item--active">.*<img src="//(.*)".*>.*<div class="perk-page__item  perk-page__item--active">.*<img src="//(.*)".*>.*<div class="perk-page__item perk-page__item--mark">.*<img src="//(.*)".*>.*<div class="perk-page__item perk-page__item--active">.*<img src="//(.*)".*>.*<div class="perk-page__item perk-page__item--active">.*<img src="//(.*)".*>
OnRegExpErrorAction=[!ShowMeter MeterRegExpError][!SetVariable CurrentlyLoading -1]
FinishAction=[!HideMeter MeterRegExpError][!SetVariable CurrentlyLoading -1]

[MeasureChampionIcon]
Measure=WebParser
URL=http://[MeasureBuild]
StringIndex=2
Download=1
DownloadFile=Champion.png

[MeasureSkill1]
Measure=WebParser
URL=[MeasureBuild]
StringIndex=3

[MeasureSkill2]
Measure=WebParser
URL=[MeasureBuild]
StringIndex=4

[MeasureSkill3]
Measure=WebParser
URL=[MeasureBuild]
StringIndex=5

[MeasureItem1]
Measure=WebParser
URL=http://[MeasureBuild]
StringIndex=6
Download=1
DownloadFile=Item1.png

[MeasureItem2]
Measure=WebParser
URL=http://[MeasureBuild]
StringIndex=7
Download=1
DownloadFile=Item2.png

[MeasureItem3]
Measure=WebParser
URL=http://[MeasureBuild]
StringIndex=8
Download=1
DownloadFile=Item3.png

[MeasurePickCount]
Measure=WebParser
URL=[MeasureBuild]
StringIndex=10

[MeasurePickCountNumber]
Measure=WebParser
URL=[MeasureBuild]
StringIndex=10
RegExpSubstitute=1
Substitute=^(\d{1,3})\,(\d{1,3})$":"\1\2"

[MeasurePickCountColor]
Measure=Calc
Formula=[MeasurePickCountNumber]
DynamicVariables=1
IfAboveValue=150
IfAboveAction=[!SetOption MeterPickCount FontColor 205,190,145,255]
IfBelowValue=150
IfBelowAction=[!SetOption MeterPickCount FontColor 204,45,45,255]

[MeasureBoots]
Measure=WebParser
URL=http://[MeasureBuild]
StringIndex=11
Download=1
DownloadFile=Boots.png

[MeasureKeystone]
Measure=WebParser
URL=http://[MeasureBuild]
StringIndex=12
Download=1
DownloadFile=Keystone.png

[MeasureRune1]
Measure=WebParser
URL=http://[MeasureBuild]
StringIndex=13
Download=1
DownloadFile=Rune1.png

[MeasureRune2]
Measure=WebParser
URL=http://[MeasureBuild]
StringIndex=14
Download=1
DownloadFile=Rune2.png

[MeasureRune3]
Measure=WebParser
URL=http://[MeasureBuild]
StringIndex=15
Download=1
DownloadFile=Rune3.png

[MeasureLoadingFrame]
Measure=Calc
Formula=Counter %5
Disabled=0