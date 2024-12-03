import Foundation

struct Soloon: Codable {
    enum Color : String, Codable {
        case blue
        case red
        case purple
        case white
    }
    
    let x: Int
    let y: Int
    let color: Color
    
    init(x: Int, y: Int, color: Color) {
        self.x = x
        self.y = y
        self.color = color
    }
    
    init?(x: Int, y: Int, entity: MegaverseEntity) {
        guard let color = Soloon.getColor(entity) else { return nil }
        self.init(x: x, y: y, color: color)
    }
    
    private static func getColor(_ entity: MegaverseEntity) -> Color? {
        switch entity {
        case .blueSoloon:
            return Color.blue
        case .purpleSoloon:
            return Color.purple
        case .redSoloon:
            return Color.red
        case .whiteSoloon:
            return Color.white
        default:
            return nil
        }
    }
}
