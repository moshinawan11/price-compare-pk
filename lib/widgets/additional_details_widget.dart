import 'package:flutter/material.dart';

class AdditionalDetailsWidget extends StatelessWidget {
  final List<Map<String, dynamic>>? additionalDetails;

  const AdditionalDetailsWidget({Key? key, this.additionalDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (additionalDetails == null || additionalDetails!.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Additional Details",
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color.fromARGB(255, 28, 55, 98),
            ),
            padding: EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: additionalDetails!
                  .map((detail) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail['title'] ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            detail['value'] ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ))
                  .toList(),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
