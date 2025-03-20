import XCTest
@testable import BRNetworking

final class BRNetworkingTests: XCTestCase {
    // MARK: Test Types
    private struct Artwork: Decodable {
        let id: Int
        let title: String
    }
    
    private struct ArtworkResponse: Decodable {
        let data: Artwork
    }
    
    private struct SearchResponse: Decodable {
        let data: [Artwork]
    }
    
    private struct ArtworkRequest: Encodable {
        let q: String
    }
    
    // MARK: Test Data
    private let testArtworkId = 129884
    private let testArtworkTitle = "Starry Night and the Astronauts"
    
    // MARK: Tests
    func testPostWithResponseBody() async {
        let request = ArtworkRequest(q: testArtworkTitle)
        let result: Result<SearchResponse, BRNetworking.Problem> = await BRNetworking.call(url: URL(string: "https://api.artic.edu/api/v1/artworks/search")!, method: .post, headers: nil, requestBody: request)
        switch result {
        case .success(let response):
            let target = response.data.first(where: { $0.id == testArtworkId && $0.title == testArtworkTitle })
            XCTAssert(target != nil, "Fetched incorrect data")
        case .failure(let problem): XCTFail("Get artwork failed with problem: \(problem.description)")
        }
    }
    
    func testPostWithoutResponseBody() async {
        let request = ArtworkRequest(q: testArtworkTitle)
        switch await BRNetworking.callWithoutResponse(url: URL(string: "https://api.artic.edu/api/v1/artworks/search")!, method: .post, headers: nil, requestBody: request) {
        case .success(_): break
        case .failure(let problem): XCTFail("Get artwork failed with problem: \(problem.description)")
        }
    }
    
    func testGetWithResponseBody() async {
        let result: Result<ArtworkResponse, BRNetworking.Problem> = await BRNetworking.call(url: URL(string: "https://api.artic.edu/api/v1/artworks/\(testArtworkId)")!, method: .get, headers: nil)
        switch result {
        case .success(let response):
            XCTAssert(response.data.id == testArtworkId && response.data.title == testArtworkTitle, "Fetched incorrect data")
        case .failure(let problem): XCTFail("Get artwork failed with problem: \(problem.description)")
        }
    }
    
    func testGetWithoutResponseBody() async {
        switch await BRNetworking.callWithoutResponse(url: URL(string: "https://api.artic.edu/api/v1/artworks/\(testArtworkId)")!, method: .get, headers: nil) {
        case .success(_): break
        case .failure(let problem): XCTFail("Get artwork failed with problem: \(problem.description)")
        }
    }
}
