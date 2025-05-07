import 'dart:io';

import 'package:conversio/models/chat.dart';
import 'package:conversio/providers/message_provider.dart';
import 'package:conversio/utils/textstyle.dart';
import 'package:conversio/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:conversio/views/screens/message_screen.dart';

class GroupCreationSheet extends StatefulWidget {
  final List<String> selectedUsers;

  const GroupCreationSheet({super.key, required this.selectedUsers});

  @override
  State<GroupCreationSheet> createState() => _GroupCreationSheetState();
}

class _GroupCreationSheetState extends State<GroupCreationSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _groupImage;
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _groupImage = File(pickedFile.path);
      });
    }
  }

  void _createGroup() async {
    if (_formKey.currentState!.validate()) {
      if (_groupImage == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Please select a group image')));
        return;
      }

      final chat = Chat(
        id: Uuid().v4(),
        isGroup: true,
        members: [
          context.read<MessageProvider>().currentUserId!,
          ...widget.selectedUsers,
        ],
        name: _nameController.text,
        description: _descriptionController.text,
        createdBy: context.read<MessageProvider>().currentUserId,
        createdAt: DateTime.now(),
        admins: [context.read<MessageProvider>().currentUserId!],
        imageUrl: _groupImage!.path,
      );

      // Close the modal sheet first
      Navigator.pop(context);

      try {
        final newChat = await context.read<MessageProvider>().createGChat(
          context,
          chat,
        );
        if (context.mounted) {
          context.replace(MessageScreen(chat: newChat));
        }
      } catch (e) {
        // Error is already handled in the provider
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Group Details",
                  style: kTextStyle(
                    context: context,
                    size: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          _groupImage != null ? FileImage(_groupImage!) : null,
                      child:
                          _groupImage == null
                              ? Icon(Iconsax.camera, size: 30)
                              : null,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Group Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a group name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: "Description (Optional)",
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 2,
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _createGroup,
                      child: Text("Create Group"),
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

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
