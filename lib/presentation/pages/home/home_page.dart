import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "가장 인기있는",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    child: Image.network(
                      "http://picsum.photos/200/300",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "현재 상영중",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 180,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(width: 8);
                    },
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          "http://picsum.photos/200/300",
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "인기순",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 180,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(width: 8);
                    },
                    itemBuilder: (context, index) {
                      final size = measureTextSize(
                        "${index + 1}",
                        style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                      return Container(
                        width: 120 + size.width / 2,
                        child: Stack(
                          children: [
                            Positioned(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    "http://picsum.photos/200/300",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Text(
                                "${index + 1}",
                                style: TextStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "평점 높은순",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 180,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(width: 8);
                    },
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          "http://picsum.photos/200/300",
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "개봉예정",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 180,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(width: 8);
                    },
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          "http://picsum.photos/200/300",
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Size measureTextSize(
  String text, {
  required TextStyle style,
  TextDirection textDirection = TextDirection.ltr,
  double maxWidth = double.infinity, // 줄바꿈 고려하려면 화면폭 등으로 지정
  int? maxLines, // 한 줄 고정이면 1
  String? ellipsis, // '…' 같이 쓰면 생략표시 고려
}) {
  final tp = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: textDirection,
    maxLines: maxLines,
    ellipsis: ellipsis,
  )..layout(minWidth: 0, maxWidth: maxWidth);

  return tp.size; // width/height 둘 다 포함
}
