import 'package:bwys/screens/home/repository/repository.dart';
import 'package:bwys/shared/bloc/product/product_bloc.dart';
import 'package:bwys/shared/models/product_model.dart';
import 'package:bwys/utils/ui/ui_utils.dart';
import 'package:bwys/widget/widget.dart';
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

  void _homeBlocListener(BuildContext context, ProductState homeState) {}

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: _homeBlocListener,
      child: BlocBuilder<ProductBloc, ProductState>(
        buildWhen: (previous, current) => current is! AddProductMessage,
        builder: (context, state) {
          if (state is HomeDataLoadedState && state.restAPIError != null) {
            return AppShowError(error: state.restAPIError);
          } else if (state is HomeDataLoadedState &&
              state.restAPIError == null) {
            productList = state.products;

            return RefreshIndicator(
              child: _showProductList(context, state),
              onRefresh: () {
                return Future.delayed(
                  Duration(seconds: 1),
                  () {
                    setState(() {
                      page = (page + 1) % (productList?.length as int);
                    });
                  },
                );
              },
            );
          }
          return Center(child: AppCircularProgressLoader());
        },
      ),
    );
  }

  Widget _showProductList(BuildContext context, HomeDataLoadedState state) {
    return ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        itemCount: productList?[page].length ?? 0,
        itemBuilder: (BuildContext context, int index) {
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
                        image: NetworkImage(
                            "https://media.istockphoto.com/photos/positivity-puts-you-in-a-position-of-power-picture-id1299077582?b=1&k=20&m=1299077582&s=170667a&w=0&h=Esjqlg_WCWmTc83Dv6PLhwPFwYN9uXoclBn0cUhtS5I="),
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
                        Row(
                          children: [
                            Text(
                              "Name : ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(productList?[page][index]
                                    .productName
                                    .toString() ??
                                ""),
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
                            Text(productList?[page][index]
                                    .productDescription
                                    .toString() ??
                                ""),
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
                            Text(productList?[page][index]
                                    .productPrice
                                    .toString() ??
                                ""),
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
        });
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
