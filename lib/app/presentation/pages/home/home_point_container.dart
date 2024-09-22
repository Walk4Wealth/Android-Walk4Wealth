import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class HomePointContainer extends StatelessWidget {
  const HomePointContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //* level kamu
                    Text(
                      'Level Kamu',
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
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    //* poin kamu
                    Text(
                      'Poin',
                      style: Theme.of(context).textTheme.bodySmall,
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
                ),
              ],
            ),
            const Divider(thickness: 1.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: SizedBox(
                    width: double.infinity,
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      child: Column(
                        children: [
                          Text(
                            'Kalori',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '1.000 kal',
                            style: Theme.of(context).textTheme.titleLarge,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: SizedBox(
                    width: double.infinity,
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      child: Column(
                        children: [
                          Text(
                            'Kalori',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '1.000 kal',
                            style: Theme.of(context).textTheme.titleLarge,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
