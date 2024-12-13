package main

import (
	"encoding/json"
	"fmt"
	"github.com/extism/go-pdk"
	"plugin/models"
)

//go:wasmimport extism:host/user makeWindow
func initWindow(uint64)

var window *models.Window

//export init
func init() {
	msg := &models.Text{
		Text:     "you successfully created a window using zig+raylib+extism from go!",
		PosX:     200,
		PosY:     120,
		FontSize: 20,
		Color:    models.COLOR_WHITE,
	}

	window = InitializeWindow(500, 450, 60, "your first window", models.COLOR_BLACK, msg)

	windowBytes, _ := json.Marshal(window)

	mem := pdk.AllocateBytes(windowBytes)

	initWindow(mem.Offset())
}

func main() {}

// just an example of initializing a window
func InitializeWindow(width int32, height int32, targetFPS int32, title string, color models.Color, initialInstructions ...models.Instruction) *models.Window {
	insts := make(map[string]models.Instruction, len(initialInstructions))

	for i, inst := range initialInstructions {
		insts[fmt.Sprintf("instruction %d", i)] = inst
	}

	w := &models.Window{
		Width:               width,
		Height:              height,
		TargetFPS:           targetFPS,
		Title:               title,
		Color:               color,
		InitialInstructions: insts,
	}

	return w
}
