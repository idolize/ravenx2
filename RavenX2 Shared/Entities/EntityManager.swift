
import SpriteKit
import GameplayKit

class EntityManager {
    
    var entities = Set<GKEntity>()
    var toRemove = Set<GKEntity>()
    let scene: SKScene
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    func add(_ entity: GKEntity) {
        entities.insert(entity)
        
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
        return entities.filter{ entity in
            if let teamComponent = entity.component(ofType: TeamComponent.self) {
                if teamComponent.team == team {
                    return true
                }
            }
            return false
        }
    }
    
    func update(_ deltaTime: CFTimeInterval) {
        for entity in entities {
            entity.update(deltaTime: deltaTime)
        }
        
        toRemove.removeAll()
    }
}


#if os(iOS)
// Handle touch events
extension EntityManager {
    // This could be optimized to manage touch stuff globally (similar to keyboard)
    // instead of on each individual component
    private func performForAllTouchComponents(_ operation: (TouchComponent) -> Void) {
        for entity in entities {
            if let touchComponent = entity.component(ofType: TouchComponent.self) {
                operation(touchComponent)
            }
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
        for entity in entities {
            if let keyboardComponent = entity.component(ofType: KeyboardComponent.self) {
                component.handleKey(theEvent, isDown: isDown)
            }
        }
    }
}
#endif
