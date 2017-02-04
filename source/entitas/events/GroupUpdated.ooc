import structs/LinkedList
import structs/List

import entitas/Interfaces
import entitas/Entity
import entitas/Exceptions
import entitas/Group
import entitas/Matcher
import entitas/World

GroupUpdatedListener : class {
    id: static Int = 0
    event: Func (Group, Entity, Int, IComponent, IComponent)
    init: func(=event) {
        id = This id
        This id = id+1
    }
}


GroupUpdated : class {

    _listeners : List<GroupUpdatedListener> = LinkedList<GroupUpdatedListener> new()

    init: func()

    add: func(event : Func (Group, Entity, Int, IComponent, IComponent)) -> Int {
        listener := GroupUpdatedListener new(event)
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
        _listeners = LinkedList<GroupUpdatedListener> new()
    }

    dispatch: func(g : Group, e : Entity, index: Int, component : IComponent, replacement : IComponent) {
        for (listener in _listeners)
            listener event(g, e, index, component, replacement)
    }

}