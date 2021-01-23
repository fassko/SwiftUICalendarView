//
//  ContentView.swift
//  CalendarTest
//
//  Created by Kristaps Grinbergs on 23/01/2021.
//

import SwiftUI

struct ContentView: View {
  
  @State var showCalendar = false
  
  var body: some View {
    Button("Open Calendar") {
      showCalendar = true
    }
    .sheet(isPresented: $showCalendar) {
      DatePickerView()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
