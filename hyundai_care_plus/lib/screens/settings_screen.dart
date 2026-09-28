import 'package:flutter/material.dart';

import '../widgets/care_background.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool serviceRemindersEnabled = true;
  bool locationEnabled = true;

  @override
  void initState() {
    super.initState();

    CareTheme.background.addListener(
      _backgroundChanged,
    );
  }

  @override
  void dispose() {
    CareTheme.background.removeListener(
      _backgroundChanged,
    );
    super.dispose();
  }

  void _backgroundChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = CareTheme.isDark;

    return Scaffold(
      backgroundColor: dark
          ? const Color(0xFF020817)
          : const Color(0xFFF3F7FC),
      body: CareBackgroundView(
        child: SafeArea(
          child: CustomScrollView(
            physics:
                const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _buildHeader(),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  18,
                  0,
                  18,
                  30,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _buildAppearanceCard(),
                      const SizedBox(height: 18),
                      _buildPreferenceCard(),
                      const SizedBox(height: 18),
                      _buildAccountCard(),
                      const SizedBox(height: 18),
                      _buildAboutCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        14,
        18,
        22,
      ),
      child: Row(
        children: [
          _iconButton(
            Icons.arrow_back_ios_new_rounded,
            () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Settings',
                  style: TextStyle(
                    color: CareTheme.primaryText,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Personalise your Hyundai Care+ experience',
                  style: TextStyle(
                    color: CareTheme.secondaryText,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: CareTheme.cardColor,
              borderRadius:
                  BorderRadius.circular(14),
              border: Border.all(
                color: CareTheme.borderColor,
              ),
            ),
            child: Icon(
              Icons.tune_rounded,
              color: CareTheme.cyan,
              size: 19,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceCard() {
    return _sectionCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.palette_rounded,
            'Appearance',
            'Choose a background for every Care+ page',
          ),
          const SizedBox(height: 18),
          _backgroundOption(
            background:
                CareBackgroundStyle.midnightAurora,
            title: 'Midnight Aurora',
            subtitle:
                'Dark, mystical & futuristic',
            icon: Icons.nightlight_round,
            previewColors: const [
              Color(0xFF020817),
              Color(0xFF083D59),
              Color(0xFF1A0B3D),
            ],
          ),
          const SizedBox(height: 12),
          _backgroundOption(
            background:
                CareBackgroundStyle.arcticDaylight,
            title: 'Arctic Daylight',
            subtitle:
                'Bright, clean & refreshing',
            icon: Icons.wb_sunny_rounded,
            previewColors: const [
              Color(0xFFF8FCFF),
              Color(0xFFDDF0FF),
              Color(0xFFBBDFFF),
            ],
          ),
        ],
      ),
    );
  }

  Widget _backgroundOption({
    required CareBackgroundStyle background,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> previewColors,
  }) {
    final bool selected =
        CareTheme.background.value == background;

    return GestureDetector(
      onTap: () {
        CareTheme.setBackground(background);
      },
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 280),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? CareTheme.cyan.withValues(
                  alpha: 0.07,
                )
              : CareTheme.cardColor,
          borderRadius:
              BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? CareTheme.cyan.withValues(
                    alpha: 0.55,
                  )
                : CareTheme.borderColor,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            _backgroundPreview(
              colors: previewColors,
              icon: icon,
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: CareTheme.primaryText,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color:
                          CareTheme.secondaryText,
                      fontSize: 7.5,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration:
                  const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? CareTheme.cyan
                    : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? CareTheme.cyan
                      : CareTheme.secondaryText
                          .withValues(alpha: .35),
                ),
              ),
              child: selected
                  ? const Icon(
                      Icons.check_rounded,
                      color: Color(0xFF07152C),
                      size: 15,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _backgroundPreview({
    required List<Color> colors,
    required IconData icon,
  }) {
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius:
            BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: .14,
          ),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 8,
            right: 8,
            child: Icon(
              icon,
              color: Colors.white.withValues(
                alpha: .72,
              ),
              size: 16,
            ),
          ),
          Positioned(
            left: 9,
            right: 9,
            bottom: 10,
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: .20,
                ),
                borderRadius:
                    BorderRadius.circular(5),
              ),
            ),
          ),
          Positioned(
            left: 9,
            right: 25,
            bottom: 20,
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: .32,
                ),
                borderRadius:
                    BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceCard() {
    return _sectionCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.notifications_active_rounded,
            'Preferences',
            'Control how Care+ keeps you updated',
          ),
          const SizedBox(height: 10),
          _switchRow(
            icon: Icons.notifications_rounded,
            title: 'Notifications',
            subtitle:
                'Service and account updates',
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
          ),
          _divider(),
          _switchRow(
            icon: Icons.build_circle_rounded,
            title: 'Service reminders',
            subtitle:
                'Maintenance and service alerts',
            value: serviceRemindersEnabled,
            onChanged: (value) {
              setState(() {
                serviceRemindersEnabled = value;
              });
            },
          ),
          _divider(),
          _switchRow(
            icon: Icons.location_on_rounded,
            title: 'Location services',
            subtitle:
                'Help find nearby service centres',
            value: locationEnabled,
            onChanged: (value) {
              setState(() {
                locationEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _switchRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: CareTheme.cyan.withValues(
                alpha: .06,
              ),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: CareTheme.cyan,
              size: 18,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: CareTheme.primaryText,
                    fontSize: 8.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: CareTheme.secondaryText,
                    fontSize: 6.5,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: CareTheme.cyan,
            activeThumbColor:
                const Color(0xFF07152C),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard() {
    return _sectionCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.manage_accounts_rounded,
            'Account',
            'Manage your Care+ account',
          ),
          const SizedBox(height: 10),
          _actionRow(
            Icons.person_outline_rounded,
            'Profile',
            'View and edit your profile',
            () => _message(
              'Open Profile from the More menu.',
            ),
          ),
          _divider(),
          _actionRow(
            Icons.lock_outline_rounded,
            'Privacy & Security',
            'Keep your account secure',
            () => _message(
              'Your account security settings are protected.',
            ),
          ),
          _divider(),
          _actionRow(
            Icons.delete_outline_rounded,
            'Account data',
            'Manage your stored information',
            _showDataDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard() {
    return _sectionCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.info_outline_rounded,
            'About',
            'Hyundai Care+',
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Hyundai Care+',
                  style: TextStyle(
                    color: CareTheme.primaryText,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: CareTheme.secondaryText,
                  fontSize: 7,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Text(
            'Your connected vehicle care companion.',
            style: TextStyle(
              color: CareTheme.secondaryText,
              fontSize: 7.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CareTheme.cardColor,
        borderRadius:
            BorderRadius.circular(21),
        border: Border.all(
          color: CareTheme.borderColor,
        ),
      ),
      child: child,
    );
  }

  Widget _sectionTitle(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Row(
      children: [
        Container(
          width: 39,
          height: 39,
          decoration: BoxDecoration(
            color: CareTheme.cyan.withValues(
              alpha: .06,
            ),
            borderRadius:
                BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: CareTheme.cyan,
            size: 18,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: CareTheme.primaryText,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(
                  color: CareTheme.secondaryText,
                  fontSize: 6.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _actionRow(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(12),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          vertical: 12,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: CareTheme.cyan,
              size: 19,
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: CareTheme.primaryText,
                      fontSize: 8.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color:
                          CareTheme.secondaryText,
                      fontSize: 6.5,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: CareTheme.secondaryText
                  .withValues(alpha: .45),
              size: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      color: CareTheme.borderColor,
    );
  }

  Widget _iconButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(14),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: CareTheme.cardColor,
            borderRadius:
                BorderRadius.circular(14),
            border: Border.all(
              color: CareTheme.borderColor,
            ),
          ),
          child: Icon(
            icon,
            color: CareTheme.primaryText,
            size: 18,
          ),
        ),
      ),
    );
  }

  void _showDataDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: CareTheme.isDark
              ? const Color(0xFF07152C)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(22),
          ),
          title: Text(
            'Account Data',
            style: TextStyle(
              color: CareTheme.primaryText,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Your vehicle, service and account information is managed securely through Hyundai Care+.',
            style: TextStyle(
              color: CareTheme.secondaryText,
              fontSize: 9,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'CLOSE',
                style: TextStyle(
                  color: CareTheme.cyan,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _message(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior:
              SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(13),
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 9,
            ),
          ),
        ),
      );
  }
}