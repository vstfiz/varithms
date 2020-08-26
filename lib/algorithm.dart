class Algorithms {
  int difficulty;
  String content;
  String name;
  String noOfLearners;
  String imageUrl;
  String category;
  int progress;

  Algorithms(this.difficulty, this.content, this.name, this.noOfLearners,
      this.imageUrl, this.category, this.progress);

  @override
  String toString() {
    return this.name + "\t\t" + this.category;
  }
}
