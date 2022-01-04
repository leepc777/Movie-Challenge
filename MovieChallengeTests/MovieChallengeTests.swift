//
//  MovieChallengeTests.swift
//  MovieChallengeTests
//
//  Created by peicheng lee on 1/4/22.
//

import XCTest
@testable import MovieChallenge
class MovieChallengeTests: XCTestCase {
    
    //test fetching all movies
    func testApolloFetch() {
        let query = SearchMoviesQuery(genre: "", limit: 0)
        let fetchAnswerExpectation = expectation(description: "WaitForResponse")
        var movies = [SearchMoviesQuery.Data.Movie]()
        
        Network.shared.apollo.fetch(query: query) { result in
            
            DispatchQueue.main.async {
                print(" ==> result :\(result)")
                switch result {
                case .success(let graphQLResult):
                    
                    if var receivedMovies = graphQLResult.data?.movies?.compactMap({ $0 }) {
                        movies = receivedMovies
                        
                        let movieCount = graphQLResult.data?.movies?.count
                        print("-->  Found \(graphQLResult.data?.movies?.count ?? 0) movies")
                        XCTAssertNotEqual(0, movieCount)
                    }
                case .failure(let error):
                    print("Error getting movies: \(error.localizedDescription)")
                    XCTAssertEqual(0, error.localizedDescription.count)
                }
            
                fetchAnswerExpectation.fulfill()
                
            }
        }
        
        waitForExpectations(timeout: 10, handler:nil)
        
        
    }
}
