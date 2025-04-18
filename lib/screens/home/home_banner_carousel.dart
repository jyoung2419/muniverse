// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/event/event_provider.dart';
// import 'home_banner.dart';
//
// class HomeBannerCarousel extends StatefulWidget {
//   const HomeBannerCarousel({super.key});
//
//   @override
//   State<HomeBannerCarousel> createState() => _HomeBannerCarouselState();
// }
//
// class _HomeBannerCarouselState extends State<HomeBannerCarousel> {
//   final PageController _pageController = PageController(initialPage: 0);
//   Timer? _timer;
//   int _currentIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
//       if (_pageController.hasClients) {
//         final nextPage = _pageController.page!.toInt() + 1;
//         _pageController.animateToPage(
//           nextPage,
//           duration: const Duration(milliseconds: 500),
//           curve: Curves.easeInOut,
//         );
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final eventList = Provider.of<EventProvider>(context).events;
//
//     if (eventList.isEmpty) {
//       return const SizedBox(height: 200, child: Center(child: Text('이벤트 없음', style: TextStyle(color: Colors.white))));
//     }
//
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.48,
//       child: Stack(
//         children: [
//           PageView.builder(
//             controller: _pageController,
//             onPageChanged: (index) {
//               setState(() {
//                 _currentIndex = index % eventList.length;
//               });
//             },
//             itemBuilder: (context, index) {
//               final realIndex = index % eventList.length;
//               final event = eventList[realIndex];
//               return HomeBanner(event: event);
//             },
//           ),
//           Positioned(
//             bottom: 16,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(eventList.length, (index) {
//                 final isActive = index == _currentIndex;
//                 return AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   margin: const EdgeInsets.symmetric(horizontal: 4),
//                   width: isActive ? 10 : 6,
//                   height: 6,
//                   decoration: BoxDecoration(
//                     color: isActive ? Colors.white : Colors.white38,
//                     shape: BoxShape.circle,
//                   ),
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
