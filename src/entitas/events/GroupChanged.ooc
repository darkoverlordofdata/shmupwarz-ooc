import structs/LinkedList
import structs/List

import entitas/Interfaces
import entitas/Entity
import entitas/Exceptions
import entitas/Group
import entitas/Matcher
import entitas/World

GroupChangedListener : class {
    id: static Int = 0
    event: Func (Group, Entity, Int, IComponent)
    init: func(=event) {
        id = This id
        This id = id+1
    }
}


GroupChanged : class {

    _listeners : List<GroupChangedListener> = LinkedList<GroupChangedListener> new()

    init: func() 

    add: func(event : Func (Group, Entity, Int, IComponent)) -> Int {
        listener := GroupChangedListener new(event)
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
        _listeners = LinkedList<GroupChangedListener> new()
    }

    dispatch: func(g : Group, e : Entity, index: Int, component : IComponent) {
        for (listener in _listeners)
            listener event(g, e, index, component)
    }

}