package main

import (
	"flag"
	"log"

	httpServer "github.com/MrDaniLLka/HW_TBD/final_app/internal/app"
)

var (
	configPath = flag.String("conf", "./configs/app.json", "path to config file")
)

func main() {
	flag.Parse()

	s, err := httpServer.New(*configPath)
	if err != nil {
		log.Fatal(err)
	}

	if err = s.Start(); err != nil {
		log.Fatal(err)
	}
}
