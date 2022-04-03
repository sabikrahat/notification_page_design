import 'package:flutter/material.dart';
import 'package:notification_page_design/notification_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => NotificationPd()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NotificationPage(),
    );
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _pd = Provider.of<NotificationPd>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: Stack(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: 15,
            itemBuilder: (context, index) {
              return GestureDetector(
                onLongPress: () {
                  _pd.isSelecting = true;
                  _pd.notificationIds.add(index);
                  _pd.reload();
                },
                onTap: () {
                  if (_pd.isSelecting) {
                    if (_pd.notificationIds.contains(index)) {
                      _pd.notificationIds.remove(index);
                    } else {
                      _pd.notificationIds.add(index);
                    }
                    _pd.reload();
                  } else {
                    // Do something to view the post
                  }
                },
                child: Card(
                  color: _pd.notificationIds.contains(index)
                      ? Colors.grey[300]
                      : Colors.white,
                  elevation: 3.0,
                  child: Dismissible(
                    key: ObjectKey('Key_$index'),
                    background: Container(
                      color: Colors.red,
                      child: const ListTile(
                        leading: Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),
                        trailing: Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    onDismissed: (DismissDirection direction) {
                      //delete the notification
                      debugPrint('delete the notification');
                    },
                    child: ListTile(
                      title: Text('Title ${index + 1}'),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description ${index + 1}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'DateTime: ${DateTime.now()} ${index + 1}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12.5),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: _pd.notificationRead[index]
                            ? const Icon(
                                Icons.visibility,
                                color: Colors.grey,
                              )
                            : const Icon(
                                Icons.visibility_off,
                                color: Colors.black,
                              ),
                        onPressed: () {
                          _pd.notificationRead[index] =
                              !_pd.notificationRead[index];
                          _pd.reload();
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          if (_pd.isSelecting)
            Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                color: Colors.blue[50],
                elevation: 5.0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        _pd.isSelecting = false;
                        _pd.notificationIds.clear();
                        _pd.reload();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          SizedBox(height: 3),
                          Icon(
                            Icons.close,
                            size: 22.0,
                          ),
                          Text(
                            'Cancel',
                            style: TextStyle(fontSize: 12.5),
                          ),
                          SizedBox(height: 3),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _pd.isSelecting = false;
                        for (var element in _pd.notificationIds) {
                          _pd.notificationRead[element] = true;
                        }
                        _pd.notificationIds.clear();
                        _pd.reload();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          SizedBox(height: 3),
                          Icon(
                            Icons.visibility,
                            size: 22.0,
                          ),
                          Text(
                            'Mark as read',
                            style: TextStyle(fontSize: 12.5),
                          ),
                          SizedBox(height: 3),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
