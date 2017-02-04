import structs/LinkedList
import structs/List

import entitas/Interfaces
import entitas/Entity
import entitas/Exceptions
import entitas/Group
import entitas/Matcher
import entitas/World

WorldChangedListener : class {
    id: static Int = 0
    event: Func (World, Entity)
    init: func(=event) {
        id = This id
        This id = id+1
    }
}


WorldChanged : class {

    _listeners : List<WorldChangedListener> = LinkedList<WorldChangedListener> new()

    init: func()

    add: func(event : Func (World, Entity)) -> Int {
        listener := WorldChangedListener new(event)
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
        _listeners = LinkedList<WorldChangedListener> new()
    }

    dispatch: func(w : World, e : Entity) {
        for (listener in _listeners)
            listener event(w, e)
    }

}