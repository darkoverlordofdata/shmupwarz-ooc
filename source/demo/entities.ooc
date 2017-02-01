use sdl2
import math
import math/Random
import sdl2/[Core, Event, Image]
import components
import game

Tau := 6.28318

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
    init: func(=id, =name, =actor, =category) {
        active = false
        position = (0, 0) as Point2d
        scale = (1, 1) as Vector2d
        tint = (0, 0, 0, 255) as SdlColor
        expires = 0
        health = (0, 0) as Health
    }
}

createPlayer: func(game: Game, renderer: SdlRenderer, id: Int) -> Entity {
    player := Entity new(id, "Player", Actor PLAYER, Category PLAYER)
    player active = true
    player position = (100, 100) as Point2d
    player bounds = (100, 100, game playerSurface@ w/2, game playerSurface@ h/2) as SdlRect
    player sprite = (game playerTexture, game playerSurface@ w, game playerSurface@ h) as Sprite
    player health = (0, 0) as Health
    player scaleTween = (0, 0, 0, false, false) as ScaleTween
    player velocity = (0, 0) as Vector2d
    player
}

createBullet: func(game: Game, renderer: SdlRenderer, id: Int) -> Entity {
    bullet := Entity new(id, "Bullet", Actor BULLET, Category BULLET)
    bullet bounds = (0, 0, game bulletSurface@ w, game bulletSurface@ h/2) as SdlRect
    bullet sprite = (game bulletTexture, game bulletSurface@ w, game bulletSurface@ h) as Sprite
    refreshBullet(bullet&)
}

createEnemy1: func(game: Game, renderer: SdlRenderer, id: Int) -> Entity {
    enemy1 := Entity new(id, "Enemy1", Actor ENEMY1, Category ENEMY)
    enemy1 bounds = (0, 0, game enemy1Surface@ w/2, game enemy1Surface@ h/2) as SdlRect
    enemy1 sprite = (game enemy1Texture, game enemy1Surface@ w, game enemy1Surface@ h) as Sprite
    refreshEnemy1(enemy1&)
}

createEnemy2: func(game: Game, renderer: SdlRenderer, id: Int) -> Entity {
    enemy2 := Entity new(id, "Enemy2", Actor ENEMY2, Category ENEMY)
    enemy2 bounds = (0, 0, game enemy2Surface@ w/2, game enemy2Surface@ h/2) as SdlRect
    enemy2 sprite = (game enemy2Texture, game enemy2Surface@ w, game enemy2Surface@ h) as Sprite
    refreshEnemy2(enemy2&)
}

createEnemy3: func(game: Game, renderer: SdlRenderer, id: Int) -> Entity {
    enemy3 := Entity new(id, "Enemy3", Actor ENEMY3, Category ENEMY)
    enemy3 bounds = (0, 0, game enemy3Surface@ w/2, game enemy3Surface@ h/2) as SdlRect
    enemy3 sprite = (game enemy3Texture, game enemy3Surface@ w, game enemy3Surface@ h) as Sprite
    refreshEnemy3(enemy3&)
}

createExplosion: func(game: Game, renderer: SdlRenderer, id: Int) -> Entity {
    explosion := Entity new(id, "Explosion", Actor EXPLOSION, Category EXPLOSION)
    explosion bounds = (0, 0, game explosionSurface@ w/2, game explosionSurface@ h/2) as SdlRect
    explosion sprite = (game explosionTexture, game explosionSurface@ w, game explosionSurface@ h) as Sprite
    refreshExplosion(explosion&)
}

createBang: func(game: Game, renderer: SdlRenderer, id: Int) -> Entity {
    bang := Entity new(id, "Bang", Actor BANG, Category EXPLOSION)
    bang bounds = (0, 0, game explosionSurface@ w/2, game explosionSurface@ h/2) as SdlRect
    bang sprite = (game explosionTexture, game explosionSurface@ w, game explosionSurface@ h) as Sprite
    refreshBang(bang&)
}

