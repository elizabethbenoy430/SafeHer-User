import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_app/homepage.dart';
import 'package:user_app/userregistration.dart';

final supabase = Supabase.instance.client;

class AddCrime extends StatefulWidget {
  const AddCrime({super.key});

  @override
  State<AddCrime> createState() => _AddCrimeState();
}

class _AddCrimeState extends State<AddCrime> {
  final TextEditingController _detailsController = TextEditingController();
  bool _isLoading = false;

  Uint8List? imageBytes;
  file_picker.PlatformFile? pickedImage;

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  /// IMAGE PICKER
  Future<void> handleImagePick() async {
    file_picker.FilePickerResult? result =
        await file_picker.FilePicker.platform.pickFiles(
      type: file_picker.FileType.image,
      withData: true,
    );

    if (result == null) return;

    pickedImage = result.files.first;
    imageBytes = pickedImage!.bytes;

    debugPrint("Image picked: ${imageBytes!.length} bytes");
    setState(() {});
  }

  /// UPLOAD IMAGE TO SUPABASE
  Future<String?> photoUpload(String uid) async {
    try {
      if (imageBytes == null) return null;

      const bucketName = 'CrimeFiles';
      final String uniqueName =
          DateTime.now().millisecondsSinceEpoch.toString();
      final filePath = "crime/${uid}_$uniqueName.${pickedImage!.extension}";

      await supabase.storage.from(bucketName).uploadBinary(
            filePath,
            imageBytes!,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      return supabase.storage.from(bucketName).getPublicUrl(filePath);
    } catch (e) {
      debugPrint("Upload error: $e");
      return null;
    }
  }

  /// ADD CRIME TO DATABASE
  Future<void> addCrime() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      String? imageUrl = await photoUpload(user.id);

      await supabase.from('tbl_crime').insert({
        "crime_details": _detailsController.text,
        "crime_file": imageUrl,
        "user_id": user.id,
        "crime_date": DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Crime reported successfully")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserHome()),
        );
      }
    } catch (e) {
      print("Error adding crime: $e");
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // APP BAR
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Crime Report",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(32),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // HEADER ICON
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.report_gmailerrorred,
                      color: Color(0xFF4CAF50),
                      size: 32,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Enter Crime Information",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // CRIME DETAILS
                  TextFormField(
                    controller: _detailsController,
                    maxLines: 5,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Crime Details",
                      labelStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(
                        Icons.description_outlined,
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1E1E1E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // FILE PICKER
                  GestureDetector(
                    onTap: handleImagePick,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            imageBytes == null ? Icons.upload_file : Icons.image,
                            color: const Color(0xFF4CAF50),
                            size: 40,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            imageBytes == null
                                ? "Tap to Upload Evidence File"
                                : "File Selected",
                            style: const TextStyle(color: Colors.white),
                          ),
                          if (imageBytes != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Image.memory(
                                imageBytes!,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ADD BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading
                          ? null
                          : () {
                              if (_detailsController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Enter crime details")),
                                );
                                return;
                              }
                              addCrime();
                            },
                      icon: const Icon(Icons.add_circle_outline,
                          color: Colors.black),
                      label: _isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text(
                              "ADD",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}