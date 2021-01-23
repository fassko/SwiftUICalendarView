//
//  DatePickerView.swift
//  CalendarTest
//
//  Created by Kristaps Grinbergs on 23/01/2021.
//

import SwiftUI

struct DatePickerView: View {
  @State private var beginingDate = Date()
  @State private var endDate = Calendar.current.date(byAdding: .day, value: 30, to: Date())!
  
  @State var calendarSelecton: CalendarSelection?
  
  var body: some View {
    VStack {
      HStack {
        Text(beginingDate, style: .date)
        Image("arrpwshape.zigzag.right.fill")
        Text(endDate, style: .date)
      }
      HorrizonView(calendarSelection: $calendarSelecton)
      
      Button("Save", action: {
        print("Saving dates")
        print($beginingDate)
      })
    }
  }
}

struct DatePickerView_Previews: PreviewProvider {
  static var previews: some View {
    DatePickerView()
  }
}
