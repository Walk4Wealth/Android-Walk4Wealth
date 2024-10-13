import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

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
      child: Consumer<UserProvider>(builder: (_, c, child) {
        return Row(
          children: [
            //* foto profil
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: c.getImgProfile(),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            const SizedBox(width: 12),

            //* nama
            Flexible(
              fit: FlexFit.tight,
              child: Text.rich(
                TextSpan(
                  text: 'Selamat datang, ',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                  children: [
                    TextSpan(
                      text: '\n${c.user?.nama ?? c.user?.username}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),

            //* icon
            Icon(
              Iconsax.notification,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ],
        );
      }),
    );
  }
}
