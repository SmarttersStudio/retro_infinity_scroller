import 'package:flutter/material.dart';
import 'package:retroinfinityscroll_example/pages/infinity_scroll_with_android_refresh_page.dart';
import 'package:retroinfinityscroll_example/pages/load_more_retro_infinity_scroll_page.dart';
import 'package:retroinfinityscroll_example/pages/simple_retro_infinity_scroll_page.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ChooseOptionsPage(),
        appBar: AppBar(title: Text("Choose to view the implementation")),
      )));
}

class ChooseOptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RaisedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => SimpleRetroInfinityPage())),
              child:
                  Text('Simple Implementation (Without Refresh and loadmore)'),
            ),
            RaisedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => LoadMoreInfinityScrollPage())),
              child: Text('With Loadmore Implementation only'),
            ),
            RaisedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) =>
                          InfinityScrollWithAndroidRefreshPage())),
              child: Text('With Android Refresh and LoadMore Implementation'),
            ),
          ],
        ),
      ),
    );
  }
}
