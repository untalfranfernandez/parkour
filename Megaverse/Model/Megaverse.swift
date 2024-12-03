import Foundation

struct Megaverse: Codable, AsyncSequence {
    struct SequenceElement {
        let entity: MegaverseEntity
        let x: Int
        let y: Int
    }
    
    typealias Element = SequenceElement
    
    let entities: [[MegaverseEntity]]
    
    private enum CodingKeys : String, CodingKey {
        case entities = "goal"
    }
    
    func makeAsyncIterator() -> MegaverseIterator {
        MegaverseIterator(entities: entities)
    }
    
    struct MegaverseIterator: AsyncIteratorProtocol {
        private let entities: [[MegaverseEntity]]
        private var currentRowIndex = 0
        private var currentColumnIndex = 0
        
        init(entities: [[MegaverseEntity]]) {
            self.entities = entities
        }
        
        mutating func next() async throws -> Element? {
            currentRowIndex += 1
            if currentRowIndex >= entities.count {
                currentRowIndex = 0
                currentColumnIndex += 1
            }
            
            if currentColumnIndex >= entities[currentRowIndex].count {
                return nil
            }
             
            return Element(
                entity: entities[currentRowIndex][currentColumnIndex],
                x: currentRowIndex,
                y: currentColumnIndex
            )
        }
    }
        
}

enum MegaverseEntity: String, Codable {
    case blueSoloon = "BLUE_SOLOON"
    case downCometh = "DOWN_COMETH"
    case leftCometh = "LEFT_COMETH"
    case polyanet = "POLYANET"
    case purpleSoloon = "PURPLE_SOLOON"
    case redSoloon = "RED_SOLOON"
    case rightCometh = "RIGHT_COMETH"
    case space = "SPACE"
    case upCometh = "UP_COMETH"
    case whiteSoloon = "WHITE_SOLOON"
}
