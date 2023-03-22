//
//  Extensions.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/19/22.
//


import SwiftUI
import UIKit

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        color: Color = AppColor.lovolDarkPurple,
        @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().foregroundColor(color).opacity(shouldShow ? 1 : 0)

            self
        }
            
    }
}
import SwiftUI

extension View {
    /// Sets the text color for a navigation bar title.
    /// - Parameter color: Color the title should be
    ///
    /// Supports both regular and large titles.
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
    
        // Set appearance for both normal and large sizes.
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
    
        return self
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
extension View {
    public func foregroundGradient(colors: [Color]) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing))
            .mask(self)
    }
    
    @ViewBuilder
    public func showLoading(_ showLoading: Bool) -> some View{
        self.allowsHitTesting(!showLoading)
        .overlay(ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity).background(Color(UIColor.systemGray5)).opacity( showLoading ? 0.75 : 0.0))
    }
}

extension Image {
    func centerCropped() -> some View {
        GeometryReader { geo in
            self
            .resizable()
            .scaledToFill()
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
        }
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    
    func getFormattedDate(format: String) -> String {
         let dateformat = DateFormatter()
         dateformat.dateFormat = format
         return dateformat.string(from: self)
     }
}
extension Formatter {
    static let date = DateFormatter()
}
extension Locale {
    static let ptBR = Locale(identifier: "pt_BR")
}
extension TimeZone {
    static let gmt = TimeZone(secondsFromGMT: 0)!
}
extension Date {
    func localizedDescription(date dateStyle: DateFormatter.Style = .medium,
                              time timeStyle: DateFormatter.Style = .medium,
                              in timeZone: TimeZone = .current,
                              locale: Locale = .current,
                              using calendar: Calendar = .current) -> String {
        Formatter.date.calendar = calendar
        Formatter.date.locale = locale
        Formatter.date.timeZone = timeZone
        Formatter.date.dateStyle = dateStyle
        Formatter.date.timeStyle = timeStyle
        return Formatter.date.string(from: self)
    }
    var localizedDescription: String { localizedDescription() }
}
extension URL {
    var isVideoURL: Bool {
        let videoTypes = ["mp4", "mov", "m4v"]
        return videoTypes.contains(self.pathExtension.lowercased())
    }
}
extension View {
    func showLoading(_ isLoading: Bool, progress: Binding<Float>) -> some View {
        if isLoading {
            return self.overlay(
                ZStack {
                    Color(.systemBackground).opacity(0.3)
                    
                    ProgressView(value: progress.wrappedValue)
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(.white)))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
            .eraseToAnyView()
        } else {
            return self.eraseToAnyView()
        }
    }
    
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}





extension Date {

    var fullDate: String { localizedDescription(date: .full, time: .none) }
    var longDate: String { localizedDescription(date: .long, time: .none) }
    var mediumDate: String { localizedDescription(date: .medium, time: .none) }
    var shortDate: String { localizedDescription(date: .short, time: .none) }

    var fullTime: String { localizedDescription(date: .none, time: .full) }
    var longTime: String { localizedDescription(date: .none, time: .long) }
    var mediumTime: String { localizedDescription(date: .none, time: .medium) }
    var shortTime: String { localizedDescription(date: .none, time: .short) }

    var fullDateTime: String { localizedDescription(date: .full, time: .full) }
    var longDateTime: String { localizedDescription(date: .long, time: .long) }
    var mediumDateTime: String { localizedDescription(date: .medium, time: .medium) }
    var shortDateTime: String { localizedDescription(date: .short, time: .short) }
}

extension String {
    
    var isBlank: Bool {
        get {
            let trimmed = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            return trimmed.isEmpty
        }
    }
    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
}
