local basicTheme = {
	system = {
		font = love.graphics.newFont(14)
	},
	background = {
		color = { 1, 0, 0, 1 } --PALETTE.black
	},
	text = {
		color = PALETTE.white,
		font = FONTS.robotic,
		align = "left",
	},
	button = {
		color = PALETTE.grey,
		hoverColor = PALETTE.orange_2,
		borderColor = PALETTE.white,
		pressedColor = { PALETTE.orange_2[1] * 0.8, PALETTE.orange_2[2] * 0.8, PALETTE.orange_2[3] * 0.8, 1 },
		textColor = PALETTE.white,
		align = "center",
		cornerRadius = 4,
		elevation = 2,
		elevationHover = 1,
		elevationPressed = 0,
		transitionDuration = 0.25,
	},
	slider = {
		trackColor = { 0.4, 0.4, 0.4 },
		knobColor = { 0.6, 0.6, 0.6 },
		grabColor = { 0.8, 0.8, 0.8 },
		knobRadius = 10,
	},
	switch = {
		offColor = { 0.5, 0.5, 0.5 },
		onColor = { 0, 0.7, 0 },
		knobColor = { 1, 1, 1 },
	},
	checkbox = {
		boxColor = { 0.4, 0.4, 0.4 },
		checkColor = { 0, 0.7, 0 },
		cornerRadius = 4,
	},
	radiobutton = {
		circleColor = { 0.4, 0.4, 0.4 },
		dotColor = { 0, 0.7, 0 },
	},
	grid = {
		color = { 0.5, 0.5, 0.5, 0.3 },
	},
	progressbar = {
		backgroundColor = { 0.2, 0.2, 0.2, 1 },
		fillColor = { 0.15, 0.15, 0.15, 1 },
		borderColor = { 0.25, 0.25, 0.25, 1 },
	},
	icon = {
		color = { 1, 1, 1, 1 },
	},
	dropdown = {
		backgroundColor = { 0.2, 0.2, 0.2, 1 },
		textColor = { 1, 1, 1 },
		align = "left",
		hoverColor = { 0.25, 0.25, 0.25, 1 },
		borderColor = { 0.15, 0.15, 0.15, 1 },
		arrowColor = { 1, 1, 1 },
		scrollBarColor = { 0.5, 0.5, 0.5 },
		scrollBarWidth = 10
	},
	textinput = {
		backgroundColor = { 0.2, 0.2, 0.2 },
		textColor = { 1, 1, 1 },
		cursorColor = { 1, 1, 1 },
		selectionColor = { 0.3, 0.7, 1, 0.5 },
		borderColor = { 0.5, 0.5, 0.5 },
		borderWidth = 2,
		padding = 5
	},
	flexContainer = {
		backgroundColor = { 0.2, 0.2, 0.2, 0.5 },
		borderColor = PALETTE.white,
		borderWidth = 2,
		padding = 0,
		handleSize = 20,
		handleColor = { 0.5, 0.5, 0.5, 1 }
	},
	container = {
		backgroundColor = PALETTE.black,
		borderColor = PALETTE.white,
		borderWidth = 2,
		padding = 0,
		handleSize = 20,
		handleColor = { 0.5, 0.5, 0.5, 1 }
	},
	node = {
		textColor = { 1, 1, 1 },
		backgroundColor = { 0.1, 0.1, 0.1 },
		borderColorHover = { 0.25, 0.25, 0.25, 1 },
		borderColor = { 0.25, 0.25, 0.25, 1 },
		inputPortColor = { 0, 1, 0 },
		outputPortColor = { 1, 0, 0 },
		connectionColor = { 0, 1, 0 },
		connectingColor = { 0.7, 0.7, 0.7 },
	},
	colorpicker = {
		cornerRadius = 4,
		backgroundColor = { 0.2, 0.2, 0.2, 0.8 },
		borderColor = { 0.3, 0.3, 0.3, 1 },
		font = love.graphics.newFont(8, "normal"),
	},
	dialogueWheel = {
		backgroundColor = { 0.2, 0.2, 0.2, 0.8 },
		highlightColor = { 0.4, 0.4, 0.8, 0.9 },
		disabledColor = { 0.3, 0.3, 0.3, 0.8 },
		textColor = { 1, 1, 1, 1 },
		font = love.graphics.newFont(24, "normal"),
		disabledTextColor = { 0.5, 0.5, 0.5, 1 },
		selectedColor = { 0.6, 0.6, 1, 0.9 },
		focusColor = { 1, 1, 1, 0.5 }
	},
	decorator = {
		img = love.graphics.newImage('assets/textures/decorator.png'),
		left = 3,
		right = 12,
		top = 3,
		bottom = 12,
		hoverImg = love.graphics.newImage('assets/textures/decorator-hover.png'),
	}
}
return basicTheme
