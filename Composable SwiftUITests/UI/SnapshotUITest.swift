import SwiftUI
import SnapshotTesting

protocol SnapshotUITest {
    //perceptualPrecision: Float = 1,
    //perceptualPrecision: 0.98,
    var smallDevice: ViewImageConfig { get }
    
    func testSutViewOnSmallDeviceLight(view: some View)
    func testSutViewOnSmallDeviceDark(view: some View)
    
    associatedtype T: View
    var smallDeviceLightConfig: T { get }
}

//Snapshotting


extension SnapshotUITest {
    
    var smallDevice: ViewImageConfig {
        .iPhone13Mini
    }
    
    
    
    var smallDeviceLightConfig: SimplySnapshotting<T> {
        .image(
            layout: .device(config: smallDevice),
            traits: .init(userInterfaceStyle: .light)
        )
    }
    
    func testSutViewOnSmallDeviceLight(view: some View) {
        runTestWithLightInterface(of: view, on: smallDevice)
    }
    
    func testSutViewOnSmallDeviceDark(view: some View) {
        runTestWithDarkInterface(of: view, on: smallDevice)
    }
    
    fileprivate func runTestWithLightInterface(of view: some View, on device: ViewImageConfig) {
        runTest(
            view: view,
            device: device,
            interfaceStyle: .light
        )
    }
    
    fileprivate func runTestWithDarkInterface(of view: some View, on device: ViewImageConfig) {
        runTest(
            view: view,
            device: device,
            interfaceStyle: .dark
        )
    }
    
    fileprivate func runTest(view: some View, device: ViewImageConfig, interfaceStyle: UIUserInterfaceStyle) {
        assertSnapshot(
            matching: view,
            as: .image(
                layout: .device(config: smallDevice),
                traits: .init(userInterfaceStyle: interfaceStyle)
            )
        )
    }
}
