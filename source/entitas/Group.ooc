import math
import structs/ArrayList
import structs/LinkedList
import structs/HashMap

import Entity
import Exceptions
import Interfaces
import Matcher
import World
import events/EntityChanged
import events/EntityReleased
import events/GroupChanged
import events/GroupsChanged
import events/GroupUpdated
import events/WorldChanged
import events/ComponentReplaced

Group: class {

    _onEntityAdded : GroupChanged
    _onEntityRemoved : GroupChanged
    _onEntityUpdated : GroupUpdated


    onEntityAdded: GroupChanged { get { _onEntityAdded } }
    onEntityRemoved: GroupChanged { get { _onEntityRemoved } }
    onEntityUpdated: GroupUpdated { get { _onEntityUpdated } }

    count: Int { get { _entities size } }
    matcher: Matcher { get { _matcher } }

    _matcher            : Matcher
    _entities           : HashMap<String, Entity>
    _entitiesCache      : Entity[]
    _singleEntityCache  : Entity
    _toStringCache      : String

    init: func(=_matcher) {
        _entities = HashMap<String, Entity> new()
        _entitiesCache = Entity[0] new()
        _onEntityAdded = GroupChanged new()
        _onEntityRemoved = GroupChanged new()
        _onEntityUpdated = GroupUpdated new()
    }

    /**
     * Handle adding and removing component from the entity without raising events
     * @param entity
     */
    handleEntitySilently: func(entity : Entity) {
        if (_matcher matches(entity))
            addEntitySilently(entity)
        else
            removeEntitySilently(entity)
    }

    /**
     * Handle adding and removing component from the entity and raisieevents
     * @param entity
     * @param index
     * @param component
     */
    handleEntity: func(entity : Entity, index : Int, component : IComponent) {
        if (_matcher matches(entity))
            addEntity(entity, index, component)
        else
            removeEntity(entity, index, component)
    }

    /**
     * Update entity and raise events
     * @param entity
     * @param index
     * @param previousComponent
     * @param newComponent
     */
    updateEntity: func(entity : Entity, index : Int, previousComponent : IComponent, newComponent : IComponent) {
        if (_entities contains?(entity id)) {
            _onEntityRemoved dispatch(this, entity, index, previousComponent)
            _onEntityAdded dispatch(this, entity, index, newComponent)
            _onEntityUpdated dispatch(this, entity, index, previousComponent, newComponent)
        }
    }

    /**
     * Add entity without raising events
     * @param entity
     */
    addEntitySilently: func(entity : Entity) {
        if (!_entities contains?(entity id)) {
            _entities[entity id] = entity
            _entitiesCache = Entity[0] new()
            _singleEntityCache = null
            entity addRef()
        }
    }
    /**
     * Add entity and raise events
     * @param entity
     * @param index
     * @param component
     */
    addEntity: func(entity : Entity, index : Int, component : IComponent) {
        if (!_entities contains?(entity id)) {
            _entities[entity id] = entity
            _entitiesCache = Entity[0] new()
            _singleEntityCache = null
            entity addRef()
            _onEntityAdded dispatch(this, entity, index, component)
        }
    }
    /**
     * Remove entity without raising events
     * @param entity
     */
    removeEntitySilently: func(entity : Entity) {
        if (_entities contains?(entity id)) {
            _entities remove(entity id)
            _entitiesCache = Entity[0] new()
            _singleEntityCache = null
            entity release()
        }
    }

    /**
     * Remove entity and raise events
     * @param entity
     * @param index
     * @param component
     */
    removeEntity: func(entity : Entity, index : Int, component : IComponent) {
        if (_entities contains?(entity id)) {
            _entities remove(entity id)
            _entitiesCache = Entity[0] new()
            _singleEntityCache = null
            _onEntityRemoved dispatch(this, entity, index, component)
            entity release()
        }
    }
    /**
     * Check if group has this entity
     *
     * @param entity
     * @returns boolean
     */
    containsEntity: func(entity : Entity) -> Bool {
        _entities contains?(entity id)
    }

    /**
     * Get a list of the entities in this group
     *
     * @returns Array<entitas Entity>
     */
    getEntities: func() -> Entity[] {
        if (_entitiesCache length == 0) {
            _entitiesCache = Entity[_entities getSize()] new()
            i := 0
            _entities each(|key, e|
                _entitiesCache[i] = e
                i += 1
            )
        }
        _entitiesCache
    }

    /**
     * Gets an entity singleton 
     * If a group has more than 1 entity, this is an error condition 
     *
     * @returns entitas Entity
     */
    getSingleEntity: func() -> Entity {
        if (_singleEntityCache == null) {
            c := _entities getSize()
            if (c == 1) 
                _entities each(|key, e|
                    _singleEntityCache = e)
            else if (c == 0)
                return null
            else
                // SingleEntityException new(_matcher toString()) throw()
                SingleEntityException new("stuff") throw()
        }
        _singleEntityCache
    }

    /**
     * Create a string representation for this group:
     *
     *    ex: 'Group(Position)'
     *
     * @returns string
     */
    toString: func() -> String {
        //componentsEnum
        if (_toStringCache == "") {
            l := _matcher getIndices() length-1
            for (i in 0..l) {
                index := _matcher getIndices()[i]
                _toStringCache += World components[index] replaceAll("Component", "")
            }
            // for (index in _matcher getIndices())
            //     _toStringCache += World components[index] replace("Component", "")
            //_toStringCache = "Group(" + String joinv(",", sb) + ")"
        }
        _toStringCache
    }
}