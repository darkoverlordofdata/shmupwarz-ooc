import math
import structs/ArrayList
import structs/LinkedList

import Entity
import Exceptions
import Interfaces
import Matcher
import World

IComponent: abstract class {
}

IOwner: interface {

}
IMatcher: interface {
    getId: func -> String
    getIndices: func-> Int[]
    matches: func(entity: Entity) -> Bool
    toString: func -> String
}


ICompoundMatcher: interface {
    getAllOfIndices: func() -> Int[] 
    getAnyOfIndices: func() -> Int[] 
    getNoneOfIndices: func() -> Int[] 
}

INoneOfMatcher: interface {

}

IAnyOfMatcher: interface {
    noneOf: func(args: Int[]) -> INoneOfMatcher 
}

IAllOfMatcher: interface {
    anyOf: func(args: Int[]) -> IAnyOfMatcher
    noneOf: func(args: Int[]) -> INoneOfMatcher
}


// ISystem: interface  {

// }

ISystem: abstract class  {
    setWorld: abstract func(world: World)
    initialize: abstract func()
    execute: abstract func()
}

ISetWorld: interface {
    setWorld: func(world: World)
}

IExecuteSystem: interface  {
    execute: func()
}

IInitializeSystem: interface  {
    initialize: func()
}
