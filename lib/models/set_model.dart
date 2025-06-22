
class SetInfo
{
    final int id;
    final double duration;
    final String exercise;
    final double mBreathRate;
    final double mHeartRate;
    final int reps;
    final double weight;

    SetInfo({ 
      required this.id,
      required this.duration,
      required this.exercise,
      required this.mBreathRate,
      required this.mHeartRate,
      required this.reps,
      required this.weight,
    });
    
    factory SetInfo.fromJson(Map<String, dynamic> json)
    {
        return SetInfo(
            id: json['id'],
            duration: json['duration'],
            exercise : json['exercise_desc'],
            mBreathRate : json['mean_breath_rate'],
            mHeartRate : json['mean_heart_rate'],
            reps : json['reps'],
            weight : json['weight'],
        );
    }
}