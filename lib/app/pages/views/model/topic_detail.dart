class TopicDetail {
  final int id;
  final String title;
  final String desc;
  final int contentCount;
  final int participantCount;
  final int views;

  TopicDetail({
    this.id = 0,
    this.title = '',
    this.desc = '',
    this.contentCount = 0,
    this.participantCount = 0,
    this.views = 0,
  });

  factory TopicDetail.fromJson(Map<String, dynamic> json) {
    return TopicDetail(
      id: json['id'] as int,
      title: json['title'] as String,
      desc: json['desc'] as String,
      contentCount: json['content_count'] as int,
      participantCount: json['participant_count'] as int,
      views: json['views'] as int,
    );
  }
}
