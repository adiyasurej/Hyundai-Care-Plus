import 'package:flutter/material.dart';

import '../widgets/care_background.dart';

class NotificationScreen extends StatefulWidget {
  final int? customerId;

  const NotificationScreen({
    super.key,
    this.customerId,
  });

  @override
  State<NotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState
    extends State<NotificationScreen> {
  int _selectedTab = 0;

  final List<_AppNotification> _notifications = [
    _AppNotification(
      title: 'Emergency Assistance Requested',
      message:
          'Your roadside assistance request has been received.',
      time: 'Just now',
      icon: Icons.emergency_rounded,
      color: Color(0xFFFF647C),
      unread: true,
    ),
    _AppNotification(
      title: 'Service Booking Confirmed',
      message:
          'Your General Service booking has been received successfully.',
      time: '2h ago',
      icon: Icons.calendar_month_rounded,
      color: Color(0xFF70E8FF),
      unread: true,
    ),
    _AppNotification(
      title: 'Service Reminder',
      message:
          'Your next vehicle service is due soon.',
      time: '1d ago',
      icon: Icons.notifications_active_rounded,
      color: Color(0xFFFFC857),
      unread: true,
    ),
    _AppNotification(
      title: 'Warranty Update',
      message:
          'Your vehicle warranty is currently active.',
      time: '3d ago',
      icon: Icons.verified_user_rounded,
      color: Color(0xFF62E6A7),
      unread: false,
    ),
    _AppNotification(
      title: 'Special Offer',
      message:
          'Exclusive offers are available for Care+ customers.',
      time: '5d ago',
      icon: Icons.local_offer_rounded,
      color: Color(0xFF9A7BFF),
      unread: false,
    ),
  ];

  List<_AppNotification> get visibleNotifications {
    if (_selectedTab == 1) {
      return _notifications
          .where((item) => item.unread)
          .toList();
    }

    return _notifications;
  }

  int get unreadCount {
    return _notifications
        .where((item) => item.unread)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020817),
      body: CareBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTabs(),
              Expanded(
                child: visibleNotifications.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        physics:
                            const BouncingScrollPhysics(),
                        padding:
                            const EdgeInsets.fromLTRB(
                          16,
                          12,
                          16,
                          30,
                        ),
                        itemCount:
                            visibleNotifications.length,
                        itemBuilder: (
                          context,
                          index,
                        ) {
                          return _buildNotificationCard(
                            visibleNotifications[index],
                          );
                        },
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
        14,
        12,
        14,
        8,
      ),
      child: Row(
        children: [
          _iconButton(
            Icons.arrow_back_rounded,
            () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Stay updated with your Care+ journey',
                  style: TextStyle(
                    color: Color(0x88FFFFFF),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: const Text(
                'Mark all read',
                style: TextStyle(
                  color: Color(0xFF70E8FF),
                  fontSize: 11,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 5,
      ),
      child: Row(
        children: [
          _buildTab(
            'All',
            0,
          ),
          _buildTab(
            'Unread',
            1,
          ),
        ],
      ),
    );
  }

  Widget _buildTab(
    String title,
    int index,
  ) {
    final selected = _selectedTab == index;

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
          margin:
              const EdgeInsets.symmetric(horizontal: 4),
          padding:
              const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF1687FF)
                : Colors.white.withValues(
                    alpha: 0.05,
                  ),
            borderRadius:
                BorderRadius.circular(14),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected
                  ? Colors.white
                  : Colors.white60,
              fontSize: 13,
              fontWeight: selected
                  ? FontWeight.bold
                  : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    _AppNotification notification,
  ) {
    return GestureDetector(
      onTap: () {
        _markRead(notification);
        _showNotificationDetails(
          notification,
        );
      },
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 180),
        margin:
            const EdgeInsets.only(bottom: 11),
        padding:
            const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: notification.unread
              ? const Color(0xFF123866)
                  .withValues(alpha: 0.42)
              : Colors.white.withValues(
                  alpha: 0.045,
                ),
          borderRadius:
              BorderRadius.circular(18),
          border: Border.all(
            color: notification.unread
                ? notification.color.withValues(
                    alpha: 0.20,
                  )
                : Colors.white.withValues(
                    alpha: 0.07,
                  ),
          ),
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: 47,
              height: 47,
              decoration: BoxDecoration(
                color: notification.color
                    .withValues(alpha: 0.10),
                borderRadius:
                    BorderRadius.circular(14),
              ),
              child: Icon(
                notification.icon,
                color: notification.color,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                      if (notification.unread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration:
                              const BoxDecoration(
                            color:
                                Color(0xFF70E8FF),
                            shape:
                                BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    notification.message,
                    style: const TextStyle(
                      color: Color(0x99FFFFFF),
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    notification.time,
                    style: TextStyle(
                      color:
                          notification.color,
                      fontSize: 10,
                      fontWeight:
                          FontWeight.w600,
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF70E8FF)
                    .withValues(alpha: 0.05),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0x5570E8FF),
                size: 55,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'All Caught Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'You have no unread notifications.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.white.withValues(
        alpha: 0.06,
      ),
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

  void _markRead(
    _AppNotification notification,
  ) {
    if (!notification.unread) {
      return;
    }

    setState(() {
      notification.unread = false;
    });
  }

  void _markAllRead() {
    setState(() {
      for (final notification in _notifications) {
        notification.unread = false;
      }
    });

    _showMessage(
      'All notifications marked as read.',
    );
  }

  void _showNotificationDetails(
    _AppNotification notification,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF07152C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
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
                const SizedBox(height: 22),
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: notification.color
                        .withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    notification.icon,
                    color: notification.color,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  notification.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  notification.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 10,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  notification.time,
                  style: TextStyle(
                    color: notification.color,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF147DFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'DONE',
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

  void _showMessage(String message) {
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
                BorderRadius.circular(14),
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 11,
            ),
          ),
        ),
      );
  }
}

class _AppNotification {
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color color;
  bool unread;

  _AppNotification({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.color,
    required this.unread,
  });
}