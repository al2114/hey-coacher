
import Foundation

class CycleList {
  var idx: Int = 0
  var count: Int = 0
  var item = [String]()
  
  
  init(_ item: [String]){
    self.item = item
    self.count = item.count
  }
  
  
  func iterNext() {
    idx = mod(idx+1,count)
  }
  
  var currentItem: String {
    return item[idx]
  }
  
  
}


class MenuItem{
  var desc: String
  var id: String
  
  init(_ desc: String, _ id: String){
    self.desc = desc
    self.id = id
  }
  
  func modifyDesc(_ newDesc: String){
    self.desc = newDesc
  }
}

class MenuList {
  var idx: Int = 0
  var count: Int = 0
  var items = [MenuItem]()
  
  
  init(_ items: [MenuItem] = [], message: String = "", idx: Int = 0){
    self.items = items
    self.count = items.count
    self.idx = idx

    if items.count != 0 {
      if message != "" {
        speak(message)
        entrySpeech = true
      }
      else {
        speak(currentItem)
      }
    }
  }

  var currentItem: String {
    return items[idx].desc
  }

  var previousItem: String {
    return items[mod(idx-1,count)].desc
  }

  var nextItem: String {
    return items[mod(idx+1,count)].desc
  }

  func iterNext() {
    idx = mod(idx+1,count)
    speak(currentItem)
  }

  func iterPrevious() {
    idx = mod(idx-1,count)
    speak(currentItem)
  }
  
  func currentId() -> String {
    return items[idx].id
  }
  
  func updateItemDesc(itemId: String, newDesc: String){
    for item in items{
      if item.id == itemId {
        item.modifyDesc(newDesc)
      }
    }
  }
}





class SessionItem{
  var desc: String
  var id: Int
  
  init(_ desc: String, _ id: Int){
    self.desc = desc
    self.id = id
  }
  
  func modifyDesc(_ newDesc: String){
    self.desc = newDesc
  }
}

class SessionList {
  var idx: Int = 0
  var count: Int = 0
  var items = [SessionItem]()
  
  
  init(_ items: [SessionItem] = [], message: String = "", idx: Int = 0){
    self.items = items
    self.count = items.count
    self.idx = idx
    
    if items.count != 0 {
      if message != "" {
        speak(message)
        entrySpeech = true
      }
      else {
        speak(currentItem)
      }
    }
  }
  
  var currentItem: String {
    return items[idx].desc
  }
  
  var previousItem: String {
    return items[mod(idx-1,count)].desc
  }
  
  var nextItem: String {
    return items[mod(idx+1,count)].desc
  }
  
  func iterNext() {
    idx = mod(idx+1,count)
    speak(currentItem)
  }
  
  func iterPrevious() {
    idx = mod(idx-1,count)
    speak(currentItem)
  }
  
  func currentId() -> Int {
    return items[idx].id
  }
  
  func updateItemDesc(itemId: Int, newDesc: String){
    for item in items{
      if item.id == itemId {
        item.modifyDesc(newDesc)
      }
    }
  }
  
  
}
