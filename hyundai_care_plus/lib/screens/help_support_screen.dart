import 'package:flutter/material.dart';

import '../widgets/care_background.dart';

class HelpSupportScreen extends StatefulWidget {
  final int? customerId;

  const HelpSupportScreen({
    super.key,
    this.customerId,
  });

  @override
  State<HelpSupportScreen> createState() =>
      _HelpSupportScreenState();
}

class _HelpSupportScreenState
    extends State<HelpSupportScreen> {
  final TextEditingController searchController =
      TextEditingController();

  String selectedCategory = 'All';

  final List<String> categories = const [
    'All',
    'Service',
    'Payment',
    'Vehicle',
    'Account',
  ];

  final List<SupportArticle> articles = const [
    SupportArticle(
      question: 'How do I book a service?',
      answer:
          'Open Service Booking, select your vehicle, choose a service centre, select an available date and time, and confirm your booking.',
      category: 'Service',
    ),
    SupportArticle(
      question: 'How can I track my service?',
      answer:
          'You can view your current service status from the Service Booking and Notifications sections.',
      category: 'Service',
    ),
    SupportArticle(
      question: 'How do I make an online payment?',
      answer:
          'Open Payments and select Google Pay, UPI, Credit/Debit Card, Net Banking or Wallet.',
      category: 'Payment',
    ),
    SupportArticle(
      question: 'How do I add my vehicle?',
      answer:
          'Open your vehicle profile and use the Add Vehicle option to enter your vehicle information.',
      category: 'Vehicle',
    ),
    SupportArticle(
      question: 'How do I update my profile?',
      answer:
          'Open Profile, select Edit Profile and update your available personal information.',
      category: 'Account',
    ),
    SupportArticle(
      question: 'How do I use roadside assistance?',
      answer:
          'Open Roadside Assistance and select the appropriate emergency service. Location sharing can be enabled so assistance can find you.',
      category: 'Vehicle',
    ),
  ];

  final List<SupportTicket> tickets = const [
    SupportTicket(
      id: '#HCP-10482',
      subject: 'Service booking enquiry',
      date: '22 Aug 2026',
      status: 'RESOLVED',
    ),
    SupportTicket(
      id: '#HCP-09871',
      subject: 'Payment receipt request',
      date: '14 Jul 2026',
      status: 'RESOLVED',
    ),
  ];

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<SupportArticle> get filteredArticles {
    final query =
        searchController.text.trim().toLowerCase();

    return articles.where((article) {
      final matchesCategory =
          selectedCategory == 'All' ||
              article.category ==
                  selectedCategory;

      final matchesSearch =
          query.isEmpty ||
              article.question
                  .toLowerCase()
                  .contains(query) ||
              article.answer
                  .toLowerCase()
                  .contains(query);

      return matchesCategory &&
          matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020817),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const CareBackground(
            child: SizedBox.expand(),
          ),
          SafeArea(
            child: CustomScrollView(
              physics:
                  const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _header(),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    0,
                    20,
                    35,
                  ),
                  sliver: SliverList(
                    delegate:
                        SliverChildListDelegate(
                      [
                        _supportHero(),
                        const SizedBox(height: 16),
                        _searchBox(),
                        const SizedBox(height: 13),
                        _categorySelector(),
                        const SizedBox(height: 20),
                        _quickActions(),
                        const SizedBox(height: 22),
                        _faqHeader(),
                        const SizedBox(height: 11),
                        ...filteredArticles.map(
                          (article) => Padding(
                            padding:
                                const EdgeInsets.only(
                              bottom: 8,
                            ),
                            child:
                                _faqCard(article),
                          ),
                        ),
                        if (filteredArticles.isEmpty)
                          _emptySearch(),
                        const SizedBox(height: 21),
                        _ticketHeader(),
                        const SizedBox(height: 10),
                        ...tickets.map(
                          (ticket) => Padding(
                            padding:
                                const EdgeInsets.only(
                              bottom: 8,
                            ),
                            child:
                                _ticketCard(ticket),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _contactSupportCard(),
                      ],
                    ),
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
  // HEADER
  // ============================================================

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        12,
        18,
        22,
      ),
      child: Row(
        children: [
          _iconButton(
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
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'We are here whenever you need us',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 8.5,
                  ),
                ),
              ],
            ),
          ),
          _iconButton(
            Icons.support_agent_rounded,
            _startChat,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HERO
  // ============================================================

  Widget _supportHero() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF102F52),
            Color(0xFF171E4B),
          ],
        ),
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFF70E8FF)
              .withValues(alpha: 0.10),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF70E8FF)
                  .withValues(alpha: 0.07),
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: Color(0xFF70E8FF),
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'How can we help?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Search our help centre or contact the Care+ support team.',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 6.5,
                    height: 1.4,
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

  Widget _searchBox() {
    return Container(
      height: 51,
      decoration: BoxDecoration(
        color:
            Colors.white.withValues(alpha: 0.045),
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color:
              Colors.white.withValues(alpha: 0.07),
        ),
      ),
      child: TextField(
        controller: searchController,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF70E8FF),
            size: 20,
          ),
          hintText:
              'Search your question...',
          hintStyle: const TextStyle(
            color: Colors.white24,
            fontSize: 7,
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
  // CATEGORY
  // ============================================================

  Widget _categorySelector() {
    return SizedBox(
      height: 35,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder:
            (_, __) => const SizedBox(
          width: 7,
        ),
        itemBuilder: (context, index) {
          final category =
              categories[index];

          final selected =
              selectedCategory == category;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory =
                    category;
              });
            },
            child: AnimatedContainer(
              duration:
                  const Duration(
                milliseconds: 180,
              ),
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 13,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF70E8FF)
                        .withValues(
                        alpha: 0.08,
                      )
                    : Colors.white.withValues(
                        alpha: 0.035,
                      ),
                borderRadius:
                    BorderRadius.circular(10),
                border: Border.all(
                  color: selected
                      ? const Color(
                          0xFF70E8FF,
                        ).withValues(
                          alpha: 0.18,
                        )
                      : Colors.white.withValues(
                          alpha: 0.05,
                        ),
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: selected
                      ? const Color(
                          0xFF70E8FF,
                        )
                      : Colors.white38,
                  fontSize: 6,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // QUICK ACTIONS
  // ============================================================

  Widget _quickActions() {
    return Row(
      children: [
        Expanded(
          child: _quickAction(
            icon: Icons.chat_bubble_rounded,
            title: 'Live Chat',
            subtitle: 'Talk to support',
            color:
                const Color(0xFF70E8FF),
            onTap: _startChat,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _quickAction(
            icon: Icons.call_rounded,
            title: 'Call Us',
            subtitle: 'Speak to an agent',
            color:
                const Color(0xFF7BFFB2),
            onTap: _callSupport,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _quickAction(
            icon: Icons.mail_rounded,
            title: 'Email',
            subtitle: 'Send an enquiry',
            color:
                const Color(0xFFB28CFF),
            onTap: _emailSupport,
          ),
        ),
      ],
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(11),
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
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(10),
                color:
                    color.withValues(alpha: 0.07),
              ),
              child: Icon(
                icon,
                color: color,
                size: 17,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 7,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white24,
                fontSize: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // FAQ
  // ============================================================

  Widget _faqHeader() {
    return Row(
      children: [
        const Icon(
          Icons.help_center_rounded,
          color: Color(0xFF70E8FF),
          size: 18,
        ),
        const SizedBox(width: 8),
        const Text(
          'Frequently Asked Questions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Text(
          '${filteredArticles.length} results',
          style: const TextStyle(
            color: Colors.white24,
            fontSize: 5.5,
          ),
        ),
      ],
    );
  }

  Widget _faqCard(
    SupportArticle article,
  ) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: Container(
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
        child: ExpansionTile(
          tilePadding:
              const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 1,
          ),
          childrenPadding:
              const EdgeInsets.fromLTRB(
            14,
            0,
            14,
            14,
          ),
          iconColor:
              const Color(0xFF70E8FF),
          collapsedIconColor:
              Colors.white30,
          leading: Container(
            width: 31,
            height: 31,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(9),
              color: const Color(0xFF70E8FF)
                  .withValues(alpha: 0.05),
            ),
            child: const Icon(
              Icons.question_mark_rounded,
              color: Color(0xFF70E8FF),
              size: 15,
            ),
          ),
          title: Text(
            article.question,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 7.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            article.category,
            style: const TextStyle(
              color: Colors.white24,
              fontSize: 5,
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                article.answer,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 6.5,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 11),
            GestureDetector(
              onTap: _startChat,
              child: const Row(
                children: [
                  Icon(
                    Icons.chat_rounded,
                    color: Color(0xFF70E8FF),
                    size: 13,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Still need help? Chat with us',
                    style: TextStyle(
                      color: Color(0xFF70E8FF),
                      fontSize: 6,
                      fontWeight: FontWeight.bold,
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
  // EMPTY SEARCH
  // ============================================================

  Widget _emptySearch() {
    return Container(
      padding: const EdgeInsets.all(25),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color:
            Colors.white.withValues(alpha: 0.025),
        borderRadius:
            BorderRadius.circular(17),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            color: Colors.white24,
            size: 30,
          ),
          SizedBox(height: 9),
          Text(
            'No matching articles',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 8,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Try another search or contact support.',
            style: TextStyle(
              color: Colors.white24,
              fontSize: 6,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TICKETS
  // ============================================================

  Widget _ticketHeader() {
    return Row(
      children: [
        const Icon(
          Icons.confirmation_number_rounded,
          color: Color(0xFFB28CFF),
          size: 18,
        ),
        const SizedBox(width: 8),
        const Text(
          'Support Requests',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: _createTicket,
          child: const Text(
            '+ NEW',
            style: TextStyle(
              color: Color(0xFF70E8FF),
              fontSize: 6,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _ticketCard(
    SupportTicket ticket,
  ) {
    return GestureDetector(
      onTap: () => _showTicket(ticket),
      child: Container(
        padding: const EdgeInsets.all(13),
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
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(11),
                color: const Color(0xFFB28CFF)
                    .withValues(alpha: 0.06),
              ),
              child: const Icon(
                Icons.confirmation_number_rounded,
                color: Color(0xFFB28CFF),
                size: 19,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.subject,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 7.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${ticket.id} • ${ticket.date}',
                    style: const TextStyle(
                      color: Colors.white24,
                      fontSize: 5.5,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF7BFFB2)
                    .withValues(alpha: 0.06),
                borderRadius:
                    BorderRadius.circular(7),
              ),
              child: Text(
                ticket.status,
                style: const TextStyle(
                  color: Color(0xFF7BFFB2),
                  fontSize: 4.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CONTACT
  // ============================================================

  Widget _contactSupportCard() {
    return GestureDetector(
      onTap: _createTicket,
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: const Color(0xFF70E8FF)
              .withValues(alpha: 0.025),
          borderRadius:
              BorderRadius.circular(19),
          border: Border.all(
            color: const Color(0xFF70E8FF)
                .withValues(alpha: 0.08),
          ),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.headset_mic_rounded,
              color: Color(0xFF70E8FF),
              size: 23,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Couldn’t find what you need?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Create a support request and our team will help you.',
                    style: TextStyle(
                      color: Colors.white30,
                      fontSize: 6,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF70E8FF),
              size: 12,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CHAT
  // ============================================================

  void _startChat() {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          const Color(0xFF07152C),
      isScrollControlled: true,
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
              20,
              18,
              20,
              25,
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration:
                      BoxDecoration(
                    color: Colors.white24,
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF70E8FF),
                  ),
                  child: const Icon(
                    Icons.support_agent_rounded,
                    color: Color(0xFF07152C),
                    size: 27,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Care+ Support Chat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'A support agent will be available shortly.',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 7,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding:
                      const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withValues(
                      alpha: 0.035,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: Color(0xFF7BFFB2),
                        size: 7,
                      ),
                      SizedBox(width: 7),
                      Text(
                        'Support team online',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 7,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 13),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showMessage(
                        'Support chat started.',
                      );
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
                          const Size(0, 46),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),
                    ),
                    child: const Text(
                      'START CHAT',
                      style: TextStyle(
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

  // ============================================================
  // CALL
  // ============================================================

  void _callSupport() {
    showMessage(
      'Calling Care+ support...',
    );
  }

  // ============================================================
  // EMAIL
  // ============================================================

  void _emailSupport() {
    showMessage(
      'Opening support email...',
    );
  }

  // ============================================================
  // NEW TICKET
  // ============================================================

  void _createTicket() {
    final subjectController =
        TextEditingController();

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
            'New Support Request',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: subjectController,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
            ),
            maxLines: 3,
            decoration: InputDecoration(
              hintText:
                  'Describe your issue...',
              hintStyle: const TextStyle(
                color: Colors.white24,
                fontSize: 7,
              ),
              filled: true,
              fillColor:
                  Colors.white.withValues(
                alpha: 0.04,
              ),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(13),
                borderSide: BorderSide.none,
              ),
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
                  fontSize: 6,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (subjectController
                    .text
                    .trim()
                    .isEmpty) {
                  showMessage(
                    'Please describe your issue.',
                  );
                  return;
                }

                Navigator.pop(context);

                showMessage(
                  'Support request created successfully.',
                );
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF147DFF),
                foregroundColor:
                    Colors.white,
              ),
              child: const Text(
                'SUBMIT',
                style: TextStyle(
                  fontSize: 6,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // TICKET DETAILS
  // ============================================================

  void _showTicket(
    SupportTicket ticket,
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
              28,
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
                const SizedBox(height: 20),
                const Text(
                  'Support Request',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 17),
                _ticketRow(
                  'Request ID',
                  ticket.id,
                ),
                _ticketRow(
                  'Subject',
                  ticket.subject,
                ),
                _ticketRow(
                  'Created',
                  ticket.date,
                ),
                _ticketRow(
                  'Status',
                  ticket.status,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _startChat();
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
                          const Size(0, 45),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),
                    ),
                    child: const Text(
                      'CONTACT SUPPORT',
                      style: TextStyle(
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

  Widget _ticketRow(
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 11),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white30,
              fontSize: 7,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 7,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUTTON
  // ============================================================

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
          content: Text(message),
        ),
      );
  }
}

// =================================================================
// MODELS
// =================================================================

class SupportArticle {
  final String question;
  final String answer;
  final String category;

  const SupportArticle({
    required this.question,
    required this.answer,
    required this.category,
  });
}

class SupportTicket {
  final String id;
  final String subject;
  final String date;
  final String status;

  const SupportTicket({
    required this.id,
    required this.subject,
    required this.date,
    required this.status,
  });
}