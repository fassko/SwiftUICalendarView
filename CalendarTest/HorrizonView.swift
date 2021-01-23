//
//  HorrizonView.swift
//  CalendarTest
//
//  Created by Kristaps Grinbergs on 23/01/2021.
//

import UIKit
import SwiftUI

import HorizonCalendar

enum CalendarSelection {
  case singleDay(Day)
  case dayRange(DayRange)
}


struct HorrizonView: UIViewRepresentable {
  
  @Binding var calendarSelection: CalendarSelection?
  
  lazy var calendar = Calendar.current
  
  lazy var dayDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = calendar
    dateFormatter.locale = calendar.locale
    dateFormatter.dateFormat = DateFormatter.dateFormat(
      fromTemplate: "EEEE, MMM d, yyyy",
      options: 0,
      locale: calendar.locale ?? Locale.current)
    return dateFormatter
  }()
  
  func makeUIView(context: Context) -> CalendarView {
    let calendarView = CalendarView(initialContent: makeContent())
    
    calendarView.daySelectionHandler = { day in
      

      switch self.calendarSelection {
      case .singleDay(let selectedDay):
        if day > selectedDay {
          calendarSelection = .dayRange(selectedDay...day)
        } else {
          calendarSelection = .singleDay(day)
        }
      case .none, .dayRange:
        self.calendarSelection = .singleDay(day)
      }

      calendarView.setContent(self.makeContent())
    }
    return calendarView
  }
  
  func updateUIView(_ uiView: CalendarView, context: UIViewRepresentableContext<HorrizonView>) {}
  
  private func makeContent() -> CalendarViewContent {
    let calendar = Calendar(identifier: .gregorian)
    let startDate = Date() //calendar.date(from: DateComponents(year: 2020, month: 01, day: 01))!
    let endDate = Calendar.current.date(byAdding: .day, value: 30, to: Date())! //calendar.date(from: DateComponents(year: 2021, month: 12, day: 31))!
    
    
    
//    return CalendarViewContent(
//      calendar: calendar,
//      visibleDateRange: startDate...endDate,
//      monthsLayout: .vertical(options: VerticalMonthsLayoutOptions()))

    let calendarSelection = self.calendarSelection
    let dateRanges: Set<ClosedRange<Date>>
    if
      case .dayRange(let dayRange) = calendarSelection,
      let lowerBound = calendar.date(from: dayRange.lowerBound.components),
      let upperBound = calendar.date(from: dayRange.upperBound.components)
    {
      dateRanges = [lowerBound...upperBound]
    } else {
      dateRanges = []
    }
    
    
    return CalendarViewContent(
      calendar: calendar,
      visibleDateRange: startDate...endDate,
      monthsLayout: .vertical(options: VerticalMonthsLayoutOptions()))

      .withInterMonthSpacing(24)
      .withVerticalDayMargin(8)
      .withHorizontalDayMargin(8)

      .withDayItemModelProvider { day in
        let textColor: UIColor
        if #available(iOS 13.0, *) {
          textColor = .label
        } else {
          textColor = .black
        }

        let isSelectedStyle: Bool
        switch calendarSelection {
        case .singleDay(let selectedDay):
          isSelectedStyle = day == selectedDay
        case .dayRange(let selectedDayRange):
          isSelectedStyle = day == selectedDayRange.lowerBound || day == selectedDayRange.upperBound
        case .none:
          isSelectedStyle = false
        }

        let dayAccessibilityText: String = ""
//        if let date = self.calendar.date(from: day.components) {
//          dayAccessibilityText = self?.dayDateFormatter.string(from: date)
//        } else {
//          dayAccessibilityText = nil
//        }

        return CalendarItemModel<DayView>(
          invariantViewProperties: .init(textColor: textColor, isSelectedStyle: isSelectedStyle),
          viewModel: .init(dayText: "\(day.day)", dayAccessibilityText: dayAccessibilityText))
      }
      .withDayRangeItemModelProvider(for: dateRanges) { dayRangeLayoutContext in
        CalendarItemModel<DayRangeIndicatorView>(
          invariantViewProperties: .init(),
          viewModel: .init(
            framesOfDaysToHighlight: dayRangeLayoutContext.daysAndFrames.map { $0.frame }))
      }
  }
}
