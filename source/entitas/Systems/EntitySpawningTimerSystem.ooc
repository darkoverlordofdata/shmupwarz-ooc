import Entity
import Exceptions
import Group
import Interfaces
import Matcher
import World



EntitySpawningTimerSystem : class implements  ISetWorld,  IExecuteSystem,  IInitializeSystem, ISystem
    _game : Game
    _world: World

    init: func(=game)



    setWorld: func(world: World) {
        _world = world
    }


    execute: func(){}


    initialize: func(){}


