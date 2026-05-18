import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app_session_cubit/app_session_cubit.dart';
import '../bloc/app_loading_cubit/app_loading_cubit.dart';

class AppOverlay extends StatelessWidget {
  const AppOverlay({super.key, required this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppSessionCubit, SessionState, bool>(
      selector: (state) {
        return state is SessionInitial || state is SessionLoading;
      },
      builder: (context, isBooting) {
        if (isBooting) {
          return const _AppSplashPage();
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            child ?? const SizedBox.shrink(),
            const _AppLoadingOverlay(),
          ],
        );
      },
    );
  }
}

class _AppSplashPage extends StatelessWidget {
  const _AppSplashPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'My splash screen App',
          style: TextStyle(
            fontSize: 28,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _AppLoadingOverlay extends StatelessWidget {
  const _AppLoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppLoadingCubit, int, bool>(
      selector: (state) {
        return state > 0;
      },
      builder: (context, isLoading) {
        if (!isLoading) return const SizedBox.shrink();
        return const Stack(
          children: [
            ModalBarrier(dismissible: false, color: Colors.black54),
            Center(
              child: SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

  }
}

// class _NoInternetBanner extends StatelessWidget {
//   const _NoInternetBanner({required this.blockWhenOffline});
//
//   final bool blockWhenOffline;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<NetworkCubit, bool>(
//       builder: (context, connected) {
//         if (connected) return const SizedBox.shrink();
//
//         return Stack(
//           children: [
//             if (blockWhenOffline)
//               const ModalBarrier(dismissible: false, color: Colors.black26),
//
//             SafeArea(
//               child: Align(
//                 alignment: Alignment.topCenter,
//                 child: Container(
//                   margin: const EdgeInsets.all(12),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 10,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.wifi_off, color: Colors.white, size: 18),
//                       SizedBox(width: 8),
//                       Text(
//                         'No internet connection',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
