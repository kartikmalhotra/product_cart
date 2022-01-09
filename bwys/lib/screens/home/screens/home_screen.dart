import 'package:bwys/config/application.dart';
import 'package:bwys/screens/home/repository/repository.dart';
import 'package:bwys/shared/bloc/product/product_bloc.dart';
import 'package:bwys/shared/models/product_model.dart';
import 'package:bwys/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisplayHomeScreen extends StatelessWidget {
  const DisplayHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductBloc>(
      create: (BuildContext context) =>
          ProductBloc(productRepository: ProductRepositoryImpl())
            ..add(GetHomeScreenData()),
      child: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isShowPlaying = false;
  ScrollController _scrollController = ScrollController();
  late List<List<Product>>? productList;
  late int page;

  @override
  void initState() {
    page = 0;
    _scrollController.addListener(() => showMoreData());

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final Stream<QuerySnapshot> _usersStream = Application
      .firebaseService!.firestoreInstance!
      .collection('proiduct_data')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: AppCircularProgressLoader());
        }

        List<Product> _list = [];
        snapshot.data!.docs.forEach((element) {
          Map<String, dynamic> data = element.data()! as Map<String, dynamic>;
          _list.add(Product.fromJson(data));
        });
        divideProductListInPages(_list);

        return RefreshIndicator(
          onRefresh: () {
            return Future.delayed(Duration(seconds: 1), () {
              setState(() => page = (page + 1) % (productList?.length as int));
            });
          },
          child: ListView.builder(
            itemCount: productList?[page].length ?? 0,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return _showProductList(context, productList![page][index]);
            },
          ),
        );
      },
    );
  }

  Widget _showProductList(BuildContext context, Product product) {
    return Container(
      height: 200,
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: NetworkImage("${product.imageURl}"),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      Text(
                        "Name : ",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(product.productName?.toString() ?? ""),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Wrap(
                    children: [
                      Text(
                        "Description : ",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(product.productDescription?.toString() ?? ""),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Wrap(
                    children: [
                      Text(
                        "Price : ",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(product.productPrice?.toString() ?? ""),
                    ],
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void divideProductListInPages(List<Product> list) {
    productList = [];
    for (int i = 0; i < list.length; i += 10) {
      productList!
          .add(list.sublist(i, i + 10 > list.length ? list.length : i + 10));
    }
  }

  void showMoreData() {
    if ((_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent)) {
      setState(() {
        page = (page + 1) % (productList?.length as int);
      });
    }
  }
}
