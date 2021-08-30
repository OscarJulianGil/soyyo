//
//  NetworkManager.swift
//  SoyYo
//
//  Created by Oscar Julian on 27/08/21.
//  Copyright © 2021 Oscar Julian Gil Bernal. All rights reserved.
//

import Foundation


class NetworkManager{
    
    var delegate : IServerResponse?    
    
    func getServerData(endpoint : String,parameters : [String:String] ){
        var url_string : String = Constantes.API + endpoint + "?"
        
        //Arma la url de la petición
        for item in parameters {
            url_string = url_string + item.key + "=" + item.value + "&"
        }
        print(url_string)
        let url = URL(string: url_string)
        let session = URLSession(configuration: .default)
        if let urlinfo = url{
            let task = session.dataTask(with: urlinfo, completionHandler: WaitServerResponse(data:response:error:))
            task.resume();
        }
    }
    
    
    func WaitServerResponse(data : Data?, response : URLResponse?, error: Error?){
        let objectResponse = ServerResponse(data: data, response: response, error: error)
        delegate?.Response(response: objectResponse)
    }
    
}
