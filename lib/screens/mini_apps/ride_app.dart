import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/mini_app_scaffold.dart';

class RideApp extends StatefulWidget {
  const RideApp({super.key});

  @override
  State<RideApp> createState() => _RideAppState();
}

class _RideAppState extends State<RideApp> {
  String? _selectedDestination;
  bool _isBooking = false;
  bool _driverFound = false;

  final List<String> _locations = [
    "F-10 Markaz, Islamabad",
    "Blue Area, Jinnah Avenue",
    "The Centaurus Mall",
    "F-7 Markaz (Jinnah Super)",
    "I-8 Markaz",
    "G-11 Markaz"
  ];

  @override
  Widget build(BuildContext context) {
    return MiniAppScaffold(
      title: "Voish Ride",
      body: Stack(
        children: [
          // Mock Map Background
          Container(
            color: Colors.grey[900],
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 100, color: Colors.white10),
                  Text("Map of Islamabad (Mock)",
                      style: TextStyle(color: Colors.white24)),
                ],
              ),
            ),
          ),

          // Booking UI
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 20)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!_driverFound) ...[
                    const Text("Where to?",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    // Destination Dropdown
                    DropdownButtonFormField<String>(
                      dropdownColor: AppTheme.surfaceDark,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppTheme.backgroundBlack,
                        prefixIcon: const Icon(Icons.search,
                            color: AppTheme.primaryRed),
                        hintText: "Enter destination",
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none),
                      ),
                      style: const TextStyle(color: Colors.white),
                      items: _locations
                          .map((loc) =>
                              DropdownMenuItem(value: loc, child: Text(loc)))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedDestination = val;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    if (_selectedDestination != null) ...[
                      _buildRideOption(
                          "Voish Mini", "Suzuki Alto", "Rs. 350", "3 min"),
                      _buildRideOption(
                          "Voish Go", "Toyota Corolla", "Rs. 500", "5 min"),
                      _buildRideOption(
                          "Voish Bike", "Honda 125", "Rs. 150", "2 min"),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isBooking = true;
                            });
                            Future.delayed(const Duration(seconds: 3), () {
                              setState(() {
                                _isBooking = false;
                                _driverFound = true;
                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryRed,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: _isBooking
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text("Confirm Ride",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ] else ...[
                    // Driver Found UI
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey,
                          child:
                              Icon(Icons.person, size: 30, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Ahmed Khan",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            Text("Toyota Corolla • LE-123",
                                style: TextStyle(color: Colors.grey)),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 16),
                                Text(" 4.9",
                                    style: TextStyle(color: Colors.white)),
                              ],
                            )
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            const Text("5 min",
                                style: TextStyle(
                                    color: AppTheme.primaryRed,
                                    fontWeight: FontWeight.bold)),
                            IconButton(
                                onPressed: () =>
                                    setState(() => _driverFound = false),
                                icon: const Icon(Icons.close,
                                    color: Colors.grey)),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionIcon(Icons.call, "Call"),
                        _buildActionIcon(Icons.message, "Chat"),
                        _buildActionIcon(Icons.share, "Share"),
                      ],
                    )
                  ]
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRideOption(String name, String car, String price, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(name.contains("Bike") ? Icons.two_wheeler : Icons.local_taxi,
              color: Colors.white),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Text(car,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Text(time,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
            backgroundColor: Colors.white10,
            radius: 24,
            child: Icon(icon, color: Colors.white)),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
