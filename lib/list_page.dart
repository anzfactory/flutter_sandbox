import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('バウンスエリア色変えたいんじゃ'), elevation: 0.0,),
      body: ChangeNotifierProvider(
        create: (context) => _OffsetChangeNotifier(0.0),
        child: _Page(),
      ),
    );
  }
}

class _Page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<_Page> {

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollControllerListener);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: <Widget>[
        _BounceArea(theme.primaryColor),
        _buildList()
      ],
    );
  }

  Widget _buildList() {
    
    return ListView.builder(
      controller: _controller, 
      physics: const AlwaysScrollableScrollPhysics(), 
      itemBuilder: (context, index) {
        
        final theme = Theme.of(context);
        switch (index) {
          case 0:
            return Container(
              color: theme.primaryColor, 
              height: 150, 
              child: Center(
                child: Text(
                  'ヘッダ', 
                  style: theme.textTheme.subhead.copyWith(color: Colors.white),
                )
              ),
            );
          case 1:
            return _buildItem('iOSで引っ張ったときに、ヘッダ部分との間に白色が見えるのが嫌なのじゃ');
          case 2:
            return _buildItem('かといって、フッターとか下の方は変えたくない。そのままで良いんじゃ');
          case 3:
            return _buildItem('なので、ListViewをContainerに入れちゃうやつはだめなのじゃ');
          case 8:
            return null;
          default:
            return _buildItem('Row: $index');
        }
      }
    );
  }

  Widget _buildItem(String text) => ListTile(title: Text(text)); 

  void _scrollControllerListener() {
    Provider.of<_OffsetChangeNotifier>(context, listen: false).setOffset(_controller.offset);
  }
}

class _BounceArea extends StatelessWidget {

  final Color _backgroundColor;

  _BounceArea(this._backgroundColor);

  @override
  Widget build(BuildContext context) {
    final offsetNotifier = Provider.of<_OffsetChangeNotifier>(context);
    return Container(
      color: _backgroundColor, 
      height: -offsetNotifier.value > 0 ? -offsetNotifier.value + 10 : 0  // ぴったりだと少し隙間が見えるので足してる
    );
  }
}

class _OffsetChangeNotifier extends ChangeNotifier {

  double _value;

  get value => _value;

  _OffsetChangeNotifier(this._value);

  void setOffset(double offset) {
    
    if (offset > 0 && _value == 0.0) {
      return;
    } else if (0 > offset) {
      _value = offset;
    } else {
      _value = 0.0;
    }
    notifyListeners();
  }
}