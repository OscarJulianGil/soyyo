//
//  ServerResponse.swift
//  SoyYo
//
//  Created by Oscar Julian on 28/08/21.
//  Copyright © 2021 Oscar Julian Gil Bernal. All rights reserved.
//

import Foundation


class ServerResponse{
    
    var data : Data?
    var response : URLResponse?
    var error: Error?
    
    init(data : Data?, response : URLResponse?, error: Error?){
        self.data = data
        self.response = response
        self.error = error
    }
}
