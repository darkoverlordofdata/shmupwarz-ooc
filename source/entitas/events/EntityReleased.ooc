import structs/LinkedList
import structs/List

import entitas/Interfaces
import entitas/Entity
import entitas/Exceptions
import entitas/Group
import entitas/Matcher
import entitas/World

EntityReleasedListener : class {
    id: static Int = 0
    event: Func (Entity)
    init: func(=event) {
        id = This id
        This id = id+1
    }
}


EntityReleased : class {

    _listeners : List<EntityReleasedListener> = LinkedList<EntityReleasedListener> new()

    init: func()

    add: func(event : Func (Entity)) -> Int {
        listener := EntityReleasedListener new(event)
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
        _listeners = LinkedList<EntityReleasedListener> new()
    }

    dispatch: func(e : Entity) {
        for (listener in _listeners)
            listener event(e)
    }

}