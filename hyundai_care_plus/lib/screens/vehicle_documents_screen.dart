import 'package:flutter/material.dart';

import '../widgets/care_background.dart';

class VehicleDocumentsScreen extends StatefulWidget {
  final int? customerId;

  const VehicleDocumentsScreen({
    super.key,
    this.customerId,
  });

  @override
  State<VehicleDocumentsScreen> createState() =>
      _VehicleDocumentsScreenState();
}

class _VehicleDocumentsScreenState
    extends State<VehicleDocumentsScreen> {
  final List<VehicleDocument> documents = [
    const VehicleDocument(
      title: 'Registration Certificate',
      shortTitle: 'RC',
      subtitle: 'Vehicle registration',
      number: 'TN 38 AB 2026',
      expiry: '12 Dec 2039',
      status: 'VALID',
      icon: Icons.description_rounded,
      color: Color(0xFF70E8FF),
    ),
    const VehicleDocument(
      title: 'Insurance',
      shortTitle: 'INS',
      subtitle: 'Motor insurance',
      number: 'HCP-INS-48291',
      expiry: '18 Mar 2027',
      status: 'ACTIVE',
      icon: Icons.verified_user_rounded,
      color: Color(0xFF7BFFB2),
    ),
    const VehicleDocument(
      title: 'PUC Certificate',
      shortTitle: 'PUC',
      subtitle: 'Pollution certificate',
      number: 'PUC-CHN-92841',
      expiry: '05 Nov 2026',
      status: 'VALID',
      icon: Icons.eco_rounded,
      color: Color(0xFFB28CFF),
    ),
    const VehicleDocument(
      title: 'Driving Licence',
      shortTitle: 'DL',
      subtitle: 'Driving licence',
      number: 'TN-DL-XXXXXX',
      expiry: '22 Jun 2034',
      status: 'VALID',
      icon: Icons.badge_rounded,
      color: Color(0xFFFFC857),
    ),
  ];

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
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _header(),
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
                        _summaryCard(),
                        const SizedBox(height: 18),
                        _sectionTitle(),
                        const SizedBox(height: 11),
                        ...documents.map(
                          (document) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: 11,
                            ),
                            child: _documentCard(document),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _securityCard(),
                        const SizedBox(height: 18),
                        _uploadCard(),
                        const SizedBox(height: 18),
                        _helpCard(),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Documents',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Your digital vehicle document wallet',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          _iconButton(
            Icons.add_rounded,
            _showUploadOptions,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SUMMARY
  // ============================================================

  Widget _summaryCard() {
    return Container(
      padding: const EdgeInsets.all(18),
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
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF70E8FF).withValues(
            alpha: 0.12,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF70E8FF).withValues(
                alpha: 0.07,
              ),
            ),
            child: const Icon(
              Icons.folder_special_rounded,
              color: Color(0xFF70E8FF),
              size: 28,
            ),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '4 Documents Protected',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'All your important vehicle documents in one place.',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 7,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.lock_rounded,
            color: Color(0xFF7BFFB2),
            size: 17,
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle() {
    return const Row(
      children: [
        Text(
          'My Documents',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        Text(
          '4 ACTIVE',
          style: TextStyle(
            color: Color(0xFF7BFFB2),
            fontSize: 6,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DOCUMENT CARD
  // ============================================================

  Widget _documentCard(
    VehicleDocument document,
  ) {
    return GestureDetector(
      onTap: () => _showDocument(document),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(
            alpha: 0.035,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withValues(
              alpha: 0.06,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                color: document.color.withValues(
                  alpha: 0.07,
                ),
              ),
              child: Icon(
                document.icon,
                color: document.color,
                size: 22,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    document.subtitle,
                    style: const TextStyle(
                      color: Colors.white30,
                      fontSize: 6,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Expires ${document.expiry}',
                    style: TextStyle(
                      color: _expiryColor(document),
                      fontSize: 6.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7BFFB2).withValues(
                      alpha: 0.06,
                    ),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    document.status,
                    style: const TextStyle(
                      color: Color(0xFF7BFFB2),
                      fontSize: 5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0x33FFFFFF),
                  size: 9,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _expiryColor(
    VehicleDocument document,
  ) {
    return document.status == 'ACTIVE'
        ? const Color(0xFF7BFFB2)
        : Colors.white38;
  }

  // ============================================================
  // SECURITY
  // ============================================================

  Widget _securityCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF7BFFB2).withValues(
          alpha: 0.025,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF7BFFB2).withValues(
            alpha: 0.08,
          ),
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.verified_user_rounded,
            color: Color(0xFF7BFFB2),
            size: 21,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Documents are protected',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Your document information is stored securely within Care+.',
                  style: TextStyle(
                    color: Colors.white30,
                    fontSize: 6,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.lock_rounded,
            color: Color(0xFF7BFFB2),
            size: 16,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // UPLOAD
  // ============================================================

  Widget _uploadCard() {
    return GestureDetector(
      onTap: _showUploadOptions,
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: const Color(0xFF70E8FF).withValues(
            alpha: 0.035,
          ),
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: const Color(0xFF70E8FF).withValues(
              alpha: 0.10,
            ),
          ),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.cloud_upload_rounded,
              color: Color(0xFF70E8FF),
              size: 25,
            ),
            SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add a document',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Upload or capture a new vehicle document.',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 6.5,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF70E8FF),
              size: 10,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HELP
  // ============================================================

  Widget _helpCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.025,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Colors.white30,
            size: 19,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Keep your vehicle documents up to date to receive timely expiry reminders.',
              style: TextStyle(
                color: Colors.white30,
                fontSize: 6.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DOCUMENT DETAILS
  // ============================================================

  void _showDocument(
    VehicleDocument document,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF07152C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
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
                const SizedBox(height: 22),
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(14),
                        color:
                            document.color.withValues(
                          alpha: 0.07,
                        ),
                      ),
                      child: Icon(
                        document.icon,
                        color: document.color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        document.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _detailRow(
                  'Document number',
                  document.number,
                ),
                _detailRow(
                  'Expiry date',
                  document.expiry,
                ),
                _detailRow(
                  'Status',
                  document.status,
                ),
                const SizedBox(height: 17),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          showMessage(
                            'Share feature ready for integration.',
                          );
                        },
                        icon: const Icon(
                          Icons.share_rounded,
                          size: 15,
                        ),
                        label: const Text(
                          'SHARE',
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              const Color(0xFF70E8FF),
                          side: BorderSide(
                            color:
                                const Color(0xFF70E8FF)
                                    .withValues(
                              alpha: 0.20,
                            ),
                          ),
                          minimumSize:
                              const Size(0, 45),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                          textStyle:
                              const TextStyle(
                            fontSize: 7,
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
                          Navigator.pop(context);
                          showMessage(
                            'Document preview opened.',
                          );
                        },
                        icon: const Icon(
                          Icons.visibility_rounded,
                          size: 15,
                        ),
                        label: const Text(
                          'VIEW',
                        ),
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF147DFF),
                          foregroundColor:
                              Colors.white,
                          minimumSize:
                              const Size(0, 45),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                          textStyle:
                              const TextStyle(
                            fontSize: 7,
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
          ),
        );
      },
    );
  }

  Widget _detailRow(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
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
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 7.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // UPLOAD OPTIONS
  // ============================================================

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF07152C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
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
                const SizedBox(height: 20),
                const Text(
                  'Add Document',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _uploadOption(
                  Icons.camera_alt_rounded,
                  'Take Photo',
                  'Capture a document using your camera',
                  const Color(0xFF70E8FF),
                ),
                _uploadOption(
                  Icons.photo_library_rounded,
                  'Choose from Gallery',
                  'Select a document image',
                  const Color(0xFFB28CFF),
                ),
                _uploadOption(
                  Icons.picture_as_pdf_rounded,
                  'Choose PDF',
                  'Add an existing document file',
                  const Color(0xFFFFC857),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _uploadOption(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        showMessage(
          '$title selected. File picker can be connected here.',
        );
      },
      contentPadding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      leading: Container(
        width: 43,
        height: 43,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withValues(
            alpha: 0.07,
          ),
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.white30,
          fontSize: 6,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Color(0x33FFFFFF),
        size: 10,
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
        borderRadius: BorderRadius.circular(14),
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
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
          content: Text(message),
        ),
      );
  }
}

// =================================================================
// MODEL
// =================================================================

class VehicleDocument {
  final String title;
  final String shortTitle;
  final String subtitle;
  final String number;
  final String expiry;
  final String status;
  final IconData icon;
  final Color color;

  const VehicleDocument({
    required this.title,
    required this.shortTitle,
    required this.subtitle,
    required this.number,
    required this.expiry,
    required this.status,
    required this.icon,
    required this.color,
  });
}