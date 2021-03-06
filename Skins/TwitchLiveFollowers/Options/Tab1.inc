[MeasureCheckForLivestreamer]
Measure=Calc
Formula=1
IfCondition= MeasureCheckForLivestreamer = 1
IfTrueAction=[!CommandMeasure MeasureOptionsLUA "detectLivestreamer()"][!DisableMeasure #CURRENTSECTION#]

[MeterTab1Title]
Meter=String
MeterStyle=sMainText | sTabTitle
Text=General Options

;=======================
;=== VIEWERS DISPLAY ===
;=======================

[MeterViewersDisplayHelp]
Meter=Image
MeterStyle=sHelpHoverIMG
X=115
Y=20R
MouseOverAction=[!SetOption #CURRENTSECTION# ImageAlpha 255][!CommandMeasure MeasureOptionsLUA "helpHover('ViewersDisplay')"]

[MeterViewersDisplay]
Meter=String
MeterStyle=sMainText
Text=Viewers Display Format:

[MeterFullButton]
Meter=Image
ImageName=#@#Images\Options\PressedButton.png
X=10R
Y=-5r
H=26
W=40
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "viewersDisplay('Full')"]

[MeterFullButtonName]
Meter=String
MeterStyle=sMainText
X=([MeterFullButton:W] / 2)r
Y=([MeterFullButton:H] / 2)r
W=[MeterFullButton:W]
StringAlign=CenterCenter
Text=Full

[MeterCompactButton]
Meter=Image
ImageName=#@#Images\Options\DepressedButton.png
W=63
H=26
X=([MeterFullButton:W] / 2 + 10)r
Y=(-([MeterFullButton:H] / 2))r
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "viewersDisplay('Compact')"]

[MeterCompactButtonName]
Meter=String
MeterStyle=sMainText
X=([MeterCompactButton:W] / 2)r
Y=([MeterCompactButton:H] / 2)r
W=[MeterCompactButton:W]
StringAlign=CenterCenter
Text=Compact

;==================
;=== THUMBNAILS ===
;==================

[MeterThumbnailHelp]
Meter=Image
MeterStyle=sHelpHoverIMG
X=188
Y=25r
MouseOverAction=[!SetOption #CURRENTSECTION# ImageAlpha 255][!CommandMeasure MeasureOptionsLUA "helpHover('Thumbnails')"]

[MeterThumbnail]
Meter=String
MeterStyle=sMainText
Text=Thumbnails:

[MeterOnButton]
Meter=Image
ImageName=#@#Images\Options\PressedButton.png
X=10R
Y=-5r
W=40
H=26
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "thumbnails('On')"]

[MeterOnButtonName]
Meter=String
MeterStyle=sMainText
X=([MeterOnButton:W] / 2)r
Y=([MeterOnButton:H] / 2)r
W=[MeterOnButton:W]
StringAlign=CenterCenter
Text=On

[MeterOffButton]
Meter=Image
ImageName=#@#Images\Options\DepressedButton.png
X=([MeterOnButton:W] / 2 + 10)r
Y=(-([MeterOnButton:H] / 2))r
W=40
H=26
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "thumbnails('Off')"]

[MeterOffButtonName]
Meter=String
MeterStyle=sMainText
X=([MeterOffButton:W] / 2)r
Y=([MeterOffButton:H] / 2)r
StringAlign=CenterCenter
Text=Off

;=====================
;=== NOTIFICATIONS ===
;=====================

[MeterNotificationHelp]
Meter=Image
MeterStyle=sHelpHoverIMG
X=139
Y=25r
MouseOverAction=[!SetOption #CURRENTSECTION# ImageAlpha 255][!CommandMeasure MeasureOptionsLUA "helpHover('OnlineNotifications')"]

[MeterNotification]
Meter=String
MeterStyle=sMainText
Text=Online Notifications:

[MeterNotifOnButton]
Meter=Image
ImageName=#@#Images\Options\PressedButton.png
X=10R
Y=-5r
W=40
H=26
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "onlineNotifications('On')"]

[MeterNotifOnButtonName]
Meter=String
MeterStyle=sMainText
X=([MeterNotifOnButton:W] / 2)r
Y=([MeterNotifOnButton:H] / 2)r
W=[MeterNotifOnButton:W]
StringAlign=CenterCenter
Text=On

