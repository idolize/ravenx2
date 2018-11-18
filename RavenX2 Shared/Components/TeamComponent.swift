import Foundation
import SpriteKit
import GameplayKit

enum Team: Int {
    case good = 1
    case bad = 2
    
    static let allValues = [good, bad]
    
    func oppositeTeam() -> Team {
        switch self {
        case .good:
            return .bad
        case .bad:
            return .good
        }
    }
}

class TeamComponent: GKComponent {
    let team: Team
    
    init(team: Team) {
        self.team = team
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
