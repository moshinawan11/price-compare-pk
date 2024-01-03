// import "package:flutter/material.dart";

// class ProductDetails extends StatelessWidget {
//   final List<String>? details;
//   const ProductDetails(this.details);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       width: double.infinity,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Product Details",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 23,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15),
//               color: Color.fromARGB(255, 28, 55, 98),
//             ),
//             padding: EdgeInsets.all(22),
//             child: Text(
//               details,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 40,
//           ),
//         ],
//       ),
//     );
//   }
// }

import "package:flutter/material.dart";

class ProductDetails extends StatelessWidget {
  final List<String>? details;
  const ProductDetails(this.details);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Product Details",
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color.fromARGB(255, 28, 55, 98),
            ),
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: details != null
                ? Padding(
                    padding: EdgeInsets.only(bottom: 22),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: details!.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemBuilder: (context, index) => Text(
                        details![index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
