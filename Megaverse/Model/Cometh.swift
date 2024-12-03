struct Cometh : Codable {
    enum Direction : String, Codable {
        case up
        case down
        case right
        case left
    }
    
    let x: Int
    let y: Int
    let direction: Direction
    
    init(x: Int, y: Int, direction: Direction) {
        self.x = x
        self.y = y
        self.direction = direction
    }
    
    init?(x: Int, y: Int, entity: MegaverseEntity) {
        guard let direction = Cometh.getDirection(entity) else { return nil }
        self.init(x: x, y: y, direction: direction)
    }
    
    private static func getDirection(_ entity: MegaverseEntity) -> Direction? {
        switch entity {
        case .downCometh:
            return .down
        case .leftCometh:
            return .left
        case .rightCometh:
            return .right
        case .upCometh:
            return .up
        default:
            return nil
        }
    }
}
