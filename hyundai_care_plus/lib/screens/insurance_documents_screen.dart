import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../widgets/care_background.dart';

class InsuranceDocumentsScreen extends StatefulWidget {
  final int? customerId;

  const InsuranceDocumentsScreen({
    super.key,
    this.customerId,
  });

  @override
  State<InsuranceDocumentsScreen> createState() =>
      _InsuranceDocumentsScreenState();
}

class _InsuranceDocumentsScreenState
    extends State<InsuranceDocumentsScreen>
    with TickerProviderStateMixin {
  late AnimationController auroraController;
  late AnimationController entranceController;

  String selectedCategory = 'All';

  final List<VehicleDocument> documents = [
    VehicleDocument(
      id: 'DOC-001',
      title: 'Vehicle Insurance',
      subtitle: 'Comprehensive Insurance Policy',
      category: 'Insurance',
      number: 'POL-HC-458921',
      issuedDate: '15 Sep 2025',
      expiryDate: '14 Sep 2026',
      status: 'Active',
      icon: Icons.shield_rounded,
      size: '2.4 MB',
    ),
    VehicleDocument(
      id: 'DOC-002',
      title: 'Registration Certificate',
      subtitle: 'Vehicle Registration Certificate',
      category: 'RC',
      number: 'TN 01 AB 4589',
      issuedDate: '12 Jan 2025',
      expiryDate: '11 Jan 2040',
      status: 'Valid',
      icon: Icons.directions_car_filled_rounded,
      size: '1.8 MB',
    ),
    VehicleDocument(
      id: 'DOC-003',
      title: 'PUC Certificate',
      subtitle: 'Pollution Under Control Certificate',
      category: 'PUC',
      number: 'PUC-785421',
      issuedDate: '08 Jul 2026',
      expiryDate: '07 Jan 2027',
      status: 'Valid',
      icon: Icons.eco_rounded,
      size: '1.1 MB',
    ),
    VehicleDocument(
      id: 'DOC-004',
      title: 'Warranty',
      subtitle: 'Hyundai Vehicle Warranty',
      category: 'Warranty',
      number: 'WAR-HC-4589',
      issuedDate: '10 Jan 2025',
      expiryDate: '09 Jan 2028',
      status: 'Active',
      icon: Icons.verified_user_rounded,
      size: '3.2 MB',
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
  }

  @override
  void dispose() {
    auroraController.dispose();
    entranceController.dispose();
    super.dispose();
  }

  List<VehicleDocument> get filteredDocuments {
    if (selectedCategory == 'All') {
      return documents;
    }

    return documents
        .where(
          (document) =>
              document.category == selectedCategory,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020817),
      body: CareBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: auroraController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _DocumentsAuroraPainter(
                          progress:
                              auroraController.value,
                        ),
                      );
                    },
                  ),
                ),
              ),
              _buildPage(),
            ],
          ),
        ),
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
                  _buildInsuranceCard(),
                ),
                const SizedBox(height: 18),
                _animated(
                  1,
                  _buildExpiryAlert(),
                ),
                const SizedBox(height: 18),
                _animated(
                  2,
                  _buildCategories(),
                ),
                const SizedBox(height: 16),
                if (filteredDocuments.isEmpty)
                  _animated(
                    3,
                    _buildEmptyState(),
                  ),
                ...List.generate(
                  filteredDocuments.length,
                  (index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: _animated(
                        index + 3,
                        _documentCard(
                          filteredDocuments[index],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 6),
                _animated(
                  10,
                  _buildUploadCard(),
                ),
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
        20,
      ),
      child: Row(
        children: [
          _circleButton(
            Icons.arrow_back_ios_new_rounded,
            () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Insurance & Documents',
                  style: TextStyle(
                    color: CareTheme.primaryText,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Keep your vehicle documents safe',
                  style: TextStyle(
                    color: CareTheme.secondaryText,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          _circleButton(
            Icons.upload_file_rounded,
            _showUploadMessage,
          ),
        ],
      ),
    );
  }

  Widget _buildInsuranceCard() {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: CareTheme.isDark
              ? const [
                  Color(0xFF10375B),
                  Color(0xFF182553),
                  Color(0xFF102C38),
                ]
              : const [
                  Color(0xFFE8F5FF),
                  Color(0xFFDDEEFF),
                  Color(0xFFE8F3F8),
                ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: CareTheme.cyan.withValues(
            alpha: 0.15,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 51,
                height: 51,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CareTheme.cyan.withValues(
                    alpha: 0.09,
                  ),
                ),
                child: Icon(
                  Icons.shield_rounded,
                  color: CareTheme.cyan,
                  size: 25,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Insurance Protected',
                      style: TextStyle(
                        color: CareTheme.primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Comprehensive vehicle coverage',
                      style: TextStyle(
                        color: CareTheme.secondaryText,
                        fontSize: 7.5,
                      ),
                    ),
                  ],
                ),
              ),
              _statusBadge(
                'ACTIVE',
                const Color(0xFF7BFFB2),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            height: 1,
            color: CareTheme.borderColor,
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _insuranceInfo(
                  'POLICY NUMBER',
                  'POL-HC-458921',
                ),
              ),
              Expanded(
                child: _insuranceInfo(
                  'VALID UNTIL',
                  '14 Sep 2026',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showDocumentDetails(
                      documents.first,
                    );
                  },
                  icon: const Icon(
                    Icons.visibility_outlined,
                    size: 16,
                  ),
                  label: const Text(
                    'VIEW POLICY',
                  ),
                  style:
                      OutlinedButton.styleFrom(
                    foregroundColor:
                        CareTheme.cyan,
                    side: BorderSide(
                      color:
                          CareTheme.cyan.withValues(
                        alpha: 0.20,
                      ),
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(13),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    showMessage(
                      'Policy download started.',
                    );
                  },
                  icon: const Icon(
                    Icons.download_rounded,
                    size: 16,
                  ),
                  label: const Text(
                    'DOWNLOAD',
                  ),
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        CareTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(13),
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

  Widget _insuranceInfo(
    String label,
    String value,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: CareTheme.secondaryText,
            fontSize: 6,
            letterSpacing: 0.7,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            color: CareTheme.primaryText,
            fontSize: 8.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildExpiryAlert() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFC857).withValues(
          alpha: 0.045,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFFFC857).withValues(
            alpha: 0.12,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFC857)
                  .withValues(alpha: 0.08),
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: Color(0xFFFFC857),
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
                  'Insurance expires in 19 days',
                  style: TextStyle(
                    color: CareTheme.primaryText,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Renew your policy before 14 Sep 2026.',
                  style: TextStyle(
                    color: CareTheme.secondaryText,
                    fontSize: 7,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              showMessage(
                'Insurance renewal options opened.',
              );
            },
            child: const Text(
              'RENEW',
              style: TextStyle(
                color: Color(0xFFFFC857),
                fontSize: 7,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    const categories = [
      'All',
      'Insurance',
      'RC',
      'PUC',
      'Warranty',
    ];

    return SizedBox(
      height: 39,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, index) =>
            const SizedBox(width: 7),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected =
              selectedCategory == category;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: AnimatedContainer(
              duration:
                  const Duration(milliseconds: 180),
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? CareTheme.cyan.withValues(
                        alpha: 0.11,
                      )
                    : CareTheme.cardColor,
                borderRadius:
                    BorderRadius.circular(12),
                border: Border.all(
                  color: selected
                      ? CareTheme.cyan.withValues(
                          alpha: 0.22,
                        )
                      : CareTheme.borderColor,
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: selected
                      ? CareTheme.cyan
                      : CareTheme.secondaryText,
                  fontSize: 7,
                  fontWeight: selected
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _documentCard(
    VehicleDocument document,
  ) {
    final statusColor =
        document.status == 'Active' ||
                document.status == 'Valid'
            ? const Color(0xFF7BFFB2)
            : const Color(0xFFFF7185);

    return GestureDetector(
      onTap: () {
        _showDocumentDetails(document);
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: CareTheme.cardColor,
          borderRadius:
              BorderRadius.circular(20),
          border: Border.all(
            color: CareTheme.borderColor,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(14),
                color: CareTheme.cyan.withValues(
                  alpha: 0.055,
                ),
              ),
              child: Icon(
                document.icon,
                color: CareTheme.cyan,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    document.title,
                    style: TextStyle(
                      color: CareTheme.primaryText,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    document.subtitle,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color: CareTheme.secondaryText,
                      fontSize: 7,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      _statusBadge(
                        document.status.toUpperCase(),
                        statusColor,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        document.size,
                        style: TextStyle(
                          color:
                              CareTheme.secondaryText,
                          fontSize: 6.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: CareTheme.secondaryText,
              size: 11,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: CareTheme.cardColor,
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: CareTheme.borderColor,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.folder_off_rounded,
            color: CareTheme.secondaryText,
            size: 42,
          ),
          const SizedBox(height: 12),
          Text(
            'No documents found',
            style: TextStyle(
              color: CareTheme.primaryText,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try another category.',
            style: TextStyle(
              color: CareTheme.secondaryText,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadCard() {
    return GestureDetector(
      onTap: _showUploadMessage,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: CareTheme.cyan.withValues(
            alpha: 0.025,
          ),
          borderRadius:
              BorderRadius.circular(20),
          border: Border.all(
            color: CareTheme.cyan.withValues(
              alpha: 0.10,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              color: CareTheme.cyan,
              size: 24,
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add a document',
                    style: TextStyle(
                      color: CareTheme.primaryText,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Upload insurance, RC, PUC or other vehicle documents.',
                    style: TextStyle(
                      color: CareTheme.secondaryText,
                      fontSize: 7,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.add_circle_outline_rounded,
              color: CareTheme.cyan,
              size: 19,
            ),
          ],
        ),
      ),
    );
  }

  void _showDocumentDetails(
    VehicleDocument document,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: CareTheme.isDark
          ? const Color(0xFF07152C)
          : Colors.white,
      isScrollControlled: true,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.fromLTRB(
              22,
              18,
              22,
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
                      color:
                          CareTheme.secondaryText,
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 23),
                Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(17),
                        color:
                            CareTheme.cyan.withValues(
                          alpha: 0.07,
                        ),
                      ),
                      child: Icon(
                        document.icon,
                        color: CareTheme.cyan,
                        size: 27,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            document.title,
                            style: TextStyle(
                              color:
                                  CareTheme.primaryText,
                              fontSize: 17,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            document.subtitle,
                            style: TextStyle(
                              color:
                                  CareTheme.secondaryText,
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _statusBadge(
                      document.status.toUpperCase(),
                      const Color(0xFF7BFFB2),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                _detailRow(
                  Icons.tag_rounded,
                  'Document Number',
                  document.number,
                ),
                _detailRow(
                  Icons.calendar_today_outlined,
                  'Issued Date',
                  document.issuedDate,
                ),
                _detailRow(
                  Icons.event_outlined,
                  'Expiry Date',
                  document.expiryDate,
                ),
                _detailRow(
                  Icons.insert_drive_file_outlined,
                  'File Size',
                  document.size,
                ),
                const SizedBox(height: 17),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(
                            sheetContext,
                          );
                          showMessage(
                            'Opening document preview...',
                          );
                        },
                        icon: const Icon(
                          Icons.visibility_outlined,
                          size: 17,
                        ),
                        label: const Text(
                          'PREVIEW',
                        ),
                        style:
                            OutlinedButton.styleFrom(
                          foregroundColor:
                              CareTheme.cyan,
                          side: BorderSide(
                            color:
                                CareTheme.cyan.withValues(
                              alpha: 0.20,
                            ),
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(
                            sheetContext,
                          );
                          showMessage(
                            'Downloading ${document.title}...',
                          );
                        },
                        icon: const Icon(
                          Icons.download_rounded,
                          size: 17,
                        ),
                        label: const Text(
                          'DOWNLOAD',
                        ),
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              CareTheme.primaryBlue,
                          foregroundColor:
                              Colors.white,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),
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
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 8),
      padding:
          const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: CareTheme.cardColor,
        borderRadius:
            BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: CareTheme.cyan,
            size: 17,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              color: CareTheme.secondaryText,
              fontSize: 8,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: CareTheme.primaryText,
                fontSize: 8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(
    String text,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.07,
        ),
        borderRadius:
            BorderRadius.circular(7),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 5.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

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

  void _showUploadMessage() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: CareTheme.isDark
          ? const Color(0xFF07152C)
          : Colors.white,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.fromLTRB(
              22,
              20,
              22,
              28,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add Document',
                  style: TextStyle(
                    color: CareTheme.primaryText,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                _uploadOption(
                  Icons.camera_alt_rounded,
                  'Take a photo',
                  () {
                    Navigator.pop(sheetContext);
                    showMessage(
                      'Camera upload will be connected here.',
                    );
                  },
                ),
                const SizedBox(height: 9),
                _uploadOption(
                  Icons.photo_library_rounded,
                  'Choose from gallery',
                  () {
                    Navigator.pop(sheetContext);
                    showMessage(
                      'Gallery upload will be connected here.',
                    );
                  },
                ),
                const SizedBox(height: 9),
                _uploadOption(
                  Icons.folder_rounded,
                  'Choose a file',
                  () {
                    Navigator.pop(sheetContext);
                    showMessage(
                      'File picker will be connected here.',
                    );
                  },
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
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: CareTheme.cardColor,
          borderRadius:
              BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: CareTheme.cyan,
              size: 21,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: CareTheme.primaryText,
                fontSize: 9,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: CareTheme.secondaryText,
              size: 10,
            ),
          ],
        ),
      ),
    );
  }

  void showMessage(String message) {
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

  Widget _animated(
    int index,
    Widget child,
  ) {
    return AnimatedBuilder(
      animation: entranceController,
      builder: (context, animatedChild) {
        final double delay =
            (index * 0.035).clamp(0.0, 0.75);

        final double value =
            ((entranceController.value -
                        delay) /
                    (1 - delay))
                .clamp(0.0, 1.0);

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset:
                Offset(0, 16 * (1 - value)),
            child: animatedChild,
          ),
        );
      },
      child: child,
    );
  }
}

class VehicleDocument {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String number;
  final String issuedDate;
  final String expiryDate;
  final String status;
  final IconData icon;
  final String size;

  const VehicleDocument({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.number,
    required this.issuedDate,
    required this.expiryDate,
    required this.status,
    required this.icon,
    required this.size,
  });
}

class _DocumentsAuroraPainter
    extends CustomPainter {
  final double progress;

  _DocumentsAuroraPainter({
    required this.progress,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint();

    final double t = progress * math.pi * 2;

    final cyanCenter = Offset(
      size.width *
          (0.18 + math.sin(t) * 0.12),
      size.height *
          (0.18 + math.cos(t) * 0.06),
    );

    paint.shader = RadialGradient(
      colors: [
        const Color(0xFF00E5FF).withValues(
          alpha: 0.075,
        ),
        Colors.transparent,
      ],
    ).createShader(
      Rect.fromCircle(
        center: cyanCenter,
        radius: size.width * 0.65,
      ),
    );

    canvas.drawRect(
      Offset.zero & size,
      paint,
    );

    final purpleCenter = Offset(
      size.width *
          (0.82 + math.cos(t) * 0.10),
      size.height *
          (0.52 + math.sin(t) * 0.07),
    );

    paint.shader = RadialGradient(
      colors: [
        const Color(0xFF8C5CFF).withValues(
          alpha: 0.065,
        ),
        Colors.transparent,
      ],
    ).createShader(
      Rect.fromCircle(
        center: purpleCenter,
        radius: size.width * 0.60,
      ),
    );

    canvas.drawRect(
      Offset.zero & size,
      paint,
    );

    final random = math.Random(42);
    final starPaint = Paint();

    for (int i = 0; i < 45; i++) {
      final double x =
          random.nextDouble() * size.width;
      final double y =
          random.nextDouble() * size.height;

      final double opacity =
          0.15 +
          ((math.sin(t + i) + 1) / 2) *
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
    covariant _DocumentsAuroraPainter oldDelegate,
  ) {
    return oldDelegate.progress != progress;
  }
}