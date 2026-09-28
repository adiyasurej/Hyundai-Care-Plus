import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../widgets/care_background.dart';

class MaintenanceRemindersScreen extends StatefulWidget {
  final int? customerId;

  const MaintenanceRemindersScreen({
    super.key,
    this.customerId,
  });

  @override
  State<MaintenanceRemindersScreen> createState() =>
      _MaintenanceRemindersScreenState();
}

class _MaintenanceRemindersScreenState
    extends State<MaintenanceRemindersScreen>
    with TickerProviderStateMixin {
  late final AnimationController auroraController;
  late final AnimationController entranceController;

  final List<MaintenanceTask> tasks = [
    MaintenanceTask(
      id: 'M01',
      title: 'Brake Inspection',
      subtitle: 'Inspect brake pads and brake fluid',
      due: 'Due in 12 days',
      date: '07 Sep 2026',
      priority: 'Important',
      icon: Icons.speed_rounded,
      color: Color(0xFFFFC857),
      completed: false,
    ),
    MaintenanceTask(
      id: 'M02',
      title: 'Engine Oil Change',
      subtitle: 'Replace engine oil and inspect oil filter',
      due: 'Due in 28 days',
      date: '23 Sep 2026',
      priority: 'Upcoming',
      icon: Icons.opacity_rounded,
      color: Color(0xFF70E8FF),
      completed: false,
    ),
    MaintenanceTask(
      id: 'M03',
      title: 'Tyre Rotation',
      subtitle: 'Rotate and inspect all four tyres',
      due: 'Due in 42 days',
      date: '07 Oct 2026',
      priority: 'Upcoming',
      icon: Icons.tire_repair_rounded,
      color: Color(0xFF70E8FF),
      completed: false,
    ),
    MaintenanceTask(
      id: 'M04',
      title: 'Air Filter',
      subtitle: 'Check and replace engine air filter',
      due: 'Completed',
      date: '18 Aug 2026',
      priority: 'Completed',
      icon: Icons.air_rounded,
      color: Color(0xFF7BFFB2),
      completed: true,
    ),
    MaintenanceTask(
      id: 'M05',
      title: 'Battery Check',
      subtitle: 'Inspect battery voltage and terminals',
      due: 'Completed',
      date: '10 Aug 2026',
      priority: 'Completed',
      icon: Icons.battery_charging_full_rounded,
      color: Color(0xFF7BFFB2),
      completed: true,
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

  int get completedCount =>
      tasks.where((task) => task.completed).length;

  int get pendingCount =>
      tasks.where((task) => !task.completed).length;

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
                painter: _MaintenanceAuroraPainter(
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
                  _buildOverview(),
                ),
                const SizedBox(height: 17),
                _animated(
                  1,
                  _buildNextService(),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Text(
                      'Maintenance Schedule',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$pendingCount upcoming',
                      style: const TextStyle(
                        color: Colors.white30,
                        fontSize: 7,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  tasks.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 11,
                      ),
                      child: _animated(
                        index + 2,
                        _maintenanceCard(
                          tasks[index],
                          index,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                _animated(
                  9,
                  _buildAddReminder(),
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
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Maintenance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Stay ahead of every service',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          _circleButton(
            Icons.add_alert_rounded,
            _addCustomReminder,
          ),
        ],
      ),
    );
  }

  Widget _buildOverview() {
    final progress =
        tasks.isEmpty ? 0.0 : completedCount / tasks.length;

    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF102E50),
            Color(0xFF201B4D),
            Color(0xFF093A41),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFF70E8FF).withValues(
            alpha: 0.12,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.event_note_rounded,
                color: Color(0xFF70E8FF),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'CARE+ MAINTENANCE PLAN',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 6.5,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Icon(
                Icons.verified_rounded,
                color: Color(0xFF7BFFB2),
                size: 17,
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Your vehicle is on track',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Keep your Hyundai healthy with timely maintenance.',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 7.5,
            ),
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    backgroundColor:
                        Colors.white.withValues(
                      alpha: 0.07,
                    ),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(
                      Color(0xFF70E8FF),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  color: Color(0xFF70E8FF),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              Expanded(
                child: _overviewStat(
                  Icons.pending_actions_rounded,
                  '$pendingCount',
                  'Upcoming',
                ),
              ),
              Expanded(
                child: _overviewStat(
                  Icons.check_circle_outline_rounded,
                  '$completedCount',
                  'Completed',
                ),
              ),
              Expanded(
                child: _overviewStat(
                  Icons.notifications_active_rounded,
                  'ON',
                  'Reminders',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _overviewStat(
    IconData icon,
    String value,
    String title,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF70E8FF),
          size: 17,
        ),
        const SizedBox(width: 7),
        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white30,
                fontSize: 5.5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNextService() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFC857).withValues(
          alpha: 0.045,
        ),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: const Color(0xFFFFC857).withValues(
            alpha: 0.12,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFC857).withValues(
                alpha: 0.08,
              ),
            ),
            child: const Icon(
              Icons.schedule_rounded,
              color: Color(0xFFFFC857),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Next recommended service',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Brake inspection • 07 Sep 2026',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 7,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showMessage(
                'Service booking opened.',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFF147DFF),
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              minimumSize:
                  const Size(0, 34),
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'BOOK',
              style: TextStyle(
                fontSize: 6.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _maintenanceCard(
    MaintenanceTask task,
    int index,
  ) {
    final completed = task.completed;

    return Dismissible(
      key: ValueKey(task.id),
      direction:
          DismissDirection.endToStart,
      confirmDismiss: (_) async {
        if (completed) {
          return false;
        }

        setState(() {
          tasks[index] =
              task.copyWith(completed: true);
        });

        showMessage(
          '${task.title} marked as completed.',
        );

        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding:
            const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color:
              const Color(0xFF7BFFB2)
                  .withValues(alpha: 0.08),
          borderRadius:
              BorderRadius.circular(19),
        ),
        child: const Icon(
          Icons.check_circle_rounded,
          color: Color(0xFF7BFFB2),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          _showReminderDetails(task);
        },
        child: AnimatedContainer(
          duration:
              const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: completed
                ? const Color(0xFF7BFFB2)
                    .withValues(alpha: 0.025)
                : Colors.white.withValues(
                    alpha: 0.04,
                  ),
            borderRadius:
                BorderRadius.circular(19),
            border: Border.all(
              color: completed
                  ? const Color(0xFF7BFFB2)
                      .withValues(alpha: 0.09)
                  : Colors.white.withValues(
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
                  borderRadius:
                      BorderRadius.circular(14),
                  color: task.color.withValues(
                    alpha: 0.055,
                  ),
                ),
                child: Icon(
                  task.icon,
                  color: task.color,
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
                            task.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight:
                                  FontWeight.bold,
                              decoration: completed
                                  ? TextDecoration
                                      .lineThrough
                                  : null,
                              decorationColor:
                                  Colors.white38,
                            ),
                          ),
                        ),
                        _priorityBadge(task),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      task.subtitle,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 6.8,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Icon(
                          completed
                              ? Icons
                                  .check_circle_outline_rounded
                              : Icons
                                  .calendar_today_outlined,
                          color: task.color,
                          size: 12,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          task.due,
                          style: TextStyle(
                            color: task.color,
                            fontSize: 6.5,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0x33FFFFFF),
                size: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priorityBadge(
    MaintenanceTask task,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: task.color.withValues(
          alpha: 0.07,
        ),
        borderRadius:
            BorderRadius.circular(7),
      ),
      child: Text(
        task.priority.toUpperCase(),
        style: TextStyle(
          color: task.color,
          fontSize: 5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAddReminder() {
    return GestureDetector(
      onTap: _addCustomReminder,
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color:
              const Color(0xFF70E8FF)
                  .withValues(alpha: 0.025),
          borderRadius:
              BorderRadius.circular(19),
          border: Border.all(
            color:
                const Color(0xFF70E8FF)
                    .withValues(alpha: 0.10),
          ),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.add_alarm_rounded,
              color: Color(0xFF70E8FF),
              size: 23,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create custom reminder',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Set a personal maintenance reminder for your vehicle.',
                    style: TextStyle(
                      color: Colors.white30,
                      fontSize: 6.8,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white24,
              size: 10,
            ),
          ],
        ),
      ),
    );
  }

  void _showReminderDetails(
    MaintenanceTask task,
  ) {
    showModalBottomSheet<void>(
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
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(17),
                        color:
                            task.color.withValues(
                          alpha: 0.07,
                        ),
                      ),
                      child: Icon(
                        task.icon,
                        color: task.color,
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
                            task.title,
                            style:
                                const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            task.priority,
                            style: TextStyle(
                              color: task.color,
                              fontSize: 8,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _detailRow(
                  Icons.description_outlined,
                  'Description',
                  task.subtitle,
                ),
                _detailRow(
                  Icons.calendar_month_outlined,
                  'Scheduled Date',
                  task.date,
                ),
                _detailRow(
                  Icons.notifications_active_outlined,
                  'Reminder',
                  task.completed
                      ? 'Completed'
                      : 'Enabled',
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                          _editReminder(task);
                        },
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 16,
                        ),
                        label: const Text(
                          'EDIT',
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
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(sheetContext);

                          if (!task.completed) {
                            final index =
                                tasks.indexOf(task);

                            if (index >= 0) {
                              setState(() {
                                tasks[index] =
                                    task.copyWith(
                                  completed: true,
                                );
                              });
                            }
                          }

                          showMessage(
                            'Reminder updated.',
                          );
                        },
                        icon: Icon(
                          task.completed
                              ? Icons
                                  .check_circle_outline_rounded
                              : Icons
                                  .check_rounded,
                          size: 16,
                        ),
                        label: Text(
                          task.completed
                              ? 'COMPLETED'
                              : 'MARK DONE',
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
                                BorderRadius.circular(14),
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
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color:
            Colors.white.withValues(alpha: 0.035),
        borderRadius:
            BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF70E8FF),
            size: 17,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 8,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow:
                  TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addCustomReminder() {
    final controller =
        TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              const Color(0xFF07152C),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(22),
          ),
          title: const Text(
            'Create Reminder',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText:
                  'e.g. Check tyre pressure',
              hintStyle: const TextStyle(
                color: Colors.white24,
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
                controller.dispose();
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
                final title =
                    controller.text.trim();

                if (title.isEmpty) {
                  return;
                }

                setState(() {
                  tasks.insert(
                    0,
                    MaintenanceTask(
                      id:
                          'CUSTOM-${DateTime.now().millisecondsSinceEpoch}',
                      title: title,
                      subtitle:
                          'Personal vehicle maintenance reminder',
                      due: 'Custom reminder',
                      date: 'Not scheduled',
                      priority: 'Personal',
                      icon:
                          Icons.notifications_active_rounded,
                      color:
                          const Color(0xFFB28CFF),
                      completed: false,
                    ),
                  );
                });

                controller.dispose();
                Navigator.pop(dialogContext);

                showMessage(
                  'Custom reminder created.',
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
                'CREATE',
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

  void _editReminder(
    MaintenanceTask task,
  ) {
    final controller =
        TextEditingController(
      text: task.title,
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              const Color(0xFF07152C),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(22),
          ),
          title: const Text(
            'Edit Reminder',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              labelText: 'Reminder',
              labelStyle: const TextStyle(
                color: Colors.white38,
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
                controller.dispose();
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
                final newTitle =
                    controller.text.trim();

                if (newTitle.isEmpty) {
                  return;
                }

                final index =
                    tasks.indexOf(task);

                if (index >= 0) {
                  setState(() {
                    tasks[index] =
                        task.copyWith(
                      title: newTitle,
                    );
                  });
                }

                controller.dispose();
                Navigator.pop(dialogContext);

                showMessage(
                  'Reminder updated.',
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
                'SAVE',
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

  void showMessage(
    String message,
  ) {
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
      builder: (context, child) {
        final delay =
            (index * 0.035).clamp(0.0, 0.8);

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

class MaintenanceTask {
  final String id;
  final String title;
  final String subtitle;
  final String due;
  final String date;
  final String priority;
  final IconData icon;
  final Color color;
  final bool completed;

  const MaintenanceTask({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.due,
    required this.date,
    required this.priority,
    required this.icon,
    required this.color,
    required this.completed,
  });

  MaintenanceTask copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? due,
    String? date,
    String? priority,
    IconData? icon,
    Color? color,
    bool? completed,
  }) {
    return MaintenanceTask(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      due: due ?? this.due,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      completed: completed ?? this.completed,
    );
  }
}

class _MaintenanceAuroraPainter
    extends CustomPainter {
  final double progress;

  const _MaintenanceAuroraPainter({
    required this.progress,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint();
    final t = progress * math.pi * 2;

    final cyanCenter = Offset(
      size.width *
          (0.18 + math.sin(t) * 0.12),
      size.height *
          (0.18 + math.cos(t) * 0.06),
    );

    paint.shader = RadialGradient(
      colors: [
        const Color(0xFF00E5FF)
            .withValues(alpha: 0.075),
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
        const Color(0xFF8C5CFF)
            .withValues(alpha: 0.065),
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
      final x =
          random.nextDouble() * size.width;
      final y =
          random.nextDouble() * size.height;

      final opacity =
          0.15 +
          ((math.sin(t + i) + 1) / 2) * 0.4;

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
    covariant _MaintenanceAuroraPainter
        oldDelegate,
  ) {
    return oldDelegate.progress !=
        progress;
  }
}