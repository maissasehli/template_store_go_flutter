import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_constants.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  // Profile Header Section - Updated to match new design
                  _buildProfileHeaderSimple(),
                  const SizedBox(height: 24),
                  // Menu Options
                  _buildMenuOptions(),
                ],
              ),
            ),
          ),
        ),
      );
  }

  // Simple profile header matching the new screenshots
  Widget _buildProfileHeaderSimple() {
    return Column(
      children: [
        // Profile Image
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.asset(
              'assets/images/profile_avatar.png', // Replace with actual image path
              width: 100.87,
              height: 100.87,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // User Name and Username
        const Center(
          child: Text(
            'Keira Knightley',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        const Center(
          child: Text(
            '@keirakn',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        const SizedBox(height: 12),
        // User Details with Edit Button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gilbert Jones',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Gabarito',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/edit-profile');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      minimumSize: const Size(0, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(66.3),
                      ),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Gilbertjones001@gmail.com',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '121-224-7890',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuOptions() {
    return Column(
      children: [
        _buildMenuOption(
          icon: ImageAsset.location,
          title: 'Address',
          onTap: () => Get.toNamed('/address'),
        ),
        _buildMenuOption(
          icon: ImageAsset.receipt,
          title: 'My orders',
          onTap: () => Get.toNamed('/orders'),
        ),
        _buildMenuOption(
          icon: ImageAsset.receipt,
          title: 'Payments',
          onTap: () => Get.toNamed('/payments'),
        ),
        _buildMenuOption(
          icon: ImageAsset.notification,
          title: 'Notifications',
          onTap: () => Get.toNamed('/notifications'),
        ),
        _buildMenuOption(
          icon: ImageAsset.setting,
          title: 'Settings',
          onTap: () => Get.toNamed('/settings'),
        ),
        _buildMenuOption(
          icon: ImageAsset.Logout,
          title: 'Logout',
          onTap: () => _showLogoutDialog(),
        ),
      ],
    );
  }

  Widget _buildMenuOption({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: SvgPicture.asset(
          icon,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(Colors.grey[700]!, BlendMode.srcIn),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.black),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              // Implement logout functionality
              Get.offAllNamed('/login');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
