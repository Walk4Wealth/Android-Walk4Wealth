import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/navigate.dart';
import '../../../core/utils/components/w_app_bar.dart';
import '../../providers/auth/logout_provider.dart';
import '../../providers/user_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WAppBar(title: 'Akun'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // mini profile card
            InkWell(
              onTap: () {
                context.read<UserProvider>().updateImgProfile(context);
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Consumer<UserProvider>(
                  builder: (_, c, child) {
                    return Row(
                      children: [
                        // foto profil
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 32,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            backgroundImage: c.getImgProfile(),
                          ),
                        ),
                        const SizedBox(width: 12),

                        Flexible(
                          fit: FlexFit.tight,
                          flex: 10,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // nama
                              Text(
                                c.user?.nama ?? c.user?.username ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              // level
                              Text(
                                (c.user?.level ?? 'null level'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Iconsax.edit_2),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // menu profile
            _menuTile(
              context,
              icon: Iconsax.profile_tick,
              title: 'Profil Saya',
              onTap: () => Navigator.pushNamed(
                context,
                To.DETAIL_PROFIL,
              ),
            ),
            _menuTile(
              context,
              icon: Iconsax.notification,
              title: 'Notifikasi',
              onTap: () {},
            ),
            _menuTile(
              context,
              icon: Iconsax.heart_add,
              title: 'Penawaran yang disukai',
              onTap: () => Navigator.pushNamed(context, To.FAVORITE),
            ),
            _menuTile(
              context,
              icon: Iconsax.setting,
              title: 'Pengaturan aplikasi',
              onTap: () {},
            ),
            _menuTile(
              context,
              icon: Iconsax.shield_tick,
              title: 'Kebijakan & Privasi',
              onTap: () {},
            ),
            _menuTile(
              context,
              foregroundColor: Colors.red,
              showTrailing: false,
              showDivider: false,
              icon: Iconsax.logout,
              title: 'Keluar',
              onTap: () {
                context.read<LogoutProvider>().logoutPopUp(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required void Function() onTap,
    Color foregroundColor = Colors.black,
    bool showTrailing = true,
    bool showDivider = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Stack(
        children: [
          ListTile(
            leading: Icon(icon),
            title: Text(
              title,
              style: TextStyle(color: foregroundColor),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(),
            trailing:
                (showTrailing) ? const Icon(Icons.arrow_forward_ios) : null,
            onTap: onTap,
            iconColor: foregroundColor,
          ),
          // divider
          Visibility(
            visible: showDivider,
            child: Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.grey,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
