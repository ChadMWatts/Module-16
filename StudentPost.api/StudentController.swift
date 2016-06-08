//
//  StudentController.swift
//  StudentPost.api
//
//  Created by Chad Watts on 6/7/16.
//  Copyright © 2016 Chad Watts. All rights reserved.
//

import Foundation

class StudentController {
    
    static let baseURL = NSURL(string: "https://mykestudentapi.firebaseio.com/students")
    static let getterEndpoint = baseURL?.URLByAppendingPathExtension("json")
    
    static func getStudents(completion: (students: [Student]) -> Void) {
        
        guard let url = getterEndpoint else {
            return
        }
        NetworkController.performRequestForURL(url, httpMethod: .Get ) { (data, error) -> Void in
            guard let data = data,
                jsonDictionary = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String:AnyObject],
                mykeStudents = jsonDictionary["group_myke"] as? [String] else {
                    completion(students: [])
                    return
            }
            // TODO: - () students
            dispatch_group_async(dispatch_get_main_queue(), { () -> void in
                
                let bestStudents = mykeStudents.flatMap({ Student(name: $0) })
                completion(students: bestStudents)
            })
            
        }
        
    }
    
    static func uploadStudent(name: String) {
        let student = Student(name: name)
        guard let requestURl = student.endpoint else {
            return
        }
        NetworkController.performRequestForURL(requestURl, httpMethod: .Put, body: student.jsonData) { (data, error) in
            if error != nil {
                print("there was an error: \(error?.localizedDescription)")
            } else {
                print("successfully loaded student")
            }
        }
    }
}


