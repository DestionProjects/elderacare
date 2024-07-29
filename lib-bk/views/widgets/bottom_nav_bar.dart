// import 'package:elderacare/views/screens/scan_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:iconly/iconly.dart';

// class CustomBottomNavBar extends StatefulWidget {
//   @override
//   _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
// }

// class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
//   int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     if (index == 2) {
//       // Navigate to DeviceScanningScreen when "Add" is tapped
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => ScanScreen(
//                   onDeviceSelected: (BluetoothDevice) {},
//                 )),
//       );
//     } else {
//       setState(() {
//         _selectedIndex = index;
//       });
//       // Handle navigation or other actions based on the selected index
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       useLegacyColorScheme: false,
//       backgroundColor: Colors.black,
//       type: BottomNavigationBarType.fixed,
//       currentIndex: _selectedIndex,
//       onTap: _onItemTapped,
//       items: [
//         BottomNavigationBarItem(
//           icon: Icon(IconlyBroken.home),
//           activeIcon: Icon(IconlyBold.home),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(IconlyBroken.search),
//           activeIcon: Icon(IconlyBold.search),
//           label: 'Search',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(IconlyBroken.plus),
//           activeIcon: Icon(IconlyBold.plus),
//           label: 'Add',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(IconlyBroken.heart),
//           activeIcon: Icon(IconlyBold.heart),
//           label: 'Activity',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(IconlyBroken.profile),
//           activeIcon: Icon(IconlyBold.profile),
//           label: 'Profile',
//         ),
//       ],
//       selectedItemColor: Colors.white,
//       unselectedItemColor: Colors.grey,
//       showSelectedLabels: false,
//       showUnselectedLabels: false,
//     );
//   }
// }
