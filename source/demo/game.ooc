use sdl2
import math
import structs/ArrayList
import structs/LinkedList
import sdl2/[Core, Event, Image, TTF, RW]
import entities
import components
import systems

Game: class {

    font: TTFFont
    rawFont: RWops
    evt : SdlEvent
    renderer: SdlRenderer
    mouse: Point2d 
    inputs: Bool[]
    system: Systems
    entities: ArrayList<Entity>
    uniqueId : Int = 0


    /* resources */
    playerSurface: SdlSurface*
    bulletSurface: SdlSurface*
    enemy1Surface: SdlSurface*
    enemy2Surface: SdlSurface*
    enemy3Surface: SdlSurface*
    particleSurface: SdlSurface*
    explosionSurface: SdlSurface*

    playerTexture: SdlTexture
    bulletTexture: SdlTexture
    enemy1Texture: SdlTexture
    enemy2Texture: SdlTexture
    enemy3Texture: SdlTexture
    particleTexture: SdlTexture
    explosionTexture: SdlTexture
    
    /* assets */
    FONT_TTF:String       = "/home/bruce/ooc/demo/res/fonts/OpenDyslexic-Bold.otf"
    PLAYER_PNG:String     = "/home/bruce/ooc/demo/res/images/fighter.png"
    BULLET_PNG:String     = "/home/bruce/ooc/demo/res/images/bullet.png"
    ENEMY1_PNG:String     = "/home/bruce/ooc/demo/res/images/enemy1.png"
    ENEMY2_PNG:String     = "/home/bruce/ooc/demo/res/images/enemy2.png"
    ENEMY3_PNG:String     = "/home/bruce/ooc/demo/res/images/enemy3.png"
    PARTICLE_PNG:String   = "/home/bruce/ooc/demo/res/images/star.png"
    EXPLOSION_PNG:String  = "/home/bruce/ooc/demo/res/images/explosion.png"

    particles: LinkedList<Point2d> = LinkedList<Point2d> new()
    bullets: LinkedList<Point2d> = LinkedList<Point2d> new()
    enemies1: LinkedList<Point2d> = LinkedList<Point2d> new()
    enemies2: LinkedList<Point2d> = LinkedList<Point2d> new()
    enemies3: LinkedList<Point2d> = LinkedList<Point2d> new()
    explosions: LinkedList<Point2d> = LinkedList<Point2d> new()
    bangs: LinkedList<Point2d> = LinkedList<Point2d> new()

    init: func(=renderer) {

        playerSurface = SDLImage load(PLAYER_PNG)
        playerTexture = SDL createTextureFromSurface(renderer, playerSurface)
        SDL setTextureBlendMode(playerTexture, SDL_BLENDMODE_BLEND)

        bulletSurface = SDLImage load(BULLET_PNG)
        bulletTexture = SDL createTextureFromSurface(renderer, bulletSurface)
        SDL setTextureBlendMode(bulletTexture, SDL_BLENDMODE_BLEND)

        enemy1Surface = SDLImage load(ENEMY1_PNG)
        enemy1Texture = SDL createTextureFromSurface(renderer, enemy1Surface)
        SDL setTextureBlendMode(enemy1Texture, SDL_BLENDMODE_BLEND)

        enemy2Surface = SDLImage load(ENEMY2_PNG)
        enemy2Texture = SDL createTextureFromSurface(renderer, enemy2Surface)
        SDL setTextureBlendMode(enemy2Texture, SDL_BLENDMODE_BLEND)

        enemy3Surface = SDLImage load(ENEMY3_PNG)
        enemy3Texture = SDL createTextureFromSurface(renderer, enemy2Surface)
        SDL setTextureBlendMode(enemy3Texture, SDL_BLENDMODE_BLEND)

        particleSurface = SDLImage load(PARTICLE_PNG)
        particleTexture = SDL createTextureFromSurface(renderer, particleSurface)
        SDL setTextureBlendMode(particleTexture, SDL_BLENDMODE_BLEND)

        explosionSurface = SDLImage load(EXPLOSION_PNG)
        explosionTexture = SDL createTextureFromSurface(renderer, explosionSurface)
        SDL setTextureBlendMode(explosionTexture, SDL_BLENDMODE_BLEND)

        font = TTFFont new(FONT_TTF, 28)
        if (!font){
            Exception new("Font can not be loaded!") throw()
        }
        initEntities()

        inputs = Bool[6] new()
        system = Systems new(this)


    }

    getUniqueId: func -> Int {
        uniqueId = uniqueId+1
    }


    drawSprite: func(e: Entity) {
        w := (e scale x != 0) ? e sprite width * e scale x : e sprite width
        h := (e scale y != 0) ? e sprite height * e scale y : e sprite height
        x := e position x - w / 2
        y := e position y - h / 2
        if (e tint r != 0 || e tint g != 0 || e tint b != 0) {
            SDL setTextureColorMod(e sprite texture, e tint r, e tint g, e tint b)
        }
        SDL renderCopy(renderer, e sprite texture, null, (x, y, w, h) as SdlRect&)
        
    }

    draw: func(fps: Int)  {		
        
        SDL setRenderDrawColor(renderer, 0x00, 0x00, 0x00, 0xff)
		SDL renderClear(renderer)
        for (e in entities) {
            if (e active && e actor != Actor PLAYER)
                drawSprite(e)
        }
        drawSprite(entities[0]) // Player on Top!
        text := font renderUTF8Solid(fps toString(), (0xff, 0xff, 0xff, 0xff) as SdlColor)
        texture := SDL createTextureFromSurface(renderer, text)
        SDL renderCopy(renderer, texture, null, (5, 5, 56, 28) as SdlRect&)
		SDL renderPresent(renderer)
    }

    update: func(delta: Double) {
        system spawn(delta)
        system collision(delta)
        system input(delta, entities[0]) // entities[0] is the player
        for (e in entities) system create(delta, e)

        act := LinkedList<Entity> new()
        for (e in entities) if (e active) act add(e) 
        
        for (e in act) system expire(delta, e)
        for (e in act) system physics(delta, e)
        for (e in act) system scaleTween(delta, e)
        for (e in act) system removeOffscreen(delta, e)

    }

    // getEntities: func() -> LinkedList<Entity> {
    //     entities
    // }

    handleEvents: func {
		// e: SdlEvent
		while (SdlEvent poll(evt&)) {
			match(evt type) {
			case SDL_QUIT =>
                inputs[Input QUIT] = true
			case SDL_KEYDOWN =>
                inputs[toInput(evt key keysym scancode)] = true
			case SDL_KEYUP =>
                inputs[toInput(evt key keysym scancode)] = false
			case SDL_MOUSEBUTTONUP =>
                inputs[Input JUMP] = false
			case SDL_MOUSEBUTTONDOWN =>
                mouse x = evt motion x
                mouse y = evt motion y
                inputs[Input JUMP] = true
			case SDL_MOUSEMOTION =>
                mouse x = evt motion x
                mouse y = evt motion y
			}
		}

    }

    toInput: func(key: Int) -> Input {
        match key {            
            case SDL_SCANCODE_LEFT => Input LEFT
            case SDL_SCANCODE_RIGHT => Input RIGHT
            case SDL_SCANCODE_UP => Input JUMP
            case SDL_SCANCODE_Z => Input JUMP
            case SDL_SCANCODE_R => Input RESTART
            case SDL_SCANCODE_Q => Input QUIT
            case => Input NONE
        }
    }

    initEntities: func {
        entities = [
            createPlayer(this, renderer, getUniqueId()),
            createEnemy1(this, renderer, getUniqueId()),
            createEnemy1(this, renderer, getUniqueId()),
            createEnemy1(this, renderer, getUniqueId()),
            createEnemy1(this, renderer, getUniqueId()),
            createEnemy1(this, renderer, getUniqueId()),
            createEnemy1(this, renderer, getUniqueId()),
            createEnemy1(this, renderer, getUniqueId()),
            createEnemy1(this, renderer, getUniqueId()),
            createEnemy1(this, renderer, getUniqueId()),
            createEnemy2(this, renderer, getUniqueId()),
            createEnemy2(this, renderer, getUniqueId()),
            createEnemy2(this, renderer, getUniqueId()),
            createEnemy2(this, renderer, getUniqueId()),
            createEnemy2(this, renderer, getUniqueId()),
            createEnemy2(this, renderer, getUniqueId()),
            createEnemy3(this, renderer, getUniqueId()),
            createEnemy3(this, renderer, getUniqueId()),
            createEnemy3(this, renderer, getUniqueId()),
            createEnemy3(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createParticle(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBullet(this, renderer, getUniqueId()),
            createBang(this, renderer, getUniqueId()),
            createBang(this, renderer, getUniqueId()),
            createBang(this, renderer, getUniqueId()),
            createBang(this, renderer, getUniqueId()),
            createBang(this, renderer, getUniqueId()),
            createBang(this, renderer, getUniqueId()),
            createBang(this, renderer, getUniqueId()),
            createBang(this, renderer, getUniqueId()),
            createExplosion(this, renderer, getUniqueId()),
            createExplosion(this, renderer, getUniqueId()),
            createExplosion(this, renderer, getUniqueId()),
            createExplosion(this, renderer, getUniqueId()),
            createExplosion(this, renderer, getUniqueId()),
            createExplosion(this, renderer, getUniqueId()),
            createExplosion(this, renderer, getUniqueId()),
            createExplosion(this, renderer, getUniqueId())
        ] as ArrayList<Entity>

    }
}