import "package:flutter/material.dart";

class ProductHighlights extends StatelessWidget {
  final List<String>? details;
  const ProductHighlights(this.details);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Product Highlights",
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
