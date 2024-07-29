import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomCard extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final String units;
  final Color color;

  const CustomCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.units,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1.0,
        ),
        // boxShadow: const [
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 4.0,
        //     spreadRadius: 0.5,
        //     offset: Offset(2, 2),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              SvgPicture.asset(icon, width: 28.0, height: 28.0),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Baseline(
                baseline: 40.0,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // const SizedBox(width: 4.0),
              Baseline(
                baseline: 40.0,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  units,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text('data', style: TextStyle(color: Colors.black54, fontSize: 14)),
        ],
      ),
    );
  }
}
