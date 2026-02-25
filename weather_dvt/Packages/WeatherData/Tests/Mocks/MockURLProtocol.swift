//
//  MockURLProtocol.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/20.
//

import Foundation

final class MockURLProtocol: URLProtocol {
    static var mockResponse: (data: Data?, response: HTTPURLResponse?, error: Error?)?

    override static func canInit(with request: URLRequest) -> Bool { true }
    override static func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        if let error = MockURLProtocol.mockResponse?.error {
            client?.urlProtocol(self, didFailWithError: error)
        } else if let response = MockURLProtocol.mockResponse?.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = MockURLProtocol.mockResponse?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } else {
            let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut, userInfo: [NSLocalizedDescriptionKey: "Mock response not configured for URL: \(request.url?.absoluteString ?? "unknown")"])
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
    
    static func clearMock() {
        mockResponse = nil
    }
}
