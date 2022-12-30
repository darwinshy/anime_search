import 'package:serverpod/server.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class RootEndpoint extends Endpoint {
  Future<List<Map<String, String?>>> search(Session session,
      {required String keyword}) async {
    final String searchQuery = keyword.replaceAll(' ', '+');

    final Uri url = Uri.parse('https://9anime.vc/search?keyword=$searchQuery');
    final http.Response response = await http.get(url);

    dom.Document html = dom.Document.html(response.body);

    final topsTitle = html
        .querySelectorAll('.film_list-wrap .film-name > a')
        .map((e) => e.innerHtml)
        .toList();

    final topsImage =
        html.querySelectorAll('.film_list-wrap .film-poster-img').map((e) {
      session.log(e.attributes.toString());
      return e.attributes['data-src'];
    }).toList();

    final tops = topsTitle
        .asMap()
        .map((index, value) => MapEntry(index, {
              'title': value,
              'image': topsImage[index],
            }))
        .values
        .toList();

    return tops;
  }

  Future<List<Map<String, String?>>> topViewed(Session session,
      {String? name}) async {
    final Uri url = Uri.parse('https://9anime.vc/home');
    final http.Response response = await http.get(url);

    dom.Document html = dom.Document.html(response.body);

    final topsTitle = html
        .querySelectorAll('#top-viewed-day .film-name > a')
        .map((e) => e.innerHtml)
        .toList();

    final topsImage =
        html.querySelectorAll('#top-viewed-day .film-poster-img').map((e) {
      session.log(e.attributes.toString());
      return e.attributes['data-src'];
    }).toList();

    final tops = topsTitle
        .asMap()
        .map((index, value) => MapEntry(index, {
              'title': value,
              'image': topsImage[index],
            }))
        .values
        .toList();

    return tops;
  }
}
