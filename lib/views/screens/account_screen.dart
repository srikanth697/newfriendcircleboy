import 'package:flutter/material.dart';
import '../../widgets/bottom_nav.dart';

// 👇 Import your 8 respective screens here
import '../screens/profile_gallery_screen.dart';
import '../screens/call_rate_screen.dart';
import '../screens/withdraws_screen.dart';
import '../screens/followers_screen.dart';
import '../screens/earnings_screen.dart';
import '../screens/streamers_screen.dart';
import '../screens/support_service_screen.dart';
import '../screens/settings_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isOnline = false;

  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.person, 'label': 'My profile & gallery'},
    {'icon': Icons.phone, 'label': 'My Call rate'},
    {'icon': Icons.work, 'label': 'My Withdraws'},
    {'icon': Icons.people, 'label': 'My Followers'},
    {'icon': Icons.monetization_on, 'label': 'My Earnings'},
    {'icon': Icons.person_add_alt_1, 'label': 'My Streamers'},
    {'icon': Icons.support_agent, 'label': 'Support Service'},
    {'icon': Icons.settings, 'label': 'Settings'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Account", style: TextStyle(color: Colors.white)),
          actions: [
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Center(
                child: Text("Online", style: TextStyle(color: Colors.white)),
              ),
            ),
            Switch(
              value: isOnline,
              onChanged: (val) => setState(() => isOnline = val),
              activeColor: Colors.green,
              inactiveTrackColor: Colors.grey.shade400,
            ),
          ],
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF00CC), Color(0xFF9A00F0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        itemCount: menuItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.pink.shade100,
              child: Icon(
                item['icon'],
                color: const Color.fromARGB(255, 233, 30, 199),
              ),
            ),
            title: Text(
              item['label'],
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProfileGalleryScreen()),
                  );
                  break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyCallRateScreen()),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyWithdrawsScreen(),
                    ),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyFollowersScreen(),
                    ),
                  );
                  break;
                case 4:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyEarningsScreen()),
                  );
                  break;
                case 5:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyStreamersScreen(),
                    ),
                  );
                  break;
                case 6:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SupportServiceScreen(),
                    ),
                  );
                  break;
                case 7:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                  break;
              }
            },
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 4),
    );
  }
}
