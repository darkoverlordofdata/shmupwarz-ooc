use sdl2
import math
import sdl2/Core

Input: enum {   
    /* User Input */
    NONE        = 0
    LEFT        = 1
    RIGHT       = 2
    JUMP        = 3
    RESTART     = 4
    QUIT        = 5
}

Actor: enum {      
    /* Indidual actor types */
    DEFAULT      = 0
    BACKGROUND   = 1
    TEXT         = 2
    LIVES        = 3
    ENEMY1       = 4
    ENEMY2       = 5
    ENEMY3       = 6
    PLAYER       = 7
    BULLET       = 8
    EXPLOSION    = 9
    BANG         = 10
    PARTICLE     = 11
    HUD          = 12
}

Category: enum {    
    /* Actor categories */
    BACKGROUND   = 0
    BULLET       = 1
    ENEMY        = 2
    EXPLOSION    = 3
    PARTICLE     = 4
    PLAYER       = 5
}

Effect: enum {      
    /* Sound Effect */
    PEW          = 0
    ASPLODE      = 1
    SMALLASPLODE = 2
}

Enemies: enum {

     /* Enemy types */
    ENEMY1       = 0
    ENEMY2       = 1
    ENEMY3       = 2
}

Timers: enum {
    /* Spawn enemy timers */
    TIMER1      = 2
    TIMER2      = 7
    TIMER3      = 13
}

Timer1: Double = 2.0
Timer2: Double = 7.0
Timer3: Double = 13.0


Health: cover {
    current: Int
    maximum: Int
}


ScaleTween: cover {
    min : Double
    max : Double
    speed : Double
    repeat : Bool
    active : Bool
}

Sprite: cover {
    texture: SdlTexture
    width: Int
    height: Int
}

Point2d: cover {
    x: Double
    y: Double
    // add: func(v: Vector2d) -> Point2d {
    //     (x + v x, y + v y) as Point2d
    // }
    // sub: func(v: Vector2d) -> Point2d {
    //     (x - v x, y - v y) as Point2d
    // }
}

Vector2d: cover {
    x: Double
    y: Double
    // mul: func(f: Double) -> Vector2d {
    //     (x * f, y * f) as Vector2d
    // }
    // div: func(f: Double) -> Vector2d {
    //     (x / f, y / f) as Vector2d
    // }
    // len: func() -> Double {
    //     sqrt(x * x + y * y)
    // }
}

