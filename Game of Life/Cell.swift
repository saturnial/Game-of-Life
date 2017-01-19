import UIKit

struct Cell {
    
    static let Length = UIScreen.main.bounds.width /
        CGFloat(World.Dimension)
    
    let id = UUID()
    
    enum State {
        case alive
        case dead
        
        var color: UIColor {
            switch self {
            case .alive:
                return .green
            case .dead:
                return .white
            }
        }
    }
    
    let x: Int, y: Int

    var state: State
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
        // Randomly decide whether the cell begins as dead or alive.
        switch arc4random_uniform(2) {
        case 1:
            self.state = .alive

        default:
            self.state = .dead
        }
    }
    
    func isNeighbor(of cell: Cell) -> Bool {
        let distance = (abs(self.x - cell.x), abs(self.y - cell.y))
        switch distance {
        case (1, 1), (1, 0), (0, 1):
            return true
        default:
            return false
        }
    }
}

extension Cell: Equatable {
    static func ==(lhs: Cell, rhs: Cell) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Cell: Hashable {
    var hashValue: Int {
        return self.id.hashValue
    }
}

extension Cell: Renderable {
    func makeView() -> UIView {
        let view = UIView()
        let origin = CGPoint(x: CGFloat(self.x) * Cell.Length,
                             y: CGFloat(self.y) * Cell.Length)
        let size = CGSize(width: Cell.Length, height: Cell.Length)
        view.frame = CGRect(origin: origin, size: size)
        view.backgroundColor = self.state.color
        return view
    }
}
