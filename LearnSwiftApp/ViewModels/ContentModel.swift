//
//  ContentModel.swift
//  LearnSwiftApp
//
//  Created by iMac on 20.10.21..
//

import Foundation
import Firebase

class ContentModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    // List of modules
    @Published var modules = [Module]()
    
    // Current module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // Current lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    // Current question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    // Current lesson explanation
    @Published var codeText = NSAttributedString()
    var styleData: Data?
    
    // Current selected content amd test
    @Published var currentContentSelected:Int?
    @Published var currentTestSelected:Int?
    
    
    init() {
        
        // Parse local included json data
//        getLocalData()
        
        // Parse local style.html
        getLocalStyles()
        
        // Get database modules
        getModules()
        
        // Download remote json file and parse data
//        getRemoteData()
        
    }
    
    // MARK: - Data methods
    
    func getLessons(module: Module, completion: @escaping () -> Void) {
        
        // Specify path
        let collection = db.collection("modules").document(module.id).collection("lessons")
        
        // Get documents
        collection.getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil {
                
                // Array to track lessons
                var lessons = [Lesson]()
                
                // Loops through the documents and build array of lessons
                for doc in snapshot!.documents {
                    
                    // New lessons
                    var l = Lesson()
                    
                    l.id = doc["id"] as? String ?? UUID().uuidString
                    l.title = doc["title"] as? String ?? ""
                    l.video = doc["video"] as? String ?? ""
                    l.duration = doc["duration"] as? String ?? ""
                    l.explanation = doc ["explanation"] as? String ?? ""
                    
                    // Adds the lesson to the arrray
                    lessons.append(l)
                }
                
                // Settings the lessons to the module
                // Loops through published modules array and finds the one that matches the id of the copy that got passed in
                
                for (index, m) in self.modules.enumerated() {
                    
                    // Finds the module that we want
                    if module.id == module.id {
                      
                        // Sets the lessons
                        self.modules[index].content.lessons = lessons
                        
                        // Calls the completion closure
                        completion()
                    }
                }
            }
        }
        
    }
    
    func getQuestions(module: Module, completion: @escaping() -> Void) {
        
        
        
    }
    
    func getModules() {
        
        let collection = db.collection("modules")
        
        // Get documents
        collection.getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil {
                
                // Creates an array for the modules
                var modules = [Module]()
                
                // Loop through the documents returned
                for doc in snapshot!.documents {
                    
                    
                    // Creates a new module instance
                    var m = Module()
                    
                    // Parses out the values from the document into the module instance
                    m.id = doc["id"] as? String ?? UUID().uuidString // cast
                    m.category = doc["category"] as? String ?? ""
                    
                    // Parses the lesson content
                    let contentMap = doc["content"] as! [String:Any]
                    
                    m.content.id = contentMap["id"] as? String ?? ""
                    m.content.description = contentMap["description"] as? String ?? ""
                    m.content.image = contentMap["image"] as? String ?? ""
                    m.content.time = contentMap["time"] as? String ?? ""
                    
                    // Parses the test content
                    let testMap = doc["test"] as! [String:Any]
                    
                    m.test.id = testMap["id"] as? String ?? ""
                    m.test.description = testMap["description"] as? String ?? ""
                    m.test.image = testMap["image"] as? String ?? ""
                    m.test.time = testMap["time"] as? String ?? ""
                    
                    // Adds it to ours array
                    modules.append(m)
                }
            }
        }
        
    }
    
//    func getLocalData() {
    func getLocalStyles() {
    /*
        // Get a url to the json file
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        do {
            // Read the file into a data object
            let jsonData = try Data(contentsOf: jsonUrl!)
            
            // Try to decode the json into an array of modules
            let jsonDecoder = JSONDecoder()
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            
            // Assign parsed modules to modules property
            self.modules = modules
        }
        catch {
            // TODO log error
            print("Couldn't parse local data")
        }
        */
        
        // Parse the style data
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do {
            
            // Read the file into a data object
            let styleData = try Data(contentsOf: styleUrl!)
            
            self.styleData = styleData
        }
        catch {
            // Log error
            print("Couldn't parse style data")
        }
        
    }
    
    func getRemoteData() {
        
        // String path
        let urlString = "https://mrnele.github.io/swift-data2/data2.json"
        
        // Creates a url object
        let url = URL(string: urlString)
        
        guard url != nil else {
            // Couldn't create url
            return
        }
        
        // Create a URLRequest object
        let request = URLRequest(url: url!)
        
        // Get the session and kick off the task
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            // Check if there's an error
            guard error == nil else {
                // There was an error 
                return
            }
            
            do {
                // Create json decoder
                let decoder = JSONDecoder()
            
                // Decode
                let modules = try decoder.decode([Module].self, from: data!)
                
                DispatchQueue.main.async {
                    
                // Append parsed modules into modules property
                self.modules += modules
            }
            }
            catch {
               print("Couldn't parse json")
            }
        }
        
        // Kick off data task
        dataTask.resume()
        
    }
    
    // MARK: - Module navigation methods
    
//    func beginModule(_ moduleId: Int) {
    func beginModule(_ moduleId: String) {
        
        // Find the index for this module id
        for index in 0..<modules.count {
            
            if modules[index].id == moduleId {
                
                 // Found the matching module
                currentModuleIndex = index
                break
            }
        }
        
        // Set the current module
        currentModule = modules[currentModuleIndex]
    }
    
    func beginLesson(_ lessonIndex:Int) {
        
        // Check that the lesson index is within range of module lessons
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        }
        else {
            currentModuleIndex = 0
        }
        
        // Set the current lesson
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        codeText = addStyling(currentLesson!.explanation)
    }
    
    func nextLesson(){
        
         // Advance the lesson index ("unapred")
            currentLessonIndex += 1
        
        // Check that it is within range
        if currentLessonIndex < currentModule!.content.lessons.count {
            
            // set the current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)
        }
        else {
            // reset the lessons state
            currentLessonIndex = 0
            currentLesson = nil            
        }
    }
    
    func hasNextLesson() -> Bool {
  
        guard currentModule != nil else {
            return false
        }
        
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
    }
  
    
    func beginTest(_ moduleId:String) {
        
        //Set the current module
        beginModule(moduleId)
        
        // Set the current question
        currentQuestionIndex = 0
        
            // If there are questions, set the current question to the first one
        if currentModule?.test.questions.count ?? 0 > 0 {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            
            // Set the question context
            codeText = addStyling(currentQuestion!.content)
        }
    }
    
    func nextQuestion() {
        
        // Advance qustion index
        currentQuestionIndex += 1
        
        // Check that it's within range of questions
        if currentQuestionIndex < currentModule!.test.questions.count {
            
            // Set the current question
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        }
        else {
        
        // If not, then reset the properties
            currentQuestionIndex = 0
            currentQuestion = nil
    }
}
    
    // MARK: - Code Styling
    
    private func addStyling(_ htmlString: String) -> NSAttributedString {
        
        var resultString = NSAttributedString()
        var data = Data()
        
        // Add the styling data
        if styleData != nil {
//            data.append(self.styleData!)
            data.append(styleData!)
        }
        
        // Add the html data
        data.append(Data(htmlString.utf8))
        
        // Technique 1
        // Convert to attributed string
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            
            resultString = attributedString
    }
        // Technique 2
        // Convert to attributed string
        
//        do {
//            let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
//
//                resultString = attributedString
//        }
//    catch {
//    print("Couldn't turn html into attributed string")
//    }
        return resultString
    }
}
