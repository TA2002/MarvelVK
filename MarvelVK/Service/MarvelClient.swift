//
//  MarvelClient.swift
//  MarvelVK
//
//  Created by Tarlan Askaruly on 31.03.2022.
//

import Foundation
import CryptoKit

class MarvelClient {
    
    // MARK: -Internal variables
    private let baseUrl = "https://gateway.marvel.com/v1/public/characters"
    private let publicKey = "da75811e92744a16aa07da5ba49bc399"
    private let privateKey = "d2cf591c8df1b428436b08208dbe63eab5d13e48"
    private var hash = ""
    private var timestamp = ""
    // MARK: -External variables
    public var isActive = false
    public var task: URLSessionDataTask?
    
    init() {
        
    }
    
    func sendRequest(offset: Int?, startsWith: String?, completion: @escaping (MarvelResponse?, Error?) -> Void) {
        isActive = true
        var components = URLComponents(string: baseUrl)!
        timestamp = String(Date().timeIntervalSince1970)
        hash = hashMD5(data: "\(timestamp)\(privateKey)\(publicKey)")
        components.queryItems = [
            URLQueryItem(name: "ts", value: timestamp),
            URLQueryItem(name: "hash", value: hash),
            URLQueryItem(name: "apikey", value: publicKey)
        ]
        if offset != nil && offset! > 0 {
            components.queryItems?.append(URLQueryItem(name: "offset", value: String(offset!)))
        }
        if let startsWith = startsWith, startsWith != "" {
            components.queryItems?.append(URLQueryItem(name: "nameStartsWith", value: startsWith))
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        
        print(components.url)
        
        task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                200 ..< 300 ~= response.statusCode,
                error == nil
            else {
                print("error: \(error)")
                self?.isActive = false
                completion(nil, error)
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(MarvelResponse.self, from: data)
                self?.isActive = false
                completion(apiResponse, nil)
            } catch {
                self?.isActive = false
                completion(nil, error)
            }
            
        }
        
        task?.resume()
    }
    
    func sendComicRequest(url: String, completion: @escaping (MarvelComicResponse?, Error?) -> Void) {
        var components = URLComponents(string: url)!
        timestamp = String(Date().timeIntervalSince1970)
        hash = hashMD5(data: "\(timestamp)\(privateKey)\(publicKey)")
        components.queryItems = [
            URLQueryItem(name: "ts", value: timestamp),
            URLQueryItem(name: "hash", value: hash),
            URLQueryItem(name: "apikey", value: publicKey)
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                200 ..< 300 ~= response.statusCode,
                error == nil
            else {
                print("error: \(error)")
                self?.isActive = false
                completion(nil, error)
                return
            }
            do {
                let apiResponse = try JSONDecoder().decode(MarvelComicResponse.self, from: data)
                completion(apiResponse, nil)
            } catch {
                completion(nil, error)
            }
            
        }
        
        task?.resume()
    }
    
}

extension MarvelClient {
    func hashMD5(data: String) -> String {
        let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        return hash.map {String(format: "%02hhx", $0)}.joined()
    }
}
