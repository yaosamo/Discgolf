//
//  colorGenerator.swift
//  Discgolf
//
//  Created by Yaroslav Samoylov on 6/23/23.
//

import Foundation

func generateRandomHex() -> String {
    let hexValues = "0123456789ABCDEF"
    var colorString = "#"
   
    for _ in 0..<6 {
        let randomIndex = Int.random(in: 0..<hexValues.count)
        let randomCharacter = hexValues[hexValues.index(hexValues.startIndex, offsetBy: randomIndex)]
        colorString.append(randomCharacter)
    }
    return colorString
}

 func hexToColor(hex: String) -> (red: Double, green: Double, blue: Double) {
    var cleanedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    if cleanedHex.count == 3 {
        cleanedHex = cleanedHex.map { "\($0)\($0)" }.joined()
    }

    var rgbValue: UInt64 = 0
    Scanner(string: cleanedHex).scanHexInt64(&rgbValue)

    let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
    let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
    let blue = Double(rgbValue & 0x0000FF) / 255.0
  
    return (red, green, blue)
 }

func isColorTooDark(red: Double, green: Double, blue: Double) -> Bool {
    // Calculate relative luminance using WCAG formula
    let relativeLuminance = (0.2126 * red) + (0.7152 * green) + (0.0722 * blue)
    // Compare relative luminance to a threshold value
    let luminanceThreshold: CGFloat = 0.7
    return relativeLuminance <= luminanceThreshold
}
