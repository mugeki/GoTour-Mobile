import 'package:flutter/material.dart';
import 'package:gotour_mobile/screens/addPlace_form.dart';

class MyPlaces extends StatefulWidget {
  const MyPlaces({Key? key}) : super(key: key);

  @override
  State<MyPlaces> createState() => _MyPlacesState();
}

class _MyPlacesState extends State<MyPlaces> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My Places",
                    style: TextStyle(color: Color(0xff499E8F), fontSize: 18),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddPlaceForm()),
                        );
                      },
                      icon: const Icon(
                        Icons.add_box_outlined,
                        color: Color(0xff499E8F),
                      ))
                ],
              ),
            ),
            // ignore: avoid_unnecessary_containers
            Container(
              // margin: const EdgeInsets.only(top: 15),
              child: Stack(
                children: [
                  SizedBox(
                      child: Column(
                    children: [
                      Container(
                        height: 200,
                        width: 300,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/logo.png'),
                              fit: BoxFit.fill,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Center(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                                height: 70,
                                width: double.infinity,
                                child: DecoratedBox(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("Tangkuban Perahu"),
                                          const Text("Bandung, West Java"),
                                          Row(
                                            children: const [
                                              Icon(
                                                Icons.star,
                                                color: Colors.yellow,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Colors.yellow,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Colors.yellow,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Colors.yellow,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Colors.yellow,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text("(120)"),
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.add,
                                              size: 10,
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.settings,
                                                size: 10,
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
