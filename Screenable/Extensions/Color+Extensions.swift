//
//  Color+Extensions.swift
//  Screenable
//
//  Created by Zaid Neurothrone on 2022-12-11.
//

import SwiftUI

extension Color: Codable {
  enum CodingKeys: CodingKey {
    case red, green, blue, alpha
  }
  
  //MARK: - Loading Color using Codable
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let r = try container.decode(Double.self, forKey: .red)
    let g = try container.decode(Double.self, forKey: .green)
    let b = try container.decode(Double.self, forKey: .blue)
    let a = try container.decode(Double.self, forKey: .alpha)
    self.init(red: r, green: g, blue: b, opacity: a)
  }
  
  //MARK: - Saving Color using Codable
  public func encode(to encoder: Encoder) throws {
    let components = getComponents()
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(components.red, forKey: .red)
    try container.encode(components.green, forKey: .green)
    try container.encode(components.blue, forKey: .blue)
    try container.encode(components.alpha, forKey: .alpha)
  }
  
  func getComponents() -> (red: Double, green: Double, blue: Double, alpha: Double) {
    var r: CGFloat = .zero
    var g: CGFloat = .zero
    var b: CGFloat = .zero
    var a: CGFloat = .zero
    let color = NSColor(self)
    color.getRed(&r, green: &g, blue: &b, alpha: &a)
    return (r, g, b, a)
  }
}
