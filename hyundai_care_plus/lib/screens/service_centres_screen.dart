import 'package:flutter/material.dart';

class ServiceCentresScreen extends StatefulWidget {
  const ServiceCentresScreen({
    super.key,
  });

  @override
  State<ServiceCentresScreen> createState() =>
      _ServiceCentresScreenState();
}

class _ServiceCentresScreenState
    extends State<ServiceCentresScreen> {
  final TextEditingController searchController =
      TextEditingController();

  String selectedFilter = 'All';

  final List<ServiceCentre> centres = const [
    ServiceCentre(
      name: 'Hyundai Service Centre',
      area: 'Anna Nagar',
      city: 'Chennai',
      address: '2nd Avenue, Anna Nagar, Chennai',
      distance: '2.4 km',
      rating: 4.7,
      open: true,
      phone: '+91 1800 114 645',
      services: [
        'General Service',
        'Periodic Maintenance',
        'Engine Diagnostics',
        'AC Service',
      ],
    ),
    ServiceCentre(
      name: 'Hyundai Care Centre',
      area: 'OMR',
      city: 'Chennai',
      address: 'Rajiv Gandhi Salai, OMR, Chennai',
      distance: '8.7 km',
      rating: 4.6,
      open: true,
      phone: '+91 1800 114 645',
      services: [
        'General Service',
        'Body Repair',
        'Insurance Support',
        'Wheel Alignment',
      ],
    ),
    ServiceCentre(
      name: 'Hyundai Authorised Workshop',
      area: 'T Nagar',
      city: 'Chennai',
      address: 'North Usman Road, T Nagar, Chennai',
      distance: '6.1 km',
      rating: 4.5,
      open: false,
      phone: '+91 1800 114 645',
      services: [
        'Periodic Maintenance',
        'Brake Service',
        'Battery Check',
        'Diagnostics',
      ],
    ),
    ServiceCentre(
      name: 'Hyundai Premium Service',
      area: 'Velachery',
      city: 'Chennai',
      address: 'Velachery Main Road, Chennai',
      distance: '10.3 km',
      rating: 4.8,
      open: true,
      phone: '+91 1800 114 645',
      services: [
        'General Service',
        'Premium Care',
        'AC Service',
        'Roadside Support',
      ],
    ),
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<ServiceCentre> get filteredCentres {
    final query =
        searchController.text.trim().toLowerCase();

    return centres.where((centre) {
      final matchesSearch =
          query.isEmpty ||
          centre.name.toLowerCase().contains(query) ||
          centre.area.toLowerCase().contains(query) ||
          centre.city.toLowerCase().contains(query) ||
          centre.address.toLowerCase().contains(query) ||
          centre.services.any(
            (service) =>
                service.toLowerCase().contains(query),
          );

      final matchesFilter =
          selectedFilter == 'All' ||
          (selectedFilter == 'Open Now' && centre.open);

      return matchesSearch && matchesFilter;
    }).toList();
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
                    _buildSearch(),
                    const SizedBox(height: 12),
                    _buildFilters(),
                    const SizedBox(height: 15),
                    _buildLocationBanner(),
                    const SizedBox(height: 16),
                    _buildMapPreview(),
                    const SizedBox(height: 20),
                    _buildResultsHeader(),
                    const SizedBox(height: 10),
                    if (filteredCentres.isEmpty)
                      _buildEmptyState()
                    else
                      ...filteredCentres.map(
                        _buildCentreCard,
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
        21,
      ),
      child: Row(
        children: [
          _iconButton(
            Icons.arrow_back_ios_new_rounded,
            () => Navigator.pop(context),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Service Centres',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Find Hyundai service near you',
                  style: TextStyle(
                    color: Color(0x73FFFFFF),
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          _iconButton(
            Icons.location_searching_rounded,
            _useCurrentLocation,
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return TextField(
      controller: searchController,
      onChanged: (_) => setState(() {}),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 10,
      ),
      decoration: InputDecoration(
        hintText: 'Search by area or service centre',
        hintStyle: const TextStyle(
          color: Colors.white30,
          fontSize: 9,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: Color(0xFF70E8FF),
          size: 20,
        ),
        suffixIcon: searchController.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  searchController.clear();
                  setState(() {});
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white38,
                  size: 17,
                ),
              ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.035),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(
            color: Color(0xFF70E8FF),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        _filterButton('All'),
        const SizedBox(width: 8),
        _filterButton('Open Now'),
      ],
    );
  }

  Widget _filterButton(String title) {
    final selected = selectedFilter == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = title;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF70E8FF)
                  .withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.035),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: selected
                ? const Color(0xFF70E8FF)
                    .withValues(alpha: 0.35)
                : Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected
                ? const Color(0xFF70E8FF)
                : Colors.white54,
            fontSize: 7.5,
            fontWeight: selected
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationBanner() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF70E8FF)
            .withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF70E8FF)
              .withValues(alpha: 0.09),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF70E8FF)
                  .withValues(alpha: 0.07),
            ),
            child: const Icon(
              Icons.my_location_rounded,
              color: Color(0xFF70E8FF),
              size: 20,
            ),
          ),
          const SizedBox(width: 11),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your location',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Anna Nagar, Chennai',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 7,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _useCurrentLocation,
            child: const Text(
              'UPDATE',
              style: TextStyle(
                color: Color(0xFF70E8FF),
                fontSize: 7,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPreview() {
    return Container(
      height: 220,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.07),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: _ServiceCentreMapPainter(),
          ),
          Positioned(
            top: 14,
            left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF07152C)
                    .withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.map_rounded,
                    color: Color(0xFF70E8FF),
                    size: 14,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'NEARBY CENTRES',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 6.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 14,
            bottom: 14,
            child: ElevatedButton.icon(
              onPressed: _openMap,
              icon: const Icon(
                Icons.open_in_full_rounded,
                size: 14,
              ),
              label: const Text(
                'OPEN MAP',
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF147DFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsHeader() {
    return Row(
      children: [
        const Text(
          'Nearby Service Centres',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Text(
          '${filteredCentres.length} found',
          style: const TextStyle(
            color: Colors.white30,
            fontSize: 7,
          ),
        ),
      ],
    );
  }

  Widget _buildCentreCard(ServiceCentre centre) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: GestureDetector(
        onTap: () => _showCentreDetails(centre),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.035),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: const Color(0xFF70E8FF)
                          .withValues(alpha: 0.055),
                    ),
                    child: const Icon(
                      Icons.car_repair_rounded,
                      color: Color(0xFF70E8FF),
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          centre.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          centre.area,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 7,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _statusBadge(centre.open),
                ],
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: Color(0xFF70E8FF),
                    size: 15,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      centre.address,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 7,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              Row(
                children: [
                  const Icon(
                    Icons.route_rounded,
                    color: Colors.white30,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    centre.distance,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 7,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFFFC857),
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    centre.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 7,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white24,
                    size: 9,
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  Expanded(
                    child: _smallAction(
                      Icons.directions_rounded,
                      'Directions',
                      () => _showDirections(centre),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _smallAction(
                      Icons.calendar_month_rounded,
                      'Book Service',
                      () => _bookService(centre),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(bool open) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: open
            ? const Color(0xFF7BFFB2)
                .withValues(alpha: 0.07)
            : const Color(0xFFFFC857)
                .withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        open ? 'OPEN' : 'CLOSED',
        style: TextStyle(
          color: open
              ? const Color(0xFF7BFFB2)
              : const Color(0xFFFFC857),
          fontSize: 5.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _smallAction(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return SizedBox(
      height: 38,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(
          icon,
          size: 14,
        ),
        label: Text(
          title,
          style: const TextStyle(
            fontSize: 6.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF70E8FF),
          side: BorderSide(
            color: const Color(0xFF70E8FF)
                .withValues(alpha: 0.20),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            color: Colors.white30,
            size: 42,
          ),
          SizedBox(height: 12),
          Text(
            'No service centres found',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Try another area or search term.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white38,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }

  void _showCentreDetails(ServiceCentre centre) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF07152C),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              30,
            ),
            child: Column(
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
                Text(
                  centre.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  centre.address,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 8,
                  ),
                ),
                const SizedBox(height: 17),
                Row(
                  children: [
                    _detailChip(
                      Icons.star_rounded,
                      '${centre.rating}',
                    ),
                    const SizedBox(width: 8),
                    _detailChip(
                      Icons.route_rounded,
                      centre.distance,
                    ),
                    const SizedBox(width: 8),
                    _detailChip(
                      centre.open
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      centre.open ? 'Open' : 'Closed',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Available Services',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: centre.services.map(
                    (service) {
                      return Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withValues(alpha: 0.04),
                          borderRadius:
                              BorderRadius.circular(9),
                        ),
                        child: Text(
                          service,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 7,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
                const SizedBox(height: 20),
                _infoRow(
                  Icons.phone_rounded,
                  centre.phone,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: centre.open
                        ? () {
                            Navigator.pop(sheetContext);
                            _bookService(centre);
                          }
                        : null,
                    icon: const Icon(
                      Icons.calendar_month_rounded,
                      size: 16,
                    ),
                    label: const Text(
                      'BOOK SERVICE',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF147DFF),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          Colors.white12,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 9),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      _showDirections(centre);
                    },
                    icon: const Icon(
                      Icons.directions_rounded,
                      size: 16,
                    ),
                    label: const Text(
                      'GET DIRECTIONS',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          const Color(0xFF70E8FF),
                      side: BorderSide(
                        color: const Color(0xFF70E8FF)
                            .withValues(alpha: 0.25),
                      ),
                      shape: RoundedRectangleBorder(
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

  Widget _detailChip(
    IconData icon,
    String text,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: const Color(0xFF70E8FF),
            size: 13,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String text,
  ) {
    return Row(
      children: [
        const Icon(
          Icons.phone_rounded,
          color: Color(0xFF70E8FF),
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 8,
          ),
        ),
      ],
    );
  }

  void _useCurrentLocation() {
    _message(
      'Using your current service area.',
    );
  }

  void _openMap() {
    _message(
      'Map view opened. Select a centre below for details.',
    );
  }

  void _showDirections(
    ServiceCentre centre,
  ) {
    _message(
      'Directions to ${centre.name} are ready.',
    );
  }

  void _bookService(
    ServiceCentre centre,
  ) {
    if (!centre.open) {
      _message(
        'This service centre is currently closed.',
      );
      return;
    }

    _message(
      'Service booking started for ${centre.name}.',
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
            borderRadius: BorderRadius.circular(13),
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
            color: Colors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.10),
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
}

class ServiceCentre {
  final String name;
  final String area;
  final String city;
  final String address;
  final String distance;
  final double rating;
  final bool open;
  final String phone;
  final List<String> services;

  const ServiceCentre({
    required this.name,
    required this.area,
    required this.city,
    required this.address,
    required this.distance,
    required this.rating,
    required this.open,
    required this.phone,
    required this.services,
  });
}

class _Road {
  final List<Offset> points;

  const _Road(this.points);
}

class _ServiceCentreMapPainter
    extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final background = Paint()
      ..color = const Color(0xFF081B2D);

    canvas.drawRect(
      Offset.zero & size,
      background,
    );

    final roadPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 13
      ..color = const Color(0xFF102E43);

    final roads = [
      _Road([
        Offset(-20, size.height * .75),
        Offset(size.width * .20, size.height * .60),
        Offset(size.width * .42, size.height * .67),
        Offset(size.width * .68, size.height * .39),
        Offset(size.width + 20, size.height * .20),
      ]),
      _Road([
        Offset(size.width * .18, -20),
        Offset(size.width * .29, size.height * .25),
        Offset(size.width * .53, size.height * .43),
        Offset(size.width * .76, size.height * .75),
        Offset(size.width + 20, size.height * .88),
      ]),
    ];

    for (final road in roads) {
      canvas.drawPath(
        _buildPath(road.points),
        roadPaint,
      );
    }

    final smallerRoadPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3
      ..color = const Color(0xFF0E293D);

    for (int i = 0; i < 8; i++) {
      final path = _buildPath([
        Offset(
          -20,
          size.height * (0.08 + i * .13),
        ),
        Offset(
          size.width * .30,
          size.height * (0.18 + i * .08),
        ),
        Offset(
          size.width * .60,
          size.height * (0.05 + i * .12),
        ),
        Offset(
          size.width + 20,
          size.height * (0.20 + i * .09),
        ),
      ]);

      canvas.drawPath(
        path,
        smallerRoadPaint,
      );
    }

    final buildingPaint = Paint()
      ..color = const Color(0xFF0B2639);

    final positions = [
      const Rect.fromLTWH(25, 40, 42, 28),
      const Rect.fromLTWH(100, 25, 32, 22),
      const Rect.fromLTWH(190, 45, 50, 27),
      const Rect.fromLTWH(290, 25, 35, 25),
      const Rect.fromLTWH(40, 145, 48, 25),
      const Rect.fromLTWH(150, 130, 36, 30),
      const Rect.fromLTWH(255, 150, 54, 27),
    ];

    for (final rect in positions) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect,
          const Radius.circular(4),
        ),
        buildingPaint,
      );
    }

    _drawMarker(
      canvas,
      Offset(
        size.width * .32,
        size.height * .53,
      ),
      const Color(0xFF70E8FF),
    );

    _drawMarker(
      canvas,
      Offset(
        size.width * .67,
        size.height * .38,
      ),
      const Color(0xFF7BFFB2),
    );

    _drawMarker(
      canvas,
      Offset(
        size.width * .76,
        size.height * .70,
      ),
      const Color(0xFFB28CFF),
    );

    final current = Offset(
      size.width * .48,
      size.height * .60,
    );

    final glow = Paint()
      ..color = const Color(0xFF70E8FF)
          .withValues(alpha: .12);

    canvas.drawCircle(
      current,
      28,
      glow,
    );

    final marker = Paint()
      ..color = const Color(0xFF70E8FF);

    canvas.drawCircle(
      current,
      7,
      marker,
    );

    final inner = Paint()
      ..color = const Color(0xFF07152C);

    canvas.drawCircle(
      current,
      3,
      inner,
    );
  }

  Path _buildPath(
    List<Offset> points,
  ) {
    final path = Path();

    if (points.isEmpty) {
      return path;
    }

    path.moveTo(
      points.first.dx,
      points.first.dy,
    );

    for (int i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final current = points[i];

      final midX =
          (previous.dx + current.dx) / 2;
      final midY =
          (previous.dy + current.dy) / 2;

      path.quadraticBezierTo(
        previous.dx,
        previous.dy,
        midX,
        midY,
      );
    }

    final last = points.last;

    path.lineTo(
      last.dx,
      last.dy,
    );

    return path;
  }

  void _drawMarker(
    Canvas canvas,
    Offset position,
    Color color,
  ) {
    final glow = Paint()
      ..color = color.withValues(alpha: .12);

    canvas.drawCircle(
      position,
      18,
      glow,
    );

    final outer = Paint()
      ..color = color;

    canvas.drawCircle(
      position,
      7,
      outer,
    );

    final inner = Paint()
      ..color = const Color(0xFF07152C);

    canvas.drawCircle(
      position,
      3,
      inner,
    );
  }

  @override
  bool shouldRepaint(
    covariant _ServiceCentreMapPainter oldDelegate,
  ) {
    return false;
  }
}