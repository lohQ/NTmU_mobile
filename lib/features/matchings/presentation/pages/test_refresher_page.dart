import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TestRefresherPage extends StatefulWidget {
  @override
  TestRefresherPageState createState() => TestRefresherPageState();
}

class TestRefresherPageState extends State<TestRefresherPage>{
  final mainController = RefreshController();
  final subController1 = RefreshController();
  final subController2 = RefreshController();
  final items1 = List.generate(10, (i)=>i);
  final items2 = List.generate(10, (i)=>i);

  void _onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState((){
      if(items1.length > 10){
        items1.removeRange(10, items1.length);
      }
      if(items2.length > 10){
        items2.removeRange(10, items2.length);
      }
    });
    mainController.refreshCompleted();
  }

  void _onLoading1() async {
    await Future.delayed(Duration(seconds: 1));
    setState((){
      items1.addAll(List.generate(3, (i)=>i));
    });
    subController1.loadComplete();
  }

  void _onLoading2() async {
    await Future.delayed(Duration(seconds: 1));
    setState((){
      items2.addAll(List.generate(3, (i)=>i));
    });
    subController2.loadComplete();
  }

  @override
  Widget build(BuildContext context){
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      header: MaterialClassicHeader(),
      controller: mainController,
      onRefresh: _onRefresh,
      child: ListView(
          children: <Widget>[
            Divider(height: 30,),
            Container(
              height: MediaQuery.of(context).size.height/4,
              child: 
                Row(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height/4,
                      width: MediaQuery.of(context).size.width/10,
                    ),
                    Expanded(
                      child: 
                      SmartRefresher(
                        controller: subController1,
                        enablePullDown: false,
                        enablePullUp: true,
                        footer: ClassicFooter(),
                        onLoading: _onLoading1,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: items1.length,
                          itemBuilder: (context, i)
                            => MyCard(i)
                          // Card(
                          //   child: Center(
                          //     child: Text(items1[i].toString())
                          //   )),
                        )
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/4,
                      width: MediaQuery.of(context).size.width/10,
                    ),
                  ],
                )
            ),
            Divider(height: 30,),
            Container(
              height: MediaQuery.of(context).size.height/4,
              child: 
                Row(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height/4,
                      width: MediaQuery.of(context).size.width/10,
                    ),
                    Expanded(
                      child:
                        SmartRefresher(
                          controller: subController2,
                          enablePullDown: false,
                          enablePullUp: true,
                          footer: ClassicFooter(),
                          onLoading: _onLoading2,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: items2.length,
                            itemBuilder: (context, i)
                            => MyCard(i+1)
                          )
                        ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/4,
                      width: MediaQuery.of(context).size.width/10,
                    ),
                  ],
                )
            ),
          ],
        )
    );
  }

}

const List<String> urls = [
  "https://i.pinimg.com/originals/f1/bf/d0/f1bfd0de20c80e7e675ab9a38b1f6ed9.jpg",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRGVwMFnVLfCeKGjvGKeYxrcRs5wXl6g7kF8TUAsvkw_dHTtPR5&usqp=CAU",
  "https://66.media.tumblr.com/24bdbb1bd5a26c40dc1c106f05ad0b85/tumblr_o561fp4gD01tin44bo1_1280.jpg",
];

class MyCard extends StatelessWidget {
  final int index;
  const MyCard(this.index);

  @override
  Widget build(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height/4,
      width: MediaQuery.of(context).size.width/4,
      child: Card(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height/5,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(urls[index%3]),
                  fit: BoxFit.fill
                )
              ),
            ),
            Text(index.toString()),
          ],
        )
      )
    );
  }
}
