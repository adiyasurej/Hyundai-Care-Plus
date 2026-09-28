import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/care_background.dart';

class RewardsScreen extends StatefulWidget {
  final int customerId;

  const RewardsScreen({
    super.key,
    required this.customerId,
  });

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen>
    with SingleTickerProviderStateMixin {
  static const Color navy = Color(0xFF020817);
  static const Color card = Color(0xFF08162D);
  static const Color card2 = Color(0xFF10233F);
  static const Color cyan = Color(0xFF70E8FF);
  static const Color blue = Color(0xFF287BFF);
  static const Color purple = Color(0xFF8B6CFF);
  static const Color green = Color(0xFF62E6A7);
  static const Color yellow = Color(0xFFFFC857);
  static const Color red = Color(0xFFFF647C);

  late final AnimationController _giftController;
  late final Animation<double> _giftScale;

  int _points = 2450;
  int _selectedTab = 0;

  final List<_Reward> _rewards = const [
    _Reward(
      title: '10% OFF Periodic Service',
      subtitle: 'Save on your next scheduled service.',
      code: 'CARE10',
      expiry: '30 Sep 2026',
      points: 800,
      icon: Icons.build_circle_rounded,
      accent: cyan,
    ),
    _Reward(
      title: 'Complimentary Car Wash',
      subtitle: 'One complimentary exterior car wash.',
      code: 'WASH500',
      expiry: '15 Oct 2026',
      points: 500,
      icon: Icons.local_car_wash_rounded,
      accent: green,
    ),
    _Reward(
      title: '₹500 Service Discount',
      subtitle: 'Flat ₹500 off on eligible services.',
      code: 'CARE500',
      expiry: '30 Nov 2026',
      points: 1200,
      icon: Icons.discount_rounded,
      accent: purple,
    ),
  ];

  final List<_RewardHistory> _history = [
    const _RewardHistory(
      title: 'Service booking bonus',
      points: 250,
      date: '24 Aug 2026',
      earned: true,
    ),
    const _RewardHistory(
      title: 'Care+ membership bonus',
      points: 500,
      date: '18 Aug 2026',
      earned: true,
    ),
    const _RewardHistory(
      title: 'Feedback reward',
      points: 100,
      date: '12 Aug 2026',
      earned: true,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _giftController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _giftScale = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(
      CurvedAnimation(
        parent: _giftController,
        curve: Curves.easeInOut,
      ),
    );

    _giftController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _giftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      body: Stack(
        children: [
          const Positioned.fill(
            child: CareBackground(
              child: SizedBox.expand(),
            ),
          ),
          SafeArea(
            child: _buildPage(),
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
            18,
            0,
            18,
            35,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildPointsCard(),
                const SizedBox(height: 18),
                _buildGiftCard(),
                const SizedBox(height: 24),
                _buildTabs(),
                const SizedBox(height: 17),
                if (_selectedTab == 0) ...[
                  _buildCouponsSection(),
                  const SizedBox(height: 24),
                  _buildOffersSection(),
                ] else if (_selectedTab == 1) ...[
                  _buildCouponsSection(),
                ] else ...[
                  _buildHistorySection(),
                ],
                const SizedBox(height: 24),
                _buildEarnPointsSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        12,
        18,
        22,
      ),
      child: Row(
        children: [
          _circleButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () {
              Navigator.of(context).maybePop();
            },
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rewards',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Earn points. Unlock benefits.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          _circleButton(
            icon: Icons.history_rounded,
            onTap: _showRewardHistory,
          ),
        ],
      ),
    );
  }

  Widget _buildPointsCard() {
    final progress =
        (_points / 5000).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF102F58),
            Color(0xFF17245A),
            Color(0xFF241548),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: cyan.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: cyan.withValues(alpha: 0.09),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.stars_rounded,
                  color: cyan,
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AVAILABLE POINTS',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      '2,450',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              _membershipBadge(),
            ],
          ),
          const SizedBox(height: 19),
          Row(
            children: [
              const Text(
                'Gold Member',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${5000 - _points} pts to Platinum',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 6.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: Colors.white10,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(
                cyan,
              ),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            'Earn more points through services, bookings and feedback.',
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 6.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _membershipBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: yellow.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: yellow.withValues(alpha: 0.22),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.workspace_premium_rounded,
            color: yellow,
            size: 14,
          ),
          SizedBox(width: 5),
          Text(
            'GOLD',
            style: TextStyle(
              color: yellow,
              fontSize: 6.5,
              fontWeight: FontWeight.bold,
              letterSpacing: .8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGiftCard() {
    return GestureDetector(
      onTap: _openGift,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
          18,
          22,
          18,
          21,
        ),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: purple.withValues(alpha: 0.16),
          ),
          boxShadow: [
            BoxShadow(
              color: purple.withValues(alpha: 0.06),
              blurRadius: 25,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              'EXCLUSIVE CARE+ SURPRISE',
              style: TextStyle(
                color: cyan,
                fontSize: 7,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'You have a gift waiting',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 17),
            ScaleTransition(
              scale: _giftScale,
              child: Container(
                width: 106,
                height: 106,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF714CFF),
                      Color(0xFF08CFE8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(29),
                  boxShadow: [
                    BoxShadow(
                      color: cyan.withValues(alpha: 0.23),
                      blurRadius: 32,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.card_giftcard_rounded,
                  color: Colors.white,
                  size: 55,
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.touch_app_rounded,
                  color: Colors.white54,
                  size: 14,
                ),
                SizedBox(width: 5),
                Text(
                  'Tap to reveal your reward',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 7.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    const tabs = [
      'For You',
      'My Coupons',
      'History',
    ];

    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: List.generate(
          tabs.length,
          (index) {
            final selected =
                _selectedTab == index;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTab = index;
                  });
                },
                child: AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    color: selected
                        ? cyan.withValues(alpha: 0.10)
                        : Colors.transparent,
                    borderRadius:
                        BorderRadius.circular(11),
                    border: selected
                        ? Border.all(
                            color:
                                cyan.withValues(alpha: 0.14),
                          )
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      color: selected
                          ? cyan
                          : Colors.white38,
                      fontSize: 7,
                      fontWeight: selected
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCouponsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          icon: Icons.confirmation_number_rounded,
          title: 'My Coupons',
          subtitle: 'Redeem your Care+ points',
        ),
        const SizedBox(height: 13),
        ..._rewards.map(
          (reward) => Padding(
            padding: const EdgeInsets.only(
              bottom: 11,
            ),
            child: _rewardCard(reward),
          ),
        ),
      ],
    );
  }

  Widget _rewardCard(_Reward reward) {
    final canRedeem =
        _points >= reward.points;

    return GestureDetector(
      onTap: () {
        if (canRedeem) {
          _redeem(reward);
        } else {
          _message(
            'You need ${reward.points - _points} more points.',
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.065),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: reward.accent.withValues(
                  alpha: 0.07,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                reward.icon,
                color: reward.accent,
                size: 25,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    reward.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reward.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 6.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Valid till ${reward.expiry}',
                    style: const TextStyle(
                      color: Colors.white30,
                      fontSize: 5.8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 7),
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: [
                Text(
                  '${reward.points} pts',
                  style: TextStyle(
                    color: reward.accent,
                    fontSize: 7.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: canRedeem
                        ? reward.accent
                            .withValues(alpha: 0.10)
                        : Colors.white
                            .withValues(alpha: 0.04),
                    borderRadius:
                        BorderRadius.circular(9),
                    border: Border.all(
                      color: canRedeem
                          ? reward.accent
                              .withValues(alpha: 0.18)
                          : Colors.white
                              .withValues(alpha: 0.06),
                    ),
                  ),
                  child: Text(
                    canRedeem
                        ? 'REDEEM'
                        : 'LOCKED',
                    style: TextStyle(
                      color: canRedeem
                          ? reward.accent
                          : Colors.white24,
                      fontSize: 5.5,
                      fontWeight: FontWeight.bold,
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

  Widget _buildOffersSection() {
    final offers = const [
      _Offer(
        title: 'Gold Member Service',
        subtitle:
            'Priority benefits on selected Hyundai services.',
        badge: 'GOLD',
        icon: Icons.workspace_premium_rounded,
        color: yellow,
      ),
      _Offer(
        title: 'Complimentary Health Check',
        subtitle:
            'Basic vehicle health inspection at selected centres.',
        badge: 'POPULAR',
        icon: Icons.health_and_safety_rounded,
        color: green,
      ),
      _Offer(
        title: 'Accessories Savings',
        subtitle:
            'Special pricing on selected genuine accessories.',
        badge: 'NEW',
        icon: Icons.shopping_bag_rounded,
        color: purple,
      ),
    ];

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          icon: Icons.local_offer_rounded,
          title: 'Exclusive Offers',
          subtitle: 'Benefits selected for you',
        ),
        const SizedBox(height: 13),
        SizedBox(
          height: 168,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics:
                const BouncingScrollPhysics(),
            itemCount: offers.length,
            separatorBuilder: (
              context,
              index,
            ) =>
                const SizedBox(width: 11),
            itemBuilder: (
              context,
              index,
            ) {
              return _offerCard(offers[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _offerCard(_Offer offer) {
    return GestureDetector(
      onTap: () {
        _showOffer(offer);
      },
      child: Container(
        width: 235,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF101F3D),
              Color(0xFF18183B),
            ],
          ),
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: offer.color.withValues(
              alpha: 0.11,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 39,
                  height: 39,
                  decoration: BoxDecoration(
                    color: offer.color.withValues(
                      alpha: 0.07,
                    ),
                    borderRadius:
                        BorderRadius.circular(11),
                  ),
                  child: Icon(
                    offer.icon,
                    color: offer.color,
                    size: 19,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: offer.color.withValues(
                      alpha: 0.07,
                    ),
                    borderRadius:
                        BorderRadius.circular(7),
                  ),
                  child: Text(
                    offer.badge,
                    style: TextStyle(
                      color: offer.color,
                      fontSize: 5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              offer.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              offer.subtitle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 6.5,
                height: 1.35,
              ),
            ),
            const Spacer(),
            const Row(
              children: [
                Text(
                  'VIEW BENEFIT',
                  style: TextStyle(
                    color: cyan,
                    fontSize: 5.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: cyan,
                  size: 12,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          icon: Icons.history_rounded,
          title: 'Points History',
          subtitle: 'Your recent Care+ activity',
        ),
        const SizedBox(height: 13),
        ..._history.map(
          (item) => Container(
            margin: const EdgeInsets.only(
              bottom: 10,
            ),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: card,
              borderRadius:
                  BorderRadius.circular(17),
              border: Border.all(
                color: Colors.white.withValues(
                  alpha: 0.055,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: (item.earned
                            ? green
                            : red)
                        .withValues(alpha: 0.07),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.earned
                        ? Icons.add_rounded
                        : Icons.remove_rounded,
                    color: item.earned
                        ? green
                        : red,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8.5,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.date,
                        style: const TextStyle(
                          color: Colors.white30,
                          fontSize: 6.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${item.earned ? '+' : '-'}${item.points}',
                  style: TextStyle(
                    color: item.earned
                        ? green
                        : red,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEarnPointsSection() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: cyan.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            icon: Icons.add_circle_outline_rounded,
            title: 'Earn More Points',
            subtitle:
                'More ways to unlock rewards',
          ),
          const SizedBox(height: 12),
          _earnRow(
            Icons.build_circle_rounded,
            'Complete a service',
            '+500 pts',
          ),
          _divider(),
          _earnRow(
            Icons.calendar_month_rounded,
            'Book your next service',
            '+250 pts',
          ),
          _divider(),
          _earnRow(
            Icons.rate_review_rounded,
            'Share your feedback',
            '+100 pts',
          ),
          _divider(),
          _earnRow(
            Icons.person_add_alt_1_rounded,
            'Refer a Hyundai owner',
            '+300 pts',
          ),
        ],
      ),
    );
  }

  Widget _earnRow(
    IconData icon,
    String title,
    String points,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 9,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: cyan,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 7.5,
              ),
            ),
          ),
          Text(
            points,
            style: const TextStyle(
              color: cyan,
              fontSize: 7,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      color: Colors.white.withValues(
        alpha: 0.06,
      ),
    );
  }

  Widget _sectionTitle({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: cyan.withValues(alpha: 0.07),
            borderRadius:
                BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            color: cyan,
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 6.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
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
            color: Colors.white.withValues(
              alpha: 0.07,
            ),
            borderRadius:
                BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: 0.10,
              ),
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

  void _openGift() {
    _giftController.stop();

    showDialog<void>(
      context: context,
      barrierColor:
          Colors.black.withValues(alpha: 0.75),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding:
              const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: card,
              borderRadius:
                  BorderRadius.circular(27),
              border: Border.all(
                color: cyan.withValues(
                  alpha: 0.18,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: cyan.withValues(
                    alpha: 0.08,
                  ),
                  blurRadius: 35,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    gradient:
                        const LinearGradient(
                      colors: [
                        Color(0xFF714CFF),
                        Color(0xFF08CFE8),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.card_giftcard_rounded,
                    color: Colors.white,
                    size: 41,
                  ),
                ),
                const SizedBox(height: 17),
                const Text(
                  'YOU UNLOCKED A GIFT',
                  style: TextStyle(
                    color: cyan,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  '₹250 OFF',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Enjoy ₹250 off your next eligible Hyundai service.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 8,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 17),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cyan.withValues(
                      alpha: 0.055,
                    ),
                    borderRadius:
                        BorderRadius.circular(14),
                    border: Border.all(
                      color: cyan.withValues(
                        alpha: 0.14,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'COUPON CODE',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 5.5,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'LUCKY250',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Copy coupon',
                        onPressed: () {
                          Clipboard.setData(
                            const ClipboardData(
                              text: 'LUCKY250',
                            ),
                          );
                          _message(
                            'Coupon code copied.',
                          );
                        },
                        icon: const Icon(
                          Icons.copy_rounded,
                          color: cyan,
                          size: 19,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 17),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(
                        dialogContext,
                      ).pop();

                      _message(
                        'Reward added to My Coupons.',
                      );
                    },
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor: cyan,
                      foregroundColor: navy,
                      elevation: 0,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(13),
                      ),
                    ),
                    child: const Text(
                      'CLAIM REWARD',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        letterSpacing: .6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      if (mounted) {
        _giftController.repeat(reverse: true);
      }
    });
  }

  void _redeem(_Reward reward) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: card,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(22),
          ),
          title: const Text(
            'Redeem Reward?',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Use ${reward.points} points for ${reward.title}?',
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 9,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop();
              },
              child: const Text(
                'CANCEL',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 8,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _points -= reward.points;

                  _history.insert(
                    0,
                    _RewardHistory(
                      title: reward.title,
                      points: reward.points,
                      date: 'Today',
                      earned: false,
                    ),
                  );
                });

                Navigator.of(
                  dialogContext,
                ).pop();

                _showRedeemedCode(reward);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: cyan,
                foregroundColor: navy,
              ),
              child: const Text(
                'REDEEM',
                style: TextStyle(
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

  void _showRedeemedCode(_Reward reward) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: card,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(22),
          ),
          title: const Text(
            'Reward Ready 🎉',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                reward.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 8,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cyan.withValues(
                    alpha: 0.055,
                  ),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Text(
                      reward.code,
                      style: const TextStyle(
                        color: cyan,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Valid till ${reward.expiry}',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 6.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(
                      text: reward.code,
                    ),
                  );

                  _message(
                    'Coupon code copied.',
                  );
                },
                icon: const Icon(
                  Icons.copy_rounded,
                  color: cyan,
                  size: 15,
                ),
                label: const Text(
                  'COPY CODE',
                  style: TextStyle(
                    color: cyan,
                    fontSize: 7,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop();
              },
              child: const Text(
                'DONE',
                style: TextStyle(
                  color: cyan,
                  fontSize: 8,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showOffer(_Offer offer) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: card,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(27),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              22,
              18,
              22,
              28,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 21),
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: offer.color.withValues(
                      alpha: 0.08,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    offer.icon,
                    color: offer.color,
                    size: 27,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  offer.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  offer.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 8,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 19),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(
                        sheetContext,
                      ).pop();

                      _message(
                        'Offer saved to your Care+ benefits.',
                      );
                    },
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor: cyan,
                      foregroundColor: navy,
                      elevation: 0,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(13),
                      ),
                    ),
                    child: const Text(
                      'SAVE OFFER',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
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

  void _showRewardHistory() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: card,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(27),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              28,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Reward History',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                ..._history.take(4).map(
                  (item) => Padding(
                    padding:
                        const EdgeInsets.only(
                      bottom: 9,
                    ),
                    child: _historyRow(item),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(
                        sheetContext,
                      ).pop();

                      setState(() {
                        _selectedTab = 2;
                      });
                    },
                    child: const Text(
                      'VIEW FULL HISTORY',
                      style: TextStyle(
                        color: cyan,
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
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

  Widget _historyRow(
    _RewardHistory item,
  ) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.035,
        ),
        borderRadius:
            BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Icon(
            item.earned
                ? Icons.add_circle_rounded
                : Icons.remove_circle_rounded,
            color:
                item.earned ? green : red,
            size: 18,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 7.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.date,
                  style: const TextStyle(
                    color: Colors.white30,
                    fontSize: 5.8,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${item.earned ? '+' : '-'}${item.points}',
            style: TextStyle(
              color:
                  item.earned ? green : red,
              fontSize: 7.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
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
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(13),
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 8,
            ),
          ),
        ),
      );
  }
}

class _Reward {
  final String title;
  final String subtitle;
  final String code;
  final String expiry;
  final int points;
  final IconData icon;
  final Color accent;

  const _Reward({
    required this.title,
    required this.subtitle,
    required this.code,
    required this.expiry,
    required this.points,
    required this.icon,
    required this.accent,
  });
}

class _RewardHistory {
  final String title;
  final int points;
  final String date;
  final bool earned;

  const _RewardHistory({
    required this.title,
    required this.points,
    required this.date,
    required this.earned,
  });
}

class _Offer {
  final String title;
  final String subtitle;
  final String badge;
  final IconData icon;
  final Color color;

  const _Offer({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.icon,
    required this.color,
  });
}