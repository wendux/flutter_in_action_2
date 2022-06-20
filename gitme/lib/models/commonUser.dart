import 'package:json_annotation/json_annotation.dart';

part 'commonUser.g.dart';

@JsonSerializable()
class CommonUser {
  CommonUser();

  late String login;
  late num id;
  late String node_id;
  late String avatar_url;
  late String gravatar_id;
  late String url;
  late String html_url;
  late String followers_url;
  late String following_url;
  late String gists_url;
  late String starred_url;
  late String subscriptions_url;
  late String organizations_url;
  late String repos_url;
  late String events_url;
  late String received_events_url;
  late String type;
  late bool site_admin;
  
  factory CommonUser.fromJson(Map<String,dynamic> json) => _$CommonUserFromJson(json);
  Map<String, dynamic> toJson() => _$CommonUserToJson(this);
}
