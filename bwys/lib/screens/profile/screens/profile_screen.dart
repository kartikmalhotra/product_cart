import 'package:bwys/config/application.dart';
import 'package:bwys/config/screen_config.dart';
import 'package:bwys/utils/ui/ui_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _showUserDescription(),
          _showUserPost(),
        ],
      ),
    );
  }

  Widget _showScreenAppBar() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            padding: EdgeInsets.all(4.0),
            alignment: Alignment.centerLeft,
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
          ),
          AppText(
            "${AppUser.email}",
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {},
            padding: EdgeInsets.all(4.0),
            alignment: Alignment.centerRight,
            icon: Icon(
              Icons.person_add,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _showUserDescription() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: AppText("${AppUser.userName}",
                style: Theme.of(context).textTheme.headline6),
          ),
          Divider(color: Colors.black, thickness: 0.3),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _showNumberText("2", "posts"),
                _showNumberText("5 M", "followers"),
                _showNumberText("5 K", "following"),
              ],
            ),
          ),
          Divider(color: Colors.black, thickness: 0.3),
        ],
      ),
    );
  }

  Widget _showNumberText(String number, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "$number",
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        AppSizedBoxSpacing(heightSpacing: AppSpacing.xs),
        Text(
          "$text",
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _showUserPost() {
    return Column(
      children: [
        GridView.count(
          primary: false,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
          crossAxisCount: 2,
          children: <Widget>[
            Container(
              child: CachedNetworkImage(
                fit: BoxFit.fitWidth,
                imageUrl:
                    "https://images.unsplash.com/photo-1509631179647-0177331693ae?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80",
              ),
              color: Colors.black12,
            ),
            Container(
              child: CachedNetworkImage(
                fit: BoxFit.fitWidth,
                imageUrl:
                    "https://images.unsplash.com/photo-1487222477894-8943e31ef7b2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjB8fGZhc2hpb258ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
              ),
              color: Colors.black12,
            ),
          ],
        ),
      ],
    );
  }
}
