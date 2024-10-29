import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/strings/asset_img_string.dart';
import '../../providers/user_provider.dart';

class HomePointContainer extends StatelessWidget {
  const HomePointContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //* my level
                  _myLevel(context),

                  //* my points
                  _myPoints(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _myPoints(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Image.asset(
              AssetImg.iconCoin,
              width: 15,
              height: 15,
            ),
            const SizedBox(width: 6),
            Text(
              'Poin',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Consumer<UserProvider>(
          builder: (_, c, child) {
            return Text(
              '${c.user?.totalPoints ?? 0}',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            );
          },
        )
      ],
    );
  }

  Widget _myLevel(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Level saya',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Consumer<UserProvider>(
          builder: (_, c, child) {
            return InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    c.user?.level ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 14),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
