
// See LICENSE folder for this sample’s licensing information.

import Foundation
import SwiftUI
import WidgetKit

enum Design {
    enum App {
        static var minWindowWidth: CGFloat { 1300 }
        static var minWindowHeight: CGFloat { 700 }
        enum TrainingPlan {
            static var windowWidth: CGFloat { 638 }
            static var windowMinHeight: CGFloat { 320 }
        }
    }
    enum Article {
        static var contentWidth: CGFloat { 834 }
        static var foregroundColor: NSColor { .labelColor }
        static func paragraphStyle(containingHTML: Bool = false) -> NSParagraphStyle {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1.2
            paragraphStyle.paragraphSpacingBefore = 10
            if containingHTML {
                paragraphStyle.alignment = .left
                paragraphStyle.paragraphSpacing = 10
                paragraphStyle.headIndent = 36
                paragraphStyle.firstLineHeadIndent = 0
                paragraphStyle.maximumLineHeight = 0
                paragraphStyle.minimumLineHeight = 0
                paragraphStyle.lineHeightMultiple = 0
                paragraphStyle.lineBreakMode = .byWordWrapping
                paragraphStyle.tabStops = [
                    NSTextTab(textAlignment: .left, location: 11),
                    NSTextTab(textAlignment: .natural, location: 36)
                ]
            }
            return paragraphStyle
        }
        static var heroHeaderReferenceFont: Font.TextStyle { .title }
        static var heroHeaderReferenceSize: CGFloat { 28 }
        static var heroContentFont: NSFont { .preferredFont(forTextStyle: .title2) }
        static func heroHeaderAttributes(at fontSize: CGFloat) -> AttributeContainer {
            AttributeContainer([
                NSAttributedString.Key.foregroundColor : foregroundColor,
                NSAttributedString.Key.font : NSFont.boldSystemFont(ofSize: fontSize)
            ])
        }
        static var heroContentAttributes: AttributeContainer {
            AttributeContainer([
                NSAttributedString.Key.foregroundColor : foregroundColor,
                NSAttributedString.Key.font : heroContentFont
            ])
        }
        static var mediaBottomSpacing: CGFloat { 50 }
        static var sectionHeaderReferenceFont: Font.TextStyle { .title2 }
        static var sectionHeaderReferenceSize: CGFloat { 22 }
        static var sectionContentFont: NSFont { .systemFont(ofSize: 17) }
        static var verticalSpacing: CGFloat { 10 }
        static func sectionHeaderAttributes(at fontSize: CGFloat) -> AttributeContainer {
            AttributeContainer([
                NSAttributedString.Key.foregroundColor : foregroundColor,
                NSAttributedString.Key.font : NSFont.boldSystemFont(ofSize: fontSize)
            ])
        }
        static var sectionContentAttributes: AttributeContainer {
            AttributeContainer([
                NSAttributedString.Key.foregroundColor : foregroundColor,
                NSAttributedString.Key.font : sectionContentFont
            ])
        }
        enum Media {
            static var imageAspectRatio: CGFloat { 2.5 }
            static var videoAspectRatio: CGFloat { 1.778 }
            static var cornerRadius: CGFloat { 13 }
        }
        enum Question {
            static var choiceFont: Font { .title3 }
            static var justificationFont: Font { .title3 }
            static var promptFont: Font { .title2 }
            static var promptPadding: CGFloat { 6 }
            static var titleFont: Font { .title.weight(.bold) }
            static var verticalSpacing: CGFloat { 5 }
        }
        enum Highlight {
            static var backgroundColor: NSColor { NSColor(cgColor: CGColor(gray: 0.78, alpha: 1.0))! }
            static var backgroundCornerRadius: CGFloat { 5 }
            static var capsuleWidth: CGFloat { 6 }
            static var colorIndicatorDiameter: CGFloat { 20 }
            static var foregroundColor: NSColor  { .black }
            static var insetPadding: CGFloat { 2 }
            static var leadingPadding: CGFloat { 16 }
            static var textLineLimit: Int { 5 }
            static var textInsetPadding: CGFloat { 4 }
            static var textStyle: Color { .primary }
            static var tintAlpha: CGFloat { 0.1 }
            static var titleFont: Font { .title2 }
            static var verticalPadding: CGFloat { 4 }
            enum Note {
                static var editorMinimumHeight: CGFloat { 50 }
                static var topPadding: CGFloat { 2 }
                static var textFont: Font { .body }
            }
        }
    }
    enum CompletionStatus {
        static var blurRadius: CGFloat { 7 }
        static var darkenFactor: CGFloat { 0.5 }
        static var overlayBackgroundColor: Color { .black }
        static var gridSymbolFont: Font { .system(size: 30, weight: .regular) }
        static var listSymbolFont: Font { .system(size: 20, weight: .regular) }
        static var symbolOpacity: CGFloat { 0.8 }
        static var symbolPadding: CGFloat { 10 }
        static var symbolStyle: Color { .white.opacity(Self.symbolOpacity) }
    }
    enum Detail {
        static var bottomSpacing: CGFloat { 10 }
        static var contentUnavailableFont: Font { .body }
        static var contentUnavailableStyle: Color { .secondary }
        static var durationFormatter: DateComponentsFormatter {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute]
            formatter.unitsStyle = .short
            return formatter
        }
        static var headerFont: Font { .title.weight(.bold) }
        static var imageSpacing: CGFloat { 8 }
        static var listSpacing: CGFloat { 20 }
        static var padding: CGFloat { 60 }
        static var sectionHeaderMaterial: Material { .thickMaterial }
        enum Featured {
            static var chevronFont: Font { .system(size: 48, weight: .thin) }
            static var comingSoonFont: Font { .title.weight(.bold) }
            static var comingSoonSpacing: CGFloat { 30 }
            static var verticalSpacing: CGFloat { 30 }
            enum Hero {
                static var captionFont: Font { .callout }
                static var contentFont: Font { .title3.weight(.regular) }
                static var contentLineLimit: Int { 5 }
                static var contentFontStyle: Color { .secondary }
                static var contentPadding: CGFloat { 16 }
                static var headerFont: Font { .title.weight(.bold) }
                static var headerLineLimit: Int { 2 }
                static var headerPadding: CGFloat { 45 }
                static var headerSpacing: CGFloat { 6 }
                static var imageAspectRatio: CGFloat { 2.5 }
                static var leadingPanelWidthFactor: CGFloat { 0.28 }
            }
            enum Promoted {
                static var contentFont: Font { .title3 }
                static var contentLineLimit: Int { 4 }
                static var cornerRadius: CGFloat { 20 }
                static var gridSpacing: CGFloat { 30 }
                static var headerFont: Font { .title2.weight(.semibold) }
                static var headerLineLimit: Int { 2 }
                static var headerPadding: CGFloat { 4 }
                static var horizontalPadding: CGFloat { 20 }
                static var imageDimension: CGFloat { 200 }
                static var topPadding: CGFloat { 12 }
            }
        }
        enum Grid {
            static var cornerRadius: CGFloat { 20 }
            static var dateFont: Font { .body.weight(.light) }
            static var dateLineLimit: Int { 1 }
            static var dateStyle: Color { .secondary }
            static var headerFont: Font { .title3.weight(.semibold) }
            static var headerLineLimit: Int { 2 }
            static var headerStyle: Color { .primary }
            static var horizontalSpacing: CGFloat { 30 }
            static var verticalSpacing: CGFloat { 35 }
            static var width: CGFloat { 294 }
        }
        enum List {
            static var contentFont: Font { .headline.weight(.regular) }
            static var contentLineLimit: Int { 2 }
            static var contentStyle: Color { .primary }
            static var cornerRadius: CGFloat { 13 }
            static var dateFont: Font { .headline.weight(.regular) }
            static var dateStyle: Color { .secondary }
            static var headerFont: Font { .title3.weight(.bold) }
            static var headerLineLimit: Int { 1 }
            static var headerStyle: Color { .primary }
            static var verticalSpacing: CGFloat { 16 }
            static var width: CGFloat { 199 }
        }
    }
    enum Search {
        static var cornerRadius: CGFloat = 8
        static var horizontalSpacing: CGFloat = 8
        static var strokeColor: Color { .secondary.opacity(0.8) }
        static var strokeWidth: CGFloat { 1 }
        static var textStyle: PlainTextFieldStyle { .plain }
        static var verticalSpacing: CGFloat = 6
        static var width: CGFloat = 120
    }
    enum Settings {
        static var subtextFont: Font { .callout }
        static var subtextStyle: Color { .secondary }
    }
    enum TrainingPlan {
        static var imageIdealWidth: CGFloat { 154 }
        static var imageIdealHeight: CGFloat { 87 }
        static var rowInsets: EdgeInsets {
            EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        }
        enum Widget {
            static var background: some ShapeStyle { .fill.tertiary }
            static var contentUnavailableFont: Font { .headline.weight(.bold) }
            static var dateFont: Font { .body.weight(.light).italic() }
            static var dateLineLimit: Int { 1 }
            static var dateStyle: Color { .secondary }
            static var emptySpacing: CGFloat { 10 }
            static var launchButtonFill: some ShapeStyle { .tint.tertiary }
            static var lineLimit: Int { 2 }
            static var verticalSpacing: CGFloat { 12 }
            static var imageCornerRadius: CGFloat { 8 }
            static var bottomSpacing: CGFloat { 24 }
            static var iconSpacing: CGFloat { 12 }
            enum Small {
                static var imageSize: CGFloat { 170 }
                static var shaderOpacity: CGFloat { 0.6 }
                static var fontColor: Color { .white }
            }
            enum Medium {
                static var imageSize: CGFloat { 42 }
            }
            enum Large {
                static var imageSize: CGFloat { 78 }
            }
            static var heroHeaderIconSize: CGFloat { 24 }
            static func heroHeaderFont(for widgetFamily: WidgetFamily) -> Font {
                switch widgetFamily {
                case .systemSmall:
                    return .title3.weight(.bold)
                case .systemMedium:
                    return .title3.weight(.medium)
                default:
                    return .title2.weight(.medium)
                }
            }
            static func titleFont(for widgetFamily: WidgetFamily) -> Font {
                switch widgetFamily {
                case .systemSmall:
                    return .title3.weight(.bold)
                default:
                    return .title2.weight(.bold)
                }
            }
            static func displayCount(for widgetFamily: WidgetFamily) -> Int {
                switch widgetFamily {
                case .systemLarge:
                    return 3
                case .systemMedium:
                    return 2
                default:
                    return 0
                }
            }
        }
    }
}
