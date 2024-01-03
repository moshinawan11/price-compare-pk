import 'package:flutter/material.dart';

class SpecificationsWidget extends StatelessWidget {
  final Map<String, Map<String, dynamic>>? specifications;

  const SpecificationsWidget({Key? key, this.specifications}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (specifications == null || specifications!.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Specifications",
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
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: specifications!.length,
              itemBuilder: (context, index) {
                String key = specifications!.keys.elementAt(index);
                Map<String, dynamic> values = specifications![key]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      key,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: values.entries.map((entry) {
                        String innerKey = entry.key;
                        String value = entry.value;
                        return Row(
                          children: [
                            Text(
                              innerKey,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Spacer(),
                            Text(
                              value,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
