
class Exercise
{
    final String description; 
    final String name;
    final int id;

    Exercise({required this.description, required this.name, required this.id});
    
    factory Exercise.fromJson(Map<String, dynamic> json)
    {
        return Exercise(
            description: json['description'],
            name: json['name'],
            id: json['id']
        );
    }
}