createParticle: func(game: Game, renderer: SdlRenderer, id: Int) -> Entity {    
    particle := Entity new(id, "Particle", Actor PARTICLE, Category PARTICLE)
    particle bounds = (0, 0, game particleSurface@ w/2, game particleSurface@ h/2) as SdlRect
    particle sprite = (game particleTexture, game particleSurface@ w, game particleSurface@ h) as Sprite
    refreshParticle(particle&)
}

refreshBullet: func(bullet: Entity@, x=0, y=0: Double) -> Entity {
    bullet active = x != 0 || y != 0
    bullet position = (x, y) as Point2d
    bullet tint = (0xd2, 0xfa, 0x00, 0xfa) as SdlColor
    bullet expires = 1
    bullet health = (2, 2) as Health
    bullet scaleTween = (0, 0, 0, false, false) as ScaleTween
    bullet velocity = (0, -800) as Vector2d
    bullet
}

refreshEnemy1: func(enemy1: Entity@, x=0, y=0: Double) -> Entity {
    enemy1 active = x != 0 || y != 0
    enemy1 position = (x, y) as Point2d
    enemy1 health = (10, 10) as Health
    enemy1 scaleTween = (0, 0, 0, false, false) as ScaleTween
    enemy1 velocity = (0, 40) as Vector2d
    enemy1
}

refreshEnemy2: func(enemy2: Entity@, x=0, y=0: Double) -> Entity {
    enemy2 active = x != 0 || y != 0
    enemy2 position = (x, y) as Point2d
    enemy2 health = (20, 20) as Health
    enemy2 scaleTween = (0, 0, 0, false, false) as ScaleTween
    enemy2 velocity = (0, 30) as Vector2d
    enemy2
}
refreshEnemy3: func(enemy3: Entity@, x=0, y=0: Double) -> Entity {
    enemy3 active = x != 0 || y != 0
    enemy3 position = (x, y) as Point2d
    enemy3 health = (60, 60) as Health
    enemy3 scaleTween = (0, 0, 0, false, false) as ScaleTween
    enemy3 velocity = (0, 20) as Vector2d
    enemy3
}

refreshExplosion: func(explosion: Entity@, x=0, y=0: Double) -> Entity {
    explosion active = x != 0 || y != 0
    explosion position = (x, y) as Point2d
    explosion scale = (0.5, 0.5) as Vector2d
    explosion tint = (0xd2, 0xfa, 0xd2, 0xfa) as SdlColor
    explosion expires = 0.5
    explosion scaleTween = (0.5/100, 0.5, -3, false, true) as ScaleTween
    explosion velocity = (0, 0) as Vector2d
    explosion
}


refreshBang: func(bang: Entity@, x=0, y=0: Double) -> Entity {
    bang active = x != 0 || y != 0
    bang position = (x, y) as Point2d
    bang scale = (0.2, 0.2) as Vector2d
    bang tint = (0xaa, 0xe8, 0xaa, 0xee) as SdlColor
    bang expires = 0.5
    bang scaleTween = (0.2/100, 0.5, -3, false, true) as ScaleTween
    bang velocity = (0, 0) as Vector2d
    bang
}

refreshParticle: func(particle: Entity@, x=0, y=0: Double) -> Entity {    
    radians := Random random() * Tau
    magnitude := Random randInt(0, 200)
    velocityX := magnitude * cos(radians)
    velocityY := magnitude * sin(radians)
    scale := Random randRange(0.1, 1.0)

    particle active = x != 0 || y != 0
    particle position = (x, y) as Point2d
    particle scale = (scale, scale) as Vector2d
    particle tint = (0xfa, 0xfa, 0xd2, 0xff) as SdlColor
    particle expires = 0.5
    particle scaleTween = (0, 0, 0, false, false) as ScaleTween
    particle velocity = (velocityX, velocityY) as Vector2d
    particle
}
