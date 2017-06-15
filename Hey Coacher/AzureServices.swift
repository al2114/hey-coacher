//
//  Services.swift
//  Hey Coacher
//
//  Created by Andrew Li on 11/06/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import Foundation


func queryDatabase(_ params: [String]) -> String {
  let baseURL = "http://databasequerypage.azurewebsites.net/query.aspx?"

  
  var url: String = baseURL
  if params.count > 1 {
    for idx in 0...(params.count-2) {
      url += params[idx] + "&"
    }
  }
  url += params[params.count-1]
  
  return url
}


func serviceBeginSession(_ exercise: String){
  
  let request = queryDatabase(["request=startsession",
                              "id=\(userID)",
                              "class=\(exercise)"])
  if let url = URL(string: request)
  {
    do {
      var contents = try String(contentsOf: url, encoding: .utf8)
      let summarydata = contents.format()
      let summarydataArr = summarydata.components(separatedBy: " ")
      
      sessionID = Int(summarydataArr[0])!
    }
    catch {
      print("Contents could not be loaded")
    }
  }
  else {
    print("The URL was bad")
  }
}

func serviceEndSession() {

  let request = queryDatabase(["request=endsession",
                               "sid=\(sessionID)"])
  if let url = URL(string: request) {
    do {
      var contents = try String(contentsOf: url, encoding: .utf8)
      let summarydata = contents.format()
      let summarydataArr = summarydata.components(separatedBy: " ")
      if(summarydataArr[0] == "Session" && summarydataArr[1] == "Ended"){
        print ("Session Ended")
      }
    }
    catch {
      print("Contents could not be loaded")
    }
  }
  else {
    print("The URL was bad")
  }
}

func serviceAnlyzeCurrentSession() -> String {
//  let request = queryDatabase(["request=progress",
//                               "pid=\(userID))",
//                               "sid=\(sessionID)"])
  
//  if let url = URL(string: request) {
  var sid = sessionID
  
  if userID == 34 {
    sid = 38
  }
  
  let request = queryDatabase(["request=progress",
                               "pid=\(userID)",
                                "sid=\(sid)"])
  
  if let url = URL(string: request){
    do {
      var contents = try String(contentsOf: url, encoding: .utf8)
      let json = contents.format()
      return json
    }
    catch {
      print("Contents could not be loaded")
      return ""
    }
  }
  else {
    print("The URL was bad")
  }
  
  return ""
}

func serviceGetSessions() -> String {
  
  let request = queryDatabase(["request=sessions",
                               "pid=\(userID)"])
  
  if let url = URL(string: request){
    do {
      var contents = try String(contentsOf: url, encoding: .utf8)
      let json = contents.format()
      return json
    }
    catch {
      print("Contents could not be loaded")
      return ""
    }
  }
  else {
    print("The URL was bad")
  }
  
  return ""
}

func serviceAnalyzeSession(_ sid: Int) -> String {
  let request = queryDatabase(["request=previous",
                               "pid=\(userID)",
                               "sid=\(sid)"])
  
  if let url = URL(string: request){
    do {
      var contents = try String(contentsOf: url, encoding: .utf8)
      let json = contents.format()
      return json
    }
    catch {
      print("Contents could not be loaded")
      return ""
    }
  }
  else {
    print("The URL was bad")
  }
  
  return ""
}
