use sdl2
import structs/ArrayList
import math
import math/Random
import sdl2/[Core, Event, Image]
import entities
import components
import game

windowSize := (0, 0, 1280, 640) as SdlRect 	

Systems: class {

    enemyT1: Double = Timer1 as Double 
    enemyT2: Double = Timer2 as Double
    enemyT3: Double = Timer3 as Double
    FireRate : Double = 0.1
    timeToFire: Double
    result: SdlRect
    game: Game

    init: func(=game) {

    }

        // for (i in 1  entities size -1) system create(delta, entities[i]&)

    collision: func(delta: Double) {
        for (i in 0..game entities size-1) {
            if (game entities[i] active && game entities[i] category == Category ENEMY) {
                for (j in 0..game entities size-1) {
                    if (game entities[j] active && game entities[j] category == Category BULLET) {
                        if (intersects(game entities[i] bounds, game entities[j] bounds)) {
                            handleCollision(game entities[i], game entities[j])
                        }
                    }
                }
            }
        }
    }

    /** 
     *  Rect methods are missing from the sdl2-ooc bindings
     */
    intersects: func(r1: SdlRect, r2: SdlRect) -> Bool {
        return ((r1 x < r2 x + r2 w) && 
                (r1 x + r1 w > r2 x) && 
                (r1 y < r2 y + r2 h) && 
                (r1 y + r1 h > r2 y)) 
    }

    handleCollision: func(a: Entity, b: Entity) {
        game bangs add((b position x, b position y) as Point2d)
        b active = false
        for (i in 0..4) game particles add((b position x, b position y) as Point2d)
        if (a health maximum != 0) {
            a health current -= b health current 
            if (a health current <= 0) {
                game explosions add((b position x, b position y) as Point2d)
                a active = false
            }
        }
    }

    spawn: func(delta: Double) {        

        spawn := func(t: Double, e: Enemies) -> Double {
            d := t-delta
            if (d<0) {
                return match e {
                    case Enemies ENEMY1 =>
                        game enemies1 add((0, 0) as Point2d)
                        Timer1 
                    case Enemies ENEMY2 =>
                        game enemies2 add((0, 0) as Point2d)
                        Timer2 
                    case Enemies ENEMY3 =>
                        game enemies3 add((0, 0) as Point2d)
                        Timer3 
                    case => 0
                }
            } else return d
        }
        enemyT1 = spawn(enemyT1, Enemies ENEMY1)
        enemyT2 = spawn(enemyT2, Enemies ENEMY2)
        enemyT3 = spawn(enemyT3, Enemies ENEMY3)

    }

    input: func(delta: Double, e: Entity) {
        if (e active && e category == Category PLAYER) {
            e position x = game mouse x
            e position y = game mouse y

            if (game inputs[Input JUMP]) {
                timeToFire -= delta
                if (timeToFire < 0.0) {
                    game bullets add((e position x - 27, e position y + 2) as Point2d)
                    game bullets add((e position x + 27, e position y + 2) as Point2d)
                    timeToFire = FireRate
                }
            }
        }
    }

    physics: func(delta: Double, e: Entity) {
        if (e active && e velocity x != 0.0 || e velocity y != 0.0) {
            x := e position x + e velocity x * delta
            y := e position y + e velocity y * delta
            e bounds x = (x-e bounds h/2)
            e bounds y = (y-e bounds w/2)
            e position x = x
            e position y = y
        }
    }

    expire: func(delta: Double, e: Entity) {
        if (e active && e expires != 0) {
            e expires = e expires - delta
            if (e expires <= 0) e active = false
        }
    }


    scaleTween: func(delta: Double, e: Entity) {
        
        if (e active && e scaleTween active) {
            x := e scale x + e scaleTween speed * delta
            y := e scale y + e scaleTween speed * delta
            active := e scaleTween active
            if (x > e scaleTween max)  {
                x = e scaleTween max
                y = e scaleTween max
                active = false
            }
            if (x < e scaleTween min) {
                x = e scaleTween min
                y = e scaleTween min
                active = false
            }
            e scale = (x, y) as Vector2d
            e scaleTween active = active
        }
    }
        
    removeOffscreen: func(delta: Double, e: Entity) {
        if (e active && e category == Category ENEMY) {
            if (e position y > windowSize h) e active = false
        }
    }

    create: func(delta: Double, e: Entity) {
        if (!e active) {
            match (e actor) {
                case Actor BULLET =>
                    if (game bullets size > 0) {
                        bullet := game bullets removeAt(0)
                        e expires = 1
                        e position = (bullet x, bullet y) as Point2d
                        e active = true
                    }
                case Actor ENEMY1 =>
                    if (game enemies1 size > 0) {
                        enemy := game enemies1 removeAt(0)
                        e position = (Random randInt(0, windowSize w-45), 45) as Point2d
                        e health = (10, 10) as Health
                        e active = true
                    }
                case Actor ENEMY2 =>
                    if (game enemies2 size > 0) {
                        enemy := game enemies2 removeAt(0)
                        e position = (Random randInt(0, windowSize w-86), 86) as Point2d
                        e health = (20, 20) as Health
                        e active = true
                    }
                case Actor ENEMY3 =>
                    if (game enemies3 size > 0) {
                        enemy := game enemies3 removeAt(0)
                        e position = (Random randInt(0, windowSize w-160), 160) as Point2d
                        e health = (60, 60) as Health
                        e active = true
                    }
                case Actor EXPLOSION =>
                    if (game explosions size > 0) {
                        explosion := game explosions removeAt(0)
                        e expires = 0.5
                        e scale = (0.5, 0.5) as Vector2d
                        e scaleTween = (0.5/100, 0.5, -3, false, true) as ScaleTween
                        e position = (explosion x, explosion y) as Point2d
                        e active = true
                    }
                case Actor BANG =>
                    if (game bangs size > 0) {
                        bang := game bangs removeAt(0)
                        e expires = 0.5
                        e scale = (0.2, 0.2) as Vector2d
                        e scaleTween = (0.2/100, 0.5, -3, false, true) as ScaleTween
                        e position = (bang x, bang y) as Point2d
                        e active = true
                    }
                case Actor PARTICLE =>
                    if (game particles size > 0) {
                        particle := game particles removeAt(0)
                        e expires = 0.5
                        e position = (particle x, particle y) as Point2d
                        e active = true
                    }
            }
        }
    }

}