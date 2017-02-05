use sdl2
import math
import sdl2/[Core, Event, Image]
import structs/ArrayList
import structs/LinkedList
import structs/Stack
import entitas/Entity
import entitas/Exceptions
import entitas/Group
import entitas/Interfaces
import entitas/Matcher
import entitas/World
import entitas/events/EntityChanged
import entitas/events/EntityReleased
import entitas/events/GroupChanged
import entitas/events/GroupsChanged
import entitas/events/GroupUpdated
import entitas/events/WorldChanged
import entitas/events/ComponentReplaced
/**
 * Entitas Generated Components and Extensions for shmupwarz
 *
 * do not edit this file
 */
POOL_SIZE := 64

/**
* Component extensions
*/
components := [
    "BoundsComponent",
    "BulletComponent",
    "ColorTweenComponent",
    "DestroyComponent",
    "EnemyComponent",
    "ExpiresComponent",
    "HealthComponent",
    "LayerComponent",
    "PlayerComponent",
    "PositionComponent",
    "ResourceComponent",
    "ScaleTweenComponent",
    "ScaleComponent",
    "ScoreComponent",
    "SoundEffectComponent",
    "TextComponent",
    "TintComponent",
    "VelocityComponent",
    "ComponentsCount"
    ]

Component: enum {
    Bounds
    Bullet
    ColorTween
    Destroy
    Enemy
    Expires
    Health
    Layer
    Player
    Position
    Resource
    ScaleTween
    Scale
    Score
    SoundEffect
    Text
    Tint
    Velocity
    ComponentsCount
}


BoundsComponent : class extends IComponent {
    radius : Double 
    init: func()
}
BulletComponent : class extends IComponent {
    active : Bool = true
    init: func()
}

ColorTweenComponent : class extends IComponent {
    redMin : Double 
    redMax : Double 
    redSpeed : Double 
    greenMin : Double 
    greenMax : Double 
    greenSpeed : Double 
    blueMin : Double 
    blueMax : Double 
    blueSpeed : Double 
    alphaMin : Double 
    alphaMax : Double 
    alphaSpeed : Double 
    redAnimate : Bool 
    greenAnimate : Bool 
    blueAnimate : Bool 
    alphaAnimate : Bool 
    repeat : Bool 
    init: func()
}
DestroyComponent : class extends IComponent {
    active : Bool = true
    init: func()
}

EnemyComponent : class extends IComponent {
    active : Bool = true
    init: func()
}

ExpiresComponent : class extends IComponent {
    delay : Double 
    init: func()
}
HealthComponent : class extends IComponent {
    health : Double 
    maximumHealth : Double 
    init: func()
}
LayerComponent : class extends IComponent {
    ordinal : Int 
    init: func()
}
PlayerComponent : class extends IComponent {
    active : Bool = true
    init: func()
}

PositionComponent : class extends IComponent {
    x : Double 
    y : Double 
    init: func()
}
ResourceComponent : class extends IComponent {
    path : String 
    sprite : SdlTexture 
    bgd : Bool 
    init: func()
}
ScaleTweenComponent : class extends IComponent {
    min : Double 
    max : Double 
    speed : Double 
    repeat : Bool 
    active : Bool 
    init: func()
}
ScaleComponent : class extends IComponent {
    x : Double 
    y : Double 
    init: func()
}
ScoreComponent : class extends IComponent {
    value : Double 
    init: func()
}
SoundEffectComponent : class extends IComponent {
    effect : Int 
    init: func()
}
TextComponent : class extends IComponent {
    text : String 
    sprite : SdlTexture 
    init: func()
}
TintComponent : class extends IComponent {
    r : Int 
    g : Int 
    b : Int 
    a : Int 
    init: func()
}
VelocityComponent : class extends IComponent {
    x : Double 
    y : Double 
    init: func()
}


