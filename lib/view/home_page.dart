// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iot_smart_home/model/colors.dart';
// import 'package:iot_smart_home/services/data/const_data/const_data.dart';
// import 'package:iot_smart_home/view/widgets/combonent_container.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('My Home')),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ListView(
//           children: [
//             // Notification Section
//             Container(
//               padding: const EdgeInsets.all(15),
//               decoration: BoxDecoration(
//                 color: bacContentContainers,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Row(
//                 spacing: 10,
//                 children: [
//                   Icon(Icons.warning_amber, color: Color(0xffff7416)),
//                   Text('1 Window Open', style: TextStyle(fontSize: 18)),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Livingroom Section
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 8),
//                   child: Row(
//                     mainAxisAlignment: .spaceBetween,
//                     children: [
//                       Text(
//                         'Livingroom',
//                         style: Theme.of(context).textTheme.titleLarge,
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Get.toNamed('/livingroom');
//                         },
//                         child: Text(
//                           'View All Data',
//                           style: TextStyle(color: const Color(0xFF2196F3)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 GridView.builder(
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 8,
//                     mainAxisSpacing: 8,
//                     childAspectRatio: 2,
//                   ),
//                   itemCount: livingRoomData.length > 4
//                       ? 4
//                       : livingRoomData.length,
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   padding: const EdgeInsets.all(8),
//                   itemBuilder: (context, index) {
//                     return combonentContainer(
//                       icon: livingRoomData[index]['icon'],
//                       text: livingRoomData[index]['title'],
//                       status: livingRoomData[index]['status'],
//                       checkActive: livingRoomData[index]['checkActive'],
//                       isNormal: livingRoomData[index]['isNormal'],
//                       isActive: livingRoomData[index]['isActive'],
//                       isChecked: livingRoomData[index]['isChecked'],
//                       onTap: (state) {
                        
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),

//             const SizedBox(height: 20),

//             // Bedroom Section
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 8),
//                   child: Row(
//                     mainAxisAlignment: .spaceBetween,
//                     children: [
//                       Text(
//                         'Bedroom',
//                         style: Theme.of(context).textTheme.titleLarge,
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           // Get.toNamed('/bedroom');
//                         },
//                         child: Text(
//                           'View All Data',
//                           style: TextStyle(color: const Color(0xFF2196F3)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 GridView.builder(
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 8,
//                     mainAxisSpacing: 8,
//                     childAspectRatio: 2,
//                   ),
//                   itemCount: bedroomData.length > 4 ? 4 : bedroomData.length,
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   padding: const EdgeInsets.all(8),
//                   itemBuilder: (context, index) {
//                     return combonentContainer(
//                       icon: bedroomData[index]['icon'],
//                       text: bedroomData[index]['title'],
//                       status: bedroomData[index]['status'],
//                       checkActive: bedroomData[index]['checkActive'],
//                       isNormal: bedroomData[index]['isNormal'],
//                       isActive: bedroomData[index]['isActive'],
//                       isChecked: bedroomData[index]['isChecked'],
//                       onTap: (state) => print(state),
//                     );
//                   },
//                 ),
//               ],
//             ),

//             const SizedBox(height: 20),

//             // Kitchen Section
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 8),
//                   child: Row(
//                     mainAxisAlignment: .spaceBetween,
//                     children: [
//                       Text(
//                         'Kitchen',
//                         style: Theme.of(context).textTheme.titleLarge,
//                       ),
//                       TextButton(
//                         onPressed: () {},
//                         child: Text(
//                           'View All Data',
//                           style: TextStyle(color: const Color(0xFF2196F3)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 GridView.builder(
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 8,
//                     mainAxisSpacing: 8,
//                     childAspectRatio: 2,
//                   ),
//                   itemCount: kitchenData.length > 4 ? 4 : kitchenData.length,
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   padding: const EdgeInsets.all(8),
//                   itemBuilder: (context, index) {
//                     return combonentContainer(
//                       icon: kitchenData[index]['icon'],
//                       text: kitchenData[index]['title'],
//                       status: kitchenData[index]['status'],
//                       checkActive: kitchenData[index]['checkActive'],
//                       isNormal: kitchenData[index]['isNormal'],
//                       isActive: kitchenData[index]['isActive'],
//                       isChecked: kitchenData[index]['isChecked'],
//                       onTap: (state) => print(state),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
