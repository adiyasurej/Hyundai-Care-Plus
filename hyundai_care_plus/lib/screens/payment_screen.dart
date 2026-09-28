import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final int customerId;

  const PaymentScreen({
    super.key,
    required this.customerId,
  });

  @override
  State<PaymentScreen> createState() =>
      _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController amountController =
      TextEditingController();

  String selectedMethod = 'UPI';
  bool processing = false;

  final List<PaymentRecord> paymentHistory = [
    PaymentRecord(
      title: 'Service Payment',
      amount: 2850,
      date: '22 Aug 2026',
      status: 'Paid',
      icon: Icons.build_circle_rounded,
    ),
    PaymentRecord(
      title: 'Insurance Renewal',
      amount: 4200,
      date: '12 Jul 2026',
      status: 'Paid',
      icon: Icons.shield_rounded,
    ),
    PaymentRecord(
      title: 'Service Booking',
      amount: 1500,
      date: '28 Jun 2026',
      status: 'Paid',
      icon: Icons.calendar_month_rounded,
    ),
  ];

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020817),
      body: SafeArea(
        child: CustomScrollView(
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
                30,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _buildBalanceCard(),
                    const SizedBox(height: 16),
                    _buildPaymentForm(),
                    const SizedBox(height: 18),
                    _buildMethods(),
                    const SizedBox(height: 22),
                    _buildHistoryHeader(),
                    const SizedBox(height: 10),
                    ...paymentHistory.map(
                      _buildPaymentHistoryCard,
                    ),
                  ],
                ),
              ),
            ),
          ],
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
            () => Navigator.pop(context),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Payments',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Manage your Hyundai Care+ payments',
                  style: TextStyle(
                    color: Color(0x73FFFFFF),
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          _iconButton(
            Icons.receipt_long_rounded,
            _showReceipts,
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF123E62),
            Color(0xFF17295A),
            Color(0xFF083B43),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF70E8FF)
              .withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.account_balance_wallet_rounded,
                color: Color(0xFF70E8FF),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Payment Overview',
                style: TextStyle(
                  color: Color(0xB3FFFFFF),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '₹0.00',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'No outstanding payments',
            style: TextStyle(
              color: Color(0xFF7BFFB2),
              fontSize: 8,
            ),
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              _overviewItem(
                'Customer ID',
                '#${widget.customerId}',
              ),
              const Spacer(),
              _overviewItem(
                'Status',
                'Active',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _overviewItem(
    String title,
    String value,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white30,
            fontSize: 6.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentForm() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.07),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Make a Payment',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Enter the amount you want to pay.',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 7.5,
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: amountController,
            keyboardType:
                const TextInputType.numberWithOptions(
              decimal: true,
            ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
            decoration: InputDecoration(
              prefixText: '₹ ',
              prefixStyle: const TextStyle(
                color: Color(0xFF70E8FF),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              hintText: 'Enter amount',
              hintStyle: const TextStyle(
                color: Colors.white24,
                fontSize: 9,
              ),
              filled: true,
              fillColor: Colors.white.withValues(
                alpha: 0.035,
              ),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Colors.white.withValues(
                    alpha: 0.06,
                  ),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFF70E8FF),
                ),
              ),
            ),
          ),
          const SizedBox(height: 13),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed:
                  processing ? null : _processPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF147DFF),
                disabledBackgroundColor:
                    Colors.white12,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
              child: processing
                  ? const SizedBox(
                      width: 19,
                      height: 19,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'CONTINUE TO PAYMENT',
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: .4,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethods() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _methodCard(
                'UPI',
                Icons.qr_code_2_rounded,
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: _methodCard(
                'Card',
                Icons.credit_card_rounded,
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: _methodCard(
                'Net Banking',
                Icons.account_balance_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _methodCard(
    String title,
    IconData icon,
  ) {
    final bool selected =
        selectedMethod == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = title;
        });
      },
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 180),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 7,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF70E8FF)
                  .withValues(alpha: 0.07)
              : Colors.white
                  .withValues(alpha: 0.025),
          borderRadius:
              BorderRadius.circular(15),
          border: Border.all(
            color: selected
                ? const Color(0xFF70E8FF)
                    .withValues(alpha: 0.45)
                : Colors.white
                    .withValues(alpha: 0.06),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: selected
                  ? const Color(0xFF70E8FF)
                  : Colors.white38,
              size: 21,
            ),
            const SizedBox(height: 7),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : Colors.white54,
                fontSize: 6.5,
                fontWeight: selected
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryHeader() {
    return Row(
      children: [
        const Text(
          'Payment History',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Text(
          '${paymentHistory.length} transactions',
          style: const TextStyle(
            color: Colors.white30,
            fontSize: 7,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentHistoryCard(
    PaymentRecord payment,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 9),
      child: Container(
        padding: const EdgeInsets.all(14),
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
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(13),
                color:
                    const Color(0xFF70E8FF)
                        .withValues(alpha: 0.055),
              ),
              child: Icon(
                payment.icon,
                color:
                    const Color(0xFF70E8FF),
                size: 19,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    payment.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    payment.date,
                    style: const TextStyle(
                      color: Colors.white30,
                      fontSize: 6.5,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${payment.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color:
                        const Color(0xFF7BFFB2)
                            .withValues(alpha: 0.07),
                    borderRadius:
                        BorderRadius.circular(6),
                  ),
                  child: Text(
                    payment.status,
                    style: const TextStyle(
                      color:
                          Color(0xFF7BFFB2),
                      fontSize: 5.5,
                      fontWeight:
                          FontWeight.bold,
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

  Future<void> _processPayment() async {
    final String raw =
        amountController.text.trim();

    if (raw.isEmpty) {
      _message(
        'Please enter a payment amount.',
      );
      return;
    }

    final double? amount =
        double.tryParse(raw);

    if (amount == null || amount <= 0) {
      _message(
        'Please enter a valid amount.',
      );
      return;
    }

    if (amount > 1000000) {
      _message(
        'Please enter an amount below ₹10,00,000.',
      );
      return;
    }

    setState(() {
      processing = true;
    });

    await Future<void>.delayed(
      const Duration(milliseconds: 900),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      processing = false;
    });

    _showPaymentConfirmation(amount);
  }

  void _showPaymentConfirmation(
    double amount,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              const Color(0xFF07152C),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(22),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF7BFFB2),
                size: 25,
              ),
              SizedBox(width: 9),
              Text(
                'Payment Ready',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            '₹${amount.toStringAsFixed(2)} via $selectedMethod is ready to be processed.',
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 9.5,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'CANCEL',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 8,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _message(
                  'Payment flow completed successfully.',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF147DFF),
                foregroundColor:
                    Colors.white,
              ),
              child: const Text(
                'CONFIRM',
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

  void _showReceipts() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor:
          const Color(0xFF07152C),
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              28,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Receipts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 9),
                const Text(
                  'Your payment receipts are available in Payment History.',
                  style: TextStyle(
                    color: Color(0x73FFFFFF),
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.receipt_long_rounded,
                      size: 16,
                    ),
                    label: const Text(
                      'VIEW PAYMENT HISTORY',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF147DFF),
                      foregroundColor:
                          Colors.white,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
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
          margin:
              const EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
        ),
      );
  }
}

class PaymentRecord {
  final String title;
  final double amount;
  final String date;
  final String status;
  final IconData icon;

  const PaymentRecord({
    required this.title,
    required this.amount,
    required this.date,
    required this.status,
    required this.icon,
  });
}