/**
* Entity extensions
*/
extend Entity {


    /* Entity: Bounds methods*/

    /** @type Bounds */
    getBounds: func() -> BoundsComponent {
        getComponent(Component Bounds as Int) as BoundsComponent
    }
    /** @type boolean */
    hasBounds : Bool {
        get { hasComponent(Component Bounds as Int) }
    }
    clearBoundsComponentPool: func() {
        __boundsComponentPool clear()
    }
    /**
     * @param radius Double
     * @return entitas.Entity
     */
    addBounds: func(radius:Double) -> This {
        c := __boundsComponentPool size > 0 ? __boundsComponentPool pop() : BoundsComponent new()
        c radius = radius
        addComponent(Component Bounds as Int, c)
        this
    }
    /**
     * @param radius Double
     * @return entitas.Entity
     */
    replaceBounds: func(radius:Double) -> This {
        previousComponent := this hasBounds ? this getBounds() : null
        c := __boundsComponentPool size > 0 ? __boundsComponentPool pop() : BoundsComponent new()
        c radius = radius
        replaceComponent(Component Bounds as Int, c) 
        if (previousComponent != null)
            __boundsComponentPool push(previousComponent)
        this
    }
    /**
     * @returns entitas.Entity
     */
    removeBounds: func() -> This {
        c := getBounds()
        removeComponent(Component Bounds as Int) 
        __boundsComponentPool push(c)
        this
    }


    /* Entity: Bullet methods*/

    /** @type boolean */
    isBullet : Bool {
        get { hasComponent(Component Bullet as Int) }
    }
    /**
     * @param value boolean
     * @return entitas.Entity
     */
    setBullet: func(value : Bool) -> This {
        index := Component Bullet as Int
        c := __bulletComponent
        if (value) {
            addComponent(index, c)
        } else {
            removeComponent(index)
        }
        this
    }


    /* Entity: ColorTween methods*/

    /** @type ColorTween */
    getColorTween: func() -> ColorTweenComponent {
        getComponent(Component ColorTween as Int) as ColorTweenComponent
    }
    /** @type boolean */
    hasColorTween : Bool {
        get { hasComponent(Component ColorTween as Int) }
    }
    clearColorTweenComponentPool: func() {
        __colorTweenComponentPool clear()
    }
    /**
     * @param redMin Double
     * @param redMax Double
     * @param redSpeed Double
     * @param greenMin Double
     * @param greenMax Double
     * @param greenSpeed Double
     * @param blueMin Double
     * @param blueMax Double
     * @param blueSpeed Double
     * @param alphaMin Double
     * @param alphaMax Double
     * @param alphaSpeed Double
     * @param redAnimate Bool
     * @param greenAnimate Bool
     * @param blueAnimate Bool
     * @param alphaAnimate Bool
     * @param repeat Bool
     * @return entitas.Entity
     */
    addColorTween: func(redMin:Double,redMax:Double,redSpeed:Double,greenMin:Double,greenMax:Double,greenSpeed:Double,blueMin:Double,blueMax:Double,blueSpeed:Double,alphaMin:Double,alphaMax:Double,alphaSpeed:Double,redAnimate:Bool,greenAnimate:Bool,blueAnimate:Bool,alphaAnimate:Bool,repeat:Bool) -> This {
        c := __colorTweenComponentPool size > 0 ? __colorTweenComponentPool pop() : ColorTweenComponent new()
        c redMin = redMin
        c redMax = redMax
        c redSpeed = redSpeed
        c greenMin = greenMin
        c greenMax = greenMax
        c greenSpeed = greenSpeed
        c blueMin = blueMin
        c blueMax = blueMax
        c blueSpeed = blueSpeed
        c alphaMin = alphaMin
        c alphaMax = alphaMax
        c alphaSpeed = alphaSpeed
        c redAnimate = redAnimate
        c greenAnimate = greenAnimate
        c blueAnimate = blueAnimate
        c alphaAnimate = alphaAnimate
        c repeat = repeat
        addComponent(Component ColorTween as Int, c)
        this
    }
    /**
     * @param redMin Double
     * @param redMax Double
     * @param redSpeed Double
     * @param greenMin Double
     * @param greenMax Double
     * @param greenSpeed Double
     * @param blueMin Double
     * @param blueMax Double
     * @param blueSpeed Double
     * @param alphaMin Double
     * @param alphaMax Double
     * @param alphaSpeed Double
     * @param redAnimate Bool
     * @param greenAnimate Bool
     * @param blueAnimate Bool
     * @param alphaAnimate Bool
     * @param repeat Bool
     * @return entitas.Entity
     */
    replaceColorTween: func(redMin:Double,redMax:Double,redSpeed:Double,greenMin:Double,greenMax:Double,greenSpeed:Double,blueMin:Double,blueMax:Double,blueSpeed:Double,alphaMin:Double,alphaMax:Double,alphaSpeed:Double,redAnimate:Bool,greenAnimate:Bool,blueAnimate:Bool,alphaAnimate:Bool,repeat:Bool) -> This {
        previousComponent := this hasColorTween ? this getColorTween() : null
        c := __colorTweenComponentPool size > 0 ? __colorTweenComponentPool pop() : ColorTweenComponent new()
        c redMin = redMin
        c redMax = redMax
        c redSpeed = redSpeed
        c greenMin = greenMin
        c greenMax = greenMax
        c greenSpeed = greenSpeed
        c blueMin = blueMin
        c blueMax = blueMax
        c blueSpeed = blueSpeed
        c alphaMin = alphaMin
        c alphaMax = alphaMax
        c alphaSpeed = alphaSpeed
        c redAnimate = redAnimate
        c greenAnimate = greenAnimate
        c blueAnimate = blueAnimate
        c alphaAnimate = alphaAnimate
        c repeat = repeat
        replaceComponent(Component ColorTween as Int, c) 
        if (previousComponent != null)
            __colorTweenComponentPool push(previousComponent)
        this
    }
    /**
     * @returns entitas.Entity
     */
    removeColorTween: func() -> This {
        c := getColorTween()
        removeComponent(Component ColorTween as Int) 
        __colorTweenComponentPool push(c)
        this
    }


    /* Entity: Destroy methods*/

    /** @type boolean */
    isDestroy : Bool {
        get { hasComponent(Component Destroy as Int) }
    }
    /**
     * @param value boolean
     * @return entitas.Entity
     */
    setDestroy: func(value : Bool) -> This {
        index := Component Destroy as Int
        c := __destroyComponent
        if (value) {
            addComponent(index, c)
        } else {
            removeComponent(index)
        }
        this
    }


    /* Entity: Enemy methods*/

    /** @type boolean */
    isEnemy : Bool {
        get { hasComponent(Component Enemy as Int) }
    }
    /**
     * @param value boolean
     * @return entitas.Entity
     */
    setEnemy: func(value : Bool) -> This {
        index := Component Enemy as Int
        c := __enemyComponent
        if (value) {
            addComponent(index, c)
        } else {
            removeComponent(index)
        }
        this
    }


    /* Entity: Expires methods*/

    /** @type Expires */
    getExpires: func() -> ExpiresComponent {
        getComponent(Component Expires as Int) as ExpiresComponent
    }
    /** @type boolean */
    hasExpires : Bool {
        get { hasComponent(Component Expires as Int) }
    }
    clearExpiresComponentPool: func() {
        __expiresComponentPool clear()
    }
    /**
     * @param delay Double
     * @return entitas.Entity
     */
    addExpires: func(delay:Double) -> This {
        c := __expiresComponentPool size > 0 ? __expiresComponentPool pop() : ExpiresComponent new()
        c delay = delay
        addComponent(Component Expires as Int, c)
        this
    }
    /**
     * @param delay Double
     * @return entitas.Entity
     */
    replaceExpires: func(delay:Double) -> This {
        previousComponent := this hasExpires ? this getExpires() : null
        c := __expiresComponentPool size > 0 ? __expiresComponentPool pop() : ExpiresComponent new()
        c delay = delay
        replaceComponent(Component Expires as Int, c) 
        if (previousComponent != null)
            __expiresComponentPool push(previousComponent)
        this
    }
    /**
     * @returns entitas.Entity
     */
    removeExpires: func() -> This {
        c := getExpires()
        removeComponent(Component Expires as Int) 
        __expiresComponentPool push(c)
        this
    }


    /* Entity: Health methods*/

    /** @type Health */
    getHealth: func() -> HealthComponent {
        getComponent(Component Health as Int) as HealthComponent
    }
    /** @type boolean */
    hasHealth : Bool {
        get { hasComponent(Component Health as Int) }
    }
    clearHealthComponentPool: func() {
        __healthComponentPool clear()
    }
    /**
     * @param health Double
     * @param maximumHealth Double
     * @return entitas.Entity
     */
    addHealth: func(health:Double,maximumHealth:Double) -> This {
        c := __healthComponentPool size > 0 ? __healthComponentPool pop() : HealthComponent new()
        c health = health
        c maximumHealth = maximumHealth
        addComponent(Component Health as Int, c)
        this
    }
    /**
     * @param health Double
     * @param maximumHealth Double
     * @return entitas.Entity
     */
    replaceHealth: func(health:Double,maximumHealth:Double) -> This {
        previousComponent := this hasHealth ? this getHealth() : null
        c := __healthComponentPool size > 0 ? __healthComponentPool pop() : HealthComponent new()
        c health = health
        c maximumHealth = maximumHealth
        replaceComponent(Component Health as Int, c) 
        if (previousComponent != null)
            __healthComponentPool push(previousComponent)
        this
    }
    /**
     * @returns entitas.Entity
     */
    removeHealth: func() -> This {
        c := getHealth()
        removeComponent(Component Health as Int) 
        __healthComponentPool push(c)
        this
    }


    /* Entity: Layer methods*/

    /** @type Layer */
    getLayer: func() -> LayerComponent {
        getComponent(Component Layer as Int) as LayerComponent
    }
    /** @type boolean */
    hasLayer : Bool {
        get { hasComponent(Component Layer as Int) }
    }
    clearLayerComponentPool: func() {
        __layerComponentPool clear()
    }
    /**
     * @param ordinal Int
     * @return entitas.Entity
     */
    addLayer: func(ordinal:Int) -> This {
        c := __layerComponentPool size > 0 ? __layerComponentPool pop() : LayerComponent new()
        c ordinal = ordinal
        addComponent(Component Layer as Int, c)
        this
    }
    /**
     * @param ordinal Int
     * @return entitas.Entity
     */
    replaceLayer: func(ordinal:Int) -> This {
        previousComponent := this hasLayer ? this getLayer() : null
        c := __layerComponentPool size > 0 ? __layerComponentPool pop() : LayerComponent new()
        c ordinal = ordinal
        replaceComponent(Component Layer as Int, c) 
        if (previousComponent != null)
            __layerComponentPool push(previousComponent)
        this
    }
    /**
     * @returns entitas.Entity
     */
    removeLayer: func() -> This {
        c := getLayer()
        removeComponent(Component Layer as Int) 
        __layerComponentPool push(c)
        this
    }


    /* Entity: Player methods*/

    /** @type boolean */
    isPlayer : Bool {
        get { hasComponent(Component Player as Int) }
    }
    /**
     * @param value boolean
     * @return entitas.Entity
     */
    setPlayer: func(value : Bool) -> This {
        index := Component Player as Int
        c := __playerComponent
        if (value) {
            addComponent(index, c)
        } else {
            removeComponent(index)
        }
        this
    }


    /* Entity: Position methods*/

    /** @type Position */
    getPosition: func() -> PositionComponent {
        getComponent(Component Position as Int) as PositionComponent
    }
    /** @type boolean */
    hasPosition : Bool {
        get { hasComponent(Component Position as Int) }
    }
    clearPositionComponentPool: func() {
        __positionComponentPool clear()
    }
    /**
     * @param x Double
     * @param y Double
     * @return entitas.Entity
     */
    addPosition: func(x:Double,y:Double) -> This {
        c := __positionComponentPool size > 0 ? __positionComponentPool pop() : PositionComponent new()
        c x = x
        c y = y
        addComponent(Component Position as Int, c)
        this
    }
    /**
     * @param x Double
     * @param y Double
     * @return entitas.Entity
     */
    replacePosition: func(x:Double,y:Double) -> This {
        previousComponent := this hasPosition ? this getPosition() : null
        c := __positionComponentPool size > 0 ? __positionComponentPool pop() : PositionComponent new()
        c x = x
        c y = y
        replaceComponent(Component Position as Int, c) 
        if (previousComponent != null)
            __positionComponentPool push(previousComponent)
        this
    }
    /**
     * @returns entitas.Entity
     */
    removePosition: func() -> This {
        c := getPosition()
        removeComponent(Component Position as Int) 
        __positionComponentPool push(c)
        this
    }


    /* Entity: Resource methods*/

    /** @type Resource */
    getResource: func() -> ResourceComponent {
        getComponent(Component Resource as Int) as ResourceComponent
    }
    /** @type boolean */
    hasResource : Bool {
        get { hasComponent(Component Resource as Int) }
    }
    clearResourceComponentPool: func() {
        __resourceComponentPool clear()
    }
    /**
     * @param path String
     * @param sprite SdlTexture
     * @param bgd Bool
     * @return entitas.Entity
     */
    addResource: func(path:String,sprite:SdlTexture,bgd:Bool) -> This {
        c := __resourceComponentPool size > 0 ? __resourceComponentPool pop() : ResourceComponent new()
        c path = path
        c sprite = sprite
        c bgd = bgd
        addComponent(Component Resource as Int, c)
        this
    }
    /**
     * @param path String
     * @param sprite SdlTexture
     * @param bgd Bool
     * @return entitas.Entity
     */
    replaceResource: func(path:String,sprite:SdlTexture,bgd:Bool) -> This {
        previousComponent := this hasResource ? this getResource() : null
        c := __resourceComponentPool size > 0 ? __resourceComponentPool pop() : ResourceComponent new()
        c path = path
        c sprite = sprite
        c bgd = bgd
        replaceComponent(Component Resource as Int, c) 
        if (previousComponent != null)
            __resourceComponentPool push(previousComponent)
        this
    }
    /**
     * @returns entitas.Entity
     */
    removeResource: func() -> This {
        c := getResource()
        removeComponent(Component Resource as Int) 
        __resourceComponentPool push(c)
        this
    }


    /* Entity: ScaleTween methods*/

    /** @type ScaleTween */
    getScaleTween: func() -> ScaleTweenComponent {
        getComponent(Component ScaleTween as Int) as ScaleTweenComponent
    }
    /** @type boolean */
    hasScaleTween : Bool {
        get { hasComponent(Component ScaleTween as Int) }
    }
    clearScaleTweenComponentPool: func() {
        __scaleTweenComponentPool clear()
    }
    /**
     * @param min Double
     * @param max Double
     * @param speed Double
     * @param repeat Bool
     * @param active Bool
     * @return entitas.Entity
     */
    addScaleTween: func(min:Double,max:Double,speed:Double,repeat:Bool,active:Bool) -> This {
        c := __scaleTweenComponentPool size > 0 ? __scaleTweenComponentPool pop() : ScaleTweenComponent new()
        c min = min
        c max = max
        c speed = speed
        c repeat = repeat
        c active = active
        addComponent(Component ScaleTween as Int, c)
        this
    }
    /**
     * @param min Double
     * @param max Double
     * @param speed Double
     * @param repeat Bool
     * @param active Bool
     * @return entitas.Entity
     */
    replaceScaleTween: func(min:Double,max:Double,speed:Double,repeat:Bool,active:Bool) -> This {
        previousComponent := this hasScaleTween ? this getScaleTween() : null
        c := __scaleTweenComponentPool size > 0 ? __scaleTweenComponentPool pop() : ScaleTweenComponent new()
        c min = min
        c max = max
        c speed = speed
        c repeat = repeat
        c active = active
        replaceComponent(Component ScaleTween as Int, c) 
        if (previousComponent != null)
            __scaleTweenComponentPool push(previousComponent)
        this
    }
    /**
     * @returns entitas.Entity
     */
    removeScaleTween: func() -> This {
        c := getScaleTween()
        removeComponent(Component ScaleTween as Int) 
        __scaleTweenComponentPool push(c)
        this
    }


    /* Entity: Scale methods*/

    /** @type Scale */
    getScale: func() -> ScaleComponent {
        getComponent(Component Scale as Int) as ScaleComponent
    }
    /** @type boolean */
    hasScale : Bool {
        get { hasComponent(Component Scale as Int) }
    }
    clearScaleComponentPool: func() {
        __scaleComponentPool clear()
    }
    /**
     * @param x Double
     * @param y Double
     * @return entitas.Entity
     */
    addScale: func(x:Double,y:Double) -> This {
        c := __scaleComponentPool size > 0 ? __scaleComponentPool pop() : ScaleComponent new()
        c x = x
        c y = y
        addComponent(Component Scale as Int, c)
        this
    }
    /**
     * @param x Double
     * @param y Double
     * @return entitas.Entity
     */
    replaceScale: func(x:Double,y:Double) -> This {
        previousComponent := this hasScale ? this getScale() : null
        c := __scaleComponentPool size > 0 ? __scaleComponentPool pop() : ScaleComponent new()
        c x = x
        c y = y
        replaceComponent(Component Scale as Int, c) 
        if (previousComponent != null)
            __scaleComponentPool push(previousComponent)
        this
    }
    /**
     * @returns entitas.Entity
     */
    removeScale: func() -> This {
        c := getScale()
        removeComponent(Component Scale as Int) 
        __scaleComponentPool push(c)
        this
    }


    /* Entity: Score methods*/

    /** @type Score */
    getScore: func() -> ScoreComponent {
        getComponent(Component Score as Int) as ScoreComponent
    }
    /** @type boolean */
    hasScore : Bool {
        get { hasComponent(Component Score as Int) }
    }
    clearScoreComponentPool: func() {
        __scoreComponentPool clear()
    }
    /**
     * @param value Double
     * @return entitas.Entity
     */
    addScore: func(value:Double) -> This {
        c := __scoreComponentPool size > 0 ? __scoreComponentPool pop() : ScoreComponent new()
        c value = value
        addComponent(Component Score as Int, c)
        this
    }
    /**
     * @param value Double
     * @return entitas.Entity
     */
    replaceScore: func(value:Double) -> This {
        previousComponent := this hasScore ? this getScore() : null
        c := __scoreComponentPool size > 0 ? __scoreComponentPool pop() : ScoreComponent new()
        c value = value
        replaceComponent(Component Score as Int, c) 
        if (previousComponent != null)
            __scoreComponentPool push(previousComponent)
        this
    }
    /**
     * @returns entitas.Entity
     */
    removeScore: func() -> This {
        c := getScore()
        removeComponent(Component Score as Int) 
        __scoreComponentPool push(c)
        this
    }


    /* Entity: SoundEffect methods*/

    /** @type SoundEffect */
    getSoundEffect: func() -> SoundEffectComponent {
        getComponent(Component SoundEffect as Int) as SoundEffectComponent
    }
    /** @type boolean */
    hasSoundEffect : Bool {
        get { hasComponent(Component SoundEffect as Int) }
    }
    clearSoundEffectComponentPool: func() {
        __soundEffectComponentPool clear()
    }
    /**
     * @param effect Int
     * @return entitas.Entity
     */
    addSoundEffect: func(effect:Int) -> This {
        c := __soundEffectComponentPool size > 0 ? __soundEffectComponentPool pop() : SoundEffectComponent new()
        c effect = effect
        addComponent(Component SoundEffect as Int, c)
        this
    }
    /**
     * @param effect Int
     * @return entitas.Entity
     */
    replaceSoundEffect: func(effect:Int) -> This {
        previousComponent := this hasSoundEffect ? this getSoundEffect() : null
        c := __soundEffectComponentPool size > 0 ? __soundEffectComponentPool pop() : SoundEffectComponent new()
        c effect = effect
        replaceComponent(Component SoundEffect as Int, c) 
        if (previousComponent != null)
            __soundEffectComponentPool push(previousComponent)
        this
    }
    /**
     * @returns entitas.Entity
     */
    removeSoundEffect: func() -> This {
        c := getSoundEffect()
        removeComponent(Component SoundEffect as Int) 
        __soundEffectComponentPool push(c)
        this
    }


    /* Entity: Text methods*/

    /** @type Text */
    getText: func() -> TextComponent {
        getComponent(Component Text as Int) as TextComponent
    }
    /** @type boolean */
    hasText : Bool {
        get { hasComponent(Component Text as Int) }
    }
    clearTextComponentPool: func() {
        __textComponentPool clear()
    }
    /**
     * @param text String
     * @param sprite SdlTexture
     * @return entitas.Entity
     */
    addText: func(text:String,sprite:SdlTexture) -> This {
        c := __textComponentPool size > 0 ? __textComponentPool pop() : TextComponent new()
        c text = text
        c sprite = sprite
        addComponent(Component Text as Int, c)
        this
    }
    /**
     * @param text String
     * @param sprite SdlTexture
     * @return entitas.Entity
     */
    replaceText: func(text:String,sprite:SdlTexture) -> This {
        previousComponent := this hasText ? this getText() : null
        c := __textComponentPool size > 0 ? __textComponentPool pop() : TextComponent new()
        c text = text
        c sprite = sprite
        replaceComponent(Component Text as Int, c) 
        if (previousComponent != null)
            __textComponentPool push(previousComponent)
        this
    }
    /**
     * @returns entitas.Entity
     */
    removeText: func() -> This {
        c := getText()
        removeComponent(Component Text as Int) 
        __textComponentPool push(c)
        this
    }


    /* Entity: Tint methods*/

    /** @type Tint */
    getTint: func() -> TintComponent {
        getComponent(Component Tint as Int) as TintComponent
    }
    /** @type boolean */
    hasTint : Bool {
        get { hasComponent(Component Tint as Int) }
    }
    clearTintComponentPool: func() {
        __tintComponentPool clear()
    }
    /**
     * @param r Int
     * @param g Int
     * @param b Int
     * @param a Int
     * @return entitas.Entity
     */
    addTint: func(r:Int,g:Int,b:Int,a:Int) -> This {
        c := __tintComponentPool size > 0 ? __tintComponentPool pop() : TintComponent new()
        c r = r
        c g = g
        c b = b
        c a = a
        addComponent(Component Tint as Int, c)
        this
    }
    /**
     * @param r Int
     * @param g Int
     * @param b Int
     * @param a Int
     * @return entitas.Entity
     */
    replaceTint: func(r:Int,g:Int,b:Int,a:Int) -> This {
        previousComponent := this hasTint ? this getTint() : null
        c := __tintComponentPool size > 0 ? __tintComponentPool pop() : TintComponent new()
        c r = r
        c g = g
        c b = b
        c a = a
        replaceComponent(Component Tint as Int, c) 
        if (previousComponent != null)
            __tintComponentPool push(previousComponent)
        this
    }
    /**
     * @returns entitas.Entity
     */
    removeTint: func() -> This {
        c := getTint()
        removeComponent(Component Tint as Int) 
        __tintComponentPool push(c)
        this
    }


    /* Entity: Velocity methods*/

    /** @type Velocity */
    getVelocity: func() -> VelocityComponent {
        getComponent(Component Velocity as Int) as VelocityComponent
    }
    /** @type boolean */
    hasVelocity : Bool {
        get { hasComponent(Component Velocity as Int) }
    }
    clearVelocityComponentPool: func() {
        __velocityComponentPool clear()
    }
    /**
     * @param x Double
     * @param y Double
     * @return entitas.Entity
     */
    addVelocity: func(x:Double,y:Double) -> This {
        c := __velocityComponentPool size > 0 ? __velocityComponentPool pop() : VelocityComponent new()
        c x = x
        c y = y
        addComponent(Component Velocity as Int, c)
        this
    }
    /**
     * @param x Double
     * @param y Double
     * @return entitas.Entity
     */
    replaceVelocity: func(x:Double,y:Double) -> This {
        previousComponent := this hasVelocity ? this getVelocity() : null
        c := __velocityComponentPool size > 0 ? __velocityComponentPool pop() : VelocityComponent new()
        c x = x
        c y = y
        replaceComponent(Component Velocity as Int, c) 
        if (previousComponent != null)
            __velocityComponentPool push(previousComponent)
        this
    }
    /**
     * @returns entitas.Entity
     */
    removeVelocity: func() -> This {
        c := getVelocity()
        removeComponent(Component Velocity as Int) 
        __velocityComponentPool push(c)
        this
    }


    initPools: func(){
        /* Preallocate component pools*/
        __boundsComponentPool = Stack<BoundsComponent> new()
        for(i in 1..POOL_SIZE) 
            __boundsComponentPool push(BoundsComponent new())

        __bulletComponent = BulletComponent new()
        __colorTweenComponentPool = Stack<ColorTweenComponent> new()
        for(i in 1..POOL_SIZE) 
            __colorTweenComponentPool push(ColorTweenComponent new())

        __destroyComponent = DestroyComponent new()

        __enemyComponent = EnemyComponent new()
        __expiresComponentPool = Stack<ExpiresComponent> new()
        for(i in 1..POOL_SIZE) 
            __expiresComponentPool push(ExpiresComponent new())
        __healthComponentPool = Stack<HealthComponent> new()
        for(i in 1..POOL_SIZE) 
            __healthComponentPool push(HealthComponent new())
        __layerComponentPool = Stack<LayerComponent> new()
        for(i in 1..POOL_SIZE) 
            __layerComponentPool push(LayerComponent new())

        __playerComponent = PlayerComponent new()
        __positionComponentPool = Stack<PositionComponent> new()
        for(i in 1..POOL_SIZE) 
            __positionComponentPool push(PositionComponent new())
        __resourceComponentPool = Stack<ResourceComponent> new()
        for(i in 1..POOL_SIZE) 
            __resourceComponentPool push(ResourceComponent new())
        __scaleTweenComponentPool = Stack<ScaleTweenComponent> new()
        for(i in 1..POOL_SIZE) 
            __scaleTweenComponentPool push(ScaleTweenComponent new())
        __scaleComponentPool = Stack<ScaleComponent> new()
        for(i in 1..POOL_SIZE) 
            __scaleComponentPool push(ScaleComponent new())
        __scoreComponentPool = Stack<ScoreComponent> new()
        for(i in 1..POOL_SIZE) 
            __scoreComponentPool push(ScoreComponent new())
        __soundEffectComponentPool = Stack<SoundEffectComponent> new()
        for(i in 1..POOL_SIZE) 
            __soundEffectComponentPool push(SoundEffectComponent new())
        __textComponentPool = Stack<TextComponent> new()
        for(i in 1..POOL_SIZE) 
            __textComponentPool push(TextComponent new())
        __tintComponentPool = Stack<TintComponent> new()
        for(i in 1..POOL_SIZE) 
            __tintComponentPool push(TintComponent new())
        __velocityComponentPool = Stack<VelocityComponent> new()
        for(i in 1..POOL_SIZE) 
            __velocityComponentPool push(VelocityComponent new())

    }
}

    /** @type Stack<Bounds> */
