import UIKit

struct NavigationBarAppearance {
    
    static func navigationBarColors(background : UIColor?,
                                    titleColor : UIColor? = nil,
                                    tintColor : UIColor? = nil,
                                    showLineSeparator: Bool
    ){
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithOpaqueBackground()
        navigationAppearance.backgroundColor = background ?? .clear
        
        navigationAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .black]
        navigationAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .black]
        
        if !showLineSeparator {
            navigationAppearance.shadowColor = .clear
            navigationAppearance.shadowImage = UIImage()
        }
        
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
        
        UINavigationBar.appearance().tintColor = tintColor ?? titleColor ?? .black
    }
}
