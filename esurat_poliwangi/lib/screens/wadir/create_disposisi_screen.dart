// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:esurat_poliwangi/services/surat_disposisi_service.dart';
import 'package:intl/intl.dart';

class CreateDisposisiScreen extends StatefulWidget {
  const CreateDisposisiScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateDisposisiScreenState createState() => _CreateDisposisiScreenState();
}

class _CreateDisposisiScreenState extends State<CreateDisposisiScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _indukController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();
  final TextEditingController _disposisiSingkatController =
      TextEditingController();
  final TextEditingController _disposisiNarasiController =
      TextEditingController();

  String? _suratMasukId;
  String? _userId;

  @override
  void dispose() {
    _indukController.dispose();
    _waktuController.dispose();
    _disposisiSingkatController.dispose();
    _disposisiNarasiController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
      );
      if (pickedTime != null) {
        final DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        _waktuController.text =
            DateFormat('yyyy-MM-ddTHH:mm').format(finalDateTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final suratDisposisiService = Provider.of<SuratDisposisiService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Disposisi'),
      ),
      body: FutureBuilder(
        future: Future.wait([
          suratDisposisiService.getSuratMasuk(),
          suratDisposisiService.getUsers(),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final suratMasukList =
              snapshot.data![0] as List<Map<String, dynamic>>;
          final usersList = snapshot.data![1] as List<Map<String, dynamic>>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                children: [
                  _buildDropdownField(
                    label: 'Pilih Surat Masuk',
                    hintText: 'Pilih surat masuk yang akan didisposisi',
                    items: suratMasukList,
                    value: _suratMasukId,
                    onChanged: (value) {
                      setState(() {
                        _suratMasukId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select Surat Masuk';
                      }
                      return null;
                    },
                    isUserDropdown: false,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    label: 'Disposisi kepada',
                    hintText: 'Pilih user yang akan menerima disposisi',
                    items: usersList,
                    value: _userId,
                    onChanged: (value) {
                      setState(() {
                        _userId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select User';
                      }
                      return null;
                    },
                    isUserDropdown: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _indukController,
                    label: 'Induk',
                    hintText: 'Tulis induk disposisi',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Induk';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _selectDateTime(context),
                    child: IgnorePointer(
                      child: _buildTextField(
                        controller: _waktuController,
                        label: 'Waktu',
                        hintText: 'dd/MM/yyyy HH:mm',
                        keyboardType: TextInputType.datetime,
                        suffixIcon: Icons.calendar_today,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Waktu';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _disposisiSingkatController,
                    label: 'Disposisi Singkat',
                    hintText: 'Tulis disposisi singkat',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Disposisi Singkat';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _disposisiNarasiController,
                    label: 'Disposisi Narasi',
                    hintText: 'Tulis narasi disposisi',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Disposisi Narasi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await suratDisposisiService.createSuratDisposisi({
                          'surat_masuk_id': _suratMasukId,
                          'user_id': _userId,
                          'induk': _indukController.text,
                          'waktu': _waktuController.text,
                          'disposisi_singkat': _disposisiSingkatController.text,
                          'disposisi_narasi': _disposisiNarasiController.text,
                        });

                        setState(() {
                          _suratMasukId = null;
                          _userId = null;
                          _indukController.clear();
                          _waktuController.clear();
                          _disposisiSingkatController.clear();
                          _disposisiNarasiController.clear();
                        });

                        showSnackBar(context, 'Disposisi berhasil dibuat');
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hintText,
    required List<Map<String, dynamic>> items,
    required String? value,
    required Function(String?) onChanged,
    required String? Function(String?)? validator,
    bool isUserDropdown = false,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item['id'].toString(),
          child: isUserDropdown ? Text(item['name']) : Text(item['perihal']),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    IconData? suffixIcon,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}
