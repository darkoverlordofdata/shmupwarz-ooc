


EntityIsNotEnabled: class extends Exception {
    init: func(msg: String) {
        super("Entity is Not Enabled: %s" format(msg))
    }
}
EntityAlreadyHasComponent: class extends Exception {
    init: func(name: String, index: Int) {
        super("Cannot add %s at index %d" format(name, index))
    }
}
EntityDoesNotHaveComponent: class extends Exception {
    init: func(name: String, index: Int) {
        super("Cannot remove %s at index %d: %s" format(name, index))
    }
}
EntityIsAlreadyReleased: class extends Exception {
    init: func(id: String, name: String) {
        super("Entity is Already Released %s: %s" format(id, name))
    }
}
SingleEntityException: class extends Exception {
    init: func(matcher: String) {
        super("Single Entity Exception in : %s" format(matcher))
    }
}
MatcherException: class extends Exception {
    init: func(msg: String) {
        super(": %s" format(msg))
    }
}
WorldDoesNotContainEntity: class extends Exception {
    init: func(msg: String) {
        super(": %s" format(msg))
    }
}
