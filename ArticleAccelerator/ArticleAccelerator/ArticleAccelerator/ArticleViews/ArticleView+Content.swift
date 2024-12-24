// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import SwiftUI

extension ArticleView {
    var initialContent: AttributedString {
        var content = AttributedString()
        guard let article else { return content }
        
        let heroAttributes = (
            design.heroHeaderAttributes(at: heroHeaderFontSize),
            design.heroContentAttributes
        )
        let hero = article.hero.attributedString(with: heroAttributes)
        content.addLine(hero)
        
        for section in article.body {
            let sectionAttributes = (
                design.sectionHeaderAttributes(at: sectionHeaderFontSize),
                design.sectionContentAttributes
            )
            let text = section.attributedString(with: sectionAttributes)
            content.addLine(text)
        }
        content += "\n"
        return content
    }
}

extension ContentBlock {
    func attributedString(with attributes: (header: AttributeContainer, content: AttributeContainer)) -> AttributedString {
        let header = header.attributedString(with: attributes.header)
        let content = content.attributedString(with: attributes.content)
        return header + content
    }
}

fileprivate extension StringProtocol {
    private var isHTML: Bool {
        let htmlSentinel = "</"
        if contains(htmlSentinel) {
            return true
        }
        return false
    }
    
    private var spans: [String] {
        split(separator: "\n").map { String($0) }
    }
    
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func attributedString(with attributes: AttributeContainer) -> AttributedString {
        var result = AttributedString()
        for span in spans {
            let defaultString = AttributedString(self)
            
            guard let data = span.data(using: .utf8) else {
                result.addLine(defaultString)
                continue
            }
            
            let paragraphStyle = design.paragraphStyle(containingHTML: span.isHTML)
            var legacyDictionary = attributes.legacyDictionary
            legacyDictionary.updateValue(paragraphStyle, forKey: .paragraphStyle)
            let fullAttributes = AttributeContainer(legacyDictionary)
            
            if span.isHTML {
                guard let string = NSAttributedString(html: data, documentAttributes: nil) else {
                    result.addLine(defaultString)
                    continue
                }
                result.addLine()
                result += AttributedString(string).mergingAttributes(fullAttributes)
                
            } else {
                guard let string = try? AttributedString(markdown: data) else {
                    result.addLine(defaultString)
                    continue
                }
                result.addLine(string.mergingAttributes(fullAttributes))
            }
        }
        return result
    }
}

fileprivate extension AttributeContainer {
    var legacyDictionary: [NSAttributedString.Key : Any] {
        let sample = AttributedString(" ").mergingAttributes(self)
        return NSAttributedString(sample).attributes(at: 0, effectiveRange: nil)
    }
}

fileprivate extension AttributedString {
    static func +(lhs: AttributedString, rhs: String) -> AttributedString {
        let suffix = AttributedString(rhs)
        var result = lhs
        result.append(suffix)
        return result
    }
    
    static func +(lhs: String, rhs: AttributedString) -> AttributedString {
        var result = AttributedString(lhs)
        result.append(rhs)
        return result
    }
    
    mutating func addLine(_ text: AttributedString = "") {
        self += text + "\n"
    }
}

fileprivate typealias design = Design.Article
