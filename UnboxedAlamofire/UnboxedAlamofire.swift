//
//  UnboxedAlamofire.swift
//  UnboxedAlamofire
//
//  Created by Serhii Butenko on 26/7/16.
//  Copyright © 2016 Serhii Butenko. All rights reserved.
//

import Foundation
import Alamofire
import Unbox

// MARK: - Requests

extension DataRequest {
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter queue: The queue on which the completion handler is dispatched.
     - parameter keyPath: The key path where object mapping should be performed.
     - parameter options: The JSON serialization reading options. `.allowFragments` by default.
     - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped by Unbox.
     
     - returns: The request.
     */
    @discardableResult
    public func responseObject<T: Unboxable>(queue: DispatchQueue? = nil, keyPath: String? = nil, options: JSONSerialization.ReadingOptions = .allowFragments, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.unboxObjectResponseSerializer(options: options, keyPath: keyPath), completionHandler: completionHandler)
    }
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter queue: The queue on which the completion handler is dispatched.
     - parameter keyPath: The key path where object mapping should be performed.
     - parameter options: The JSON serialization reading options. `.allowFragments` by default.
     - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped by Unbox.
     
     - returns: The request.
     */
    @discardableResult
    public func responseArray<T: Unboxable>(queue: DispatchQueue? = nil, keyPath: String? = nil, options: JSONSerialization.ReadingOptions = .allowFragments, completionHandler: @escaping (DataResponse<[T]>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.unboxArrayResponseSerializer(options: options, keyPath: keyPath), completionHandler: completionHandler)
    }
}

// MARK: - Serializers
extension DataRequest {
    /**
     Creates a response serializer that returns an object parsed using Unbox of the given result type constructed from the response data
     
     - parameter options: The JSON serialization reading options. `.allowFragments` by default.
     - parameter keyPath: The key path where object mapping should be performed.
     
     - returns: An Unbox object response serializer.
     */
    public static func unboxObjectResponseSerializer<T: Unboxable>(options: JSONSerialization.ReadingOptions = .allowFragments, keyPath:String?) -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            return Request.serializeUnboxObjectResponse(options: options, keyPath: keyPath, response: response, data: data, error: error)
        }
    }
    
    /**
     Creates a response serializer that returns an arry of objects parsed using Unbox of the given result type constructed from the response data
     
     - parameter options: The JSON serialization reading options. `.allowFragments` by default.
     - parameter keyPath: The key path where object mapping should be performed.
     
     - returns: An Unbox object response serializer.
     */
    public static func unboxArrayResponseSerializer<T: Unboxable>(options: JSONSerialization.ReadingOptions = .allowFragments, keyPath:String?) -> DataResponseSerializer<[T]> {
        return DataResponseSerializer { _, response, data, error in
            return Request.serializeUnboxArrayResponse(options: options, keyPath: keyPath, response: response, data: data, error: error)
        }
    }
}

extension Request {
    
    /**
     Returns an object parsed using Unbox contained in a result type constructed from the response data
     
     - parameter options: The JSON serialization reading options. `.allowFragments` by default.
     - parameter keyPath: The key path where object mapping should be performed.
     - parameter response: The response from the server.
     - parameter data: The data returned from the server.
     - parameter error: The error already encountered if it exists.
     
     - returns: The result data type.
     */
    public static func serializeUnboxObjectResponse<T: Unboxable>(options: JSONSerialization.ReadingOptions, keyPath:String?, response: HTTPURLResponse?, data: Data?, error: Error?) -> Result<T> {
        if let error = error {
            return .failure(error)
        }
        
        let JSONResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
        let result = JSONResponseSerializer.serializeResponse(nil, response, data, error)
        
        let jsonCandidate: Any?
        if let keyPath = keyPath , !keyPath.isEmpty {
            jsonCandidate = (result.value as AnyObject?)?.value(forKeyPath: keyPath)
        } else {
            jsonCandidate = result.value
        }
        
        guard let json = jsonCandidate as? UnboxableDictionary else {
            return .failure(UnboxedAlamofireError(description: "Invalid data."))
        }
        
        do {
            return .success(try unbox(dictionary: json))
        } catch let unboxError as UnboxError {
            return .failure(UnboxedAlamofireError(description: unboxError.description))
        } catch let error as NSError {
            return .failure(error)
        }
    }
    
    /**
     Returns an arry of objects parsed using Unbox contained in a result type constructed from the response data
     
     - parameter options: The JSON serialization reading options. `.allowFragments` by default.
     - parameter keyPath: The key path where object mapping should be performed.
     - parameter response: The response from the server.
     - parameter data: The data returned from the server.
     - parameter error: The error already encountered if it exists.
     
     - returns: The result data type.
     */
    public static func serializeUnboxArrayResponse<T: Unboxable>(options: JSONSerialization.ReadingOptions, keyPath:String?, response: HTTPURLResponse?, data: Data?, error: Error?) -> Result<[T]> {
        if let error = error {
            return .failure(error)
        }
        
        let JSONResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
        let result = JSONResponseSerializer.serializeResponse(nil, response, data, error)
        
        let jsonCandidate: Any?
        if let keyPath = keyPath , !keyPath.isEmpty {
            jsonCandidate = (result.value as AnyObject?)?.value(forKeyPath: keyPath)
        } else {
            jsonCandidate = result.value
        }
        
        guard let json = jsonCandidate as? [UnboxableDictionary] else {
            return .failure(UnboxedAlamofireError(description: "Invalid data."))
        }
        
        do {
            return .success(try map(json))
        } catch let unboxError as UnboxError {
            return .failure(UnboxedAlamofireError(description: unboxError.description))
        } catch let error as NSError {
            return .failure(error)
        }
    }
}

// MARK: - Helpers

public struct UnboxedAlamofireError: Error, CustomStringConvertible {
    
    public let description: String
}

private func map<T: Unboxable>(_ objects: [UnboxableDictionary]) throws -> [T] {
    
    return try objects.reduce([T]()) { container, rawValue in
        let value = try unbox(dictionary: rawValue) as T
        return container + [value]
    }
}
