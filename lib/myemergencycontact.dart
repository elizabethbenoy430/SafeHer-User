import 'package:flutter/material.dart';
import 'package:user_app/addemergencycontact.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class MyEmergencyContact extends StatefulWidget {
  MyEmergencyContact({super.key});
  dynamic contactList = [];
  bool isLoading = true;

  @override
  State<MyEmergencyContact> createState() => _MyEmergencyContactState();
}

class _MyEmergencyContactState extends State<MyEmergencyContact> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchemergencycontacts();
  }

  Future<void> fetchemergencycontacts() async {
    try {
      final response = await supabase
          .from('tbl_emergencycontact')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id);

      setState(() {
        widget.contactList = response;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching contacts: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Emergency Contacts",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: widget.contactList.length,
                    itemBuilder: (context, index) {
                      final person = widget.contactList[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.redAccent,
                              child: Text(
                                person['emergencycontact_name'][0],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    person['emergencycontact_name'],
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "📞 ${person['emergencycontact_number']}",
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                  Text(
                                    "👥 ${person['emergencycontact_relation']}",
                                    style: const TextStyle(color: Colors.white54),
                                  ),
                                ],
                              ),
                            ),

                            IconButton(
                              icon: const Icon(Icons.call, color: Colors.greenAccent),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // ✅ Bottom Add Button
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        "Add Emergency Contact",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmergencyContact()),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}