__boundsComponentPool : Stack<BoundsComponent>

/** @type Bullet */
__bulletComponent : BulletComponent
    /** @type Stack<ColorTween> */
__colorTweenComponentPool : Stack<ColorTweenComponent>

/** @type Destroy */
__destroyComponent : DestroyComponent

/** @type Enemy */
__enemyComponent : EnemyComponent
    /** @type Stack<Expires> */
__expiresComponentPool : Stack<ExpiresComponent>
    /** @type Stack<Health> */
__healthComponentPool : Stack<HealthComponent>
    /** @type Stack<Layer> */
__layerComponentPool : Stack<LayerComponent>

/** @type Player */
__playerComponent : PlayerComponent
    /** @type Stack<Position> */
__positionComponentPool : Stack<PositionComponent>
    /** @type Stack<Resource> */
__resourceComponentPool : Stack<ResourceComponent>
    /** @type Stack<ScaleTween> */
__scaleTweenComponentPool : Stack<ScaleTweenComponent>
    /** @type Stack<Scale> */
__scaleComponentPool : Stack<ScaleComponent>
    /** @type Stack<Score> */
__scoreComponentPool : Stack<ScoreComponent>
    /** @type Stack<SoundEffect> */
__soundEffectComponentPool : Stack<SoundEffectComponent>
    /** @type Stack<Text> */
__textComponentPool : Stack<TextComponent>
    /** @type Stack<Tint> */
__tintComponentPool : Stack<TintComponent>
    /** @type Stack<Velocity> */
__velocityComponentPool : Stack<VelocityComponent>

