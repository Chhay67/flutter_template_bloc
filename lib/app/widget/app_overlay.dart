import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app_loading_cubit/app_loading_cubit.dart';

class AppOverlay extends StatelessWidget {
  const AppOverlay({
    super.key,
    required this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child ?? const SizedBox.shrink(),
        const _CustomLoadingWidget(),
        //_NoInternetBanner()
      ],
    );
  }
}

class _CustomLoadingWidget extends StatelessWidget {
  const _CustomLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppLoadingCubit, int>(
      buildWhen: (previous, current) {
        return (previous > 0) != (current > 0);
      },
      builder: (context, count) {
        if (count <= 0) return const SizedBox.shrink();

        return const Stack(
          children: [
            ModalBarrier(
              dismissible: false,
              color: Colors.black54,
            ),
            Center(
              child: SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
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