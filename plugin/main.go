package main

import (
	"encoding/json"
	"github.com/extism/go-pdk"
	"plugin/models"
)

//go:wasmimport extism:host/user makeWindow
func makeWindow(uint64)

//export run
func run() {
	window := InitializeWindow(500, 450, 60, "your first window", models.COLOR_BLACK)

	windowBytes, _ := json.Marshal(window)

	mem := pdk.AllocateBytes(windowBytes)

	makeWindow(mem.Offset())
}

func main() {}

// just an example of initializing a window
func InitializeWindow(width int32, height int32, targetFPS int32, title string, color models.Color) *models.Window {
	msg := &models.Text{
		Text:     "you successfully created a window using zig+raylib+extism from go!",
		PosX:     200,
		PosY:     120,
		FontSize: 20,
		Color:    models.COLOR_WHITE,
	}

	window := &models.Window{
		Width:     width,
		Height:    height,
		TargetFPS: targetFPS,
		Title:     title,
		Color:     color,
		InitialInstructions: map[string]models.Instruction{
			"": msg,
		},
	}

	return window
}
