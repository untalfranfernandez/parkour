import Foundation

@main
struct MyApp {
    static func main() async {
        // The environment variable can be defined within the Xcode scheme.
        guard let candidateID = ProcessInfo.processInfo.environment["CANDIDATE_ID"] else {
            fatalError("Missing CANDIDATE_ID. Please set the environment variable")
        }
        
        let megaverseApi = MegaverseApi(candidateID: candidateID)
        
        // Uncomment the following line to run phase one.
        // await phaseOne(megaverseApi)
        
        // Uncomment the following line to run phase two.
        // await phaseTwo(megaverseApi)
    }
    
    fileprivate static func phaseOne(_ megaverseApi: MegaverseApi) async {
        await createPolyanet(megaverseApi, polyanet: generatePolyanet())
    }
    
    fileprivate static func phaseTwo(_ megaverseApi: MegaverseApi) async {
        do {
            let nonSpaceEntities = try await megaverseApi.getMegaverse().filter {
                $0.entity != .space
            }
            for try await entity in nonSpaceEntities {
                switch entity.entity {
                case .blueSoloon, .purpleSoloon, .redSoloon, .whiteSoloon:
                    guard let soloon = Soloon(x: entity.x, y: entity.y, entity: entity.entity) else { continue }
                    await invokeApiWithBackoff(megaverseApi, data: [soloon], block: { soloon in
                        try await megaverseApi.post(soloon)
                    })
                    
                case .upCometh, .downCometh, .leftCometh, .rightCometh:
                    await invokeApiWithBackoff(megaverseApi, data: [entity], block: { entity in
                        guard let cometh = Cometh(x: entity.x, y: entity.y, entity: entity.entity) else { return }
                        try await megaverseApi.post(cometh)
                    })
                
                case .polyanet:
                    await invokeApiWithBackoff(megaverseApi, data: [Polyanet(x: entity.x, y: entity.y)], block: { polyanet in
                        try await megaverseApi.post(polyanet)
                    })
                
                case .space:
                    // These were already filtered out.
                    break
                }
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    private static func invokeApiWithBackoff<T>(
        _ megaverseApi: MegaverseApi,
        data: [T],
        block: @escaping (T) async throws -> Void,
        backoffInSeconds: Int = 5,
        backoffFactor: Double = 1.5,
        maxBackoffInSeconds: Int = 60
    ) async {
        await withTaskGroup(of: T?.self) { group in
            for entry in data {
                group.addTask {
                    do {
                        try await block(entry)
                        return nil
                    } catch {
                        print("Failed to create: \(entry) error \(error)")
                        return entry
                    }
                }
            }
            
            var failed: [T] = []
            for await result in group.compactMap({ $0 }) {
                failed.append(result)
            }
            
            if !failed.isEmpty {
                let newBackoffInSeconds = Int(Double(backoffInSeconds) * backoffFactor)
                guard newBackoffInSeconds <= maxBackoffInSeconds else {
                    // If this happens is because the API is not responding, probably because
                    // we are hitting it to hard. This should be reconsidered in a real world scenario.
                    return
                }
                try? await Task.sleep(for: .seconds(newBackoffInSeconds))
                await invokeApiWithBackoff(megaverseApi, data: failed, block: block)
            }
        }
    }
    
    private static func createPolyanet(
        _ megaverseApi: MegaverseApi,
        polyanet: [Polyanet],
        backoffInSeconds: Int = 5,
        backoffFactor: Double = 1.5,
        maxBackoffInSeconds: Int = 60
    ) async {
        await invokeApiWithBackoff(megaverseApi, data: polyanet, block: { polyanet in
            try await megaverseApi.post(polyanet)
        })
    }
    
    // Once the Phase two was shown I realized that this first phase could have been solve
    // following the same approach as the second phase. I'm leaving this function here as an
    // example of how to create a list of polyanets and post them to the API.
    
    private static func generatePolyanet() -> [Polyanet] {
        let centeredPolyanet = Polyanet(x: 5, y: 5)
        return (1..<4).reduce(into: [centeredPolyanet]) { result, offset in
            result.append(contentsOf: [
                centeredPolyanet.insetBy(x: -offset, y: -offset),
                centeredPolyanet.insetBy(x: offset, y: -offset),
                centeredPolyanet.insetBy(x: -offset, y: offset),
                centeredPolyanet.insetBy(x: offset, y: offset)
            ])
        }
    }
}
