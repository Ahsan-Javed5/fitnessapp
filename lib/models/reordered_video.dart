class ReorderedVideo {
  int? id;
  int? position;

  ReorderedVideo(this.id, this.position);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'position': position,
    };
  }
}
