import structs/LinkedList
import structs/List

import entitas/Interfaces
import entitas/Entity
import entitas/Exceptions
import entitas/Group
import entitas/Matcher
import entitas/World

GroupsChangedListener : class {
    id: static Int = 0
    event: Func (World, Group)
    init: func(=event) {
        id = This id
        This id = id+1
    }
}


GroupsChanged : class {

    _listeners : List<GroupsChangedListener> = LinkedList<GroupsChangedListener> new()

    init: func()

    add: func(event : Func (World, Group)) -> Int {
        listener := GroupsChangedListener new(event)
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
        _listeners = LinkedList<GroupsChangedListener> new()
    }

    dispatch: func(w : World, g : Group) {
        for (listener in _listeners)
            listener event(w, g)
    }

}