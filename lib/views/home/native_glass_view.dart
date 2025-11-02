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

    return SizedBox(
      height: totalHeight,
      width: double.infinity,
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
    );
  }
}
