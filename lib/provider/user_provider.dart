import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task/model/users.dart';

final usersProviderLoaderProvider = StateProvider((ref) => true);

final usersProviderApiService = StateNotifierProvider.autoDispose((ref) {
  return UsersApiService(ref.read, ref.watch);
});

class UsersApiService extends StateNotifier<List<Users>> {
  final Reader read;
  final watch;

  UsersApiService(this.read, this.watch, [Users? state]) : super([]) {
    getUsers();
  }

  getUsers() async {
    Response res;
    var dio = Dio();
    res = await dio.get(
      Uri.encodeFull("https://jsonplaceholder.typicode.com/users"),
      options: Options(
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (res.statusCode != 200) {
      throw Exception('Couldn\'t load users');
    }

    var users = (res.data as List).map((x) => Users.fromJson(x)).toList();

    state = users;
    read(usersProviderLoaderProvider).state = false;
  }
}
