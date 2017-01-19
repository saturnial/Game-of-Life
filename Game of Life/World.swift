import UIKit

protocol Renderable {
    func makeView() -> UIView
}

class World {
    
    static let Dimension = 20
    
    let cells: [Cell]
    
    let cellToViews: [Cell: UIView]
    
    let cellToNeighboringCells: [Cell: [Cell]]
    
    init() {
        var accumulatorOfCells: [Cell] = []
        var accumulatorOfCellsToViews: [Cell: UIView] = [:]
        var accumualtorOfCellsToNeighboringCells: [Cell: [Cell]] = [:]
        
        for x in 0..<World.Dimension {
            for y in 0..<World.Dimension {
                accumulatorOfCells.append(Cell(x: x, y: y))
            }
        }

        for cell in accumulatorOfCells {
            accumulatorOfCellsToViews[cell] = cell.makeView()
            accumualtorOfCellsToNeighboringCells[cell] =
                accumulatorOfCells.filter { cell.isNeighbor(of: $0) }
        }

        self.cells = accumulatorOfCells
        self.cellToViews = accumulatorOfCellsToViews
        self.cellToNeighboringCells = accumualtorOfCellsToNeighboringCells
    }
    
    /**
     Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
     Any live cell with two or three live neighbours lives on to the next generation.
     Any live cell with more than three live neighbours dies, as if by overpopulation.
     Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
     */
    @objc func tick() {
        self.killLivingCells()
        self.birthNewCells()
        
        // Update the UI.
        for (cell, view) in self.cellToViews {
            view.backgroundColor = cell.state.color
        }
    }
    
    /**
     Death: a cell can die by:
     - Overcrowding: if a cell is alive at time t + 1 and 4 or more of
     its neighbors are also alive at time t, the cell will be dead at
     time t + 1.
     - Exposure: If a live cell at time t has only 1 live neighbor or no
     live neighbors, it will be dead at time t + 1.
     */
    private func killLivingCells() {
        let livingCells = self.cells.filter { $0.state == .alive }
        
        for liveCell in livingCells {
            guard let neighbors = self.cellToNeighboringCells[liveCell] else {
                return
            }
            let livingNeighbors = neighbors.filter{ $0.state == .alive }
            if livingNeighbors.count < 2 || livingNeighbors.count > 3 {
                liveCell.state = .dead
            }
        }
    }
    
    /**
     Birth: a cell that is dead at time t will be alive at time t + 1
     if exactly 3 of its eight neighbors were alive at time t.
     */
    private func birthNewCells() {
        let deadCells = self.cells.filter { $0.state == .dead }
        
        for deadCell in deadCells {
            guard let neighbors = self.cellToNeighboringCells[deadCell] else {
                return
            }
            let livingNeighbors = neighbors.filter{ $0.state == .alive }
            if livingNeighbors.count == 3 {
                deadCell.state = .alive
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
        for subView in self.cellToViews.values {
            view.addSubview(subView)
        }
        return view
    }
}