[MeterNotifOffButton]
Meter=Image
ImageName=#@#Images\Options\DepressedButton.png
X=([MeterNotifOnButton:W] / 2 + 10)r
Y=(-([MeterNotifOnButton:H] / 2))r
W=40
H=26
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "onlineNotifications('Off')"]

[MeterNotifOffButtonName]
Meter=String
MeterStyle=sMainText
X=([MeterNotifOffButton:W] / 2)r
Y=([MeterNotifOffButton:H] / 2)r
StringAlign=CenterCenter
Text=Off

;============================
;=== LIVESTREAMER QUALITY ===
;============================

[MeterQualityHelp]
Meter=Image
MeterStyle=sHelpHoverIMG | sLivestreamer
X=131
Y=25r
MouseOverAction=[!SetOption #CURRENTSECTION# ImageAlpha 255][!CommandMeasure MeasureOptionsLUA "helpHover('Quality')"]

[MeterQualityText]
Meter=String
MeterStyle=sMainText | sLivestreamer
Text=Livestreamer Quality:

[MeterSourceButton]
Meter=Image
MeterStyle=sLivestreamer
ImageName=#@#Images\Options\PressedButton.png
W=55
H=26
X=115
Y=10R
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "livestreamerQuality('Source')"]

[MeterSourceButtonName]
Meter=String
MeterStyle=sMainText | sLivestreamer
X=([MeterSourceButton:W] / 2)r
Y=([MeterSourceButton:H] / 2)r
W=[MeterSourceButton:W]
StringAlign=CenterCenter
Text=Source

[MeterHighButton]
Meter=Image
MeterStyle=sLivestreamer
ImageName=#@#Images\Options\DepressedButton.png
W=45
H=26
X=([MeterSourceButton:W] / 2 + 10)r
Y=(-([MeterSourceButton:H] / 2))r
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "livestreamerQuality('High')"]

[MeterHighButtonName]
Meter=String
MeterStyle=sMainText | sLivestreamer
X=([MeterHighButton:W] / 2)r
Y=([MeterHighButton:H] / 2)r
W=[MeterHighButton:W]
StringAlign=CenterCenter
Text=High

[MeterMediumButton]
Meter=Image
MeterStyle=sLivestreamer
ImageName=#@#Images\Options\DepressedButton.png
W=57
H=26
X=([MeterHighButton:W] / 2 + 10)r
Y=(-([MeterHighButton:H] / 2))r
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "livestreamerQuality('Medium')"]

[MeterMediumButtonName]
Meter=String
MeterStyle=sMainText | sLivestreamer
X=([MeterMediumButton:W] / 2)r
Y=([MeterMediumButton:H] / 2)r
W=[MeterMediumButton:W]
StringAlign=CenterCenter
Text=Medium

[MeterLowButton]
Meter=Image
MeterStyle=sLivestreamer
ImageName=#@#Images\Options\DepressedButton.png
W=42
H=26
X=([MeterMediumButton:W] / 2 + 10)r
Y=(-([MeterMediumButton:H] / 2))r
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "livestreamerQuality('Low')"]

[MeterLowButtonName]
Meter=String
MeterStyle=sMainText | sLivestreamer
X=([MeterLowButton:W] / 2)r
Y=([MeterLowButton:H] / 2)r
W=[MeterLowButton:W]
StringAlign=CenterCenter
Text=Low

[MeterMobileButton]
Meter=Image
MeterStyle=sLivestreamer
ImageName=#@#Images\Options\DepressedButton.png
W=57
H=26
X=([MeterLowButton:W] / 2 + 10)r
Y=(-([MeterLowButton:H] / 2))r
LeftMouseUpAction=[!CommandMeasure MeasureOptionsLUA "livestreamerQuality('Mobile')"]

[MeterMobileButtonName]
Meter=String
MeterStyle=sMainText | sLivestreamer
X=([MeterMobileButton:W] / 2)r
Y=([MeterMobileButton:H] / 2)r
W=[MeterMobileButton:W]
StringAlign=CenterCenter
Text=Mobile

