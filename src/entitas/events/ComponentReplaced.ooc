import structs/LinkedList
import structs/List

import entitas/Interfaces
import entitas/Entity
import entitas/Exceptions
import entitas/Group
import entitas/Matcher
import entitas/World

ComponentReplacedListener : class {
    id: static Int = 0
    event: Func (Entity, Int, IComponent, IComponent)
    init: func(=event) {
        id = This id
        This id = id+1
    } 
}


ComponentReplaced : class {

    _listeners : List<ComponentReplacedListener> = LinkedList<ComponentReplacedListener> new()
    
    init: func()

    add: func(event : Func (Entity, Int, IComponent, IComponent)) -> Int {

        listener := ComponentReplacedListener new(event)        
        _listeners add(listener)
        listener id
    }

    remove: func(eventId: Int) {
        for (listener in _listeners) 
            if (listener id == eventId) {
                _listeners remove(listener)
                return
            }
    }
    clear: func() {
        _listeners = LinkedList<ComponentReplacedListener> new()
    }

    dispatch: func(e : Entity, index : Int, component : IComponent, replacement : IComponent) {
        for (listener in _listeners)
            listener event(e, index, component, replacement)
    }

}