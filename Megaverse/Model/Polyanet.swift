struct Polyanet : Codable {
    let x: Int
    let y: Int
    
    func insetBy(x: Int, y: Int) -> Polyanet {
        Polyanet(x: self.x + x, y: self.y + y)
    }
}
