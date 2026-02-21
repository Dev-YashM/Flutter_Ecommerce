import 'package:flutter/material.dart';
import 'package:mahalaxmi_coolers/core/theme/app_colors.dart';
import 'package:mahalaxmi_coolers/features/cart.dart';
import 'package:mahalaxmi_coolers/features/home.dart';
import 'package:mahalaxmi_coolers/features/orders.dart';
import 'package:mahalaxmi_coolers/features/profile.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({
    super.key,
    required this.title,
    required this.mobileNumber,
  });

  final String title;
  final String mobileNumber;

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  int selectedIndex = 0;

  late List<Widget> features;

  @override
  void initState() {
    super.initState();

    /// ✅ Now widget.mobileNumber is safe to use
    features = [
      const HomeScreen(),
      ProfileScreen(mobileNumber: widget.mobileNumber),
    ];
  }

  void navigateToIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
    Navigator.pop(context); // close drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(
          color: AppColors.surface,   // 🔥 Drawer icon color
        ),
      ),

      /// 🔥 Drawer Added
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.ac_unit,
                      size: 40,
                      color: Theme.of(context).colorScheme.surface),
                  const SizedBox(height: 10),
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.mobileNumber,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ],
              ),
            ),

            /// 🏠 Home
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () => navigateToIndex(0),
            ),

            /// 👤 Profile
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("My Profile"),
              onTap: () => navigateToIndex(1),
            ),

            const Divider(),

            /// 🛒 Cart (To Implement)
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text("My Cart"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen(),));
              },
            ),

            /// 📦 Orders (To Implement)
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text("My Orders"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyOrdersScreen(),)
                );
              },
            ),

            /// ❤️ Wishlist
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text("Wishlist"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Wishlist coming soon")),
                );
              },
            ),

            const Divider(),

            /// ⚙ Settings
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Settings coming soon")),
                );
              },
            ),

            /// 🚪 Logout
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Logout logic pending")),
                );
              },
            ),
          ],
        ),
      ),

      body: features[selectedIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        indicatorColor: Theme.of(context).colorScheme.primary,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}