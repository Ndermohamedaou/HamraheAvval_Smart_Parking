class Filter {
  int filterIndex = 1;

  int get10Filter({int getLenLs}) =>
      filterIndex = getLenLs >= 10 ? 10 : getLenLs;
}

Filter filtered = Filter();
