import math
import math/Random
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

World: class {

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

    _hex := [ // hex identity values 0-255
        "00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "0a", "0b", "0c", "0d", "0e", "0f",
        "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "1a", "1b", "1c", "1d", "1e", "1f",
        "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "2a", "2b", "2c", "2d", "2e", "2f",
        "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "3a", "3b", "3c", "3d", "3e", "3f",
        "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "4a", "4b", "4c", "4d", "4e", "4f",
        "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "5a", "5b", "5c", "5d", "5e", "5f",
        "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "6a", "6b", "6c", "6d", "6e", "6f",
        "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "7a", "7b", "7c", "7d", "7e", "7f",
        "80", "81", "82", "83", "84", "85", "86", "87", "88", "89", "8a", "8b", "8c", "8d", "8e", "8f",
        "90", "91", "92", "93", "94", "95", "96", "97", "98", "99", "9a", "9b", "9c", "9d", "9e", "9f",
        "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7", "a8", "a9", "aa", "ab", "ac", "ad", "ae", "af",
        "b0", "b1", "b2", "b3", "b4", "b5", "b6", "b7", "b8", "b9", "ba", "bb", "bc", "bd", "be", "bf",
        "c0", "c1", "c2", "c3", "c4", "c5", "c6", "c7", "c8", "c9", "ca", "cb", "cc", "cd", "ce", "cf",
        "d0", "d1", "d2", "d3", "d4", "d5", "d6", "d7", "d8", "d9", "da", "db", "dc", "dd", "de", "df",
        "e0", "e1", "e2", "e3", "e4", "e5", "e6", "e7", "e8", "e9", "ea", "eb", "ec", "ed", "ee", "ef",
        "f0", "f1", "f2", "f3", "f4", "f5", "f6", "f7", "f8", "f9", "fa", "fb", "fc", "fd", "fe", "ff"
    ]


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
        entity initialize(name, uidgen(), _creationIndex)
        _entities[entity id] = entity
        _entitiesCache = Entity[0] new()

        /*
         * @param entitas.IEntity entity
         * @param number index
         * @param entitas.IComponent component
         */
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

        /*
         * @param entitas.IEntity entity
         * @param number index
         * @param entitas.IComponent previousComponent
         * @param entitas.IComponent newComponent
         */
        updateGroupsComponentReplaced = func(entity : Entity, index : Int, previousComponent : IComponent, newComponent : IComponent) {
            if (index+1 <= _groupsForIndex size) {
                groups := _groupsForIndex[index]
                if (groups != null)
                    for (group in groups)
                        group updateEntity(entity, index, previousComponent, newComponent)
            }
        }
        
        /*
         * @param entitas.IEntity entity
         */
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

    /**
    * Fast UUID generator, RFC4122 version 4 compliant
    * format xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
    *
    * uid is used as id for entities for better distribution 
    * in hash tables than an incrementing id
    *
    *
    * @author Jeff Ward (jcward.com).
    * @license MIT license
    * @link http://stackoverflow.com/questions/105034/how-to-create-a-guid-uuid-in-javascript/21963136#21963136
    **/

    uidgen: func() -> String {


        d0 := Random randInt(0, 0xffff)
        d1 := Random randInt(0, 0xffff)
        d2 := Random randInt(0, 0xffff)
        d3 := Random randInt(0, 0xffff)

        hex00 := d0 & 0xff
        hex01 := d0 >> 16 & 0xff
        hex02 := d0 >> 24 & 0xff
        hex03 := d1 & 0xff
        hex04 := d1 >> 8 & 0xff
        hex05 := d1 >> 16 & 0x0f | 0x40
        hex06 := d1 >> 24 & 0xff
        hex07 := d2 & 0x3f | 0x80
        hex08 := d2 >> 8 & 0xff
        hex09 := d2 >> 16 & 0xff
        hex10 := d2 >> 24 & 0xff
        hex11 := d3 & 0xff
        hex12 := d3 >> 8 & 0xff
        hex13 := d3 >> 16 & 0xff
        hex14 := d3 >> 24 & 0xff
        //int hex15 = 0

        sb := ""

        sb = sb + _hex[hex00]
        sb = sb + _hex[hex01]
        sb = sb + _hex[hex02]
        sb = sb + "-"
        sb = sb + _hex[hex03]
        sb = sb + _hex[hex04]
        sb = sb + "-"
        sb = sb + _hex[hex05]
        sb = sb + _hex[hex06]
        sb = sb + "-"
        sb = sb + _hex[hex07]
        sb = sb + _hex[hex08]
        sb = sb + "-"
        sb = sb + _hex[hex09]
        sb = sb + _hex[hex10]
        sb = sb + _hex[hex11]
        sb = sb + _hex[hex12]
        sb = sb + _hex[hex13]
        sb = sb + _hex[hex14]

        return sb
    }


}