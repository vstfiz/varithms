class Algorithms {
  int difficulty;
  String content;
  String name;
  String imageUrl;
  String category;
  int progress;
  String implInJava;
  String implInPython;

  Algorithms(this.difficulty, this.content, this.name, this.imageUrl,
      this.category, this.progress, this.implInJava, this.implInPython);

  @override
  String toString() {
    return this.name + "\t\t" + this.category;
  }
}
