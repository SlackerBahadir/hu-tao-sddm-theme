import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1920
    height: 1080
    
    property int sessionIndex: session.index
    
    // Fallback gradient background with more Hu Tao-inspired colors
    Rectangle {
        id: fallbackBackground
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#0d0a0f" }  // Deep purple-black
            GradientStop { position: 0.3; color: "#1a0d14" }  // Dark burgundy
            GradientStop { position: 0.6; color: "#2d1419" }  // Rich maroon
            GradientStop { position: 1.0; color: "#4a1c1c" }  // Darker red
        }
    }
    
    // Animated ghost particles background
    Item {
        anchors.fill: parent
        z: 10  // Ensure particles are above background and overlay
        
        Repeater {
            model: 12
            
            Rectangle {
                id: ghostParticle
                width: 6 + Math.random() * 8
                height: width
                radius: width / 2
                color: "#ff6b6b"
                opacity: backgroundImage.visible ? (0.3 + Math.random() * 0.4) : (0.2 + Math.random() * 0.3)
                
                property real baseX: Math.random() * root.width
                property real baseY: Math.random() * root.height
                property real speed: 0.5 + Math.random() * 1.5
                
                x: baseX
                y: baseY
                
                // Floating animation
                SequentialAnimation on y {
                    loops: Animation.Infinite
                    NumberAnimation { 
                        to: ghostParticle.baseY - 50 - Math.random() * 100
                        duration: 3000 + Math.random() * 2000
                        easing.type: Easing.InOutSine 
                    }
                    NumberAnimation { 
                        to: ghostParticle.baseY
                        duration: 3000 + Math.random() * 2000
                        easing.type: Easing.InOutSine 
                    }
                }
                
                // Opacity pulsing
                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    NumberAnimation { 
                        to: backgroundImage.visible ? 0.2 : 0.1
                        duration: 2000 + Math.random() * 1500
                        easing.type: Easing.InOutSine 
                    }
                    NumberAnimation { 
                        to: backgroundImage.visible ? 0.7 : 0.6
                        duration: 2000 + Math.random() * 1500
                        easing.type: Easing.InOutSine 
                    }
                }
            }
        }
    }
    
    // Background image (only visible if source is valid and loaded)
    Image {
        id: backgroundImage
        anchors.fill: parent
        source: {
            if (config.Background) {
                var bg = config.Background.toString()
                if (bg.startsWith("/") || bg.startsWith("file://")) {
                    return bg
                }
                return Qt.resolvedUrl(bg)
            }
            return ""
        }
        fillMode: Image.PreserveAspectCrop
        visible: status === Image.Ready && source != ""
        asynchronous: true
    }
    
    // Dark overlay with gradient for better text readability
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.4; color: "#22000000" }
            GradientStop { position: 1.0; color: "#44000000" }
        }
        visible: backgroundImage.visible
    }
    
    // Butterfly pattern overlay with better animation
    Item {
        anchors.fill: parent
        opacity: backgroundImage.visible ? 0.2 : 0.15
        z: 5  // Above background but below particles
        
        Repeater {
            model: 8
            
            Item {
                id: butterflyContainer
                width: 30
                height: 30
                x: Math.random() * (root.width - 30)
                y: Math.random() * (root.height - 30)
                
                property real angle: 0
                
                // Butterfly shape using two circles
                Row {
                    spacing: -5
                    anchors.centerIn: parent
                    
                    Rectangle {
                        width: 12
                        height: 18
                        color: "#ff6b6b"
                        opacity: 0.4
                        radius: 6
                        transform: Rotation { angle: -20 }
                    }
                    Rectangle {
                        width: 12
                        height: 18
                        color: "#ff6b6b"
                        opacity: 0.4
                        radius: 6
                        transform: Rotation { angle: 20 }
                    }
                }
                
                // Floating movement
                SequentialAnimation on x {
                    loops: Animation.Infinite
                    NumberAnimation { 
                        to: butterflyContainer.x + 50 + Math.random() * 100
                        duration: 4000 + Math.random() * 3000
                        easing.type: Easing.InOutSine 
                    }
                    NumberAnimation { 
                        to: butterflyContainer.x
                        duration: 4000 + Math.random() * 3000
                        easing.type: Easing.InOutSine 
                    }
                }
                
                SequentialAnimation on y {
                    loops: Animation.Infinite
                    NumberAnimation { 
                        to: butterflyContainer.y - 30 - Math.random() * 50
                        duration: 3000 + Math.random() * 2000
                        easing.type: Easing.InOutSine 
                    }
                    NumberAnimation { 
                        to: butterflyContainer.y + 30 + Math.random() * 50
                        duration: 3000 + Math.random() * 2000
                        easing.type: Easing.InOutSine 
                    }
                }
                
                // Wing flapping
                SequentialAnimation on scale {
                    loops: Animation.Infinite
                    NumberAnimation { to: 1.1; duration: 300 }
                    NumberAnimation { to: 0.9; duration: 300 }
                }
            }
        }
    }
    
    // Main container with enhanced styling
    Rectangle {
        id: mainContainer
        anchors.centerIn: parent
        width: 420
        height: 580
        color: "#2a1717"
        radius: 25
        border.color: "#ff6b6b"
        border.width: 2
        opacity: 0.96
        z: 20  // Ensure login form is above everything
        
        // Glowing border effect
        Rectangle {
            anchors.fill: parent
            anchors.margins: -3
            color: "transparent"
            border.color: "#ff6b6b"
            border.width: 1
            radius: 28
            opacity: 0.3
            z: -1
        }
        
        // Entrance animation
        NumberAnimation on opacity {
            from: 0
            to: 0.96
            duration: 1000
            easing.type: Easing.OutQuart
        }
        
        NumberAnimation on scale {
            from: 0.7
            to: 1.0
            duration: 800
            easing.type: Easing.OutBack
        }
        
        // Enhanced breathing animation
        SequentialAnimation on border.width {
            loops: Animation.Infinite
            NumberAnimation { to: 3; duration: 2500; easing.type: Easing.InOutSine }
            NumberAnimation { to: 2; duration: 2500; easing.type: Easing.InOutSine }
        }
        
        // Enhanced drop shadow
        Rectangle {
            anchors.fill: parent
            anchors.margins: -8
            color: "#000000"
            opacity: 0.4
            radius: 33
            z: -2
            
            // Subtle shadow animation
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation { to: 0.2; duration: 3000; easing.type: Easing.InOutSine }
                NumberAnimation { to: 0.4; duration: 3000; easing.type: Easing.InOutSine }
            }
        }
        
        Column {
            anchors.fill: parent
            anchors.margins: 40
            spacing: 20
            
            // Enhanced title with subtitle
            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 5
                
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "ようこそ、あなた~"
                    color: "#ff6b6b"
                    font.family: "serif"
                    font.pixelSize: 26
                    font.bold: true
                    
                    NumberAnimation on opacity {
                        from: 0
                        to: 1
                        duration: 1500
                        easing.type: Easing.OutQuart
                    }
                    
                    // Character typing effect
                    property string fullText: "ようこそ、あなた~"
                    property int currentChar: 0
                    
                    Timer {
                        id: typingTimer
                        interval: 150
                        repeat: true
                        running: true
                        onTriggered: {
                            if (parent.currentChar < parent.fullText.length) {
                                parent.text = parent.fullText.substring(0, parent.currentChar + 1)
                                parent.currentChar++
                            } else {
                                stop()
                            }
                        }
                    }
                    
                    Component.onCompleted: {
                        text = ""
                        currentChar = 0
                        typingTimer.start()
                    }
                }
                
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "~ Wangsheng Funeral Parlor Login ~"
                    color: "#ffcc99"
                    font.family: "serif"
                    font.pixelSize: 14
                    font.italic: true
                    opacity: 0.8
                    
                    NumberAnimation on opacity {
                        from: 0
                        to: 0.8
                        duration: 2000
                        easing.type: Easing.OutQuart
                    }
                }
            }
            
            Item { height: 15 } // Spacer
            
            // Enhanced username input field
            Column {
                width: parent.width
                spacing: 8
                
                Text {
                    text: "Spirit Name:"
                    color: "#ffcc99"
                    font.pixelSize: 15
                    font.bold: true
                }
                
                Rectangle {
                    id: usernameField
                    width: parent.width
                    height: 48
                    color: "#3d2424"
                    border.color: usernameInput.focus ? "#ff8888" : "#663333"
                    border.width: 2
                    radius: 12
                    
                    // Glow effect when focused
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -2
                        color: "transparent"
                        border.color: "#ff6b6b"
                        border.width: 1
                        radius: 14
                        opacity: usernameInput.focus ? 0.4 : 0
                        
                        Behavior on opacity {
                            NumberAnimation { duration: 300 }
                        }
                    }
                    
                    Behavior on border.color {
                        ColorAnimation { duration: 300 }
                    }
                    
                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.color = "#4a3030"
                        onExited: parent.color = "#3d2424"
                        onClicked: usernameInput.forceActiveFocus()
                    }
                    
                    TextInput {
                        id: usernameInput
                        anchors.fill: parent
                        anchors.margins: 12
                        verticalAlignment: TextInput.AlignVCenter
                        color: "#ffcc99"
                        font.pixelSize: 16
                        text: userModel.lastUser || ""
                        
                        Keys.onPressed: {
                            if (event.key === Qt.Key_Tab) {
                                passwordInput.focus = true
                                event.accepted = true
                            }
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                passwordInput.focus = true
                                event.accepted = true
                            }
                        }
                    }
                    
                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Enter your spirit name..."
                        color: "#997755"
                        font.pixelSize: 16
                        visible: usernameInput.text.length === 0 && !usernameInput.focus
                        opacity: 0.7
                    }
                }
            }
            
            // Enhanced password field
            Column {
                width: parent.width
                spacing: 8
                
                Text {
                    text: "Secret Incantation:"
                    color: "#ffcc99"
                    font.pixelSize: 15
                    font.bold: true
                }
                
                Rectangle {
                    id: passwordField
                    width: parent.width
                    height: 48
                    color: "#3d2424"
                    border.color: passwordInput.focus ? "#ff8888" : "#663333"
                    border.width: 2
                    radius: 12
                    
                    // Glow effect when focused
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -2
                        color: "transparent"
                        border.color: "#ff6b6b"
                        border.width: 1
                        radius: 14
                        opacity: passwordInput.focus ? 0.4 : 0
                        
                        Behavior on opacity {
                            NumberAnimation { duration: 300 }
                        }
                    }
                    
                    Behavior on border.color {
                        ColorAnimation { duration: 300 }
                    }
                    
                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.color = "#4a3030"
                        onExited: parent.color = "#3d2424"
                        onClicked: passwordInput.forceActiveFocus()
                    }
                    
                    TextInput {
                        id: passwordInput
                        anchors.fill: parent
                        anchors.margins: 12
                        verticalAlignment: TextInput.AlignVCenter
                        color: "#ffcc99"
                        font.pixelSize: 16
                        echoMode: TextInput.Password
                        
                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                loginButton.login()
                                event.accepted = true
                            }
                            if (event.key === Qt.Key_Tab) {
                                usernameInput.focus = true
                                event.accepted = true
                            }
                        }
                    }
                    
                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Whisper your secret..."
                        color: "#997755"
                        font.pixelSize: 16
                        visible: passwordInput.text.length === 0 && !passwordInput.focus
                        opacity: 0.7
                    }
                }
            }
            
            Item { height: 15 } // Spacer
            
            // Enhanced login button with better effects
            Rectangle {
                id: loginButton
                width: parent.width
                height: 55
                radius: 15
                border.color: "#ffcc99"
                border.width: 2
                
                gradient: Gradient {
                    GradientStop { 
                        position: 0.0
                        color: mouseArea3.pressed ? "#cc5555" : (mouseArea3.containsMouse ? "#ff7777" : "#ff6b6b")
                    }
                    GradientStop { 
                        position: 1.0
                        color: mouseArea3.pressed ? "#aa4444" : (mouseArea3.containsMouse ? "#ee6666" : "#dd5555")
                    }
                }
                
                function login() {
                    sddm.login(usernameInput.text, passwordInput.text, sessionCombo.currentIndex)
                }
                
                Behavior on scale {
                    NumberAnimation { duration: 150 }
                }
                
                // Enhanced hover animation
                SequentialAnimation on scale {
                    running: mouseArea3.containsMouse
                    loops: Animation.Infinite
                    NumberAnimation { to: 1.03; duration: 1000; easing.type: Easing.InOutSine }
                    NumberAnimation { to: 1.0; duration: 1000; easing.type: Easing.InOutSine }
                }
                
                // Glow effect
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: -3
                    color: "transparent"
                    border.color: "#ff6b6b"
                    border.width: 1
                    radius: 18
                    opacity: mouseArea3.containsMouse ? 0.5 : 0
                    
                    Behavior on opacity {
                        NumberAnimation { duration: 300 }
                    }
                }
                
                Text {
                    anchors.centerIn: parent
                    text: "Enter the Afterlife... I mean, Login!"
                    color: "#2a1717"
                    font.pixelSize: 17
                    font.bold: true
                }
                
                MouseArea {
                    id: mouseArea3
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        loginButton.scale = 0.95
                        scaleBackTimer.start()
                        loginButton.login()
                    }
                    
                    Timer {
                        id: scaleBackTimer
                        interval: 100
                        onTriggered: loginButton.scale = 1.0
                    }
                }
            }
            
            // Enhanced error message with animation
            Rectangle {
                width: parent.width
                height: errorMessage.visible ? errorMessage.height + 16 : 0
                color: "#442222"
                border.color: "#ff4444"
                border.width: errorMessage.visible ? 1 : 0
                radius: 8
                visible: errorMessage.text !== ""
                
                Behavior on height {
                    NumberAnimation { duration: 300; easing.type: Easing.OutQuart }
                }
                
                Text {
                    id: errorMessage
                    anchors.centerIn: parent
                    width: parent.width - 16
                    text: ""
                    color: "#ff6666"
                    font.pixelSize: 14
                    font.bold: true
                    wrapMode: Text.Wrap
                    horizontalAlignment: Text.AlignHCenter
                    visible: text !== ""
                }
            }
            
            Item { height: 10 } // Spacer
            
            // Enhanced session selection
            Column {
                width: parent.width
                spacing: 8
                
                Text {
                    text: "Choose Your Realm:"
                    color: "#ffcc99"
                    font.pixelSize: 15
                    font.bold: true
                }
                
                Rectangle {
                    id: sessionCombo
                    width: parent.width
                    height: 45
                    color: "#3d2424"
                    border.color: "#663333"
                    border.width: 2
                    radius: 12
                    
                    property int currentIndex: 0
                    property string currentText: "Loading realms..."
                    property bool expanded: false
                    
                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                    
                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        text: sessionCombo.currentText
                        color: "#ffcc99"
                        font.pixelSize: 15
                    }
                    
                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        text: sessionCombo.expanded ? "👻" : "🌸"
                        font.pixelSize: 16
                        
                        SequentialAnimation on rotation {
                            running: sessionCombo.expanded
                            loops: Animation.Infinite
                            NumberAnimation { to: 360; duration: 2000 }
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.color = "#4a3030"
                        onExited: parent.color = "#3d2424"
                        onClicked: {
                            sessionCombo.expanded = !sessionCombo.expanded
                            sessionDropdown.visible = sessionCombo.expanded
                        }
                    }
                    
                    Rectangle {
                        id: sessionDropdown
                        anchors.top: parent.bottom
                        anchors.topMargin: 5
                        width: parent.width
                        height: Math.min(sessionList.contentHeight + 10, 200)
                        color: "#3d2424"
                        border.color: "#663333"
                        border.width: 2
                        radius: 12
                        visible: false
                        z: 100
                        opacity: 0
                        
                        Behavior on opacity {
                            NumberAnimation { duration: 300; easing.type: Easing.OutQuart }
                        }
                        
                        onVisibleChanged: {
                            opacity = visible ? 1 : 0
                        }
                        
                        ListView {
                            id: sessionList
                            anchors.fill: parent
                            anchors.margins: 8
                            model: sessionModel
                            clip: true
                            
                            delegate: Rectangle {
                                width: sessionList.width
                                height: 40
                                color: mouseArea2.containsMouse ? "#ff6b6b" : "transparent"
                                opacity: mouseArea2.containsMouse ? 0.9 : 1
                                radius: 8
                                
                                Behavior on color {
                                    ColorAnimation { duration: 200 }
                                }
                                
                                Text {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: model.name || ("Realm " + index)
                                    color: mouseArea2.containsMouse ? "#2a1717" : "#ffcc99"
                                    font.pixelSize: 15
                                    font.bold: mouseArea2.containsMouse
                                }
                                
                                MouseArea {
                                    id: mouseArea2
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: {
                                        sessionCombo.currentIndex = index
                                        sessionCombo.currentText = model.name || ("Realm " + index)
                                        sessionCombo.expanded = false
                                        sessionDropdown.visible = false
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Enhanced bottom info bar
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 70
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.3; color: "#11000000" }
            GradientStop { position: 1.0; color: "#1a0d0d" }
        }
        
        Row {
            anchors.left: parent.left
            anchors.leftMargin: 25
            anchors.verticalCenter: parent.verticalCenter
            spacing: 25
            
            // Enhanced time display
            Column {
                spacing: 2
                
                Text {
                    id: timeText
                    color: "#ffcc99"
                    font.pixelSize: 20
                    font.bold: true
                    
                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: {
                            timeText.text = Qt.formatDateTime(new Date(), "hh:mm:ss")
                        }
                    }
                    
                    Component.onCompleted: {
                        text = Qt.formatDateTime(new Date(), "hh:mm:ss")
                    }
                }
                
                Text {
                    text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
                    color: "#cc9966"
                    font.pixelSize: 12
                    opacity: 0.8
                }
            }
        }
        
        Row {
            anchors.right: parent.right
            anchors.rightMargin: 25
            anchors.verticalCenter: parent.verticalCenter
            spacing: 15
            
            // Enhanced power buttons
            Rectangle {
                id: shutdownButton
                width: 50
                height: 50
                color: shutdownMouse.pressed ? "#cc5555" : (shutdownMouse.containsMouse ? "#ff7777" : "transparent")
                radius: 25
                border.color: "#ff6b6b"
                border.width: 2
                
                Text {
                    anchors.centerIn: parent
                    text: "⚰️"
                    font.pixelSize: 20
                }
                
                MouseArea {
                    id: shutdownMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: sddm.powerOff()
                }
                
                SequentialAnimation on scale {
                    running: shutdownMouse.containsMouse
                    loops: Animation.Infinite
                    NumberAnimation { to: 1.1; duration: 800; easing.type: Easing.InOutSine }
                    NumberAnimation { to: 1.0; duration: 800; easing.type: Easing.InOutSine }
                }
            }
            
            Rectangle {
                id: rebootButton
                width: 50
                height: 50
                color: rebootMouse.pressed ? "#cc5555" : (rebootMouse.containsMouse ? "#ff7777" : "transparent")
                radius: 25
                border.color: "#ff6b6b"
                border.width: 2
                
                Text {
                    anchors.centerIn: parent
                    text: "🔄"
                    font.pixelSize: 18
                }
                
                MouseArea {
                    id: rebootMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: sddm.reboot()
                }
                
                SequentialAnimation on scale {
                    running: rebootMouse.containsMouse
                    loops: Animation.Infinite
                    NumberAnimation { to: 1.1; duration: 800; easing.type: Easing.InOutSine }
                    NumberAnimation { to: 1.0; duration: 800; easing.type: Easing.InOutSine }
                }
            }
        }
    }
    
    
    // Animation sequences
    SequentialAnimation {
        id: shakeAnimation
        NumberAnimation { target: mainContainer; property: "x"; to: mainContainer.x - 10; duration: 100 }
        NumberAnimation { target: mainContainer; property: "x"; to: mainContainer.x + 10; duration: 100 }
        NumberAnimation { target: mainContainer; property: "x"; to: mainContainer.x - 5; duration: 100 }
        NumberAnimation { target: mainContainer; property: "x"; to: mainContainer.x; duration: 100 }
    }
    
    SequentialAnimation {
        id: successAnimation
        NumberAnimation { target: mainContainer; property: "scale"; to: 1.05; duration: 200 }
        NumberAnimation { target: mainContainer; property: "scale"; to: 1.0; duration: 200 }
    }
    
    // Click outside to close dropdowns
    MouseArea {
        anchors.fill: parent
        onClicked: {
            sessionCombo.expanded = false
            sessionDropdown.visible = false
        }
        z: -1
    }
    
    // Connect to SDDM signals
    Connections {
        target: sddm
        
        function onLoginFailed() {
            errorMessage.text = "Even the spirits reject this combination! Try again~"
            // Shake animation for error
            shakeAnimation.start()
            passwordInput.text = ""
            passwordInput.focus = true
        }
        
        function onLoginSucceeded() {
            errorMessage.text = ""
            // Success animation
            successAnimation.start()
        }
    }
    
    Component.onCompleted: {
        // Set default session
        if (sessionModel.count > 0) {
            var defaultIndex = sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0
            sessionCombo.currentIndex = defaultIndex
            
            var sessionName = sessionModel.data(sessionModel.index(defaultIndex, 0), Qt.DisplayRole)
            if (!sessionName) {
                sessionName = sessionModel.data(sessionModel.index(defaultIndex, 0), 0x0100)
                if (!sessionName) {
                    sessionName = sessionModel.data(sessionModel.index(defaultIndex, 0))
                }
            }
            
            sessionCombo.currentText = sessionName || ("Realm " + defaultIndex)
        }
        
        // Focus logic
        if (usernameInput.text.length > 0) {
            passwordInput.forceActiveFocus()
        } else {
            usernameInput.forceActiveFocus()
        }
    }
}
