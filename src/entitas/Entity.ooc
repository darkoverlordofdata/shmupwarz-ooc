import math
import structs/ArrayList
import structs/LinkedList

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

Entity: class {

    _creationIndex: Int
    _name: String
    _id: String
    _isEnabled: Bool
    _onEntityReleased : EntityReleased
    _onComponentAdded : EntityChanged
    _onComponentRemoved : EntityChanged
    _onComponentReplaced : ComponentReplaced
    onEntityReleasedId : Int
    onComponentAddedId : Int
    onComponentRemovedId : Int
    onComponentReplacedId : Int

    creationIndex: Int { get { _creationIndex } }    
    name: String { get { _name } }
    id: String { get { _id } }
    isEnabled: Bool { get { _isEnabled } }
    onEntityReleased: EntityReleased { get { _onEntityReleased } }
    onComponentAdded: EntityChanged { get { _onComponentAdded } }
    onComponentRemoved: EntityChanged { get { _onComponentRemoved } }
    onComponentReplaced: ComponentReplaced { get { _onComponentReplaced } }


    first           : static Bool = true
    maxEntities     : static Int = 128
    incEntities     : static Int = 64
    db_index        : static Int = 0
    _components     : static IComponent[]

    db_id           : Int = 0
    ic              : Int = 0
    refCount       : Int = 0
    _totalComponents: Int
    _componentCount : Int
    _toStringCache  : String
    _componentsEnum : String[]
    _world          : World
    _componentsCache: IComponent[]
    _indiceCache    : Int[]


    /**
     * The basic game object  Everything is an entity with components that
     * are added / removed as needed 
     *
     * @param Object componentsEnum
     * @param number totalComponents
     * @constructor
     */
    init: func(componentsEnum: String[], totalComponents : Int = 32) {
        _totalComponents = totalComponents
        _componentCount = componentsEnum length

        if (first) {
            _components = IComponent[_componentCount * maxEntities] new()
            first = false
        }

        // if (db_index >= maxEntities) {
        //     maxEntities += incEntities
        //     _components resize(_componentCount * maxEntities)
        // }

        db_id = db_index += 1
        ic = db_id * _componentCount

        _onEntityReleased = EntityReleased new()
        _onComponentAdded = EntityChanged new()
        _onComponentRemoved = EntityChanged new()
        _onComponentReplaced = ComponentReplaced new()
        _indiceCache = Int[totalComponents] new()
        _componentsEnum = componentsEnum
        _world = World instance
        
    }

    /**
     * Initialize the entity after allocation from the pool
     *
     * @param string  name
     * @param string  id
     * @param int creationIndex
     */
    initialize: func(name: String, id: String, creationIndex: Int) {
        _name = name
        _creationIndex = creationIndex
        _isEnabled = true
        _id = id
        addRef()
    }

    /**
     * AddComponent
     *
     * @param number index
     * @param entitas IComponent component
     * @returns entitas Entity
     */
    addComponent: func(index : Int, component : IComponent) -> Entity {
        if (!_isEnabled)
            EntityIsNotEnabled new("Cannot add component!") throw()

        if (hasComponent(index))
            EntityAlreadyHasComponent new(_componentsEnum[index], index) throw()

        _components[ic+index] = component
        _componentsCache = IComponent[0] new()
        _indiceCache = Int[0] new()
        _toStringCache = ""
        _onComponentAdded dispatch(this, index, component)
        this
    }    

    /**
     * RemoveComponent
     *
     * @param number index
     * @returns entitas Entity
     */
    removeComponent: func(index : Int) -> Entity {
        if (!_isEnabled)
            EntityIsNotEnabled new("Cannot remove component!") throw()

        if (!hasComponent(index))
            EntityDoesNotHaveComponent new(_componentsEnum[index], index) throw()

        _replaceComponent(index, null)
        this
    }
    
    /**
     * ReplaceComponent
     *
     * @param number index
     * @param entitas IComponent component
     * @returns entitas Entity
     */
    replaceComponent: func(index : Int, component : IComponent) -> Entity {
        if (!_isEnabled)
            EntityIsNotEnabled new("Cannot replace component!") throw()

        if (hasComponent(index)) {
            _replaceComponent(index, component)
        }
        else if (component != null) {
            addComponent(index, component)
        }
        this
    }

    _replaceComponent: func(index : Int, replacement : IComponent) {
        previousComponent := _components[ic+index]
        if (previousComponent == replacement) {
            _onComponentReplaced dispatch(this, index, previousComponent, replacement)
        } else {
            _components[ic+index] = replacement
            _componentsCache = IComponent[0] new()
            if (replacement == null) {
                _components[ic+index] = null
                _indiceCache = Int[0] new()
                _toStringCache = ""
                _onComponentRemoved dispatch(this, index, previousComponent)
            } else {
                _onComponentReplaced dispatch(this, index, previousComponent, replacement)
            }
        }
    }

    /**
     * GetComponent
     *
     * @param number index
     * @param entitas IComponent component
     */
    getComponent: func(index : Int) -> IComponent{
        if (!hasComponent(index))
            EntityDoesNotHaveComponent new(_componentsEnum[index], index) throw()

        _components[ic+index]
    }

    /**
     * GetComponents
     *
     * @returns Array<entitas IComponent>
     */
    getComponents: func() -> IComponent[] {
        if (_componentsCache length == 0) {
            components := IComponent[_componentCount] new()
            //for var component in _components
            for (i in ic..ic+_componentCount-1) {
                if (_components[i] != null)
                    components[ic-i]= _components[i]
            }
            _componentsCache = components
        }
        _componentsCache
    }

    /**
     * GetComponentIndices
     *
     * @returns Array<number>
     */
    getComponentIndices: func() -> Int[] {
        if (_indiceCache length == 0) {
            indices := Int[_componentCount] new()
            index := 0
            for (i in ic..ic+_componentCount-1) {
                if (_components[i] != null)
                    indices[ic-i] = index
                index += 1
            }
            _indiceCache = indices
        }
        _indiceCache
    }

    /**
     * HasComponent
     *
     * @param number index
     * @returns boolean
     */
    hasComponent: func(index: Int) -> Bool {
        _components[ic+index] != null
    }


    /**
     * HasComponents
     *
     * @param Array<number> indices
     * @returns boolean
     */
    hasComponents: func(indices: Int[]) -> Bool {
        for (index in 0..indices length)
            if (_components[ic+index] == null)
                return false
        
        true
    }

    /**
     * HasAnyComponent
     *
     * @param Array<number> indices
     * @returns boolean
     */
    hasAnyComponent: func(indices: Int[]) -> Bool {
        for (index in 0..indices length) {
            if (_components[ic+index] != null)
                return true
        }
        false
    }

    /**
     * RemoveAllComponents
     *
     */
    removeAllComponents: func() {
        _toStringCache = ""
        index := 0
        for (i in ic..ic+_componentCount-1) {
            if (_components[i] != null)
                _replaceComponent(index, null)
            index += 1
        }
    }
    
    /**
     * Destroy
     *
     */
    destroy: func() {
        removeAllComponents()
        _onComponentAdded clear()
        _onComponentReplaced clear()
        _onComponentRemoved clear()
        _isEnabled = false
    }
    
    /**
     * ToString
     *
     * @returns string
     */
    toString: func() -> String {
        if (_toStringCache == "") {
            seperator := ", "

            components := getComponentIndices()
            lastSeperator := components length - 1
            for (i in 0..lastSeperator) {
                _toStringCache += _componentsEnum[components[i]] replaceAll("Component", "")
                if (i < lastSeperator)
                    _toStringCache += seperator
            }
        }
        _toStringCache
    }
    

    /**
     * AddRef
     *
     * @returns entitas Entity
     */
    addRef: func() -> Entity {
        refCount += 1
        this
    }
    

    /**
     * Release
     *
     */
    release: func()  {
        refCount -= 1
        if (refCount == 0)
            _onEntityReleased dispatch(this)
        else if (refCount < 0)
            EntityIsAlreadyReleased new(id, name) throw()
    }
}