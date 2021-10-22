//
//  ContentModel.swift
//  LearnSwiftApp
//
//  Created by iMac on 20.10.21..
//

import Foundation

class ContentModel: ObservableObject {

    @Published var modules = [Module]()
    
    var styleData: Data?
    
    init() {
        getLocalData()
        }
        
        func getLocalData() {
            // get a url to the json file
            let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
            
            do {
                // read the file into a Data object
                let jsonData = try Data(contentsOf: jsonUrl!)
                // try to decode the json into an array of moduls                let jsonDecoder = JSONDecoder()
                let jsonDecoder = JSONDecoder()
                let modules = try jsonDecoder.decode([Module].self, from: jsonData)
                
                // assign parsed modules to modules property
                self.modules = modules
            }
            catch {
                // todo log error
                print("Couldn't parse local data")
            }
            // parse the Style Data
            let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")//
            
            do{
                // read the file into a data object
                let styleData = try Data(contentsOf: styleUrl!)
                
                self.styleData = styleData
            }
            catch {
                // log error
                print("Couldn't parse style data")
            }
            
        }
}

