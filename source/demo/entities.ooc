use sdl2
import math
import math/Random
import sdl2/[Core, Event, Image]
import components
import game

Entity: class {
    id: Int                     /* Unique sequential id */
    name: String                /* Display name */
    active: Bool                /* In use */
    actor: Actor                /* Actor Id */
    category: Category          /* Actor Category */
    position: Point2d           /* Position on screen */
    bounds: SdlRect             /* Collision bounds */
    sprite: Sprite              /* Sprite */
                                /* Optional: */
    scale: Vector2d             /* Display scale */
    tint: SdlColor              /* SdlColor to use as tint */
    expires: Double             /* Countdown until expiration */
    health: Health              /* Track health */
    scaleTween: ScaleTween      /* scale Tweening variables*/
    velocity: Vector2d          /* Cartesian velocity*/
    init: func() {

    }
}

createPlayer: func(game: Game, renderer: SdlRenderer, id: Int) -> Entity {
    player := Entity new()
    player id = id
    player name = "Player" 
    player active = true
    player actor = Actor PLAYER
    player category = Category PLAYER
    player position = (100, 100) as Point2d
    player bounds = (100, 100, game playerSurface@ w/2, game playerSurface@ h/2) as SdlRect
    player sprite = (game playerTexture, game playerSurface@ w, game playerSurface@ h) as Sprite
    player scale = (1, 1) as Vector2d
    player tint = (0, 0, 0, 255) as SdlColor
    player expires = 0
    player health = (0, 0) as Health
    player scaleTween = (0, 0, 0, false, false) as ScaleTween
    player velocity = (0, 0) as Vector2d
    player
}

createBullet: func(game: Game, renderer: SdlRenderer, id: Int) -> Entity {
    bullet := Entity new()
    bullet id = id
    bullet name = "Bullet" 
    bullet active = false
    bullet actor = Actor BULLET
    bullet category = Category BULLET
    bullet position = (0, 0) as Point2d
    bullet bounds = (0, 0, game bulletSurface@ w/2, game bulletSurface@ h/2) as SdlRect
    bullet sprite = (game bulletTexture, game bulletSurface@ w, game bulletSurface@ h) as Sprite
    bullet scale = (1, 1) as Vector2d
    bullet tint = (0xd2, 0xfa, 0x00, 0xfa) as SdlColor
    bullet expires = 1
    bullet health = (2, 2) as Health
    bullet scaleTween = (0, 0, 0, false, false) as ScaleTween
    bullet velocity = (0, -800) as Vector2d
    bullet
}

createEnemy1: func(game: Game, renderer: SdlRenderer, id: Int) -> Entity {
    enemy1 := Entity new()
    enemy1 id = id
    enemy1 name = "Enemy1" 
    enemy1 active = false
    enemy1 actor = Actor ENEMY1
    enemy1 category = Category ENEMY
    enemy1 position = (0, 0) as Point2d
    enemy1 bounds = (0, 0, game enemy1Surface@ w/2, game enemy1Surface@ h/2) as SdlRect
    enemy1 sprite = (game enemy1Texture, game enemy1Surface@ w, game enemy1Surface@ h) as Sprite
    enemy1 scale = (1, 1) as Vector2d
    enemy1 tint = (0, 0, 0, 255) as SdlColor
    enemy1 expires = 0
    enemy1 health = (10, 10) as Health
    enemy1 scaleTween = (0, 0, 0, false, false) as ScaleTween
    enemy1 velocity = (0, 40) as Vector2d
    enemy1
}

createEnemy2: func(game: Game, renderer: SdlRenderer, id: Int) -> Entity {
    enemy2 := Entity new()
    enemy2 id = id
    enemy2 name = "Enemy2" 
    enemy2 active = false
    enemy2 actor = Actor ENEMY2
    enemy2 category = Category ENEMY
    enemy2 position = (0, 0) as Point2d
    enemy2 bounds = (0, 0, game enemy2Surface@ w/2, game enemy2Surface@ h/2) as SdlRect
    enemy2 sprite = (game enemy2Texture, game enemy2Surface@ w, game enemy2Surface@ h) as Sprite
    enemy2 scale = (1, 1) as Vector2d
    enemy2 tint = (0, 0, 0, 255) as SdlColor
    enemy2 expires = 0
    enemy2 health = (20, 20) as Health
    enemy2 scaleTween = (0, 0, 0, false, false) as ScaleTween
    enemy2 velocity = (0, 30) as Vector2d
    enemy2
}

