import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../widgets/care_background.dart';

class SupportScreen extends StatefulWidget {
  final int? customerId;

  const SupportScreen({
    super.key,
    this.customerId,
  });

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen>
    with TickerProviderStateMixin {
  late AnimationController auroraController;
  late AnimationController entranceController;

  final TextEditingController searchController =
      TextEditingController();

  final List<SupportCategory> categories = const [
    SupportCategory(
      title: 'Service',
      subtitle: 'Booking & maintenance',
      icon: Icons.build_circle_rounded,
      color: Color(0xFF70E8FF),
    ),
    SupportCategory(
      title: 'Roadside',
      subtitle: 'Emergency assistance',
      icon: Icons.car_repair_rounded,
      color: Color(0xFFFFC857),
    ),
    SupportCategory(
      title: 'Payments',
      subtitle: 'Bills & transactions',
      icon: Icons.account_balance_wallet_rounded,
      color: Color(0xFF7BFFB2),
    ),
    SupportCategory(
      title: 'Account',
      subtitle: 'Profile & settings',
      icon: Icons.person_rounded,
      color: Color(0xFFB28CFF),
    ),
  ];

  final List<SupportArticle> articles = const [
    SupportArticle(
      title: 'How do I book a service?',
      category: 'Service',
      icon: Icons.calendar_month_rounded,
    ),
    SupportArticle(
      title: 'How can I track my vehicle?',
      category: 'Vehicle',
      icon: Icons.location_on_rounded,
    ),
    SupportArticle(
      title: 'How do Care+ points work?',
      category: 'Rewards',
      icon: Icons.stars_rounded,
    ),
    SupportArticle(
      title: 'How do I update my profile?',
      category: 'Account',
      icon: Icons.edit_rounded,
    ),
    SupportArticle(
      title: 'How do I request roadside assistance?',
      category: 'Roadside',
      icon: Icons.warning_amber_rounded,
    ),
  ];

  final List<ChatMessage> messages = [
    ChatMessage(
      text:
          'Hi! I’m your Hyundai Care+ assistant. How can I help you today?',
      fromUser: false,
    ),
  ];

  @override
  void initState() {
    super.initState();

    auroraController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    auroraController.dispose();
    entranceController.dispose();
    searchController.dispose();
    super.dispose();
  }

  List<SupportArticle> get filteredArticles {
    final query =
        searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return articles;
    }

    return articles.where((article) {
      return article.title
              .toLowerCase()
              .contains(query) ||
          article.category
              .toLowerCase()
              .contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020817),
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: auroraController,
            builder: (context, child) {
              return CustomPaint(
                painter: _SupportAuroraPainter(
                  progress: auroraController.value,
                ),
              );
            },
          ),
          CareBackground(
            child: SafeArea(
              child: _buildPage(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: _buildHeader(),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            20,
            0,
            20,
            30,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                _animated(
                  0,
                  _buildHero(),
                ),

                const SizedBox(height: 17),

                _animated(
                  1,
                  _buildSearch(),
                ),

                const SizedBox(height: 19),

                _animated(
                  2,
                  _buildCategories(),
                ),

                const SizedBox(height: 20),

                _animated(
                  3,
                  _buildQuickHelp(),
                ),

                const SizedBox(height: 20),

                _animated(
                  4,
                  _buildArticles(),
                ),

                const SizedBox(height: 20),

                _animated(
                  5,
                  _buildContactCard(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        12,
        18,
        20,
      ),
      child: Row(
        children: [
          _circleButton(
            Icons.arrow_back_ios_new_rounded,
            () => Navigator.pop(context),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Help & Support',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'We are here whenever you need us',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          _circleButton(
            Icons.chat_bubble_outline_rounded,
            _openChat,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HERO
  // ============================================================

  Widget _buildHero() {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF102F52),
            Color(0xFF211A4C),
            Color(0xFF073A40),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color:
              const Color(0xFF70E8FF).withValues(
            alpha: 0.13,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  const Color(0xFF70E8FF)
                      .withValues(alpha: 0.07),
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: Color(0xFF70E8FF),
              size: 31,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'How can we help?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Get answers, contact support or chat with Care+.',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 7.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _buildSearch() {
    return Container(
      height: 51,
      decoration: BoxDecoration(
        color:
            Colors.white.withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              Colors.white.withValues(alpha: 0.07),
        ),
      ),
      child: TextField(
        controller: searchController,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF70E8FF),
            size: 20,
          ),
          hintText: 'Search help articles...',
          hintStyle: const TextStyle(
            color: Colors.white24,
            fontSize: 8,
          ),
          suffixIcon:
              searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        searchController.clear();
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white38,
                        size: 17,
                      ),
                    )
                  : null,
        ),
      ),
    );
  }

  // ============================================================
  // CATEGORIES
  // ============================================================

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Browse by category',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.7,
          ),
          itemBuilder: (context, index) {
            final category =
                categories[index];

            return _categoryCard(category);
          },
        ),
      ],
    );
  }

  Widget _categoryCard(
    SupportCategory category,
  ) {
    return GestureDetector(
      onTap: () {
        searchController.text =
            category.title;
      },
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color:
              Colors.white.withValues(alpha: 0.035),
          borderRadius:
              BorderRadius.circular(17),
          border: Border.all(
            color:
                Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(11),
                color:
                    category.color.withValues(
                  alpha: 0.07,
                ),
              ),
              child: Icon(
                category.icon,
                color: category.color,
                size: 19,
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    category.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.subtitle,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white30,
                      fontSize: 5.8,
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

  // ============================================================
  // QUICK HELP
  // ============================================================

  Widget _buildQuickHelp() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            const Color(0xFF70E8FF)
                .withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              const Color(0xFF70E8FF)
                  .withValues(alpha: 0.10),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.flash_on_rounded,
                color: Color(0xFFFFC857),
                size: 18,
              ),
              SizedBox(width: 7),
              Text(
                'Quick Help',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _quickAction(
                  Icons.calendar_month_rounded,
                  'Book Service',
                  () {
                    showMessage(
                      'Opening service booking...',
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _quickAction(
                  Icons.car_repair_rounded,
                  'Roadside',
                  () {
                    _roadsideDialog();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _quickAction(
                  Icons.chat_rounded,
                  'Chat',
                  _openChat,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickAction(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 7,
        ),
        decoration: BoxDecoration(
          color:
              Colors.white.withValues(alpha: 0.035),
          borderRadius:
              BorderRadius.circular(13),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: const Color(0xFF70E8FF),
              size: 20,
            ),
            const SizedBox(height: 7),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 6,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ARTICLES
  // ============================================================

  Widget _buildArticles() {
    final results = filteredArticles;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              'Popular Help',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Icon(
              Icons.auto_awesome_rounded,
              color: Color(0xFFB28CFF),
              size: 16,
            ),
          ],
        ),
        const SizedBox(height: 11),
        if (results.isEmpty)
          _emptySearch()
        else
          ...results.map(
            (article) =>
                Padding(
              padding:
                  const EdgeInsets.only(
                bottom: 9,
              ),
              child:
                  _articleCard(article),
            ),
          ),
      ],
    );
  }

  Widget _articleCard(
    SupportArticle article,
  ) {
    return GestureDetector(
      onTap: () {
        _showArticle(article);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color:
              Colors.white.withValues(alpha: 0.035),
          borderRadius:
              BorderRadius.circular(16),
          border: Border.all(
            color:
                Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(11),
                color:
                    const Color(0xFF70E8FF)
                        .withValues(alpha: 0.05),
              ),
              child: Icon(
                article.icon,
                color:
                    const Color(0xFF70E8FF),
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
                    article.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    article.category,
                    style: const TextStyle(
                      color: Colors.white24,
                      fontSize: 6,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0x33FFFFFF),
              size: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptySearch() {
    return Container(
      padding: const EdgeInsets.all(25),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color:
            Colors.white.withValues(alpha: 0.03),
        borderRadius:
            BorderRadius.circular(17),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            color: Colors.white24,
            size: 28,
          ),
          SizedBox(height: 9),
          Text(
            'No help articles found',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONTACT
  // ============================================================

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF70E8FF)
                .withValues(alpha: 0.06),
            const Color(0xFFB28CFF)
                .withValues(alpha: 0.04),
          ],
        ),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color:
              Colors.white.withValues(alpha: 0.07),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Still need help?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Our Care+ support team is ready to assist you.',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 7,
            ),
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _openChat,
                  icon: const Icon(
                    Icons.chat_rounded,
                    size: 15,
                  ),
                  label: const Text(
                    'LIVE CHAT',
                  ),
                  style:
                      OutlinedButton.styleFrom(
                    foregroundColor:
                        const Color(0xFF70E8FF),
                    side: BorderSide(
                      color:
                          const Color(0xFF70E8FF)
                              .withValues(
                        alpha: 0.20,
                      ),
                    ),
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    textStyle:
                        const TextStyle(
                      fontSize: 6.5,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    showMessage(
                      'Calling Hyundai Care+ support...',
                    );
                  },
                  icon: const Icon(
                    Icons.phone_rounded,
                    size: 15,
                  ),
                  label: const Text(
                    'CALL SUPPORT',
                  ),
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF147DFF),
                    foregroundColor:
                        Colors.white,
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    textStyle:
                        const TextStyle(
                      fontSize: 6.5,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CHAT
  // ============================================================

  void _openChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CareChatScreen(
          initialMessages: messages,
        ),
      ),
    );
  }

  // ============================================================
  // ARTICLE
  // ============================================================

  void _showArticle(
    SupportArticle article,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          const Color(0xFF07152C),
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              22,
              18,
              22,
              30,
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration:
                        BoxDecoration(
                      color: Colors.white24,
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Icon(
                      article.icon,
                      color:
                          const Color(0xFF70E8FF),
                      size: 25,
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Text(
                        article.title,
                        style:
                            const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  'Care+ Guide',
                  style: TextStyle(
                    color:
                        Color(0xFF70E8FF),
                    fontSize: 8,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _articleContent(
                    article,
                  ),
                  style:
                      const TextStyle(
                    color: Colors.white54,
                    fontSize: 8.5,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _openChat();
                    },
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(
                        0xFF147DFF,
                      ),
                      foregroundColor:
                          Colors.white,
                      minimumSize:
                          const Size(
                        double.infinity,
                        46,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          13,
                        ),
                      ),
                    ),
                    child:
                        const Text(
                      'ASK CARE+ ASSISTANT',
                      style:
                          TextStyle(
                        fontSize: 7,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _articleContent(
    SupportArticle article,
  ) {
    switch (article.category) {
      case 'Service':
        return 'Open the Service section from your Care+ home screen, select your vehicle and preferred service centre, choose an available date and time, then confirm your booking.';
      case 'Vehicle':
        return 'Use Vehicle Tracking to view your vehicle status, service progress and the latest available location information.';
      case 'Rewards':
        return 'Care+ points can be earned through eligible services, vehicle health activities and referral programs. Use the Rewards section to view and redeem available benefits.';
      case 'Account':
        return 'Open your profile and choose Edit Profile to update your personal details, contact information and other account preferences.';
      case 'Roadside':
        return 'For roadside assistance, open the Roadside Assistance feature and follow the emergency assistance steps shown on screen.';
      default:
        return 'Care+ provides guided assistance for your vehicle, service and account needs.';
    }
  }

  // ============================================================
  // ROADSIDE
  // ============================================================

  void _roadsideDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              const Color(0xFF07152C),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(22),
          ),
          title: const Text(
            'Roadside Assistance',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Need immediate assistance with your vehicle?',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 9,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'CANCEL',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 7,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                showMessage(
                  'Roadside assistance request started.',
                );
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFFFFC857),
                foregroundColor:
                    Colors.black,
              ),
              child: const Text(
                'REQUEST HELP',
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // BUTTON
  // ============================================================

  Widget _circleButton(
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
            color:
                Colors.white.withValues(alpha: 0.07),
            borderRadius:
                BorderRadius.circular(14),
            border: Border.all(
              color:
                  Colors.white.withValues(alpha: 0.10),
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void showMessage(
    String message,
  ) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior:
              SnackBarBehavior.floating,
          margin:
              const EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
          content:
              Text(message),
        ),
      );
  }

  // ============================================================
  // ENTRANCE
  // ============================================================

  Widget _animated(
    int index,
    Widget child,
  ) {
    return AnimatedBuilder(
      animation: entranceController,
      builder: (context, child) {
        final delay = index * 0.035;

        final value =
            ((entranceController.value -
                        delay) /
                    (1 - delay))
                .clamp(0.0, 1.0);

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset:
                Offset(0, 16 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

// =================================================================
// MODELS
// =================================================================

class SupportCategory {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const SupportCategory({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class SupportArticle {
  final String title;
  final String category;
  final IconData icon;

  const SupportArticle({
    required this.title,
    required this.category,
    required this.icon,
  });
}

class ChatMessage {
  final String text;
  final bool fromUser;

  ChatMessage({
    required this.text,
    required this.fromUser,
  });
}

// =================================================================
// CHAT SCREEN
// =================================================================

class CareChatScreen extends StatefulWidget {
  final List<ChatMessage> initialMessages;

  const CareChatScreen({
    super.key,
    required this.initialMessages,
  });

  @override
  State<CareChatScreen> createState() =>
      _CareChatScreenState();
}

class _CareChatScreenState
    extends State<CareChatScreen> {
  late List<ChatMessage> messages;

  final TextEditingController controller =
      TextEditingController();

  final ScrollController scrollController =
      ScrollController();

  @override
  void initState() {
    super.initState();

    messages = List<ChatMessage>.from(
      widget.initialMessages,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void sendMessage() {
    final text =
        controller.text.trim();

    if (text.isEmpty) return;

    setState(() {
      messages.add(
        ChatMessage(
          text: text,
          fromUser: true,
        ),
      );

      controller.clear();
    });

    Future.delayed(
      const Duration(milliseconds: 700),
      () {
        if (!mounted) return;

        setState(() {
          messages.add(
            ChatMessage(
              text:
                  'Thanks for reaching out. I can help you with service, vehicle health, rewards, maintenance or roadside assistance.',
              fromUser: false,
            ),
          );
        });

        _scrollToBottom();
      },
    );

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        if (!scrollController.hasClients) {
          return;
        }

        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration:
              const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF020817),
      appBar: AppBar(
        backgroundColor:
            const Color(0xFF07152C),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Care+ Assistant',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Online',
              style: TextStyle(
                color: Color(0xFF7BFFB2),
                fontSize: 7,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding:
                  const EdgeInsets.all(18),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message =
                    messages[index];

                return Align(
                  alignment: message.fromUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    constraints:
                        const BoxConstraints(
                      maxWidth: 300,
                    ),
                    margin:
                        const EdgeInsets.only(
                      bottom: 10,
                    ),
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 11,
                    ),
                    decoration:
                        BoxDecoration(
                      color: message.fromUser
                          ? const Color(
                              0xFF147DFF,
                            )
                          : const Color(
                              0xFF10243F,
                            ),
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),
                    child: Text(
                      message.text,
                      style:
                          const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        height: 1.4,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                12,
                8,
                12,
                12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      style:
                          const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                      ),
                      onSubmitted: (_) =>
                          sendMessage(),
                      decoration:
                          InputDecoration(
                        hintText:
                            'Ask Care+...',
                        hintStyle:
                            const TextStyle(
                          color: Colors.white24,
                          fontSize: 8,
                        ),
                        filled: true,
                        fillColor:
                            const Color(
                          0xFF10243F,
                        ),
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            15,
                          ),
                          borderSide:
                              BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed:
                        sendMessage,
                    style:
                        IconButton.styleFrom(
                      backgroundColor:
                          const Color(
                        0xFF147DFF,
                      ),
                    ),
                    icon:
                        const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 17,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =================================================================
// AURORA
// =================================================================

class _SupportAuroraPainter
    extends CustomPainter {
  final double progress;

  _SupportAuroraPainter({
    required this.progress,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint();

    final t =
        progress * math.pi * 2;

    final cyanCenter = Offset(
      size.width *
          (0.18 +
              math.sin(t) * 0.12),
      size.height *
          (0.18 +
              math.cos(t) * 0.06),
    );

    paint.shader =
        RadialGradient(
      colors: [
        const Color(0xFF00E5FF)
            .withValues(alpha: 0.075),
        Colors.transparent,
      ],
    ).createShader(
      Rect.fromCircle(
        center: cyanCenter,
        radius:
            size.width * 0.65,
      ),
    );

    canvas.drawRect(
      Offset.zero & size,
      paint,
    );

    final purpleCenter = Offset(
      size.width *
          (0.82 +
              math.cos(t) * 0.10),
      size.height *
          (0.52 +
              math.sin(t) * 0.07),
    );

    paint.shader =
        RadialGradient(
      colors: [
        const Color(0xFF8C5CFF)
            .withValues(alpha: 0.065),
        Colors.transparent,
      ],
    ).createShader(
      Rect.fromCircle(
        center: purpleCenter,
        radius:
            size.width * 0.60,
      ),
    );

    canvas.drawRect(
      Offset.zero & size,
      paint,
    );

    final random =
        math.Random(42);

    final starPaint =
        Paint();

    for (int i = 0; i < 45; i++) {
      final x =
          random.nextDouble() *
              size.width;

      final y =
          random.nextDouble() *
              size.height;

      final opacity =
          0.15 +
          ((math.sin(t + i) + 1) /
                  2) *
              0.4;

      starPaint.color =
          Colors.white.withValues(
        alpha: opacity,
      );

      canvas.drawCircle(
        Offset(x, y),
        0.65,
        starPaint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant
        _SupportAuroraPainter
            oldDelegate,
  ) {
    return oldDelegate.progress !=
        progress;
  }
}