
//go:build ignore

package main

import (
	"fmt"
	"os"

	voicevoxcorego "github.com/sh1ma/voicevoxcore.go"
)

func main() {
	text := "ずんだもんなのだ"

	core := voicevoxcorego.NewVoicevoxCore()
	initializeOptions := voicevoxcorego.NewVoicevoxInitializeOptions(0, 0, false, "/go/open_jtalk_dic_utf_8-1.11")
	core.Initialize(initializeOptions)

	core.LoadModel(3)

	ttsOptions := voicevoxcorego.NewVoicevoxTtsOptions(false, true)
	result, err := core.Tts(text, 1, ttsOptions)
	if err != nil {
		fmt.Println(err)
	}
	f, _ := os.Create("out.wav")
	_, err = f.Write(result)
	if err != nil {
		fmt.Println(err)
	}
}
