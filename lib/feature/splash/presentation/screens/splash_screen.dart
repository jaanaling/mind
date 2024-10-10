import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bubblebrain/routes/route_value.dart';
import 'package:advertising_id/advertising_id.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startLoading(context);
  }

  Future<void> startLoading(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final adId = await AdvertisingId.id(true);
    });
     

    context.go(RouteValue.mindMap.path);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/image/img.png',
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: LinearProgressIndicator(
              minHeight: 10,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF320072)),
              backgroundColor: Colors.grey[300],
            ),
          ),
        ),
      ],
    );
  }
}
