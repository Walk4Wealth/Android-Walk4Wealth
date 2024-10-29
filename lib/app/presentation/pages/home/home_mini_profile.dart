import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/enums/request_state.dart';
import '../../providers/user_provider.dart';

class HomeMiniProfile extends StatelessWidget {
  const HomeMiniProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        top: kToolbarHeight,
        left: 16,
        right: 16,
      ),
      child: LayoutBuilder(builder: (_, size) {
        return Consumer<UserProvider>(builder: (ctx, c, _) {
          return Row(
            children: [
              //* foto profil
              _profileImage(context, c),
              const SizedBox(width: 12),

              //* nama
              // "Selamat datang: nama"
              _welcomeName(context, c, size.maxWidth),
            ],
          );
        });
      }),
    );
  }

  Widget _profileImage(BuildContext context, UserProvider c) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        radius: 30,
        backgroundImage:
            (c.state == RequestState.SUCCESS) ? c.getImgProfile() : null,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }

  Widget _welcomeName(BuildContext context, UserProvider c, double width) {
    return Flexible(
      fit: FlexFit.tight,
      child: (c.state == RequestState.SUCCESS)
          //* succees state
          ? Text.rich(
              TextSpan(
                text: 'Selamat datang, ',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                children: [
                  TextSpan(
                    text: (c.state == RequestState.SUCCESS)
                        ? '\n${c.user?.nama ?? c.user?.username}'
                        : '\nMemuat...',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                  ),
                ],
              ),
            )
          //* loading/error state
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat datang, ',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                ),
                const SizedBox(height: 8),
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: width / 3,
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
