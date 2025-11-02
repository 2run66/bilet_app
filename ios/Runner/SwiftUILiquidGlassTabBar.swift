import UIKit
import SwiftUI
import Flutter

@available(iOS 15.0, *)
class SwiftUILiquidGlassTabBarFactory: NSObject, FlutterPlatformViewFactory {
  private let messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }

  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    FlutterStandardMessageCodec.sharedInstance()
  }

  func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
    return SwiftUILiquidGlassTabBar(frame: frame, viewId: viewId, messenger: messenger)
  }
}

@available(iOS 15.0, *)
class SwiftUILiquidGlassTabBar: NSObject, FlutterPlatformView {
  private let hostingController: UIHostingController<LiquidGlassTabBarView>
  private let methodChannel: FlutterMethodChannel

  init(frame: CGRect, viewId: Int64, messenger: FlutterBinaryMessenger) {
    let tabBarView = LiquidGlassTabBarView(viewId: viewId, messenger: messenger)
    hostingController = UIHostingController(rootView: tabBarView)
    methodChannel = FlutterMethodChannel(name: "liquid_glass_tabbar_\(viewId)", binaryMessenger: messenger)
    super.init()
    
    hostingController.view.frame = frame
    hostingController.view.backgroundColor = .clear
  }

  func view() -> UIView {
    return hostingController.view
  }
}

@available(iOS 15.0, *)
struct LiquidGlassTabBarView: View {
  let viewId: Int64
  let messenger: FlutterBinaryMessenger
  @State private var selectedIndex: Int = 0
  
  init(viewId: Int64, messenger: FlutterBinaryMessenger) {
    self.viewId = viewId
    self.messenger = messenger
  }
  
  var body: some View {
    HStack(spacing: 0) {
      TabBarButton(icon: "house", fillIcon: "house.fill", title: "Home", isSelected: selectedIndex == 0) {
        selectedIndex = 0
        notifyFlutter(index: 0)
      }
      TabBarButton(icon: "magnifyingglass", fillIcon: "magnifyingglass", title: "Browse", isSelected: selectedIndex == 1) {
        notifyFlutter(index: 1)
        selectedIndex = 1
      }
      TabBarButton(icon: "ticket", fillIcon: "ticket.fill", title: "Tickets", isSelected: selectedIndex == 2) {
        notifyFlutter(index: 2)
        selectedIndex = 2
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.top, 8)
    .padding(.bottom, 8)
    .background {
      if #available(iOS 26.0, *) {
        Color.clear
          .glassEffect() // Native iOS 26 Liquid Glass!
      } else {
        Color.clear
          .background(.ultraThinMaterial)
      }
    }
    .onAppear {
      setupMethodChannel()
    }
  }
  
  private func setupMethodChannel() {
    let channel = FlutterMethodChannel(name: "liquid_glass_tabbar_\(viewId)", binaryMessenger: messenger)
    channel.setMethodCallHandler { [self] call, result in
      if call.method == "setIndex", let args = call.arguments as? [String: Any], let index = args["index"] as? Int {
        DispatchQueue.main.async {
          self.selectedIndex = index
        }
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
  }
  
  private func notifyFlutter(index: Int) {
    let channel = FlutterMethodChannel(name: "liquid_glass_tabbar_\(viewId)", binaryMessenger: messenger)
    channel.invokeMethod("onTap", arguments: ["index": index])
  }
}

@available(iOS 13.0, *)
struct TabBarButton: View {
  let icon: String
  let fillIcon: String
  let title: String
  let isSelected: Bool
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      VStack(spacing: 4) {
        Image(systemName: isSelected ? fillIcon : icon)
          .font(.system(size: 24))
        Text(title)
          .font(.system(size: 10))
      }
      .foregroundColor(isSelected ? .blue : .secondary)
      .frame(maxWidth: .infinity)
    }
  }
}

