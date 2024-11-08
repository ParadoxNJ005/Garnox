import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import '../components/Custom_navDrawer.dart';
import '../components/custom_helpr.dart';
import '../utils/contstants.dart';

class Classes extends StatefulWidget {
  const Classes({super.key});

  @override
  State<Classes> createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final storage = FlutterSecureStorage();
  List<Map<String, String>> _classList = [];

  @override
  void initState() {
    super.initState();
    _loadClassesForSelectedDay();
  }

  Future<void> _loadClassesForSelectedDay() async {
    log("hi ${_selectedDay?.day}");
    String? jsonString = await storage.read(key: "${_selectedDay?.day}");
    if (jsonString != null) {
      log(jsonString);
      List<dynamic> classes = jsonDecode(jsonString);
      setState(() {
        _classList = classes.map((e) => Map<String, String>.from(e)).toList();
      });
    } else {
      setState(() {
        _classList = [];
      });
    }
  }


  Future<void> _saveClassesForSelectedDay() async {
    await storage.write(
        key: "${_selectedDay!.day}", value: jsonEncode(_classList));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Plan Your Day',
          style: GoogleFonts.epilogue(
            textStyle: TextStyle(
              color: Constants.BLACK,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/svgIcons/hamburger.svg",
            color: Constants.BLACK,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              "assets/svgIcons/notification.svg",
              color: Constants.BLACK,
            ),
            onPressed: () {},
          ),
        ],
      ),
      drawer: CustomNavDrawer(),
      // floatingActionButton: FloatingActionButton(
      //
      //   backgroundColor: Colors.blue,
      //   child: Icon(Icons.add),
      // ),
      body: Column(
        children: [
          SizedBox(height: 15),
          Card(
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              calendarFormat: _calendarFormat,
              startingDayOfWeek: StartingDayOfWeek.monday,
              availableCalendarFormats: const {
                CalendarFormat.week: 'Week',
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _loadClassesForSelectedDay();
              },
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                isTodayHighlighted: true,
                selectedDecoration: BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                defaultDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                weekendDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
          Container(
            height: 45,
            width: 180,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text(
                        'Add Class',
                        style: TextStyle(color: Colors.black),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _classController,
                            decoration: InputDecoration(
                              labelText: 'Class',
                              labelStyle: TextStyle(color: Colors.black),
                              hintText: 'Enter class name',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextField(
                            controller: _durationController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Duration',
                              labelStyle: TextStyle(color: Colors.black),
                              hintText: 'Enter duration in minutes',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextField(
                            controller: _time,
                            decoration: InputDecoration(
                              labelText: 'Start time',
                              labelStyle: TextStyle(color: Colors.black),
                              hintText: 'Enter Time',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            String className = _classController.text.trim().toString();
                            String duration = _durationController.text.trim().toString();
                            String startTime = _time.text.trim().toString();

                            // if (className != null && duration.isNotEmpty && startTime.isNotEmpty) {
                            Map<String, String> mp = {
                              "className": className,
                              "duration": duration,
                              "start_time": startTime,
                            };

                            setState(() {
                              _classList.add(mp);
                            });

                            await _saveClassesForSelectedDay();
                            Dialogs.showSnackbar(context, "Class Added");

                            _classController.clear();
                            _durationController.clear();
                            _time.clear();

                            Navigator.of(context).pop();

                          },
                          child: Text(
                            'Add',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text("Add Details", style: TextStyle(color: Constants.WHITE, fontSize: 20)),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Constants.APPCOLOUR),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("My Schedule" ,style: TextStyle(fontWeight: FontWeight.bold , fontSize: 25),),
                Text("View all",style: TextStyle(fontWeight: FontWeight.bold , fontSize: 15 , color: Colors.blue),)
              ],
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: _classList.isEmpty
                ? Center(child: Text('No classes for this day'))
                : ListView.builder(
              itemCount: _classList.length,
              itemBuilder: (context, index) {
                final classData = _classList[index];
                return Dismissible(
                  key: Key(classData['className']!),
                  direction: DismissDirection.horizontal,
                  background: Container(
                    color: Colors.black26,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.black26,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) async {
                    setState(() {
                      _classList.removeAt(index);
                    });

                    // Save the updated list to storage
                    await _saveClassesForSelectedDay();
                    Dialogs.showSnackbar(context, "Class Deleted");
                  },
                  child: comp(
                    classData['className']!,
                    classData['start_time']!,
                    classData['duration']!,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget comp(String name, String time, String duration) {
    bool isChecked = false;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        //
        // decoration: BoxDecoration(
        //   // #fffdd0 background color
        //   border: Border.all(color: Colors.grey, width: 1), // Adding border
        //   borderRadius: BorderRadius.circular(8), // Border radius
        // ),
        child: Card(
          child: ListTile(
            leading: IconButton(
              icon: SvgPicture.asset(
                "assets/svgIcons/file.svg",
              ),
              onPressed: () {
                log("File icon pressed");
                // Handle file icon pressed action
              },
            ),
            title: Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold, // Text weight
                fontSize: 16, // Adjust the font size
                color: Colors.black, // Set text color
              ),
            ),
            subtitle: Text(
              "Duration: $duration hours",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            trailing: Text(
              "$time",
              style: TextStyle(
                fontWeight: FontWeight.w500, // Slightly lighter than bold
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

}
