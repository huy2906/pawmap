import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch Hẹn Của Tôi'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Sắp tới'),
                Tab(text: 'Lịch sử'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildUpcomingTab(),
                  _buildHistoryTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 1, // Mock count
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ngày mai, 09:00 AM',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryMintDark,
                      ),
                    ),
                    Chip(
                      label: Text('Đã xác nhận', style: TextStyle(fontSize: 12, color: AppTheme.primaryMintDark)),
                      backgroundColor: AppTheme.primaryMint,
                      side: BorderSide.none,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Phòng khám thú y PetCare',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text('Dịch vụ: Khám tổng quát cho Mèo (Miu)'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text('Hủy lịch'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Chi tiết'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistoryTab() {
    return const Center(
      child: Text('Chưa có lịch sử khám bệnh nào.'),
    );
  }
}
