import SwiftUI

extension EdgeInsets {
    
    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
}
