package models

type Color int32

const (
	COLOR_BLANK Color = iota
	COLOR_LIGHT_GRAY
	COLOR_GRAY
	COLOR_DARK_GRAY
	COLOR_YELLOW
	COLOR_GOLD
	COLOR_ORANGE
	COLOR_PINK
	COLOR_RED
	COLOR_MAROON
	COLOR_GREEN
	COLOR_LIME
	COLOR_DARK_GREEN
	COLOR_SKY_BLUE
	COLOR_BLUE
	COLOR_DARK_BLUE
	COLOR_PURPLE
	COLOR_VIOLET
	COLOR_DARK_PURPLE
	COLOR_BEIGE
	COLOR_BROWN
	COLOR_DARK_BROWN
	COLOR_WHITE
	COLOR_BLACK
	COLOR_MAGENTA
	COLOR_RAY_WHITE
)

var colors = map[Color]string{
	COLOR_BLANK:       "blank",
	COLOR_LIGHT_GRAY:  "light_gray",
	COLOR_GRAY:        "gray",
	COLOR_DARK_GRAY:   "dark_gray",
	COLOR_YELLOW:      "yellow",
	COLOR_GOLD:        "gold",
	COLOR_ORANGE:      "orange",
	COLOR_PINK:        "pink",
	COLOR_RED:         "red",
	COLOR_MAROON:      "maroon",
	COLOR_GREEN:       "green",
	COLOR_LIME:        "lime",
	COLOR_DARK_GREEN:  "dark_green",
	COLOR_SKY_BLUE:    "sky_blue",
	COLOR_BLUE:        "blue",
	COLOR_DARK_BLUE:   "dark_blue",
	COLOR_PURPLE:      "purple",
	COLOR_VIOLET:      "violet",
	COLOR_DARK_PURPLE: "dark_purple",
	COLOR_BEIGE:       "beige",
	COLOR_BROWN:       "brown",
	COLOR_DARK_BROWN:  "dark_brown",
	COLOR_WHITE:       "white",
	COLOR_BLACK:       "black",
	COLOR_MAGENTA:     "magenta",
	COLOR_RAY_WHITE:   "ray_white",
}

func (c *Color) String() string {
	return colors[*c]
}