createEnemy3: func(game: Game, renderer: SdlRenderer, id: Int) -> Entity {
    enemy3 := Entity new()
    enemy3 id = id
    enemy3 name = "Enemy3" 
    enemy3 active = false
    enemy3 actor = Actor ENEMY3
    enemy3 category = Category ENEMY
    enemy3 position = (0, 0) as Point2d
    enemy3 bounds = (0, 0, game enemy3Surface@ w/2, game enemy3Surface@ h/2) as SdlRect
    enemy3 sprite = (game enemy3Texture, game enemy3Surface@ w, game enemy3Surface@ h) as Sprite
    enemy3 scale = (1, 1) as Vector2d
    enemy3 tint = (0, 0, 0, 255) as SdlColor
    enemy3 expires = 0
    enemy3 health = (60, 60) as Health
    enemy3 scaleTween = (0, 0, 0, false, false) as ScaleTween
    enemy3 velocity = (0, 20) as Vector2d
    enemy3
}

createExplosion: func(game: Game, renderer: SdlRenderer, id: Int) -> Entity {
    explosion := Entity new()
    explosion id = id
    explosion name = "Explosion" 
    explosion active = false
    explosion actor = Actor EXPLOSION
    explosion category = Category EXPLOSION
    explosion position = (0, 0) as Point2d
    explosion bounds = (0, 0, game explosionSurface@ w/2, game explosionSurface@ h/2) as SdlRect
    explosion sprite = (game explosionTexture, game explosionSurface@ w, game explosionSurface@ h) as Sprite
    explosion scale = (0.5, 0.5) as Vector2d
    explosion tint = (0xd2, 0xfa, 0xd2, 0xfa) as SdlColor
    explosion expires = 0.5
    explosion health = (0, 0) as Health
    explosion scaleTween = (0.5/100, 0.5, -3, false, true) as ScaleTween
    explosion velocity = (0, 0) as Vector2d
    explosion
}

createBang: func(game: Game, renderer: SdlRenderer, id: Int) -> Entity {
    bang := Entity new()
    bang id = id
    bang name = "Bang" 
    bang active = false
    bang actor = Actor BANG
    bang category = Category EXPLOSION
    bang position = (0, 0) as Point2d
    bang bounds = (0, 0, game explosionSurface@ w/2, game explosionSurface@ h/2) as SdlRect
    bang sprite = (game explosionTexture, game explosionSurface@ w, game explosionSurface@ h) as Sprite
    bang scale = (0.2, 0.2) as Vector2d
    bang tint = (0xaa, 0xe8, 0xaa, 0xee) as SdlColor
    bang expires = 0.5
    bang health = (0, 0) as Health
    bang scaleTween = (0.2/100, 0.5, -3, false, true) as ScaleTween
    bang velocity = (0, 0) as Vector2d
    bang
}

createParticle: func(game: Game, renderer: SdlRenderer, id: Int) -> Entity {    
    radians := Random random() * 6.28318 // Tau
    magnitude := Random randInt(0, 200)
    velocityX := magnitude * cos(radians)
    velocityY := magnitude * sin(radians)
    scale := Random randRange(0.1, 1.0)

    particle := Entity new()
    particle id = id
    particle name = "Particle" 
    particle active = false
    particle actor = Actor PARTICLE
    particle category = Category PARTICLE
    particle position = (0, 0) as Point2d
    particle bounds = (0, 0, game particleSurface@ w/2, game particleSurface@ h/2) as SdlRect
    particle sprite = (game particleTexture, game particleSurface@ w, game particleSurface@ h) as Sprite
    particle scale = (scale, scale) as Vector2d
    particle tint = (0xfa, 0xfa, 0xd2, 0xff) as SdlColor
    particle expires = 0.5
    particle health = (0, 0) as Health
    particle scaleTween = (0, 0, 0, false, false) as ScaleTween
    particle velocity = (velocityX, velocityY) as Vector2d
    particle
}
