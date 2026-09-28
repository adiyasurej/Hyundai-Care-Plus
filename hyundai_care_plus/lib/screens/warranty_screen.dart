import 'package:flutter/material.dart';

class WarrantyScreen extends StatefulWidget {
  final int? customerId;

  const WarrantyScreen({
    super.key,
    this.customerId,
  });

  @override
  State<WarrantyScreen> createState() =>
      _WarrantyScreenState();
}

class _WarrantyScreenState
    extends State<WarrantyScreen> {
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020817),
      body: Stack(
        children: [
          const Positioned.fill(
            child: _WarrantyBackground(),
          ),
          SafeArea(
            child: Column(
              children: [
                _header(),
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.fromLTRB(
                      16,
                      8,
                      16,
                      30,
                    ),
                    child: Column(
                      children: [
                        _warrantyCard(),
                        const SizedBox(height: 18),
                        _coverageCard(),
                        const SizedBox(height: 18),
                        _infoCard(),
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

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        14,
        12,
        14,
        10,
      ),
      child: Row(
        children: [
          _button(
            Icons.arrow_back_rounded,
            () => Navigator.pop(context),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Warranty',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Protection for your Hyundai',
                  style: TextStyle(
                    color: Color(0x88FFFFFF),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _button(
            Icons.refresh_rounded,
            () => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _warrantyCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF123866),
            Color(0xFF282052),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF70E8FF)
              .withValues(alpha: 0.20),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1687FF)
                .withValues(alpha: 0.12),
            blurRadius: 25,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xFF62E6A7)
                      .withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  color: Color(0xFF62E6A7),
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
                      'Hyundai i20',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'TN 07 AB 1234',
                      style: TextStyle(
                        color: Color(0x99FFFFFF),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              _activeBadge(),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Standard Vehicle Warranty',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _dateBox(
                  'START DATE',
                  '01 Jan 2024',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _dateBox(
                  'EXPIRY DATE',
                  '31 Dec 2027',
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              const Text(
                '68%',
                style: TextStyle(
                  color: Color(0xFF70E8FF),
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Padding(
                padding:
                    EdgeInsets.only(bottom: 5),
                child: Text(
                  'remaining',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius:
                BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.68,
              minHeight: 9,
              backgroundColor:
                  Color(0x25FFFFFF),
              valueColor:
                  AlwaysStoppedAnimation<Color>(
                Color(0xFF62E6A7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _activeBadge() {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF62E6A7)
            .withValues(alpha: 0.12),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF62E6A7)
              .withValues(alpha: 0.25),
        ),
      ),
      child: const Text(
        'ACTIVE',
        style: TextStyle(
          color: Color(0xFF62E6A7),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _dateBox(
    String label,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.black
            .withValues(alpha: 0.13),
        borderRadius:
            BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _coverageCard() {
    const components = [
      'Engine',
      'Transmission',
      'Electrical Components',
      'Suspension',
      'Braking System',
    ];

    return _card(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Covered Components',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          ...components.map(
            (component) {
              return Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 11,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color:
                          Color(0xFF62E6A7),
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      component,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _showDetails =
                      !_showDetails;
                });
              },
              icon: Icon(
                _showDetails
                    ? Icons.expand_less
                    : Icons.expand_more,
              ),
              label: Text(
                _showDetails
                    ? 'HIDE DETAILS'
                    : 'VIEW DETAILS',
              ),
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF1687FF),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 13,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(13),
                ),
              ),
            ),
          ),
          if (_showDetails) ...[
            const SizedBox(height: 15),
            const Text(
              'Warranty coverage is subject to Hyundai warranty terms and conditions. Keep your service history up to date to maintain eligibility.',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoCard() {
    return _card(
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFF70E8FF)
                  .withValues(alpha: 0.09),
              borderRadius:
                  BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: Color(0xFF70E8FF),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Need warranty help?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Contact Hyundai Care+ support for assistance.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white38,
            size: 15,
          ),
        ],
      ),
    );
  }

  Widget _card({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white
            .withValues(alpha: 0.05),
        borderRadius:
            BorderRadius.circular(21),
        border: Border.all(
          color: Colors.white
              .withValues(alpha: 0.08),
        ),
      ),
      child: child,
    );
  }

  Widget _button(
    IconData icon,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.white
          .withValues(alpha: 0.06),
      borderRadius:
          BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(14),
        child: SizedBox(
          width: 45,
          height: 45,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _WarrantyBackground
    extends StatelessWidget {
  const _WarrantyBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF031426),
            Color(0xFF082840),
            Color(0xFF110B2B),
          ],
        ),
      ),
    );
  }
}