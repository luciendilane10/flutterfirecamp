abstract class Repository<T> {
  void add(T item);
  List<T> getAll();
  void update(T item);
  void delete(int id);
}