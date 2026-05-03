import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ Sơ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Người dùng PawMap',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text('user@example.com'),
              const SizedBox(height: 24),
              
              // Pets Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Thú cưng của tôi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Thêm'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildPetCard('Miu', 'Mèo Anh Lông Ngắn', Icons.pets),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Menu Items
              _buildMenuItem(Icons.favorite, 'Danh sách yêu thích'),
              _buildMenuItem(Icons.star, 'Đánh giá của tôi'),
              _buildMenuItem(Icons.article, 'Cẩm nang chăm sóc'),
              _buildMenuItem(Icons.help, 'Hỗ trợ & Góp ý'),
              _buildMenuItem(Icons.logout, 'Đăng xuất', color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetCard(String name, String breed, IconData icon) {
    return Card(
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.orange[100],
              child: Icon(icon, color: Colors.orange),
            ),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(breed, style: const TextStyle(fontSize: 10), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}
