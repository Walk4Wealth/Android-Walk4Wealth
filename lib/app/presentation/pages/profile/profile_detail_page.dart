import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/components/w_app_bar.dart';
import '../../../core/utils/components/w_text_field.dart';
import '../../providers/user_provider.dart';

class ProfileDetailPage extends StatelessWidget {
  const ProfileDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        title: context.watch<UserProvider>().user?.nama ??
            context.watch<UserProvider>().user?.username ??
            'Akun ini tidak memiliki Nama',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: Consumer<UserProvider>(
            builder: (_, c, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // foto
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            backgroundImage: c.getImgProfile(),
                          ),
                        ),
                        //
                        Text(
                          c.user?.username ??
                              'Akun ini tidak memiliki username',
                        ),
                        Text(
                          c.user?.email ?? 'Akun ini tidak memiliki email',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // level
                  _profileMenu(
                    context,
                    title: 'Level',
                    value: c.user?.level ?? 'Akun ini tidak memiliki Level',
                  ),

                  // role
                  _profileMenu(
                    context,
                    title: 'Role',
                    value: c.user?.role ?? 'Akun ini tidak memiliki Role',
                  ),

                  // usia
                  _profileMenu(
                    context,
                    title: 'Usia',
                    value: '${c.user?.age ?? 0} Tahun',
                  ),

                  Row(
                    children: [
                      // tinggi
                      Flexible(
                        child: _profileMenu(
                          context,
                          title: 'Tinggi',
                          value: '${c.user?.height ?? 0} Cm',
                        ),
                      ),
                      const SizedBox(width: 8),
                      // berat
                      Flexible(
                        child: _profileMenu(
                          context,
                          title: 'Berat',
                          value: '${c.user?.weight ?? 0} Kg',
                        ),
                      ),
                    ],
                  ),

                  // no telp
                  _profileMenu(
                    context,
                    title: 'Kontak',
                    value: '${c.user?.noTelp ?? '0*********'}',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _profileMenu(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 4),
        WTextField(
          isDense: true,
          readOnly: true,
          initialValue: value,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
