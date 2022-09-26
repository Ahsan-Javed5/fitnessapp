class ReorderedGroup {
  int? id;
  int? position;

  ReorderedGroup(this.id, this.position);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'position': position,
    };
  }
}
