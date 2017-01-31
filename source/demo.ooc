use sdl2
import sdl2/[Core, Event, TTF]
import demo/components
import demo/entities
import demo/systems
import demo/game
import os/Time
import math

windowSize := (0, 0, 640, 720) as SdlRect 	

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
	mark1 := Time microsec() as Double / 1000000
	mark2 := 0.0
	delta := 0.0
	frame := 0
	fps := 60

	t1 := 0
	t2 := 0
	k := 0

	while (!game inputs[Input QUIT]) {
        game handleEvents()

		mark2 = Time microsec() as Double / 1000000
		delta = mark2 - mark1
		if (delta < 0) {
			delta = delta + 1.0
			fps = ceil(1.0/delta)
		}
		mark1 = mark2

		// t1 = Time microsec()
        game update(delta)
		// t1 = Time microsec() - t1
		// //"time: %f" printfln(t1 as Double / 1000000)
		// t2 = t2 + t1
		// k = k + 1
		// if (k == 1000) {
		// 	"time: %f" printfln(t2 as Double/1000)
		// }
		Time sleepMilli(1)
		game draw(fps)
	}
	
	SDL destroyRenderer(renderer)
	SDL destroyWindow(window)
	SDL quit()
}

