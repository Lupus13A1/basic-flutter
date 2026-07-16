import 'package:basic_app/constants/app_text_styles.dart';
import 'package:basic_app/widgets/app_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = true;

  void _handleBottomNavTap(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 2:
        break;
      default:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Coming soon')));
    }
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEAECEF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF6B7280)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyEmphasis.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
          trailing ?? Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: const Color(0xFF6B7280)),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppTextStyles.bodySecondary.copyWith(
            fontSize: 13,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F8),
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: 2,
        onTap: _handleBottomNavTap,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 250,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?auto=format&fit=crop&w=1200&q=80',
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.12),
                                Colors.black.withValues(alpha: 0.26),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 12,
                          child: Container(
                            height: 38,
                            width: 38,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                    child: Transform.translate(
                      offset: const Offset(0, -28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const CircleAvatar(
                                  radius: 38,
                                  backgroundImage: NetworkImage(
                                    'https://media1.giphy.com/media/v1.Y2lkPTZjMDliOTUyczhjenQwN3FqZHNpOG95bGl5NnQ3YzY4MXMyZG52bjZ5YWV6amJhaSZlcD12MV9zdGlja2Vyc19zZWFyY2gmY3Q9cw/ESxJEr8Bk14WGjLB18/source.gif',
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                height: 38,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(19),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Edit',
                                  style: AppTextStyles.bodySecondary.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF40464F),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Thanet Chankhua',
                            style: AppTextStyles.headline1.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _infoChip(
                                Icons.calendar_month_outlined,
                                '16 Oct 2004',
                              ),
                              const SizedBox(width: 18),
                              _infoChip(
                                Icons.location_on_outlined,
                                'Nonthaburi, Thailand',
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Nope Nope Nope Nope\nNope ',
                            style: AppTextStyles.bodySecondary.copyWith(
                              height: 1.45,
                              color: const Color(0xFF525960),
                            ),
                          ),
                          const SizedBox(height: 22),
                          Text(
                            'Other Information',
                            style: AppTextStyles.bodyEmphasis.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _settingTile(
                            icon: Icons.notifications_none,
                            title: 'Notification',
                            trailing: Switch.adaptive(
                              value: notificationsEnabled,
                              activeThumbColor: const Color(0xFF22C55E),
                              activeTrackColor: const Color(0xFFA7F3D0),
                              onChanged: (value) {
                                setState(() {
                                  notificationsEnabled = value;
                                });
                              },
                            ),
                          ),
                          _settingTile(icon: Icons.language, title: 'Language'),
                          _settingTile(
                            icon: Icons.dark_mode_outlined,
                            title: 'Dark Mode',
                            trailing: Switch.adaptive(
                              value: darkModeEnabled,
                              activeThumbColor: const Color(0xFF22C55E),
                              activeTrackColor: const Color(0xFFA7F3D0),
                              onChanged: (value) {
                                setState(() {
                                  darkModeEnabled = value;
                                });
                              },
                            ),
                          ),
                          _settingTile(
                            icon: Icons.description_outlined,
                            title: 'Terms and conditions of Use',
                          ),
                          _settingTile(
                            icon: Icons.support_agent_outlined,
                            title: 'Support',
                          ),
                          _settingTile(icon: Icons.logout, title: 'Log out'),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
