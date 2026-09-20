import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  final Function(int)? onNavigateTab;

  const ProfileScreen({
    super.key,
    this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Profile',
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 24),

              // User Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceOffWhite,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.dividerColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        CupertinoIcons.person_fill,
                        color: AppTheme.primaryBlue,
                        size: 34,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Munib Akhtar',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'munib@rentaboat.app',
                            style: GoogleFonts.outfit(
                              fontSize: 13.5,
                              color: AppTheme.textGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      CupertinoIcons.pencil_circle_fill,
                      color: AppTheme.primaryBlue,
                      size: 28,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Text(
                'Account Settings',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 12),

              _buildSettingsTile(
                icon: CupertinoIcons.person_badge_plus,
                title: 'Personal Information',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: CupertinoIcons.calendar,
                title: 'My Bookings',
                onTap: () {
                  if (onNavigateTab != null) onNavigateTab!(2);
                },
              ),
              _buildSettingsTile(
                icon: CupertinoIcons.creditcard,
                title: 'Payment Methods & Wallet',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: CupertinoIcons.bell,
                title: 'Notifications & Alerts',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: CupertinoIcons.doc_text_viewfinder,
                title: 'Boating Licenses & Insurance',
                onTap: () {},
              ),

              const SizedBox(height: 24),
              Text(
                'Support & Legal',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 12),

              _buildSettingsTile(
                icon: CupertinoIcons.question_circle,
                title: 'Help Center & Safety Rules',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: CupertinoIcons.shield_lefthalf_fill,
                title: 'Terms of Service & Privacy',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: CupertinoIcons.square_arrow_left,
                title: 'Log Out',
                color: AppTheme.coralRed,
                onTap: () {},
              ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceOffWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerColor.withValues(alpha: 0.7)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (color ?? AppTheme.primaryBlue).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: color ?? AppTheme.primaryBlue,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: color ?? AppTheme.textDark,
          ),
        ),
        trailing: const Icon(
          CupertinoIcons.chevron_right,
          color: AppTheme.textLightGray,
          size: 16,
        ),
      ),
    );
  }
}
