import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Image.network(
                  "https://picsum.photos/200/300",
                  fit: BoxFit.fitWidth,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "영화 제목",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "개봉 날짜",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      "간단 설명",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "러닝타임",
                      style: TextStyle(color: Colors.white),
                    ),
                    Divider(
                      height: 20,
                      thickness: 2,
                      color: Colors.grey[800],
                    ),
                    Container(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        separatorBuilder: (context, index) => SizedBox(width: 4),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            height: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey[500]!), borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              "태그:애니메이션",
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(
                      height: 20,
                      thickness: 2,
                      color: Colors.grey[800],
                    ),
                    Text(
                      "영화 줄거리 내용",
                      style: TextStyle(color: Colors.white),
                    ),
                    Divider(
                      height: 20,
                      thickness: 2,
                      color: Colors.grey[800],
                    ),
                    Text(
                      "흥행정보",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 70,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        separatorBuilder: (context, index) => SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[600]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "0.000",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "평점",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        separatorBuilder: (context, index) => SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          return Image.network(
                            "https://picsum.photos/300/200",
                            fit: BoxFit.fitHeight,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
