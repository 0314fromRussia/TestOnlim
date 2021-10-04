//
//  FetchData.swift
//  TestOnlim
//
//  Created by Никита Дмитриев on 04.10.2021.
//

import Foundation

struct GetService {
    
    func getData<Type: Codable>(url: URL, completion: @escaping (Type?, Data?) -> Void) {
        
        //Ответ URLSession, обрабатывается асинхронно, параллельно основному потоку, так что, чтобы вытащить из responseData-замыкания данные, мы будем использовать замыкание.
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error ) in
            
            guard let data = data else { return }
            
            let response = try? JSONDecoder().decode(Type.self, from: data)
            
            completion(response, data)
        }
        dataTask.resume()
    }
}
