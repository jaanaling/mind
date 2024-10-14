import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/components/app_logic/bloc/initialization_cubit.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InitializationCubit()..initialize(),
      child: BlocListener<InitializationCubit, InitializationState>(
        listener: (context, state) {
          if (state is InitializedState) {
            context.go(state.startRoute);
          }
        },
        child: Stack(
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
        ),
      ),
    );
  }
}
