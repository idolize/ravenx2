
import SpriteKit
import GameplayKit

enum System {
    case firing, touch, keyboard
}

class EntityManager {
    
    var entities = Set<GKEntity>()
    var toRemove = Set<GKEntity>()
    let scene: SKScene
    
    lazy var componentSystems: [System: GKComponentSystem] = {
        var systems = [System: GKComponentSystem]()
        systems[System.firing] = GKComponentSystem(componentClass: FiringComponent.self)
        #if os(iOS)
        systems[System.touch] = GKComponentSystem(componentClass: TouchComponent.self)
        #endif
        #if os(OSX)
        systems[System.keyboard] = GKComponentSystem(componentClass: KeyboardComponent.self)
        #endif
        return systems
    }()
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    func add(_ entity: GKEntity) {
        entities.insert(entity)
        
        for componentSystem in componentSystems.values {
            componentSystem.addComponent(foundIn: entity)
        }
        
        if let spriteNode = entity.component(ofType: NodeComponent.self)?.node {
            scene.addChild(spriteNode)
        }
    }
    
    func remove(_ entity: GKEntity) {
        if let spriteNode = entity.component(ofType: NodeComponent.self)?.node {
            spriteNode.removeFromParent()
        }
        
        toRemove.insert(entity)
        entities.remove(entity)
    }
    
    func entitiesForTeam(_ team: Team) -> [GKEntity] {
        return entities.compactMap{ entity in
            if let teamComponent = entity.component(ofType: TeamComponent.self) {
                if teamComponent.team == team {
                    return entity
                }
            }
            return nil
        }
    }
    
    func update(_ deltaTime: CFTimeInterval) {
        let componentSystemsFlat = componentSystems.values
        for componentSystem in componentSystemsFlat {
            componentSystem.update(deltaTime: deltaTime)
        }
        for entity in entities {
            entity.update(deltaTime: deltaTime)
        }
        
        for curRemove in toRemove {
            for componentSystem in componentSystemsFlat {
                componentSystem.removeComponent(foundIn: curRemove)
            }
        }
        toRemove.removeAll()
    }
}


#if os(iOS)
// Handle touch events
extension EntityManager {
    private func performForAllTouchComponents(_ operation: (TouchComponent) -> Void) {
        for case let component as TouchComponent in componentSystems[System.touch]?.components ?? [] {
            operation(component)
        }
    }
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        performForAllTouchComponents({ component in
            component.touchesBegan(touches, with: event, in: scene)
        })
    }
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        performForAllTouchComponents({ component in
            component.touchesMoved(touches, with: event, in: scene)
        })
    }
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        performForAllTouchComponents({ component in
            component.touchesEnded(touches, with: event, in: scene)
        })
    }
    
    func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        performForAllTouchComponents({ component in
            component.touchesCancelled(touches, with: event, in: scene)
        })
    }
}
#endif

#if os(OSX)
// Handle keyboard events
extension EntityManager {
    func handleKey(theEvent: NSEvent, isDown: Bool) {
        for case let component as KeyboardComponent in componentSystems[System.keyboard]?.components ?? [] {
            component.handleKey(theEvent, isDown: isDown)
        }
    }
}
#endif
