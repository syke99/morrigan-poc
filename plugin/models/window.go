package models

import "encoding/json"

type Window struct {
	Width               int32        `json:"width"`
	Height              int32        `json:"height"`
	TargetFPS           int32        `json:"targetFPS"`
	Title               string       `json:"title"`
	Color               Color        `json:"color"`
	InitialInstructions Instructions `json:"initialInstructions"`
}

type Instructions map[string]Instruction

type Instruction interface {
	unmarshal(data []byte) error
	marshal() ([]byte, error)
}

type valid struct {
}

func (i Instructions) UnmarshalJSON(data []byte) error {
	var err error
	dst := make(map[string]interface{})
	if err = json.Unmarshal(data, &dst); err != nil {
		return err
	}

	for _, v := range dst {
		switch val := v.(type) {
		case *Text:
			err = val.unmarshal(data)
		}
	}

	if err != nil {
		return err
	}

	return nil
}

func (i Instructions) MarshalJSON() ([]byte, error) {
	var bytes []byte
	var err error
	var dst map[string]interface{}
	if bytes, err = json.Marshal(dst); err != nil {
		return nil, err
	}
	for _, v := range dst {
		switch val := v.(type) {
		case *Text:
			bytes, err = val.marshal()
		}
	}

	if err != nil {
		return nil, err
	}

	return bytes, err
}

type Text struct {
	Text     string `json:"text"`
	PosX     int32  `json:"posX"`
	PosY     int32  `json:"posY"`
	FontSize int32  `json:"fontSize"`
	Color    Color  `json:"color"`
}

func (t *Text) unmarshal(data []byte) error {
	return json.Unmarshal(data, t)
}

func (t *Text) marshal() ([]byte, error) {
	return json.Marshal(t)
}
