import math
import structs/ArrayList
import structs/LinkedList
import structs/List
import structs/HashMap
import structs/Stack

import Entity
import Exceptions
import Group
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

World: class implements IOwner {

    components: static String[]
    instance : static World
    //random : Rand

    componentsCount: Int { get { _totalComponents } }
    count: Int { get { _entities size } }
    reusableEntitiesCount: Int { get { _reusableEntities size } }
    retainedEntitiesCount: Int { get { _retainedEntities size } }
    onEntityCreated : WorldChanged { get { _onEntityCreated } }
    onEntityWillBeDestroyed : WorldChanged { get { _onEntityWillBeDestroyed } }
    onEntityDestroyed : WorldChanged { get { _onEntityDestroyed } }
    onGroupCreated : GroupsChanged { get { _onGroupCreated} } 
    name : String { get { _name } }

    _onEntityCreated : WorldChanged
    _onEntityWillBeDestroyed : WorldChanged
    _onEntityDestroyed : WorldChanged
    _onGroupCreated : GroupsChanged
    _name: String

    _totalComponents    : Int = 0
    _creationIndex      : Int = 0
    _groups             : HashMap<String, Group>
    _entities           : HashMap<String, Entity>
    _retainedEntities   : HashMap<String, Entity>
    _reusableEntities   : Stack<Entity>
    _groupsForIndex     : ArrayList<ArrayList<Group>>
    _componentsEnum     : String[]
    _entitiesCache      : Entity[]
    _initializeSystems  : LinkedList<ISystem>
    _executeSystems     : LinkedList<ISystem>
    
    updateGroupsComponentAddedOrRemoved: Func(Entity, Int, IComponent) 
    updateGroupsComponentReplaced: Func(Entity, Int, IComponent, IComponent) 
    onEntityReleased: Func(Entity) 


    /**
     * @constructor
     * @param Object components
     * @param number totalComponents
     * @param number startCreationIndex
     */
    init: func(components : String[], startCreationIndex : Int=0) {
        //World _random = new Rand()
        World instance = this
        World components = components
        
        _onGroupCreated = GroupsChanged new()
        _onEntityCreated = WorldChanged new()
        _onEntityDestroyed = WorldChanged new()
        _onEntityWillBeDestroyed = WorldChanged new()

        _componentsEnum = components
        _totalComponents = components length
        _creationIndex = startCreationIndex
        _groupsForIndex = ArrayList<ArrayList<Group>> new()

        _reusableEntities = Stack<Entity> new()
        _retainedEntities = HashMap<String, Entity> new()
        _entitiesCache = Entity[0] new()
        _entities = HashMap<String, Entity> new()
        _groups = HashMap<String, Group> new()
        _initializeSystems = LinkedList<ISystem> new()
        _executeSystems = LinkedList<ISystem> new()
    }

    /**
     * Create a new entity
     * @param string name
     * @returns entitas Entity
     */
    createEntity: func(name : String) -> Entity {
        entity := _reusableEntities size > 0 ? _reusableEntities pop() : Entity new(_componentsEnum, _totalComponents) 
        _creationIndex += 1
        entity initialize(name, "", _creationIndex)
        _entities[entity id] = entity
        _entitiesCache = Entity[0] new()

        updateGroupsComponentAddedOrRemoved = func(entity : Entity, index : Int, component : IComponent) {
            if (index+1 <= _groupsForIndex size) {
                groups := _groupsForIndex[index]
                if (groups != null) {
                    try {
                        for (group in groups)
                            group handleEntity(entity, index, component)
                    } catch (e : Exception) {
                        assert(false)
                    }
                }
            }
        }

        updateGroupsComponentReplaced = func(entity : Entity, index : Int, previousComponent : IComponent, newComponent : IComponent) {
            if (index+1 <= _groupsForIndex size) {
                groups := _groupsForIndex[index]
                if (groups != null)
                    for (group in groups)
                        group updateEntity(entity, index, previousComponent, newComponent)
            }
        }
        
        onEntityReleased = func(entity : Entity) {
            if (entity isEnabled)
                /*raise new Exception EntityIsNotDestroyedException("Cannot release entity ")*/
                return

            entity onEntityReleased remove(entity onEntityReleasedId)
            _retainedEntities remove(entity id)
            _reusableEntities push(entity)
        }


        entity onComponentAddedId = entity onComponentAdded add(updateGroupsComponentAddedOrRemoved)
        entity onComponentRemovedId = entity onComponentRemoved add(updateGroupsComponentAddedOrRemoved)
        entity onComponentReplacedId = entity onComponentReplaced add(updateGroupsComponentReplaced)
        entity onEntityReleasedId = entity onEntityReleased add(onEntityReleased)
        onEntityCreated dispatch(this, entity)
        entity
    }

    /**
     * Destroy an entity
     * @param entitas Entity entity
     */
    destroyEntity: func(entity : Entity) {
        if (!_entities contains?(entity id))
            WorldDoesNotContainEntity new ("Could not destroy entity!") throw()

        _entities remove(entity id)
        _entitiesCache = Entity[0] new()
        _onEntityWillBeDestroyed dispatch(this, entity)
        entity destroy()

        _onEntityDestroyed dispatch(this, entity)

        if (entity refCount == 1) {
            entity onEntityReleased remove(entity onEntityReleasedId)
            _reusableEntities push(entity)
        } else {
            _retainedEntities[entity id] = entity
        }
        entity release()
    }
    /**
     * Destroy All Entities
     */
    destroyAllEntities: func() {
        entities := getEntities()
        for (i in 0..entities length-1) {
            destroyEntity(entities[i])
        }
    }

    /**
     * Check if pool has this entity
     *
     * @param entitas Entity entity
     * @returns boolean
     */
    hasEntity: func(entity : Entity) -> Bool {
        _entities contains?(entity id)
    }
    /**
     * Gets all of the entities
     *
     * @returns Array<entitas Entity>
     */
    getEntities: func(matcher : Matcher=null) -> Entity[] {
        if (matcher != null) {
            return getGroup(matcher) getEntities()
        } else {
            if (_entitiesCache length == 0) {
                _entitiesCache = Entity[_entitiesCache length] new()
                i := 0
                _entities each(|key, e| 
                    _entitiesCache[i] = e
                    i += 1
                )
            }
            return _entitiesCache
        }
    }
    /**
     * add System
     * @param entitas ISystem|Function
     * @returns entitas ISystem
     */
    add: func(system : ISystem) -> World {
        if (system instanceOf?(ISetWorld)) 
            system setWorld(this)

        if (system instanceOf?(IInitializeSystem))
            _initializeSystems add(system)

        if (system instanceOf?(IExecuteSystem))
            _executeSystems add(system)

        this
    }
    /**
     * Initialize Systems
     */
    initialize: func() -> World {
        for (sys in _initializeSystems)
            sys initialize()
        this
    }

    /**
     * Execute sustems
     */
    execute: func() {
        for (sys in _executeSystems)
            sys execute()
    }

    /**
     * Gets all of the entities that match
     *
     * @param entias IMatcher matcher
     * @returns entitas Group
     */
    getGroup: func(matcher : Matcher) -> Group {
        group:Group

        if (_groups contains?(matcher getId())) {
            group = _groups[matcher getId()]
        } else {
            group = Group new(matcher)

            entities := getEntities()
            try {
                for (i in 0..entities length-1)
                    group handleEntitySilently(entities[i])

            } catch (e : Exception) {
                assert(false)
            }

            _groups[matcher getId()] = group

            for (i in 0..matcher getIndices() length-1) {
                index := matcher getIndices()[i]
                if (_groupsForIndex[index] == null)
                    _groupsForIndex[index] = ArrayList<Group> new()
                _groupsForIndex[index] add(group)
            }
            _onGroupCreated dispatch(this, group)
        }
        group
    }

}