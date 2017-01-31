use sdl2
import sdl2/[Core, Event, TTF]
import demo/components
import demo/entities
import demo/systems
import demo/game
import os/Time
import math

windowSize := (0, 0, 1280, 640) as SdlRect 	

main: func (argc: Int, argv: CString*) {
	SDL init(SDL_INIT_EVERYTHING)
    TTF init()
	

	window := SDL createWindow(
		"ShmupWarz",
		SDL_WINDOWPOS_UNDEFINED,
		SDL_WINDOWPOS_UNDEFINED,
		windowSize w, windowSize h, SDL_WINDOW_SHOWN)
	
	renderer := SDL createRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC)
    game := Game new(renderer)
	
	frame := 0
	fps := 60

	mark1 := Time microsec() as Double / 1000000
	mark2 := 0.0
	delta := 0.0


	while (!game inputs[Input QUIT]) {
        game handleEvents()

		mark2 = Time microsec() as Double / 1000000
		delta = mark2 - mark1
		if (delta < 0) delta = (1.0+mark2) - mark1
		mark1 = mark2

        game update(delta)
		game draw(ceil(1.0/delta))
	}
	
	SDL destroyRenderer(renderer)
	SDL destroyWindow(window)
	SDL quit()
}

