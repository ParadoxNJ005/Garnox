import 'package:flutter/material.dart';
import '../database/Apis.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true; // To show the loading spinner
  bool hasError = false; // To handle any errors during fetch

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  // Fetch notifications from API
  Future<void> _fetchNotifications() async {
    try {
      List<Map<String, dynamic>> fetchedNotifications = await APIs.fetchNotifications();
      setState(() {
        notifications = fetchedNotifications;
        isLoading = false; // Set loading to false once the data is fetched
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true; // Handle any error
      });
    }
  }

  // Function to format the time from IST
  String _formatTime(String timeString) {
    DateTime dateTime = DateTime.parse(timeString);
    DateTime istTime = dateTime.add(Duration(hours: 5, minutes: 30));
    return timeago.format(istTime); // Show time like "3 hours ago"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold),),
        centerTitle: false,
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back , color: Colors.black,)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show a loading spinner while fetching
          : hasError
          ? const Center(child: Text('Error fetching notifications. Try again later.'))
          : notifications.isEmpty
          ? const Center(child: Text('No Notifications'))
          : RefreshIndicator(
        onRefresh: _fetchNotifications, // Pull to refresh
        child: Padding(
          padding: const EdgeInsets.only(top :25.0),
          child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4, // Add some shadow for better depth
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                child: ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.blue, size: 32),
                  title: Text(
                    notification['title'] ?? 'Sem Breaker',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      notification['body'] ?? '',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  trailing: Text(
                    _formatTime(notification['time'] ?? ''),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  onTap: () {
                    // Handle notification tap if needed
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
