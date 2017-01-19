import UIKit

protocol Renderable {
    func makeView() -> UIView
}

struct World {
    
    static let Dimension = 10
    
    var cells: [Cell: UIView] = [:]
    
    init() {
        for x in 0..<World.Dimension {
            for y in 0..<World.Dimension {
                let cell = Cell(x: x, y: y)
                let view = cell.makeView()
                cells[cell] = view
            }
        }
    }
}

extension World: Renderable {
    func makeView() -> UIView {
        let view = UIView()
        let length = UIScreen.main.bounds.width
        let buffer = UIScreen.main.bounds.height - (Cell.Length * CGFloat(World.Dimension))
        view.frame = CGRect(origin: CGPoint(x: 0, y: buffer),
                            size: CGSize(width: length, height: length))
        for subView in self.cells.values {
            view.addSubview(subView)
        }
        return view
    }
}


extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}
