import UIKit

struct Cell {
    
    static let Length = UIScreen.main.bounds.width /
        CGFloat(World.Dimension)
    
    let id = UUID()
    
    enum State {
        case Alive
        case Dead
    }
    
    let x: Int, y: Int

    var state: State = .Dead
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
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
        view.backgroundColor = UIColor.random
        return view
    }
}
