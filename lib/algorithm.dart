class Algorithms {
  String difficulty;
  String content;
  String name;
  String noOfLearners;
  String imageUrl;
  String category;

  Algorithms(this.difficulty, this.content, this.name, this.noOfLearners,
      this.imageUrl, this.category);

  @override
  String toString() {
    return this.name + "\t\t" + this.category;
  }
}
