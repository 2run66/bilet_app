import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LiquidGlassTabBar extends StatefulWidget {
  const LiquidGlassTabBar({
    super.key,
    required this.index,
    required this.onTap,
  });

  final int index;
  final ValueChanged<int> onTap;

  @override
  State<LiquidGlassTabBar> createState() => _LiquidGlassTabBarState();
}

class _LiquidGlassTabBarState extends State<LiquidGlassTabBar> {
  MethodChannel? _methodChannel;
  int _viewId = -1;

  @override
  void didUpdateWidget(covariant LiquidGlassTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_viewId != -1 && oldWidget.index != widget.index) {
      _methodChannel?.invokeMethod('setIndex', {'index': widget.index});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      return const SizedBox.shrink();
    }
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    const double barHeight = kBottomNavigationBarHeight;
    final double totalHeight = barHeight + bottomInset;
    final double screenWidth = MediaQuery.of(context).size.width;
    const double maxWidth = 320.0; // Tighter width
    final double horizontalPadding = (screenWidth - maxWidth) / 2;

    return Padding(
      padding: EdgeInsets.only(
        left: horizontalPadding > 0 ? horizontalPadding : 16,
        right: horizontalPadding > 0 ? horizontalPadding : 16,
        bottom: 0,
      ),
      child: SizedBox(
        height: totalHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: UiKitView(
            viewType: 'liquid_glass_tabbar',
            onPlatformViewCreated: (id) {
              _viewId = id;
              _methodChannel = MethodChannel('liquid_glass_tabbar_$id');
              _methodChannel?.invokeMethod('setIndex', {'index': widget.index});
              _methodChannel?.setMethodCallHandler((call) async {
                if (!mounted) return;
                if (call.method == 'onTap') {
                  final map = Map<String, dynamic>.from(call.arguments as Map);
                  final idx = (map['index'] as num).toInt();
                  widget.onTap(idx);
                }
              });
            },
            creationParams: const <String, dynamic>{},
            creationParamsCodec: const StandardMessageCodec(),
          ),
        ),
      ),
    );
  }
}
