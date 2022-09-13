package main

import (
	"os"

	"github.com/jeremybumsted/bkgreeter" 
)

func main() {
	bkgreeter.Hello(os.Getenv("BUILDKITE_BUILD_AUTHOR"))
}
