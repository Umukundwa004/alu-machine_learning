import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data_provider.dart';
import '../models/models.dart';
import 'package:uuid/uuid.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2C5A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2C5A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Assignments',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: const Color(0xFF1A2C5A),
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFFFFB800),
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Formative'),
                Tab(text: 'Summative'),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, child) {
          final assignments = [...dataProvider.assignments];
          assignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));

          return Column(
            children: [
              const SizedBox(height: 16),
              // Create Group Assignment Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showAddAssignmentDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB800),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Create Group Assignment',
                      style: TextStyle(
                        color: Color(0xFF1A2C5A),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Assignments list
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAssignmentList(assignments),
                    _buildAssignmentList(
                      assignments.where((a) => a.priority == 'High').toList(),
                    ),
                    _buildAssignmentList(
                      assignments.where((a) => a.priority == 'Low').toList(),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAssignmentList(List<Assignment> assignments) {
    if (assignments.isEmpty) {
      return const Center(
        child: Text(
          'No assignments',
          style: TextStyle(color: Colors.white54, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: assignments.length,
      itemBuilder: (context, index) {
        final assignment = assignments[index];
        final dataProvider = Provider.of<DataProvider>(context, listen: false);
        return _buildAssignmentItem(context, assignment, dataProvider);
      },
    );
  }

  Widget _buildAssignmentItem(
    BuildContext context,
    Assignment assignment,
    DataProvider dataProvider,
  ) {
    final now = DateTime.now();
    final daysUntilDue = assignment.dueDate.difference(now).inDays;
    final isOverdue = daysUntilDue < 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: isOverdue
                ? const Color(0xFFE53935)
                : const Color(0xFFFFB800),
            width: 4,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: GestureDetector(
          onTap: () {
            dataProvider.toggleAssignmentStatus(assignment.id);
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: assignment.isCompleted
                    ? const Color(0xFF4CAF50)
                    : Colors.grey,
                width: 2,
              ),
              color: assignment.isCompleted
                  ? const Color(0xFF4CAF50)
                  : Colors.transparent,
            ),
            child: Icon(
              Icons.check,
              color: assignment.isCompleted ? Colors.white : Colors.transparent,
              size: 16,
            ),
          ),
        ),
        title: Text(
          assignment.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A2C5A),
            decoration: assignment.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              assignment.course,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(
                      assignment.priority,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    assignment.priority,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _getPriorityColor(assignment.priority),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Due: ${assignment.dueDate.day}/${assignment.dueDate.month}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isOverdue ? const Color(0xFFE53935) : Colors.grey,
                    fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: () {
                Future.delayed(
                  const Duration(milliseconds: 100),
                  () => _showEditAssignmentDialog(context, assignment),
                );
              },
              child: const Row(
                children: [
                  Icon(Icons.edit, size: 18, color: Color(0xFF1A2C5A)),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              onTap: () {
                final dataProvider = Provider.of<DataProvider>(
                  context,
                  listen: false,
                );
                dataProvider.deleteAssignment(assignment.id);
              },
              child: const Row(
                children: [
                  Icon(Icons.delete, size: 18, color: Color(0xFFE53935)),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAssignmentDialog(BuildContext context) {
    String title = '';
    String course = '';
    String priority = 'Medium';
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Assignment'),
              backgroundColor: Colors.white,
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Assignment Title *',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => title = value,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Course Name *',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => course = value,
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (pickedDate != null) {
                          setState(() => selectedDate = pickedDate);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Due Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField(
                      value: priority,
                      items: ['High', 'Medium', 'Low']
                          .map(
                            (p) => DropdownMenuItem(value: p, child: Text(p)),
                          )
                          .toList(),
                      onChanged: (value) => priority = value!,
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB800),
                  ),
                  onPressed: () {
                    if (title.isEmpty || course.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all required fields'),
                        ),
                      );
                      return;
                    }
                    final dataProvider = Provider.of<DataProvider>(
                      context,
                      listen: false,
                    );
                    dataProvider.addAssignment(
                      Assignment(
                        id: const Uuid().v4(),
                        title: title,
                        course: course,
                        dueDate: selectedDate,
                        priority: priority,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Color(0xFF1A2C5A)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditAssignmentDialog(BuildContext context, Assignment assignment) {
    String title = assignment.title;
    String course = assignment.course;
    String priority = assignment.priority;
    DateTime selectedDate = assignment.dueDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Assignment'),
              backgroundColor: Colors.white,
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: TextEditingController(text: title),
                      decoration: const InputDecoration(
                        labelText: 'Assignment Title *',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => title = value,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: TextEditingController(text: course),
                      decoration: const InputDecoration(
                        labelText: 'Course Name *',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => course = value,
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (pickedDate != null) {
                          setState(() => selectedDate = pickedDate);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Due Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField(
                      value: priority,
                      items: ['High', 'Medium', 'Low']
                          .map(
                            (p) => DropdownMenuItem(value: p, child: Text(p)),
                          )
                          .toList(),
                      onChanged: (value) => priority = value!,
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB800),
                  ),
                  onPressed: () {
                    if (title.isEmpty || course.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all required fields'),
                        ),
                      );
                      return;
                    }
                    final dataProvider = Provider.of<DataProvider>(
                      context,
                      listen: false,
                    );
                    dataProvider.updateAssignment(
                      assignment.id,
                      Assignment(
                        id: assignment.id,
                        title: title,
                        course: course,
                        dueDate: selectedDate,
                        priority: priority,
                        isCompleted: assignment.isCompleted,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Color(0xFF1A2C5A)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return const Color(0xFFE53935);
      case 'Medium':
        return const Color(0xFFFFB800);
      case 'Low':
        return const Color(0xFF4CAF50);
      default:
        return Colors.grey;
    }
  }
}
