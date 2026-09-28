import 'package:flutter/material.dart';

class AboutLegalScreen
    extends StatelessWidget {
  const AboutLegalScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF020817),
      appBar: AppBar(
        backgroundColor:
            Colors.transparent,
        elevation: 0,
        foregroundColor:
            Colors.white,
        title:
            const Text(
          'About & Legal',
          style:
              TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child:
            SingleChildScrollView(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            5,
            20,
            35,
          ),
          child:
              Column(
            children: [
              _brandCard(),

              const SizedBox(
                height: 18,
              ),

              _legalCard(
                context,
                icon:
                    Icons.info_outline_rounded,
                title:
                    'About Hyundai Care+',
                content:
                    'Hyundai Care+ is designed to bring vehicle service, maintenance, warranty, assistance, documents and customer support together in one convenient application.',
              ),

              _legalCard(
                context,
                icon:
                    Icons.privacy_tip_outlined,
                title:
                    'Privacy Policy',
                content:
                    'Your account and vehicle information should be handled securely and used only to provide Hyundai Care+ services, communication and support.',
              ),

              _legalCard(
                context,
                icon:
                    Icons.description_outlined,
                title:
                    'Terms of Service',
                content:
                    'Use of Hyundai Care+ is subject to the applicable service terms, booking conditions, payment terms and assistance policies.',
              ),

              _legalCard(
                context,
                icon:
                    Icons.security_outlined,
                title:
                    'Data & Security',
                content:
                    'Hyundai Care+ uses account information and vehicle information to provide personalized vehicle-care features and service management.',
              ),

              _legalCard(
                context,
                icon:
                    Icons.support_agent_rounded,
                title:
                    'Customer Support',
                content:
                    'For service-related questions, booking assistance or account support, use the Help & Support section inside Hyundai Care+.',
              ),

              const SizedBox(
                height: 18,
              ),

              Container(
                width:
                    double.infinity,
                padding:
                    const EdgeInsets.all(
                  18,
                ),
                decoration:
                    BoxDecoration(
                  color:
                      Colors.white
                          .withValues(
                    alpha:
                        0.045,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                  border:
                      Border.all(
                    color:
                        Colors.white
                            .withValues(
                      alpha:
                          0.08,
                    ),
                  ),
                ),
                child:
                    const Column(
                  children: [
                    Icon(
                      Icons
                          .directions_car_filled_rounded,
                      color:
                          Color(
                        0xFF70E8FF,
                      ),
                      size: 35,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'HYUNDAI CARE+',
                      style:
                          TextStyle(
                        color:
                            Colors.white,
                        fontSize:
                            16,
                        fontWeight:
                            FontWeight.bold,
                        letterSpacing:
                            2,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Your Hyundai. Our Care. Always.',
                      textAlign:
                          TextAlign.center,
                      style:
                          TextStyle(
                        color:
                            Colors.white38,
                        fontSize:
                            8,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Version 1.0',
                      style:
                          TextStyle(
                        color:
                            Colors.white24,
                        fontSize:
                            7,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _brandCard() {
    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.all(
        22,
      ),
      decoration:
          BoxDecoration(
        gradient:
            const LinearGradient(
          begin:
              Alignment.topLeft,
          end:
              Alignment.bottomRight,
          colors: [
            Color(0xFF112D52),
            Color(0xFF261650),
            Color(0xFF063E49),
          ],
        ),
        borderRadius:
            BorderRadius.circular(
          25,
        ),
        border:
            Border.all(
          color:
              Colors.white
                  .withValues(
            alpha:
                0.10,
          ),
        ),
      ),
      child:
          const Column(
        children: [
          Icon(
            Icons
                .directions_car_filled_rounded,
            color:
                Colors.white,
            size: 48,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            'HYUNDAI',
            style:
                TextStyle(
              color:
                  Colors.white,
              fontSize:
                  24,
              fontWeight:
                  FontWeight.bold,
              letterSpacing:
                  4,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            'CARE+',
            style:
                TextStyle(
              color:
                  Color(0xFF70E8FF),
              fontSize:
                  18,
              fontWeight:
                  FontWeight.w700,
              letterSpacing:
                  3,
            ),
          ),
          SizedBox(
            height: 9,
          ),
          Text(
            'Drive Safe. We Care.',
            style:
                TextStyle(
              color:
                  Colors.white54,
              fontSize:
                  9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _legalCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      width:
          double.infinity,
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white
                .withValues(
          alpha:
              0.045,
        ),
        borderRadius:
            BorderRadius.circular(
          19,
        ),
        border:
            Border.all(
          color:
              Colors.white
                  .withValues(
            alpha:
                0.075,
          ),
        ),
      ),
      child:
          Theme(
        data:
            Theme.of(context).copyWith(
          dividerColor:
              Colors.transparent,
        ),
        child:
            ExpansionTile(
          tilePadding:
              const EdgeInsets
                  .symmetric(
            horizontal: 16,
          ),
          childrenPadding:
              const EdgeInsets
                  .fromLTRB(
            16,
            0,
            16,
            18,
          ),
          leading:
              Container(
            width: 42,
            height: 42,
            decoration:
                BoxDecoration(
              color:
                  const Color(
                0xFF70E8FF,
              ).withValues(
                alpha:
                    0.07,
              ),
              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),
            child:
                Icon(
              icon,
              color:
                  const Color(
                0xFF70E8FF,
              ),
              size: 20,
            ),
          ),
          title:
              Text(
            title,
            style:
                const TextStyle(
              color:
                  Colors.white,
              fontSize:
                  10,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          iconColor:
              Colors.white54,
          collapsedIconColor:
              Colors.white30,
          children: [
            Align(
              alignment:
                  Alignment.centerLeft,
              child:
                  Text(
                content,
                style:
                    const TextStyle(
                  color:
                      Colors.white54,
                  fontSize:
                      8,
                  height:
                      1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}