import 'package:flutter/material.dart';
import '../models/facility.dart';

class BookingScreen extends StatefulWidget {
  final Facility facility;

  const BookingScreen({super.key, required this.facility});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _selectedDate;
  String? _selectedService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đặt Lịch Hẹn')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cơ sở: ${widget.facility.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Text('Chọn dịch vụ'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: widget.facility.services.map((s) => DropdownMenuItem<String>(
                value: s['name'],
                child: Text('${s['name']} - ${s['price']} VND'),
              )).toList(),
              onChanged: (val) => setState(() => _selectedService = val),
            ),
            const SizedBox(height: 24),
            const Text('Chọn ngày'),
            const SizedBox(height: 8),
            ListTile(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              title: Text(_selectedDate == null ? 'Chưa chọn' : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
            ),
            const SizedBox(height: 24),
            const Text('Thú cưng'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'Miu', child: Text('Miu - Mèo Anh')),
              ],
              onChanged: (val) {},
            ),
            const SizedBox(height: 24),
            const Text('Ghi chú'),
            const SizedBox(height: 8),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedService == null || _selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vui lòng chọn đầy đủ dịch vụ và ngày!')),
                    );
                    return;
                  }
                  // Xử lý lưu Firestore
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đặt lịch thành công!')),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('XÁC NHẬN ĐẶT LỊCH'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
